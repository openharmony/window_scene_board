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

import audio from '@ohos.multimedia.audio';
import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AudioConstants } from '../common/Constants';

const TAG = 'AudioSoundModel';
const log = Logger.getLogHelper(LogDomain.SCB);

export interface AudioOutputChangeListener4VM {
  onOutputDevicesChange: (devices: audio.AudioDeviceDescriptors) => void
  onCurrentOutputDeviceChange: (device: audio.AudioDeviceDescriptors) => void
  onVolumeChange: (minVolume: number, curVolume: number, maxVolume: number) => void
  onTipVolumeChange: (minVolume: number, curVolume: number, maxVolume: number) => void
  onAudioRendererStreamChange: (rendererInfoArray: audio.AudioRendererChangeInfoArray) => void
};

export class AudioSoundModel {
  private static instance: AudioSoundModel;
  // manager
  private audioManager?: audio.AudioManager;
  private audioRoutingManager?: audio.AudioRoutingManager;
  private audioVolumeManager?: audio.AudioVolumeManager;
  private audioVolumeGroupManager?: audio.AudioVolumeGroupManager;
  private audioStreamManager: audio.AudioStreamManager | undefined;
  // common
  private readonly COMMUNICATION_SCENES: audio.AudioScene[] =
    [audio.AudioScene.AUDIO_SCENE_RINGING, audio.AudioScene.AUDIO_SCENE_VOICE_CHAT];
  private currentScene?: audio.AudioScene;
  // audio output
  private outputListenEnable: boolean = false;
  private rendererInfoForPlay: audio.AudioRendererInfo =
    {
      usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
      rendererFlags: 0
    };
  private rendererInfoForCall: audio.AudioRendererInfo =
    {
      usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
      rendererFlags: 0
    };
  private audioOutputListeners = new Set<AudioOutputChangeListener4VM>();
  private audioOutputDevices: audio.AudioDeviceDescriptors = [];
  private currentOutputDevice: audio.AudioDeviceDescriptors = [];
  private minVolume: number = AudioConstants.DEFAULT_MIN_VOLUME;
  private curVolume: number = AudioConstants.DEFAULT_CUR_VOLUME;
  private maxVolume: number = AudioConstants.DEFAULT_MAX_VOLUME;
  private minTipVolume: number = AudioConstants.DEFAULT_MIN_VOLUME;
  private curTipVolume: number = AudioConstants.DEFAULT_CUR_VOLUME;
  private maxTipVolume: number = AudioConstants.DEFAULT_MAX_VOLUME;
  private audioRendererInfoArray: audio.AudioRendererChangeInfoArray = [];
  private isPc: boolean = DeviceHelper.isPcNot2in1Device();

  public static getInstance(): AudioSoundModel {
    if (AudioSoundModel.instance) {
      return AudioSoundModel.instance;
    }
    AudioSoundModel.instance = new AudioSoundModel();
    return AudioSoundModel.instance;
  }

  /**
   * 订阅音频输出变更监听
   * @param listener 业务监听对象
   * @param caller 调用方
   */
  public registerAudioOutputChangeListener(listener: AudioOutputChangeListener4VM, caller: string): void {
    if (!listener) {
      log.showWarn(TAG, `${caller} registerOutputDevicesListener invalid listener`);
      return;
    }
    this.audioOutputListeners.add(listener);
    log.showInfo(TAG, `${caller} register audioOutputListeners size: ${this.audioOutputListeners.size}`);
    if (this.audioOutputListeners.size > 0 && !this.outputListenEnable) {
      this.outputListenEnable = true;
      this.initOutputStateFromAudio(`by ${TAG} self`);
      this.initListenOutputChangeFromAudio();
    }
    this.refreshOutputStatus4VM(listener);
  }

  /**
   * 取消订阅音频输出变更监听
   * @param listener 业务监听对象
   * @param caller 调用方
   */
  public unregisterAudioOutputChangeListener(listener: AudioOutputChangeListener4VM, caller: string): void {
    if (!listener) {
      log.showWarn(TAG, `${caller} unregisterOutputDevicesListener invalid listener`);
      return;
    }
    this.audioOutputListeners.delete(listener);
    log.showInfo(TAG, `${caller} unregister audioOutputListeners size: ${this.audioOutputListeners.size}`);
    if (this.audioOutputListeners.size === 0 && this.outputListenEnable) {
      this.outputListenEnable = false;
      this.offListenOutputChangeFromAudio();
    }
  }

  /**
   * 判断当前是否为通话场景
   */
  public isCommunicationNow(): boolean {
    return this.COMMUNICATION_SCENES.includes(this.currentScene as audio.AudioScene);
  }

  /**
   * 选择输出设备
   * @param deviceIndex 设备id
   * @param isMedia 媒体/通话场景选择设备
   * @param caller 调用方
   * @param clientUid 应用uid
   */
  public async selectAudioOutputDevice(deviceIndex: number,
    isMedia: boolean, caller: string, clientUid?: number): Promise<boolean> {
    log.showInfo(TAG, `${caller} ${isMedia} selectAudioOutputDevice deviceIndex: ${deviceIndex} begin`);
    const device = this.audioOutputDevices.find((device) => device.id === deviceIndex);
    let selectRes: boolean = false;
    if (device) {
      const audioRendererFilter: audio.AudioRendererFilter = {
        rendererInfo: isMedia ? this.rendererInfoForPlay : this.rendererInfoForCall,
        uid: clientUid ?? undefined
      }
      selectRes = await this.executeSelectAudioOutputDevice(audioRendererFilter, [device]);
    } else {
      log.showWarn(TAG, `${caller} ${isMedia} selectAudioOutputDevice invalid deviceIndex: ${deviceIndex}`);
    }
    return selectRes;
  }

  /**
   * 下发音量
   * @param volumeType 音频流类型
   * @param tarVolume 下发音量
   * @param caller 调用方
   */
  public async setAudioVolume(volumeType: number, tarVolume: number, caller: string): Promise<boolean> {
    log.showInfo(TAG, `${caller} ${volumeType} setAudioVolume tarVolume: ${tarVolume} begin`);
    await this.initAudioVolumeManager();
    let setRes: boolean = false;
    try {
      await this.audioVolumeGroupManager?.setVolume(volumeType, tarVolume);
      setRes = true;
    } catch (e) {
      log.showWarn(TAG, `setAudioVolume error ${e?.message}`);
    }
    return setRes;
  }

  /**
   * 基于音量类型调大/小音量
   * @param volumeType 音量类型
   * @param isUp 调大或调小
   */
  public async turnVolume(volumeType: number, isUp: boolean, caller: string): Promise<boolean> {
    log.showInfo(TAG, `${caller} ${volumeType} turn Volume begin , isUp: ${isUp}`);
    await this.initAudioVolumeManager();
    let turnRes: boolean = false;
    try {
      await this.audioVolumeGroupManager?.adjustSystemVolumeByStep(volumeType,
        isUp ? audio.VolumeAdjustType.VOLUME_UP : audio.VolumeAdjustType.VOLUME_DOWN);
      turnRes = true;
    } catch (error) {
      log.showError(TAG, `turnVolume error ${error?.message}`);
    };
    return turnRes;
  }

  /**
   * 下发静音状态
   *
   * @param volumeType 音频流类型
   * @param tarMuteState 下发静音状态
   * @param caller 调用方
   */
  public async setAudioMute(volumeType: number, tarMuteState: boolean, caller: string): Promise<boolean> {
    log.showInfo(TAG, `${caller} ${volumeType} setAudioMute tarMuteState: ${tarMuteState} begin`);
    await this.initAudioVolumeManager();
    let setRes: boolean = false;
    try {
      await this.audioVolumeGroupManager?.mute(volumeType, tarMuteState);
      setRes = true;
    } catch (e) {
      log.showWarn(TAG, `setAudioMute error ${e?.message}`);
    }
    return setRes;
  }

  /**
   * 基于音量类型获取静音状态
   *
   * @param volumeType 音量类型
   * @param caller 调用方
   * @returns
   */
  public async getMute(volumeType: number, caller: string): Promise<boolean> {
    await this.initAudioVolumeManager();
    log.showInfo(TAG, `${caller} ${volumeType} check if muted begin`);
    let res: boolean = false;
    try {
      res = await this.audioVolumeGroupManager?.isMute(volumeType) as boolean;
    } catch (e) {
      log.showError(TAG, `${caller} get device mute status error: ${e?.message}`);
    }
    log.showInfo(TAG, `${caller} check if volume type ${volumeType} muted end, res ${res}`);
    return res;
  }

  /**
   * 基于音量类型获取最小音量
   *
   * @param volumeType 音量类型
   * @param caller 调用方
   * @returns
   */
  public async getMinVolume(volumeType: number, caller: string): Promise<number> {
    await this.initAudioVolumeManager();
    log.showInfo(TAG, `${caller} get device min volume type ${volumeType} begin`);
    let minVolume: number = AudioConstants.DEFAULT_MIN_VOLUME;
    try {
      minVolume = await this.audioVolumeGroupManager?.getMinVolume(volumeType) ?? minVolume;
    } catch (e) {
      log.showError(TAG, `get device min volume type: ${volumeType} error: ${e?.message}`);
    }
    log.showInfo(TAG, `${caller} getVolume get min vol done ${minVolume} - ${volumeType}`);
    return minVolume;
  }

  /**
   * 基于音量类型获取最大音量
   *
   * @param volumeType 音量类型
   * @param caller 调用方
   * @returns
   */
  public async getMaxVolume(volumeType: number, caller: string): Promise<number> {
    await this.initAudioVolumeManager();
    log.showInfo(TAG, `${caller} get device max volume type ${volumeType} begin`);
    let maxVolume: number = AudioConstants.DEFAULT_MAX_VOLUME;
    try {
      maxVolume = await this.audioVolumeGroupManager?.getMaxVolume(volumeType) ?? maxVolume;
    } catch (e) {
      log.showError(TAG, `get device max volume type: ${volumeType} error: ${e?.message}`);
    }
    log.showInfo(TAG, `${caller} getVolume get max vol done ${maxVolume} - ${volumeType}`);
    return maxVolume;
  }

  /**
   * 基于音量类型获取当前音量
   *
   * @param volumeType 音量类型
   * @param caller 调用方
   * @returns
   */
  public async getCurVolume(volumeType: number, caller: string): Promise<number> {
    await this.initAudioVolumeManager();
    log.showInfo(TAG, `${caller} get device cur volume type ${volumeType} begin`);
    let curVolume: number = AudioConstants.DEFAULT_CUR_VOLUME;
    try {
      curVolume = await this.audioVolumeGroupManager?.getVolume(volumeType) ?? curVolume;
    } catch (e) {
      log.showError(TAG, `get device cur volume type: ${volumeType} error: ${e?.message}`);
    }
    log.showInfo(TAG, `${caller} getVolume get cur vol done ${curVolume} - ${volumeType}`);
    return curVolume;
  }

  /**
   * 初始化查询输出音频数据
   *
   * @param caller 调用方
   */
  public async initOutputStateFromAudio(caller: string): Promise<void> {
    log.showInfo(TAG, `${caller} initOutputStateFromAudio begin`);
    await this.doQueryOutputAudioDevices();
    await this.getPreferOutputDevice();
    await this.getAudioRendererInfoArray();
  }

  constructor() {
    this.initManager();
  }

  private initManager(): void {
    this.initAudioManager();
    this.initAudioRoutingManager();
    this.initAudioVolumeManager();
    this.initAudioStreamManager();
  }

  private initAudioManager(): void {
    try {
      if (!this.audioManager) {
        this.audioManager = audio.getAudioManager();
        log.showInfo(TAG, `init audioManager success`);
      }
    } catch (e) {
      log.showError(TAG, `initAudioManager error: ${e?.message}`);
    }
  }

  private initAudioRoutingManager(): void {
    try {
      if (!this.audioRoutingManager) {
        this.audioRoutingManager = this.audioManager?.getRoutingManager();
        log.showInfo(TAG, `init audioRoutingManager success`);
      }
    } catch (e) {
      log.showError(TAG, `initAudioRoutingManager error: ${e?.message}`);
    }
  }

  private async initAudioVolumeManager(): Promise<void> {
    try {
      if (!this.audioVolumeManager) {
        this.audioVolumeManager = this.audioManager?.getVolumeManager();
        log.showInfo(TAG, `init audioVolumeManager success`);
      }
      if (!this.audioVolumeGroupManager) {
        this.audioVolumeGroupManager =
          await this.audioVolumeManager?.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
        log.showInfo(TAG, `init audioVolumeGroupManager success`);
      }
    } catch (e) {
      log.showError(TAG, `initAudioVolumeManager error: ${e?.message}`);
    }
  }

  private initAudioStreamManager(): void {
    try {
      if (!this.audioStreamManager) {
        this.audioStreamManager = this.audioManager?.getStreamManager();
        log.info(TAG, `init audioStreamManager success`);
      }
    } catch (e) {
      log.error(TAG, `initAudioStreamManager error: ${e?.message}`);
    }
  }

  private initListenOutputChangeFromAudio(): void {
    this.initListenAudioSceneChange();
    this.initListenDeviceChange();
    this.initListenCurrentOutputDeviceChange();
    this.initListenVolumeChange();
    this.initListenAudioRendererChange();
  }

  private offListenOutputChangeFromAudio(): void {
    this.offListenAudioSceneChange();
    this.offListenDeviceChange();
    this.offListenCurrentOutputDeviceChange();
    this.offListenVolumeChange();
    this.offListenAudioRendererChange();
  }

  private async executeSelectAudioOutputDevice(filter: audio.AudioRendererFilter,
    devices: audio.AudioDeviceDescriptors): Promise<boolean> {
    this.initAudioRoutingManager();
    try {
      await this.audioRoutingManager?.selectOutputDeviceByFilter(filter, devices);
    } catch (e) {
      log.showError(TAG, `Select output devices error: ${e?.message}`);
      return false;
    }
    return true;
  }

  private initListenAudioSceneChange(): void {
    this.initAudioManager();
    log.showInfo(TAG, `initListenAudioSceneChange begin`);
    try {
      this.audioManager?.on('audioSceneChange', this.audioSceneChangeCallback);
    } catch (e) {
      log.showError(TAG, `init listen audio scene change error: ${e?.message}`);
    }
    log.showInfo(TAG, `initListenAudioSceneChange end`);
  }

  private offListenAudioSceneChange(): void {
    this.initAudioManager();
    log.showInfo(TAG, `offListenAudioSceneChange begin`);
    try {
      this.audioManager?.off('audioSceneChange', this.audioSceneChangeCallback);
    } catch (e) {
      log.showError(TAG, `off listen audio scene change error: ${e?.message}`);
    }
    log.showInfo(TAG, `offListenAudioSceneChange end`);
  }

  private audioSceneChangeCallback: (audioScene: audio.AudioScene) => void =
    (audioScene: audio.AudioScene) => {
      log.showInfo(TAG, `onAudioSceneChange scene: ${audioScene}-${this.currentScene}`);
      this.currentScene = audioScene;
      // 查询更新主音量
      this.getVolume();
    };

  private initListenDeviceChange(): void {
    this.initAudioRoutingManager();
    log.showInfo(TAG, `initListenDeviceChange begin`);
    try {
      this.audioRoutingManager?.on('deviceChange', audio.DeviceFlag.ALL_DEVICES_FLAG, this.audioDevicesChangeCallback);
    } catch (e) {
      log.showError(TAG, `init listen device change error: ${e?.message}`);
    }
    log.showInfo(TAG, `initListenDeviceChange end`);
  }

  private offListenDeviceChange(): void {
    this.initAudioRoutingManager();
    log.showInfo(TAG, `offListenDeviceChange begin`);
    try {
      this.audioRoutingManager?.off('deviceChange', this.audioDevicesChangeCallback);
    } catch (e) {
      log.showError(TAG, `off listen device change error: ${e?.message}`);
    }
    log.showInfo(TAG, `offListenDeviceChange end`);
  }

  private audioDevicesChangeCallback: (deviceChanged: audio.DeviceChangeAction) => void =
    (deviceChanged: audio.DeviceChangeAction) => {
      log.showInfo(TAG, `onAudioDevicesChange: ${deviceChanged.type}-${deviceChanged.deviceDescriptors.length}`);
      // 查询更新输出输入设备
      this.doQueryOutputAudioDevices().then(() => {
        this.getPreferOutputDevice();
      });
    };

  private initListenCurrentOutputDeviceChange(): void {
    this.initAudioRoutingManager();
    log.showInfo(TAG, `initListenCurrentOutputDeviceChange begin`);
    try {
      this.audioRoutingManager?.on('preferOutputDeviceChangeForRendererInfo',
        this.rendererInfoForPlay, async (device) => {
          if (!await this.isCommunicationScene()) {
            log.showInfo(TAG, `preferOutputDeviceChangeForRendererInfo callback from play`);
            this.currentOutputDeviceChangeCallback(device);
          }
        });
    } catch (e) {
      log.showError(TAG, `listen play prefer output device change fail, message: ${e?.message}`);
    }
    try {
      this.audioRoutingManager?.on('preferOutputDeviceChangeForRendererInfo',
        this.rendererInfoForCall, async (device) => {
          if (await this.isCommunicationScene()) {
            log.showInfo(TAG, `preferOutputDeviceChangeForRendererInfo callback from call`);
            this.currentOutputDeviceChangeCallback(device);
          }
        });
    } catch (e) {
      log.showError(TAG, `listen call prefer output device change fail, message: ${e?.message}`);
    }
    log.showInfo(TAG, `initListenCurrentOutputDeviceChange end`);
  }

  private offListenCurrentOutputDeviceChange(): void {
    this.initAudioRoutingManager();
    log.showInfo(TAG, `offListenCurrentOutputDeviceChange begin`);
    try {
      this.audioRoutingManager?.off('preferOutputDeviceChangeForRendererInfo');
    } catch (e) {
      log.showError(TAG, `off listen current output device change error: ${e?.message}`);
    }
    log.showInfo(TAG, `offListenCurrentOutputDeviceChange end`);
  }

  private currentOutputDeviceChangeCallback(device: audio.AudioDeviceDescriptors | undefined): void {
    if (!device) {
      log.showWarn(TAG, `query current output device invalid`);
    }
    this.currentOutputDevice = device ?? this.currentOutputDevice;
    this.refreshCurrentOutputDevice4VM();
    // 当前输出设备刷新后，刷新音量
    this.getVolume();
  }

  private initListenVolumeChange(): void {
    this.initAudioVolumeManager();
    log.showInfo(TAG, `initListenVolumeChange begin`);
    try {
      this.audioVolumeManager?.on('volumeChange', this.volumeChangeCallback);
    } catch (e) {
      log.showError(TAG, `init listen volume change error: ${e?.message}`);
    }
    log.showInfo(TAG, `initListenVolumeChange end`);
  }

  private offListenVolumeChange(): void {
    this.initAudioVolumeManager();
    log.showInfo(TAG, `offListenVolumeChange begin`);
    try {
      this.audioVolumeManager?.off('volumeChange', this.volumeChangeCallback);
    } catch (e) {
      log.showError(TAG, `off listen volume change error: ${e?.message}`);
    }
    log.showInfo(TAG, `offListenVolumeChange end`);
  }

  private volumeChangeCallback = (volumeEvent: audio.VolumeEvent): void => {
    if (!volumeEvent) {
      log.showWarn(TAG, `volumeChangeCallback volumeEvent invalid`);
      return;
    }
    log.showInfo(TAG, `volumeChangeCallback volumeEvent info: ${volumeEvent.volumeType}-${volumeEvent.volume}`);
    if (this.isPc) {
      // pc音频框架，主音量刷新，直接接收通话流和媒体流音量
      if (volumeEvent.volumeType === audio.AudioVolumeType.MEDIA ||
        volumeEvent.volumeType === audio.AudioVolumeType.VOICE_CALL) {
        this.curVolume = volumeEvent.volume ?? this.minVolume;
        this.refreshVolume4VM();
      }
    } else {
      // pad音频框架，主音量刷新，通话场景仅接收通话流音量，媒体场景仅接收媒体流音量
      if ((volumeEvent.volumeType === audio.AudioVolumeType.MEDIA && !this.isCommunicationNow()) ||
        (volumeEvent.volumeType === audio.AudioVolumeType.VOICE_CALL && this.isCommunicationNow())) {
        this.curVolume = volumeEvent.volume ?? this.minVolume;
        this.refreshVolume4VM();
      }
    }

    if (volumeEvent.volumeType === AudioConstants.RINGTONE_VOLUME_TYPE) {
      this.refreshTipVolume4VM();
    }
  }

  private initListenAudioRendererChange(): void {
    this.initAudioStreamManager();
    log.info(TAG, `initListenAudioRendererChange begin`);
    try {
      this.audioStreamManager?.on('audioRendererChange', this.rendererChangeCallback);
    } catch (e) {
      log.error(TAG, `init listen AudioRenderer change error: ${e?.message}`);
    }
    log.info(TAG, `initListenAudioRendererChange end`);
  }

  private offListenAudioRendererChange(): void {
    this.initAudioStreamManager();
    log.info(TAG, `offListenAudioRendererChange begin`);
    try {
      this.audioStreamManager?.off('audioRendererChange', this.rendererChangeCallback);
    } catch (e) {
      log.error(TAG, `off listen AudioRenderer change error: ${e?.message}`);
    }
    log.info(TAG, `offListenAudioRendererChange end`);
  }

  private rendererChangeCallback = (rendererInfoArray: audio.AudioRendererChangeInfoArray): void => {
    log.info(TAG, `onAudioRendererChange is called, length: ${rendererInfoArray.length}`);
    this.audioRendererInfoArray = rendererInfoArray ?? this.audioRendererInfoArray;
    this.refreshAudioRendererStream4VM();
  }

  private async doQueryOutputAudioDevices(): Promise<void> {
    this.initAudioRoutingManager();
    // 获取音频输出设备
    log.showInfo(TAG, `query audio output device begin`);
    try {
      const outputDevice = await this.audioRoutingManager?.getDevices(audio.DeviceFlag.OUTPUT_DEVICES_FLAG);
      if (!outputDevice) {
        log.showWarn(TAG, `query output device invalid`);
      }
      this.audioOutputDevices = outputDevice ?? this.audioOutputDevices;
      this.refreshOutputDevicesList4VM();
      log.showInfo(TAG, `query audio output device end`);
    } catch (e) {
      log.showError(TAG, `doQueryOutputAudioDevices getDevices error: ${e?.message}`);
    }
  }

  private async getPreferOutputDevice(): Promise<void> {
    this.initAudioRoutingManager();
    log.showInfo(TAG, `query current output devices begin`);
    let rendererInfo: audio.AudioRendererInfo = {
      usage: await this.isCommunicationScene() ?
      audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION : audio.StreamUsage.STREAM_USAGE_MUSIC,
      rendererFlags: 0
    };
    try {
      const device = await this.audioRoutingManager?.getPreferOutputDeviceForRendererInfo(rendererInfo);
      log.showInfo(TAG, `getPreferOutputDeviceForRendererInfo callback`);
      this.currentOutputDeviceChangeCallback(device);
    } catch (err) {
      log.showError(TAG, `get prefer output audio error: ${err?.message}`);
    }
  }

  private async getVolume(): Promise<void> {
    await this.getVolumeByType(this.isCommunicationNow() ? audio.AudioVolumeType.VOICE_CALL :
      audio.AudioVolumeType.MEDIA, (min, cur, max) => {
      this.minVolume = min ?? this.minVolume;
      this.curVolume = cur ?? this.minVolume;
      this.maxVolume = max ?? this.maxVolume;
      this.refreshVolume4VM();
    });
    await this.getVolumeByType(AudioConstants.RINGTONE_VOLUME_TYPE, (min, cur, max) => {
      this.minTipVolume = min ?? this.minTipVolume;
      this.curTipVolume = cur ?? this.minTipVolume;
      this.maxTipVolume = max ?? this.maxTipVolume;
      this.refreshTipVolume4VM();
    });
  }

  private async getVolumeByType(volumeType: number,
    getVolumeFunc: (min: number, cur: number, max: number) => void): Promise<void> {
    await this.initAudioVolumeManager();
    log.showInfo(TAG, `get device volume begin, type: ${volumeType}`);
    try {
      const minVolume = await this.audioVolumeGroupManager?.getMinVolume(volumeType);
      log.showInfo(TAG, `getVolume get min vol done ${minVolume} - ${volumeType}`);
      const maxVolume = await this.audioVolumeGroupManager?.getMaxVolume(volumeType);
      log.showInfo(TAG, `getVolume get max vol done ${maxVolume} - ${volumeType}`);
      const curVolume = await this.audioVolumeGroupManager?.getVolume(volumeType);
      log.showInfo(TAG, `getVolume get cur vol done ${curVolume} - ${volumeType}`);
      if (getVolumeFunc && minVolume !== undefined && maxVolume !== undefined && curVolume !== undefined) {
        getVolumeFunc(minVolume, curVolume, maxVolume);
      }
    } catch (e) {
      log.showError(TAG, `get device volume type: ${volumeType} error: ${e?.message}`);
    }
  }

  private async isCommunicationScene(): Promise<boolean> {
    try {
      this.currentScene = await this.audioManager?.getAudioScene();
      if (this.currentScene === undefined) {
        log.showWarn(TAG, `query current scene invalid`);
        return false;
      }
    } catch (err) {
      log.showError(TAG, `getAudioScene error`);
    }
    return this.COMMUNICATION_SCENES.includes(this.currentScene as audio.AudioScene);
  }

  private async getAudioRendererInfoArray(): Promise<void> {
    this.initAudioStreamManager();
    log.info(TAG, `get AudioRendererInfoArray begin`);
    try {
      const rendererInfoArray = await this.audioStreamManager?.getCurrentAudioRendererInfoArray();
      log.info(TAG, `get audioRendererInfoArray length: ${rendererInfoArray?.length}`);
      this.audioRendererInfoArray = rendererInfoArray ?? this.audioRendererInfoArray;
      this.refreshAudioRendererStream4VM();
    } catch (e) {
      log.error(TAG, `get audioRendererInfoArray error: ${e?.message}`);
    }
  }

  private refreshOutputStatus4VM(listener: AudioOutputChangeListener4VM): void {
    listener.onOutputDevicesChange(this.audioOutputDevices);
    listener.onCurrentOutputDeviceChange(this.currentOutputDevice);
    listener.onVolumeChange(this.minVolume, this.curVolume, this.maxVolume);
    listener.onTipVolumeChange(this.minTipVolume, this.curTipVolume, this.maxTipVolume);
    listener.onAudioRendererStreamChange(this.audioRendererInfoArray);
  }

  private refreshOutputDevicesList4VM(): void {
    this.audioOutputListeners.forEach(listener => {
      listener.onOutputDevicesChange(this.audioOutputDevices);
    });
  }

  private refreshCurrentOutputDevice4VM(): void {
    this.audioOutputListeners.forEach(listener => {
      listener.onCurrentOutputDeviceChange(this.currentOutputDevice);
    });
  }

  private refreshVolume4VM(): void {
    this.audioOutputListeners.forEach(listener => {
      listener.onVolumeChange(this.minVolume, this.curVolume, this.maxVolume);
    });
  }

  private refreshTipVolume4VM(): void {
    this.audioOutputListeners.forEach(listener => {
      listener.onTipVolumeChange(this.minTipVolume, this.curTipVolume, this.maxTipVolume);
    });
  }

  private refreshAudioRendererStream4VM(): void {
    this.audioOutputListeners.forEach(listener => {
      listener.onAudioRendererStreamChange(this.audioRendererInfoArray);
    });
  }
}