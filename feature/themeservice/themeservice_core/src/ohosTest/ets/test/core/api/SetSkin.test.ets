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
import { describe, expect, it } from '@ohos/hypium';
import { FileUtil, TsLog } from '@ohos/themeservicebase/Index';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { ThemePresetDataGetter } from '../../../core/util/ThemePresetDataGetter';
import { SetSkinExecutor } from '../../../../../main/ets/service/impl/activate/SetSkinExecutor';
import { ThemeInfo } from '@ohos/themeservice_inner_api/Index';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';
import { systemDateTime } from '@kit.BasicServicesKit';
import { ThemeActivateServiceImpl } from '../../../../../main/ets/service/impl/ThemeActivateServiceImpl';

const TAG: string = 'SetSkin.test';

export default function SetSkinTest() {
  describe('SetSkinTest', () => {
    it('test001_set_skin_success', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi()
        .setSkin('', ['com.ohos.audioaccessorymanager']);
      TsLog.debug(TAG, `setSkin ret: ${ret}`);
      expect(ret).assertTrue();
    })

    it('test002_set_invalid_skin', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi()
        .setSkin('invalid', ['com.ohos.audioaccessorymanager']);
      expect(ret).assertFalse();
    })

    it('test003_set_invalid_skin', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi()
        .setSkin('invalid', ['']);
      expect(ret).assertFalse();
    })

    it('test004_set_invalid_skin', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi()
        .setSkin('invalid', ['wallpaper1','wallpaper2', '']);
      expect(ret).assertFalse();
    })

    it('test005_set_skin', 0, async () => {
      let wallpaper: string = await ThemePresetDataGetter.getDefaultHomeWallPaper();
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setSkin(wallpaper, ['wallpaper1','wallpaper2', '']);
      TsLog.debug(TAG, `test005_set_skin ret: ${ret}`);
      expect(ret).assertFalse();
    })

    it('test006_set_skin', 0, async () => {
      let wallpaper: string = await ThemePresetDataGetter.getDefaultHomeWallPaper();
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setSkin(wallpaper, ['com.ohos.audioaccessorymanager']);
      TsLog.debug(TAG, `test006_set_skin ret: ${ret}`);
      expect(ret).assertFalse();
    })

    it('test007_set_skin', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let ret: boolean = await new SetSkinExecutor(themeInfo).setSkin('', ['']);
      TsLog.debug(TAG, `test007_set_skin ret: ${ret}`);
      expect(ret).assertTrue();
    })

    it('test008_set_skin', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let skinPath: string = await ThemePresetDataGetter.getDefaultHomeWallPaper();
      let ret: boolean = await new SetSkinExecutor(themeInfo).setSkin(skinPath, ['wallpaper1']);
      TsLog.debug(TAG, `test008_set_skin ret: ${ret}`);
      expect(ret).assertFalse();
    })

    it('test009_set_skin', 0, async () => {
      let originPath: string = '';
      let customPath: string = '';
      let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let eid: string = systemDateTime.getTime(true).toString();
      if (customPath && FileUtil.isFileExists(customPath)) {
        eid = defaultTheme.editorId;
      }
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(originPath, eid);
      let skinPath: string = await ThemePresetDataGetter.getDefaultHomeWallPaper();
      let ret: boolean = await new SetSkinExecutor(themeInfo).setSkin(skinPath, ['wallpaper1', 'wallpaper2']);
      TsLog.debug(TAG, `test009_set_skin ret: ${ret}`);
      expect(ret).assertFalse();
    })
  })
}