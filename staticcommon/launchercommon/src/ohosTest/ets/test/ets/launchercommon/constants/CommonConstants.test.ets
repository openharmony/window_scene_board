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
import {
  CommonConstants,
  CenterConstants,
  DeviceState,
  AppStatus,
  DesktopMode,
  SystemBarChangeType,
  BusinessType
} from '../../../../../../main/ets/constants/CommonConstants';

export default function CommonConstantsTest_2() {
  describe('CommonConstantsTest_2', () => {
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
    it('CommonConstantsTest_getDeviceRadius', 0, () => {
      CommonConstants.getDeviceRadius();
      CenterConstants.itemCenterX = [[1,1]];
      const expand:DeviceState = DeviceState.EXPAND_STATE;
      const folder:DeviceState = DeviceState.FOLDED_STATE;
      const defState:DeviceState = DeviceState.DEFAULT_STATE;

      const state:AppStatus = AppStatus.INSTALLING;
      const stateWaiting:AppStatus =  AppStatus.WIFI_WAITING;

      const mode0:DesktopMode = DesktopMode.NORMAL_MODE;
      const mode1:DesktopMode =  DesktopMode.EDIT_MODE;
      const mode2:DesktopMode =  DesktopMode.PREVIEW_MODE;

      const type0:SystemBarChangeType =  SystemBarChangeType.SHOW_BAR;
      const type1:SystemBarChangeType =  SystemBarChangeType.HIDE_BAR;
      const type2:SystemBarChangeType =  SystemBarChangeType.CANCEL_TASK;
      const type3:SystemBarChangeType =  SystemBarChangeType.SET_TASK;

      const business0:BusinessType =  BusinessType.BUSINESS_BASIC_DESKTOP;
      const business1:BusinessType =  BusinessType.BUSINESS_CARD;
      const business2:BusinessType =  BusinessType.BUSINESS_APP;
      const business3:BusinessType =  BusinessType.BUSINESS_FOLDER;
      const business4:BusinessType =  BusinessType.BUSINESS_DRAG;
      expect(true).assertTrue();
    })
  })
}
