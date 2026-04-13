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

import { LogDomain, LogHelper } from '@ohos/basicutils'
import { NumberConstants, OverflowConstants } from '@ohos/commonconstants';
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OverflowFormStatus, OverflowFormVm } from '../../viewmodel/OverflowFormVm';
import { OverflowFormStatusController, OverflowOperation } from './OverflowFormStatusController';
import { OverflowSceneAnimationFormEvent } from '../../event/OverflowSceneAnimationFormEvent';

const TAG = 'OverflowSceneAnimationFormStatusController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OverflowSceneAnimationFormStatusController extends OverflowFormStatusController {
  private startOverflowFormTimeout?: number;

  constructor(cardId: string) {
    super(cardId);
  }

  protected canDoOperation(operation: OverflowOperation, overflowFormItemEvent: OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm, uiExtProxy: UIExtensionProxy | null): boolean {
    log.showInfo(`canDoOperation, operation: ${operation}, now status: ${viewModel.overflowFormStatus}`);
    switch (operation.targetStatus) {
      case OverflowFormStatus.INACTIVE: {
        return this.canChangeToInactive(overflowFormItemEvent);
      }
      case OverflowFormStatus.ACTIVE: {
        return this.canChangeToActive(overflowFormItemEvent, viewModel, uiExtProxy);
      }
      case OverflowFormStatus.PAUSE: {
        return this.canChangeToPause(viewModel);
      }
      default: {
        return false;
      }
    }
  }

  private canChangeToPause(viewModel: OverflowFormVm): boolean {
    log.showInfo('canChangeToPause, viewModel.overflowFormStatus: %{public}d', viewModel.overflowFormStatus);
    return viewModel.overflowFormStatus === OverflowFormStatus.ACTIVE;
  }

  protected handleFormalOperation(overflowFormItemEvent: OverflowSceneAnimationFormEvent,
    formalOperation: OverflowOperation, viewModel: OverflowFormVm): void {
    switch (formalOperation.targetStatus) {
      case OverflowFormStatus.INACTIVE: {
        this.handleInactiveStatus(overflowFormItemEvent, formalOperation.hasAnimation);
        break;
      }
      case OverflowFormStatus.ACTIVE: {
        this.handleActiveStatus(overflowFormItemEvent, formalOperation.hasAnimation, viewModel);
        break;
      }
      case OverflowFormStatus.PAUSE: {
        this.handlePauseStatus(overflowFormItemEvent, formalOperation.hasAnimation);
        break;
      }
      default: {
        break;
      }
    }
  }

  protected beforeStartOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowSceneAnimationFormEvent): void {
    log.showInfo(`beforeStartOverflowFormAnimationCallback: formId: ${this.mCardId}`);
    super.beforeStartOverflowFormAnimationCallback(overflowFormItemEvent);
    overflowFormItemEvent.setActiveFormBeforeAnimation();
  }

  protected finishStartOverflowFormAnimationCallback(overflowFormItemEvent: OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm): void {
    log.showInfo(`finishStartOverflowFormAnimationCallback: formId: ${this.mCardId}`);
    overflowFormItemEvent.setBaseFormVisibility(Visibility.Hidden);
    overflowFormItemEvent.releaseSnapshot();
    overflowFormItemEvent.afterStartOverflowForm();
  }

  protected beforeStopOverflowFormAnimationCallback(
    overflowFormItemEvent: OverflowSceneAnimationFormEvent): void {
    log.showInfo(`beforeStopOverflowFormAnimationCallback: formId: ${this.mCardId}`);
    overflowFormItemEvent.setBaseFormVisibility(Visibility.Visible);
  }

  protected finishStopOverflowFormAnimationCallback(overflowFormItemEvent: OverflowSceneAnimationFormEvent): void {
    log.showInfo(`finishStopOverflowFormAnimationCallback: formId: ${this.mCardId}`);
    overflowFormItemEvent.updateLongPressStatus(false);
    overflowFormItemEvent.updateOverflowFormEnableStatus(false);
    overflowFormItemEvent.afterStopOverflowForm();
  }

  protected pauseOverflowFormDirectly(overflowFormItemEvent: OverflowSceneAnimationFormEvent): void {
    log.showInfo('pauseOverflowFormDirectly: formId: %{public}s', this.mCardId);
    overflowFormItemEvent.pauseOverflowForm();
    overflowFormItemEvent.afterPauseOverflowForm();
  }

  protected beforePauseOverflowFormAnimationCallback(overflowFormItemEvent: OverflowSceneAnimationFormEvent): void {
    log.showInfo('beforePauseOverflowFormAnimationCallback: formId: %{public}s', this.mCardId);
  }

  protected pauseOverflowForm(overflowFormItemEvent: OverflowSceneAnimationFormEvent): void {
    overflowFormItemEvent.pauseOverflowForm();
  }

  protected finishPauseOverflowFormAnimationCallback(overflowFormItemEvent: OverflowSceneAnimationFormEvent): void {
    log.showInfo('finishPauseOverflowFormAnimationCallback: formId: %{public}s', this.mCardId);
    overflowFormItemEvent.afterPauseOverflowForm();
  }

  protected reportOverflowCardEvent(overflowFormItemEvent: OverflowSceneAnimationFormEvent,
    status: OverflowFormStatus): void {
    switch (status) {
      case OverflowFormStatus.INACTIVE: {
        overflowFormItemEvent.handleDisconnectOverflowCardEvent();
        break;
      }
      default: {
        break;
      }
    }
  }

  protected startOverflowFormDirectly(overflowFormItemEvent: OverflowSceneAnimationFormEvent,
    viewModel: OverflowFormVm): void {
    log.showInfo(`startOverflowFormDirectly: formId: ${this.mCardId}`);
    if (overflowFormItemEvent.isSystemApp()) {
      super.startOverflowFormDirectly(overflowFormItemEvent, viewModel);
      return;
    }
    if (this.startOverflowFormTimeout) {
      clearTimeout(this.startOverflowFormTimeout);
      this.startOverflowFormTimeout = undefined;
    }
    this.beforeStartOverflowFormAnimationCallback(overflowFormItemEvent);
    this.startOverflowFormTimeout = setTimeout(() => {
      this.startOverflowForm(overflowFormItemEvent);
      this.finishStartOverflowFormAnimationCallback(overflowFormItemEvent, viewModel);
    }, NumberConstants.CONSTANT_NUMBER_250);
  }
}