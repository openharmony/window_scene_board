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

import curves from '@ohos.curves';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it
} from '@ohos/hypium';
import { StyleConstants } from '@ohos/launchercommon';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { AiSuggestionAnimHelper } from '../../../../../../main/ets/default/animation/AiSuggestionAnimHelper';

/**
 * 多尺寸动画参数测试
 */
export default function AiSuggestionAnimHelperTest() {
  describe('AiSuggestionAnimHelperTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('assertScaleDimension_1_2', 0, () => {
      let targetScale: number = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
      let dimension = FormDimension.Dimension_1_2;
      expect(targetScale).assertEqual(AiSuggestionAnimHelper.getScaleByDimension(dimension, false));
    });

    it('assertScaleDimension_2_1', 0, () => {
      let targetScale: number = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
      let dimension = FormDimension.Dimension_2_1;
      expect(targetScale).assertEqual(AiSuggestionAnimHelper.getScaleByDimension(dimension, false));
    });

    it('assertScaleDimension_2_2', 0, () => {
      let targetScale: number = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
      let dimension = FormDimension.Dimension_2_2;
      expect(targetScale).assertEqual(AiSuggestionAnimHelper.getScaleByDimension(dimension, false));
    });

    it('assertScaleDimension_2_4', 0, () => {
      let targetScale: number = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
      let dimension = FormDimension.Dimension_2_4;
      expect(targetScale).assertEqual(AiSuggestionAnimHelper.getScaleByDimension(dimension, false));
    });

    it('assertScaleDimension_4_4', 0, () => {
      let targetScale: number = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
      let dimension = FormDimension.Dimension_4_4;
      expect(targetScale).assertEqual(AiSuggestionAnimHelper.getScaleByDimension(dimension, false));
    });

    it('assertScaleDimensionInvalid', 0, () => {
      let targetScale: number = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
      let dimension = -1;
      expect(targetScale).assertEqual(AiSuggestionAnimHelper.getScaleByDimension(dimension, false));
    });

    it('assertCurveDimension_1_2', 0, () => {
      let targetCurve: number = curves.interpolatingSpring(1, 1, 410, 38).interpolate(1);
      let dimension = FormDimension.Dimension_1_2;
      expect(targetCurve).assertEqual(AiSuggestionAnimHelper.getCurveByDimension(dimension).interpolate(1));
    });

    it('assertCurveDimension_2_1', 0, () => {
      let targetCurve: number = curves.interpolatingSpring(1, 1, 410, 38).interpolate(1);
      let dimension = FormDimension.Dimension_2_1;
      expect(targetCurve).assertEqual(AiSuggestionAnimHelper.getCurveByDimension(dimension).interpolate(1));
    });

    it('assertCurveDimension_2_2', 0, () => {
      let targetCurve: number = curves.interpolatingSpring(0.5, 1, 350, 35).interpolate(1);
      let dimension = FormDimension.Dimension_2_2;
      expect(targetCurve).assertEqual(AiSuggestionAnimHelper.getCurveByDimension(dimension).interpolate(1));
    });

    it('assertCurveDimension_2_4', 0, () => {
      let targetCurve: number = curves.interpolatingSpring(0.5, 1, 350, 35).interpolate(1);
      let dimension = FormDimension.Dimension_2_4;
      expect(targetCurve).assertEqual(AiSuggestionAnimHelper.getCurveByDimension(dimension).interpolate(1));
    });

    it('assertCurveDimension_4_4', 0, () => {
      let targetCurve: number = curves.interpolatingSpring(0, 1, 240, 28).interpolate(1);
      let dimension = FormDimension.Dimension_4_4;
      expect(targetCurve).assertEqual(AiSuggestionAnimHelper.getCurveByDimension(dimension).interpolate(1));
    });

    it('assertCurveDimensionInvalid', 0, () => {
      let targetCurve: number = curves.interpolatingSpring(0, 1, 240, 28).interpolate(1);
      let dimension = -1;
      expect(targetCurve).assertEqual(AiSuggestionAnimHelper.getCurveByDimension(dimension).interpolate(1));
    });

    it('assertGetTransition_nullItem', 0, () => {
      let item: LauncherRecItem = new LauncherRecItem();
      let index: number = 0;
      let changedItemIdsSet: Set<string> = new Set();
      changedItemIdsSet.add('123');
      expect(TransitionEffect.IDENTITY === AiSuggestionAnimHelper.getTransition(item, index, changedItemIdsSet, 0))
        .assertEqual(false);
    });

    it('assertGetTransition_nullIndex', 0, () => {
      let item: LauncherRecItem = new LauncherRecItem();
      let index: number = -1;
      let changedItemIdsSet: Set<string> = new Set();
      changedItemIdsSet.add('123');
      expect(TransitionEffect.IDENTITY === AiSuggestionAnimHelper.getTransition(item, index, changedItemIdsSet, 0))
        .assertEqual(false);
    });

    it('assertGetTransition_AiSuggestionLauncherRecItem', 0, () => {
      let item: LauncherRecItem = new LauncherRecItem();
      item.bundleName = '';
      let index: number = 0;
      let changedItemIdsSet: Set<string> = new Set();
      changedItemIdsSet.add('123');
      expect(TransitionEffect.IDENTITY === AiSuggestionAnimHelper.getTransition(item, index, changedItemIdsSet, 0))
        .assertEqual(false);
    });

    it('assertGetTransition_nullChangedItemIdsSet', 0, () => {
      let item: LauncherRecItem = new LauncherRecItem();
      let index: number = 0;
      let changedItemIdsSet: Set<string> = new Set();
      expect(TransitionEffect.IDENTITY === AiSuggestionAnimHelper.getTransition(item, index, changedItemIdsSet, 0))
        .assertEqual(false);
    });

    it('assertGetTransition_AppTransitionEffect', 0, () => {
      let item: LauncherRecItem = new LauncherRecItem();
      item.itemType = AiSuggestionConstants.TYPE_APP;
      let index: number = 0;
      let changedItemIdsSet: Set<string> = new Set();
      changedItemIdsSet.add('123');
      expect(TransitionEffect.IDENTITY !== AiSuggestionAnimHelper.getTransition(item, index, changedItemIdsSet, 0))
        .assertEqual(true);
    });

    it('assertGetTransition_FormTransitionEffect', 0, () => {
      let item: LauncherRecItem = new LauncherRecItem();
      item.itemType = AiSuggestionConstants.TYPE_CARD;
      let index: number = 0;
      let changedItemIdsSet: Set<string> = new Set();
      changedItemIdsSet.add('123');
      expect(TransitionEffect.IDENTITY !== AiSuggestionAnimHelper.getTransition(item, index, changedItemIdsSet, 0))
        .assertEqual(true);
    });
  });
}