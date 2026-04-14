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

import { LogDomain, LogHelper, SingletonHelper, Trace } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { HiEditModeEventUtils } from '../hisysevent/HiEditModeEventUtils';
import { HiEditModeDataEnterType, HiEditModeDataExitType } from '../hisysevent/HiEditModeData';
import { LaunchLayoutCacheManager } from '../../cache/layout/LaunchLayoutCacheManager';
import { BusinessType } from '../../constants/CommonConstants';

const TAG: string = 'EditModeReportManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * EditMode大数据打点管理类
 */
export class EditModeReportManager {
  private desktopLayout: GridLayoutItemInfo[] = [];
  private startTimeStamp: number = 0;
  private isLayoutChanged: boolean = false;

  constructor() {
  }

  /**
   * 是否桌面布局改变
   *
   * @returns boolean
   */
  public isLayoutChange(): boolean {
    return this.isLayoutChanged;
  }

  /**
   * 进入标记模式打点
   *
   * @param type
   */
  public reportEnterEditMode(type?: number): void {
    this.startTimeStamp = new Date().getTime();
    try {
      this.desktopLayout = JSON.parse(JSON.stringify(Array.from(
        LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP))));
    } catch {
      log.showError('json parse error.');
    }
    type = type ?? HiEditModeDataEnterType.ENTER_UNKNOWN;
    HiEditModeEventUtils.reportEnterEditMode(type);
  }

  /**
   * 退出编辑模式打点
   *
   * @param type
   */
  public reportLeaveEditMode(type?: number): void {
    this.isLayoutChanged = this.isEditLayoutChange();

    type = type ?? HiEditModeDataExitType.EXIT_UNKNOWN;
    HiEditModeEventUtils.reportExitEditMode(type, {
      ISCHANGED: this.isLayoutChanged,
      DURATION: `${new Date().getTime() - this.startTimeStamp}`
    });

    this.startTimeStamp = 0;
  }

  private isEditLayoutChange(): boolean {
    let curLayoutInfo: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
      .getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);

    let curItemMap: Map<string | number, GridLayoutItemInfo> = new Map();
    let curFolderMap: Map<string, GridLayoutItemInfo> = new Map();

    let preItemMap: Map<string | number, GridLayoutItemInfo> = new Map();
    let preFolderMap: Map<string, GridLayoutItemInfo> = new Map();

    this.classifyLayout(curLayoutInfo, curItemMap, curFolderMap);
    this.classifyLayout(this.desktopLayout, preItemMap, preFolderMap);

    if (this.isChangeLayout(curItemMap, preItemMap) || this.isChangeFolderItems(curFolderMap, preFolderMap)) {
      return true;
    }
    return false;
  }

  private isChangeFolderItems(curFolderMap: Map<string, GridLayoutItemInfo>, preFolderMap: Map<string, GridLayoutItemInfo>): boolean {
    // 遍历每个文件夹
    for (const mEntry of preFolderMap) {
      let preFolder: Array<GridLayoutItemInfo[]> | undefined = mEntry[1].layoutInfo;
      let curFolder: Array<GridLayoutItemInfo[]> | undefined = curFolderMap.get(mEntry[0])?.layoutInfo;
      if (!preFolder || !curFolder) {
        log.showError('The folder is invalid.');
        continue;
      }

      if (preFolder.length !== curFolder.length) {
        // 文件夹中的页数改变
        log.showInfo('Folder page change.');
        return true;
      }

      let curAppMap: Map<string, GridLayoutItemInfo> = new Map();
      let preAppMap: Map<string, GridLayoutItemInfo> = new Map();
      for (let pageIndex = 0; pageIndex < preFolder.length; pageIndex++) {
        // 把该文件夹中的所有页的应用整合到一个map中
        this.classifyLayout(preFolder[pageIndex], preAppMap, undefined);
        this.classifyLayout(curFolder[pageIndex], curAppMap, undefined);
      }
      if (this.isChangeLayout(curAppMap, preAppMap)) {
        // 比较该文件夹中的布局是否有变化
        log.showInfo('Folder items change.');
        return true;
      }
    }
    return false;
  }

  private isChangeLayout(curLayout: Map<string | number, GridLayoutItemInfo>,
                         preLayout: Map<string | number, GridLayoutItemInfo>): boolean {
    if (curLayout.size !== preLayout.size) {
      return true;
    }
    for (const mEntry of preLayout) {
      if (!curLayout.has(mEntry[0]) || !this.isSamePosition(mEntry[1], curLayout.get(mEntry[0]))) {
        return true;
      }
    }

    return false;
  }

  private classifyLayout(layoutInfo: GridLayoutItemInfo[], itemMap: Map<string | number, GridLayoutItemInfo>,
                         folderMap?: Map<string, GridLayoutItemInfo>): void {
    for (let i = 0; i < layoutInfo?.length; i++) {
      let item = layoutInfo[i];
      if (!item) {
        log.showError('The item is invalid.');
        continue;
      }
      if (item.typeId === CommonConstants.TYPE_APP) {
        itemMap.set(item.bundleName, item);
      } else if (item.typeId === CommonConstants.TYPE_CARD) {
        itemMap.set(item.cardId ?? '', item);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        itemMap.set(item.folderId ?? '', item);
        folderMap?.set(item.folderId ?? '', item);
      } else if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
        itemMap.set(item.formStackId ?? '', item);
      }
    }
  }

  private isSamePosition(item1: GridLayoutItemInfo, item2?: GridLayoutItemInfo): boolean {
    return (item1 && item2 && item1.page === item2.page && item1.column === item2.column &&
      item1.row === item2.row) ?? false;
  }
}