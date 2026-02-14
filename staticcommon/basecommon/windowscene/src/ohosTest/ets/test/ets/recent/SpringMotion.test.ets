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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  TestType,
  Size,
  Level,
  when,
  ArgumentMatchers,
  MockKit } from '@ohos/hypium';
import { SpringMotion } from '../../../../../main/ets/recent/SpringMotion';
import { SpringModel, SpringProperty, SpringModelType } from '../../../../../main/ets/recent/SpringModel';

export function SpringMotionTest() {
  describe('SpringMotionTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let springProperty: SpringProperty = new SpringProperty(0, 0, 0)
    let springMotion:SpringMotion = new SpringMotion(1, 1, 1, springProperty);

    it('SpringMotion_test_move_01', 0, (): void => {
      springMotion.model_ = SpringModel.build(1, 1, null);
      springMotion.move(1);
      expect(springMotion.model_).assertEqual(undefined);
    })

    it('SpringMotion_test_move_02', 0, (): void => {
      springMotion.model_ = SpringModel.build(1, 1, new SpringProperty(1, 1, 1));
      let mocker: MockKit = new MockKit();
      let isCompleted: Function = mocker.mockFunc(springMotion, springMotion.isCompleted);
      when(isCompleted)(ArgumentMatchers.any).afterReturn(true);
      springMotion.move(1);
      expect(springMotion.currentVelocity_).assertEqual(0.0);
      mocker.clearAll();
    })

    it('SpringMotion_test_move_03', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let isCompleted: Function = mocker.mockFunc(springMotion, springMotion.isCompleted);
      when(isCompleted)(ArgumentMatchers.any).afterReturn(false);
      springMotion.move(1);
      expect(springMotion.isCompleted()).assertFalse();
      mocker.clearAll();
    })

    it ('SpringMotion_test_getType_01', 0, (): void => {
      springMotion.model_ = SpringModel.build(1, 1, null);
      expect(springMotion.getType()).assertEqual(SpringModelType.CRITICAL_DAMPED);
    })

    it ('SpringMotion_test_getType_02', 0, (): void => {
      springMotion.model_ = SpringModel.build(1, 1, new SpringProperty(1, 1, 1));
      expect(springMotion.getType()).assertEqual(SpringModelType.UNDER_DAMPED);
    })

    it('SpringMotion_test_getCurrentPosition', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      springMotion.currentPosition_ = 1;
      expect(springMotion.getCurrentPosition()).assertEqual(1);
    })

    it('SpringMotion_test_getCurrentVelocity', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      springMotion.currentVelocity_ = 1;
      expect(springMotion.getCurrentVelocity()).assertEqual(1);
    })

    it('SpringMotion_test_getEndValue', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      springMotion.endPosition_ = 1;
      expect(springMotion.getEndValue()).assertEqual(1);
    })

    it('SpringMotion_test_isCompleted2_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      springMotion.accuracy_ = 1;
      springMotion.endPosition_ = 0;
      expect(springMotion.isCompleted2(0, 0)).assertTrue();
    })

    it('SpringMotion_test_isCompleted2_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      springMotion.accuracy_ = 1;
      springMotion.endPosition_ = 0;
      expect(springMotion.isCompleted2(0, 1)).assertFalse();
    })

    it('SpringMotion_test_isCompleted2_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      springMotion.accuracy_ = 1;
      springMotion.endPosition_ = 0;
      expect(springMotion.isCompleted2(1, 0)).assertFalse();
    })

    it('SpringMotion_test_setAccuracy', 0 , ()=> {
      springMotion.setAccuracy(0)
      expect(springMotion.accuracy_).assertEqual(0);
    })

    it('SpringMotion_test_reset', 0 , ()=> {
      springMotion.reset(0, 0, 0, springProperty)
      expect(springMotion.currentPosition_).assertEqual(0);
      expect(springMotion.currentVelocity_).assertEqual(0);
      expect(springMotion.endPosition_).assertEqual(0);
    })
  })
}