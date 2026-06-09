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

import HashSet from '@ohos.util.HashSet';
import { sEventManager, obtainLocalEvent, Callback } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import osAccount from '@ohos.account.osAccount';
import { CacheValue } from '../base/GlobalStatusCache';

export type KeyguardObserverCallback = Callback;

const TAG = 'KeyguardObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum KeyguardObserverStage {
  ACCOUNT_ACTIVE = 'ACCOUNT_ACTIVE',
  ACCOUNT_CHECKING = 'ACCOUNT_CHECKING',
  AUTH_SUCCESS_ANIMATE_FINISH = 'AUTH_SUCCESS_ANIMATE_FINISH',
  AUTH_SUCCESS_ANIMATE_CALLBACK = 'AUTH_SUCCESS_ANIMATE_CALLBACK',
  AUTH_SUCCESS = 'AUTH_SUCCESS',
}

export class KeyguardObserver {
  private static instance: KeyguardObserver;
  private observationStages: Map<string, HashSet<KeyguardObserverCallback>> = new Map();

  public static getInstance(): KeyguardObserver {
    if (!KeyguardObserver.instance) {
      KeyguardObserver.instance = new KeyguardObserver();
    }
    return KeyguardObserver.instance;
  }

  public onAccountActive(callback: KeyguardObserverCallback): void {
    this.registerStage(KeyguardObserverStage.ACCOUNT_ACTIVE, callback);
  }

  public notifyAccountActive(): void {
    this.notify(KeyguardObserverStage.ACCOUNT_ACTIVE);
  }

  public onAccountChecking(callback: KeyguardObserverCallback): void {
    this.registerStage(KeyguardObserverStage.ACCOUNT_CHECKING, callback);
  }

  public notifyAccountChecking(status: number): void {
    this.notify(KeyguardObserverStage.ACCOUNT_CHECKING, status);
  }

  public onAuthSuccessAniFinish(callback: KeyguardObserverCallback): void {
    this.registerStage(KeyguardObserverStage.AUTH_SUCCESS_ANIMATE_FINISH, callback);
  }

  public notifyAuthSuccessAniFinish(): void {
    this.notify(KeyguardObserverStage.AUTH_SUCCESS_ANIMATE_FINISH);
  }

  public onAuthSuccessAniCallback(callback: KeyguardObserverCallback): void {
    this.registerStage(KeyguardObserverStage.AUTH_SUCCESS_ANIMATE_CALLBACK, callback);
  }

  public notifyAuthSuccessAniCallback(): void {
    this.notify(KeyguardObserverStage.AUTH_SUCCESS_ANIMATE_CALLBACK);
  }

  public onAuthSuccess(callback: KeyguardObserverCallback): void {
    this.registerStage(KeyguardObserverStage.AUTH_SUCCESS, callback);
  }

  public notifyAuthSuccess(authType: osAccount.AuthType): void {
    this.notify(KeyguardObserverStage.AUTH_SUCCESS, authType);
  }

  public destroy(): void {
    this.observationStages.forEach((callbacks, stage) => {
      callbacks.forEach((callback) => {
        sEventManager.off(stage, callback);
      });
      log.showInfo(`unregister,stage=[${stage}]`);
    });
  }

  private notify(keyPoint: string, noticeData?: CacheValue): void {
    const stageName = this.getNameWithPrefix(keyPoint);
    log.showInfo(`notify start,[${stageName}]`);
    const result =
      sEventManager.publish(obtainLocalEvent(stageName, noticeData !== undefined ? noticeData : stageName));
    log.showInfo(`notify end,stage=[${stageName}],result=${result}`);
  }

  private registerStage(keyPoint: string, callback: KeyguardObserverCallback): void {
    const stageName = this.getNameWithPrefix(keyPoint);
    log.showInfo(`register start,[${stageName}]`);
    if (!this.observationStages.has(stageName)) {
      this.observationStages.set(stageName, new HashSet());
    }

    const func: KeyguardObserverCallback = callback;
    const observationStage = this.observationStages.get(stageName);
    if (!observationStage?.has(func)) {
      observationStage?.add(func);
    }

    sEventManager.subscribe(stageName, func);
    log.showInfo(`register end,stage=[${stageName}] size=${observationStage?.length}`);
  }

  private getNameWithPrefix(stage: string): string {
    return `KeyguardObserver-${stage}`;
  }
}