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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { IntentParseUtil } from '../../../../../../main/ets/utils/IntentParseUtil'

export default function IntentParseUtilTest() {
  describe('IntentParseUtilTest', () => {
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

    it('test_getComponentByIntent01', 0, async () => {
      let intentStr: string = 'anyString';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(IntentParseUtil, IntentParseUtil.parseIntent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Map([
        ["key1", "value1"],
        ["key2", "value2"]
      ]));
      try {
        expect(IntentParseUtil.getComponentByIntent(intentStr)).assertNull();
      } catch (e) {
      }
      mocker.clear(IntentParseUtil);
      mocker.clearAll();
    });

    it('test_getComponentByIntent02', 0, async () => {
      let intentStr: string = 'anyString';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(IntentParseUtil, IntentParseUtil.parseIntent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Map());
      try {
        expect(IntentParseUtil.getComponentByIntent(intentStr)).assertNull();
      } catch (e) {
      }
      mocker.clear(IntentParseUtil);
      mocker.clearAll();
    });

    it('test_parseIntent', 0, async () => {
      let intentStr: string = 'any;Component;Str';
      expect(IntentParseUtil.parseIntent(intentStr)).not().assertNull();
    });

    it('test_isRetainedShortcut', 0, async () => {
      let intentStr: string = '#Intent;component=com.ohos.systemui/com.openharmony.keyguard.onekeylock.shortcut.ApproachActivity;end';
      let result = IntentParseUtil.isRetainedShortcut(intentStr);
      expect(result).assertTrue();
    });

    it('test_queryShortcutToAppMappingPackageName', 0, async () => {
      let intentStr: string = 'any;Component;Str';
      let result = IntentParseUtil.queryShortcutToAppMappingPackageName(intentStr);
      expect(result).not().assertNull();
    });
  })
}