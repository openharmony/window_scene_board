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

import audio from '@ohos.multimedia.audio';
import {
  DeviceHelper,
  obtainLocalEvent,
  obtainStartAbilityWithWant,
  sEventManager
} from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ExtAppConstants } from '@ohos/commonconstants';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { inputConsumer } from '@kit.InputKit';
import { volumeDownKeyOptions, volumeUpKeyOptions } from '../common/KeyOptions';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import { AudioHelper } from '../utils/AudioHelper';
import { HashMap } from '@kit.ArkTS';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';

export interface VolumeComponentStyle {
  width: number;
  height: number;
  bgColor: ResourceStr;
  selectedBgColor: ResourceStr;
  bgBlur: number;
}

export class VolumeConstants {
  public static readonly DEFAULT_MAX_VOLUME: number = 15;
  public static readonly DEFAULT_MIN_VOLUME: number = 0;
  public static readonly DEFAULT_MIN_VOLUME_ONE: number = 1;
  public static readonly DEFAULT_VOLUME_INVALID: number = -1;
}

export const VOLUME_COMPONENT_ID = 'volumeComponent'

export function getVolumeStyle(): VolumeComponentStyle {
  return {
    width: 96,
    height: 324,
    bgColor: $r('app.color.volume_bg_color'),
    selectedBgColor: $r('app.color.volume_selected_bg_color'),
    bgBlur: 45
  }
}

/**
 * 音量监听回调函数
 */
type VolumeChangeCallback = (value: number, type: audio.AudioVolumeType, needChangeTye: boolean) => void;

/**
 * 音量相关参数
 */
export class VolumeValueInfo {
  public volumePercentage: number = VolumeConstants.DEFAULT_VOLUME_INVALID; // 音量ui值默认百分比值
  public currentVolumeValue: number = VolumeConstants.DEFAULT_MAX_VOLUME; // 当前音量值
  public maxVolumeValue: number = VolumeConstants.DEFAULT_MAX_VOLUME; // 最大音量
  public minVolumeValue: number = VolumeConstants.DEFAULT_MIN_VOLUME; // 最小音量
}

const TAG = 'volumeVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const MAX_RETRY_TIMES: number = 5; // AudioManager最多重试次数.
const RETRY_DELAY_TIMES: number = 1500; //重试间隔时间
const REFRESH_ICON_TIMEOUT: number = 280;

export class VolumeController extends BaseController<CommonData> {
  public lottieData: object | null = null;
  private static instance?: VolumeController;
  // 响铃模式
  public ringMode: audio.AudioRingMode = audio.AudioRingMode.RINGER_MODE_NORMAL;
  private audioManager: audio.AudioManager | null = null;
  private audioVolumeManager: audio.AudioVolumeManager | null = null;
  private audioStreamManager: audio.AudioStreamManager | null = null;
  private audioVolumeGroupManager: audio.AudioVolumeGroupManager | null = null;
  // 记录不同音频流类型当前的音量信息
  private volumeInfoMap: Map<audio.AudioVolumeType, VolumeValueInfo> = new Map([
    [audio.AudioVolumeType.VOICE_CALL, new VolumeValueInfo()],
    [audio.AudioVolumeType.RINGTONE, new VolumeValueInfo()],
    [audio.AudioVolumeType.MEDIA, new VolumeValueInfo()],
    [audio.AudioVolumeType.ALARM, new VolumeValueInfo()]
  ]);
  // 音量调整最小只能调整到1的音频类型集合
  private minVolumeOneSet: Set<audio.AudioVolumeType> =
    new Set([audio.AudioVolumeType.ALARM, audio.AudioVolumeType.VOICE_CALL]);
  // 当前正在生效的音频流类型
  private currentVolumeType: audio.AudioVolumeType = audio.AudioVolumeType.MEDIA;
  private callbackMap: HashMap<string, VolumeChangeCallback> = new HashMap();
  // 当前是否处于语音助手语音识别态
  private isCapturerRunning: boolean = false;
  private refreshIconTimeout: number | null = null;

  constructor() {
    super();
    this.loadAudioManager(0);
  }

  static getInstance(): VolumeController {
    if (!VolumeController.instance) {
      VolumeController.instance = new VolumeController();
    }
    return VolumeController.instance;
  }

  /**
   * 加载AudioManager
   * @param reloadTimes 当前重试次数
   */
  private loadAudioManager(reloadTimes: number) {
    if (reloadTimes >= MAX_RETRY_TIMES) {
      log.showInfo(`fail init AudioManager`);
      return;
    }
    try {
      this.audioManager = audio.getAudioManager();
      this.audioVolumeManager = this.audioManager.getVolumeManager();
      this.audioVolumeManager.on('volumeChange', this.onVolumeChange);
      this.audioVolumeGroupManager = this.audioVolumeManager.getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID);
      this.initAllVolumeInfo();
      this.onRingModeEventReceived(this.audioVolumeGroupManager.getRingerModeSync());
      this.audioVolumeGroupManager?.on('ringerModeChange', (ringerMode) => {
        this.onRingModeEventReceived(ringerMode);
      });
      this.audioVolumeManager.on('activeVolumeTypeChange', this.updateVolumeUICallback);

      log.showInfo(`init volumeVM success audioVolumeManager:${this.audioVolumeManager}
        audioVolumeGroupManager:${this.audioVolumeGroupManager}`);

      this.audioStreamManager = this.audioManager.getStreamManager();
      this.audioStreamManager.on('audioCapturerChange',
        (audioCapturerChangeInfoArray: Array<audio.AudioCapturerChangeInfo>) => {
          this.updateCapturerUICallback(audioCapturerChangeInfoArray);
        });
    } catch (err) {
      log.showError(`fail init volumeVM ,err: ${err}, reloadTime ${reloadTimes}`);
      this.releaseAudioManagerCallback();
      setTimeout(() => {
        this.loadAudioManager(reloadTimes + 1);
      }, RETRY_DELAY_TIMES)
    }
  }

  public getVolumePercentage(): number {
    return this.volumeInfoMap.get(this.currentVolumeType)?.volumePercentage as number;
  }

  public setVolumePercentage(volumePercentage: number): void {
    let volumeInfo = this.volumeInfoMap.get(this.currentVolumeType);
    if (volumeInfo !== undefined) {
      volumeInfo.volumePercentage = volumePercentage;
    }
  }

  getData(): CommonData {
    return new CommonData();
  }

  isAvailable(): boolean {
    return true;
  }

  /**
   * 监听响铃模式切换事件
   * @param ringModeEvent
   */
  private onRingModeEventReceived(ringModeEvent: audio.AudioRingMode): void {
    log.showInfo(`listen ring mode is ${ringModeEvent}`);
    let volumeInfo = this.volumeInfoMap.get(audio.AudioVolumeType.RINGTONE);
    if (volumeInfo === undefined) {
      return;
    }
    this.ringMode = ringModeEvent;
    if (ringModeEvent !== audio.AudioRingMode.RINGER_MODE_NORMAL) {
      volumeInfo.currentVolumeValue = 0;
    } else {
      volumeInfo.currentVolumeValue =
        this.audioVolumeGroupManager?.getVolumeSync(audio.AudioVolumeType.RINGTONE) as number ??
        VolumeConstants.DEFAULT_MAX_VOLUME;
    }
    if (this.currentVolumeType === audio.AudioVolumeType.RINGTONE) {
      this.callbackMap.forEach((callback) => {
        if (volumeInfo !== undefined) {
          callback?.(volumeInfo.currentVolumeValue, this.currentVolumeType, true);
        }
      })
      log.showInfo(`update current ring volume: ${volumeInfo.currentVolumeValue}`);
    }
  }

  /**
   * 初始化不同音频流类型对应的音量信息
   */
  public initAllVolumeInfo(): void {
    this.volumeInfoMap.forEach((volumeInfo, volumeType) => {
      try {
        // 最大值
        let maxVolumeValue =
          this.audioVolumeGroupManager?.getMaxVolumeSync(audio.AudioVolumeType.MEDIA) ??
          VolumeConstants.DEFAULT_MAX_VOLUME;
        volumeInfo.maxVolumeValue = maxVolumeValue;
        // 最小值
        let minVolumeValue =
          this.audioVolumeGroupManager?.getMinVolumeSync(audio.AudioVolumeType.MEDIA) ??
          VolumeConstants.DEFAULT_MIN_VOLUME;
        volumeInfo.minVolumeValue = minVolumeValue;
        // 当前值
        let volumeValue = this.audioVolumeGroupManager?.getVolumeSync(volumeType) as number ??
        VolumeConstants.DEFAULT_MAX_VOLUME;
        volumeInfo.currentVolumeValue = volumeValue;
        log.showInfo(`${volumeType} init volume value, max ${maxVolumeValue}, min ${minVolumeValue}, cur ${volumeValue}`);
      } catch (err) {
        log.showError(`Failed to obtain volume value, error ${err}.`);
      }
    });
  }

  /**
   * 控制中心显示时更新音量ui，切换至对应的音频通道
   */
  public updateVolumeUI(): void {
    try {
      let audioVolumeType = this.audioVolumeGroupManager?.getActiveVolumeTypeSync(0);
      log.showInfo(`get audioVolumeType ${audioVolumeType}, this.isCapturerRunning: ${this.isCapturerRunning}`);
      if (audioVolumeType !== undefined && this.volumeInfoMap.has(audioVolumeType)) {
        this.currentVolumeType = audioVolumeType;
      }
    } catch (err) {
      log.showError(`Failed to get active volume type, error ${err}.`);
    }
    this.refreshVolumeIconDelay();
    log.showInfo(`set currentVolumeType ${this.currentVolumeType}`);
  }

  private updateVolumeUICallback = (audioVolumeType: audio.AudioVolumeType) => {
    log.showInfo(`updateVolumeUICallback: ${audioVolumeType}`);
    if (audioVolumeType === undefined || !this.volumeInfoMap.has(audioVolumeType)) {
      return;
    }
    this.currentVolumeType = audioVolumeType;
    log.showInfo(`updateVolumeUICallback set currentVolumeType ${this.currentVolumeType}`);
    this.refreshVolumeIconDelay();
  }

  private updateCapturerUICallback(audioCapturerChangeInfoArray: Array<audio.AudioCapturerChangeInfo>) {
    if (CheckEmptyUtils.isEmptyArr(audioCapturerChangeInfoArray)) {
      return;
    }
    log.showInfo(`updateCapturerUICallback size: ${audioCapturerChangeInfoArray.length}`);
    audioCapturerChangeInfoArray.forEach((capturerInfo) => {
      if (capturerInfo?.capturerInfo?.source === audio.SourceType.SOURCE_TYPE_VOICE_RECOGNITION) {
        this.isCapturerRunning = capturerInfo?.capturerState === audio.AudioState.STATE_RUNNING;
        if (this.isCapturerRunning) {
          this.isCapturerRunning = true;
          this.refreshVolumeIconDelay();
        } else if (capturerInfo?.capturerState > audio.AudioState.STATE_RUNNING) {
          this.updateVolumeUI();
        }
      }
    });
  }

  private refreshVolumeIconDelay(): void {
    if (this.refreshIconTimeout !== null) {
      clearTimeout(this.refreshIconTimeout);
      this.refreshIconTimeout = null;
    }
    this.refreshIconTimeout = setTimeout(() => {
      log.showInfo(`refreshVolumeIconDelay curType=${this.currentVolumeType}`);
      this.callbackMap.forEach((callback) => {
        callback?.(this.volumeInfoMap.get(this.currentVolumeType)?.currentVolumeValue as number,
          this.currentVolumeType, true);
      });
      this.refreshIconTimeout = null;
    }, REFRESH_ICON_TIMEOUT);
  }

  /**
   * 释放音量变化监听以及输出设备类型变化监听
   */
  public releaseVolumeChangeCallback(): void {
    this.releaseAudioManagerCallback();
    AudioHelper.getInstance().offOutputDeviceChange();
  }

  /**
   * 释放音量通道和录音监听
   */
  private releaseAudioManagerCallback(): void {
    try {
      this.audioVolumeManager?.off('volumeChange', this.onVolumeChange);
      this.audioVolumeManager?.off('activeVolumeTypeChange', this.updateVolumeUICallback);
      this.audioStreamManager?.off('audioCapturerChange');
    } catch (err) {
      log.showError(`releaseAudioManager fail:${(err as BusinessError).code}, ${(err as BusinessError).message}`);
    }
  }

  /**
   * 是否需要加载lottie
   */
  isLoadLottie(): boolean {
    return true;
  }

  initLottieData(): void {
    if (DeviceHelper.isPC()) {
      return;
    }
    log.showInfo('initLottieData start');
    this.loadLottieData('lottie_volume_media_cc.json', (value) => {
      this.lottieData = value;
      log.showInfo(`initLottieData success`);
      sEventManager.publish(obtainLocalEvent('volumeLottieReady', true));
    });
  }

  /**
   * 移除lottie缓存
   */
  removeLottieData(): void {
    log.showInfo('remove volume LottieData');
    this.lottieData = null;
    this.isAlreadyLoadLottie = false;
    sEventManager.publish(obtainLocalEvent('volumeLottieReady', false));
  }

  private onVolumeChange = (volumeEvent: audio.VolumeEvent) => {
    log.showInfo(`onVolumeChange stream: ${volumeEvent.volumeType}, level: ${volumeEvent.volume} `);
    let volumeInfo = this.volumeInfoMap.get(volumeEvent.volumeType);
    if (volumeInfo !== undefined) {
      volumeInfo.currentVolumeValue = volumeEvent.volume;
    }
    if (volumeEvent.volumeType === this.currentVolumeType) {
      this.callbackMap.forEach((callback) => {
        callback?.(volumeEvent.volume, volumeEvent.volumeType, false);
      });
    }
  }

  public getCurrentVolumeType(): audio.AudioVolumeType {
    return this.currentVolumeType;
  }

  getMaxVolume() {
    let volumeInfo = this.volumeInfoMap.get(this.currentVolumeType);
    if (volumeInfo !== undefined) {
      return volumeInfo.maxVolumeValue;
    }
    return VolumeConstants.DEFAULT_MAX_VOLUME;
  }

  getMinVolume() {
    let volumeInfo = this.volumeInfoMap.get(this.currentVolumeType);
    if (volumeInfo !== undefined) {
      return volumeInfo.minVolumeValue;
    }
    return VolumeConstants.DEFAULT_MIN_VOLUME;
  }

  public getVolume(): number {
    return this.volumeInfoMap.get(this.currentVolumeType)?.currentVolumeValue as number;
  }

  public setVolumeChangeCallback(callbackTag: string, callback?: VolumeChangeCallback): void {
    if (callback === undefined) {
      this.callbackMap.remove(callbackTag);
      log.showInfo('VolumeChangeCallback remove:' + callbackTag);
    } else {
      this.callbackMap.set(callbackTag, callback);
      log.showInfo('VolumeChangeCallback set:' + callbackTag);
    }
  }

  setVolume(volume: number) {
    if (this.getVolume() === volume) {
      return;
    }
    this.audioVolumeGroupManager?.setVolume(this.currentVolumeType, volume, (error: BusinessError) => {
      if (error) {
        log.showError(`sound setVolume media ${volume} fail, ${(error as BusinessError).code} ${(error as BusinessError).message}`);
      }
      log.showInfo(`sound setVolume media ${volume}`);
    })
  }

  adjustVolumeChange(adjustType: audio.VolumeAdjustType) {
    if (this.audioVolumeGroupManager === undefined || this.audioVolumeGroupManager === null) {
      log.showWarn('adjustVolumeDownByStep undefined');
      this.releaseVolumeChangeCallback();
      this.loadAudioManager(4);
    }
    this.audioVolumeGroupManager?.adjustVolumeByStep(adjustType, (err: BusinessError) => {
      if (err) {
        log.showError(`failed to adjust the volume up by step. ${err.code} ${err.message} ${this.getVolume()}`);
        return;
      } else {
        log.showInfo(`success to adjust the volume up by step. ${this.getVolume()}`);
      }
    });
  }

  adjustVolumeUpByStep() {
    log.showInfo('adjustVolumeUpByStep start');
    if (this.getVolume() === undefined || this.getVolume() as number >= this.getMaxVolume()) {
      log.showError(`adjustVolumeUpByStep.getVolume Value is : ${this.getVolume()}`);
      return;
    }
    this.adjustVolumeChange(audio.VolumeAdjustType.VOLUME_UP)
  }

  adjustVolumeDownByStep() {
    log.showInfo('adjustVolumeDownByStep start');
    let minValue = this.minVolumeOneSet.has(this.currentVolumeType) ? VolumeConstants.DEFAULT_MIN_VOLUME_ONE :
    VolumeConstants.DEFAULT_MIN_VOLUME;
    if (this.getVolume() === undefined || this.getVolume() as number <= minValue) {
      log.showError(`adjustVolumeDownByStep.getVolume Value is : ${this.getVolume()}`);
      return;
    }
    this.adjustVolumeChange(audio.VolumeAdjustType.VOLUME_DOWN)
  }

  /**
   * 跳转音频管家
   */
  goToAudioAccessoryManager(mac: string) {
    if (!mac) {
      return;
    }
    const want = {
      bundleName: ExtAppConstants.PKG_AUDIO_ACCESSORY_MANAGER,
      abilityName: ExtAppConstants.ABILITY_AUDIO_ACCESSORY_MANAGER,
      parameters: {
        mac: mac,
        'ohos.aafwk.param.callerBundleName': 'com.ohos.sceneboard'
      }
    } as Want;
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant(want));
  }

  registerKeyInputEvent(volumeUpKeyCallback: () => void,
    volumeDownKeyCallback: () => void) {
    try {
      inputConsumer.on('key', volumeUpKeyOptions, volumeUpKeyCallback);
    } catch (error) {
      log.showInfo(`Subscribe VolumeUpKeyOptions failed, error: ${(error as BusinessError).code}  ${(error as BusinessError).message}`);
    }
    try {
      inputConsumer.on('key', volumeDownKeyOptions, volumeDownKeyCallback);
    } catch (error) {
      log.showError(`Subscribe VolumeDownKeyOptions failed, error: ${(error as BusinessError).code}  ${(error as BusinessError).message}`);
    }
  }

  unregisterKeyInputEvent(volumeUpKeyCallback: () => void, volumeDownKeyCallback: () => void) {
    try {
      inputConsumer.off('key', volumeUpKeyOptions, volumeUpKeyCallback);
    } catch (error) {
      log.showInfo(`Subscribe VolumeUpKeyOptions failed, error:${(error as BusinessError).code}  ${(error as BusinessError).message}`);
    }
    try {
      inputConsumer.off('key', volumeDownKeyOptions, volumeDownKeyCallback);
    } catch (error) {
      log.showError(`Subscribe VolumeDownKeyOptions failed, error:${(error as BusinessError).code}  ${(error as BusinessError).message}`);
    }
  }

  public volumeUpKeyCallback = () => {
    log.showInfo(`inputConsumer callback volumeUpKeyCallback ${this.getVolume()}`);
    this.adjustVolumeUpByStep();
  }
  public volumeDownKeyCallback = () => {
    log.showInfo(`inputConsumer callback volumeDownKeyCallback ${this.getVolume()}`);
    this.adjustVolumeDownByStep();
  }
}

