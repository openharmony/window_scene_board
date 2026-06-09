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

import hilog from '@ohos.hilog';
import type TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let abilityDelegator = undefined;
let abilityDelegatorArguments = undefined;
let cmd = undefined;

async function onAbilityCreateCallback(): Promise<void> {
  hilog.info(0x0000, 'testTag', '%{public}s', 'onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err): Promise<void> {
  hilog.info(0x0000, 'testTag', 'addAbilityMonitorCallback : %{public}s', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner OnPrepare ');
  }

  onRun(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    const bundleName = abilityDelegatorArguments.bundleName;
    const testAbilityName = 'TestAbility';
    let lMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
    cmd = `aa start -d 0 -a ${testAbilityName} -b ${bundleName}`;
    if (abilityDelegatorArguments.parameters['-D'] === 'true') {
      cmd += ' -D';
    }
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner tryStartTestAbility');
    this.tryStartTestAbility(5, 10000);
  }

  async tryStartTestAbility(tryTimes: number, intervals: number): Promise<void> {
    let remainTimes = tryTimes - 1;
    if (remainTimes < 0) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner tryStartTestAbility failed');
      return;
    }
    setTimeout(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', `OpenHarmonyTestRunner tryStartTestAbility, remainTimes:${remainTimes}`);
      abilityDelegator.executeShellCommand(cmd, (err, data) => {
        if (data === null || data === undefined || !data) {
          hilog.info(0x0000, 'testTag', 'startAbility : err : %{public}s', JSON.stringify(err) ?? '');
          this.tryStartTestAbility(remainTimes, intervals);
          return;
        }
        let message: string = JSON.stringify(data) ?? '';
        hilog.info(0x0000, 'testTag', 'startAbility : message : %{public}s', message);
        if (message.includes('error')) {
          this.tryStartTestAbility(remainTimes, intervals);
        }
      });
      hilog.info(0x0000, 'testTag', '%{public}s', `OpenHarmonyTestRunner tryStartTestAbility end, remainTimes:${remainTimes}`);
    }, intervals);
  }
}