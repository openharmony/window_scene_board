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
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { Constants, ThemeCode, ThemePackInfo } from '@ohos/themeservice_inner_api';
import { JsonUtils, TsLog } from '@ohos/themeservicebase';
import { getThemePackParser } from '../../../../../main/ets/preset/ThemePackParser';
import { TrialThemeInfo } from '../../../../../main/ets/remote/model/TrialThemeInfo';
import { ThemePackUtils } from '../../../../../main/ets/util/ThemePackUtils';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { ThemePresetDataGetter } from '../../../core/util/ThemePresetDataGetter';

const TAG: string = 'LimitedFreeThemeTest';

export default function LimitedFreeThemeTest() {
  describe('LimitedFreeThemeTest', () => {
    let themePath: string;
    let id: string;
    beforeAll(async () => {
      // 1.激活限时免费套餐
      themePath = await ThemePresetDataGetter.getDefaultThemePath();
      let themePackInfo: ThemePackInfo = await getThemePackParser().parse(themePath);
      id = ThemePackUtils.getDescription(themePackInfo.description, 'id') as string;
    });

    it("testCorrectLimitedFreeTheme", Level.LEVEL0, async () => {
      await testActivateLimitedFreeTheme(themePath, id);
      await testCorrectLimitedFreeTheme(id);
    })

    it("testPromoteLimitedFreeTheme", Level.LEVEL0, async () => {
      await testActivateLimitedFreeTheme(themePath, id);
      await testPromoteLimitedFreeTheme(themePath, id);
    })
  })
}

async function testActivateLimitedFreeTheme(themePath: string, id: string) {
  // 激活限时免费套餐
  let limitedDuration: number = 5 * 1000;
  let reminderDuration: number = 2 * 1000;
  let activateRet: number =
    await TSOhosTestManger.hwAppCallApi(api => api.activateTrialTheme(themePath, limitedDuration, 'theme',
      Constants.LIMITED_FREE, reminderDuration));
  expect(activateRet).assertEqual(ThemeCode.SUCCESS);
}

async function testCorrectLimitedFreeTheme(id: string): Promise<void> {
  // 重新校准时间
  let correctLimitedDuration: number = 10 * 1000;
  let correctReminderDuration: number = 4 * 1000;
  let correctRet: number =
    await TSOhosTestManger.hwAppCallApi(api => api.correctLimitedFreeTheme(id, 'theme', correctLimitedDuration,
      correctLimitedDuration));
  expect(correctRet).assertEqual(ThemeCode.SUCCESS);
}

async function testPromoteLimitedFreeTheme(themePath: string, id: string): Promise<void> {
  // 提升限免套餐
  let ret: number =
    await TSOhosTestManger.hwAppCallApi(api => api.promoteTrialTheme(id, themePath, 'theme'));
  expect(ret).assertEqual(ThemeCode.SUCCESS);
  let limitedFreeThemeInfo: Nullable<TrialThemeInfo> =
    await TSOhosTestManger.hwAppCallApi(api => api.getTrialTheme());
  expect(limitedFreeThemeInfo).not().assertUndefined();
}

async function testRollBackTheme(): Promise<void> {
  // 回退主题
  let ret: number =
    await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
  expect(ret).assertEqual(ThemeCode.SUCCESS);

  let limitedFreeThemeInfo: Nullable<TrialThemeInfo> =
    await TSOhosTestManger.hwAppCallApi(api => api.getTrialTheme());
  assertLimitedFreeNullable(limitedFreeThemeInfo);
}

function assertLimitedFreeNullable(limitedFreeThemeInfo: Nullable<TrialThemeInfo>): void {
  expect(limitedFreeThemeInfo?.trialEndTime).assertUndefined();
  expect(limitedFreeThemeInfo?.reminderEndTime).assertUndefined();
  expect(limitedFreeThemeInfo?.preThemeInfo).assertUndefined();
  expect(limitedFreeThemeInfo?.trialThemeId).assertUndefined();
  expect(limitedFreeThemeInfo?.trialType).assertUndefined();
}

async function assertLimitedFreeThemeInfo(id: string, limitedDuration: number,
  reminderDuration: number): Promise<void> {
  let limitedFreeThemeInfo: Nullable<TrialThemeInfo> =
    await TSOhosTestManger.hwAppCallApi(api => api.getTrialTheme());
  TsLog.info(TAG, `assertLimitedFreeThemeInfo: ${JsonUtils.stringify(limitedFreeThemeInfo)}`);
  TsLog.info(TAG,
    `assertLimitedFreeThemeInfo, id:${id}, limitedDuration:${limitedDuration},reminderDuration:${reminderDuration}`);
  expect(limitedFreeThemeInfo).not().assertUndefined();
  expect(limitedFreeThemeInfo?.trialEndTime).assertLarger(limitedDuration);
  expect(limitedFreeThemeInfo?.reminderEndTime).assertLarger(reminderDuration);
  expect(limitedFreeThemeInfo?.trialThemeId).assertEqual(id);
  expect(limitedFreeThemeInfo?.trialType).assertEqual('theme');
}
