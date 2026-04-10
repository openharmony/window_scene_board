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
import {
  ResUtils,
  windowMgr,
} from '@ohos/windowscene';
import {
  DeviceHelper,
  EventManager,
  EvtBus,
  PluginSlot,
  ViewCallback,
  ViewManagerPolicy,
  ViewType,
  WindowEvent,
  sEventManager,
  obtainLocalEvent,
  GlobalContext,
  PluginInfo,
  PluginPosition,
  SettingsUtil,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { HoverConstants } from '@ohos/commonconstants';
import { ColorResourceUtils, DarkModeEvent, StatusBarType, ThemeChangeEvent } from '@ohos/systemuicommon';
import { LogHelper, LogDomain, SingletonHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import {
  VolumeAnimViewData,
  VolumeDraggingViewData,
  BackgroundOpacity,
  VolumeViewData,
  BlurOpacity
} from '../model/VolumeViewData';
import { curves } from '@kit.ArkUI';
import sVolumeController from '../controller/VolumeController';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { AccessibilityUtil } from '@ohos/screenlockcommon';
import StyleConfiguration, {
  ControlCenterQuickToggleLayoutStyle
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import lottie, { AnimationItem } from '@ohos/lottie';

import Constants from '../common/Constants';
import VolumePanelService from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/model/VolumePanelService';
import { SYSTEM_VOLUME_TYPE, VolumeInfo } from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/common/Constants';
import { HostType } from '@ohos/systemuicommon';
import { AudioPlayerHelper } from '../../../soundpanel/util/AudioPlayerNewHelper';
import common from '@ohos.app.ability.common';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { audio } from '@kit.AudioKit';
import { AudioSoundViewModel } from '../../../soundpanel/viewmodel/AudioSoundViewModel';
import { AudioSoundModel } from '../../../soundpanel/model/AudioSoundModel';

const TAG = 'Ctrl.VolumeViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const LOCAL_EVENT_TYPE = 'local';

export const AUDIO_DEVICE_TYPE_KEY = 'AudioDeviceType';

export const AUDIO_DEVICE_LIST_KEY = 'AudioDeviceList';

export const AUDIO_PANEL_FOCUS_KEY = 'AudioPanelFocus';

export const VOLUME_PANEL_MAX_VOLUME_KEY = 'VolumePanelMaxVolume';

export const VOLUME_PANEL_MIN_VOLUME_KEY = 'VolumePanelMinVolume';

export const VOLUME_PANEL_CURRENT_VOLUME_VALUE_KEY = 'VolumePanelCurrentVolumeValue';

export const VOLUME_PANEL_IS_MUTE_KEY = 'VolumePanelIsMute';

export const KEY_BOARD_IS_ACTIVE_KEY = 'KeyBoardIsActive';

export const MOUSE_IS_ACTIVE_KEY = 'MouseIsActive';

export const AUDIO_DEVICE_ID_KEY = 'AudioDeviceId';

export const VOLUME_CHANGE_EVENT = 'VolumeChangeEvent';

/**
 * 鼠标滚轮每次滚动触发的手势事件偏移量为21的倍数
 */
const MOUSE_SCROLL_EVENT_OFFSET = 21;

enum VolumeStatus {
  DEFAULT = 0,
  // 根据超出范围播放动画，深浅模式均显示蓝色
  DRAGGING_BEFORE_START = 1,
  // 深色模式显示白色，浅色模式显示黑色，回弹动效
  RELEASE_BEFORE_START = 2,
  // 根据亮度值播放动画，深浅模式均显示蓝色
  DRAGGING_BEFORE_SUN = 3,
  // 深色模式显示白色，浅色模式显示黑色
  RELEASE_BEFORE_SUN = 4,
  // 根据亮度值播放动画，显示蓝色
  DRAGGING_AFTER_SUN = 5,
  // 显示黑色
  RELEASE_AFTER_SUN = 6,
  // 根据超出范围播放动画，显示蓝色
  DRAGGING_AFTER_END = 7,
  // 显示黑色，回弹动效
  RELEASE_AFTER_END = 8,
}

const DELAY_TIME = 50;
const LOW_VOLUME_SEGMENT = 1 / 3;
const HIGH_VOLUME_SEGMENT = 2 / 3;
const SOUND_ENABLE_KEY = 'is_volume_adjust_sound_enabled';
const IS_SOUND_ENABLE: string = '1';
const VOLUME_WIDTH: number = 312;

/**
 * 横竖屏状态两个亮度条共享的数据
 */
export class VolumeSharedViewData {
  private animViewData: VolumeAnimViewData = new VolumeAnimViewData();
  private draggingViewData: VolumeDraggingViewData = new VolumeDraggingViewData();
  private backgroundOpacity: BackgroundOpacity = new BackgroundOpacity();
  private blurOpacity: BlurOpacity = new BlurOpacity();

  public getAnimViewData(): VolumeAnimViewData {
    return this.animViewData;
  }

  public getDraggingViewData(): VolumeDraggingViewData {
    return this.draggingViewData;
  }

  public getBackgroundOpacity(): BackgroundOpacity {
    return this.backgroundOpacity;
  }

  public getBlurOpacity(): BlurOpacity {
    return this.blurOpacity;
  }

  public static getInstance(): VolumeSharedViewData {
    return SingletonHelper.getInstance(VolumeSharedViewData, 'VolumeSharedData');
  }
}

export class VolumeViewModel {
  private readonly INVERT_COLOR_START: number = 25; // vp
  private readonly VOLUME_WIDTH: number =
    ControlCenterPluginMgr.isPcMode ? VOLUME_WIDTH : ResUtils.getConvertNumber($r('app.float.Control_center_brightness_width')); //vp
  // 音量条图标可点击热区宽度
  private readonly VOLUME_ICON_WIDTH: number = 27; //vp
  private readonly START_FRAME_INDEX: number = 61; // frame
  private readonly END_FRAME_INDEX: number = 300; // frame
  private readonly TOTAL_FRAMES: number = 360; // frame
  // 颜色过渡动画的帧数
  private readonly COLOR_TRANSITION_FRAMES_SHORT: number = 5;
  // 回滚动画速度
  private readonly SCROLL_SPEED: number = 3;
  public mainCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(new RenderingContextSettings(true));
  private lottieName: string = 'CCVolumeSunIcon';
  private isPc: boolean = DeviceHelper.isPC();
  private isHad: boolean = DeviceHelper.isHAD();
  private style: ControlCenterQuickToggleLayoutStyle = StyleConfiguration.getControlCenterQuickToggleLayoutStyle();
  private isPanelDismissing: boolean = false;
  private animationItem: AnimationItem | undefined = undefined;
  private volumeStatus: VolumeStatus = VolumeStatus.DEFAULT;
  private lastX: number = 0;
  private lastEndPositionX: number = 0;
  private colorTranslatorIntervalId: number = -1;
  private physicsValue: number = 0;
  private eventMgr: EventManager | undefined = undefined;
  private currentEndPositionX: number = 0;
  private viewData: VolumeViewData = new VolumeViewData();
  private animViewData: VolumeAnimViewData = VolumeSharedViewData.getInstance().getAnimViewData();
  private draggingViewData: VolumeDraggingViewData = VolumeSharedViewData.getInstance().getDraggingViewData();
  private backgroundOpacity: BackgroundOpacity = VolumeSharedViewData.getInstance().getBackgroundOpacity();
  private blurOpacity: BlurOpacity = VolumeSharedViewData.getInstance().getBlurOpacity();
  private timeId: number = -1;
  private isCanvasReady: boolean = false;
  private loadCount: number = 0;
  private lastLoadTime: number = 0;
  private colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(this).resourceManager);
  // 音量参数
  private isStart: boolean = false;
  private audioPlayerHelper: AudioPlayerHelper | null = null;
  private maxVolume: SubscribedAbstractProperty<number>;
  private minVolume: number;
  private currentVolumeValue: SubscribedAbstractProperty<number>;
  private isMute: SubscribedAbstractProperty<boolean>;
  //
  private currentAudioVolumeType: number = audio.AudioVolumeType.MEDIA;
  private currentAudioVolume: number = 0;
  //
  private volumeBeforeMute: number = 0;
  private timer: number | null = null;
  private sliderValue: number = -1;
  private offsetXOfPrevious: number = 0;
  private isMouseScroll: boolean = false;
  private localXOfVolumeIconTouchDown: number = 0;
  private model: AudioSoundModel = AudioSoundModel.getInstance();

  constructor() {
    this.maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_VOLUME_KEY, Constants.DEFAULT_MAX_VOLUME);
    this.minVolume = Constants.DEFAULT_MIN_VOLUME;
    this.currentVolumeValue =
      AppStorage.setAndLink(VOLUME_PANEL_CURRENT_VOLUME_VALUE_KEY, Constants.DEFAULT_MIN_VOLUME);
    this.isMute = AppStorage.setAndLink(VOLUME_PANEL_IS_MUTE_KEY, Constants.DEFAULT_MUTE_STATUS);

  }

  public aboutToAppear(isLandscapeVolume: boolean, physicsValue: number) {
    log.showInfo(`aboutToAppear: landscape:${isLandscapeVolume}`);
    // view model init
    this.initViewModel();
    this.lottieName = this.lottieName + isLandscapeVolume;
    this.physicsValue = physicsValue;
    this.viewData.volumeUIValue = this.countUIValue();
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.viewData.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
    this.eventMgr.on(DarkModeEvent, (event: DarkModeEvent) => {
      this.handleDarkModeEvent(event);
    });
    VolumePanelService.registerListener(this);
    ViewManagerPolicy.registerViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
    this.eventMgr.on(ThemeChangeEvent, () => {
      this.refreshSun();
    });
    let context = (GlobalContext.getInstance().getObject('desktopContext') as common.Context);
    if (!this.audioPlayerHelper) {
      this.audioPlayerHelper = new AudioPlayerHelper(context);
    }
  }

  public initViewModel(): void {
    if (this.isStart) {
      return;
    }
    log.showInfo('initViewModel');
    AppStorage.setOrCreate('lastVolume', -1);
    this.isStart = true;
  }

  public updateVolumeInfo(volumeInfo: VolumeInfo): void {
    log.showDebug(`updateVolumeInfo, volumeInfo: ${JSON.stringify(volumeInfo)} `);
    log.showDebug(`updateVolumeInfo, currentAudioVolumeType: ${this.currentAudioVolumeType} `);
    if (!this.updateUi(volumeInfo)) {
      return;
    }

    this.currentAudioVolume = volumeInfo.volume;
    log.showDebug(`updateVolumeInfo, currentAudioVolume: ${this.currentAudioVolume} `);
    log.showDebug(`updateVolumeInfo, currentAudioVolumeType: ${this.currentAudioVolumeType} `);
    log.showDebug(`updateVolumeInfo, isMute: ${this.isMute.get()} `);
    log.showDebug(`updateVolumeInfo, maxVolume: ${this.maxVolume.get()} `);
    log.showDebug(`updateVolumeInfo, minVolume: ${this.minVolume} `);

    let isMute = this.adjustMuteState(volumeInfo);
    if (!isMute) {
      this.volumeBeforeMute = volumeInfo.volume;
    }
    log.showDebug(`updateVolumeInfo, ajust mute: ${isMute} `);
    log.showDebug(`updateVolumeInfo, volumeBeforeMute: ${this.volumeBeforeMute} `);

    this.updateDisplayVolume(isMute ? this.minVolume : volumeInfo.volume, this.maxVolume.get(),
      this.minVolume);
  }

  private updateUi(volumeInfo: VolumeInfo): boolean {
    if (volumeInfo.volumeType !== audio.AudioVolumeType.VOICE_CALL &&
      volumeInfo.volumeType !== audio.AudioVolumeType.MEDIA) {
      return false;
    }
    return true;
  }

  private adjustMuteState(volumeInfo: VolumeInfo): boolean {
    if (this.minVolume === this.currentAudioVolume) {
      return true;
    }
    return volumeInfo.isMute;
  }

  private updateDisplayVolume(volume: number, maxVolume: number, minVolume: number): void {
    log.showDebug(`updateDisplayVolume, volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    let displayVolume: number = volume;
    this.currentVolumeValue.set(displayVolume);
    log.showDebug(`updateDisplayVolume, mCurrentVolumeValue: ${this.currentVolumeValue.get()}`);
  }

  public aboutToDisappear() {
    log.showInfo(`aboutToDisappear: ${this.lottieName}`);
    this.endDraggingWithNoAnim();
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
    ViewManagerPolicy.unRegisterViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
  }

  public getViewData(): VolumeViewData {
    return this.viewData;
  }

  public handleOnHover(isHover?: boolean): void {
    if (isHover === undefined) {
      return;
    }
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.viewData.isHover = isHover;
      this.viewData.animateScale = isHover ? this.isHad ? HoverConstants.HAD_HOVER_BRIGHTNESS_SCALE :
      HoverConstants.HOVER_BRIGHTNESS_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
    });
  }

  public handleOnTouch(event?: TouchEvent): void {
    if (!this.isPc) {
      if (event?.type == TouchType.Move && this.draggingViewData.isDragging === true && event?.stopPropagation) {
        event?.stopPropagation();
      }
      return;
    }
    if (event?.type === TouchType.Move) {
      return;
    }
    if (this.draggingViewData.isDragging) {
      return;
    }
    //Down的时候更新
    if (event?.type === TouchType.Down && event.touches.length > 0) {
      // PC音量条交互逻辑
      animateTo({
        curve: Curve.EaseInOut,
        tempo: 7
      }, () => {
        this.viewData.volumeUIValue = RTLUtil.isRTL() ?
          this.VOLUME_WIDTH - event!.touches[event.touches.length - 1].x : event!.touches[event.touches.length - 1].x;
      })
      let volumeValue = this.countPhysicsValue(this.viewData.volumeUIValue, `Touch`);
      // 点击区域在图标上, 非静音场景下先设置音量为静音, 静音场景下正常调节音量
      if (this.physicsValue !== this.minVolume && this.isTouchToVolumeIcon(event)) {
        log.showInfo(`set mute`);
        volumeValue = this.minVolume;
        // 记录此时的点击坐标
        this.localXOfVolumeIconTouchDown = this.viewData.volumeUIValue;
      }
      this.updateVolume(volumeValue, true, 'handleOnTouch');
      this.physicsValue = volumeValue;
    } else if (event?.type === TouchType.Up) {
      const isCommunicationNow: boolean = this.model.isCommunicationNow();
      if (isCommunicationNow && this.viewData.volumeUIValue < this.getMinUIValue()) {
        this.viewData.volumeUIValue = this.getMinUIValue();
      }
      this.localXOfVolumeIconTouchDown = 0;
      let isSoundEnabled: string = SettingsUtil.getSystemValue(SOUND_ENABLE_KEY, IS_SOUND_ENABLE);
      if (isSoundEnabled === IS_SOUND_ENABLE) {
        (this.audioPlayerHelper as AudioPlayerHelper).playAudioOnce();
      }
    }
  }

  /**
   * 判断点击亮度条点击区域是否在音量图标上
   */
  private isTouchToVolumeIcon(event?: TouchEvent): boolean {
    let clickPositionX = RTLUtil.isRTL() ? this.VOLUME_WIDTH - event!.touches[0].x : event!.touches[0].x;
    if (clickPositionX >= 0 && clickPositionX <= this.VOLUME_ICON_WIDTH) {
      return true;
    }
    return false;
  }

  public onPanActionStart(event: GestureEvent) {
    this.isPanelDismissing = DropDownPanelManager.isPanelDismissing();

    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }

    log.showInfo('onActionStart');

    if (!this.draggingViewData.isDragging) {
      this.draggingViewData.isDragging = true;
    }

    if (this.localXOfVolumeIconTouchDown !== 0) {
      this.viewData.volumeUIValue = this.localXOfVolumeIconTouchDown;
      this.localXOfVolumeIconTouchDown = 0;
    }
    this.currentEndPositionX = this.viewData.volumeUIValue;
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    this.timeId = setTimeout(() => {
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
      log.showInfo('start hide CC mainLayout');
      this.blurOpacity.blurOpacity = 0;
      this.viewData.showBlurLayer = true;
      animateTo({
        curve: curves.responsiveSpringMotion(0.28, 1, 0),
        onFinish: () => {
        }
      }, () => {
        this.animViewData.scaleX = 1.05;
      })

      animateTo({
        curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
        duration: 150,
      }, () => {
        this.backgroundOpacity.backgroundOpacity = 0;
        this.animViewData.shadowRadius = 40;
      })

      this.timeId = -1;
    }, 100);
    this.lastX = (RTLUtil.isRTL() ? this.VOLUME_WIDTH - event?.offsetX : event?.offsetX) ?? 0;
    this.lastEndPositionX = 0;
    // 鼠标滚轮逻辑
    if (event?.offsetX !== 0 && event?.axisVertical !== 0 && event?.axisHorizontal === 0) {
      log.showInfo('mouse scroll event start');
      this.offsetXOfPrevious = 0;
      this.isMouseScroll = true;
    }
  }

  public onPanActionUpdate(event: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionUpdate, not dragging, return');
      return;
    }
    let moveDistance = (RTLUtil.isRTL() ? this.VOLUME_WIDTH - event?.offsetX : event?.offsetX) - this.lastX;
    if (this.isMouseScroll) {
      moveDistance = this.adjustVolumeWithMouseScroll(event);
    }
    if (Math.abs(moveDistance - 0) < Number.EPSILON) {
      return;
    }
    this.lastX = RTLUtil.isRTL() ? this.VOLUME_WIDTH - event?.offsetX : event?.offsetX;
    // 鼠标滚轮调节音量时，currentEndPositionX的值不能超出最大值或最小值
    if (this.isMouseScroll) {
      this.currentEndPositionX += moveDistance;
      this.offsetXOfPrevious = event?.offsetX;
      this.currentEndPositionX = parseFloat(Math.min(
        Math.max(this.currentEndPositionX, 0),
        this.VOLUME_WIDTH).toFixed(1));
    } else {
      let dis = event?.offsetX - this.lastEndPositionX;
      this.currentEndPositionX = RTLUtil.isRTL() ? this.currentEndPositionX - dis :
        this.currentEndPositionX + dis;
    }
    this.lastEndPositionX = event?.offsetX;
    this.onCurrentEndPositionXChange();
  }

  public onPanActionEnd(event: GestureEvent) {
    log.showInfo('touch cancel');
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionEnd, not dragging, return');
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    const isCommunicationNow: boolean = this.model.isCommunicationNow();
    log.showInfo(`lscslsc : ${isCommunicationNow}, ${this.viewData.volumeUIValue}， ${this.getMinUIValue()}`);
    if (isCommunicationNow && this.viewData.volumeUIValue < this.getMinUIValue()) {
      this.viewData.volumeUIValue = this.getMinUIValue();
    }
    let physicsValue = this.countPhysicsValue(this.viewData.volumeUIValue, `panActionEnd`);
    log.showDebug(`onActionEnd, UI value: ${this.viewData.volumeUIValue}, physicsValue: ${physicsValue}`);
    this.updateVolume(physicsValue, false, 'onPanActionEnd');
    this.draggingViewData.isDragging = false;
    if (this.timeId !== -1) {
      clearTimeout(this.timeId);
    } else {
      log.showInfo('start show CC mainLayout');
      this.blurOpacity.blurOpacity = 1;

      this.doEndAnim();
    }
    let isSoundEnabled: string = SettingsUtil.getSystemValue(SOUND_ENABLE_KEY, IS_SOUND_ENABLE);
    if (isSoundEnabled === IS_SOUND_ENABLE) {
      (this.audioPlayerHelper as AudioPlayerHelper).playAudioOnce();
    }
    this.offsetXOfPrevious = 0;
    this.isMouseScroll = false;
  }

  private doEndAnim() {
    animateTo({
      curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
      duration: 100,
    }, () => {
      this.backgroundOpacity.backgroundOpacity = 1;
      this.animViewData.shadowRadius = 0;
    });
    animateTo({
      curve: curves.responsiveSpringMotion(0.28, 1, 0)
    }, () => {
      this.animViewData.scaleX = 1;
    });

    animateTo({
      curve: Curve.Sharp,
      duration: 150,
      delay: 100,
      onFinish: () => {
        if (!this.draggingViewData.isDragging) {
          this.viewData.showBlurLayer = false;
          this.animViewData.volumeBlurOpacity = 1;
          AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
          AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
        }
      }
    }, () => {
      this.animViewData.volumeBlurOpacity = 0;
    });
  }

  /**
   * PanGesture手势拖拽过程中，鼠标右键会中断这个过程，导致 onActionEnd 不触发，但会触发 onActionCancel 事件；
   * 在 onActionCancel 中将状态变量复位；
   */
  public onPanActionCancel() {
    log.showInfo('onPanActionCancel');
    if (this.draggingViewData.isDragging || this.viewData.showBlurLayer) {
      this.viewData.volumeUIValue = this.countUIValue();
      this.draggingViewData.isDragging = false;
      this.viewData.showBlurLayer = false;
    }
  }

  public onLayoutChange() {
    log.showInfo('onLayoutChange');
    this.endDraggingWithNoAnim();
  }

  public updatePhysicsValue(physicsValue: number, minValue: number) {
    this.minVolume = minValue;
    if (physicsValue === this.countPhysicsValue(this.viewData.volumeUIValue, `physicsValueChange`)) {
      log.showInfo('volume is no changed');
      return;
    }
    this.physicsValue = physicsValue;
    log.showInfo(`updatePhysicsValue to: ${this.physicsValue}, current ui value is ${this.viewData.volumeUIValue}`);
    // 音量条拖动过程中不响应回调，避免拖动中音量条进度和实际物理回调音量值不同导致的突变
    if (this.viewData.showBlurLayer === false || !this.draggingViewData.isDragging) {
      animateTo({
        curve: curves.responsiveSpringMotion(0.28, 0.97, 0)
      }, () => {
        // 响应物理回调时更新存储下发音量的value
        this.sliderValue = physicsValue;
        this.viewData.volumeUIValue = this.countUIValue();
      })
      log.showInfo(`updatePhysicsValue, ui value change to: ${this.viewData.volumeUIValue}`);
      this.refreshSun();
    }
  }

  public onDraggingStop() {
    log.showDebug('onDraggingStop');
    if (this.draggingViewData.isDragging === false) {
      let currentEndPositionX = this.currentEndPositionX;
      this.refreshSunAnimWhenRelease(currentEndPositionX);
    }
  }

  public onCanvasReady() {
    this.isCanvasReady = true;
    this.reloadAnim();
    log.showInfo('onCanvasReady, get total frames: ' + this.animationItem?.totalFrames);
  }

  public onCanvasDisappear() {
    log.showInfo(`canvas disappear: ${this.lottieName}`);
    this.isCanvasReady = false;
    lottie.destroy(this.lottieName);
    this.endDraggingWithNoAnim();
  }

  /**
   * 通过方向键调节音量
   */
  public adjustVolumeWithArrowKey(value: number) {
    log.showInfo(`adjustVolumeWithArrowKey`);
    if (RTLUtil.isRTL()) {
      value = -value;
    }
    if (this.physicsValue + value < this.minVolume) {
      log.showWarn('it is currently the minimum volume, physicsValue: ' + this.physicsValue);
      return;
    }
    if (this.physicsValue + value > this.maxVolume.get()) {
      log.showWarn('it is currently the maximum volume, physicsValue: ' + this.physicsValue);
      return;
    }
    this.physicsValue = this.physicsValue + value;
    this.viewData.volumeUIValue = this.countUIValue();
    this.updateVolume(this.countPhysicsValue(this.viewData.volumeUIValue, `ArrowKey`),
      true, 'adjustVolumeWithArrowKey');
  }

  public playAudioOnce() {
    let isSoundEnabled: string = SettingsUtil.getSystemValue(SOUND_ENABLE_KEY, IS_SOUND_ENABLE);
    if (isSoundEnabled === IS_SOUND_ENABLE) {
      (this.audioPlayerHelper as AudioPlayerHelper).playAudioOnce();
    }
  }

  /**
   * 通过鼠标滚轮调节音量
   */
  private adjustVolumeWithMouseScroll(event: GestureEvent): number {
    let range = this.getVolumeRange();
    let isMouseScrollToUp: boolean = (event?.offsetX - this.offsetXOfPrevious) >= 0;
    return (isMouseScrollToUp ? (this.VOLUME_WIDTH / range) : -(this.VOLUME_WIDTH / range));
  }

  private endDraggingWithNoAnim() {
    if (this.draggingViewData.isDragging) {
      this.backgroundOpacity.backgroundOpacity = 1;
      this.blurOpacity.blurOpacity = 1;
      this.animViewData.shadowRadius = 0;
      this.animViewData.scaleX = 1;
      this.draggingViewData.isDragging = false;
      this.viewData.showBlurLayer = false;
      this.animViewData.volumeBlurOpacity = 1;
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
      let physicsValue = this.countPhysicsValue(this.viewData.volumeUIValue, `endDragging`);
      log.showDebug(`endDraggingWithNoAnim: physicsValue: ${physicsValue}, volumeUIValue: ${this.viewData.volumeUIValue}`);
      // 将亮度值写入数据库
      this.updateVolume(physicsValue, false, 'endDraggingWithNoAnim');
    }
  }

  private onCurrentEndPositionXChange() {
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onCurrentEndPositionXChange,but not dragging, return');
      return;
    }
    animateTo({
      curve: curves.responsiveSpringMotion(0.1, 1, 0)
    }, () => {
      this.viewData.volumeUIValue = Math.min(
        Math.max(this.currentEndPositionX, 0),
        this.VOLUME_WIDTH);
    })
    let physicsValue = this.countPhysicsValue(this.viewData.volumeUIValue, `panGestureUpdate`);
    this.physicsValue = physicsValue;
    this.updateVolume(physicsValue, true, 'onCurrentEndPositionXChange');
  }

  private getVolumeRange(): number {
    return this.maxVolume.get() - this.minVolume;
  }

  private countUIValue(): number {
    let range = this.getVolumeRange();
    let percentage = (this.physicsValue - this.minVolume) / range;
    let volumeUI = this.VOLUME_WIDTH * percentage;
    log.showInfo(`phsics value:${this.physicsValue};countUIValue percentage:${percentage};ui value:${volumeUI}`);
    return volumeUI;
  }

  private getMinUIValue(): number {
    let range = this.getVolumeRange();
    let percentage = this.minVolume / range;
    let volumeUI = this.VOLUME_WIDTH * percentage;
    log.showInfo(`minVolume:${this.minVolume};countMinUIValue percentage:${percentage};MinUIValue value:${volumeUI}`);
    return volumeUI;
  }

  private countPhysicsValue(uiVar: number, tag: string): number {
    let range = this.getVolumeRange();
    if (this.VOLUME_WIDTH <= 0 || range <= 0) {
        return 0;
    }
    let volume = uiVar / this.VOLUME_WIDTH * range + this.minVolume;
    // 解决取整问题：静音但仍显示有音量，音量已达最大值，控制中心显示音量未达最大值
    if (volume < range * LOW_VOLUME_SEGMENT) {
      volume = Math.ceil(volume);
    } else if (volume > range * HIGH_VOLUME_SEGMENT) {
      volume = Math.floor(volume);
    } else {
      volume = Math.round(volume);
    }
    if (volume > this.maxVolume.get()) {
      volume = this.maxVolume.get();
    } else if (volume < this.minVolume) {
      volume = this.minVolume;
    }
    log.showInfo(`count volume value according to ui value: ${volume};range: ${range};tag: ${tag};minVolume: ${this.minVolume}`);
    return Math.round(volume);
  }

  private refreshSunAnimWhenRelease(currentEndPositionX: number) {
    if (currentEndPositionX < 0) {
      this.scrollBeforeSun();
    } else if (currentEndPositionX < this.INVERT_COLOR_START && currentEndPositionX >= 0) {
      this.volumeStatus = VolumeStatus.RELEASE_BEFORE_SUN;
      let colorMode = GlobalContext.getContext().config.colorMode as number;
      if (colorMode === 0) {
        this.transitColor($r('app.color.control_center_brightness_sun_blue'),
          $r('app.color.control_center_brightness_sun_write'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      } else {
        this.transitColor($r('app.color.control_center_brightness_sun_blue'),
          $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      }
      this.playCurrentFrame(currentEndPositionX);
    } else if (currentEndPositionX >= this.INVERT_COLOR_START && currentEndPositionX <= this.VOLUME_WIDTH) {
      if (this.volumeStatus === VolumeStatus.DRAGGING_AFTER_SUN ||
        this.volumeStatus === VolumeStatus.DRAGGING_BEFORE_SUN) {
        this.transitColor($r('app.color.control_center_brightness_sun_blue'),
          $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      }
      this.volumeStatus = VolumeStatus.RELEASE_AFTER_SUN;
      this.playCurrentFrame(currentEndPositionX);
    } else if (currentEndPositionX > this.VOLUME_WIDTH) {
      this.scrollAfterSun();
    }
  }

  private scrollAfterSun() {
    this.volumeStatus = VolumeStatus.RELEASE_AFTER_END;
    let currentFrame = this.animationItem?.currentFrame as number;
    let totalFrame = currentFrame - this.END_FRAME_INDEX;
    if (this.SCROLL_SPEED > totalFrame) {
      log.showInfo('scrollAfterSun, not enough for scroll, return');
      this.transitColor($r('app.color.control_center_brightness_sun_blue'),
        $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      return;
    }

    let count = 0;
    if (this.colorTranslatorIntervalId !== -1) {
      clearInterval(this.colorTranslatorIntervalId);
    }
    const intervalId = setInterval(() => {
      count += this.SCROLL_SPEED;
      if (count > totalFrame) {
        this.colorTranslatorIntervalId = -1;
        clearInterval(intervalId); // 停止计时器
        return;
      }
      let colorXArr = this.getTransitionColorArr(
        this.colorTool.getArrayColor($r('app.color.control_center_brightness_sun_blue')),
        this.colorTool.getArrayColor($r('app.color.control_center_brightness_sun_black')), count, totalFrame);
      this.animationItem?.changeColor(colorXArr);
      this.animationItem?.goToAndStop(currentFrame - this.SCROLL_SPEED, true);
      currentFrame -= this.SCROLL_SPEED;
    }, 0);
    this.colorTranslatorIntervalId = intervalId;
  }

  private scrollBeforeSun() {
    this.volumeStatus = VolumeStatus.RELEASE_BEFORE_START;
    let currentFrame = this.animationItem?.currentFrame as number;
    this.animationItem?.setSpeed(6);
    let colorMode = GlobalContext.getContext().config.colorMode as number;
    if (colorMode === 0) {
      this.transitColor($r('app.color.control_center_brightness_sun_blue'),
        $r('app.color.control_center_brightness_sun_write'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
    } else {
      this.transitColor($r('app.color.control_center_brightness_sun_blue'),
        $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
    }
    // 当playSegments起点和终点一致的时候会播放整段动画
    if (currentFrame === this.START_FRAME_INDEX) {
      return;
    }
    this.animationItem?.playSegments([currentFrame, this.START_FRAME_INDEX], true);
  }

  private handleDarkModeEvent(event: DarkModeEvent) {
    let color = $r('app.color.Control_center_brightness_icon_color');
    if ((this.viewData.volumeUIValue <= this.INVERT_COLOR_START) && event.isDarkMode) {
      color = $r('app.color.control_center_brightness_sun_write');
    } else {
      color = $r('app.color.control_center_brightness_sun_black');
    }
    this.animationItem?.changeColor(this.colorTool.getArrayColor(color));
    this.playCurrentFrame(this.viewData.volumeUIValue);
  }

  private refreshSun() {
    if (this.animationItem == null) {
      log.showInfo('refresh sun but lottie is null, reload');
      this.reloadAnim();
      return;
    }
    let colorMode: number = GlobalContext.getContext().config.colorMode as number;
    log.showInfo(`refreshSun, brightnessUIValue: ${this.viewData.volumeUIValue}`);
    let color = $r('app.color.control_center_brightness_sun_black');
    if ((this.viewData.volumeUIValue <= this.INVERT_COLOR_START) && (colorMode === 0)) {
      color = $r('app.color.control_center_brightness_sun_write');
    } else {
      color = $r('app.color.control_center_brightness_sun_black');
    }
    this.animationItem?.changeColor(this.colorTool.getArrayColor(color));
    this.playCurrentFrame(this.viewData.volumeUIValue);
  }

  // 根据currentLoc播放指定帧
  private playCurrentFrame(currentEndPositionX: number): number {
    currentEndPositionX = Math.ceil(currentEndPositionX);
    let isOver: boolean = !(currentEndPositionX >= 0 && currentEndPositionX <= this.VOLUME_WIDTH);
    let result: number = 0;
    // 超出亮度条范围
    if (isOver) {
      if (currentEndPositionX < 0) {
        result = this.START_FRAME_INDEX -
          Math.abs(currentEndPositionX) *
          this.getFramesPerVpWhenBeforeSun(currentEndPositionX);
      } else {
        result = this.END_FRAME_INDEX +
          (currentEndPositionX - this.VOLUME_WIDTH) *
          this.getFramesPerVpWhenOverSun(currentEndPositionX);
      }
    } else {
      // 在亮度条范围内
      result = this.START_FRAME_INDEX + currentEndPositionX * this.getFramesPerVp();
    }
    if (result < 0) {
      result = 0;
    } else if (result > this.TOTAL_FRAMES) {
      result = this.TOTAL_FRAMES;
    }
    this.animationItem?.goToAndStop(result, true);
    return result;
  }

  private getFramesPerVp(): number {
    return (this.END_FRAME_INDEX - this.START_FRAME_INDEX + 1) / this.VOLUME_WIDTH;
  }

  // 超出亮度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenBeforeSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((0 - currentLoc) / 500));
    return frames;
  }

  // 超出亮度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenOverSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((currentLoc - this.VOLUME_WIDTH) / 500));
    return frames;
  }

  /**
   * 传入帧的序号，获取中间的过渡颜色
   *
   * @param start 开始颜色
   * @param end 结束颜色
   * @param index 帧序号
   * @param frames 总共帧数
   */
  private getTransitionColorArr(start: number[], end: number[], index: number, frames: number): number[] {
    let r1: number = start[0];
    let g1: number = start[1];
    let b1: number = start[2];
    let r2: number = end[0];
    let g2: number = end[1];
    let b2: number = end[2];
    let a2: number = end[3];
    let rDiff: number = r2 - r1;
    let gDiff: number = g2 - g1;
    let bDiff: number = b2 - b1;
    let coefficient: number = curves.initCurve(Curve.Linear).interpolate(index / frames);
    let r3 = Math.ceil(r1 + rDiff * coefficient);
    let g3 = Math.ceil(g1 + gDiff * coefficient);
    let b3 = Math.ceil(b1 + bDiff * coefficient);
    let transitionColor: number[] = [r3, g3, b3, a2];
    return transitionColor;
  }

  /**
   * 使用指定曲线使得当前帧的颜色从startR过渡到endR
   *
   * @param startR
   * @param endR
   * @param frames
   * @param curve
   */
  private transitColor(startR: Resource, endR: Resource, frames: number, curve: Curve = Curve.Sharp): void {
    if (startR == null || endR == null) {
      log.showDebug('param is invalid, not deal');
      return;
    }
    if (startR == endR) {
      log.showDebug('color is same, not deal');
      return;
    }
    // 如果之前的颜色过渡动画未完成，就停止，直接开始下一轮的颜色过渡动画，避免中间出现错误颜色
    if (this.colorTranslatorIntervalId !== -1) {
      clearInterval(this.colorTranslatorIntervalId);
    }
    let start = this.colorTool.getArrayColor(startR);
    let end = this.colorTool.getArrayColor(endR);
    let r1: number = start[0];
    let g1: number = start[1];
    let b1: number = start[2];
    let r2: number = end[0];
    let g2: number = end[1];
    let b2: number = end[2];
    let a2: number = end[3];
    let rDiff: number = r2 - r1;
    let gDiff: number = g2 - g1;
    let bDiff: number = b2 - b1;
    let interpolator = curves.initCurve(curve);

    let count = 0;
    const intervalId = setInterval(() => {
      count++;
      if (count > frames) {
        this.colorTranslatorIntervalId = -1;
        clearInterval(intervalId); // 停止计时器
        return;
      }
      let coefficient: number = interpolator.interpolate(count / frames);
      let r3 = Math.ceil(r1 + rDiff * coefficient);
      let g3 = Math.ceil(g1 + gDiff * coefficient);
      let b3 = Math.ceil(b1 + bDiff * coefficient);
      let transitionColor: number[] = [r3, g3, b3, a2];
      this.animationItem?.changeColor(transitionColor);
      this.animationItem?.goToAndStop(this.animationItem?.currentFrame, true);
    }, 0);
    this.colorTranslatorIntervalId = intervalId;
  }

  private dropDownCallback: ViewCallback = {
    onHide: (): void => {
      log.showInfo('dropDown onHide');
      // 控制中心收起之后参数复原
      this.endDraggingWithNoAnim();
    }
  }

  private reloadAnim() {
    const now: number = Date.now();
    if (now - this.lastLoadTime < 1000) {
      this.loadCount++;
      if (this.loadCount >= 10) {
        log.showInfo('into dead loop')
        return;
      }
    } else {
      this.lastLoadTime = now;
      this.loadCount = 0;
    }
    let lottieData: object | null = sVolumeController.matchLottieData(false);
    if (lottieData == null) {
      log.showInfo('sunLottieData is null, return');
      return;
    }
    if (this.isCanvasReady === false) {
      log.showInfo('canvas is not ready, return');
      return;
    }
    if (this.animationItem?.isLoaded) {
      log.showInfo('lottie has been loaded, return');
      this.refreshSun();
      return;
    }
    this.animationItem = lottie.loadAnimation({
      container: this.mainCanvasRenderingContext, // 渲染上下文
      renderer: 'canvas', // 渲染方式
      loop: false, // 是否循环播放,默认true
      autoplay: false, // 是否自动播放，默认true
      packageName: 'com.controlCenter',
      name: this.lottieName,
      animationData: lottieData// 播放的动画json数据
    })
    this.animationItem.addEventListener('DOMLoaded', (args: Object): void => {
      log.showInfo(`addEventListener DOMLoaded, ${this.animationItem?.name}`);
      this.refreshSun();
    })
    this.animationItem.addEventListener('destroy', (args: Object): void => {
      log.showInfo(`addEventListener destroy, ${this.animationItem?.name}`);
      this.animationItem = undefined;
      this.reloadAnim();
    })
  }

  public updateVolume(volume: number, isDragging: boolean, tag?: string): void {
    log.showInfo(`updateVolume tag: ${tag}`)
    this.throttleSetVolume(volume);
    if (!isDragging) {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_change_brightness'),
        `${this.getAccessibilityVolumeValue(volume)}%}`));
    }
  }

  throttleSetVolume(value: number): void {
    this.sliderValue = value;
    if (!this.timer) {
      this.timer = setTimeout(() => {
        this.setVolume(this.sliderValue);
        clearTimeout(this.timer);
        this.timer = null;
      }, DELAY_TIME);
    }
  }

  setVolume(volume: number): void {
    let lastVolume: number | undefined = AppStorage.get('lastVolume');
    if (lastVolume && volume === lastVolume) {
      log.showDebug('equal volume');
      return;
    }
    log.showInfo(`setVolume, displayVolume: ${volume} `);
    AppStorage.set('lastVolume', volume);
    AudioSoundViewModel.getInstance().setOutputVolume(volume, TAG);
  }

  private notifyVolumeChange(volumeInfo: VolumeInfo): void {
    log.showInfo(`notifyVolumeChange, volumeInfo: ${JSON.stringify(volumeInfo)}`);
    sEventManager.publish(obtainLocalEvent(VOLUME_CHANGE_EVENT, volumeInfo));
  }

  public getAccessibilityVolumeValue(volume: number): string {
    if (this.getVolumeRange() <= 0) {
      return volume.toFixed(0);
    }
    return ((volume - this.minVolume) / this.getVolumeRange() * 100).toFixed(0);
  }

  public handleLabelClick(): boolean {
    // pc点击文字弹出二级窗口，并关闭控制中心面板
    sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, false));
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    // 设置二级页面窗口位置
    let position = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_SOUND_PANEL);
    if (StatusBarType.isMacStyle(AppStorage.get('statusBarType') as number)) {
      let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      position.left = controlCenterPosition.left + controlCenterPosition.width - position.width;
    }
    EvtBus.post(WindowPositionChangeEvent,
      { windowName: PluginSlot.SLOT_STATUS_SOUND_PANEL,
        position: PluginPosition.POSITION_RIGHT,
        area: position,
        caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER});
    let info = AppStorage.get<PluginInfo>(PluginSlot.SLOT_STATUS_SOUND_PANEL + '_info');
    windowMgr.setWindowData(PluginSlot.SLOT_STATUS_SOUND_PANEL, info);
    windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_SOUND_PANEL, true);
    sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, true));
    return true;
  }
}

let volumeViewModel = new VolumeViewModel();

export default volumeViewModel as VolumeViewModel;