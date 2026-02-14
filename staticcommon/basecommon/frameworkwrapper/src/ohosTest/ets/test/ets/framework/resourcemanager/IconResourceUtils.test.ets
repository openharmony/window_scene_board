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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { IconResourceUtils } from '../../../../../../main/ets/resourcemanager/IconResourceUtils'

export function IconResourceUtilsTest() {
  describe('IconResourceUtilsTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('test_getResourceInfo_01', 0, () => {
      let isError = false;
      try {
        IconResourceUtils.getResourceInfo('', '', '', 0);
      } catch (err) {
        isError = true;
      }
      expect(isError).assertTrue();
    });

    it('test_getResourceInfo_02', 0, () => {
      let result = IconResourceUtils.getResourceInfo('com.ohos.calculator', '', '', 0);
      expect(result).not().assertNull();
    });

    it('test_getResourceInfo_03', 0, () => {
      let result = IconResourceUtils.getResourceInfo('com.ohos.calculator', 'moduleName', '', 0);
      expect(result).not().assertNull();
    });

    it('test_getResourceInfo_04', 0, () => {
      const appIndex: number = Number.MAX_VALUE;
      let isError = false;
      try {
        IconResourceUtils.getResourceInfo('com.ohos.calculator', 'moduleName', '', appIndex);
      } catch (error) {
        isError = true;
      }
      expect(isError).assertFalse();
    });

    it('test_getResourceInfo_05', 0, () => {
      const appIndex: number = Number.MAX_VALUE;
      let isError = false;
      try {
        IconResourceUtils.getResourceInfo('com.ohos.calculator', 'moduleName', 'abilityName', appIndex);
      } catch (error) {
        isError = true;
      }
      expect(isError).assertFalse();
    });
  });
}
