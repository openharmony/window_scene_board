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
import type Want from '@ohos.app.ability.Want';
import type rpc from '@ohos.rpc';
import DesktopProviderServiceProxy from '@ohos/pcbase/src/main/ets/service/DesktopProviderServiceProxy';

/**
 * 桌面对外提供服务
 *
 * @since 2024-03-11
 */
export default class DesktopProviderService extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    DesktopProviderServiceProxy.getInstance().onCreate(want);
  }

  onRequest(want: Want, startId: number): void {
    DesktopProviderServiceProxy.getInstance().onRequest(want, startId);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    return DesktopProviderServiceProxy.getInstance().onConnect(want);
  }

  onDisconnect(want: Want): void | Promise<void> {
    DesktopProviderServiceProxy.getInstance().onDisconnect(want);
  }

  onDestroy(): void {
    DesktopProviderServiceProxy.getInstance().onDestroy();
  }
}
