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
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response'
import { RecentDeviceService, RequestMethod } from '@ohos/phonebase/src/main/ets/service/RecentDeviceService'

export default function RecentDeviceServiceTest() {
  describe('RecentDeviceServiceTest', () => {
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

    it('test_RecentDeviceService_01', 0, async () => {
      let instance: RecentDeviceService = new RecentDeviceService();
      let msg: CallMessage = {method: '', extra: instance};
      let ret: string = await instance.onCall(JSON.stringify(msg));
      expect(ret).assertEqual(Response.INVALID_METHOD_ERROR);
    });

    it('test_RecentDeviceService_02', 0, async () => {
      let instance: RecentDeviceService = new RecentDeviceService();
      let msg: CallMessage = {method: 'anyMethodNotExist', extra: instance};
      let ret: string = await instance.onCall(JSON.stringify(msg));
      expect(ret).assertEqual(Response.UNKNOWN_METHOD_ERROR);
    });

    it('test_RecentDeviceService_03', 0, async () => {
      let instance: RecentDeviceService = new RecentDeviceService();
      let msg: CallMessage = {method: RequestMethod.CLEAR_RECENT_CARDS, extra: instance};
      let ret: string = await instance.onCall(JSON.stringify(msg));
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_RecentDeviceService_04', 0, async () => {
      let instance: RecentDeviceService = new RecentDeviceService();
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