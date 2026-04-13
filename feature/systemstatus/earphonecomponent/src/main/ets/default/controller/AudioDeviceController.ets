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

import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  AudioManagerHelper,
} from '@ohos/basicutils';
import {
  AudioEvent,
  EvtBus,
  sEventManager,
  obtainLocalEvent,
  PluginRequestEvent,
  PluginSlot,
  EventManager
} from '@ohos/frameworkwrapper';
import audio from '@ohos.multimedia.audio';

const TAG = 'Model.AudioDeviceController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const REMOTE_CAST_TYPE = 24;
const NO_EAR_PHONE_TYPE = -1;

export interface CurDevInfo {
  deviceId: number,
  deviceType: audio.DeviceType,
  deviceAddress?: string,
  networkId?: string;
}

export class AudioDeviceController {
  private audioManager: audio.AudioManager;
  private audioRoutingManager?: audio.AudioRoutingManager;
  private audioStreamManager?: audio.AudioStreamManager;
  private curDevLink?: AbstractProperty<CurDevInfo>;

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  static getInstance(): AudioDeviceController {
    return SingletonHelper.getInstance(AudioDeviceController, TAG);
  }

  constructor() {
    this.audioManager = AudioManagerHelper.getAudioManager();
    this.curDevLink = AppStorage.setAndRef('CurDevSelect', { deviceType: audio.DeviceType.SPEAKER, deviceId: -1 });
    this.getAndShowDevice();
    this.setRoutingManagerListener();
    sEventManager.subscribe('MediaCardRefreshEvent', (state: boolean) => {
      log.showDebug('MediaCardRefreshEvent Change');
      this.getAndShowDevice();
    });
    this.eventMgr.produceOn(PluginRequestEvent,
      (slot?: string): PluginRequestEvent | null => this.onProducePluginRequestEvent(slot));
  }

  /**
   * 标示耳机图标
   */
  private getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_EARPHONE;
  }

  /**
   * 状态栏图标可见性事件
   */
  private sbPluginRequest: PluginRequestEvent = PluginRequestEvent.create(this.getSbPluginSlot(),
    PluginRequestEvent.REQUEST_TYPE_VISIBILITY, PluginRequestEvent.VALUE_VISIBILITY_GONE);

  async setRoutingManagerListener(): Promise<void> {
    if (!this.audioRoutingManager) {
      log.showInfo('setRoutingManagerListener fail without audioRoutingManager');
      return;
    }
    log.showWarn('setRoutingManagerListener deviceChange');
    try {
      this.audioRoutingManager.on('deviceChange', audio.DeviceFlag.ALL_DEVICES_FLAG, async (deviceChangeAction) => {
        log.showInfo('Device change callback');
        let event = AudioEvent.create(deviceChangeAction);
        EvtBus.post(AudioEvent, event);

        let deviceDescriptors = deviceChangeAction.deviceDescriptors;
        if (deviceChangeAction.type === audio.DeviceChangeType.DISCONNECT) {
          log.showInfo('Device disconnected change');
        } else {
          log.showInfo('Device connected change');
        }
        for (let i = 0; i < deviceDescriptors.length; i++) {
          let changeDev: audio.AudioDeviceDescriptor = deviceDescriptors[i];
          log.showInfo(`change dev info : ${changeDev.id}|${changeDev.deviceType}`);
        }
        this.getAndShowDevice();
      });
    } catch (error) {
      log.error(`audioRoutingManager.on fail error: ${error}`);
    }


    log.showInfo('setRoutingManagerListener preferOutputDeviceChangeForRendererInfo');
    let rendererInfo: audio.AudioRendererInfo = {
      content: audio.ContentType.CONTENT_TYPE_MUSIC,
      usage: audio.StreamUsage.STREAM_USAGE_MEDIA,
      rendererFlags: 0 };
    try {
      this.audioRoutingManager.on('preferOutputDeviceChangeForRendererInfo', rendererInfo, (desc) => {
        log.showInfo('preferOutputDeviceChangeForRendererInfo callback');
        this.getAndShowDevice();
        sEventManager.publish(obtainLocalEvent('outOutDeviceChangeEvent', true));
        log.showInfo('outOutDeviceChangeEvent callback');
      });
    } catch (error) {
      log.error(`audioRoutingManager.on fail error: ${error}`);
    }

    log.showInfo('setRoutingManagerListener  end');
  }

  async getAndShowDevice(): Promise<void> {
    log.showInfo('createDeviceManager start');
    if (this.audioManager) {
      log.showInfo('get audio Manager');
      if (!this.audioStreamManager) {
        this.audioStreamManager = this.audioManager.getStreamManager();
      }
      if (!this.audioRoutingManager) {
        this.audioRoutingManager = this.audioManager.getRoutingManager();
        this.setRoutingManagerListener();
      }
    }
    let outputArray: audio.AudioRendererChangeInfoArray =
      await this.audioStreamManager?.getCurrentAudioRendererInfoArray()!;
    log.showInfo(' get audioStreamManager array :' + outputArray.length);
    outputArray.forEach(((renderInfo, index) => {
      log.showInfo(`foreach renderInfo : ${renderInfo.streamId} | ${renderInfo.deviceDescriptors.length} | ${index}`);
      let curdev: audio.AudioDeviceDescriptor = renderInfo.deviceDescriptors[renderInfo.deviceDescriptors.length - 1];
      log.showInfo('foreach AudioDeviceDescriptor : ' + curdev.deviceType + '|' + curdev.networkId + '|' + curdev.id + '|' + index);
      log.showDebug(`foreach AudioDeviceDescriptor set cur : ${curdev.id}`);
      log.showInfo(`foreach insss : ${index}`);
      let curDevInfo: CurDevInfo = {
        deviceId: curdev.id,
        deviceType: curdev.deviceType,
        deviceAddress: curdev.address,
        networkId: curdev.networkId,
      };
      this.setCurDevLink(curDevInfo);
      log.showInfo(`foreach done for : ${index}`);
    }));
    try {
      if (this.audioRoutingManager) {
        log.showInfo('get curDev from new interface');
        let curDevicesAvailable: audio.AudioDeviceDescriptors =
          await this.audioRoutingManager.getActiveOutputDeviceDescriptors();
        log.showInfo(`get curDev from new interface , curAvailable : ${curDevicesAvailable}`);
        log.showInfo(`get curDev from new interface , curAvailable size : ${curDevicesAvailable.length}`);
        for (let i = 0; i < curDevicesAvailable.length; i++) {
          let curdev: audio.AudioDeviceDescriptor = curDevicesAvailable[i];
          log.showInfo(`get curDev from new interface , dev : ${curdev.deviceType} | ${curdev.id}`);
          let curDevInfo: CurDevInfo = {
            deviceId: curdev.id,
            deviceType: curdev.deviceType,
            deviceAddress: curdev.address,
            networkId: curdev.networkId
          };
          AppStorage.set('AudioDeviceType', curDevInfo.deviceType);
          this.setCurDevLink(curDevInfo);
        }
      }
    } catch (err) {
      log.showInfo(`get curDev from new interface , err : ${err}`);
    }

    try {
      const curCallDevicesAvailable: audio.AudioDeviceDescriptors =
        await this.audioRoutingManager?.getPreferOutputDeviceForRendererInfo({
          usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION, rendererFlags: 0,
        }) || [];
      log.showInfo(`get call device, size : ${curCallDevicesAvailable.length}`);
      for (let i = 0; i < curCallDevicesAvailable.length; i++) {
        let curDev : audio.AudioDeviceDescriptor = curCallDevicesAvailable[i];
        let curDevInfo: CurDevInfo = {
          deviceId: curDev.id,
          deviceType: curDev.deviceType,
          deviceAddress: curDev.address,
          networkId: curDev.networkId
        };
        AppStorage.setOrCreate('curCallDev', curDevInfo);
      }
    } catch (err) {
      log.showInfo(`get call device, err: ${err}`);
    }
  }

  setCurDevLink(curDevInfo: CurDevInfo): void {
    log.showDebug('setCurDevLink start');
    if (this.curDevLink == null) {
      log.showInfo('setCurDevLink CurDevLink is null'); // pc控制中心出现未初始化情况
      this.curDevLink = AppStorage.setAndRef('CurDevSelect', { deviceType: audio.DeviceType.SPEAKER, deviceId: -1 });
    }
    this.curDevLink.set(curDevInfo);
    this.handleStatusBarState(this.getEarPhoneEnable(curDevInfo.deviceType));
    log.showDebug('setCurDevLink end');
  }

  private getEarPhoneEnable(deviceType: number): boolean {
    switch (deviceType) {
      case audio.DeviceType.SPEAKER:
      case audio.DeviceType.EARPIECE:
      case audio.DeviceType.BLUETOOTH_A2DP:
      case audio.DeviceType.BLUETOOTH_SCO:
      case audio.DeviceType.DISPLAY_PORT:
      case audio.DeviceType.NEARLINK:
      case REMOTE_CAST_TYPE:
      case NO_EAR_PHONE_TYPE:
        return false;
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      default:
        return true;
    }
  }

  /**
   * 控制状态栏图标显示与隐藏
   * @param newState
   */
  private handleStatusBarState(newState: boolean): void {

    let oldState = this.sbPluginRequest.isVisible();
    log.showFatal(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
    if (oldState !== newState) {
      log.showInfo(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

  /**
   * plugin请求事件生产者
   *
   * @param slot plugin唯一标示
   * @return 事件
   */
  private onProducePluginRequestEvent(slot?: string): PluginRequestEvent | null {
    if (slot !== this.getSbPluginSlot()) {
      return null;
    }
    return this.sbPluginRequest;
  }
}

let sAudioDeviceController = SingletonHelper.getInstance(AudioDeviceController, TAG);

export default sAudioDeviceController as AudioDeviceController;