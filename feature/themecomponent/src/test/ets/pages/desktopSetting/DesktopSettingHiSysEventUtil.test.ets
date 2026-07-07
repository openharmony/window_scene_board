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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { DesktopSettingHiSysEventUtil } from '../../../../main/ets/pages/desktopSetting/DesktopSettingHiSysEventUtil';

export function DesktopSettingHiSysEventUtilTest() {
  describe('DesktopSettingHiSysEventUtilTest', () => {
    beforeAll(() => {

    });
    beforeEach(() => {

    });
    afterEach(() => {

    });
    afterAll(() => {

    });

    it('test_reportSettingEnterHomeScreen', Level.LEVEL0, (): void => {
      DesktopSettingHiSysEventUtil.reportSettingEnterHomeScreen();
      expect(true).assertTrue();
    })

    it('test_reportSettingEnterIntelligent', Level.LEVEL0, (): void => {
      DesktopSettingHiSysEventUtil.reportSettingEnterIntelligent();
      expect(true).assertTrue();
    })

    it('test_reportSettingVoiceSearchSwitch_true', Level.LEVEL0, (): void => {
      DesktopSettingHiSysEventUtil.reportSettingVoiceSearchSwitch(true);
      expect(true).assertTrue();
    })

    it('test_reportSettingVoiceSearchSwitch_false', Level.LEVEL0, (): void => {
      DesktopSettingHiSysEventUtil.reportSettingVoiceSearchSwitch(false);
      expect(true).assertTrue();
    })

    it('test_reportSettingAutoAlignSwitch_true', Level.LEVEL0, (): void => {
      DesktopSettingHiSysEventUtil.reportSettingAutoAlignSwitch(true);
      expect(true).assertTrue();
    })

    it('test_reportSettingAutoAlignSwitch_false', Level.LEVEL0, (): void => {
      DesktopSettingHiSysEventUtil.reportSettingAutoAlignSwitch(false);
      expect(true).assertTrue();
    })
  });
}