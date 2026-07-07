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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import type { LauncherCardInfo } from '../../bean/LauncherCardInfo';
import { BaseCommand } from '../BaseCommand';
import { CommandConsumer } from '../CommandConsumer';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';
import { AiSuggestionFormManager } from '../../manager/AiSuggestionFormManager';
import { FormLayoutCacheManager } from '@ohos/launchercommon';

const TAG = 'DeleteCardFromFormStackCommand';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 移除堆叠卡片
 *
 * @since 2024-02-04
 */
export class DeleteCardFromFormStackCommand extends BaseCommand {
  private isOuter: boolean;

  constructor(commandId: string) {
    super();
    this.commandId = commandId;
    this.commandType = AiSuggestionUpdateConstants.CommandType.DELETE_CARD_FROM_STACK;
    this.isOuter = FormLayoutCacheManager.getInstance().checkIfFormInExternalScreen(commandId);
  }

  execute(): void {
    log.showError(`commandId: ${this.commandId}, isOuter: ${this.isOuter}`);
    let deleteCards: LauncherCardInfo[] = this.data as LauncherCardInfo[];
    if (CheckEmptyUtils.isEmptyArr(deleteCards)) {
      log.showWarn('deleteCards is empty');

      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }
    let deleteCardIds: string[] = deleteCards.map(cardInfo => cardInfo.operateFormId);
    if (!this.canExecute('', deleteCardIds)) {
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }
    log.showError('delete card from stack, commandId: %{public}s, deleteId: %{public}s',
      this.commandId, deleteCardIds.toString());

    let isKeyGuard: boolean = ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD);
    const isNeedAnimate = !isKeyGuard;
    new FormStackViewModel().deleteCardsFromFormStackForAI(this.commandId, deleteCardIds, isNeedAnimate, this.isOuter);

    // 删除语音助手建议的子卡片
    deleteCardIds
      .forEach(deleteCardId => AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(deleteCardId));

    CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
  }

  protected canExecute(cardId: string, deleteIds: string[]): boolean {
    for (const cardId of deleteIds) {
      if (!AbilityFormUtil.getCardBelongFormStack(cardId)) {
        log.showWarn('delete cardId: %{public}s is not belong to any formstack', cardId);
        return false;
      }
    }
    return true;
  }
}