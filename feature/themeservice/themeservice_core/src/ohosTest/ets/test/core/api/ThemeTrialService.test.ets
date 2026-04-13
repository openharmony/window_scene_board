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

import { afterAll, beforeAll, describe, expect, it, Level, TestType } from '@ohos/hypium';
import { Constants, ThemeCode, ThemeInfo, ThemePackInfo } from '@ohos/themeservice_inner_api/Index';
import { JsonUtils, NullableType, TsLog } from '@ohos/themeservicebase';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { TrialThemeInfo } from '../../../../../main/ets/remote/model/TrialThemeInfo';
import { activateThemeService } from '../../../../../main/ets/service/impl/ThemeActivateServiceImpl';
import { ThemeTrialServiceImpl } from '../../../../../main/ets/service/impl/ThemeTrialServiceImpl';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const TAG: string = 'ThemeTrialServiceTestLog';
const THEME_PATH: string = `/sys_prod/variant/region_comm/china/resource/themes/theme/default`;
const FONT_PATH: string = `/sys_prod/variant/region_comm/china/resource/themes/font/font_01/`;

export default function ThemeTrialServiceTest() {
  describe('ThemeTrialServiceTest', () => {
    let testServiceImpl: ThemeTrialServiceImpl;

    beforeAll(async () => {
      testServiceImpl = new ThemeTrialServiceImpl();
      await activateThemeService().activateDefaultTheme();
      await activateThemeService().activateDefaultFont();
    });

    afterAll(async () => {
      testServiceImpl = new ThemeTrialServiceImpl();
      await activateThemeService().activateDefaultTheme();
      await activateThemeService().activateDefaultFont();
    });

    it('getTrialTheme_test', 0, async () => {
      await testGetTrialTheme();
    });

    it('activateTrialTheme_success', 0, async () => {
      // 试用主题正常过程
      await activateTrial();
      // 回退上个主题
      await rollbackPrev();
    });

    it('activateTrialFont_success', 0, async () => {
      // 试用字体正常过程
      await activateTrialFont();
      // 回退上个主题
      await rollbackPrev();
    });

    it('activateTrialTheme_invalidParam', Level.LEVEL1, async () => {
      await testActivateTrialThemeInvalidParam();
    })

    it('stopTrialTheme_test', 0, async () => {
      await testStopTrialTheme();
    });

    it('promoteTrialTheme_test', 0, async () => {
      await testPromoteTrialTheme();
    });

    // 回退默认主题，失败
    it('rollbackThemeDefaultFailed_test', 0, async () => {
      let result: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
      expect(result).assertEqual(ThemeCode.ERROR_ROLLBACK_THEME);
    });

    // 回退默认主题，成功
    it('rollbackThemeDefaultSuccess_test', 0, async () => {
      await activateTrial();
      let result: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
      expect(result).assertEqual(ThemeCode.SUCCESS);
    });

    // 回退默认字体，成功
    it('rollbackFontDefaultSuccess_test', 0, async () => {
      await activateTrialFont();
      let result: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
      expect(result).assertEqual(ThemeCode.SUCCESS);
    });

    // 初始化操作成功
    it('onInit_test', 0, async () => {
      await activateTrialFont();
      await testServiceImpl.onInit();
      let result: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
      expect(result).assertEqual(ThemeCode.SUCCESS);
    });

    // 通知主题App（重启）
    it('notifyThemeAppRestart_test', 0, async () => {
      await activateTrialFont();
      await testServiceImpl.notifyThemeAppRestart();
      let result: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
      TsLog.info(TAG, `notifyThemeAppRestart_test , result  = ${result}`);
      expect(result).assertEqual(ThemeCode.SUCCESS);
    });

    // 通知主题App（到期）
    it('notifyThemeAppExpires_test', 0, async () => {
      await activateTrialFont();
      await testServiceImpl.notifyThemeAppExpires();
      let result: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
      TsLog.info(TAG, `notifyThemeAppExpires_test , result  = ${result}`);
      expect(result).assertEqual(ThemeCode.SUCCESS);
    });

    // 通知主题App（提前）
    it('notifyThemeAppAdvanced_test', 0, async () => {
      await activateTrialFont();
      await testServiceImpl.notifyThemeAppAdvanced();
      let result: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('default'));
      TsLog.info(TAG, `notifyThemeAppAdvanced_test , result  = ${result}`);
      expect(result).assertEqual(ThemeCode.SUCCESS);
    });

    it('factoryReset_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      await AssertUtils.expectParallelInvoke(() => TSOhosTestManger.retailAppCallApi(api => api.factoryReset()));
    });

    it('checkPrevTheme_test', TestType.SECURITY | Level.LEVEL1, async () => {
      expect(await testServiceImpl.checkPrevTheme(undefined)).assertFalse();

      let themeInfo: NullableType<ThemeInfo> = new ThemeInfo('themeId', 'editId');
      expect(await testServiceImpl.checkPrevTheme(themeInfo)).assertFalse();

      themeInfo.originThemePack = new ThemePackInfo();
      themeInfo.originThemePack.srcPath = THEME_PATH;
      themeInfo.originThemePack.origin = 'presetFragment';
      expect(await testServiceImpl.checkPrevTheme(themeInfo)).assertFalse();

      themeInfo.originThemePack.origin = 'preset';
      expect(await testServiceImpl.checkPrevTheme(themeInfo)).assertTrue();
    });
  });
}

async function testGetTrialTheme() {
  let trialCacheData: Nullable<TrialThemeInfo> = await TSOhosTestManger.hwAppCallApi(api => api.getTrialTheme());
  TsLog.info(TAG, `testGetTrialTheme , trialCacheData  = ${JsonUtils.stringify(trialCacheData)}`);
  expect(trialCacheData).not().assertUndefined();
}

async function testActivateTrialThemeInvalidParam() {
  await AssertUtils.expectErrorCode(() => TSOhosTestManger.hwAppCallApi(api => api.activateTrialTheme(`error path`, -1,
    'theme')), RemoteCode.ERR_PARAM);

  await AssertUtils.expectErrorCode(() => TSOhosTestManger.hwAppCallApi(api => api.activateTrialTheme(`error path`,
    3 * 30 * 24 * 60 * 60 * 1000 + 1, 'theme')), RemoteCode.ERR_PARAM);

  await AssertUtils.expectErrorCode(() => TSOhosTestManger.hwAppCallApi(api => api.activateTrialTheme(`error path`, -1,
    'font')), RemoteCode.ERR_PARAM);

  await AssertUtils.expectErrorCode(() => TSOhosTestManger.hwAppCallApi(api => api.activateTrialTheme(`error path`,
    3 * 30 * 24 * 60 * 60 * 1000 + 1, 'font')), RemoteCode.ERR_PARAM);
}

async function testStopTrialTheme() {
  await activateTrial();
  // 再次应用主题，取消试用
  await TSOhosTestManger.hwAppCallApi(api => api.activateTheme(THEME_PATH));
  // 获取试用信息为空
  let trialCacheDataEmpty: Nullable<TrialThemeInfo> = await TSOhosTestManger.hwAppCallApi(api => api
    .getTrialTheme());
  expect(trialCacheDataEmpty?.trialThemeId).assertUndefined();
}

async function testPromoteTrialTheme() {
  await activateTrial();
  // 升级异常结果
  let promoteResult1: number = await TSOhosTestManger.hwAppCallApi(api => api.promoteTrialTheme('errorId',
    THEME_PATH, 'theme'));
  expect(promoteResult1).assertEqual(ThemeCode.ERROR_PROMOTE_TRIAL_THEME);
  // 升级异常结果
  let promoteResult2: number = await TSOhosTestManger.hwAppCallApi(api => api.promoteTrialTheme('errorId',
    THEME_PATH, 'font'));
  expect(promoteResult2).assertEqual(ThemeCode.ERROR_PROMOTE_TRIAL_THEME);
  // 升级异常结果
  await AssertUtils.expectErrorCode(() => TSOhosTestManger.hwAppCallApi(api => api.promoteTrialTheme('errorId',
    'errorPath', 'font')), RemoteCode.ERR_PARAM);
  // 回退上个主题
  await rollbackPrev();
}

/**
 * 试用主题
 */
async function activateTrial(): Promise<void> {
  // 试用主题
  let trialResult: number = await TSOhosTestManger.hwAppCallApi(api => api.activateTrialTheme(THEME_PATH, 10000,
    'theme'));
  expect(trialResult).assertEqual(ThemeCode.SUCCESS);
  // 获取试用信息不为空
  let trialCacheDataSuccess: Nullable<TrialThemeInfo> = await TSOhosTestManger.hwAppCallApi(api => api
    .getTrialTheme());
  expect(trialCacheDataSuccess?.trialThemeId).not().assertUndefined();
}

/**
 * 试用字体
 */
async function activateTrialFont(): Promise<void> {
  // 试用主题
  let trialResult: number =
    await TSOhosTestManger.hwAppCallApi(api => api.activateTrialTheme(FONT_PATH, 10000, 'font', Constants.TRIAL,
      undefined));
  TsLog.info(TAG, `activateTrialFont , trialResult  = ${trialResult}`);
  expect(trialResult).assertEqual(ThemeCode.SUCCESS);
  // 获取试用信息不为空
  let trialCacheDataSuccess: Nullable<TrialThemeInfo> = await TSOhosTestManger.hwAppCallApi(api => api.getTrialTheme());
  TsLog.info(TAG, `activateTrialFont , trialCacheDataSuccess  = ${JsonUtils.stringify(trialCacheDataSuccess)}`);
  expect(trialCacheDataSuccess).not().assertUndefined();
}

/**
 * 回退上一个主题/字体
 */
async function rollbackPrev(): Promise<void> {
  // 回退上个主题/字体
  let rollbackResult: number = await TSOhosTestManger.hwAppCallApi(api => api.rollbackTheme('prev'));
  expect(rollbackResult).assertEqual(ThemeCode.SUCCESS);
  // 获取试用信息为空
  let trialCacheDataEmpty: Nullable<TrialThemeInfo> = await TSOhosTestManger.hwAppCallApi(api => api.getTrialTheme());
  expect(trialCacheDataEmpty?.trialThemeId).assertUndefined();
}
