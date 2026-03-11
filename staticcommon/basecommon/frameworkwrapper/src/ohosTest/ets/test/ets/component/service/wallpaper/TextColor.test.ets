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

import { it, describe, expect, Level } from '@ohos/hypium';
import { TextColor } from '../../../../../../../main/ets/service/wallpaper/TextColor';
import { WallpaperConstants } from '@ohos/commonconstants';
import effectKit from '@ohos.effectKit';

export function TextColorTest() {
  describe('TextColorTest', (): void => {
    it('TextColorTest_test_getInstance_should_not_null', Level.LEVEL0, (): void => {
      let instance1: TextColor = new TextColor('red', WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
        WallpaperConstants.ALPHA_0, 1);
      expect(instance1.mTextColor).assertEqual('red');

      let color: effectKit.Color = {
        red: 255,
        green: 255,
        blue: 255,
        alpha: 0
      };
      let instance2: TextColor =
        new TextColor(color, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_0, 1);
      expect(instance2.mTextColor).assertEqual('#ffffff');
    })
  })
}