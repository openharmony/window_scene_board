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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RealPaddingParam } from '@ohos/componentdrag';
import {
  DragGridParam,
  DragGridPosition,
  DragItemPosition,
  DragPosition,
} from '@ohos/componentdrag';
import { AppGridItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppGridItemInfo';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper';
import { CommonAppGridLayoutUtility } from './CommonAppGridLayoutUtility';
import { FoldedAppGridLayoutUtility } from '../../folded/FoldedAppGridLayoutUtility';

const TAG = 'AppGridLayoutUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class AppGridLayoutUtil {
  private static sInstance: CommonAppGridLayoutUtility | undefined = undefined;
  private static sExtInstance: CommonAppGridLayoutUtility | undefined = undefined;
  private static sInitialized: boolean = false;

  private constructor() {
  }

  /**
   * 有条件实例化
   * @param fold
   */
  public static initInstance(fold: boolean): void {
    if (AppGridLayoutUtil.sInitialized) {
      log.showInfo(`initInstance-repeat-${fold}`);
      return;
    }

    if (fold) {
      AppGridLayoutUtil.sInstance = new FoldedAppGridLayoutUtility();
      AppGridLayoutUtil.sExtInstance = new FoldedAppGridLayoutUtility();
      AppGridLayoutUtil.sInstance.setIsSinglePage(false);
      AppGridLayoutUtil.sExtInstance.setIsSinglePage(false);
    } else {
      AppGridLayoutUtil.sInstance = new CommonAppGridLayoutUtility();
      AppGridLayoutUtil.sExtInstance = new CommonAppGridLayoutUtility();
  }

    AppGridLayoutUtil.sInitialized = true;
    log.showInfo(`initInstance-${fold}`);
  }

  /**
   * 参数取整初始化
   * @param gridParam
   * @param realPadding
   * @param centerX
   * @param centerY
   */
  public static initGridPositionRound(gridParam: DragGridParam, realPadding: RealPaddingParam,
    gridSpace?: number, screenId?: number): void {
    if (screenId === undefined || screenId === 0) {
      AppGridLayoutUtil.sInstance?.initGridParameter(gridParam, realPadding, gridSpace);
    } else {
      AppGridLayoutUtil.sExtInstance?.initGridParameter(gridParam, realPadding, gridSpace);
    }
  }

  /**
   * 根据宫格行列值，获取宫格左上角坐标值
   * @param row
   * @param column
   * @param page
   * @returns
   */
  public static getGridItemPosition(row: number, column: number, page?: number, screenId: number = 0): number[] {
    log.showInfo(`getGridItemPosition screenId: ${screenId}, (${row}, ${column}, ${page})`);
    let newColumn: number = RTLUtil.isRTL() ? ((AppGridLayoutUtil.sInstance?.maxColumnIndex ?? 0) - column) : column;
    let position: DragPosition | undefined = undefined;
    if (screenId === undefined || screenId === 0) {
      position =
        AppGridLayoutUtil.sInstance?.getPosition({
          row: row, column: newColumn
        }, page);
    } else {
      position =
        AppGridLayoutUtil.sExtInstance?.getPosition({
          row: row, column: newColumn
        }, page);
    }
    let x: number = px2vp(Math.floor(vp2px(position?.x ?? 0)));
    let y: number = px2vp(Math.floor(vp2px(position?.y ?? 0)));
    return [x, y];
  }

  /**
   * 查询获取屏幕位置对应的宫格坐标
   * @param x
   * @param y
   * @returns
   */
  public static getRowAndColumn(x: number, y: number, page?: number, screenId?: number): DragGridPosition | undefined {
    log.showInfo('getRowAndColumn');
    if (screenId === undefined || screenId === 0) {
      return AppGridLayoutUtil.sInstance?.getRowAndColumn(x, y, page);
    } else {
      return AppGridLayoutUtil.sExtInstance?.getRowAndColumn(x, y, page);
    }
  }

  /**
   * appItem关键信息
   * @param item
   * @returns
   */
  public static appGridItemToString(item: AppItemInfo): string {
    return item ? `${item.bundleName}-${item.row}-${item.column}-${item.page}` : '';
  }

  /**
   * grid pos 关键信息
   * @param position
   * @returns
   */
  public static appGridPosToString(position: DragItemPosition): string {
    return position ? `x:${position.x}-y:${position.y}-r:${position.row}-c:${position.column}-p:${position.page}` : '';
  }

  /**
   * 布局位置处理
   * @param appListInfo
   * @returns
   */
  public static getGridLayoutOptions(appListInfo: AppItemInfo[], oldColMax?: number,
    newColMax?: number, screenId?: number): GridLayoutOptions | undefined {
    if (screenId === undefined || screenId === 0) {
      return AppGridLayoutUtil.sInstance?.getGridLayoutOptions(appListInfo, oldColMax, newColMax);
    } else {
      return AppGridLayoutUtil.sExtInstance?.getGridLayoutOptions(appListInfo, oldColMax, newColMax);
    }
  }

  public static setExtraPaddingTopOffset(space: number, screenId?: number): void {
    if (screenId === undefined || screenId === 0) {
      return AppGridLayoutUtil.sInstance?.setExtraPaddingTopOffset(space);
    } else {
      return AppGridLayoutUtil.sExtInstance?.setExtraPaddingTopOffset(space);
    }
  }

  public static setIsSinglePage(single: boolean): void {
      return AppGridLayoutUtil.sInstance?.setIsSinglePage(single);
  }

  /**
   *  AppGridItemInfo转AppItemInfo
   * @param itemInfo
   * @returns
   */
  public static fromAppItemInfo(itemInfo: AppGridItemInfo): AppItemInfo {
    let appItemInfo: AppItemInfo = {
      bundleName: itemInfo.bundleName ?? '',
      abilityName: itemInfo.abilityName ?? '',
      moduleName: itemInfo.moduleName,
      shortcutId: itemInfo.shortcutId,
      appIndex: itemInfo.appIndex,
      page: itemInfo.page,
      column: itemInfo.column,
      row: itemInfo.row,
      downloadProgress: itemInfo.downloadProgress,
      appStatus: itemInfo.appStatus,
      callerName: itemInfo.callerName,
      appIconId: 0,
      appName: ''
    };
    return appItemInfo;
  }
}