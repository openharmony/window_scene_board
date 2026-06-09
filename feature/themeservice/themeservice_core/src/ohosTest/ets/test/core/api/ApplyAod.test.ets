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
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';
import { ThemePresetDataGetter } from '../../../core/util/ThemePresetDataGetter';

const TAG: string = 'ApplyAodTest';

export default function ApplyAodTest() {
  describe('applyAodTest', () => {
    it('test001_apply_success', 0, async () => {
      let aodList: string[] = await ThemePresetDataGetter.getAod();
      let ret: boolean = await TSOhosTestManger.getTsKitRemoteApi().applyAod(aodList[1]);
      expect(ret).assertTrue();
    })

    it('test002_apply_fail', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsKitRemoteApi().applyAod(``);
      expect(ret).assertFalse();
    })

    it('test003_apply_Aod_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      let aodList: string[] = await ThemePresetDataGetter.getAod();
      await AssertUtils.expectParallelInvokeBoolean(() =>
        TSOhosTestManger.getTsKitRemoteApi().applyAod(aodList[1]), true);
    })
  })
}