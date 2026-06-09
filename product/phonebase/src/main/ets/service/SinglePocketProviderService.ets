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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IService, BaseServiceStub } from '@ohos/componenthelper'
import lazy { OuterHomeManagerUtil } from '../SceneBoard/screenlock/utils/OuterHomeManagerUtil';
import lazy { SinglePocketService } from './singlepocket/SinglePocketService';

const TAG = 'SinglePocketProviderService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * SceneBoard对扩展小折叠折叠到外屏接续使能接口
 *
 * @since 2024-12-02
 */
export default class SinglePocketProviderService extends ServiceExtensionAbility {
  private readonly singlePocketProviderService = new SinglePocketProviderServiceStub(TAG);

  onCreate(want: Want): void {
    log.showInfo(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want, startId: number): void {
    log.showInfo(TAG, `onRequest, want: ${want.abilityName}, startId: ${startId}`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.showInfo(TAG, `onConnect, want: ${want.abilityName} ${want.bundleName}`);
    return this.singlePocketProviderService;
  }

  onDisconnect(want: Want): void | Promise<void> {
    // service断连后外屏会置为上锁
    OuterHomeManagerUtil.getInstance().setAppSwitchContinuation(false);
    log.showInfo(TAG, `onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy(): void {
    log.showInfo(TAG, 'onDestroy');
  }
}

/**
 * SceneBoard对外提供服务映射，一个请求码对应一个对外服务
 */
export class SinglePocketProviderServiceStub extends BaseServiceStub {
  protected getTag(): string {
    return TAG;
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [RequestCode.SINGLE_POCKET, (): IService => new SinglePocketService()],
    ]);
  }
}

/**
 * 请求码枚举
 */
export const enum RequestCode {
  /**
   * 扩展新形态小外屏折叠接续码
   */
  SINGLE_POCKET = 1,
}