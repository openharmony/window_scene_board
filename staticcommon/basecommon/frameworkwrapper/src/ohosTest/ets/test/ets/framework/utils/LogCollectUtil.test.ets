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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { LogCollectUtil } from '../../../../../../main/ets/utils/LogCollectUtil';
const TAG = 'LogCollectUtilTest';

export function LogCollectUtilTest() {
  describe('LogCollectUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('unregisterCollectLogCallbackTest', 0, (): void => {
      expect(LogCollectUtil.getInstance().unregisterCollectLogCallback(TAG) === undefined).assertTrue();
      expect(LogCollectUtil.getInstance()['mCollectLogCallbacksMap'].has(TAG)).assertFalse();
    })

    it('unregisterCollectLogCallbackTest_delete', 0, (): void => {
      LogCollectUtil.getInstance().registerCollectLogCallback(TAG, (): void => {
      });
      LogCollectUtil.getInstance().unregisterCollectLogCallback(TAG);
      expect(LogCollectUtil.getInstance()['mCollectLogCallbacksMap'].has(TAG)).assertFalse();
    })

    it('createCollectLogInterval', 0, (): void => {
      LogCollectUtil.getInstance()['mLogCollectEnable'] = true;
      LogCollectUtil.getInstance().createCollectLogInterval();
      expect(LogCollectUtil.getInstance()['mTimerId'] !== -1).assertTrue();
    })

    it('createCollectLogInterval_return_with_mTimerId_existed', 0, (): void => {
      let curTimerId: number = LogCollectUtil.getInstance()['mTimerId'];
      expect(LogCollectUtil.getInstance()['mTimerId'] > 0).assertTrue();
      LogCollectUtil.getInstance().createCollectLogInterval();
      expect(curTimerId === LogCollectUtil.getInstance()['mTimerId']).assertTrue();
    })

    it('createCollectLogInterval_return_with_mLogCollectEnable_disabled', 0, (): void => {
      LogCollectUtil.getInstance().clearCollectLogInterval();
      LogCollectUtil.getInstance()['mLogCollectEnable'] = false;
      LogCollectUtil.getInstance().createCollectLogInterval();
      expect(LogCollectUtil.getInstance()['mTimerId'] === -1).assertTrue();
      LogCollectUtil.getInstance().clearCollectLogInterval();
    })
  })
}