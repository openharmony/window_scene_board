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
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { BaseTransformItem } from './BaseTransformItem';
import { CardTransformItem } from './CardTransformItem';

const TAG = 'CombineCardTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class CombineCardTransformItem extends CardTransformItem {
  public isSupportInohos(): boolean {
    return true;
  }

  public async transformBackupInfoToGridInfo(backupTransformItemList: BaseTransformItem [], type: string):
    Promise<GridLayoutItemInfo[]> {
    log.showInfo(TAG, 'transform combineCard Item');
    let backupCompInfoList: BaseTransformItem[] =
      backupTransformItemList.filter(item => item.backupInfo && item.backupInfo.container === this.backupInfo.id);
    let combineCardInfo: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(this.backupInfo);
    combineCardInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
    if (combineCardInfo.area && !CheckEmptyUtils.isEmptyArr(combineCardInfo.area) &&
      combineCardInfo.area.length === NumberConstants.CONSTANT_NUMBER_TWO) {
      combineCardInfo.area[0] = combineCardInfo.area[0] === NumberConstants.CONSTANT_NUMBER_THREE ?
        NumberConstants.CONSTANT_NUMBER_FOUR : combineCardInfo.area[0];
      combineCardInfo.area[1] = combineCardInfo.area[1] === NumberConstants.CONSTANT_NUMBER_THREE ?
        NumberConstants.CONSTANT_NUMBER_FOUR : combineCardInfo.area[1];
    }
    combineCardInfo.layoutInfo = [[]];
    let result: GridLayoutItemInfo[] = [];
    for (let i = 0; i < backupCompInfoList.length; i++) {
      let innerItem: GridLayoutItemInfo[] = await backupCompInfoList[i].transformBackupInfoToGridInfo(
        backupTransformItemList, type);
      if (innerItem && innerItem.length > 0) {
        combineCardInfo.layoutInfo[0].push(...innerItem);
      }
    }
    if (!CheckEmptyUtils.isEmptyArr(combineCardInfo.layoutInfo[0])) {
      log.showInfo(TAG, `the subcard length of a combined card is : ${combineCardInfo.layoutInfo[0].length}`);
      result.push(combineCardInfo);
    }
    return result;
  }
}