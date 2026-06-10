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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import {
  AllAppsStyleConfigMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/model/AllAppsStyleConfigMgr';

export default function AllAppsStyleConfigMgrTest() {
  describe('AllAppsStyleConfigMgrTest', () => {
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

    it('AllAppsStyleConfigMgr_getStyleConfig_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsFoldExpandStatus = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockIsLandscape = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandStatus)().afterReturn(false);
      when(mockIsPad)().afterReturn(false);
      when(mockIsLandscape)().afterReturn(false);
      const result = AllAppsStyleConfigMgr.getStyleConfig();
      expect(result !== undefined).assertTrue()
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      done();
    });

    it('AllAppsStyleConfigMgr_getStyleConfig_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockIsFoldExpandStatus = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscape = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsPad)().afterReturn(false);
      when(mockIsFoldExpandStatus)().afterReturn(true);
      when(mockIsLandscape)().afterReturn(false);
      const result = AllAppsStyleConfigMgr.getStyleConfig();
      expect(result !== undefined).assertTrue()
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      done();
    });

    it('AllAppsStyleConfigMgr_getStyleConfig_3', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockIsFoldExpandStatus = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscape = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsPad)().afterReturn(true);
      when(mockIsFoldExpandStatus)().afterReturn(true);
      when(mockIsLandscape)().afterReturn(false);
      const result = AllAppsStyleConfigMgr.getStyleConfig();
      expect(result !== undefined).assertTrue()
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      done();
    });

    it('AllAppsStyleConfigMgr_getStyleConfig_4', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsFoldExpandStatus = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscape = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandStatus)().afterReturn(false);
      when(mockIsLandscape)().afterReturn(true);
      const result = AllAppsStyleConfigMgr.getStyleConfig();
      expect(result !== undefined).assertTrue()
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      done();
    });
  })
}