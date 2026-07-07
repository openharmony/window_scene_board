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

import Constants, {
  VolumeAnimType,
  VolumeInfo,
  AnimViewData,
  VolumeBarAlignRule,
} from '../common/Constants';
import ViewModel, { VolumeAccessibilityVM } from '../viewmodel/VolumePanelVM';
import VolumeComponentStyle from '../common/VolumeComponentStyle';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { LogDomain, Logger, } from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  sEventManager,
  obtainLocalEvent
} from '@ohos/frameworkwrapper';
import VolumeWindowController from '../common/VolumeWindowController';
import { VolumePanelServiceWrapper } from '../model/VolumePanelServiceWrapper';
import audio from '@ohos.multimedia.audio';
import { VolumeReportBuilder, VolumeSysEventUtil } from '../common/VolumeSysEventUtil';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { ConfigurationConstant } from '@kit.AbilityKit';
import VolumeProgressCanvasComponent from './VolumeProgressCanvasComponent';
import { SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICommonUtil';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { AccessibilityUtil, VibratorUtil } from '@ohos/systemuicommon';
import { ColorModeVolumeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeVolumeViewData';
import { ResUtils } from '@ohos/windowscene';
import { OutdoorVm } from '@ohos/systemuicommon/src/main/ets/vm/OutdoorVm';

const TAG = 'VolumeControl-Progress';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const CLICK_RADIUS = 3;
const INVALID_FINGER_ID = -1;
const ICON_OPACITY_DURATION: number = 133;

@Component
export default struct VolumeProgressComponent {
  /**
   * 是否支持震动
   */
  private isSupportVibrate: boolean = true;
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Link isBlockExpandCancelTouch: boolean;
  @Link isSideVolumeTouchable: boolean;
  @Link isDragControlStop: boolean; // 拖拽抬手不修改音量
  @Link @Watch('onVolumeAnimTypeChanged') volumeAnimType: number;
  @Link @Watch('onDarkModeChanged') darkModeData: CommonData;
  @Link @Watch('onBackgroundChanged') isShowAboveLauncher: boolean;
  @Link isTouchControlling: boolean; // 侧滑落手不改变音量
  @Link currColorMode: number;
  @Link volumeAccessibilityPercentValues: Map<audio.AudioVolumeType, number>;
  @Link volumeAccessibilityVM: VolumeAccessibilityVM;
  @Link currentActiveVolumeType: audio.AudioVolumeType;
  @Link lightY: Dimension;
  @State @Watch('onVolumeValueChanged') volumeValue: number = Constants.DEFAULT_MAX_VOLUME; // 音量默认最大值
  @State volumeTranslateX: number = 0;
  @State volumeIconScale: number = 1;
  @State volumeIconVisible: Visibility = Visibility.Visible;
  @State volumeIconOpacity: number = 1;
  @State volumeSliderColor: Resource = $r('app.color.volume_side_progress_slider_color');
  @State volumeBackgroundColor: Resource = $r('app.color.volume_panel_progress_background_color_above_launcher');
  @State volumeContainerWidth: number = 0;
  @State componentWidth: number = 0;
  @State componentHeight: number = 0;
  @State leftPadding: number = 0;
  @State isShowVolumeImage: boolean = true;
  @State @Watch('onVolumeHeightPercentChanged') volumeHeightPercent: number = 1;
  @State volumeMediaValue: number = Constants.DEFAULT_MAX_VOLUME; // 音量默认最大值;
  @State colorModeVolumeViewData: ColorModeVolumeViewData = ColorModeViewModel.getInstance().getVolumeViewData();
  @State iconAccessibilityDescription: Resource | undefined = undefined;
  @Prop isDefaultBlackBgColor: boolean;
  @Prop isDefaultWhiteBgColor: boolean;
  @Prop isRTL: boolean;
  @Prop animViewData?: AnimViewData;
  @Prop isExpandVolumePanel?: boolean;
  @Prop isConfigSmallScreen: boolean;
  @Prop activeChannelTypes: audio.AudioVolumeType[] = [];
  @Prop ringerMode: audio.AudioRingMode;
  volumeChannelType: audio.AudioVolumeType = audio.AudioVolumeType.MEDIA;
  volumeChannelName: Resource = $r('app.string.volume_channel_media');
  callback: (volumeType: audio.AudioVolumeType, value: number) => void = () => {
  };
  onVolumeTouchedCallback: (event?: TouchEvent) => void = () => {
  };
  onTouchDownChangedCallback: (windowX: number, windowY: number) => void = () => {
  };
  onExpandVolumeDialog: () => void = () => {};
  onActiveVolumeChannelTypeChange: (volumeChannelType: audio.AudioVolumeType, isMove?: boolean) => void = () => {};
  public volumeIndex: number = 0;
  private maxVolumeValue: number = Constants.DEFAULT_MAX_VOLUME;
  private minVolumeValue: number = Constants.DEFAULT_MIN_VOLUME;
  private volumeComponentStyle = VolumeComponentStyle.getVolumeComponentStyle();
  private mWidth: number = this.volumeComponentStyle.volumeProgressComponentWidth;
  private mHeight: number = this.volumeComponentStyle.volumeProgressComponentHeight;
  private mWidthMax: number = this.volumeComponentStyle.volumeBarMaxWidth;
  private mHeightMax: number = this.volumeComponentStyle.volumeProgressComponentHeightMax; // 166
  private mWidthThin: number = this.volumeComponentStyle.volumeProgressComponentWidthThin;
  private mWidthThinMin: number = this.volumeComponentStyle.volumeProgressComponentWidthThinMin; // 7.2
  private mWidthThinMax: number = this.volumeComponentStyle.volumeProgressComponentWidthThinMax; // 8.8
  private mHeightThinMin: number = this.volumeComponentStyle.volumeProgressComponentHeightThinMin; // 154
  private volumeShadowOptions: ShadowOptions = this.volumeComponentStyle.volumeShadowOptions;
  private volumeIconId: string = '';
  private previousRecoverTimer: number = 0;
  private volumeIconTouchX: number = 0;
  private volumeIconTouchY: number = 0;
  private isVolumeProgressTouchable: boolean = true; // 音量图标支持触摸
  private isNeedTouchDown: boolean = false;
  private fingerId = INVALID_FINGER_ID;
  private isLongPress: boolean = false;
  private isVolumeSetting: boolean = false; // 滑动音量条后，是否正在发送请求，防止回弹
  private debounceSetVolume =
    SystemUICommonUtil.debounce(() => this.isVolumeSetting = false, Constants.SET_VOLUME_DELAY_TIME);
  // 是否立即执行回弹动效
  private isExecuteRecoverVolumeThinSize: boolean = false;
  private realMediaVolumeValue: number = 0;
  @State volumeBarAlignRules: AlignRuleOption = this.volumeComponentStyle.defaultVolumeBarAlignRules;
  @State volumeBarMargin: Margin = this.volumeComponentStyle.defaultVolumeBarMargin;
  private mHeightTopStretch: number = this.volumeComponentStyle.volumeProgressComponentHeightStretch; // 170
  private mHeightDownStretch: number = this.volumeComponentStyle.volumeProgressComponentHeightMax; // 166
  private isTouchStretching: boolean = false; // 是否正在执行滑动触底触顶拉伸动效中，防止重复触发
  private touchDownPointY: number = 0;
  private touchDownVolumeHeight: number = 0;

  aboutToAppear() {
    log.showInfo(TAG, 'aboutToAppear');
    this.onDarkModeChanged(); // 侧边栏使用默认，不是侧边栏的重新初始化
    this.componentWidth = this.mWidth;
    this.componentHeight = this.mHeight;
    this.volumeContainerWidth = this.componentWidth;
    this.isSupportVibrate = ViewModel.checkDeviceSupportVibrate();
    ViewModel.registerVolumeChangedListener(this);
    this.onVolumeTypeChanged();
    this.setVolumeIconId();
    this.setIconAccessibilityDescription();
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
    ViewModel.unRegisterVolumeChangedListener(this);
  }

  // 监听音量高度
  private onVolumeHeightPercentChanged(): void {
    if (this.currentActiveVolumeType === this.volumeChannelType) {
      // 光照向下偏移5%同时跟手
      this.lightY = `${(1 - this.volumeHeightPercent) * 100 + 5}%`;
    }
  }

  onVolumeKeyPressed(isKeyUp: boolean, currentVolumeType: audio.AudioVolumeType): void {
    // 执行侧边栏细条按键动画
    if (!this.isVolumeSideBar()) {
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN ||
      this.volumeAnimType === VolumeAnimType.TYPE_KEY_DOWN_THIN) {
      if (this.isTouchControlling) {
        return;
      }
      this.volumeKeyDownAndUp(isKeyUp);
    }
  }

  onVolumeActiveTypeChanged(activeType: audio.AudioVolumeType) {}

  onVolumeChanged(volumeInfo: VolumeInfo) {
    if (volumeInfo && this.volumeChannelType === audio.AudioVolumeType.MEDIA &&
      volumeInfo.volumeType === audio.AudioVolumeType.MEDIA && !volumeInfo.updateUi) {
      this.realMediaVolumeValue = volumeInfo.volume;
      this.checkSafeMediaVolumeValue();
    }
    if (volumeInfo == null || this.isTouchControlling) {
      log.showWarn(TAG, `volumeInfo is null ${this.isTouchControlling}`);
      return;
    }
    if (this.volumeChannelType != volumeInfo.volumeType) {
      return;
    }

    this.changeSidePanelVolumeInfo(volumeInfo,
      this.volumeAnimType === VolumeAnimType.TYPE_IN && !AccessibilityUtil.isAccessibilityMode());
  }

  onBackgroundChanged(): void {
    if (!this.isVolumeSideBar()) {
      // 侧边栏音量条依据是否桌面修改背景色
      return;
    }
    if (this.isShowAboveLauncher) {
      this.volumeBackgroundColor = $r('app.color.volume_panel_progress_background_color_above_launcher');
    } else {
      this.volumeBackgroundColor = $r('app.color.volume_panel_progress_background_color');
    }
  }

  onActiveTypeChanged(activeType: audio.AudioVolumeType, volumeValue: number, checkVolume: boolean) {}

  onDarkModeChanged(): void {
    if (this.isVolumeSideBar()) {
      // 侧边栏音量条不支持深色模式
      return;
    }
    // 深色模式发生变化，重新获取颜色
    this.volumeSliderColor = $r('app.color.volume_dialog_progress_slider_color');
    this.volumeBackgroundColor = $r('app.color.volume_dialog_progress_background_color');
  }

  build() {
    if (this.showVisibility()) {
      this.buildVolComponent();
    }
  }

  @Builder
  private buildProgress() {
    Column()
      .height((1 - this.volumeHeightPercent) * this.componentHeight)
      .width(this.componentWidth)
      .backgroundColor(this.colorModeViewData.calcSecondarySolidColor(this.getVolumeBrightnessVolumeBlackBg(),
        this.getBrightnessVolumeBlackBg(), this.colorModeVolumeViewData.volumeBgPickColor))
      .backgroundBrightnessInternal(this.colorModeViewData.isSolidEnable() ? undefined :
        this.getBrightnessVolumeBlackBg())
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
      })
      .pixelRound({
        bottom: !this.isExpandVolumePanel && this.volumeHeightPercent < 1 ? PixelRoundCalcPolicy.FORCE_CEIL :
          PixelRoundCalcPolicy.NO_FORCE_ROUND,
      })
    Column()
      .backgroundColor(this.colorModeViewData.calcSecondarySolidColor(this.getVolumeBrightnessVolumeWhiteBg(),
        this.getBrightnessVolumeWhiteBg(), this.colorModeVolumeViewData.volumeBgPickColor))
      .backgroundBrightnessInternal(this.colorModeViewData.isSolidEnable() ? undefined :
      this.getBrightnessVolumeWhiteBg())
      .width(this.componentWidth)
      .height(this.volumeHeightPercent * this.componentHeight)
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      })
      .opacity(this.getWhiteBgOpacity())
      .brightness(this.getWhiteBgBrightness())
  }

  @Builder
  private buildVolComponent() {
    RelativeContainer() {
      if (!this.isExpandVolumePanel) {
        Column() {
          this.buildProgress()
        }
        .borderRadius(this.componentWidth / 2)
        .clip(true)
        .useEffect(true)
        .pointLight(this.getPointLight())
      } else {
        this.buildProgress()
      }
    }
    .id(`${this.volumeIconId}-bg`)
    .width(this.componentWidth)
    .height(this.componentHeight)
    .borderRadius(this.isTouchStretching ? (this.componentWidth / Constants.VOLUME_BAR_STRETCH_WIDTH_RATIO) / 2 :
      this.componentWidth / 2)
    .clip(true)
    .hitTestBehavior(HitTestMode.Block)
    .onTouch(this.onVolumeProgressTouched)
    .gesture(GestureGroup(GestureMode.Exclusive,
      PanGesture(),
      TapGesture()
        .onAction((event: GestureEvent) => {
          const touchPoint = event?.fingerList?.[0];
          if (touchPoint === undefined) {
            return;
          }
          if (!this.isVolumeSideBar()) {
            const progressHeight = this.componentHeight - touchPoint.localY;
            this.setProgressHeight(progressHeight, true);
          }
        }),
      LongPressGesture({ repeat: false })
        .onAction(() => {
          if (this.onExpandVolumeDialog && (this.volumeAnimType === VolumeAnimType.TYPE_IN ||
            this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_STOP ||
            this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK_STOP) && !this.isConfigSmallScreen &&
            !OutdoorVm.instance.isInOutdoorMode) {
            this.isLongPress = true;
            this.onExpandVolumeDialog();
          }
        })))
    .alignSelf(ItemAlign.Center)
    .shadow(this.getVolumeProgressShadow())
    .translate({ x: this.volumeTranslateX })
    .alignRules(this.volumeBarAlignRules)
    .margin(this.volumeBarMargin)
    .responseRegion(this.getVolumeProgressRegion())
    .accessibilityLevel('no')

    Stack({ alignContent: Alignment.Center }) {
      // canvas icon: 不支持alignRules; 开机不加载lottie资源
      if (this.volumeChannelType === audio.AudioVolumeType.MEDIA && this.volumeAnimType !== VolumeAnimType.TYPE_NONE &&
        !this.isUseSliderIcon()) {
        this.loadIcon();
      } else if (this.volumeChannelType === audio.AudioVolumeType.ACCESSIBILITY) {
        this.buildIcon()
      } else {
        // 普通icon 使用alignRules会导致音量柱由粗变细图标消失方式不对
        this.buildSymbolGlyphIcon();
      }
    }
    .id(`${this.volumeIconId}-container`)
    .hitTestBehavior(HitTestMode.Transparent)
    .translate({ x: this.volumeTranslateX })
    .alignRules({
      bottom: { anchor: `${this.volumeIconId}-bg`, align: VerticalAlign.Bottom },
      middle: { anchor: `${this.volumeIconId}-bg`, align: HorizontalAlign.Center }
    })
    .onClick(() => {
      if (this.minVolumeValue === 0 && AccessibilityUtil.isAccessibilityMode()) {
        this.onVolumeIconClicked();
      }
    })
    .onAccessibilityFocus((isFocus: boolean) => {
      this.volumeAccessibilityVM.isContainerFocus = isFocus;
      VolumeWindowController.getInstance()
        .handleAccessibilityAutoDismissTimer(isFocus, this.volumeAnimType);
    })
    .accessibilityDescription(this.iconAccessibilityDescription)
    .accessibilityLevel(this.minVolumeValue === 0 ? 'yes' : 'no')
    .opacity(this.volumeIconOpacity)
  }

  /**
   * 媒体图标
   */
  @Builder
  loadIcon() {
    VolumeProgressCanvasComponent({
      volumeAnimType: this.volumeAnimType,
      volumeMediaValue: this.volumeMediaValue,
      isRTL: this.isRTL,
      volumeIconScale: this.volumeIconScale,
      volumeCanvasVisible: this.volumeIconVisible,
      onVolumeIconTouched: (event?: TouchEvent) => {
        this.onVolumeIconTouched(event);
      },
    })
  }

  @Builder
  buildSymbolGlyphIcon() {
    SymbolGlyph(this.getSymbolGlyphValue())
      .fontSize(Constants.SYMBOL_GLYPH_FONT_SIZE)
      .fontWeight(FontWeight.Normal)
      .fontColor([$r('app.color.volume_channel_icon_color')])
      .hitTestBehavior(HitTestMode.Transparent)
      .margin({ bottom: Constants.ICON_MARGIN_BOTTOM })
      .draggable(false)
      .id(this.volumeIconId)
      .visibility(this.volumeIconVisible)
      .scale({
        x: this.isRTLForSymbolGlyph() ? -this.volumeIconScale : this.volumeIconScale,
        y: this.volumeIconScale,
        centerX: '50%',
        centerY: '50%'
      })
      .onTouch(this.onVolumeIconTouched)
  }

  @Builder
  buildIcon() {
    Image($r('app.media.icon_volume_accessibility'))
      .draggable(false)
      .id(this.volumeIconId)
      .width(18)
      .height(18)
      .scale({
        x: this.volumeIconScale,
        y: this.volumeIconScale,
        centerX: '50%',
        centerY: '50%'
      })
      .visibility(this.volumeIconVisible)
      .margin({ bottom: Constants.ICON_MARGIN_BOTTOM })
      .fillColor($r('app.color.volume_channel_icon_color'))
      .onTouch(this.onVolumeIconTouched)
      .hitTestBehavior(HitTestMode.Transparent)
      .renderGroup(true)
      .matchTextDirection(true)
  }

  private getSymbolGlyphValue(): Resource {
    if (this.volumeChannelType === audio.AudioVolumeType.MEDIA ||
      this.volumeChannelType === audio.AudioVolumeType.VOICE_CALL ||
      this.volumeChannelType === audio.AudioVolumeType.VOICE_ASSISTANT) {
      // 使用外设图标
      if (this.isUseSliderIcon()) {
        log.showInfo(TAG, 'getSymbolGlyphValue isUseSliderIcon: true');
        return this.animViewData?.sliderIcon as Resource;
      }
    }
    return this.getVolumeIcon();
  }

  /**
   * 是否使用外设图标
   */
  private isUseSliderIcon(): boolean {
    if (!this.isExpandVolumePanel && this.animViewData?.useSliderIcon && this.animViewData?.sliderIcon) {
      return true;
    }
    return false;
  }

  /**
   * 图标是否镜像:
   * 外设图标需要镜像
   * 铃声图标、闹钟图标、语音助手图标、不需要镜像
   * 通话图标资源会自动镜像
   * @returns true = 需要镜像 | false = 不需要镜像
   */
  private isRTLForSymbolGlyph(): boolean {
    if (this.isRTL && this.isUseSliderIcon()) {
      return true;
    }
    return false;
  }

  private getVolumeProgressRegion(): Rectangle {
    return this.isStateKeyControl() ? // 细条热区,等价于沿用粗音量条范围 细*5=粗
      {
        x: '-400%',
        y: 0,
        width: '700%',
        height: '100%'
      } :
      !this.isExpandVolumePanel ? // 粗条热区
        {
          x: 0,
          y: 0,
          width: this.activeChannelTypes.findIndex(channelType => channelType === this.volumeChannelType) === 0 ?
            '150%' : '120%',
          height: '100%'
        } : // 展开时默认热区
        {
          x: 0,
          y: -Constants.RESPONSE_REGION_FOR_VOLUME_TOP,
          width: '100%',
          height: this.componentHeight + Constants.RESPONSE_REGION_FOR_VOLUME_TOP +
          Constants.RESPONSE_REGION_FOR_VOLUME_BOTTOM,
        }
  }

  private getBrightnessVolumeWhiteBg(): BrightnessOptions | undefined {
    if (!this.isDefaultWhiteBgColor) {
      return undefined;
    }
    return !this.isExpandVolumePanel ? BrightnessOptionUtils.brightnessVolumeWhiteBg :
      this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
      BrightnessOptionUtils.brightnessVolumeWhiteBgDark : BrightnessOptionUtils.brightnessVolumeWhiteBgLight
  }

  private getBrightnessVolumeBlackBg(): BrightnessOptions | undefined {
    if (!this.isDefaultBlackBgColor) {
      return undefined;
    }
    return !this.isExpandVolumePanel ? BrightnessOptionUtils.brightnessVolumeBlackBg :
      this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
      BrightnessOptionUtils.brightnessVolumeBlackBgDark : BrightnessOptionUtils.brightnessVolumeBlackBgLight
  }

  private getVolumeBrightnessVolumeBlackBg(): ResourceColor {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return this.volumeComponentStyle.volumePanelDialogProgressColor
    } else {
      return this.volumeComponentStyle.volumeExpandDialogProgressColor;
    }
  }

  private getVolumeBrightnessVolumeWhiteBg(): ResourceColor {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return this.volumeComponentStyle.volumeExpandProgressColor
    } else {
      return this.volumeComponentStyle.volumePanelProgressColor;
    }
  }

  private showVisibility() {
    if (this.activeChannelTypes.includes(this.volumeChannelType)) {
      return true;
    }
    return false;
  }

  private getVolumeProgressLeftPadding(): number {
    if (this.isStateKeyControl()) {
      return this.volumeComponentStyle.volumeContainerPadding;
    }
    return 0;
  }

  private getVolumeProgressWidth(): number {
    // 按键调节时增大左侧响应区域
    return this.componentWidth + this.getVolumeProgressLeftPadding();
  }

  private heightToVolumeValue(progressHeight: number): number {
    if (this.componentHeight <= 0) {
      log.showWarn(TAG, `componentHeight is less than 0`);
      return 0;
    }
    // 高度转为音量值向上取整
    let volumeValue =
      Math.ceil((this.maxVolumeValue - Constants.DEFAULT_MIN_VOLUME) * progressHeight / this.componentHeight);
    if (volumeValue > this.maxVolumeValue) {
      volumeValue = this.maxVolumeValue;
    }
    if (volumeValue < this.minVolumeValue) {
      volumeValue = this.minVolumeValue;
    }
    return volumeValue;
  }

  private refreshVolumeHeightPercent(volumeHeight: number): void {
    if (this.maxVolumeValue - Constants.DEFAULT_MIN_VOLUME <= 0) {
      this.volumeHeightPercent = 1;
      log.showWarn(TAG, `refreshVolume: max volume - min volume is less than 0`);
      return;
    }
    this.volumeHeightPercent = volumeHeight / this.componentHeight;
  }

  private checkVolumeHeight(): void {
    this.refreshVolumeHeightPercent(this.volumeValueToHeight(this.volumeValue));
  }

  private volumeValueToHeight(volumeValue: number): number {
    if (this.maxVolumeValue - Constants.DEFAULT_MIN_VOLUME <= 0) {
      log.showWarn(TAG, `volumeToHeight: max volume - min volume is less than 0`);
      return 0;
    }
    return this.componentHeight * volumeValue / (this.maxVolumeValue - Constants.DEFAULT_MIN_VOLUME);
  }

  /**
   * 声道触摸
   */
  private onVolumeProgressTouched = (event?: TouchEvent): void => {
    if (event == null || event.changedTouches == null || event.changedTouches.length <= 0) {
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_NONE) {
      return;
    }
    let pointer = event.changedTouches[0];
    if (pointer == null) {
      return;
    }
    if (TouchType.Down === event.type) {
      this.isBlockExpandCancelTouch = false;
      this.isTouchControlling = true;
      if (this.fingerId === INVALID_FINGER_ID) {
        this.fingerId = pointer.id;
        this.touchDownPointY = pointer.y;
        this.touchDownVolumeHeight = this.volumeHeightPercent * this.componentHeight;
        this.realMediaVolumeValue = 0;
      }
      this.onActiveVolumeChannelTypeChange?.(this.volumeChannelType);
    }
    if (this.fingerId !== pointer.id) {
      log.showWarn(TAG, `No need Touch change volume ${this.volumeChannelType} ${this.fingerId} ${pointer.id}`);
      return;
    }
    if (TouchType.Up === event.type || TouchType.Cancel === event.type) {
      this.isTouchControlling = false;
      if (this.fingerId === pointer.id) {
        this.fingerId = INVALID_FINGER_ID;
        if (this.isVolumeSideBar()) {
          this.executeShrinkAnimForTouch();
        }
        this.checkSafeMediaVolumeValue();
      }
    }
    if (this.isBlockExpandCancelTouch) {
      if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.isBlockExpandCancelTouch = false;
      }
      return;
    }
    this.processUserInteraction(event);
    if (!this.isVolumeProgressTouchable) {
      if (TouchType.Up === event.type || TouchType.Cancel === event.type) {
        this.isVolumeProgressTouchable = true;
      }
      return;
    }
    this.onTouchCallback(pointer.windowX, pointer.windowY, event);
    if (!this.isSideVolumeTouchable) {
      if (TouchType.Up === event.type || TouchType.Cancel === event.type) {
        this.isSideVolumeTouchable = true;
        if (this.isVolumeSideBar() && !this.isDragControlStop && !this.isLongPress) {
          // 不包括侧滑反悔
          this.touchChangeVolume(event, true);
        }
        this.isDragControlStop = false;
        this.isLongPress = false; // 长按时不响应音量滑动调节事件
      }
      return;
    }
    if (TouchType.Move === event.type) { // 避免抬手时已经触发音量条缩小，componentHeight变小导致高度计算错误
      this.touchChangeVolume(event);
    }
  }

  private onTouchCallback(windowX: number, windowY: number, event?: TouchEvent): void {
    if (this.onVolumeTouchedCallback) {
      if (this.isNeedTouchDown) {
        if (this.onTouchDownChangedCallback) {
          this.onTouchDownChangedCallback(windowX, windowY);
        }
        this.isNeedTouchDown = false;
      }
      this.onVolumeTouchedCallback(event);
    }
  }

  /**
   * 手指触摸更改音量
   * @param event
   */
  private touchChangeVolume(event: TouchEvent, isTouchUp: boolean = false): void {
    if (!event) {
      log.showError(TAG, 'touchChangeVolume event is invalid');
      return;
    }
    const touchPoint = event.changedTouches[0];
    const moveDistance = this.touchDownPointY - touchPoint.y;
    // 滑动距离未达到阈值不修改音量
    if (event.type === TouchType.Move && Math.abs(moveDistance) < Constants.MOVE_DISTANCE_THRESHOLD) {
      return;
    }

    let progressHeight = this.componentHeight - touchPoint.y;
    if (event.type === TouchType.Move) {
      progressHeight = this.touchDownVolumeHeight + moveDistance;
      // 滑动音量触底触顶后继续滑动
      const isTopExceeded = this.volumeValue === this.maxVolumeValue && progressHeight > this.mHeightMax;
      const isBottomExceeded = this.volumeValue === this.minVolumeValue && progressHeight < 0;
      if (isTopExceeded || isBottomExceeded) {
        // 执行触底触顶拉伸动效
        this.executeStretchAnimForTouch(isTopExceeded ? VolumeBarAlignRule.TOP : VolumeBarAlignRule.DOWN);
        progressHeight = isTopExceeded ? this.componentHeight : 0;
      } else if (progressHeight > 0 && progressHeight < this.mHeightTopStretch) {
        // 执行拉伸状态下的收缩动效
        this.executeShrinkAnimForTouch();
      }
    }
    log.showDebug(TAG, `TouchEvent type ${touchPoint.type}, x ${touchPoint.x}, y ${touchPoint.y}, h ${progressHeight} ${this.componentHeight}`);
    this.setProgressHeight(progressHeight, isTouchUp);
  }

  private setProgressHeight(progressHeight: number, isTouchUp: boolean = false): void {
    if (progressHeight < 0) {
      progressHeight = 0;
    }
    if (progressHeight > this.componentHeight) {
      progressHeight = this.componentHeight;
    }
    let resultValue = this.heightToVolumeValue(progressHeight);
    if (resultValue <= this.minVolumeValue) {
      // 显示高度校验，通话通道最小值不为0
      resultValue = this.minVolumeValue;
      progressHeight = this.volumeValueToHeight(this.minVolumeValue);
    }
    this.executeAnimForRefreshPercent(progressHeight, isTouchUp);
    if (this.volumeValue != resultValue) {
      this.volumeValue = resultValue;
      //音量条面板展开时滑动打点
      VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_ADJUSTED,
        VolumeReportBuilder.builder()
          .channel(this.volumeChannelType)
          .isLocked(ScreenLockApi.getLock())
          .uiType(this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ? 1 : 0)
          .volume(resultValue)
          .adjustedType(1)
          .build())
      HiDfxEventUtil.reportSlideSelectedVolBar(this.volumeChannelType, resultValue);
      try {
        this.isVolumeSetting = true;
        this.debounceSetVolume();
        VolumePanelServiceWrapper.setVolumeByTypeAsync(this.volumeChannelType, resultValue);
      } catch (error) {
        log.error(TAG, 'set volume error', error);
      }
      if (resultValue === 0) {
        this.setRingMode(this.volumeChannelType, resultValue);
        VolumeWindowController.getInstance().updateVolumeInfo(null);
      }
    }
  }

  private volumeKeyDownAndUp(isKeyUp: boolean): void {
    if (this.volumeAnimType === VolumeAnimType.TYPE_KEY_DOWN_THIN) {
      if (this.volumeValue <= 0 && this.componentHeight < this.mHeightDownStretch) {
        this.executeStretchAnimForVolumeKey(VolumeBarAlignRule.DOWN);
        return;
      }
      // 按音量下键，音量条处于收缩状态
      const isShrinkState = this.componentWidth === this.mWidthThinMax && this.componentHeight === this.mHeightThinMin;
      // 按音量下键，音量条处于触底拉伸状态
      const isStretchState =
        this.componentWidth === this.mWidthThinMin && this.componentHeight === this.mHeightDownStretch;
      if (isShrinkState || isStretchState) {
        this.isExecuteRecoverVolumeThinSize = true;
        return;
      }
      this.executeKeyDownAnim();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN) {
      if (this.volumeValue >= this.maxVolumeValue && this.componentHeight < this.mHeightTopStretch) {
        this.executeStretchAnimForVolumeKey(VolumeBarAlignRule.TOP);
        return;
      }
      // 按音量上键，音量条处于正常拉伸状态
      const isNormalStretchState =
        this.componentWidth === this.mWidthThinMin && this.componentHeight === this.mHeightMax;
      // 按音量上键，音量条处于触顶拉伸状态
      const isTopStretchState =
        this.componentWidth === this.mWidthThinMin && this.componentHeight === this.mHeightTopStretch;
      if (isNormalStretchState || isTopStretchState) {
        this.isExecuteRecoverVolumeThinSize = true;
        return;
      }
      this.executeKeyUpAnim();
    }
  }

  /**
   * 解决连续按键抖动，连续同一状态保持不变，让动画执行结束
   */
  private recoverVolumeThinSize(delay: number = 150): void {
    // 双通道时非活跃通道不触发
    if (this.activeChannelTypes.length > 1 && !this.isMainVolumeBar()) {
      return;
    }
    this.clearThinRecoverTimer();
    this.previousRecoverTimer = setTimeout(() => {
      if (this.volumeAnimType !== VolumeAnimType.TYPE_KEY_UP_THIN &&
        this.volumeAnimType !== VolumeAnimType.TYPE_KEY_DOWN_THIN) {
        // 动画时长导致上手后音量条仍为细状态
        return;
      }
      animateTo({
        duration: 450,
        iterations: 1,
        curve: this.volumeComponentStyle.interpolatingKeyUpAndDown,
        playMode: PlayMode.Normal
      }, () => {
        this.componentWidth = this.mWidthThin;
        this.componentHeight = this.mHeight;
        this.volumeTranslateX = 0;
        this.leftPadding = this.getVolumeProgressLeftPadding();
        this.volumeContainerWidth = this.getVolumeProgressWidth();
        this.setVolumeAlignRules();
      });
    }, delay);
  }

  private clearThinRecoverTimer(): void {
    if (this.previousRecoverTimer > 0) {
      clearTimeout(this.previousRecoverTimer);
      this.previousRecoverTimer = 0;
    }
  }

  onKeyUp(): void {
    const delay = this.isExecuteRecoverVolumeThinSize ? 0 : 150;
    this.isExecuteRecoverVolumeThinSize = false;
    setTimeout(() => {
      this.recoverVolumeThinSize(delay);
    }, 50);
  }

  private onVolumeAnimTypeChanged(): void {
    if (this.volumeAnimType === VolumeAnimType.TYPE_NONE) {
      this.fingerId = INVALID_FINGER_ID;
    }
    this.onDarkModeChanged();
    if (this.volumeAnimType === VolumeAnimType.TYPE_IN) {
      // 父组件先添加，添加后子组件添加，事件先通知父组件：影响连续按键动效
      ViewModel.registerVolumeKeyPressedListener(this);
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      ViewModel.unRegisterVolumeKeyPressedListener(this);
      return;
    }
    if (this.isExpandVolumePanel) {
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_TO_THIN) {
      this.onVolumeAnimTypeThickToThin();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK) {
      this.onVolumeAnimTypeThinToThick();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK_STOP) {
      this.onVolumeAnimTypeThinToThickStop();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START) {
      this.onVolumeAnimTypeThickDownStart();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_STOP) {
      this.onVolumeAnimTypeThickDownStop();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN) {
      this.onDarkModeChanged();
      this.volumeTranslateX = 0
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_NONE) {
      this.onVolumeAnimTypeNone();
      return;
    }
  }

  private onVolumeAnimTypeThickToThin() {
    if (this.activeChannelTypes.length > 1 && !this.isMainVolumeBar()) {
      return;
    }
    animateTo({
      duration: 200,
      iterations: 1,
      curve: Curve.Sharp,
      playMode: PlayMode.Normal,
      delay: 100
    }, () => {
      this.volumeIconVisible = Visibility.Hidden;
    });
    animateTo({
      duration: 350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThick2Thin,
      playMode: PlayMode.Normal
    }, () => {
      this.componentWidth = this.mWidthThin;
      this.componentHeight = this.mHeight;
      this.volumeIconScale = 0.4;
      this.leftPadding = this.getVolumeProgressLeftPadding();
    });
    animateTo({
      duration: ICON_OPACITY_DURATION,
      iterations: 1,
      curve: Curve.Linear,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeIconOpacity = 0;
    });
  }

  private onVolumeAnimTypeThinToThick() {
    animateTo({
      duration: 350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThin2Thick,
      playMode: PlayMode.Normal
    }, () => {
      // 双通道时宽度不变，单音量条宽度加宽
      this.componentWidth = this.activeChannelTypes.length > 1 ? this.mWidth : this.mWidthMax;
      this.componentHeight = this.mHeightMax;
      this.volumeIconScale = 1;
      this.leftPadding = this.getVolumeProgressLeftPadding();
      this.volumeContainerWidth = this.getVolumeProgressWidth();
    });
    animateTo({
      duration: 350,
      iterations: 1,
      curve: Curve.Sharp,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeIconVisible = Visibility.Visible;
    });
    animateTo({
      duration: ICON_OPACITY_DURATION,
      iterations: 1,
      curve: Curve.Linear,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeIconOpacity = 1;
    });
  }

  private onVolumeAnimTypeThinToThickStop() {
    animateTo({
      duration: 350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal
    }, () => {
      this.componentWidth = this.mWidth;
      this.componentHeight = this.mHeight;
      this.leftPadding = 0;
      this.volumeContainerWidth = this.componentWidth;
      this.setVolumeAlignRules();
    });
  }

  private onVolumeAnimTypeThickDownStart() {
    if (this.activeChannelTypes.length > 1) {
      return;
    }
    animateTo({
      duration: 350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThickDownStart,
      playMode: PlayMode.Normal
    }, () => {
      this.componentWidth = this.mWidthMax;
      this.componentHeight = this.mHeightMax;
      this.leftPadding = 0;
      this.volumeContainerWidth = this.componentWidth;
      this.checkVolumeHeight();
    });
  }

  private onVolumeAnimTypeThickDownStop() {
    animateTo({
      duration: 350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThickDownStop,
      playMode: PlayMode.Normal
    }, () => {
      this.componentWidth = this.mWidth;
      this.componentHeight = this.mHeight;
      this.leftPadding = 0;
      this.volumeContainerWidth = this.componentWidth;
    });
  }

  private onVolumeAnimTypeNone() {
    log.showInfo(TAG, `onVolumeAnimTypeNone ${this.volumeChannelType} volId:${this.volumeIconId}`);
    this.componentWidth = this.mWidth;
    this.componentHeight = this.mHeight;
    this.volumeTranslateX = 0;
    this.volumeIconScale = 1;
    this.volumeIconOpacity = 1;
    this.volumeIconVisible = Visibility.Visible;
    this.leftPadding = this.getVolumeProgressLeftPadding();
    this.volumeContainerWidth = this.getVolumeProgressWidth();
    this.isLongPress = false;
  }

  private onVolumeValueChanged(): void {
    this.volumeAccessibilityPercentValues.set(this.volumeChannelType,
      Math.round(this.volumeValue / this.maxVolumeValue * 100));
    this.setIconAccessibilityDescription();
    if (this.volumeChannelType === audio.AudioVolumeType.MEDIA) {
      this.volumeMediaValue = this.volumeValue;
      return;
    }
  }

  private isStateKeyControl(): boolean {
    if (!this.isVolumeSideBar()) {
      return false;
    }
    return this.volumeAnimType === VolumeAnimType.TYPE_THICK_TO_THIN ||
      this.volumeAnimType === VolumeAnimType.TYPE_KEY_DOWN_THIN ||
      this.volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN;
  }

  private isVolumeSideBar(): boolean {
    if (!this.isMainVolumeBar()) {
      return false;
    }
    return this.volumeAnimType !== VolumeAnimType.TYPE_ALL_CONTROL_IN &&
      this.volumeAnimType !== VolumeAnimType.TYPE_ALL_CONTROL_OUT;
  }

  private isMainVolumeBar(): boolean {
    return this.volumeChannelType === this.currentActiveVolumeType;
  }

  private getVolumeProgressShadow(): ShadowOptions | undefined {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return undefined
    }
    return this.volumeShadowOptions;
  }

  /**
   * 获取声道底部展示的图标
   * @returns
   */
  private getVolumeIcon(): Resource {
    if (this.volumeChannelType === audio.AudioVolumeType.VOICE_CALL) {
      return Constants.SYMBOL_PHONE_FILL;
    }
    if (this.volumeChannelType === audio.AudioVolumeType.ALARM) {
      return Constants.SYMBOL_ALARM_FILL;
    }
    if (this.volumeChannelType === audio.AudioVolumeType.VOICE_ASSISTANT) {
      return Constants.SYMBOL_VOICE_FILL;
    }
    if (this.volumeChannelType === audio.AudioVolumeType.RINGTONE) {
      switch (this.ringerMode) {
        case audio.AudioRingMode.RINGER_MODE_SILENT:
          return Constants.SYMBOL_BELL_SLASH_FILL;
        case audio.AudioRingMode.RINGER_MODE_VIBRATE:
          // 适配PCE设备无震动模式
          return this.isSupportVibrate ? Constants.SYMBOL_RECTANGLE_PORTRAIT_WAVE_2_FILL :
          Constants.SYMBOL_BELL_SLASH_FILL;
        case audio.AudioRingMode.RINGER_MODE_NORMAL:
          return Constants.SYMBOL_BELL_FILL;
        default:
          return Constants.SYMBOL_BELL_FILL;
      }
    }
    // 兜底，不支持的声道暂时显示成媒体
    if (this.volumeValue > ((this.maxVolumeValue - this.minVolumeValue) * 2 / 3 + this.minVolumeValue)) {
      return Constants.SYMBOL_SPEAKER_WAVE_3_FILL;
    } else if (this.volumeValue > ((this.maxVolumeValue - this.minVolumeValue) / 3 + this.minVolumeValue)) {
      return Constants.SYMBOL_SPEAKER_WAVE_2_FILL;
    } else {
      return Constants.SYMBOL_SPEAKER_WAVE_1_FILL;
    }
  }

  private changeSidePanelVolumeInfo(volumeInfo: VolumeInfo, immediately?: boolean) {
    if (volumeInfo.volume !== this.maxVolumeValue && this.volumeValue === volumeInfo.volume) {
      return;
    }

    if (this.isVolumeSetting) {
      log.showInfo(TAG, `isVolumeSetting ${this.volumeValue} ${volumeInfo.volume}`);
      return;
    }

    if (volumeInfo.volumeType === this.volumeChannelType) {
      if (ViewModel.isMute(this.volumeChannelType)) {
        this.volumeValue = this.minVolumeValue;
      } else {
        this.volumeValue = volumeInfo.volume;
      }
      if (immediately) {
        this.checkVolumeHeight();
        return;
      }
      // 按键细条高度值渐变
      animateTo({
        duration: 450,
        iterations: 1,
        curve: this.volumeComponentStyle.interpolatingSpringVolumeProgress,
        playMode: PlayMode.Normal
      }, () => {
        this.checkVolumeHeight();
      });
    }
  }

  public onVolumeTypeChanged(): void {
    ViewModel.getMaxVolume(this.volumeChannelType, (value) => {
      this.maxVolumeValue = value;
      this.checkVolumeHeight();
    });
    ViewModel.getMinVolume(this.volumeChannelType, (value) => {
      this.minVolumeValue = value;
      this.checkVolumeHeight();
    });
    ViewModel.getVolumeByType(this.volumeChannelType, (volumeInfo: VolumeInfo) => {
      if (volumeInfo == null || this.volumeChannelType != volumeInfo.volumeType) {
        return;
      }
      this.volumeValue = volumeInfo.volume;
      if (this.volumeChannelType === audio.AudioVolumeType.MEDIA) {
        this.volumeMediaValue = this.volumeValue;
      }
      log.showInfo(TAG, `onVolumeTypeChanged channelType:${this.volumeChannelType} volumeValue:${this.volumeValue}`);
      this.checkVolumeHeight();
    });
  }

  /**
   * icon触摸事件icon处理完后，会向上继续传给父组件
   * 解决icon上落手点击或滑动意图区分
   *
   * @param event 触摸事件
   */
  private onVolumeIconTouched = (event?: TouchEvent): void => {
    // 正在消失时不响应图标触摸事件
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_NONE) {
      return;
    }
    if (this.isLongPress) {
      // 长按时不响应图标触摸事件
      log.showInfo(TAG, `long press;`);
      return;
    }
    if (!event?.touches?.length || !event?.changedTouches?.length) {
      return;
    }
    let x: number = event.touches[0].windowX;
    let y: number = event.touches[0].windowY;
    if (TouchType.Down === event.type) {
      this.isVolumeProgressTouchable = false;
      this.volumeIconTouchX = x;
      this.volumeIconTouchY = y;
      return;
    }
    if (TouchType.Move === event.type) {
      if (this.isVolumeProgressTouchable) {
        return;
      }
      let deltaScreenX = x - this.volumeIconTouchX;
      let deltaScreenY = y - this.volumeIconTouchY;
      let delta = VolumeWindowController.getInstance().rotateCoordinate(deltaScreenX, deltaScreenY);
      let deltaX = delta[0];
      let deltaY = delta[1];
      if (Math.abs(deltaX) > CLICK_RADIUS || Math.abs(deltaY) > CLICK_RADIUS) {
        // 一个方向移动超出阈值判定为滑动，此时音量条开始响应触摸事件
        this.isVolumeProgressTouchable = true;
        this.isNeedTouchDown = true;
      }
      return;
    }

    if ((TouchType.Up === event.type || TouchType.Cancel === event.type) && !this.isVolumeProgressTouchable) {
      if (this.minVolumeValue > Constants.DEFAULT_MIN_VOLUME) {
        this.onOtherVolumeIconClicked(event);
      } else {
        this.onVolumeIconClicked();
      }
      this.onActiveVolumeChannelTypeChange?.(this.volumeChannelType, true);
    }
  }

  /**
   * 点击静音图标
   */
  private onVolumeIconClicked(): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      VolumeWindowController.getInstance().startAutoDismissTimer();
    }
    let isMute = !ViewModel.isMute(this.volumeChannelType);
    if (isMute) {
      this.volumeValue = this.minVolumeValue;
      VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_ADJUSTED,
        VolumeReportBuilder.builder()
          .channel(this.volumeChannelType)
          .isLocked(ScreenLockApi.getLock())
          .uiType(this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ? 1 : 0)
          .volume(this.volumeValue)
          .adjustedType(1)
          .build())
      VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_PANEL_CLICK_MUTE,
        VolumeReportBuilder.builder().channel(this.volumeChannelType).isLocked(ScreenLockApi.getLock()).build());
    } else {
      let lastVolume = ViewModel.getLastVolumeValue(this.volumeChannelType);
      this.volumeValue = (lastVolume === this.minVolumeValue) ? this.minVolumeValue + 1 : lastVolume;
      VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_PANEL_CLICK_CANCEL_MUTE,
        VolumeReportBuilder.builder().channel(this.volumeChannelType).isLocked(ScreenLockApi.getLock()).build());
    }
    log.showInfo(TAG, `onVolumeIconClicked ${this.volumeChannelType} ${isMute}  ${this.volumeValue}`)
    ViewModel.setMuteByType(this.volumeChannelType, isMute);
    if (!this.isVolumeSideBar()) {
      this.executeAnimForRefreshPercent(this.volumeValueToHeight(this.volumeValue), true);
    } else {
      this.refreshSliderVolume(isMute);
    }
  }

  /**
   * 处理其他音量最小值不为0的icon点击
   */
  private onOtherVolumeIconClicked(event: TouchEvent): void {
    const touchPoint = event.changedTouches[0];
    const iconHeight = ResUtils.getNumberFromLength(Constants.SYMBOL_GLYPH_FONT_SIZE);
    const progressHeight = iconHeight + Constants.ICON_MARGIN_BOTTOM - touchPoint.y;
    this.setProgressHeight(progressHeight, true);
    log.showInfo(TAG, `onOtherVolumeIconClicked, progressHeight: ${progressHeight}, volumeValue: ${this.volumeValue}`);
  }

  private refreshSliderVolume(isMute: boolean) {
    if (isMute) {
      this.executeAnimForRefreshPercent(this.volumeValueToHeight(this.volumeValue), true);
    } else {
      // 按键细条高度值渐变
      animateTo({
        duration: 450,
        iterations: 1,
        curve: this.volumeComponentStyle.interpolatingSpringVolumeProgress,
        playMode: PlayMode.Normal
      }, () => {
        this.checkVolumeHeight();
      });
    }
  }

  private setVolumeIconId(): void {
    if (this.volumeChannelType == audio.AudioVolumeType.RINGTONE) {
      this.volumeIconId = `${TAG}_Image_ringtone`;
      return;
    }
    if (this.volumeChannelType == audio.AudioVolumeType.ALARM) {
      this.volumeIconId = `${TAG}_Image_alarm`;
      return;
    }
    if (this.volumeChannelType == audio.AudioVolumeType.VOICE_CALL) {
      this.volumeIconId = `${TAG}_Image_call`;
      return;
    }
    if (this.volumeChannelType == audio.AudioVolumeType.VOICE_ASSISTANT) {
      this.volumeIconId = `${TAG}_Image_voice`;
      return;
    }
    if (this.volumeChannelType == audio.AudioVolumeType.ACCESSIBILITY) {
      this.volumeIconId = `${TAG}_Image_accessibility`;
      return;
    }
    this.volumeIconId = `${TAG}_Image_media`;
  }

  private processUserInteraction(event?: TouchEvent): void {
    if (AccessibilityUtil.isAccessibilityMode() &&
      (this.volumeAccessibilityVM.isContainerFocus || this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN)) {
      return;
    }
    if (event?.type === TouchType.Down) {
      VolumeWindowController.getInstance().pauseAutoDismissTimer();
      return
    }
    if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      VolumeWindowController.getInstance().startAutoDismissTimer();
    }
  }

  private setRingMode(volumeType: audio.AudioVolumeType, volume: number): void {
    if (volumeType !== audio.AudioVolumeType.RINGTONE) {
      return;
    }
    let ringMode = (volume <= 0) ?
      (this.isSupportVibrate ? audio.AudioRingMode.RINGER_MODE_VIBRATE : audio.AudioRingMode.RINGER_MODE_SILENT) :
    audio.AudioRingMode.RINGER_MODE_NORMAL;
    sEventManager.publish(obtainLocalEvent('RingModeEvent', ringMode));
  }

  private setIconAccessibilityDescription(): void {
    const mediaChannelName = $r('app.string.volume_accessibility_media');
    const activeChannelName = ViewModel.getAllSupportedVolumeChannels().find(channel => channel.volumeType ===
    this.volumeChannelType)?.channelName ?? mediaChannelName;
    const channelName =
      this.volumeChannelType === audio.AudioVolumeType.MEDIA ? mediaChannelName :
        activeChannelName;
    this.iconAccessibilityDescription = $r('app.string.volume_accessibility_icon', channelName,
      this.volumeValue === 0 ? $r('app.string.volume_accessibility_icon_disabled') :
      $r('app.string.volume_accessibility_icon_enabled'));
  }

  private checkSafeMediaVolumeValue(): void {
    // 连接外设时可能会触发安全音量提示抬手或音频回调后检查恢复当前音量
    if (this.realMediaVolumeValue && this.realMediaVolumeValue !== this.volumeValue && !this.isTouchControlling &&
      this.realMediaVolumeValue === Math.ceil(this.maxVolumeValue / 2)) {
      this.volumeValue = this.realMediaVolumeValue;
      this.volumeMediaValue = this.volumeValue;
      this.refreshSliderVolume(false);
      this.realMediaVolumeValue = 0;
    }
  }

  private getPointLight(): PointLightStyle {
    const activeChannelIndex =
      this.activeChannelTypes.findIndex(channelType => channelType === this.currentActiveVolumeType);
    const currentChannelIndex =
      this.activeChannelTypes.findIndex(channelType => channelType === this.volumeChannelType);
    const spaceIndex = currentChannelIndex - activeChannelIndex;
    return this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START && Math.abs(spaceIndex) === 1 ? {
      lightSource: {
        positionX: spaceIndex > 0 ? '100%' : '0%',
        positionY: this.lightY,
        positionZ: 45,
        intensity: 1,
        color: $r('app.color.volume_side_progress_color')
      },
      illuminated: IlluminatedType.BORDER,
      bloom: 3,
    } : {
      lightSource: {
        positionX: 0,
        positionY: 0,
        positionZ: 0,
        intensity: 0,
        color: ''
      },
      illuminated: IlluminatedType.NONE,
      bloom: 0,
    }
  }

  private getWhiteBgOpacity(): number {
    if (this.activeChannelTypes.length > 1 && !this.isExpandVolumePanel) {
      if (this.currentActiveVolumeType !== this.volumeChannelType) {
        return 0.6;
      } else if (this.currentActiveVolumeType === this.volumeChannelType &&
        this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START) {
        return 1;
      } else {
        return 0.9;
      }
    }
    return 1;
  }

  private getWhiteBgBrightness(): number {
    if (this.activeChannelTypes.length > 1 && !this.isExpandVolumePanel) {
      if (this.currentActiveVolumeType !== this.volumeChannelType) {
        return 1;
      } else if (this.currentActiveVolumeType === this.volumeChannelType &&
        this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START) {
        return 1.2;
      } else {
        return 1.1;
      }
    }
    return 1;
  }

  /**
   * 按音量上键执行拉伸动效
   */
  private executeKeyUpAnim(): void {
    animateTo({
      duration: 450,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingKeyUpAndDown,
      playMode: PlayMode.Normal
    }, () => {
      this.componentWidth = this.mWidthThinMin;
      this.componentHeight = this.mHeightMax;
      // 按键时未以中心变化，向左平移（8-7.2）
      this.volumeTranslateX = (this.mWidthThinMin - this.mWidthThin) / 2;
      this.leftPadding = this.getVolumeProgressLeftPadding();
      this.volumeContainerWidth = this.getVolumeProgressWidth();
    });
  }

  /**
   * 按音量下键执行收缩动效
   */
  private executeKeyDownAnim(): void {
    animateTo({
      duration: 450,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingKeyUpAndDown,
      playMode: PlayMode.Normal
    }, () => {
      this.componentWidth = this.mWidthThinMax;
      this.componentHeight = this.mHeightThinMin;
      // 按键时未以中心变化，向右平移（8-8.8）
      this.volumeTranslateX = (this.mWidthThinMax - this.mWidthThin) / 2;
      this.leftPadding = this.getVolumeProgressLeftPadding();
      this.volumeContainerWidth = this.getVolumeProgressWidth();
    });
  }

  /**
   * 点击音量条音量进度动效
   */
  private executeAnimForRefreshPercent(progressHeight: number, isTouchUp: boolean = false): void {
    if (isTouchUp) {
      animateTo({
        duration: 450,
        iterations: 1,
        curve: this.volumeComponentStyle.interpolatingSpringVolumeProgress,
        playMode: PlayMode.Normal,
      }, () => {
        this.refreshVolumeHeightPercent(progressHeight);
      });
    } else {
      animateTo({
        curve: this.volumeComponentStyle.responsiveSpringMotionVolumeProgress,
      }, () => {
        this.refreshVolumeHeightPercent(progressHeight);
      })
    }
  }

  /**
   * 音量按键触发触底触顶动效
   */
  private executeStretchAnimForVolumeKey(alignRule: VolumeBarAlignRule): void {
    animateTo({
      duration: 450,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingKeyUpAndDown,
      playMode: PlayMode.Normal,
    }, () => {
      this.setVolumeAlignRules(alignRule, true);
      this.componentHeight = alignRule === VolumeBarAlignRule.TOP ? this.mHeightTopStretch : this.mHeightDownStretch;
      this.componentWidth = this.mWidthThinMin;
      // 按键时未以中心变化，向左平移（8-7.2）
      this.volumeTranslateX = (this.mWidthThinMin - this.mWidthThin) / 2;
    });
    this.startVibration(alignRule, 0);
  }

  /**
   * 滑动触发触底触顶动效
   */
  private executeStretchAnimForTouch(alignRule: VolumeBarAlignRule): void {
    if ((this.volumeAnimType !== VolumeAnimType.TYPE_THICK_DOWN_START &&
      this.volumeAnimType !== VolumeAnimType.TYPE_THIN_TO_THICK) || this.isTouchStretching) {
      return;
    }
    if (this.volumeValue !== Constants.DEFAULT_MIN_VOLUME && this.volumeValue !== Constants.DEFAULT_MAX_VOLUME) {
      return;
    }
    this.isTouchStretching = true;
    animateTo({
      duration: 450,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringVolumeProgress,
      playMode: PlayMode.Normal,
    }, () => {
      const width = this.activeChannelTypes.length > 1 ? this.mWidth : this.mWidthMax;
      this.componentHeight = this.mHeightTopStretch;
      this.componentWidth = width * Constants.VOLUME_BAR_STRETCH_WIDTH_RATIO;
      this.volumeTranslateX = -width * (1 - Constants.VOLUME_BAR_STRETCH_WIDTH_RATIO) / 2;
      this.setVolumeAlignRules(alignRule);
    });
    this.startVibration(alignRule, 1);
  }

  /**
   * 滑动回弹动效
   */
  private executeShrinkAnimForTouch(): void {
    if ((this.volumeAnimType !== VolumeAnimType.TYPE_THICK_DOWN_START &&
      this.volumeAnimType !== VolumeAnimType.TYPE_THIN_TO_THICK) || !this.isTouchStretching) {
      return;
    }
    this.isTouchStretching = false;
    animateTo({
      duration: 450,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringVolumeProgress,
      playMode: PlayMode.Normal
    }, () => {
      if (this.activeChannelTypes.length > 1) { // 双通道
        this.componentHeight = this.mHeight;
        this.componentWidth = this.mWidth;
      } else {
        this.componentHeight = this.mHeightMax;
        this.componentWidth = this.mWidthMax;
      }
      this.volumeTranslateX = 0;
      this.setVolumeAlignRules();
    });
  }

  /**
   * 触底触顶后触发振动和打点
   * @param alignRule 对齐方式
   * @param adjustedType 调整音量方式: 0 = 按键控制 | 1 = 滑动控制
   */
  private startVibration(alignRule: VolumeBarAlignRule, adjustedType: number): void {
    // 触底触顶触发振动
    const intensity = alignRule === VolumeBarAlignRule.TOP ? Constants.VIBRATION_INTENSITY_FOR_TOP :
    Constants.VIBRATION_INTENSITY_FOR_DOWN;
    setTimeout(() => {
      log.showInfo(TAG, `startVibration, adjustedType: ${adjustedType} intensity: ${intensity}`);
      VibratorUtil.startVibration('haptic.slide', 'physicalFeedback', intensity);
    }, adjustedType === 0 ? Constants.VIBRATION_DELAY_TIME : 0);
    // 触底触顶打点
    VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_BAR_OVER_TOP_OR_DOWN,
      VolumeReportBuilder.builder()
        .channel(this.volumeChannelType)
        .isLocked(ScreenLockApi.getLock())
        .adjustedType(adjustedType)
        .volumeValTopOrDown(alignRule)
        .build());
  }

  /**
   * 设置音量条在触底触顶拉起时的对齐方式
   */
  private setVolumeAlignRules(alignRule: VolumeBarAlignRule = VolumeBarAlignRule.DEFAULT, isSetMargin?: boolean): void {
    switch (alignRule) {
      case VolumeBarAlignRule.TOP:
        this.volumeBarAlignRules = {
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          right: { anchor: '__container__', align: HorizontalAlign.End },
        };
        const marginBottom = (this.mHeight - this.mHeightMax) / 2;
        this.volumeBarMargin = {
          top: 0,
          bottom: isSetMargin && this.componentHeight === this.mHeightMax ? marginBottom : 0,
        };
        break;
      case VolumeBarAlignRule.DOWN:
        this.volumeBarAlignRules = {
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End },
        };
        const marginTop = (this.mHeight - this.mHeightThinMin) / 2;
        this.volumeBarMargin = {
          top: isSetMargin && this.componentHeight === this.mHeightThinMin ? marginTop : 0,
          bottom: 0,
        };
        break;
      default:
        this.volumeBarAlignRules = this.volumeComponentStyle.defaultVolumeBarAlignRules;
        this.volumeBarMargin = this.volumeComponentStyle.defaultVolumeBarMargin;
        break;
    }
  }
}

@Concurrent
export function setVolumeByTypeAsync(volumeType: audio.AudioVolumeType, volume: number): void {
  VolumePanelServiceWrapper.setVolumeByTypeAsync(volumeType, volume);
}