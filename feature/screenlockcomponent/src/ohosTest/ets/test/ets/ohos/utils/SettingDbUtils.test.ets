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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { SettingDbUtils } from '@ohos/screenlockcommon/src/main/ets/utils/SettingDbUtils';

export default function SettingDbUtilsTest() {

  describe('SettingDbUtilsTest', (): void => {

    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {

    });

    afterAll((): void => {

    });

    it('test_setSignatureText', TestConst.TEST_LEVEL, (): void => {
      const oldVal: string = SettingDbUtils.getSignatureText();
      SettingDbUtils.setSignatureText('test');
      const str: string = SettingDbUtils.getSignatureText();
      expect(str).assertEqual('test');
      SettingDbUtils.setSignatureText(oldVal);
    });

    it('test_setSlGreetText', TestConst.TEST_LEVEL, (): void => {
      const oldVal: string = SettingDbUtils.getSlGreetFlagText();
      SettingDbUtils.setSlGreetFlagText('1');
      const str: string = SettingDbUtils.getSlGreetFlagText();
      expect(str).assertEqual('1');
      SettingDbUtils.setSignatureText(oldVal);
    });

    it('test_setSignatureVisible', TestConst.TEST_LEVEL, (): void => {
      const oldVal:boolean = SettingDbUtils.getSignatureVisible() === 'true';
      SettingDbUtils.setSignatureVisible(true);
      const str:boolean = SettingDbUtils.getSignatureVisible() === 'true';
      expect(str).assertTrue();
      SettingDbUtils.setValToDbWithCatch('lock_screen_owner_info_enabled', '' + oldVal);
      SettingDbUtils.setNormalValToDbWithCatch('lock_screen_owner_info_enabled', '' + oldVal);
    });
  });
}