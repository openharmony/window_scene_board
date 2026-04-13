/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { commonEventManager } from '@kit.BasicServicesKit';
import type { BusinessError } from '@ohos.base';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'GameEventListener';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const GAME_EVENT_LISTENER_FIELD: string = 'usual.event.gameservice.GAME_STATUS_CHANGE';
const PUBLISH_SYSTEM_COMMON_EVENT: string = 'ohos.permission.PUBLISH_SYSTEM_COMMON_EVENT';
const enum GameStatus {
  // 前台状态
  ENTER_GAME = 1,
  // 后台状态
  GAME_BACKEND = 2,
  // 应用退出
  EXIT_GAME = 3,
  // 应用获焦
  GAME_FOCUS = 4,
  // 应用失焦
  GAME_BLUR = 5,
}

export class GameEventListener {
  private static instance: GameEventListener;
  private supportRecycleForm: boolean = true;
  private currProcessGame: string = '';
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  private constructor() {
  }

  public isSupportRecycleForm(): boolean {
    return this.supportRecycleForm;
  }

  public setSupportRecycleForm(value: boolean): void {
    this.supportRecycleForm = value;
  }

  static getInstance(): GameEventListener {
    if (GameEventListener.instance == null) {
      GameEventListener.instance = new GameEventListener();
    }
    return GameEventListener.instance;
  }

  public initGameEventListener(): void {
    // Subscribed Information.
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [GAME_EVENT_LISTENER_FIELD],
      publisherPermission: PUBLISH_SYSTEM_COMMON_EVENT,
    };
    // Creating a Subscriber
    try {
      this.createSubscribe(subscribeInfo);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.showError(`Subscribing game event failed, message is ${err?.message}`);
    }
  }

  private createSubscribe(subscribeInfo: commonEventManager.CommonEventSubscribeInfo): void {
    commonEventManager.createSubscriber(subscribeInfo,
      (err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
        if (this.subscriber) {
          log.showWarn('gameEvent is subscribed, no need to subscribe again');
          return;
        }
        if (err) {
          log.showError(`Failed to create game subscriber, code is ${err.code}, message is ${err.message}`);
          return;
        }
        this.subscriber = commonEventSubscriber;
        // Subscribing to Common Event Callbacks.
        commonEventManager.subscribe(this.subscriber,
          (err: BusinessError, commonEventData: commonEventManager.CommonEventData) => {
            if (err) {
              log.showError(`Failed to subscribe game event, code is ${err.code}, message is ${err.message}`);
              return;
            }
            if (CheckEmptyUtils.isEmpty(commonEventData)) {
              log.showError('Game event data parameters are null');
            } else if (commonEventData.event === GAME_EVENT_LISTENER_FIELD && commonEventData.parameters) {
              this.updateFormRecycleStatus(commonEventData.parameters.type, commonEventData.parameters.bundleName);
            }
          });
      });
  }

  public destroySubscribe(): void {
    if (!this.subscriber) {
      log.showWarn('subscriber is null');
      return;
    }
    try {
      commonEventManager.unsubscribe(this.subscriber);
      this.subscriber = null;
      log.showInfo('unsubscribe succeed');
    } catch (err) {
      log.showError(`unsubscribe fail, code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private updateFormRecycleStatus(lastGameStatus: number, bundleName: string): void {
    log.showInfo(`last game status code is ${lastGameStatus}, bundleName is ${bundleName}`);
    if (lastGameStatus === GameStatus.ENTER_GAME) {
      this.currProcessGame = bundleName;
      this.setSupportRecycleForm(false);
      log.showInfo(`update supportRecycleForm = ${this.supportRecycleForm} when enter_game`);
    } else if (lastGameStatus === GameStatus.GAME_BACKEND || lastGameStatus === GameStatus.EXIT_GAME) {
      if (this.currProcessGame === bundleName) {
        this.setSupportRecycleForm(true);
        log.showInfo(`update supportRecycleForm = ${this.supportRecycleForm} when game_backend or exit_game`);
      }
    }
  }
}