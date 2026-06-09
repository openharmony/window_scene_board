/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  PluginSlot,
  WindowEvent,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { HoverConstants } from '@ohos/commonconstants';
import MediaCardComponent from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/MediaCardComponent'
import { CommonData } from '@ohos/controlcentercommon/Index';
import StyleConfiguration, {
  ControlCenterMediaCardLayoutStyle
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import { ControlCenterData, ToggleData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { QuickToggleController } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import lazy { PluginCardComponent } from '@ohos/plugincardcomponent/src/main/ets/default/pages/PluginCardComponent';
import {
  ColorModeViewData,
  ColorModeViewModel
} from '@ohos/systemuicommon/Index';
import { CommonConstants } from '@ohos/launchercommon';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { PCToggleFactory } from './pcStyle/PCStyleFactory';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Ctrl.MediaCardLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SHADOW_OFFSET_Y: number = 4
const CONTROL_CENTER_LONG_BUTTON_LEFT_PADDING: number = 4
const HAD_CONTROL_CENTER_LONG_BUTTON_LEFT_PADDING: number = 4.5
const GRID_GAP: number = 16;

@Component
export default struct ControlCenterMediaCardLayout {
  @State hasMediaCard: boolean = true;
  @StorageLink('QuickToggleData') toggleData: ToggleData = QuickToggleController.getInstance().getToggleData();
  @StorageLink('deviceNumber') deviceNum: number = 0;
  @State style: ControlCenterMediaCardLayoutStyle = StyleConfiguration.getControlCenterMediaCardLayoutStyle();
  @State cardWidth: number = StyleConfiguration.getControlCenterMediaCardLayoutStyle().cardWidth;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false;
  @StorageLink('DarkModeModel_DarkModeStatus') darkModeData: CommonData = new CommonData();
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @State mediaLandscape: boolean = false;
  @State currentPosY: number = 0;
  @State gridItemHeight: number = 0;
  @Prop listPosY: number = 0;
  @Link data: ControlCenterData;
  @State isShowMedia: boolean = true; // 是否显示播控卡片
  @State animateScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @State isShowTerminalButton: boolean = true;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private isHad: boolean = DeviceHelper.isHAD();

  aboutToAppear() {
    log.showInfo(`aboutToAppear listPosY: ${this.listPosY} toggleData: ${this.toggleData.toString()}`);
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
    this.eventMgr.offAll();
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.toggleData.topToggle, (slot: string, index?: number) => {
          GridItem() {
            ToggleComponent({
              toggleId: slot,
              templateType: ToggleTemplateType.TAGGED,
              toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
              toggleStyle: PCToggleFactory.getInstance().createTaggedStyle(),
              toggleScene: ToggleScene.PC
            })
          }
          .borderRadius(16)
          .geometryTransition(slot)
          .height($r('app.float.Control_center_long_button_height'))
        }, (componentName: string) => componentName)

        if (this.isShowTerminalButton) {
          GridItem() {
            Stack() {
              PluginCardComponent({
                isBussinessStyle: true,
                vibrationEffectId: CommonConstants.VIBRATION_EFFECT_MEDIUM
              })
                .size({
                  width: $r('app.float.Control_center_long_button_width'),
                  height: $r('app.float.Control_center_long_button_height'),
                })
            }
          }
          .focusable(this.deviceNum === 0 ? false : true)
        }
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(GRID_GAP)
      .rowsGap(GRID_GAP)
      .clip(false)
      .height($r('app.float.control_center_top_toggle_height'))

      if (this.hasMediaCard) {
        Row() {
          MediaCardComponent({
            isLandscape: $isLandscape,
            mediaLandscape: $mediaLandscape,
            isBussinessStyle: true,
          })
            .size(
              {
                width: $r('app.float.Control_center_media_width'),
                height: $r('app.float.Control_center_media_height')
              }
            )
        }
        .backgroundColor(this.colorModeViewData.commonBgOffColor)
        .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
        .width($r('app.float.Control_center_media_width'))
        .height($r('app.float.Control_center_media_height'))
        .justifyContent(FlexAlign.Start)
        .borderRadius($r('app.float.Control_center_media_border_radius'))
        .clip(true)
        .margin({
          top: 16,
        })
        .shadow({
          radius: $r('app.float.Control_center_icon_shadow_radius'),
          color: $r('app.color.Control_center_icon_shadow_color'),
          offsetY: SHADOW_OFFSET_Y
        })
        .scale({ x: this.animateScale, y: this.animateScale })
        .onHover(this.onHoverChanged)
      }
    }
    .width('100%')
    .height($r('app.float.control_center_media_card_toggle_height'))
    .padding({
      left: $r('app.float.Control_center_padding'),
      right: $r('app.float.Control_center_padding')
    })

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
}

