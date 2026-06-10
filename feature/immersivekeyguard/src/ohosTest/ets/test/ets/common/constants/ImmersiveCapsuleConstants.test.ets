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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { ImmersiveCapsuleConstants } from '../../../../../../main/ets/common/constants/ImmersiveCapsuleConstants';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCapsuleConstantsTest() {
  describe('ImmersiveCapsuleConstantsTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('getIconAreaSpecs', Level.LEVEL0, (): void => {
      let specs = ImmersiveCapsuleConstants.getIconAreaSpecs();
      expect(specs).not().assertNull();
    });

    it('getCapsuleHeight', Level.LEVEL0, (): void => {
      let specs = ImmersiveCapsuleConstants.getCapsuleHeight();
      expect(specs).not().assertNull();
    });

    it('getMainTextFontSize', Level.LEVEL0, (): void => {
      let size = ImmersiveCapsuleConstants.getMainTextFontSize();
      expect(size).not().assertNull();
    });

    it('getIconColor', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getIconColor();
      expect(color).not().assertNull();
    });

    it('test_getTextAreaWidth', Level.LEVEL0, (): void => {
      let width = ImmersiveCapsuleConstants.getTextAreaWidth();
      expect(width).not().assertNull();
    });

    it('test_getTextAreaWidth_expand', Level.LEVEL0, (): void => {
      let width = ImmersiveCapsuleConstants.getTextAreaWidth(true);
      expect(width).not().assertNull();
    });

    it('test_getMainTextFontColor', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getMainTextFontColor();
      expect(color).not().assertNull();
    });

    it('test_getMainTextFontColor_Light', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getMainTextFontColor(true);
      expect(color).not().assertNull();
    });

    it('test_getDefaultFontColor', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getDefaultFontColor();
      expect(color).not().assertNull();
    });

    it('test_getDefaultFontColor_Light', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getDefaultFontColor(true);
      expect(color).not().assertNull();
    });

    it('test_getSecondaryTextFontSize', Level.LEVEL0, (): void => {
      let fontSize = ImmersiveCapsuleConstants.getSecondaryTextFontSize();
      expect(fontSize).not().assertNull();
    });

    it('test_getSecondaryTextFontColor', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getSecondaryTextFontColor();
      expect(color).not().assertNull();
    });

    it('test_getSecondaryTextFontColor_Light', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getSecondaryTextFontColor(true);
      expect(color).not().assertNull();
    });

    it('test_getCapsuleBlur', Level.LEVEL0, (): void => {
      let blur = ImmersiveCapsuleConstants.getCapsuleBlur();
      expect(blur).not().assertNull();
    });

    it('test_getCapsuleBlur_Light', Level.LEVEL0, (): void => {
      let blur = ImmersiveCapsuleConstants.getCapsuleBlur(true);
      expect(blur).not().assertNull();
    });

    it('test_getProgressBackgroundColor', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getProgressBackgroundColor();
      expect(color).not().assertNull();
    });

    it('test_getProgressBackgroundColor_Light', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getProgressBackgroundColor(true);
      expect(color).not().assertNull();
    });

    it('test_getProgressColor', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getProgressColor();
      expect(color).not().assertNull();
    });

    it('test_getProgressColor_Light', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getProgressColor(true);
      expect(color).not().assertNull();
    });

    it('test_getButtonBackground', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getButtonBackground();
      expect(color).not().assertNull();
    });

    it('test_getButtonColor', Level.LEVEL0, (): void => {
      let color = ImmersiveCapsuleConstants.getButtonColor();
      expect(color).not().assertNull();
    });

    it('test_getShadeEffect', Level.LEVEL0, (): void => {
      let shadeEffect = ImmersiveCapsuleConstants.getShadeEffect();
      expect(shadeEffect).not().assertNull();
    });

    it('test_getShadeEffect_Light', Level.LEVEL0, (): void => {
      let shadeEffect = ImmersiveCapsuleConstants.getShadeEffect(true);
      expect(shadeEffect).not().assertNull();
    });

    it('test_getCapsuleBrightEffect', Level.LEVEL0, (): void => {
      ImmersiveCapsuleConstants.getCapsuleBrightEffect(true, true);
      ImmersiveCapsuleConstants.getCapsuleBrightEffect(true, false);
      ImmersiveCapsuleConstants.getCapsuleBrightEffect(false, false);
      ImmersiveCapsuleConstants.getCapsuleBrightEffect(false, true);
      expect(ImmersiveCapsuleConstants).not().assertNull();
    });

    it('test_getCapsuleTextBrightEffect', Level.LEVEL0, (): void => {
      ImmersiveCapsuleConstants.getCapsuleTextBrightEffect(true, true);
      ImmersiveCapsuleConstants.getCapsuleTextBrightEffect(true, false);
      ImmersiveCapsuleConstants.getCapsuleTextBrightEffect(false, false);
      ImmersiveCapsuleConstants.getCapsuleTextBrightEffect(false, true);
      expect(ImmersiveCapsuleConstants).not().assertNull();
    });

    it('test_getCapsuleExtendBrightEffect', Level.LEVEL0, (): void => {
      ImmersiveCapsuleConstants.getCapsuleExtendBrightEffect(true);
      ImmersiveCapsuleConstants.getCapsuleExtendBrightEffect(false);
      ImmersiveCapsuleConstants.getCapsuleExtendBrightEffect(undefined);
      expect(ImmersiveCapsuleConstants).not().assertNull();
    });
  });
}