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
import SceneBoardServiceStub from './SceneBoardServiceStub'
import type { BusinessError } from '@ohos.base';
import { LogHelper, LogDomain } from '@ohos/basicutils';

import { DfxSceneBoard, BizScene, BizStage, StageRes, ErrCode, DfxReportSceneInfo } from '../DFX/DfxUtils';
import PluginCardController from '../controller/PluginCardController';
import { PageMode, SuperDeviceController } from '../controller/SuperDeviceController';

const TAG: string = 'SuperDeviceExtServiceProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default class SuperDeviceExtServiceProxy {
  private static readonly COMMAND_SUBSCRIBE_SHOW_INFO: number = 1000;
  private static readonly COMMAND_UNSUBSCRIBE_SHOW_INFO: number = 1001;
  private static readonly COMMAND_START_CONTINUITY: number = 1002;
  private static readonly COMMAND_STOP_CONTINUITY: number = 1003;
  private static readonly COMMAND_QUERY_CURRENT_TASKS: number = 1004;
  private static readonly COMMAND_PC_OPEN_PAGE_LIST: number = 1005;
  private static readonly DELAY_TIME: number = 30000;
  private static readonly SUPER_DEVICE_TOKEN = 'com.ohos.superdevice.SuperDeviceExtService';
  private object: SceneBoardServiceStub = new SceneBoardServiceStub('continuity');
  private proxy: rpc.IRemoteObject;
  private controller: PluginCardController = PluginCardController.getInstance();
  private taskId: number = 0;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  async subscribeShowInfo(): Promise<boolean> {
    if (this.proxy === null) {
      log.showError('proxy is null');
      return false;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    try {
      log.showInfo('subscribeShowInfo, write remote object');
      data.writeInterfaceToken(SuperDeviceExtServiceProxy.SUPER_DEVICE_TOKEN);
      data.writeRemoteObject(this.object);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      log.showError(`Rpc write remote object fail, errorCode:${e.code}, errorMessage:${e.message}`);
    }
    await this.proxy.sendMessageRequest(SuperDeviceExtServiceProxy.COMMAND_SUBSCRIBE_SHOW_INFO, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          log.showInfo('sendMessageRequest got result');
          let ret = result.reply.readBoolean();
          if (!ret) {
            log.showError('subscribe ShowInfo failed');
            return false;
          }
        } else {
          log.showError(`RPC: sendMessageRequest failed, errCode:${result.errCode}`);
          return false;
        }
        return true;
      })
      .catch((e: Error) => {
        log.showError(`RPC: sendMessageRequest failed, message:${e.message}`);
        return false;
      })
      .finally(() => {
        log.showInfo('RPC: sendMessageRequest ends, reclaim parcel');
        data.reclaim();
        reply.reclaim();
      });
    return true;
  }

  async unsubscribeShowInfo(): Promise<boolean> {
    if (this.proxy === null) {
      log.showError('proxy is null');
      return false;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(SuperDeviceExtServiceProxy.SUPER_DEVICE_TOKEN);
    data.writeRemoteObject(this.object);
    await this.proxy.sendMessageRequest(SuperDeviceExtServiceProxy.COMMAND_UNSUBSCRIBE_SHOW_INFO, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          log.showInfo('sendMessageRequest got result');
          let ret = result.reply.readBoolean();
          if (!ret) {
            log.showError('subscribe ShowInfo failed');
            return false;
          }
        } else {
          log.showError(`RPC: sendMessageRequest failed, errCode:${result.errCode}`);
          return false;
        }
        return true;
      })
      .catch((e: Error) => {
        log.showError(`RPC: sendMessageRequest failed, message:${e.message}`);
        return false;
      })
      .finally(() => {
        log.showInfo('RPC: sendMessageRequest ends, reclaim parcel');
        data.reclaim();
        reply.reclaim();
      });
    return true;
  }

  async startContinuity(showInfo: DeviceShowInfo, serviceName: string): Promise<boolean> {
    if (this.proxy === null) {
      log.showError('proxy is null');
      return false;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(SuperDeviceExtServiceProxy.SUPER_DEVICE_TOKEN);
    data.writeParcelable(showInfo);
    data.writeString(serviceName);
    await this.proxy.sendMessageRequest(SuperDeviceExtServiceProxy.COMMAND_START_CONTINUITY, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          log.showInfo('sendMessageRequest got result');
          let ret = result.reply.readBoolean();
          if (!ret) {
            log.showError('start continuity failed');
            return false;
          }
        } else {
          log.showError(`RPC: sendMessageRequest failed, errCode:${result.errCode}`);
          return false;
        }
        return true;
      })
      .catch((e: Error) => {
        log.showError(`RPC: sendMessageRequest failed, message:${e.message}`);
        return false;
      })
      .finally(() => {
        log.showInfo('RPC: sendMessageRequest ends, reclaim parcel');
        data.reclaim();
        reply.reclaim();
      });
    return true;
  }

  async stopContinuity(showInfo: DeviceShowInfo, serviceName: string): Promise<boolean> {
    if (this.proxy === null) {
      log.showError('proxy is null');
      return false;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(SuperDeviceExtServiceProxy.SUPER_DEVICE_TOKEN);
    data.writeParcelable(showInfo);
    data.writeString(serviceName);
    await this.proxy.sendMessageRequest(SuperDeviceExtServiceProxy.COMMAND_STOP_CONTINUITY, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          log.showInfo('sendMessageRequest got result');
          let ret = result.reply.readBoolean();
          if (!ret) {
            log.showError('stop continuity failed');
            return false;
          }
        } else {
          log.showError(`RPC: sendMessageRequest failed, errCode:${result.errCode}`);
          return false;
        }
        return true;
      })
      .catch((e: Error) => {
        log.showError(`RPC: sendMessageRequest failed, message:${e.message}`);
        return false;
      })
      .finally(() => {
        log.showInfo('RPC: sendMessageRequest ends, reclaim parcel');
        data.reclaim();
        reply.reclaim();
      });
    return true;
  }

  async openPageList(mWallpaperAvgColor: string, isLoginAccount: boolean, pivotX?: string,
    pivotY?: string): Promise<boolean> {
    if (this.proxy === null) {
      log.showError('proxy is null');
      return false;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(SuperDeviceExtServiceProxy.SUPER_DEVICE_TOKEN);
    data.writeString(mWallpaperAvgColor);
    data.writeBoolean(isLoginAccount);
    data.writeString(pivotX);
    data.writeString(pivotY);
    await this.proxy.sendMessageRequest(SuperDeviceExtServiceProxy.COMMAND_PC_OPEN_PAGE_LIST, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          log.showInfo('sendMessageRequest got result');
          let ret = result.reply.readBoolean();
          if (!ret) {
            log.showError('open page list failed');
            return false;
          }
        } else {
          log.showError(`RPC: sendMessageRequest failed, errCode:${result.errCode}`);
          return false;
        }
        return true;
      })
      .catch((e: Error) => {
        log.showError(`RPC: sendMessageRequest failed, message:${e.message}`);
        return false;
      })
      .finally(() => {
        log.showInfo('RPC: sendMessageRequest ends, reclaim parcel');
        data.reclaim();
        reply.reclaim();
      });
    return true;
  }

  async beAbleUnsubscribe(): Promise<boolean> {
    if (this.proxy === null) {
      log.showError('proxy is null');
      return false;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(SuperDeviceExtServiceProxy.SUPER_DEVICE_TOKEN);
    data.writeRemoteObject(this.object);
    await this.proxy.sendMessageRequest(SuperDeviceExtServiceProxy.COMMAND_QUERY_CURRENT_TASKS, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          log.showInfo('sendMessageRequest got result');
          let ret = result.reply.readBoolean();
          if (!ret) {
            log.showError('subscribe ShowInfo failed');
            this.setTimeOutRunningTask(ret);
          } else {
            this.setTimeOutRunningTask(ret);
          }
        } else {
          log.showError(`RPC: sendMessageRequest failed, errCode:${result.errCode}`);
          return false;
        }
        return true;
      })
      .catch((e: Error) => {
        log.showError(`RPC: sendMessageRequest failed, message:${e.message}`);
        return false;
      })
      .finally(() => {
        log.showInfo('RPC: sendMessageRequest ends, reclaim parcel');
        data.reclaim();
        reply.reclaim();
      });
    return true;
  }

  private setTimeOutRunningTask(result: boolean) {
    this.clearTimeOutRunningTask();
    log.info('setRunningTask');
    this.taskId = setTimeout(() => {
      result ? this.controller.release() : this.beAbleUnsubscribe()
      this.clearTimeOutRunningTask();
      SuperDeviceController.getInstance().setPageMode(PageMode.OTHER);
    }, SuperDeviceExtServiceProxy.DELAY_TIME)
  }

  public clearTimeOutRunningTask() {
    log.info('clearTimeOutRunningTask');
    clearTimeout(this.taskId);
  }
}