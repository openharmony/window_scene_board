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

import formHost from '@ohos.app.form.formHost';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { CommonConstants } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AiSuggestionFormManager } from './AiSuggestionFormManager';
import { CommandConsumer } from '../command/CommandConsumer';

const TAG = 'AiSuggestionFormRecycleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

const RECOVER_DELAY: number = 2 * 1000;

class RecycleCard {
  public recycleTime: number = 0;
  public cardId: string = '';

  constructor(recycleTime: number, cardId: string) {
    this.recycleTime = recycleTime;
    this.cardId = cardId;
  }
}

/**
 * 语音助手建议子片回收管理类
 *
 * @since 2025-03-08
 */
export class AiSuggestionFormRecycleManager {
  private static instance: AiSuggestionFormRecycleManager;
  private recycleMap: Map<string, RecycleCard[]> = new Map();

  /**
   * get AiSuggestionFormManager instance
   *
   * @return AiSuggestionFormManager instance
   */
  public static getInstance(): AiSuggestionFormRecycleManager {
    if (AiSuggestionFormRecycleManager.instance == null) {
      AiSuggestionFormRecycleManager.instance = new AiSuggestionFormRecycleManager();
    }
    return AiSuggestionFormRecycleManager.instance;
  }

  /**
   * 通知语音助手建议回收恢复子卡
   *
   * @param state true 回收 false 恢复
   * @param cardId 卡片ID
   */
  public onRecycleStateChange(state: boolean, cardId: string | undefined): void {
    if (!cardId) {
      log.showError('onRecycleStateChange invalid cardId');
      return;
    }
    if (state) {
      const cardInfo = AiSuggestionFormManager.getInstance().getCardInfo(cardId);
      const displayCardInfo = LauncherCardInfo.getDisplayCardInfo(cardInfo);
      const ids = displayCardInfo?.recItems?.filter(recItem => {
        return recItem.itemType === CommonConstants.TYPE_CARD && recItem.cardId;
      }).map(recItem => recItem.cardId).map(cardId => new RecycleCard(0, cardId));

      this.startRecycle(cardId, ids ?? []);
    } else {
      if (this.recycleMap.has(cardId)) {
        let ids: RecycleCard[] = [];
        const cardInfo = AiSuggestionFormManager.getInstance().getCardInfo(cardId);
        if (cardInfo) {
          ids = this.recycleMap.get(cardId) ?? [];
          this.startRecover(cardId, ids);
        } else {
          this.recycleMap.delete(cardId);
          log.showError(`onRecycleStateChange cardId: ${cardId}, cardInfo not exist`);
        }
      }
    }
  }

  private startRecycle(parentCardId: string, recycleCards: RecycleCard[]): void {
    if (CheckEmptyUtils.isEmptyArr(recycleCards)) {
      return;
    }
    const recycleList = recycleCards.map(recycleCard => recycleCard.cardId);
    try {
      formHost.recycleForms(recycleList).then(() => {
        this.recycleMap.set(parentCardId, recycleCards);
        this.insertListToCurrentRecycleList(recycleCards);
        log.showError(`startRecycle recycleForms success, parentCardId: ${parentCardId}, recycleList: ${recycleList.toString()}`);
      }).catch((error: Error) => {
        log.error(`startRecycle recycleForms onError parentCardId: ${parentCardId}, error msg: ${error}`);
      });
    } catch (error) {
      log.error('startRecycle fail, catch err:', error);
    }
  }

  private insertListToCurrentRecycleList(recycleCards: RecycleCard[]): void {
    let dateNow: number = Date.now();
    recycleCards.forEach(recycleCard => recycleCard.recycleTime = dateNow);
  }

  private startRecover(parentCardId: string, recycleCards: RecycleCard[]): void {
    if (CheckEmptyUtils.isEmptyArr(recycleCards)) {
      log.showInfo(`startRecover parentCardId:${parentCardId}, no card to recover`);
      return;
    }
    const formList = recycleCards.map(recycleCard => recycleCard.cardId);

    log.showInfo(`startRecover parentCardId:${parentCardId}, formList:${formList.toString()}`);

    // 回收时间不足2s的，延迟2s恢复，其他的即时恢复
    const list: string[][] = this.getRecoverList(recycleCards);
    const currentRecoverList: string[] = list[0];
    const delayRecoverList: string[] = list[1];
    this.recoverStateHandler(parentCardId, currentRecoverList);

    if (!CheckEmptyUtils.isEmptyArr(delayRecoverList)) {
      setTimeout((delayRecoverList: string[]) => {
        log.showInfo('startRecover time up to recover delay2s forms');
        this.recoverStateHandler(parentCardId, delayRecoverList);
      }, RECOVER_DELAY, delayRecoverList);
    }
  }

  private getRecoverList(recycleCards: RecycleCard[]): string[][] {
    let currentRecoverList: string[] = [];
    let delayRecoverList: string[] = [];
    let timeNow: number = Date.now();
    recycleCards.forEach(recycleCard => {
      let timeDiff: number = timeNow - recycleCard.recycleTime;
      if (timeDiff < RECOVER_DELAY) {
        delayRecoverList.push(recycleCard.cardId);
      } else {
        currentRecoverList.push(recycleCard.cardId);
      }
    });
    return [currentRecoverList, delayRecoverList];
  }

  private recoverStateHandler(parentCardId: string, recoverList: string[]): void {
    log.showInfo(`recoverStateHandler parentCardId:${parentCardId}, recoverList:${recoverList.toString()}`);
    if (CheckEmptyUtils.isEmptyArr(recoverList)) {
      return;
    }
    this.recycleMap.delete(parentCardId);

    // 卡片回收成功后触发刷新命令执行
    CommandConsumer.getInstance().debounceExecuteCommands();
    try {
      formHost.recoverForms(recoverList).then(() => {
        log.showError(`recoverStateHandler recoverForms success, parentCardId:${parentCardId}, recoverList: ${recoverList.toString()}`);
      }).catch((error: Error) => {
        log.error(`recoverStateHandler recoverForms parentCardId: ${parentCardId}, recoverList: ${recoverList.toString()}, error msg: ${error}`);
      });
    } catch (error) {
      log.error('recoverStateHandler fail, catch err:', error);
    }
  }
}