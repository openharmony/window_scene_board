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
import { KeyValueArray, SCBDebugUtils } from '../../../../../../../main/ets/scene/dump/uiDumpUtils/SCBDebugUtils';

export default function SCBDebugUtilsTest() {
  let keyValues: KeyValueArray = new KeyValueArray();
  let arrays: KeyValueArray[] = [keyValues];
  describe('SCBDebugUtilsTest', () => {
    beforeAll(() => {
      keyValues.push("test", "test");
      arrays = [keyValues];
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('buildArrayContext', 0, () => {
      let result = SCBDebugUtils.buildArrayContext(arrays);
      expect(result).assertEqual(`[{'test':"test"}]`);
    })

    it('buildContext', 0, () => {
      let result = SCBDebugUtils.buildContext(keyValues);
      expect(result).assertEqual(`test:"test"\r\n`);
    })
  })
}