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
import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { LiveUseScene } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationAnimationParas } from '../../../main/ets/common/NotificationAnimationParas';
import { NotificationConstants } from '../../../main/ets/common/NotificationConstants';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NotificationType } from '../../../main/ets/common/NotificationType';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfScrollAnimation } from '../../../main/ets/animation/NtfScrollAnimation';
export default function NtfScrollAnimationTest() {
  describe('getCorrectPositionYDiff_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_animationPara_is_undefined_or_clearAnimOpacity_is_0', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let result = ntfscrollanimation.getCorrectPositionYDiff(0, undefined, positionYDiff);
      expect(result).assertEqual(positionYDiff);

      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 0;
      result = ntfscrollanimation.getCorrectPositionYDiff(0, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_plus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_greater_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = 1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY + 1);
      });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_ntfItemTranslateY_minus_1_when_checkIsTranslateYInvalid_is_true_and_itemScrollOffset_is_less_than_0',
      0, () => {
        let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
        let positionYDiff: number = 10;
        let itemScrollOffset: number = -1;
        let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
        animationPara.clearAnimOpacity = 1;
        animationPara.ntfItemTranslateY = 5;
        let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
        expect(result).assertEqual(animationPara.ntfItemTranslateY - 1);
      });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });

    it('should_return_positionYDiff_when_checkIsTranslateYInvalid_is_false', 0, () => {
      let ntfscrollanimation: NtfScrollAnimation = new NtfScrollAnimation();
      let positionYDiff: number = 10;
      let itemScrollOffset: number = 0;
      let animationPara: NotificationAnimationParas = new NotificationAnimationParas();
      animationPara.clearAnimOpacity = 1;
      animationPara.ntfItemTranslateY = 5;
      let result = ntfscrollanimation.getCorrectPositionYDiff(itemScrollOffset, animationPara, positionYDiff);
      expect(result).assertEqual(positionYDiff);
    });
  });
}