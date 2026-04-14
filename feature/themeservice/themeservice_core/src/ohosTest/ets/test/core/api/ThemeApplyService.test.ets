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

import { beforeAll, describe, expect, it, Level, TestType } from '@ohos/hypium';
import { EditThemeArg, ThemeInfo, ThemeOptions } from '@ohos/themeservice_inner_api/Index';
import { NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { ThemePresetDataGetter } from '../../../core/util/ThemePresetDataGetter';
import { AssertUtils } from '../../../core/util/AssertUtils';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';

const TAG: string = 'ThemeApplyService.test';

export default function ThemeApplyServiceTest() {
  describe('themeApplyServiceTest', () => {
    let defThemePath: string;
    beforeAll(async () => {
      defThemePath = await ThemePresetDataGetter.getDefaultThemePath();
      await themeInfoService.get().init();
    });

    it('activateEditedTheme_fail', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateEditedTheme('0');
      TsLog.debug(TAG, `activateThemeTest:${defThemePath}, ret:${ret}`);
      expect(ret).assertFalse();
    })

    it('activateEditedTheme_success', 0, async () => {
      let themeList: NullableType<ThemeInfo[]> =
        await TSOhosTestManger.getTsCoreRemoteApi().getThemeList(0);
      expect(themeList != null).assertTrue();
      expect(themeList?.length !== 0).assertTrue();
      const editorId: string = themeList![0]?.editorId;
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateEditedTheme(editorId);
      TsLog.debug(TAG, `activateThemeTest:${defThemePath}, ret:${ret}`);
      expect(ret).assertTrue();
    })

    it('activateTheme_success', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateTheme(defThemePath);
      TsLog.debug(TAG, `activateThemeTest:${defThemePath}, ret:${ret}`);
      expect(ret).assertTrue();
    })

    it("activateTheme_fail", 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateTheme('');
      TsLog.debug(TAG, `activateThemeTest:${defThemePath}, ret:${ret}`);
      expect(ret).assertFalse();
    })

    it('activateThemeOpt_success', 0, async () => {
      let option: ThemeOptions = new ThemeOptions();
      option.home = ThemeOptions.ENABLE;
      option.lock = ThemeOptions.ENABLE;
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateTheme(defThemePath, option);
      TsLog.debug(TAG, `activateThemeOpt:${defThemePath}, ret:${ret}`);
      expect(ret).assertTrue();
    })

    it('activateThemeOpt_icon_success', 0, async () => {
      let option: ThemeOptions = new ThemeOptions();
      option.icons = ThemeOptions.ENABLE;
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateTheme(defThemePath, option);
      TsLog.info(TAG, `activateThemeIcon:${defThemePath}, ret:${ret}`);
      expect(ret).assertTrue();
    })
    it('activateThemeOpt_aod_success', 0, async () => {
      let option: ThemeOptions = new ThemeOptions();
      option.aod = ThemeOptions.ENABLE;
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateTheme(defThemePath, option);
      TsLog.debug(TAG, `activateThemeAod:${defThemePath}, ret:${ret}`);
      expect(ret).assertTrue();
    })

    it('activateThemeCustom_success', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateThemeCustom(defThemePath);
      TsLog.debug(TAG, `activateThemeCustom:${defThemePath}, ret:${ret}`);
      expect(ret).assertTrue();
    })

    it('saveThemeCustom_success', 0, async () => {
      let ret: string = await TSOhosTestManger.getTsCoreRemoteApi().saveThemeCustom(defThemePath);
      TsLog.debug(TAG, `saveThemeCustom:${defThemePath}, ret:${ret}`);
      expect(ret).not().assertNull();
    })

    it('activateThemeCustomWithPath_success', 0, async () => {
      await testActivateThemeCustomWithPathSuccess(defThemePath);
    })

    it("editTheme_fail", 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().editTheme(new EditThemeArg('', 'default'));
      expect(ret).assertFalse();
    })

    it('activateTheme_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      let defThemePath: string = await ThemePresetDataGetter.getDefaultThemePath();
      let option: ThemeOptions = new ThemeOptions();
      option.home = ThemeOptions.ENABLE;
      option.lock = ThemeOptions.ENABLE;
      await AssertUtils.expectParallelInvoke(() => TSOhosTestManger.getTsCoreRemoteApi()
        .activateTheme(defThemePath, option))
    })

    it('activateThemeCustom_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      let defThemePath: string = await ThemePresetDataGetter.getDefaultThemePath();
      await AssertUtils.expectParallelInvoke(() =>
      TSOhosTestManger.getTsCoreRemoteApi().activateThemeCustom(defThemePath))
    })
  })
}

async function testActivateThemeCustomWithPathSuccess(defThemePath: string) {
  let customPath: string = defThemePath;
  let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateThemeCustom(defThemePath, customPath);
  TsLog.debug(TAG, `activateThemeCustomWithPath:${defThemePath}, ret:${ret}`);
  expect(ret).assertTrue();
}