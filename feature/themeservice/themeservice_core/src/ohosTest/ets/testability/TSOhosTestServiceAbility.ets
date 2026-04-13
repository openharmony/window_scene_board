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

import { rpc } from '@kit.IPCKit';
import Want from '@ohos.app.ability.Want';
import { createRemoteStub, TsLog } from '@ohos/themeservicebase/Index';
import ThemeServiceAbility from '../../../main/ets/ability/service/ThemeServiceAbility';
import { TSOhosTestRemoteCallee } from './TSOhosTestRemoteCallee';


const TAG: string = 'TSOhosTestServiceAbility';

export default class TSOhosTestServiceAbility extends ThemeServiceAbility {
  onCreate(want: Want): void {
    TsLog.info(TAG, `onCreate...`);
    super.onCreate(want);
    TsLog.info(TAG, `onCreate.`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    return createRemoteStub(`OhosTestThemeRemoteServiceStub`, new TSOhosTestRemoteCallee()) as rpc.RemoteObject;
  }
}


