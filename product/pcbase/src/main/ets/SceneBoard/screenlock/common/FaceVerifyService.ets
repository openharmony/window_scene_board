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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {vibratorMgr, FaceUnlockConstants } from '@ohos/screenlockcommon';
import accountModel, { AuthType } from '../refactor/AccountsModel'
import ScreenLockService from '../refactor/ScreenLockService';
import type { Callback } from '@ohos.base';
import { biometricsVerifyService } from './BiometricsVerifyService';

const TAG = 'ScreenLock-FaceVerifyService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const INVALID_INDEX: number = -1;

export class FaceVerifyService {
  private onRetryFaceVerifyCallback: Callback<void> | undefined = undefined;

  // 重新触发人脸解锁
  public retryFaceVerify(): void {
    if (!this.isFaceUnlockSupportedBySystem()) {
      return;
    }
    if (!this.isFaceVerifyEnable()) {
      return;
    }
    const invokeSuccess: boolean = ScreenLockService.invokeFaceVerify();
    if (this.onRetryFaceVerifyCallback) {
      this.onRetryFaceVerifyCallback();
    }
    if (invokeSuccess) {
      vibratorMgr.startVibration();
    }
  }

  public isFaceVerifyEnable(): boolean {
    let disableReasons = biometricsVerifyService.getDisableReason();
    if (disableReasons.length > 0) {
      log.warn(`faceVerify disable reason ${disableReasons.toString()}`);
      return false;
    }
    if (!AppStorage.get(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN)) {
      log.warn(`faceVerify not enable`);
      return false;
    }
    return true;
  }

  public isFaceUnlockSupportedBySystem(): boolean {
    log.showInfo(`face unlock is supported by system: ${biometricsVerifyService.faceUnlockEnable}`);
    return biometricsVerifyService.faceUnlockEnable;
  }

  public setRetryFaceVerifyCallback(callback: Callback<void> | undefined): void {
    this.onRetryFaceVerifyCallback = callback;
  }
}

export let faceVerifyService = SingletonHelper.getInstance(FaceVerifyService, TAG);