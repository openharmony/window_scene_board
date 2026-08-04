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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DockItemInfo } from '../../bean/DockItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { BaseTransferBean } from '../BaseTransferBean';

const TAG = 'LogBatchPrint';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.BACKUP, TAG);
// 打印对象的最大属性长度
const MAX_OBJ_ATTR_LEN: number = 6;

/**
 * 日志批量打印
 */
export class LogBatchPrint {
  /**
   * 分批打印短行日志减少日志行数,对象属性长度超过6不予打印
   *
   * @param srcObjList 源待打印对象集合
   * @param batchSize 每批打印的个数
   * @param description 打印描述
   * @param callerName 调用的类名
   */
  public static printLogsInBatch(srcObjList: Object[], batchSize: number, description: string,
    callerName: string): void {
    if (CheckEmptyUtils.isEmptyArr(srcObjList) || typeof srcObjList[0] !== 'object' ||
      Object.keys(srcObjList[0]).length > MAX_OBJ_ATTR_LEN) {
      log.showWarn(`the object array is null or the arribete length is too long, desc: ${description}`);
      return;
    }
    log.showWarn(description + `, size: ${srcObjList.length}, callerName: ${callerName}`);
    let tarObjList: Object[] = [];
    let numCount: number = 0;
    for (let i = 0; i < srcObjList.length; i++) {
      tarObjList.push(srcObjList[i]);
      // 分批打印日志, [起始序号,结束序号]:
      if ((i + 1) % batchSize === 0 || i === srcObjList.length - 1) {
        log.showWarn(`[${numCount}, ${i}]:` + JSON.stringify(tarObjList));
        numCount = i + 1;
        tarObjList = [];
      }
    }
  }

  /**
   * 根据类型返回相应打印对象，该方法只用于克隆过程打印新机特有元素
   *
   * @param uniqueSingleItem
   * @returns 新机特有元素打印对象
   */
  public static getUniqueItemObject(uniqueSingleItem: BaseTransferBean): Object {
    let uniqueSingleObject: Object = {} as IBaseInfo;
    if (CheckEmptyUtils.isEmpty(uniqueSingleItem)) {
      return uniqueSingleObject;
    }
    // 处理应用和分身
    if (uniqueSingleItem.typeId === CommonConstants.TYPE_APP) {
      uniqueSingleObject = {
        bundleName: uniqueSingleItem.bundleName,
        abilityName: uniqueSingleItem.abilityName,
        infoName: uniqueSingleItem.infoName,
        appIndex: uniqueSingleItem.appIndex
      } as IBaseInfo;
      return uniqueSingleObject;
    }
    // 处理卡片
    if (uniqueSingleItem.typeId === CommonConstants.TYPE_CARD) {
      uniqueSingleObject = {
        bundleName: uniqueSingleItem.bundleName,
        cardName: uniqueSingleItem.cardName,
        cardId: uniqueSingleItem.cardId
      } as IBaseInfo;
      return uniqueSingleObject;
    }
    // 处理文件夹
    if (uniqueSingleItem.typeId === CommonConstants.TYPE_FOLDER) {
      let subBundleNameList: string[] = [];
      if (!CheckEmptyUtils.isEmptyArr(uniqueSingleItem.layoutInfo?.[0])) {
        uniqueSingleItem.layoutInfo?.[0].forEach(item => subBundleNameList.push(item.bundleName));
      }
      uniqueSingleObject = {
        folderId: uniqueSingleItem.folderId,
        folderName: uniqueSingleItem.folderName,
        subBundleNameList: subBundleNameList,
        intent: uniqueSingleItem.intent 
      } as IBaseInfo;
      return uniqueSingleObject;
    }
    // 处理堆叠卡片
    if (uniqueSingleItem.typeId === CommonConstants.TYPE_FORM_STACK) {
      let subCardIdList: string[] = [];
      if (!CheckEmptyUtils.isEmptyArr(uniqueSingleItem.layoutInfo?.[0])) {
        uniqueSingleItem.layoutInfo?.[0].forEach(item => subCardIdList.push(item.infoId ?? ''));
      }
      uniqueSingleObject = {
        FormStackId: uniqueSingleItem.infoId,
        subCardIdList: subCardIdList
      } as IBaseInfo;
      return uniqueSingleObject;
    }
    // 处理快捷方式
    if (uniqueSingleItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      uniqueSingleObject = {
        bundleName: uniqueSingleItem.bundleName,
        abilityName: uniqueSingleItem.abilityName,
        infoName: uniqueSingleItem.infoName,
        appIndex: uniqueSingleItem.appIndex,
        shortcutId: uniqueSingleItem.shortcutId
      } as IBaseInfo;
      return uniqueSingleObject;
    }
    return uniqueSingleObject;
  }

  /**
   * 根据类型返回相应打印对象，该方法只用于桌面缓存数据打印
   *
   * @param desktopLayoutItem 桌面缓存对象
   * @returns 桌面元素打印对象
   */
  public static getDesktopLayoutObject(desktopLayoutItem: GridLayoutItemInfo): Object {
    let desktopLayoutObject: Object = {} as IBaseInfo;
    if (CheckEmptyUtils.isEmpty(desktopLayoutItem)) {
      return desktopLayoutObject;
    }
    // 处理应用、分身、快捷方式
    if (desktopLayoutItem.typeId === CommonConstants.TYPE_APP ||
      desktopLayoutItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      desktopLayoutObject = {
        keyName: desktopLayoutItem.keyName,
        appStatus: desktopLayoutItem.appStatus,
        appName: desktopLayoutItem.appName,
        position: [desktopLayoutItem.page, desktopLayoutItem.row, desktopLayoutItem.column]
      } as IBaseInfo;
      return desktopLayoutObject;
    }
    // 处理卡片
    if (desktopLayoutItem.typeId === CommonConstants.TYPE_CARD) {
      desktopLayoutObject = {
        cardId: desktopLayoutItem.cardId,
        cardName: desktopLayoutItem.cardName,
        area: desktopLayoutItem.area,
        position: [desktopLayoutItem.page, desktopLayoutItem.row, desktopLayoutItem.column]
      } as IBaseInfo;
      return desktopLayoutObject;
    }
    // 处理文件夹
    if (desktopLayoutItem.typeId === CommonConstants.TYPE_FOLDER) {
      let subItemLength: number = 0;
      if (!CheckEmptyUtils.isEmptyArr(desktopLayoutItem.layoutInfo?.[0])) {
        subItemLength = desktopLayoutItem.layoutInfo?.[0].length ?? 0;
      }
      desktopLayoutObject = {
        folderId: desktopLayoutItem.folderId,
        folderName: desktopLayoutItem.folderName,
        subItemLength: subItemLength,
        area: desktopLayoutItem.area,
        position: [desktopLayoutItem.page, desktopLayoutItem.row, desktopLayoutItem.column]
      } as IBaseInfo;
      return desktopLayoutObject;
    }
    // 处理堆叠卡片
    if (desktopLayoutItem.typeId === CommonConstants.TYPE_FORM_STACK) {
      let subCardIdList: string[] = [];
      if (!CheckEmptyUtils.isEmptyArr(desktopLayoutItem.layoutInfo?.[0])) {
        desktopLayoutItem.layoutInfo?.[0].forEach(item => subCardIdList.push(item.infoId ?? ''));
      }
      desktopLayoutObject = {
        FormStackId: desktopLayoutItem.formStackId,
        subCardIdList: subCardIdList,
        position: [desktopLayoutItem.page, desktopLayoutItem.row, desktopLayoutItem.column]
      } as IBaseInfo;
      return desktopLayoutObject;
    }
    desktopLayoutObject = {
      keyName: desktopLayoutItem.keyName,
      typeId: desktopLayoutItem.typeId,
      position: [desktopLayoutItem.page, desktopLayoutItem.row, desktopLayoutItem.column]
    } as IBaseInfo;
    return desktopLayoutObject;
  }

  /**
   * 根据类型返回相应打印对象，该方法只用于dock区的缓存数据打印
   *
   * @param dockItem dock区缓存对象
   * @returns dock打印对象
   */
  public static getDockCacheObject(dockItem: DockItemInfo): Object {
    let dockItemObject: Object = {} as IBaseInfo;
    if (CheckEmptyUtils.isEmpty(dockItem)) {
      return dockItemObject;
    }
    // 处理文件夹
    if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
      let subKeyNameList: string[] = [];
      if (!CheckEmptyUtils.isEmptyArr(dockItem.layoutInfo?.[0])) {
        dockItem.layoutInfo?.[0].forEach(item => subKeyNameList.push(item.keyName ?? ''));
      }
      dockItemObject = {
        folderId: dockItem.bundleName,
        subKeyNameList: subKeyNameList,
        column: dockItem.column
      } as IBaseInfo;
      return dockItemObject;
    }
    // 处理应用、分身、快捷方式等
    dockItemObject = {
      keyName: dockItem.keyName,
      appName: dockItem.appName,
      appStatus: dockItem.appStatus,
      column: dockItem.column
    } as IBaseInfo;
    return dockItemObject;
  }
}

export interface IBaseInfo {
  bundleName?: string;
  abilityName?: string;
  infoName?: string;
  appIndex?: number;
  cardName?: string;
  cardId?: string;
  folderId?: string;
  folderName?: string;
  subBundleNameList?: string[];
  intent?: string;
  FormStackId?: string;
  subCardIdList?: string[];
  shortcutId?: string;
  position?: (number | undefined)[];
  area?: number[];
  subItemLength?: number;
  typeId?: number;
  keyName?: string;
  column?: number;
  subKeyNameList?: string[];
  appStatus?: number;
  appName?: string;
}