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

import type TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'TestAbility');
let abilityDelegator = undefined;
let abilityDelegatorArguments = undefined;
let cmd = undefined;
const global: object = new Function("return this")();

async function onAbilityCreateCallback(): Promise<void> {
  log.info('onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err): Promise<void> {
  log.info('addAbilityMonitorCallback: ', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare(): void {
    log.info('OpenHarmonyTestRunner OnPrepare ');
  }

  async onRun(): Promise<void> {

    log.info('OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    const bundleName = abilityDelegatorArguments.bundleName;
    const testAbilityName = 'NotificationComponentTestAbility';
    let lMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
    cmd = `aa start -d 0 -a ${testAbilityName} -b ${bundleName}`;
    if (abilityDelegatorArguments.parameters['-D'] === 'true') {
      cmd += ' -D';
    }
    log.info('OpenHarmonyTestRunner tryStartTestAbility');

    const savePath: string = '__savePath__';
    const readPath: string = '__readPath__';
    const testMode: string = '__testMode__';
    let uid: number = Math.floor(abilityDelegator.getAppContext().applicationInfo.uid / 200000);
    global[savePath] = '/data/storage/el2/base/js_coverage.json';
    global[readPath] = '/data/app/el2/' + uid + '/base/' + bundleName + '/js_coverage.json';
    global[testMode] = 'ohostest';

    this.tryStartTestAbility(5, 10000);
  }

  async tryStartTestAbility(tryTimes: number, intervals: number): Promise<void> {
    let remainTimes = tryTimes - 1;
    if (remainTimes < 0) {
      log.info('OpenHarmonyTestRunner tryStartTestAbility failed');
      return;
    }
    log.info(`OpenHarmonyTestRunner tryStartTestAbility, remainTimes:${remainTimes}`);
    await abilityDelegator.executeShellCommand(cmd, (err, data) => {
      if (data === null || data === undefined || !data) {
        log.info(0x0000, 'testTag', 'startAbility : err ', err);
        this.tryStartTestAbility(remainTimes, intervals);
        return;
      }
      let message: string = JSON.stringify(data) ?? '';
      log.info(0x0000, 'testTag', 'startAbility : message : %{public}s', message);
      if (message.includes('error')) {
        this.tryStartTestAbility(remainTimes, intervals);
      }
    });
    log.info(`OpenHarmonyTestRunner tryStartTestAbility end, remainTimes:${remainTimes}`);
  }
}