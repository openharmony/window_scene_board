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
import { FileUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { SmallFoldStyleUtil } from '../../../../../../main/ets/utils/SmallFoldStyleUtil';

/**
 * 小折叠工具类测试类
 */
export default function SmallFoldStyleUtilTest() {
  describe('SmallFoldStyleUtilTest', () => {
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

    it('test_getFontSizeScale', 0, () => {
      let fontScale: number = SmallFoldStyleUtil.getFontSizeScale();
      expect(true).assertTrue();
    })

    it('test_getScaleSize', 0, () => {
      let fontSize: string = SmallFoldStyleUtil.getScaleSize(10, 1.75);
      expect(true).assertTrue();
    })

    it('test_getFontScale', 0, () => {
      let fontScale: number = SmallFoldStyleUtil.getFontScale(1.75);
      expect(true).assertTrue();
    })

    it('test_getFontSizeScale', 0, () => {
      let fontScale: number = SmallFoldStyleUtil.getFontSizeScale();
      expect(true).assertTrue();
    })

    it('test_getMultitaskingFilterMap', 0, () => {
      let map: Map<string, string[]> = SmallFoldStyleUtil.getMultitaskingFilterMap();
      expect(true).assertTrue();
    })

    it('test_getMultitaskingFilterMap_parseMultitaskingFilterFile', 0, () => {
      let map: Map<string, string[]> = SmallFoldStyleUtil.getMultitaskingFilterMap() ?? new Map();
      let a = 'test';
      map.has('testkey')
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(null);
      let map1: Map<string, string[]> = SmallFoldStyleUtil.getMultitaskingFilterMap();
      map1.has('testkey')

      let filterObj: object = JSON.parse('{"code":"200","data":{}}');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(filterObj);
      let filter: object[] = filterObj?.['filter'];
      let map2: Map<string, string[]> = SmallFoldStyleUtil.getMultitaskingFilterMap();
      map2.has('testkey2')

      let filterObj1: object = JSON.parse('{"code":"200","filter":' +
        '[{"bundleName":"com.openharmony.ohos.sugesture","abilities":["ablity1","ablity1"]},' +
        '{"abilities":["ablity1","ablity1"]}]}');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(filterObj1);
      let filter1: object[] = filterObj1?.['filter'];
      let map3: Map<string, string[]> = SmallFoldStyleUtil.getMultitaskingFilterMap();
      let has = map3.has('com.openharmony.ohos.sugesture');
      expect(a).assertEqual('test');
      mocker.clear(DeviceHelper);
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

  })
}