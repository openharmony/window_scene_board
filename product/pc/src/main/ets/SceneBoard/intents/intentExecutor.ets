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

import InsightIntentExecutor from '@ohos.app.ability.InsightIntentExecutor';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import insightIntent from '@ohos.app.ability.insightIntent';
import { IntentVM } from '@ohos/pcbase/src/main/ets/SceneBoard/intents/vm/intentVM';

const TAG: string = 'IntentExecutor';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export default class IntentExecutor extends InsightIntentExecutor {
  private static readonly REBOOT_INTENT: string = 'Rebooting';
  private static readonly LOCK_SCREEN_INTENT: string = 'LockScreen';
  private static readonly SHUTDOWN_INTENT: string = 'Shutdown';
  private static readonly SLEEP_INTENT: string = 'ComputerHibernation';
  private static readonly DEACTIVATE_ACCOUNT_INTENT: string = 'DeactivateAccountIntent';
  private static readonly SWITCH_STATUS_BAR_INTENT: string = 'SwitchStatusBarIntent';


  async onExecuteInServiceExtensionAbility(
    intentName: string,
    intentParam: Record<string, Object>): Promise<insightIntent.ExecuteResult> {
    log.showInfo('intentName is ' + intentName);
    return new Promise((resolve) => {
      switch (intentName) {
        case IntentExecutor.REBOOT_INTENT:
          IntentVM.reboot().then((result) => {
            resolve(result);
          })
          break;
        case IntentExecutor.LOCK_SCREEN_INTENT:
          IntentVM.lockScreen().then((result) => {
            resolve(result);
          })
          break;
        case IntentExecutor.SHUTDOWN_INTENT:
          IntentVM.shutdown().then((result) => {
            resolve(result);
          })
          break;
        case IntentExecutor.SLEEP_INTENT:
          IntentVM.sleep().then((result) => {
            resolve(result);
          })
          break;
        case IntentExecutor.DEACTIVATE_ACCOUNT_INTENT:
          IntentVM.deactivateOsAccount().then((result) => {
            resolve(result);
          })
          break;
        case IntentExecutor.SWITCH_STATUS_BAR_INTENT:
          IntentVM.switchStatusBar().then((result) => {
            resolve(result);
          })
          break;
        default:
          break;
      }
    });
  }
}