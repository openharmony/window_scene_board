/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus, WindowEvent, PluginSlot } from '@ohos/frameworkwrapper';
import { FASlotName, HoverConstants } from '@ohos/commonconstants';
import { curves } from '@kit.ArkUI';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import StyleConfiguration, { SingleFoldLongButtonStyle } from '../../common/StyleConfiguration';
import MediaCardComponent from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/MediaCardComponent';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { QuickToggleController } from '../../controller/QuickToggleController';
import { SingleFoldFactory } from '../../SingleFoldStyle/SingleFoldStyleFactory';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Ctrl.SingleFoldMediaCardLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct SingleFoldControlCenterMediaCardLayout {
  private style: SingleFoldLongButtonStyle =
    StyleConfiguration.getSingleFoldLongButtonStyle();
  private eventMgr: EventManager | undefined = undefined;
  @State hasMediaCard: boolean = true;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @State isShowMedia: boolean = true; // 是否显示播控卡片
  @State mediaLandscape: boolean = false;
  @State animateScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @ObjectLink animationData: ControlCenterAnimationData;
  @State isShowTerminalButton: boolean = false;
  @State isInPrivacySpace: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('isSysColor') isSysColor: boolean = true;
  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @Prop isShowWifiCard: boolean = true;
  @StorageLink('foldStatusForOuterScreen') foldStatus: number = AppStorage.get<number>('foldStatusForOuterScreen') as number;

  aboutToAppear() {
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
  }

  /**
   * 图标hover效果
   *
   * @param event 悬浮事件
   */
  onHoverChanged = (isHover?: boolean) => {
    if (isHover === undefined) {
      return;
    }
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.animateScale = isHover ? HoverConstants.HOVER_MEDIA_CARD_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
    });
  }

  private buttonClickEffect(event: TouchEvent) {
    if (event.type === TouchType.Down) {
      animateTo({
        curve: curves.springMotion(0.15, 0.94)
      }, () => {
        this.animateScale = 0.94;
      });
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      animateTo({
        curve: curves.springMotion(0.15, 0.94)
      }, () => {
        this.animateScale = 1;
      });
    }
  }

  build() {
    Column() {
      Row({ space: this.style.space }) {
        if (this.hasMediaCard) {
          Stack() {
            if (this.controlCenterState !== ControlCenterState.MEDIA_CENTER) {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(this.colorModeViewData.commonBgOffColor)
                .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
                .borderRadius($r('app.float.Control_center_meidaCard_radius'))
                .zIndex(0)
                .id(`smallScreenDeviceListBgStart`)
                .geometryTransition('smallScreenDeviceListBg')
            }
            if (this.foldStatus === DeviceState.FOLDED_STATE) {
              Stack() {
                Flex()
                  .width('100%').height('100%')
                  .id('LocalDeviceStart').geometryTransition('LocalDevice', {follow: true})
                MediaCardComponent({ isLandscape: $isLandscape, mediaLandscape: $mediaLandscape })
              }
              .width('100%')
              .height('100%')
              .clip(false)
              .borderRadius($r('app.float.Control_center_meidaCard_radius'))
              .zIndex(1)
              .pointLight({
                illuminated: 3,
              })
            }
          }
          .size({ width: 132, height: 132 }
          )
          .id('control_center_media_card')
          .visibility(this.isShowMedia ? Visibility.Visible : Visibility.Hidden)
          .onHover(this.onHoverChanged)
          .scale({ x: this.animateScale, y: this.animateScale })
          .onTouch((event: TouchEvent) => {
            this.buttonClickEffect(event);
          })
        }

        if (this.isShowWifiCard && this.foldStatus === DeviceState.FOLDED_STATE) {
          Grid() {
            this.loadLongButtonLayout(FASlotName.WIFI_UI_EXTENSION)
            this.loadLongButtonLayout(FASlotName.BLUETOOTH_UI_EXTENSION)
          }
          .width(this.style.newCardWidth)
          .rowsGap(this.style.space)
          .clip(false)
        }
      }
      .width(this.style.singleCardWidth)
      .height($r('app.float.Single_fold_control_center_mediaAndWifiBlue_height'))
      .clip(false)
    }
    .opacity(this.animationData.opacity)
    .scale({
      x: this.animationData.scale,
      y: this.animationData.scale
    })
    .translate({ y: this.animationData.itemTranslate + Math.max(this.animationData.translate, 0) })
  }

  @Builder
  loadLongButtonLayout(slot: string) {
    GridItem() {
      if (this.controlCenterState !== ControlCenterState.SUB_PANEL ||
        sToggleSubWindowController.getCurrentSubPanelSlot() !== slot) {
        ToggleComponent({
          toggleId: slot,
          toggleStyle: SingleFoldFactory.getInstance().createTaggedStyle(),
          toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
          templateType: ToggleTemplateType.TAGGED,
          toggleScene: ToggleScene.SINGLE_FOLD_OUTER_SCREEN
        })
          .borderRadius($r('app.float.Control_center_long_button_radius'))
          .id('transition_topToggle' + slot)
          .geometryTransition(slot + CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.showMediaAboveCardToggles)
      }
    }
    .borderRadius($r('app.float.Control_center_long_button_radius'))
    .width($r('app.float.Single_fold_control_center_long_button_width'))
    .height($r('app.float.Single_fold_control_center_long_button_height'))
  }
}

