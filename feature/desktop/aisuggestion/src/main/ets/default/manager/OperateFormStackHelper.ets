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
import type { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import type { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { CommandConsumer } from '../command/CommandConsumer';
import type { OperateFormStackDetails } from '../command/OperateFormStackDetails';

const TAG = 'OperateFormStackHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 操作堆叠帮助类
 *
 * @since 2023-08-11
 */
export class OperateFormStackHelper {
  private static instance: OperateFormStackHelper;

  /**
   * get CreateFormStackHelper instance
   *
   * @return CreateFormStackHelper instance
   */
  static getInstance(): OperateFormStackHelper {
    if (OperateFormStackHelper.instance == null) {
      OperateFormStackHelper.instance = new OperateFormStackHelper();
    }
    return OperateFormStackHelper.instance;
  }

  /**
   * 场景卡的缓存数据. key:cardId
   */
  private portfolioCardInfoCacheMap: Map<string, LauncherCardInfo> = new Map();
  /**
   * 创建堆叠 key:cardId 操作堆叠 key:stackId
   */
  private formStackLengthMap: Map<string, OperateFormStackDetails> = new Map();

  /**
   * 获取场景卡的信息
   *
   * @param cardId cardId
   * @return card info
   */
  getCachePortfolioCardInfo(cardId: string): LauncherCardInfo | undefined {
    if (!this.portfolioCardInfoCacheMap.has(cardId)) {
      log.showError('getCachePortfolioCardInfo cardId:%{public}s not exist', cardId);
      return undefined;
    }
    log.showInfo('getCachePortfolioCardInfo cardId:%{public}s', cardId);
    let cardInfo = this.portfolioCardInfoCacheMap.get(cardId);

    // 使用后删除，清空缓存
    this.portfolioCardInfoCacheMap.delete(cardId);
    return cardInfo;
  }

  /**
   * 设置场景卡的信息
   *
   * @param cardId cardId
   */
  setCachePortfolioCardInfo(cardId: string, launcherCardInfo: LauncherCardInfo): void {
    log.showInfo('setCachePortfolioCardInfo cardId:%{public}s', cardId);
    this.portfolioCardInfoCacheMap.set(cardId, launcherCardInfo);
  }

  /**
   * 设置堆叠组的大小
   *
   * @param keyId 使用commandId_commandType作为keyId
   */
  setFormStackLength(keyId: string, details: OperateFormStackDetails): void {
    this.formStackLengthMap.set(keyId, details);
  }

  onPortfolioCardAddToFormStack(extraData: ExtraData): void {
    let commandId = extraData?.commandId;
    let keyId = `${commandId}_${extraData.commandType}`;
    if (!commandId || !this.formStackLengthMap.has(keyId)) {
      log.showError('commandId: %{public}s,type: %{public}d finish error', commandId, extraData.commandType);
      CommandConsumer.getInstance().finishCommand(commandId, extraData.commandType);
      return;
    }
    log.showInfo('onPortfolioCardAddToFormStack commandId: %{public}s', commandId);

    let details = this.formStackLengthMap.get(keyId);
    if (details) {
      details.addSize--;
      if (details.addSize === 0) {
        CommandConsumer.getInstance().finishCommand(commandId, extraData.commandType);
      }
    }
  }
}