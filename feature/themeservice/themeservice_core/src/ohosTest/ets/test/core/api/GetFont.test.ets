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
import { describe, expect, it } from '@ohos/hypium'
import { FontInfo as FontInfo1} from '../../../../../main/ets/service/model/FontInfo'
import { FontInfo as FontInfo2} from '@ohos/themeservice_inner_api/src/main/ets/model/FontInfo'
import { NullableType } from '@ohos/themeservicebase'
import { PresetThemeExtCache } from '../../../../../main/ets/cache/PresetThemeCache'
import { TSOhosTestManger } from '../../../core/TSOhosTestManger'

export default function GetFontTest() {

  describe('GetFontTest', () => {
    it('test001_getFont', 0,async () => {
      const defaultFont: NullableType<FontInfo1> = await PresetThemeExtCache.getInstance().getDefaultFont();
      expect(defaultFont).not().assertUndefined();
      await TSOhosTestManger.getTsCoreRemoteApi().applyFont(defaultFont!.id, defaultFont!.ttfFileSrc, defaultFont!.origin);
      let curFont: NullableType<FontInfo2> = await TSOhosTestManger.getTsCoreRemoteApi().getCurrentFont();
      expect(curFont?.id).assertEqual(defaultFont!.id);
      expect(defaultFont?.multiWeight).assertUndefined();
      expect(curFont?.multiWeight).assertTrue()
    })
  })

}