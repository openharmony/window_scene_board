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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';

const TAG = 'IntentServiceExtAbilityProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default class IntentServiceExtAbilityProxy {
  private static mInstance: IntentServiceExtAbilityProxy;

  public static getInstance(): IntentServiceExtAbilityProxy {
    if (!IntentServiceExtAbilityProxy.mInstance) {
      IntentServiceExtAbilityProxy.mInstance = new IntentServiceExtAbilityProxy();
    }
    return IntentServiceExtAbilityProxy.mInstance;
  }

  onCreate(want: Want) {
    log.showInfo('IntentServiceExtAbility onCreate');
  }

  onDestroy() {
    log.showInfo('IntentServiceExtAbility onDestroy');
  }
}