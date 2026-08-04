/**
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { UpdateRdbManager } from '../manager/UpdateRdbManager';
import { transferRelationManager } from '../manager/TransferRelationManager';
import { LogDomain, Logger, CheckEmptyUtils } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { BackupFavoriteInfo, BackupItemType } from '../model/BackupFavoriteInfo';
import { TransferLayoutManager } from './TransferLayoutManager';
import dataConvert from './DataConvert';
import { CommonConstants, SceneType } from '../constants/CommonConstants';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import preferences from '@ohos.data.preferences';
import type ctx from '@ohos.app.ability.common';
import { BaseTransformItem } from './transfromitem/BaseTransformItem';
import { TransformItemFactory } from './transfromitem/TransformItemFactory';
import { CardUpdateInMigrateEvent, FormHiSysEventReporter } from '../utils/FormHiSysEventReporter';
import { IntentParseUtil, PackageRelation } from '../utils/IntentParseUtil';
import { OhosMigrateLayoutManager } from './OhosMigrateLayoutManager';
import { AddCardToNewPageManager } from './manager/AddCardToNewPageManager';
import { OhosSuperAdditionRelationManager, shortcutTransferRelationManager } from '../TsIndex';

const TAG = 'TransformController';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class TransformController {
  private updateRdbManager: UpdateRdbManager;

  constructor() {
    this.updateRdbManager = UpdateRdbManager.getInstance();
  }

  /**
   *  start transfer launcherDb and data such as layout and badge
   * @returns Promise<void>
   */
  public async startTransferLauncherDbData(): Promise<void> {
    log.showInfo(TAG, 'TransferLauncherDbData start');
    await this.updateRdbManager.saveOldLayoutToContext();
    await this.loadRelation();
    await this.transLayout();
    log.showInfo(TAG, 'TransferLauncherDbData end');
  }

  private async loadRelation(): Promise<void> {
    await transferRelationManager.loadTransferInfos();
    await shortcutTransferRelationManager.loadTransferInfos();
    await OhosSuperAdditionRelationManager.getInstance().loadTransferInfos();
  }

  private async transLayout(): Promise<void> {
    log.showInfo(TAG, 'TransferLayoutManager start');
    await AddCardToNewPageManager.getInstance().init(SceneType.HWLAUNCHER_MIGRATE_ohos);
    const backUpInfoList: BackupFavoriteInfo[] = await this.updateRdbManager.queryLauncherDbDesktopInfo(false);
    if (CheckEmptyUtils.isEmptyArr(backUpInfoList)) {
      log.showInfo(TAG, 'not find any data in old database!');
      return;
    }
    let backupTransformItemList: BaseTransformItem [] = [];
    for (let backupInfo of backUpInfoList) {
      AddCardToNewPageManager.getInstance().addCardToNewPageShortcut(backupInfo);
      backupTransformItemList.push(TransformItemFactory.getInstance().getTransformItem(backupInfo));
    }
    let oldLayoutGrid: number[] = GlobalContext.getInstance().getObject('oldLayoutGrid') as number[];
    if (CheckEmptyUtils.isEmptyArr(oldLayoutGrid)) {
      oldLayoutGrid = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
    }
    let oldLayoutCol = oldLayoutGrid[0];
    let oldLayoutRow = oldLayoutGrid[1];
    let curLayoutRow = 0;
    let curLayoutCol = 0;
    try {
      await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'DESKTOP_LAYOUT_INFO')
        .then((preference) => {
          curLayoutCol = preference.getSync('column', CommonConstants.DEFAULT_COL) as number;
          curLayoutRow = preference.getSync('row', CommonConstants.DEFAULT_ROW) as number;
        }).catch((reason: Error) => {
          log.showError(TAG, `getPreferences error ${JSON.stringify(reason)}`);
        });
    } catch (error) {
      log.error(TAG, 'registerCallBack error', error);
    }
    log.showInfo(TAG, `oldLayoutCol ${oldLayoutCol} oldLayoutRow ${oldLayoutRow}  ==> backup to curLayoutCol` +
      ` ${curLayoutCol} curLayoutRow ${curLayoutRow}`);
    let transferManager: TransferLayoutManager | OhosMigrateLayoutManager | null = null;
    if (DeviceHelper.isPad()) {
      transferManager = new TransferLayoutManager([oldLayoutCol, oldLayoutRow], [curLayoutCol, curLayoutRow]);
    } else {
      transferManager = new OhosMigrateLayoutManager([oldLayoutCol, oldLayoutRow], [curLayoutCol, curLayoutRow]);
    }
    log.showInfo(TAG, 'TransferLayoutManager end');
    this.reportCardUpdateAfterLayout(backUpInfoList, transferManager.getNewLayoutCardItems());
  }

  private reportCardUpdateAfterLayout(backUpInfoList: BackupFavoriteInfo[], newCardList: GridLayoutItemInfo[]): void {
    log.showInfo(TAG, 'reportCardUpdateAfterLayout start');
    let oldCardList: BackupFavoriteInfo[] = backUpInfoList.filter(item =>
    item.itemType === BackupItemType.BACKUP_ITEM_TYPE_WIDGET ||
      item.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD);
    newCardList.forEach(newItem => {
      let oldFormItem = oldCardList.find(oldItem => oldItem.id === newItem.id);
      if (oldFormItem) {
        this.reportCardUpdateInMigrate(oldFormItem, newItem, backUpInfoList);
      } else {
        log.showWarn(TAG, 'old card info not found, new card => id=%{public}d, cardId=%{public}d, bundleName=%{public}s, ' +
          'dimension=%{public}d, cardName=%{public}s',
          newItem.id, newItem.cardId, newItem.bundleName, newItem.cardDimension, newItem.cardName);
      }
    });
    log.showInfo(TAG, 'reportCardUpdateAfterLayout end');
  }

  private reportCardUpdateInMigrate(oldFormItem: BackupFavoriteInfo, newFormItem: GridLayoutItemInfo,
    backUpInfoList: BackupFavoriteInfo[]): void {
    let event: CardUpdateInMigrateEvent = {
      originalType: oldFormItem.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD ? 'card' : 'widget',
      prePackageName: this.getOldCardPackageName(oldFormItem, backUpInfoList),
      preCellSize: `${oldFormItem.spanX}*${oldFormItem.spanY}`,
      preFormName: this.getOldFormName(oldFormItem),
      preFormId: oldFormItem.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD ? String(oldFormItem.appWidgetId) : '-1',
      preVersionCode: oldFormItem.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD ? '' : '-1',
      preCurrentPage: oldFormItem.screen,
      preCellX: oldFormItem.cellX,
      preCellY: oldFormItem.cellY,
      packageName: newFormItem.bundleName,
      cellSize: `${newFormItem.area?.[0]}*${newFormItem.area?.[1]}`,
      formName: oldFormItem.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD ? (newFormItem.cardName ?? '-1') : '-1',
      formId: String(newFormItem.cardId),
      currentPage: newFormItem.page,
      cellX: newFormItem.column,
      cellY: newFormItem.row,
      originalPosition: oldFormItem.cellX === newFormItem.column && oldFormItem.cellY === newFormItem.row ? '1' : '0',
    };
    FormHiSysEventReporter.reportCardUpdateInMigrate(event);
  }

  // 卡片/widget的包名和应用包名可能不一致,优先从设备应用获取包名
  private getOldCardPackageName(backupInfo: BackupFavoriteInfo, backUpInfoList: BackupFavoriteInfo[]): string {
    // 根据类型和title查询设备应用
    let oldCardInfo: BackupFavoriteInfo | undefined = backUpInfoList.find(item => {
      return item.itemType === CommonConstants.TYPE_APP && item.title === backupInfo.title;
    });
    if (CheckEmptyUtils.isEmpty(oldCardInfo)) {
      oldCardInfo = backupInfo;
    }
    // 从intent中取包名
    let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(oldCardInfo?.intent ?? '');
    if (packageRelation) {
      return packageRelation.packageName;
    }
    return '';
  }

  private getOldFormName(backupInfo: BackupFavoriteInfo): string {
    if (backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_WIDGET) {
      return '-1';
    }
    if (backupInfo.itemType !== BackupItemType.BACKUP_ITEM_TYPE_CARD) {
      return '';
    }
    let intentMap: Map<string, string> = IntentParseUtil.parseIntent(backupInfo.intent);
    if (!intentMap) {
      return '';
    }
    return intentMap.get(IntentParseUtil.KEY_FORM_NAME) ?? '';
  }
}
