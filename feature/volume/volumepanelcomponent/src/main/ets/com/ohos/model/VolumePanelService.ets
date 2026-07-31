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
import { LogDomain, SingletonHelper, AudioManagerHelper, Logger, } from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  obtainLocalEvent,
  sEventManager,
  EventConstants,
  DeviceHelper,
  EventManager,
  EvtBus,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import Constants, { SYSTEM_VOLUME_TYPE, VolumeInfo } from '../common/Constants';
import type { VolumeListener, VolumeKeyPressedListener, PreviousVolumeCallback } from '../common/Interfaces';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { RegisterAPIProtector } from '@ohos/systemuicommon/src/main/ets/statusbar/RegisterAPIProtector';
import { VolumePanelVisibilityEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import VolumePanelVM from '../viewmodel/VolumePanelVM';
import { SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICommonUtil';

const TAG = 'VolumePanelModel';
const VOLUME_CHANGE_EVENT = 'volumeChangeEvent';
const AUDIO_RING_MODE_EVENT = 'AudioRingModeEvent';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const sRegisterAPIProtector: RegisterAPIProtector = RegisterAPIProtector.get();

enum InterfaceName {
  isMute,
  mute,
  getVolume,
  setVolume
}

type Callback = (...args: (Object | null)[]) => void;

interface CallQueue {
  interfaceName: InterfaceName,
  params: Object[],
  callbackFunction: Callback;
}

export class VolumePanelService {
  public mIsStart: boolean = false;
  public mListeners = new Set<VolumeListener>();
  public mVolumeKeyPressedListener = new Set<VolumeKeyPressedListener>();
  public mPreviousVolumeCallback?: PreviousVolumeCallback;
  public mAudioManager = AudioManagerHelper.getAudioManager();
  public mAudioVolumeManager: audio.AudioVolumeManager;
  public mAudioStreamManager: audio.AudioStreamManager;
  public mInterfaceCallQueue: CallQueue[] = [];
  public mIsLoop: boolean = false;
  public keyPressListeners = new Set<VolumeKeyPressedListener>();
  private eventMgr: EventManager = EvtBus.createEventManager();
  private volumePanelNeedShow: boolean = true;

  constructor() {
    log.showInfo(TAG, 'constructor');
    this.mAudioVolumeManager = this.mAudioManager.getVolumeManager();
    this.mAudioStreamManager = this.mAudioManager.getStreamManager();
  }

  startService(): void {
    if (this.mIsStart) {
      return;
    }
    log.showInfo(TAG, 'startService');
    this.mIsStart = true;
    log.showInfo(TAG, 'registser volumeChange.');
    let isPhone = DeviceHelper.isPhone() || DeviceHelper.isPad();
    if (isPhone) {
      sRegisterAPIProtector.run(TAG, 'volumeChange', this.registerVolumeChangeListener);
      log.showInfo(TAG, 'Register sync volume change.');
      this.eventMgr.on(VolumePanelVisibilityEvent, this.onVolumePanelVisibilityEvent);
    } else {
      try {
        this.mAudioVolumeManager.on('volumeChange', this.onVolumeChange.bind(this));
        log.showInfo(TAG, 'Register async volume change.');
      } catch (e) {
        log.showError(TAG, `Register async volume change error: ${e?.message}`);
      }
    }
  }

  stopService(): void {
    if (!this.mIsStart) {
      return;
    }
    log.showInfo(TAG, 'stopService');
    this.mIsStart = false;
    this.mVolumeKeyPressedListener?.clear();
    this.eventMgr.offAll();
  }

  async getRingerMode(): Promise<void> {
    try {
      const audioVolumeGroupManager =
        await this.mAudioVolumeManager.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
      const ringerMode = await audioVolumeGroupManager.getRingerMode();
      log.showInfo(TAG, `get ringerMode ${ringerMode}`);
      sEventManager.publish(obtainLocalEvent(AUDIO_RING_MODE_EVENT, { ringerMode }));
    } catch (error) {
      log.error(TAG, 'getRingerMode error', error);
    }
  }

  /**
   * 处理音量面板展示事件
   */
  private onVolumePanelVisibilityEvent = (event: VolumePanelVisibilityEvent): void => {
    this.volumePanelNeedShow = event.volumePanelNeedShow;
    log.showInfo(TAG, `onVolumePanelVisibilityEvent volumePanelNeedShow: ${this.volumePanelNeedShow}`);
  };

  /**
   * 监听音频事件
   */
  public registerVolumeChangeListener = async (): Promise<void> => {
    try {
      log.showInfo(TAG, `register volume change listener`);
      // 监听系统音量变化事件
      this.mAudioVolumeManager.on('volumeChange', this.onVolumeChangeSync);
      const audioVolumeGroupManager =
        await this.mAudioVolumeManager.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
      // 监听响铃模式切换事件
      audioVolumeGroupManager.on('ringerModeChange', (ringerMode: audio.AudioRingMode) => {
        log.showInfo(TAG, `ringerModeChange ${ringerMode}`);
        this.getVolumeInfo(audio.AudioVolumeType.RINGTONE, (volumeInfo: VolumeInfo) => {
          sEventManager.publish(obtainLocalEvent(AUDIO_RING_MODE_EVENT, { volumeInfo, ringerMode }));
        });
      });
      // 获取响铃模式
      this.getRingerMode();
    } catch (error) {
      this.mAudioVolumeManager?.off('volumeChange', this.onVolumeChangeSync);
      log.error(TAG, 'Register volume change error', error?.message);
      throw error as Error;
    }
  };

  registerListener(listener: VolumeListener): void {
    let res = this.mListeners.add(listener);
    log.showInfo(TAG, `registser VolumeListener ${res}`);
  }

  unregisterListener(listener: VolumeListener): void {
    let res = this.mListeners.delete(listener);
    log.showInfo(TAG, `unregistser VolumeListener ${res}`);
  }

  registerKeyPressListeners(listener: VolumeKeyPressedListener): void {
    let res = this.keyPressListeners.add(listener);
    log.showInfo(TAG, `registser keyPressListeners ${res}`);
  }

  unregisterKeyPressListeners(listener: VolumeKeyPressedListener): void {
    let res = this.keyPressListeners.delete(listener);
    log.showInfo(TAG, `unregistser keyPressListeners ${res}`);
  }

  setPreviousVolumeCallback(callback: PreviousVolumeCallback): void {
    this.mPreviousVolumeCallback = callback;
  }

  registerVolumeKeyPressedListener(listener: VolumeKeyPressedListener): void {
    if (listener == null) {
      return;
    }
    this.mVolumeKeyPressedListener.add(listener);
  }

  unRegisterVolumeKeyPressedListener(listener: VolumeKeyPressedListener): void {
    if (listener == null) {
      return;
    }
    this.mVolumeKeyPressedListener.delete(listener);
  }

  async onVolumeChange(data: audio.VolumeEvent): Promise<void> {
    log.showInfo(TAG, `onVolumeChange, data: type ${data.volumeType} volume ${data.volume} update ${data.updateUi}`);
    let volumeType = this.formatAudioVolumeTypeFromInterface(data.volumeType);
    this.isMute(volumeType, (volumeType2, data2) => {
      log.showInfo(TAG, `onVolumeChange->isMute, volumeType2: ${volumeType2} data2: ${data2}`);
      let volumeInfo: VolumeInfo = {
        volumeType: volumeType,
        volume: data.volume,
        isMute: data2 as boolean,
        updateUi: data.updateUi,
        isActive: true,
        maxVolume: Constants.DEFAULT_VOLUME_INVALID,
        minVolume: Constants.DEFAULT_VOLUME_INVALID,
        lastVolume: data.volume
      };
      log.debug(TAG, `Publish volume change: ${volumeInfo.volumeType} volume ${volumeInfo.volume} update ${volumeInfo.updateUi}`);
      this.notifyVolumeKeyPressed(volumeInfo); // 该方法使用了全局VolumeInfo对象，与下一句更新音量不可修改顺序
      this.mListeners.forEach(listener => {
        listener.updateVolumeInfo(volumeInfo);
      });
      sEventManager.publish(obtainLocalEvent(VOLUME_CHANGE_EVENT, volumeInfo));
    });
  }

  isMute(volumeType: audio.AudioVolumeType, callback: (volumeType: audio.AudioVolumeType, data: Object) => void): void {
    log.showInfo(TAG, `isMute, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.isMute,
      params: [interfaceVolumeType],
      callbackFunction: (err, data) => {
        log.showInfo(TAG, `isMute, callback err: ${err}`);
        if (err) {
          return;
        }
        callback(volumeType, data!);
      }
    });
  }

  getVolumeInfo(volumeType: audio.AudioVolumeType, callback?: (volumeInfo: VolumeInfo) => void): void {
    log.showInfo(TAG, `getVolumeInfo, volumeType: ${volumeType}`);
    this.getVolume(volumeType, (volumeType: audio.AudioVolumeType, data: number) => {
      log.showInfo(TAG, `getVolumeInfo->getVolume, volumeType: ${volumeType} data: ${data}`);
      this.isMute(volumeType, (volumeType2, data2) => {
        log.showInfo(TAG, `getVolumeInfo->isMute, volumeType2: ${volumeType2} data2: ${data2}`);
        let volumeInfo: VolumeInfo = {
          volumeType: volumeType,
          volume: data,
          isMute: data2 as boolean,
          updateUi: false,
          isActive: false,
          maxVolume: Constants.DEFAULT_VOLUME_INVALID,
          minVolume: Constants.DEFAULT_VOLUME_INVALID,
          lastVolume: data
        };
        if (callback) {
          callback(volumeInfo);
        }
      });
    });
  }

  isActive(volumeType: audio.AudioVolumeType, callback: Function): void {
    log.showInfo(TAG, `isActive, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.mAudioStreamManager.isActive(interfaceVolumeType, (err, data) => {
      log.showInfo(TAG, `isActive, err: ${err} ${interfaceVolumeType} data: ${data}`);
      if (err) {
        return;
      }
      callback(volumeType, data);
    });
  }

  getVolume(volumeType: audio.AudioVolumeType, callback: Function): void {
    log.showInfo(TAG, `getVolume, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.getVolume,
      params: [interfaceVolumeType],
      callbackFunction: (err, data) => {
        log.showInfo(TAG, `getVolume callback err: ${err}`);
        if (err) {
          return;
        }
        callback(volumeType, data);
      }
    });
  }

  async getMaxVolume(volumeType: audio.AudioVolumeType, callback: Function): Promise<void> {
    let maxVolume = Constants.DEFAULT_MAX_VOLUME;
    try {
      log.showInfo(TAG, `getMaxVolume start, volumeType: ${volumeType}`);
      const audioVolumeGroupManager =
        await this.mAudioVolumeManager.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
      const interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
      maxVolume = await audioVolumeGroupManager.getMaxVolume(interfaceVolumeType);
      log.showInfo(TAG, `getMaxVolume success, volumeType: ${volumeType}, maxVolume: ${maxVolume}`);
    } catch (err) {
      log.error(TAG, 'getMaxVolume error', err);
    }
    callback(volumeType, maxVolume);
  }

  async getMinVolume(volumeType: audio.AudioVolumeType, callback: Function): Promise<void> {
    let minVolume = Constants.DEFAULT_MIN_VOLUME;
    try {
      log.showInfo(TAG, `getMinVolume start, volumeType: ${volumeType}`);
      const audioVolumeGroupManager =
        await this.mAudioVolumeManager.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
      const interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
      minVolume = await audioVolumeGroupManager.getMinVolume(interfaceVolumeType);
      log.showInfo(TAG, `getMinVolume success, volumeType: ${volumeType}, minVolume: ${minVolume}`);
    } catch (err) {
      log.error(TAG, 'getMinVolume error', err);
    }
    callback(volumeType, minVolume);
  }

  setVolumeAndMute(volumeType: audio.AudioVolumeType, volume: number, mute: boolean, callback?: () => void): void {
    log.showInfo(TAG, `setVolumeAndMute, volumeType: ${volumeType} volume: ${volume} mute: ${mute}`);
    if (volume !== undefined && mute !== undefined) {
      this.setVolume(volumeType, volume, () => {
        log.showInfo(TAG, 'setVolume');
        this.setMute(volumeType, mute, callback);
      });
    } else if (volume !== undefined) {
      this.setVolume(volumeType, volume);
    } else if (mute !== undefined) {
      this.setMute(volumeType, mute, callback);
    }
  }

  setVolume(volumeType: audio.AudioVolumeType, volume: number, callback?: () => void): void {
    log.showInfo(TAG, `setVolume, volumeType: ${volumeType} volume: ${volume}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.setVolume,
      params: [interfaceVolumeType, volume],
      callbackFunction: (err) => {
        log.showInfo(TAG, `setVolume, callback err: ${err} `);
        if (err) {
          return;
        }
      }
    });
    if (callback) {
      callback();
    }
  }

  setMute(volumeType: audio.AudioVolumeType, mute: boolean, callback?: () => void): void {
    log.showInfo(TAG, `setMute, volumeType: ${volumeType} mute: ${mute}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.mute,
      params: [interfaceVolumeType, mute],
      callbackFunction: (err) => {
        log.showInfo(TAG, `setMute callback err: ${err}`);
        if (err) {
          return;
        }
        if (callback) {
          callback();
        }
      }
    });
  }

  formatAudioVolumeTypeFromInterface(audioVolumeType: number): number {
    log.showInfo(TAG, `formatAudioVolumeTypeFromInterface, ${Object.values(audio.AudioVolumeType)}`);
    let formatValue: number;
    if (audioVolumeType === audio.AudioVolumeType.VOICE_CALL) {
      formatValue = audio.AudioVolumeType.VOICE_CALL;
    } else if (audioVolumeType === audio.AudioVolumeType.RINGTONE) {
      formatValue = audio.AudioVolumeType.RINGTONE;
    } else if (audioVolumeType === audio.AudioVolumeType.ALL) {
      formatValue = audio.AudioVolumeType.ALL;
    } else if (audioVolumeType === audio.AudioVolumeType.ACCESSIBILITY) {
      formatValue = audio.AudioVolumeType.ACCESSIBILITY;
    } else if (audioVolumeType === audio.AudioVolumeType.ALARM) {
      formatValue = audio.AudioVolumeType.ALARM;
    } else if (audioVolumeType === audio.AudioVolumeType.ULTRASONIC) {
      formatValue = audio.AudioVolumeType.ULTRASONIC;
    } else if (audioVolumeType === SYSTEM_VOLUME_TYPE) {
      formatValue = SYSTEM_VOLUME_TYPE;
    } else {
      log.showWarn(TAG, `No matching found audioVolumeType`);
      formatValue = audio.AudioVolumeType.MEDIA;
    }
    return formatValue;
  }

  formatAudioVolumeTypeToInterface(audioVolumeType: number): number {
    let formatValue: number;
    if (audioVolumeType === audio.AudioVolumeType.VOICE_CALL) {
      formatValue = audio.AudioVolumeType.VOICE_CALL;
    } else if (audioVolumeType === audio.AudioVolumeType.RINGTONE) {
      formatValue = audio.AudioVolumeType.RINGTONE;
    } else if (audioVolumeType === audio.AudioVolumeType.ALL) {
      formatValue = audio.AudioVolumeType.ALL;
    } else if (audioVolumeType === audio.AudioVolumeType.ACCESSIBILITY) {
      formatValue = audio.AudioVolumeType.ACCESSIBILITY;
    } else if (audioVolumeType === audio.AudioVolumeType.ALARM) {
      formatValue = audio.AudioVolumeType.ALARM;
    } else if (audioVolumeType === audio.AudioVolumeType.ULTRASONIC) {
      formatValue = audio.AudioVolumeType.ULTRASONIC;
    } else if (audioVolumeType === SYSTEM_VOLUME_TYPE) {
      formatValue = SYSTEM_VOLUME_TYPE;
    } else {
      log.showWarn(TAG, `No matching found audioVolumeType`);
      formatValue = audio.AudioVolumeType.MEDIA;
    }
    return formatValue;
  }

  addInterfaceCallQueue(data: CallQueue) {
    log.showDebug(TAG, 'addInterfaceCallQueue');
    this.mInterfaceCallQueue.push(data);
    this.executeCall();
  }

  execInterfaceCallQueueFirst(): void {
    log.showInfo(TAG, `execInterfaceCallQueueFirst, ${this.mInterfaceCallQueue.length}`);
    let queueData = this.mInterfaceCallQueue[0];
    const volumeType = queueData.params[0] as audio.AudioVolumeType;
    if (queueData.interfaceName === InterfaceName.isMute) {
      this.mAudioManager.isMute(volumeType, (err, data) => {
        log.showInfo(TAG, 'execInterfaceCallQueueFirst, isMute callback');
        this.execInterfaceCallQueueNext();
        queueData.callbackFunction(err, data);
      });
    } else if (queueData.interfaceName === InterfaceName.mute) {
      this.mAudioManager.mute(volumeType, queueData.params[1] as boolean, (err) => {
        log.showInfo(TAG, 'execInterfaceCallQueueFirst, mute callback');
        this.execInterfaceCallQueueNext();
        queueData.callbackFunction(err);
      });
    } else if (queueData.interfaceName === InterfaceName.getVolume) {
      this.mAudioManager.getVolume(volumeType, (err, data) => {
        log.showInfo(TAG, 'execInterfaceCallQueueFirst, getVolume callback');
        this.execInterfaceCallQueueNext();
        queueData.callbackFunction(err, data);
      });
    } else if (queueData.interfaceName === InterfaceName.setVolume) {
      this.mAudioManager.setVolume(volumeType, queueData.params[1] as number, (err) => {
        log.showInfo(TAG, 'execInterfaceCallQueueFirst, setVolume callback');
        this.execInterfaceCallQueueNext();
        queueData.callbackFunction(err);
      });
    }
  }

  async execInterfaceCallQueueNext(): Promise<void> {
    let len = this.mInterfaceCallQueue.length;
    log.showInfo(TAG, `execInterfaceCallQueueNext, ${len}`);
    if (len === 0) {
      return;
    }
    this.mInterfaceCallQueue.splice(0, 1);
    if (this.mInterfaceCallQueue.length > 0) {
      this.execInterfaceCallQueueFirst();
    }
  }

  async executeCall(): Promise<void> {
    if (this.mIsLoop) {
      log.showInfo(TAG, `Add task to queue, Length: ${this.mInterfaceCallQueue.length}`);
      return;
    }
    this.mIsLoop = true;
    while (this.mInterfaceCallQueue.length > 0) {
      await this.runTask();
    }
    this.mIsLoop = false;
  }

  async runTask(): Promise<void> {
    let queueData = this.mInterfaceCallQueue[0];
    log.showInfo(TAG, `runTask queueLength: ${this.mInterfaceCallQueue.length}`);
    if (queueData.interfaceName === InterfaceName.isMute) {
      if (queueData.params[0] == null) {
        this.mInterfaceCallQueue.splice(0, 1);
        queueData.callbackFunction('', null);
        return;
      }
      await this.mAudioManager.isMute(queueData.params[0] as audio.AudioVolumeType)
        .then((value) => {
          log.showInfo(TAG, 'runTask isMute return');
          queueData.callbackFunction(null, value);
          this.mInterfaceCallQueue.splice(0, 1);
        })
        .catch((err: Error) => {
          log.showError(TAG, 'runTask isMute return error');
          this.mInterfaceCallQueue.splice(0, 1);
          queueData.callbackFunction(err, null);
        });
    } else if (queueData.interfaceName === InterfaceName.mute) {
      if (queueData.params[0] == null || queueData.params[1] == null) {
        this.mInterfaceCallQueue.splice(0, 1);
        queueData.callbackFunction('');
        return;
      }
      await this.mAudioManager.mute(queueData.params[0] as audio.AudioVolumeType, queueData.params[1] as boolean)
        .then(() => {
          log.showInfo(TAG, 'runTask mute return success');
          queueData.callbackFunction(null);
          this.mInterfaceCallQueue.splice(0, 1);
          this.publishRingModeEvent(queueData.params[0] as audio.AudioVolumeType, queueData.params[1] as boolean);
        })
        .catch((err: Error) => {
          log.showError(TAG, 'runTask mute return error');
          this.mInterfaceCallQueue.splice(0, 1);
          queueData.callbackFunction(err);
        });
    } else if (queueData.interfaceName === InterfaceName.getVolume) {
      if (queueData.params[0] == null) {
        this.mInterfaceCallQueue.splice(0, 1);
        queueData.callbackFunction('', null);
        return;
      }
      await this.mAudioManager.getVolume(queueData.params[0] as audio.AudioVolumeType)
        .then((value) => {
          log.showInfo(TAG, 'runTask getVolume return');
          queueData.callbackFunction(null, value);
          this.mInterfaceCallQueue.splice(0, 1);
        })
        .catch((err: Error) => {
          log.showError(TAG, 'runTask getVolume return error');
          this.mInterfaceCallQueue.splice(0, 1);
          queueData.callbackFunction(err, null);
        });
    } else if (queueData.interfaceName === InterfaceName.setVolume) {
      if (queueData.params[0] == null || !queueData.params[1] == null) {
        this.mInterfaceCallQueue.splice(0, 1);
        queueData.callbackFunction('');
        return;
      }
      await this.mAudioManager.setVolume(queueData.params[0] as audio.AudioVolumeType, queueData.params[1] as number)
        .then(() => {
          log.showInfo(TAG, `setVolume, type: ${queueData.params[0]}, value: ${queueData.params[1]}`);
          log.showInfo(TAG, 'runTask setVolume return success');
          queueData.callbackFunction(null);
          this.mInterfaceCallQueue.splice(0, 1);
          this.publishRingModeEvent(queueData.params[0] as audio.AudioVolumeType, queueData.params[1] <= 0);
        })
        .catch((err: Error) => {
          log.showError(TAG, 'runTask setVolume return error');
          this.mInterfaceCallQueue.splice(0, 1);
          queueData.callbackFunction(err);
        });
    }
  }

  private publishRingModeEvent(volumeType: audio.AudioVolumeType, isMute: boolean): void {
    if (volumeType !== audio.AudioVolumeType.RINGTONE) {
      return;
    }
    let ringMode = isMute ? audio.AudioRingMode.RINGER_MODE_VIBRATE : audio.AudioRingMode.RINGER_MODE_NORMAL;
    sEventManager.publish(obtainLocalEvent(EventConstants.RING_MODE_EVENT, ringMode));
  }

  /**
   * 多模物理音量按键监听不可用（只能有一个监听者），使用音量变化判断音量按键
   *
   * @param currentVolume 变化后的音量
   */
  private notifyVolumeKeyPressed(currentVolume: VolumeInfo): void {
    if (!this.mPreviousVolumeCallback || !currentVolume || !currentVolume.updateUi) {
      return;
    }
    let previousVolume = this.mPreviousVolumeCallback.getPreviousVolume(currentVolume.volumeType) as VolumeInfo;
    if (!previousVolume) {
      return;
    }
    let minVolume = previousVolume.minVolume;
    let deltaVolume = currentVolume.volume - previousVolume.volume;
    let isKeyUp = false;
    if (deltaVolume > 0) {
      isKeyUp = true;
    } else if (deltaVolume < 0) {
      isKeyUp = false;
    } else {
      isKeyUp = minVolume !== currentVolume.volume;
    }
    log.showDebug(TAG, `on volume key pressed isKeyUp: ${isKeyUp}`);
    HiDfxEventUtil.reportAdjustVolByPressButton(currentVolume.volumeType, currentVolume.volume);

    this.keyPressListeners?.forEach((listener: VolumeKeyPressedListener) => {
      log.showInfo(TAG, `this.keyPressListener`);
      listener?.onKeyPressed?.(currentVolume);
    });
    this.mVolumeKeyPressedListener?.forEach((listener: VolumeKeyPressedListener) => {
      listener?.onVolumeKeyPressed(isKeyUp, currentVolume.volumeType);
    });
  }

  private getIsVolumeTypeActive = async (volumeType: audio.AudioVolumeType): Promise<boolean> => {
    let isActive: boolean = false;
    try {
      isActive = await SystemUICommonUtil.timeout(this.mAudioStreamManager.isActive(volumeType),
        Constants.VOLUME_IS_ACTIVE_TIMEOUT);
    } catch (e) {
      log.error(TAG, `getActiveVolumeType error,code: ${e?.code}, msg:${e?.message}`);
    }
    return isActive;
  }

  private getActiveVolumeType = async (activeType: audio.AudioVolumeType): Promise<void> => {
    const activeTypes: Promise<boolean>[] = [];
    for (const volumeType of Constants.VOLUME_TYPE_WEIGHTS as audio.AudioVolumeType[]) {
      const isNeedQuery = volumeType !== activeType && volumeType !== audio.AudioVolumeType.ACCESSIBILITY;
      activeTypes.push(isNeedQuery ? this.getIsVolumeTypeActive(volumeType) : Promise.resolve(true));
    }
    VolumePanelVM.globalVolumeActiveTypes = await Promise.all(activeTypes);
    VolumePanelVM.globalCurrentVolumeActive = activeType;
  }

  /**
   * 音频API音量变化的回调(Phone & Pad)
   * @param data 音频返回的数据
   * @returns
   */
  private onVolumeChangeSync = async (data: audio.VolumeEvent): Promise<void> => {
    if (ScreenLockApi.getLock()) {
      // 锁屏下未激活媒体音频时不展示UI follow双
      log.showInfo(TAG, `screen locked`);
      const isActiveMedia = await this.mAudioStreamManager.isActive(audio.AudioVolumeType.MEDIA);
      if (data.volumeType === audio.AudioVolumeType.MEDIA && !isActiveMedia) {
        log.showInfo(TAG, `no need show UI ${data.volumeType} ${isActiveMedia}`);
        return;
      }
    }
    if (!this.volumePanelNeedShow) {
      log.showInfo(TAG, `Panels do not need to show`);
      return;
    }
    log.showWarn(TAG, `onVolumeChange, data: Sync type ${data.volumeType} volume ${data.volume} update ${data.updateUi}`);
    if (!ViewManagerPolicy.isViewShowing(ViewType.VOLUME) && data.updateUi) {
      await this.getActiveVolumeType(data.volumeType);
      log.showInfo(TAG, `getActiveVolumeType success ${VolumePanelVM.globalVolumeActiveTypes.length}`);
    }
    let volumeType = this.formatAudioVolumeTypeFromInterface(data.volumeType);
    let volumeInfo: VolumeInfo = {
      // 音量流类型
      volumeType: volumeType,
      // 音量等级
      volume: data.volume,
      isMute: false,
      // 在UI中显示音量变化: true显示, false不显示
      updateUi: data.updateUi,
      isActive: true,
      maxVolume: Constants.DEFAULT_VOLUME_INVALID,
      minVolume: Constants.DEFAULT_VOLUME_INVALID,
      lastVolume: data.volume
    };
    log.debug(TAG, `Publish volume change: ${volumeInfo.volumeType} volume ${volumeInfo.volume} update ${volumeInfo.updateUi}`);
    this.notifyVolumeKeyPressed(volumeInfo); // 该方法使用了全局VolumeInfo对象，与下一句更新音量不可修改顺序
    this.mListeners.forEach(listener => {
      listener.updateVolumeInfo(volumeInfo);
    });
    sEventManager.publish(obtainLocalEvent(VOLUME_CHANGE_EVENT, volumeInfo));
  };
}

let volumePanelService = SingletonHelper.getInstance(VolumePanelService, TAG);

export default volumePanelService as VolumePanelService;