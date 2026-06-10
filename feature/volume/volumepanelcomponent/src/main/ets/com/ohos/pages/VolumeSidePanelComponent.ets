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

import VolumeProgressComponent from '../pages/VolumeProgressComponent';
import { LogDomain, Logger, } from '@ohos/basicutils';
import {
  viewMgrPolicy,
  DeviceHelper,
  GlobalContext,
  ViewType,
  HiDfxEventUtil,
  EvtBus,
  sEventManager,
  EventManager,
  obtainStartAbilityWithWant,
  SCBDesktopCacheManager,
  ConfigurationEvent,
  ViewCallback,
  TrimLevel,
} from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import {
  SCBTransitionManager,
  ResUtils,
  SCBUnlockTransitionController,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import ViewModel, { VolumeAccessibilityVM } from '../viewmodel/VolumePanelVM';
import Constants, { VolumeAnimType, VolumeChannel, VolumeInfo, AnimViewData } from '../common/Constants';
import VolumeComponentStyle from '../common/VolumeComponentStyle';
import VolumeWindowController from '../common/VolumeWindowController';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { CommonData } from '@ohos/controlcentercommon/Index';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import call from '@ohos.telephony.call';
import { display, MeasureUtils } from '@kit.ArkUI';
import { BrightnessOptionUtils, ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { VolumeReportBuilder, VolumeSysEventUtil } from '../common/VolumeSysEventUtil';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { i18n } from '@kit.LocalizationKit';
import audio from '@ohos.multimedia.audio';
import { SymbolIconUtil } from '@ohos/systemuicommon';
import { VolumePanelServiceWrapper } from '../model/VolumePanelServiceWrapper';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { LayoutUtils } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { getAvgColor } from '@ohos/systemuicommon/src/main/ets/utils/ColorInvertTool';
import { effectKit } from '@kit.ArkGraphics2D';
import { ColorModeVolumeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeVolumeViewData';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { ItemUtils } from '@ohos/componenthelper';
import { accessibility } from '@kit.AccessibilityKit';
import { SystemUIView } from '@ohos/systemuicommon/src/main/ets/view/SystemUIView';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { KeyCode, inputMonitor, KeyEvent, Action } from '@kit.InputKit';
import VolumePanelService from '../model/VolumePanelService';
import type { VolumeKeyPressedListener } from '../common/Interfaces';

const TAG = 'VolumeControl-SidePanel';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const VOLUME_TEXT_ID = `${TAG}_Text_volume`;
const SETTING_BUTTON_ID = `${TAG}_Button_setting`;
const VOLUME_ACCESSIBILITY_TEXT_ID = `${TAG}_Text_accessibility`;
const UNLOCK_DELAY_TIME: number = 80;
const POPUP_DELAY_TIME: number = 1150;
const VOLUME_PANEL_OPACITY_DELAY_TIME: number = 50;
const POPUP_DEFAULT_TIME: number = Number.MAX_SAFE_INTEGER;
const TRANSITION_OPACITY: number = 0.5;
const SECOND_PANEL_SCALE: number = 0.9;
const VOLUME_TEXT_SCALE: number = 0.9;
const VOLUME_PANEL_SCALE: number = 0.9;
const PANEL_RIGHT: number = 16;
const IN_TYPE_PANEL_RIGHT: number = 4;
const OUT_TYPE_PANEL_RIGHT: number = 8;
const ANIMATION_TIME_83: number = 83;
const ANIMATION_TIME_150: number = 150;
const ANIMATION_TIME_250: number = 250;
const ANIMATION_TIME_300: number = 300;
const ANIMATION_TIME_350: number = 350;
const ANIMATION_TIME_400: number = 400;
const ANIMATION_TIME_500: number = 500;
const PANEL_OFFSET_TOP: number = 20;
// 音量条形态总热区宽度110 - 音量条宽度加边距56
const VOLUME_EXPAND_REGION: number = 54;
const MARGIN_STATUS_BAR_TOP: number = 8;
const ACCESSIBILITY_DEFAULT_PERCENT: number = 100;
const MULTI_VOLUME_SPACE: number = 8;
const EXPAND_VOLUME_DELAY: number = 17;
const VOLUME_ACTIVE_INDEX: number = 99;
// 判断当前字体放大倍数 档位限制到特大1.7倍
const MAX_PANEL_FONT_SCALE: number = 1.7;


enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}
enum DisappearType {
  /* 从音量面板状态消失 */
  DISAPPEAR_FROM_CONTROL = 0,
  /* 从细音量条状态消失 */
  DISAPPEAR_FROM_THIN = 1,
  /* 从粗音量条状态消失 */
  DISAPPEAR_FROM_THICK = 2
}
interface VolumeChannelInfo {
  channel: VolumeChannel;
  index: number;
}

@Component
export default struct VolumeSidePanelComponent {
  private volumeComponentStyle = VolumeComponentStyle.getVolumeComponentStyle();
  private mWidth: number = this.volumeComponentStyle.volumeProgressComponentWidth;
  private mWidthThin: number = this.volumeComponentStyle.volumeProgressComponentWidthThin;
  private volumeStackBorderRadius: number = this.volumeComponentStyle.volumePanelRadio;
  private volumeShadowOptions: ShadowOptions = this.volumeComponentStyle.volumeShadowOptions;
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('DarkModeModel_DarkModeStatus') @Watch('onDarkModeChanged') darkModeData: CommonData = new CommonData();
  @State @Watch('onVolumeAnimTypeChanged') volumeAnimType: number = VolumeAnimType.TYPE_OUT;
  @State colorModeVolumeViewData: ColorModeVolumeViewData = ColorModeViewModel.getInstance().getVolumeViewData();
  // 深色模式colorMode：0， 浅色模式colorMode：1
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  /**
   * 窗口宽度,单位px
   */
  @State mWindowWidth: number = 0;
  /**
   * 窗口高度,单位px
   */
  @State mWindowHeight: number = 0;
  @State isShowAboveLauncher: boolean = false;
  @State isSideVolumeTouchable: boolean = true;
  @State isDragControlStop: boolean = false;
  @State volumeStackWidth: number = this.mWidth;
  @State backgroundBlurWidth: number = this.volumeComponentStyle.volumeProgressComponentWidth;
  @State volumeStackHeight: number = this.volumeComponentStyle.volumeStackHeightInNumber;
  @State volumeStackOpacity: number = 0;
  @State volumeArrowTranslateX: number = 0;
  @State isRenderVolumeArrow: boolean = false;
  @State volumeArrowOpacity: number = 0;
  @State volumeTranslateX: number = 0;
  @State volumeScale: number = 1;
  @State volumeBarTopMargin: number = this.volumeComponentStyle.volumePanelTopMargin;
  @State volumeDialogBgColor: ResourceColor = this.volumeComponentStyle.volumeExpandBackgroundColor;
  @State volumeDialogScale: number = 1;
  @State volumeDialogTranslateX: number = 0;
  @State volumeDialogWindowOpacity: number = 0;
  @State volumeDialogMaxWidth: number = this.volumeComponentStyle.volumeDialogWidthInNumber;
  @State volumeDialogWidth: number = this.volumeComponentStyle.volumeDialogInitWidth;
  @State dialogChannelContainerHeight: number = this.volumeComponentStyle.volumeDialogInitHeight;
  @State mainVolumeBarTranslateX: number = 0;
  @State mainVolumeBarScale: number = 1;
  @State volumeStackBackHeight: number = 8;
  @State volumeStackPaddingWidth: number = 0;
  @State volumeOobeState: boolean = false;
  @State volumeIsShow: boolean = false;
  @State isAllOutFinished: boolean = false;
  @State dialogHeight: Length = this.volumeComponentStyle.volumeBarContainerHeight;
  @State panelScales: number[] = [1, SECOND_PANEL_SCALE, 0.8, 0.7, 0.6, 0.5];
  @State componentOpacities: number[] = [0, 0, 0, 0, 0, 0];
  @State panelToRights: number[] = [PANEL_RIGHT, PANEL_RIGHT, PANEL_RIGHT, PANEL_RIGHT, PANEL_RIGHT, PANEL_RIGHT];
  @State isAllControlOuting: boolean = false;
  @State volumeTextScale: number = VOLUME_TEXT_SCALE;
  @State panelTextOpacity: number = 0;
  @State volumeTextOpacity: number = 0;
  @State secondPanelOpacity: number = 0;
  @State volumePanelOpacity: number = 1;
  @State areaRectWidth:number = 0;
  @State isBlockExpandCancelTouch: boolean = false;
  @State isSysColor: boolean = true;
  @State isTouchControlling: boolean = false;
  @State volumePanelTextFontSize: number = this.volumeComponentStyle.volumePanelTextFontSize;
  @State volumeTitleFontSize: number = this.volumeComponentStyle.volumeTitleFontSize;
  @State volumeMoreSettingFontSize: number = this.volumeComponentStyle.volumeMoreSettingFontSize;
  @State volumePanelTextHeight: number = this.volumeComponentStyle.volumePanelTextHeight;
  @State volumePanelTextMinFontSize: number = this.volumeComponentStyle.volumePanelTextMinFontSize;
  @State volumePopupFontSize: number = this.volumeComponentStyle.volumePopupFontSize;
  // 换肤状态标志位
  @State isDefaultBlackBgColor: boolean = true;
  @State isDefaultWhiteBgColor: boolean = true;
  @State isDefaultTitleColor: boolean = true;
  @State isDefaultContentColor: boolean = true;
  @State isDefaultStackingBg: boolean = true;
  @State isDefaultBackgroundColor: boolean = true;
  // 当前是否是从右到左(RTL)显示
  @State isRTL: boolean = false;
  @Provide('clearStaticVolumeLottieMemory') clearStaticVolumeLottieMemory: boolean = false;
  @State animViewData: AnimViewData = new AnimViewData();
  @State volumeAccessibilityPercentValues: Map<audio.AudioVolumeType, number> = new Map();
  @State volumeAccessibilityVM: VolumeAccessibilityVM = new VolumeAccessibilityVM();
  @State volumeChannels: VolumeChannel[] = [];
  @State activeChannelTypes: audio.AudioVolumeType[] = [];
  @State @Watch('onCurrentActiveVolumeTypeChanged') currentActiveVolumeType: audio.AudioVolumeType =
    audio.AudioVolumeType.MEDIA;
  @State ringerMode: audio.AudioRingMode = audio.AudioRingMode.RINGER_MODE_NORMAL;
  @State lightY: Dimension = '0%';
  @State isShowVolumeAccessibilityText: boolean = false;
  // 状态栏高度
  private statusBarHeight: number = ViewModel.getStatusBarHeight();
  private outputDevice: audio.AudioDeviceDescriptor | undefined = undefined;
  private isConfigSmallScreen: boolean = false;
  private isConfigDialogWidth: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private stopPopup: boolean = false;
  private maxWindowColorOpacity: number = this.volumeComponentStyle.volumeWindowMaxOpacityLight;
  private ratioX: number = this.mWindowWidth;
  private lastX: number = 0;
  private lastY: number = 0;
  private downX: number = 0;
  private downY: number = 0;
  private displayState: boolean = false;
  private outTimerHandle: number = 0;
  private volumePaddingTop: number = 0;
  private volumePopupShow: number = POPUP_DEFAULT_TIME;
  private cutoutWidth: number = 0;
  private desktopCacheFlag: boolean = false;
  private volumeChannelSize: number = 0;
  private volumeDialogChannels: audio.AudioVolumeType[] = [];
  private volumeActiveChannelSize: number = 1;
  private animationInCount: number = 0;
  private animationOutCount: number = 0;
  private lastVolumeType: number = VolumeAnimType.TYPE_NONE;
  private volumePopupHasShowTimes: number = -1;
  private volumeArrowTimer: number = 0;
  private isExpandRegionTouching: boolean = false;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private nextActiveVolumeChannelType?: audio.AudioVolumeType = undefined;
  private forceVolumeKeyControlTypeTimeId?: number = undefined;
  private forceVolumeType?: audio.AudioVolumeType = undefined;
  private isVolumeBarHiding: boolean = false;
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: TAG,
    onLock: ():void => this.onTouchVolumeOutSide(true),
    onUnlock: ():void => this.onTouchVolumeOutSide(true)
  };

  private volumeLottieClearCallback: ViewCallback = {
    onTrimMemory: (level): void => {
      switch (level) {
        case TrimLevel.CRITICAL:
          this.clearStaticVolumeLottieMemory = !this.clearStaticVolumeLottieMemory;
          log.showInfo(TAG, 'volumeLottie onStaticMemory');
          break;
      }
    }
  };

  beforeVolumeWindowShow(volumeInfo: VolumeInfo): void {
    this.volumeIsShow = true;
    if (volumeInfo !== null) {
      ViewModel.refreshVolumeState(volumeInfo.volumeType, volumeInfo.volume);
    } else {
      log.showInfo(TAG, 'Update volume window info is null.');
      ViewModel.startRefreshVolumeActiveState(true);
    }
    this.refreshVolumeInfoWhenValueIsNegative();
  }

  /**
   * 仅音量为-1时才刷新
   */
  refreshVolumeInfoWhenValueIsNegative(): void {
    // 获取媒体除外的其他声道类型
    const channels = this.volumeChannels.filter(o => o.volumeType !== audio.AudioVolumeType.MEDIA);
    const volumeTypes: audio.AudioVolumeType[] = channels.map(o => o.volumeType);
    const allAudioInfo = ViewModel.getAllAudioVolumeInfo();
    volumeTypes?.map(volumeChannelType => {
      // 获取声道音量值
      const volume = allAudioInfo?.get(volumeChannelType)?.volume;
      // 值为-1则刷新
      if (volume === Constants.DEFAULT_VOLUME_INVALID) {
        log.showInfo(TAG, `refresh volume by channelType:${volumeChannelType} volume:${volume}`);
        ViewModel.updateRelativeProgress(this.volumeChannels.findIndex(volumeChannel => volumeChannel.volumeType ===
          volumeChannelType));
      }
    });
  }

  onOoberStateChanged(oobeState: boolean): void {
    this.volumeOobeState = oobeState;
  }

  private showVolumeBar(curVolumeInfo?: VolumeInfo): void {
    this.currentActiveVolumeType = curVolumeInfo?.volumeType ?? audio.AudioVolumeType.MEDIA;
    this.activeChannelTypes = ViewModel.getSidebarActiveChannelTypes(this.animViewData?.useSliderIcon);
    this.volumeActiveChannelSize = this.activeChannelTypes.length;
    this.onVolumeAnimTypeNone();
    if (this.volumeActiveChannelSize > 1) {
      this.volumeChannels.sort((a, b) => Constants.VOLUME_TYPE_WEIGHTS.findIndex(volumeType => volumeType ===
      b.volumeType) - Constants.VOLUME_TYPE_WEIGHTS.findIndex(volumeType => volumeType === a.volumeType));
      this.updateVolumeBarSceneRegion(this.volumeActiveChannelSize);
      this.setOriginalRight();
      // 多音量条场景下一帧开始执行动效，避免初始位移值被上次的位移值影响panelToRights不正确
      animateToImmediately({
        tempo: 0
      }, () => {
        this.volumeAnimType = VolumeAnimType.TYPE_IN;
      })
    } else {
      this.volumeAnimType = VolumeAnimType.TYPE_IN;
    }
    this.forceVolumeKeyControlType(this.currentActiveVolumeType);
  }

  onVolumeWindowStateChanged(isShow: boolean, curVolumeInfo?: VolumeInfo): void {
    if (isShow && this.isVolumeBarHiding) {
      log.showInfo(TAG, 'hiding, not show');
      return;
    }
    this.cancelDismissTimer();
    this.isSideVolumeTouchable = true;
    this.onDarkModeChanged();
    if (isShow) {
      this.stopPopup = false;
      ViewModel.registerVolumeKeyPressedListener(this);
      performanceMonitor.begin('VOLUME_BAR_SHOW', performanceMonitor.ActionType.LAST_DOWN, 'NO_USER');
      VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_PANEL_TRIGGER,
        VolumeReportBuilder.builder().isLocked(ScreenLockApi.getLock()).build());
      // 解决屏幕旋转后，避免volumeBarTopMargin与volumeTranslateX在一个动效，volumeTranslateX在下一帧执行
      this.setDesktopCache(true);
      if (this.displayState) {
        setTimeout(() => {
          this.showVolumeBar(curVolumeInfo);
          this.displayState = false;
        }, 0)
      } else {
        this.showVolumeBar(curVolumeInfo);
      }
      this.registerInputMonitor();
    } else {
      ViewModel.unRegisterVolumeKeyPressedListener(this);
      ViewModel.stopRefreshVolumeActiveState();
      this.forceVolumeKeyControlType(-1, true);
      this.unregisterInputMonitor();
      if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START) {
        this.volumeAnimType = VolumeAnimType.TYPE_THICK_DOWN_STOP;
      }
      if (this.volumeAnimType === VolumeAnimType.TYPE_NONE ||
      this.volumeAnimType === VolumeAnimType.TYPE_OUT) {
        this.volumeAnimType = VolumeAnimType.TYPE_NONE;
        return;
      }
      if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
        return;
      }
      this.setVolumeArrowAnimation(false);
      if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN) {
        this.volumeAnimType = VolumeAnimType.TYPE_ALL_CONTROL_OUT;
      } else {
        this.volumeAnimType = VolumeAnimType.TYPE_OUT;
      }
    }
  }

  /**
   * 音量面板窗口尺寸变化回调
   * @param width 屏幕宽度 px
   * @param height 屏幕高度 px
   * @param cutoutWidth vp
   */
  onVolumeWindowSizeChanged(width: number, height: number, cutoutWidth: number): void {
    this.handleAverageColor();
    this.mWindowWidth = width;
    this.mWindowHeight = height;
    this.cutoutWidth = ArkUIAdapter.px2vp(this.mWindowWidth) - cutoutWidth;
    this.adjustVolumePosition();
    this.updateVolumeBarSceneRegion();
  }

  private updateVolumeBarSceneRegion(channelSize: number = 1): void {
    let rspHeight = ArkUIAdapter.vp2px(this.volumeComponentStyle.volumeBarContainerHeight);
    // 触摸扩大热区
    const volumeExpandRegion = VOLUME_EXPAND_REGION;
    let rspWidth =
      ArkUIAdapter.vp2px(this.volumeComponentStyle.volumeBarInitTranslationX * channelSize +
      this.cutoutWidth + volumeExpandRegion);
    let left = this.mWindowWidth - rspWidth;
    log.showInfo(TAG, `volume expand response region ${rspWidth}`);
    const volumeSettingHeight = this.isExpandVolumePanel() ? this.volumeComponentStyle.volumeSettingHeightExpand :
    this.volumeComponentStyle.volumeSettingHeight;
    let top = ArkUIAdapter.vp2px(this.volumeBarTopMargin + volumeSettingHeight);
    VolumeWindowController.getInstance().updateVolumeResponseReginWithUiContext(left, top, rspWidth, rspHeight);
  }

  private handleAverageColor(): void {
    if (!this.colorModeViewData.isSolidEnable()) {
      return;
    }
    let mainSession = SCBScreenSessionManager.getInstance()?.getMainScreenSession()
    if (!mainSession) {
      log.showInfo(TAG, `MainScreenSession does not exist`)
      return;
    }
    getAvgColor(mainSession?.session?.screenId, 0.5).then((averageColor: effectKit.Color | undefined) => {
      log.info(TAG, 'Get Average Color');
      if (averageColor && (averageColor.red !== this.colorModeVolumeViewData.volumePickColor.red ||
        averageColor.green !== this.colorModeVolumeViewData.volumePickColor.green ||
        averageColor.blue !== this.colorModeVolumeViewData.volumePickColor.blue)) {
        this.colorModeVolumeViewData.volumePickColor = averageColor;
        this.volumeDialogBgColor =
          this.colorModeViewData.calcSecondarySolidColor(this.volumeComponentStyle.volumeExpandBackgroundColor,
            this.getBrightnessVolumeBackground(), this.colorModeVolumeViewData.volumePickColor)

        this.colorModeVolumeViewData.volumeBgPickColor =
          this.colorModeViewData.convertResourceColorToEffectColor(this.volumeDialogBgColor);
      }
    })
      .catch((error: Error) => {
        log.error(TAG, 'Get AvgColor failed:', error.message);
      });
  }

  onKeyPressed(currentVolume: VolumeInfo) {
    if (currentVolume) {
      this.reportVolumeKeyPressed(currentVolume);
    }
  }

  onVolumeKeyPressed(isKeyUp: boolean, currentVolumeType: audio.AudioVolumeType): void {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
    this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT ||
    this.volumeAnimType === VolumeAnimType.TYPE_OUT ||
    this.volumeAnimType === VolumeAnimType.TYPE_NONE ||
    this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK ||
    this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START) {
      return;
    }
    if (this.isTouchControlling) {
      return;
    }
    if (!this.activeChannelTypes.includes(currentVolumeType) &&
      this.activeChannelTypes.length < (this.isAccessibilityMode ? 3 : 2)) {
      this.currentActiveVolumeType = currentVolumeType;
      this.activeChannelTypes.push(currentVolumeType);
      this.volumeActiveChannelSize = this.activeChannelTypes.length;
      if (this.volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN ||
        this.volumeAnimType === VolumeAnimType.TYPE_KEY_DOWN_THIN ||
        this.volumeAnimType === VolumeAnimType.TYPE_THICK_TO_THIN) {
        this.volumeAnimType = VolumeAnimType.TYPE_THIN_TO_THICK;
        this.volumeAnimType = VolumeAnimType.TYPE_THIN_TO_THICK_STOP;
      }
      animateTo({
        curve: this.volumeComponentStyle.springMotionDefault,
        playMode: PlayMode.Normal,
        iterations: 1,
      }, () => {
        this.setVolumePanel();
        this.volumeDialogWidth = this.volumeComponentStyle.volumeDialogInitWidth +
          (this.volumeActiveChannelSize - 1) * this.volumeComponentStyle.volumeBarInitTranslationX;
      })
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_TO_THIN ||
    this.volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN ||
    this.volumeAnimType === VolumeAnimType.TYPE_KEY_DOWN_THIN) {
      if (isKeyUp) {
        this.volumeAnimType = VolumeAnimType.TYPE_KEY_UP_THIN;
      } else {
        this.volumeAnimType = VolumeAnimType.TYPE_KEY_DOWN_THIN;
      }
      return;
    }
    if (!this.isAccessibilityMode) {
      this.volumeAnimType = VolumeAnimType.TYPE_THICK_TO_THIN;
    }
  }

  /**
   * 音量条打点 按键控制
   * @param currentVolume
   */
  reportVolumeKeyPressed(currentVolume: VolumeInfo) {
    VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_ADJUSTED,
      VolumeReportBuilder.builder()
        .channel(currentVolume.volumeType)
        .isLocked(ScreenLockApi.getLock())
        .uiType(this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ? 1 : 0)
        .volume(currentVolume.volume)
        .adjustedType(0)
        .build())
  }

  onVolumeDisplayChanged(displayState: boolean): void {
    this.displayState = displayState;
  }

  onDeviceConfigChanged(isConfigurable: boolean, isConfigDialogWidth: boolean): void {
    log.showInfo(TAG, `volume deviceConfigChange ${isConfigurable} ${isConfigDialogWidth}`);
    this.isConfigSmallScreen = isConfigurable;
    this.isConfigDialogWidth = isConfigDialogWidth;
  }

  onDarkModeChanged(): void {
    if (this.darkModeData?.status) {
      // 深色模式与浅色模式窗口透明度不同
      this.maxWindowColorOpacity = this.volumeComponentStyle.volumeWindowMaxOpacityDark;
    } else {
      this.maxWindowColorOpacity = this.volumeComponentStyle.volumeWindowMaxOpacityLight;
    }
  }

  aboutToAppear() {
    let isMobileDataAvailable = call.hasVoiceCapability();
    log.showInfo(TAG, `aboutToAppear ${isMobileDataAvailable}`);
    this.volumeChannels = ViewModel.getAllSupportedVolumeChannels();
    this.volumeChannelSize = this.volumeChannels.length;
    this.volumeDialogChannels = Constants.PANEL_CHANNELS.slice();
    if (!isMobileDataAvailable) {
      const callIndex =
        this.volumeDialogChannels.findIndex(volumeType => volumeType === audio.AudioVolumeType.VOICE_CALL);
      if (callIndex !== -1) {
        this.volumeDialogChannels.splice(callIndex, 1);
      }
    }
    this.setOriginalRight();
    this.setOriginalOpacity();
    this.setOriginalScale();
    ViewModel.initViewModel();
    ViewModel.registerWindowStateListener(this);
    ViewModel.registerKeyPressedListener(this);
    ViewModel.registerOutputDeviceChangeListener(this);
    this.avoidCutOutArea();
    this.volumePaddingTop = ViewModel.getVolumeTopPadding();
    this.volumePopupShow = ViewModel.checkVolumePopup();
    this.volumeBarTopMargin = this.volumePaddingTop - this.volumeComponentStyle.volumeSettingHeight;
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    this.eventMgr.on(ConfigurationEvent, this.onConfigurationEvent);
    viewMgrPolicy.registerViewCallback(ViewType.VOLUME, this.volumeLottieClearCallback);
  }

  /**
   * 更新设备信息
   */
  updateOutputDevice(outputDevice: audio.AudioDeviceDescriptor | undefined): void {
    this.outputDevice = outputDevice;
    const deviceIcon: string =
      outputDevice ? ViewModel.getOutputDeviceIcon(outputDevice.address, outputDevice.deviceType) : '';
    if (deviceIcon) {
      this.animViewData.useSliderIcon = true;
      this.animViewData.sliderIcon = $r(deviceIcon);
    } else {
      this.animViewData.useSliderIcon = false;
      this.animViewData.sliderIcon = undefined;
    }
    log.showInfo(TAG, `updateOutputDevice name: ${outputDevice?.name}, deviceType: ${outputDevice?.deviceType}, deviceIcon: ${deviceIcon}, useSliderIcon: ${this.animViewData.useSliderIcon}`);
  }

  private async isThemeChangeColor(color: Resource, baseColor: string): Promise<boolean> {
    try {
      const resourceColorPromise: Promise<number> = getContext(this)
        .resourceManager
        .getColor(color.id);
      const resourceColor = await resourceColorPromise;
      log.showInfo(TAG, `resourceColor ${resourceColor} baseColor ${baseColor} colorId ${color.id}`);
      return resourceColor.toString() === Number.parseInt(baseColor, 16).toString();
    } catch (e) {
      log.error(TAG, 'get resource color failed', e);
      return true;
    }
  }

  private onConfigurationEvent = (event: ConfigurationEvent): void => {
    // 判断当前是LTR 还是 RTL 来判断是否翻转canvas canvas不支持自动镜像
    const systemLanguage = i18n.System.getSystemLanguage();
    this.isRTL = i18n.isRTL(systemLanguage);

    let fontSizeScaleLimit = event?.config?.fontSizeScale ?? 1;
    fontSizeScaleLimit = fontSizeScaleLimit > MAX_PANEL_FONT_SCALE ? MAX_PANEL_FONT_SCALE : fontSizeScaleLimit;
    log.showInfo(TAG, `change fontSizeScaleLimit ${fontSizeScaleLimit}`);
    this.volumeTitleFontSize = this.volumeComponentStyle.volumeTitleFontSize * fontSizeScaleLimit;
    this.volumeMoreSettingFontSize = this.volumeComponentStyle.volumeMoreSettingFontSize * fontSizeScaleLimit;
    this.volumePanelTextHeight = this.volumeComponentStyle.volumePanelTextHeight;
    this.volumePopupFontSize = this.volumeComponentStyle.volumePopupFontSize * fontSizeScaleLimit;
    log.showInfo(TAG, `fontSizeScale ${this.volumeMoreSettingFontSize} ${this.volumeTitleFontSize} ${this.volumePopupFontSize}`);
    this.setRealFontsize(fontSizeScaleLimit);

    setTimeout(() => {
      log.showInfo(TAG, 'volume theme change');
      this.onThemeChangeEvent();
    }, 100);
  }

  private setRealFontsize(fontSizeScaleLimit: number): void {
    this.volumePanelTextFontSize = Math.floor(this.volumeComponentStyle.volumePanelTextFontSize * fontSizeScaleLimit);
    this.volumePanelTextMinFontSize = this.volumeComponentStyle.volumePanelTextMinFontSize;
    const measureUtils: MeasureUtils = ArkUIAdapter.getMeasureUtils(this.getUIContext());
    const maxLenChannel = this.volumeChannels.filter(channel => this.volumeDialogChannels.includes(channel.volumeType))
      .reduce((max, current) => {
        const currentString = ResUtils.getInnerString(current.channelName);
        const maxString = ResUtils.getInnerString(max.channelName);
        return currentString.length > maxString.length ? current : max;
      });
    const maxLenChannelName = ResUtils.getInnerString(maxLenChannel.channelName);
    for (let fontsize = this.volumePanelTextFontSize; fontsize > 0; fontsize--) {
      const size = measureUtils.measureTextSize({
        textContent: maxLenChannelName,
        fontSize: `${fontsize}vp`,
        constraintWidth: this.getChannelNameWidth(),
        wordBreak: WordBreak.HYPHENATION,
        fontWeight: FontWeight.Regular,
        textAlign: TextAlign.Center,
      });
      if (size.height && size.height <= ArkUIAdapter.vp2px(this.volumePanelTextHeight * MAX_PANEL_FONT_SCALE)) {
        const calcTextHeight = ArkUIAdapter.px2vp(size.height);
        log.showInfo(TAG, `calc text height ${calcTextHeight}`);
        this.volumePanelTextFontSize = fontsize;
        this.volumePanelTextMinFontSize = fontsize;
        this.volumePanelTextHeight =
          this.volumePanelTextHeight < calcTextHeight ? calcTextHeight : this.volumePanelTextHeight;
        break;
      }
    }
    log.showInfo(TAG, `real fontSize ${this.volumePanelTextFontSize} height ${this.volumePanelTextHeight}`);
  }

  /**
   * 音量条: 主题切换
   * 根据面板标题、描述文字、音量条黑色部分、音量条白色部分的资源颜色是否更换, 判断需不需要支持提亮功能
   * 注意:提亮与换肤不能并存
   */
  private onThemeChangeEvent = async (): Promise<void> => {
    // 标题
    this.isDefaultTitleColor =
      await this.isThemeChangeColor(this.volumeComponentStyle.volumeTitleFontColor,
        this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
        this.volumeComponentStyle.volumeFontColorDark : this.volumeComponentStyle.volumeFontColorBase);
    // 描述文字
    this.isDefaultContentColor =
      await this.isThemeChangeColor(this.volumeComponentStyle.volumeContentFontColor,
        this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
        this.volumeComponentStyle.volumeFontColorDark : this.volumeComponentStyle.volumeFontColorBase);
    // 音量柱黑色部分
    this.isDefaultBlackBgColor =
      await this.isThemeChangeColor(this.getVolumeBrightnessVolumeBlackBg(),
        this.volumeComponentStyle.backgroundBrightnessVolumeBlackBg);
    // 音量柱白色部分
    this.isDefaultWhiteBgColor =
      await this.isThemeChangeColor(this.getVolumeBrightnessVolumeWhiteBg(),
        this.volumeComponentStyle.backgroundBrightnessVolumeWhiteBg);
    // 音量面板的整个面板背景
    this.isDefaultBackgroundColor =
      await this.isThemeChangeColor(this.volumeComponentStyle.volumeExpandBackgroundColor,
        this.volumeComponentStyle.volumeBackgroundBaseColor
      );
  }

  private getVolumeBrightnessVolumeBlackBg(): Resource {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return this.volumeComponentStyle.volumePanelDialogProgressColor;
    } else {
      return this.volumeComponentStyle.volumeExpandDialogProgressColor;
    }
  }

  private getVolumeBrightnessVolumeWhiteBg(): Resource {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return this.volumeComponentStyle.volumeExpandProgressColor;
    } else {
      return this.volumeComponentStyle.volumePanelProgressColor;
    }
  }

  brightnessTitle(): BrightnessOptions | undefined {
    log.showInfo(TAG, `volume title brightness: ${this.isDefaultTitleColor}`);
    if (!this.isDefaultTitleColor) {
      return undefined;
    }
    return this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
    BrightnessOptionUtils.foregroundPrimaryOptionDarkVolume : BrightnessOptionUtils.foregroundPrimaryOptionLightVolume;
  }

  brightnessContent(): BrightnessOptions | undefined {
    log.showDebug(TAG, `volume content brightness: ${this.isDefaultContentColor}`);
    if (!this.isDefaultContentColor) {
      return undefined;
    }
    return this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
    BrightnessOptionUtils.foregroundSecondaryDarkOptionVolume : BrightnessOptionUtils.foregroundSecondaryOptionVolume
  }

  private setOriginalRight(isExpand: boolean = false): void {
    for (let index = 0; index < this.volumeChannelSize; index++) {
      const i = this.activeChannelTypes.findIndex(item => item === this.volumeChannels[index].volumeType);
      const space = (i - this.volumeActiveChannelSize) *
        (MULTI_VOLUME_SPACE + this.volumeComponentStyle.volumeProgressComponentWidth) + MULTI_VOLUME_SPACE;
      this.panelToRights[index] = isExpand ? PANEL_RIGHT : space;
    }
  }

  avoidCutOutArea() {
    try {
      display.getDefaultDisplaySync().getCutoutInfo().then((data) => {
        if (data) {
          this.areaRectWidth = ArkUIAdapter.px2vp(data?.waterfallDisplayAreaRects.right.width);
        }
        log.showInfo(TAG, `areaRectWidth = ${this.areaRectWidth}`);
      });
    } catch (e) {
      log.showError(TAG, 'getCutoutInfo failed');
    }
  }

  private setOriginalOpacity(): void {
    for (let index = 0; index < this.volumeChannelSize; index++) {
      this.componentOpacities[index] = 0;
    }
  }

  private setOriginalScale(isExpand: boolean = false): void {
    for (let index = 0; index < this.volumeChannelSize; index++) {
      this.panelScales[index] = isExpand ? (1 - 0.1 * index) : 0.7;
    }
  }

  aboutToDisappear() {
    ViewModel.unRegisterWindowStateListener(this);
    ViewModel.unRegisterKeyPressedListener(this);
    ViewModel.unRegisterOutputDeviceChangeListener(this);
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockTransitionController, false);
    viewMgrPolicy.unRegisterViewCallback(ViewType.VOLUME, this.volumeLottieClearCallback);
    this.eventMgr?.offAll();
  }

  /**
   * 点击音量面板之外关闭音量面板
   * @param isScreenLockEvent: boolean
   */
  public onTouchVolumeOutSide(isScreenLockEvent?: boolean): void {
    // 手指一直在屏幕上时，不响应touch事件, 锁屏时继续执行消失事件
    if ((this.isTouchControlling || this.isExpandRegionTouching) && !isScreenLockEvent) {
      return;
    }
    // 多次点击，避免打断退出动画
    if (this.volumeAnimType === VolumeAnimType.TYPE_NONE ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return;
    }
    if (this.volumeAnimType != VolumeAnimType.TYPE_ALL_CONTROL_IN) {
      // 单音量条按住滑动的时候需先执行滑动结束再消失，否则会导致音量条直接消失还是变粗的状态;
      if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START) {
        this.onVolumeAnimTypeThickDownStop(true);
      } else {
        this.volumeAnimType = VolumeAnimType.TYPE_OUT;
      }
      return;
    }
    this.volumeAnimType = VolumeAnimType.TYPE_ALL_CONTROL_OUT;
    VolumeWindowController.getInstance().clearWindowTimer();
  }

  private getStackHeight(): number {
    if (this.isExpandVolumePanel()) {
      return this.volumeComponentStyle.volumeBarContainerHeight + this.volumeComponentStyle.volumePanelTextMargin +
      this.volumePanelTextHeight;
    }

    return this.volumeComponentStyle.volumeBarContainerHeight;
  }

  build() {
    // 全屏点击事件，点击音量面板外部触发音量面板隐藏
    Stack({ alignContent: Alignment.TopEnd }) {
      if (SystemUICcmConfig.instance.isEnabledWorker) {
        SystemUIView()
      }
      this.buildVolumeContent();
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.getVolumeDialogWindowColor())
    .onTouch((event) => {
      if (this.isVolumePanelUntouchable()) {
        log.showInfo(TAG, 'dissmissing expand region untouchable');
        return;
      }
      this.setVolumeArrowAnimation(false);
      this.processUserInteraction(event);
      this.onVolumePanelTouched(event, true);
    })
    .direction(Direction.Ltr)
  }

  @Builder
  buildVolumeContent() {
    EffectComponent() {
      Stack({ alignContent: Alignment.End }) {
        // 左滑弹出的音量条面板
        this.volumeControlDialog()
        if (this.isShowVolumeAccessibilityText) {
          this.volumeAccessibilityText()
        }
      }
      .height(this.volumeComponentStyle.volumeDialogHeightInNumber)
      .translate(this.getVolumeTranslate())
      .scale(this.getVolumeScale())
      .animation(this.getVolumeAnimateParam())
      .alignSelf(ItemAlign.End)
      .margin({ top: this.volumeBarTopMargin, right: this.areaRectWidth })
    }
    .align(Alignment.End)
    .width(this.getEffectComponentWidth())
    .translate({ x: this.volumeDialogTranslateX })
    .backgroundEffect((this.volumeAnimType !== VolumeAnimType.TYPE_ALL_CONTROL_IN &&
      this.volumeAnimType !== VolumeAnimType.TYPE_ALL_CONTROL_OUT) ? {
      policy: 1,
      radius: 200,
      saturation: 1.2
    } : undefined)
    .opacity(this.volumePanelOpacity)
  }

  /**
   * 音量面板标题
   */
  @Builder
  volumeTitle() {
    Text($r('app.string.volume'))
      .draggable(false)
      .id(VOLUME_TEXT_ID)
      .fontSize(`${this.volumeTitleFontSize}vp`)
      .fontColor(this.colorModeViewData.calcSecondarySolidColor(this.volumeComponentStyle.volumeTitleFontColor,
        this.brightnessTitle(), this.colorModeVolumeViewData.volumeBgPickColor))
      .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined : this.brightnessTitle())
      .maxLines(1)
      .opacity(this.volumeTextOpacity)
      .scale({ x: this.volumeTextScale, y: this.volumeTextScale })
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Medium)
      .height(this.volumeComponentStyle.volumeTitleHeight)
      .width('100%')
      .margin({
        top: this.volumeComponentStyle.volumeTitleMarginTop
      })
      // 通过设置左右内边距来实现侧边音量条时显示标题实际宽度为0
      .padding({
        left: this.volumeComponentStyle.volumeDialogInitWidth / 2,
        right: this.volumeComponentStyle.volumeDialogInitWidth / 2
      })
      .onAccessibilityFocus((isFocus: boolean) => {
        VolumeWindowController.getInstance()
          .handleAccessibilityAutoDismissTimer(isFocus, this.volumeAnimType);
      })
      .accessibilityFocusDrawLevel(1)
      .accessibilityNextFocusId(`${TAG}_Row_0`)
  }

  /**
   * 音量面板无障碍默认聚焦空组件
   */
  @Builder
  volumeAccessibilityText() {
    Text(' ')
      .id(VOLUME_ACCESSIBILITY_TEXT_ID)
      .opacity(0)
      .position({ x: 0, y: 0 })
      .onAccessibilityFocus((isFocus: boolean) => {
        log.showInfo(TAG, `volume panel empty component isFocus: ${isFocus}`);
        this.isShowVolumeAccessibilityText = false;
      })
  }

  /**
   * 音量面板“更多设置”按钮
   */
  @Builder
  displayMoreSetting() {
    Button($r('app.string.volume_channel_more_setting'), { type: ButtonType.Capsule, stateEffect: true })
      .id(SETTING_BUTTON_ID)
      .buttonStyle(ButtonStyleMode.TEXTUAL)
      .visibility(this.volumeOobeState ? Visibility.Hidden : Visibility.Visible)
      .fontColor($r('app.color.volume_popup_more_button_color'))
      .fontSize(`${this.volumeMoreSettingFontSize}vp`)
      .fontWeight(FontWeight.Medium)
      .opacity(this.volumeTextOpacity)
      .onClick(this.onVolumeSettingClicked)
      .width(this.volumeDialogWidth - this.volumeComponentStyle.volumeMoreSettingTextBottomMargin * 2)
      .margin({
        bottom: this.volumeComponentStyle.volumeMoreSettingTextBottomMargin,
      })
      .enabled(this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN)
      .clip(false)
      .onAccessibilityFocus((isFocus: boolean) => {
        VolumeWindowController.getInstance()
          .handleAccessibilityAutoDismissTimer(isFocus, this.volumeAnimType);
      })
      .accessibilityNextFocusId(SETTING_BUTTON_ID)
  }

  @Builder
  volumeControlDialog() {
    // 弹框面板背景，在侧边只展示一个音量条时隐藏
    Column() {
      this.volumeTitle();
      this.displayMoreSetting();
    }
    .backgroundColor(this.volumeDialogBgColor)
    .backgroundBrightnessInternal(this.colorModeViewData.isSolidEnable() ? undefined :
    this.getBrightnessVolumeBackground())
    .width(this.volumeDialogWidth)
    .height(this.volumeStackHeight)
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(this.volumeStackBorderRadius)
    .clip(true)
    .visibility(this.isExpandVolumePanel() ? Visibility.Visible : Visibility.None)
    .opacity(this.volumeStackOpacity)
    .backgroundEffect({
      policy: 1,
      radius: 80,
    })
    .shadow(this.volumeShadowOptions)
    .id(`${TAG}_Column_volumeDialog`)
    .onTouch((event) => {
      // 展开时延长面板展示时间
      if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN) {
        this.processUserInteraction(event);
      }
      event?.stopPropagation();
    })

    /*使用Stack按顺序一字排开，实现展开堆叠层次效果*/
    this.displayVolumeChannels();
  }

  /**
   * 音量条下的文本
   * @param channel 音量条信息
   */
  @Builder
  volumeChannelText(channel: VolumeChannel) {
    Stack({ alignContent: Alignment.Top }) {
      Text(channel.channelName)
        .draggable(false)
        .id(`${TAG}_Text_${channel.channelId}`)
        .fontSize(`${this.volumePanelTextFontSize}vp`)
        .maxFontSize(`${this.volumePanelTextFontSize}vp`)
        .minFontSize(`${this.volumePanelTextMinFontSize}vp`)
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.Center)
        .scale({ x: this.volumeTextScale, y: this.volumeTextScale })
        .opacity(this.panelTextOpacity)
        .fontColor(this.colorModeViewData.calcSecondarySolidColor(this.volumeComponentStyle.volumeContentFontColor,
          this.brightnessContent(), this.colorModeVolumeViewData.volumeBgPickColor))
        .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined : this.brightnessContent())
        .enabled(false)
        .accessibilityLevel('no')
        .wordBreak(WordBreak.HYPHENATION)
        .width('100%')
    }
    .width(this.getChannelNameWidth())
    .height(this.getVolumeTextHeight())
    .alignRules({
      top: { anchor: `${TAG}_VolumeBarComponent_${channel.channelId}`, align: VerticalAlign.Bottom },
      middle: { anchor: `${TAG}_VolumeBarComponent_${channel.channelId}`, align: HorizontalAlign.Center },
    })
    .padding({ top: this.volumeComponentStyle.volumePanelTextMargin })
    .visibility(this.isExpandVolumePanel() ? Visibility.Visible : Visibility.None)
    .enabled(false)
  }

  @Builder
  buildVolumeChannel($$: VolumeChannelInfo) {
    RelativeContainer() {
      this.VolumeComponent($$);
      if (this.volumeDialogChannels.includes($$.channel.volumeType)) {
        this.volumeChannelText($$.channel)
      }
    }
    .margin({ right: ($$.index === undefined) ? PANEL_RIGHT : this.panelToRights[$$.index] })
    .scale({
      x: ($$.index === undefined) ? 1 : this.panelScales[$$.index],
      y: ($$.index === undefined) ? 1 : this.panelScales[$$.index],
    })
    .animation(this.getMultiVolumeAnimation($$.channel.volumeType))
    .zIndex(this.getVolumeChannelZIndex($$))
    .width(this.volumeComponentStyle.volumeProgressComponentWidth)
    .height('100%')
    .hitTestBehavior(HitTestMode.None)
    .id(`${TAG}_Row_${$$.index}`)
    .onAccessibilityFocus((isFocus: boolean) => {
      this.volumeAccessibilityVM.isContainerFocus = isFocus;
      VolumeWindowController.getInstance()
        .handleAccessibilityAutoDismissTimer(isFocus, this.volumeAnimType);
      if (isFocus) {
        this.nextActiveVolumeChannelType = $$.channel.volumeType;
        this.activeVolumeChannelTypeChange(true);
        this.forceVolumeKeyControlType($$.channel.volumeType);
      }
    })
    .accessibilityDescription(this.getVolumeBarAccessibilityDescription($$))
    .accessibilityLevel('yes')
    .accessibilityNextFocusId(this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN &&
      $$.channel.volumeType === audio.AudioVolumeType.VOICE_CALL ? SETTING_BUTTON_ID : undefined)

  }

  @Builder
  displayVolumeChannels() {
    /*使用Stack按顺序一字排开，实现展开堆叠层次效果*/
    Stack({ alignContent: Alignment.End }) {
      ForEach(this.volumeChannels, (channel: VolumeChannel, index?: number) => {
        if (!this.isExpandVolumePanel() || this.volumeDialogChannels.includes(channel.volumeType)) {
          this.buildVolumeChannel({
            channel,
            index: this.volumeChannels.findIndex(item => item.channelId === channel.channelId)
          })
        }
      }, (channel: VolumeChannel, index?: number) => {
        return channel.channelId;
      })

      if (this.isRenderVolumeArrow) {
        Image($r('app.media.handle'))
          .width(this.volumeComponentStyle.volumeArrowWidth)
          .opacity(this.volumeArrowOpacity)
          .height(this.volumeComponentStyle.volumeArrowHeight)
          .margin({
            right: this.volumeComponentStyle.volumeArrowMargin +
              (this.volumeActiveChannelSize - 1) * (MULTI_VOLUME_SPACE +
            this.volumeComponentStyle.volumeProgressComponentWidth)
          })
          .translate({ x: this.volumeArrowTranslateX })
          .fillColor(this.colorModeViewData.calcSecondarySolidColor(
            this.volumeComponentStyle.volumeBackgroundAboveLauncher,
            BrightnessOptionUtils.brightnessVolumeStackingBg, this.colorModeVolumeViewData.volumePickColor))
          .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined :
            BrightnessOptionUtils.brightnessVolumeStackingBg)
      }

    }
    .width(this.volumeDialogWidth)
    .height(this.getStackHeight())
    .hitTestBehavior(HitTestMode.None)
    .direction(Direction.Ltr)
    .id(`${TAG}_VolumeChannel_Container`)
  }

  @Builder
  private VolumeComponent($$: VolumeChannelInfo) {
    RelativeContainer() {
      VolumeProgressComponent({
        volumeIndex: $$.index,
        isShowAboveLauncher: $isShowAboveLauncher,
        isSideVolumeTouchable: $isSideVolumeTouchable,
        isBlockExpandCancelTouch: $isBlockExpandCancelTouch,
        volumeAnimType: $volumeAnimType,
        darkModeData: $darkModeData,
        isDragControlStop: $isDragControlStop,
        volumeChannelType: $$.channel.volumeType,
        volumeChannelName: $$.channel.channelName,
        volumeAccessibilityPercentValues: $volumeAccessibilityPercentValues,
        volumeAccessibilityVM: $volumeAccessibilityVM,
        isTouchControlling: $isTouchControlling,
        currColorMode: $currColorMode,
        currentActiveVolumeType: $currentActiveVolumeType,
        lightY: $lightY,
        activeChannelTypes: this.activeChannelTypes,
        ringerMode: this.ringerMode,
        onVolumeTouchedCallback: (event?: TouchEvent) => {
          if (!this.isExpandVolumePanel()) {
            this.setVolumeArrowAnimation(false);
            this.onVolumePanelTouched(event);
          }
        },
        onTouchDownChangedCallback: (windowX: number, windowY: number) => {
          if (!this.isExpandVolumePanel()) {
            this.touchDownChangedCallback(windowX, windowY);
          }
        },
        callback: (volumeType: audio.AudioVolumeType, value: number) => {
          // channel中的type不准确，使用回传的实时type
          ViewModel.setVolumeByType(volumeType, value);
        },
        isDefaultBlackBgColor: this.isDefaultBlackBgColor,
        isDefaultWhiteBgColor: this.isDefaultWhiteBgColor,
        isRTL: this.isRTL,
        onExpandVolumeDialog: () => {
          this.expandVolumeDialog();
        },
        isConfigSmallScreen: this.isConfigSmallScreen,
        animViewData: this.animViewData,
        isExpandVolumePanel: this.isExpandVolumePanel(),
        onActiveVolumeChannelTypeChange: (volumeChannelType: audio.AudioVolumeType, isMove?: boolean) => {
          this.nextActiveVolumeChannelType = volumeChannelType;
          if (isMove && volumeChannelType !== this.currentActiveVolumeType) {
            this.activeVolumeChannelTypeChange(true);
          }
        },
      })
    }
    .translate({ x: this.mainVolumeBarTranslateX })
    .scale(this.getActiveBarScale($$.channel.volumeType))
    .id(`${TAG}_VolumeBarComponent_${$$.channel.channelId}`)
    .height(this.volumeComponentStyle.volumeProgressComponentHeight)
    .alignRules({ top: { anchor: '__container__', align: VerticalAlign.Top } })
    .direction(Direction.Ltr)
    .opacity(this.isExpandVolumePanel() ? this.componentOpacities[$$.index] : 1)
  }

  private getVolumeTextHeight(): number {
    const volumeTextHeight = this.volumePanelTextHeight + this.volumeComponentStyle.volumePanelTextMargin;
    return this.isExpandVolumePanel() ? volumeTextHeight : 0;
  }

  private getEffectComponentWidth(): number | undefined {
    if (this.volumeAnimType !== VolumeAnimType.TYPE_ALL_CONTROL_IN) {
      const effectWidth = this.volumeDialogWidth + Math.abs(this.volumeDialogTranslateX);
      return effectWidth + (this.volumeActiveChannelSize === 1 ? Math.abs(this.volumeTranslateX) :
      Math.abs(this.cutoutWidth));
    }
    return undefined;
  }

  /**
   * 音量面板背景色提亮
   */
  private getBrightnessVolumeBackground(): BrightnessOptions | undefined {
    if (!this.isDefaultBackgroundColor) {
      return undefined;
    }
    return this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
    BrightnessOptionUtils.backgroundFourOptionDark : BrightnessOptionUtils.backgroundFourOption;
  }

  private countVolumeArrowTimes(): void {
    this.volumePopupShow = this.volumePopupShow + 1;
    this.volumePopupHasShowTimes = this.volumePopupShow;
    ViewModel.setVolumePopup(this.volumePopupShow);
  }

  private touchDownChangedCallback(windowX: number, windowY: number): void {
    this.setVolumeArrowAnimation(false);
    this.lastX = windowX;
    this.lastY = windowY;
    this.downX = windowX;
    this.downY = windowY;
    if (this.volumeAnimType === VolumeAnimType.TYPE_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_STOP ||
      this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK_STOP) {
      this.isSideVolumeTouchable = false;
    }
  }

  @Builder
  popupBuilder() {
    Column() {
      Text($r('app.string.volume_popup_note'))
        .fontSize(`${this.volumePopupFontSize}vp`)
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.Start)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .padding(this.volumeComponentStyle.popupMargin)
    }
    .justifyContent(FlexAlign.Center)
    .width(this.volumeComponentStyle.popupWidth + 2 * this.volumeComponentStyle.popupMargin)
  }

  private setVolumeArrowAnimation(state: boolean): void {
    if (state) {
      this.isRenderVolumeArrow = (this.volumePopupShow >= POPUP_DEFAULT_TIME) ? false : true;
      if (this.isRenderVolumeArrow) {
        log.showInfo(TAG, `play VolumeArrowAnimation`);
        this.countVolumeArrowTimes();
        this.playVolumeArrowAnimation();
        VolumeWindowController.getInstance().clearWindowTimer();
      }
    } else {
      if (this.volumeArrowTimer > 0) {
        clearTimeout(this.volumeArrowTimer);
        this.volumeArrowTimer = 0;
      }
      this.isRenderVolumeArrow = false;
    }
  }

  private playVolumeArrowAnimation(): void {
    animateTo({
      curve: this.volumeComponentStyle.curveOpacityArrow,
      duration: 183,
    }, () => {
      this.volumeArrowOpacity = 1;
    })
    animateTo({
      curve: this.volumeComponentStyle.curveTranslateXArrow,
      iterations: 5,
      delay: 183,
      duration: 200,
      playMode: PlayMode.Alternate,
    }, () => {
      this.volumeArrowTranslateX = -5;
    })
    animateTo({
      curve: this.volumeComponentStyle.curveOpacityArrow,
      duration: 183,
      delay: 983,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        VolumeWindowController.getInstance().resetWindowTimer();
      },
    }, () => {
      this.volumeArrowOpacity = 0;
    })
  }

  private getChannelNameWidth(): number {
    const length = this.volumeDialogChannels.length;
    const margins = 8;
    const itemSpace = (this.volumeDialogMaxWidth - margins -
      length * this.volumeComponentStyle.volumeProgressComponentWidth) / (length + 1);
    return itemSpace + this.volumeComponentStyle.volumeProgressComponentWidth - margins;
  }

  /**
   * 判断设备是否横屏或倒置竖屏
   *
   * @returns true 横屏或倒置竖屏
   */
  private isDisplayLandOrDisplayReverse(): boolean {
    if (DeviceHelper.isPhone() && (VolumeWindowController.getInstance().isDisplayLand() ||
    VolumeWindowController.getInstance().isDisplayReverse())) {
      return true;
    }
    if (DeviceHelper.isPad() && (VolumeWindowController.getInstance().isDisplayLand() ||
    VolumeWindowController.getInstance().isDisplayReverse())) {
      return true;
    }
    if (this.isConfigSmallScreen) {
      return true;
    }
    return false;
  }

  /**
   * 设置展开面板宽度
   *
   */
  private setDialogWidth(): void {
    if (this.isConfigDialogWidth) {
      this.setDialogWidthWithRegular();
      return;
    }
    if (VolumeWindowController.getInstance().isFoldExpand() || VolumeWindowController.getInstance().isDisplayLand()) {
      // 宽屏使用栅格
      let widthInPixel = ResUtils.getLandBoxGridRowWidth(this.mWindowWidth);
      this.volumeDialogMaxWidth = ArkUIAdapter.px2vp(widthInPixel);
      log.showInfo(TAG, `volume dialog in box grid style, width: ${this.volumeDialogMaxWidth}.`);
    } else { // 窄屏固定宽度
      this.setDialogWidthWithRegular();
    }
  }

  private setDialogWidthWithRegular(): void {
    this.volumeDialogMaxWidth = this.volumeComponentStyle.volumeDialogWidthInNumber;
    log.showInfo(TAG, `volume dialog in constant width style, width: ${this.volumeDialogMaxWidth}.`);
  }

  private adjustVolumePosition(): void {
    const volumeSettingHeight = this.isExpandVolumePanel() ? this.volumeComponentStyle.volumeSettingHeightExpand :
    this.volumeComponentStyle.volumeSettingHeight;
    if (VolumeWindowController.getInstance().isHalfFoldedStatus()) {
      let heightInVp = DeviceHelper.isSmallFoldProduct() ? ArkUIAdapter.px2vp(this.mWindowHeight) :
        ArkUIAdapter.px2vp(this.mWindowHeight) / 2;
      this.volumeBarTopMargin = (heightInVp - this.volumeComponentStyle.volumeDialogHeightInNumber) / 2;
      log.showInfo(TAG, `volume dialog in half fold style, width: ${this.volumeBarTopMargin}.`);
    } else if (this.isDisplayLandOrDisplayReverse()) { // 横屏高度居中 竖屏下倒置也要居中
      let heightInVp = ArkUIAdapter.px2vp(this.mWindowHeight);
      this.volumeBarTopMargin = (heightInVp - this.volumeComponentStyle.volumeDialogHeightInNumber) / 2;
    } else { // 竖屏对齐物理按键
      this.volumeBarTopMargin = this.volumePaddingTop - volumeSettingHeight;
      //XT物理按键高度较高，需要避让状态栏，距离状态栏8vp
      if (LayoutUtils.isXTProductType()) {
        const marginStatusBarTop = ResUtils.getNumber($r('app.float.status_bar_phone_height')) + MARGIN_STATUS_BAR_TOP;
        this.volumeBarTopMargin =
          this.volumeBarTopMargin < marginStatusBarTop ? marginStatusBarTop : this.volumeBarTopMargin;
      }
    }

    this.setDialogWidth();

    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN) {
      let halfX = ArkUIAdapter.px2vp(this.mWindowWidth) / 2 - this.cutoutWidth;
      this.volumeDialogWidth = this.volumeDialogMaxWidth;
      this.volumeStackWidth = this.volumeDialogMaxWidth;
      this.volumeDialogTranslateX = -halfX + this.volumeDialogWidth / 2; // x移动到屏幕中心

      if (!this.isDisplayLandOrDisplayReverse()) {
        // 平板音量键在竖屏右上的时候展开面板和音量上键对齐
        if (DeviceHelper.isPad()) {
          this.volumeBarTopMargin = this.volumeBarTopMargin + volumeSettingHeight;
        } else if (ViewModel.isPanelCompactLayout) {
          this.volumeBarTopMargin = this.volumeBarTopMargin + PANEL_OFFSET_TOP;
        }
        this.updateVolumeResponseReginByPosition();
      }
    }
  }

  private updateVolumeResponseReginByPosition(): void {
    let rspHeight = ArkUIAdapter.vp2px(this.dialogHeight as number);
    let rspWidth = ArkUIAdapter.vp2px(this.volumeDialogMaxWidth);
    let left = this.mWindowWidth / 2 - ArkUIAdapter.vp2px(this.volumeDialogMaxWidth) / 2;
    let top = ArkUIAdapter.vp2px(this.volumeBarTopMargin);
    if (this.isShowVolumePanel()) {
      left = 0;
      top = this.statusBarHeight;
      rspWidth = this.mWindowWidth;
      rspHeight = this.mWindowHeight;
    }
    VolumeWindowController.getInstance().updateVolumeResponseReginWithUiContext(left, top, rspWidth, rspHeight);
  }

  private getVolumeDialogWindowColor(): ResourceColor {
    if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START ||
    this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_STOP ||
    this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK ||
    this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK_STOP) {
      return `rgba(0,0,0,${this.volumeDialogWindowOpacity})`;
    }
    return Color.Transparent;
  }

  private getVolumeDialogScale(): ScaleOptions {
    if (this.volumeAnimType === VolumeAnimType.TYPE_NONE ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return { x: this.volumeDialogScale, y: this.volumeDialogScale, centerX: '50%', centerY: '50%' };
    }
    return {};
  }

  private getVolumeScale(): ScaleOptions {
    return { x: this.volumeScale, y: this.volumeScale, centerX: '50%', centerY: '50%' };
  }

  private getVolumeAnimateParam(): AnimateParam | undefined {
    if (this.volumeAnimType === VolumeAnimType.TYPE_IN) {
      return this.volumeActiveChannelSize > 1 ? undefined : this.getTypeInParam();
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_OUT) {
      return {
        duration: 450,
        curve: this.volumeComponentStyle.interpolatingSpringDefault,
        playMode: PlayMode.Normal,
        iterations: 1
      };
    }
    return {
      iterations: 0
    };
  }

  private getTypeInParam(): AnimateParam {
    return {
      duration: 450,
      curve: this.volumeComponentStyle.springMotionDefault,
      playMode: PlayMode.Normal,
      iterations: 1,
      onFinish: () => {
        this.setDesktopCache(false);
        performanceMonitor.end('VOLUME_BAR_SHOW');
      }
    };
  }

  private getVolumeTranslate(): TranslateOptions {
    // 不允许在build的get方法里改变状态变量，放到onVolumeAnimTypeChanged中
    let volumeTranslateX = this.volumeTranslateX;
    if (this.volumeAnimType === VolumeAnimType.TYPE_IN) {
      volumeTranslateX = -this.cutoutWidth;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_OUT) {
      volumeTranslateX = this.volumeComponentStyle.volumeBarInitTranslationX * this.volumeActiveChannelSize;
    }
    return { x: volumeTranslateX };
  }

  private onVolumeAnimTypeNone(): void {
    this.isAllControlOuting = false;
    this.dialogHeight = this.volumeComponentStyle.volumeBarContainerHeight;
    this.volumeStackWidth = this.mWidth;
    this.backgroundBlurWidth = this.volumeComponentStyle.volumeProgressComponentWidth;
    this.volumeStackHeight = this.volumeComponentStyle.volumeStackHeightInNumber;
    this.volumeStackBackHeight = 8;
    this.volumeStackOpacity = 0;
    this.panelTextOpacity = 0;
    this.volumeTextOpacity = 0;
    this.volumeTextScale = VOLUME_TEXT_SCALE;
    this.volumeTranslateX = this.volumeComponentStyle.volumeBarInitTranslationX;
    this.volumeScale = 0.7;
    this.volumeDialogWindowOpacity = 0;
    this.volumeDialogWidth = this.volumeComponentStyle.volumeDialogInitWidth;
    this.volumeDialogScale = 1;
    this.volumeDialogTranslateX = 0;
    this.dialogChannelContainerHeight = this.volumeComponentStyle.volumeDialogInitHeight;
    this.setOriginalRight();
    this.setOriginalOpacity();
    this.setOriginalScale();
    this.secondPanelOpacity = 0;
    this.volumePanelOpacity = 1;
    this.isTouchControlling = false;
    this.volumeArrowTranslateX = 0;
    this.isExpandRegionTouching = false;
    this.forceVolumeKeyControlType(-1, true);
  }

  private onVolumeAnimTypeThickToThin(): void {
    this.volumeTranslateX = 0 - this.cutoutWidth;
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThick2Thin,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeDialogWidth = this.volumeComponentStyle.volumeDialogInitThinWidth;
      this.volumeStackWidth = this.mWidthThin;
      this.backgroundBlurWidth = this.mWidthThin;
      if (this.volumeActiveChannelSize > 1) {
        const activeIndex =
          this.volumeChannels.findIndex(volumeChannel => volumeChannel.volumeType === this.currentActiveVolumeType);
        for (let index = 0; index < this.volumeChannelSize; index++) {
          if (index !== activeIndex) {
            this.panelToRights[index] =
              -this.volumeComponentStyle.volumeBarInitTranslationX - Math.abs(this.cutoutWidth);
            this.panelScales[index] = 0.7;
          } else {
            this.panelToRights[index] = PANEL_RIGHT;
          }
        }
      }
    });
  }

  private onVolumeAnimTypeThinToThick(): void {
    this.volumeDialogWidth = this.volumeComponentStyle.volumeDialogInitWidth +
      (this.volumeActiveChannelSize - 1) * this.volumeComponentStyle.volumeBarInitTranslationX;
    this.volumeDialogWindowOpacity = 0;
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThin2Thick,
      playMode: PlayMode.Normal
    }, () => {
      if (this.volumeActiveChannelSize > 1) {
        this.mainVolumeBarScale = 1.05;
        this.mainVolumeBarTranslateX = 0;
      } else {
        this.mainVolumeBarScale = 1.1;
        this.mainVolumeBarTranslateX = -4.5;
      }
    });
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeDialogWindowOpacity = this.maxWindowColorOpacity;
      this.setVolumePanel();
    });
  }

  private onVolumeAnimTypeThinToThickStop(): void {
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeStackWidth = this.mWidth;
      this.backgroundBlurWidth = this.volumeComponentStyle.volumeProgressComponentWidth;
      this.mainVolumeBarTranslateX = 0;
      this.mainVolumeBarScale = 1;
    });
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeDialogWindowOpacity = 0;
    });
  }

  private onVolumeAnimTypeThickDownStart(): void {
    // ux断点出现黑屏：指定透明度为0
    this.dialogHeight = this.volumeComponentStyle.dialogMaxHeight;
    this.volumeDialogWindowOpacity = 0;
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThickDownStart,
      playMode: PlayMode.Normal
    }, () => {
      if (this.volumeActiveChannelSize > 1) {
        this.mainVolumeBarScale = 1.05;
        this.setVolumePanel(true);
      } else {
        this.mainVolumeBarScale = 1.1;
        this.mainVolumeBarTranslateX = -4.5;
      }
    });
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeDialogWindowOpacity = this.maxWindowColorOpacity;
    });
  }

  private onVolumeAnimTypeThickDownStop(isScreenLockEvent?: boolean): void {
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringThickDownStop,
      playMode: PlayMode.Normal,
      onFinish: () => {
        if (isScreenLockEvent) {
          this.volumeAnimType = VolumeAnimType.TYPE_OUT;
        }
      },
    }, () => {
      this.volumeDialogTranslateX = 0;
      this.volumeStackOpacity = 0;
      this.mainVolumeBarScale = 1;
      this.mainVolumeBarTranslateX = 0;
      this.volumeStackWidth = this.volumeComponentStyle.volumeProgressComponentWidth;
      this.backgroundBlurWidth = this.volumeComponentStyle.volumeProgressComponentWidth;
      this.volumeStackHeight = this.volumeComponentStyle.volumeStackHeightInNumber;
      this.volumeStackBackHeight = 8;
      this.setVolumePanel();
    });
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal
    }, () => {
      this.volumeDialogWindowOpacity = 0;
      this.dialogHeight = this.volumeComponentStyle.volumeBarContainerHeight;
    });
  }

  private allControlInAnimateFinish(): void {
    this.animationInCount--;
    if (this.animationInCount === 0) {
      this.setDesktopCache(false);
      performanceMonitor.end('VOLUME_BAR_EXPAND');
    }
  }

  private getDialogWith(): number {
    let width: number = 0;
    if (this.isConfigDialogWidth) {
      return this.volumeComponentStyle.volumeDialogWidthInNumber;
    }
    if (VolumeWindowController.getInstance().isFoldExpand() || VolumeWindowController.getInstance().isDisplayLand()) {
      let widthInPixel = ResUtils.getLandBoxGridRowWidth(this.mWindowWidth);
      width = ArkUIAdapter.px2vp(widthInPixel);
    } else {
      width = this.volumeComponentStyle.volumeDialogWidthInNumber;
    }
   return width;
  }

  private allControlInInterpolatingAnimate(): void {
    const width: number = this.getDialogWith();
    //音量条等间距间隙
    let space = (width - this.volumeActiveChannelSize * this.volumeComponentStyle.volumeProgressComponentWidth) /
      (this.volumeActiveChannelSize + 1);
    animateTo({
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.allControlInAnimateFinish();
      }
    }, () => {
      this.animationInCount++;
      this.volumeStackHeight = this.volumeComponentStyle.volumeDialogHeightInNumber;
      this.volumeStackOpacity = 1;
      this.adjustVolumePosition();
      this.dialogChannelContainerHeight = this.volumeComponentStyle.volumeDialogHeightInNumber;
      this.panelTextOpacity = 1;
      for (let index = 0; index < this.volumeActiveChannelSize; index++) {
        this.panelToRights[index] = (this.volumeActiveChannelSize - 1 - index) *
          (space + this.volumeComponentStyle.volumeProgressComponentWidth) + space;
      }
    });
  }

  private allControlInOtherAnimate(): void {
    animateTo({
      duration: ANIMATION_TIME_500,
      iterations: 1,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.allControlInAnimateFinish();
      }
    }, () => {
      this.animationInCount++;
      for (let index = 0; index < this.volumeChannelSize; index++) {
        this.panelScales[index] = 1;
      }
    });

    let i = 0;
    for (let index = 0; index < this.volumeChannelSize; index++) {
      const channel = this.volumeChannels[index];
      if (this.volumeDialogChannels.includes(channel.volumeType)) {
        animateTo({
          duration: this.volumeComponentStyle.expandVolumeDurations[i],
          iterations: 1,
          curve: Curve.Friction,
          playMode: PlayMode.Normal,
          delay: i * EXPAND_VOLUME_DELAY,
          onFinish: () => {
            this.allControlInAnimateFinish();
          }
        }, () => {
          this.animationInCount++;
          this.componentOpacities[index] = 1;
          i++;
        });
      }
    }

    animateTo({
      duration: ANIMATION_TIME_250,
      iterations: 1,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      delay: ANIMATION_TIME_250,
      onFinish: () => {
        this.allControlInAnimateFinish();
      }
    }, () => {
      this.animationInCount++;
      this.volumeTextScale = 1;
      this.volumeTextOpacity = 1;
    });
    animateTo({
      duration: ANIMATION_TIME_83,
      curve: Curve.Friction,
      onFinish: () => {
        this.allControlInAnimateFinish();
      }
    }, () => {
      this.animationInCount++;
      this.volumePanelTextHeight = this.volumeStackBackHeight;
    });
  }

  private onVolumeAnimTypeAllControlIn(): void {
    performanceMonitor.begin('VOLUME_BAR_EXPAND', performanceMonitor.ActionType.LAST_DOWN, 'NO_USER');
    this.dialogHeight = this.volumeComponentStyle.volumeDialogHeightInNumber;
    for (let index = 1; index < this.volumeChannelSize; index++) {
      this.panelToRights[index] = IN_TYPE_PANEL_RIGHT;
    }
    this.volumeStackOpacity = TRANSITION_OPACITY;
    this.secondPanelOpacity = TRANSITION_OPACITY;
    HiDfxEventUtil.reportExpandVolPanel(true);
    VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_BAR_TO_PANEL,
      VolumeReportBuilder.builder()
        .isLocked(ScreenLockApi.getLock())
        .uiType(this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ? 1 : 0)
        .hintTimes(this.volumePopupHasShowTimes)
        .build());
    this.updateVolumeResponseReginByPosition();
    this.volumeTranslateX = 0 - this.cutoutWidth; // 音量条恢复到右侧后再开始计算距离，否则有偏移
    this.allControlInInterpolatingAnimate();
    this.allControlInOtherAnimate();
  }

  private allControlOutAnimateFinish(): void {
    this.animationOutCount--;
    if (this.animationOutCount === 0) {
      this.volumeAnimType = VolumeAnimType.TYPE_OUT;
      // 音量panel立即消失
      this.cancelDismissTimer();
      VolumeWindowController.getInstance().dismissVolumeWindowImmediately();
      this.volumeStackOpacity = TRANSITION_OPACITY;
      this.isAllOutFinished = true;
      performanceMonitor.end('VOLUME_BAR_COLLAPSE');
    }
  }

  private allControlOutInterpolatingAnimate(): void {
    animateTo({
      iterations: 1,
      curve: this.volumeComponentStyle.interpolatingSpringDefault,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.allControlOutAnimateFinish();
      }
    }, () => {
      this.animationOutCount++;
      this.volumeDialogTranslateX = 0;
      this.volumeDialogWidth = this.volumeComponentStyle.volumeDialogInitWidth;
      this.panelToRights[0] = PANEL_RIGHT;
      for (let index = 1; index < this.volumeChannelSize; index++) {
        this.panelToRights[index] = OUT_TYPE_PANEL_RIGHT;
      }
      this.secondPanelOpacity = TRANSITION_OPACITY;
    });
  }

  private allControlOutOtherAnimate(): void {
    animateTo({
      duration: ANIMATION_TIME_400,
      iterations: 1,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.allControlOutAnimateFinish();
      }
    }, () => {
      this.animationOutCount++;
      this.volumeStackWidth = this.mWidth;
      this.volumeStackHeight = this.volumeComponentStyle.volumeStackHeightInNumber;
    });
    animateTo({
      duration: ANIMATION_TIME_300,
      iterations: 1,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.dialogChannelContainerHeight = this.volumeComponentStyle.volumeDialogInitHeight;
        this.isAllControlOuting = true;
        this.allControlOutAnimateFinish();
      }
    }, () => {
      this.animationOutCount++;
      for (let index = 1; index < this.volumeChannelSize; index++) {
        this.componentOpacities[index] = 0;
      }
      this.volumeStackOpacity = 0;
      this.panelTextOpacity = 0;
    });
    animateTo({
      duration: ANIMATION_TIME_83,
      iterations: 1,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.allControlOutAnimateFinish();
      }
    }, () => {
      this.animationOutCount++;
      this.volumeTextOpacity = 0;
      this.volumeTextScale = VOLUME_TEXT_SCALE;
    });
  }

  private onVolumeAnimTypeAllControlOut(): void {
    performanceMonitor.begin('VOLUME_BAR_COLLAPSE', performanceMonitor.ActionType.LAST_DOWN, 'NO_USER');
    HiDfxEventUtil.reportExpandVolPanel(false);
    animateTo({
      duration: ANIMATION_TIME_350,
      iterations: 1,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        log.showInfo(TAG, `onVolumeAnimTypeAllControlOut onFinish`)
      }
    }, () => {
      this.animationOutCount++;
      this.volumeDialogScale = VOLUME_PANEL_SCALE;
    });
    animateTo({
      duration: ANIMATION_TIME_150,
      iterations: 1,
      curve: Curve.Linear,
      playMode: PlayMode.Normal,
      delay: VOLUME_PANEL_OPACITY_DELAY_TIME,
      onFinish: () => {
        this.allControlOutAnimateFinish();
      }
    }, () => {
      this.volumePanelOpacity = 0;
    });
  }

  /**
   * 音量条打点 从哪一状态消失
   * @param disappearType
   */
  reportVolumeUIDisappearType(volumeAnimType: number) {
    let disappearType:DisappearType = 0;
    // 根据VolumeAnimType判断从粗、细音量条或音量控制面板的哪个状态消失
    if (volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      disappearType = DisappearType.DISAPPEAR_FROM_CONTROL;
    } else if (volumeAnimType === VolumeAnimType.TYPE_THICK_TO_THIN ||
      volumeAnimType == VolumeAnimType.TYPE_KEY_DOWN_THIN ||
      volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN) {
      disappearType = DisappearType.DISAPPEAR_FROM_THIN;
    } else {
      disappearType = DisappearType.DISAPPEAR_FROM_THICK;
    }
    VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_PANEL_BAR_TO_DISAPPEAR,
      VolumeReportBuilder.builder()
        .disappearFromUIType(disappearType as number)
        .isLocked(ScreenLockApi.getLock())
        .build())
  }

  private onVolumeAnimTypeChanged(): void {
    log.showInfo(TAG, `volumeAnimType ${this.volumeAnimType}`);
    if (this.volumeAnimType === VolumeAnimType.TYPE_OUT) {
      this.volumeTranslateX = this.volumeComponentStyle.volumeBarInitTranslationX * this.volumeActiveChannelSize;
      this.reportVolumeUIDisappearType(this.lastVolumeType);
      this.volumeScale = 0.7;
      this.startDismissTimer(450);
      this.isVolumeBarHiding = true;
    } else {
      this.isVolumeBarHiding = false;
    }
    this.lastVolumeType = this.volumeAnimType;
    if (this.volumeAnimType !== VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      this.isAllOutFinished = false;
    } else {
      this.volumePopupHasShowTimes = -1;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_IN) {
      this.volumeTranslateX = -this.cutoutWidth;
      this.playSecondVolumeInAnimation();
      this.volumeScale = 1;
      VolumePanelServiceWrapper.generateThrottleSetVolume();
      this.setVolumePanel();
      this.volumeDialogWidth = this.volumeComponentStyle.volumeDialogInitWidth +
        (this.volumeActiveChannelSize - 1) * this.volumeComponentStyle.volumeBarInitTranslationX;
    } else {
      this.stopPopup = true;
      this.setVolumeArrowAnimation(false);
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_NONE) {
      this.onVolumeAnimTypeNone();
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
      this.onVolumeAnimTypeAllControlIn();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      this.onVolumeAnimTypeAllControlOut();
      return;
    }
  }

  // 唤出音量条第二段动效：箭头动效(如需展示)
  private playSecondVolumeInAnimation(): void {
    if (!this.isConfigSmallScreen) {
      log.showInfo(TAG, `add VolumeArrowAnimation`);
      this.volumeArrowTimer = setTimeout(() => {
        this.setVolumeArrowAnimation(!this.stopPopup);
      }, POPUP_DELAY_TIME);
    }
  }

  private startDismissTimer(time: number): void {
    this.outTimerHandle = setTimeout(() => {
      VolumeWindowController.getInstance().dismissVolumeWindowImmediately();
      this.volumeIsShow = false;
    }, time);
  }

  private cancelDismissTimer(): void {
    if (this.outTimerHandle > 0) {
      clearTimeout(this.outTimerHandle);
      this.outTimerHandle = 0;
    }
  }

  private processUserInteraction(event?: TouchEvent): void {
    if (!event) {
      log.showError(TAG, 'processUserInteraction event is invalid');
      return;
    }
    if (event.type === TouchType.Down) {
      VolumeWindowController.getInstance().pauseAutoDismissTimer();
      return
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      VolumeWindowController.getInstance().startAutoDismissTimer();
    }
  }

  private onPanelTouchedUp(isExpandRegion?: boolean): void {
    if (!this.isShowVolumePanel() && isExpandRegion) {
      log.showInfo(TAG, `touch up expand region`);
      this.onTouchVolumeOutSide();
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK) {
      this.volumeAnimType = VolumeAnimType.TYPE_THIN_TO_THICK_STOP;
    } else if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_START) {
      this.volumeAnimType = VolumeAnimType.TYPE_THICK_DOWN_STOP;
    } else if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_START) {
      this.volumeAnimType = VolumeAnimType.TYPE_THICK_DOWN_STOP;
      this.isDragControlStop = true;
    }
  }

  private onVolumePanelTouched(event?: TouchEvent, isExpandRegion?: boolean): void {
    if (!event || event.touches == null || event.touches.length <= 0) {
      return;
    }
    let pointer = event.touches[0];
    if (pointer == null) {
      return;
    }
    if (event.type === TouchType.Down && this.isExpandVolumePanel()) {
      log.showInfo(TAG, 'touch outside expand volume panel');
      this.onTouchVolumeOutSide();
      return;
    }
    if ((TouchType.Up === event.type || TouchType.Cancel === event.type) && isExpandRegion) {
      this.isExpandRegionTouching = false;
      this.isSideVolumeTouchable = true;
    }
    if (event.type === TouchType.Up) {
      this.activeVolumeChannelTypeChange(true);
      this.onPanelTouchedUp(isExpandRegion);
      return;
    }
    let x = pointer.windowX;
    let y = pointer.windowY;
    if (pointer.type === TouchType.Down) {
      this.ratioX = this.mWindowWidth;
      this.lastX = x;
      this.lastY = y;
      this.downX = x;
      this.downY = y;
      if (isExpandRegion) {
        log.showInfo(TAG, 'touch down expand region');
        return;
      }
      if (this.volumeAnimType === VolumeAnimType.TYPE_THICK_TO_THIN ||
        this.volumeAnimType === VolumeAnimType.TYPE_KEY_DOWN_THIN ||
        this.volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN) {
        this.volumeAnimType = VolumeAnimType.TYPE_THIN_TO_THICK;
      } else if (this.volumeAnimType === VolumeAnimType.TYPE_IN ||
        this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_STOP ||
        this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK_STOP) {
        this.isSideVolumeTouchable = false;
      }
      log.showInfo(TAG, 'touch down');
      this.activeVolumeChannelTypeChange();
      return;
    }
    if (this.lastX === x && this.lastY === y) {
      // 初次移动坐标值相同
      log.showInfo(TAG, 'touch same');
      return;
    }
    if (pointer.type === TouchType.Move) {
      log.showInfo(TAG, 'touch move');
      this.moveStart(x, y, isExpandRegion);
      this.moveControlStart(x, y);
    }
    this.lastX = x;
    this.lastY = y;
  }

  private moveStart(x: number, y: number, isExpandRegion?:boolean) {
    if (this.volumeAnimType === VolumeAnimType.TYPE_NONE ||
      this.volumeAnimType === VolumeAnimType.TYPE_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_THICK_DOWN_STOP ||
      this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK_STOP) {
      let xScreenDis = x - this.downX;
      let yScreenDis = y - this.downY;
      let dis = VolumeWindowController.getInstance().rotateCoordinate(xScreenDis, yScreenDis);
      let xDis = dis[0];
      let yDis = dis[1];
      if (xDis < 0 && ((Math.abs(xDis) * Math.tan(55 * Math.PI / 180)) > Math.abs(yDis))) {
        this.volumeAnimType = VolumeAnimType.TYPE_ALL_CONTROL_START;
        this.isSideVolumeTouchable = false;
        if (isExpandRegion) {
          log.showInfo(TAG, 'expand region touching');
          this.isExpandRegionTouching = true;
        }
      } else {
        if (isExpandRegion) {
          log.showInfo(TAG, 'touch expand region not expand');
          this.onTouchVolumeOutSide();
        } else {
          this.isSideVolumeTouchable = true;
          this.activeVolumeChannelTypeChange(true);
          this.volumeAnimType = VolumeAnimType.TYPE_THICK_DOWN_START;
        }
      }
    }
  }

  private moveControlStart(x: number, y: number) {
    if (this.isConfigSmallScreen) {
      return;
    }
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_START) {
      let deltaScreenX = x - this.lastX;
      let deltaScreenY = y - this.lastY;
      let delta = VolumeWindowController.getInstance().rotateCoordinate(deltaScreenX, deltaScreenY);
      let deltaX = delta[0];
      let translateX = this.volumeDialogTranslateX + ArkUIAdapter.px2vp(deltaX);
      if (translateX > 0) {
        translateX = 0;
      }
      let ratio = Math.abs(translateX) / this.volumeComponentStyle.volumePanelDragThreshold;
      let stackHeight = this.volumeComponentStyle.volumeStackHeightInNumber +
        (this.volumeComponentStyle.volumeDialogInitHeight - this.volumeComponentStyle.volumeStackHeightInNumber) *
          ratio;
      if (stackHeight > this.volumeComponentStyle.volumeDialogInitHeight) {
        stackHeight = this.volumeComponentStyle.volumeDialogInitHeight;
      }
      // 透明度：0.15->0.55保持和TRANSITION_OPACITY相近，色差过渡平缓
      let stackOpacity = this.volumeComponentStyle.volumeStackInitOpacity + 0.4 * ratio;
      let stackWidth = this.volumeComponentStyle.volumeProgressComponentWidth + 12 * ratio;
      this.volumeStackWidth = stackWidth;
      this.volumeStackHeight = stackHeight;
      this.volumeStackOpacity = stackOpacity;
      this.volumeDialogTranslateX = translateX; // 音量条
      this.volumeStackPaddingWidth = 16 * ratio;
      log.showInfo(TAG, `volumeDialogTranslateX: ${this.volumeDialogTranslateX}`);
      if (ratio >= 1 || deltaX <= -12) { // 超过阈值，动画展开音量大面板 1500px/s 或者大于80vp
        this.expandVolumeDialog();
        this.ratioX = x;
      }
    }
    //回滑打断展开，执行收起
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN && x > this.ratioX) {
      this.volumeAnimType = VolumeAnimType.TYPE_ALL_CONTROL_OUT;
      this.isBlockExpandCancelTouch = true;
      this.ratioX = this.mWindowWidth;
    }
  }

  private expandVolumeDialog(): void {
    // 设置音量面板自动关闭时长
    VolumeWindowController.getInstance().setInterval(Constants.VOLUME_DIALOG_TIMEOUT);
    if (this.volumePopupShow < POPUP_DEFAULT_TIME) {
      this.volumePopupShow = POPUP_DEFAULT_TIME;
      ViewModel.setVolumePopup(POPUP_DEFAULT_TIME);
    }
    this.setDesktopCache(true);
    this.volumeStackWidth = this.volumeComponentStyle.volumeDialogInitWidth;
    this.volumeChannels.sort((a, b) => this.volumeDialogChannels.findIndex(volumeType => volumeType === b.volumeType) -
    this.volumeDialogChannels.findIndex(volumeType => volumeType === a.volumeType));
    this.activeChannelTypes = this.volumeDialogChannels;
    this.volumeActiveChannelSize = this.activeChannelTypes.length;
    this.setOriginalRight(true);
    this.setOriginalScale(true);
    this.volumeDialogWidth = this.volumeComponentStyle.volumeDialogInitWidth;
    this.volumeStackHeight =
      this.volumeComponentStyle.volumeProgressComponentHeight + this.volumeComponentStyle.volumePanelTextHeight;
    this.volumeStackBackHeight = this.volumePanelTextHeight;
    this.volumePanelTextHeight = -this.volumeComponentStyle.volumePanelTextHeight;
    this.volumeAnimType = VolumeAnimType.TYPE_ALL_CONTROL_IN;
    if (this.isAccessibilityMode) {
      this.sendEventByResource(ResUtils.getInnerStringNumS($r('app.string.volume_accessibility_expand_dialog'),
        Constants.ACCESSIBILITY_SECONDS));
      this.requestFocusAccessibility(VOLUME_ACCESSIBILITY_TEXT_ID);
      VolumeWindowController.getInstance().startAutoDismissTimer();
    }
    this.forceVolumeKeyControlType(-1, true);
  }

  /**
   * 点击更多设置
   */
  private onVolumeSettingClicked = (): void => {
    VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_PANEL_CLICK_SETTING,
      VolumeReportBuilder.builder().isLocked(ScreenLockApi.getLock()).build());
    this.volumeAnimType = VolumeAnimType.TYPE_ALL_CONTROL_OUT;
    if (ScreenLockApi.getLock()) {
      if (AppStorage.get('lockStatus') !== ScreenLockStatus.UNLOCK) {
        ScreenLockApi.requestUnlock({
          success: (): void => {
            log.showInfo(TAG, 'requestUnlock success');
            this.goSettingIfUnlock();
          }
        }, true);
        return;
      }
      ScreenLockApi.unlockWhenNoPsw();
      setTimeout(() => {this.goSettingIfUnlock();}, UNLOCK_DELAY_TIME);
      return;
    }
    this.goSettingIfUnlock();
  }

  /**
   * 跳转到设置页面
   */
  private goSettingIfUnlock(): void {
    log.showInfo(TAG, 'goSettingIfUnlock start');
    sEventManager.publish(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.PKG_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'volume_settings',
      moduleName: 'phone'
    }));
  }

  private getSidePaddingWith(): number {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return this.volumeStackWidth;
    }
    return 10 + this.volumeStackPaddingWidth
  }

  private isExpandVolumePanel(): boolean {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT) {
      return true
    }
    return false;
  }

  private isShowVolumePanel(): boolean {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_IN ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_START) {
      return true
    }
    return false;
  }

  private setDesktopCache(flag: boolean): void {
    if (flag) {
      this.desktopCacheFlag = true;
      let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
      SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'Volume set', false, expandStatus);
      // 冻结桌面时间图标
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_FOCUS_CHANGE, false);
    } else {
      if (this.desktopCacheFlag) {
        this.desktopCacheFlag = false;
        let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
        SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'Volume set', false, expandStatus);
        this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_FOCUS_CHANGE, true);
      }
    }
  }

  private isVolumePanelUntouchable(): boolean {
    if (this.volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_OUT ||
      this.volumeAnimType === VolumeAnimType.TYPE_NONE ||
      this.isTouchControlling) {
      return true;
    } else {
      return false;
    }
  }

  private getVolumeBarAccessibilityDescription($$: VolumeChannelInfo): Resource {
    const percent = this.volumeAccessibilityPercentValues.get($$.channel.volumeType) ?? ACCESSIBILITY_DEFAULT_PERCENT;
    const channelName = $$.channel.volumeType === audio.AudioVolumeType.MEDIA ? $r('app.string.volume_accessibility_media') :
    $$.channel.channelName;
    return this.isExpandVolumePanel() || this.isConfigSmallScreen ?
    $r('app.string.volume_accessibility_dialog', percent, channelName) :
    $r('app.string.volume_accessibility_single', percent, channelName);
  }

  private async requestFocusAccessibility(customId: string): Promise<void> {
    if (!this.isAccessibilityMode) {
      return;
    }

    try {
      this.isShowVolumeAccessibilityText = true;
      await accessibility.sendAccessibilityEvent({
        type: 'requestFocusForAccessibilityNotInterrupt',
        bundleName: 'com.ohos.sceneboard',
        triggerAction: 'click',
        customId: customId,
      });
    } catch (err) {
      this.isShowVolumeAccessibilityText = false;
      log.showError(TAG, `requestFocusAccessibility failed, Code is ${err.code}, message is ${err.message}`);
    }
  }

  private async sendEventByResource(text: string): Promise<void> {
    if (!this.isAccessibilityMode) {
      return;
    }

    try {
      await accessibility.sendAccessibilityEvent({
        type: 'announceForAccessibility',
        bundleName: 'com.ohos.sceneboard',
        triggerAction: 'click',
        textAnnouncedForAccessibility: text,
      });
    } catch (err) {
      log.showError(TAG, `sendEventByText failed, Code is ${err.code}, message is ${err.message}`);
    }
  }

  public onRingerModeChanged(ringerMode: audio.AudioRingMode): void {
    log.showInfo(TAG, `onRingerModeChanged ${ringerMode}`);
    this.ringerMode = ringerMode;
  }

  private getActiveBarScale(volumeType: audio.AudioVolumeType): ScaleOptions | undefined {
    if (this.currentActiveVolumeType === volumeType) {
      return {
        x: this.mainVolumeBarScale,
        y: this.mainVolumeBarScale,
        centerX: '100%',
        centerY: '50%'
      }
    }
    return undefined;
  }

  /**
   * 各音量条布局边距
   * @param isThickDown 是否是按压时，按压时将其他音量柱向外推2vp
   * @returns
   */
  private setVolumePanel(isThickDown: boolean = false): void {
    let i = 0;
    for (let index = 0; index < this.volumeChannelSize; index++) {
      const volumeChannel = this.volumeChannels[index];
      if (this.activeChannelTypes.includes(volumeChannel.volumeType)) {
        if (isThickDown && volumeChannel.volumeType !== this.currentActiveVolumeType) {
          const activeChannelIndex =
            this.volumeChannels.findIndex(channel => channel.volumeType === this.currentActiveVolumeType);
          this.panelToRights[index] =
            index > activeChannelIndex ? this.panelToRights[index] - 2 : this.panelToRights[index] + 2;
        } else {
          this.panelToRights[index] = (this.volumeActiveChannelSize - i - 1) *
            (MULTI_VOLUME_SPACE + this.volumeComponentStyle.volumeProgressComponentWidth) + PANEL_RIGHT;
        }
        i++;
      } else {
        this.panelToRights[index] = -this.volumeComponentStyle.volumeBarInitTranslationX;
      }
      this.panelScales[index] = 1;
    }
  }

  private activeVolumeChannelTypeChange(isMove: boolean = false): void {
    const volumeChannelType = this.nextActiveVolumeChannelType;
    if (volumeChannelType !== undefined && !this.isExpandVolumePanel() &&
      this.currentActiveVolumeType !== volumeChannelType &&
      this.volumeAnimType !== VolumeAnimType.TYPE_ALL_CONTROL_START) {
      const index = this.volumeChannels.findIndex(volumeChannel => volumeChannel.volumeType === volumeChannelType);
      this.isDragControlStop = true;
      if (isMove) {
        this.activeBar(index, volumeChannelType);
        return;
      }
      animateTo({
        curve: this.volumeComponentStyle.interpolatingSpringActive,
      }, () => {
        this.panelScales[index] = 0.95;
      })
    }
  }

  private activeBar(index: number, volumeChannelType: audio.AudioVolumeType): void {
    animateTo({
      curve: this.volumeComponentStyle.interpolatingSpringActive,
    }, () => {
      this.panelScales[index] = 1;
      this.currentActiveVolumeType = volumeChannelType;
    })
  }

  private getMultiVolumeAnimation(volumeType: audio.AudioVolumeType): AnimateParam | undefined {
    const index = this.activeChannelTypes.findIndex(activeVolumeType => volumeType === activeVolumeType);
    if (index === -1 || this.volumeActiveChannelSize === 1 || this.volumeAnimType !== VolumeAnimType.TYPE_IN) {
      return undefined;
    }
    return {
      curve: this.volumeComponentStyle.springMotionMultiVolume[index],
      onFinish: () => {
        this.setDesktopCache(false);
        performanceMonitor.end('VOLUME_BAR_SHOW');
      },
    }
  }

  private getVolumeChannelZIndex($$: VolumeChannelInfo): number {
    if ($$.channel.volumeType === this.currentActiveVolumeType &&
      (this.volumeAnimType === VolumeAnimType.TYPE_THICK_TO_THIN ||
        this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK ||
        this.volumeAnimType === VolumeAnimType.TYPE_THIN_TO_THICK_STOP)) {
      return VOLUME_ACTIVE_INDEX;
    }
    return this.volumeChannelSize - $$.index;
  }

  private forceVolumeKeyControlType(forceVolumeType: audio.AudioVolumeType, isCancel = false): void {
    if (this.forceVolumeType === forceVolumeType) {
      log.showInfo(TAG, `already set force type: ${forceVolumeType}`);
      return;
    }
    let duration: number = Constants.MAX_FORCE_VOLUME_CONTROL_TYPE_SECONDS;
    if (this.forceVolumeKeyControlTypeTimeId) {
      clearInterval(this.forceVolumeKeyControlTypeTimeId);
      this.forceVolumeKeyControlTypeTimeId = undefined;
    }
    if (isCancel) {
      duration = -1;
    } else {
      this.forceVolumeKeyControlTypeTimeId = setInterval(() => {
        VolumePanelServiceWrapper.forceVolumeKeyControlType(forceVolumeType, duration);
      }, Constants.VOLUME_DIALOG_TIMEOUT);
    }
    VolumePanelServiceWrapper.forceVolumeKeyControlType(forceVolumeType, duration);
    this.forceVolumeType = forceVolumeType;
    log.showInfo(TAG, `forceVolumeKeyControlType forceVolumeType: ${forceVolumeType} duration: ${duration}`);
  }

  private onCurrentActiveVolumeTypeChanged(): void {
    if (this.currentActiveVolumeType !== audio.AudioVolumeType.ALL) {
      this.forceVolumeKeyControlType(this.currentActiveVolumeType);
    }
  }

  private registerInputMonitor(): void {
    try {
      inputMonitor.on('keyPressed', [KeyCode.KEYCODE_VOLUME_UP, KeyCode.KEYCODE_VOLUME_DOWN],
        this.volumeActionUpCallback);
    } catch (err) {
      log.error(TAG, 'registerInputMonitor failed, err: ', err);
    }
  }

  private unregisterInputMonitor(): void {
    try {
      inputMonitor.off('keyPressed', this.volumeActionUpCallback);
    } catch (err) {
      log.error(TAG, 'unregisterInputMonitor failed, err: ', err);
    }
  }

  /**
   * 监听音量键抬手事件
   */
  private volumeActionUpCallback = (event: KeyEvent): void => {
    if (event.action === Action.UP) {
      VolumePanelService?.mVolumeKeyPressedListener?.forEach((listener: VolumeKeyPressedListener) => {
        listener?.onKeyUp?.();
      });
    }
  };
}