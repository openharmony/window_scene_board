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
import { ORIGIN_PRESET, ThemeCode } from '@ohos/themeservice_inner_api/Index';
import { TsLog } from '@ohos/themeservicebase/Index';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { ActivateThemeGetter } from '../../../core/util/ActivateThemeGetter';
import { AssertUtils } from '../../../core/util/AssertUtils';

const TAG: string = 'ApplyFont.test';

export default function ApplyFontTest() {
  describe('applyFontTest', () => {
    it('test001_apply_success', 0, async () => {
      let ret: number = await TSOhosTestManger.getTsCoreRemoteApi()
        .applyFont(`200000`, `system/fonts/OpenHarmony_Sans.ttf`, ORIGIN_PRESET);
      TsLog.debug(TAG, `applyFont ret:${ret}`);
      expect(ret).assertEqual(0)
    })

    it('test002_apply_ext_success', 0, async () => {
      let ret: number = await TSOhosTestManger.getTsCoreRemoteApi()
        .applyFont(`200000`, `system/fonts/penHarmony_Sans.ttf`, ORIGIN_PRESET,
          [`system/fonts/penHarmony_Sans.ttf`, `system/fonts/penHarmony_Sans.ttf`]);
      TsLog.debug(TAG, `applyFont test004 ret:${ret}`);
      expect(ret).assertEqual(0)
    })

    it('test003_apply_fontId_right', 0, async () => {
      await TSOhosTestManger.getTsCoreRemoteApi().applyFont(`200000`, `system/fonts/penHarmony_Sans.ttf`, ORIGIN_PRESET);
      let currentFontId: Nullable<string> = await ActivateThemeGetter.getCurrentFontId();
      expect(currentFontId).assertEqual(`200000`);
    })

    it('test004_apply_fontId_ext_right', 0, async () => {
      await TSOhosTestManger.getTsCoreRemoteApi().applyFont(`200000`, `system/fonts/penHarmony_Sans.ttf`, ORIGIN_PRESET,
        [`system/fonts/penHarmony_Sans.ttf`, `system/fonts/penHarmony_Sans.ttf`]);
      let currentFontId: Nullable<string> = await ActivateThemeGetter.getCurrentFontId();
      expect(currentFontId).assertEqual(`200000`);
    })

    it('test005_apply_invalid_font', 0, async () => {
      let result: number = await TSOhosTestManger.getTsCoreRemoteApi().applyFont(`200000`, `system/invalid/penHarmony_Sans.ttf`, ORIGIN_PRESET);
      expect(result).assertEqual(-1);
    })

    it('test006_apply_font_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      await AssertUtils.expectParallelInvoke(() =>
      TSOhosTestManger.getTsCoreRemoteApi().applyFont(`200000`, `system/fonts/penHarmony_Sans.ttf`, ORIGIN_PRESET));
    })

    it('test007_apply_font_ext_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      await AssertUtils.expectParallelInvoke(() =>
      TSOhosTestManger.getTsCoreRemoteApi().applyFont(`200000`, `system/fonts/penHarmony_Sans.ttf`, ORIGIN_PRESET,
        [`system/fonts/penHarmony_Sans.ttf`, `system/fonts/penHarmony_Sans.ttf`]));
    })
  })
}