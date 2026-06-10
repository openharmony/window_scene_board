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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import MixedPSDViewModel from './MixedPSDViewModel';
import { Callback } from '@ohos.base';
import { BiometricsDisAbleReason, biometricsVerifyService } from '../common/BiometricsVerifyService';
import { AuthSubType, AuthType } from '../refactor/AccountsModel';
import ScreenLockService from '../refactor/ScreenLockService';
import osAccount from '@ohos.account.osAccount';


const TAG = 'ScreenLock-PCMixedPSDViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const ERROR_TIP_SHOW_TIME = 2500;
const FIRST_PASSWORD_ERROR_REMAIN_TIMES = 4;
const SECOND_PASSWORD_ERROR_REMAIN_TIMES = 3;


// 这里类主要是维护tip，需要知道是主动还是被动刷新tips，以及tips显示优先级
export class PCMixedPSDViewModel extends MixedPSDViewModel {
  // 记录用户进行过主动尝试行为
  public haveTryUnlock: boolean = false;
  // 记录用户主动尝试行为导致的tip刷新
  public userRetry: boolean = false;
  private timer: number | null = null;

  onAuthPassword(authType: AuthSubType, failedCallback: Callback<number>, succeedCallback?:
    Callback<void>): void {
    super.onAuthPassword(authType, (result: number) => {
      if (this.inhibitInput) {
        biometricsVerifyService.pushDisableReason(BiometricsDisAbleReason.PASSWORD_FREEZING);
      }
      this.haveTryUnlock = true;
      this.userRetry = true;
      failedCallback(result);
    }, succeedCallback);
  }

  public setPromptByUserBehavior(prompt: string): void {
    this.prompt = prompt;
    this.haveTryUnlock = true;
    this.userRetry = true;
  }

  public checkFreezingTime(callback: Callback<void>, notFreezingCallback?: Callback<void> | undefined): void {
    super.checkFreezingTime(() => {
      biometricsVerifyService.pushDisableReason(BiometricsDisAbleReason.PASSWORD_FREEZING);
      log.info('password freezing');
      callback();
    }, notFreezingCallback);
    this.haveTryUnlock = true;
    this.userRetry = true;
  }

  // PC端倒计时结束后，从重置密码页，返回来，处理倒计时提示
  protected countDownEndHandlePrompt(freezingTime: number, remainTimes: number): void {
    if (freezingTime === 0 && remainTimes === 3) {
      this.prompt = '';
    }
  }

  async changePrompt(remainTimes: number | undefined = undefined, freezingTime: number | undefined = undefined,
    callback: Callback<void>, nextPhaseFreezingTime: number = 0, psdDrawingCompleted: string = ''): Promise<void> {
    await super.changePrompt(remainTimes, freezingTime, callback, nextPhaseFreezingTime, psdDrawingCompleted);
    if (this.timer) {
      clearTimeout(this.timer);
      log.showInfo('clear password error timer');
    }
    const isCurrentUserHasFingerprint: boolean | undefined = AppStorage.get('isCurrentUserHasFingerprint');
    if (isCurrentUserHasFingerprint) {
      this.checkFpRemainTimes(() => {
        this.resetPrompt(remainTimes);
      })
    } else {
      this.resetPrompt(remainTimes);
    }
  }

  private resetPrompt(remainTimes: number | undefined): void {
    if (remainTimes === FIRST_PASSWORD_ERROR_REMAIN_TIMES || remainTimes === SECOND_PASSWORD_ERROR_REMAIN_TIMES) {
      this.timer = setTimeout(() => {
        this.prompt = '';
      }, ERROR_TIP_SHOW_TIME);
    }
  }

  private checkFpRemainTimes(callback: Callback<void>) {
    ScreenLockService.getAuthProperty(AuthType.FINGERPRINT, (properties: osAccount.ExecutorProperty) => {
      //指纹错误次数达到五次，指纹禁用时，输入密码错误后，密码错误提示语常驻
      log.showInfo(`FP remainTimes:${properties?.remainTimes},freezingTime:${properties?.freezingTime}`)
      if (properties?.remainTimes === 0 && properties?.freezingTime && properties?.freezingTime > 0) {
        return;
      }
      callback();
    });
  }
}