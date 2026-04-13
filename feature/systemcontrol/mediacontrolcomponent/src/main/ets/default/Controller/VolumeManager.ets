/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import audio from '@ohos.multimedia.audio'
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { sEventManager, unsubscribe } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import AVSessionManager from '@ohos.multimedia.avsession';
import CastDeviceManager from './CastDeviceManager';
import Constants, { VolumeInfo, LocalDeviceInfo, SetVolumeType, InputVolumeAction } from '../Util/Constants';
import SessionInfoProvider from './SessionInfoProvider';
import { CommonInterface } from './MediaInfoProvider';
import { BusinessError } from '@ohos.base';
import { EventType } from '../Util/HiSysEvent';
import { DfxParam } from '../Util/CommonInterface';
import { globalStorage } from '../Util/GlobalStorage';
import MediaInfoProvider from './MediaInfoProvider';
import { LocalEventCallback } from '../Util/LocalEventCallBack';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { StubAudioVolumeManager } from
  '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubAudioVolumeManager';

const TAG = 'VolumeManager_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const PACKAGE_NAME = 'com.ohos.mediacontroller';
PersistentStorage.PersistProp('lastVolumeSliderPosition', 0);
PersistentStorage.PersistProp('lastCallVolumeSliderPosition', 0);
PersistentStorage.PersistProp('lastCastVolumeSliderPosition', 0);

export default class VolumeManager {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private audioManager: audio.AudioManager;
  private curSessionIdLink: AbstractProperty<string>;
  private volumeLink: AbstractProperty<number>;
  private callVolumeLink: AbstractProperty<number>;
  // local
  private audioMinVolume: number = 0;
  private audioMaxVolume: number = 0;
  private audioCurVolume: number = 0;
  private audioStepVolume: number = 0;
  private isVolumeSlide: boolean = false;
  // call
  private callMinVolume: number = 0;
  private callMaxVolume: number = 0;
  private callCurVolume: number = 0;
  private callStepVolume: number = 0;
  private isCallVolumeSlide: boolean = false;

  // cast
  private castAudioMaxVolume: number = 0;
  private castAudioCurVolume: number = 0;
  private castAudioStepVolume: number = 0;
  private isCastVolumeSlide: boolean = false;
  // slider
  private audioSliderTimerId: number = 0;
  private callSliderTimerId: number = 0;
  // interface
  private commonInterface: CommonInterface | undefined = undefined;
  private static volumeSelf: VolumeManager | undefined = undefined;
  private sessionProvider: SessionInfoProvider | undefined = undefined;
  // 投播音量指令流控
  private castCommandSending: boolean = false;
  private castCommandTimerId: number = 0;
  // 本地音量指令流控
  private localCommandSending: boolean = false;
  private localCommandTimerId: number | undefined = undefined;
  private lastVolumeTimerId: number | undefined = undefined;
  // 用于解除音量监听
  private unSubscriber?: unsubscribe = undefined;
  private pInfoName = globalStorage.getStringByKey('packageName');
  private pInfoVersion = globalStorage.getStringByKey('packageVersion');
  private deviceChangeCallback: LocalEventCallback | undefined = undefined;
  private callStateChangeCallback: LocalEventCallback | undefined = undefined;

  constructor() {
    const sliderPosition = AppStorage.Get<number>('lastVolumeSliderPosition');
    const castSliderPosition = AppStorage.Get<number>('lastCastVolumeSliderPosition');
    const callSliderPosition = AppStorage.Get<number>('lastCallVolumeSliderPosition');
    log.showInfo(`volume manager constructor: ${sliderPosition}, ${castSliderPosition}, ${callSliderPosition}`);
    this.volumeLink = AppStorage.setAndRef('Volume', 0);
    this.callVolumeLink = AppStorage.setAndRef('callVolume', 0);
    this.curSessionIdLink = AppStorage.setAndRef('CurSessionId', '');
    this.audioManager = audio.getAudioManager();
    if (!this.audioManager) {
      log.warn('get audioManager fail !');
      return;
    }
  }

  static getInstance(commonInterface?: CommonInterface) : VolumeManager {
    log.showInfo('media getInstance')
    if (!VolumeManager.volumeSelf) {
      VolumeManager.volumeSelf = new VolumeManager();
      VolumeManager.volumeSelf.init();
      CastDeviceManager.on('deviceChanged', VolumeManager.volumeSelf.getDeviceChangeCallback());
      CastDeviceManager.on('callStateChange', VolumeManager.volumeSelf.getCallStateChangeCallback());
    }
    if (!!commonInterface) {
      VolumeManager.volumeSelf.commonInterface = commonInterface;
    }
    return VolumeManager.volumeSelf;
  }

  release() {
    log.showInfo('VolumeManager release')
    VolumeManager.volumeSelf = undefined;
    CastDeviceManager.off('deviceChanged', this.getDeviceChangeCallback());
    CastDeviceManager.off('callStateChange', this.getCallStateChangeCallback());
    this.commonInterface = undefined;
    this.sessionProvider = undefined;
    // 解除监听，释放内存
    if (this.unSubscriber) {
      this.unSubscriber();
      this.unSubscriber = undefined;
    }
  }

  setCastVolumeParams(minVolume: number, maxVolume: number, curVolume: number) {
    // 音量长按标记，避免对端延迟回调引起跳变
    if (AppStorage.get('soundLongPress')) {
      return;
    }
    log.showInfo(`set Cast Volume Params: [${minVolume}, ${maxVolume}], cur=${curVolume}`);
    this.castAudioStepVolume = Math.round(Constants.CAST_VOLUME_MAX / (maxVolume - minVolume)) || 1;
    this.castAudioMaxVolume = maxVolume * this.castAudioStepVolume > Constants.CAST_VOLUME_MAX ?
      Constants.CAST_VOLUME_MAX : maxVolume * this.castAudioStepVolume;
    this.castAudioCurVolume = curVolume * this.castAudioStepVolume;
    log.showInfo(`set Cast Volume Params done: step=${this.castAudioStepVolume}`);
  }

  updateVolumeSet(volume: number, type: SetVolumeType, needRestore = false) {
    const sessionId = this.curSessionIdLink.get();
    log.showInfo(`update volume: ${volume}, needRestore=${needRestore}, type=${type},
      ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))}`);
    if ((type === SetVolumeType.AUDIO) || (type === SetVolumeType.CAST)) {
      log.showInfo(`set audio volume not match with cast mode: type=${type}`);
      return;
    }
    if (volume < 0) {
      log.showInfo(`get volume with invalid number: ${volume}`);
      return;
    }
    let targetVolume = volume;
    if (needRestore) {
      if (type === SetVolumeType.CALL) {
        const callSliderPosition: number = AppStorage.get<number>('lastCallVolumeSliderPosition') as number;
        const volumeStep = this.callStepVolume;
        const isAlmostStart = callSliderPosition > 0 && callSliderPosition < volumeStep;
        const isAlmostEnd = callSliderPosition > Constants.CALL_VOLUME_SLIDER_MAX - volumeStep &&
          callSliderPosition < Constants.CALL_VOLUME_SLIDER_MAX;
        if ((isAlmostStart && volume <= volumeStep && volume !== 0) ||
          (isAlmostEnd && volume >= Constants.CALL_VOLUME_SLIDER_MAX - volumeStep &&
            volume !== Constants.CALL_VOLUME_SLIDER_MAX)) {
          targetVolume = callSliderPosition;
        } else {
          AppStorage.setOrCreate('lastCallVolumeSliderPosition', 0);
        }
        this.callVolumeLink.set(targetVolume);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncAppStorage', { name: 'callVolume', value: targetVolume });
        }
      } else {
        const sliderPosition: number = AppStorage.get<number>(
          type === SetVolumeType.AUDIO ? 'lastVolumeSliderPosition' : 'lastCastVolumeSliderPosition'
        ) as number;
        const volumeStep = type === SetVolumeType.AUDIO ? this.audioStepVolume : this.castAudioStepVolume;
        const isAlmostStart = sliderPosition > 0 && sliderPosition < volumeStep;
        const isAlmostEnd = sliderPosition > Constants.VOLUME_SLIDER_MAX - volumeStep &&
          sliderPosition < Constants.VOLUME_SLIDER_MAX;
        log.showInfo(`restore current slider: ${sliderPosition},
        step= ${volumeStep}, [${isAlmostStart}, ${isAlmostEnd}]`);
        if ((isAlmostStart && volume <= volumeStep && volume !== 0) ||
          (isAlmostEnd && volume >= Constants.VOLUME_SLIDER_MAX - volumeStep &&
            volume !== Constants.VOLUME_SLIDER_MAX)) {
          targetVolume = sliderPosition;
        } else {
          AppStorage.setOrCreate(type === SetVolumeType.AUDIO ? 'lastVolumeSliderPosition' :
            'lastCastVolumeSliderPosition', 0);
        }
        this.volumeLink.set(targetVolume);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncAppStorage', { name: 'Volume', value: targetVolume });
        }
        log.showInfo(`update volume done: ${targetVolume}`);
      }
    }
  }

  private async init() {
    log.showInfo('deviceChanged listen');
    this.sessionProvider = await SessionInfoProvider.getInstance();

    Promise.all([
      this.audioManager.getMinVolume(audio.AudioVolumeType.MEDIA),
      this.audioManager.getMaxVolume(audio.AudioVolumeType.MEDIA),
      this.audioManager.getVolume(audio.AudioVolumeType.MEDIA)
    ]).then((values) => {
      this.audioMinVolume = values[0];
      log.showInfo(`Promised return min volume: ${values[0]}`);
      this.audioMaxVolume = values[1];
      log.showInfo(`Promised return max volume: ${values[1]}`);
      this.audioCurVolume = values[2];
      log.showInfo(`Promised return volume: ${values[2]}`);
      this.audioStepVolume = Constants.VOLUME_SLIDER_MAX / (this.audioMaxVolume - this.audioMinVolume);
      this.updateVolumeSet((this.audioCurVolume - this.audioMinVolume) * this.audioStepVolume,
        SetVolumeType.AUDIO, true);
    });

    // call volume init
    Promise.all([
      this.audioManager.getMinVolume(audio.AudioVolumeType.VOICE_CALL),
      this.audioManager.getMaxVolume(audio.AudioVolumeType.VOICE_CALL),
      this.audioManager.getVolume(audio.AudioVolumeType.VOICE_CALL)
    ]).then((values) => {
      this.callMinVolume = values[0];
      log.showInfo(`Promised return min call volume: ${values[0]}`);
      this.callMaxVolume = values[1];
      log.showInfo(`Promised return max call volume: ${values[1]}`);
      this.callCurVolume = values[2];
      log.showInfo(`Promised return call volume: ${values[2]}`);
      this.callStepVolume = Constants.CALL_VOLUME_SLIDER_MAX / this.callMaxVolume;
      this.updateVolumeSet(this.callCurVolume * this.callStepVolume, SetVolumeType.CALL, true);
    });

    this.unSubscriber = sEventManager.subscribe('volumeChangeEvent', (data: VolumeInfo) => {
      this.onVolumeChange(data)
    });
  }

  getDfxParam(volume: number): DfxParam {
    let mediaInfoProvider = MediaInfoProvider.getInstance();
    let devType: number = mediaInfoProvider.getCurrentDeviceType();
    let screenFoldedStatus: number = mediaInfoProvider.getFold();
    let screenStatus: number = mediaInfoProvider.getScreenStatus();
    const dfxParam : DfxParam = {
      PACKAGE_NAME: PACKAGE_NAME,
      DEVICE_TYPE: devType,
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      VOLUME: volume,
      CONTROLINTERFACE: globalStorage.getNumberByKey('isShowSwitch'),
      TIME: new Date().getTime(),
      SCREENSTATUS: screenStatus,
      DEVICEMODELTYPE: mediaInfoProvider.getDeviceModelType(),
      SCREENFOLDEDSTATUS: screenFoldedStatus
    };
    return dfxParam;
  }

  onVolumeChange(data: VolumeInfo) {
    let type: audio.AudioVolumeType = data.volumeType;
    let num: number = data.volume;
    log.showInfo(`volumeChange ${JSON.stringify(data)}`)
    if (type == audio.AudioVolumeType.MEDIA) {
      log.showInfo(' new Volume :' + num);
      this.audioCurVolume = num;
      let curVolumeChange = (num - this.audioMinVolume) * this.audioStepVolume;
      let curVolumeShowing = this.volumeLink.get();
      log.showInfo(' volume change  :' + curVolumeChange + '|' + curVolumeShowing);
      log.showInfo(' volume set showing  :' + curVolumeChange);
      this.updateVolumeSet(curVolumeChange, SetVolumeType.AUDIO, true);
      const dfxParam = this.getDfxParam(num);
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_DEVICE_ADJUST_VOLUME, dfxParam, true);
      log.showInfo(' new Volume num  :' + this.volumeLink.get());
    }
    if (type == audio.AudioVolumeType.VOICE_CALL) {
      log.showInfo(' call volume  new Volume :' + num);
      this.callCurVolume = num;
      let curVolumeChange = num * this.callStepVolume;
      let curVolumeShowing = this.callVolumeLink.get();
      log.showInfo(' call volume change  :' + curVolumeChange + '|' + curVolumeShowing);
      log.showInfo(' call volume volume set showing  :' + curVolumeChange);
      this.updateVolumeSet(curVolumeChange, SetVolumeType.CALL, true);
      const dfxParam = this.getDfxParam(num);
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_DEVICE_ADJUST_VOLUME, dfxParam, true);
      log.showInfo('call volume new Volume num  :' + this.callVolumeLink.get());
    }
  }

  getDeviceChangeCallback(): LocalEventCallback {
    if (!this.deviceChangeCallback) {
      this.deviceChangeCallback = new LocalEventCallback(async (eventData: LocalDeviceInfo) => {
        log.showInfo('device changed, refresh volume state' + eventData);
        this.refreshVolumeState();
      });
    }
    return this.deviceChangeCallback;
  }

  getCallStateChangeCallback(): LocalEventCallback {
    if (!this.callStateChangeCallback) {
      this.callStateChangeCallback = new LocalEventCallback((hasCall: boolean) => {
        this.refreshVolumeState();
      });
    }
    return this.callStateChangeCallback;
  }

  async getCurrentVolume() :Promise<number> {
    return this.audioManager.getVolume(audio.AudioVolumeType.MEDIA).then((data) => {
      log.showInfo(`this is media current volume: ${data}`)
      return data * this.audioStepVolume;
    });
  }
  async getCurrentCallVolume() :Promise<number> {
    return this.audioManager.getVolume(audio.AudioVolumeType.VOICE_CALL).then((data) => {
      log.showInfo(`this is call current volume: ${data}`)
      return data * this.callStepVolume;
    });
  }
  refreshVolumeState() {
    Promise.all([
      this.audioManager.getMinVolume(audio.AudioVolumeType.MEDIA),
      this.audioManager.getMaxVolume(audio.AudioVolumeType.MEDIA),
      this.audioManager.getVolume(audio.AudioVolumeType.MEDIA),
    ]).then((values: number[]) => {
      if (this.audioMinVolume === values[0] && this.audioMaxVolume === values[1] &&
        this.audioCurVolume === values[2]) {
        return;
      }
      this.audioMinVolume = values[0];
      this.audioMaxVolume = values[1];
      this.audioCurVolume = values[2];
      log.showInfo(`update audio volume ${this.audioCurVolume}, ${this.audioMaxVolume}, ${this.audioMinVolume}`);
      this.audioStepVolume = Constants.VOLUME_SLIDER_MAX / (this.audioMaxVolume - this.audioMinVolume);
      this.updateVolumeSet((this.audioCurVolume - this.audioMinVolume) * this.audioStepVolume,
        SetVolumeType.AUDIO, true);
    });

    Promise.all([
      this.audioManager.getMinVolume(audio.AudioVolumeType.VOICE_CALL),
      this.audioManager.getMaxVolume(audio.AudioVolumeType.VOICE_CALL),
      this.audioManager.getVolume(audio.AudioVolumeType.VOICE_CALL),
    ]).then((values: number[]) => {
      if (this.callMinVolume === values[0] && this.callMaxVolume === values[1] &&
        this.callCurVolume === values[2]) {
        return;
      }
      this.callMinVolume = values[0];
      this.callMaxVolume = values[1];
      this.callCurVolume = values[2];
      log.showInfo(`update call volume ${this.callCurVolume}, ${this.callMaxVolume}, ${this.callMinVolume}`);
      this.callStepVolume = Constants.CALL_VOLUME_SLIDER_MAX / this.callMaxVolume;
      this.updateVolumeSet(this.callCurVolume * this.callStepVolume, SetVolumeType.CALL, true);
    });
  }

  async callVolumeChange(volume: number, mode: number, type: SetVolumeType, sessionId?: string) {
    log.showInfo(`input volume: ${volume}, ${mode}, ${type}`);
    if (type === SetVolumeType.CALL) {
      // get call volume
      AppStorage.setOrCreate('lastCallVolumeSliderPosition', volume);
      log.showInfo(`call volume input volume: volume = ${AppStorage.Get('lastCallVolumeSliderPosition')}`);
      const volumeStep = this.callStepVolume;
      const volumeMax = this.callMaxVolume;
      const volumeMin = this.callMinVolume;
      let settingVolume = volume / volumeStep;
      if (settingVolume <= volumeMin) {
        settingVolume = volumeMin;
      } else if (settingVolume < volumeMin + 1) {
        settingVolume = volumeMin + 1;
      } else if (settingVolume >= volumeMax) {
        settingVolume = volumeMax;
      } else if (settingVolume > volumeMax - 1) {
        settingVolume = volumeMax - 1;
      } else {
        settingVolume = Math.round(settingVolume);
      }
      this.isCallVolumeSlide = true;
      if (mode != SliderChangeMode.Begin && mode != SliderChangeMode.Moving) {
        this.callSliderTimerId = setTimeout(() => {
          const volumeCur = this.callCurVolume;
          log.showInfo('delay 300ms to turn on volume listener: ' + volumeCur + ', ' + settingVolume + ', ' + type);
          if (volumeCur != settingVolume) {
            log.showInfo(' later volume change : ' + volumeCur + '|' + settingVolume);
            this.updateVolumeSet(volumeCur * this.callStepVolume, type, true);
          }
          this.isCallVolumeSlide = false;
        }, 300);
        log.showInfo(' set audioSliderTimer : ' + this.audioSliderTimerId);
      }

      this.audioManager.setVolume(audio.AudioVolumeType.VOICE_CALL, settingVolume).then(() => {
        const dfxParam = this.getDfxParam(settingVolume);
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_DEVICE_ADJUST_VOLUME, dfxParam, true);
      }).catch((errorCode : BusinessError) => {
        let dfxParam : DfxParam = {PACKAGE_NAME : PACKAGE_NAME, OPERATE_TYPE : 'ADJUST_VOLUME', COLD_START: false,
          REASON: errorCode.message};
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
      });

    } else {
      // media volume
      log.showInfo('media volume change : ' + volume + '|' + mode);
      AppStorage.setOrCreate(type === SetVolumeType.AUDIO ? 'lastVolumeSliderPosition' :
        'lastCastVolumeSliderPosition', volume);
      const volumeStep = type === SetVolumeType.AUDIO ? this.audioStepVolume : this.castAudioStepVolume;
      const volumeMax = type === SetVolumeType.AUDIO ? this.audioMaxVolume : this.castAudioMaxVolume;
      let settingVolume = volume / volumeStep;
      log.showInfo('cal target volume: ' + settingVolume + '|' + volumeMax);
      if (settingVolume > 0 && settingVolume < 1) {
        settingVolume = 1;
      } else if (settingVolume > volumeMax - 1 && settingVolume < volumeMax) {
        settingVolume = volumeMax - 1;
      } else {
        settingVolume = Math.round(settingVolume);
      }
      log.showInfo('call volume change : ' + volume + '|' + settingVolume + '|' + mode);
      if (mode != SliderChangeMode.Moving) {
        log.showInfo(' clear audioSliderTimer : ' + this.audioSliderTimerId);
        clearTimeout(this.audioSliderTimerId);
      }
      this.isVolumeSlide = type === SetVolumeType.AUDIO;
      this.isCastVolumeSlide = type === SetVolumeType.CAST;
      if (mode != SliderChangeMode.Begin && mode != SliderChangeMode.Moving) {
        this.audioSliderTimerId = setTimeout(() => {
          const volumeCur = type === SetVolumeType.AUDIO ? this.audioCurVolume : this.castAudioCurVolume;
          log.showInfo('delay 300ms to turn on volume listener: ' + volumeCur + ', ' + settingVolume + ', ' + type);
          if (volumeCur != settingVolume) {
            log.showInfo(' later volume change : ' + volumeCur + '|' + settingVolume);
            this.updateVolumeSet(volumeCur * this.audioStepVolume, type, true);
          }
          this.isVolumeSlide = false;
          this.isCastVolumeSlide = false;
        }, type === SetVolumeType.AUDIO ? 300 : 400);
        log.showInfo(' set audioSliderTimer : ' + this.audioSliderTimerId);
      }
      const dfxParam = this.getDfxParam(settingVolume);
      if (type === SetVolumeType.AUDIO) {
        log.showInfo(' set volume : ' + settingVolume);
        if (this.lastVolumeTimerId) {
          clearTimeout(this.lastVolumeTimerId);
          this.lastVolumeTimerId = undefined;
        }
        if (this.localCommandSending && mode != SliderChangeMode.End) {
          log.showInfo( `sendControlCommand: local set volume last in sending`);
          // 延迟设置最后一次拖动的音量，避免音量丢失
          this.lastVolumeTimerId = setTimeout(() => {
            log.showInfo(`last volume with timer: ${settingVolume}`)
            this.setAudioVolume(settingVolume, dfxParam);
          }, 300);
          return;
        }
        if (this.localCommandTimerId) {
          clearTimeout(this.localCommandTimerId);
          this.localCommandTimerId = undefined;
        }
        if (mode === SliderChangeMode.End) {
          log.showInfo(`set volume with slider end: ${settingVolume}`);
          this.audioManager?.setVolume(audio.AudioVolumeType.MEDIA, settingVolume).then(() => {
            this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_DEVICE_ADJUST_VOLUME, dfxParam, true);
          })
            .catch((errorCode : BusinessError) => {
              let dfxParam : DfxParam = {PACKAGE_NAME : PACKAGE_NAME, OPERATE_TYPE : 'ADJUST_VOLUME', COLD_START: false,
                REASON: errorCode.message};
              this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
            });
          this.localCommandSending = false;
          return;
        }
        this.localCommandSending = true;
        this.localCommandTimerId = setTimeout(() => {
          log.showInfo(`set volume with timer: ${settingVolume}`);
          this.setAudioVolume(settingVolume, dfxParam);
          clearTimeout(this.localCommandTimerId);
          this.localCommandTimerId = undefined;
        }, 200);
      }
    }
  }

  /**
   * 设置本地音量
   * @param settingVolume
   * @param dfxParam
   */
  setAudioVolume(settingVolume: number, dfxParam : DfxParam) {
    log.showInfo(`set volume with slider: ${settingVolume}`);
    this.audioManager?.setVolume(audio.AudioVolumeType.MEDIA, settingVolume).then(() => {
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_DEVICE_ADJUST_VOLUME, dfxParam, true);
    })
      .catch((errorCode : BusinessError) => {
        let dfxParam : DfxParam = {PACKAGE_NAME : PACKAGE_NAME, OPERATE_TYPE : 'ADJUST_VOLUME', COLD_START: false,
          REASON: errorCode.message};
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
      });
    this.localCommandSending = false;
  }

  async setPcmCastVolume(sessionId: string, actionType: InputVolumeAction) {
    try {
      let bundleInfo = await this.sessionProvider?.getBundleInfoForSession(sessionId);
      if (!bundleInfo) {
        log.showError(`setPcmCastVolume bundle not found`);
        return;
      }
      let uid = bundleInfo.appInfo.uid;
      let currentVolume: number = StubAudioVolumeManager.getSystemVolumeByUid(this.audioManager.getVolumeManager(),
        audio.AudioVolumeType.MEDIA, uid);
      currentVolume = currentVolume < this.audioMinVolume ? this.audioMinVolume : currentVolume;
      currentVolume = currentVolume > this.audioMaxVolume ? this.audioMaxVolume : currentVolume;
      let newVolume = currentVolume + (actionType === InputVolumeAction.PLUS ?  1 : -1);
      newVolume = newVolume < this.audioMinVolume ? this.audioMinVolume : newVolume;
      newVolume = newVolume > this.audioMaxVolume ? this.audioMaxVolume : newVolume;
      log.showInfo(`setPcmCastVolume ${actionType} uid ${uid} currentVolume ${currentVolume} newVolume ${newVolume}`);
      StubAudioVolumeManager.setSystemVolumeByUid(this.audioManager.getVolumeManager(),
        audio.AudioVolumeType.MEDIA, newVolume, uid);
    } catch (err) {
      log.showError(`setPcmCastVolume err code ${err.code} message ${err.message}`);
    }
  }

  /**
   * 设置投播音量
   * @param sessionId
   * @param actionType
   */
  callCastVolumeChange(sessionId: string, actionType: InputVolumeAction) {
    let settingVolume = actionType === InputVolumeAction.PLUS ? this.castAudioCurVolume + this.castAudioStepVolume :
      this.castAudioCurVolume - this.castAudioStepVolume;
    if (settingVolume < 0) {
      settingVolume = 0;
    } else if (settingVolume > this.castAudioMaxVolume) {
      settingVolume = this.castAudioMaxVolume;
    } else {
      settingVolume = Math.round(settingVolume);
    }
    log.showWarn(`settingVolume ${settingVolume},castAudioCurVolume ${this.castAudioCurVolume}`)
    if (this.castAudioCurVolume === settingVolume) {
      return;
    }
    if (!this.commonInterface) {
      log.showInfo( `sendControlCommand error`);
      return;
    }
    this.castAudioCurVolume = settingVolume;
    let setVolumeCommand : AVSessionManager.AVCastControlCommand = { command: 'setVolume',
      parameter: settingVolume };
    const dfxParam = this.getDfxParam(settingVolume);
    this.commonInterface?.sendControlCommand(sessionId, setVolumeCommand).then(() => {
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_DEVICE_ADJUST_VOLUME, dfxParam, true);
    })
      .catch((errorCode : BusinessError) => {
        let dfxParam : DfxParam = {PACKAGE_NAME : PACKAGE_NAME, OPERATE_TYPE : 'ADJUST_VOLUME', COLD_START: false,
          REASON: errorCode.message};
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
      });
  }

  async getNextVolume(type: SetVolumeType, inputType: InputVolumeAction) {
    let volumeMin = type === SetVolumeType.CALL ? this.callMinVolume : this.audioMinVolume;
    let volumeStep = type === SetVolumeType.CALL ? this.callStepVolume : this.audioStepVolume;
    let volumeMax = type === SetVolumeType.CALL ? this.callMaxVolume : this.audioMaxVolume;
    let currentVolume = type === SetVolumeType.CALL ? this.callCurVolume: this.audioCurVolume;
    log.showWarn(`currentVolume ${currentVolume}, step ${volumeStep}, max ${volumeMax}, min ${volumeMin}`)
    let settingVolume = inputType === InputVolumeAction.PLUS ? currentVolume + 1 : currentVolume - 1;
    if (settingVolume <= volumeMin) {
      settingVolume = volumeMin;
    } else if (settingVolume < volumeMin + 1) {
      settingVolume = volumeMin + 1;
    } else if (settingVolume >= volumeMax) {
      settingVolume = volumeMax;
    } else if (settingVolume > volumeMax - 1) {
      settingVolume = volumeMax - 1;
    } else {
      settingVolume = Math.round(settingVolume);
    }
    settingVolume = settingVolume * volumeStep;
    log.showInfo(`getNextVolume ${settingVolume}`);
    return settingVolume;
  }
}