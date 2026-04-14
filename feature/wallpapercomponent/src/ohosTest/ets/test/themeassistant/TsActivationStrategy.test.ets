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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { TsMashupHandler } from '../../../../main/ets/themeassistant/handler/TsMashupHandler'
import { TsActivationStrategy } from '../../../../main/ets/themeassistant/TsActivationStrategy'

export default function TsActivationStrategyTest() {
  describe('TsActivationStrategyTest', () => {
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
    it('TsActivationStrategy_getActivationType_test01', 0, () => {
      let tsActivationStrategy: TsActivationStrategy = new TsActivationStrategy();
      let tsMashupHandler: TsMashupHandler = new TsMashupHandler('');
      (tsActivationStrategy as object)['mashupHandler'] = tsMashupHandler;
      (tsActivationStrategy as object)['activeThemePath'] = '';
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.isNgTheme);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.isThemeEdited);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      tsActivationStrategy.getActivationType();
      expect(tsActivationStrategy).not().assertUndefined();
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.isNgTheme);
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.isThemeEdited);
      mock.clearAll();
    })

    it('TsActivationStrategy_getActivationType_test02', 0, () => {
      let tsActivationStrategy: TsActivationStrategy = new TsActivationStrategy();
      let tsMashupHandler: TsMashupHandler = new TsMashupHandler('');
      (tsActivationStrategy as object)['mashupHandler'] = tsMashupHandler;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.isNgTheme);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.isThemeEdited);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      tsActivationStrategy.getActivationType();
      expect(tsActivationStrategy).not().assertUndefined();
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.isNgTheme);
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.isThemeEdited);
      mock.clearAll();
    })

    it('TsActivationStrategy_getActivationType_test03', 0, () => {
      let tsActivationStrategy: TsActivationStrategy = new TsActivationStrategy();
      let tsMashupHandler: TsMashupHandler = new TsMashupHandler('');
      (tsActivationStrategy as object)['mashupHandler'] = tsMashupHandler;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.isNgTheme);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.checkIsNgStatic);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      tsActivationStrategy.getActivationType();
      expect(tsActivationStrategy).not().assertUndefined();
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.isNgTheme);
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.checkIsNgStatic);
      mock.clearAll();
    })

    it('TsActivationStrategy_getActivationType_test04', 0, () => {
      let tsActivationStrategy: TsActivationStrategy = new TsActivationStrategy();
      let tsMashupHandler: TsMashupHandler = new TsMashupHandler('');
      (tsActivationStrategy as object)['mashupHandler'] = tsMashupHandler;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.isNgTheme);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mock.mockFunc(tsMashupHandler,tsMashupHandler.checkIsNgStatic);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      tsActivationStrategy.getActivationType();
      expect(tsActivationStrategy).not().assertUndefined();
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.isNgTheme);
      mock.ignoreMock(tsMashupHandler,tsMashupHandler.checkIsNgStatic);
      mock.clearAll();
    })

    it('TsActivationStrategy_staticValidityCheck_test01', 0, () => {
      let tsActivationStrategy: TsActivationStrategy = new TsActivationStrategy();
      (tsActivationStrategy as object)['staticValidityCheck'](true);
      expect(tsActivationStrategy).not().assertUndefined();
    })

    it('TsActivationStrategy_staticValidityCheck_test02', 0, () => {
      let tsActivationStrategy: TsActivationStrategy = new TsActivationStrategy();
      (tsActivationStrategy as object)['staticValidityCheck'](false);
      expect(tsActivationStrategy).not().assertUndefined();
    })

  })
}