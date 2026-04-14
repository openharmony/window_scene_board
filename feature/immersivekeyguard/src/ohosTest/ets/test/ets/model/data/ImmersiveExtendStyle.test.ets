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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { ImmersiveExtendStyle } from '../../../../../../main/ets/model/data/ImmersiveExtendStyle';

export function ImmersiveExtendStyleTest() {
  describe('ImmersiveExtendStyleTest', (): void => {
    beforeAll((): void => {

    });

    beforeEach((): void => {

    });

    afterAll((): void => {

    });

    afterEach((): void => {

    });

    it('ImmersiveExtendStyle_extendWidth', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.extendWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_extendHeight', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.extendHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextWidth', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextHeight', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextMaxFont', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextMaxFont).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextMinFont', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextMinFont).not().assertNull();
    });

    it('ImmersiveExtendStyle_textColor', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.textColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonWidth', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonMaxWidth', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonMaxWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonHeight', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonTextHeight', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonTextHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonTopMargin', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonTopMargin).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonLeftMargin', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonLeftMargin).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleBackgroundColor', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleBackgroundColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonSpace', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonSpace).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonHeight', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonLength', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonLength).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonBorderRadius', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonBorderRadius).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonBackground', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonBackground).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonColor', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressHeight', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressWidth', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressStrokeWidth', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressStrokeWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressBackgroundColor', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressBackgroundColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressColor', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_extendWidth02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.extendWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_extendHeight02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.extendHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextWidth02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextHeight02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextMaxFont02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextMaxFont).not().assertNull();
    });

    it('ImmersiveExtendStyle_normalTextMinFont02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.normalTextMinFont).not().assertNull();
    });

    it('ImmersiveExtendStyle_textColor02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.textColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonWidth02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonMaxWidth02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonMaxWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonHeight02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonTextHeight02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonTextHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonTopMargin02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonTopMargin).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleButtonLeftMargin02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleButtonLeftMargin).not().assertNull();
    });

    it('ImmersiveExtendStyle_capsuleBackgroundColor02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.capsuleBackgroundColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonSpace02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonSpace).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonHeight02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonLength02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonLength).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonBorderRadius02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonBorderRadius).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonBackground02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonBackground).not().assertNull();
    });

    it('ImmersiveExtendStyle_buttonColor02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.buttonColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressHeight02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressHeight).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressWidth02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressStrokeWidth02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressStrokeWidth).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressBackgroundColor02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressBackgroundColor).not().assertNull();
    });

    it('ImmersiveExtendStyle_progressColor02', Level.LEVEL1, (): void => {
      let immersiveExtendStyle = new ImmersiveExtendStyle();
      expect(immersiveExtendStyle.progressColor).not().assertNull();
    });
  });
}