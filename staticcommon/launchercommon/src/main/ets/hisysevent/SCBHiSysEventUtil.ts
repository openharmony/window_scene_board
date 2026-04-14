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
import {
  HiSysReportEvent,
  ReportDomain,
  HiSysEventUtil,
  DeviceHelper,
  IconResourceManager
} from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import type { DockItemInfo } from '../bean/DockItemInfo';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import type { DeviceState } from '../constants/CommonConstants';
import { SettingsModel } from '../model/SettingsModel';
import {
  EmptyGridInfoBean,
  FolderStateInfoBean,
  IconGridInfoBean,
  OuterIconGridInfoBean,
  IconGridInfoBeanParams,
  LocationTypes,
  ReportParams,
  ShortcutInfoBeanParams,
  OuterShortcutInfoBean
} from './ReportParams';
import { LaunchLayoutCacheManager } from '../cache/layout/LaunchLayoutCacheManager';

import type {
  DragIconAdjustmentSequenceParams,
  FolderStateInfoParams,
  DesktopRegisterDMSListenerParams,
  DesktopReceiveDMSNoticeParams,
  DesktopShowContinueIconEndParams,
  UserClickContinueIconEventParams,
  TriggerContinueMissionParams
} from './ReportParams';
import { HiSysContinueSceneStageData } from './HiSysData';
import { GridLayoutUtil, ResidentLayoutCacheMgr } from '../TsIndex';

const TAG = 'SCBHiSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * 桌面相关打点工具类
 */
export class SCBHiSysEventUtil {
  // 大文件夹信息
  public static FOLDER_INFORMATION = 'FOLDER_INFORMATION';
  // 图标在单屏内调整顺序
  public static DRAG_ICON_ADJUSTMENT_SEQUENCE = 'DRAG_ICON_ADJUSTMENT_SEQUENCE_UE';

  private static mSCBReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCENE_BOARD_UE);
  private static outerMSCBReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.OUTER_HOME_UE);

  private static mAppContinueReportEvent: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.APP_CONTINUE);

  private static folderWeeklyReportCount: number = 0;
  // 应用接续  事件名称
  private static APPLICATION_CONTINUE_BEHAVIOR = 'APPLICATION_CONTINUE_BEHAVIOR';

  // 快捷方式总数
  private static shortcutIconNums: number = 0;

  /**
   * 桌面_每一屏的网格种类及对应个数(状态点,周报,周日报)
   */
  private static EMPTY_GRID_INFORMATION = 'EMPTY_GRID_INFORMATION';

  /**
   * 桌面图标位置状态点
   */
  private static ICON_GRID_INFORMATION = 'ICON_GRID_INFORMATION';

  /**
   * 新形态小外屏桌面应用详情状态点（图标位置）
   */
  private static OUTER_HOME_ICON_GRID_INFORMATION = 'OUTER_HOME_ICON_GRID_INFORMATION';

  /**
   * 桌面图标位置状态点数据分组个数
   */
  private static ICON_GRID_INFORMATION_GROUP_COUNT: number = 20;

  /**
   * 快捷方式状态点
   */
  private static SHORTCUT_INFORMATION = 'SHORTCUT_INFORMATION_UE';

  /**
   * 外屏快捷方式状态点
   */
  private static OUTER_HOME_SHORTCUT_INFORMATION = 'OUTER_HOME_SHORTCUT_INFORMATION';

  // 特殊文件夹内应用数量
  private static notHarmonyAppNum: number = 0;
  private static easyAppNum: number = 0;

  /**
   * 图标调整顺序
   */
  public static reportDragIconAdjustmentSequence(fromPosition: string, toPosition: string, packageName: string,
    deviceState: DeviceState, type: number, mode: number, isShortcut: boolean): void {
    let params: DragIconAdjustmentSequenceParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FROMPOSITION: fromPosition,
      TOPOSITION: toPosition,
      PACKAGENAME: packageName,
      DUALSTATUS: deviceState,
      TYPE: type,
      MODE: mode,
      SCREEN_TYPE: HiSysEventUtil.screenType,
      IS_SHORTCUT: isShortcut
    };
    SCBHiSysEventUtil.mSCBReportEvent.reportBehavior(SCBHiSysEventUtil.DRAG_ICON_ADJUSTMENT_SEQUENCE, params);
  }

  /**
   * 获取桌面、dock区所有的文件夹
   */
  public static folderStateInfoMethod(): void {
    const date: Date = new Date();
    const folderItems: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
      .selectGridLayoutItemsByType(CommonConstants.TYPE_FOLDER);
    folderItems.forEach((folderItem: GridLayoutItemInfo) => {
      SCBHiSysEventUtil.folderStateBeanMethod(date, folderItem, folderItem.folderId ?? '', false);
    });
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    residentList?.forEach((dockFolderItem: DockItemInfo) => {
      if (dockFolderItem && dockFolderItem.typeId === CommonConstants.TYPE_FOLDER) {
        SCBHiSysEventUtil.folderStateBeanMethod(date, dockFolderItem, dockFolderItem.appId ?? '', true);
      }
    });
  }

  private static folderStateBeanMethod(date: Date, item: DockItemInfo | GridLayoutItemInfo, folderId: string,
    isInDock: boolean): void {
    let folderStateInfo: FolderStateInfoBean = new FolderStateInfoBean();
    let mSettingsModel = SettingsModel.getInstance();
    folderStateInfo.serialNum = date.toLocaleDateString()?.trim();
    folderStateInfo.folderId = folderId;
    folderStateInfo.launcherType = 1;
    folderStateInfo.launcherIdType = mSettingsModel.getGridConfig()?.column + '*' + mSettingsModel.getGridConfig()?.row;
    if (item?.area) {
      folderStateInfo.folderIdType = item.area[0] + '*' + item.area[1];
    }
    folderStateInfo.screenCount = LaunchLayoutCacheManager.getInstance().selectPageCount();
    folderStateInfo.screenIndex = item?.page === undefined ? -1 : item?.page;
    folderStateInfo.cellX = item.row ?? 0;
    folderStateInfo.cellY = item.column ?? 0;
    folderStateInfo.isInDock = isInDock;
    // 文件夹内的页数
    folderStateInfo.pageNum = item.layoutInfo?.length ?? 0;
    // 文件夹内的应用总数
    let tempNum = 0;
    item.layoutInfo?.forEach(items => tempNum += items.length);
    folderStateInfo.iconNum = tempNum;
    SCBHiSysEventUtil.reportFolderInfo(folderStateInfo);
  }

  /**
   * 每周日上报文件夹状态信息
   */
  private static reportFolderInfo(folderInfoBean: FolderStateInfoBean): void {
    if (!folderInfoBean) {
      log.showError('folderInfoBean error');
      return;
    }
    let params: FolderStateInfoParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SERIALNUM: folderInfoBean.serialNum,
      FOLDERID: folderInfoBean.folderId,
      LAUNCHERTYPE: folderInfoBean.launcherType,
      LAUNCHERGRIDTYPE: folderInfoBean.launcherIdType,
      FOLDERGRIDTYPE: folderInfoBean.folderIdType,
      ISINDOCK: folderInfoBean.isInDock,
      SCREENCOUNT: folderInfoBean.screenCount,
      SCREENINDEX: folderInfoBean.screenIndex,
      CELLX: folderInfoBean.cellX,
      CELLY: folderInfoBean.cellY,
      PAGENUMBER: folderInfoBean.pageNum,
      ICONNUMBER: folderInfoBean.iconNum,
      FOLDERTYPE: folderInfoBean.folderType
    };
    SCBHiSysEventUtil.folderWeeklyReportCount++;
    SCBHiSysEventUtil.mSCBReportEvent.reportStatistic(SCBHiSysEventUtil.FOLDER_INFORMATION, params);
  }

  /**
   * 桌面向DMS注册接续事件监听打点
   * @param
   */

  public static reportDesktopRegisterDMSListener(func: string, result: number): void {
    log.showInfo(`reportDesktopRegisterDMSListener ${new Date().getTime()}`);
    let params: DesktopRegisterDMSListenerParams = {
      ORG_PKG: ReportParams.PACKAGE_NAME,
      FUNC: func,
      BIZ_SCENE: HiSysContinueSceneStageData.SCENE_SECOND,
      BIZ_STAGE: HiSysContinueSceneStageData.SCENE_SECOND_STAGE_FIRST,
      STAGE_RES: result,
      BIZ_STATE: HiSysContinueSceneStageData.SCENE_END
    };
    SCBHiSysEventUtil.mAppContinueReportEvent.reportBehavior(SCBHiSysEventUtil.APPLICATION_CONTINUE_BEHAVIOR, params);
  }

  /**
   * 桌面接到DMS接续事件通知打点
   * @param ACTIVE/INACTIVE 接续状态
   * @param bundleName
   * @param networkId
   */
  public static reportDesktopReceiveDMSNotice(func: string, scene: number, stage: number, result: number, continueState: string): void {
    log.showInfo(`reportDesktopReceiveDMSNotice ${scene} ${stage} ${new Date().getTime()}`);
    let params: DesktopReceiveDMSNoticeParams = {
      ORG_PKG: ReportParams.PACKAGE_NAME,
      FUNC: func,
      BIZ_SCENE: scene,
      BIZ_STAGE: stage,
      STAGE_RES: result,
      NOTIFY_MODE: continueState
    };
    SCBHiSysEventUtil.mAppContinueReportEvent.reportBehavior(SCBHiSysEventUtil.APPLICATION_CONTINUE_BEHAVIOR, params);
  }

  /**
   * 桌面显示接续图标动效结束位置打点
   */
  public static reportDesktopShowContinueIconEnd(func: string, scene: number, stage: number, result: number): void {
    log.showInfo(`reportDesktopShowContinueIconEnd ${scene} ${stage} ${new Date().getTime()}`);
    let params: DesktopShowContinueIconEndParams = {
      ORG_PKG: ReportParams.PACKAGE_NAME,
      FUNC: func,
      BIZ_SCENE: scene,
      BIZ_STAGE: stage,
      STAGE_RES: result,
      BIZ_STATE: HiSysContinueSceneStageData.SCENE_END
    };
    SCBHiSysEventUtil.mAppContinueReportEvent.reportBehavior(SCBHiSysEventUtil.APPLICATION_CONTINUE_BEHAVIOR, params);
  }

  /**
   * 用户点击接续图标打点
   * @param bundleName
   */
  public static reportUserClickContinueIconEvent(func: string, result: number): void {
    log.showInfo(`reportUserClickContinueIconEvent ${new Date().getTime()}`);
    let params: UserClickContinueIconEventParams = {
      ORG_PKG: ReportParams.PACKAGE_NAME,
      FUNC: func,
      BIZ_SCENE: HiSysContinueSceneStageData.SCENE_TENTH,
      BIZ_STAGE: HiSysContinueSceneStageData.SCENE_TENTH_STAGE_FIRST,
      STAGE_RES: result,
      BIZ_STATE: HiSysContinueSceneStageData.SCENE_START
    };
    SCBHiSysEventUtil.mAppContinueReportEvent.reportBehavior(SCBHiSysEventUtil.APPLICATION_CONTINUE_BEHAVIOR, params);
  }

  /**
   * 触发接续流程打点
   * @param bundleName
   * @param networkId
   */
  public static reportTriggerContinueMission(func: string, anonymousDeviceId: string, result: number): void {
    log.showInfo(`reportTriggerContinueMission ${new Date().getTime()}`);
    let params: TriggerContinueMissionParams = {
      ORG_PKG: ReportParams.PACKAGE_NAME,
      FUNC: func,
      BIZ_SCENE: HiSysContinueSceneStageData.SCENE_TENTH,
      BIZ_STAGE: HiSysContinueSceneStageData.SCENE_TENTH_STAGE_SECOND,
      STAGE_RES: result,
      PEER_NET_ID: anonymousDeviceId
    };
    SCBHiSysEventUtil.mAppContinueReportEvent.reportBehavior(SCBHiSysEventUtil.APPLICATION_CONTINUE_BEHAVIOR, params);
  }

  /**
   * 桌面_每一屏的空网格种类及对应个数(状态点,周报,周日报)
   */
  public static reportEmptyGridInfo(infos: EmptyGridInfoBean[]): void {
    log.showDebug('reportEmptyGridInfo enter');
    if (CheckEmptyUtils.isEmptyArr(infos)) {
      return;
    }
    log.showInfo(`reportEmptyGridInfo length=${infos.length}`);
    SCBHiSysEventUtil.mSCBReportEvent.batchReportStatistic(SCBHiSysEventUtil.EMPTY_GRID_INFORMATION, infos);
  }

  /**
   * 构造外屏桌面图标位置状态点数据
   */
  private static buildOuterIconGridReportParam(beans: IconGridInfoBeanParams[]): OuterIconGridInfoBean[] {
    let res: OuterIconGridInfoBean[] = [];
    if (!CheckEmptyUtils.isEmptyArr(beans)) {
      for (let bean of beans) {
        let reportParam: OuterIconGridInfoBean = new OuterIconGridInfoBean();
        reportParam.SCREENID = bean.SCREENID;
        reportParam.PACKAGENAME = bean.PACKAGENAME;
        reportParam.CELLX = bean.CELLX;
        reportParam.CELLY = bean.CELLY;
        reportParam.LOCATIONTYPE = bean.LOCATIONTYPE;
        reportParam.FOLDERTYPE = bean.FOLDERTYPE;
        reportParam.APPTYPE = bean.APPTYPE;
        reportParam.APPNAME = bean.APPNAME;
        reportParam.NOTHARMONYNUM = SCBHiSysEventUtil.notHarmonyAppNum;
        reportParam.EASYNUM = SCBHiSysEventUtil.easyAppNum;
        res.push(reportParam);
      }
    }
    return res;
  }

  private static doBatchReportIconGridInfo(params: IconGridInfoBeanParams[], isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(params)) {
      return;
    }
    if (isOuter) {
      let reportOuterParams: OuterIconGridInfoBean[] = SCBHiSysEventUtil.buildOuterIconGridReportParam(params);
      SCBHiSysEventUtil.outerMSCBReportEvent.batchReportStatistic(SCBHiSysEventUtil.OUTER_HOME_ICON_GRID_INFORMATION, reportOuterParams);
      log.showInfo(`doBatchReportIconGridInfo params.length=${params.length}, reportOuterParams.length=${reportOuterParams.length}`);
    } else {
      let reportParams: IconGridInfoBean[] = SCBHiSysEventUtil.buildIconGridReportParam(params);
      SCBHiSysEventUtil.mSCBReportEvent.batchReportStatistic(SCBHiSysEventUtil.ICON_GRID_INFORMATION, reportParams);
      log.showInfo(`doBatchReportIconGridInfo params.length=${params.length}, reportParams.length=${reportParams.length}`);
    }
  }

  private static buildAndBatchReportIconGridInfo(isOuter?: boolean): void {
    SCBHiSysEventUtil.notHarmonyAppNum = 0;
    SCBHiSysEventUtil.easyAppNum = 0;
    let beans: IconGridInfoBeanParams[] = [];
    if (!isOuter) {
      const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      residentList?.forEach((dockItem: DockItemInfo) => {
        SCBHiSysEventUtil.buildIconGridInfo(dockItem, beans);
      });
    }
    const gridItems: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getGridLayoutItemList(isOuter);
    gridItems.forEach((desktopItem: GridLayoutItemInfo) => {
      SCBHiSysEventUtil.buildIconGridInfo(desktopItem, beans);
    });
    SCBHiSysEventUtil.doBatchReportIconGridInfo(beans, isOuter);
  }

  private static reportInnerIconGridInfo(): void {
    let isOuter: boolean = false;
    SCBHiSysEventUtil.buildAndBatchReportIconGridInfo(isOuter);
  }

  private static reportOuterIconGridInfo(): void {
    let isOuter: boolean = true;
    SCBHiSysEventUtil.buildAndBatchReportIconGridInfo(isOuter);
  }

  /**
   * 桌面图标位置状态点
   */
  public static reportIconGridInfo(): void {
    SCBHiSysEventUtil.reportInnerIconGridInfo();
  }

  /**
   * 构造桌面图标位置状态点数据
   */
  private static buildIconGridReportParam(beans: IconGridInfoBeanParams[]): IconGridInfoBean[] {
    let res: IconGridInfoBean[] = [];
    // 每组分20个，与大数据沟通好的。
    let paramGroups: IconGridInfoBeanParams[][] =
      SCBHiSysEventUtil.chunkArr(beans, SCBHiSysEventUtil.ICON_GRID_INFORMATION_GROUP_COUNT);
    if (!CheckEmptyUtils.isEmptyArr(paramGroups)) {
      for (let params of paramGroups) {
        let reportParam: IconGridInfoBean = new IconGridInfoBean();
        reportParam.PARAMS = JSON.stringify(params);
        reportParam.NOTHARMONYNUM = SCBHiSysEventUtil.notHarmonyAppNum;
        reportParam.EASYNUM = SCBHiSysEventUtil.easyAppNum;
        res.push(reportParam);
      }
    }
    return res;
  }

  /**
   * 获取appName
   *
   * @param appItem 图标元素 DockItemInfo或GridLayoutItemInfo
   * @returns 应用名
   */
  private static getAppName(appItem: DockItemInfo | GridLayoutItemInfo): string {
    if (appItem.typeId === CommonConstants.TYPE_APP || appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      if (CheckEmptyUtils.isEmpty(appItem.appName)) {
        return IconResourceManager.getInstance().getAppNameByCache(appItem.appLabelId, appItem.bundleName,
          appItem.moduleName, appItem.appName);
      }
      return appItem.appName ?? '';
    }
    return '';
  }

  private static buildIconGridInfo(appItem: DockItemInfo | GridLayoutItemInfo, beans: IconGridInfoBeanParams[]): void {
    if (appItem.typeId === CommonConstants.TYPE_FOLDER) {
      // 文件夹内
      SCBHiSysEventUtil.buildIconGridInfoInFolder(appItem, beans);
    }
  }

  /**
   * 遍历文件夹内元素, 构建图标状态点参数
   *
   * @param appItem 图标元素 DockItemInfo或GridLayoutItemInfo
   */
  private static buildIconGridInfoInFolder(appItem: DockItemInfo | GridLayoutItemInfo,
    beans: IconGridInfoBeanParams[]): void {
    appItem.layoutInfo?.forEach((appItems: GridLayoutItemInfo[]) => {
      appItems.forEach((item: GridLayoutItemInfo) => {
        let folderType: number = -1;
        let locationType = SCBHiSysEventUtil.getLocationType(appItem, item);
        beans.push(SCBHiSysEventUtil.buildIconGridInfoBean(item, appItem, locationType, folderType, -1,
          SCBHiSysEventUtil.getAppName(item)));
      });
    });
  }

  private static chunkArr(arr: IconGridInfoBeanParams[], size: number): IconGridInfoBeanParams[][] {
    if (CheckEmptyUtils.isEmptyArr(arr) || !size || size < 1) {
      return [];
    }
    let start = 0;
    let end = 0;
    let result: IconGridInfoBeanParams[][] = [];
    for (let i = 0; i < Math.ceil(arr.length / size); i++) {
      start = i * size;
      end = start + size;
      result.push(arr.slice(start, end));
    }
    return result;
  }

  private static getLocationType(folder: DockItemInfo | GridLayoutItemInfo,
    floderItem: GridLayoutItemInfo): LocationTypes {
    let locationType = LocationTypes.FLODER;
    if (GridLayoutUtil.isBigFolder(folder)) {
      if (floderItem.page && floderItem.page > 0) {
        locationType = LocationTypes.BIG_FLODER_HIDE;
      } else {
        locationType = LocationTypes.BIG_FLODER;
      }
    }
    return locationType;
  }

  /**
   * 构建图标信息
   *
   * @param appType 应用类型 0-正常应用，可直接打开, 1-未OpenHarmony化应用（未安装）, -1-均不是
   * @param appName 应用名
   */
  private static buildIconGridInfoBean(item: DockItemInfo | GridLayoutItemInfo,
    screenColumnRow: DockItemInfo | GridLayoutItemInfo, locationType: LocationTypes, folderType: number,
    appType: number, appName: string): IconGridInfoBeanParams {
    let params: IconGridInfoBeanParams = {
      SCREENID: screenColumnRow.page ?? 0,
      PACKAGENAME: item.bundleName,
      CELLX: screenColumnRow.column ?? 0,
      CELLY: screenColumnRow.row ?? 0,
      LOCATIONTYPE: locationType,
      FOLDERTYPE: folderType,
      APPTYPE: appType,
      APPNAME: appName,
    };
    return params;
  }

  public static buildAndBatchReportShortcutInfo(isOuter?: boolean): void {
    SCBHiSysEventUtil.shortcutIconNums = 0;
    let beans: ShortcutInfoBeanParams[] = [];
    if (!isOuter) {
      const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      residentList?.forEach((dockItem: DockItemInfo) => {
        SCBHiSysEventUtil.buildShortcutInfo(dockItem, beans);
      });
    }
    const gridItems: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getGridLayoutItemList(isOuter);
    gridItems.forEach((desktopItem: GridLayoutItemInfo) => {
      SCBHiSysEventUtil.buildShortcutInfo(desktopItem, beans);
    });
    SCBHiSysEventUtil.doBatchReportShortcutInfo(beans, isOuter);
  }

  private static reportInnerShortcutInfo(): void {
    let isOuter: boolean = false;
    SCBHiSysEventUtil.buildAndBatchReportShortcutInfo(isOuter);
  }

  private static reportOuterShortcutInfo(): void {
    let isOuter: boolean = true;
    SCBHiSysEventUtil.buildAndBatchReportShortcutInfo(isOuter);
  }

  /**
   * 快捷方式状态点
   */
  public static reportShortcutInfo(): void {
    SCBHiSysEventUtil.reportInnerShortcutInfo();
  }

  /**
   * 快捷方式参数构建
   *
   * @param appItem 图标元素 DockItemInfo或GridLayoutItemInfo
   * @param beans 快捷方式详细信息数组
   */
  private static buildShortcutInfo(appItem: DockItemInfo | GridLayoutItemInfo, beans: ShortcutInfoBeanParams[]): void {
    // 桌面快捷方式
    if (appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      SCBHiSysEventUtil.shortcutIconNums++;
      beans.push(SCBHiSysEventUtil.buildShortcutInfoBean(appItem, appItem,
        appItem.container === CommonConstants.CONTAINER_SMARTDOCK ? LocationTypes.DOCK : LocationTypes.DESKTOP,
        SCBHiSysEventUtil.getAppName(appItem)));
    } else if (appItem.typeId === CommonConstants.TYPE_FOLDER) {
      // 文件夹内
      SCBHiSysEventUtil.buildShortcutInfoInFolder(appItem, beans);
    }
  }

  /**
   * 遍历文件夹内元素构造快捷方式参数
   */
  private static buildShortcutInfoInFolder(appItem: DockItemInfo | GridLayoutItemInfo,
    beans: ShortcutInfoBeanParams[]): void {
    appItem.layoutInfo?.forEach((appItems: GridLayoutItemInfo[]) => {
      appItems.forEach((item: GridLayoutItemInfo) => {
        if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          SCBHiSysEventUtil.shortcutIconNums++;
          let locationType = SCBHiSysEventUtil.getLocationType(appItem, item);
          beans.push(SCBHiSysEventUtil.buildShortcutInfoBean(item, item, locationType, SCBHiSysEventUtil.getAppName(item)));
        }
      });
    });
  }

  /**
   * 快捷方式参数构建
   *
   * @param appItem 图标元素 DockItemInfo或GridLayoutItemInfo
   */
  private static buildShortcutInfoBean(item: DockItemInfo | GridLayoutItemInfo,
    screenColumnRow: DockItemInfo | GridLayoutItemInfo, locationType: LocationTypes,
    shortCutName: string): ShortcutInfoBeanParams {
    let params: ShortcutInfoBeanParams = {
      BUNDLENAME: item.bundleName,
      SHORTCUTNAME: shortCutName,
      PAGENUM: screenColumnRow.page ?? 0,
      COLUMN: screenColumnRow.column ?? 0,
      ROW: screenColumnRow.row ?? 0,
      LOCATIONTYPE: locationType,
      TOTALNUM: 0
    };
    return params;
  }

  /**
   * 快捷方式状态点
   *
   * @param params 快捷方式信息数组
   */
  private static doBatchReportShortcutInfo(params: ShortcutInfoBeanParams[], isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(params)) {
      return;
    }
    if (isOuter) {
      let reportOuterParams: OuterShortcutInfoBean[] = SCBHiSysEventUtil.buildOuterShortcutReportParam(params);
      SCBHiSysEventUtil.outerMSCBReportEvent.batchReportStatistic(SCBHiSysEventUtil.OUTER_HOME_SHORTCUT_INFORMATION, reportOuterParams);
      log.showInfo(`doBatchReportShortcutInfo params.length=${params.length}, reportOuterParams.length=${reportOuterParams.length}`);
    } else {
      for (let param of params) {
        param.TOTALNUM = SCBHiSysEventUtil.shortcutIconNums;
      }
      SCBHiSysEventUtil.mSCBReportEvent.batchReportStatistic(SCBHiSysEventUtil.SHORTCUT_INFORMATION, params);
      log.showInfo(`doBatchReportShortcutInfo params.length=${params.length}, reportParams.length=${params.length}`);
    }
  }

  /**
   * 构造外屏快捷方式状态点数据
   * @param beans 快捷方式详细信息数组
   */
  private static buildOuterShortcutReportParam(beans: ShortcutInfoBeanParams[]): OuterShortcutInfoBean[] {
    let res: OuterShortcutInfoBean[] = [];
    if (!CheckEmptyUtils.isEmptyArr(beans)) {
      for (let bean of beans) {
        let reportParam: OuterShortcutInfoBean = new OuterShortcutInfoBean();
        reportParam.BUNDLENAME = bean.BUNDLENAME;
        reportParam.SHORTCUTNAME = bean.SHORTCUTNAME;
        reportParam.PAGENUM = bean.PAGENUM;
        reportParam.COLUMN = bean.COLUMN;
        reportParam.ROW = bean.ROW;
        reportParam.LOCATIONTYPE = bean.LOCATIONTYPE;
        reportParam.TOTALNUM = SCBHiSysEventUtil.shortcutIconNums;
        res.push(reportParam);
      }
    }
    return res;
  }

}