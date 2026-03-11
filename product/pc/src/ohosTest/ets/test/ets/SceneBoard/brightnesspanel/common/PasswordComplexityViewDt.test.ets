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

import osAccount from '@ohos.account.osAccount';
import account_osAccount from '@ohos.account.osAccount';
import util from '@ohos.util';
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import PasswordComplexityViewModel
  from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/vm/PasswordComplexityViewModel';

const TAG = 'ScreenLock-PasswordComplexityViewTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default function PasswordComplexityViewTest() {
  describe('PasswordComplexityViewTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })


    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.name: 新密码默认规格验证：锁屏密码由6-32位字符组成，且不含非法字符
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 锁屏密码由5位字符组成
     */
    it('checkNewPasswordInputDefaultFormat_101', 0, checkNewPasswordInputDefaultFormat_101);

    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 锁屏密码由33位字符组成
     */
    it('checkNewPasswordInputDefaultFormat_102', 0, checkNewPasswordInputDefaultFormat_102);

    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.name: 新密码默认规格验证：锁屏密码由6-32位字符组成，且不含非法字符
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 锁屏密码含非法字符
     */
    it('checkNewPasswordInputDefaultFormat_103', 0, checkNewPasswordInputDefaultFormat_103);

    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.name: 新密码默认规格验证：锁屏密码由6-32位字符组成，且不含非法字符
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 锁屏密码由6-32位字符组成，且不含非法字符
     */
    it('checkNewPasswordInputDefaultFormat_104', 0, checkNewPasswordInputDefaultFormat_104);

    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.name: EDM已设置密码复杂度且密码长度为0
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 假设EDM已设置密码复杂度且密码长度为0情况
     */
    it('checkNewPasswordInputDefaultFormat_105', 0, checkNewPasswordInputDefaultFormat_105);

    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.name: 新密码密码复杂度规格校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 密码长度小于最小长度
     */
    it('checkPasswordComplexity_101', 0, checkPasswordComplexity_101);

    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.name: 新密码密码复杂度规格校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 密码长度大于最大长度
     */
    it('checkPasswordComplexity_102', 0, checkPasswordComplexity_102);

    /**
     * @tc.number:checkNewPasswordInputDefaultFormat
     * @tc.name: 新密码密码复杂度规格校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 密码长度符合要求
     */
    it('checkPasswordComplexity_103', 0, checkPasswordComplexity_103);

    /*
      * @tc.number:checkConfirmPasswordInput
      * @tc.name: 确认密码输入框校验
      * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
      * @tc.desc: 新密码和确认密码输入不一致
      */
    it('checkConfirmPasswordInput_101', 0, checkConfirmPasswordInput_101);

    /*
     * @tc.number:checkConfirmPasswordInput
     * @tc.name: 确认密码输入框校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 新密码和确认密码输入不一致
     */
    it('checkConfirmPasswordInput_102', 0, checkConfirmPasswordInput_102);

    /*
     * @tc.number:checkOldPasswordInput
     * @tc.name: 旧密码输入框校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 密码为空时，校验旧密码输入框
     */
    it('checkOldPasswordInput_101', 0, checkOldPasswordInput_101);

    /*
     * @tc.number:checkOldPasswordInput
     * @tc.name: 旧密码输入框校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 输入正确密码验证
     */
    it('checkOldPasswordInput_102', 0, checkOldPasswordInput_102);

    /*
    * @tc.number:checkOldPasswordInput
    * @tc.name: 旧密码输入框校验
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 校验旧密码输入框 :密码校验失败但未冻结
    */
    it('checkOldPasswordInput_104', 0, checkOldPasswordInput_104);

    /*
   * @tc.number:checkOldPasswordInput
   * @tc.name: 旧密码输入框校验
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: 校验旧密码输入框 : 校验成功
   */
    it('checkOldPasswordInput_105', 0, checkOldPasswordInput_105);

    /*
    * @tc.number:checkOldPasswordInput
    * @tc.name: 旧密码输入框校验
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 校验旧密码输入框 :输入正确密码
    */
    it('checkOldPasswordInput_106', 0, checkOldPasswordInput_106);

    /*
    * @tc.number:updatePassword
    * @tc.name: 输入错误密码，验证更新密码
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 输入错误密码，验证更新密码
    */
    it('updatePassword_101', 0, updatePassword_101);

    /*
    * @tc.number:refreshPrompt
    * @tc.name: 刷新密码提示
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 刷新密码提示
    */
    it('refreshPrompt_101', 0, refreshPrompt_101);

    /*
   * @tc.number:dealPwdAuthResult
   * @tc.name: 处理旧密码校验结果
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: 处理旧密码校验结果
   */
    it('dealPwdAuthResult_101', 0, dealPwdAuthResult_101);

    /*
   * @tc.number:dealRecKeyAuthResult
   * @tc.name: 处理恢复密钥校验结果
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: 处理恢复密钥校验结果
   */
    it('dealRecKeyAuthResult_101', 0, dealRecKeyAuthResult_101);

  })


}


/**
 * 新密码默认规格校验：锁屏密码由5位字符组成
 */
function checkNewPasswordInputDefaultFormat_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.isDetailIconShow = false;
  psdcVM.newPasswordInput = '1234x';
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertTrue()
}

/**
 * 新密码默认规格校验：锁屏密码由33位字符组成
 */
function checkNewPasswordInputDefaultFormat_102() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.isDetailIconShow = false;
  psdcVM.newPasswordInput = '1234x1234512345123451234512345123';
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertTrue()
}

/**
 * 新密码默认规格校验：锁屏密码含非法字符
 */
function checkNewPasswordInputDefaultFormat_103() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.isDetailIconShow = false;
  psdcVM.newPasswordInput = '123456~';
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertTrue()
}

/**
 * EDM已设置密码复杂度且新密码为空
 */
function checkNewPasswordInputDefaultFormat_105() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.isDetailIconShow = true;
  psdcVM.newPasswordInput = '';
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertFalse()
}

/**
 * EDM已设置密码复杂度且密码长度为0
 */
function checkNewPasswordInputDefaultFormat_104() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.isDetailIconShow = false;
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertFalse()
}

/**
 * 新密码密码复杂度规格校验: 在长度在2-4的范围内时，长度为1
 */
function checkPasswordComplexity_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.minLength = 2;
  psdcVM.maxLength = 4;
  psdcVM.isDetailIconShow = true;
  psdcVM.newPasswordInput = '1';
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertTrue();
}

function checkPasswordComplexity_102() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.minLength = 2;
  psdcVM.maxLength = 4;
  psdcVM.isDetailIconShow = true;
  psdcVM.newPasswordInput = '12345';
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertTrue();
}

function checkPasswordComplexity_103() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.minLength = 2;
  psdcVM.maxLength = 4;
  psdcVM.isDetailIconShow = true;
  psdcVM.newPasswordInput = '123';
  psdcVM.checkNewPasswordInput();
  expect(psdcVM.isNewPasswordWarningShow).assertFalse();
}

function checkConfirmPasswordInput_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.newPasswordInput = '1234567';
  psdcVM.confirmPasswordInput = '123456';
  psdcVM.checkConfirmPasswordInput();
  expect(psdcVM.isConfirmPasswordWarningShow).assertTrue();

}

function checkConfirmPasswordInput_102() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.newPasswordInput = '123456';
  psdcVM.confirmPasswordInput = '123456';
  psdcVM.checkConfirmPasswordInput();
  expect(psdcVM.isConfirmPasswordWarningShow).assertFalse();
}

async function checkOldPasswordInput_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.oldPasswordInput = '';
  psdcVM.isOldPasswordChanged = false;
  psdcVM.checkOldPasswordInput();
  expect(psdcVM.isOldPasswordWarningShow).assertFalse();
}

async function checkOldPasswordInput_102() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  psdcVM.oldPasswordInput = '123456';
  psdcVM.isOldPasswordChanged = false;
  psdcVM.checkOldPasswordInput();
  expect(psdcVM.isOldPasswordWarningShow).assertFalse();
}

async function checkOldPasswordInput_104() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  let extraInfo: osAccount.AuthResult = {
    remainTimes: 5,
    freezingTime: 0,
  };
  await psdcVM.resultHandle(1230001, extraInfo);
  expect(psdcVM.isOldPasswordWarningShow).assertTrue();
}

async function checkOldPasswordInput_105() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  let extraInfo: osAccount.AuthResult = {};
  await psdcVM.resultHandle(0, extraInfo);
  expect(psdcVM.isOldPasswordWarningShow).assertFalse();
}

async function checkOldPasswordInput_106() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  let password = '123456';
  addPin(password, () => {
  });
  psdcVM.oldPasswordInput = '123456';
  psdcVM.isOldPasswordChanged = true;
  psdcVM.checkOldPasswordInput(() => {
  }, () => {
  });
  expect(psdcVM.isOldPasswordWarningShow).assertFalse();
  deletePin(password);
}

async function updatePassword_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  let password = '123456';
  addPin(password, () => {
  });
  psdcVM.oldPasswordInput = '123456';
  psdcVM.newPasswordInput = '123456';
  try {
    psdcVM.updatePin(() => {
    }, () => {
    });
    deletePin(password);
    return;
  } catch (e) {
    deletePin(password);
  }
  expect(false).assertTrue();

}

async function refreshPrompt_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  let password = '123456';
  addPin(password, () => {
    psdcVM.oldPasswordInput = '123456';
    psdcVM.refreshPrompt();
    expect(psdcVM.isOldPasswordWarningShow).assertFalse();
    deletePin(password);
  });
}

function addPin(addPassword: string, successCallback: Callback<void>): void {
  // 设置锁屏密码
  let textEncoder = new util.TextEncoder();
  let password: Uint8Array = textEncoder.encode(addPassword);
  let pinAuth: account_osAccount.PINAuth = new account_osAccount.PINAuth();
  pinAuth.unregisterInputer();
  pinAuth.registerInputer({
    onGetData: (authSubType: account_osAccount.AuthSubType, callback: account_osAccount.IInputData) => {
      callback.onSetData(authSubType, password);
    }
  });
  let credentialInfo: account_osAccount.CredentialInfo = {
    credType: account_osAccount.AuthType.PIN,
    credSubType: account_osAccount.AuthSubType.PIN_MIXED,
    token: new Uint8Array([]),
  };
  let userIDM = new account_osAccount.UserIdentityManager();
  userIDM.openSession((err: BusinessError, challenge: Uint8Array) => {
    try {
      userIDM.addCredential(credentialInfo, {
        onResult: (result: number, extraInfo: account_osAccount.RequestResult) => {
          log.showInfo(`add pin result :${result}`);
          dealResult(result, successCallback);
        }
      });
    } catch (e) {
      log.showError(` add pin failed message: ${(e as BusinessError).message}`);
    }
  });
}

function dealResult(result: number, successCallback: Callback<void>){
  if (result === 0) {
    successCallback();
  }
}

function deletePin(delPassword: string): void {
  try {
    let pinAuth: osAccount.PINAuth = new osAccount.PINAuth();
    let textEncoder = new util.TextEncoder();
    let password: Uint8Array = textEncoder.encode(delPassword);
    let credentialInfo: osAccount.CredentialInfo = {
      credType: osAccount.AuthType.PIN,
      credSubType: osAccount.AuthSubType.PIN_MIXED,
      token: new Uint8Array([]),
    };
    pinAuth.unregisterInputer();
    // 用旧密码注册PIN码输入器
    pinAuth.registerInputer({
      onGetData: (authSubType: osAccount.AuthSubType, callback: osAccount.IInputData) => {
        callback.onSetData(authSubType, password);
      }
    });
    deletePinDetail(pinAuth, credentialInfo);

  } catch (e) {
    log.showError(` delete pin failed message: ${(e as BusinessError).message}`);
  }
}


function deletePinDetail(pinAuth: osAccount.PINAuth, credentialInfo: osAccount.CredentialInfo) {
  let userIDM = new osAccount.UserIdentityManager();
  let userAuth: osAccount.UserAuth = new osAccount.UserAuth();
  let authOptions: osAccount.AuthOptions = {
    authIntent: osAccount.AuthIntent.UNLOCK
  };
  userIDM.openSession((err: BusinessError, challenge: Uint8Array) => {
    userAuth.auth(challenge, credentialInfo.credType, osAccount.AuthTrustLevel.ATL4, authOptions, {
      onResult: (result: number, extraInfo: osAccount.AuthResult) => {
        if (result !== osAccount.ResultCode.SUCCESS) {
          pinAuth.unregisterInputer();
          return;
        }
        if (extraInfo && extraInfo.token) {
          let token: Uint8Array = extraInfo.token;
          delUser(token);
        }
        pinAuth.unregisterInputer();
      }
    });
  })
}

function delUser(token: Uint8Array) {
  let userIDM = new osAccount.UserIdentityManager();
  userIDM.delUser(token, {
    onResult: (result: number, extraInfo: osAccount.RequestResult) => {
      log.showInfo(`delete pin result :${result}`);
    }
  });
}

function dealPwdAuthResult_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  let pinAuth: osAccount.PINAuth = new osAccount.PINAuth();
  let credentialInfo: osAccount.CredentialInfo = {
    credType: osAccount.AuthType.RECOVERY_KEY,
    credSubType: 0,
    token: new Uint8Array([]),
  };
  let extraInfo: osAccount.AuthResult = {
    remainTimes: 5,
    freezingTime: 0,
  };
  let result: number = 0;
  psdcVM.dealPwdAuthResult(pinAuth, credentialInfo, result, extraInfo,
    () => {
    });
  expect(psdcVM.isUpdatePinSuccess).assertFalse();
}

function dealRecKeyAuthResult_101() {
  let psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  let pinAuth: osAccount.PINAuth = new osAccount.PINAuth();
  let credentialInfo: osAccount.CredentialInfo = {
    credType: osAccount.AuthType.RECOVERY_KEY,
    credSubType: 0,
    token: new Uint8Array([]),
  };
  let extraInfo: osAccount.AuthResult = {
    remainTimes: 5,
    freezingTime: 0,
  };
  let result: number = 0;
  psdcVM.dealRecKeyAuthResult(pinAuth, credentialInfo, result, extraInfo,
    () => {
    }, () => {
    });
  expect(psdcVM.isUpdatePinSuccess).assertFalse();
}