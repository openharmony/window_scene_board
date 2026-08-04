/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, Logger } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { BackupFavoriteInfo } from '../../model/BackupFavoriteInfo';
import dataConvert from '../DataConvert';

const TAG = 'BaseTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
// 常规用户id
const NORMAL_USER_ID: number = 100;

export class BaseTransformItem {
  public backupInfo: BackupFavoriteInfo;

  constructor(backupInfo: BackupFavoriteInfo) {
    this.backupInfo = backupInfo;
  }

  public isSupportInohos(): boolean {
    log.showInfo(TAG, `app not support in ohos, appName: ${this.backupInfo.title},  itemType: ${this.backupInfo.itemType}, screen: ${this.backupInfo.screen}, ` +
      `container: ${this.backupInfo.container}, point: [${this.backupInfo.cellY}, ${this.backupInfo.cellX}]`);
    return false;
  }

  public async transformBackupInfoToGridInfo(backupTransformItemList: BaseTransformItem [], type: string): Promise<GridLayoutItemInfo[]> {
    log.error(TAG, 'Base dealAndValidApp function should never be called');
    return [];
  }

  public async transformBackupInfoToGridInfoOnClone(backupTransformItemList: BaseTransformItem [], type: string): Promise<GridLayoutItemInfo[]> {
    return this.transformBackupInfoToGridInfo(backupTransformItemList, type);
  }

  protected buildGridInfoByBackupInfo(backupInfo: BackupFavoriteInfo): GridLayoutItemInfo {
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.id = backupInfo.id;
    item.area = [backupInfo.spanX, backupInfo.spanY];
    item.page = backupInfo.screen;
    item.column = backupInfo.cellX;
    item.row = backupInfo.cellY;
    item.container = backupInfo.container;
    if ((backupInfo.profileId ?? 0) > 0 && dataConvert.getCurUserId() === NORMAL_USER_ID) {
      item.appIndex = NumberConstants.CONSTANT_NUMBER_ONE;
    } else {
      item.appIndex = NumberConstants.CONSTANT_NUMBER_ZERO;
    }
    return item;
  }
}