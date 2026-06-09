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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { BaseServiceStub, IService} from '@ohos/componenthelper';

const TAG = 'ScreenLockExtensionService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 皮套对应用提供的服务，处理加载业务
 *
 * @since 2024-09-15
 */
export default class ScreenLockExtensionService extends ServiceExtensionAbility {
  private readonly screenLockProviderService = new ScreenLockExtensionServiceStub(TAG);

  onCreate(want: Want): void {
    log.showInfo(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want, startId: number): void {
    log.showInfo(TAG, `onRequest, want: ${want.abilityName}, startId: ${startId}`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.showInfo(TAG, `onConnect, want: ${want.abilityName} ${want.bundleName}`);
    return this.screenLockProviderService;
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
export class ScreenLockExtensionServiceStub extends BaseServiceStub {
  protected getTag(): string {
    return TAG;
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map();
  }
}

/**
 * 请求码枚举
 */
export const enum RequestCode {
  /**
   * 闹钟
   */
  EXT_ALARM_CLOCK = 1,
  /**
   * 通话
   */
  EXT_PHONE = 2,
  /**
   * 畅联
   */
  EXT_LINK = 3,
  /**
   * 分布式解锁
   */
  DISTRIBUTED_LOCK = 4,
}