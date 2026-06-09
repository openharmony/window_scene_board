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
import { describe, expect, it } from '@ohos/hypium';
import { ThemeInfo } from '@ohos/themeservice_inner_api/Index';
import { JsonUtils, NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { GetThemeType } from '../../../../../main/ets/contant/TSTypes';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { ThemePresetDataGetter } from '../../../core/util/ThemePresetDataGetter';

const TAG: string = 'RemoveThemeTest';

export default function RemoveThemeTest() {
  describe('RemoveThemeTest', () => {
    // 测试移除主题接口-editorId不存在的场景
    it('removeTheme001', 0, async () => {
      TsLog.info(TAG, `removeTheme001`);
      let oldThemeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi()
        .getThemeList(GetThemeType.TS_GET_THEME_SETTING);
      await TSOhosTestManger.getTsCoreRemoteApi().removeTheme('0');
      let newThemeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi()
        .getThemeList(GetThemeType.TS_GET_THEME_SETTING);
      expect(newThemeInfos?.length).assertEqual(oldThemeInfos?.length);
    });

    // 测试移除主题接口-移除主题成功
    it('removeTheme002', 0, async () => {
      TsLog.info(TAG, `removeTheme002...`);
      let defThemePath: string = await ThemePresetDataGetter.getDefaultThemePath();
      TsLog.info(TAG, `getDefaultThemePath:${defThemePath}`);
      let oldTheme: NullableType<ThemeInfo> = await TSOhosTestManger.getTsCoreRemoteApi().getCurrentTheme();
      let editorId: string | undefined = oldTheme?.editorId ?? '';
      let activateResult: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateTheme(defThemePath);
      TsLog.info(TAG, `activateTheme activateResult:${activateResult}`);
      expect(activateResult).assertTrue();

      let currentTheme: NullableType<ThemeInfo> = await TSOhosTestManger.getTsCoreRemoteApi().getCurrentTheme();
      TsLog.info(TAG, `getCurrentTheme:${JsonUtils.stringify(currentTheme)}`);
      expect(currentTheme?.originThemePack?.srcPath === defThemePath).assertTrue();

      await TSOhosTestManger.getTsCoreRemoteApi().activateEditedTheme(editorId);
      let oldThemeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi()
        .getThemeList(GetThemeType.TS_GET_THEME_SETTING);
      let result: NullableType<number>;
      result = oldThemeInfos?.findIndex(themeInfo => themeInfo.editorId === currentTheme?.editorId);
      TsLog.info(TAG, `getThemeList result:${result}`);
      expect(result === -1).assertFalse();

      await TSOhosTestManger.getTsCoreRemoteApi().removeTheme(currentTheme?.editorId ?? '');
      let newThemeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi()
        .getThemeList(GetThemeType.TS_GET_THEME_SETTING);
      result = newThemeInfos?.findIndex(themeInfo => themeInfo.editorId === currentTheme?.editorId);
      TsLog.info(TAG, `removeTheme result:${result}`);
      expect(result === -1).assertTrue();
      TsLog.info(TAG, `removeTheme002.`);
    });
  })
}