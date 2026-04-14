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
import { MapUtils, NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';
import { ThemeInfoV2 } from '../../../core/remote/model/ThemeInfo';
import { LockConfig, ThemePackInfo } from '../../../core/remote/model/ThemePackInfo';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';

const TAG: string = 'GetThemeListTest';

/**
 * 测试 ThemeInfoCodec能力
 */
export default function GetThemeListTest() {
  describe('GetThemeListTest', () => {
    it('test001_GetThemeList_success', 0, async () => {
      await themeInfoService.get().init();
      let themeInfos: NullableType<ThemeInfoV2[]> = await TSOhosTestManger.getTsCoreRemoteApi().getThemeListV2(0);
      expect(themeInfos).not().assertUndefined();
      for (const element of themeInfos!) {
        TsLog.debug(TAG, `[start][${element.id} - ${element.editorId}]getThemeList_fromSetting`);
        assertThemePack(element.originThemePack);
        assertThemePack(element.customThemePack!);
        expect(element.mixThemeInfos === undefined || MapUtils.isMapType(element.mixThemeInfos)).assertTrue();
        TsLog.debug(TAG, `[end]getThemeList_fromSetting`);
      }
    });

    it('test002_GetCurrentTheme_success', 0, async () => {
      await themeInfoService.get().init();
      let themeInfo: NullableType<ThemeInfoV2> = await TSOhosTestManger.getTsCoreRemoteApi().getCurrentThemeV2();
      expect(themeInfo).not().assertUndefined();
      TsLog.debug(TAG, `[start][${themeInfo!.id} - ${themeInfo!.editorId}]getCurrentTheme`);
      assertThemePack(themeInfo!.originThemePack);
      assertThemePack(themeInfo!.customThemePack!);
      TsLog.debug(TAG, `[end]getCurrentTheme`);
    });
  })
}

function assertThemePack(themePack: Nullable<ThemePackInfo>) {
  if (themePack) {
    expect(themePack.srcPath).not().assertUndefined();
    TsLog.debug(TAG, `${themePack.srcPath}`);
    if (themePack.description) {
      TsLog.debug(TAG, `description:${JSON.stringify(themePack.description)}`);
      TsLog.debug(TAG, `description id:${themePack.description.id}`);
      TsLog.debug(TAG, `description origin:${themePack.description.origin}`);
      TsLog.debug(TAG, `description title:${themePack.description.title}`);
      expect(themePack.description.id).not().assertUndefined();
      expect(themePack.description.origin).not().assertUndefined();
      expect(themePack.description.title).not().assertUndefined();
    }

    if (themePack.lockManifest) {
      TsLog.debug(TAG, `lockManifest:${JSON.stringify(themePack.lockManifest)}`);
      expect(themePack.lockManifest.type).not().assertUndefined();
    }
    if (themePack.homeManifest) {
      TsLog.debug(TAG, `homeManifest:${JSON.stringify(themePack.homeManifest)}`);
      expect(themePack.homeManifest.type).not().assertUndefined();
    }

    if (themePack.lockConfig) {
      themePack.lockConfig.forEach((value: LockConfig, key: string) => {
        TsLog.debug(TAG, `lockConfig, key:${key}, value:${JSON.stringify(value)}}`);
        expect(value).not().assertUndefined();
      })
    }
  }
}
