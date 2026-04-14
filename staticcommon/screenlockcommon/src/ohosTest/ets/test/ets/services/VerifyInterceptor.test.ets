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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when,ArgumentMatchers } from '@ohos/hypium'
import { osAccount } from '@kit.BasicServicesKit'
import { AcquireExtraInfo, ResultHandler } from '../../../../../main/ets/services/ScreenLockVerifyService'
import { CommonFaceInterceptor,
  CommonFingerprintInterceptor,
  CommonPwdInterceptor } from '../../../../../main/ets/services/VerifyInterceptor'
import { FaceUnlockConstants, FaceUnlockVerifyState } from '../../../../../main/ets/TsIndex'
import { AuthType, IAMAuthResult } from '../../../../../main/ets/utils/AccountHelper'


export default function VerifyInterceptorTest() {
  describe('VerifyInterceptorTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    let handler: ResultHandler = {
      authType: AuthType.PIN,
      authTypeStr: '',
      setHasHandleResult: (): void => { },
      setHasHandleAcquireInfo: (): void => { },
      broadcastResult: (result: number): void => { },
      broadcastAcquireInfo: (module: number, acquire: number, extraInfo: AcquireExtraInfo): void => { },
      sendAuthResultToOuterHome: (result: number): void => { }
    }
    let extraInfo: AcquireExtraInfo = {
      authResult: 0,
      authRemainAttempts: 0,
      lockoutDuration: 0,
      userId: 0
    };

    it('CommonPwdInterceptorTest_onAcquireInfo_001', Level.LEVEL0, () => {
      let instance = new CommonPwdInterceptor();
      let result = instance.onAcquireInfo(handler, 1, 1, extraInfo);
      expect(result).assertTrue();

      result = instance.onAcquireInfo(handler, 1, 0, extraInfo);
      expect(result).assertTrue();
    })

    it('CommonFaceInterceptorTest_onAcquireInfo_002', Level.LEVEL0, () => {
      let instance = new CommonFaceInterceptor();
      if(instance['_verifyStateListener'].onVerifyStateChange){
        let result = instance['_verifyStateListener'].onVerifyStateChange(AuthType.PIN, false);
        expect(result == null).assertTrue();

        result = instance['_verifyStateListener'].onVerifyStateChange(AuthType.FACE, false);
        expect(result == null).assertTrue();

        result = instance['_verifyStateListener'].onVerifyStateChange(AuthType.FACE, true);
        expect(result == null).assertTrue();
      }
    })

    it('CommonFaceInterceptorTest_onAcquireInfo_003', Level.LEVEL0, () => {
      let instance = new CommonFaceInterceptor();
      let result = instance.onAcquireInfo(handler, 1, FaceUnlockConstants.FACE_AUTH_TIP_AUTH_SUCCESS, extraInfo);
      expect(result).assertTrue();

      result = instance.onAcquireInfo(handler, 1, FaceUnlockConstants.FACE_UNLOCK_ANIMATOR_DURATION, extraInfo);
      expect(result).assertFalse();
    })

    it('CommonFaceInterceptorTest_doInit_004', Level.LEVEL0, () => {
      let instance = new CommonFaceInterceptor();
      let result = instance['doInit']();
      expect(result == null).assertTrue();
    })

    it('CommonFaceInterceptorTest_doRelease_005', Level.LEVEL0, () => {
      let instance = new CommonFaceInterceptor();
      let result = instance['doRelease']();
      expect(result == null).assertTrue();
    })

    it('CommonFaceInterceptorTest_handleFaceAuthResult_006', Level.LEVEL0, () => {
      let instance = new CommonFaceInterceptor();
      AppStorage.set(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.LOCKED);
      let result = instance['handleFaceAuthResult'](handler, 1);
      expect(result == null).assertTrue();

      AppStorage.set(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.SUCCESS);
      result = instance['handleFaceAuthResult'](handler,1);
      expect(result == null).assertTrue();

      AppStorage.set(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.VERIFYING);
      result = instance['handleFaceAuthResult'](handler,IAMAuthResult.SUCCEED);
      expect(result == null).assertTrue();

      result = instance['handleFaceAuthResult'](handler,IAMAuthResult.INCORRECT_CREDENTIAL);
      expect(result == null).assertTrue();

      result = instance['handleFaceAuthResult'](handler,IAMAuthResult.AUTH_TIMEOUT);
      expect(result == null).assertTrue();

      result = instance['handleFaceAuthResult'](handler,IAMAuthResult.AUTH_LOCKED);
      expect(result == null).assertTrue();

      result = instance['handleFaceAuthResult'](handler,IAMAuthResult.AUTH_IS_CANCELED);
      expect(result == null).assertTrue();

      result = instance['handleFaceAuthResult'](handler,IAMAuthResult.CREDENTIAL_NOT_ENROLLED);
      expect(result == null).assertTrue();

      result = instance['handleFaceAuthResult'](handler,IAMAuthResult.INVALID_PARAM);
      expect(result == null).assertTrue();
    })

    it('CommonFaceInterceptorTest_setFaceRecognitionState_007', Level.LEVEL0, () => {
      let instance = new CommonFaceInterceptor();
      AppStorage.set(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.LOCKED);
      let result = instance['setFaceRecognitionState'](1);
      expect(result == null).assertTrue();

      AppStorage.set(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.SUCCESS);
      result = instance['setFaceRecognitionState'](1);
      expect(result == null).assertTrue();
    })

    it('CommonFaceInterceptorTest_sendFaceUnlockEvent_008', Level.LEVEL0, () => {
      let instance = new CommonFaceInterceptor();
      let result = instance['sendFaceUnlockEvent']();
      expect(result == null).assertTrue();
    })

    it('CommonFingerprintInterceptorTest_sendFaceUnlockEvent_009', Level.LEVEL0, () => {
      let instance = new CommonFingerprintInterceptor();
      let result = instance.onAcquireInfo(handler, 1, 6, extraInfo);
      expect(result).assertTrue();

      result = instance.onAcquireInfo(handler, 1, 10001, extraInfo);
      expect(result).assertTrue();
    })

    it('CommonFingerprintInterceptorTest_handleTipsResult_010', Level.LEVEL0, () => {
      let instance = new CommonFingerprintInterceptor();
      let result = instance['handleTipsResult'](handler, null);
      expect(result == null).assertTrue();

      extraInfo.authResult = osAccount.ResultCode.SUCCESS;
      result = instance['handleTipsResult'](handler, extraInfo);
      expect(result == null).assertTrue();

      extraInfo.authResult = osAccount.ResultCode.FAIL;
      result = instance['handleTipsResult'](handler, extraInfo);
      expect(result == null).assertTrue();

      extraInfo.authResult = osAccount.ResultCode.LOCKED;
      result = instance['handleTipsResult'](handler, extraInfo);
      expect(result == null).assertTrue();

      extraInfo.authResult = osAccount.ResultCode.NOT_ENROLLED;
      result = instance['handleTipsResult'](handler, extraInfo);
      expect(result == null).assertTrue();
    })

  })
}