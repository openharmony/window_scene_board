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

import formInfo from '@ohos.app.form.formInfo';
import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { AppModel, CommonConstants, FormLayoutCacheManager, FormManager, } from '@ohos/launchercommon';
import bundleManager from '@ohos.bundle.bundleManager';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import type { InputComposedAbilities } from '../bean/InputComposedAbilities';
import { InputComposedData } from '../bean/InputComposedData';
import type { InputRefreshData } from '../bean/InputRefreshData';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import type { BaseCommand } from '../command/BaseCommand';
import { AddFormToFormStackCommand } from '../command/imp/AddFormToFormStackCommand';
import { CreateFormStackCommand } from '../command/imp/CreateFormStackCommand';
import { DeleteCardFromFormStackCommand } from '../command/imp/DeleteCardFromFormStackCommand';
import { SwitchCardToTopCommand } from '../command/imp/SwitchCardToTopCommand';
import { UpdateFormsCommand } from '../command/imp/UpdateFormsCommand';
import { AiSuggestionResourceManager } from '../manager/AiSuggestionResourceManager';
import { AbilityFormUtil } from './AbilityFormUtil';
import { InputRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/InputRecItem';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { CardResourceInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/CardResourceInfo';

const TAG: string = 'DataConverter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

// 轮转置顶延时，以确保创建堆叠时，新增的卡片已经刷新完成再显示出来
const SWITCH_COMMAND_EXECUTE_DELAY = 1000;

// 删除卡片延时，以确保没有被删除的卡片已经刷新完成
const DELETE_COMMAND_EXECUTE_DELAY = 1000;

// 刷新延时，以确保创建堆叠时，轮转卡片的动效已经完成
const UPDATE_COMMAND_EXECUTE_DELAY = 1000;

/**
 * 数据预处理，将输入的数据转化成指令
 *
 * @since 2024-02-06
 */
export class DataConverter {
  /**
   * 需要刷新的卡片
   * key: 母卡ID
   * value: 刷新的卡片数据
   */
  private mRefreshForms: Map<string, LauncherCardInfo> = new Map();
  /**
   * 需要操作的堆叠
   * key: 堆叠ID
   * value: 操作的卡片数据集合
   */
  private mOperateStacks: Map<string, LauncherCardInfo[]> = new Map();
  /**
   * 需要创建的堆叠
   * key: 母卡ID
   * value: 添加的卡片数据集合
   */
  private mCreateStacks: Map<string, LauncherCardInfo[]> = new Map();

  /**
   * 数据转化为命令集合
   *
   * @param inputRefreshDataList 原始输入数据
   * @returns Map<操作类型，Map<命令ID, 命令组>> 操作类型：更新卡片，创建堆叠，操作堆叠
   */
  async convertToCommands(inputRefreshDataList: InputRefreshData[]): Promise<Map<number, Map<string, BaseCommand[]>>> {
    const commandMap: Map<number, Map<string, BaseCommand[]>> = new Map();
    if (CheckEmptyUtils.isEmptyArr(inputRefreshDataList)) {
      log.showWarn('convertToCommands input is empty');
      return commandMap;
    }
    this.logInputInfo(inputRefreshDataList);

    // 数据转化、过滤、分组
    await Promise.all(
      inputRefreshDataList.map(
        async inputRefreshData => {
          const cardInfoList: LauncherCardInfo[] = await this.convertComposedData(inputRefreshData.dataList);
          inputRefreshData.formIds
            .filter(formId => this.isExistInDesktop(formId))
            .forEach(
              (formId: string) => {
                cardInfoList.forEach(
                  (cardInfo: LauncherCardInfo) => {
                    const info = ObjectCopyUtil.deepClone(cardInfo, new LauncherCardInfo());
                    info.operateFormId = formId;
                    info.stackId = AbilityFormUtil.getCardBelongFormStack(formId)?.formStackId ?? info.stackId;
                    const groupType = this.getGroupType(info);
                    this.groupByType(info, groupType);
                  }
                );
              }
            );
        }
      )
    );

    // 根据分组的数据进行排序生成命令
    commandMap.set(AiSuggestionUpdateConstants.GroupType.CREATE_STACKS, this.handleCreateStackData());
    commandMap.set(AiSuggestionUpdateConstants.GroupType.OPERATE_STACKS, this.handleOperateStackData());
    commandMap.set(AiSuggestionUpdateConstants.GroupType.REFRESH_FORMS, this.handleRefreshFormData());
    return commandMap;
  }

  private logInputInfo(inputRefreshDataList: InputRefreshData[]): void {
    inputRefreshDataList.forEach(inputRefreshData => {
      if (!inputRefreshData) {
        log.showWarn('invalid inputRefreshData');
        return;
      }
      if (ArrayUtils.isEmpty(inputRefreshData.formIds)) {
        log.showWarn('inputRefreshData formIds empty');
        return;
      }
      if (ArrayUtils.isEmpty(inputRefreshData.dataList)) {
        log.showWarn(`cardIds: ${inputRefreshData.formIds.toString()}, invalid dataList`);
        return;
      }
      inputRefreshData.dataList.forEach(refreshData => {
        if (!refreshData) {
          log.showWarn(`cardIds: ${inputRefreshData.formIds.toString()}, invalid refreshData`);
          return;
        }
        if (!InputComposedData.isNeedUpdateContent(refreshData)) {
          return;
        }
        log.showError('cardIds: %{public}s, optType: %{public}d, portfolioId: %{public}s, portrait recItems:' +
          ' %{public}s, landscape recItems: %{public}s', inputRefreshData.formIds.toString(), refreshData.optType,
          refreshData.portfolioInfo?.portfolioId, this.getRecItemContent(refreshData.portrait?.recItems),
          this.getRecItemContent(refreshData.landscape?.recItems));
      });
    });
  }

  private getRecItemContent(recItems: InputRecItem[] | undefined): string {
    if (!recItems) {
      return '';
    }
    return recItems.map(item => {
      if (item.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        return item.subRecItems?.map(subRecItem => subRecItem.serviceId).join(',');
      } else {
        return item.serviceId;
      }
    }).join(',')
  }

  private handleRefreshFormData(): Map<string, BaseCommand[]> {
    const operateMap: Map<string, BaseCommand[]> = new Map();
    this.mRefreshForms.forEach(
      (cardInfo, cardId) => {
        const commands: BaseCommand[] = [];
        operateMap.set(cardId, commands);
        const cmd = new UpdateFormsCommand(cardId);
        cmd.operateCardId = cardId;
        cmd.data = cardInfo;
        commands.push(cmd);
      }
    );
    return operateMap;
  }

  private handleOperateStackData(): Map<string, BaseCommand[]> {
    const operateMap: Map<string, BaseCommand[]> = new Map();
    this.mOperateStacks.forEach(
      (cardInfoList, stackId) => {
        const commands: BaseCommand[] = [];
        const deleteCards: LauncherCardInfo[] = [];
        const addCardMap: Map<string, LauncherCardInfo[]> = new Map();
        const updateCards: LauncherCardInfo[] = [];
        const switchCards: LauncherCardInfo[] = [];
        for (let index = 0; index < cardInfoList.length; index++) {
          const cardInfo = cardInfoList[index];
          if (LauncherCardInfo.isDeleteCard(cardInfo)) {
            deleteCards.push(cardInfo);
          } else if (LauncherCardInfo.isAddCard(cardInfo)) {
            const addCards = addCardMap.get(cardInfo.operateFormId) ?? [];
            addCards.push(cardInfo);
            addCardMap.set(cardInfo.operateFormId, addCards);
          } else if (LauncherCardInfo.isUpdateCard(cardInfo)) {
            updateCards.push(cardInfo);
          } else if (LauncherCardInfo.isNeedToSwitch(cardInfo)) {
            switchCards.push(cardInfo);
          } else {
            log.showWarn('unknown optType:%{public}d', cardInfo.optType);
          }
        }
        this.buildAddCommands(addCardMap, commands, stackId);
        this.buildUpdateCommands(updateCards, commands, stackId);
        this.buildSwitchCommands(switchCards, commands, stackId);
        this.buildDeleteCommands(deleteCards, commands, stackId);
        operateMap.set(stackId, commands);
      }
    );
    return operateMap;
  }

  private buildAddCommands(addCardMap: Map<string, LauncherCardInfo[]>, commands: BaseCommand[],
    stackId: string): void {
    if (addCardMap.size === 0) {
      return;
    }
    const cmd = new AddFormToFormStackCommand(stackId);
    cmd.data = addCardMap;
    commands.push(cmd);
    const addCards: LauncherCardInfo[] = Array.from(addCardMap.values()).flat();
    let cardIndex = addCards.findIndex(cardInfo => LauncherCardInfo.isNeedToSwitch(cardInfo));
    if (cardIndex !== CommonConstants.INVALID_VALUE) {
      let cardInfo = addCards[cardIndex];
      const cmd = new SwitchCardToTopCommand(stackId);
      cmd.commandType = AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP_AFTER_ADD_CARD_TO_STACK;
      cmd.data = cardInfo;
      cmd.delayTime = SWITCH_COMMAND_EXECUTE_DELAY;
      commands.push(cmd);
    }
  }

  private buildDeleteCommands(deleteCards: LauncherCardInfo[], commands: BaseCommand[], stackId: string): void {
    if (CheckEmptyUtils.isEmptyArr(deleteCards)) {
      return;
    }
    const cmd = new DeleteCardFromFormStackCommand(stackId);
    cmd.data = deleteCards;
    cmd.delayTime = DELETE_COMMAND_EXECUTE_DELAY;
    commands.push(cmd);
  }

  private buildUpdateCommands(updateCards: LauncherCardInfo[], commands: BaseCommand[], stackId: string): void {
    updateCards.forEach(cardInfo => {
      const cmd = new UpdateFormsCommand(stackId);
      cmd.data = cardInfo;
      cmd.operateCardId = cardInfo.operateFormId;
      commands.push(cmd);
    });
  }

  private buildSwitchCommands(
    switchCards: LauncherCardInfo[],
    commands: BaseCommand[],
    stackId: string
  ): void {
    switchCards.forEach((cardInfo) => {
      if (LauncherCardInfo.isNeedToSwitch(cardInfo)) {
        const cmd = new SwitchCardToTopCommand(stackId);
        cmd.data = cardInfo;
        cmd.delayTime = SWITCH_COMMAND_EXECUTE_DELAY;
        cmd.commandType = AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP;
        commands.push(cmd);
      }
    });
  }

  private handleCreateStackData(): Map<string, BaseCommand[]> {
    const operateMap: Map<string, BaseCommand[]> = new Map();
    this.mCreateStacks.forEach((cardInfoList, cardId) => {
      const commands: BaseCommand[] = [];
      // 1、创建堆叠
      const cmd = new CreateFormStackCommand(cardId);
      cmd.data = cardInfoList;
      commands.push(cmd);

      // 2、轮转置顶
      let cardIndex = cardInfoList.findIndex(cardInfo => LauncherCardInfo.isNeedToSwitch(cardInfo));
      if (cardIndex !== CommonConstants.INVALID_VALUE) {
        let cardInfo = cardInfoList[cardIndex];
        const cmd = new SwitchCardToTopCommand(cardId);
        cmd.commandType = AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP_AFTER_CREATE_STACK;
        cmd.data = cardInfo;
        cmd.delayTime = SWITCH_COMMAND_EXECUTE_DELAY;
        commands.push(cmd);
      }

      // 3、刷新母卡
      let cardInfo = this.mRefreshForms.get(cardId);
      if (cardInfo) {
        const cmd = new UpdateFormsCommand(cardId);
        cmd.operateCardId = cardId;
        cmd.data = cardInfo;
        cmd.delayTime = UPDATE_COMMAND_EXECUTE_DELAY;
        commands.push(cmd);
        this.mRefreshForms.delete(cardId);
      }
      operateMap.set(cardId, commands);
    });
    return operateMap;
  }

  private isExistInDesktop(cardId: string): boolean {
    let item = FormLayoutCacheManager.getInstance().selectAllFormsList().find(item => item.cardId === cardId);
    return !CheckEmptyUtils.isEmpty(item);
  }

  private getGroupType(cardInfo: LauncherCardInfo): AiSuggestionUpdateConstants.GroupType {
    if (!CheckEmptyUtils.checkStrIsEmpty(cardInfo.stackId)) {
      return AiSuggestionUpdateConstants.GroupType.OPERATE_STACKS;
    }
    if (LauncherCardInfo.isAddCard(cardInfo)) {
      return AiSuggestionUpdateConstants.GroupType.CREATE_STACKS;
    }
    return AiSuggestionUpdateConstants.GroupType.REFRESH_FORMS;
  }

  private groupByType(cardInfo: LauncherCardInfo, groupType: AiSuggestionUpdateConstants.GroupType): void {
    switch (groupType) {
      case AiSuggestionUpdateConstants.GroupType.REFRESH_FORMS:
        if (!CheckEmptyUtils.checkStrIsEmpty(cardInfo.stackId)) {
          const operateCards = this.mOperateStacks.get(cardInfo.stackId) ?? [];
          operateCards.push(cardInfo);
          this.mOperateStacks.set(cardInfo.stackId, operateCards);
        } else {
          this.mRefreshForms.set(cardInfo.operateFormId.toString(), cardInfo);
        }
        break;
      case AiSuggestionUpdateConstants.GroupType.OPERATE_STACKS:
        const operateCards = this.mOperateStacks.get(cardInfo.stackId) ?? [];
        operateCards.push(cardInfo);
        this.mOperateStacks.set(cardInfo.stackId, operateCards);
        break;
      case AiSuggestionUpdateConstants.GroupType.CREATE_STACKS:
        if (this.isInvalidCreateCard(cardInfo)) {
          log.showWarn('groupByType invalid create formstack info %{public}s', cardInfo.operateFormId);
          return;
        }
        const formId = cardInfo.operateFormId.toString();
        const createCards = this.mCreateStacks.get(formId) ?? [];
        createCards.push(cardInfo);
        this.mCreateStacks.set(formId, createCards);
        break;
      default:
        log.showWarn('groupByType unknown type = %{public}d', groupType);
        break;
    }
  }

  private isInvalidCreateCard(cardInfo: LauncherCardInfo): boolean {
    // 检查是否不在堆叠中，在堆叠中直接丢弃，跟桌面状态不匹配
    const cardId = cardInfo.operateFormId;
    return this.isCardExistInFormStack(cardId);
  }

  private isCardExistInFormStack(cardId: string): boolean {
    return AbilityFormUtil.getCardBelongFormStack(cardId) != null;
  }

  private async convertComposedData(composedDataList: InputComposedData[]): Promise<LauncherCardInfo[]> {
    return Promise.all(
      composedDataList.map(
        async composedData => {
          const portrait = await this.convertDisplayData(composedData.portrait);
          const landscapeOrExpand = await this.convertDisplayData(composedData.landscape ?? composedData.expand);
          const recommendCard = await this.convertDisplayData(composedData.recommendCard);
          const portfolioInfo = await this.convertPortfolioInfo(composedData.portfolioInfo);
          return ObjectCopyUtil.deepClone({
            recId: composedData.recId,
            subRecId: composedData.subRecId,
            optType: composedData.optType,
            portrait,
            landscapeOrExpand,
            recommendCard,
            portfolioInfo,
            cardUniqueTag: composedData.cardUniqueTag,
            featureVersion: composedData.featureVersion,
          } as LauncherCardInfo
          );
        }
      )
    );
  }

  private async convertPortfolioInfo(portfolioInfo: PortfolioInfo | undefined): Promise<PortfolioInfo | null> {
    // normal card
    if (CheckEmptyUtils.isEmpty(portfolioInfo)) {
      return Promise.resolve(null);
    }
    if (!portfolioInfo) {
      return Promise.resolve(null);
    }
    // portfolio card
    const retInfo = ObjectCopyUtil.deepClone(portfolioInfo);
    retInfo.dark = await this.convertCardResourceInfo(portfolioInfo.dark) ?? new CardResourceInfo();
    retInfo.light = await this.convertCardResourceInfo(portfolioInfo.light) ?? new CardResourceInfo();
    return retInfo;
  }

  private async convertCardResourceInfo(cardResourceInfo: CardResourceInfo | undefined)
    : Promise<CardResourceInfo | undefined> {
    if (!cardResourceInfo) {
      // default卡片仅有顶部标题和ID，没有插画资源
      return undefined;
    }

    await AiSuggestionResourceManager.getInstance()
      .loadResources([cardResourceInfo.picResId, cardResourceInfo.pic1ResId])
    return ObjectCopyUtil.deepClone(cardResourceInfo);
  }

  private async convertDisplayData(inputComposedAbilities: InputComposedAbilities | undefined)
    : Promise<LauncherDisplayCardInfo | undefined> {
    if (CheckEmptyUtils.isEmpty(inputComposedAbilities)) {
      return undefined;
    }
    if (!inputComposedAbilities) {
      return undefined;
    }
    const rowsTemplate = this.composeTemplate(inputComposedAbilities.row);
    const columnsTemplate = this.composeTemplate(inputComposedAbilities.column);
    const launcherRecItems: Array<LauncherRecItem | undefined> =
      await Promise.all(inputComposedAbilities.recItems?.map(async (item) => await this.convertRecItem(item)));
    const displayCardInfo = new LauncherDisplayCardInfo();
    displayCardInfo.row = inputComposedAbilities.row;
    displayCardInfo.column = inputComposedAbilities.column;
    displayCardInfo.sceneSpanX = inputComposedAbilities.sceneSpanX;
    displayCardInfo.sceneSpanY = inputComposedAbilities.sceneSpanY;
    displayCardInfo.rowsTemplate = rowsTemplate;
    displayCardInfo.columnsTemplate = columnsTemplate;
    displayCardInfo.patternId = inputComposedAbilities.patternId;
    displayCardInfo.recItems = launcherRecItems.filter(Boolean) as LauncherRecItem[];
    displayCardInfo.headerHeight =
      (!inputComposedAbilities.headerHeight || Number.isNaN(inputComposedAbilities.headerHeight)) ? 28 :
      inputComposedAbilities.headerHeight;
    displayCardInfo.columnGap =
      (!inputComposedAbilities.columnGap || Number.isNaN(inputComposedAbilities.columnGap)) ? 8 :
      inputComposedAbilities.columnGap;
    displayCardInfo.rowGap = (!inputComposedAbilities.rowGap || Number.isNaN(inputComposedAbilities.rowGap)) ? 8 :
    inputComposedAbilities.rowGap;
    displayCardInfo.gridPadding =
      (!inputComposedAbilities.gridPadding || Number.isNaN(inputComposedAbilities.gridPadding)) ? 8 :
      inputComposedAbilities.gridPadding;
    log.showInfo(`convertDisplayData headerHeight:${displayCardInfo.headerHeight}, columnGap:${displayCardInfo.columnGap}, rowGap:${displayCardInfo.rowGap}, gridPadding:${displayCardInfo.gridPadding}`);
    return displayCardInfo;
  }

  private async convertRecItem(item: InputRecItem): Promise<LauncherRecItem | undefined> {
    const launcherRecItem: LauncherRecItem = ObjectCopyUtil.deepClone(item) as LauncherRecItem;
    if (item.itemType === AiSuggestionConstants.TYPE_APP) {
      return await this.convertAppItem(launcherRecItem);
    } else if (item.itemType === AiSuggestionConstants.TYPE_CARD) {
      return await this.convertFormItem(launcherRecItem);
    } else if (item.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
      return await this.convertAppGroupItem(launcherRecItem);
    } else if (item.itemType === AiSuggestionConstants.TYPE_RECOMMEND_CARD) {
      return launcherRecItem;
    } else {
      log.showWarn('convertRecItem unknown item type = %{public}d', item.itemType);
    }
    return undefined;
  }

  private async convertAppGroupItem(launcherRecItem: LauncherRecItem): Promise<LauncherRecItem> {
    const subInputItems = launcherRecItem.subRecItems;
    if (CheckEmptyUtils.isEmptyArr(subInputItems)) {
      log.showWarn('convertAppGroupItem subInputItems is empty');
      return launcherRecItem;
    }

    const subRecItems: Array<LauncherRecItem | undefined> = await Promise.all(
      subInputItems.map(
        async subInputItem => await this.convertAppItem(ObjectCopyUtil.deepClone(subInputItem) as LauncherRecItem)
      )
    );
    launcherRecItem.subLauncherRecItems = subRecItems.filter(Boolean) as LauncherRecItem[];
    return launcherRecItem;
  }

  private async convertFormItem(launcherRecItem: LauncherRecItem): Promise<LauncherRecItem> {
    let currentModuleFormsInfo =
      await FormManager.getInstance().getFormsInfo(launcherRecItem.bundleName, launcherRecItem.moduleName);
    if (!currentModuleFormsInfo || CheckEmptyUtils.isEmptyArr(currentModuleFormsInfo)) {
      log.showWarn('convertFormItem currentModuleFormsInfo is empty');
      return launcherRecItem;
    }
    const itemInfo: formInfo.FormInfo | undefined = currentModuleFormsInfo.find(
      formInfo => {
        return launcherRecItem.abilityName === formInfo.abilityName && launcherRecItem.formName === formInfo.name;
      }
    );

    // 补充isTransparent信息,该字段表示卡片是否支持透明
    launcherRecItem.isTransparent = itemInfo?.transparencyEnabled ?? false;
    return launcherRecItem;
  }

  private async convertAppItem(launcherRecItem: LauncherRecItem): Promise<LauncherRecItem | undefined> {
    if (!launcherRecItem) {
      return undefined;
    }
    const appItemInfo = AppModel.getInstance().getAppInfoByBundleName(launcherRecItem.bundleName);
    if (!appItemInfo) {
      log.showWarn(`convertAppItem appItemInfo is empty, bundleName=${launcherRecItem.bundleName}`);
      return undefined;
    }
    if (CheckEmptyUtils.isEmpty(appItemInfo)) {
      log.showWarn(`convertAppItem appItemInfo is empty, bundleName=${launcherRecItem.bundleName}`);
      return launcherRecItem;
    }

    if (!CheckEmptyUtils.checkStrIsEmpty(launcherRecItem.iconUrl)) {
      AiSuggestionResourceManager.getInstance().getResource(launcherRecItem.iconUrl);
    }
    let appIndex: number = 0;
    if (!CheckEmptyUtils.isEmpty(launcherRecItem.uid)) {
      try {
        let identity = await bundleManager.getAppCloneIdentity(launcherRecItem.uid);
        appIndex = identity?.appIndex;
      } catch (err) {
      }
    }

    launcherRecItem.appIconId = appItemInfo.appIconId;
    launcherRecItem.moduleName = appItemInfo.moduleName ?? '';
    launcherRecItem.abilityName = appItemInfo.abilityName;
    launcherRecItem.badgeNumber = appItemInfo.badgeNumber ?? 0;
    launcherRecItem.appIndex = appIndex;
    launcherRecItem.appName = appItemInfo.appName;
    launcherRecItem.keyName = `${appItemInfo.bundleName}${appItemInfo.abilityName}${appItemInfo.moduleName}${appIndex}`;
    return launcherRecItem;
  }

  private composeTemplate(num: number): string {
    return Array(num).fill('1fr').join(' ');
  }
}