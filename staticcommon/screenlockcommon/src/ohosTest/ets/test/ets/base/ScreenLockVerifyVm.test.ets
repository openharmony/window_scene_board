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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers, when } from '@ohos/hypium'
import { AcquireExtraInfo, BaseVerifyViewVm, VerifyResult } from '../../../../../main/ets/TsIndex'
import { AuthType } from '../../../../../main/ets/utils/AccountHelper'

export default function ScreenLockVerifyVmTest() {
  describe('ScreenLockVerifyVmTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_onVerifyResult_1', 0, () => {
      let verifyObj = new MyVerifyViewVm(16);
      verifyObj.onVerifyResult(AuthType.FACE, VerifyResult.SUCCESS);
      expect(verifyObj.faceVerifyState).assertEqual(true);
      verifyObj.onVerifyResult(AuthType.FACE, VerifyResult.FAIL);
      expect(verifyObj.faceVerifyState).assertEqual(false);
      verifyObj.onVerifyResult(AuthType.FACE, VerifyResult.OTHER_SUCCESS);
      expect(verifyObj.faceVerifyState).assertEqual(false);
    })

    it('test_onVerifyResult_2', 0, () => {
      let verifyObj = new MyVerifyViewVm(16);
      verifyObj.onVerifyResult(AuthType.FINGERPRINT, VerifyResult.SUCCESS);
      expect(verifyObj.fingerVerifyState).assertEqual(true);
      verifyObj.onVerifyResult(AuthType.FINGERPRINT, VerifyResult.FAIL);
      expect(verifyObj.fingerVerifyState).assertEqual(false);
      verifyObj.onVerifyResult(AuthType.FINGERPRINT, VerifyResult.OTHER_SUCCESS);
      expect(verifyObj.fingerVerifyState).assertEqual(true);
      verifyObj.onVerifyResult(AuthType.FINGERPRINT, 666);
      expect(verifyObj.fingerVerifyState).assertEqual(true);
    })

    it('test_onVerifyResult_3', 0, () => {
      let verifyObj = new MyVerifyViewVm(16);
      verifyObj.onVerifyResult(AuthType.DOMAIN, VerifyResult.SUCCESS);
      expect(verifyObj.fingerVerifyState).assertEqual(false);
    })

    it('test_onAcquireInfo_1', 0, () => {
      let verifyObj = new MyVerifyViewVm(16);
      let info: AcquireExtraInfo = {
        authResult: 1,
        authRemainAttempts: 2,
        lockoutDuration: 3,
        userId: 20241226
      };
      verifyObj.onAcquireInfo(AuthType.FACE, 2024, 1226, info);
      expect(verifyObj.extraInfo.userId).assertEqual(20241226);
    })

    it('test_onAcquireInfo_2', 0, () => {
      let verifyObj = new MyVerifyViewVm(16);
      let info: AcquireExtraInfo = {
        authResult: 0,
        authRemainAttempts: 2,
        lockoutDuration: 3,
        userId: 20241226
      };
      verifyObj.onAcquireInfo(AuthType.FINGERPRINT, 2024, 1226, info);
      expect(verifyObj.extraInfo.userId).assertEqual(20241226);
      verifyObj.onAcquireInfo(AuthType.FINGERPRINT, 2024, 10001, info);
      expect(verifyObj.extraInfo.userId).assertEqual(20241226);
      info.authResult = 1;
      verifyObj.onAcquireInfo(AuthType.FINGERPRINT, 2024, 10001, info);
      expect(verifyObj.extraInfo.userId).assertEqual(20241226);
      info.authResult = 9;
      verifyObj.onAcquireInfo(AuthType.FINGERPRINT, 2024, 10001, info);
      expect(verifyObj.extraInfo.userId).assertEqual(20241226);
      info.authResult = 10;
      verifyObj.onAcquireInfo(AuthType.FINGERPRINT, 2024, 10001, info);
      expect(verifyObj.extraInfo.userId).assertEqual(20241226);
    })

    it('test_onAcquireInfo_3', 0, () => {
      let verifyObj = new MyVerifyViewVm(16);
      let info: AcquireExtraInfo = {
        authResult: 1,
        authRemainAttempts: 2,
        lockoutDuration: 3,
        userId: 20241226
      };
      verifyObj.onAcquireInfo(AuthType.DOMAIN, 2024, 1226, info);
      expect(verifyObj.extraInfo.userId).assertEqual(0);
    })

    it('test_onFingerprintAcquireInfo', 0, () => {
      let obj = new MyVerifyViewVm(16);
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(obj, (obj as object)['isNeedStrongAuth']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let info: AcquireExtraInfo = {
        authResult: 1,
        authRemainAttempts: 2,
        lockoutDuration: 3,
        userId: 20241227
      };
      obj.onFingerprintAcquireInfo(2024, 1227, info);
      expect(obj.extraInfo.userId).assertEqual(20241227);
      mocker.clear(obj);
      mocker.clearAll();
    })
  })
}

class MyVerifyViewVm extends BaseVerifyViewVm {
  public fingerVerifyState: boolean;
  public faceVerifyState: boolean;
  public extraInfo: AcquireExtraInfo = {
    authResult: 0,
    authRemainAttempts: 0,
    lockoutDuration: 0,
    userId: 0
  };

  protected isNeedHandleVerifyResult(): boolean {
    throw new Error('Method not implemented.')
  }

  constructor(persistentId: number) {
    super(persistentId);
    this.fingerVerifyState = false;
    this.faceVerifyState = false;
  }

  public onVerifyResult(authType: AuthType, verifyResult: VerifyResult): void {
    super.onVerifyResult(authType, verifyResult);
  }

  public onFaceVerifyResult(verifyResult: VerifyResult): void {
    super.onFaceVerifyResult(verifyResult);
  }

  public onFingerVerifyResult(verifyResult: VerifyResult): void {
    super.onFingerVerifyResult(verifyResult);
  }

  public onFaceVerifySuccess() {
    this.faceVerifyState = true;
  }

  public onFaceVerifyFail() {
    this.faceVerifyState = false;
  }

  public onFingerVerifySuccess() {
    this.fingerVerifyState = true;
  }

  public onFingerVerifyFail() {
    this.fingerVerifyState = false;
  }

  public onFingerVerifyOtherSuccess() {
    this.fingerVerifyState = true;
  }

  public onAcquireInfo(authType: AuthType, module: number, acquire: number, extraInfo: AcquireExtraInfo): void {
    super.onAcquireInfo(authType, module, acquire, extraInfo);
  }

  public onFaceAcquireInfo(module: number, acquire: number, extraInfo: AcquireExtraInfo): void {
    super.onFaceAcquireInfo(module, acquire, extraInfo);
    this.extraInfo = extraInfo;
  }

  public onFingerprintAcquireInfo(module: number, acquire: number, extraInfo: AcquireExtraInfo): void {
    super.onFingerprintAcquireInfo(module, acquire, extraInfo);
    this.extraInfo = extraInfo;
  }
}