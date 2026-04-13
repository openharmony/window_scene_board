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
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { VerifyDataManager, VerifyInfo } from '../manager/VerifyDataManager';
import {
  AcquireExtraInfo,
  ScreenLockVerifyService,
  VerifyResult,
  VerifyStateListener
} from '../services/ScreenLockVerifyService';
import { AccountHelper, AuthType } from '../utils/AccountHelper';
import { BaseViewVm } from './ScreenLockVmViewInf';

const TAG = 'BaseVerifyViewVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 验证提示码
 */
export enum AcquireResultCode {
  /**
   * 成功
   */
  SUCCESS = osAccount.ResultCode.SUCCESS,

  /**
   * 失败
   */
  FAIL = osAccount.ResultCode.FAIL,

  /**
   * 锁定
   */
  LOCKED = osAccount.ResultCode.LOCKED,

  /**
   * 密码芯片故障
   */
  HARDWARE_ERROR = 10002,
}

/**
 * 指纹提示码
 */
export enum FingerprintAcquireCode {
  /**
   * 指纹点击过快
   */
  FINGERPRINT_TIP_TOO_FAST = osAccount.FingerprintTips.FINGERPRINT_TIP_TOO_FAST,

  /**
   * 指纹按下
   */
  FINGERPRINT_TIP_FINGER_DOWN = osAccount.FingerprintTips.FINGERPRINT_TIP_FINGER_DOWN,

  /**
   * 指纹抬起
   */
  FINGERPRINT_TIP_FINGER_UP = osAccount.FingerprintTips.FINGERPRINT_TIP_FINGER_UP,

  /**
   * 指纹结果
   */
  FINGERPRINT_TIP_SINGLE_PRESS_RESULT = 10001,

  /**
   * 指纹验证中提升开启人脸认证
   */
  FINGERPRINT_TIP_TRIGGER_FACE_RECOGNITION = 10006,

  /**
   * 指纹防误触提示
   */
  FINGERPRINT_ANTITOUCH_NOTIFICATION_CAMERA = 9,
}

/**
 * 基础验证视图的VM
 */
export abstract class BaseVerifyViewVm extends BaseViewVm {
  private readonly _verifyStateChangeListener: VerifyStateListener = {
    onVerifyResult: (authType: AuthType, verifyResult: VerifyResult): void => {
      if (!this.isNeedHandleVerifyResult()) {
        return;
      }
      this.onVerifyResult(authType, verifyResult);
    },
    onAcquireInfo: (authType: AuthType, module: number, acquire: number, extraInfo?: AcquireExtraInfo): void => {
      if (!this.isNeedHandleVerifyResult()) {
        return;
      }
      this.onAcquireInfo(authType, module, acquire, extraInfo);
    }
  };

  protected get faceVerifyInfo(): VerifyInfo {
    return VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE);
  }

  protected get fingerprintVerifyInfo(): VerifyInfo {
    return VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT);
  }

  protected doInit(params?: object): void {
    log.showInfo('doInit');
    super.doInit(params);
    ScreenLockVerifyService.getInstance().registerObserver(this._verifyStateChangeListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    super.doRelease();
    ScreenLockVerifyService.getInstance().unRegisterObserver(this._verifyStateChangeListener);
  }

  /**
   * 判断是否需要处理验证结果
   *
   * @returns 是否需要处理验证结果
   */
  protected abstract isNeedHandleVerifyResult(): boolean;

  protected onVerifyResult(authType: AuthType, verifyResult: VerifyResult): void {
    switch (authType) {
      case AuthType.FACE:
        this.onFaceVerifyResult(verifyResult);
        break;
      case AuthType.FINGERPRINT:
        this.onFingerVerifyResult(verifyResult);
        break;
      case AuthType.PIN:
        this.onPasswordVerifyResult(verifyResult);
        break;
      default:
        break;
    }
  }

  protected onFaceVerifyResult(verifyResult: VerifyResult): void {
    switch (verifyResult) {
      case VerifyResult.SUCCESS:
        this.onFaceVerifySuccess();
        break;
      case VerifyResult.FAIL:
        this.onFaceVerifyFail();
        break;
      default:
        break;
    }
  }

  protected onFaceVerifySuccess(): void {
    // 验证成功
  }

  protected onFaceVerifyFail(): void {
    // 验证失败
  }

  protected onPasswordVerifyResult(verifyResult: VerifyResult): void {
    switch (verifyResult) {
      case VerifyResult.SUCCESS:
        this.onPasswordVerifySuccess();
        break;
      case VerifyResult.FAIL:
        this.onPasswordVerifyFail();
        break;
      default:
        break;
    }
  }

  protected onPasswordVerifySuccess(): void {
    // 验证成功
  }

  protected onPasswordVerifyFail(): void {
    // 验证失败
  }

  protected onFingerVerifyResult(verifyResult: VerifyResult): void {
    Trace.end(Trace.CORE_METHOD_FINGERPRINT_AUTH);
    switch (verifyResult) {
      case VerifyResult.SUCCESS:
        this.onFingerVerifySuccess();
        break;
      case VerifyResult.FAIL:
        this.onFingerVerifyFail();
        break;
      case VerifyResult.OTHER_SUCCESS:
        this.onFingerVerifyOtherSuccess();
        break;
      default:
        break;
    }
  }

  protected onFingerVerifySuccess(): void {
    // 验证成功
  }

  protected onFingerVerifyFail(): void {
    // 验证失败
  }

  protected onFingerVerifyOtherSuccess(): void {
    // 其他账号验证成功
  }

  protected onAcquireInfo(authType: AuthType, module: number, acquire: number, extraInfo?: AcquireExtraInfo): void {
    switch (authType) {
      case AuthType.FACE:
        this.onFaceAcquireInfo(module, acquire, extraInfo);
        break;
      case AuthType.FINGERPRINT:
        this.onFingerprintAcquireInfo(module, acquire, extraInfo);
        break;
      default:
        break;
    }
  }

  protected onFaceAcquireInfo(module: number, acquire: number, extraInfo?: AcquireExtraInfo): void {
    // 人脸验证信息
  }

  protected onFingerprintAcquireInfo(module: number, acquire: number, extraInfo?: AcquireExtraInfo): void {
    // 指纹验证信息
    if (this.isNeedStrongAuth(acquire, extraInfo)) {
      this.onFingerprintAcquireTriggerStrongAuth();
    } else {
      this.onOtherFingerprintAcquireInfo(module, acquire, extraInfo);
    }
  }

  protected onFingerprintAcquireTriggerStrongAuth(): void {
    // 指纹验证触发强认证
  }

  protected onOtherFingerprintAcquireInfo(module: number, acquire: number, extraInfo?: AcquireExtraInfo): void {
    // 指纹验证未触发强认证
    if (acquire === FingerprintAcquireCode.FINGERPRINT_TIP_SINGLE_PRESS_RESULT) {
      this.handleFingerprintAcquireResult(extraInfo);
    }
  }

  protected onOtherFingerprintAcquireSuccess(extraInfo: AcquireExtraInfo): void {
    // 指纹验证成功
  }

  protected onOtherFingerprintAcquireFail(extraInfo: AcquireExtraInfo): void {
    // 指纹验证成功
  }

  private handleFingerprintAcquireResult(extraInfo?: AcquireExtraInfo): void {
    if (!extraInfo) {
      log.showInfo('not single press result, no need to process.');
      return;
    }
    switch (extraInfo.authResult) {
      case AcquireResultCode.SUCCESS:
        log.showInfo('fingerprint auth success.');
        this.onOtherFingerprintAcquireSuccess(extraInfo);
        break;
      case AcquireResultCode.FAIL:
      case AcquireResultCode.LOCKED:
        log.showInfo('fingerprint auth failed.');
        this.onOtherFingerprintAcquireFail(extraInfo);
        break;
      default:
        break;
    }
    return;
  }

  private isNeedStrongAuth(acquire: number, extraInfo?: AcquireExtraInfo): boolean {
    if (!this.fingerprintVerifyInfo.isNeedStrongAuth) {
      return false;
    }
    if (extraInfo?.userId === AccountHelper.getInstance().currentLocalId) {
      log.showInfo('current user acquire, need strong auth.');
      return true;
    }
    switch (acquire) {
      case FingerprintAcquireCode.FINGERPRINT_TIP_SINGLE_PRESS_RESULT:
        log.showInfo('fingerprint trigger strong auth.');
        return true;
      default:
        break;
    }
    return false;
  }
}