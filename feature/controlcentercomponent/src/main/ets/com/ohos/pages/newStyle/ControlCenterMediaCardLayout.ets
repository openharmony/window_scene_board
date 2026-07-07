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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, EventManager, EvtBus, PluginSlot, WindowEvent, } from '@ohos/frameworkwrapper';
import { FASlotName, HoverConstants } from '@ohos/commonconstants';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import display from '@ohos.display';
import StyleConfiguration, {
  ControlCenterMediaCardLayoutStyle,
  ControlCenterLongButtonLayoutStyle,
  SingleExpandLongButtonStyle
} from '../../common/StyleConfiguration';
import MediaCardComponent from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/MediaCardComponent';
import lazy {
  ExpandMediaCardComponent
} from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/ExpandMediaCardComponent';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { curves } from '@kit.ArkUI';
import { BusinessError, osAccount } from '@kit.BasicServicesKit';
import {
  ToggleScene,
  ToggleTemplateType
} from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { QuickToggleController } from '../../controller/QuickToggleController';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { PhoneStyleFactory } from '../../phoneStyle/PhoneStyleFactory';
import { OutdoorConfig } from '@ohos/basicutils/src/main/ets/utils/OutdoorConfig';
import { DisplayUtils } from '@ohos/screenlockcommon';

const TAG = 'Ctrl.MediaCardLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const PRIVACY_SPACE: number = 1024;

@Component
export default struct ControlCenterMediaCardLayout {
  private style: ControlCenterMediaCardLayoutStyle = StyleConfiguration.getControlCenterMediaCardLayoutStyle();
  private longButtonStyle: ControlCenterLongButtonLayoutStyle | SingleExpandLongButtonStyle = StyleConfiguration.getControlCenterLongButtonLayoutStyle();
  private eventMgr: EventManager | undefined = undefined;
  @State isFoldDevice: boolean = false; // 是否为折叠屏
  @State hasMediaCard: boolean = true;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false;
  @State isShowMedia: boolean = true; // 是否显示播控卡片
  @State mediaLandscape: boolean = false;
  @State isLargeMediaCard: boolean = false;
  @State animateScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @State isShowTerminalButton: boolean = false;
  @State isInPrivacySpace: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('isSysColor') isSysColor: boolean = true;
  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @StorageLink('foldStatusForOuterScreen') foldStatus: number = AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @Prop isShowWifiCard: boolean = true;
  @StorageLink('isToggleLightEnabled') isToggleLightEnabled: boolean = true;
  @StorageLink('hasCall') hasCall: boolean = false;
  @State isMediaCardUnavailable: boolean = OutdoorConfig.getInstance().isInOutdoorMode();

  aboutToAppear() {
    log.info(TAG,`abouttoappear-foldStatus-${this.foldStatus}`)
    this.getIsFoldable();
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    try {
      accountManager.getForegroundOsAccountLocalId().then((localId: number) => {
        log.showInfo('getForegroundOsAccountLocalId');
        accountManager.queryOsAccountById(localId).then((accountInfo: osAccount.OsAccountInfo) => {
          this.isInPrivacySpace = (accountInfo.type === PRIVACY_SPACE);
          log.showInfo('isInPrivacySpace:  %{public}s', this.isInPrivacySpace);
        }).catch((err: BusinessError) => {
          log.showInfo('queryOsAccountById error');
        });
      }).catch((err: BusinessError) => {
        log.showInfo('getForegroundOsAccountLocalId error');
      });
    } catch (e) {
      log.showInfo('getForegroundOsAccountLocalId exception');
    }
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
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        this.animateScale = 0.94;
      });
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        this.animateScale = 1;
      });
    }
  }

  /**
   * 判断是否为折叠屏
   */
  getIsFoldable() {
    try {
      this.isFoldDevice = display.isFoldable();
    } catch (error) {
      this.isFoldDevice = false;
    }
  }

  getFoldStatus() {
    try {
      const foldStatus = display.getFoldStatus();
      return foldStatus == 2;
    } catch (error) {
      return false
    }
  }

  getGeometryKey(name: string) {
    return this.mediaLandscape !== this.isLandscape && !DeviceHelper.isPad() &&
      !(this.isFoldDevice && !this.getFoldStatus()) ? `${name}Hide` : name;
  }

  build() {
    if (this.isLargeMediaCard) {
      this.buildLargeMediaCard();
    } else {
      this.buildCommonMediaCard();
    }
  }

  @Builder
  buildCommonMediaCard() {
    Column() {
      Row({ space: this.longButtonStyle.space }) {
        if (this.hasMediaCard) {
          Stack() {
            if (this.controlCenterState !== ControlCenterState.MEDIA_CENTER) {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(this.colorModeViewData.getSolidColor(
                  this.colorModeViewData.commonBgOffColor, this.colorModeViewData.mainCardOption))
                .backgroundBrightnessInternal(this.colorModeViewData.getBrightnessOption(
                  this.colorModeViewData.mainCardOption))
                .borderRadius(this.style.newBorderRadius)
                .zIndex(0)
                .id(this.getGeometryKey(this.hasCall ? 'callPanelStart' : 'mediaPanelStart'))
                .geometryTransition(this.getGeometryKey(this.hasCall ? 'callPanel' : 'mediaPanel'),
                  { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
            }
            Column() {
              MediaCardComponent({ isLandscape: $isLandscape, mediaLandscape: $mediaLandscape })
            }
            .width('100%')
            .height('100%')
            .clip(false)
            .borderRadius(this.style.newBorderRadius)
            .zIndex(1)
            .pointLight({
              illuminated: this.isToggleLightEnabled ? IlluminatedType.BORDER_CONTENT : IlluminatedType.NONE,
            })
          }
          .size({ width: this.longButtonStyle.newCardWidth, height: this.style.newCardHeight }
          )
          .id('control_center_media_card')
          .visibility(this.isShowMedia ? Visibility.Visible : Visibility.Hidden)
          .onHover(this.onHoverChanged)
          .scale({ x: this.animateScale, y: this.animateScale })
          .onTouch((event: TouchEvent) => {
            this.buttonClickEffect(event);
          })
          .opacity(this.isMediaCardUnavailable ? 0.6 : 1)
          .enabled(!this.isMediaCardUnavailable)
        }

        // if (this.isShowWifiCard && (this.foldStatus !== DeviceState.FOLDED_STATE)) {
        if (this.isShowWifiCard && (DisplayUtils.getFoldStatus() === 0 || 1)) {
          Grid() {
            this.loadLongButtonLayout(FASlotName.WIFI_UI_EXTENSION)
            this.loadLongButtonLayout(FASlotName.BLUETOOTH_UI_EXTENSION)
          }
          .width(this.longButtonStyle.newCardWidth)
          .rowsGap(this.style.space)
          .clip(false)
        }
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.singleCardWidth)
      .height($r('app.float.Control_center_mediaAndWifiBlue_height'))
      .clip(false)
    }
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        delay: 20,
        duration: 200
      }),
      TransitionEffect.OPACITY.animation({
        duration: 10
      }),
    ))
  }

  @Builder
  buildLargeMediaCard() {
    Column() {
      ExpandMediaCardComponent();
    }
    .height('100%')
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        delay: 20,
        duration: 200
      }),
      TransitionEffect.OPACITY.animation({
        duration: 10
      }),
    ))
  }

  @Builder
  loadLongButtonLayout(slot: string) {
    GridItem() {
      if (this.controlCenterState !== ControlCenterState.SUB_PANEL ||
        sToggleSubWindowController.getCurrentSubPanelSlot() !== slot) {
        ToggleComponent({
          toggleId: slot,
          templateType: ToggleTemplateType.TAGGED,
          toggleStyle: PhoneStyleFactory.getInstance().createTaggedStyle(),
          toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
          toggleScene: ToggleScene.PHONE
        })
          .borderRadius($r('app.float.Control_center_long_button_radius'))
          .id('transition_topToggle' + slot)
          .geometryTransition(slot + CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.showMediaAboveCardToggles)
      }
    }
    .borderRadius($r('app.float.Control_center_long_button_radius'))
    .width(this.longButtonStyle.newCardWidth)
    .height($r('app.float.Control_center_long_button_height'))
  }
}

