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
  AudioManagerHelper,
  LogDomain,
  AppStorageUtil,
  DataProperty,
  Logger,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  sEventManager,
  obtainLocalEvent,
  SCBWindowSceneConfig
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { SCBConstants, WindowConstants } from '@ohos/commonconstants';
import audio from '@ohos.multimedia.audio';
import Constants, { VolumeRingModeParam } from '../common/Constants';
import type { VolumeInfo, VolumeChannel } from '../common/Constants';
import { AccessibilityUtil, HostType } from '@ohos/systemuicommon';
import VolumePanelService from '../model/VolumePanelService';
import VolumeWindowController from '../common/VolumeWindowController';
import {
  VolumeWindowStateListener,
  VolumeChangedListener,
  VolumeKeyPressedListener,
  OutputDeviceListener
} from '../common/Interfaces';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { BusinessError } from '@kit.BasicServicesKit';
import SymbolIconUtil, { AVCastPickerDeviceIconName } from '@ohos/systemuicommon/src/main/ets/utils/SymbolIconUtil';
import { VolumeReportBuilder, VolumeSysEventUtil } from '../common/VolumeSysEventUtil';

export const VOLUME_PANEL_MAX_KEY = 'VolumePanelMaxVolume';

export const VOLUME_PANEL_MIN_KEY = 'VolumePanelMinVolume';

export const VOLUME_PANEL_VALUE_KEY = 'VolumePanelVolumeValue';

export const VOLUME_PANEL_IS_MUTE_KEY = 'VolumePanelIsMute';

export const VOLUME_CHANGE_EVENT = 'VolumeChangeEvent';

export const AUDIO_RING_MODE_EVENT = 'AudioRingModeEvent';

const TAG = 'VolumePanelVM';
const REFRESH_TIME = 200;
const NUMBER_HALF = 2;
const DEFAULT_VOLUME_PADDING_TOP = '164';
const DEFAULT_VOLUME_POPUP = '0';
const ALREADY_SHOW_VOLUME_POPUP = '3';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const volumeChannels: VolumeChannel[] = [];
const OUTPUT_DEVICE_INDEX = 0;
const PANEL_COMPACT_LAYOUT: string[] = ['ICL', 'DEL'];

interface VolumeValue {
  maxVolume: number;
  minVolume: number;
}

export class VolumePanelVM {
  public mIsStart: boolean = false;
  public mAllVolumeTypes = [audio.AudioVolumeType.VOICE_CALL, audio.AudioVolumeType.ALARM,
    audio.AudioVolumeType.RINGTONE, audio.AudioVolumeType.MEDIA,
    audio.AudioVolumeType.ACCESSIBILITY, audio.AudioVolumeType.ULTRASONIC];
  public mVolumeBaseMap: Record<number, VolumeValue> = {};
  public mVolumeChangedListeners = new Set<VolumeChangedListener>();
  public mGlobalVolumeInfoMap = new Map<audio.AudioVolumeType, VolumeInfo>();
  public mCurrentAudioVolumeType: number = audio.AudioVolumeType.MEDIA; // PC uses
  public phoneCurrentAudioVolumeType: number = audio.AudioVolumeType.MEDIA; // phone used
  public mCurrentAudioVolume?: number;
  public mUpdatingAudioVolume?: number;
  public mVolumeBeforeMute: number = 0;
  public mIsRefreshActiveVolumeType: boolean = false;
  public mIsDevicePhone: boolean = true;
  public isPanelCompactLayout: boolean = false;
  public isUpdateUiByVolumeInfo: Function | null = null;
  public globalVolumeChannelMap = new Map<audio.AudioVolumeType, VolumeChannel>(
    [[audio.AudioVolumeType.MEDIA, {
      channelId: 'media',
      volumeType: audio.AudioVolumeType.MEDIA,
      channelName: $r('app.string.volume_channel_media'),
    }], [audio.AudioVolumeType.RINGTONE, {
      channelId: 'ring',
      volumeType: audio.AudioVolumeType.RINGTONE,
      channelName: $r('app.string.volume_channel_ringer'),
    }], [audio.AudioVolumeType.ALARM, {
      channelId: 'alarm',
      volumeType: audio.AudioVolumeType.ALARM,
      channelName: $r('app.string.volume_channel_alarm'),
    }], [audio.AudioVolumeType.ACCESSIBILITY, {
      channelId: 'accessibility',
      volumeType: audio.AudioVolumeType.ACCESSIBILITY,
      channelName: $r('app.string.volume_accessibility_accessibility'),
    }], [audio.AudioVolumeType.VOICE_CALL, {
      channelId: 'call',
      volumeType: audio.AudioVolumeType.VOICE_CALL,
      channelName: $r('app.string.volume_channel_voice_call'),
    }]]);
  public globalVolumeActiveTypes: boolean[] = [];
  public globalCurrentVolumeActive: audio.AudioVolumeType = audio.AudioVolumeType.MEDIA;

  private audioManager: audio.AudioManager | null = null;
  private audioVolumeManager: audio.AudioVolumeManager | null = null;
  private audioRoutingManager: audio.AudioRoutingManager | null = null;
  private rendererInfo: audio.AudioRendererInfo;
  /**
   * 最高优先级输出设备变化监听列表
   */
  public mOutputDeviceChangeListeners = new Set<OutputDeviceListener>();

  constructor() {
    this.audioManager = AudioManagerHelper.getAudioManager();
    this.audioVolumeManager = this.audioManager.getVolumeManager();
    this.audioRoutingManager = this.audioManager.getRoutingManager();
    this.rendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_MEDIA,
      rendererFlags: 0
    };
    log.showInfo(TAG, 'constructor');
  }

  private copyVolumeInfo(volumeInfo: VolumeInfo): VolumeInfo {
    return {
      volumeType: volumeInfo.volumeType,
      volume: volumeInfo.volume,
      maxVolume: volumeInfo.maxVolume,
      minVolume: volumeInfo.minVolume,
      lastVolume: volumeInfo.lastVolume,
      isMute: volumeInfo.isMute,
      isActive: volumeInfo.isActive,
      hostType: volumeInfo.hostType,
      updateUi: volumeInfo.updateUi,
    };
  }

  initViewModel(isUpdateUiByVolumeInfo?: Function): void {
    if (this.mIsStart) {
      return;
    }
    log.showInfo(TAG, 'initViewModel');
    this.mIsStart = true;
    if (isUpdateUiByVolumeInfo) {
      this.isUpdateUiByVolumeInfo = isUpdateUiByVolumeInfo;
    }
    this.onOutputDeviceChange();
    this.mIsDevicePhone = DeviceHelper.isPhone() || DeviceHelper.isPad();
    AppStorageUtil.setOrCreate<number>(VOLUME_PANEL_MAX_KEY, DeviceHelper.isPC() ?
      Constants.PC_DEFAULT_MAX_VOLUME : Constants.DEFAULT_MAX_VOLUME, new DataProperty(true, false));
    AppStorageUtil.setOrCreate<number>(VOLUME_PANEL_MIN_KEY, Constants.DEFAULT_MIN_VOLUME,
      new DataProperty(true, false));
    AppStorageUtil.setOrCreate<number>(VOLUME_PANEL_VALUE_KEY, Constants.DEFAULT_MIN_VOLUME,
      new DataProperty(true, false));
    AppStorageUtil.setOrCreate<boolean>(VOLUME_PANEL_IS_MUTE_KEY, Constants.DEFAULT_MUTE_STATUS,
      new DataProperty(true, false));
    this.mAllVolumeTypes.forEach((volumeType: audio.AudioVolumeType) => {
      this.initAudioVolumeInfo(volumeType);
    });
    VolumePanelService.startService();
    VolumePanelService.registerListener(this);
    VolumePanelService.setPreviousVolumeCallback(this);
    this.getInitVolumeInfo();
    sEventManager.subscribe(VOLUME_CHANGE_EVENT, (volumeInfo: VolumeInfo) => {
      this.updateVolumeInfo(volumeInfo);
    });
    sEventManager.subscribe(AUDIO_RING_MODE_EVENT, (audioInfo: VolumeRingModeParam) => {
      if (audioInfo.volumeInfo) {
        log.showWarn(TAG, `ringModeEvent AUDIO_RING_MODE_EVENT ${audioInfo.volumeInfo.volume} ${audioInfo.volumeInfo.updateUi} ${audioInfo.ringerMode}`);
        const volumeInfo = this.copyVolumeInfo(audioInfo.volumeInfo);
        volumeInfo.updateUi = true;
        this.updateVolumeInfo(volumeInfo);
      }
      VolumeWindowController.getInstance()
        .mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
        listener?.onRingerModeChanged?.(audioInfo?.ringerMode);
      });
    });
    this.checkDevice();
  }

  getInitVolumeInfo(updateUi?: boolean): void {
    this.getActiveVolumeType(JSON.parse(JSON.stringify(this.mAllVolumeTypes)),
      (activeVolumeType: audio.AudioVolumeType) => {
      log.showInfo(TAG, `getInitVolumeInfo, activeVolumeType: ${activeVolumeType}`);
      if (activeVolumeType === undefined) {
        activeVolumeType = audio.AudioVolumeType.MEDIA;
      }
      this.setActiveVolumeType(activeVolumeType, true);
      VolumePanelService.getVolumeInfo(activeVolumeType, (volumeInfo: VolumeInfo) => {
        volumeInfo = this.copyVolumeInfo(volumeInfo);
        volumeInfo.updateUi = updateUi === undefined ? volumeInfo.updateUi : updateUi;
        this.updateVolumeInfo(volumeInfo);
      });
    });
  }

  getActiveVolumeType(volumeTypes: number[], callback: Function): void {
    log.showInfo(TAG, 'getActiveVolumeType, volumeTypes.length');
    if (volumeTypes.length === 0) {
      callback(undefined);
      return;
    }
    VolumePanelService.isActive(volumeTypes[0], (volumeType: audio.AudioVolumeType, data: boolean) => {
      log.showInfo(TAG, `getActiveVolumeType, volumeType: ${volumeType} data: ${data}`);
      if (data) {
        callback(volumeType);
      } else {
        volumeTypes.splice(0, 1);
        this.getActiveVolumeType(volumeTypes, callback);
      }
    });
  }

  updateMaxVolume(volumeType: audio.AudioVolumeType, value: number): void {
    log.showDebug(TAG, `updateMaxVolume, volumeType: ${volumeType} value: ${value}`);
    this.mVolumeBaseMap[volumeType].maxVolume = value;
    let volumeInfo = this.getAudioVolumeInfo(volumeType);
    if (volumeInfo !== null) {
      volumeInfo.maxVolume = value;
    }
  }

  updateMinVolume(volumeType: audio.AudioVolumeType, value: number): void {
    log.showDebug(TAG, `updateMinVolume, volumeType: ${volumeType} value: ${value}`);
    this.mVolumeBaseMap[volumeType].minVolume = value;
    let volumeInfo = this.getAudioVolumeInfo(volumeType);
    if (volumeInfo !== null) {
      volumeInfo.minVolume = value;
    }
  }


  /**
   * 触摸滑动到0更新音量值
   * @param volumeType 声道类型
   * @param value 音量值
   */
  updateVolumeWhenTouchToZero(volumeType: audio.AudioVolumeType, value: number): void {
    let volumeInfo = this.getAudioVolumeInfo(volumeType);
    if (volumeInfo !== null) {
      volumeInfo.volume = value;
    }
  }

  getPreviousVolume(volumeType: audio.AudioVolumeType): VolumeInfo {
    return this.getAudioVolumeInfo(volumeType);
  }

  /**
   * 根据音量变化(onVolumeChangeSync)更新音量信息
   * @param volumeInfo
   */
  updateVolumeInfo(volumeInfo: VolumeInfo): void {
    log.showInfo(TAG, `updateVolumeInfo, type: ${this.mCurrentAudioVolumeType}`);
    if (!this.mIsDevicePhone && !this.updateUi(volumeInfo)) {
      return;
    }
    if (this.mIsDevicePhone && volumeInfo.updateUi) {
      this.phoneCurrentAudioVolumeType = volumeInfo.volumeType;
    }
    let volumeType = volumeInfo.volumeType;
    if (volumeType === audio.AudioVolumeType.ALL) {
      return;
    }
    let maxVolume = this.mVolumeBaseMap[volumeType]?.maxVolume;
    let minVolume = this.mVolumeBaseMap[volumeType]?.minVolume;
    AppStorageUtil.setOrCreate<number>(VOLUME_PANEL_MAX_KEY, maxVolume, new DataProperty(true, false));
    AppStorageUtil.setOrCreate<number>(VOLUME_PANEL_MIN_KEY, minVolume, new DataProperty(true, false));
    log.showInfo(TAG, `updateVolumeInfo, mMaxVolume: ${AppStorage.get<number>(VOLUME_PANEL_MAX_KEY)} `);
    log.showInfo(TAG, `updateVolumeInfo, mMinVolume: ${AppStorage.get<number>(VOLUME_PANEL_MIN_KEY)} `);

    this.mCurrentAudioVolume = volumeInfo.volume;
    log.showInfo(TAG, `updateVolumeInfo, mCurrentAudioVolume: ${this.mCurrentAudioVolume} `);
    log.showInfo(TAG, `updateVolumeInfo, audioVolumeType: ${volumeType} `);

    let isMute = this.adjustMuteState(volumeInfo);
    AppStorageUtil.setOrCreate<boolean>(VOLUME_PANEL_IS_MUTE_KEY, isMute, new DataProperty(true, false));
    if (!isMute) {
      this.mVolumeBeforeMute = volumeInfo.volume;
    }
    log.showInfo(TAG, `updateVolumeInfo, mIsMute: ${AppStorage.get<boolean>(VOLUME_PANEL_IS_MUTE_KEY)} `);
    log.showInfo(TAG, `updateVolumeInfo, mVolumeBeforeMute: ${this.mVolumeBeforeMute} `);

    this.updateDisplayVolume(isMute ? minVolume : volumeInfo.volume, maxVolume, minVolume);
    this.setVolumeValue(volumeType, volumeInfo.volume as number);
    let resultVolumeInfo: VolumeInfo | null = null;
    let globalVolumeInfo = this.getAudioVolumeInfo(volumeType);
    if (globalVolumeInfo !== null) {
      resultVolumeInfo = this.copyVolumeInfo(globalVolumeInfo);
    }
    // 先切换侧边音量类型
    this.mVolumeChangedListeners?.forEach(callback => {
      // 手机平板在收到音频上报不同类型的音频，updateUI为false时不切换侧边音量柱类型
      if (this.mIsDevicePhone && this.phoneCurrentAudioVolumeType !== volumeInfo.volumeType && !volumeInfo.updateUi) {
        return;
      }
      callback?.onActiveTypeChanged(volumeType, volumeInfo.volume, false);
    });
    if (resultVolumeInfo) {
      resultVolumeInfo.updateUi = volumeInfo.updateUi;
    }
    this.mVolumeChangedListeners?.forEach(callback => {
      callback?.onVolumeChanged(resultVolumeInfo);
    });
  }

  updateDisplayVolume(volume: number, maxVolume: number, minVolume: number): void {
    log.showInfo(TAG, `updateDisplayVolume, volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    AppStorageUtil.setOrCreate<number>(VOLUME_PANEL_VALUE_KEY, volume, new DataProperty(true, false));
    log.showInfo(TAG, `updateDisplayVolume, mVolumeValue: ${AppStorage.get(VOLUME_PANEL_VALUE_KEY)}`);
  }

  calcVolumeByDisplayVolume(displayVolume: number): number {
    let volume: number = displayVolume + AppStorage.get<number>(VOLUME_PANEL_MIN_KEY)!;
    if (AppStorage.get<number>(VOLUME_PANEL_MIN_KEY)! <= Constants.DEFAULT_VOLUME_INVALID) {
      log.showError(TAG, `volumePanelMinVolume is invalid, update volume`);
      volume = displayVolume;
    }
    log.showInfo(TAG, `calcVolumeByDisplayVolume, volume: ${volume}`);
    return volume;
  }

  startRefreshVolumeActiveState(immediately: boolean): void {
    if (this.mIsRefreshActiveVolumeType) {
      return;
    }
    this.mIsRefreshActiveVolumeType = true;
    this.refreshVolumeActiveState(immediately);
  }

  stopRefreshVolumeActiveState(): void {
    this.mIsRefreshActiveVolumeType = false;
  }

  requestMaxVolume(volumeType: audio.AudioVolumeType, callback?: (maxVolume: number) => void): void {
    VolumePanelService.getMaxVolume(volumeType, (volumeType: audio.AudioVolumeType, value: number) => {
      if (!callback) {
        return;
      }
      callback(value);
    });
  }

  requestMinVolume(volumeType: audio.AudioVolumeType, callback?: (minVolume: number) => void): void {
    VolumePanelService.getMinVolume(volumeType, (volumeType: audio.AudioVolumeType, value: number) => {
      if (!callback) {
        return;
      }
      callback(value);
    });
  }

  getLastVolumeValue(volumeType: audio.AudioVolumeType): number {
    return this.getAudioVolumeInfo(volumeType)?.lastVolume as number ?? (Constants.DEFAULT_MAX_VOLUME / NUMBER_HALF);
  }

  getMaxVolume(volumeType: audio.AudioVolumeType, callback: (value: number) => void): void {
    const volumeInfo = this.getAudioVolumeInfo(volumeType);
    const maxVolume = volumeInfo?.maxVolume;
    log.showInfo(TAG, `requestMaxVolume start, volumeType: ${volumeType}, maxVolume: ${maxVolume}`);
    this.requestMaxVolume(volumeType, (value: number) => {
      log.showInfo(TAG, `requestMaxVolume success, volumeType: ${volumeType}, maxVolume: ${value}`);
      const newValue = value ?? Constants.DEFAULT_MAX_VOLUME;
      this.updateMaxVolume(volumeType, newValue);
      callback(newValue);
    });
  }

  getMinVolume(volumeType: audio.AudioVolumeType, callback: (value: number) => void): void  {
    const volumeInfo = this.getAudioVolumeInfo(volumeType);
    const minVolume = volumeInfo?.minVolume;
    log.showInfo(TAG, `requestMinVolume start, volumeType: ${volumeType}, minVolume: ${minVolume}`);
    this.requestMinVolume(volumeType, (value: number) => {
      log.showInfo(TAG, `requestMinVolume success, volumeType: ${volumeType}, minVolume: ${value}`);
      const newValue = value ?? Constants.DEFAULT_MIN_VOLUME;
      this.updateMinVolume(volumeType, newValue);
      callback(newValue);
    });
  }

  getVolumeByType(volumeType: audio.AudioVolumeType, callback?: (volumeInfo: VolumeInfo) => void): void {
    VolumePanelService.getVolumeInfo(volumeType, (volumeInfo: VolumeInfo) => {
      if (!callback || !volumeInfo) {
        return;
      }
      let globalVolumeInfo = this.getAudioVolumeInfo(volumeType);
      if (globalVolumeInfo !== null) {
        globalVolumeInfo.volume = volumeInfo.volume;
        globalVolumeInfo.isMute = this.isVolumeMute(globalVolumeInfo.minVolume as number, volumeInfo.volume as number);
        callback(this.copyVolumeInfo(globalVolumeInfo));
      }
    });
  }

  setVolumeByType(volumeType: number, volumeValue: number): void {
    let volumeInfo = this.getAudioVolumeInfo(volumeType);
    log.showInfo(TAG, `Get audio info ${volumeValue}`);
    let notifyVolumeInfo = this.copyVolumeInfo(volumeInfo);
    let isMute = false;
    if (notifyVolumeInfo !== null) {
      notifyVolumeInfo.isMute = this.isVolumeMute(notifyVolumeInfo.minVolume as number, volumeValue as number);
      notifyVolumeInfo.volume = volumeValue;
      notifyVolumeInfo.lastVolume = volumeInfo.volume;
      isMute = notifyVolumeInfo.isMute;
    }
    VolumePanelService.setVolume(volumeType, volumeValue, () => {
      if (isMute) {
        VolumePanelService.setMute(volumeType, true);
      }
      if (notifyVolumeInfo === null) {
        return;
      }
      this.notifyVolumeChange(this.copyVolumeInfo(notifyVolumeInfo));
    });
    VolumeWindowController.getInstance().updateVolumeInfo(null);
  }

  setMuteByType(volumeType: number, isMute: boolean): void {
    VolumePanelService.setMute(volumeType, isMute);
  }

  isMute(volumeType: number): boolean {
    return this.getAudioVolumeInfo(volumeType)?.isMute as boolean ?? false;
  }

  setVolume(displayVolume: number): void {
    log.showInfo(TAG, `setVolume, displayVolume: ${displayVolume} `);
    let volume: number = this.calcVolumeByDisplayVolume(displayVolume);
    this.mUpdatingAudioVolume = volume;
    let isCurrentMute = volume === AppStorage.get<number>(VOLUME_PANEL_MIN_KEY);
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType as string;
    if (uiType === SCBConstants.UITYPE_PC) {
      VolumePanelService.setMute(audio.AudioVolumeType.RINGTONE, isCurrentMute);
    }
    VolumePanelService.setVolume(audio.AudioVolumeType.ALL, volume, () => {
      log.showInfo(TAG, 'setVolume callback');

      let volumeInfo: VolumeInfo = {
        volumeType: this.mCurrentAudioVolumeType,
        volume: volume,
        isMute: isCurrentMute,
        updateUi: false,
        isActive: true,
        hostType: HostType.VOLUME_PANEL,
        maxVolume: Constants.DEFAULT_VOLUME_INVALID,
        minVolume: Constants.DEFAULT_VOLUME_INVALID,
        lastVolume: volume
      };
      this.notifyVolumeChange(volumeInfo);

      this.mVolumeBeforeMute = volume;
    });

    VolumeWindowController.getInstance().updateVolumeInfo(null);
  }

  async mute(): Promise<void> {
    try {
      let avgMgr = await this.audioVolumeManager?.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
      let isMute = await avgMgr?.isMute(audio.AudioVolumeType.ALL);
      log.showInfo(TAG, `Muted: ${isMute}}`);
      await avgMgr?.mute(audio.AudioVolumeType.ALL, !isMute);
    } catch (error) {
      log.showError(TAG, 'catch error');
    }
  }

  registerVolumeChangedListener(listener: VolumeChangedListener): void {
    if (listener == null) {
      return;
    }
    this.mVolumeChangedListeners?.add(listener);
  }

  unRegisterVolumeChangedListener(listener: VolumeChangedListener): void {
    if (listener == null) {
      return;
    }
    this.mVolumeChangedListeners?.delete(listener);
  }

  registerWindowStateListener(listener: VolumeWindowStateListener): void {
    if (listener == null) {
      return;
    }
    VolumeWindowController.getInstance().registerWindowStateListener(listener);
  }

  unRegisterWindowStateListener(listener: VolumeWindowStateListener): void {
    if (listener == null) {
      return;
    }
    VolumeWindowController.getInstance().unRegisterWindowStateListener(listener);
  }

  registerVolumeKeyPressedListener(listener: VolumeKeyPressedListener): void {
    if (listener == null) {
      return;
    }
    VolumePanelService.registerVolumeKeyPressedListener(listener);
  }

  unRegisterVolumeKeyPressedListener(listener: VolumeKeyPressedListener): void {
    if (listener == null) {
      return;
    }
    VolumePanelService.unRegisterVolumeKeyPressedListener(listener);
  }

  registerKeyPressedListener(listener: VolumeKeyPressedListener): void {
    if (listener == null) {
      return;
    }
    VolumePanelService.registerKeyPressListeners(listener);
  }

  unRegisterKeyPressedListener(listener: VolumeKeyPressedListener): void {
    if (listener == null) {
      return;
    }
    VolumePanelService.unregisterKeyPressListeners(listener);
  }

  /**
   * 获取音量支持的声道
   * @param isMobileDataAvailable 是否支持通话
   * @returns
   */
  getAllSupportedVolumeChannels(): VolumeChannel[] {
    if (volumeChannels.length > 0) {
      return volumeChannels;
    }
    // 媒体
    volumeChannels.push(this.globalVolumeChannelMap.get(audio.AudioVolumeType.MEDIA)!);
    // 铃声
    volumeChannels.push(this.globalVolumeChannelMap.get(audio.AudioVolumeType.RINGTONE)!);
    // 闹钟
    volumeChannels.push(this.globalVolumeChannelMap.get(audio.AudioVolumeType.ALARM)!);
    // 通话
    volumeChannels.push(this.globalVolumeChannelMap.get(audio.AudioVolumeType.VOICE_CALL)!);
    // 语音助手
    // 无障碍
    volumeChannels.push(this.globalVolumeChannelMap.get(audio.AudioVolumeType.ACCESSIBILITY)!);
    return volumeChannels;
  }

  /**
   * 获取侧边音量支持的声道
   * @returns
   */
  getSidebarActiveChannelTypes(isUseSliderIcon: boolean): audio.AudioVolumeType[] {
    let activeChannelTypes: audio.AudioVolumeType[] = [];
    let isActiveChannelTypes: boolean[] = [];
    // 非无障碍场景支持优先级高的前2条，无障碍3条 外设不展示多音量条
    if (isUseSliderIcon) {
      activeChannelTypes.push(this.globalCurrentVolumeActive);
    } else {
      try {
        isActiveChannelTypes = this.globalVolumeActiveTypes;
      } catch (e) {
        activeChannelTypes.push(this.globalCurrentVolumeActive);
        log.error(TAG, 'getSidebarActiveChannelTypes error', e);
      }
      Constants.VOLUME_TYPE_WEIGHTS.forEach((volumeType, index) => {
        if (isActiveChannelTypes[index] && volumeType !== audio.AudioVolumeType.ACCESSIBILITY) {
          activeChannelTypes.push(volumeType);
        }
      })
      activeChannelTypes = activeChannelTypes.slice(0, 2);
    }
    if (AccessibilityUtil.isAccessibilityMode()) {
      activeChannelTypes.push(audio.AudioVolumeType.ACCESSIBILITY);
    }
    log.showInfo(TAG, `getSidebarActiveChannelTypes ${activeChannelTypes.length}`);
    return activeChannelTypes;
  }

  private isVolumeMute(minVolume: number, volumeValue: number): boolean {
    if (minVolume > Constants.DEFAULT_MIN_VOLUME) {
      return false;
    }
    return volumeValue <= minVolume;
  }

  private setVolumeValue(volumeType: audio.AudioVolumeType, volumeValue: number): void {
    let volumeInfo = this.getAudioVolumeInfo(volumeType);
    if (volumeInfo !== null) {
      if (!volumeInfo.isMute) {
        volumeInfo.lastVolume = volumeInfo.volume;
      }
      volumeInfo.volume = volumeValue;
      volumeInfo.isMute = this.isVolumeMute(volumeInfo.minVolume as number, volumeValue as number);
    }
  }

  private setActiveVolumeType(volumeType: audio.AudioVolumeType, isActive: boolean): void {
    let tempIsActive = false;
    if (isActive !== null) {
      tempIsActive = isActive;
    }
    let volumeInfo = this.getAudioVolumeInfo(volumeType);
    if (volumeInfo !== null) {
      volumeInfo.isActive = tempIsActive;
    }
  }

  private isVolumeTypeActive(volumeType: audio.AudioVolumeType): boolean {
    return this.getAudioVolumeInfo(volumeType)?.isActive as boolean ?? false;
  }

  private getAudioVolumeInfo(volumeType: audio.AudioVolumeType): VolumeInfo {
    return this.mGlobalVolumeInfoMap?.get(volumeType) as VolumeInfo;
  }

  private initAudioVolumeInfo(volumeType: audio.AudioVolumeType): void {
    this.mVolumeBaseMap[volumeType] = {
      maxVolume: Constants.DEFAULT_MAX_VOLUME,
      minVolume: Constants.DEFAULT_MIN_VOLUME
    };
    this.mGlobalVolumeInfoMap?.set(volumeType, {
      volumeType: volumeType,
      volume: Constants.DEFAULT_MAX_VOLUME,
      isMute: false,
      updateUi: false,
      isActive: false,
      hostType: HostType.VOLUME_PANEL,
      maxVolume: Constants.DEFAULT_VOLUME_INVALID,
      minVolume: Constants.DEFAULT_VOLUME_INVALID,
      lastVolume: Constants.DEFAULT_MAX_VOLUME
    });
    this.requestMaxVolume(volumeType, (value) => {
      this.updateMaxVolume(volumeType, value);
    });
    this.requestMinVolume(volumeType, (value) => {
      this.updateMinVolume(volumeType, value);
    });
  }

  private getCurrentActiveVolumeType(): audio.AudioVolumeType {
    if (this.isVolumeTypeActive(audio.AudioVolumeType.VOICE_CALL)) {
      return audio.AudioVolumeType.VOICE_CALL;
    }
    if (this.isVolumeTypeActive(audio.AudioVolumeType.ALARM)) {
      return audio.AudioVolumeType.ALARM;
    }
    if (this.isVolumeTypeActive(audio.AudioVolumeType.RINGTONE)) {
      return audio.AudioVolumeType.RINGTONE;
    }
    return audio.AudioVolumeType.MEDIA;
  }

  private refreshVolumeActiveState(immediately: boolean): void {
    if (!this.mIsRefreshActiveVolumeType) {
      return;
    }
    let count = 0;
    setTimeout(() => {
      this.mAllVolumeTypes.forEach((volumeType: audio.AudioVolumeType) => {
        VolumePanelService.isActive(volumeType, (volumeType: audio.AudioVolumeType, isActive: boolean) => {
          count++;
          this.setActiveVolumeType(volumeType, isActive);
          if (count === this.mAllVolumeTypes.length) {
            this.mVolumeChangedListeners.forEach(listener => {
              let type = this.getCurrentActiveVolumeType();
              listener?.onVolumeActiveTypeChanged(type);
            });
            this.refreshVolumeActiveState(false);
          }
        });
      });
    }, immediately ? 0 : REFRESH_TIME);
  }

  private adjustMuteState(volumeInfo: VolumeInfo): boolean {
    if (AppStorage.get<number>(VOLUME_PANEL_MIN_KEY) === this.mCurrentAudioVolume) {
      return true;
    }
    return volumeInfo.isMute;
  }

  private isMuteState(): boolean {
    if (AppStorage.get<number>(VOLUME_PANEL_MIN_KEY) === this.mCurrentAudioVolume) {
      return true;
    }
    return AppStorage.get<boolean>(VOLUME_PANEL_IS_MUTE_KEY)!;
  }

  private notifyVolumeChange(volumeInfo: VolumeInfo): void {
    log.showInfo(TAG, 'notifyVolumeChange, volumeInfo');
    sEventManager.publish(obtainLocalEvent(VOLUME_CHANGE_EVENT, volumeInfo));
  }

  private updateUi(volumeInfo: VolumeInfo): boolean {
    if (volumeInfo.volumeType !== this.mCurrentAudioVolumeType) {
      if (this.isUpdateUiByVolumeInfo) {
        return this.isUpdateUiByVolumeInfo(volumeInfo);
      }
      return false;
    }
    if (volumeInfo.hostType && (volumeInfo.hostType === HostType.VOLUME_PANEL ||
      volumeInfo.hostType === HostType.SOUND_PANEL)) {
      return true;
    }
    return true;
  }

  public getVolumeTopPadding(): number {
    try {
      let data = systemParameterEnhance.getSync('const.systemui.volume_key_top_padding', DEFAULT_VOLUME_PADDING_TOP);
      log.showDebug(TAG, `Get volume top padding ${data}`);
      return parseInt(data);
    } catch (error) {
      log.showInfo(TAG, 'Get volume top padding failed:', error);
      return parseInt(DEFAULT_VOLUME_PADDING_TOP);
    }
  }

  public checkVolumePopup(): number {
    try {
      let data = systemParameterEnhance.getSync('persist.systemui.popup', DEFAULT_VOLUME_POPUP);
      log.showDebug(TAG, `Get volume popup statue ${data}`);
      return parseInt(data);
    } catch (error) {
      log.showInfo(TAG, 'Get volume popup statue failed:', error);
      return parseInt(ALREADY_SHOW_VOLUME_POPUP);
    }
  }

  /**
   * 检查设备是否支撑震动
   */
  public checkDeviceSupportVibrate(): boolean {
    let result: boolean = true;
    try {
      result = systemParameterEnhance.getSync('const.vibrator.support_vibrator', 'true') === 'true';
      log.showInfo(TAG, `check device support vibrator ${result}`);
    } catch (error) {
      log.showError(TAG, `check device support vibrator failed: ${error?.massage}`);
    }
    return result;
  }

  public setVolumePopup(data: number): void {
    try {
      systemParameterEnhance.setSync('persist.systemui.popup', data.toString());
      log.showInfo(TAG, `Set volume popup ${data}`);
    } catch (error) {
      log.showInfo(TAG, 'Set volume popup failed:', error?.message);
    }
  }

  /**
   * 获取所有声道信息
   * @returns
   */
  public getAllAudioVolumeInfo(): Map<audio.AudioVolumeType, VolumeInfo> {
    return this.mGlobalVolumeInfoMap;
  }

  /**
   * 刷新所有声道的音量
   */
  private refreshAllVolumeChannel(): void {
    this.mVolumeChangedListeners.forEach(listener => {
      listener?.onVolumeTypeChanged();
    });
    const reportArr: string[] = [];
    Array.from(this.mGlobalVolumeInfoMap.values()).forEach((item: VolumeInfo) => {
      reportArr.push(`${item.volumeType},${item.maxVolume},${item.minVolume}`);
    });
    VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.REFRESH_MAX_AND_MIN_VOLUME,
      VolumeReportBuilder.builder().maxAndMinVolume(reportArr.join(';')).build());
  }

  public refreshVolumeState(volumeType: audio.AudioVolumeType, volumeValue: number): void {
    this.mVolumeChangedListeners.forEach(listener => {
      listener?.onActiveTypeChanged(volumeType, volumeValue, true);
    });
  }

  public updateRelativeProgress(index: number): void {
    const progressInstance =
      Array.from(this.mVolumeChangedListeners.values()).find((listener) => listener.volumeIndex === index);
    progressInstance?.onVolumeTypeChanged();
  }

  private checkDevice(): void {
    try {
      let data = systemParameterEnhance.getSync('const.build.product');
      log.showDebug(TAG, `DeviceType is ${data}`);
      this.isPanelCompactLayout = PANEL_COMPACT_LAYOUT.includes(data);
    } catch (error) {
      log.error(TAG, 'Get vDeviceType failed:', error);
      this.isPanelCompactLayout = false;
    }
  }

  public async registerOutputDeviceChangeListener(listener: OutputDeviceListener): Promise<void> {
    if (listener == null) {
      return;
    }
    const outputDevice = await this.getOutputDevice();
    listener?.updateOutputDevice(outputDevice);
    this.mOutputDeviceChangeListeners.add(listener);
  }

  public unRegisterOutputDeviceChangeListener(listener: OutputDeviceListener): void {
    if (listener == null) {
      return;
    }
    this.mOutputDeviceChangeListeners.delete(listener);
  }

  private onOutputDeviceChange(): void {
    try {
      this.audioRoutingManager?.on('preferOutputDeviceChangeForRendererInfo', this.rendererInfo,
        this.outputDeviceCallback);
    } catch (err) {
      log.showError(TAG, `registerOutputDeviceChangeListener fail:${(err as BusinessError).code}, ${(err as BusinessError).message}`);
    }
  }

  private readonly outputDeviceCallback: (descriptors: audio.AudioDeviceDescriptors) => void =
    (descriptors: audio.AudioDeviceDescriptors) => {
      if (!descriptors || descriptors?.length < 1) {
        log.showError(TAG, `onOutputDeviceChange descriptors invalid: ${descriptors}`);
        return;
      }
      const outputDevice: audio.AudioDeviceDescriptor = descriptors[OUTPUT_DEVICE_INDEX];
      log.showInfo(TAG, `onOutputDeviceChange displayName: ${outputDevice?.displayName}, deviceType: ${outputDevice?.deviceType}`);
      this.mOutputDeviceChangeListeners.forEach((listener) => {
        listener?.updateOutputDevice(outputDevice);
      });
      // 输出设备变化后,刷新所有声道的音量值
      this.refreshAllVolumeChannel();
      this.getInitVolumeInfo(true);
    };

  /**
   * 根据音频信息，返回优先级最高的输出设备，同步返回结果。
   * @returns 优先级最高的输出设备mac集合
   */
  public async getOutputDevice(): Promise<undefined | audio.AudioDeviceDescriptor> {
    try {
      const descriptors = await this.audioRoutingManager?.getPreferOutputDeviceForRendererInfo(this.rendererInfo);
      const outputDevice: audio.AudioDeviceDescriptor | undefined = descriptors?.[OUTPUT_DEVICE_INDEX];
      log.showInfo(TAG, `getOutputDevice name: ${outputDevice?.name} displayName:${outputDevice?.displayName}, deviceType: ${outputDevice?.deviceType}`);
      return outputDevice;
    } catch (err) {
      log.showError(TAG, `getOutputDevice: Result ERROR: ${(err as BusinessError).code}, ${(err as BusinessError).message}`);
      return undefined;
    }
  }

  /**
   *  获取状态栏高度
   * @returns 单位px
   */
  public getStatusBarHeight(): number {
    const height = windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height;
    log.showInfo(TAG, `getStatusBarHeight ${height}`);
    return height;
  }

  /**
   * 获取外设图标
   * @param address
   * @param deviceType
   * @returns
   */
  public getOutputDeviceIcon(address: string, deviceType: number = audio.DeviceType.INVALID): string {
    switch (deviceType) {
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
        // 有线耳机
        return AVCastPickerDeviceIconName.WIRED_SYMBOL;
      case audio.DeviceType.BLUETOOTH_A2DP:
      case audio.DeviceType.BLUETOOTH_SCO:
        // 蓝牙设备
        return SymbolIconUtil.getBluetoothFillIcon(address);
      case audio.DeviceType.NEARLINK:
        // 星闪
        return SymbolIconUtil.getNearlinkFillIcon(address);
      default:
        return '';
    }
  }
}

/*
 * 音量条无障碍参数
 */
@Observed
export class VolumeAccessibilityVM {
  public accessibilityChannelType: audio.AudioVolumeType = audio.AudioVolumeType.MEDIA;
  public isContainerFocus: boolean = false;
}

let volumePanelVM = new VolumePanelVM();

export default volumePanelVM as VolumePanelVM;