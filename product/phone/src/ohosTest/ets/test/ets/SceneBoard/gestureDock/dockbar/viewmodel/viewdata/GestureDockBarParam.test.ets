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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenProperty } from '@ohos/windowscene';

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { ScreenInfoUtil } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/ScreenInfoUtil';
import {
  DockBarParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarParam';

export default function GestureDockBarParamTest() {
  describe('GestureDockBarParamTest', () => {
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

    it('GestureDockBarParam_resetDockMaxHeight_1', 0, async (done: Function) => {
      let dockBarParam: DockBarParam = new DockBarParam();
      expect(dockBarParam.resetDockMaxHeight(2) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarParam_resetDockMaxHeight_2', 0, async (done: Function) => {
      let dockBarParam: DockBarParam = new DockBarParam();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mocker = new MockKit();
      let mockScreenInfoUtil = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      let mockDeviceHelper = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockScreenInfoUtil)(ArgumentMatchers.any).afterReturn(true);
      when(mockDeviceHelper)().afterReturn(false);
      expect(dockBarParam.resetDockMaxHeight(2, screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      done();
    })

    it('GestureDockBarParam_resetDockMaxHeight_3', 0, async (done: Function) => {
      let dockBarParam: DockBarParam = new DockBarParam();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mocker = new MockKit();
      let mockScreenInfoUtil = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      let mockDeviceHelper = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockScreenInfoUtil)(ArgumentMatchers.any).afterReturn(false);
      when(mockDeviceHelper)().afterReturn(false);
      expect(dockBarParam.resetDockMaxHeight(2, screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      done();
    })

    it('GestureDockBarParam_resetDockMaxHeight_4', 0, async (done: Function) => {
      let dockBarParam: DockBarParam = new DockBarParam();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mocker = new MockKit();
      let mockScreenInfoUtil = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      let mockDeviceHelper = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockScreenInfoUtil)(ArgumentMatchers.any).afterReturn(true);
      when(mockDeviceHelper)().afterReturn(true);
      expect(dockBarParam.resetDockMaxHeight(2, screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      done();
    })
  })
}