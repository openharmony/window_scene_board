/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { GridLayoutItemInfo } from '@ohos/launchercommon';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils
} from '@ohos/basicutils';
import FeatureConstants from './constants/FeatureConstants';

const TAG = 'DesktopSortUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class DesktopSortUtils {

  /**
   * 升序: 升序比较两个APP/文件/文件夹的名称；
   * 降序：与升序相反
   * @param items
   * @param isAscend 是否升序排列
   * @returns
   */
  public static sortItemsByName(items: GridLayoutItemInfo[], isAscend: boolean, isApp: boolean): GridLayoutItemInfo[] {
    if (items.length < FeatureConstants.MIN_NEED_SORT_LEN) {
      return items;
    }

    let newGridLayoutItems: GridLayoutItemInfo[] = items;
    newGridLayoutItems.sort((item1: GridLayoutItemInfo, item2: GridLayoutItemInfo) => {
      if (!item1 || !item2) {
        log.showWarn('sortItemsByName compareGridLayout failure as item is null');
        return 0;
      }
      let nameGap: number = 0;
      if (isApp) {
        nameGap = item1.appName?.localeCompare(item2.appName ?? '', 'zh') ?? 0;
      } else {
        nameGap = item1.fileFolderName?.localeCompare(item2.fileFolderName ?? '', 'zh') ?? 0;
      }
      return isAscend ? nameGap : -nameGap;
    });
    return newGridLayoutItems;
  }

  /**
   * 升序: 升序比较两个文件的修改日期，如果修改日期相同则降序比较名称，如果名称相同则降序比较大小；
   * 降序：与升序相反
   * @param items
   * @param isAscend 是否升序排列
   * @returns
   */
  public static sortItemsByModifiedTime(items: GridLayoutItemInfo[], isAscend: boolean): GridLayoutItemInfo[] {
    if (items.length < FeatureConstants.MIN_NEED_SORT_LEN) {
      return items;
    }
    let newGridLayoutItems: GridLayoutItemInfo[] = items;
    newGridLayoutItems.sort((item1: GridLayoutItemInfo, item2: GridLayoutItemInfo) => {
      if (!item1 || !item2) {
        log.showWarn('sortItemsByModifiedTime compareGridLayout failure as item is null');
        return 0;
      }
      let timeGap: number = (item1.mtime ?? 0) - (item2.mtime ?? 0);
      let compareRes: number = timeGap;
      if (compareRes === 0) {
        let nameGap: number = item2.fileFolderName?.localeCompare(item1.fileFolderName ?? '', 'zh') ?? 0;
        compareRes = (nameGap === 0 ? ((item2.size ?? 0) - (item1.size ?? 0)) : nameGap);
      }
      return isAscend ? compareRes : -compareRes;
    });
    return newGridLayoutItems;
  }

  /**
   * 升序: 升序比较两个文件的创建日期，如果创建日期相同则降序比较名称，如果名称相同则降序比较大小;
   * 降序：与升序相反
   * @param items
   * @param isAscend 是否升序排列
   * @returns
   */
  public static sortItemsByCreatedTime(items: GridLayoutItemInfo[], isAscend: boolean): GridLayoutItemInfo[] {
    if (items.length < FeatureConstants.MIN_NEED_SORT_LEN) {
      return items;
    }
    let newGridLayoutItems: GridLayoutItemInfo[] = items;
    newGridLayoutItems.sort((item1: GridLayoutItemInfo, item2: GridLayoutItemInfo) => {
      if (!item1 || !item2) {
        log.showWarn('sortItemsByCreatedTime compareGridLayout failure as item is null');
        return 0;
      }
      let timeGap: number = (item1.ctime ?? 0) - (item2.ctime ?? 0);
      let compareRes: number = timeGap;
      if (compareRes === 0) {
        let nameGap: number = item2.fileFolderName?.localeCompare(item1.fileFolderName ?? '', 'zh') ?? 0;
        compareRes = (nameGap === 0 ? ((item1.size ?? 0) - (item2.size ?? 0)) : nameGap);
      }
      return isAscend ? compareRes : -compareRes;
    });
    return newGridLayoutItems;
  }

  /**
   * 升序: 升序比较两个文件的大小，如果大小相同则升序比较名称，如果名称相同则降序比较修改时间;
   * 降序：与升序相反
   * @param items
   * @param isAscend 是否升序排列
   * @returns
   */
  public static sortItemsBySize(items: GridLayoutItemInfo[], isAscend: boolean): GridLayoutItemInfo[] {
    if (items.length < FeatureConstants.MIN_NEED_SORT_LEN) {
      return items;
    }
    let newGridLayoutItems: GridLayoutItemInfo[] = items;
    newGridLayoutItems.sort((item1: GridLayoutItemInfo, item2: GridLayoutItemInfo) => {
      if (!item1 || !item2) {
        log.showWarn('sortItemsBySize compareGridLayout failure as item is null');
        return 0;
      }
      let sizeGap: number = (item1.size ?? 0) - (item2.size ?? 0);
      let compareRes: number = sizeGap;
      if (compareRes === 0) {
        let nameGap: number = item1.fileFolderName?.localeCompare(item2.fileFolderName ?? '', 'zh') ?? 0;
        compareRes = (nameGap === 0 ? ((item2.mtime ?? 0) - (item1.mtime ?? 0)) : nameGap);
      }
      return isAscend ? compareRes : -compareRes;
    });
    return newGridLayoutItems;
  }

  public static getFileExtension(fileName: string): string {
    let index = fileName?.lastIndexOf('.');
    return index === -1 ? '' : fileName?.substring(index + 1);
  }

  /**
   * 升序: 升序比较两个文件的后缀名，如果后缀名相同则升序比较名称，如果名称相同则降序比较修改时间； 降序：与升序相反
   * 升序时，按照有后缀文件、无后缀文件排列；降序时，按照无后缀文件、有后缀文件排列
   * @param items
   * @param isAscend 是否升序排列
   * @returns
   */
  public static sortItemsByType(items: GridLayoutItemInfo[], isAscend: boolean): GridLayoutItemInfo[] {
    if (items.length < FeatureConstants.MIN_NEED_SORT_LEN) {
      return items;
    }
    let newGridLayoutItems: GridLayoutItemInfo[] = items;
    newGridLayoutItems.sort((item1: GridLayoutItemInfo, item2: GridLayoutItemInfo) => {
      return DesktopSortUtils.compareItem(item1, item2, isAscend);
    });
    return newGridLayoutItems;
  }

  private static compareItem(item1: GridLayoutItemInfo, item2: GridLayoutItemInfo, isAscend: boolean): number {
    if (!item1 || !item2) {
      log.showWarn('sortItemsByType compareGridLayout failure as item is null');
      return 0;
    }
    const fileExtension1: string = DesktopSortUtils.getFileExtension(item1.fileFolderName ?? '');
    const fileExtension2: string = DesktopSortUtils.getFileExtension(item2.fileFolderName ?? '');
    if ((!CheckEmptyUtils.checkStrIsEmpty(fileExtension1)) && CheckEmptyUtils.checkStrIsEmpty(fileExtension2)) {
      return isAscend ? -1 : 1;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(fileExtension1) && (!CheckEmptyUtils.checkStrIsEmpty(fileExtension2))) {
      return isAscend ? 1 : -1;
    }
    let typeGap: number = fileExtension1?.localeCompare(fileExtension2, 'zh');
    let compareRes: number = typeGap;
    if (compareRes === 0) {
      let nameGap: number = item1.fileFolderName?.localeCompare(item2.fileFolderName ?? '', 'zh') ?? 0;
      compareRes = (nameGap === 0 ? ((item2.mtime ?? 0) - (item1.mtime ?? 0)) : nameGap);
    }
    return isAscend ? compareRes : -compareRes;
  }
}