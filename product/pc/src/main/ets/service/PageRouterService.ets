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
import type Want from '@ohos.app.ability.Want';
import type rpc from '@ohos.rpc';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PageRouterServiceProxy } from '@ohos/form/src/main/ets/default/service/PageRouterServiceProxy';

const TAG = 'PageRouterService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

class PcPageRouterServiceProxy extends PageRouterServiceProxy {
  protected isFormEditEnabled(): boolean {
    return true;
  }
}

export default class PageRouterService extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    PcPageRouterServiceProxy.getInstance().onCreate(want);
  }

  onRequest(want: Want, startId: number): void {
    PcPageRouterServiceProxy.getInstance().onRequest(want, startId);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    return PcPageRouterServiceProxy.getInstance().onConnect(want);
  }

  onDisconnect(want: Want): void | Promise<void> {
    return PcPageRouterServiceProxy.getInstance().onDisconnect(want);
  }

  onDestroy(): void {
    PcPageRouterServiceProxy.getInstance().onDestroy();
  }
}