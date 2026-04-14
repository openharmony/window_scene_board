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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';

const TAG = 'FieldNotNullCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FieldNotNullCorrector extends AbstractGridLayoutCorrector {

  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?:boolean): void {
    let incorrectData: GridLayoutItemInfo[] = girdLayoutInfo.filter((itemInfo) => {
      // 脏数据
      if (itemInfo.typeId === CommonConstants.TYPE_CARD) {
        return CheckEmptyUtils.checkStrIsEmpty(itemInfo.cardId) && CheckEmptyUtils.isEmpty(itemInfo.bundleName);
      } else if (itemInfo.typeId === CommonConstants.TYPE_FOLDER) {
        return CheckEmptyUtils.isEmpty(itemInfo.infoName) && CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo?.[0]);
      }
      return false;
    });

    incorrectData.forEach((itemInfo) => {
      log.showError(`gridLayoutCorrector delete:${JSON.stringify(itemInfo)}`);
      girdLayoutInfo.splice(girdLayoutInfo.indexOf(itemInfo), 1);
      this.deleteRdbGridLayoutItemInfo(itemInfo, isOuter);
    });
  }
}