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

import type Want from '@ohos.app.ability.Want';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BundleConstants, CardItemInfo, GridLayoutItemInfo } from '../TsIndex';

const TAG: string = 'ExtraData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 创建堆叠时的额外数据
 *
 * @since 2024-02-22
 */
export class ExtraData {
  public commandId: string = ''

  public commandType: number = 0;

  public operateFormId: number = 0;

  public portfolioId: string = ''

  public cardUniqueTag: string = ''

  public cardType: number = 0;

  /**
   * 获取额外数据
   *
   * @param formItem
   * @returns 额外数据
   */
  public static getExtendData(formItem: GridLayoutItemInfo): ExtraData | undefined {
    if (CheckEmptyUtils.isEmpty(formItem)) {
      return undefined;
    }

    if (formItem.extend1) {
      return ExtraData.getExtend1(formItem.extend1);
    }
    return undefined;
  }

  /**
   * 获取额外extend1数据
   *
   * @param extend1
   * @returns 额外数据
   */
  public static getExtend1(extend1: string): ExtraData | undefined {
    if (CheckEmptyUtils.checkStrIsEmpty(extend1)) {
      return undefined;
    }
    let want: Want | undefined = ExtraData.parseJsonString(extend1);
    if (!want?.parameters?.data) {
      return undefined;
    }
    return want.parameters.data as object as ExtraData;
  }

  /**
   * 获取命令ID
   *
   * @param formItem
   * @returns 命令ID
   */
  public static getCommandId(formItem: GridLayoutItemInfo): string {
    if (CheckEmptyUtils.isEmpty(formItem)) {
      return '';
    }

    return ExtraData.getExtendData(formItem)?.commandId ?? '';
  }


  /**
   * 获取场景卡ID
   *
   * @param formItem
   * @returns 场景卡ID
   */
  public static getPortfolioId(formItem: GridLayoutItemInfo): string {
    if (CheckEmptyUtils.isEmpty(formItem)) {
      return 'default';
    }
    return ExtraData.getExtendData(formItem)?.portfolioId ?? 'default';
  }

  /**
   * 获取卡片TAG
   *
   * @param formItem
   * @returns TAG
   */
  public static getCardUniqueTag(formItem: GridLayoutItemInfo): string | undefined {
    if (CheckEmptyUtils.isEmpty(formItem)) {
      return undefined;
    }
    return ExtraData.getExtendData(formItem)?.cardUniqueTag;
  }

  /**
   * 设置卡片tag
   *
   * @param cardItemInfo
   * @param cardUniqueTag
   */
  public static setCardUniqueTag(cardItemInfo: GridLayoutItemInfo, cardUniqueTag: string): void {
    if (CheckEmptyUtils.isEmpty(cardItemInfo)) {
      return;
    }
    let want: Want | undefined = ExtraData.parseJsonString(cardItemInfo.extend1);
    if (!want?.parameters?.data) {
      return;
    }
    let data = want.parameters.data as ExtraData;
    data.cardUniqueTag = cardUniqueTag;
    cardItemInfo.extend1 = JSON.stringify(want);
  }

  /**
   * 设置场景卡ID
   *
   * @param cardItemInfo
   * @param portfolioId
   */
  public static setPortfolioId(cardItemInfo: GridLayoutItemInfo, portfolioId: string): void {
    if (CheckEmptyUtils.isEmpty(cardItemInfo)) {
      return;
    }
    let want: Want | undefined = ExtraData.parseJsonString(cardItemInfo.extend1);
    if (!want?.parameters?.data) {
      return;
    }
    let data = want.parameters.data as ExtraData;
    data.portfolioId = portfolioId;
    if (portfolioId === 'default') {
      data.cardType = 0;
    }
    cardItemInfo.extend1 = JSON.stringify(want);
  }

  /**
   * 重置卡片数据
   *
   * @param cardItemInfo
   */
  public static resetExtend1AfterAddSuccess(cardItemInfo: CardItemInfo): void {
    if (CheckEmptyUtils.isEmpty(cardItemInfo)) {
      return;
    }
    let want: Want | undefined = ExtraData.parseJsonString(cardItemInfo.extend1);
    if (!want?.parameters?.data) {
      return;
    }
    let data = want.parameters.data as ExtraData;
    data.commandId = '';
    data.commandType = -1;
    data.operateFormId = -1;
    cardItemInfo.extend1 = JSON.stringify(want);
  }

  /**
   * 重置卡片数据
   *
   * @param cardItemInfo
   */
  public static resetData(cardItemInfo: GridLayoutItemInfo): void {
    if (!cardItemInfo || CheckEmptyUtils.isEmpty(cardItemInfo.extend1)) {
      return;
    }
    log.showWarn(`resetData cardItemInfo extend1=${cardItemInfo.extend1}`);
    let want: Want | undefined = ExtraData.parseJsonString(cardItemInfo.extend1);
    if (!want?.parameters?.data) {
      return;
    }
    want.parameters.data = '';
    cardItemInfo.extend1 = JSON.stringify(want);
  }

  /**
   * 更新卡片类型
   *
   * @param cardType
   * @param cardItemInfo
   */
  public static updateVoiceCardType(cardType: number, cardItemInfo: CardItemInfo): void {
    if (CheckEmptyUtils.isEmpty(cardItemInfo) || !(cardItemInfo.bundleName === BundleConstants.AI_SUGGESTION_BUNDLE &&
      cardItemInfo.abilityName === BundleConstants.AI_SUGGESTION_ABILITY)) {
      return;
    }
    let want: Want | undefined = ExtraData.parseJsonString(cardItemInfo.extend1);
    if (!want?.parameters?.data) {
      return;
    }
    let data = want.parameters.data as ExtraData;
    data.cardType = cardType;
    cardItemInfo.extend1 = JSON.stringify(want);
  }

  private static parseJsonString(str?: string): Want | undefined {
    if (!str) {
      log.showError('parseJsonString str empty');
      return undefined;
    }
    try {
      return JSON.parse(str) as Want;
    } catch (e) {
      log.showError(`parseJsonString error, ${e}`);
      return undefined;
    }
  }
}
