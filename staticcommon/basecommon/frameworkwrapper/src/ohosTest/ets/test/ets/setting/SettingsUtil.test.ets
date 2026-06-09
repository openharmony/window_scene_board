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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import sSettingsUtil from '../../../../../main/ets/setting/SettingsUtil';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';

export function SettingsUtilTest() {
  describe('SettingsUtilTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_setValue_should_return_true', Level.LEVEL0, (): void => {
      let value: boolean = sSettingsUtil.setValue(SettingsKeyConstants.DEVICE_PROVISIONED, SettingsConstants.OOBE_STATUS_ON);
      expect(value).assertTrue();
    })

    it('test_getValue_should_return_string', Level.LEVEL0, (): void => {
      let value: string = sSettingsUtil.getValue(SettingsKeyConstants.DEVICE_PROVISIONED, SettingsConstants.OOBE_STATUS_ON);
      expect(value).assertEqual(SettingsConstants.OOBE_STATUS_ON);
    })
  })
}