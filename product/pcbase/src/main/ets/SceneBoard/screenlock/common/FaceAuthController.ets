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
import { ResUtils } from '@ohos/windowscene';
import {
  FaceUnlockConstants,
  FaceUnlockVerifyState,
  AccessibilityUtil,
} from '@ohos/screenlockcommon';
import { AuthType } from '../refactor/AccountsModel';
import service from '../refactor/ScreenLockService';
import osAccount from '@ohos.account.osAccount';
import FreezingTipUtil from '@ohos/screenlockcomponent/src/main/ets/common/FreezingTipUtil';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { biometricsVerifyService } from './BiometricsVerifyService';

const TAG = 'ScreenLock-PCFaceAuthController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
// 人脸正常禁用30秒
const FACE_LOCK_TIME_UP_LIMIT: number = 30000;

export class FaceAuthController {
  public authRetryTip: string = '';
  private static retryCountDownTimerId: number = -1;

  public refreshAuthRetryTip(): void {
    service.getAuthProperty(AuthType.FACE, async (properties: osAccount.ExecutorProperty) => {
      log.showInfo(`The faceUnlock property = ${JSON.stringify(properties)}`);
      const freezingTime: number = (!!properties?.freezingTime) ? properties?.freezingTime : 0;
      if (freezingTime === 0) {
        log.showInfo('set faceUnlock state to ready.');
        AppStorage.setOrCreate(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.READY);
      } else if (freezingTime <= FACE_LOCK_TIME_UP_LIMIT) {
        const freezingTimeStr = await FreezingTipUtil.getFreezingTimeStr(freezingTime);
        if (!!freezingTimeStr) {
          this.authRetryTip = await this.getFreezingTimeTip(freezingTimeStr);
        }
        this.countdown();
      } else {
        log.showWarn(`face freezingTime is more than ${FACE_LOCK_TIME_UP_LIMIT}`);
        this.authRetryTip = '';
      }
    });
  }

  private async getFreezingTimeTip(freezingTimeStr: string): Promise<string> {
    let biometrics = biometricsVerifyService.getEnableBiometrics();
    if (!freezingTimeStr) {
      return '';
    } else if (biometrics.length === 1 && biometrics.indexOf(AuthType.FACE) >= 0) {
      return (await ResUtils.getInnerStringNum($r('app.string.face_recognition_try_again_after_time_or_try_pwd_pc'),
        freezingTimeStr));
    } else {
      return (await ResUtils.getInnerStringNum($r('app.string.face_recognition_try_again_after_time_or_try_others_pc'),
        freezingTimeStr));
    }
  }

  private clearCountDownTimer(): void {
    if (FaceAuthController.retryCountDownTimerId !== -1) {
      log.showInfo(`timer id is ${FaceAuthController.retryCountDownTimerId}, need to clear timeout.`);
      clearTimeout(FaceAuthController.retryCountDownTimerId);
      FaceAuthController.retryCountDownTimerId = -1;
    }
  }

  private countdown(): void {
    this.clearCountDownTimer();
    FaceAuthController.retryCountDownTimerId = setTimeout(() => {
      this.refreshAuthRetryTip()
    }, Constants.MILLISECOND_TO_SECOND);
  }

  private faceAccessibilityResult(resolve: Function, reject: Function): void {
    service.getAuthProperty(AuthType.FACE, async (properties: osAccount.ExecutorProperty) => {
      const freezingTime: number = (!!properties?.freezingTime) ? properties?.freezingTime : 0;
      if (freezingTime <= FACE_LOCK_TIME_UP_LIMIT) {
        const freezingTimeStr = await FreezingTipUtil.getFreezingTimeStr(freezingTime);
        if (!!freezingTimeStr) {
          let disableFace = await this.getFreezingTimeTip(freezingTimeStr);
          log.showInfo(`refreshAccessibilityFaceResult ${disableFace}`);
          resolve(disableFace);
        } else {
          log.showWarn(`face freezingTime is more than ${FACE_LOCK_TIME_UP_LIMIT}`);
        }
      }
      resolve('');
    });
  }

  private async refreshAccessibilityFaceResult(): Promise<string> {
    let promise: Promise<string> = new Promise((resolve: Function, reject: Function) => {
      this.faceAccessibilityResult(resolve, reject)
    })
    return await promise;
  }

  public getDisableFaceAccessibilityTips(): string {
    let faceResult: string = '';
    this.refreshAccessibilityFaceResult().then((data) => {
      faceResult = data;
    });
    return faceResult;
  }

  public refreshDisableFaceAccessibility(): void {
    service.getAuthProperty(AuthType.FACE, async (properties: osAccount.ExecutorProperty) => {
      const freezingTime: number = (!!properties?.freezingTime) ? properties?.freezingTime : 0;
      if (freezingTime <= FACE_LOCK_TIME_UP_LIMIT) {
        const freezingTimeStr = await FreezingTipUtil.getFreezingTimeStr(freezingTime);
        if (!!freezingTimeStr) {
          this.authRetryTip = await this.getFreezingTimeTip(freezingTimeStr);
          AccessibilityUtil.sendAccessibility(this.authRetryTip);
        }
      } else {
        log.showWarn(`face freezingTime is more than ${FACE_LOCK_TIME_UP_LIMIT}`);
        this.authRetryTip = '';
        AccessibilityUtil.sendAccessibility(this.authRetryTip);
      }
    });
  }
}

export let faceAuthController = SingletonHelper.getInstance(FaceAuthController, TAG) as FaceAuthController