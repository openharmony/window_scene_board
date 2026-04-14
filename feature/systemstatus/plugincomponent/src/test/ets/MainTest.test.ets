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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { ToggleStyle } from '@ohos/systemuicommon';

export function MainTest() {
  describe('MainTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('pluginComponent_testcase1', 0, (): void => {
      expect('testcase1'.length).assertLarger(0);
    })

    it('testcase2', 0, (): void => {
      expect('testcase2'.length).assertLarger(1);
    })

    it('testcase3', 0, (): void => {
      expect('testcase1'.length).assertLarger(2);
    })

    it('longClickTest', 0, (): void => {
      expect(DeviceHelper.isPC()).assertFalse();
    })

    it('longClickTest1', 0, (): void => {
      expect(DeviceHelper.isPhone()).assertTrue();
    })

    it('styleTest', 0, (): void => {
      expect(ToggleStyle.getStyle().cellHeight).assertLarger(1);
    })
  })
}