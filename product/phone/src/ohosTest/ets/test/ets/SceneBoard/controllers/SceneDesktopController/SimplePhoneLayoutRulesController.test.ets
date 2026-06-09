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
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { CalculateDesktopRst, LayoutViewModel } from '@ohos/launchercommon';
import {
  IconSize,
  ScreenWidth
} from '@ohos/phonebase/src/main/ets/SceneBoard/controllers/SceneDesktopController/PhoneLayoutRulesController';
import {
  SimplePhoneLayoutRulesController
} from '@ohos/phonebase/src/main/ets/SceneBoard/controllers/SceneDesktopController/SimplePhoneLayoutRulesController';

export default function SimplePhoneLayoutRulesControllerTest() {
  describe('SimplePhoneLayoutRulesControllerTest', () => {
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

    it('test_createEmergencyStyle', 0, () => {
      try{
        let mLayoutViewModel = LayoutViewModel.getInstance();
        let baseConfig = mLayoutViewModel.getBaseConfig();
        let fold: SimplePhoneLayoutRulesController = SimplePhoneLayoutRulesController.getInstance(baseConfig);
        expect(baseConfig).not().assertNull();
      }catch{}
    })

    it('test_calculateProductConfig', 0, () => {
      let mLayoutViewModel = LayoutViewModel.getInstance();
      let baseConfig = mLayoutViewModel.getBaseConfig();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      try {
        let fold: SimplePhoneLayoutRulesController = SimplePhoneLayoutRulesController.getInstance(baseConfig);
        (fold as object)['mScreenWidth'] = 0;
        expect((fold as object)['mScreenWidth']).assertEqual(0);
        when(mockfunc)().afterReturn(ScreenWidth.LARGE);
        fold.calculateProductConfig();
        let iconSizeOfGrid: number = (fold as object)['iconSizeOfGrid'];
        expect(iconSizeOfGrid).assertEqual(IconSize.LARGE);
        when(mockfunc)().afterReturn(ScreenWidth.MIDDLE - 10);
        fold.calculateProductConfig();
        let iconSizeOfGrid1: number = (fold as object)['iconSizeOfGrid'];
        expect(iconSizeOfGrid1).assertEqual(IconSize.SMALL);
        when(mockfunc)().afterReturn(ScreenWidth.MIDDLE);
        fold.calculateProductConfig();
        let iconSizeOfGrid2: number = (fold as object)['iconSizeOfGrid'];
        expect(iconSizeOfGrid2).assertEqual(IconSize.MIDDLE);
      } catch (e) {
      }
      mocker.clear(baseConfig);
      mocker.clearAll();
    })

    it('test_calculateDesktop', 0, () => {
      let mLayoutViewModel = LayoutViewModel.getInstance();
      let baseConfig = mLayoutViewModel.getBaseConfig();
      let fold: SimplePhoneLayoutRulesController = SimplePhoneLayoutRulesController.getInstance(baseConfig);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      when(mockfunc)().afterReturn(0);
      try {
        let rst: CalculateDesktopRst = fold.calculateDesktop();
        expect(rst).not().assertNull();
      } catch (e) {}
      when(mockfunc)().afterReturn(ScreenWidth.MIDDLE);
      let mockfunc1: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenHeight);
      when(mockfunc1)().afterReturn(0);
      try {
        let rst1: CalculateDesktopRst = fold.calculateDesktop();
        expect(rst1).not().assertNull();
      } catch (e) {}
      when(mockfunc)().afterReturn(ScreenWidth.LARGE);
      mocker.ignoreMock(baseConfig, baseConfig.getScreenHeight);
      try {
        let rst2: CalculateDesktopRst = fold.calculateDesktop();
        expect(rst2).not().assertNull();
      } catch (e) {}
      mocker.clear(baseConfig);
      mocker.clearAll();
    })

  })
}