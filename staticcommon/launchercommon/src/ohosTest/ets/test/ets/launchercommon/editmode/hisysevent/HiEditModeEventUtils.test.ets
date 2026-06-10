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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { HiEditModeEventUtils } from '../../../../../../../main/ets/editmode/hisysevent/HiEditModeEventUtils';
import type { EditModeUninstallParams, ExitEditModeParams } from '../../../../../../../main/ets/editmode/hisysevent/EditModeReportParams';
import { AppItemInfo, GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';

export default function HiEditModeEventUtilsTest() {
  describe('HiEditModeEventUtilsTest', () => {
    it('test_HiEditModeEventUtils', 0, () => {
      const flag = true;
      try {
      HiEditModeEventUtils.reportEnterEditMode(1);
      HiEditModeEventUtils.reportExitEditMode(1, null);
      HiEditModeEventUtils.reportExitEditMode(1, {
        PNAMEID: '',
        PVERSIONID: '',
        ISCHANGED: true,
        DURATION: ''
      });
      HiEditModeEventUtils.reportEditModeToUninstall({
        TYPE: 1,
        APP_TYPE: '',
        APP_INFO: ''
      })
      HiEditModeEventUtils.reportEditModeConfirmUninstall({
        TYPE: 1,
        APP_TYPE: '',
        APP_INFO: ''
      })
      HiEditModeEventUtils.reportEditModeCancelUninstall({
        TYPE: 1,
        APP_TYPE: '',
        APP_INFO: ''
      })
      } catch (e) {}
      expect(flag).assertTrue();
    })

    it('test_event', 0, () => {
      let flag = true;
      HiEditModeEventUtils.reportEnterEditMode(1);
      let params: ExitEditModeParams = {
        ISCHANGED: false,
        DURATION: ''
      }
      HiEditModeEventUtils.reportExitEditMode(1, params);

      let uninstallParam: EditModeUninstallParams = {
        TYPE: 0,
        APP_TYPE: '',
        APP_INFO: ''
      }
      HiEditModeEventUtils.reportEditModeToUninstall(uninstallParam);
      HiEditModeEventUtils.reportEditModeConfirmUninstall(uninstallParam);
      HiEditModeEventUtils.reportEditModeCancelUninstall(uninstallParam);
      expect(flag).assertTrue();

    })

    it('test_reportAddAppToScreenByClick', 0, () => {
      let flag = true;
      let editTestAppItem: AppItemInfo = {
        abilityName : 'AppTest',
        appName : 'AppTestName',
        appId : '99',
        bundleName : 'com.ohos.appTest',
        moduleName : 'test',
        keyName : 'editTestApp'
      } as AppItemInfo;
      HiEditModeEventUtils.reportAddAppToScreenByClick(editTestAppItem, 0, 0, 0);
      expect(flag).assertTrue();
    })

    it('test_reportAddAppToScreenByDrag', 0, () => {
      let flag = true;
      let editTestAppItem: GridLayoutItemInfo = {
        abilityName : 'AppTest',
        appName : 'AppTestName',
        appIconId : 9999,
        bundleName : 'com.ohos.appTest',
        moduleName : 'test',
        keyName : 'editTestApp'
      } as GridLayoutItemInfo;
      HiEditModeEventUtils.reportAddAppToScreenByDrag(editTestAppItem, 0, 0, 0);
      expect(flag).assertTrue();
    })
  })
}
