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

import {
  LogDomain,
  Trace,
  TraceUtil,
  DomainName,
  LogHelper,
} from '@ohos/basicutils';
import { sEventManager, ViewType } from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { RTLUtil } from '@ohos/componenthelper';
import {
  SliderButtonBaseViewModel
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonBaseViewModel';
import {
  SliderButtonAnimViewData,
  SliderButtonViewData,
  SliderIconViewData
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { VolumeConstants, VolumeController } from './VolumnController';
import audio from '@ohos.multimedia.audio';
import { AudioHelper } from '../utils/AudioHelper';
import { IconMap } from '../utils/IconMap';
import SoundReporterController from './SoundReporterController';
import { soundSubPageController } from './SoundSubPageLayoutController';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { AnimationSegment } from '@ohos/lottie';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';

const TAG = 'Ctrl.VolumeButtonViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class VolumeButtonViewModel extends SliderButtonBaseViewModel {
  // 媒体喇叭各个等级关键帧
  public mediaLottieKeyFrames: number[][] = [[0, 29], [104, 140], [179, 214]];
  private readonly speakerWaveZero: number = 0;
  private readonly speakerWaveOne: number = 1;
  private readonly speakerWaveTwo: number = 2;
  private readonly speakerWaveThree: number = 3;
  private readonly accessTextType: string = 'text';
  private readonly accessDesType: string = 'description';
  // 音量ui的等级值，用于喇叭图标切换
  private volumeLevelOne: number = 0;
  private volumeLevelTwo: number = 0;
  private preVolumeValueLevel: number = -1;
  private outputDevice?: audio.AudioDeviceDescriptor;
  // 当前正在生效的音频流类型
  private currentVolumeType: audio.AudioVolumeType = audio.AudioVolumeType.MEDIA;
  // 当前音频流可以调整到的最小值
  private canAdjustMinValue: number = 0;
  private appearTimestamp: number = Date.now();
  public modelTag: string = TAG;

  constructor(viewData: SliderButtonViewData, animData: SliderButtonAnimViewData,
    iconViewData: SliderIconViewData, logTag: string) {
    iconViewData.startFrameIndex = 1;
    iconViewData.endFrameIndex = 270;
    iconViewData.totalFrames = 270;
    super(viewData, animData, iconViewData, logTag);
    this.modelTag = logTag;
  }

  /**
   * 更新viewModel标识
   */
  public updateTag(newTag: string): void {
    this.modelTag = newTag;
    this.updateLogTag(newTag);
  }

  public aboutToAppear() {
    this.currentVolumeType = VolumeController.getInstance().getCurrentVolumeType();
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.getViewData().sliderWidth : this.getViewData().sliderHeight;
    this.canAdjustMinValue = this.getMaxValue() !== 0 ? sliderLength / this.getMaxValue() : 0;
    super.aboutToAppear();
    this.updateVolumeLevel();
    this.loadLottieData();
    // 如果lottie需要重新刷新和加载，监听lottie加载完毕事件
    sEventManager.subscribe('volumeLottieReady', this.lottieDataReady);
    if (this.getViewData().isExpand) {
      this.getLottieAnimMode().getIconViewData().iconName = $r('app.string.sound_title');
      this.getLottieAnimMode().getIconViewData().subPageIcon = $r('sys.symbol.speaker_wave_3_fill');
      this.executeSubpageAnim(true);
      sEventManager.subscribe('ControlCenterState', this.onControlCenterStateChange);
    }
    let volumePercentage = VolumeController.getInstance().getVolumePercentage();
    if (volumePercentage !== VolumeConstants.DEFAULT_VOLUME_INVALID) {
      // 从二级页回到button刷新ui进度值，防止ui值比例跳变
      const sliderLength: number =
        this.getViewData().isHorizontal ? this.getViewData().sliderWidth : this.getViewData().sliderHeight;
      this.getAnimData().uiValue = volumePercentage * sliderLength;
      log.showInfo(`button reUpdateUiValue: ${this.getAnimData().uiValue} percentage: ${volumePercentage}`);
    }
    try {
      this.outputDevice = AudioHelper.getInstance().getOutputDevice();
      this.updateVolumeIcon(true);
      // 监听音量变化
      VolumeController.getInstance().setVolumeChangeCallback(this.modelTag +
        this.appearTimestamp, this.volumeChangeCallback);
      // 监听设备类型变化
      AudioHelper.getInstance().addOutputDeviceChangeListener(this.modelTag + this.appearTimestamp, {
        onEvent: (outputDevice: audio.AudioDeviceDescriptor) => {
          log.showInfo(`outputDeviceChange: ${outputDevice.displayName}`);
          this.outputDevice = outputDevice;
          // 先刷新进度条
          VolumeController.getInstance().initAllVolumeInfo();
          this.updateVolumeValue();
          // 后刷新图标
          this.updateVolumeIcon(false);
          if (this.getAnimData().useLottieData) {
            this.refreshIcon();
          }
        }
      });
      log.showInfo(`aboutToAppear ${this.modelTag}`);
    } catch (err) {
      log.error(`fail init VolumeController ,err: ${err}`);
    }
  }

  private updateVolumeLevel(): void {
    this.volumeLevelOne = this.getMaxValue() / 3;
    this.volumeLevelTwo = this.getMaxValue() * 2 / 3;
  }

  private volumeChangeCallback = async (value: number, volumeType: audio.AudioVolumeType, needChangeTye: boolean) => {
    // 如果下拉面板不可见，不用更新ui值
    if (!DropDownAdapter.isDropDownShow()) {
      log.showInfo(`volumeChange DROPDOWN not show return, value:${value}`);
      return;
    }
    // 如果出声通道改变更新音量值
    if (this.currentVolumeType !== volumeType && !needChangeTye) {
      log.showInfo(`currentVolumeType is not same, volumeType:${volumeType}`);
      return;
    }
    this.currentVolumeType = volumeType;
    this.onPhysicsValueChange(value);
    if (this.physValUpdateUI) {
      this.saveVolumeUIPercentage();
    }
    // 更新图标
    if (needChangeTye) {
      this.updateVolumeIcon(false);
    }
  }

  /**
   * 进度条拖拽场景改变图标颜色(lottie改色暂时屏蔽)
   *
   * @param isChosen 是否是拖动进度条的高亮状态
   */
  public changeIconColor(isChosen: boolean): void {
    log.showInfo(`changeIconColor volume isChosen: ${isChosen}`)
    // 换肤场景的深色模式在拖动进图条时需要改变颜色
    let isSysColor = AppStorage.get('isSysColor') as boolean;
    let darkColorMode = this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    if (isSysColor || !darkColorMode) {
      return;
    }
    let changeColor = isChosen ? $r('app.color.control_center_brightness_sun_black') :
      $r('app.color.control_center_brightness_sun_write');
    if (!this.getAnimData().useLottieData) {
      this.getAnimData().iconColor = changeColor;
    }
  }

  private lottieDataReady = () => {
    log.showInfo(`subscribe volumeLottieReady ${this.modelTag}`);
    this.loadLottieData();
    this.getLottieAnimMode().onCanvasReady();
  }

  private onControlCenterStateChange = (state: number) => {
    if (state === 0) {
      log.showInfo(`onControlCenterStateChange state ${state}`);
      this.executeSubpageAnim(false);
    }
  }

  public aboutToDisappear() {
    log.showInfo(`aboutToDisappear ${this.modelTag}`);
    super.aboutToDisAppear();
    sEventManager.off('volumeLottieReady', this.lottieDataReady);
    sEventManager.off('ControlCenterState', this.onControlCenterStateChange);
    VolumeController.getInstance().setVolumeChangeCallback(this.modelTag + this.appearTimestamp, undefined);
    AudioHelper.getInstance().removeOutputDeviceChangeListener(this.modelTag + this.appearTimestamp);
  }

  /**
   * 无障碍模式下语音播报内容
   * @param type
   * @returns
   */
  public getAccessibility(type: string): string {
    if (type === this.accessTextType) {
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_volume'),
        `${this.getAccessibilityPhysicsValue()}%`);
    } else if (type === this.accessDesType) {
      let announceDesc = ResUtils.getInnerString(this.getViewData().isHorizontal ?
      $r('app.string.cc_accessibility_str_change_volume_desc') :
      $r('app.string.cc_accessibility_str_change_vertical_volume_desc'));
      if (!this.getViewData().isExpand && !this.getViewData().isSingleFoldStyle) {
        announceDesc += ' ' + ResUtils.getInnerString($r('app.string.cc_accessibility_str_long_click'));
      }
      return announceDesc;
    } else {
      return '';
    }
  }

  /**
   * 加载lottie动画数据
   * @returns 是否加载成功
   */
  public loadLottieData(): boolean {
    let lottieData = VolumeController.getInstance().lottieData;
    log.showInfo(`loadLottieData, lottieData is null: ${lottieData === null}, modelTag:${this.modelTag}`);
    if (lottieData !== null) {
      let curFrame: number = this.getCurrentFrame() <= 0 ? 1 : this.getCurrentFrame();
      this.getLottieAnimMode().getIconViewData().initialSegment = [curFrame - 1, curFrame] as AnimationSegment;
      this.getLottieAnimMode().setLottieData(lottieData);
      this.getLottieAnimMode().needUpdateIconByAnim(true);
      this.getLottieAnimMode().setCurrentFrame(this.getCurrentFrame());
      return true;
    } else if (!DropDownAdapter.isDropDownShow()) {
      log.showInfo('clear resource, setLottieData null');
      this.getLottieAnimMode().setLottieData(null);
    }
    return false;
  }

  /**
   * CanvasReady回调
   */
  public onCanvasReady(): void {
    if (this.loadLottieData()) {
      this.getLottieAnimMode().onCanvasReady();
    }
  }

  /**
   * 更新当前真实音量值
   */
  public getPhysicsValue(): number {
    return VolumeController.getInstance().getVolume() as number;
  }

  /**
   * 最大音量值
   */
  public getMaxValue(): number {
    return VolumeController.getInstance().getMaxVolume() as number;
  }

  /**
   * 最小音量值
   */
  public getMinValue(): number {
    return VolumeController.getInstance().getMinVolume() as number;
  }

  /**
   * 将真实物理值写入数据库
   */
  public setPhysicsValue(continuous: boolean): void {
    VolumeController.getInstance().setVolume(this.physicsValue);
  }

  /**
   * 滑动条点击行为打点上报
   */
  public reportSliderClickEvent(): void {
    log.showInfo(`reportVolumeSlideEvent start:${this.startPhysicsValue}  to:${this.physicsValue}`)
    if (this.outputDevice !== undefined) {
      SoundReporterController.changeVoicePageVolumeReport(this.outputDevice.deviceType, this.outputDevice.address,
        this.physicsValue);
    }
  }

  /**
   * 滑动条滑动行为打点上报
   */
  public reportSliderSlideEvent(): void {
    log.showInfo(`reportVolumeSlideEvent start:${this.startPhysicsValue}  to:${this.physicsValue}`)
    if (this.outputDevice !== undefined) {
      SoundReporterController.changeVoicePageVolumeReport(this.outputDevice.deviceType, this.outputDevice.address,
        this.physicsValue);
    }
  }

  public onLongPressAction(event: GestureEvent, isHorizontal: boolean = true): void {
    super.onLongPressAction(event);
    soundSubPageController.showWindow(isHorizontal);
  }

  /**
   * 主动更新一次ui
   */
  private updateVolumeValue(): void {
    this.physicsValue = this.getPhysicsValue();
    this.getAnimData().uiValue = this.countUIValue();
    this.saveVolumeUIPercentage();
    log.showInfo(`updateVolumeValue ${this.physicsValue}  uiValue ${this.getAnimData().uiValue}`);
  }

  /**
   * 更新音量条图标
   */
  private updateVolumeIcon(needIconTransitionEffect: boolean): void {
    if (!needIconTransitionEffect) {
      this.getLottieAnimMode().getIconViewData().iconTransitionEffect = false;
      log.showInfo('iconTransitionEffect false')
    }
    log.showInfo(`updateVolumeIcon deviceType ${this.outputDevice?.deviceType}, currentVolumeType ${this.currentVolumeType}`);
    switch (this.currentVolumeType) {
      case audio.AudioVolumeType.RINGTONE:
        this.updateRingIcon();
        break;
      case audio.AudioVolumeType.ALARM:
        this.updateIconWithSymbol($r('sys.symbol.alarm_fill_1'));
        log.showInfo(`updateVolumeIcon use alarm icon`);
        break;
      case audio.AudioVolumeType.VOICE_CALL:
        AudioHelper.getInstance().isWirelessDevice(this.outputDevice?.deviceType) ?
        this.updateIconWithSymbol(
          IconMap.getFillEarphoneIcon(this.outputDevice?.address as string, this.outputDevice?.deviceType),
          SymbolRenderingStrategy.MULTIPLE_OPACITY) : this.updateIconWithSymbol($r('sys.symbol.phone_fill'));
        log.showInfo(`updateVolumeIcon use phone icon`);
        break;
      case audio.AudioVolumeType.VOICE_ASSISTANT:
        AudioHelper.getInstance().isWirelessDevice(this.outputDevice?.deviceType) ?
        this.updateIconWithSymbol(
          IconMap.getFillEarphoneIcon(this.outputDevice?.address as string, this.outputDevice?.deviceType),
          SymbolRenderingStrategy.MULTIPLE_OPACITY) : this.updateIconWithSymbol($r('sys.symbol.Voice_fill'));
        log.showInfo(`updateVolumeIcon use voice icon`);
        break;
      case audio.AudioVolumeType.MEDIA:
        this.updateMediaIcon();
        break;
      default:
        this.getAnimData().useLottieData = true;
        break;
    }
    if (!needIconTransitionEffect) {
      setTimeout(() => {
        this.getLottieAnimMode().getIconViewData().iconTransitionEffect = true;
        log.showInfo('iconTransitionEffect true')
      }, 100)
    }
  }

  /**
   * 更新媒体流图标
   * 规则：蓝牙设备和有线设备获取图片资源，其他默认lottie资源
   */
  private updateMediaIcon(): void {
    if (AudioHelper.getInstance().isWirelessDevice(this.outputDevice?.deviceType)) {
      this.updateIconWithSymbol(IconMap.getFillEarphoneIcon(
        this.outputDevice?.address as string, this.outputDevice?.deviceType),
        SymbolRenderingStrategy.MULTIPLE_OPACITY);
      log.showInfo(`updateMediaIcon use earphone icon`);
    } else if (AudioHelper.getInstance().isUsbHeadset(this.outputDevice?.deviceType)) {
      this.updateIconWithSymbol(IconMap.getUsbHeadsetIcon(), SymbolRenderingStrategy.MULTIPLE_OPACITY);
      log.showInfo(`updateMediaIcon use headset icon`);
    } else if (this.outputDevice?.deviceType === audio.DeviceType.NEARLINK) {
      this.updateIconWithSymbol(IconMap.getFillEarphoneIcon(
        this.outputDevice?.address as string, audio.DeviceType.NEARLINK),
        SymbolRenderingStrategy.MULTIPLE_OPACITY);
      log.showInfo('updateMediaIcon use NEARLINK icon');
    } else {
      log.showInfo(`updateMediaIcon use speaker lottie`);
      this.getAnimData().useLottieData = true;
    }
  }

  /**
   * 更新响铃图标
   * 规则：如果音量不为0则显示响铃图标，如果音量为0，需要判断是震动还是静音
   */
  private updateRingIcon(): void {
    if (this.getAnimData().uiValue > 0) {
      this.updateIconWithSymbol($r('sys.symbol.bell_fill'));
      log.showInfo(`updateRingIcon bell`)
    } else if (VolumeController.getInstance().ringMode === audio.AudioRingMode.RINGER_MODE_SILENT) {
      log.showInfo(`updateRingIcon slash`)
      this.updateIconWithSymbol($r('sys.symbol.bell_slash_fill'));
    } else {
      log.showInfo(`updateRingIcon vibrate`)
      this.updateIconWithImg($r('app.media.icon_volume_vibrate'));
    }
  }

  /**
   * 替换音量条图标-使用symbol
   *
   * @param sliderIcon 图标资源
   * @param symbolRendering  渲染策略
   */
  private updateIconWithSymbol(sliderIcon: Resource,
    symbolRendering: SymbolRenderingStrategy = SymbolRenderingStrategy.SINGLE): void {
    this.getAnimData().sliderIcon = sliderIcon;
    this.getAnimData().symbolRendering = symbolRendering;
    this.getAnimData().useSymbol = true;
    this.getAnimData().useLottieData = false;
    // 释放lottie资源
    this.getLottieAnimMode().onCanvasDisappear();
  }

  /**
   * 替换音量条图标-使用image
   * @param sliderIcon 图标资源
   */
  private updateIconWithImg(sliderIcon: Resource): void {
    this.getAnimData().sliderIcon = sliderIcon;
    this.getAnimData().useSymbol = false;
    this.getAnimData().useLottieData = false;
    // 释放lottie资源
    this.getLottieAnimMode().onCanvasDisappear();
  }

  /**
   * 开始拖动动效
   */
  public startDraggingAnimation(): void {
    super.startDraggingAnimation();
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_SLIDING_VOLUME);
  }

  /**
   * 滑动调整音量值，获取ui
   * @returns 点击对应的ui值
   */
  public getUIValueOfPanAction(): number {
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.getViewData().sliderWidth : this.getViewData().sliderHeight;
    let uiValue = Math.min(Math.max(this.currentEndPosition, 0), sliderLength);
    if (this.currentVolumeType !== audio.AudioVolumeType.ALARM &&
      this.currentVolumeType !== audio.AudioVolumeType.VOICE_CALL) {
      return uiValue;
    }
    return Math.max(uiValue, this.canAdjustMinValue);
  }

  /**
   * 拖动结束动效后记录ui值
   */
  public endDraggingAnimation(): void {
    super.endDraggingAnimation();
    TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SLIDING_VOLUME);
    this.saveVolumeUIPercentage();
    AccessibilityUtil.sendAccessibility(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_change_volume'),
      `${this.getAccessibilityPhysicsValue()}%}`));
  }

  /**
   * 点击开始
   */
  public onTapAction(event: GestureEvent): void {
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_TAP_VOLUME);
    super.onTapAction(event);
  }


  /**
   * 点击调整音量值，获取ui
   * @param event
   * @returns
   */
  getUIValueOfTapAction(event: GestureEvent): number {
    let uiValue: number = 0;
    if (this.getViewData().isHorizontal) {
      uiValue =
        RTLUtil.isRTL() ? this.getViewData().sliderWidth - event.fingerList[0].localX : event.fingerList[0].localX;
    } else {
      uiValue = this.getViewData().sliderHeight - event.fingerList[0].localY;
    }
    if (this.currentVolumeType !== audio.AudioVolumeType.ALARM &&
      this.currentVolumeType !== audio.AudioVolumeType.VOICE_CALL) {
      return uiValue;
    }
    return Math.max(uiValue, this.canAdjustMinValue);
  }

  /**
   * 点击进度值播放动画
   */
  public refreshIcon() {
    this.refreshIconWithAnim();
  }

  /**
   * 拖动进度值播放动画
   */
  public playCurrentFrame(currentEndPosition: number): void {
    this.refreshIconWithAnim();
  }

  /**
   * 刷新icon，根据音量值变化播放指定段的动效
   */
  public refreshIconWithAnim() {
    let frameSegments: number[] = this.getFrameSegments();
    if (frameSegments === undefined || frameSegments.length === 0) {
      return;
    }
    this.getLottieAnimMode().refreshIconAnim(frameSegments);
  }

  /**
   * 音量变化获取对应的音量等级区间，相同区间内不需要动画过过渡
   * @returns
   */
  private getFrameSegments(): number[] {
    log.showInfo(`volume value: ${this.physicsValue}`);
    let frameSegments: number[] = [];
    let currentValueLevel = this.getVolumeValueLevel(this.physicsValue);
    if (currentValueLevel === this.preVolumeValueLevel) {
      log.showInfo(`volume level not change ${currentValueLevel}`);
      return frameSegments;
    }
    if (currentValueLevel > this.preVolumeValueLevel) {
      frameSegments = this.mediaLottieKeyFrames[currentValueLevel - 1];
    } else {
      frameSegments = this.mediaLottieKeyFrames[currentValueLevel].slice().reverse();
    }
    this.preVolumeValueLevel = currentValueLevel;
    log.showInfo(`frameSegments :${frameSegments}`);
    return frameSegments;
  }

  /**
   * 根据音量等级变化，获取播放动画区间帧
   * @param currentValueLevel
   * @returns
   */
  getFrameSegmentsByLevel(currentValueLevel: number): number[] {
    if (currentValueLevel > this.preVolumeValueLevel) {
      return this.mediaLottieKeyFrames[currentValueLevel - 1];
    } else {
      return Array.from(this.mediaLottieKeyFrames[this.preVolumeValueLevel]).reverse();
    }
  }

  /**
   * 将音量值分为4个区间
   * [0,0]、[1,5]、[6,10]、[11,15]
   * @param value
   * @returns 对应的区间等级
   */
  private getVolumeValueLevel(value: number): number {
    if (value > this.volumeLevelTwo) {
      return this.speakerWaveThree;
    } else if (value > this.volumeLevelOne) {
      return this.speakerWaveTwo;
    } else if (value > 0) {
      return this.speakerWaveOne;
    }
    return this.speakerWaveZero;
  }

  /**
   * 获取当前音量值对应的动效帧
   * @returns
   */
  private getCurrentFrame(): number {
    if (this.physicsValue > this.volumeLevelTwo) {
      this.preVolumeValueLevel = this.speakerWaveThree;
      return this.mediaLottieKeyFrames[2][1];
    } else if (this.physicsValue > this.volumeLevelOne) {
      this.preVolumeValueLevel = this.speakerWaveTwo;
      return this.mediaLottieKeyFrames[1][1];
    } else if (this.physicsValue > 0) {
      this.preVolumeValueLevel = this.speakerWaveOne;
      return this.mediaLottieKeyFrames[0][1];
    }
    this.preVolumeValueLevel = this.speakerWaveZero;
    return this.mediaLottieKeyFrames[0][0];
  }

  /**
   * 点击动效结束后记录ui值
   */
  public onTapActionEnd(): void {
    TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_TAP_VOLUME);
    this.saveVolumeUIPercentage();
  }

  private saveVolumeUIPercentage(): void {
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.getViewData().sliderWidth : this.getViewData().sliderHeight;
    if (sliderLength !== 0) {
      VolumeController.getInstance().setVolumePercentage(this.getAnimData().uiValue / sliderLength);
      log.showInfo(`subpage savePercentageOfUI: ${VolumeController.getInstance().getVolumePercentage()}`);
    }
  }
}