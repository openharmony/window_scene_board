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

import { describe, beforeAll, it, TestType, expect } from '@ohos/hypium';
import { LogDomain, Logger } from '@ohos/basicutils';
import SuperPrivacyUtils from '../../../../../main/ets/util/SuperPrivacyUtils';

const TAG = 'SuperPrivacyUtilsUtilsTest';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export default function SuperPrivacyUtilsUtilsTest() {
  describe('SuperPrivacyUtilsUtilsTest', () => {
    beforeAll(() => {
      log.info(TAG, 'beforeAll begin');
    })

    /**
     * @tc.number: SuperPrivacyUtilsUtilsTest_000
     * @tc.name: SuperPrivacyUtils
     * @tc.type: TestType.FUNCTION
     * @tc.desc: 超级隐私状态查询
     */
    it('SuperPrivacyUtilsUtilsTest_000', TestType.FUNCTION, async () => {
      log.debug(TAG, 'SuperPrivacyUtilsUtilsTest_000 it begin');
      SuperPrivacyUtils.isSupportFoldProtection();
      SuperPrivacyUtils.isSupportSoftProtection();
      SuperPrivacyUtils.isSupportSuperPrivacy();
      SuperPrivacyUtils.isPaddleDevice();
      log.debug(TAG, 'SuperPrivacyUtilsUtilsTest_000 it end');
    });
  });
}