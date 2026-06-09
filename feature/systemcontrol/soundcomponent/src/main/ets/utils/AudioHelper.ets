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
import { HashMap } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BusinessError } from '@kit.BasicServicesKit';

const OUTPUT_DEVICE_INDEX = 0;

const TAG = 'Sound.AudioHelper'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

/*
 *
 * 事件监听器
 * @since 2023/11/15 11:48:16
 */
interface EventListener<T> {
  /**
   * 当事件发生时回调
   * @param data 上报数据
   */
  onEvent: (data: T) => void;
}

export class AudioHelper {
  private audioManager: audio.AudioManager | null = null;
  private audioRoutingManager: audio.AudioRoutingManager | null = null;
  private rendererInfo: audio.AudioRendererInfo;
  public outputDevice?: audio.AudioDeviceDescriptor;
  private static instance?: AudioHelper;
  /**
   * 最高优先级输出设备变化监听列表
   */
  private mOutputDeviceChangeListeners: HashMap<string, EventListener<audio.AudioDeviceDescriptor>> = new HashMap();

  /**
   * 最高优先级输出设备变化回调，保持回调为单例，防止注册多个回调引起内存泄漏
   */
  private readonly outputDeviceCallback: (descriptors: audio.AudioDeviceDescriptors) => void =
    (descriptors: audio.AudioDeviceDescriptors) => {
      if (!descriptors || descriptors.length < 1) {
        log.showError(`onOutputDeviceChange descriptors invalid: ${descriptors}`);
        return;
      }
      this.outputDevice = descriptors[OUTPUT_DEVICE_INDEX];
      log.showInfo(`onOutputDeviceChange displayName: ${this.outputDevice.displayName}, deviceType: ${
      this.outputDevice.deviceType},mOutputDeviceChangeListeners length ${this.mOutputDeviceChangeListeners.length}`);
      this.mOutputDeviceChangeListeners.forEach((listener) => {
        listener?.onEvent(this.outputDevice as audio.AudioDeviceDescriptor);
      });
    };

  constructor() {
    try {
      this.audioManager = audio.getAudioManager();
      this.audioRoutingManager = this.audioManager.getRoutingManager();
      log.showInfo(`init volumeVM success`);
    } catch (err) {
      log.showInfo(`fail init volumeVM ,err: ${err}`);
    }
    this.rendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_MEDIA,
      rendererFlags: 0
    }
    this.onOutputDeviceChange();
  }

  static getInstance(): AudioHelper {
    if (!AudioHelper.instance) {
      AudioHelper.instance = new AudioHelper();
    }
    return AudioHelper.instance;
  }

  /**
   * 根据音频信息，返回优先级最高的输出设备，同步返回结果。
   * @returns 优先级最高的输出设备mac集合
   */
  public getOutputDevice(): undefined | audio.AudioDeviceDescriptor {
    try {
      const descriptors = this.audioRoutingManager?.getPreferredOutputDeviceForRendererInfoSync(this.rendererInfo);
      this.outputDevice = descriptors?.[OUTPUT_DEVICE_INDEX];
      log.showInfo(`getOutputDevice name: ${this.outputDevice?.name} displayName:${this.outputDevice?.displayName}, deviceType: ${this.outputDevice?.deviceType}`);
    } catch (err) {
      log.showError(`getOutputDevice: Result ERROR: ${(err as BusinessError).code}, ${(err as BusinessError).message}`);
    }
    return this.outputDevice;
  }

  /**
   * 订阅最高优先级输出设备变化事件
   */
  public onOutputDeviceChange() {
    try {
      this.audioRoutingManager?.on('preferOutputDeviceChangeForRendererInfo', this.rendererInfo,
        this.outputDeviceCallback);
    } catch (err) {
      log.showError(`onOutputDeviceChange fail:${(err as BusinessError).code}, ${(err as BusinessError).message}`);
    }
  }

  /**
   * 取消订阅最高优先级输出设备变化事件。
   */
  public offOutputDeviceChange() {
    try {
      this.audioRoutingManager?.off('preferOutputDeviceChangeForRendererInfo', this.outputDeviceCallback);
    } catch (err) {
      log.showError(`offOutputDeviceChange fail:${(err as BusinessError).code}, ${(err as BusinessError).message}`);
    }
  }

  /**
   * 添加最高优先级输出设备变化监听器
   * @param tag 监听器标记
   * @param listener 监听器
   */
  public addOutputDeviceChangeListener(tag: string, listener: EventListener<audio.AudioDeviceDescriptor>) {
    if (!tag) {
      return;
    }
    log.showInfo(`addOutputDeviceChangeListener ${tag}`)
    this.mOutputDeviceChangeListeners.set(tag, listener);
  }

  /**
   * 移除最高优先级输出设备变化监听器
   * @param tag 监听器标记
   */
  public removeOutputDeviceChangeListener(tag: string) {
    this.mOutputDeviceChangeListeners.remove(tag);
    log.showInfo(`removeOutputDeviceChangeListener ${tag}`)
  }

  /**
   * 判断设备类型是否为无线设备
   * @param deviceType 设备类型
   * @returns true 是星闪或A2DP或SCO
   */
  public isWirelessDevice(deviceType: number = audio.DeviceType.INVALID): boolean {
    return deviceType === audio.DeviceType.NEARLINK || deviceType === audio.DeviceType.BLUETOOTH_A2DP ||
      deviceType === audio.DeviceType.BLUETOOTH_SCO;
  }

  /**
   * 判断设备类型是否为USB_HEADSET或WIRED_HEADSET或WIRED_HEADPHONES
   * @param deviceType 设备类型
   * @returns true 是有线耳机
   */
  public isUsbHeadset(deviceType: number = audio.DeviceType.INVALID): boolean {
    return deviceType === audio.DeviceType.USB_HEADSET || deviceType === audio.DeviceType.WIRED_HEADSET ||
      deviceType === audio.DeviceType.WIRED_HEADPHONES;
  }
}
