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
import { describe, expect, it, Level, TestType } from '@ohos/hypium';
import { TARGET_LOCK, TConfigArg } from '@ohos/themeservicekit';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { ActivateThemeGetter } from '../../../core/util/ActivateThemeGetter';
import { AssertUtils } from '../../../core/util/AssertUtils';


export default function SetCurrentThemeCfgTest() {
  describe('SetCurrentThemeCfgTest', () => {
    it('test001_Activated', 0, async () => {
      const lockConfigArgs: TConfigArg = {
        target: TARGET_LOCK,
        qualifier: 'base',
        fileName: 'lock_config.json',
        value: 'lockConfig:{postion:1}'
      };
      const homeConfigArgs: TConfigArg = {
        target: 'home',
        qualifier: 'base',
        fileName: 'lock_config.json',
        value: 'homeConfig:{postion:1}'
      };
      let success: boolean = await TSOhosTestManger.getTsKitRemoteApi()
        .setCurrentThemeCfg([lockConfigArgs, homeConfigArgs]);
      expect(success).assertTrue();
      expect(await getActiveHomeCfg()).assertEqual(homeConfigArgs.value);
      expect(await getActiveLockCfg()).assertEqual(lockConfigArgs.value);
    })

    it('test002_Not_Activated', 0, async () => {
      const lockConfigArgs: TConfigArg = {
        target: TARGET_LOCK,
        qualifier: 'base',
        fileName: 'config.json',
        value: 'Config:{postion:2}'
      };
      let success: boolean = await TSOhosTestManger.getTsKitRemoteApi()
        .setCurrentThemeCfg([lockConfigArgs], false);
      expect(success).assertTrue();
      expect(await getActiveLockCfg()).not().assertEqual(lockConfigArgs.value);
    })

    it('test_003_setCurrentThemeCfg_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      await testSetCurrentThemeCfg();
    })
  })
}

async function testSetCurrentThemeCfg(): Promise<void> {
  const lockConfigArgs: TConfigArg = {
    target: TARGET_LOCK,
    qualifier: 'base',
    fileName: 'config.json',
    value: 'Config:{postion:2}'
  };
  await AssertUtils.expectParallelInvokeBoolean(() => TSOhosTestManger.getTsKitRemoteApi()
    .setCurrentThemeCfg([lockConfigArgs], false), true);
}

function getActiveHomeCfg(): Promise<Nullable<string>> {
  return ActivateThemeGetter.getActivatedThemeCfg(`/system/home/base/lock_config.json`);
}

function getActiveLockCfg(): Promise<Nullable<string>> {
  return ActivateThemeGetter.getActivatedThemeCfg(`/system/lock/base/lock_config.json`);
}
