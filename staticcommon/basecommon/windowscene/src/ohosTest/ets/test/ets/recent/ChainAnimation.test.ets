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
  MockKit,
  when
} from '@ohos/hypium';
import { ChainAnimation, ChainAnimationNode } from '../../../../../main/ets/recent/ChainAnimation';
import { SpringProperty } from '../../../../../main/ets/recent/SpringModel';
import systemDateTime from '@ohos.systemDateTime';
import { SpringMotion } from '../../../../../main/ets/recent/SpringMotion';

// 计算index周围需要联动的数量
const DEFAULT_CHAIN_VALUE_ACCURACY: number = 0.1;

let springProperty: SpringProperty = new SpringProperty(0,0,0)
let chainAnimation:ChainAnimation = new ChainAnimation(1, 1, 1, springProperty, 5);
let node: ChainAnimationNode = new ChainAnimationNode(1, 0, 1, 1, springProperty);


export function ChainAnimationTest() {
  describe('ChainAnimationTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('ChainAnimationNode_test', 0 ,() => {
      let chainAnimationNode: ChainAnimationNode = new ChainAnimationNode(1, 0, 1, 1, springProperty);
      expect(chainAnimationNode.index_).assertEqual(1);
      expect(chainAnimationNode.space_).assertEqual(0);
      expect(chainAnimationNode.maxSpace_).assertEqual(1);
      expect(chainAnimationNode.minSpace_).assertEqual(1);
    })

    it('ChainAnimationNode_test_setDelta', 0 ,() => {
      let delta:number = 1;
      let duration:number = 1;
      node.setDelta(delta, duration)
      expect(node.curPosition_).assertEqual(1);
    })

    it('ChainAnimationNode_test_reset', 0 ,() => {
      let value:number = 1;
      node.reset(value)
      expect(node.curPosition_).assertEqual(value);
    })

    it('ChainAnimationNode_test_getDelta', 0 ,() => {
      let value:number = 1;
      node.getDelta()
      expect(node.curPosition_).assertEqual(value);
    })

    it('ChainAnimationNode_test_tickAnimation_01', 0 ,() => {
      let duration:number = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(node, node.spring_.isCompleted);
      when(mockfunc)().afterReturn(true);
      expect(node.tickAnimation(duration)).assertFalse();
      mocker.clearAll();
    })

    it('ChainAnimationNode_test_tickAnimation_02', 0 ,() => {
      let duration:number = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(node, node.spring_.isCompleted);
      when(mockfunc)().afterReturn(false);
      expect(node.tickAnimation(duration)).assertFalse();
      mocker.clearAll();
    })

    it('ChainAnimationNode_test_setIndex', 0 ,() => {
      node.setSpace(0, 1, 1)
      expect(node.space_).assertEqual(0);
      expect(node.maxSpace_).assertEqual(1);
      expect(node.minSpace_).assertEqual(1);
    })

    it('ChainAnimationNode_test_setSpace', 0 ,() => {
      let index:number = 1;
      node.setIndex(index)
      expect(node.curPosition_).assertEqual(index);
    })

    it('ChainAnimation_test_setDelta', 0 ,() => {
      chainAnimation.setDelta(0, 0);
      chainAnimation.timestamp_ = 0;
      expect(chainAnimation.timestamp_).assertEqual(0);
    })

    it('ChainAnimation_test_getValue_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.getValue(1)).assertInstanceOf('Number');
    })

    it('ChainAnimation_test_getValue_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.getValue(-1)).assertInstanceOf('Number');
    })

    it('ChainAnimation_test_setControlIndex_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let index:number = 0;
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.setControlIndex(index, 0)).assertEqual(0);
    })

    it('ChainAnimation_test_setControlIndex_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let index:number = 1
      chainAnimation.controlIndex_ = 0;
      let delta:number = chainAnimation.getValue(index);
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.setControlIndex(index, 0)).assertEqual(delta);
    })

    it('ChainAnimation_test_setControlIndex_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let index:number = 2
      chainAnimation.controlIndex_ = 0;
      let delta:number = chainAnimation.getValue(index);
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.setControlIndex(index, 0)).assertEqual(delta);
    })

    it('ChainAnimation_test_setControlIndex_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let index:number = 3
      chainAnimation.controlIndex_ = 0;
      let delta:number = chainAnimation.getValue(index);
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.setControlIndex(index, 0)).assertEqual(delta);
    })

    it('ChainAnimation_test_setControlIndex_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let index:number = 4
      chainAnimation.controlIndex_ = 0;
      let delta:number = chainAnimation.getValue(index);
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.setControlIndex(index, 0)).assertEqual(delta);
    })

    it('ChainAnimation_test_setControlIndex_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let index:number = 5
      chainAnimation.controlIndex_ = 0;
      let delta:number = chainAnimation.getValue(index);
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.setControlIndex(index, 0)).assertEqual(delta);
    })

    it('ChainAnimation_test_setControlIndex_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let index:number = 1
      chainAnimation.controlIndex_ = 0;
      let delta:number = chainAnimation.getValue(index);
      chainAnimation.controlIndex_ = 0;
      expect(chainAnimation.setControlIndex(index, 0)).assertEqual(delta);
    })

    it('ChainAnimation_test_getControlIndex', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let controlIndex:number = 1;
      expect(chainAnimation.getControlIndex()).assertEqual(controlIndex);
    })

    it('ChainAnimation_test_setMaxIndex', 0, () => {
      chainAnimation.setMaxIndex(0)
      expect(chainAnimation.maxIndex_).assertEqual(0);
    })

    it('ChainAnimation_test_setConductivity', 0, () => {
      chainAnimation.setConductivity(0)
      expect(chainAnimation.conductivity_ === 0).assertTrue();
    })

    it('ChainAnimation_test_setIntensity', 0, () => {
      chainAnimation.setIntensity(0)
      expect(chainAnimation.intensity_ === 0).assertTrue();
    })

    it('ChainAnimation_test_setEdgeEffectIntensity', 0, () => {
      chainAnimation.setEdgeEffectIntensity(0)
      expect(chainAnimation.edgeEffectIntensity_ === 0).assertTrue();
    })

    it('ChainAnimation_test_setSpace', 0, () => {
      chainAnimation.setSpace(0, 1, 2)
      expect(chainAnimation.space_).assertEqual(0);
      expect(chainAnimation.maxSpace_).assertEqual(1);
      expect(chainAnimation.minSpace_).assertEqual(2);
    })

    it('ChainAnimation_test_tickAnimation', 0, () => {
      let timestamp:number = 0;
      let duration2 = timestamp - chainAnimation.timestamp2_
      let mocker: MockKit = new MockKit();
      let mockfunc_0_true: Function = mocker.mockFunc(node, node.tickAnimation);
      when(mockfunc_0_true)(duration2).afterReturn(true);
      expect(node.tickAnimation(duration2)).assertTrue();
      let mockfunc_0_false: Function = mocker.mockFunc(node, node.tickAnimation);
      when(mockfunc_0_false)(duration2).afterReturn(false);
      expect(node.tickAnimation(duration2)).assertFalse();
      timestamp = 1;
      let mockfunc_true: Function = mocker.mockFunc(node, node.tickAnimation);
      when(mockfunc_true)(duration2).afterReturn(true);
      expect(node.tickAnimation(duration2)).assertTrue();
      let mockfunc_false: Function = mocker.mockFunc(node, node.tickAnimation);
      when(mockfunc_false)(duration2).afterReturn(false);
      expect(node.tickAnimation(duration2)).assertFalse();
      mocker.clearAll();
    })
  })
}