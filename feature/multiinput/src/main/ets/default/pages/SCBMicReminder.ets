/**
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
import lazy { BaseViewController } from '@ohos/frameworkcommon';
import lazy {
  ViewType,
  viewMgrPolicy,
  DeviceHelper,
  GlobalContext,
  EventManager,
  EvtBus,
  ViewArea
} from '@ohos/frameworkwrapper';
import lazy { SCBFoldStatePropertyChangeEvent, SCBPropertyChangeReason,
  SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import Constants, { SCBFoldState } from '../common/constants/Constants';
import lazy { MultiInputViewModel } from '../common/viewmodel/MultiInputViewModel';
import { ConfigurationConstant } from '@kit.AbilityKit';

const TAG = 'SCBMicReminder';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export interface MicToastParam {
  textMargin: Resource;
  borderOrOutlineRadius: Resource;
  toastbackgroundColor: ResourceColor;
  borderOrOutlineWidth: Resource;
  shadowOption: ShadowOptions;
  blurStyle?: BlurStyle,
  backEffect?: BackgroundEffectOptions | undefined;
  backBrightnessInternal?: BrightnessOptions | undefined;
}

@Component
export struct SCBMicReminder {
  persistentId: number = 0;
  @Link screenProp: SCBScreenProperty;
  @State screenWidth: number = 0;
  @State screenHeight : number = 0;
  @State panelWidth: number = 0;
  @State panelHeight : number = 0;
  @State windowLeft: number = 0;
  @State windowTop: number = 0;
  @State languageJustify: boolean = false;
  @State foldedOrPortrait: boolean = false;
  @State viewController: BaseViewController = new BaseViewController(ViewType.MIC_REMINDER);
  @StorageLink('isMicMuteState') @Watch('updateMicMuteState') isMicMuteState: boolean | undefined = undefined;
  @StorageLink('systemLanguage') language: string = '';
  @State isDarkMode: boolean = false;
  private previousShowTimerHandle: number = 0;
  private mInterval: number = Constants.MIC_REMINDER_TIMEOUT_SHORT;
  private eventManager: EventManager = EvtBus.createEventManager();
  // 浅色模式提亮参数
  private backBrightnessLightParam: BrightnessOptions = {
    rate: 0.2873,
    lightUpDegree: 0.6793,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 2,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1.2, 1],
    fraction: 0,
  }
 
  // 深色模式提亮参数
  private backBrightnessDarkParam: BrightnessOptions = {
    rate: -0.2067,
    lightUpDegree: 0.14,
    cubicCoeff: -0.6667,
    quadCoeff: 1.3333,
    saturation: 1.4,
    posRGB: [0.3, 0.5, 0.8],
    negRGB: [0.3, 1, 1],
    fraction: 0,
  }

  autoDismissMicReminder() {
    log.showInfo('autoDismissMicReminder');
    this.clearWindowTimer();
    this.previousShowTimerHandle = setTimeout(() => {
      this.viewController.hide();
    }, this.mInterval);
  }

  private clearWindowTimer(): void {
    if (this.previousShowTimerHandle > 0) {
      clearTimeout(this.previousShowTimerHandle);
      this.previousShowTimerHandle = 0;
    }
  }

  private updateMicReminderRect(): void {
    this.getLanguage();
    this.panelWidth = Constants.MIC_REMINDER_WIDTH;
    this.panelHeight = Constants.MIC_REMINDER_HEIGHT;
    let dockHeight: number = px2vp(MultiInputViewModel.getInstance().dockHeight);
    this.windowLeft = (this.screenWidth - this.panelWidth) / Constants.DEFAULT_2;
    this.windowTop = this.screenHeight - (DeviceHelper.isPad() ? (Constants.MIC_REMINDER_BOTTOM_PADDING_PAD + this.panelHeight) :
      (this.panelHeight + Constants.MIC_REMINDER_BOTTOM_PADDING + dockHeight));
    log.showInfo(`screenWidth: ${this.screenWidth}, screenHeight: ${this.screenHeight}, dockHeight: ${dockHeight}`);
    let viewArea: ViewArea = {
      left: this.windowLeft,
      top: this.windowTop,
      width: this.panelWidth,
      height: this.panelHeight
    }

    this.viewController.updateArea(viewArea)
    this.viewController.updateRect(viewArea)
  }

  private updateMicMuteState(): void {
    this.getLanguage();
    this.updateMicReminderRect();
    this.isMicMuteState = AppStorage.get<boolean>('isMicMuteState') as boolean;
    log.showInfo(`updateMicMuteState - MicMuteState: ${this.isMicMuteState}`);
    this.isDarkMode = GlobalContext.getContext().config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    this.viewController.show();
    this.autoDismissMicReminder();
  }

  private getLanguage(): void {
    this.languageJustify = this.language.slice(0, 2) === 'ug';
    log.showInfo(`language: ${this.language}, languageJustify: ${this.languageJustify}`);
  }

  screenPCPropertyChangeCallbacks = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.screenWidth = px2vp(screenProperty.width);
    this.screenHeight = px2vp(screenProperty.height);
    log.showInfo(`SCBPropertyChangeReason: ${reason}, isLandscape: ${DeviceHelper.isLandscape()}`);
    this.updateMicReminderRect();
  }

  onBigScreenStatusChange = async (bigScreenStateProperty: SCBFoldStatePropertyChangeEvent) => {
    log.showInfo(`onBigScreenStatusChange property, bSideHeight: ${bigScreenStateProperty.bSideHeight}, ` +
      `curState: ${bigScreenStateProperty.curState}, tarState: ${bigScreenStateProperty.tarState}`);
    // 键盘避让
    if (bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD) {
      this.screenHeight = px2vp(bigScreenStateProperty.bSideHeight);
      this.screenWidth = px2vp(bigScreenStateProperty.bSideWidth);
    } else {
      this.screenHeight = px2vp(this.screenProp.height);
      this.screenWidth = px2vp(this.screenProp.width);
    }
    this.updateMicReminderRect();
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear screen width: ${this.screenProp?.width}, screen height: ${this.screenProp?.height}`);
    viewMgrPolicy.registerViewController(ViewType.MIC_REMINDER, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.getLanguage();
    this.isDarkMode = GlobalContext.getContext().config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    this.screenWidth = px2vp(this.screenProp.width);
    this.screenHeight = px2vp(this.screenProp.height);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPCPropertyChangeCallbacks);
    this.eventManager.on(SCBFoldStatePropertyChangeEvent, this.onBigScreenStatusChange);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'aboutToDisappear');
    this.eventManager.offAll();
    this.clearWindowTimer();
    viewMgrPolicy.unregisterViewController(ViewType.MIC_REMINDER);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPCPropertyChangeCallbacks);
  }

  @Builder
  MicReminderBuilder(param: MicToastParam) {
    Row() {
      Row() {
        SymbolGlyph(this.isMicMuteState ? $r('sys.symbol.mic_slash_fill') :
        $r('sys.symbol.mic_fill'))
          .fontColor(this.isMicMuteState ? [$r('sys.color.ohos_id_color_warning')] :
            [$r('sys.color.icon_primary')])
          .draggable(false)
          .fontSize(20)
          .margin({
            left: this.languageJustify ? 0 : param.textMargin,
            right: this.languageJustify ? param.textMargin : 0,
          })
        Text(this.isMicMuteState ? $r('app.string.mic_reminder_mute') : $r('app.string.mic_reminder_unmute'))
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize('14vp')
          .fontColor($r('sys.color.font_primary'))
          .align(Alignment.Center)
          .alignSelf(ItemAlign.Center)
          .margin({
            left: $r('sys.float.padding_level4'),
            right: param.textMargin,
            bottom: $r('sys.float.padding_level4'),
            top: $r('sys.float.padding_level4')
          })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .border({
        radius: param.borderOrOutlineRadius,
        color: $r('app.color.mic_reminder_border_color'),
        width: param.borderOrOutlineWidth
      })
      .outline({
        radius: param.borderOrOutlineRadius,
        color: $r('app.color.mic_reminder_outline_color'),
        width: param.borderOrOutlineWidth
      })
      .shadow(param.shadowOption)
      .backgroundEffect(param.backEffect)
      .backgroundBlurStyle(param.blurStyle, { policy: BlurStyleActivePolicy.ALWAYS_ACTIVE })
      .backgroundColor(param.toastbackgroundColor)
      .backgroundBrightnessInternal(param.backBrightnessInternal)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .size({ width: '100%', height: '100%' })
  }

  build() {
    if (DeviceHelper.isPad() && this.viewController.isShowing()) {
      this.MicReminderBuilder({
        textMargin: $r('sys.float.padding_level6'),
        toastbackgroundColor: this.isDarkMode ? $r('app.color.pannel_background_dark_color') : $r('app.color.pannel_background_color'),
        borderOrOutlineRadius: $r('app.float.micreminder_border_radius_pad'),
        borderOrOutlineWidth: $r('app.float.micreminder_border_width_pad'),
        blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        shadowOption: {
          color: $r('sys.color.ohos_id_shadow_default_xs'),
          radius: $r('sys.float.ohos_id_shadow_default_md_shadow'),
          offsetX: $r('sys.float.ohos_id_shadow_default_md_offset_x'),
          offsetY: $r('sys.float.ohos_id_shadow_default_md_offset_y')
        }
      })
    } else if (DeviceHelper.isPC() && this.viewController.isShowing()) {
      this.MicReminderBuilder({
        textMargin: $r('sys.float.padding_level4'),
        toastbackgroundColor: $r('app.color.mic_reminder_bg_color'),
        borderOrOutlineRadius: $r('sys.float.corner_radius_level4'),
        borderOrOutlineWidth: $r('app.float.micreminder_border_width_pc'),
        shadowOption: {
          color: $r('sys.color.ohos_id_shadow_default_xs'),
          radius: $r('sys.float.ohos_id_shadow_default_xs_shadow'),
          offsetX: $r('sys.float.ohos_id_shadow_default_xs_offset_x'),
          offsetY: $r('sys.float.ohos_id_shadow_default_xs_offset_y')
        },
        backEffect: {
          radius: this.isDarkMode ? Constants.MIC_REMINDER_BLUR_RADIUS_DK : Constants.MIC_REMINDER_BLUR_RADIUS_LG,
        },
        backBrightnessInternal: this.isDarkMode ? this.backBrightnessDarkParam :
        this.backBrightnessLightParam
      })
    }
  }
}