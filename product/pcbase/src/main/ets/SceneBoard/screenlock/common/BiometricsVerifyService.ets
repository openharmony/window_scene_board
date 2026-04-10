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

import { LogDomain, LogHelper, SingletonHelper, } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { FaceUnlockConstants, FingerprintConstants } from '@ohos/screenlockcommon';
import screenLockService from '../refactor/ScreenLockService';
import { AuthType } from '../refactor/AccountsModel';
import { userAuth } from '@kit.UserAuthenticationKit';
import { tipPriorityScheduler } from './TipPriority';
import camera from '@ohos.multimedia.camera';
import { AsyncCallback, BusinessError } from '@ohos.base';

const TAG = 'ScreenLock-BiometricsVerifyService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const INVALID_INDEX: number = -1;

// 所有导致生物识别不可用，且tip不被触发因素
export enum BiometricsDisAbleReason {
  // 用户第一次登录,只允许密码解锁去解锁一些文件资料
  FIRST_LOGIN = 0,
  // 密码失败被冻结，出于安全考虑，只让使用密码解锁
  PASSWORD_FREEZING = 1,
  // 密码过期阶段,不允许人脸指纹解锁
  PASSWORD_EXPIRED = 2,
  // 密码通过恢复密钥重设后,不允许人脸指纹解锁
  PASSWORD_RESET = 3,
}

export class BiometricsVerifyService {
  // 每次重新进入锁屏storage重置
  public storage: Map<string, string> = new Map();
  public faceUnlockEnable: boolean = false;
  private fingerprintEnable: boolean = false;
  private cameraManager: camera.CameraManager | undefined;
  private isCameraMuted: boolean = false;
  private biometricsSubscribe: Callback<void>[] = [];
  private disableReason: BiometricsDisAbleReason[] = [];

  // 获取可用生物识别 功能开启，数据已录入，多次失败造成短时间禁用依然算作有效生物识别方式,功能未被禁用
  public getEnableBiometrics(): AuthType[] {
    if (this.disableReason.length > 0) {
      return [];
    }
    return this.getRegisterBiometrics();
  }

  // 获取可用生物识别 功能开启，数据已录入，多次失败造成短时间禁用依然算作有效生物识别方式
  public getRegisterBiometrics(): AuthType[] {
    let result: AuthType[] = [];
    if (AppStorage.get<boolean>(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN) &&
      !screenLockService.getCameraMuted() && this.faceUnlockEnable) {
      result.push(AuthType.FACE);
    }
    let hasFingerprint: boolean | undefined = AppStorage.get(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT);
    if (hasFingerprint) {
      this.updateFingerprintEnable();
    }
    if (hasFingerprint && this.fingerprintEnable) {
      result.push(AuthType.FINGERPRINT);
    }
    return result;
  }

  // 订阅可用生物识别列表变动
  public addBiometricsChangeSubscribe(callback: Callback<void>): void {
    if (this.biometricsSubscribe.indexOf(callback) === INVALID_INDEX) {
      this.biometricsSubscribe.push(callback);
    }
  }

  // 取消订阅可用生物识别列表变动
  public deleteBiometricsChangeSubscribe(callback: Callback<void>): void {
    const index = this.biometricsSubscribe.indexOf(callback);
    if (index === INVALID_INDEX) {
      log.showWarn('deleteBiometricsSubscribe fail');
      return;
    }
    this.biometricsSubscribe.splice(index, 1);
  }

  private updateFingerprintEnable(): void {
    const value: string = sSettingsUtil.getValueBySECURE(FingerprintConstants.KEY_FINGERPRINT_KEYGUARD_ENABLE,
      FingerprintConstants.FINGERPRINT_KEYGUARD_ENABLE_DEFAULT);
    this.fingerprintEnable = value === FingerprintConstants.SWITCH_ENABLE;
    log.showDebug(`BiometricsVerify : fingerprintEnable ${this.fingerprintEnable}`);
  }

  private updateFaceUnlockEnable(): void {
    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.FACE, userAuth.AuthTrustLevel.ATL3);
      log.showInfo('face unlock is supported by system');
      this.faceUnlockEnable = true;
    } catch (error) {
      log.showError(`face unlock is not supported by system, error = ${error}`);
      this.faceUnlockEnable = false;
    }
  }

  private onCameraMuteChange: AsyncCallback<boolean> = (err: BusinessError, curMuted: boolean) => {
    if (err) {
      log.showError(`onCameraMuteChange err:, ${err.message}`);
      return;
    }
    log.showInfo(`curMuted：${curMuted}`);
    screenLockService.setCameraMuted(curMuted);
    let oldFlag = AppStorage.get<boolean>(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN) && !this.isCameraMuted;
    let newFlag = AppStorage.get<boolean>(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN) && !curMuted;
    this.isCameraMuted = curMuted;
    if (oldFlag != newFlag) {
      for (let i = 0; i < this.biometricsSubscribe.length; i++) {
        this.biometricsSubscribe[i]();
      }
    }
  }

  // 插入生物禁用因素
  public pushDisableReason(reason: BiometricsDisAbleReason) {
    log.showInfo(`pushDisableReason ${reason}`);
    if (this.disableReason.indexOf(reason) === INVALID_INDEX) {
      this.disableReason.push(reason);
      for (let i = 0; i < this.biometricsSubscribe.length; i++) {
        this.biometricsSubscribe[i]();
      }
    }
  }

  // 移除生物禁用因素
  public popDisableReason(reason: BiometricsDisAbleReason) {
    log.showInfo(`popDisableReason ${reason}`);
    const index = this.disableReason.indexOf(reason);
    if (index === INVALID_INDEX) {
      log.showWarn('popDisableReason fail');
      return;
    }
    this.disableReason.splice(index, 1);
    for (let i = 0; i < this.biometricsSubscribe.length; i++) {
      this.biometricsSubscribe[i]();
    }
  }

  // 获取生物禁用因素列表
  getDisableReason(): BiometricsDisAbleReason[] {
    return this.disableReason;
  }

  // 初始化
  public init(): void {
    if (AppStorage.get('isBeginSleepStart')) {
      AppStorage.setOrCreate('isPowerInterceptLockScreen', true);
    }
    this.storage.clear();
    this.updateFingerprintEnable();
    this.updateFaceUnlockEnable();
    try {
      this.cameraManager = camera?.getCameraManager(getContext());
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(`getCameraManager error, code:${errInfo?.code}, message:${errInfo?.message}`);
    }
    this.isCameraMuted = this.cameraManager?.isCameraMuted() || false;
    screenLockService.setCameraMuted(this.isCameraMuted);
    this.cameraManager?.on('cameraMute', this.onCameraMuteChange);

    if (screenLockService.firstUnLockScreen) {
      this.pushDisableReason(BiometricsDisAbleReason.FIRST_LOGIN);
    }
    tipPriorityScheduler.init();
    log.showInfo(`Init`);
  }

  // 反初始化
  public unInit(): void {
    this.biometricsSubscribe = [];
    this.disableReason.length = 0;
    log.showInfo(`unInit`);
    AppStorage.setOrCreate('isPowerInterceptLockScreen', false);
  }
}

export let biometricsVerifyService = SingletonHelper.getInstance(BiometricsVerifyService, TAG);