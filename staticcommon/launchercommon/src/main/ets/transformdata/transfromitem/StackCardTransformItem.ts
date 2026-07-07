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
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { BackupFavoriteInfo, BackupItemType } from '../../model/BackupFavoriteInfo';
import DataConvert from '../DataConvert';
import { BaseTransformItem } from './BaseTransformItem';
import { CardTransformItem } from './CardTransformItem';
import { CheckEmptyUtils } from '@ohos/basicutils';

const TAG = 'StackCardTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class StackCardTransformItem extends CardTransformItem {
  public isSupportInohos(): boolean {
    return true;
  }

  public async transformBackupInfoToGridInfo(backupTransformItemList: BaseTransformItem [], type: string):
    Promise<GridLayoutItemInfo[]> {
    log.showInfo(TAG, 'transform stackCard Item');
    let result: GridLayoutItemInfo[] = [];
    let backupInfo: BackupFavoriteInfo = this.backupInfo;
    let item: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(backupInfo);
    item.typeId = CommonConstants.TYPE_FORM_STACK;
    item.formStackId = String(DataConvert.incCurrentTime());
    if (item.area && !CheckEmptyUtils.isEmptyArr(item.area) &&
      item.area.length === NumberConstants.CONSTANT_NUMBER_TWO) {
      item.area[0] = item.area[0] === NumberConstants.CONSTANT_NUMBER_THREE ? NumberConstants.CONSTANT_NUMBER_FOUR :
        item.area[0];
      item.area[1] = item.area[1] === NumberConstants.CONSTANT_NUMBER_THREE ? NumberConstants.CONSTANT_NUMBER_FOUR :
        item.area[1];
    }
    // 堆叠中的卡片在CardTransformItem中已经标记
    this.setCardSourceType(item, type);
    let backupCompInfoList: BaseTransformItem[] = backupTransformItemList.filter(
      item => item.backupInfo.container === backupInfo.id &&
        item.backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD);
    const orderBefore = backupCompInfoList.map(item => item.backupInfo.appWidgetId ?? item.backupInfo.id);
    backupCompInfoList.sort((a: BaseTransformItem, b: BaseTransformItem) => a.backupInfo.cellY - b.backupInfo.cellY);
    const intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
    intentMap.set('cardOrder', backupCompInfoList.map(i => i.backupInfo.appWidgetId ?? i.backupInfo.id));
    item.intent = CommonUtils.mapToJsonStr(intentMap);
    log.showInfo(TAG, `double formStack is ${item.formStackId}, screen: ${item.page}, container: ${item.container}, point: [${item.row}, ${item.column}] ` +
      `formStack.length: ${backupCompInfoList?.length}, sortFormStack: ${orderBefore}->${item.intent}`);
    result.push(item);
    for (let i = 0; i < backupCompInfoList?.length; i++) {
      let commonCardGridInfo: GridLayoutItemInfo[] =
        await backupCompInfoList[i].transformBackupInfoToGridInfo(backupTransformItemList, type);
      if (commonCardGridInfo) {
        result.push(...commonCardGridInfo);
      }
    }
    return result;
  }
}