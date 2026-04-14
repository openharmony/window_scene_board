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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { MapUtils, TsLog } from '@ohos/themeservicebase/Index';
import { TServiceApi } from '@ohos/themeservice_inner_api/Index';
import { ThemeInfo, ThemePackInfo } from '@ohos/themeservice_inner_api/Index';
import { NullableType } from '@ohos/themeservicebase';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';

const TAG: string = 'GetThemeInfoInner.test';

export default function GetThemeInfoInnerTest() {
  describe('GetThemeInfoInnerTest', () => {
    beforeAll(async () => {
      await themeInfoService.get().init();
    });

    it('test001', 0, async () => {
      let themeInfo: NullableType<ThemeInfo> = await TServiceApi.themeInfoInner().getCurrentInnerTheme();
      expect(themeInfo).not().assertUndefined();
      assertThemePack(themeInfo!.originThemePack!);
      assertThemePack(themeInfo!.customThemePack!);
    })

    it("test002", 0, async () => {
      let themeInfos: NullableType<ThemeInfo[]> = await TServiceApi.themeInfoInner().getCurrentInnerThemeInfoList(0);
      expect(themeInfos).not().assertUndefined();
      for (const element of themeInfos!) {
        assertThemePack(element.originThemePack!);
        assertThemePack(element.customThemePack!);
        expect(element.mixThemeInfos === undefined || MapUtils.isMapType(element.mixThemeInfos)).assertTrue();
      }
    })

    it("test003", 0, async () => {
      let themeInfos: NullableType<ThemeInfo[]> = await TServiceApi.themeInfoInner().getCurrentInnerThemeInfoList(1);
      expect(themeInfos).not().assertUndefined();
      for (const element of themeInfos!) {
        assertThemePack(element.originThemePack!);
        assertThemePack(element.customThemePack!);
        expect(element.mixThemeInfos === undefined || MapUtils.isMapType(element.mixThemeInfos)).assertTrue();
      }
    })
  })
}

function assertThemePack(themePack: Nullable<ThemePackInfo>) {
  if (themePack) {
    expect(themePack.srcPath).not().assertUndefined();
    TsLog.debug(TAG, `${themePack.srcPath}`);
    if (themePack.description) {
      TsLog.debug(TAG, `description:${JSON.stringify(themePack.description)}`);
      expect(themePack.description).not().assertUndefined();
    }

    if (themePack.lockManifest) {
      TsLog.debug(TAG, `lockManifest:${JSON.stringify(themePack.lockManifest)}`);
      expect(themePack.lockManifest).not().assertUndefined();
    }
    if (themePack.homeManifest) {
      TsLog.debug(TAG, `homeManifest:${JSON.stringify(themePack.homeManifest)}`);
      expect(themePack.homeManifest).not().assertUndefined();
    }
  }
}
