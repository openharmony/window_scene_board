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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { SwiperLoadData } from '../../../../../../../main/ets/service/swiperData/SwiperLoadData'

export default function SwiperLoadDataTest() {
  describe('SwiperLoadDataTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('SwiperLoadData_getIndexBySwiperKey_text1', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3];
      let result: number = instance.getIndexBySwiperKey(3);
      expect(result).assertEqual(2)
    })
    it('SwiperLoadData_getIndexBySwiperKey_text2', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3];
      let result: number = instance.getIndexBySwiperKey(4);
      expect(result).assertEqual(-1)
    })
    it('SwiperLoadData_getSwiperKeyByIndex_text1', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3];
      let result: number = instance.getSwiperKeyByIndex(4);
      expect(result).assertEqual(-1)
    })
    it('SwiperLoadData_getSwiperKeyByIndex_text2', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3];
      let result: number = instance.getSwiperKeyByIndex(2);
      expect(result).assertEqual(3)
    })
    it('SwiperLoadData_getNeighborSwiperKey_text1', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4, 5, 6];
      let result: number = instance.getNeighborSwiperKey(2);
      expect(result).assertEqual(1)
    })
    it('SwiperLoadData_getNeighborSwiperKey_text2', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4];
      let mocker: MockKit = new MockKit();
      let result: number = instance.getNeighborSwiperKey(3);
      expect(result).assertEqual(4)
    })
    it('SwiperLoadData_addBlankPageMiddle_text1', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4];
      let result: number = instance.addBlankPageMiddle(2, 0);
      expect(instance).not().assertUndefined();
    })
    it('SwiperLoadData_addBlankPageMiddle_text2', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4];
      let result: number = instance.addBlankPageMiddle(4, 0);
      expect(result).assertEqual(-2)
    })
    it('SwiperLoadData_addBlankPageMiddle_text3', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4];
      let result: number = instance.addBlankPageMiddle(2, 2);
      expect(instance).not().assertUndefined();
    })
    it('SwiperLoadData_refreshPages_text1', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4];
      expect(instance.refreshPages(4) == null).assertTrue()
    })
    it('SwiperLoadData_refreshPages_text2', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4];
      expect(instance.refreshPages(3) == null).assertTrue()
    })
    it('SwiperLoadData_refreshPages_text3', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['pages'] = [1, 2, 3, 4];
      expect(instance.refreshPages(6) == null).assertTrue()
    })
    it('SwiperLoadData_updatePageMaxValue_text1', 0, () => {
      let instance: SwiperLoadData = SwiperLoadData.getInstance();
      expect(instance !== null).assertTrue();
      (instance as object)['maxValue'] = 2;
      (instance as object)['pages'] = [1, 2, 3, 4];
      let result: object = (instance as object)['updatePageMaxValue']();
      expect(result == null).assertTrue();
    })
  })
}