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
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { FormLayoutCacheManager, FormModel, GridLayoutItemInfo, RdbStoreManager, } from '@ohos/launchercommon';
import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import { FormStackStyleConstants } from '@ohos/formstack/src/main/ets/common/FormStackStyleConstants';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { LauncherCardInfo } from '../../bean/LauncherCardInfo';
import { OperateFormStackHelper } from '../../manager/OperateFormStackHelper';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';
import { BaseCommand } from '../BaseCommand';
import { CommandConsumer } from '../CommandConsumer';
import { OperateFormStackDetails } from '../OperateFormStackDetails';

const TAG = 'AddFormToFormStackCommand';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const FINISH_COMMAND_DELAY = 2000;

interface GeneratedObjectLiteralInterface_1 {
  commandId: string;
  commandType: number;
  operateFormId: string;
  portfolioId: string;
  cardUniqueTag: string;
  cardType: AiSuggestionUpdateConstants.CardType;
}

interface GeneratedObjectLiteralInterface_2 {
  'data': GeneratedObjectLiteralInterface_1;
}

/**
 * 添加卡片到堆叠
 *
 * @since 2024-02-04
 */
export class AddFormToFormStackCommand extends BaseCommand {
  private isOuter: boolean;

  constructor(commandId: string) {
    super();
    this.commandId = commandId;
    this.commandType = AiSuggestionUpdateConstants.CommandType.ADD_CARD_TO_STACK;
    this.isOuter = FormLayoutCacheManager.getInstance().checkIfFormInExternalScreen(commandId);
  }

  async execute(): Promise<void> {
    log.showError(`commandId: ${this.commandId}, isOuter: ${this.isOuter}`);
    const stackItemList = AbilityFormUtil.getFormStackInfoByFormStackId(this.commandId);
    if (CheckEmptyUtils.isEmptyArr(stackItemList)) {
      log.showWarn('addCardToFormStack fail, formstack is emtpy');
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }
    let addCardMap: Map<string, LauncherCardInfo[]> = this.data as Map<string, LauncherCardInfo[]>;
    const addCardLength = Array.from(addCardMap.values()).flat().length;
    if (this.isExceedLimit(addCardLength, stackItemList.length)) {
      log.showWarn('addCardToFormStack fail, stackId:%{public}s, stackLength:%{public}d,' +
        ' addCardLength:%{public}d, exceeding the limit', this.commandId, stackItemList.length, addCardLength);
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }
    for (const entry of addCardMap) {
      const operateCardId = entry[0];
      const addCards = entry[1];
      await this.addCardsToFormStack(addCards, stackItemList, operateCardId);
    }
    setTimeout(() => {
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
    }, FINISH_COMMAND_DELAY);
  }

  private async addCardsToFormStack(targetCards: LauncherCardInfo[], stackItemList: GridLayoutItemInfo[],
    operateFormId: string): Promise<void> {
    if (!this.canExecute(operateFormId, [])) {
      log.showWarn(`addCardToFormStack fail, operateFormId:${operateFormId} not exist in formstack`);
      return;
    }
    const addCards = targetCards
      .filter(addCardInfo => !LauncherCardInfo.isExpired(addCardInfo))
      .filter(addCardInfo => LauncherCardInfo.isCardInfoValid(addCardInfo));

    log.showInfo(`addCards portfolioIds: ${addCards.map(addCard => addCard.portfolioInfo?.portfolioId).join(',')}`);
    if (CheckEmptyUtils.isEmptyArr(addCards)) {
      log.showWarn(`addCardToFormStack fail, addCards:${operateFormId} is empty, targetCards size:${targetCards.length}`);
      return;
    }
    const layoutInfo =
      FormLayoutCacheManager.getInstance().selectAllFormsList(this.isOuter).find(item => item.cardId === operateFormId);

    let addCardList = await this.getCardList(operateFormId, addCards, layoutInfo);

    let details = new OperateFormStackDetails();
    details.addSize = addCardList.length;
    OperateFormStackHelper.getInstance().setFormStackLength(`${this.commandId}_${this.commandType}`, details);
    let isCardOnTopOfFormStack = stackItemList[stackItemList.length - 1].cardId === operateFormId;
    let targetCardId = isCardOnTopOfFormStack ? stackItemList[0].cardId : operateFormId;
    let isAddCardToFormStackSuccess = new FormStackViewModel().addCardsToFormStack(this.commandId, addCardList, {
      isNeedAnimate: true,
      targetCardId: targetCardId,
      isAppendFromTail: !isCardOnTopOfFormStack,
    }, this.isOuter);
    if (!isAddCardToFormStackSuccess) {
      this.onAddCardToFormStackFail(addCardList);
    }
  }

  private isExceedLimit(addCardLength: number, stackLength: number): boolean {
    const formCount = addCardLength + stackLength;
    if ((!this.isOuter && formCount <= FormStackStyleConstants.FORM_STACK_CARD_MAX_NUM) ||
      (this.isOuter && formCount <= FormStackStyleConstants.OUTER_FORM_STACK_CARD_MAX_NUM)) {
      return false;
    }
    return true;
  }

  private async getCardList(
    operateFormId: string,
    addCards: LauncherCardInfo[],
    layoutInfo: GridLayoutItemInfo | undefined,
  ): Promise<GridLayoutItemInfo[]> {
    let addCardList: GridLayoutItemInfo[] = [];
    for (let addCardInfo of addCards) {
      let addLayoutInfo: GridLayoutItemInfo;
      if (addCardInfo.recommendCard) {
        addLayoutInfo = AbilityFormUtil.createCard(layoutInfo, addCardInfo.recommendCard.recItems?.[0]);
      } else {
        addLayoutInfo = AbilityFormUtil.createVoiceSuggestionCard(layoutInfo);
        // commandId有可能不是number类型，使用随机数乘以当前时间戳生成cardId
        addLayoutInfo.cardId = AbilityFormUtil.generateCardId();
        addLayoutInfo.extend1 = JSON.stringify({
          parameters: ({
            'data': ({
              commandId: this.commandId,
              commandType: this.commandType,
              operateFormId: operateFormId,
              portfolioId: addCardInfo.portfolioInfo?.portfolioId,
              cardUniqueTag: addCardInfo.cardUniqueTag,
              cardType: AiSuggestionUpdateConstants.CardType.TEMP,
            } as GeneratedObjectLiteralInterface_1)
          } as GeneratedObjectLiteralInterface_2)
        });
      }
      log.showError('add from to stack, commandId: %{public}s, operateFormId: %{public}s, newCardId: %{public}s',
        this.commandId, operateFormId, addLayoutInfo.cardId);
      addCardList.push(addLayoutInfo);
      if (addLayoutInfo.cardId) {
        OperateFormStackHelper.getInstance().setCachePortfolioCardInfo(addLayoutInfo.cardId, addCardInfo);
      }
    }
    return addCardList;
  }

  onAddCardToFormStackFail(cards: GridLayoutItemInfo[]): void {
    log.showWarn(`onAddCardToFormStackFail cardIds: [${cards.map(cardInfo => cardInfo.cardId).join(',')}]`);
    cards.forEach(cardInfo => {
      FormModel.getInstance().deleteFormById(cardInfo.cardId, false, this.isOuter, 0, false);
    });
  }

  protected canExecute(cardId: string, deleteIds: string[]): boolean {
    if (!super.canExecute(cardId, deleteIds)) {
      log.showWarn('canExecute return');
      return false;
    }
    if (!AbilityFormUtil.getCardBelongFormStack(cardId)) {
      log.showWarn('add parent cardId: %{public}s is not belong to any formstack', cardId);
      return false;
    }
    return true;
  }
}