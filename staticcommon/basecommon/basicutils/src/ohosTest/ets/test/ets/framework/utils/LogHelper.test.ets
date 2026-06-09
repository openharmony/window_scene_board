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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LogHelper, LogDomain } from '../../../../../../main/ets/utils/LogHelper';

const TAG = 'LogHelperTest';
const mLog: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export function LogHelperTest() {
  describe('LogHelperTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('LogHelperTest_debug_warn_fatal_error', 0, ():void =>{
      let mError: Error = new Error('mtest');
      let mocker: MockKit = new MockKit();
      let mockFunc:Function = mocker.mockFunc(mLog, mLog.isLoggable);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      mLog.debug(`showDebugTest`);
      mLog.warn(1);
      mLog.error(mError);
      expect(mLog.fatal(`showFatalTest`) === undefined).assertTrue();
      mocker.clear(mLog);
      mocker.clearAll();
    })

    it('LogHelperTest_isLoggable_domain_is_not_enable', 0, (): void => {
      let mLogger:LogHelper = LogHelper.getLogHelper(1, 'mTester');
      expect(mLogger.showInfo(`showInfoTest`) === undefined).assertTrue();
    })
  })
}