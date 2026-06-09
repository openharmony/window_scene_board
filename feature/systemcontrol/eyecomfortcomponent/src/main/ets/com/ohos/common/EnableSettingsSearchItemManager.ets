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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { rpc } from '@kit.IPCKit';
import type abilityCommon from '@ohos.app.ability.common';
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'Ctrl.EnableSettingsSearchItemManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SETTINGS_ENABLE_SEARCH_ITEMS = 2;

interface ISearchItems {
  itemList: string[];
}

export class EnableSettingsSearchItemManager {
  private readonly SETTINGS_EXTENSION_ABILITY: string = 'SettingsExtService';
  private readonly SETTINGS_BUNDLE_NAME: string = 'com.ohos.settings';
  private static instance: EnableSettingsSearchItemManager | null = null;
  private context: abilityCommon.ServiceExtensionContext | null = null;
  private proxy: rpc.IRemoteObject | null = null;
  private connectionId: number | undefined = -1;
  private want: Want = {
    bundleName: this.SETTINGS_BUNDLE_NAME,
    abilityName: this.SETTINGS_EXTENSION_ABILITY,
  };

  private constructor() {
    this.context = GlobalContext.getContext();
  }

  /**
   * 获取EnableSettingsSearchItemManager实例
   *
   * @returns EnableSettingsSearchItemManager实例
   */
  public static getInstance(): EnableSettingsSearchItemManager {
    if (EnableSettingsSearchItemManager.instance === null) {
      EnableSettingsSearchItemManager.instance = new EnableSettingsSearchItemManager();
    }
    return EnableSettingsSearchItemManager.instance;
  }

  /**
   * 建立连接
   *
   * @returns true：成功, false：失败
   */
  private connectServiceExtensionAbility(): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      if (CheckEmptyUtils.isEmpty(this.context)) {
        log.showError('the context is null');
        resolve(false);
        return;
      }
      if (this.proxy !== null) {
        log.showError('already connect');
        resolve(true);
        return;
      }
      try {
        this.connectionId = this.context?.connectServiceExtensionAbility(this.want, {
          onConnect: (elementName: bundleManager.ElementName, remote: rpc.IRemoteObject) => {
            log.showInfo('onConnect... name: %{public}s', elementName.bundleName);
            this.proxy = remote;
            resolve(true);
          },
          onDisconnect: (elementName: bundleManager.ElementName) => {
            log.showError('onDisconnect... name: %{public}s', elementName.bundleName);
            this.proxy = null;
            resolve(false);
          },
          onFailed: (code: number) => {
            log.showError('onFailed... code: %{public}d', code);
            resolve(false);
          }
        });
      } catch (error) {
        log.showError('connect AppFoundationServiceExtension exception %{public}s', error?.message);
        reject(false);
      }
    });
  }

  /**
   * 断开连接
   */
  private disconnectServiceExtensionAbility(): void {
    log.showInfo('disconnectServiceExtensionAbility, connectId = %{public}d', this.connectionId);
    if (CheckEmptyUtils.isEmpty(this.context) || this.proxy === null) {
      log.showError('the context is null or already disconnect');
      return;
    }
    try {
      this.context?.disconnectServiceExtensionAbility(this.connectionId);
      // 断连时释放资源
      this.proxy = null;
    } catch (error) {
      log.showError('disconnect AppFoundationServiceExtension exception %{public}s', error?.message);
    }
  }

  private async sendEnableRequest(enableKey: string, isEnable: boolean): Promise<void> {
    // 如果proxy为空，则建联失败
    if (this.proxy === null || this.proxy === undefined) {
      log.showError('connectServiceExtensionAbility failed');
      return;
    }
    let option: rpc.MessageOption = new rpc.MessageOption();
    let data: rpc.MessageSequence = new rpc.MessageSequence();
    let reply: rpc.MessageSequence = new rpc.MessageSequence();
    try {
      const itemList: string[] = [enableKey];
      const searchItems: ISearchItems = { itemList };
      const method: string = isEnable ? 'enableSearchItems' : 'disableSearchItems';
      data.writeString(JSON.stringify({method, extra: searchItems}));
      await this.proxy.sendMessageRequest(SETTINGS_ENABLE_SEARCH_ITEMS, data, reply, option)
        .then((result: rpc.RequestResult) => {
        if (result.errCode !== 0) {
          log.showError('sendMessageRequest failed: %{public}d', result.errCode);
          return;
        }
        log.showInfo(`sendMessageRequest success reply=${JSON.stringify(reply)}`);
      }).catch((error: BusinessError) => {
        log.showError('sendMessageRequest error. %{public}d', error.code);
      });
    } catch (error) {
      log.showError(`sendMessageRequest exception. error:${error} stack： ${error?.stack}`);
    } finally {
      data.reclaim();
      reply.reclaim();
    }
  }


  /**
   * Enable设置搜索项
   *
   * @param packageList 包名列表
   * @param context 上下文
   */
  public async enableSettingsSearchItem(enableKey: string, isEnable: boolean): Promise<void> {
    if (this.context === null || CheckEmptyUtils.isEmpty(enableKey)) {
      log.showError('enableKey or context is null');
      return;
    }
    log.showInfo(`start enableSettingsSearchItem enableKey=${enableKey} isEnable=${isEnable}`);
    let result: boolean = await this.connectServiceExtensionAbility();
    log.showInfo('connect result = %{public}s', result);

    // 建联失败，直接返回
    if (!result) {
      log.showError('connect SettingsServiceExtension failed');
      return;
    }
    // 使能接口
    this.sendEnableRequest(enableKey, isEnable);

    // 断开连接
    this.disconnectServiceExtensionAbility();
  }
}
