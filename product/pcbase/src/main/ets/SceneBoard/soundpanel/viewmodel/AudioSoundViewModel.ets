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
import HashMap from '@ohos.util.HashMap';
import { LogDomain, Logger } from '@ohos/basicutils';
import { AudioOutputChangeListener4VM, AudioSoundModel } from '../model/AudioSoundModel';
import { AudioConstants } from '../common/Constants';

export interface audioDevice {
  viewIndex: number,
  deviceIndex: number,
  name: ResourceStr,
  type: audio.DeviceType,
  address: string
};

export interface AudioRendererStream {
  streamId: number,
  rendererState: number,
  usage: number
};

export enum AudioUsage {
  STREAM_USAGE_UNKNOWN = 0,
  STREAM_USAGE_MUSIC = 1,
  STREAM_USAGE_VOICE_COMMUNICATION = 2,
  STREAM_USAGE_ALARM = 4,
  STREAM_USAGE_VOICE_MESSAGE = 5,
  STREAM_USAGE_RINGTONE = 6,
  STREAM_USAGE_NOTIFICATION = 7,
  STREAM_USAGE_ACCESSIBILITY = 8,
  STREAM_USAGE_SYSTEM = 9,
  STREAM_USAGE_MOVIE = 10,
  STREAM_USAGE_GAME = 11,
  STREAM_USAGE_AUDIOBOOK = 12,
  STREAM_USAGE_NAVIGATION = 13,
  STREAM_USAGE_DTMF = 14,
  STREAM_USAGE_ENFORCED_TONE = 15,
  STREAM_USAGE_ULTRASONIC = 16,
  STREAM_USAGE_VIDEO_COMMUNICATION = 17,
  STREAM_USAGE_VOICE_CALL_ASSISTANT = 21,
}

export enum AudioRendererState {
  STATE_PREPARED = 1,
  STATE_RUNNING = 2,
  STATE_STOPPED = 3,
  STATE_RELEASED = 4,
  STATE_PAUSED = 5
}

export interface AudioOutputChangeListener4V {
  onOutputDevicesChange?: ( devices: audioDevice[] ) => void
  onCurrentOutputDeviceChange?: ( viewIndex: number ) => void
  onVolumeChange?: ( minVolume: number, curVolume: number, maxVolume: number ) => void
  onTipVolumeChange?: ( minVolume: number, curVolume: number, maxVolume: number ) => void
  onAudioRendererStreamChange?: ( rendererInfoArray: AudioRendererStream[] ) => void
};

const TAG = 'AudioSoundViewModel';
const log = Logger.getLogHelper(LogDomain.SCB);

// pc状态栏声音面板定制化音频业务，非通用，慎重使用，出现异常不对其他邻域负责
export class AudioSoundViewModel {
  private static instance: AudioSoundViewModel;
  private model: AudioSoundModel = AudioSoundModel.getInstance();
  // audio output
  private outputListeners = new Set<AudioOutputChangeListener4V>();
  private outputRegisterEnable: boolean = false;
  private outputDevice: audioDevice[] = [];
  private outputDeviceForSelect: audioDevice[] = [];
  private outputDeviceAddressMap: HashMap<string, number> = new HashMap();
  private currentOutputDevice: number = AudioConstants.DEFAULT_DEVICE_ID;
  private minVolume: number = AudioConstants.DEFAULT_MIN_VOLUME;
  private curVolume: number = AudioConstants.DEFAULT_CUR_VOLUME;
  private maxVolume: number = AudioConstants.DEFAULT_MAX_VOLUME;
  private minTipVolume: number = AudioConstants.DEFAULT_MIN_VOLUME;
  private curTipVolume: number = AudioConstants.DEFAULT_CUR_VOLUME;
  private maxTipVolume: number = AudioConstants.DEFAULT_MAX_VOLUME;
  private rendererStream: AudioRendererStream[] = [];

  public static getInstance(): AudioSoundViewModel {
    if (AudioSoundViewModel.instance) {
      return AudioSoundViewModel.instance;
    }
    AudioSoundViewModel.instance = new AudioSoundViewModel();
    return AudioSoundViewModel.instance;
  }

  /**
   * 订阅输出变更监听
   * @param listener 业务监听对象
   * @param caller 调用方
   */
  public registerOutputChangeListener(listener: AudioOutputChangeListener4V, caller: string): void {
    if (!listener) {
      log.showWarn(TAG, `${caller} registerOutputChangeListener invalid listener`);
      return;
    }
    this.outputListeners.add(listener);
    log.showInfo(TAG, `${caller} register outputListeners size: ${this.outputListeners.size}`);
    if (this.outputListeners.size > 0 && !this.outputRegisterEnable) {
      this.outputRegisterEnable = true;
      this.model.registerAudioOutputChangeListener(this.audioOutputChangeListener, TAG);
    }
    this.refreshOutputStatus4V(listener);
  }

  /**
   * 取消订阅输出变更监听
   * @param listener 业务监听对象
   * @param caller 调用方
   */
  public unregisterOutputChangeListener(listener: AudioOutputChangeListener4V, caller: string): void {
    if (!listener) {
      log.showWarn(TAG, `${caller} unregisterOutputChangeListener invalid listener`);
      return;
    }
    this.outputListeners.delete(listener);
    log.showInfo(TAG, `${caller} unregister outputListeners size: ${this.outputListeners.size}`);
    if (this.outputListeners.size === 0 && this.outputRegisterEnable) {
      this.outputRegisterEnable = false;
      this.model.unregisterAudioOutputChangeListener(this.audioOutputChangeListener, TAG);
    }
  }

  /**
   * 选择输出设备
   * @param viewIndex 设备viewIndex
   * @param caller 调用方
   */
  public async selectOutputDevice(viewIndex: number, caller: string): Promise<void> {
    log.showInfo(TAG, `${caller} selectOutputDevice viewIndex: ${viewIndex} begin`);
    const device = this.outputDeviceForSelect.find((device) => device.viewIndex === viewIndex);
    if (!device) {
      log.showWarn(TAG, `${caller} selectOutputDevice invalid viewIndex: ` +
        `${viewIndex}, selectOutputDevice len: ${this.outputDeviceForSelect.length}`);
      return;
    }
    log.showInfo(TAG, `selectOutputDevice device info: ` +
      `${device.deviceIndex} - [${device.name}] - ${device.type}`);
    let playSelectRes: boolean = false;
    let callSelectRes: boolean = false;
    if (device.type === audio.DeviceType.BLUETOOTH_SCO) {
      let anotherDevice = this.outputDeviceForSelect.find((device) => device.viewIndex === viewIndex &&
        device.type === audio.DeviceType.BLUETOOTH_A2DP);
      if (anotherDevice) {
        playSelectRes = await this.model.selectAudioOutputDevice(anotherDevice.deviceIndex, true, TAG);
      }
      callSelectRes = await this.model.selectAudioOutputDevice(device.deviceIndex, false, TAG);
    } else if (device.type === audio.DeviceType.BLUETOOTH_A2DP) {
      let anotherDevice = this.outputDeviceForSelect.find((device) => device.viewIndex === viewIndex &&
        device.type === audio.DeviceType.BLUETOOTH_SCO);
      playSelectRes = await this.model.selectAudioOutputDevice(device.deviceIndex, true, TAG);
      if (anotherDevice) {
        callSelectRes = await this.model.selectAudioOutputDevice(anotherDevice.deviceIndex, false, TAG);
      }
    } else {
      playSelectRes = await this.model.selectAudioOutputDevice(device.deviceIndex, true, TAG);
      callSelectRes = await this.model.selectAudioOutputDevice(device.deviceIndex, false, TAG);
    }
    log.showInfo(TAG, `${caller} ${viewIndex} selectOutputDevice result: ${playSelectRes} - ${callSelectRes}`);
  }

  /**
   * 设置下发主音量，根据场景下发通话/媒体音量
   * @param tarVolume 下发音量
   * @param caller 调用方
   */
  public async setOutputVolume(tarVolume: number, caller: string): Promise<void> {
    const isCommunicationNow: boolean = this.model.isCommunicationNow();
    log.showInfo(TAG, `${caller} ${isCommunicationNow ? 'call' : 'media'} setOutputVolume tarVolume: ${tarVolume} begin`);
    if (tarVolume < this.minVolume || tarVolume > this.maxVolume) {
      log.showWarn(TAG, `${caller} setOutputVolume invalid: ` +
        `${this.minVolume} - ${tarVolume} - ${this.maxVolume}`);
      tarVolume = tarVolume < this.minVolume ? this.minVolume : tarVolume;
      tarVolume = tarVolume > this.maxVolume ? this.maxVolume : tarVolume;
    }
    const setRes = await this.model.setAudioVolume(isCommunicationNow ? audio.AudioVolumeType.VOICE_CALL :
      audio.AudioVolumeType.MEDIA, tarVolume, TAG);
    log.showInfo(TAG, `${caller} ${isCommunicationNow ? 'call' : 'media'} setOutputVolume result: ${setRes}`);
  }

  /**
   * 设置下发提示音量
   * @param tarVolume 下发音量
   * @param caller 调用方
   */
  public async setTipVolume(tarVolume: number, caller: string): Promise<void> {
    log.showInfo(TAG, `${caller} setTipVolume tarVolume: ${tarVolume} begin`);
    if (tarVolume < this.minTipVolume || tarVolume > this.maxTipVolume) {
      log.showWarn(TAG, `${caller} setTipVolume invalid: ` +
        `${this.minTipVolume} - ${tarVolume} - ${this.maxTipVolume}`);
      tarVolume = tarVolume < this.minTipVolume ? this.minTipVolume : tarVolume;
      tarVolume = tarVolume > this.maxTipVolume ? this.maxTipVolume : tarVolume;
    }
    const setRes = await this.model.setAudioVolume(AudioConstants.RINGTONE_VOLUME_TYPE, tarVolume, TAG);
    log.showInfo(TAG, `${caller} setTipVolume result: ${setRes}`);
  }

  /**
   * 调大/小主音量
   * @param isUp 调大或调小
   * @param caller 调用方
   */
  public async turnOutputVolume(isUp: boolean, caller: string): Promise<void> {
    const isCommunicationNow: boolean = this.model.isCommunicationNow();
    log.showInfo(TAG, `${caller} ${isCommunicationNow ? 'call' : 'media'} turnOutputVolume begin, isUp: ${isUp} begin`);
    if ((isUp && this.curVolume === this.maxVolume) || (!isUp && this.curVolume === this.minVolume)) {
      log.showWarn(TAG, `${caller} turnOutputVolume fail, The volume is the maximum or minimum.`);
      return;
    }
    const turnRes = await this.model.turnVolume(isCommunicationNow ? audio.AudioVolumeType.VOICE_CALL :
      audio.AudioVolumeType.MEDIA, isUp, TAG);
    log.showInfo(TAG, `${caller} ${isCommunicationNow ? 'call' : 'media'} turnOutputVolume result: ${turnRes}`);
  }

  /**
   * 调大/小提示音量
   * @param isUp 调大或调小
   * @param caller 调用方
   */
  public async turnTipVolume(isUp: boolean, caller: string): Promise<void> {
    log.showInfo(TAG, `${caller} turnTipVolume begin, isUp: ${isUp} begin`);
    if ((isUp && this.curTipVolume === this.maxTipVolume) || (!isUp && this.curTipVolume === this.minTipVolume)) {
      log.showWarn(TAG, `${caller} turnTipVolume fail, The volume is the maximum or minimum.`);
      return;
    }
    const turnRes = await this.model.turnVolume(AudioConstants.RINGTONE_VOLUME_TYPE, isUp, TAG);
    log.showInfo(TAG, `${caller} turnTipVolume result: ${turnRes}`);
  }

  /**
   * 设置下发主音量静音状态
   * @param tarMuteState 下发静音状态
   * @param caller 调用方
   */
  public async setOutputMute(tarMuteState: boolean, caller: string): Promise<void> {
    const isCommunicationNow: boolean = this.model.isCommunicationNow();
    log.showInfo(TAG, `${caller} ${isCommunicationNow ? 'call' : 'media'} setOutputMute tarMuteState: ` +
      `${tarMuteState} begin`);
    const setRes = await this.model.setAudioMute(isCommunicationNow ? audio.AudioVolumeType.VOICE_CALL :
      audio.AudioVolumeType.MEDIA, tarMuteState, TAG);
    log.showInfo(TAG, `${caller} ${isCommunicationNow ? 'call' : 'media'} setOutputMute result: ${setRes}`);
  }

  /**
   * 设置下发提示音量静音状态
   * @param tarMuteState 下发静音状态
   * @param caller 调用方
   */
  public async setTipMute(tarMuteState: boolean, caller: string): Promise<void> {
    log.showInfo(TAG, `${caller} setTipMute tarMuteState: ${tarMuteState} begin`);
    const setRes = await this.model.setAudioMute(AudioConstants.RINGTONE_VOLUME_TYPE, tarMuteState, TAG);
    log.showInfo(TAG, `${caller} setTipMute result: ${setRes}`);
  }

  /**
   * 主动查询输出音频数据
   * @param caller 调用方
   */
  public async getOutputState(caller: string): Promise<void> {
    log.showInfo(TAG, `${caller} getOutputState begin`);
    await this.model.initOutputStateFromAudio(TAG);
  }

  private audioOutputChangeListener: AudioOutputChangeListener4VM = {
    onOutputDevicesChange: (devices: audio.AudioDeviceDescriptors) => {
      this.outputDevicesDataProcessFromModel(devices);
    },
    onCurrentOutputDeviceChange: (device: audio.AudioDeviceDescriptors) => {
      this.currentOutputDeviceDataProcessFromModel(device);
    },
    onVolumeChange: (minVolume: number, curVolume: number, maxVolume: number) => {
      log.showInfo(TAG, `volume change info: ${minVolume} - ${curVolume} - ${maxVolume}`);
      this.minVolume = minVolume ?? this.minVolume;
      this.curVolume = curVolume ?? this.minVolume;
      this.maxVolume = maxVolume ?? this.maxVolume;
      this.refreshVolume4V();
      this.notifyTipPanel();
    },
    onTipVolumeChange: (minVolume: number, curVolume: number, maxVolume: number) => {
      log.showInfo(TAG, `tip volume change info: ${minVolume} - ${curVolume} - ${maxVolume}`);
      this.minTipVolume = minVolume ?? this.minTipVolume;
      this.curTipVolume = curVolume ?? this.minTipVolume;
      this.maxTipVolume = maxVolume ?? this.maxTipVolume;
      this.refreshTipVolume4V();
    },
    onAudioRendererStreamChange: (rendererInfoArray: audio.AudioRendererChangeInfoArray) => {
      log.showInfo(TAG, `audio renderer stream change info: ${rendererInfoArray.length}`);
      let tarRendererStreams: AudioRendererStream[] = [];
      for (const rendererInfo of rendererInfoArray) {
        let tarRendererStream: AudioRendererStream = {
          streamId: rendererInfo.streamId,
          rendererState: rendererInfo.rendererState,
          usage: rendererInfo.rendererInfo.usage
        }
        tarRendererStreams.push(tarRendererStream);
        log.showInfo(TAG, `push query renderer info: ${tarRendererStream.rendererState}-${tarRendererStream.usage}`);
      }
      this.rendererStream = tarRendererStreams;
      this.refreshRendererStream4V();
    }
  };

  private outputDevicesDataProcessFromModel(devices: audio.AudioDeviceDescriptors): void {
    // 对当前输出设备列表进行view层的业务处理
    log.showInfo(TAG, `outputDevicesDataProcessFromModel devices length: ${devices.length}`);
    let tarDevices: audioDevice[] = [];
    let tarDevicesForSelect: audioDevice[] = [];
    this.outputDeviceAddressMap.clear();
    for (const device of devices) {
      let isAlreadyInDeviceList: boolean = this.outputDeviceAddressMap.hasKey(device.address);
      let tarDevice: audioDevice = {
        viewIndex: this.getDeviceViewIndex(device, this.outputDeviceAddressMap),
        deviceIndex: device.id,
        name: this.getDeviceName(device),
        type: device.deviceType,
        address: device.address
      }
      if (!isAlreadyInDeviceList) {
        tarDevices.push(tarDevice);
      }
      tarDevicesForSelect.push(tarDevice);
      log.showInfo(TAG, `push query output device info: ` +
        `${tarDevice.deviceIndex}-[${device.name}]-${device.deviceType}`);
    }
    this.sortAudioDevices(tarDevices);
    this.outputDevice = tarDevices;
    this.outputDeviceForSelect = tarDevicesForSelect;
    this.refreshOutputDevicesList4V();
  }

  private currentOutputDeviceDataProcessFromModel(device: audio.AudioDeviceDescriptors): void {
    if (!device || device.length === 0) {
      log.showWarn(TAG, `currentOutputDeviceDataProcessFromModel get current device invalid`);
      return;
    }
    const currentDevice: audio.AudioDeviceDescriptor = device[0];
    let tarDevice = this.outputDeviceForSelect.find((item) => item.deviceIndex === currentDevice.id);
    if (tarDevice) {
      this.currentOutputDevice = tarDevice.viewIndex;
      log.showInfo(TAG, `current output device info: ` +
        `${tarDevice.deviceIndex}-[${currentDevice.name}]-${currentDevice.deviceType}`);
      // 通知状态栏声音提示气泡更新当前输出设备显示
      AppStorage.setOrCreate('curDeviceTypeForHoverTips', currentDevice.deviceType);
    } else {
      log.showWarn(TAG, `current output device not exist, info: ` +
        `[${currentDevice.name}]-${currentDevice.deviceType}`);
      this.currentOutputDevice = AudioConstants.DEFAULT_DEVICE_ID;
    }
    this.refreshCurrentOutputDevice4V();
  }

  // 通知状态栏声音提示气泡更新音量百分比显示
  private notifyTipPanel(): void {
    let volumePercent: number = Math.ceil(this.curVolume / this.maxVolume * 100);
    // 音量百分比参数校验修正
    volumePercent = Number.isNaN(volumePercent) ? 0 : volumePercent;
    volumePercent = volumePercent > 100 ? 100 : volumePercent;
    log.showInfo(TAG, `notifyTipPanel result: ${volumePercent}`);
    AppStorage.setOrCreate('volumePercentForHoverTips', volumePercent);
  }

  /**
   * 获取默认名称描述
   * @param device 设备信息
   */
  private getDeviceName(device: audio.AudioDeviceDescriptor): ResourceStr {
    if (device && device.name) {
      return device.name;
    }
    let nameResource: Resource = $r('app.string.sound_output_device_default');
    if (!device) {
      return nameResource;
    }
    switch (device.deviceType) {
      case audio.DeviceType.EARPIECE:
        nameResource = $r('app.string.sound_device_earpiece');
        break;
      case audio.DeviceType.SPEAKER:
        nameResource = $r('app.string.sound_output_device_local');
        break;
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      case audio.DeviceType.USB_HEADSET:
        nameResource = $r('app.string.sound_output_device_earphone');
        break;
      case audio.DeviceType.BLUETOOTH_SCO:
      case audio.DeviceType.BLUETOOTH_A2DP:
        nameResource = $r('app.string.sound_output_device_bluetooth');
        break;
      case audio.DeviceType.MIC:
        nameResource = $r('app.string.sound_intput_device_local');
        break;
      case audio.DeviceType.DISPLAY_PORT:
      case audio.DeviceType.REMOTE_CAST:
      case audio.DeviceType.HDMI:
        nameResource = $r('app.string.sound_output_device_display_port');
        break;
      case audio.DeviceType.USB_DEVICE:
      case audio.DeviceType.DEFAULT:
        nameResource = $r('app.string.sound_output_device_default');
        break;
      default:
        log.showWarn(TAG, `unknown type: ${device.deviceType}`);
        break;
    }
    return nameResource;
  }

  private getDeviceViewIndex(device: audio.AudioDeviceDescriptor, addressMap: HashMap<string, number>): number {
    // 非蓝牙设备直接用id作为ViewIndex
    if (device.deviceType !== audio.DeviceType.BLUETOOTH_A2DP && device.deviceType !== audio.DeviceType.BLUETOOTH_SCO) {
      log.showInfo(TAG, `get Non-Bluetooth input device id`);
      return device.id;
    }
    // 根据是否已存有该设备ID地址返回ViewIndex
    if (addressMap.isEmpty() || !addressMap.hasKey(device.address)) {
      log.showInfo(TAG, `Bluetooth input device not connected before`);
      addressMap.set(device.address, device.id);
      return device.id;
    }
    let index: number = addressMap.get(device.address);
    log.showInfo(TAG, `Bluetooth device has in out devices list, viewIdex: ${index}`);
    return index;
  }

  private sortAudioDevices(devices: audioDevice[]): void {
    // 设备列表排序： 板载麦克风/扬声器 > 蓝牙耳机 > 其他设备（根据type的由大到小排序）
    devices.sort((x: audioDevice, y: audioDevice) => {
      if (x.type === audio.DeviceType.MIC || x.type === audio.DeviceType.SPEAKER) {
        return -1;
      }
      if (y.type === audio.DeviceType.MIC || y.type === audio.DeviceType.SPEAKER) {
        return 1;
      }
      if (x.type === audio.DeviceType.BLUETOOTH_A2DP || x.type === audio.DeviceType.BLUETOOTH_SCO) {
        return -1;
      }
      if (y.type === audio.DeviceType.BLUETOOTH_A2DP || y.type === audio.DeviceType.BLUETOOTH_SCO) {
        return 1;
      }
      if (x.type > y.type) {
        return -1;
      }
      if (x.type < y.type) {
        return 1;
      }
      return 0;
    });
  }

  private refreshOutputStatus4V(listener: AudioOutputChangeListener4V): void {
    listener.onOutputDevicesChange?.(this.outputDevice);
    listener.onCurrentOutputDeviceChange?.(this.currentOutputDevice);
    listener.onVolumeChange?.(this.minVolume, this.curVolume, this.maxVolume);
    listener.onTipVolumeChange?.(this.minTipVolume, this.curTipVolume, this.maxTipVolume);
    listener.onAudioRendererStreamChange?.(this.rendererStream);
  }

  private refreshOutputDevicesList4V(): void {
    this.outputListeners.forEach(listener => {
      listener.onOutputDevicesChange?.(this.outputDevice);
    });
  }

  private refreshCurrentOutputDevice4V(): void {
    this.outputListeners.forEach(listener => {
      listener.onCurrentOutputDeviceChange?.(this.currentOutputDevice);
    });
  }

  private refreshVolume4V(): void {
    this.outputListeners.forEach(listener => {
      listener.onVolumeChange?.(this.minVolume, this.curVolume, this.maxVolume);
    });
  }

  private refreshTipVolume4V(): void {
    this.outputListeners.forEach(listener => {
      listener.onTipVolumeChange?.(this.minTipVolume, this.curTipVolume, this.maxTipVolume);
    });
  }

  private refreshRendererStream4V(): void {
    this.outputListeners.forEach(listener => {
      listener.onAudioRendererStreamChange?.(this.rendererStream);
    });
  }
}