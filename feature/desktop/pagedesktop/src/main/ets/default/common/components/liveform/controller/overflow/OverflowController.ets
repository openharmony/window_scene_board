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
import { GameCardInfo } from '@ohos/launchercommon/src/main/ets/bean/GameCardInfo';
import formInfo from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/@ohos.app.form.formInfo';
import { AbstractOverflowPolicy } from './AbstractOverflowPolicy';
import { OverflowNoLimitPolicy } from './OverflowNoLimitPolicy';
import { OverflowDefaultPolicy } from './OverflowDefaultPolicy';

const TAG: string = 'OverflowController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 针对非游戏卡片进行是否可以溢出的判断，以及选择策略
 */
export class OverflowController {
  private mFormItemWidth: number = 0;
  private mFormItemHeight: number = 0;
  private isSystemApp: boolean | undefined = false;
  private policy: AbstractOverflowPolicy = new OverflowDefaultPolicy();

  constructor(formItemWidth: number, formItemHeight: number, isSystemApp: boolean | undefined,
    gameCardInfo: GameCardInfo | undefined) {
    this.mFormItemWidth = formItemWidth;
    this.mFormItemHeight = formItemHeight;
    this.isSystemApp = isSystemApp;
    this.checkOverflowPolicy(gameCardInfo);
  }

  public release(): void {
    log.showInfo('release');
    this.policy.release();
  }

  /**
   * 溢出动作函数初始化
   * @param stopOverflow 停止溢出
   */
  public initFunction(
    startOverflow?: () => void,
    stopOverflow?: (hasAnimation: boolean, isTimeOut: boolean) => void
  ): void {
    this.policy.initFunction(startOverflow, stopOverflow);
  }

  /*
  * 根据类型选择策略
  * 系统应用不限制
  * 三方游戏（无）
  * 三方非游戏卡片限制时间、限制区域
  * @param gameCardInfo 卡片信息
  */
  private checkOverflowPolicy(gameCardInfo: GameCardInfo | undefined): void {
    log.showInfo(`checkOverflowPolicy isSystemApp: ${this.isSystemApp} gameType: ${gameCardInfo?.gameType}`);
    if (this.isSystemApp) {
      this.policy = new OverflowNoLimitPolicy();
    } else {
      this.policy = new OverflowDefaultPolicy();
    }
  }

  public canOverflow(overflowInfo: formInfo.OverflowInfo, cardDimension: number): boolean {
    return this.policy.canOverflow(overflowInfo, cardDimension, this.mFormItemWidth, this.mFormItemHeight);
  }

  public handleOverflowRequest(overflowInfo: formInfo.OverflowInfo, isLongActiveForm: boolean = false): boolean {
    return this.policy.handleOverflowRequest(overflowInfo, this.mFormItemWidth, this.mFormItemHeight, isLongActiveForm);
  }

  public cancelOverflow(): void {
    this.policy.cancelOverflow();
  }
}