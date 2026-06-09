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
import type abilityCommon from '@ohos.app.ability.common';
import { rpc } from '@kit.IPCKit';
import common from '@ohos.app.ability.common';
import { bundleManager, Want } from '@kit.AbilityKit';
import { BusinessError, Callback, osAccount } from '@kit.BasicServicesKit';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { OnAcquireInfo } from '../ScreenLockVerifyService';

const TAG = 'SLAutoTestService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const ACCESS_TOCKEN: string = 'connect';
const DEFAULT_DEBUG_TEST_STATUS: number = 0;
const AUTH_SWITCH_ID = 8;
const WANT: Want = {
  deviceId: '',
  bundleName: 'com.example.fakeaccountsmodel',
  abilityName: 'accountserviceability'
};

interface AuthSwitchInfo {
  isSwitchOpen,
}

function shouldExecute(): boolean {
  return !!parseInt(systemParameterEnhance.getSync('screenlock.fakeAccounts.service.test',
        DEFAULT_DEBUG_TEST_STATUS.toString()));
}

export class SLAutoTestService {
  private context?: abilityCommon.ServiceExtensionContext;
  private remote?: rpc.IRemoteObject;
  private _isAlive: boolean = false;
  private connectId: number | undefined = 0;
  private static sInstance: SLAutoTestService;

  public static getInstance(): SLAutoTestService {
    if (SLAutoTestService.sInstance == null) {
      SLAutoTestService.sInstance = new SLAutoTestService();
    }
    return SLAutoTestService.sInstance;
  }

  /**
   * 启动Fake账号服务
   *
   * @returns 是否成功
   */
  public startService(): boolean {
    if (!shouldExecute()) {
      return false;
    }
    this.context = GlobalContext.getContext();
    this.context?.startServiceExtensionAbility(WANT).then(() => {
      log.showInfo('Succeeded start ServiceExtensionAbility');
      this._isAlive = true;
    }).catch((err: BusinessError) => {
      log.showError(`Failed to start ServiceExtensionAbility. Code is ${err.code}, message is ${err.message}`);
    });
    return false;
  }

  /**
   * 终止Fake账号服务
   *
   * @returns 是否成功
   */
  public stopService(): boolean {
    if (!shouldExecute()) {
      return false;
    }
    this.context = GlobalContext.getContext();
    this.context?.stopServiceExtensionAbility(WANT).then(() => {
      log.showInfo('Succeeded stop ServiceExtensionAbility');
      this._isAlive = false;
    }).catch((err: BusinessError) => {
      log.showError(`Failed to Stop ServiceExtensionAbility. Code is ${err.code}, message is ${err.message}`);
    });
    return false;
  }

  /**
   * 判断当前服务是否激活
   *
   * @returns 是否激活
   */
  public get isAlive(): boolean {
    return this._isAlive;
  }

  public get isSwitchAbilityOpen(): boolean {
    return !!parseInt(systemParameterEnhance.getSync('screenlock.fakeAccounts.service.authSwitch',
      DEFAULT_DEBUG_TEST_STATUS.toString()));
  }

  /**
   * 连接Fake账号服务
   *
   * @returns 是否成功
   */
  public connectService(): boolean {
    if (!shouldExecute()) {
      return false;
    }
    try {
      this.connectId = this.context?.connectServiceExtensionAbility(WANT, this.setConnect());
      log.showInfo('Succeeded in connect ServiceExtensionAbility.');
      return !!this.connectId;
    } catch (err) {
      log.showError(`connect fail code: ${err.code} message: ${err.message}`);
    }
    return false;
  }

  async sendMessage<T>(authType: number, otherData: T,
    execCallback: Callback<OnAcquireInfo | Array<number>>): Promise<OnAcquireInfo | Array<number> | undefined> {
    if (!shouldExecute()) {
      return undefined;
    }
    if (!this.remote) {
      log.showError('sendUnlock has no remote');
      return undefined;
    }

    let data: rpc.MessageSequence = rpc.MessageSequence.create();
    let reply: rpc.MessageSequence = rpc.MessageSequence.create();
    this.setToken(data);
    this.setData(data, otherData);
    let finalResult: OnAcquireInfo | Array<number>;
    try {
      let result = await this.remote.sendMessageRequest(authType, data, reply, new rpc.MessageOption());
      finalResult = this.getAcquireInfo(authType, result.reply);
      if (execCallback) {
        if (authType === AUTH_SWITCH_ID) {
          execCallback(finalResult as Array<number>);
        } else {
          execCallback(finalResult as OnAcquireInfo);
        }
      }
      log.showDebug(`sendUnlock result: ${JSON.stringify(finalResult)}`);
    } catch (error) {
      log.showError(`send message failed: ${JSON.stringify(error)} and ${error.message}`);
      return undefined;
    }
    data.reclaim();
    reply.reclaim();
    return finalResult;
  }

  private getAcquireInfo(authType: number, reply: rpc.MessageSequence): OnAcquireInfo | Array<number> {
    if (authType === AUTH_SWITCH_ID) {
      return reply.readIntArray();
    } else {
      return {
        authType: reply.readInt(),
        moduleId: reply.readInt(),
        acquire: reply.readInt(),
        extraInfo: new Uint8Array(reply.readIntArray()),
      };
    }

  }

  /**
   * 为服务设置发送的数据
   *
   * @param data
   */
  public setData<T>(data: rpc.MessageSequence, otherData: T): void {
    if (!data) {
      log.showError('setData has no data');
      return;
    }
    switch (typeof otherData) {
      case 'string':
        data.writeString(otherData);
        break;
      case 'number':
        data.writeInt(otherData);
        break;
      case 'boolean':
        data.writeBoolean(otherData);
        break;
      default:
        log.showWarn('Input parameters of a non-specified type');
    }
  }

  /**
   * 断联Fake账号服务
   *
   * @returns 是否成功
   */
  public disconnectService(): boolean {
    if (!shouldExecute()) {
      return false;
    }
    try {
      if (!this.connectId) {
        return false;
      }
      this.context?.disconnectServiceExtensionAbility(this.connectId);
      this.connectId = 0;
      return true;
    } catch (err) {
      log.showError(`disconnect fail code: ${err.code} message: ${err.message}`);
    }
    return false;
  }

  /**
   * 配置连接回调
   *
   */
  private setConnect(): common.ConnectOptions {
    return {
      onConnect: (elementName: bundleManager.ElementName, remote: rpc.IRemoteObject): void => {
        log.showInfo('fake accountsModel connect');
        this.remote = remote;
      },
      onDisconnect: (elementName: bundleManager.ElementName): void => {
        log.showInfo('fake accountsModel disconnect');
      },
      onFailed: (code: number): void => {
        log.showError(`fake accountsModel connect fail errorCode = ${code}`);
      }
    };
  }

  private setToken(data: rpc.MessageSequence): void {
    if (data != null) {
      data.writeInterfaceToken(ACCESS_TOCKEN);
    } else {
      log.showError('data is null');
    }
  }
}