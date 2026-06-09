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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  ForceType,
  GravityAnimationAlgorithm,
  GravityAnimationParameter } from '../../../../../../../../../main/ets/service/animator/gravity/algorithm/algorithm/GravityAnimationAlgorithm';

/**
 * GravityAnimationAlgorithm DT测试套，只做基本流程的覆盖。完整功能在场景用例，也就是GravityAnimationManager中构造场景覆盖。
 */
export function GravityAnimationAlgorithmTest() {
  describe('GravityAnimationAlgorithmTest', (): void => {
    let alg = new GravityAnimationAlgorithm(10, 10, ForceType.REPULSION, [1, 1]);
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('GravityAnimationAlgorithm_generateParameter_001', Level.LEVEL0, (): void => {
      let left = alg.generateParameter(9, 10);
      let right = alg.generateParameter(11, 10);
      let top = alg.generateParameter(10, 9);
      let bottom = alg.generateParameter(10, 11);
      let out = alg.generateParameter(10000, 10000);

      expect(left.effected).assertTrue();
      expect(right.effected).assertTrue();
      expect(top.effected).assertTrue();
      expect(bottom.effected).assertTrue();
      expect(out.effected).assertFalse();
    })

    it('GravityAnimationAlgorithm_generateParameter_002', Level.LEVEL0, (): void => {
      let left = alg.generateParameter(9, 10);
      let right = alg.generateParameter(11, 10);
      let top = alg.generateParameter(10, 9);
      let bottom = alg.generateParameter(10, 11);
      let nearestDelay = left.delay;

      expect(right.delay).assertEqual(nearestDelay);
      expect(top.delay).assertEqual(nearestDelay);
      expect(bottom.delay).assertEqual(nearestDelay);
    })

    it('GravityAnimationAlgorithm_generateParameter_003', Level.LEVEL0, (): void => {
      let left = alg.generateParameter(9, 10);

      expect(left.now.x).assertEqual(9);
      expect(left.now.y).assertEqual(10);
    })

    it('GravityAnimationAlgorithm_generateParameter_004', Level.LEVEL0, (): void => {
      let left = alg.generateParameter(9, 10);
      let out = alg.generateParameter(10000, 10000);

      expect(alg.parameterToString(left).length).assertLarger(0);
      expect(alg.parameterToString(out).length).assertLarger(0);
    })

    it('GravityAnimationAlgorithm_adjustParameter_001', Level.LEVEL0, (): void => {
      let left = alg.generateParameter(9, 10);
      let right = alg.generateParameter(11, 10);
      let top = alg.generateParameter(10, 9);
      let bottom = alg.generateParameter(10, 11);
      /* 按照规则，距离引力点不大于这个范围的元素不受引力影响，因此center不受影响 */
      let center = alg.generateParameter(10, 10);
      let out = alg.generateParameter(10000, 10000);
      let nearestDelay = left.delay;
      let array = new Array<GravityAnimationParameter>();

      array.push(left);
      array.push(right);
      array.push(out);
      array.push(top);
      array.push(bottom);
      array.push(center);

      alg.adjustParameter(new Array<GravityAnimationParameter>());
      alg.adjustParameter(array);

      expect(center.effected).assertFalse();
      /* center不是最近点，所以left/right/top/bottom 均是最近点，delay为0 */
      expect(left.delay).assertLess(nearestDelay);
      expect(left.delay).assertEqual(0);
      expect(right.delay).assertEqual(0);
      expect(top.delay).assertEqual(0);
      expect(bottom.delay).assertEqual(0);
    })

    it('GravityAnimationAlgorithm_adjustParameter_002', Level.LEVEL0, (): void => {
      let left = alg.generateParameter(9, 10);
      let right = alg.generateParameter(11, 10);
      let top = alg.generateParameter(10, 9);
      let bottom = alg.generateParameter(10, 11);
      /* 一定偏移后，这个点是受到影响的 */
      let center = alg.generateParameter(10.1, 10.1);
      let out = alg.generateParameter(10000, 10000);
      let nearestDelay = left.delay;
      let array = new Array<GravityAnimationParameter>();

      array.push(left);
      array.push(right);
      array.push(out);
      array.push(top);
      array.push(bottom);
      array.push(center);

      alg.adjustParameter(new Array<GravityAnimationParameter>());
      alg.adjustParameter(array);

      expect(center.effected).assertTrue();
      expect(center.delay).assertEqual(0);
      expect(left.delay).assertLess(nearestDelay);
      expect(right.delay).assertLess(nearestDelay);
      expect(top.delay).assertLess(nearestDelay);
      expect(bottom.delay).assertLess(nearestDelay);
    })
  })
}