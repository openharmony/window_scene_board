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
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { AgentInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/AgentInfo';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';

const TAG: string = 'LauncherCardInfo';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议卡片数据
 *
 * @since 2023-10-08
 */
export class LauncherCardInfo {
  public recId: string = '';

  public subRecId: number = 0;

  public optType: number = 0;

  // 用于数据分组，可能与真实状态不同，当卡片刷新时，该字段可能为undefined
  public stackId: string = '';

  public operateFormId: string = '';

  public cardUniqueTag: string = '';

  public portrait?: LauncherDisplayCardInfo;

  public landscapeOrExpand?: LauncherDisplayCardInfo;

  public portfolioInfo?: PortfolioInfo;

  public recommendCard?: LauncherDisplayCardInfo;

  // 分发特性支持版本号,如：换一换功能>=1
  public featureVersion: number = 0;

  static isMainCard(cardInfo: LauncherCardInfo): boolean {
    return !cardInfo?.portfolioInfo || !cardInfo.portfolioInfo.portfolioId ||
      cardInfo.portfolioInfo.portfolioId === 'default' ||
      cardInfo.portfolioInfo.portfolioId === '';
  }

  /**
   * 根据设备状态获取显示内容
   *
   * @returns 卡片显示内容
   */
  static getDisplayCardInfo(cardInfo: LauncherCardInfo | undefined,
    isExpand?: boolean): LauncherDisplayCardInfo | undefined {
    if (!cardInfo) {
      return undefined;
    }
    if (isExpand === null || isExpand === undefined) {
      isExpand = AbilityFormUtil.isExpand();
    }

    // 堆叠轮转推新数据
    if (cardInfo.recommendCard) {
      return cardInfo.recommendCard;
    }

    // 折叠屏展开或者横屏
    let launchDisplayCardInfo: LauncherDisplayCardInfo | undefined =
      (isExpand || !AbilityFormUtil.isPortrait()) ? cardInfo.landscapeOrExpand : cardInfo.portrait;
    return launchDisplayCardInfo ?? cardInfo.portrait;
  }

  static isDeleteCard(cardInfo: LauncherCardInfo): boolean {
    if (CheckEmptyUtils.isEmpty(cardInfo)) {
      return false;
    }
    return cardInfo.optType === AiSuggestionUpdateConstants.OptType.DELETE_CARD;
  }

  static isAddCard(cardInfo: LauncherCardInfo): boolean {
    if (CheckEmptyUtils.isEmpty(cardInfo)) {
      return false;
    }
    return cardInfo.optType === AiSuggestionUpdateConstants.OptType.ADD_CARD ||
      cardInfo.optType === AiSuggestionUpdateConstants.OptType.ADD_AND_SWITCH;
  }

  static isUpdateCard(cardInfo: LauncherCardInfo): boolean {
    if (CheckEmptyUtils.isEmpty(cardInfo)) {
      return false;
    }
    return cardInfo.optType === AiSuggestionUpdateConstants.OptType.UPDATE_CARD ||
      cardInfo.optType === AiSuggestionUpdateConstants.OptType.UPDATE_AND_SWITCH;
  }

  static isNeedToSwitch(cardInfo: LauncherCardInfo): boolean {
    if (CheckEmptyUtils.isEmpty(cardInfo)) {
      return false;
    }
    return cardInfo.optType === AiSuggestionUpdateConstants.OptType.SWITCH_CARD ||
      cardInfo.optType === AiSuggestionUpdateConstants.OptType.ADD_AND_SWITCH;
  }

  static isCardInfoValid(cardInfo?: LauncherCardInfo): boolean {
    if (!cardInfo) {
      return false;
    }
    const displayCardInfo: LauncherDisplayCardInfo | undefined = LauncherCardInfo.getDisplayCardInfo(cardInfo);
    return !CheckEmptyUtils.isEmptyArr(displayCardInfo?.recItems) ||
      !CheckEmptyUtils.isEmpty(cardInfo.portfolioInfo?.agentInfo);
  }

  static isCardInfoInValid(displayCardInfo?: LauncherDisplayCardInfo,
    agentInfo?: AgentInfo): boolean {
    return CheckEmptyUtils.isEmptyArr(displayCardInfo?.recItems) && !agentInfo;
  }

  static isExpired(cardInfo?: LauncherCardInfo): boolean {
    if (!cardInfo) {
      return true;
    }
    const portfolioInfo: PortfolioInfo | undefined = cardInfo.portfolioInfo;
    if (!portfolioInfo) {
      // 没有场景数据，不需要判断
      return false;
    }
    if (!portfolioInfo.expireTime || portfolioInfo.expireTime === 0) {
      // 没有expireTime 或者 expireTime = 0，不需要判断
      return false;
    }
    // 当前时间大于失效时间，表示该数据已经失效
    const isExpired = Date.now() >= portfolioInfo.expireTime;
    if (isExpired) {
      log.showWarn(`portfolioInfo ${portfolioInfo.portfolioId} is isExpired, expireTime:${portfolioInfo.expireTime}`);
    }
    return isExpired;
  }
}