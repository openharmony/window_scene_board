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
import {
  AppItemInfo,
  AppModel,
  CardItemInfo,
  CommonConstants,
  EventConstants,
  FormLayoutCacheManager,
  FormModel,
  GridLayoutItemInfo,
} from '@ohos/launchercommon';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { SCBTransitionController, SCBTransitionManager } from '@ohos/windowscene';
import { FormStackEventInfo } from '../bean/FormStackEventInfo';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import AiSuggestionActionManager from '../manager/AiSuggestionActionManager';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { AiSuggestionDataHelper } from './AiSuggestionDataHelper';
import { AiSuggestionRdbHelper } from './AiSuggestionRdbHelper';

const TAG = 'AiSuggestionDataProcess';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * AiSuggestionDataProcess
 *
 * @since 2025-06-11
 */
export class AiSuggestionDataProcess {
  /**
   * 收到堆叠的通知
   *
   * @param eventInfo 堆叠的信息
   */
  public static onFormStackNotify(eventInfo: FormStackEventInfo): void {
    if (CheckEmptyUtils.isEmpty(eventInfo)) {
      log.showWarn('onFormStackNotify invalid eventInfo');
      return;
    }
    if (eventInfo.actionName === EventConstants.EVENT_FORM_STACK_SLIDE_CARD) {
      AiSuggestionDataProcess.reportFormStackSlideCardIfNeed(eventInfo);
      return;
    }
    if (CheckEmptyUtils.isEmpty(eventInfo.actionName) || CheckEmptyUtils.isEmpty(eventInfo.cardItemInfo) ||
    CheckEmptyUtils.isEmptyArr(eventInfo.cardItemInfoArr)) {
      log.showWarn('onFormStackNotify eventInfo detail invalid');
      return;
    }
    if (!AiSuggestionUtil.isVoiceAbilityForm(eventInfo.cardItemInfo?.bundleName ?? '',
      eventInfo.cardItemInfo?.abilityName ?? '')) {
      log.showInfo('onFormStackNotify not voice card');
      return;
    }
    log.showInfo('onFormStackNotify eventName: %{public}s, stackId: %{public}s', eventInfo.actionName,
      eventInfo.stackId);
    switch (eventInfo.actionName) {
      case EventConstants.EVENT_FORM_STACK_ITEM_DRAG_LEAVE:
        AiSuggestionDataProcess.onEventhubSetVoiceCardType(false, eventInfo.cardItemInfo, eventInfo.cardItemInfoArr);
        break;
      case EventConstants.EVENT_FORM_STACK_LEFT_SLIDE_DELETE:
      case EventConstants.EVENT_FORM_STACK_CLICK_DELETE:
        // 先刷新cardInfo的cardType
        AiSuggestionDataProcess.onEventhubSetVoiceCardType(true, eventInfo.cardItemInfo, eventInfo.cardItemInfoArr);

        // 再通知语音助手建议
        AiSuggestionActionManager.getInstance()
          .removeForm(eventInfo.cardItemInfo as object as GridLayoutItemInfo, true);

        // 释放本地卡片缓存及占用的卡片框架卡片资源
        AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(eventInfo.cardItemInfo?.cardId);
        break;
      default:
        break;
    }
  }

  private static reportFormStackSlideCardIfNeed(eventInfo: FormStackEventInfo): void {
    const gridlayoutInfo = FormLayoutCacheManager.getInstance().selectGridLayoutItemById(eventInfo.stackId);
    if (gridlayoutInfo && !AbilityFormUtil.isFormStackContainVoiceCard(gridlayoutInfo)) {
      // 只上报包含有语音助手建议的堆叠组卡片切换事件
      return;
    }
    AiSuggestionActionManager.getInstance().switchFormStack(eventInfo);
  }

  /**
   * 修改cardType
   *
   * @param isDelete 是否删除了卡片
   * @param cardItemInfo 卡片信息
   * @param itemList 卡片列表
   */
  public static onEventhubSetVoiceCardType(isDelete: boolean, cardItemInfo: CardItemInfo | undefined,
    itemList: CardItemInfo[]): void {
    if (!cardItemInfo || CheckEmptyUtils.isEmptyArr(itemList)) {
      return;
    }
    let dragExtraData = ExtraData.getExtendData(cardItemInfo as object as GridLayoutItemInfo);
    let cardType = dragExtraData ? dragExtraData.cardType : AiSuggestionUpdateConstants.CardType.DEFAULT;
    if (cardType === AiSuggestionUpdateConstants.CardType.TEMP && !isDelete) {
      AiSuggestionDataProcess.updateVoiceCardType(AiSuggestionUpdateConstants.CardType.DEFAULT, cardItemInfo);
      // 更新extend1之后需要更新dragItemInfo,否则落位后无法同步更新这个修改到卡片布局缓存中
      let dragItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo');
      if (dragItemInfo && dragItemInfo.cardId === cardItemInfo.cardId) {
        log.showWarn(`onEventhubSetVoiceCardType refresh dragItemInfo extend1, cardId=${cardItemInfo.cardId}`);
        dragItemInfo.extend1 = cardItemInfo.extend1;
        AppStorage.set<GridLayoutItemInfo>('dragItemInfo', dragItemInfo);
      }
    } else if (cardType === AiSuggestionUpdateConstants.CardType.DEFAULT &&
      (!dragExtraData || !dragExtraData.portfolioId || dragExtraData.portfolioId === 'default')) {
      // 主卡被移出堆叠或者主卡被移除，将其他卡片设置成独立场景卡
      AiSuggestionDataProcess.changeCardsCardType(cardItemInfo, itemList);
    } else {
      log.showWarn('onEventhubSetVoiceCardType do nothing, cardId=%{public}s isDelete=%{public}s extend1=%{public}s',
        cardItemInfo.cardId, isDelete, cardItemInfo.extend1);
    }
  }

  private static changeCardsCardType(cardItemInfo: CardItemInfo, itemInfoArr: CardItemInfo[]): void {
    // 找到所有的语音助手建议卡片
    const itemList = itemInfoArr.filter(item => cardItemInfo.cardId !== item.cardId &&
    AiSuggestionUtil.isVoiceAbilityForm(item.bundleName, item.abilityName));

    // 判断堆叠里有没有主卡
    const hasMainCard =
      itemList.some(item => AiSuggestionDataProcess.isMainCard(item));
    log.showInfo(`changeCardsCardType hasMainCard: ${hasMainCard}`);
    if (!hasMainCard && itemList.length > 0) {
      // 堆叠里没有主卡，将场景卡更新成独立场景卡
      itemList.filter(item => AiSuggestionDataProcess.isPortfolioCard(item))
        .forEach(item => {
          AiSuggestionDataProcess.updateVoiceCardType(AiSuggestionUpdateConstants.CardType.DEFAULT, item);
        });
    }
  }

  private static async updateVoiceCardType(cardType: number, cardItemInfo: CardItemInfo): Promise<void> {
    ExtraData.updateVoiceCardType(cardType, cardItemInfo);
    log.showWarn('updateVoiceCardType cardId=%{public}s extend1=%{public}s',
      cardItemInfo.cardId, cardItemInfo.extend1);
    FormModel.getInstance().updateExtend1ByCardId(cardItemInfo.extend1, cardItemInfo.cardId);
  }

  private static isMainCard(item: CardItemInfo): boolean {
    return PortfolioInfo.isMainCard(ExtraData.getExtendData(item as object as GridLayoutItemInfo)?.portfolioId ?? '');
  }

  private static isPortfolioCard(item: CardItemInfo): boolean {
    return PortfolioInfo.isPortfolioCard(ExtraData.getPortfolioId(item as object as GridLayoutItemInfo));
  }

  private static updateVoiceRecItem(rectItems: LauncherRecItem[], bundleName: string,
    newAppInfo: AppItemInfo | undefined): number {
    if (!rectItems || rectItems.length <= 0) {
      return 0;
    }
    let index = rectItems.findIndex((item) =>
    item.itemType === CommonConstants.TYPE_APP && item.bundleName === bundleName);
    if (index === -1) {
      return 0;
    }
    let recItemInfo = rectItems[index];
    log.showInfo(`old appIconId: ${recItemInfo.appIconId}, new appIconId: ${newAppInfo?.appIconId}`);
    recItemInfo.appIconId = newAppInfo?.appIconId ?? 0;
    recItemInfo.badgeNumber = newAppInfo?.badgeNumber ?? 0;
    return 1;
  }

  private static updateAllVoice(bundleName: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('updateAllVoice bundleName is empty!');
      return;
    }
    let appInfo = AppModel.getInstance().getAppInfoByBundleName(bundleName);
    if (!appInfo) {
      log.showWarn(`updateAllVoice cannot get app info, bundleName=${bundleName}`);
      return;
    }
    let voiceCardList: GridLayoutItemInfo[] = AbilityFormUtil.getAllAiSuggestionItems();
    log.showInfo(`suggestion items length: ${voiceCardList.length}`);
    voiceCardList.forEach((item: GridLayoutItemInfo) => {
      let cardInfo: LauncherCardInfo | undefined = AiSuggestionFormManager.getInstance().getCardInfo(item.cardId);
      if (!cardInfo) {
        log.showWarn(`not found card info, cardId=${item.cardId}`);
        return;
      }
      let updatedNum: number =
        AiSuggestionDataProcess.updateVoiceRecItem(cardInfo.portrait?.recItems ?? [], bundleName, appInfo);
      updatedNum += AiSuggestionDataProcess.updateVoiceRecItem(cardInfo.landscapeOrExpand?.recItems ?? [], bundleName,
        appInfo);
      if (updatedNum > 0) {
        AiSuggestionFormManager.getInstance().refreshCardInfo(item.cardId);
        AiSuggestionRdbHelper.updateAiSuggestionCardRdbInfo(item.cardId);
      }
    });
  }

  /**
   * 处理更新图标事件
   *
   * @param event 事件名称
   * @param params 应用包名
   */
  public static processEvent(event: string, params: string): void {
    log.showInfo(`receive event: ${event}, params: ${params}`);
    if (event === EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE) {
      AiSuggestionDataProcess.updateAllVoice(params);
    }
  }

  /**
   * 删除动效控制器列表中无效的卡片
   *
   * @param item 推荐的卡片信息
   * @param recItems 推荐的内容
   * @param cardId 母卡ID
   * @param recCardTransitionControllerMap 动效控制器
   * @returns 被删除的卡片ID
   */
  public static releaseCardItemIfNeed(item: LauncherRecItem, recItems: LauncherRecItem[], cardId: string | undefined,
    recCardTransitionControllerMap: Map<String, SCBTransitionController>): string {
    if (!item || item.itemType === CommonConstants.TYPE_APP || !item.cardId) {
      return '';
    }
    if (item.cardId === cardId) {
      log.showInfo(`not need release parent card ${item.cardId}`);
      return '';
    }

    const inRecItem = recItems?.find(recItem => recItem.cardId === item.cardId);
    if (inRecItem && !AbilityFormUtil.isDefaultCard(inRecItem)) {
      log.showInfo(`not need release transition manager, card ${item.cardId}`);
      return '';
    }
    log.showInfo(`release transition manager %{public}s  %{public}s, parent card %{public}s, map size=%{public}d`,
      item.cardId, item.bundleName, cardId, recCardTransitionControllerMap.size);
    const formItemId = AiSuggestionDataHelper.getFormId(item);
    const transitionController = recCardTransitionControllerMap.get(formItemId);
    if (transitionController) {
      SCBTransitionManager.getInstance().unRegisterTransitionController(transitionController);
      recCardTransitionControllerMap.delete(formItemId);
    }
    return formItemId;
  }

  /**
   * 根据旧的推荐列表和新的推荐列表获取要刷新的recItemId集合和最晚消失的服务索引
   *
   * @param oldRecItems 旧的推荐列表
   * @param newRecItems 新的推荐列表
   * @returns 改变的数据集
   */
  public static updateChangedItemRecord(oldRecItems: LauncherRecItem[], newRecItems: LauncherRecItem[]):
    Record<string, Set<string> | number> {
    let newItemIdSet = new Set<string>();
    if (CheckEmptyUtils.isEmptyArr(oldRecItems) || CheckEmptyUtils.isEmptyArr(newRecItems)) {
      log.showWarn('updateChangedItemRecord oldRecItems or newRecItems isEmptyArr');
      const diffOptions: Record<string, Set<string> | number> = {};
      diffOptions['diffIdSet'] = newItemIdSet;
      diffOptions['disappearLastIndex'] = 0;
      return diffOptions;
    }
    let oldItemIdSet = new Set<string>();
    oldRecItems.sort((a: LauncherRecItem, b: LauncherRecItem) => {
      return (a.rowStart - b.rowStart);
    }).forEach((recItem, index) => {
      if (recItem.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        recItem.subLauncherRecItems.forEach((subItem) => {
          oldItemIdSet.add(LauncherRecItem.getUniqueId(subItem));
        });
      } else {
        oldItemIdSet.add(LauncherRecItem.getUniqueId(recItem));
      }
    });

    newRecItems.sort((a: LauncherRecItem, b: LauncherRecItem) => {
      return (a.rowStart - b.rowStart);
    }).forEach((recItem, index) => {
      if (recItem.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        recItem.subLauncherRecItems?.forEach((subItem) => {
          newItemIdSet.add(LauncherRecItem.getUniqueId(subItem));
        });
      } else {
        newItemIdSet.add(LauncherRecItem.getUniqueId(recItem));
      }
    });

    let disappearLastIndex = 0;
    let startIndex = 0;
    oldItemIdSet.forEach((item) => {
      if (newItemIdSet.has(item)) {
        newItemIdSet.delete(item);
      } else {
        disappearLastIndex = Math.max(startIndex, disappearLastIndex);
      }
      startIndex++;
    });
    const diffOptions: Record<string, Set<string> | number> = {};
    diffOptions['diffIdSet'] = newItemIdSet;
    diffOptions['disappearLastIndex'] = disappearLastIndex;
    return diffOptions;
  }
}