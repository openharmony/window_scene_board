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

import { IconPicType } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { CardItemInfo, CommonConstants, FormModel } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';

const TAG = 'ServiceValidator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 推荐服务校验工具
 *
 * @since 2024-11-27
 */
export class ServiceValidator {
  /**
   * 判断cardInfo是否有效
   *
   * @param cardInfo 卡片信息
   * @returns true 有效 false 无效
   */
  public static async isCardInfoValid(cardInfo: LauncherCardInfo | undefined): Promise<boolean> {
    if (!cardInfo) {
      log.showError('cardInfo invalid');
      return false;
    }
    const portraitValid = await ServiceValidator.isValid(cardInfo.portrait?.recItems ?? []);
    if (!portraitValid) {
      log.showError('portrait info invalid');
      return false;
    }
    if (!CheckEmptyUtils.isEmptyArr(cardInfo.landscapeOrExpand?.recItems)) {
      const landscapeValid = await ServiceValidator.isValid(cardInfo.landscapeOrExpand?.recItems ?? []);
      if (!landscapeValid) {
        log.showError('landscape info invalid');
        return false;
      }
    }
    return true;
  }

  private static async isValid(items: LauncherRecItem[]): Promise<boolean> {
    if (CheckEmptyUtils.isEmptyArr(items)) {
      log.showError('items is empty');
      return false;
    }
    for (const item of items) {
      if (!item) {
        log.showError('item invalid');
        return false;
      }
      if (item.itemType === AiSuggestionConstants.TYPE_CARD) {
        const isFormValid = await ServiceValidator.isFormValid(item);
        if (!isFormValid) {
          log.showError(`invalid form ${item.bundleName}_${item.moduleName}_${item.abilityName}_${item.formName}_${item.dimension}`);
          return false;
        }
      } else if (item.itemType === AiSuggestionConstants.TYPE_APP) {
        const isAppValid = await ServiceValidator.isAppValid(item.bundleName, item.moduleName, item.abilityName);
        if (!isAppValid) {
          log.showError(`invalid app ${item.bundleName}_${item.moduleName}_${item.abilityName}`);
          return false;
        }
      } else if (item.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        const isSubItemValid = await ServiceValidator.isSubItemValid(item.subLauncherRecItems);
        if (!isSubItemValid) {
          return false;
        }
      } else {
        log.showError(`unknown item type ${item.itemType}`);
        return false;
      }
    }
    return true;
  }

  private static async isSubItemValid(subRecItems: LauncherRecItem[]): Promise<boolean> {
    if (CheckEmptyUtils.isEmptyArr(subRecItems)) {
      log.showError('subRecItems is empty');
      return false;
    }
    for (let subRecItem of subRecItems) {
      if (!subRecItem) {
        log.showError('subRecItem invalid');
        return false;
      }
      if (subRecItem.itemType === AiSuggestionConstants.TYPE_APP) {
        const isAppValid =
          await ServiceValidator.isAppValid(subRecItem.bundleName, subRecItem.moduleName, subRecItem.abilityName);
        if (!isAppValid) {
          log.showError(`invalid subItem app ${subRecItem.bundleName}_${subRecItem.moduleName}_${subRecItem.abilityName}`);
          return false;
        }
      } else {
        log.showError(`unknown subItem type ${subRecItem.itemType}`);
        return false;
      }
    }
    return true;
  }

  private static async isFormValid(item: LauncherRecItem): Promise<boolean> {
    const cards: CardItemInfo[] = await FormModel.getInstance().getFormsInfoFromMapAndManager(item.bundleName);
    if (CheckEmptyUtils.isEmptyArr(cards)) {
      log.showError('cards is empty');
      return false;
    }
    const index = cards.findIndex(card => {
      return card.bundleName === item.bundleName &&
        card.moduleName === item.moduleName &&
        card.abilityName === item.abilityName &&
        card.cardName === item.formName &&
        card.supportDimensions.findIndex(cardDimension => {
          return cardDimension === item.dimension;
        }) !== CommonConstants.INVALID_VALUE;
    });
    return index !== -1;
  }

  private static async isAppValid(bundleName: string, moduleName: string, abilityName: string): Promise<boolean> {
    let iconInfo =
      await IconResourceManager.getInstance().getIconResource(bundleName, moduleName, abilityName);
    if (!iconInfo) {
      log.showError('iconInfo is invalid');
      return false;
    }
    return iconInfo.iconType !== IconPicType.NONE;
  }
}