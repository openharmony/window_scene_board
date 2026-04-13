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
import rpc from '@ohos.rpc';
import Want from '@ohos.app.ability.Want';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { createStatusBarStub } from '@ohos/statusbarextensionservice';

const TAG = 'StatusBarServiceExtensionAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default class StatusBarExtensionService extends ServiceExtensionAbility {
  onCreate(want: Want) {
    log.showInfo('StatusbarServiceExtAbility onCreate new');
  }

  onRequest(want: Want, startId: number) {
    log.showInfo('StatusbarServiceExtAbility onRequest');
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.showInfo('StatusbarServiceExtAbility onConnect');
    return createStatusBarStub('StatusBar');
  }

  onDisconnect(want: Want) {
    log.showInfo('StatusbarServiceExtAbility onDisconnect');
  }

  onDestroy() {
    log.info('StatusbarServiceExtAbility onDestroy');
  }
}