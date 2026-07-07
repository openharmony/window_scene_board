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
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  FormLayoutCacheManager,
  FormModel,
  FormStackEventIdUtil,
  GridLayoutItemInfo,
  RdbStoreManager,
} from '@ohos/launchercommon';
import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { LauncherCardInfo } from '../../bean/LauncherCardInfo';
import { OperateFormStackHelper } from '../../manager/OperateFormStackHelper';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';

import { BaseCommand } from '../BaseCommand';
import { CommandConsumer } from '../CommandConsumer';
import { OperateFormStackDetails } from '../OperateFormStackDetails';
import { UserSwitchService } from '@ohos/screenlockcommon';

const TAG = 'CreateFormStackCommand';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const FINISH_COMMAND_DELAY = 3000;

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
 * 创建堆叠卡片命令
 *
 * @since 2024-02-04
 */
export class CreateFormStackCommand extends BaseCommand {
  public eventId: string;
  public onCreateFailed: (cards: GridLayoutItemInfo[], endLayoutInfo: GridLayoutItemInfo) => void =
    (createFormStackList, endLayoutInfo) => {
      this.onCreateFormStackFail(createFormStackList, endLayoutInfo)
    };
  private isOuter: boolean;

  constructor(commandId: string) {
    super();
    this.commandId = commandId;
    this.commandType = AiSuggestionUpdateConstants.CommandType.CREATE_FORM_STACK;
    this.eventId = FormStackEventIdUtil.getCreateFormStackFailedEventId(this.commandId);
    GlobalContext.getContext()?.eventHub.on(this.eventId, this.onCreateFailed);
    this.isOuter = FormLayoutCacheManager.getInstance().checkIfFormInExternalScreen(commandId);
  }

  execute(): void {
    log.showError(`commandId: ${this.commandId}, isOuter: ${this.isOuter}`);
    let cardInfoList: LauncherCardInfo[] = this.data as LauncherCardInfo[];
    cardInfoList =
      cardInfoList?.filter(addCardInfo => !LauncherCardInfo.isExpired(addCardInfo))
        .filter(addCardInfo => LauncherCardInfo.isCardInfoValid(addCardInfo));
    if (!cardInfoList || cardInfoList.length === 0) {
      log.showError('createFormStack occur error, cardInfoList is invalid');
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }
    let cardInfo = cardInfoList[0];
    const endLayoutInfo = FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId(cardInfo.operateFormId,
      this.isOuter);
    if (!endLayoutInfo || !this.canExecute(endLayoutInfo?.cardId ?? '', [])) {
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
      return;
    }
    this.createFormStack(endLayoutInfo, cardInfoList);
  }

  protected canExecute(cardId: string, cardIds: string[]): boolean {
    if (!super.canExecute(cardId, cardIds)) {
      log.showWarn('canExecute return');
      return false;
    }
    if (AbilityFormUtil.getCardBelongFormStack(cardId)) {
      // 已经在堆叠里了，不能再执行创建堆叠
      log.showWarn('parent cardId: %{public}s has already exist in formstack', cardId);
      return false;
    }
    return true;
  }

  async createFormStack(endLayoutInfo: GridLayoutItemInfo, cardInfoList: LauncherCardInfo[]): Promise<void> {
    const createFormStackList: GridLayoutItemInfo[] = [];
    const formStackViewModel = new FormStackViewModel();
    for (let i = 0; i < cardInfoList.length; i++) {
      let cardInfo = cardInfoList[i];
      let startLayoutInfo: GridLayoutItemInfo;
      if (cardInfo.recommendCard) {
        startLayoutInfo = AbilityFormUtil.createCard(endLayoutInfo, cardInfo.recommendCard.recItems?.[0]);
      } else {
        startLayoutInfo = AbilityFormUtil.createVoiceSuggestionCard(endLayoutInfo);
        startLayoutInfo.cardId = String(Math.ceil(Math.random() * Number(this.commandId)));
        startLayoutInfo.extend1 = JSON.stringify({
          parameters: ({
            'data': ({
              commandId: this.commandId,
              commandType: this.commandType,
              operateFormId: cardInfo.operateFormId,
              portfolioId: cardInfo.portfolioInfo?.portfolioId,
              cardUniqueTag: cardInfo.cardUniqueTag,
              cardType: AiSuggestionUpdateConstants.CardType.TEMP,
            } as GeneratedObjectLiteralInterface_1)
          } as GeneratedObjectLiteralInterface_2)
        });
      }
      log.showError('createFormStack operateFormId: %{public}s, newCardId: %{public}s',
        endLayoutInfo.cardId, startLayoutInfo.cardId);

      createFormStackList.push(startLayoutInfo);
      if (startLayoutInfo.cardId) {
        OperateFormStackHelper.getInstance().setCachePortfolioCardInfo(startLayoutInfo.cardId, cardInfo);
      }
    }
    createFormStackList.push(endLayoutInfo);
    let details = new OperateFormStackDetails();
    details.addSize = cardInfoList.length;
    OperateFormStackHelper.getInstance().setFormStackLength(`${this.commandId}_${this.commandType}`, details);
    let isCreateFormStackSuccess =
      formStackViewModel.addNewFormStack(createFormStackList, endLayoutInfo, true, false, this.isOuter);

    if (!isCreateFormStackSuccess) {
      // 删除脏数据
      this.onCreateFormStackFail(createFormStackList, endLayoutInfo);
    }
    setTimeout(() => {
      GlobalContext.getContext()?.eventHub.off(this.eventId, this.onCreateFailed);
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType);
    }, FINISH_COMMAND_DELAY);
  }

  onCreateFormStackFail(cards: GridLayoutItemInfo[], endLayoutInfo: GridLayoutItemInfo): void {
    let addCardList = cards.filter(cardInfo => cardInfo.cardId !== endLayoutInfo.cardId);
    log.showWarn(`onAddCardToFormStackFail cardIds: [${addCardList.map(cardInfo => cardInfo.cardId).join(',')}]`);
    addCardList.forEach(cardInfo => {
      FormModel.getInstance().deleteFormById(cardInfo.cardId, false, this.isOuter, 0, false);
    });
  }
}