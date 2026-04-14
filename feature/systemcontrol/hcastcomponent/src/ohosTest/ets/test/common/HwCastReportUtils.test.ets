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

import { afterAll, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { CommonData } from '@ohos/screenlockcommon';
import { CastReportUtils } from '../../../../main/ets/com/ohos/common/CastReportUtils';
import { Constants } from '../../../../main/ets/com/ohos/common/Constants';

export function CastReportUtilsTest() {
  describe('CastReportUtilsTest', (): void => {
    it('CastReportUtilsTest_reportUEProjectionStart', Level.LEVEL1, reportUEProjectionStart);
    it('CastReportUtilsTest_reportUEWifiBtDialogEvent', Level.LEVEL1, reportUEWifiBtDialogEvent);
    it('CastReportUtilsTest_reportUEPrivacyDialogEvent', Level.LEVEL1, reportUEPrivacyDialogEvent);
    it('CastReportUtilsTest_reportUEFailDialogEvent', Level.LEVEL1, reportUEFailDialogEvent);
  })
}

function reportUEProjectionStart() {
  CastReportUtils.reportUEProjectionStart(1);
  expect(CastReportUtils).not().assertUndefined();
}

function reportUEWifiBtDialogEvent() {
  CastReportUtils.reportUEWifiBtDialogEvent(true, true, Constants.REPORT_DIALOG_CONFIRM);
  expect(CastReportUtils).not().assertUndefined();
}

function reportUEPrivacyDialogEvent() {
  CastReportUtils.reportUEPrivacyDialogEvent(Constants.REPORT_DIALOG_SHOW);
  expect(CastReportUtils).not().assertUndefined();
}

function reportUEFailDialogEvent() {
  CastReportUtils.reportUEFailDialogEvent(Constants.REPORT_DIALOG_CANCEL, Constants.DIALOG_DEFAULT);
  CastReportUtils.reportUEFailDialogEvent(Constants.REPORT_DIALOG_CANCEL, Constants.DIALOG_WIFI_BLUETOOTH);
  expect(CastReportUtils).not().assertUndefined();
}
