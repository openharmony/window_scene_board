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

import HashMap from '@ohos.util.HashMap';
import audio from '@ohos.multimedia.audio';
import { LogDomain, LogHelper, SingletonHelper, AudioManagerHelper } from '@ohos/basicutils';
import { AudioIoType, PcAudioDevice } from '../PcAudioDevice';
import Constants from '../common/Constants';
import { BusinessError } from '@kit.BasicServicesKit';

export interface InputDevicesChangeListener { onInputDevicesChange: ( devices: PcAudioDevice[] ) => void };
export interface CurrentInputDeviceChangeListener { onCurrentInputDeviceChange: ( id: number ) => void };
export interface CurrentMicrophoneMuteStatusListener { onCurrentMicrophoneMuteStatus: ( isMute: boolean ) => void };
export interface CapturerInfoArrayListener {
  onCapturerInfoArrayChange: ( capturerInfoArray: Array<audio.AudioCapturerChangeInfo> ) => void
};

const TAG = 'MicrophonePanelModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class MicrophonePanelModel {
  private inputDevicesListeners = new Set<InputDevicesChangeListener>();
  private currentInputDeviceListeners = new Set<CurrentInputDeviceChangeListener>();
  private currentMicrophoneMuteStatusListeners = new Set<CurrentMicrophoneMuteStatusListener>();
  private capturerInfoArrayListeners = new Set<CapturerInfoArrayListener>();
  private audioManager = AudioManagerHelper.getAudioManager();
  private audioRoutingManager?: audio.AudioRoutingManager;
  private audioVolumeManager?: audio.AudioVolumeManager;
  private audioVolumeGroupManager?: audio.AudioVolumeGroupManager;
  private audioStreamManager?: audio.AudioStreamManager;
  private readonly COMMUNICATION_SCENES: audio.AudioScene[] =
    [audio.AudioScene.AUDIO_SCENE_RINGING, audio.AudioScene.AUDIO_SCENE_VOICE_CHAT];
  private audioInputDevices: PcAudioDevice[] = [];
  private currentInputAudioDeviceIndex: number = Constants.DEFAULT_DEVICE_ID;
  private currentScene?: audio.AudioScene;
  private currentMicrophoneMuteStatus: boolean = false;
  private currentCapturerInfoArray: Array<audio.AudioCapturerChangeInfo> = [];
  private inputDeviceAddressSet: HashMap<string, number> = new HashMap<string, number>();
  private timer: number | undefined;

  constructor() {
    log.showInfo(`constructor`);
    this.initAudioManager();
    this.initListenDeviceChange();
    this.initListenCurrentInputDeviceChange();
    this.doQueryInputAudioDevices();
    this.initListenMicrophoneMute();
    this.doQueryMicrophoneMuteStatus();
    this.initListenCapturerInfoChange();
    this.doQueryCapturerInfo();
  }

  /**
   * 刷新model所有数据
   */
  public async refreshAllStatusInfo(): Promise<void> {
    this.initAudioManager();
    this.doQueryInputAudioDevices();
    this.doQueryMicrophoneMuteStatus();
    this.doQueryCapturerInfo();
    log.showInfo(`refreshAllStatusInfo end`);
  }

  /**
   * 订阅输入设备列表
   *
   * @param listener 监听方法
   */
  public registerInputDevicesListener(listener: InputDevicesChangeListener): void {
    if (!listener) {
      return;
    }
    this.inputDevicesListeners.add(listener);
    log.showInfo(`register InputDevicesListener size: ${this.inputDevicesListeners.size}`);
  }

  /**
   * 取消订阅输入设备列表
   *
   * @param listener 监听方法
   */
  public unregisterInputDevicesListener(listener: InputDevicesChangeListener): void {
    if (!listener) {
      return;
    }
    this.inputDevicesListeners.delete(listener);
    log.showInfo(`unregister InputDevicesListener size: ${this.inputDevicesListeners.size}`);
  }

  /**
   * 订阅当前输入设备id
   *
   * @param listener 监听方法
   */
  public registerCurrentInputDeviceListener(listener: CurrentInputDeviceChangeListener): void {
    if (!listener) {
      return;
    }
    this.currentInputDeviceListeners.add(listener);
    log.showInfo(`register CurrentInputDeviceListener size: ${this.currentInputDeviceListeners.size}`);
  }

  /**
   * 取消订阅当前输入设备id
   *
   * @param listener 监听方法
   */
  public unregisterCurrentInputDeviceListener(listener: CurrentInputDeviceChangeListener): void {
    if (!listener) {
      return;
    }
    this.currentInputDeviceListeners.delete(listener);
    log.showInfo(`unregister CurrentInputDeviceListener size: ${this.currentInputDeviceListeners.size}`);
  }

  /**
   * 订阅麦克风静音状态
   *
   * @param listener 监听方法
   */
  public registerCurrentMicrophoneMuteStatusListener(listener: CurrentMicrophoneMuteStatusListener): void {
    if (!listener) {
      return;
    }
    this.currentMicrophoneMuteStatusListeners.add(listener);
    log.showInfo(`register CurrentMicrophoneMuteStatusListener size: ` +
      `${this.currentMicrophoneMuteStatusListeners.size}`);
  }

  /**
   * 取消订阅麦克风静音状态
   *
   * @param listener 监听方法
   */
  public unregisterCurrentMicrophoneMuteStatusListener(listener: CurrentMicrophoneMuteStatusListener): void {
    if (!listener) {
      return;
    }
    this.currentMicrophoneMuteStatusListeners.delete(listener);
    log.showInfo(`unregister CurrentMicrophoneMuteStatusListener size: ` +
      `${this.currentMicrophoneMuteStatusListeners.size}`);
  }

  /**
   * 订阅当前capturer流
   *
   * @param listener 监听方法
   */
  public registerCapturerInfoArrayListener(listener: CapturerInfoArrayListener): void {
    if (!listener) {
      return;
    }
    this.capturerInfoArrayListeners.add(listener);
    log.showInfo(`register CapturerInfoArrayListeners size: ${this.capturerInfoArrayListeners.size}`);
  }

  /**
   * 取消订阅当前capturer流
   *
   * @param listener 监听方法
   */
  public unregisterCapturerInfoArrayListener(listener: CapturerInfoArrayListener): void {
    if (!listener) {
      return;
    }
    this.capturerInfoArrayListeners.delete(listener);
    log.showInfo(`unregister CapturerInfoArrayListeners size: ${this.capturerInfoArrayListeners.size}`);
  }

  /**
   * 获取当前输入设备列表
   */
  public getAudioInputDevices(): PcAudioDevice[] {
    return this.audioInputDevices;
  }

  /**
   * 获取当前输入设备id
   */
  public getCurrentInputAudioDeviceIndex(): number {
    return this.currentInputAudioDeviceIndex;
  }

  /**
   * 获取当前麦克风静音状态
   */
  public getCurrentMicrophoneMuteStatus(): boolean {
    return this.currentMicrophoneMuteStatus;
  }

  /**
   * 获取当前capturer流
   */
  public getCurrentCapturerInfoArray(): Array<audio.AudioCapturerChangeInfo> {
    return this.currentCapturerInfoArray;
  }

  /**
   * 切换全局的输入焦点设备
   *
   * @param viewIndex 设备viewIndex
   * @param caller 调用方
   */
  public async selectAudioInputDevice(viewIndex: number, caller: string): Promise<void> {
    this.initAudioRoutingManager();
    log.showInfo(`${caller} selectAudioInputDevice begin, viewIndex :${viewIndex}`);
    let filterCapturerInfoForCall: audio.AudioCapturerFilter = {
      capturerInfo: {
        source: audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION,
        capturerFlags: 0
      },
    };
    let filterCapturerInfoForPlay: audio.AudioCapturerFilter = {
      capturerInfo: {
        source: audio.SourceType.SOURCE_TYPE_MIC,
        capturerFlags: 0
      },
    };
    const tarDevice = this.audioInputDevices.find((i) => i.getViewIndex() === viewIndex);
    if (!tarDevice) {
      log.showWarn(`${caller} select invalid input devices, viewIndex :${viewIndex}`);
      return;
    }
    const deviceType = tarDevice.getDeviceType();
    let playSelectRes: boolean = false;
    let callSelectRes: boolean = false;
    if (deviceType === audio.DeviceType.BLUETOOTH_SCO) {
      const anotherDevice = this.audioInputDevices.find((i) => i.getViewIndex() === tarDevice.getViewIndex() &&
        i.getDeviceType() === audio.DeviceType.BLUETOOTH_A2DP);
      if (anotherDevice) {
        playSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForPlay,
          [anotherDevice.getAudioDeviceDescriptor()]);
      } else {
        playSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForPlay,
          [tarDevice.getAudioDeviceDescriptor()]);
      }
      callSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForCall,
        [tarDevice.getAudioDeviceDescriptor()]);
    } else if (deviceType === audio.DeviceType.BLUETOOTH_A2DP) {
      const anotherDevice = this.audioInputDevices.find((i) => i.getViewIndex() === tarDevice.getViewIndex() &&
        i.getDeviceType() === audio.DeviceType.BLUETOOTH_SCO);
      playSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForPlay,
        [tarDevice.getAudioDeviceDescriptor()]);
      if (anotherDevice) {
        callSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForCall,
          [anotherDevice.getAudioDeviceDescriptor()]);
      } else {
        callSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForCall,
          [tarDevice.getAudioDeviceDescriptor()]);
      }
    } else {
      playSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForPlay,
        [tarDevice.getAudioDeviceDescriptor()]);
      callSelectRes = await this.executeSelectAudioInputDevice(filterCapturerInfoForCall,
        [tarDevice.getAudioDeviceDescriptor()]);
    }
    log.showInfo(`${caller} ${viewIndex} select input devices result: ${playSelectRes} - ${callSelectRes}`);
  }

  /**
   * 下发麦克风静音状态
   *
   * @param mute 麦克风静音状态
   * @param caller 调用方
   */
  public async setMicrophoneMute(mute: boolean, caller: string): Promise<void> {
    this.initAudioVolumeManager();
    log.showInfo(`${caller} setMicrophoneMute begin, mute :${mute}`);
    try {
      await this.audioVolumeGroupManager?.setMicMute(mute);
    } catch (e) {
      log.showError(`${caller} set microphone mute ERROR, mute :${mute}`);
    }
  }

  private initAudioRoutingManager(): void {
    try {
      if (this.audioRoutingManager === undefined) {
        this.audioRoutingManager = this.audioManager.getRoutingManager();
        log.showInfo(`init audioRoutingManager success`);
      }
    } catch (error) {
      log.showError(`initAudioManager error`);
    }
  }

  private initAudioVolumeManager(): void {
    try {
      if (this.audioVolumeManager === undefined) {
        this.audioVolumeManager = this.audioManager.getVolumeManager();
        log.showInfo(`init audioVolumeManager success`);
      }
    } catch (error) {
      log.showError(`audioVolumeManager error`);
    }
    try {
      if (this.audioVolumeGroupManager === undefined) {
        this.audioVolumeGroupManager =
          this.audioVolumeManager?.getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID);
        log.showInfo(`init audioVolumeGroupManager success`);
      }
    } catch (error) {
      log.showError(`audioVolumeGroupManager error`);
    }
  }

  private initAudioStreamManager(): void {
    try {
      if (this.audioStreamManager === undefined) {
        this.audioStreamManager = this.audioManager.getStreamManager();
        log.showInfo(`init audioStreamManager success`);
      }
    } catch (error) {
      log.showError(`audioStreamManager error`);
    }
  }

  private initAudioManager(): void {
    this.initAudioRoutingManager();
    this.initAudioVolumeManager();
    this.initAudioStreamManager();
  }

  private async executeSelectAudioInputDevice(filter: audio.AudioCapturerFilter,
    devices: audio.AudioDeviceDescriptors): Promise<boolean> {
    try {
      await this.audioRoutingManager?.selectInputDeviceByFilter(filter, devices);
    } catch (e) {
      log.showError(`Select input devices by filter error: ${e?.message}`);
      return false;
    }
    return true;
  }

  private initListenDeviceChange(): void {
    this.initAudioRoutingManager();
    log.showInfo(`initListenDeviceChange begin`);
    try {
      this.audioRoutingManager?.on('deviceChange', audio.DeviceFlag.ALL_DEVICES_FLAG, this.handleOnAudioDevicesChange);
    } catch (error) {
      log.showError(`init listen device change error`);
    }
  }

  private handleOnAudioDevicesChange: (deviceChanged: audio.DeviceChangeAction) => void =
    (deviceChanged: audio.DeviceChangeAction) => {
      log.showInfo(`onAudioDevicesChange: ${deviceChanged.type}-${deviceChanged.deviceDescriptors.length}`);
      // 查询输入设备信息，并刷新输入设备列表UI
      this.doQueryInputAudioDevices();
    };

  private initListenCurrentInputDeviceChange(): void {
    this.initAudioRoutingManager();
    log.showInfo(`initListenCurrentInputDeviceChange begin`);
    let capturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC,
      capturerFlags: 0
    };
    try {
      this.audioRoutingManager?.on('preferredInputDeviceChangeForCapturerInfo', capturerInfo,
        this.handleOnAudioCurrentInputDevicesChange);
    } catch (error) {
      log.showError(`init listen current input device change error`);
    }
  }

  private handleOnAudioCurrentInputDevicesChange: (inputDevices: audio.AudioDeviceDescriptors) => void =
    (inputDevices: audio.AudioDeviceDescriptors) => {
      log.showInfo(`listen preferredInputDeviceChangeForCapturerInfo change, getPrefer device`);
      this.getPreferInputDevice();
    };

  private async doQueryInputAudioDevices(): Promise<void> {
    this.initAudioRoutingManager();
    // 获取音频输入设备列表
    log.showInfo(`do query input audio devices begin`);
    this.audioRoutingManager?.getDevices(audio.DeviceFlag.INPUT_DEVICES_FLAG)
      .then((inputDevices: audio.AudioDeviceDescriptors) => {
        this.audioInputDevices = [];
        this.inputDeviceAddressSet.clear();
        inputDevices.forEach((item: audio.AudioDeviceDescriptor) => {
          let device =
            new PcAudioDevice(item.id, item.name, item.deviceType.toString(), AudioIoType.INPUT_AUDIO_DEVICE_TYPE,
              item.deviceType, item);
          device.setViewIndex(this.getAudioInputDeviceForViewIndex(item));
          this.audioInputDevices.push(device);
          log.showInfo(`reflush input device: ${item.id} - [${item.name}] - ${item.deviceType.toString()}`);
        });

      // 排序输入音频设备列表的数组
      this.sortInputAudioDevices();
      // 更新view输入设备列表
      this.refreshInputDevicesListForViewModel();

      this.getPreferInputDevice();
    }).catch((error: BusinessError) => {
      log.showError(`getDevices error: ${error?.message}`);
    });
  }

  private getAudioInputDeviceForViewIndex(item: audio.AudioDeviceDescriptor): number {
    // 非蓝牙设备直接用id作为ViewIndex
    if (item.deviceType !== audio.DeviceType.BLUETOOTH_A2DP && item.deviceType !== audio.DeviceType.BLUETOOTH_SCO) {
      log.info(`get Non-Bluetooth input device id`);
      return item.id;
    }
    // 根据是否已存有该设备ID地址返回ViewIndex
    if (this.inputDeviceAddressSet.isEmpty() || !this.inputDeviceAddressSet.hasKey(item.address)) {
      log.info(`Bluetooth input device not connected before`);
      this.inputDeviceAddressSet.set(item.address, item.id);
      return item.id;
    }
    let index = Number(this.inputDeviceAddressSet.get(item.address));
    log.info(`Bluetooth device has in input devices list, viewIdex: ${index} - ${item.id}}`);
    return index;
  }

  private sortInputAudioDevices(): void {
    this.audioInputDevices.sort((x: PcAudioDevice, y: PcAudioDevice) => {
      if (x.getDeviceType().valueOf() === audio.DeviceType.MIC) {
        return -1;
      }
      if (y.getDeviceType().valueOf() === audio.DeviceType.MIC) {
        return 1;
      }
      if (x.getDeviceType().valueOf() === audio.DeviceType.BLUETOOTH_A2DP ||
        x.getDeviceType().valueOf() === audio.DeviceType.BLUETOOTH_SCO) {
        return -1;
      }
      if (y.getDeviceType().valueOf() === audio.DeviceType.BLUETOOTH_A2DP ||
        y.getDeviceType().valueOf() === audio.DeviceType.BLUETOOTH_SCO) {
        return 1;
      }
      if (x.getDeviceType().valueOf() > y.getDeviceType().valueOf()) {
        return -1;
      }
      if (x.getDeviceType().valueOf() < y.getDeviceType().valueOf()) {
        return 1;
      }
      return 0;
    });
  }

  /**
   * 获取首选的输入设备
   *
   * @param handlePreferAudio 获取后的回调
   */
  private async getPreferInputDevice(): Promise<void> {
    this.initAudioRoutingManager();
    log.showInfo(`query current input devices begin`);
    let capturerInfo: audio.AudioCapturerInfo = {
      source: await this.getCapturerInfoSource(),
      capturerFlags: 0
    };
    try {
      let descriptors: audio.AudioDeviceDescriptors | undefined =
        await this.audioRoutingManager?.getPreferredInputDeviceForCapturerInfo(capturerInfo);
      // 刷新当前选中输入设备
      this.resetPreferInputAudioDevice(descriptors);

      // 通知viewModel刷新
      this.refreshCurrentInputDeviceForViewModel();
    } catch (err) {
      log.showError(`get prefer Input audio error`);
    }
  }

  /**
   * 根据音频场景变动捕获信息，返回场景对应的录音源
   *
   * @returns 录音源
   */
  private async getCapturerInfoSource(): Promise<number> {
    try {
      this.currentScene = await this.audioManager.getAudioScene();
    } catch (err) {
      log.showError(`getAudioSceneSync error`);
    }
    log.showInfo(`current Audio Scene input: ${this.currentScene}`);
    if (await this.isCommunicationScene()) {
      return audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION;
    }
    return audio.SourceType.SOURCE_TYPE_MIC;
  }

  private async isCommunicationScene(): Promise<boolean> {
    if (this.currentScene === undefined) {
      try {
        this.currentScene = await this.audioManager.getAudioScene();
      } catch (err) {
        log.showError(`getAudioSceneSync error`);
      }
    }
    return this.currentScene ? this.COMMUNICATION_SCENES.includes(this.currentScene) : false;
  }

  /**
   * 重置prefer的输入设备
   *
   * @param descriptors 输入设备
   */
  private resetPreferInputAudioDevice(descriptors?: audio.AudioDeviceDescriptors): void {
    // 后设置优选输入Audio设备
    if (this.audioInputDevices === undefined || this.audioInputDevices.length < 1) {
      this.currentInputAudioDeviceIndex = Constants.DEFAULT_DEVICE_ID;
      log.showWarn(`Resolve prefer input audio with no input audio devices`);
      // 应该不存在没有MIC的PC
      return;
    }
    if (descriptors != null && descriptors.length >= 1) {
      // 注意：此时只会取数组中第一个元素作为当前输入Audio设备
      let device = this.audioInputDevices.find((item) => item.getDeviceIndex() === descriptors[0].id);
      if (device) {
        this.currentInputAudioDeviceIndex = device.getDeviceIndex();
        log.showInfo(`currentInputAudioDevice info: [${device.getDeviceName()}] - ${device.getDeviceType()}`);
        return;
      }
    }
    // 设置默认的麦克风为当前输入设备
    let micIndex = this.audioInputDevices.findIndex((item) => item.getDeviceType() === audio.DeviceType.MIC);
    if (micIndex > -1) {
      this.currentInputAudioDeviceIndex = this.audioInputDevices[micIndex].getDeviceIndex();
      log.showInfo(`current input device not in list, micIndex: ${this.currentInputAudioDeviceIndex}`);
    }
  }

  private initListenMicrophoneMute(): void {
    this.initAudioVolumeManager();
    log.showInfo(`initListenMicrophoneMute begin`);
    try {
      this.audioVolumeGroupManager?.on('micStateChange', (micStateChangeEvent: audio.MicStateChangeEvent) => {
        log.showInfo(`listen microphone mute status: ${micStateChangeEvent.mute}`);
        this.currentMicrophoneMuteStatus = micStateChangeEvent.mute;
        this.refreshCurrentMicrophoneMuteStatusForViewModel();
      });
    } catch (error) {
      log.showError(`init listen microphone mute error`);
    }
  }

  /**
   * 获取麦克风静音状态
   *
   * @returns 静音状态
   */
  private async doQueryMicrophoneMuteStatus(): Promise<void> {
    this.initAudioVolumeManager();
    try {
      log.showInfo(`do query microphone mute status begin`);
      this.currentMicrophoneMuteStatus = await this.audioVolumeGroupManager?.isMicrophoneMute() ?? false;
      log.showInfo(`query microphone mute status result: ${this.currentMicrophoneMuteStatus}`);
      this.refreshCurrentMicrophoneMuteStatusForViewModel();
    } catch (e) {
      log.error(`do query microphone mute status fail`);
    }
  }

  private initListenCapturerInfoChange(): void {
    this.initAudioStreamManager();
    log.showInfo(`initListenCapturerInfoChange begin`);
    try {
      this.audioStreamManager?.on('audioCapturerChange',
        (audioCapturerChangeInfoArray: audio.AudioCapturerChangeInfoArray) => {
          log.showInfo(`listen capturer change length: ${audioCapturerChangeInfoArray.length}`);
          this.currentCapturerInfoArray = audioCapturerChangeInfoArray;
          this.setTimeoutRefreshCapturerInfoChange();
        });
    } catch (err) {
      log.showError(`init listen capturer info change error`);
    }
  }

  private setTimeoutRefreshCapturerInfoChange(): void {
    if (!this.timer) {
      this.timer = setTimeout(() => {
        log.showInfo(`refresh capturer change length: ${this.currentCapturerInfoArray.length}`);
        this.refreshCapturerInfoArrayForViewModel();
        clearTimeout(this.timer);
        this.timer = undefined;
      }, Constants.DELAY_TIME);
    }
  }

  private async doQueryCapturerInfo(): Promise<void> {
    this.initAudioStreamManager();
    try {
      log.showInfo(`do query capturer info begin`);
      this.currentCapturerInfoArray = await this.audioStreamManager?.getCurrentAudioCapturerInfoArray() ?? [];
      log.showInfo(`query capturer info length: ${this.currentCapturerInfoArray.length}`);
      this.refreshCapturerInfoArrayForViewModel();
    } catch (e) {
      log.error(`do query capturer info fail`);
    }
  }

  private refreshInputDevicesListForViewModel(): void {
    this.inputDevicesListeners.forEach(listener => {
      listener.onInputDevicesChange(this.audioInputDevices);
    });
  }

  private refreshCurrentInputDeviceForViewModel(): void {
    this.currentInputDeviceListeners.forEach(listener => {
      listener.onCurrentInputDeviceChange(this.currentInputAudioDeviceIndex);
    });
  }

  private refreshCurrentMicrophoneMuteStatusForViewModel(): void {
    this.currentMicrophoneMuteStatusListeners.forEach(listener => {
      listener.onCurrentMicrophoneMuteStatus(this.currentMicrophoneMuteStatus);
    });
  }

  private refreshCapturerInfoArrayForViewModel(): void {
    this.capturerInfoArrayListeners.forEach(listener => {
      listener.onCapturerInfoArrayChange(this.currentCapturerInfoArray);
    });
  }

}

let microphonePanelModel = SingletonHelper.getInstance(MicrophonePanelModel, TAG);

export default microphonePanelModel as MicrophonePanelModel;
