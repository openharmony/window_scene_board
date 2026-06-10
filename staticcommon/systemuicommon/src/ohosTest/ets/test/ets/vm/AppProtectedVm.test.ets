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

import { beforeEach, it, describe, expect } from '@ohos/hypium';
import { AppProtectedVm } from '../../../../../main/ets/vm/AppProtectedVm';

const DEFAULT: number = 0;

export function AppProtectedVmTest() {
  describe('AppProtectedVmTest', (): void => {
    const appProtectVm: AppProtectedVm = AppProtectedVm.get();
    beforeEach((): void => {
      appProtectVm.protectedAppSet.add('com.ohos.AutoRegService_0');
      appProtectVm.protectedAppSet.add('com.ohos.airtouchservice_0');
    })
    it('initTest', DEFAULT, initTest);
    it('isProtectedTest', DEFAULT, isProtectedTest);
  })
}

async function initTest(done: Function): Promise<void> {
  const appProtectedVm = AppProtectedVm.get();
  await appProtectedVm.init();
  const protectedCount = appProtectedVm.protectedAppSet.size;
  expect(protectedCount).assertLargerOrEqual(2);
  done();
}

function isProtectedTest(): void {
  const appProtectedVm = AppProtectedVm.get();
  const isAutoRegServiceProtected = appProtectedVm.isProtected('com.ohos.AutoRegService_0');
  const isAirtouchserviceProtected = appProtectedVm.isProtected('com.ohos.airtouchservice_0');
  const isAutoRegService_1Protected = appProtectedVm.isProtected('com.ohos.AutoRegService_1');
  expect(isAutoRegServiceProtected).assertTrue();
  expect(isAirtouchserviceProtected).assertTrue();
  expect(isAutoRegService_1Protected).assertFalse();
}