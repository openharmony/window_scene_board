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

import { Queue } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import formInfo from '@ohos.app.form.formInfo';
import lazy { OverflowFormStatus, OverflowFormVm } from '../../viewmodel/OverflowFormVm';
import { OverflowFunInteractionFormEvent } from '../../event/OverflowFunInteractionFormEvent';
import { OverflowSceneAnimationFormEvent } from '../../event/OverflowSceneAnimationFormEvent';

const TAG = 'OverflowFormStatusController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export abstract class OverflowFormStatusController {
  private mOperationQueue: Queue<OverflowOperation> = new Queue();
  private getCanUpdateStatus?: () => boolean;
  private setCanUpdateStatus?: (value: boolean) => void;
  protected mCardId?: string;
  private isReadyChangeActive?: () => boolean;
  private handleStopOverflow?: (overflowInfo: formInfo.OverflowInfo) => void;
  private mOverflowTimer?: number;

  constructor(cardId: string) {
    this.mCardId = cardId;
  }

  public release(): void {
    log.showInfo('release');
    this.clearOverflowFormActiveTimer();
  }

  /**
   * 初始状态控制的相关功能函数
   *
   * @param setCanUpdateStatus 设置是否可以更新状态的函数
   * @param getCanUpdateStatus 获取是否可以更新状态的函数
   * @param isReadyChangeActive 是否准备好切换到激活状态的函数
   * @param handleStopOverflow 处理停止溢出的函数
   */
  public initFunction(
    setCanUpdateStatus?: (value: boolean) => void, getCanUpdateStatus?: () => boolean,
    isReadyChangeActive?: () => boolean, handleStopOverflow?: (overflowInfo: formInfo.OverflowInfo) => void): void {
    this.setCanUpdateStatus = setCanUpdateStatus;
    this.getCanUpdateStatus = getCanUpdateStatus;
    this.isReadyChangeActive = isReadyChangeActive;
    this.handleStopOverflow = handleStopOverflow;
  }

  /**
   * 注册状态操作
   *
   * @param overflowFormItemEvent overflow卡片事件
   * @param targetStatus 目标状态
   * @param hasAnimation 是否有动画
   * @param viewModel overflow卡片的视图模型
   * @param uiExtProxy UIExtensionProxy
   */
  public registerOperation(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    targetStatus: OverflowFormStatus, hasAnimation: boolean, viewModel: OverflowFormVm,
    uiExtProxy: UIExtensionProxy | null): void {
    // 向消息队列中注册状态切换事件，因为消息的注册和状态切换回调的执行都是在同一个线程里，所且操作都是同步的，
    // 所以当仅当执行动效操作的时候，队列中才有积压消息
    let operation: OverflowOperation = new OverflowOperation(new Date().getTime(), targetStatus, hasAnimation);
    this.mOperationQueue.add(operation);
    let canUpdateStatus: boolean = this.getCanUpdateStatus?.() as boolean;
    log.showInfo(`registerOperation, canUpdateStatus: ${canUpdateStatus}` +
      `, operation: ${operation}, cardId: ${this.mCardId}`);
    if (canUpdateStatus) {
      this.updateStatus(overflowFormItemEvent, viewModel, uiExtProxy);
    }
  }

  /**
   * 更新状态
   *
   * @param overflowFormItemEvent overflow卡片事件
   * @param viewModel overflow卡片的视图模型
   * @param uiExtProxy UIExtensionProxy
   */
  public updateStatus(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm, uiExtProxy: UIExtensionProxy | null): void {
    if (this.mOperationQueue.length <= 0) {
      log.showInfo(`updateStatus, queue is not ready, return` +
        `, this.mOperationQueue.length: ${this.mOperationQueue.length}`);
      return;
    }
    this.setCanUpdateStatus?.(false);
    let formalOperation: OverflowOperation = this.mOperationQueue.pop();
    while (this.mOperationQueue.length > 0) {
      formalOperation = this.pickFormalOperation(formalOperation, this.mOperationQueue.pop());
    }
    let curStatus: OverflowFormStatus = formalOperation.targetStatus;
    let preStatus: OverflowFormStatus = viewModel.overflowFormStatus;
    log.showInfo(`updateStatus, curStatus : ${curStatus}, preStatus : ${preStatus}`);
    if (this.canDoOperation(formalOperation, overflowFormItemEvent, viewModel, uiExtProxy)) {
      log.showInfo(`updateStatus, start handleFormalOperation: ${formalOperation}`);
      this.handleFormalOperation(overflowFormItemEvent, formalOperation, viewModel);
    } else {
      log.showInfo(`updateStatus, cancel handleFormalOperation: ${formalOperation}`);
      this.setCanUpdateStatus?.(true);
    }
    if (preStatus !== curStatus) {
      this.reportOverflowCardEvent(overflowFormItemEvent, curStatus);
    }
  }

  protected reportOverflowCardEvent(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    status: OverflowFormStatus): void {};

  private pickFormalOperation(oper1: OverflowOperation, oper2: OverflowOperation): OverflowOperation {
    // 先比较最终状态的优先级，非激活态 > 暂停态 > 激活态
    // 然后比较时间戳，在相同优先级操作下，选择操作时间更新的一个
    if (oper1.targetStatus.valueOf() < oper2.targetStatus.valueOf()) {
      return oper1;
    }
    if (oper1.targetStatus.valueOf() === oper2.targetStatus.valueOf()) {
      return oper1.timeStamp > oper2.timeStamp ? oper1 : oper2;
    }
    return oper2;
  }

  protected abstract canDoOperation(
    operation: OverflowOperation,
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm, uiExtProxy: UIExtensionProxy | null): boolean;

  protected canChangeToInactive(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): boolean {
    return overflowFormItemEvent.isOverflowFormEnable();
  }

  protected canChangeToActive(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm, uiExtProxy: UIExtensionProxy | null): boolean {
    let isReady: boolean = this.isReadyChangeActive?.() as boolean;
    log.showInfo(`canChangeToActive, viewModel.overflowFormStatus: ${viewModel.overflowFormStatus}` +
      `, isReady: ${isReady}, uiExtProxy: ${(uiExtProxy === null)}`);
    if (viewModel.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      return false;
    }
    if (isReady) {
      return true;
    }

    // 快速操作时，存在 extensionComponent 尚未创建，其他应用已经拉起的场景
    if (uiExtProxy && viewModel.overflowFormStatus == OverflowFormStatus.INACTIVE) {
      this.registerOperation(overflowFormItemEvent, OverflowFormStatus.INACTIVE, false, viewModel, uiExtProxy);
    }
    return false;
  }

  protected handleInactiveStatus(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    hasAnimation: boolean): void {
    if (!hasAnimation) {
      this.clearOverflowFormActiveTimer();
      this.doOperationDirectly(() => { this.stopOverflowFormDirectly(overflowFormItemEvent); });
    } else {
      this.doOperationWithAnimation(
        () => { this.beforeStopOverflowFormAnimationCallback(overflowFormItemEvent); },
        () => { this.stopOverflowForm(overflowFormItemEvent); },
        () => { this.finishStopOverflowFormAnimationCallback(overflowFormItemEvent); }
      );
    }
  }

  protected handleActiveStatus(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    hasAnimation: boolean, viewModel: OverflowFormVm): void {
    if (!hasAnimation) {
      this.clearOverflowFormActiveTimer();
      this.doOperationDirectly(() => { this.startOverflowFormDirectly(overflowFormItemEvent, viewModel); });
    } else {
      this.doOperationWithAnimation(
        () => { this.beforeStartOverflowFormAnimationCallback(overflowFormItemEvent); },
        () => { this.startOverflowForm(overflowFormItemEvent); },
        () => { this.finishStartOverflowFormAnimationCallback(overflowFormItemEvent, viewModel); }
      );
    }
  }

  protected handlePauseStatus(overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    hasAnimation: boolean): void {
    if (!hasAnimation) {
      this.doOperationDirectly(() => { this.pauseOverflowFormDirectly(overflowFormItemEvent); });
    } else {
      this.doOperationWithAnimation(
        () => { this.beforePauseOverflowFormAnimationCallback(overflowFormItemEvent); },
        () => { this.pauseOverflowForm(overflowFormItemEvent); },
        () => { this.finishPauseOverflowFormAnimationCallback(overflowFormItemEvent); }
      );
    }
  }

  protected abstract handleFormalOperation(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    formalOperation: OverflowOperation, viewModel: OverflowFormVm): void;

  protected doOperationWithAnimation(beforeCallback?: Function, animationCallback?: Function,
    finishCallback?: Function): void {
    this.clearOverflowFormActiveTimer();
    beforeCallback?.();
    animateTo({
      duration: NumberConstants.CONSTANT_NUMBER_250,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish:() => {
        finishCallback?.();
        this.setCanUpdateStatus?.(true);
      }
    }, () => {
      animationCallback?.();
    });
  }

  protected doOperationDirectly(operationCallback: Function | undefined): void {
    operationCallback?.();
    this.setCanUpdateStatus?.(true);
  }

  /**
   * 清除 overflow 卡片的激活定时器
   */
  public clearOverflowFormActiveTimer(): void {}

  protected stopOverflowFormDirectly(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    log.showInfo(`stopOverflowFormDirectly: formId: ${this.mCardId}`);
    this.beforeStopOverflowFormAnimationCallback(overflowFormItemEvent);
    overflowFormItemEvent.stopOverflowForm();
    this.finishStopOverflowFormAnimationCallback(overflowFormItemEvent);
  }

  protected startOverflowFormDirectly(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm): void {
    log.showInfo(`startOverflowFormDirectly: formId: ${this.mCardId}`);
    this.beforeStartOverflowFormAnimationCallback(overflowFormItemEvent);
    this.startOverflowForm(overflowFormItemEvent);
    this.finishStartOverflowFormAnimationCallback(overflowFormItemEvent, viewModel);
  }

  protected beforeStopOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    log.showInfo(`beforeStopOverflowFormAnimationCallback: formId: ${this.mCardId}`);
  }

  protected stopOverflowForm(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    overflowFormItemEvent.stopOverflowForm();
  }

  protected abstract finishStopOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void;

  protected pauseOverflowFormDirectly(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    log.showInfo(`pauseOverflowFormDirectly: formId: ${this.mCardId}`);
    overflowFormItemEvent.pauseOverflowForm();
  }

  protected beforePauseOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    log.showInfo(`beforePauseOverflowFormAnimationCallback: formId: ${this.mCardId}`);
  }

  protected pauseOverflowForm(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    overflowFormItemEvent.updateLongPressStatus(false);
    overflowFormItemEvent.pauseOverflowForm();
  }

  protected finishPauseOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    log.showInfo(`finishPauseOverflowFormAnimationCallback: formId: ${this.mCardId}`);
  }

  protected beforeStartOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    log.showInfo(`beforeStartOverflowFormAnimationCallback: formId: ${this.mCardId}`);

    // 无条件重置长按标志位
    overflowFormItemEvent.updateLongPressStatus(false);
  }

  protected startOverflowForm(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent): void {
    overflowFormItemEvent.startOverflowForm();
  }

  protected abstract finishStartOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowFunInteractionFormEvent | OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm): void;

  private clearOverflowTimer(): void {
    if (this.mOverflowTimer) {
      clearTimeout(this.mOverflowTimer);
    }
    this.mOverflowTimer = undefined;
  }
}

export class OverflowOperation {
  public timeStamp: number = 0;
  public targetStatus: OverflowFormStatus = OverflowFormStatus.INACTIVE;
  public hasAnimation: boolean = false;

  constructor(timeStamp: number, targetStatus: OverflowFormStatus, hasAnimation: boolean) {
    this.timeStamp = timeStamp;
    this.targetStatus = targetStatus;
    this.hasAnimation = hasAnimation;
  }

  public toString(): string {
    return `${this.targetStatus}_${this.hasAnimation}`;
  }
}
