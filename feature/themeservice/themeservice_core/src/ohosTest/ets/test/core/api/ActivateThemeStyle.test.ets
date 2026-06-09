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
import { afterAll, beforeAll, describe, expect, it, Level, TestType } from '@ohos/hypium';
import { ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, NullableType, TsLog } from '@ohos/themeservicebase';
import { ThemeCacheInfo } from '../../../../../main/ets/cache/ThemeInfoStoreCache';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const defaultStyle: string = 'style0';

const styleName: string = 'style1';

const TAG: string = 'ActivateThemeStyleTest';

export default function ActivateThemeStyleTest() {
  describe('ActivateThemeStyleTest', () => {
    const tempThemePath: string = '/data/themes/s/theme';

    beforeAll(async () => {
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      TsLog.info(TAG, `themeInfo srcPath = ${themeInfo.originThemePack?.srcPath}, id = ${themeInfo.id}`);

      if (!FileUtil.isFileExists(tempThemePath)) {
        FileUtil.createDirRecur(tempThemePath);
      }

      if (!themeInfo.originThemePack) {
        TsLog.warning(TAG, `current theme info not find origin theme pack`);
        return;
      }
      let originSrcPath: string = themeInfo.originThemePack.srcPath;
      await FileUtil.copyDirAsync(originSrcPath, tempThemePath);

      // 创建aod 场景
      let tempActivatePath: string = `${tempThemePath}/${FileUtil.getFileName(originSrcPath)}`;
      TsLog.info(TAG, `tempActivatePath:${tempActivatePath}`);
      await copyRes(`${tempActivatePath}/aod`, `${tempActivatePath}/aod_extension/${styleName}`);

      // 创建skin场景
      let audioPath: string = `${tempActivatePath}/skin/com.ohos.audioaccessorymanager/entry/base`;
      TsLog.info(TAG, `audioPath = ${audioPath}`);
      if (!FileUtil.isFileExists(audioPath)) {
        FileUtil.createDirRecur(audioPath);
      }
      await copyRes(`${tempActivatePath}/skin`, `${tempActivatePath}/skin_extension/${styleName}`);

      let cacheInfo: NullableType<ThemeCacheInfo> = await themeInfoService.get().getCurrentCacheTheme();
      if (cacheInfo) {
        cacheInfo.srcPath = tempActivatePath;
        TsLog.info(TAG, `cacheInfo id = ${cacheInfo.id}`);
        await themeInfoService.get().updateCurrentCacheTheme(cacheInfo);
      }
    });

    afterAll(async () => {
      await FileUtil.deleteAsync(tempThemePath);
    });

    it('test001_activate_aod_default_success', 0, async () => {
      let contentType: string[] = ['aod'];
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateThemeStyle(contentType, defaultStyle);
      expect(ret).assertTrue();
    });

    it('test002_activate_aod_skin_default_success', 0, async () => {
      let contentType: string[] = ['aod', 'skin'];
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateThemeStyle(contentType, defaultStyle);
      expect(ret).assertTrue();
    });

    it('test003_activate_style_default_fail', 0, async () => {
      let contentType: string[] = [''];
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateThemeStyle(contentType, defaultStyle);
      expect(ret).assertFalse();
    });

    it('test004_activate_aod_style1_success', 0, async () => {
      let contentType: string[] = ['aod'];
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateThemeStyle(contentType, styleName);
      expect(ret).assertTrue();
    });

    it('test005_activate_aod_other_style_fail', 0, async () => {
      let contentType: string[] = ['aod'];
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().activateThemeStyle(contentType, 'other');
      expect(ret).assertFalse();
    });

    it('test006_getThemeList', 0, async () => {
      let currentThemeInfo: NullableType<ThemeInfo> = await TSOhosTestManger.getTsCoreRemoteApi().getCurrentTheme();
      let unlockThemeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi().getThemeList(1);
      let result: NullableType<number> = unlockThemeInfos?.findIndex((themeInfo:ThemeInfo) => themeInfo.editorId == currentThemeInfo?.editorId);
      expect(result).assertEqual(-1);
    });

    it('test007_invalid_getThemeList', 0, async () => {
      let themeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi().getThemeList(-1);
      expect(themeInfos).assertUndefined()
    });

    it('test008_invalid_applyTheme', 0, async () => {
      let oldThemeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi().getThemeList(0);
      await themeInfoService.get().applyTheme(new ThemeInfo('invalid_id','invalid_editId'), new Map());
      let newThemeInfos: NullableType<ThemeInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi().getThemeList(0);
      expect(oldThemeInfos?.length).assertEqual(newThemeInfos?.length);
    });

    it('test09_activateThemeStyle_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      let contentType: string[] = ['aod', 'skin'];
      await AssertUtils.expectParallelInvoke(() =>
      TSOhosTestManger.getTsCoreRemoteApi().activateThemeStyle(contentType, defaultStyle));
    });
  });
};

async function copyRes(srcPath: string, dstPath: string): Promise<void> {
  if (!FileUtil.isFileExists(srcPath)) {
    return;
  }
  let fileNames: string[] = await FileUtil.listFileNames(srcPath);
  for (let fileName of fileNames) {
    const file: string = `${srcPath}/${fileName}`;
    if (FileUtil.isDir(file)) {
      TsLog.info(TAG, `${fileName} copy = ${await FileUtil.copyDirAsync(file, dstPath)}`);
    } else {
      TsLog.info(TAG, `${fileName} copy = ${await FileUtil.copyFileAsync(file, `${dstPath}/${fileName}`)}`);
    }
  }
}