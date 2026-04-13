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

import { ArgumentMatchers, describe, it, Level, MockKit, TestType, when } from '@ohos/hypium';
import { BundleUtils, CallerInfo } from '@ohos/themeservicebase/Index';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { Illegal, OHOS_TEST_openharmony_APP } from '../../../core/remote/TSOhosRemoteCallerInfo';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';
import { BundleMocker } from '../../../mock/BundleMocker';

export default function TrustCallerInterceptorTest() {
  describe('TrustCallerInterceptorTest', () => {
    it('Illegal_bundleName', TestType.SAFETY | Level.LEVEL0, async () => {
      await testIllegalCaller(Illegal.bundleName);
    })
    it('Illegal_appIdentifier', TestType.SAFETY | Level.LEVEL0, async () => {
      await testIllegalCaller(Illegal.appIdentifier);
    })
    it('Illegal_appId', TestType.SAFETY | Level.LEVEL0, async () => {
      await testIllegalCaller(Illegal.appId);
    })
    it('Illegal_fingerprint', TestType.SAFETY | Level.LEVEL0, async () => {
      await testIllegalCaller(Illegal.fingerprint);
    })

    it('undefined_callerBundleName', TestType.SAFETY | Level.LEVEL0, async () => {
      let mocker: MockKit = new MockKit()
      let getBundleNameByUidFun: Function = mocker.mockFunc(BundleUtils, BundleUtils.getBundleNameByUid)
      when(getBundleNameByUidFun)(ArgumentMatchers.any).afterReturn(Promise.resolve(undefined));
      await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi().trustCallerTest(), RemoteCode
        .ERR_OHOS_ERROR);
      mocker.clear(BundleUtils);
      mocker.clearAll();
    })

    it('undefined_signatureInfo', TestType.SAFETY | Level.LEVEL0, async () => {
      let mocker: MockKit = new MockKit()
      let getBundleNameByUidFun: Function = mocker.mockFunc(BundleUtils, BundleUtils.getBundleNameByUid)
      when(getBundleNameByUidFun)(ArgumentMatchers.any).afterReturn(Promise.resolve(OHOS_TEST_openharmony_APP.bundleName));

      let getBundleSignatureFun: Function = mocker.mockFunc(BundleUtils, BundleUtils.getBundleSignature)
      when(getBundleSignatureFun)(ArgumentMatchers.any).afterReturn(Promise.resolve(undefined));

      await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi().trustCallerTest(), RemoteCode
        .ERR_OHOS_ERROR);
      mocker.clear(BundleUtils);
      mocker.clearAll();
    })
  })
}

async function testIllegalCaller(callerInfo: CallerInfo): Promise<void> {
  let mockKit: MockKit = BundleMocker.mock(callerInfo);
  await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi().trustCallerTest(), RemoteCode
    .ERR_ILLEGAL_CALLER);
  BundleMocker.clear(mockKit);
}