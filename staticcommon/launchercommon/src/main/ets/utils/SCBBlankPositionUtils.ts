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

import { LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  DeliverUtil,
  LaunchLayoutCacheManager,
  LayoutDescription,
  layoutLockUtil,
  PageInfoManager,
  StyleConstants
} from '../TsIndex';
const START_FIND_POSITION = 1;
const START_FIND_POSITION_BIG_FOLD = 2;
const START_FIND_POSITION_THREE_FOLD = 3;
const ROW_OFFSET_THREE = 3;
const TAG = 'SCBBlankPositionUtils';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 桌面找空白位帮助类
 */
export class SCBBlankPositionUtils {
  /**
   * 获取开始找空位的起始页
   *
   * @returns 开始找空位的起始页
   */
  public getFindBlankStartPage(maxPage: number, isOuter?: boolean): number {
    // 从第二屏开始查找空白位置
    let startFindPage: number = maxPage === 1 ? 0 : START_FIND_POSITION;
    // 三折屏设备找位规则
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      let displayCount: number = PageInfoManager.getInstance().getDisplayCount();
      if (displayCount === StyleConstants.DEFAULT_3) {
        startFindPage = START_FIND_POSITION_THREE_FOLD;
      } else if (displayCount === StyleConstants.DEFAULT_2) {
        startFindPage = START_FIND_POSITION_BIG_FOLD;
      }
    } else if (DeviceHelper.isFoldButNotSmallFoldAndSingleDisplay()) {
      // 大折叠从第三屏开始查找，保持布局美观
      startFindPage = START_FIND_POSITION_BIG_FOLD;
    }
    // 折叠PC从第0页开始找
    if (DeviceHelper.isSuperFoldMachine()) {
      startFindPage = 0;
    }
    let lockedPageNum: number =
      layoutLockUtil.isLocked('install app') ? layoutLockUtil.getLockedPageNum(isOuter ?? false) : 0;
    return Math.max(startFindPage, lockedPageNum);
  }


  /**
   * 适配主屏页业务的找位逻辑，确定起始页
   *
   * @returns 开始找空位的起始页
   */
  public getStartFindPageByHomePage(maxPage: number, isOuter?: boolean): number {
    // 从第二屏开始查找空白位置
    let startFindPage: number = maxPage === 1 ? 0 : START_FIND_POSITION;
    let homePageIndex: number = PageInfoManager.getInstance().getHomePageIndex();
    // 每屏显示的页数
    let displayCount = PageInfoManager.getInstance().getDisplayCount();
    //基于不同形态设备，分别在当前形态设置的主屏的下一大屏找位
    if (displayCount > 1) {
      startFindPage = Math.floor(homePageIndex / displayCount) * displayCount + displayCount;
    } else {
      startFindPage = homePageIndex + displayCount;
    }
    // 折叠PC从第0页开始找
    if (DeviceHelper.isSuperFoldMachine()) {
      startFindPage = 0;
    }
    let lockedPageNum: number = layoutLockUtil.isLocked('install app') ?
      layoutLockUtil.getLockedPageNum(isOuter ?? false) : 0;
    return Math.max(startFindPage, lockedPageNum);
  }

  /**
   * 查找桌面空白页
   * @returns
   */
  public findBlankPosition(isOuter?: boolean, bundleName?: string): DesktopPosition {
    let desktopPosition: DesktopPosition = new DesktopPosition();
    let layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription(isOuter);
    if (!layoutDescription) {
      log.showError(TAG, 'findBlankPosition invalid layoutDescription');
      return desktopPosition;
    }
    desktopPosition.maxColumn = layoutDescription.column;
    desktopPosition.maxRow = layoutDescription.row;
    // 从第二屏开始查找空白位置
    let startFindPage: number = this.getStartFindPageByHomePage(layoutDescription.maxPage, isOuter);
    // zyt预置应用首次开机的找位规则
    if (!layoutLockUtil.isLocked('install app') && DeliverUtil.CANCEL_DELIVER_FOLDER &&
      DeliverUtil.DELIVER_PREINSTALLED_APP_SET.has(bundleName) && PageInfoManager.getInstance().getHomePageIndex() === 0) {
      if (DeviceHelper.isLargeInFoldProduct()) {
        startFindPage = NumberConstants.CONSTANT_NUMBER_TWO;
      } else if (DeviceHelper.isThreeFoldProduct()) {
        startFindPage = NumberConstants.CONSTANT_NUMBER_THREE;
      } else {
        startFindPage = NumberConstants.CONSTANT_NUMBER_ONE;
      }
    }
    log.showInfo(TAG, 'findBlankPosition from[%{public}d] -> to[%{public}d]', startFindPage, layoutDescription.maxPage);
    for (let i = startFindPage; i < startFindPage + layoutDescription.maxPage; i++) {
      desktopPosition.page = i % layoutDescription.maxPage;
      if (this.findBlankPositionPage(desktopPosition, false)) {
        return desktopPosition;
      }
    }
    // 超过18屏，放到startFindPage中的文件夹中
    desktopPosition.page = startFindPage;
    desktopPosition.isFind = false;
    return desktopPosition;
  }

  /**
   * 检查当前页是不是有空余位置
   * @param desktopPosition
   * @param isOuter
   * @returns
   */
  private findBlankPositionPage(desktopPosition: DesktopPosition, isOuter?: boolean): boolean {
    let rowOffset: number = 0;
    if (DeviceHelper.isPad() && desktopPosition.page === 0) {
      rowOffset = ROW_OFFSET_THREE;
    }
    let cacheManager = LaunchLayoutCacheManager.getInstance();
    for (let row = rowOffset; row < desktopPosition.maxRow; row++) {
      for (let column = 0; column < desktopPosition.maxColumn; column++) {
        if (cacheManager.isFindBlankPositionPage([desktopPosition.areaX, desktopPosition.areaY],
          desktopPosition.page, column, row, isOuter)) {
          log.showInfo(TAG, 'findBlankPositionPage page:%{public}d row:%{public}d column:%{public}d result: true',
            desktopPosition.page, row, column);
          desktopPosition.row = row;
          desktopPosition.column = column;
          desktopPosition.isFind = true;
          return true;
        }
      }
    }
    log.showInfo(TAG, 'findBlankPosition page:%{public}d result: false', desktopPosition.page);
    return false;
  }
}

/**
 * 桌面位置信息
 */
export class DesktopPosition {
  private _page: number = 0;
  private _column: number = 0;
  private _row: number = 0;
  private _maxColumn: number = 1;
  private _maxRow: number = 1;
  private _areaX: number = 1;
  private _areaY: number = 1;
  private _isFind: boolean = false;

  public set page(value: number) {
    this._page = value;
  }

  public get page(): number {
    return this._page;
  }

  public set column(value: number) {
    this._column = value;
  }

  public get column(): number {
    return this._column;
  }

  public set row(value: number) {
    this._row = value;
  }

  public get row(): number {
    return this._row;
  }

  public set maxColumn(value: number) {
    this._maxColumn = value;
  }

  public get maxColumn(): number {
    return this._maxColumn;
  }

  public set maxRow(value: number) {
    this._maxRow = value;
  }

  public get maxRow(): number {
    return this._maxRow;
  }

  public set areaX(value: number) {
    this._areaX = value;
  }

  public get areaX(): number {
    return this._areaX;
  }

  public set areaY(value: number) {
    this._areaY = value;
  }

  public get areaY(): number {
    return this._areaY;
  }

  public set isFind(value: boolean) {
    this._isFind = value;
  }

  public get isFind(): boolean {
    return this._isFind;
  }
}

export const scbBlankPositionUtils: SCBBlankPositionUtils = SingletonHelper.getInstance(SCBBlankPositionUtils, TAG);