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

import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import { ArrayUtils, DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { DeviceHelper, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import rdb from '@ohos.data.relationalStore';
import { IDataHandler } from './InfoDataHandleController';
import GridLayoutInfoColumns, { GridLayoutInfoEnums } from './column/GridLayoutInfoColumns';
import { CommonConstants } from '../constants/CommonConstants';
import GridLayoutItemInfoDB from '../entity/GridLayoutItemInfoDataBase';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { SceneMsgEnum } from '../TsIndex';

const TAG: string = 'MinorUpdateHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MAX_DOCK_NUM = 4;

/*
 * 修改少量数据时的处理方案：遍历数据在数据库中是否存在，存在则更新，不存在则添加入数据库,总计操作2*size次sql
 * 单次sql执行效率更高，但是累积操作次数较多，适合精准更新少量数据
 */
export default class MinorUpdateHandler implements IDataHandler {
  async handleDataToRdb(target: string, gridItemList: GridLayoutItemInfo[],
    rdbStoreHelper: RdbStoreHelper, container?: number, screenId?: number, reason?: string):
    Promise<void> {
    if (ArrayUtils.isEmpty(gridItemList)) {
      log.showError('gridItemList is null on handleDataToRdb');
      return;
    }
    log.showInfo('handleDataToRdb target: %{public}s, dataSize: %{public}d', target, gridItemList.length);
    for (let i = 0; i < gridItemList.length; i++) {
      let element: GridLayoutItemInfo = gridItemList[i];
      const predicates = new rdb.RdbPredicates(target);
      predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, element.typeId);
      if (!DeviceHelper.isPhoneOrPad()) {
        predicates.and().notEqualTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
        const conditionContainer = container ?? element.container;
        if (conditionContainer) {
          predicates.and().equalTo(GridLayoutInfoColumns.CONTAINER, conditionContainer);
        }
      }

      if (element.typeId === CommonConstants.TYPE_FOLDER || element.typeId === CommonConstants.TYPE_REGION_FOLDER) {
        predicates.and().equalTo(GridLayoutInfoColumns.INFO_ID, element.folderId);
      } else if (element.typeId === CommonConstants.TYPE_CARD) {
        predicates.and().equalTo(GridLayoutInfoColumns.INFO_ID, element.cardId);
      } else if (element.typeId === CommonConstants.TYPE_FILE_FOLDER) {
        predicates.and().equalTo(GridLayoutInfoColumns.FILE_INO, element.ino);
      } else if (element.typeId === CommonConstants.TYPE_FORM_STACK) {
        predicates.and().equalTo(GridLayoutInfoColumns.INFO_ID, element.formStackId);
      } else {
        predicates.and().equalTo(GridLayoutInfoColumns.BUNDLE_NAME, element.bundleName);
        if (element.typeId === CommonConstants.TYPE_APP) {
          predicates.and().equalTo(GridLayoutInfoColumns.APP_INDEX, element.appIndex ?? 0);
        }
        if (element.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          predicates.and().equalTo(GridLayoutInfoColumns.APP_INDEX, element.appIndex ?? 0)
            .and().equalTo(GridLayoutInfoColumns.SHORTCUT_ID, element.shortcutId ?? '');
        }
      }

      let isExist: boolean = await rdbStoreHelper.isExistData(predicates);
      if (isExist) {
        let valuesBucket: rdb.ValuesBucket = {
          [GridLayoutInfoEnums.ROW]: element.row,
          [GridLayoutInfoEnums.COLUMN]: element.column,
          [GridLayoutInfoEnums.PAGE_INDEX]: element.page,
          [GridLayoutInfoEnums.PORTRAIT_ROW]: element.portraitRow,
          [GridLayoutInfoEnums.PORTRAIT_COLUMN]: element.portraitColumn,
          [GridLayoutInfoEnums.PORTRAIT_PAGE_INDEX]: element.portraitPage,
          [GridLayoutInfoEnums.PORTRAIT_WIDTH]: element.portraitArea?.[0] ?? -1,
          [GridLayoutInfoEnums.PORTRAIT_HEIGHT]: element.portraitArea?.[1] ?? -1,
          [GridLayoutInfoEnums.LANDSCAPE_ROW]: element.landscapeRow,
          [GridLayoutInfoEnums.LANDSCAPE_COLUMN]: element.landscapeColumn,
          [GridLayoutInfoEnums.LANDSCAPE_PAGE_INDEX]: element.landscapePage,
          [GridLayoutInfoEnums.LANDSCAPE_WIDTH]: element.landscapeArea?.[0] ?? -1,
          [GridLayoutInfoEnums.LANDSCAPE_HEIGHT]: element.landscapeArea?.[1] ?? -1,
          [GridLayoutInfoEnums.CONTAINER]: container ? container : element.container,
          [GridLayoutInfoEnums.WIDTH]: element.area?.[0],
          [GridLayoutInfoEnums.HEIGHT]: element.area?.[1],
          [GridLayoutInfoEnums.SCREEN_ID]: screenId ?? 0,
        };
        if (element.typeId === CommonConstants.TYPE_FILE_FOLDER ||
          element.typeId === CommonConstants.TYPE_REGION_FOLDER) {
          valuesBucket[GridLayoutInfoColumns.URI] = element.uri;
          valuesBucket[GridLayoutInfoColumns.INFO_NAME] = element.fileFolderName;
        }
        let num: number = await rdbStoreHelper.update(predicates, valuesBucket, undefined, SceneMsgEnum.MINOR_UPDATE, false, 0, target);
        this.toLog('update', target, element, num, container);
        continue;
      }
      log.showInfo('insert item to rdb, target: %{public}s, bundleName: %{public}s', target, element.bundleName);
      let valuesBucket: rdb.ValuesBucket = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(element).toValuesBucket();
      valuesBucket[GridLayoutInfoColumns.CONTAINER] = container ? container : element.container;
      let num: number = await rdbStoreHelper.insert(target, valuesBucket);
      this.toLog('insert', target, element, num, container);
    }

    // Dock数据异常打点
    for (let i = 0; i < gridItemList.length; i++) {
      const conditionContainer = container ?? gridItemList[i].container;
      if (DeviceHelper.isPhone() && conditionContainer === CommonConstants.CONTAINER_SMARTDOCK) {
        let predicates = new rdb.RdbPredicates(target);
        predicates.equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
        // dock按照列升序查询
        predicates.orderByAsc(GridLayoutInfoColumns.COLUMN);
        let resultSet = await rdbStoreHelper.query(predicates, []);
        const count: number = resultSet.columnCount;
        if (count > MAX_DOCK_NUM) {
          HiDfxEventUtil.reportDockRegionItemsCount(CommonConstants.DOCK_RESIDENT, count, reason);
        }
        break;
      }
    }
  }

  private toLog(label: string, target: string, element: GridLayoutItemInfo, num: number,
    container?: number): void {
    let res: string = num > 0 ? 'success' : 'failed';
    log.showWarn('%{public}s item to rdb %{public}s, target: %{public}s, bundleName: %{public}s, num: %{public}d, container: %{public}d, page: %{public}d, row: %{public}d, column: %{public}d',
      label, res, target, element.bundleName, num, container ? container : element.container, element.page, element.row,
      element.column);
  }
}