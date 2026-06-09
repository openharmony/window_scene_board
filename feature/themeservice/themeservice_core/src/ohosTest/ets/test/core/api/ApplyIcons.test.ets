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
import { TsLog } from '@ohos/themeservicebase/Index';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';
import { ThemeInfo } from '@ohos/themeservice_inner_api';
import { ApplyIconsExecutor } from '../../../../../main/ets/service/impl/activate/ApplyIconsExecutor';

const TAG: string = 'ApplyIconsTest';

export default function ApplyIconsTest() {
  describe('ApplyIconsTest', () => {
    it('test001_apply_success', 0, async () => {
      let icons: string[] = await ThemePresetDataGetter.getIcons();
      let ret: boolean = await TSOhosTestManger.getTsKitRemoteApi().applyIcons(icons[0]);
      expect(ret).assertTrue();
    })

    it('test001_apply_fail', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsKitRemoteApi().applyIcons('data/invalidIcons');
      expect(ret).assertFalse();
    })

    it('test_003_applyIcons_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      let icons: string[] = await ThemePresetDataGetter.getIcons();
      await AssertUtils.expectParallelInvokeBoolean(() =>
        TSOhosTestManger.getTsKitRemoteApi().applyIcons(icons[0]), true);
    })

    it('test_004_applyIconsExecutor_test', 0, async () => {
      let icons: string[] = await ThemePresetDataGetter.getIcons();
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyIconsExecutor(themeInfo).applyIcons(icons[0]);
      TsLog.debug(TAG, `test_004_applyIconsExecutor_test ret: ${ret}`);
      expect(ret).assertTrue();
    })

    it('test_005_applyIconsExecutor_test', 0, async () => {
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyIconsExecutor(themeInfo).applyIcons('data/invalidIcons');
      expect(ret).assertFalse();
      TsLog.debug(TAG, `test_005_applyIconsExecutor_test ret: ${ret}`);
    })

    it('test_006_applyIconsExecutor_test', 0, async () => {
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyIconsExecutor(themeInfo).applyIcons('test');
      expect(ret).assertFalse();
      TsLog.debug(TAG, `test_006_applyIconsExecutor_test ret: ${ret}`);
    })
  })
}