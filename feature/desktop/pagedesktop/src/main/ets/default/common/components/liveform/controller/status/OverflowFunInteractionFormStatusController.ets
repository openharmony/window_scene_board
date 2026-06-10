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

import { LogDomain, LogHelper } from '@ohos/basicutils'
import { OverflowConstants } from '@ohos/commonconstants';
import { LiveFormSupportMgr } from '@ohos/launchercommon';
import { OverflowFormStatus, OverflowFormVm } from '../../viewmodel/OverflowFormVm';
import { OverflowFormStatusController, OverflowOperation } from './OverflowFormStatusController';
import { OverflowFunInteractionFormEvent } from '../../event/OverflowFunInteractionFormEvent';

const TAG = 'OverflowFunInteractionFormStatusController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OverflowFunInteractionFormStatusController extends OverflowFormStatusController {
  private overflowActiveTime: number;
  private mPauseTimer?: number;

  constructor(cardId: string, pauseDuration: number | undefined) {
    super(cardId);
    let gameCardMaxPauseTime: number | undefined = LiveFormSupportMgr.getInstance().getGameCardMaxPauseTime();
    if (!gameCardMaxPauseTime || gameCardMaxPauseTime <= 0) {
      gameCardMaxPauseTime = OverflowConstants.OVERFLOW_ACTIVE_TIMER;
    }
    this.overflowActiveTime =
      (pauseDuration && pauseDuration > 0) ? Math.min(pauseDuration, gameCardMaxPauseTime) : gameCardMaxPauseTime;
  }

  /**
   * 更新 overflow 卡片的激活定时器
   *
   * @param overflowFormItemEvent overflow卡片事件
   * @param viewModel overflow卡片的视图模型
   */
  public updateOverflowFormActiveTimer(
    overflowFormItemEvent: OverflowFunInteractionFormEvent,
    viewModel: OverflowFormVm): void {
    this.clearOverflowFormActiveTimer();
    this.mPauseTimer = setTimeout(() => {
      // 倒计时结束，执行状态切换动效
      this.registerOperation(overflowFormItemEvent, OverflowFormStatus.PAUSE, true, viewModel, null);
    }, this.overflowActiveTime);
  }

  /**
   * 清除 overflow 卡片的激活定时器
   */
  public clearOverflowFormActiveTimer(): void {
    if (this.mPauseTimer) {
      clearTimeout(this.mPauseTimer);
    }
    this.mPauseTimer = undefined;
  }

  protected canDoOperation(operation: OverflowOperation, overflowFormItemEvent: OverflowFunInteractionFormEvent,
    viewModel: OverflowFormVm, uiExtProxy: UIExtensionProxy | null): boolean {
    log.showInfo(`canDoOperation, operation: ${operation}, now status: ${viewModel.overflowFormStatus}`);
    switch (operation.targetStatus) {
      case OverflowFormStatus.INACTIVE: {
        return this.canChangeToInactive(overflowFormItemEvent);
      }
      case OverflowFormStatus.PAUSE: {
        return this.canChangeToPause(viewModel);
      }
      case OverflowFormStatus.ACTIVE: {
        return this.canChangeToActive(overflowFormItemEvent, viewModel, uiExtProxy);
      }
      default: {
        return false;
      }
    }
  }

  private canChangeToPause(viewModel: OverflowFormVm): boolean {
    log.showInfo(`canChangeToPause, viewModel.overflowFormStatus: ${viewModel.overflowFormStatus}` +
      `, viewModel.isInLongPress: ${viewModel.isInLongPress}`);
    if (viewModel.overflowFormStatus == OverflowFormStatus.PAUSE && !viewModel.isInLongPress) {
      return false;
    }
    if (viewModel.overflowFormStatus === OverflowFormStatus.INACTIVE) {
      return false;
    }
    return true;
  }

  protected handleFormalOperation(overflowFormItemEvent: OverflowFunInteractionFormEvent,
    formalOperation: OverflowOperation, viewModel: OverflowFormVm): void {
    switch (formalOperation.targetStatus) {
      case OverflowFormStatus.INACTIVE: {
        this.handleInactiveStatus(overflowFormItemEvent, formalOperation.hasAnimation);
        break;
      }
      case OverflowFormStatus.PAUSE: {
        this.handlePauseStatus(overflowFormItemEvent, formalOperation.hasAnimation);
        break;
      }
      case OverflowFormStatus.ACTIVE: {
        this.handleActiveStatus(overflowFormItemEvent, formalOperation.hasAnimation, viewModel);
        break;
      }
      default: {
        break;
      }
    }
  }

  protected finishStartOverflowFormAnimationCallback(overflowFormItemEvent: OverflowFunInteractionFormEvent,
    viewModel: OverflowFormVm): void {
    log.showInfo(`finishStartOverflowFormAnimationCallback: formId: ${this.mCardId}`);
    overflowFormItemEvent.updateControlButtonInRenderGroupStatus(false);
    this.updateOverflowFormActiveTimer(overflowFormItemEvent, viewModel);
  }

  protected finishStopOverflowFormAnimationCallback(overflowFormItemEvent: OverflowFunInteractionFormEvent): void {
    overflowFormItemEvent.updateLongPressStatus(false);
    overflowFormItemEvent.updateOverflowFormEnableStatus(false);
    overflowFormItemEvent.updateControlButtonInRenderGroupStatus(false);
  }

  protected reportOverflowCardEvent(overflowFormItemEvent: OverflowFunInteractionFormEvent,
    status: OverflowFormStatus): void {
    switch (status) {
      case OverflowFormStatus.INACTIVE: {
        overflowFormItemEvent.handleDisconnectOverflowCardEvent();
        break;
      }
      case OverflowFormStatus.PAUSE: {
        overflowFormItemEvent.handlePauseOverflowCardEvent();
        break;
      }
      default: {
        break;
      }
    }
  }
}