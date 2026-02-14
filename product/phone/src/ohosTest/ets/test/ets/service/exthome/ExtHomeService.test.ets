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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when, ArgumentMatchers }
  from '@ohos/hypium';
import { ExtHomeService } from '@ohos/phonebase/src/main/ets/service/exthome/ExtHomeService';
import { CallResult, IExecutor } from '@ohos/phonebase/src/main/ets/service/exthome/executor/IExecutor';
import { InvokeUnlock } from '@ohos/phonebase/src/main/ets/service/exthome/executor/impl/invokeUnlock';
import { BundleVerifyUtils } from '@ohos/phonebase/src/main/ets/service/exthome/BundleVerifyUtils';

/**
 * ExtHomeService DT测试套
 */
export default function ExtHomeServiceTest() {
  describe('ExtHomeServiceTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('ExtHomeService_onCall_return_invalid_method', Level.LEVEL0, async (done: Function) => {
      let extHomeService: ExtHomeService = new ExtHomeService();
      expect(extHomeService).not().assertNull();
      done();
    })

    it('ExtHomeService_onCall_return_unknown_method', Level.LEVEL0, async (done: Function) => {
      let extHomeService: ExtHomeService = new ExtHomeService();
      expect(extHomeService).not().assertNull();
      let result: string = await extHomeService.onCall('{"method":"test"}');
      expect(result).assertEqual(CallResult.UNKNOWN_METHOD);
      done();
    })

    it('ExtHomeService_onCall_return_verify_failed', Level.LEVEL0, async (done: Function) => {
      let extHomeService: ExtHomeService = new ExtHomeService();
      expect(extHomeService).not().assertNull();
      const mocker: MockKit = new MockKit();
      const verifyIdentityMock: Function = mocker.mockFunc(extHomeService,extHomeService.verifyIdentity);
      when(verifyIdentityMock)(ArgumentMatchers.any).afterReturn(false);
      let result: string = await extHomeService.onCall('{"method":"FaceVerify"}');
      expect(result).assertEqual(CallResult.VERIFY_FAILED);
      mocker.clear(extHomeService);
      mocker.clearAll();
      done();
    })

    it('ExtHomeService_onCall_return_success', Level.LEVEL0, async (done: Function) => {
      let extHomeService: ExtHomeService = new ExtHomeService();
      expect(extHomeService).not().assertNull();
      const mocker: MockKit = new MockKit();
      const verifyIdentityMock: Function = mocker.mockFunc(extHomeService,extHomeService.verifyIdentity);
      when(verifyIdentityMock)(ArgumentMatchers.any).afterReturn(true);
      let result: string = await extHomeService.onCall('{"method":"FaceVerify"}');
      expect(result).assertEqual(CallResult.SUCCESS);
      mocker.clear(extHomeService);
      mocker.clearAll();
      done();
    })

    it('test_onCall_001', Level.LEVEL0, async (done: Function) => {
      let extHomeService: ExtHomeService = new ExtHomeService();
      let res0 = await extHomeService.onCall('undefined');
      expect(res0).assertEqual(CallResult.FAIL);
      let json: string = 'errorjson';
      let res = await extHomeService.onCall(json);
      expect(res).assertEqual(CallResult.FAIL);
      let json1: string = '"extra":"{"test":"testvalue"}"';
      let res1 = await extHomeService.onCall(json1);
      expect(res1).assertEqual(CallResult.FAIL);
      done();
    })

    it('test_verifyIdentity1', Level.LEVEL0, async (done: Function) => {
      let extHomeService: ExtHomeService = new ExtHomeService();
      let executor = (): IExecutor => new InvokeUnlock();
      let whiteItem : string = 'com.ohos.outerhome';
      let mocker: MockKit = new MockKit();
      let mockerFunc: Function = mocker.mockFunc(BundleVerifyUtils,BundleVerifyUtils.getBundleName);
      when(mockerFunc)().afterReturn('test');
      let res = await extHomeService.verifyIdentity(executor());
      expect(res).assertEqual(false);
      when(mockerFunc)().afterReturn(whiteItem);
      let mockerFunc1: Function = mocker.mockFunc(BundleVerifyUtils,BundleVerifyUtils.isSystemApp);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(false);
      let res1 = await extHomeService.verifyIdentity(executor());
      expect(res1).assertEqual(false);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(true);
      await extHomeService.verifyIdentity(executor());
      expect(BundleVerifyUtils.isSystemApp(whiteItem)).assertEqual(true);
      mocker.clear(BundleVerifyUtils);
      mocker.clearAll();
      done();
    })

  })
}