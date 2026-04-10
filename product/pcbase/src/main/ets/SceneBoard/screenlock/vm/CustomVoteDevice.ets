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
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { VoteDevice } from '../refactor/VoteDevice';
import systemParameter from '@ohos.systemparameter';

const TAG = 'ScreenLock-CustomVoteDevice';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const VOTE_TIMEOUT_READY: number = 3000;
const MAX_VALUE: number = 2;

export class CustomVoteDevice extends VoteDevice {
  public static isReboot: boolean = CustomVoteDevice.isRebootForBuild();

  public readyFinish: number = 0;

  /**
   * 判断机器是否是重启进入的Sceneboard（其他会重启Sceneboard的方式：新建用户，注销登录等）
   * @returns
   */
  private static isRebootForBuild(): boolean {
    try {
      return systemParameter.getSync('bootevent.lockscreen.ready') !== 'true';
    } catch (e) {
      log.showError('status get error for reboot');
      return false;
    }
  }

  public scheduleForReadyTimeout(): void {
    this.scheduleVoteTimeout(VOTE_TIMEOUT_READY);
  }

  /*
    等待锁屏完成 以及 锁屏视觉ready
   */
  public voteForReady(): void {
    super.voteForReady();
  }
}

