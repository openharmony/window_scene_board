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
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { CommonConstants, DockItemInfo, GridLayoutItemInfo} from '@ohos/launchercommon';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { DesktopDataInfo } from './DesktopDataInfo';

const TAG = 'AbstractLayoutChangeChecker';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

export abstract class AbstractLayoutChangeChecker {
  private oldSuggestionCardIds: Map<number, string[]> = new Map();

  private newSuggestionCardIds: Map<number, string[]> = new Map();

  private oldFormstackIds: string[] = [];

  private newFormstackIds: string[] = [];

  constructor() {
  }

  /**
   * 布局是否发生变化
   *
   * @returns 发生变化返回true
   */
  public abstract isLayoutChange(screenIndex: number): boolean;

  protected abstract getDesktopDataInfo(): DesktopDataInfo | undefined;

  private updateDesktopSuggestionCardIds(suggestionCardIds: Map<number, string[]>, formStackIds: string[],
    appGridInfo: [GridLayoutItemInfo[]]): void {
    suggestionCardIds.clear();
    formStackIds.splice(0);
    for (let page = 0; page < appGridInfo.length; page++) {
      let itemInfos: GridLayoutItemInfo[] = appGridInfo[page];
      suggestionCardIds.set(page, this.getAllSuggestionCardIds(itemInfos));
      formStackIds.push(...this.getAllFormstackIdsWithSuggestionCards(itemInfos));
    }
  }

  /**
   * 查询所有包含语音助手建议卡片的堆叠组
   *
   * @returns 堆叠组ID
   */
  private getAllFormstackIdsWithSuggestionCards(itemInfos: GridLayoutItemInfo[]): string[] {
    let formStackIds: string[] = [];
    for (let i = 0; i < itemInfos.length; i++) {
      let info = itemInfos[i];
      if (info.typeId === CommonConstants.TYPE_FORM_STACK) {
        let formStackItemInfo = info;
        if (CheckEmptyUtils.isEmptyArr(formStackItemInfo.layoutInfo?.[0])) {
          continue;
        }
        const hasSuggestionCard = formStackItemInfo.layoutInfo?.[0]
          .some(itemInfo => AiSuggestionUtil.isVoiceAbilityForm(itemInfo.bundleName, itemInfo.abilityName));
        if (hasSuggestionCard && formStackItemInfo.formStackId) {
          formStackIds.push(formStackItemInfo.formStackId);
        }
      }
    }
    return formStackIds;
  }

  /**
   * 查询所有语音助手建议卡片
   *
   * @returns 语音助手建议卡片
   */
  private getAllSuggestionCardIds(itemInfos: GridLayoutItemInfo[]): string[] {
    let suggestionCardIds: string[] = [];
    for (let i = 0; i < itemInfos.length; i++) {
      let info = itemInfos[i];
      if (AiSuggestionUtil.isVoiceAbilityForm(info.bundleName, info.abilityName)) {
        if (info.cardId) {
          suggestionCardIds.push(info.cardId);
        }
      } else if (info.typeId === CommonConstants.TYPE_FORM_STACK) {
        let formStackItemInfo = info;
        if (CheckEmptyUtils.isEmptyArr(formStackItemInfo.layoutInfo?.[0])) {
          continue;
        }
        let itemList = formStackItemInfo.layoutInfo?.[0]
          .filter(itemInfo => AiSuggestionUtil.isVoiceAbilityForm(itemInfo.bundleName, itemInfo.abilityName));
        itemList?.forEach(item => {
          if (item.cardId) {
            suggestionCardIds.push(item.cardId);
          }
        });
      }
    }
    return suggestionCardIds;
  }

  private mergeVoiceLayoutNearPages(voiceLayoutPages: number[]): number[] {
    if (CheckEmptyUtils.isEmptyArr(voiceLayoutPages)) {
      return [];
    }
    const screenIndexSet: Set<number> = new Set<number>();
    for (let screenIndex of voiceLayoutPages) {
      const nearScreenIndex: number = screenIndex % 2 === 0 ? (screenIndex + 1) : (screenIndex - 1);
      screenIndexSet.add(screenIndex);
      screenIndexSet.add(nearScreenIndex);
    }
    return Array.from(screenIndexSet).sort();
  }

  /**
   * 判断item是否被删除
   *
   * @param oldItemInfoList 旧列表
   * @param newItemInfoList 新列表
   * @returns true 有item被移除
   */
  private isItemDelete(page: number, oldItemInfoList: GridLayoutItemInfo[],
    newItemInfoList: GridLayoutItemInfo[]): boolean {
    for (const oldInfo of oldItemInfoList) {
      if (oldInfo.typeId !== CommonConstants.TYPE_APP && oldInfo.typeId !== CommonConstants.TYPE_FOLDER &&
        oldInfo.typeId !== CommonConstants.TYPE_CARD && oldInfo.typeId !== CommonConstants.TYPE_FORM_STACK) {
        // 不是这几种类型不判断
        continue;
      }
      if (!this.isContain(oldInfo, newItemInfoList) && this.isNeedNotifyItemDelete(page, oldInfo)) {
        log.showInfo(`isItemDelete oldInfo page: ${page}, typeId: ${oldInfo.typeId}, bundleName: ${oldInfo.bundleName}`);
        // 旧数据在新列表中找不到，则说明界面发生变化，需要刷新
        return true;
      }
    }
    return false;
  }

  private isNeedNotifyItemDelete(page: number, oldInfo: GridLayoutItemInfo): boolean {
    if (oldInfo.typeId === CommonConstants.TYPE_CARD &&
      AiSuggestionUtil.isVoiceAbilityForm(oldInfo.bundleName, oldInfo.abilityName)) {
      // 被删除的语音助手建议卡片在新的列表中找不到
      return !this.newSuggestionCardIds.get(page)?.some(cardId => oldInfo.cardId === cardId);
    } else if (oldInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      return this.newFormstackIds.some(stackId => oldInfo.formStackId === stackId);
    } else {
      return true;
    }
  }

  private isContain(itemInfo: GridLayoutItemInfo, itemList: GridLayoutItemInfo[]): boolean {
    for (const item of itemList) {
      let isSameApp = itemInfo.typeId === CommonConstants.TYPE_APP && item.typeId === CommonConstants.TYPE_APP &&
        itemInfo.keyName === item.keyName;
      if (isSameApp) {
        return true;
      }
      let isSameFolder =
        itemInfo.typeId === CommonConstants.TYPE_FOLDER && item.typeId === CommonConstants.TYPE_FOLDER &&
          itemInfo.folderId === item.folderId && !this.isFolderSizeChange(itemInfo, item);
      if (isSameFolder) {
        return true;
      }
      let isSameFa = itemInfo.typeId === CommonConstants.TYPE_CARD && item.typeId === CommonConstants.TYPE_CARD &&
        itemInfo.cardId === item.cardId;
      if (isSameFa) {
        return true;
      }
      let isSameFormStack =
        itemInfo.typeId === CommonConstants.TYPE_FORM_STACK && item.typeId === CommonConstants.TYPE_FORM_STACK &&
          itemInfo.formStackId === item.formStackId &&
          this.getStackVoiceCardNumber(itemInfo) === this.getStackVoiceCardNumber(item);
      if (isSameFormStack) {
        return true;
      }
    }
    return false;
  }

  private getStackVoiceCardNumber(itemInfo: GridLayoutItemInfo): number {
    if (CheckEmptyUtils.isEmptyArr(itemInfo?.layoutInfo?.[0])) {
      log.showWarn(`getStackVoiceCardNumber data empty`);
      return 0;
    }
    let voiceCardNumber = itemInfo?.layoutInfo?.[0]
      .filter(itemInfo => AiSuggestionUtil.isVoiceAbilityForm(itemInfo.bundleName, itemInfo.abilityName)).length;
    return voiceCardNumber ?? 0;
  }

  private isNeedNotifyItemAdd(page: number, newInfo: GridLayoutItemInfo): boolean {
    if (newInfo.typeId === CommonConstants.TYPE_CARD &&
      AiSuggestionUtil.isVoiceAbilityForm(newInfo.bundleName, newInfo.abilityName)) {
      // 新增的语音助手建议卡片在旧的列表中找不到
      return !this.oldSuggestionCardIds.get(page)?.some(cardId => newInfo.cardId === cardId);
    } else if (newInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      return this.oldFormstackIds.some(stackId => newInfo.formStackId === stackId);
    } else {
      return true;
    }
  }

  public isResidentListChange(oldItemInfoList: DockItemInfo[], newItemInfoList: DockItemInfo[]): boolean {
    if (DeviceHelper.isPC() || DeviceHelper.isPad() || SCBSceneSessionManager.getInstance().isPcMode()) {
      log.showWarn('pc or pad not notify resident layout change');
      return false;
    }
    if (oldItemInfoList.length !== newItemInfoList.length) {
      // dock栏数量变化直接通告
      return true;
    }
    for (let i = 0; i < oldItemInfoList.length; i++) {
      let oldItem: DockItemInfo = oldItemInfoList[i];
      let newItem: DockItemInfo = newItemInfoList[i];
      if (!oldItem || !newItem) {
        continue;
      }
      if (oldItem.typeId !== CommonConstants.TYPE_APP || newItem.typeId !== CommonConstants.TYPE_APP) {
        continue;
      }
      if (newItem.keyName !== oldItem.keyName) {
        log.showInfo(`oldItem: ${oldItem.bundleName}, newItem: ${newItem.bundleName}`);
        return true;
      }
    }
    return false;
  }

  protected deepCloneItemInfoList(appGridInfo: [GridLayoutItemInfo[]]): [GridLayoutItemInfo[]] {
    let tempGridLayoutList: [GridLayoutItemInfo[]] = [[]];
    for (let i = 0; i < appGridInfo.length; i++) {
      let tempGridLayout: GridLayoutItemInfo[] = [];
      appGridInfo[i].forEach(view => {
        tempGridLayout.push(ObjectCopyUtil.deepClone(view));
      });
      tempGridLayoutList[i] = tempGridLayout;
    }
    return tempGridLayoutList;
  }

  protected deepCloneResidentList(dockItemList: DockItemInfo[]): DockItemInfo[] {
    let tempDockItem: DockItemInfo[] = [];
    dockItemList.forEach((view) => {
      tempDockItem.push(ObjectCopyUtil.deepClone(view));
    });
    return tempDockItem;
  }

  private isFolderSizeChange(newFolder: GridLayoutItemInfo, oldFolder: GridLayoutItemInfo): boolean {
    if (newFolder.area?.length !== 2 || newFolder.area.length !== oldFolder.area?.length) {
      return true;
    }
    return newFolder.area[0] !== oldFolder.area[0] || newFolder.area[1] !== oldFolder.area[1];
  }

  /**
   * 是否正在拖拽堆叠卡片到桌面
   *
   * @returns 正在拖拽堆叠卡片到桌面返回true
   */
  public isDrag(): boolean {
    let isDrag: boolean | undefined = AppStorage.get<boolean>('isDrag');
    let dragItemType: number | undefined = AppStorage.get<number>('dragItemType');
    // 拖拽堆叠中场景卡到桌面时桌面布局会变化，此时不通知服务侧
    if (isDrag === true && dragItemType === CommonConstants.DRAG_FROM_FORM_STACK) {
      log.showWarn('receive layout change event, discard it due to being in drag');
      return true;
    }
    return false;
  }
}