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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { AnimationManager } from '../../../../../main/ets/common/AnimationManager';

export default function AnimationManagerTest() {
  describe('AnimationManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('TEXT_EFFECT_ANIMATION', 0, () => {
      const textEffect = AnimationManager.TEXT_EFFECT_ANIMATION;
      expect(textEffect === undefined).assertFalse();
    })
    it('TEXT_FINAL_EFFECT_ANIMATION', 0, () => {
      const clickTextEffect = AnimationManager.TEXT_FINAL_EFFECT_ANIMATION;
      expect(clickTextEffect === undefined).assertFalse();
    })
    it('INITIAL_REBOOT_TRANSITION', 0, () => {
      const rebootEffect = AnimationManager.INITIAL_REBOOT_TRANSITION;
      expect(rebootEffect === undefined).assertFalse();
    })
    it('INITIAL_POWER_OFF_TRANSITION', 0, () => {
      const powerOffEffect = AnimationManager.INITIAL_POWER_OFF_TRANSITION;
      expect(powerOffEffect === undefined).assertFalse();
    })
    it('TEXT_TIPS_TRANSITION', 0, () => {
      const tipEffect = AnimationManager.TEXT_TIPS_TRANSITION;
      expect(tipEffect === undefined).assertFalse();
    })
    it('SCALE_ANIMATION', 0, () => {
      const scaleAttr = AnimationManager.SCALE_ANIMATION;
      expect(scaleAttr === undefined).assertFalse();
    })
    it('REBOOT_TRANSITION', 0, () => {
      const rebootTrans = AnimationManager.REBOOT_TRANSITION;
      expect(rebootTrans === undefined).assertFalse();
    })
    it('POWER_OFF_TRANSITION', 0, () => {
      const powerTrans = AnimationManager.POWER_OFF_TRANSITION;
      expect(powerTrans === undefined).assertFalse();
    })
    it('INITIAL_TEXT_MARGIN', 0, () => {
      const margin = AnimationManager.INITIAL_TEXT_MARGIN;
      expect(margin === 0).assertFalse();
    })
    it('TEXT_MARGIN', 0, () => {
      const textMargin = AnimationManager.TEXT_MARGIN;
      expect(textMargin === 0).assertFalse();
    })
    it('CLICK_ANIMATION', 0, () => {
      try {
        let helper = () => {
          AnimationManager.CLICK_ANIMATION;
          throw new Error('clickAnimation');
        }
        expect(helper()).assertThrowError('clickAnimation');
      } catch (e) {
      }
    })
  })
}