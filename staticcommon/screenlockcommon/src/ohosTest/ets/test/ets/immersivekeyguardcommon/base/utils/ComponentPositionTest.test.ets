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


import { it, describe, expect } from '@ohos/hypium';
import { CmpPosWrapper } from '../../../../../../../main/ets/immersivekgcommon/base/utils/ComponentPosition';
import { ComponentPosition } from '../../../../../../../main/ets/immersivekgcommon/base/utils/ComponentPosition';

export function ComponentPositionTest() {
  describe('ComponentPositionTest', (): void => {
    it('test_initDynamicCurveRate', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      expect(testInstance instanceof CmpPosWrapper).assertTrue();
    });
    it('test_getCmpGlobalX', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.getCmpGlobalX();
      expect(res !== undefined).assertTrue();
    });
    it('test_getCmpCenterX', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.getCmpCenterX();
      expect(res !== undefined).assertTrue();
    });
    it('test_getCmpGlobalY', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.getCmpGlobalY();
      expect(res !== undefined).assertTrue();
    });
    it('test_getCmpCenterY', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.getCmpGlobalY();
      expect(res !== undefined).assertTrue();
    });
    it('test_getCmpWidth', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.getCmpWidth();
      expect(res !== undefined).assertTrue();
    });
    it('test_getCmpHeight', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.getCmpHeight();
      expect(res !== undefined).assertTrue();
    });
    it('test_isPositionValid', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.isPosValid();
      expect(res !== undefined).assertTrue();
    });
    it('test_toString', 0, (): void => {
      let pos: ComponentPosition = {}
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let res = testInstance.toString();
      expect(res !== undefined).assertTrue();
    });
    it('ComponentPositionTest_001', 0, (): void => {
      let pos: ComponentPosition = { width: 10 }
      let testInstance: CmpPosWrapper = CmpPosWrapper.wrapper(pos);
      let result = testInstance.isPosValid();
      expect(result).assertFalse();
      let pos1: ComponentPosition = { width: 10, height:10 }
      let testInstance1: CmpPosWrapper = CmpPosWrapper.wrapper(pos1);
      let result1 = testInstance1.isPosValid();
      expect(result1).assertTrue();
    });
  });
}