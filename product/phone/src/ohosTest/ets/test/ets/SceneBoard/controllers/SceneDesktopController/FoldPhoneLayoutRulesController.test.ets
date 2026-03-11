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
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { CalculateDesktopRst, LayoutViewModel, RadiusUtil } from '@ohos/launchercommon';
import {
  FoldPhoneLayoutRulesController
} from '@ohos/phonebase/src/main/ets/SceneBoard/controllers/SceneDesktopController/FoldPhoneLayoutRulesController';
import {
  IconSize,
  ScreenWidth
} from '@ohos/phonebase/src/main/ets/SceneBoard/controllers/SceneDesktopController/PhoneLayoutRulesController';

export default function FoldPhoneLayoutRulesControllerTest() {
  describe('FoldPhoneLayoutRulesControllerTest', () => {
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
      let mLayoutViewModel = LayoutViewModel.getInstance();
      let baseConfig = mLayoutViewModel.getBaseConfig();
      let fold: FoldPhoneLayoutRulesController = FoldPhoneLayoutRulesController.getInstance(baseConfig);
      expect(baseConfig).not().assertNull();
    })

    it('test_calculateProductConfig', 0, () => {
      let mLayoutViewModel = LayoutViewModel.getInstance();
      let baseConfig = mLayoutViewModel.getBaseConfig();
      let fold: FoldPhoneLayoutRulesController = FoldPhoneLayoutRulesController.getInstance(baseConfig);
      (fold as object)['mScreenWidth'] = 0;
      expect((fold as object)['mScreenWidth']).assertEqual(0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
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
      mocker.clear(baseConfig);
      mocker.clearAll();
    })

    it('test_calculateDesktop', 0, () => {
      let mLayoutViewModel = LayoutViewModel.getInstance();
      let baseConfig = mLayoutViewModel.getBaseConfig();
      let fold: FoldPhoneLayoutRulesController = FoldPhoneLayoutRulesController.getInstance(baseConfig);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      when(mockfunc)().afterReturn(0);
      let rst: CalculateDesktopRst = fold.calculateDesktop();
      expect(rst).not().assertNull();
      when(mockfunc)().afterReturn(ScreenWidth.MIDDLE);
      let mockfunc1: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenHeight);
      when(mockfunc1)().afterReturn(0);
      let rst1: CalculateDesktopRst = fold.calculateDesktop();
      expect(rst1).not().assertNull();
      when(mockfunc)().afterReturn(ScreenWidth.LARGE);
      mocker.ignoreMock(baseConfig, baseConfig.getScreenHeight);
      let rst2: CalculateDesktopRst = fold.calculateDesktop();
      expect(rst2).not().assertNull();
      mocker.clear(baseConfig);
      mocker.clearAll();
    })

    it('test_calculateOpenFolderIconRadius', 0, () => {
      let mLayoutViewModel = LayoutViewModel.getInstance();
      let baseConfig = mLayoutViewModel.getBaseConfig();
      let fold: FoldPhoneLayoutRulesController = FoldPhoneLayoutRulesController.getInstance(baseConfig);
      let commonDefault: number = 14;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(RadiusUtil, RadiusUtil.calculateRadius);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(commonDefault);
      let radius: number = (fold as object)['calculateOpenFolderIconRadius'](10, true);
      expect(radius).assertEqual(5);
      let radius1: number = (fold as object)['calculateOpenFolderIconRadius'](60, true);
      expect(radius1).assertEqual(commonDefault);
      let radius2: number = (fold as object)['calculateOpenFolderIconRadius'](10);
      expect(radius2).assertEqual(5);
      let radius3: number = (fold as object)['calculateOpenFolderIconRadius'](60, false);
      expect(radius3).assertEqual(commonDefault);
      mocker.clear(RadiusUtil);
      mocker.clearAll();
    })


  })
}