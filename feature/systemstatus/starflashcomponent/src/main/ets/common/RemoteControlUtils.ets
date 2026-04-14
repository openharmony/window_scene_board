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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
// import { constant, manager, remoteDevice } from '@kit.NearLinkKit';

const TAG = 'RemoteControlUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class RemoteControlUtils {
  // 星闪开关状态
  public static readonly STATE_TURNING_ON: number = 0;
  public static readonly STATE_ON: number = 1;
  public static readonly STATE_TURNING_OFF: number = 2;
  public static readonly STATE_OFF: number = 3;
  // 星闪连接状态
  public static readonly STATE_CONNECTING: number = 0;
  public static readonly STATE_CONNECTED: number = 1;
  public static readonly STATE_DISCONNECTING: number = 2;
  public static readonly STATE_DISCONNECTED: number = 3;

  /**
   * 获取配对设备列表
   *
   * @returns 配对设备列表
   */
  public static getPairedDevices(): Array<string> {
    let devices: string[] = [];
    try {
      // devices = manager.getPairedDevices();
    } catch (err) {
      log.showError(`get paired devices fail, errCode: ${err?.code}`);
    }
    return devices;
  }

  // public static getConnectionState(deviceId: string): constant.ConnectionState {
  //   let connectState: constant.ConnectionState = constant.ConnectionState.STATE_DISCONNECTED;
  //   if (CheckEmptyUtils.checkStrIsEmpty(deviceId)) {
  //     return connectState;
  //   }
  //
  //   try {
  //     connectState = remoteDevice.createRemoteDevice(deviceId)?.getConnectionState();
  //   } catch (err) {
  //     log.showError(`get connection state fail, errCode: ${err?.code}`);
  //   }
  //   log.showInfo(`get connection state connectState: ${connectState}`);
  //   return connectState;
  // }

  /**
   * 实时查看星闪开关状态
   */
  public static isNearLinkOn(): boolean {
    let isOn: boolean = RemoteControlUtils.isNearLinkStateOn(RemoteControlUtils.getNearLinkCurrentState());
    log.showInfo(`isOn： ${isOn}`);
    return isOn;
  }

  /**
   * 获得星闪当前开关状态
   *
   * @returns 开关状态
   */
  public static getNearLinkCurrentState(): number {
    let state = RemoteControlUtils.STATE_OFF;
    try {
      // state = manager.getState();
    } catch (err) {
      log.showError(`get near link switch state fail, errCode: ${err?.code}`);
    }
    log.showInfo(`near link state: ${state}`);
    return state;
  }

  /**
   * 判断对应状态是否开启状态
   *
   * @param state 待判断的状态
   */
  public static isNearLinkStateOn(state: number): boolean {
    return state === RemoteControlUtils.STATE_ON;
  }
}