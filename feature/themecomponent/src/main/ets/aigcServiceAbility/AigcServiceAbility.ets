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
import rpc from '@ohos.rpc'
import { AigcConstant } from './AigcConstant';
import IdlAigcServiceImpl from './IdlService/IdlAigcServiceStubImpl';
import { Log } from './IdlService/Log';

const TAG: string = '[AigcService]AigcServiceAbility';

export default class AigcServiceAbility extends ServiceExtensionAbility {

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    Log.info(TAG, 'onConnect, success');
    return new IdlAigcServiceImpl(AigcConstant.INTERFACE_TOKEN, this.context);
  }

  onCreate(want: Want): void {
    Log.info(TAG, 'onCreate');
  }

  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
  }

  onRequest(want: Want, startId: number): void {
    Log.info(TAG, 'onRequest');
  }

  onDisconnect(want: Want): void | Promise<void> {
    Log.info(TAG, 'onDisconnect');
  }
}