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
import { BaseServiceStubUtils } from '../../../../../../main/ets/utils/BaseServiceStubUtils'
import rpc from '@ohos.rpc'

export default function BaseServiceStubUtilsTest() {
  describe('BaseServiceStubUtilsTest', () => {
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
    it('BaseServiceStubUtils_writeStringInNormal_01', 0, () => {
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      let result: Boolean = BaseServiceStubUtils.writeStringInNormal(data, '');
      expect(result).assertFalse();
    })

    it('BaseServiceStubUtils_writeStringInNormal_02', 0, () => {
      let data = null;
      let result: Boolean = BaseServiceStubUtils.writeStringInNormal(data, '');
      expect(result).assertFalse();
    })

    it('BaseServiceStubUtils_writeStringInNormal_03', 0, () => {
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      let result: Boolean = BaseServiceStubUtils.writeStringInNormal(data, '1');
      expect(result).assertTrue();
    })

    it('BaseServiceStubUtils_getRemoteString_01', 0, () => {
      let data = null;
      let result: string = BaseServiceStubUtils.getRemoteString(data);
      expect(result).assertEqual('');
    })

    it('BaseServiceStubUtils_getRemoteString_02', 0, () => {
      let baseServiceStubUtils: BaseServiceStubUtils = new BaseServiceStubUtils();
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      let result: string = BaseServiceStubUtils.getRemoteString(data);
      expect(baseServiceStubUtils).not().assertUndefined();
    })

    it('BaseServiceStubUtils_getRemoteObject_01', 0, () => {
      let data = null;
      let result: rpc.IRemoteObject | null = BaseServiceStubUtils.getRemoteObject(data);
      expect(result).assertNull();
    })

    it('BaseServiceStubUtils_getRemoteObject_02', 0, () => {
      let baseServiceStubUtils: BaseServiceStubUtils = new BaseServiceStubUtils();
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      BaseServiceStubUtils.getRemoteObject(data);
      expect(baseServiceStubUtils).not().assertUndefined();
    })

    it('BaseServiceStubUtils_writeStringInSegments_01', 0, () => {
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      let result: boolean = BaseServiceStubUtils.writeStringInSegments(data, '');
      expect(result).assertFalse();
    })

    it('BaseServiceStubUtils_writeStringInSegments_02', 0, () => {
      let data = null;
      let result: boolean = BaseServiceStubUtils.writeStringInSegments(data, '');
      expect(result).assertFalse();
    })

    it('BaseServiceStubUtils_writeStringInSegments_03', 0, () => {
      let baseServiceStubUtils: BaseServiceStubUtils = new BaseServiceStubUtils();
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      BaseServiceStubUtils.writeStringInSegments(data, String('1'.length * 130000));
      expect(baseServiceStubUtils).not().assertUndefined();
    })

    it('BaseServiceStubUtils_writeStringInSegments_04', 0, () => {
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      let result: boolean = BaseServiceStubUtils.writeStringInSegments(data, String('1'.length * 60000));
      expect(result).assertTrue();
    })

    it('BaseServiceStubUtils_writeRawDataBuffer_01', 0, () => {
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      let result: boolean = BaseServiceStubUtils.writeRawDataBuffer(data, '');
      expect(result).assertTrue();
    })

    it('BaseServiceStubUtils_writeRawDataBuffer_02', 0, () => {
      let data: rpc.MessageSequence = rpc.MessageSequence.create();
      let result: boolean = BaseServiceStubUtils.writeRawDataBuffer(data, '1');
      expect(result).assertTrue();
    })
  })
}