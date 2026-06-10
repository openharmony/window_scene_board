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

import {
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  LogHelper,
  ObjUtil,
  TraceUtil
} from '@ohos/basicutils/src/main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  AppItemInfo,
  CommonConstants,
  DeviceState,
  DisappearLastAppData,
  DockItemInfo,
  FolderAppItemInfo,
  FolderCommonConstants,
  FolderManager,
  FolderModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LauncherLayoutCacheUtil,
  LaunchLayoutCacheManager,
  LayoutViewModel,
  NotHarmonyUtil,
  PageInfoManager,
  RecentBundleMissionInfo,
  ResidentLayoutCacheMgr,
  SettingsModel,
  SmallFolderCacheManager,
  SmallFolderIconFileUtil,
  SmallFolderRegion,
  StyleConstants
} from '../../../TsIndex';
import { FolderStyleManager } from './FolderStyleManager';
import { FoldersData } from './model/data/FoldersData';
import { SCBScreenSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { desktopUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { AreaSpan } from '../../../utils/GridLayoutUtil';
import { AppCategoryUtils } from '../../../utils/AppCategoryUtils';
import { BadgeManager } from '../../../manager/BadgeManager';
import { BaseBundleInfo } from '../../../bean/BaseBundleInfo';

/**
 * 设置Grid行列的基本单位
 */
const TEMPLATE_UNIT: string = '1fr ';
const HEXADECIMAL_VALUE: number = 36;
const TAG = 'FolderCommonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹公共工具类
 */
export class FolderCommonUtil {
  /**
   * 修改文件夹area的宽度大小
   *
   * @param width 宽度
   * @returns 修改后的宽度
   */
  public static getModifyAreaWidth(width: number): number {
    if (width < AreaSpan.SPAN_2) {
      return AreaSpan.SPAN_1;
    } else if (width < AreaSpan.SPAN_4) {
      return AreaSpan.SPAN_2;
    } else {
      return AreaSpan.SPAN_4;
    }
  }

  /**
   * 修改文件夹area的高度大小
   *
   * @param height 高度
   * @returns 修改后的高度
   */
  public static getModifyAreaHeight(height: number): number {
    if (height < AreaSpan.SPAN_2) {
      return AreaSpan.SPAN_1;
    } else {
      return AreaSpan.SPAN_2;
    }
  }

  /**
   * 根据显示个数获取Grid的模板
   *
   * @param value 显示的个数
   * @returns Grid模板
   */
  public static getTemplate(value: number): string {
    let template: string = '';
    for (let i = 0; i < value; i++) {
      template += TEMPLATE_UNIT;
    }
    return template.trim();
  }

  /**
   * 获取文件夹布局的应用列表，展开态会过滤掉加号
   *
   * @param folder 文件夹
   */
  public static getFilterAppListInFolder(folder: GridLayoutItemInfo,
    filter?: (item: GridLayoutItemInfo) => boolean): GridLayoutItemInfo[] {
    let folderAppList: GridLayoutItemInfo[] = [];
    if (!folder || !folder.layoutInfo) {
      log.showWarn('open folder or its layout shouldn`t be null, do nothing ...');
      return folderAppList;
    }
    for (let i = 0; i < folder.layoutInfo.length; i++) {
      folderAppList = folderAppList.concat(folder.layoutInfo[i]);
    }
    if (filter) {
      folderAppList = folderAppList.filter(item => !GridLayoutUtil.isAddIcon(item) && filter(item));
    } else {
      folderAppList = folderAppList.filter(item => !GridLayoutUtil.isAddIcon(item));
    }
    return folderAppList;
  }

  /**
   * 过滤掉应用列表中的加号
   *
   * @param itemList 应用列表
   * @returns 过滤加号后的列表
   */
  public static getFilterAddIconList(itemList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    return itemList.filter(item => !GridLayoutUtil.isAddIcon(item));
  }

  /**
   * 获取文件夹解散的DisappearData
   *
   * @param folderId 文件夹id
   * @param lastApp 解锁后剩余的应用
   * @param hiddenAppKey 删除图标的keyname
   * @param uninstallApp 解散前移除的未安装的应用
   * @returns
   */
  public static getDisappearFolderData(folderId: string, lastApp: GridLayoutItemInfo | undefined,
    hiddenAppKey: string, uninstallApp?: GridLayoutItemInfo | undefined,): DisappearLastAppData {
    log.showInfo('getDisappearFolderData, folderId=%{public}s', folderId);
    let lastAppKey: string | undefined = (lastApp && lastApp.keyName !== hiddenAppKey) ? lastApp.keyName : '';
    const disappearLastAppData: DisappearLastAppData = {
      folderId: folderId,
      lastAppKeyName: lastAppKey,
      hiddenAppKeyName: hiddenAppKey,
      restApp: lastApp,
      uninstallApp: uninstallApp
    };
    return disappearLastAppData;
  }

  /**
   * 获取文件夹最大应用数量
   */
  public static getMaxAppCount(): number {
    let numPerPage: number = StyleConstants.DEFAULT_FOLDER_OPEN_ROW_SIZE * StyleConstants.DEFAULT_FOLDER_OPEN_COL_SIZE;
    if (DeviceHelper.isFold() || DeviceHelper.isPad()) {
      numPerPage = StyleConstants.DEFAULT_FOLDER_OPEN_ROW_SIZE_EXPENDED * StyleConstants.DEFAULT_FOLDER_OPEN_COL_SIZE;
    }
    return numPerPage * StyleConstants.FOLDER_APP_MAX_PAGES;
  }

  /**
   * 获取展开态每页最大数量
   *
   * @returns
   */
  public static getOpenFolderMaxPerPage(): number {
    let folderModel: FolderModel = FolderModel.getInstance();
    return (folderModel.getFolderOpenLayout()?.column ?? 0) * (folderModel.getFolderOpenLayout()?.row ?? 0);
  }

  /**
   * 获取卸载app弹窗提示内容
   *
   * @param 应用名称
   */
  public static getUninstallDialogName(appName: string): string {
    let strName = (CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device')) ? 'is_delete_form' : 'isUninstall';
    return ResourceManager.getInstance().getStringByName(strName, appName || '');
  }

  /**
   * 获取折叠态文件夹最大显示的图标数量包括堆叠图标
   *
   * @param area 文件夹大小
   * @returns 图标数量
   */
  public static getContractedFolderMaxShowIconNum(area: number[]): number {
    let countInRow: number = FolderStyleManager.getInstance().getCountPerRowInFolder(area);
    let countInCol: number = FolderStyleManager.getInstance().getCountPerColumnInFolder(area);
    if (FolderCommonUtil.isLayout1X1(area)) {
      return countInRow * countInCol;
    }
    return countInRow * countInCol;
  }

  /**
   * 获取折叠态文件夹最大显示的图标数量不包括堆叠图标
   *
   * @param area 文件夹大小
   * @returns 图标数量
   */
  public static getShowIconNumWithoutSuperpose(area: number[]): number {
    let countInRow: number = FolderStyleManager.getInstance().getCountPerRowInFolder(area);
    let countInCol: number = FolderStyleManager.getInstance().getCountPerColumnInFolder(area);
    if (FolderCommonUtil.isLayout1X1(area)) {
      return countInRow * countInCol;
    }
    return countInRow * countInCol - 1;
  }

  /**
   * 生成文件夹id
   *
   * @returns 文件夹id
   */
  public static generateFolderId(): string {
    return new Date().getTime().toString();
  }

  /**
   * 给原始文件夹id添加前缀
   *
   * @param originFolderId 文件夹item
   * @param prefix 卸载元素列表
   * @returns 添加前缀后的文件夹id
   */
  public static transFolderID(originFolderId: string, prefix: string): string {
    return `${prefix}_${originFolderId}`;
  }

  /**
   * 文件夹名字的占位符替换成转换后真实名字
   *
   * @returns 文件夹名字
   */
  public static getRealFolderName(originFolderName: string, folderId?: string): string {
    if (ObjUtil.isInvalid(originFolderName)) {
      log.showWarn('getRealFolderName, originFolderName is invalid');
      return originFolderName;
    }
    let isIntelFolder: boolean = originFolderName.startsWith('#');
    if (isIntelFolder) {
      let realFoldrName = AppCategoryUtils.getIntelFolderName(originFolderName);
      log.showInfo(`getRealFolderName realFoldrName: ${realFoldrName}`);
      if (!CheckEmptyUtils.checkStrIsEmpty(realFoldrName)) {
        return realFoldrName;
      }
    }
    let reg: RegExp = /^\$\{([^{}]+)\}(.*)/;
    let ret: RegExpMatchArray | null = originFolderName.match(reg);
    if (ret) {
      if (folderId) {
        log.showInfo(`getRealFolderName isPresetfolderName folderId: ${folderId}`);
      }
      if (ret.length === 2) {
        return ResourceManager.getInstance().getStringByName(ret[1]);
      } else if (ret.length === 3) {
        return ResourceManager.getInstance().getStringByName(ret[1], parseInt(ret[2]) || 1);
      }
    }
    return originFolderName.trim();
  }

  /**
   * 生成一个随机数字
   */
  public static getUUID(): string {
    let id = Date.now().toString(HEXADECIMAL_VALUE);
    id += Math.random().toString(HEXADECIMAL_VALUE).substr(2);
    return id;
  }

  /**
   * 卸载场景，过滤文件夹中的应用
   *
   * @param folderItem 文件夹item
   * @param uninstallItems 卸载元素列表
   * @param isUninstall 是否卸载场景
   * @returns 过滤后的文件夹列表
   */
  public static filterListAfterUninstall(folderItem: GridLayoutItemInfo,
    uninstallItems: GridLayoutItemInfo[], isUninstall: boolean): GridLayoutItemInfo[] {
    if (!folderItem) {
      return [];
    }
    let items: GridLayoutItemInfo[] = folderItem.layoutInfo?.flat() ?? [];
    let filterList: GridLayoutItemInfo[] = [];
    if (CheckEmptyUtils.isEmptyArr(items)) {
      log.showWarn('the layout of folder %{public}s is empty', folderItem.folderId);
      return filterList;
    }
    if (isUninstall) {
      filterList = items.filter(item => {
        if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          return !FolderCommonUtil.isSameShortcut(item, uninstallItems) && !FolderCommonUtil.isShortcutOfApp(item, uninstallItems);
        } else if (item.typeId === CommonConstants.TYPE_APP) {
          return !FolderCommonUtil.isRelatedApp(item, uninstallItems);
        } else {
          return !GridLayoutUtil.isAddIcon(item);
        }
      });
    } else {
      filterList = items.filter(item => !FolderCommonUtil.isItemInList(item, uninstallItems) && !GridLayoutUtil.isAddIcon(item));
    }
    return filterList;
  }

  private static isItemInList(item: GridLayoutItemInfo, itemList: GridLayoutItemInfo[]): boolean {
    return itemList.findIndex(element => (GridLayoutUtil.generateUniqueKey(item) ===
    GridLayoutUtil.generateUniqueKey(element))) >= 0;
  }

  private static isSameShortcut(shortcut: GridLayoutItemInfo, itemList: GridLayoutItemInfo[]): boolean {
    return itemList.findIndex(item => LauncherLayoutCacheUtil.isSameShortcutApp(shortcut, item.bundleName,
      item.shortcutId ?? '', item.appIndex ?? 0)) >= 0;
  }

  private static isShortcutOfApp(shortcut: GridLayoutItemInfo, itemList: GridLayoutItemInfo[]): boolean {
    return itemList.findIndex(item => item.typeId === CommonConstants.TYPE_APP &&
      item.bundleName === shortcut.bundleName && item.appIndex === shortcut.appIndex) >= 0;
  }

  private static isRelatedApp(appItem: GridLayoutItemInfo, itemList: GridLayoutItemInfo[]): boolean {
    return itemList.findIndex(item => {
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        return GridLayoutUtil.generateUniqueKey(appItem) === GridLayoutUtil.generateUniqueKey(item);
      } else {
        return LauncherLayoutCacheUtil.isRelatedApp(appItem, item);
      }
    }) >= 0;
  }

  /**
   * 文件夹是否支持重命名
   *
   * @param folderId 文件夹id
   * @returns true 支持重命名
   */
  public static isFolderSupportRename(folderId: string): boolean {
    return !NotHarmonyUtil.isNotHarmonyFolderById(folderId);
  }

  /**
   * 文件夹元素是否有足够的落位空间拖拽到桌面
   *
   * @param folderAppList 应用列表
   * @param msg 提示信息
   * @returns true有足够空间落位
   */
  public static isEnoughDropSpace(): boolean {
    let cacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let itemCount: number = cacheManager.selectAllOccupiedSpace();
    let maxSpace: number = cacheManager.selectMaxSpace();
    if (itemCount > maxSpace) {
      return false;
    }
    return true;
  }

  /**
   * 是否文件夹需要解散
   *
   * @param folderAppList 文件夹剩余的应用列表
   * @param folderId 文件夹id
   * @returns true需要解散
   */
  public static isNeedReleased(folderAppList: GridLayoutItemInfo[], folderId: string): boolean {
    return folderAppList.length <= 1 && (folderAppList.length <= 1) &&
      NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderId, folderAppList.length, folderAppList);
  }

  /**
   * bundleName是否在指定元素列表中
   *
   * @param bundleName 应用bundleName
   * @param items 元素列表
   * @returns true 在列表里
   */
  public static isBundleNameInList(bundleName: string, items: GridLayoutItemInfo[]): boolean {
    return items.findIndex(item => item.bundleName === bundleName) >= 0;
  }

  /**
   * 是否在当前页
   *
   * @param folder 文件夹
   * @returns
   */
  public static isFolderInCurrentPage(folder: GridLayoutItemInfo): boolean {
    if (folder.container !== CommonConstants.CONTAINER_DESKTOP) {
      return true;
    }
    let page: number = folder.page ?? 0;
    let currentPage: number = desktopUtil.getPageIndexValue();
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      let displayCount: number = PageInfoManager.getInstance().getDisplayCount();
      if (displayCount === 0) {
        displayCount = 1;
      }
      return Math.floor(currentPage / displayCount) === Math.floor(page / displayCount);
    }
    return currentPage === page;
  }

  /**
   * 根据keyname查询应用是否在文件夹中
   *
   * @param folderId 文件夹id
   * @param keyName 应用的keyname
   * @returns true存在
   */
  public static isKeyNameInFolder(folderId: string, keyName: string): boolean {
    let folder: FoldersData = FolderManager.getInstance().getFolder(folderId);
    let items: GridLayoutItemInfo[] = folder.getItems();
    let index: number = items.findIndex((item: GridLayoutItemInfo) => {
      return AppItemInfo.getKeyName(item) === keyName;
    });
    return index >= 0;
  }

  /**
   * 坐标是否在GridSwiper的区域内
   *
   * @param positionY number y坐标
   * @returns boolean y是否在GridSwiper的区域内
   */
  public static isInGridSwiperArea(positionY: number): boolean {
    if (CheckEmptyUtils.isEmpty(positionY)) {
      return false;
    }
    let sysUIHeight: number = LayoutViewModel.getInstance().getSysUITopHeight();
    return (positionY > sysUIHeight && !FolderCommonUtil.isInDockArea(positionY)) ? true : false;
  }

  /**
   * 是否在dock区域
   *
   * @param y y方向位移
   * @returns true在dock区
   */
  public static isInDockArea(y: number): boolean {
    let layoutVm: LayoutViewModel = LayoutViewModel.getInstance();
    const swiperBottom: number = layoutVm.getScreenHeight() - layoutVm.getDockHeight();
    if (swiperBottom && y >= swiperBottom) {
      return true;
    }
    return false;
  }

  /**
   * 是否1*1大小
   *
   * @param area 占的宫格大小
   * @returns true for 1X1
   */
  public static isLayout1X1(area: number[]): boolean {
    if (CheckEmptyUtils.isEmptyArr(area)) {
      return false;
    }
    return area[0] === 1 && area[1] === 1;
  }

  /**
   * 是否4*2大小
   *
   * @param area 占的宫格大小
   * @returns true for 4X2
   */
  public static isLayout4X2(area: number[]): boolean {
    if (CheckEmptyUtils.isEmpty(area)) {
      return false;
    }
    return area[0] === CommonConstants.GRID_SPAN_4 && area[1] === CommonConstants.GRID_SPAN_2;
  }

  /**
   * 获取当前布局是否1*1大小
   *
   * @param folderId 文件夹id
   * @returns true 是1*1大小
   */
  public static isLayout1X1ByFolderId(folderId: string): boolean {
    let folder: FoldersData | undefined = FolderManager.getInstance().getFolder(folderId);
    if (!folder) {
      return false;
    }
    return FolderCommonUtil.isLayout1X1(folder.getGridInfo().area ?? []);
  }

  /**
   * 是否Dock文件夹
   *
   * @param folderId 文件夹id
   * @returns true：是dock文件夹
   */
  public static isDockFolder(folderId: string): boolean {
    let folder: FoldersData | undefined = FolderManager.getInstance().getFolder(folderId);
    if (!folder) {
      return false;
    }
    return folder.getGridInfo()?.container === CommonConstants.CONTAINER_SMARTDOCK;
  }

  /**
   * 文件夹列数是否大于等于2
   *
   * @param folderId 文件夹id
   * @returns
   */
  public static isColumnMoreTwo(folderId: string): boolean {
    let folder: FoldersData | undefined = FolderManager.getInstance().getFolder(folderId);
    if (!folder) {
      return false;
    }
    return folder.getGridInfo().column as number >= NumberConstants.CONSTANT_NUMBER_TWO;
  }

  /**
   * 转换一维数组成文件夹布局的二维数组
   * appInfos是一维数组，folderItem.layoutInfo是二维分页
   *
   * @param {GridLayoutItemInfo[]} appInfos.
   * @return {GridLayoutItemInfo[][]} folderItem layout
   */
  public static translateFolderLayout(appInfos: GridLayoutItemInfo[]): GridLayoutItemInfo[][] {
    let folderLayout: GridLayoutItemInfo[][] = [];
    let folderOpenColumn = FolderModel.getInstance().getFolderOpenLayout()?.column ?? 0;
    let folderOpenRow = FolderModel.getInstance().getFolderOpenLayout()?.row ?? 0;
    const allCount = folderOpenColumn * folderOpenRow;
    if (appInfos.length > allCount && allCount > 0) {
      let integer = Math.floor(appInfos.length / allCount);
      let remainder = appInfos.length % allCount;
      for (let i = 0; i < integer; i++) {
        folderLayout.push(appInfos.slice(i * allCount, (i + 1) * allCount));
      }
      if (remainder !== 0) {
        folderLayout.push(appInfos.slice(integer * allCount, integer * allCount + remainder));
      }
    } else {
      folderLayout = [appInfos];
    }
    return folderLayout;
  }

  /**
   * 计算角标数量
   *
   * @param appInfos 文件夹应用
   * @returns 角标
   */
  public static calculateBadgeNum(appInfos: GridLayoutItemInfo[]): number {
    let badgeNumber = 0;
    appInfos.forEach((item: GridLayoutItemInfo) => {
      if (!item || item.typeId !== CommonConstants.TYPE_APP) {
        return;
      }
      // 启动时, 这里可以保证角标正常.
      item.badgeNumber = BadgeManager.getInstance().getAppBadgeValue(item as BaseBundleInfo);
      if (item.badgeNumber && item.badgeNumber > 0) {
        badgeNumber = badgeNumber + item.badgeNumber;
      }
    });
    return badgeNumber;
  }

  /**
   * 更新文件夹布局应用的位置信息
   *
   * @param folderAppInfo 文件夹内元素列表
   */
  public static updateFolderAppLocation(folderAppInfo: GridLayoutItemInfo[]): void {
    if (CheckEmptyUtils.isEmpty(folderAppInfo)) {
      return;
    }
    let folderOpenColumn = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let folderOpenRow = FolderModel.getInstance().getFolderOpenLayout()?.row;
    if (!folderOpenColumn || !folderOpenRow) {
      return;
    }
    for (let i = 0; i < folderAppInfo.length; i++) {
      folderAppInfo[i].column = i % folderOpenColumn;
      folderAppInfo[i].row = Math.floor(i / folderOpenColumn % folderOpenRow);
      folderAppInfo[i].page = Math.floor(i / (folderOpenColumn * folderOpenRow));
    }
  }

  /**
   * 初始化文件夹截图缓存
   *
   * @param msg 用于DFX的日志打印
   */
  public static initFolderIconCache(msg: string): void {
    log.showInfo('start to init snapshot cache: %{public}s', msg);
    TraceUtil.startTrace(DomainName.HOME, TraceUtil.INIT_FOLDER_SNAPSHOT);
    let folders: FoldersData[] = FolderManager.getInstance().getFolders();
    folders.forEach((folder: FoldersData) => {
      let folderItem: GridLayoutItemInfo = folder.getGridInfo();
      if (FolderCommonUtil.isLayout1X1(folderItem.area ?? [])) {
        let iconKey: string = SmallFolderIconFileUtil.getIconKey(folderItem.folderId ?? '', false);
        let appListKey: string = SmallFolderIconFileUtil.generateAppListKey(false, folder.getMainPageItems());
        let endIconKey: string = SmallFolderIconFileUtil.getIconKey(folderItem.folderId ?? '', true);
        let endAppListKey: string = SmallFolderIconFileUtil.generateAppListKey(true, folder.getLastPageItems());
        FolderCommonUtil.loadIconFromFileSync(iconKey, appListKey);
        FolderCommonUtil.loadIconFromFileSync(endIconKey, endAppListKey);
      }
    });
    TraceUtil.endTrace(DomainName.HOME, TraceUtil.INIT_FOLDER_SNAPSHOT);
    log.showInfo('end to init snapshot cache: %{public}s', msg);
  }

  private static loadIconFromFileSync(iconKey: string, appListKey: string): void {
    if (SmallFolderIconFileUtil.isIconFileExistSync(iconKey)) {
      try {
        SmallFolderCacheManager.getInstance().setCache(iconKey, appListKey);
      } catch (error) {
        log.error('loadIconFromPath: image error', error);
      }
    }
  }

  /**
   * 是否特殊定制文件夹
   *
   * @param folderId 文件夹id
   * @returns true是特殊定制文件夹
   */
  public static isCustomizedFolder(folderId: string): boolean {
    return NotHarmonyUtil.isNotHarmonyFolderById(folderId);
  }

  /**
   * 获取空的FolderData
   *
   * @returns
   */
  public static getEmptyFolderData(): GridLayoutItemInfo {
    let emptyFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
    emptyFolderData.bundleName = '';
    emptyFolderData.abilityName = '';
    emptyFolderData.folderId = '-1';
    emptyFolderData.appIconId = -1;
    emptyFolderData.negativeId = -1;
    emptyFolderData.isSelect = false;
    emptyFolderData.enterEditing = false;
    emptyFolderData.downloadProgress = 0;
    emptyFolderData.appStatus = 0;
    emptyFolderData.iconResource = undefined;
    emptyFolderData.callerName = undefined;
    emptyFolderData.area = [1, 1];
    emptyFolderData.isEmpty = true;
    return emptyFolderData;
  }

  /**
   * 计算小文件夹在屏幕区域
   *
   * @param folderItem 文件夹item
   * @returns 区域位置信息SmallFolderRegion
   */
  public static getSmallFolderRegion(folderItem: GridLayoutItemInfo): number {
    if (!folderItem) {
      log.showError('getSmallFolderRegion, folderItem is invalid.');
      return SmallFolderRegion.LEFT_UP_REGION;
    }
    const gridRow: number = SettingsModel.getInstance().getGridConfig().row;
    const gridColumn: number = SettingsModel.getInstance().getGridConfig().column;
    const folderRow: number = folderItem.row ?? 0;
    const folderPage: number = folderItem.page ?? -1;
    const halfOfRow: number = (gridRow % StyleConstants.DEFAULT_2 === 0) ?
      (gridRow / StyleConstants.DEFAULT_2) : ((gridRow + 1) / StyleConstants.DEFAULT_2);
    const isFoldExpand: boolean = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    const isInDock: boolean = folderItem.isInDock ?? false;
    let folderColumn: number = folderItem.column ?? 0;
    let halfOfColumn: number = (gridColumn % StyleConstants.DEFAULT_2 === 0) ?
      (gridColumn / StyleConstants.DEFAULT_2) : ((gridColumn + 1) / StyleConstants.DEFAULT_2);
    let isLeft: boolean = false;
    let isUp: boolean = false;
    if (isInDock) {
      const dockList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let dockColumn: number = dockList.length;
      folderColumn = dockList.findIndex((item: DockItemInfo) => item.keyName === folderItem.keyName);
      if (isFoldExpand || DeviceHelper.isPad()) {
        const recentListLength: number = (AppStorage.get('recentList') as Array<RecentBundleMissionInfo> ?? []).length;
        dockColumn += recentListLength;
      }
      halfOfColumn = (dockColumn % StyleConstants.DEFAULT_2 === 0) ?
        (dockColumn / StyleConstants.DEFAULT_2) : ((dockColumn + 1) / StyleConstants.DEFAULT_2);
      isLeft = folderColumn < halfOfColumn;
    } else {
      isLeft = isFoldExpand ? folderPage % StyleConstants.DEFAULT_2 === 0 : folderColumn < halfOfColumn;
      isUp = folderRow < halfOfRow;
    }
    return FolderCommonUtil.calculateRegion(isLeft, isUp);
  }

  private static calculateRegion(isLeft: boolean, isUp: boolean): SmallFolderRegion {
    if (isLeft && isUp) {
      return SmallFolderRegion.LEFT_UP_REGION;
    } else if (isLeft && !isUp) {
      return SmallFolderRegion.LEFT_DOWN_REGION;
    } else if (!isLeft && !isUp) {
      return SmallFolderRegion.RIGHT_DOWN_REGION;
    } else {
      return SmallFolderRegion.RIGHT_UP_REGION;
    }
  }

  /**
   * 是否使用实时模糊
   *
   * @param isSolidColor 是否纯色模式
   * @param isFromDock 是否dock区文件夹
   * @returns true使用实时模糊
   */
  public static isUseEffect(isSolidColor: boolean, isFromDock: boolean): boolean {
    if (isFromDock) {
      return !isSolidColor && !FolderCommonUtil.isExistDockBackPlane();
    }
    return !isSolidColor;
  }

  /**
   * 获取文件夹背板颜色
   *
   * @param isSolidColor 是否纯色模式
   * @param isFromDock 是否dock区文件夹
   * @returns 背板颜色
   */
  public static getFolderBgColor(isSolidColor: boolean, isFromDock: boolean): ResourceColor | undefined {
    if (isSolidColor) {
      return $r('app.color.low_back_plane_bg_color');
    }
    return (isFromDock && FolderCommonUtil.isExistDockBackPlane()) ? $r('app.color.back_plane_bg_color') : undefined;
  }

  private static isExistDockBackPlane(): boolean {
    const folderStatus: number | undefined = AppStorage.get<number>('folderStatus');
    return (DeviceHelper.isPad() || (DeviceHelper.isFoldButNotSmallFoldProduct() &&
      folderStatus === DeviceState.EXPAND_STATE));
  }
}