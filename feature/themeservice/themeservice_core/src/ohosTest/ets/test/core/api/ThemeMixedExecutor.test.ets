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
import { ThemeInfo, ThemeOptions } from '@ohos/themeservice_inner_api/Index';
import { FileUtil, TsLog } from '@ohos/themeservicebase/Index';
import { ThemeMixedExecutor } from '../../../../../main/ets/service/impl/activate/ThemeMixedExecutor';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';
import { ThemeEditInfo } from '../../../../../main/ets/cache/ThemeInfoStoreCache';
import { systemDateTime } from '@kit.BasicServicesKit';
import { ThemeActivateServiceImpl } from '../../../../../main/ets/service/impl/ThemeActivateServiceImpl';

const TAG: string = 'ThemeMixedExecutor.test';

export default function ThemeMixedExecutorTest() {
  describe('ThemeMixedExecutorTest', () => {
    it('test001_theme_isMixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const isMixed: boolean = await mixedExecutor.isMixed();
      TsLog.debug(TAG, `test001_theme_isMixed ret: ${isMixed}`);
      expect(isMixed).assertFalse();
    })

    it('test002_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath);
      TsLog.debug(TAG, `test002_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test003_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed("", undefined);
      TsLog.debug(TAG, `test003_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test004_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let option: ThemeOptions = new ThemeOptions();
      option.home = ThemeOptions.ENABLE;
      option.lock = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, option);
      TsLog.debug(TAG, `test004_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test005_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let option: ThemeOptions = new ThemeOptions();
      option.home = ThemeOptions.ENABLE;
      option.lock = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, option, true);
      TsLog.debug(TAG, `test005_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test006_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let option: ThemeOptions = new ThemeOptions();
      option.home = ThemeOptions.ENABLE;
      option.lock = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, option, false);
      TsLog.debug(TAG, `test006_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test007_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let option: ThemeOptions = new ThemeOptions();
      option.home = ThemeOptions.ENABLE;
      option.lock = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, option, false, undefined);
      TsLog.debug(TAG, `test007_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test008_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let option: ThemeOptions = new ThemeOptions();
      option.home = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, option, false, undefined);
      TsLog.debug(TAG, `test008_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test009_theme_mixed', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let option: ThemeOptions = new ThemeOptions();
      option.lock = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, undefined, true, undefined);
      TsLog.debug(TAG, `test009_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo !== undefined).assertTrue();
    })

    it('test010_theme_mixed', 0, async () => {
      let originPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let option: ThemeOptions = new ThemeOptions();
      option.lock = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, defaultTheme);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, option, true, undefined);
      TsLog.debug(TAG, `test010_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo).not().assertUndefined();
    })

    it('test011_theme_mixed', 0, async () => {
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let originPath: string = defaultTheme.originThemePack?.srcPath ? defaultTheme.originThemePack.srcPath : '';
      let option: ThemeOptions = new ThemeOptions();
      option.lock = ThemeOptions.ENABLE;
      option.fonts = ThemeOptions.ENABLE;
      option.aod = ThemeOptions.ENABLE;
      option.icons = ThemeOptions.ENABLE;
      const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, defaultTheme);
      const mixedThemeEditInfo: ThemeEditInfo = await mixedExecutor.activateThemeMixed(originPath, option, true, undefined);
      TsLog.debug(TAG, `test011_theme_mixed ret: ${mixedThemeEditInfo}`);
      expect(mixedThemeEditInfo).not().assertUndefined();
    })
  })
}