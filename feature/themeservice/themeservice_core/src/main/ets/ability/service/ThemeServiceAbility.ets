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

import Want from '@ohos.app.ability.Want';
import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import rpc from '@ohos.rpc';
import { createRemoteStub, TsLog } from '@ohos/themeservicebase/Index';
import { TSRemoteCallee } from '../../remote/callee/TSRemoteCallee';
import { TSInitializer } from '../../service/TSInitializer';

const TAG: string = 'ThemeServiceAbility';

export default class ThemeServiceAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    super.onCreate(want);
    TsLog.info(TAG, `onCreate...`);
    TSInitializer.init(this.context);
    TsLog.info(TAG, `onCreate.`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    return createRemoteStub(`ThemeRemoteServiceStub`, new TSRemoteCallee()) as rpc.RemoteObject;
  }
}


