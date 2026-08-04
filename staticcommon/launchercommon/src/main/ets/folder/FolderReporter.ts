/**
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
import type { DockItemInfo } from '../bean/DockItemInfo';
import type FolderItemInfo from './FolderItemInfo';
import type { FolderAppItemInfo } from './FolderItemInfo';
import type { DragItemPosition } from '@ohos/componentdrag';
import type { RecentBundleMissionInfo } from '../bean/RecentBundleMissionInfo';
import { StyleConstants } from '../constants/StyleConstants';
import { LogDomain, LogHelper, CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import {
  DeliverUtil,
  ResidentLayoutCacheMgr,
  FolderLayoutCacheManager,
  NotHarmonyUtil
} from '../TsIndex';
import { desktopUtil } from '@ohos/componenthelper';
import {
  DeviceHelper,
  HiSysEventUtil,
  FolderSizeModifyBean,
  DragIconIntoFolderBean,
  MoveIconInFolderBean
} from '@ohos/frameworkwrapper';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import { AppStatus, CommonConstants } from '../constants/CommonConstants';
import { AppListInfo, FolderModel } from './FolderModel';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import {
  AppCategoryParams,
  DragIconFromNotHarmonyFolderBean } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import {AppCategoryInfoManager} from '../manager/AppCategoryInfoManager';

const TAG = 'FolderReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CONVERT_RESULT_0 = 'RES: 0, FAILREASON: 0';

/**
 * folder reporter
 */
export class FolderReporter {
  private static instance: FolderReporter;
  private appListInfo: AppListInfo = new AppListInfo();

  private constructor() {
  }

  public isFolderInDock(folderInfo: FolderItemInfo): boolean {
    let resistDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let dockItem: DockItemInfo | undefined = resistDockItems?.find((item: DockItemInfo) => {
      return GridLayoutUtil.isSmallFolder(item) && item?.keyName === folderInfo.folderId;
    });
    if (dockItem) {
      return true;
    }
    return false;
  }

  /**
   *
   * @param folderInfo 文件夹信息
   * @param appListInfo
   */
  public reportCreateFolder(folderInfo: FolderItemInfo, isInDock: boolean, layoutItemInfo: GridLayoutItemInfo): void {
    let folderPosition: string = `SCREENINDEX:${folderInfo?.page}, CELLX:${folderInfo?.row}, CELLY:${folderInfo?.column}, isInDock: ${isInDock ? 1 : 0}`;
    let folderContent: string = `ICONCOUNT:${this.getFolderIconCount(folderInfo?.layoutInfo)}`;
    const catIds = this.extractCatIds(layoutItemInfo);
    HiSysEventUtil.reportCreateSmallFolder(folderInfo?.folderId,
      StyleConstants.DEFAULT_0, StyleConstants.DEFAULT_0, folderContent, folderPosition, catIds.join(','));
  }

  /**
   * 克隆场景文件夹生成打点
   *
   * @param folderInfo 文件夹信息
   * @param appListInfo
   */
  public reportCreateFolderInTransfer(folderInfo: GridLayoutItemInfo, isInDock: boolean): void {
    let folderPosition: string = `SCREENINDEX:${folderInfo?.page}, CELLX:${folderInfo?.row}, CELLY:${folderInfo?.column}, isInDock: ${isInDock ? 1 : 0}`;
    let folderContent: string = `ICONCOUNT:${this.getFolderIconCount(folderInfo?.layoutInfo)}`;
    // 克隆场景生成的文件夹不存在分类id，无需查询
    HiSysEventUtil.reportCreateSmallFolder(folderInfo?.folderId,
      StyleConstants.DEFAULT_0, StyleConstants.DEFAULT_0, folderContent, folderPosition, '');
  }

  /**
   * Extract category IDs from folder layout info
   *
   * @param folderInfo
   */
  private extractCatIds(folderInfo: GridLayoutItemInfo): number[] {
    if (!folderInfo.layoutInfo) {
      return [];
    }
    return folderInfo.layoutInfo
      .flat(2) // Flatten 2D array
      .filter(item => !GridLayoutUtil.isAddIcon(item)) // Filter out add icons
      .map(app => AppCategoryInfoManager.getInstance().readCatIdFromCache(app.bundleName))
      .filter(catId => catId !== undefined) as number[];
  }

  /**
   * 文件夹打点上报，拖拽鸿蒙化应用进入未鸿蒙化文件夹
   *
   * @param dragItemInfo
   * @param endLayoutInfo
   */
  public reportDragIconIntoNotHarmonyFolder(dragItemInfo: GridLayoutItemInfo,
    endLayoutInfo: GridLayoutItemInfo | DockItemInfo, folderId: string): void {
    let folderPositionInDesktop: string = this.getItemPositionInDesktop(endLayoutInfo,
      endLayoutInfo?.container === CommonConstants.CONTAINER_DOCK);
    if (!endLayoutInfo?.layoutInfo) {
      return;
    }
    let iconCount: number = this.getFolderIconCount(endLayoutInfo.layoutInfo);
    let folderPageCount: number = endLayoutInfo.layoutInfo?.length;
    let folderContent: string = `SCREENCOUNT:${folderPageCount}, ICONCOUNT:${iconCount}`;
    let folderType: number = DeliverUtil.getFolderTypeByFolderId(folderId);
    HiSysEventUtil.reportDragIconIntoNotHarmonyFolder(folderPositionInDesktop,
      !GridLayoutUtil.isSmallFolder(endLayoutInfo), folderContent, folderId, folderType);
  }

  /**
   * 文件夹打点上报，拖拽应用进入dock区文件夹
   * @param dragItemInfo
   * @param endLayoutInfo
   */
  public reportDragIconIntoDockFolder(startLayoutInfo: DockItemInfo, endLayoutInfo: DockItemInfo): void {
    if (!endLayoutInfo?.layoutInfo) {
      return;
    }
    let iconCount: number = this.getFolderIconCount(endLayoutInfo.layoutInfo);
    let folderPageCount: number = endLayoutInfo.layoutInfo?.length;
    let folderContent: string = `SCREENCOUNT:${folderPageCount}, SHORTCUTCOUNT:${iconCount}`;
    let folderPositionInDesktop: string = this.getItemPositionInDesktop(endLayoutInfo, true);
    HiSysEventUtil.reportDragIconIntoFolder(startLayoutInfo?.bundleName,
      folderPositionInDesktop, !GridLayoutUtil.isSmallFolder(endLayoutInfo),
      folderContent, endLayoutInfo?.appId);
  }

  /**
   * 文件夹打点上报，拖拽应用进入文件夹
   * @param dragItemInfo
   * @param endLayoutInfo
   */
  public reportDragIconIntoFolder(dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo): void {
    let folderPositionInDesktop: string = this.getItemPositionInDesktop(endLayoutInfo,
      endLayoutInfo?.container === CommonConstants.CONTAINER_DOCK);
    if (!endLayoutInfo?.layoutInfo) {
      return;
    }
    let iconCount: number = this.getFolderIconCount(endLayoutInfo.layoutInfo);
    let folderPageCount: number = endLayoutInfo?.layoutInfo?.length;
    let folderContent: string = `SCREENCOUNT:${folderPageCount}, SHORTCUTCOUNT:${iconCount}`;
    HiSysEventUtil.reportDragIconIntoFolder(dragItemInfo?.bundleName, folderPositionInDesktop,
      !GridLayoutUtil.isSmallFolder(endLayoutInfo), folderContent, endLayoutInfo?.folderId);
  }

  /**
   *
   * 文件夹打点上报 - 拖拽文件夹
   * @param folderItemInfo  拖拽的文件夹
   * @param endPosition  文件夹落位位置
   * @param startIsInDockArea 起拖位置是否在dock区
   * @param endIsInDockArea 拖拽终点位置是否在dock区
   */
  public reportDragFolder(folderItemInfo: GridLayoutItemInfo, startPosition: DragItemPosition | undefined,
    endPosition: DragItemPosition | undefined, startIsInDockArea: boolean, endIsInDockArea?: boolean): void {
    if (!folderItemInfo || !folderItemInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(folderItemInfo.layoutInfo) || !endPosition || !startPosition) {
      log.showError('reportDragFolder invalid param');
      return;
    }
    if (startPosition?.isInDock) {
      startPosition.page = -1;
    }
    let dragStartPositionInDesktop: string = this.getItemPositionInDesktop(startPosition, startIsInDockArea);
    let dragEndPositionInDesktop: string = this.getItemPositionInDesktop(endPosition, endIsInDockArea ?? false);
    let folderContent: string = this.getFolderContent(folderItemInfo?.layoutInfo);
    let folderType: number = DeliverUtil.getFolderTypeByFolderId(folderItemInfo?.folderId ?? '');
    HiSysEventUtil.reportDragFolder(dragStartPositionInDesktop,
      dragEndPositionInDesktop, !GridLayoutUtil.isSmallFolder(folderItemInfo)
      , folderContent, folderItemInfo?.folderId, folderType);
  }

  /**
   * 文件夹打点上报 - 拖拽图标到文件夹外
   *
   * @param dragItemInfo 拖拽图标
   * @param folderItemInfo 文件夹对象
   */
  public reportDragIconFromFolder(dragItemBundleName: string, folderItemInfo: GridLayoutItemInfo): void {
    if (!dragItemBundleName || !folderItemInfo) {
      log.showError('reportDragIconFromFolder: dragItemInfo or folderItemInfo error');
      return;
    }
    log.showDebug('start to reportDragIconFromFolder');
    let isInDock: boolean = false;
    let dragItemType: number | undefined = AppStorage.get<number>('dragItemType');
    if (dragItemType && dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
      isInDock = true;
    }
    let dragIconIntoFolderBean: DragIconIntoFolderBean = new DragIconIntoFolderBean();

    if (!folderItemInfo.layoutInfo) {
      return;
    }
    let iconCount: number = this.getFolderIconCount(folderItemInfo.layoutInfo) - 1;
    let folderPageCount: number = folderItemInfo.layoutInfo.length;
    let folderContent: string = `SCREENCOUNT:${folderPageCount}, SHORTCUTCOUNT:${iconCount}`;
    dragIconIntoFolderBean.folderPositionInDesktop = this.getItemPositionInDesktop(folderItemInfo, isInDock);
    dragIconIntoFolderBean.isCardFolder = !GridLayoutUtil.isSmallFolder(folderItemInfo);
    dragIconIntoFolderBean.folderContent = folderContent;
    dragIconIntoFolderBean.draggingPackageNames = dragItemBundleName;
    dragIconIntoFolderBean.folderId = folderItemInfo.folderId ?? '';
    HiSysEventUtil.reportDragIconFromFolder(dragIconIntoFolderBean);
    log.showDebug('reportDragIconFromFolder: dragIconIntoFolderBean -- %{public}s', dragIconIntoFolderBean);
  }

  /**
   * 文件夹打点上报 - 拖拽图标到未鸿蒙化文件夹外
   *
   * @param dragItemInfo 拖拽图标
   * @param folderItemInfo 文件夹对象
   */
  public reportDragIconFromNotHarmonyFolder(dragItemBundleName: string, folderItemInfo: GridLayoutItemInfo): void {
    if (!dragItemBundleName || !folderItemInfo) {
      log.showError('reportDragIconFromFolder: dragItemInfo or folderItemInfo error');
      return;
    }
    let isInDock: boolean = false;
    let dragItemType: number | undefined = AppStorage.get<number>('dragItemType');
    if (dragItemType && dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
      isInDock = true;
    }
    let dragIconIntoFolderBean: DragIconFromNotHarmonyFolderBean = new DragIconFromNotHarmonyFolderBean();

    if (!folderItemInfo.layoutInfo) {
      return;
    }
    let iconCount: number = this.getFolderIconCount(folderItemInfo.layoutInfo);
    let folderPageCount: number = folderItemInfo.layoutInfo.length;
    let folderContent: string = `SCREENCOUNT:${folderPageCount}, SHORTCUTCOUNT:${iconCount}`;
    dragIconIntoFolderBean.folderPositionInDesktop = this.getItemPositionInDesktop(folderItemInfo, isInDock);
    dragIconIntoFolderBean.isCardFolder = !GridLayoutUtil.isSmallFolder(folderItemInfo);
    dragIconIntoFolderBean.folderContent = folderContent;
    dragIconIntoFolderBean.folderId = folderItemInfo.folderId ?? '';
    dragIconIntoFolderBean.folderType = DeliverUtil.getFolderTypeByFolderId(folderItemInfo?.folderId ?? '');
    HiSysEventUtil.reportDragIconFromNotHarmonyFolder(dragIconIntoFolderBean);
  }

  /**
   * 文件夹打点上报 - 通过菜单方式转换文件夹类型
   *
   * @param removeLayout
   * @param result
   * @param operation
   */
  public reportMenuModifyFolderSize(removeLayout: GridLayoutItemInfo, result: string, operation: string): void {
    if (!removeLayout || !result || !operation) {
      log.showError('reportMenuModifyFolderSize: params error');
      return;
    }
    log.showDebug('start to reportMenuModifyFolderSize');
    // 转换成功时，不论小转大还是大转小，转换后的位置都不会在dock栏
    let isInDock: boolean = false;
    // 转换失败时，
    if (result !== CONVERT_RESULT_0) {
      isInDock = this.isInDock(removeLayout?.bundleName, removeLayout?.abilityName);
    }
    let folderIconPositionDesktop: string = this.getItemPositionInDesktop(removeLayout, isInDock);
    let folderSizeModifyBean: FolderSizeModifyBean = new FolderSizeModifyBean();
    folderSizeModifyBean.operation = operation;
    folderSizeModifyBean.result = result;
    folderSizeModifyBean.folderIconPositionInDesktop = folderIconPositionDesktop;
    if (removeLayout.layoutInfo) {
      folderSizeModifyBean.folderContent = this.getFolderContent(removeLayout.layoutInfo);
    }
    folderSizeModifyBean.folderId = removeLayout.folderId ?? '';
    folderSizeModifyBean.folderType = DeliverUtil.getFolderTypeByFolderId(removeLayout.folderId ?? '');
    HiSysEventUtil.reportMenuModifyFolderSize(folderSizeModifyBean);
    log.showDebug('reportMenuModifyFolderSize: folderSizeModifyBean -- %{public}s', folderSizeModifyBean);
  }

  /**
   * 文件夹打点上报 - 拖拽文件夹内图标移位
   *
   * @param tempGridInfo
   * @param tempArr
   * @param folderId 文件夹Id
   */
  public reportMoveIconInFolder(tempGridInfo: GridLayoutItemInfo, pageIndex: number, dragItemInfo: GridLayoutItemInfo,
    dragItemFolderPosition: number[], endAppPosition: number[], folderId?: string): void {
    if (!tempGridInfo || !dragItemInfo) {
      log.showError('reportMoveIconInFolder: tempGridInfo or dragItemInfo error');
      return;
    }
    log.showDebug('start to reportMoveIconInFolder');
    let isInDock: boolean = false;
    const dragItemType: number | undefined = AppStorage.get<number>('dragItemType');
    if (dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) { // 从dock区文件夹拖出
      isInDock = true;
    }
    if (CheckEmptyUtils.isEmpty(tempGridInfo)) {
      return;
    }
    if (CheckEmptyUtils.isEmpty(dragItemFolderPosition) || dragItemFolderPosition?.length < 2) {
      return;
    }
    let startPosition: string = `SCREENCOUNT: ${tempGridInfo?.layoutInfo?.length}, SCREENINDEX: ${dragItemFolderPosition[2]},` +
      ` CELLX: ${dragItemFolderPosition[0]}, CELLY: ${dragItemFolderPosition[1]}, isInDock: ${isInDock}`;
    let endPosition: string = '';
    if (endAppPosition && endAppPosition?.length >= 2) {
      endPosition = `SCREENCOUNT: ${tempGridInfo?.layoutInfo?.length}, SCREENINDEX: ${pageIndex},` +
        ` CELLX: ${endAppPosition[0]}, CELLY: ${endAppPosition[1]}, isInDock: ${isInDock}`;
    }
    let moveIconInFolderBean: MoveIconInFolderBean = new MoveIconInFolderBean();
    moveIconInFolderBean.folderPositionInDesktop = this.getItemPositionInDesktop(tempGridInfo, isInDock) as string;
    moveIconInFolderBean.isCardFolder = !GridLayoutUtil.isSmallFolder(tempGridInfo);
    if (tempGridInfo.layoutInfo) {
      moveIconInFolderBean.folderContent = this?.getFolderContent(tempGridInfo.layoutInfo) as string;
    }
    moveIconInFolderBean.packageNames = dragItemInfo?.bundleName as string;
    moveIconInFolderBean.folderId = folderId ?? '';
    moveIconInFolderBean.startPosition = startPosition;
    moveIconInFolderBean.endPosition = endPosition;
    let folderType: number = DeliverUtil.getFolderTypeByFolderId(folderId ?? '');
    HiSysEventUtil.reportMoveIconInFolder(moveIconInFolderBean, folderType);
    log.showDebug('reportMoveIconInFolder: moveIconInFolderBean -- %{public}s', moveIconInFolderBean);
  }

  /**
   * 文件夹打开打点
   *
   * @param folderItem 文件夹信息
   * @param isOpenFolder 是否打开文件夹
   */
  public reportFolderOperation(folderItem: FolderItemInfo | GridLayoutItemInfo, isOpenFolder: boolean): void {
    if (!isOpenFolder) {
      return;
    }
    if (!folderItem) {
      log.showError('reportFolderOperation: folderItem error');
      return;
    }
    let iconCount: number = this.getFolderIconCount(folderItem.layoutInfo ?? []);
    let folderPosition: string = this.getItemPositionInDesktop(
      folderItem, folderItem?.container === CommonConstants.CONTAINER_DOCK);
    log.showInfo('in reportFolderOperation open');
    let folderType: number = DeliverUtil.getFolderTypeByFolderId(folderItem.folderId ?? '');
    HiSysEventUtil.reportOpenFolder((folderItem?.layoutInfo as Object[])?.length, iconCount,
      !GridLayoutUtil.isSmallFolder(folderItem), folderType,
      folderPosition, iconCount, folderItem?.folderId);
  }

  /**
   * 文件夹关闭打点
   *
   * @param isCloseFolderAni 是否关闭文件夹动效
   * @param folderItem 文件夹信息
   * @param folderId 文件夹Id
   */
  public reportCloseFolder(isCloseFolderAni: boolean, folderItem: GridLayoutItemInfo, folderId?: string): void {
    if (isCloseFolderAni) {
      if (!folderItem) {
        log.showError('openFolderData error');
        return;
      }
      let folderContent: string = this.getFolderContent(folderItem?.layoutInfo ?? []);
      let folderPositionInDesktop: string = this.getItemPositionInDesktop(folderItem,
        folderItem?.container === CommonConstants.CONTAINER_DOCK);
      let folderType: number = DeliverUtil.getFolderTypeByFolderId(folderId ?? '');
      HiSysEventUtil.reportCloseFolder(folderPositionInDesktop,
        !GridLayoutUtil.isSmallFolder(folderItem), folderContent,
        folderItem?.folderId, folderType);
    }
  }

  /**
   * 上报点击文件夹图标事件
   *
   * @param folderItem 文件夹
   * @param appItem 点击的图标
   */
  public reportClickAppIconInFolderEvent(folderItem: GridLayoutItemInfo, appItem: GridLayoutItemInfo): void {
    let component: string = appItem.bundleName;
    let containerType: string = 'cardFolderClose';
    const screenPageCount: number = FolderLayoutCacheManager.getInstance().selectPageCount();
    let folderPositionInDesktop: string = `SCREENCOUNT: ${screenPageCount} SCREENINDEX: ${folderItem.page}
     CELLX: ${folderItem.column} CELLY: ${folderItem.row} isInDock:false`;
    let column: number = FolderModel.getInstance().getFolderOpenLayout()?.column ?? 0;
    let appIndex: number = 0;
    let appColumn: number = 0;
    let appRow: number = 0;
    if (!folderItem.layoutInfo) {
      return;
    }
    for (let j = 0; j < folderItem.layoutInfo.length; j++) {
      for (let i = 0; i < folderItem.layoutInfo[j].length; i++) {
        if (folderItem.layoutInfo[j][i]?.appIconId === appItem.appIconId) {
          appIndex = j;
          appColumn = i % column;
          appRow = Math.floor(i / column);
        }
      }
    }
    let iconPositionInFolder: string = `SCREENCOUNT: ${folderItem.layoutInfo.length}, SCREENINDEX: ${appIndex},
      CELLX: ${appColumn}, CELLY: ${appRow}, isInDock:false`;
    let itemAppType: number = DeliverUtil.getAppType(appItem);
    // 未鸿蒙化应用增加打点（点亮字段）
    if (itemAppType === DeliverUtil.APPTYPE_COMMON || itemAppType === DeliverUtil.APPTYPE_TYPE_GRAY) {
      HiSysEventUtil.reportClickAppIcon(component, containerType, '-1', folderPositionInDesktop,
        iconPositionInFolder, 'true', 'false', folderItem.folderId, itemAppType, appItem.appIndex, '', '');
    } else if (itemAppType === DeliverUtil.APPTYPE_TYPE_NOTHARMONY &&
      appItem?.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      if (CommonUtils.jsonStrToMap(appItem.intent).get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) !== 1) {
        HiSysEventUtil.reportClickAppIcon(appItem.bundleName, containerType, '-1', folderPositionInDesktop,
          iconPositionInFolder, 'true', 'false', folderItem.folderId, itemAppType, appItem.appIndex, 'false',
          '0');
      } else {
        let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(appItem?.intent);
        let lightData: number = intentMap.get('lightData') as number;
        let timeSpan: number;
        if (lightData) {
          timeSpan = new Date().getTime() - lightData;
        } else {
          timeSpan = -1;
        }
        HiSysEventUtil.reportClickAppIcon(appItem.bundleName, containerType, '-1', folderPositionInDesktop,
          iconPositionInFolder, 'true', 'false', folderItem.folderId, itemAppType, appItem.appIndex, 'true',
          timeSpan.toString());
      }
    } else {
      HiSysEventUtil.reportClickAppIcon(component, containerType, '-1', folderPositionInDesktop, iconPositionInFolder,
        'true', 'false', folderItem.folderId, itemAppType, appItem.appIndex, '', '');
    }
    if (appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      HiSysEventUtil.reportClickShortcut(component, appItem.shortcutId, containerType, '-1', folderPositionInDesktop,
        iconPositionInFolder, folderItem.folderId);
    }
  }

  /**
   * 构造文件夹打点常用参数 FOLDERCONTENT
   *
   * @param layoutInfo 文件夹list（二维数组），每一页为一个数组
   * @returns 拼接后的参数 FOLDERCONTENT
   */
  private getFolderContent(layoutInfo: GridLayoutItemInfo[][] | FolderAppItemInfo[][]): string {
    if (!layoutInfo || layoutInfo.length <= 0) {
      log.showError('getFolderContent: layoutInfo error');
      let emptyStr: string = ' ';
      return emptyStr;
    }
    let iconCount: number = this.getFolderIconCount(layoutInfo);
    let folderPageCount: number = layoutInfo?.length;
    let folderContent: string = `SCREENCOUNT: ${folderPageCount}, SHORTCUTCOUNT: ${iconCount} `;
    return folderContent;
  }

  /**
   * 获取文件夹内图标的数量
   *
   * @param folderItemLayoutInfo
   * @returns 文件夹内图标数量
   */
  private getFolderIconCount(folderItemLayoutInfo: Array<GridLayoutItemInfo[]> |
    FolderAppItemInfo[][]): number {
    let iconCount: number = 0;
    for (let i = 0; i < folderItemLayoutInfo?.length; i++) {
      iconCount += folderItemLayoutInfo[i]?.length;
    }
    return iconCount;
  }

  /**
   * 打点过程中获取PositionInDesktop值
   *
   * @param itemInfo
   * @returns 拼接后的FOLDERPOSITIONINDESKTOP内容
   */
  private getItemPositionInDesktop(itemInfo: GridLayoutItemInfo |
    DragItemPosition | FolderItemInfo | DockItemInfo, isInDock: boolean): string {
    this.appListInfo = AppStorage.get<AppListInfo>(desktopUtil.getAppListInfo()) as AppListInfo;
    let screenPageCount: number = 0;
    if (CheckEmptyUtils.isEmpty(this.appListInfo)) {
      screenPageCount = 0;
    } else {
      screenPageCount = this.appListInfo?.appGridInfo?.length;
    }
    return `SCREENCOUNT:${screenPageCount}, SCREENINDEX:${itemInfo?.page === undefined ? -1 : itemInfo?.page},
     CELLX:${itemInfo?.row}, CELLY:${itemInfo?.column}, isInDock:${isInDock};`;
  }

  /**
   * 打点中判断是否在dock栏
   *
   * @param bundleName
   * @param abilityName
   * @returns
   */
  public isInDock(bundleName: string, abilityName: string): boolean {
    let resistDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let dockItem: DockItemInfo | undefined = resistDockItems?.find((item: DockItemInfo) => {
      return item?.bundleName === bundleName && item?.abilityName === abilityName;
    });
    if (dockItem) {
      log.showDebug(`isInResident ${bundleName}, ${abilityName}, ${dockItem}`);
      return true;
    }
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      log.showDebug('In fold.');
      return false;
    }
    let recentItems: RecentBundleMissionInfo[] | undefined = AppStorage.get('recentList');
    let recentItem: RecentBundleMissionInfo | undefined = recentItems?.find((item: RecentBundleMissionInfo) => {
      return item?.bundleName === bundleName && item?.abilityName === abilityName;
    });
    return recentItem !== null && recentItem !== undefined;
  }

  /**
   *
   * @returns FolderReporter实例
   */
  public static getInstance(): FolderReporter {
    if (CheckEmptyUtils.isEmpty(FolderReporter.instance)) {
      FolderReporter.instance = new FolderReporter();
    }
    return FolderReporter.instance;
  }
}

