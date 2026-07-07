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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormLayoutCacheManager } from '@ohos/launchercommon';
import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import type { LauncherCardInfo } from '../../bean/LauncherCardInfo';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';

import { BaseCommand } from '../BaseCommand';
import { CommandConsumer } from '../CommandConsumer';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';

const TAG = 'SwitchCardToTopCommand';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 将卡片置顶
 *
 * @since 2024-02-04
 */
export class SwitchCardToTopCommand extends BaseCommand {
  private isOuter: boolean;

  constructor(commandId: string) {
    super();
    this.commandId = commandId;
    this.isOuter = FormLayoutCacheManager.getInstance().checkIfFormInExternalScreen(commandId);
  }

  execute(): void {
    log.showError('commandId: %{public}s is execute', this.commandId);
    const launcherCardInfo: LauncherCardInfo = this.data as LauncherCardInfo;
    if (!launcherCardInfo) {
      log.showWarn('invalid launcherCardInfo');
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }
    let stackId: string | undefined = undefined;
    let cardId: string | undefined = undefined;
    switch (this.commandType) {
      case AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP:
        stackId = this.commandId;
        cardId = launcherCardInfo.operateFormId;
        break;
      case AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP_AFTER_CREATE_STACK:
        stackId = AbilityFormUtil.getCardBelongFormStack(this.commandId)?.formStackId;
        cardId = this.getSwitchCardId(launcherCardInfo, stackId);
        break;
      case AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP_AFTER_ADD_CARD_TO_STACK:
        stackId = this.commandId;
        cardId = this.getSwitchCardId(launcherCardInfo, stackId);
        break;
      default:
        break;
    }
    if (!this.canExecute(cardId ?? '', [])) {
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }

    log.showError('switch card to top, stackId: %{public}s, cardId: %{public}s', stackId, cardId);
    const viewModel: FormStackViewModel = new FormStackViewModel();
    viewModel.swapCardToTopOfFormStack(stackId ?? '', cardId ?? '', true, this.isOuter);
    CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
  }


  private getSwitchCardId(launcherCardInfo: LauncherCardInfo, stackId: string | undefined): string | undefined {
    const portfolioId = launcherCardInfo?.portfolioInfo?.portfolioId;
    log.showInfo('switch card to top, stackId: %{public}s, portfolioId:%{public}s', stackId, portfolioId);
    if (!stackId) {
      log.showWarn('invalid stackId');
      return undefined;
    }
    if (launcherCardInfo.recommendCard) {
      const recItem: LauncherRecItem = launcherCardInfo.recommendCard.recItems?.[0];
      return AbilityFormUtil.getFormStackInfoByFormStackId(stackId)
        .filter(info => AbilityFormUtil.isSameForm(recItem, info))[0]?.cardId;
    }

    if (!portfolioId) {
      log.showWarn('invalid portfolioId');
      return undefined;
    }
    let cardInfo = AbilityFormUtil.getItemInfoFromStackByPortfolioId(stackId, portfolioId);
    if (!cardInfo) {
      log.showWarn('can not find portfolioId: %{public}s in stackId: %{public}s', portfolioId, stackId);
      return '';
    }
    return cardInfo.cardId;
  }

  protected canExecute(cardId: string, cardIds: string[]): boolean {
    if (!cardId || !AbilityFormUtil.getCardBelongFormStack(cardId)) {
      log.showWarn('switch cardId: %{public}s is not belong to any formstack', cardId);
      return false;
    }
    return true;
  }
}