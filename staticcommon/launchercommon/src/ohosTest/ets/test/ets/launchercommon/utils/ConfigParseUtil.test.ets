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
import { ConfigParseUtil } from '../../../../../../main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ConfigParseUtilTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
export default function ConfigParseUtilTest() {
  describe('ConfigParseUtilTest', () => {
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
    it('test_getConfig', 0, async() =>  {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const configFile: string = 'FileNotExists';
      const res = await ConfigParseUtil.getConfig(configFile);
      log.info('test_getConfig res: ' + res + '.');
      expect(res).assertEqual('');
    })

    it('test_getAllConfig', 0, async() =>  {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const configFile: string = 'FileNotExists';
      const res = await ConfigParseUtil.getAllConfig(configFile);
      log.info('test_getAllConfig res: ' + res + '.');
      expect(res.length).assertEqual(0);
    })
    it('test_getExistConfig', 0, async() =>  {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const CONFIG = 'etc/launcher_icon_map_table.json';
      const res = await ConfigParseUtil.getConfig(CONFIG);
      log.info('test_getAllConfig res: ' + res + '.');
      expect(res).assertContain(CONFIG);
    })
    it('test_getAllConfigExist', 0, async() =>  {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const configFile: string = 'etc/hw_launcher_default_workspace.json';
      const res = await ConfigParseUtil.getAllConfig(configFile);
      log.info('test_getAllConfig res: ' + res + '.');
      expect(res.length).assertLarger(0);
    })
  })
}