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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import {FingerprintConstants, CommonConstants } from '@ohos/screenlockcommon';
import { AuthType } from '../refactor/AccountsModel';
import screenLockService from '../refactor/ScreenLockService';
import osAccount from '@ohos.account.osAccount';
import { PromptShowType } from '@ohos/screenlockcomponent/src/main/ets/fingerprint/BasePromptViewModel';
import { PCBasePromptViewModel } from './PCBasePromptViewModel';
import { strongAuthManager } from '@ohos/screenlockcommon';

const TAG = 'ScreenLock-CustomizePromptViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 提示词默认间隔时间 (ms)
const DEFAULT_DURATION_TIME: number = 2500;

export class CustomizePromptViewModel extends PCBasePromptViewModel {
  public isShowPrompt: boolean = false;
  public isCountDown: boolean = false;
  public isPsdCountDown: boolean = false;
  public prompt: string | undefined = undefined;
  private defaultPrompt: Resource | undefined = undefined;
  // 提示词延时ID
  private timerId: number = -1;
  // 倒计时延时ID
  private countDownTimerId: number = -1;
  private getPromptCallback: Function = (remainTimes: number, freezingTime: number, isPsdFreezing: boolean) => {};
  private getPsdFreezingTimeCallback: Function = () => {};
  private startTime: number = new Date().getTime();

  init(defaultPrompt: Resource | undefined) {
    this.defaultPrompt = !!defaultPrompt ? defaultPrompt : this.defaultPrompt;
    this.prompt = ResUtils.getInnerString(this.defaultPrompt);
  }

  public showPrompt(prompt: string, promptShowType: PromptShowType, duration: number = DEFAULT_DURATION_TIME) {
    if (strongAuthManager.isNeedStrongAuth()) {
      return;
    }
    log.showInfo(`prompt:${prompt}, promptShowType:${promptShowType}, duration${duration}`);
    if (this.timerId !== -1) {
      log.showInfo(`timer id is ${this.timerId}, need to clear timeout.`);
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
    this.prompt = prompt;
    this.isShowPrompt = true;
    if (promptShowType === PromptShowType.TEMPORARY) {
      this.timerId = setTimeout(() => {
        log.showInfo(`duration time ${duration} prompt`);
        this.prompt = ResUtils.getInnerString(this.defaultPrompt);
      }, duration);
    }
  }

  async changePrompt(remainTimes: number, freezingTime: number, isPsdFreezing: boolean) {
    const propStr: string = await this.getPromptCallback(remainTimes, freezingTime, isPsdFreezing);
    if (remainTimes >= 3) {
      this.showPrompt(propStr, PromptShowType.TEMPORARY);
      return;
    }
    this.showPrompt(propStr, PromptShowType.PERMANENT);
    if (remainTimes === 0) {
      AppStorage.setOrCreate('isPwdVisibleForPC', true);
      this.bindCountDown(true);
    }
  }

  refreshVM() {
    this.prompt = ResUtils.getInnerString(this.defaultPrompt);
    this.isShowPrompt = false;
    this.clearCountDownTimer();
  }

  refreshStartTime() {
    this.startTime = new Date().getTime();
  }

  checkFreezingTime() {
    log.showInfo(`fingerprint checkFreezingTime`);
    screenLockService.getAuthProperty(AuthType.FINGERPRINT, (properties: osAccount.ExecutorProperty) => {
      this.authCallback(properties, true);
    })
  }

  async authCallback(properties: osAccount.ExecutorProperty, isFirst: boolean) {
    if (!properties || properties.remainTimes === undefined || properties.freezingTime === undefined) {
      log.showError(`properties(${properties}) is invalid`);
      return;
    }
    let remainTimes = properties.remainTimes;
    let freezingTime = properties.freezingTime;
    let pwdFreezingTime = -1;
    let isPsdFreezing = false;
    if (freezingTime === FingerprintConstants.INVALID_DURATION) {
      pwdFreezingTime = await this.getPsdFreezingTimeCallback();
      this.defaultPrompt = $r('app.string.fp_disable_enter_psd');
    }
    if (pwdFreezingTime > 0) {
      freezingTime = pwdFreezingTime;
      isPsdFreezing = true;
    }
    this.countdown(remainTimes, freezingTime, isPsdFreezing, isFirst);
  }

  bindCountDown(isFirst: boolean) {
    let real = (new Date().getTime() - this.startTime);
    let diff = CommonConstants.INTERVAL - (real % CommonConstants.INTERVAL);
    this.countDownTimerId = setTimeout(() => {
      screenLockService.getAuthProperty(AuthType.FINGERPRINT, (properties: osAccount.ExecutorProperty) => {
        this.authCallback(properties, isFirst);
      });
    }, diff);
  }

  async countdown(remainTimes: number, freezingTime: number, isPsdFreezing: boolean, isFirst: boolean) {
    log.showInfo(`countdown remainTimes:${remainTimes}, freezingTime:${freezingTime}, isPsdFreezing:${isPsdFreezing}.`);

    if (isFirst) {
      log.showInfo('first need to clean.');
      this.clearCountDownTimer();
      this.isShowPrompt = true;
      this.isCountDown = true;
      this.isPsdCountDown = isPsdFreezing;
    }

    if (remainTimes !== 0 || freezingTime <= 0 || freezingTime === FingerprintConstants.INVALID_DURATION) {
      log.showInfo(`remainTimes:${remainTimes}, freezingTime:${freezingTime}, so no need to count down.`);
      this.clearCountDownTimer();
      this.prompt = ResUtils.getInnerString(this.defaultPrompt);
      return;
    }

    this.prompt = await this.getPromptCallback(remainTimes, freezingTime, isPsdFreezing);
    this.bindCountDown(false);
  }

  setGetPromptCallback(callback: Function) {
    this.getPromptCallback = callback;
  }

  setGetPsdFreezingTimeCallback(callback: Function) {
    this.getPsdFreezingTimeCallback = callback;
  }

  public clearCountDownTimer() {
    if (this.countDownTimerId !== -1) {
      log.showInfo(`timer id is ${this.countDownTimerId}, need to clear timeout.`);
      clearTimeout(this.countDownTimerId);
      this.countDownTimerId = -1;
      this.isCountDown = false;
      this.isPsdCountDown = false;
    }
  }

  public clearPrompt() {
      log.showInfo(`clear CustomizePromptViewModel Prompt`);
      this.prompt = undefined;
      this.defaultPrompt = undefined;
  }
}