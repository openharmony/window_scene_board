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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  editModeManager,
  CommonConstants,
  GridLayoutItemInfo,
  AppListInfo,
  AppItemInfo,
  CardItemInfo,
  DefaultDesktopLayoutInfo
} from '../TsIndex';
import { DeviceHelper, HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper';

const APP_AREA_SIZE = [1, 1];
const CARD_2_SIZE = 2;
const OUTER_LAYOUT_SIZE = 4;
const ADD_ICON_APP_STORAGE_NAME = 'isShowOuterAddAppIcon';
const IS_DELETE_OUTER_APP = 'isDeleteOuterApp';
const DEFAULT_MAX_PAGE_COUNT = 18;
// 打点参数
const PNAMEID: string = 'com.ohos.sceneboard';
const PVERSIONID: string = 'sceneBoard';
const LAUNCHER_OUTER_ADD_ICON_EVENT: string = 'LAUNCHER_OUTER_ADD_ICON_EVENT';

const TAG: string = 'OuterAddAppIconManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * +号图标打点参数
 */
interface ReportParams {
  // 进程包名
  PNAMEID: string;
  // 进程名
  PVERSIONID: string;
}

class IconPositionInfo {
  public page: number = 0;
  public row: number = 0;
  public column: number = 0;
}

class LastPageInfo {
  public appList: GridLayoutItemInfo[] = [];
  public pageIndex: number = 0;
}

/**
 * 新形态小折叠外屏+号管理类
 */
export class OuterAddAppIconManager {
  private needAddAppPageIndex: number = 0;
  private isNeedDelBlackPage: boolean = false;
  private addIconBeforeApp: GridLayoutItemInfo | null | undefined;
  private maxPageCount: number =
    DefaultDesktopLayoutInfo.getDefaultLayoutInfo()?.layoutDescription?.maxPage ?? DEFAULT_MAX_PAGE_COUNT;
  private mOuterHomeReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.OUTER_HOME_UE);
  private isOccupiedArr: string[][] = [];
  private lastAppBundleName: string | undefined;
  private isOnlyRelyBundleName: boolean = false;

  constructor() {
  }

  /**
   * 获取最后一个App所在尾部位置
   *
   * @param 页面信息
   * @returns Array [结束行,结束列]
   */
  private getLastAppPosition(appList: GridLayoutItemInfo[]): [number, number] {
    this.isOnlyRelyBundleName = false;
    if (appList.length === 0) {
      this.addIconBeforeApp = null;
      this.lastAppBundleName = '';
      return [0, 0];
    }
    let endRow = 0;
    let endColumn = 0;
    this.isOccupiedArr = Array(OUTER_LAYOUT_SIZE).fill(null).map(() =>
      Array(OUTER_LAYOUT_SIZE).fill('')
    );
    this.addIconBeforeApp = appList[appList.length - 1];
    this.lastAppBundleName = this.addIconBeforeApp?.bundleName;

    appList.forEach((appInfo: GridLayoutItemInfo) => {
      if (this.isAddAppIcon(appInfo)) {
        return;
      }
      // postion [行, 列]
      let curStartPost: [number, number] = [appInfo.row ?? 0, appInfo.column ?? 0];
      let curEndColumn = curStartPost[1] + (appInfo.area?.[0] ?? 0);
      let curEndRow = curStartPost[0] + (appInfo.area?.[1] ?? 0);

      if (curEndRow > endRow || (curEndRow === endRow && curEndColumn > endColumn)) {
        endRow = curEndRow;
        endColumn = curEndColumn;
        this.addIconBeforeApp = appInfo;
        this.lastAppBundleName = appInfo.bundleName;
      }

      // 更新被占据的位置
      for (let row = curStartPost[0]; row < curEndRow; row++) {
        for (let col = curStartPost[1]; col < curEndColumn; col++) {
          this.isOccupiedArr[row][col] = appInfo.bundleName;
        }
      }
    });
    // 特殊情况
    let updatePostion: [number, number] | undefined = this.getCardSpecialPostion([endRow, endColumn]);
    if (updatePostion) {
      log.showInfo(`update [${endRow}, ${endColumn}] to ${updatePostion}`);
      endRow = updatePostion[0];
      endColumn = updatePostion[1];
    }
    return [endRow, endColumn];
  }

  /**
   * 判断该应用是否为2*2卡片
   *
   * @param appInfo
   * @returns true/false
   */
  private isCardSize2(appInfo: GridLayoutItemInfo): boolean {
    if (!appInfo || !appInfo.area || appInfo.area.length < 2) {
      log.showInfo(`Get addIconBeforeApp area size failed.`);
      return false;
    }
    return (appInfo.area?.[0] === CARD_2_SIZE && appInfo.area?.[1] === CARD_2_SIZE);
  }

  /**
   * 若最后一个占位为2*2卡片，列举特殊情况并更新位置
   *
   * @param endPostion
   * @returns new endPostion
   */
  private getCardSpecialPostion(endPostion: [number, number]): [number, number] | undefined {
    if (!this.addIconBeforeApp) {
      return undefined;
    }
    // 若最后一个不为2*2卡片，或+号位置需要换行，直接返回
    if (!this.isCardSize2(this.addIconBeforeApp) || endPostion[1] === OUTER_LAYOUT_SIZE) {
      return undefined;
    }
    // 判断2*2卡片右侧1/2号位是否还有app
    let rightIPostion: [number, number] = [endPostion[0] - 2, endPostion[1]];
    let rightIIPostion: [number, number] = [endPostion[0] - 2, endPostion[1] + 1];
    // 若右侧2号位有App
    if (rightIIPostion[1] < OUTER_LAYOUT_SIZE && this.isOccupiedArr[rightIIPostion[0]][rightIIPostion[1]]) {
      this.lastAppBundleName = this.isOccupiedArr[rightIIPostion[0]][rightIIPostion[1]];
      return undefined;
    }
    log.showInfo(`This endPostion is 2*2 card. Update endPositon.`);
    // 若右侧1号位有App
    if (this.isOccupiedArr[rightIPostion[0]][rightIPostion[1]]) {
      this.lastAppBundleName = this.isOccupiedArr[rightIPostion[0]][rightIPostion[1]];
      if (rightIPostion[1] + 1 === OUTER_LAYOUT_SIZE) {
        return undefined;
      }
      this.isOnlyRelyBundleName = true;
      return [rightIPostion[0] + 1, rightIPostion[1] + 1];
    }
    return [endPostion[0] - 1, endPostion[1]];
  }

  /**
   * 页面尾部位置是否已被占用
   *
   * @param 页面信息
   * @returns boolean true已有app,false无
   */
  private isPageEndHaveApp(appList: GridLayoutItemInfo[]): boolean {
    return appList.some((appInfo: GridLayoutItemInfo) => {
      let curEndColumn = (appInfo.column ?? 0) + (appInfo.area?.[0] ?? 0);
      let curEndRow = (appInfo.row ?? 0) + (appInfo.area?.[1] ?? 0);
      return curEndColumn === OUTER_LAYOUT_SIZE && curEndRow === OUTER_LAYOUT_SIZE && !this.isAddAppIcon(appInfo);
    });
  }

  /**
   * 获取尾部非空白页
   *
   * @param 页面列表
   * @returns LastPageInfo 页面应用列表,页面索引
   */
  private getLastHaveAppPage(pageList: GridLayoutItemInfo[][]): LastPageInfo {
    for (let i = pageList.length - 1; i >= 0; i--) {
      if (pageList[i].length > 0) {
        return { appList: pageList[i], pageIndex: i };
      }
    }
    return { appList: [], pageIndex: 0 };
  }

  /**
   * 计算+号的位置
   *
   * @param pageIndex 最后一个app/卡片所在页索引
   * @param endColumn 最后一个app/卡片右下角所在列
   * @param endRow 最后一个app/卡片右下角所在行
   *
   * @returns +号所在位置
   */
  private getAddIconPosition(pageIndex: number, endColumn: number, endRow: number): IconPositionInfo {
    // 最后一个app在页面尾部,+号需要出现在下一页
    if (endRow === OUTER_LAYOUT_SIZE && endColumn === OUTER_LAYOUT_SIZE) {
      return { page: pageIndex + 1, column: 0, row: 0 };
    }
    // 最后一个app在所在行尾部,+号需要出现在下一行第一位
    if (endRow < OUTER_LAYOUT_SIZE && endColumn === OUTER_LAYOUT_SIZE) {
      return { page: pageIndex, column: 0, row: endRow };
    }
    return { page: pageIndex, column: endColumn, row: endRow - 1 };
  }

  /**
   * 判断app是不是+号
   *
   * @param GridLayoutItemInfo 应用信息
   * @returns boolean true是+号,false不是+号
   */
  public isAddAppIcon(appInfo: GridLayoutItemInfo): boolean {
    return appInfo.typeId === CommonConstants.TYPE_ADD &&
      appInfo.bundleName === CommonConstants.OUTER_ADD_APP_ICON_BUNDLE_NAME;
  }

  /**
   * +号图标打点信息
   *
   */
  public outerAddAppIconReport(): void {
    let params: ReportParams = {
      PNAMEID: PNAMEID,
      PVERSIONID: PVERSIONID
    };
    this.mOuterHomeReportEvent.reportBehavior(LAUNCHER_OUTER_ADD_ICON_EVENT, params);
  }
}

export const outerAddAppIconManager: OuterAddAppIconManager = SingletonHelper.getInstance(OuterAddAppIconManager, TAG);