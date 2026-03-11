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

import WallpaperConstants from '@ohos/commonconstants/src/main/ets/constants/WallpaperConstants';
import { describe, beforeEach, afterEach, it, expect, Level } from '@ohos/hypium';
import { GrayscaleUtil } from '../../../../../../main/ets/utils/GrayscaleUtil';

export function GrayscaleUtilTest() {
  describe('GrayscaleUtilTest', () => {
    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_calculate_grayscale_correctly_when_all_values_are_valid', Level.LEVEL0, () => {
      const result = GrayscaleUtil.calGrayscale(10, 20, 30, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}281f2933`);
    });

    it('should_calculate_grayscale_correctly_when_alpha_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil.calGrayscale(10, 20, 30, 0);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}001f2933`);
    });

    it('should_calculate_grayscale_correctly_when_red_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil.calGrayscale(0, 20, 30, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}28182c36`);
    });

    it('should_calculate_grayscale_correctly_when_green_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil.calGrayscale(10, 0, 30, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}282a203e`);
    });

    it('should_calculate_grayscale_correctly_when_blue_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil.calGrayscale(10, 20, 0, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}28222c18`);
    });

    it('should_return_correct_color_when_all_values_are_valid', Level.LEVEL0, () => {
      const result = GrayscaleUtil['convertRGBA2ResourceColor'](10, 20, 30, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}280a141e`);
    });

    it('should_return_correct_color_when_alpha_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil['convertRGBA2ResourceColor'](10, 20, 30, 0);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}000a141e`);
    });

    it('should_return_correct_color_when_red_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil['convertRGBA2ResourceColor'](0, 20, 30, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}2800141e`);
    });

    it('should_return_correct_color_when_green_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil['convertRGBA2ResourceColor'](10, 0, 30, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}280a001e`);
    });

    it('should_return_correct_color_when_blue_is_zero', Level.LEVEL0, () => {
      const result = GrayscaleUtil['convertRGBA2ResourceColor'](10, 20, 0, 40);
      expect(result)
        .assertEqual(`${WallpaperConstants.COLOR_PREFIX}280a1400`);
    });

  })
}