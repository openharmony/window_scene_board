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
import { BundleConstants, CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import { RdbStoreManager } from '../RdbStoreManager';
import { ExtraData } from '../../aisuggestion/ExtraData';
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
    // 处理语音助手建议卡片脏数据
    this.dealDirtyVoiceCard(girdLayoutInfo, isOuter);

    this.dealDirtyVoiceInfo(girdLayoutInfo);

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

  /**
   * 处理语音助手建议卡片在堆叠的脏数据
   *
   * @param itemInfo 卡片信息
   */
  private correctFormStackVoiceForm(itemInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    // 脏数据: 场景卡在堆叠的数据
    let extraData: ExtraData | undefined = ExtraData.getExtend1(itemInfo.extend1 ?? '');
    if (extraData?.cardType === CARD_TYPE_TEMP &&
      (CheckEmptyUtils.checkStrIsEmpty(extraData.portfolioId) || extraData.portfolioId === 'default')) {
      ExtraData.resetData(itemInfo);
      RdbStoreManager.getInstance().updateExtend1ByCardId(itemInfo.extend1 ?? '', itemInfo.infoId ?? '', isOuter);
      log.showError(`correctFormStackVoiceForm cardId: ${itemInfo.infoId}, extend1=${itemInfo.extend1}`);
    }
  }

  /**
   * 处理语音助手建议在桌面的脏数据
   *
   * @param gridLayoutInfo 桌面布局信息
   * @param itemInfo 卡片信息
   * @param isOuter 是不是外屏
   */
  private correctDesktopVoiceCard(gridLayoutInfo: GridLayoutItemInfo[], index: number, isOuter?: boolean): void {
    const itemInfo = gridLayoutInfo[index];
    let extraData: ExtraData | undefined = ExtraData.getExtend1(itemInfo.extend1 ?? '');
    if (extraData?.cardType === CARD_TYPE_TEMP) {
      // 场景卡在桌面上，cardType不能为TEMP，将卡片删除
      gridLayoutInfo.splice(index, 1);
      RdbStoreManager.getInstance().deleteFormInfoById(itemInfo.cardId ?? '', isOuter);
      log.showError(`correctDesktopVoiceCard cardId: ${itemInfo.infoId}, extend1=${itemInfo.extend1}`);
    }
  }

  private isVoiceCard(itemInfo: GridLayoutItemInfo): boolean {
    return itemInfo.typeId === CommonConstants.TYPE_CARD &&
      itemInfo.bundleName === BundleConstants.AI_SUGGESTION_BUNDLE;
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

  private correctFormStackVoiceCard(itemInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    itemInfo.layoutInfo?.[0]?.forEach(stackItemInfo => {
      if (this.isVoiceCard(stackItemInfo)) {
        this.correctFormStackVoiceForm(itemInfo, isOuter);
      }
    });
  }

  private collectVoiceId(voiceIds: Set<string>, gridLayoutInfo: GridLayoutItemInfo): void {
    if (this.isVoiceCard(gridLayoutInfo)) {
      voiceIds.add(gridLayoutInfo.cardId ?? '');
    } else if (gridLayoutInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      gridLayoutInfo.layoutInfo?.[0]?.forEach(stackItemInfo => {
        if (this.isVoiceCard(stackItemInfo)) {
          voiceIds.add(stackItemInfo.cardId ?? '');
        }
      });
    }
  }

  private dealDirtyVoiceCard(gridLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    log.showInfo('fix dirty aiSuggestion form start');
    for (let i = gridLayoutInfo.length - 1; i >= 0; i--) {
      const itemInfo = gridLayoutInfo[i];
      if (this.isVoiceCard(itemInfo)) {
        this.correctDesktopVoiceCard(gridLayoutInfo, i, isOuter);
      } else if (itemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
        this.correctFormStackVoiceCard(itemInfo, isOuter);
      }
    }
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

  private dealDirtyVoiceInfo(gridLayoutInfo: GridLayoutItemInfo[]): void {
    const voiceIds: Set<string> = new Set();
    gridLayoutInfo.forEach(itemInfo => {
      this.collectVoiceId(voiceIds, itemInfo);
    });
    RdbStoreManager.getInstance().queryAllVoiceCardInfo()
      .then((voiceInfoList: Record<string, string>[]) => {
        log.showWarn(`voiceInfosLength: ${voiceInfoList.length} voiceIdsLength: ${Array.from(voiceIds).length}`);
        voiceInfoList.forEach(voiceInfo => {
          if (!voiceIds.has(voiceInfo.cardId)) {
            RdbStoreManager.getInstance().deleteVoiceCardInfoByCardId(voiceInfo.cardId);
          }
        });
      });
  }
}