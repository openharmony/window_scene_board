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

import { UIAbility } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityDelegatorRegistry, TestRunner } from '@kit.TestKit';
import { TsLog } from '@ohos/themeservicebase/Index';

let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
let abilityDelegatorArguments: abilityDelegatorRegistry.AbilityDelegatorArgs;
const TAG: string = 'testTag';

async function onAbilityCreateCallback(data: UIAbility) {
  TsLog.info(TAG, 'onAbilityCreateCallback, data: ${}', JSON.stringify(data));
}

async function addAbilityMonitorCallback(err: BusinessError) {
  TsLog.info(TAG, 'addAbilityMonitorCallback : %{public}s', JSON.stringify(err) ?? '');
}

const CMD_LIST: string[] = ['param set persist.scb.testmode.enable true',
  'power-shell wakeup',
  'uinput -T -d 300 600 -m 300 600 300 100 -u 300 100',
  'power-shell timeout -o 600000'];

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare() {
    TsLog.info(TAG, '%{public}s', 'OpenHarmonyTestRunner OnPrepare');
  }

  async onRun() {
    TsLog.info(TAG, '%{public}s', 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();
    TsLog.debug(TAG, `abilityDelegatorArguments = ${JSON.stringify(abilityDelegatorArguments)}`);
    abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
    let moduleName: string = abilityDelegatorArguments.parameters['-m'];
    let context = abilityDelegator.getAppContext().getApplicationContext().createModuleContext(moduleName);

    const testAbilityName: string = 'TestAbility';
    let lMonitor: abilityDelegatorRegistry.AbilityMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
      moduleName: moduleName
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);

    await this.executeShellCommand(CMD_LIST);

    let cmd: string = `aa start -d 0 -a ${testAbilityName} -b ${abilityDelegatorArguments.bundleName}`;
    if (abilityDelegatorArguments.parameters['-D'] === 'true') {
      cmd += ' -D';
    }
    TsLog.info(TAG, '%{public}s', 'OpenHarmonyTestRunner tryStartTestAbility');
    this.tryStartTestAbility(cmd, 5, 3000);
  }

  private async executeShellCommand(cmds: string[]): Promise<void> {
    for (const cmd of cmds) {
      let cmdResult: abilityDelegatorRegistry.ShellCmdResult = await abilityDelegator.executeShellCommand(cmd, 15000);
      TsLog.debug(TAG, `${cmd} -> ${JSON.stringify(cmdResult)}`);
    }
  }

  async tryStartTestAbility(cmd: string, tryTimes: number, intervals: number): Promise<void> {
    let remainTimes: number = tryTimes - 1;
    if (remainTimes < 0) {
      TsLog.info(TAG, '%{public}s', 'OpenHarmonyTestRunner tryStartTestAbility failed');
      return;
    }
    setTimeout(() => {
      TsLog.info(TAG, '%{public}s', `OpenHarmonyTestRunner tryStartTestAbility, remainTimes:${remainTimes}`);
      abilityDelegator.executeShellCommand(cmd, (err, data) => {
        if (data === null || data === undefined || !data) {
          TsLog.info(TAG, 'testTag', 'startAbility : err : %{public}s', JSON.stringify(err) ?? '');
          this.tryStartTestAbility(cmd, remainTimes, intervals);
          return;
        }
        let message: string = JSON.stringify(data) ?? '';
        TsLog.info(TAG, 'startAbility : message : %{public}s', message);
        if (message.includes('error')) {
          this.tryStartTestAbility(cmd, remainTimes, intervals);
        }
      });
      TsLog.info(TAG, '%{public}s', `OpenHarmonyTestRunner tryStartTestAbility end, remainTimes:${remainTimes}`);
    }, intervals);
  }
}
