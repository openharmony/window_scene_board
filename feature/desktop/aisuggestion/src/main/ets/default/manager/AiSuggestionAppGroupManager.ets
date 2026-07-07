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

import ArrayList from '@ohos.util.ArrayList';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';

const TAG = 'AiSuggestionAppGroupManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * AppGroup call back
 */
export interface AiSuggestionAppGroupCallback {
  onUpdate: (cardInfo: LauncherRecItem) => void;
}

/**
 * 语音助手建议应用组数据管理类
 *
 * @since 2025-03-17
 */
export class AiSuggestionAppGroupManager {
  private static instance: AiSuggestionAppGroupManager;
  /**
   * AppGroup callbacks for AiSuggestionAppGroup. key:cardId_rowStart_columnStart
   */
  private appGroupCallbackMap: Map<string, ArrayList<AiSuggestionAppGroupCallback>> = new Map();
  /**
   * AppGroup callbacks for AiSuggestionAppGroup. key:cardId_rowStart_columnStart
   */
  private recItemMap: Map<string, LauncherRecItem> = new Map();

  private constructor() {
  }

  /**
   * get AiSuggestionAppGroupManager instance
   *
   * @return AiSuggestionAppGroupManager instance
   */
  static getInstance(): AiSuggestionAppGroupManager {
    if (AiSuggestionAppGroupManager.instance == null) {
      AiSuggestionAppGroupManager.instance = new AiSuggestionAppGroupManager();
    }
    return AiSuggestionAppGroupManager.instance;
  }

  /**
   * register callback for appGroup data
   *
   * @param groupKey groupKey
   * @param callback appGroup callback
   */
  public registerCallback(groupKey: string, callback: AiSuggestionAppGroupCallback): void {
    if (AbilityFormUtil.isCardIdInvalid(groupKey)) {
      log.showWarn('registerCallback: invalid groupKey: %{public}s', groupKey);
      return;
    }
    let callbacks = this.appGroupCallbackMap.get(groupKey) ?? new ArrayList<AiSuggestionAppGroupCallback>();
    callbacks.add(callback);
    this.appGroupCallbackMap.set(groupKey, callbacks);
    log.showWarn(`registerCallback: ${groupKey}, size: ${callbacks.length}`);
  }

  /**
   * unregister callback by appGroup id
   *
   * @param groupKey card id
   * @param callback appGroup callback
   */
  public unRegisterCallback(groupKey: string, callback: AiSuggestionAppGroupCallback): void {
    log.showWarn('unRegisterCallback: %{public}s', groupKey);
    let callbacks = this.getCardInteraction(groupKey);
    callbacks?.remove(callback);
  }

  private getCardInteraction(groupKey: string): ArrayList<AiSuggestionAppGroupCallback> {
    const cardInteraction = this.appGroupCallbackMap.get(groupKey);
    if (!cardInteraction) {
      log.showWarn('getCardInteraction: %{public}s can not find interface, key exists? %{public}s',
        groupKey, this.appGroupCallbackMap.has(groupKey));
    }
    return cardInteraction ?? new ArrayList();
  }

  public setRecItem(groupKey: string, recItem: LauncherRecItem): void {
    this.recItemMap.set(groupKey, recItem);
  }

  public updateSubItems(formItem: GridLayoutItemInfo | undefined, recItem: LauncherRecItem): void {
    if (!formItem) {
      log.showError('updateSubItems fail, invalid formItem');
      return;
    }
    const groupKey: string = `${formItem.cardId}_${recItem.rowStart}_${recItem.columnStart}`;
    const callBacks = this.getCardInteraction(groupKey);
    if (!callBacks || callBacks.length === 0) {
      log.showInfo('updateSubItems callBacks not exist');
      return;
    }
    const oldRecItem = this.recItemMap.get(groupKey);
    if (!oldRecItem || !recItem) {
      log.showInfo('updateSubItems oldRecItem or recItem not exist');
      return;
    }
    if (this.isDiff(formItem, oldRecItem, recItem)) {
      callBacks.forEach(callBack => {
        callBack.onUpdate(recItem);
      });
    }
  }

  private isDiff(formItem: GridLayoutItemInfo, oldRecItem: LauncherRecItem, recItem: LauncherRecItem): boolean {
    const oldGroupKey = LauncherRecItem.getSubItemUniqueKey(formItem, oldRecItem);
    const newGroupKey = LauncherRecItem.getSubItemUniqueKey(formItem, recItem);
    log.showInfo(`isDiff oldGroupKey: ${oldGroupKey}}, newGroupKey: ${newGroupKey}`);
    return oldGroupKey !== newGroupKey;
  }
}