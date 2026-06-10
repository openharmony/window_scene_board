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
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import PhoneSmartDockLayoutConfig from '@ohos/phonebase/src/main/ets/common/PhoneSmartDockLayoutConfig'


export default function PhoneSmartDockLayoutConfigTest() {
  describe('PhoneSmartDockLayoutConfigTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_isPhone', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc)().afterReturn(true);
      let instance : PhoneSmartDockLayoutConfig = PhoneSmartDockLayoutConfig.getInstance();
      when(mockfunc)().afterReturn(true);
      instance = PhoneSmartDockLayoutConfig.getInstance();
      expect(instance).not().assertUndefined();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
  })
}
