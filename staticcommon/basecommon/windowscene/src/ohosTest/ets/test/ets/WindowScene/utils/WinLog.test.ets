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
import hilog from '@ohos.hilog';
import {
  WinLog,
  WinLogDomain,
  WinLogHelper
}
from '../../../../../../main/ets/utils/WinLog';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  SysTestKit
} from '@ohos/hypium';

export function WinLogTest() {
  describe('WinLogTest', () => {

    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('shouldReturnNonUndefinedWinLogHelper', 0, () => {
        expect(WinLogHelper.getWinLogHelper(WinLogDomain.WMS_RECOVER)).not().assertUndefined;
    });

    it('getShowInfoTest', 0, async () => {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `showInfo`);
      const isCalled1 = await SysTestKit.existKeyword('showInfo');
      expect(isCalled1).assertTrue();
    });

    it('getShowDebugTest', 0, async () => {
      WinLog.showDebug(WinLogDomain.WMS_RECOVER, `getShowDebugTest`);
      const isCalled1 = await SysTestKit.existKeyword('getShowDebugTest');
      expect(isCalled1).assertTrue();
    });

    it('getShowWarnTest', 0, async () => {
      WinLog.showWarn(WinLogDomain.WMS_RECOVER, `getShowWarnTest`);
      const isCalled1 = await SysTestKit.existKeyword('getShowWarnTest');
      expect(isCalled1).assertTrue();
    });

    it('getShowErrorTest', 0, async () => {
      WinLog.showError(WinLogDomain.WMS_RECOVER, 'getShowErrorTest');
      const isCalled1 = await SysTestKit.existKeyword('getShowErrorTest');
      expect(isCalled1).assertTrue();
    });

    it('getShowFatalTest', 0, async () => {
      WinLog.showFatal(WinLogDomain.WMS_RECOVER, 'getShowFatalTest');
      const isCalled1 = await SysTestKit.existKeyword('getShowFatalTest');
      expect(isCalled1).assertTrue();
    });

  });
}