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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { GlobalSearchLocationService, RequestMethod } from '@ohos/phonebase/src/main/ets/service/GlobalSearchLocationService'

export default function GlobalSearchLocationServiceTest() {
  describe('GlobalSearchLocationServiceTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_GlobalSearchLocationService_01', 0, async () => {
      let instance: GlobalSearchLocationService = new GlobalSearchLocationService();
      let msg: CallMessage = {method: '', extra: instance};
      let ret: string = await instance.onCall(JSON.stringify(msg));
      expect(ret).assertEqual('invalid method');
    });

    it('test_GlobalSearchLocationService_02', 0, async () => {
      let instance: GlobalSearchLocationService = new GlobalSearchLocationService();
      let msg: CallMessage = {method: 'anyMethodNotExist', extra: instance};
      let ret: string = await instance.onCall(JSON.stringify(msg));
      expect(ret).assertEqual('unknown method');
    });

    it('test_GlobalSearchLocationService_04', 0, async () => {
      let instance: GlobalSearchLocationService = new GlobalSearchLocationService();
      let ret: boolean = instance.isSupportSegments();
      expect(ret).assertFalse();
    });

    interface CallMessage {
      /**
       * 方法名
       */
      method: string;

      /**
       * 附加参数
       */
      extra: object;
    }

  })
}