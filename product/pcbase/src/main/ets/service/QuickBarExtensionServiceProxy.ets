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


import rpc from '@ohos.rpc';
import Want from '@ohos.app.ability.Want';
import { LogDomain, Logger } from '@ohos/basicutils';
import { createQuickBarStub } from '@ohos/pcsmartdock';

const TAG = 'QuickBarExtensionServiceProxy ';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export default class QuickBarExtensionServiceProxy {
  private static mInstance: QuickBarExtensionServiceProxy;

  public static getInstance(): QuickBarExtensionServiceProxy {
    if (!QuickBarExtensionServiceProxy.mInstance) {
      QuickBarExtensionServiceProxy.mInstance = new QuickBarExtensionServiceProxy();
    }
    return QuickBarExtensionServiceProxy.mInstance;
  }

  onCreate(want: Want) {
    log.showInfo(TAG, 'QuickBarServiceExtAbility onCreate new');
  }

  onRequest(want: Want, startId: number) {
    log.showInfo(TAG, 'QuickBarServiceExtAbility onRequest');
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.showInfo(TAG, 'QuickBarServiceExtAbility onConnect');
    return createQuickBarStub('PCQuickBar');
  }

  onDisconnect(want: Want) {
    log.showInfo(TAG, 'QuickBarServiceExtAbility onDisconnect');
  }

  onDestroy() {
    log.info(TAG, 'QuickBarServiceExtAbility onDestroy');
  }
}