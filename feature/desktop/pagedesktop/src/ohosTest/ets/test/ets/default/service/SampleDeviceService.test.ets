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
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';
import { RestoringDesktopLayout } from '../../../../../../main/ets/default/service/impl/RestoringDesktopLayout';
import { CallMessage, SampleDeviceService } from '../../../../../../main/ets/default/service/SampleDeviceService';
/**
 * 样机演示对外提供服务，服务调用测试
 *
 *@since 2023-04-11
 */
const mSampleDeviceService: SampleDeviceService = new SampleDeviceService(new RestoringDesktopLayout());
export default function SampleDeviceServiceTest() {
  describe('SampleDeviceServiceTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    //!msg.method为true,模拟错误传参不包含key('method')
    it('test_onCall01', 0, async () => {
      let msg: string = '{"extra":"restoringDesktopLayout"}';
      let response: string =  await mSampleDeviceService.onCall(msg);
      expect(response).assertEqual(Response.INVALID_METHOD_ERROR);
    });
    //!executor为true,模拟包含 key('method'),但不包含对应value
    it('test_onCall02', 0, async () => {
      let msg: string = '{"method":"restoringDesk"}';
      let response: string =  await mSampleDeviceService.onCall(msg);
      expect(response).assertEqual(Response.UNKNOWN_METHOD_ERROR);
    });
    //传入正确的json串，包含key('method')，且传入正确的value
    it('test_onCall03', 0, async () => {
      let msg: string = '{"method":"restoringDesktopLayout"}';
      let response: string =  await mSampleDeviceService.onCall(msg);
      expect(response).not().assertNull();
    });
  })
}
