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

import rpc from '@ohos.rpc';
import { DeviceShowInfo } from '../common/model/DeviceShowInfo';
import PluginCardController from '../controller/PluginCardController';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogHelper, LogDomain } from '@ohos/basicutils';

const TAG: string = 'SceneBoardServiceStub';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default class SceneBoardServiceStub extends rpc.RemoteObject {
  private static readonly COMMAND_SHOW_INFO_LIST_CHANGE: number = 1004;
  private static readonly COMMAND_UPDATE_STATE: number = 1005;
  private static readonly COMMAND_ACCOUNT_STATE: number = 1006;
  private static readonly MAX_DEVICE_NUM: number = 1024;
  private static readonly SUPER_DEVICE_SERVICE_DESCRIPTOR = 'com.openharmony.SuperDeviceManager';

  constructor(descriptor: string) {
    super(descriptor);
  }

  onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): boolean | Promise<boolean> {
    let token: string = data.readInterfaceToken();
    if (token !== SceneBoardServiceStub.SUPER_DEVICE_SERVICE_DESCRIPTOR ) {
      return false;
    }
    log.showInfo(`onRemoteMessageRequest called, code:${code}`);
    switch (code) {
      case SceneBoardServiceStub.COMMAND_SHOW_INFO_LIST_CHANGE:
        return this.deviceListUpdate(data, reply, option);
      case SceneBoardServiceStub.COMMAND_UPDATE_STATE:
        return this.notifyStateUpdate(data, reply, option);
      case SceneBoardServiceStub.COMMAND_ACCOUNT_STATE:
        return this.setAccountState(data, reply, option);
      default: {
        log.showError(`RpcServer: unknown code:${code}`);
        return false;
      }
    }
  }

  private deviceListUpdate(data: rpc.MessageSequence, reply: rpc.MessageSequence, option: rpc.MessageOption): boolean {
    if (PluginCardController.isRelease) {
      log.showError('Releasing resource... not handle rpc message');
      return true;
    }
    let deviceNum = data.readInt();
    deviceNum = deviceNum > SceneBoardServiceStub.MAX_DEVICE_NUM ? SceneBoardServiceStub.MAX_DEVICE_NUM : deviceNum;
    let devices: DeviceShowInfo[] = [];
    try {
      log.showInfo(`device length:${deviceNum}`);
      for (let i = 0; i < deviceNum; i++) {
        devices.push(new DeviceShowInfo('', '', '', '', '', '', '', []));
      }
      data.readParcelableArray(devices);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      log.showError(`Rpc read deviceShowInfoList fail, errorCode:${e.code}, errorMessage:${e.message}`);
    }
    PluginCardController.getInstance().setRadarAllDevices(devices);
    PluginCardController.getInstance().deviceListUpdate(devices);
    return true;
  }

  private notifyStateUpdate(data: rpc.MessageSequence, reply: rpc.MessageSequence, option: rpc.MessageOption): boolean {
    let key = data.readString();
    let serviceName = data.readString();
    let state = data.readInt();
    let errorMessage = data.readString();
    let errorCode = data.readString();
    log.showInfo(`notifyStateUpdate, serviceName:${serviceName}, state:${state} error: ${errorMessage}`);
    PluginCardController.getInstance().notifyStateUpdate(key, serviceName, state, errorMessage, errorCode);
    return true;
  }

  private setAccountState(data: rpc.MessageSequence, reply: rpc.MessageSequence, option: rpc.MessageOption): boolean {
    let accountState = data.readBoolean();
    log.showInfo(`notifyStateUpdate, accountState:${accountState}`);
    PluginCardController.getInstance().setAccountState(accountState);
    return true;
  }
}