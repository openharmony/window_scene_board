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

import common from '@ohos.app.ability.common';
import rpc from '@ohos.rpc';
import Want from '@ohos.app.ability.Want';
import bundleManager from '@ohos.bundle.bundleManager';
import IdlOuterHomeServiceProxy from './IdlOuterHomeServiceProxy';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'OuterHomeRemoteService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class OuterHomeRemoteService {
  private remoteObj: rpc.IRemoteObject | null = null;
  private proxy: IdlOuterHomeServiceProxy | null = null;
  private connectionCode: number | undefined;
  private context: common.UIAbilityContext | null = null;

  public constructor(context: Context) {
    this.context = context as common.UIAbilityContext;
  }

  /**
   * 获取服务代理
   *
   * @returns 服务代理
   */
  public async getProxy(): Promise<IdlOuterHomeServiceProxy> {
    const want: Want = {
      bundleName: 'com.ohos.outerhome',
      abilityName: 'CoverHomeProviderAbility'
    };
    return new Promise((resolve, reject) => {
      if (!this.context) {
        log.showError('getProxyInner, context is empty');
        let error: Record<string, string | number> = {
          'message': 'context is empty'
        };
        return reject(error);
      }
      this.connectionCode = this.context?.connectServiceExtensionAbility(want, {
        onConnect: (elementName: bundleManager.ElementName, remote: rpc.IRemoteObject): void => {
          log.showInfo(`getProxy, onConnect connectionCode:${this.connectionCode}`);
          this.remoteObj = remote;
          this.proxy = new IdlOuterHomeServiceProxy(remote);
          resolve(this.proxy);
        },
        onDisconnect: (elementName: bundleManager.ElementName): void => {
          log.showInfo(`getProxy, onDisconnect connectionCode:${this.connectionCode}`);
          this.clean();
        },
        onFailed: (code: number): void => {
          log.showError('getProxy, onFailed');
          this.clean();
          let error: Record<string, string | number> = {
            'code': code,
            'message': 'getProxy failed'
          };
          reject(error);
        }
      });
    });
  }

  private clean(): void {
    this.remoteObj = null;
    this.proxy = null;
  }

  /**
   * 断连服务
   */
  public disConnect(): void {
    if (!this.context) {
      log.showError('disConnect, context is empty');
      return;
    }
    this.context.disconnectServiceExtensionAbility(this.connectionCode as number);
  }
}