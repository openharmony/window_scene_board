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
import { CommonConstants, RdbStoreManager } from '@ohos/launchercommon';
import { AiSuggestDataManager } from '@ohos/launchercommon/src/main/ets/manager/AiSuggestDataManager';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import { JsonHelper } from '../utils/JsonHelper';

const TAG = 'AiSuggestionRdbHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * AiSuggestionRdbHelper
 *
 * @since 2025-06-11
 */
export class AiSuggestionRdbHelper {
  /**
   * 某张卡片插入数据库的重试次数 key:cardId
   */
  private static reUpdateTimerMap: Map<string, number> = new Map();

  /**
   * 从数据库中获取所有的语音助手建议卡片ID
   *
   * @returns 语音助手建议卡片ID列表
   */
  public static async getAllInnerCardIdFromRdb(): Promise<string[]> {
    let cardIdList: string[] = [];
    try {
      let voiceCardInfoList: Record<string, string>[] = await RdbStoreManager.getInstance().queryAllVoiceCardInfo();
      log.showInfo('getAllInnerCardIdFromRdb , voiceCardInfoList: %{public}s',
        voiceCardInfoList.map(item => item.cardId).toString());
      voiceCardInfoList.forEach((voiceCardInfo) => {
        cardIdList.push(voiceCardInfo.cardId);
        let cardInfo: LauncherCardInfo = JSON.parse(voiceCardInfo.strData);
        cardInfo?.portrait?.recItems?.forEach((item) => {
          if (item && item.itemType === CommonConstants.TYPE_CARD && item.cardId) {
            cardIdList.push(item.cardId);
          }
        });
        cardInfo?.landscapeOrExpand?.recItems?.forEach((item) => {
          if (item && item.itemType === CommonConstants.TYPE_CARD && item.cardId) {
            cardIdList.push(item.cardId);
          }
        });
      });
    } catch (err) {
      log.error('getAllInnerCardIdFromRdb failed, ', err);
    }
    return Array.from(new Set(cardIdList));
  }

  /**
   * 更新RDB中的语音助手建议内容，如果出现更新失败的情况，起定时器重新写入
   *
   * @param outerCardId 语音助手建议的卡片ID
   * @param retryTimes 失败重试次数
   */
  public static async updateAiSuggestionCardRdbInfo(outerCardId: string | undefined,
    retryTimes: number = 3): Promise<void> {
    log.showInfo('updateAiSuggestionCardInfo %{public}s %{public}d', outerCardId, retryTimes);
    if (!outerCardId || retryTimes <= 0) {
      return;
    }
    if (!outerCardId) {
      log.showError('updateAiSuggestionCardRdbInfo invalid cardId');
      return;
    }
    let launcherCardInfo: LauncherCardInfo | undefined = AiSuggestionFormManager.getInstance().getCardInfo(outerCardId);
    let result = await RdbStoreManager.getInstance().updateVoiceCardInfoMap(outerCardId,
      JSON.stringify(launcherCardInfo, JsonHelper.dbReplacer));
    AiSuggestDataManager.getInstance().updateAiSuggestData(outerCardId);
    if (!result) {
      if (!AiSuggestionRdbHelper.reUpdateTimerMap.get(outerCardId)) {
        let tempTimer = setTimeout(() => {
          AiSuggestionRdbHelper.updateAiSuggestionCardRdbInfo(outerCardId, --retryTimes);
        }, AiSuggestionConstants.AI_SUGGESTION_REWRITE_TIME);
        AiSuggestionRdbHelper.reUpdateTimerMap.set(outerCardId, tempTimer);
        log.showInfo('create timer %{public}s', outerCardId);
      } else {
        clearTimeout(AiSuggestionRdbHelper.reUpdateTimerMap.get(outerCardId));
        let tempTimer = setTimeout(() => {
          AiSuggestionRdbHelper.updateAiSuggestionCardRdbInfo(outerCardId, --retryTimes);
        }, AiSuggestionConstants.AI_SUGGESTION_REWRITE_TIME);
        AiSuggestionRdbHelper.reUpdateTimerMap.set(outerCardId, tempTimer);
        log.showInfo('reCreate timer %{public}s', outerCardId);
      }
    } else {
      const timerId = AiSuggestionRdbHelper.reUpdateTimerMap.get(outerCardId);
      log.showInfo('updateAiSuggestionCardInfo ok: %{public}s, timer: %{public}d', outerCardId, timerId);
      if (timerId) {
        clearTimeout(timerId);
        AiSuggestionRdbHelper.reUpdateTimerMap.delete(outerCardId);
      }
    }
  }
}