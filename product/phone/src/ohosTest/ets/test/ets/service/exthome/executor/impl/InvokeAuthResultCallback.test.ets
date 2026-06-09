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

import rpc from '@ohos.rpc';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { GlobalStatusCache } from '@ohos/screenlockcommon';
import { BundleVerifyUtils } from '@ohos/phonebase/src/main/ets/service/exthome/BundleVerifyUtils';
import { InvokeAuthResultCallback } from '@ohos/phonebase/src/main/ets/service/exthome/executor/impl/InvokeAuthResultCallback';

/**
 * InvokeAuthResultCallback DT测试套
 */
export default function InvokeAuthResultCallbackTest() {
  describe('InvokeAuthResultCallbackTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('InvokeFace_execute_null_remoteObject', Level.LEVEL0, async (done: Function) => {
      let invokeAuthResultCallback: InvokeAuthResultCallback = new InvokeAuthResultCallback();
      expect(invokeAuthResultCallback).not().assertNull();
      let extra: object = new Object();
      invokeAuthResultCallback.execute(extra, null);
      expect(invokeAuthResultCallback.mRemoteObject).assertNull();
      done();
    })

    it('InvokeFace_execute_normal_mode', Level.LEVEL0, async (done: Function) => {
      let invokeAuthResultCallback: InvokeAuthResultCallback = new InvokeAuthResultCallback();
      expect(invokeAuthResultCallback).not().assertNull();
      let extra: object = new Object();
      let remoteObject = new rpc.RemoteObject('test');
      invokeAuthResultCallback.execute(extra, remoteObject);
      expect(invokeAuthResultCallback.mRemoteObject).not().assertNull();
      expect(invokeAuthResultCallback.mRemoteObject?.getDescriptor()).assertEqual('test');
      done();
    })

    it('test_InvokeAuthResultCallback_execute', Level.LEVEL0, async (done: Function) => {
      let invokeAuthResultCallback: InvokeAuthResultCallback = new InvokeAuthResultCallback();
      let extra: object = new Object();
      let remoteObject = new rpc.RemoteObject('test');
      invokeAuthResultCallback.mRemoteObject = new rpc.RemoteObject('test');
      let statusCache: GlobalStatusCache = GlobalStatusCache.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(statusCache, statusCache.getStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      invokeAuthResultCallback.execute(extra, remoteObject);
      expect(invokeAuthResultCallback).not().assertNull();
      mocker.clear(statusCache);
      mocker.clearAll();
      done();
    })

    it('test_InvokeAuthResultCallback_verifyIdentity', Level.LEVEL0, async (done: Function) => {
      let invokeAuthResultCallback: InvokeAuthResultCallback = new InvokeAuthResultCallback();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(BundleVerifyUtils, BundleVerifyUtils.hasPermission);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = await invokeAuthResultCallback.verifyIdentity('');
      expect(result).assertFalse();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result1: boolean = await invokeAuthResultCallback.verifyIdentity('');
      expect(result1).assertTrue();
      mocker.clear(BundleVerifyUtils);
      mocker.clearAll();
      done();
    })
  })
}
