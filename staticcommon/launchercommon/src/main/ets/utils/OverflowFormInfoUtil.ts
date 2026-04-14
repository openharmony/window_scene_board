/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import {
  CheckEmptyUtils,
  CommonUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { OverflowConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import type { CardItemInfo } from '../bean/CardItemInfo';
import { GameCardInfo } from '../bean/GameCardInfo';
import { FormModel } from '../model/FormModel';
import { GridLayoutItemInfo } from '../TsIndex';

const TAG = 'OverflowFormInfoUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OverflowFormInfoUtil {
  /**
   * Fills the overflow card information (`cardItemInfo`) based on the type of the form (`formItem`).
   *
   * @param formItem The form information object containing details of the form.
   * @param cardItemInfo The card item information object to be populated with overflow data.
   */
  public static fillOverflowCardInfo(formItem: formInfo.FormInfo, cardItemInfo: CardItemInfo): void {
    let gameType: string = formItem.customizeData?.gameType;
    log.showInfo(`The gameType is: ${gameType}`);
    if (gameType === OverflowConstants.QUICK_TYPE_GAMECARD) {
      OverflowFormInfoUtil.fillQuickGameCardInfo(formItem, cardItemInfo, gameType);
    } else {
      OverflowFormInfoUtil.fillExtensionTypeCardInfo(formItem, cardItemInfo);
    }
  }

  /**
   * 补充gridLayoutInfo中的互动卡片配置信息
   *
   * @param layoutInfo layoutInfo
   */
  public static fillOverflowCardInfoInGridLayout(layoutInfo: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(layoutInfo)) {
      return;
    }
    if (!CheckEmptyUtils.isEmpty(layoutInfo.gameCardInfo)) {
      return;
    }
    if (!layoutInfo.cardName) {
      log.showWarn(`fillOverflowCardInfoInGridLayout, bundleName: ${layoutInfo.bundleName}`);
      return;
    }
    let newFormInfos: CardItemInfo[] | undefined = FormModel.getInstance().getAppItemFormInfo(layoutInfo.bundleName);
    if (!newFormInfos) {
      log.showInfo(`fillOverflowCardInfoInGridLayout newFormInfos is empty`);
      return;
    }
    let newFormInfo: CardItemInfo = newFormInfos.filter(newItem => newItem.cardName === layoutInfo.cardName)?.[0];
    if (!CheckEmptyUtils.isEmpty(newFormInfo) && !CheckEmptyUtils.isEmpty(newFormInfo.gameCardInfo) ) {
      layoutInfo.gameCardInfo = newFormInfo.gameCardInfo;
    }
  }

  /**
   * 从数据库中的intent解析出互动卡片的信息
   *
   * @param intent db中存放的互动卡片信息
   * @returns 互动卡片对象
   */
  public static parseLiveFormCardInfo(intent: string | undefined): GameCardInfo | undefined {
    try {
      let cardInfoStr: string = CommonUtils.jsonStrToMap(intent).get(OverflowConstants.INTENT_KEY_GAMECARD) as string;
      if (CheckEmptyUtils.checkStrIsEmpty(cardInfoStr)) {
        cardInfoStr = CommonUtils.jsonStrToMap(intent).get(OverflowConstants.INTENT_KEY_LIVE_FORM_CARD) as string;
      }
      if (!CheckEmptyUtils.checkStrIsEmpty(cardInfoStr)) {
        return JSON.parse(cardInfoStr);
      }
    } catch (error) {
      log.showError(TAG, `parseLiveFormCardInfo error, json format error. ${error.code}: ${error.message}`);
    }
    return undefined;
  }

  /**
   * 更新互动卡片数据
   *
   * @param intentMap 现有的卡片数据
   * @param intent 待更新的互动卡片数据
   * @param key db中存储的json字符串key值
   * @returns 更新后的互动卡片数据json字符串
   */
  public static updateLiveFromData(intentMap: Map<string, Object>, intent: string, key: string): string | undefined {
    let cardInfoStr: string = CommonUtils.jsonStrToMap(intent).get(key) as string;
    if (cardInfoStr && cardInfoStr.trim().length > 0) {
      intentMap.set(key, cardInfoStr);
      try {
        return CommonUtils.mapToJonStr(intentMap);
      } catch (error) {
        log.showError(`updateFormData, updateLiveFromData failed,
          key:${key} err code:${error?.code} msg:${error?.message}`);
      }
    }
    return undefined;
  }

  private static fillQuickGameCardInfo(formItem: formInfo.FormInfo, cardItemInfo: CardItemInfo, gameType: string): void {
    let formBindGame: string = formItem.customizeData.formBindGame;
    let gameCardInfo: GameCardInfo;
    if (CheckEmptyUtils.checkStrIsEmpty(formBindGame) ||
      formBindGame.trim().length >= OverflowConstants.CONFIG_PARAM_LENGTH_LIMIT) {
      log.showInfo(`fillQuickGameCardInfo failed`);
      return;
    }
    gameCardInfo = new GameCardInfo();
    gameCardInfo.gameType = gameType;
    gameCardInfo.formBindAbility = OverflowConstants.FORM_BIND_ABILITY_DEFAULT;
    gameCardInfo.formBindGame = formBindGame;
    gameCardInfo.pauseDuration = OverflowConstants.OVERFLOW_ACTIVE_TIMER;
    OverflowFormInfoUtil.fillCardItemIntent(gameCardInfo, cardItemInfo);
  }

  private static fillExtensionTypeCardInfo(formItem: formInfo.FormInfo, cardItemInfo: CardItemInfo): void {
    if (!OverflowFormInfoUtil.fillFunInteractionParams(formItem, cardItemInfo)) {
      OverflowFormInfoUtil.fillSceneAnimationParams(formItem, cardItemInfo);
    }
  }

  // 是否游戏卡
  public static isGameCard(formInfo: CardItemInfo): boolean {
    return formInfo.gameCardInfo !== undefined && (
      formInfo.gameCardInfo.gameType === OverflowConstants.QUICK_TYPE_GAMECARD ||
      formInfo.gameCardInfo.extensionType === OverflowConstants.INTERACTION_TYPE);
  }

  private static fillFunInteractionParams(formItem: formInfo.FormInfo, cardItemInfo: CardItemInfo): boolean {
    let formBindAbility: string = formItem.funInteractionParams?.abilityName ?? '';
    let formBindGame: string = formItem.funInteractionParams?.targetBundleName ?? '';
    let subBundleName: string = formItem.funInteractionParams?.subBundleName ?? '';
    let pauseDuration: number = formItem.funInteractionParams?.keepStateDuration ?? OverflowConstants.OVERFLOW_ACTIVE_TIMER;
    let gameCardInfo: GameCardInfo | undefined;
    if (!formItem.funInteractionParams || CheckEmptyUtils.checkStrIsEmpty(formBindGame) ||
      formBindGame.trim().length >= OverflowConstants.CONFIG_PARAM_LENGTH_LIMIT) {
      log.showInfo(`fillFunInteractionParams failed`);
      return false;
    }
    gameCardInfo = new GameCardInfo();
    if (!CheckEmptyUtils.checkStrIsEmpty(formBindAbility) &&
      formBindAbility.trim().length < OverflowConstants.CONFIG_PARAM_LENGTH_LIMIT) {
      gameCardInfo.formBindAbility = formBindAbility;
    } else {
      gameCardInfo.formBindAbility = OverflowConstants.FORM_BIND_ABILITY_DEFAULT;
    }
    gameCardInfo.extensionType = OverflowConstants.INTERACTION_TYPE;
    gameCardInfo.formBindGame = formBindGame;
    gameCardInfo.subBundleName = subBundleName ?? '';
    gameCardInfo.pauseDuration = pauseDuration;
    OverflowFormInfoUtil.fillCardItemIntent(gameCardInfo, cardItemInfo);
    return true;
  }

  private static fillSceneAnimationParams(formItem: formInfo.FormInfo, cardItemInfo: CardItemInfo): void {
    let formBindAbility: string = formItem.sceneAnimationParams?.abilityName ?? '';
    let disabledDesktopBehaviors: string = formItem.sceneAnimationParams?.disabledDesktopBehaviors ?? '';
    let gameCardInfo: GameCardInfo | undefined;
    if (!formItem.sceneAnimationParams || CheckEmptyUtils.checkStrIsEmpty(formBindAbility) ||
      formBindAbility.trim().length >= OverflowConstants.CONFIG_PARAM_LENGTH_LIMIT) {
      log.showInfo(`fillSceneAnimationParams failed`);
      return;
    }
    gameCardInfo = new GameCardInfo();
    gameCardInfo.formBindAbility = formBindAbility;
    gameCardInfo.extensionType = OverflowConstants.ANIMATION_TYPE;
    if (!CheckEmptyUtils.checkStrIsEmpty(disabledDesktopBehaviors)) {
      gameCardInfo.disabledDesktopBehaviors = disabledDesktopBehaviors;
    }
    OverflowFormInfoUtil.fillCardItemIntent(gameCardInfo, cardItemInfo);
  }

  private static fillCardItemIntent(gameCardInfo: GameCardInfo, cardItemInfo: CardItemInfo): void {
    cardItemInfo.gameCardInfo = gameCardInfo;
    let intentMap: Map<string, string> = new Map<string, string>();
    if (gameCardInfo.gameType === OverflowConstants.QUICK_TYPE_GAMECARD) {
      intentMap.set(OverflowConstants.INTENT_KEY_GAMECARD, JSON.stringify(gameCardInfo));
    } else {
      intentMap.set(OverflowConstants.INTENT_KEY_LIVE_FORM_CARD, JSON.stringify(gameCardInfo));
    }
    cardItemInfo.intent = CommonUtils.mapToJonStr(intentMap);
    log.showInfo(`fillGameCardInfo, gameType is: ${gameCardInfo.gameType}` +
      `, extensionType is:${gameCardInfo.extensionType}` +
      `, formBindAbility is empty:${CheckEmptyUtils.checkStrIsEmpty(gameCardInfo.formBindAbility)}` +
      `, formBindGame is empty:${CheckEmptyUtils.checkStrIsEmpty(gameCardInfo.formBindGame)}` +
      `, subBundleName is empty:${CheckEmptyUtils.checkStrIsEmpty(gameCardInfo.subBundleName)}`);
  }
}
