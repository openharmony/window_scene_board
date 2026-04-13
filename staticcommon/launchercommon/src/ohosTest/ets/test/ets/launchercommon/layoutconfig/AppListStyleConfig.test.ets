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
import { AppListStyleConfig } from '../../../../../../main/ets/layoutconfig/AppListStyleConfig'
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants'

export default function AppListStyleConfigTest() {
  describe('AppListStyleConfigTest', () => {
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

    it('test_getInstance', 0, () => {
      let instance = AppListStyleConfig.getInstance();
      expect(instance).not().assertNull();
    })

    it('test_getConfigLevel', 0, () => {
      let instance = AppListStyleConfig.getInstance();
      expect(instance.getConfigLevel() === CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON).assertTrue();
    })

    it('test_initConfig', 0, () => {
      let instance = AppListStyleConfig.getInstance();
      expect(instance.initConfig() === undefined).assertTrue();
    })

    it('test_getConfigType', 0, () => {
      let instance = AppListStyleConfig.getInstance();
      expect(instance.getConfigType() === CommonConstants.LAYOUT_CONFIG_TYPE_STYLE).assertTrue();
    })

    it('test_getConfigName', 0, () => {
      let instance = AppListStyleConfig.getInstance();
      expect(instance.getConfigName() === AppListStyleConfig.APP_LIST_STYLE_CONFIG).assertTrue();
    })
  })
}