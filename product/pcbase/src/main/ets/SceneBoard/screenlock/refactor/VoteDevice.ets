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
import systemParameter from '@ohos.systemparameter';
import { DrawDoneManager } from '@ohos/screenlockcommon';
import accountModel from './AccountsModel';
import ScreenLockService from './ScreenLockService';
import commonEventManager from '@ohos.commonEventManager';

const TAG = 'ScreenLock-VoteDevice';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const VOTE_TIMEOUT_READY: number = 200;
const SCREEN_LOCK_BOOT: string = 'ScreenLock_VoteDevice_Boot_Completed';

export class VoteDevice {
  private drawDoneManager: DrawDoneManager = new DrawDoneManager(SCREEN_LOCK_BOOT);
  private voteTimeId: number = 0;

  public scheduleVoteTimeout(timeout: number): void {
    this.cancelVoteTimeout();
    this.voteTimeId = setTimeout(() => {
      this.voteBootEvent();
    }, timeout);
  }

  public cancelVoteTimeout(): void {
    if (this.voteTimeId !== 0) {
      clearTimeout(this.voteTimeId);
      this.voteTimeId = 0;
    }
  }

  public voteBootEvent(): void {
    log.showInfo('voteBootEvent for lockscreen begin');
    try {
      systemParameter.setSync('bootevent.lockscreen.ready', 'true');
    } catch (err) {
      log.showInfo('set voteBootEvent error');
    }
    log.showInfo('voteBootEvent for lockscreen end');
  }

  public scheduleForReadyTimeout(): void {
    this.scheduleVoteTimeout(VOTE_TIMEOUT_READY);
  }

  public voteForReady(): void {
    this.cancelVoteTimeout();
    this.voteBootEvent();
  }

  public publishScreenLockBoot(isScreenLockShow: boolean): void {
    // 锁屏重启并且锁屏显示 注册监听
    if (isScreenLockShow) {
      this.drawDoneManager.registerComponentDrawObserver(this.notifyScreenLockDrawDone);
    }
    // 锁屏不显示直接发送
    this.notifyScreenLockBootCompleted();
    log.showInfo(`publishScreenLockBoot isScreenLockShow:${isScreenLockShow}`);
  }

  private notifyScreenLockDrawDone = (): void => {
    ScreenLockService.notifyDrawDone();
  };

  private notifyScreenLockBootCompleted(): void {
    this.publishByUser('common.event.SCREENLOCK_BOOT_COMPLETED');
  }

  protected publishByUser(eventName: string): void {
    let curUsr: number = accountModel.getCurrentUserId();
    log.showDebug(`publishByUser event name: ${eventName}, currentUsr: ${curUsr}`);
    let publishData: commonEventManager.CommonEventPublishData = {
      parameters: {
        userId: curUsr
      }
    };
    try {
      commonEventManager.publish(eventName, publishData, (err) => {
        if (err) {
          log.showError(`publishEvent ${eventName} error. code: ${err.code}`);
          return;
        }
        log.showInfo(`publishEvent ${eventName} success.`);
      });
    } catch (error) {
      log.showError(`publishEvent ${eventName} failed.`);
    }
  }
}

