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

import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import { RdbStoreManager } from '../RdbStoreManager';
import { LiveFormSupportMgr } from '../../form/manager/FormHostService';
import {
  Extend1Data,
  FormCommonUtil,
  FormConstants,
  FormHiSysEventReporter,
  RemoveCardEvent,
  RemoveCardResultType,
} from '../../TsIndex';

const TAG = 'DirtyFormCorrector';
const CARD_TYPE_TEMP: number = 1;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DirtyFormCorrector extends AbstractGridLayoutCorrector {
  private pageDeletedSet: Set<number> = new Set();

  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    // 处理小游戏卡片脏数据
    this.dealDirtyGameCard(girdLayoutInfo, isOuter);
  }

  private addPageDeleted(page: number): void {
    this.pageDeletedSet.add(page);
  }

  constructor(pageSet: Set<number>) {
    super();
    this.pageDeletedSet = pageSet;
  }

  private correctDesktopGameCard(gridLayoutInfo: GridLayoutItemInfo[], index: number, isOuter?: boolean): void {
    const itemInfo = gridLayoutInfo[index];
    gridLayoutInfo.splice(index, 1);
    RdbStoreManager.getInstance().deleteFormInfoById(itemInfo.cardId, isOuter);
    this.addPageDeleted(itemInfo.page);
    log.showError(`correctDesktopGameCard cardId: ${itemInfo.cardId}, isOuter: ${isOuter}`);

    const event: RemoveCardEvent = {
      packageName: itemInfo.bundleName,
      area: itemInfo.area,
      formId: itemInfo.cardId.toString(),
      moduleName: itemInfo.moduleName,
      formName: itemInfo.cardName,
      position: `[${itemInfo.page},${itemInfo.column},${itemInfo.row}]`,
      resultType: RemoveCardResultType.REMOVE,
      sourceType: Extend1Data.getCardSourceType(itemInfo.extend1),
      formType: FormCommonUtil.getFormType(itemInfo.gameCardInfo),
    };
    FormHiSysEventReporter.reportRemoveCard(event);
  }

  private isDelGameCard(itemInfo: GridLayoutItemInfo): boolean {
    if (LiveFormSupportMgr.getInstance().isSupportGameCard() ||
      LiveFormSupportMgr.getInstance().isSupportFunInteraction()) {
      return false;
    }
    return itemInfo.typeId === CommonConstants.TYPE_CARD &&
      itemInfo.bundleName === FormConstants.BUNDLE_LITE_GAMES &&
      itemInfo.gameCardInfo?.formBindGame === FormConstants.BIND_GAME_STACKING_BOXES;
  }

  private dealDirtyGameCard(gridLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    log.showInfo('fix dirty liteGames form start');
    for (let i = gridLayoutInfo.length - 1; i >= 0; i--) {
      const itemInfo = gridLayoutInfo[i];
      if (!itemInfo) {
        continue;
      }
      if (this.isDelGameCard(itemInfo)) {
        this.correctDesktopGameCard(gridLayoutInfo, i, isOuter);
      }
    }
  }
}