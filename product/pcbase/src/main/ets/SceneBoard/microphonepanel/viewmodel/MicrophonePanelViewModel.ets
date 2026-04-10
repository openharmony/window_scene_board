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
import { image } from '@kit.ImageKit';
import bundleManager from '@ohos.bundle.bundleManager';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import type context from '@ohos.app.ability.common';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import Constants from '../common/Constants';
import MicrophonePanelModel, {
  CapturerInfoArrayListener,
  CurrentInputDeviceChangeListener,
  CurrentMicrophoneMuteStatusListener,
  InputDevicesChangeListener } from '../model/MicrophonePanelModel';
import { PcAudioDevice } from '../PcAudioDevice';

export interface StateChangeListener { onStateChange: Function }

export interface InputDevicesChangeForUIListener { onInputDevicesChangeForUI: (devices: InputCardItemProp[]) => void }

export interface CurrentInputDeviceChangeForUIListener { onCurrentInputDeviceChangeForUI: (idex: number) => void }

export interface CurrentMicrophoneMuteStatusForUIListener {
  onCurrentMicrophoneMuteStatusForUI: (isMute: boolean) => void
}

export interface AppCapturerCardItemsForUIListener {
  onCapturerInfoArrayForUI: (appCapturerCardItems: AppCapturerCardItemProp[]) => void
}

export interface InputCardItemProp {
  viewIndex?: number,
  deviceIndex: number,
  title: string,
  type: audio.DeviceType,
  address: string
}

export interface AppCapturerCardItemProp {
  clientUid: number;
  bundleName: string;
  appName: string;
  icon: image.PixelMap | ResourceStr | DrawableDescriptor;
}

const TAG = 'MicrophonePanelViewModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class MicrophonePanelViewModel {
  private inputDevicesForUIListeners = new Set<InputDevicesChangeForUIListener>();
  private currentInputDeviceForUIListeners = new Set<CurrentInputDeviceChangeForUIListener>();
  private currentMicrophoneMuteStatusForUIListeners = new Set<CurrentMicrophoneMuteStatusForUIListener>();
  private appCapturerCardItemsForUIListeners = new Set<AppCapturerCardItemsForUIListener>();
  private audioInputDevices: InputCardItemProp[] = [];
  private currentInputAudioDeviceIndex: number = Constants.DEFAULT_DEVICE_ID;
  private currentMicrophoneMuteStatus: boolean = false;
  private appCapturerCardItems: AppCapturerCardItemProp[] = [];
  private mStateChangeListeners = new Set<StateChangeListener>();

  constructor() {
    log.showInfo(`constructor`);
    MicrophonePanelModel.registerInputDevicesListener(this.inputDevicesChangeListener);
    MicrophonePanelModel.registerCurrentInputDeviceListener(this.currentInputDeviceChangeListener);
    MicrophonePanelModel.registerCurrentMicrophoneMuteStatusListener(this.currentMicrophoneMuteStatusListener);
    MicrophonePanelModel.registerCapturerInfoArrayListener(this.capturerInfoArrayListenerListener);
    this.inputDevicesDataProcessFromModel(MicrophonePanelModel.getAudioInputDevices());
    this.currentInputDeviceDataProcessFromModel(MicrophonePanelModel.getCurrentInputAudioDeviceIndex());
    this.currentMicrophoneMuteStatusDataProcessFromModel(MicrophonePanelModel.getCurrentMicrophoneMuteStatus());
    this.capturerInfoArrayDataProcessFromModel(MicrophonePanelModel.getCurrentCapturerInfoArray());
  }

  /**
   * 订阅面板打开状态
   *
   * @param listener 监听方法
   */
  public registerStateChangeListener(listener: StateChangeListener): void {
    if (!listener) {
      return;
    }
    this.mStateChangeListeners.add(listener);
    log.showInfo(`register StateChangeListener size: ${this.mStateChangeListeners.size}`);
  }

  /**
   * 取消订阅面板打开状态
   *
   * @param listener 监听方法
   */
  public unregisterStateChangeListener(listener: StateChangeListener): void {
    if (!listener) {
      return;
    }
    this.mStateChangeListeners.delete(listener);
    log.showInfo(`unregister StateChangeListener size: ${this.mStateChangeListeners.size}`);
  }

  /**
   * 通知更新面板打开状态
   *
   * @param listener 监听方法
   */
  public refreshStateChange(panelState:boolean): void {
    log.showInfo(`refreshStateChange, panelState: ${panelState}`);
    this.mStateChangeListeners.forEach(listener => {
      listener.onStateChange(panelState)
    });
  }

  /**
   * 获取当前输入设备列表
   */
  public getAudioInputDevices(): InputCardItemProp[] {
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
   * 获取当前capturer流中附带的APP信息
   */
  public getAppCapturerCardItems(): AppCapturerCardItemProp[] {
    return this.appCapturerCardItems;
  }

  /**
   * 下发选择全局输入设备
   *
   * @param index 设备id
   * @param caller 调用方
   */
  public selectAudioInputDevice(index: number, caller: string): void {
    log.showInfo(`${caller} selectAudioInputDevice begin, index :${index}`);
    let odx = this.audioInputDevices.findIndex((i) => i.viewIndex === index);
    if (odx > -1) {
      this.currentInputAudioDeviceIndex = index;
      this.refreshCurrentInputDeviceForUI(index);
      MicrophonePanelModel.selectAudioInputDevice(index, caller);
    } else {
      log.showWarn(`${caller} select input devices ERROR: no device with ${index}`);
    }
  }

  /**
   * 下发选择麦克风静音状态
   *
   * @param mute 麦克风静音状态
   * @param caller 调用方
   */
  public setMicrophoneMute(mute: boolean, caller: string): void {
    log.showInfo(`${caller} setMicrophoneMute begin, mute :${mute}`);
    this.currentMicrophoneMuteStatus = mute;
    this.refreshCurrentMicrophoneMuteStatusForUI(mute);
    MicrophonePanelModel.setMicrophoneMute(mute, caller);
  }

  /**
   * 订阅输入设备列表
   *
   * @param listener 监听方法
   */
  public registerInputDevicesForUIListener(listener: InputDevicesChangeForUIListener): void {
    if (!listener) {
      return;
    }
    this.inputDevicesForUIListeners.add(listener);
    log.showInfo(`register InputDevicesForUIListener size: ${this.inputDevicesForUIListeners.size}`);
  }

  /**
   * 取消订阅输入设备列表
   *
   * @param listener 监听方法
   */
  public unregisterInputDevicesForUIListener(listener: InputDevicesChangeForUIListener): void {
    if (!listener) {
      return;
    }
    this.inputDevicesForUIListeners.delete(listener);
    log.showInfo(`unregister InputDevicesForUIListener size: ${this.inputDevicesForUIListeners.size}`);
  }

  /**
   * 订阅当前输入设备id
   *
   * @param listener 监听方法
   */
  public registerCurrentInputDeviceForUIListener(listener: CurrentInputDeviceChangeForUIListener): void {
    if (!listener) {
      return;
    }
    this.currentInputDeviceForUIListeners.add(listener);
    log.showInfo(`register CurrentInputDeviceForUIListener size: ` +
      `${this.currentInputDeviceForUIListeners.size}`);
  }

  /**
   * 取消订阅当前输入设备id
   *
   * @param listener 监听方法
   */
  public unregisterCurrentInputDeviceForUIListener(listener: CurrentInputDeviceChangeForUIListener): void {
    if (!listener) {
      return;
    }
    this.currentInputDeviceForUIListeners.delete(listener);
    log.showInfo(`unregister CurrentInputDeviceForUIListener size: ` +
      `${this.currentInputDeviceForUIListeners.size}`);
  }

  /**
   * 订阅麦克风静音状态
   *
   * @param listener 监听方法
   */
  public registerCurrentMicrophoneMuteStatusForUIListener(listener: CurrentMicrophoneMuteStatusForUIListener): void {
    if (!listener) {
      return;
    }
    this.currentMicrophoneMuteStatusForUIListeners.add(listener);
    log.showInfo(`register currentMicrophoneMuteStatusForUIListeners size: ` +
      `${this.currentMicrophoneMuteStatusForUIListeners.size}`);
  }

  /**
   * 取消订阅麦克风静音状态
   *
   * @param listener 监听方法
   */
  public unregisterCurrentMicrophoneMuteStatusForUIListener(listener: CurrentMicrophoneMuteStatusForUIListener): void {
    if (!listener) {
      return;
    }
    this.currentMicrophoneMuteStatusForUIListeners.delete(listener);
    log.showInfo(`unregister currentMicrophoneMuteStatusForUIListeners size: ` +
      `${this.currentMicrophoneMuteStatusForUIListeners.size}`);
  }

  /**
   * 订阅当前capturer流中附带的APP信息
   *
   * @param listener 监听方法
   */
  public registerCapturerInfoArrayForUIListener(listener: AppCapturerCardItemsForUIListener): void {
    if (!listener) {
      return;
    }
    this.appCapturerCardItemsForUIListeners.add(listener);
    log.showInfo(`register CapturerInfoArrayForUIListeners size: ` +
      `${this.currentInputDeviceForUIListeners.size}`);
  }

  /**
   * 取消订阅当前capturer流中附带的APP信息
   *
   * @param listener 监听方法
   */
  public unregisterCapturerInfoArrayForUIListener(listener: AppCapturerCardItemsForUIListener): void {
    if (!listener) {
      return;
    }
    this.appCapturerCardItemsForUIListeners.delete(listener);
    log.showInfo(`unregister CapturerInfoArrayForUIListeners size: ` +
      `${this.currentInputDeviceForUIListeners.size}`);
  }

  // 输入设备列表UI参数变更的监听回调
  private inputDevicesChangeListener: InputDevicesChangeListener = {
    onInputDevicesChange: (devices: PcAudioDevice[]) => {
      this.inputDevicesDataProcessFromModel(devices);
    }
  };

  // 输入焦点设备UI参数变更的监听回调
  private currentInputDeviceChangeListener: CurrentInputDeviceChangeListener = {
    onCurrentInputDeviceChange: (idex: number) => {
      this.currentInputDeviceDataProcessFromModel(idex);
    }
  };

  // 麦克风静音UI参数变更的监听回调
  private currentMicrophoneMuteStatusListener: CurrentMicrophoneMuteStatusListener = {
    onCurrentMicrophoneMuteStatus: (isMute: boolean) => {
      this.currentMicrophoneMuteStatusDataProcessFromModel(isMute);
    }
  };

  // 使用capturer流的应用UI参数变更的监听回调
  private capturerInfoArrayListenerListener: CapturerInfoArrayListener = {
    onCapturerInfoArrayChange: (capturerInfoArray: Array<audio.AudioCapturerChangeInfo>) => {
      this.capturerInfoArrayDataProcessFromModel(capturerInfoArray);
    }
  };

  private inputDevicesDataProcessFromModel(devices: PcAudioDevice[]): void {
    // 对当前输入设备列表进行view层的业务处理
    log.showInfo(`inputDevicesDataProcessFromModel length: ${devices.length}`);
    let tarInputDevices: InputCardItemProp[] = [];
    for (const item of devices) {
      let index = tarInputDevices.findIndex(tarItem => {
        return item.getViewIndex() === tarItem.viewIndex;
      });
      if (index !== -1) { // 去除重复的蓝牙设备
        continue;
      }
      tarInputDevices.push({
        viewIndex: item.getViewIndex(),
        deviceIndex: item.getDeviceIndex(),
        title: this.getDeviceName(item.getDeviceName(), item.getDeviceType()),
        type: item.getDeviceType(),
        address: item.getAudioDeviceDescriptor().address
      });
      log.showInfo(`push device info: ` +
        `${item.getDeviceIndex()} - [${item.getDeviceName()}] - ${item.getDeviceType()}`);
    }
    this.audioInputDevices = tarInputDevices;
    this.refreshInputDevicesListForUI(tarInputDevices);
  }

  private getDeviceName(deviceName: string, deviceType: number): string {
    if (deviceName !== undefined && deviceName !== '' && deviceName !== null) {
      log.showInfo(`getDeviceName: ${deviceName}`);
      return deviceName;
    }
    let nameResource: Resource | null = null;
    switch (deviceType) {
      case audio.DeviceType.EARPIECE:
        nameResource = $r('app.string.sound_device_earpiece');
        break;
      case audio.DeviceType.SPEAKER:
        nameResource = $r('app.string.sound_output_device_local');
        break;
      case audio.DeviceType.MIC:
        nameResource = $r('app.string.sound_intput_device_local');
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
      case audio.DeviceType.DISPLAY_PORT:
      case audio.DeviceType.REMOTE_CAST:
        nameResource = $r('app.string.sound_output_device_display_port');
        break;
      default:
        log.showError(`${TAG} unknown type: ${deviceType}`);
        nameResource = $r('app.string.sound_output_device_default');
        break;
    }
    let resName: string = '';
    try {
      const context: context.Context = GlobalContext.getContext() as context.Context;
      resName = context.resourceManager.getStringSync(nameResource);
    } catch (e) {
      log.error(`getStringByNameSync fail`);
    }
    return resName;
  }

  private currentInputDeviceDataProcessFromModel(index: number): void {
    // 对当前输入设备选中进行view层的业务处理
    log.showInfo(`currentInputDeviceDataProcessFromModel index: ${index}`);
    const inputDevices = MicrophonePanelModel.getAudioInputDevices();
    let tarDevices = inputDevices.find(device => {
      return device.getDeviceIndex() === index;
    });
    log.showInfo(`currentInputDeviceDataProcessFromModel tarDevices: ${tarDevices?.getViewIndex()} ` +
      `- [${tarDevices?.getDeviceName()}] - ${tarDevices?.getDeviceType()}`);
    if (!tarDevices) {
      log.showWarn(`not has the tarDevices, index: ${index}`);
      return;
    }
    this.currentInputAudioDeviceIndex = tarDevices.getViewIndex() ?? Constants.DEFAULT_DEVICE_ID;
    this.refreshCurrentInputDeviceForUI(this.currentInputAudioDeviceIndex);
  }

  private currentMicrophoneMuteStatusDataProcessFromModel(isMute: boolean): void {
    // 对当前输入设备选中进行view层的业务处理
    log.showInfo(`currentMicrophoneMuteStatusDataProcessFromModel status: ${isMute}`);
    this.currentMicrophoneMuteStatus = isMute;
    this.refreshCurrentMicrophoneMuteStatusForUI(isMute);
  }

  private capturerInfoArrayDataProcessFromModel(capturerInfoArray: Array<audio.AudioCapturerChangeInfo>): void {
    // 对当前输入设备选中进行view层的业务处理
    log.showInfo(`capturerInfoArrayDataProcessFromModel length: ${capturerInfoArray.length}`);
    let tarAppCaptruerInfos: AppCapturerCardItemProp[] = [];
    for (const capturerInfo of capturerInfoArray) {
      if (capturerInfo.capturerState === audio.AudioState.STATE_RUNNING) {
        // 去重
        let index: number = tarAppCaptruerInfos.findIndex((appCaptruerInfo) => {
          return appCaptruerInfo.clientUid === capturerInfo.clientUid;
        });
        if (index !== -1) {
          continue;
        }

        let tarAppCaptruerInfo: AppCapturerCardItemProp | null = this.getAppCardItemByCapturerInfo(capturerInfo);
        if (tarAppCaptruerInfo === null) {
          continue;
        }
        log.showInfo(`push appCapturerCardItem appName: ${tarAppCaptruerInfo.appName}`);
        tarAppCaptruerInfos.push(tarAppCaptruerInfo as AppCapturerCardItemProp);
      }
    }
    this.appCapturerCardItems = tarAppCaptruerInfos;
    this.refreshCapturerInfoArrayForUI(tarAppCaptruerInfos);
  }

  private getAppCardItemByCapturerInfo(capturerInfo: audio.AudioCapturerChangeInfo): AppCapturerCardItemProp | null {
    try {
      let appBundleName = bundleManager.getBundleNameByUidSync(capturerInfo.clientUid);
      log.showInfo(`getAppCardItemByCapturerInfo bundName: ${appBundleName}`);
      if (appBundleName === Constants.PCSETTINGS_BUNDLE_NAME ) {
        return null;
      }
      let appInfo: bundleResourceManager.BundleResourceInfo =
        bundleResourceManager.getBundleResourceInfo(appBundleName);
      let appCardItem: AppCapturerCardItemProp = {
        clientUid: capturerInfo.clientUid,
        bundleName: appBundleName,
        appName: appInfo.label,
        icon: appInfo.icon
      };
      return appCardItem;
    } catch (err) {
      log.showError(`getAppCardItemsByCapturerInfo error`);
    }
    return null;
  }

  private refreshInputDevicesListForUI(devices: InputCardItemProp[]): void {
    this.inputDevicesForUIListeners.forEach(listener => {
      listener.onInputDevicesChangeForUI(devices);
    });
  }

  private refreshCurrentInputDeviceForUI(idex: number): void {
    this.currentInputDeviceForUIListeners.forEach(listener => {
      listener.onCurrentInputDeviceChangeForUI(idex);
    });
  }

  private refreshCurrentMicrophoneMuteStatusForUI(isMute: boolean): void {
    this.currentMicrophoneMuteStatusForUIListeners.forEach(listener => {
      listener.onCurrentMicrophoneMuteStatusForUI(isMute);
    });
  }

  private refreshCapturerInfoArrayForUI(appCapturerCardItemProps :AppCapturerCardItemProp[]): void {
    this.appCapturerCardItemsForUIListeners.forEach(listener => {
      listener.onCapturerInfoArrayForUI(appCapturerCardItemProps);
    });
  }
}

let microphonePanelViewModel = new MicrophonePanelViewModel();

export default microphonePanelViewModel as MicrophonePanelViewModel;
