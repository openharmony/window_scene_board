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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IService, BaseServiceStub } from '@ohos/componenthelper'
import { ExtHomeService } from './exthome/ExtHomeService';

const TAG = 'ExtHomeProviderService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * Sceneboard对第二个home提供服务
 *
 * @since 2024-03-24
 */
export default class ExtHomeProviderService extends ServiceExtensionAbility {
  private readonly extHomeProviderService = new ExtHomeProviderServiceStub(TAG);

  onCreate(want: Want): void {
    log.showInfo(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want, startId: number): void {
    log.showInfo(TAG, `onRequest, want: ${want.abilityName}, startId: ${startId}`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.showInfo(TAG, `onConnect, want: ${want.abilityName} ${want.bundleName}`);
    return this.extHomeProviderService;
  }

  onDisconnect(want: Want): void | Promise<void> {
    log.showInfo(TAG, `onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy(): void {
    log.showInfo(TAG, 'onDestroy');
  }
}

/**
 * Sceneboard对外提供服务映射，一个请求码对应一个对外服务
 */
export class ExtHomeProviderServiceStub extends BaseServiceStub {
  protected getTag(): string {
    return TAG;
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [RequestCode.EXT_HOME, (): IService => new ExtHomeService()],
    ]);
  }
}

/**
 * 请求码枚举
 */
export const enum RequestCode {
  /**
   * 第二个Home应用
   */
  EXT_HOME = 1,
}