/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import BitSet from './BitSet';
import { AppStatus, CommonConstants, DeviceState } from '../constants/CommonConstants';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { DockItemInfo } from '../bean/DockItemInfo';
import { CardItemInfo } from '../bean/CardItemInfo';
import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper, IconResourceManager } from '@ohos/frameworkwrapper';
import { desktopUtil, RTLUtil, ObjectCopyUtil } from '@ohos/componenthelper';
import type { AppItemInfo } from '../bean/AppItemInfo';
import DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import util from '@ohos.util';
import { StyleConstants } from '../constants/StyleConstants';
import { DragGridParam, DragGridPosition, DragPosition, GridItemPositionUtil } from '@ohos/componentdrag';
import { image } from '@kit.ImageKit';
import { DesktopFileInfo, FileType } from '../bean/DesktopFileInfo';
import { PageInfoManager } from '../cache/layout/PageInfoManager';
import { NumberConstants } from '@ohos/commonconstants';
import FolderItemInfo from '../folder/FolderItemInfo';
import { RdbStoreManager } from '../db/RdbStoreManager';
import OpenFolderData from '../folder/OpenFolderData';
import { LaunchLayoutCacheManager } from '../cache/layout/LaunchLayoutCacheManager';

const TAG = 'GridLayoutUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const TYPE_CHECKER = new util.types();

export default class GridLayoutUtil {
  /**
   * 宫格位置计算工具类
   */
  private static positionUtil: GridItemPositionUtil = new GridItemPositionUtil();

  private static editModePositionUtil: GridItemPositionUtil = new GridItemPositionUtil();

  /**
   * 是否大折叠设备
   */
  private static isLargeFold: boolean = DeviceHelper.isLargeInFoldProduct();

  /**
   * 是否是编辑模式
   */
  private static isEditMode: boolean = false;

  /**
   * 折叠屏折叠态和展开态时桌面宫格距屏幕左边缘的距离不同，故需要单独设置paddingLeft
   * 折叠屏折叠态的paddingLeft在initGridPosition时设置，展开态的paddingLeft设置为数组
   * 该数组有两项，依次为折叠屏展开态左半屏宫格和右半屏宫格距屏幕左边缘的距离
   * 编辑模式下试图获取非编辑模式下的图标坐标时会由于使用一套paddingLeft而导致获取到的坐标横坐标错误
   * 因此需要设置两套paddingLeft以区分编辑和非编辑模式
   */
  private static foldScreenExpandPaddingLeft: number[] = [0, 0];

  private static foldScreenExpandPaddingLeftInEditMode: number[] = [0, 0];

  private static screenWidth: number = 0;

  private static columnCount: number = 0;

  private static rowCount: number = 0;
  /**
   * update GridLayoutInfo
   *
   * @param newLayoutRows new layout rows
   * @param newLayoutColumns new layout columns
   *
   * @return new GridLayoutInfo
   */
  static updateGridLayoutInfo(gridLayoutInfo: DefaultDesktopLayoutInfo, newLayoutRows: number,
    newLayoutColumns: number): DefaultDesktopLayoutInfo {
    gridLayoutInfo.layoutDescription.pageCount = GridLayoutUtil.updateLayoutInfo(
      gridLayoutInfo.layoutInfo, newLayoutRows, newLayoutColumns);
    gridLayoutInfo.layoutDescription.row = newLayoutRows;
    gridLayoutInfo.layoutDescription.column = newLayoutColumns;
    return gridLayoutInfo;
  }

  /**
   * update layoutInfo
   *
   * @param layoutInfo appLayoutInfo List
   * @param newLayoutRows new layout rows
   * @param newLayoutColumns new layout columns
   *
   * @return new layout pages num
   */
  private static updateLayoutInfo(layoutInfo: GridLayoutItemInfo[], newLayoutRows: number,
    newLayoutColumns: number): number {
    let currentPage = -1;
    let insertPages = 0;
    const currentPageBitset = new BitSet(newLayoutRows * newLayoutColumns);

    for (let i = 0; i < layoutInfo.length;) {
      let mPage = layoutInfo[i].page;
      if (currentPage !== mPage && mPage !== undefined) {
        currentPage = mPage;
        currentPageBitset.clear();
      }

      while (i < layoutInfo.length && layoutInfo[i].page === currentPage) {
        if (GridLayoutUtil.updatePositionSuccess(layoutInfo[i], currentPageBitset, newLayoutRows, newLayoutColumns, currentPage + insertPages)) {
          i++;
        } else {
          currentPageBitset.clear();
          insertPages++;
        }
      }
    }

    return currentPage + insertPages + 1;
  }

  /**
   * update app position info
   *
   * @param appLayout appLayoutInfo List Item
   * @param currentPageBitset current page bitset
   * @param layoutRows new layout rows
   * @param layoutColumns new layout columns
   * @param currentPage app pages index
   *
   * @return whether update success
   */
  private static updatePositionSuccess(appLayout: GridLayoutItemInfo, currentPageBitset: BitSet,
    layoutRows: number, layoutColumns: number, currentPage: number): boolean {
    for (let r = 0; r < layoutRows; r++) {
      for (let c = 0; c < layoutColumns; c++) {
        if (!currentPageBitset.get(r * layoutColumns + c)) {
          appLayout.page = currentPage;
          appLayout.row = r;
          appLayout.column = c;
          currentPageBitset.set(r * layoutColumns + c);
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Check whether an item is small folder.
   *
   * @param item the item on desktop
   * @returns true if the item is a small folder.
   */
  public static isSmallFolder(item: GridLayoutItemInfo | DockItemInfo | FolderItemInfo): boolean {
    if (!item || !item.area) {
      return false;
    }
    return item.typeId === CommonConstants.TYPE_FOLDER && item.area[0] === 1 && item.area[1] === 1;
  }

  /**
   * Check whether an item is big folder.
   *
   * @param item the item on desktop
   * @returns true if the item is a big folder.
   */
  public static isBigFolder(item: GridLayoutItemInfo | AppItemInfo): boolean {
    if (!item || !item.area) {
      return false;
    }
    return item.typeId === CommonConstants.TYPE_FOLDER && (item.area[0] > 1 || item.area[1] > 1);
  }

  /**
   * 判断是否是“+”号
   * @param item 图标信息
   * @returns true: 文件夹“+”号
   */
  public static isAddIcon(item: GridLayoutItemInfo): boolean {
    return item?.typeId === CommonConstants.TYPE_ADD;
  }

  /**
   * 计算当前点击是否在grid的有效区域
   * @param event 点击事件
   * @returns true则表示可以点击打开文件夹，反之不行
   */
  public static countBoundary(event: ClickEvent, area: number[], appLength: number, appSize: number,
      gridGap: number, gridPadding: number): boolean {
    let curX = event.x;
    let curY = event.y;
    log.showInfo(`grid onClick curX:${curX} curY:${curY}`);
    let length = appLength;
    let row = 0;
    let col = 0;

    const rowSize = GridLayoutUtil.getCountPerRowInFolder(area);
    if (length < GridLayoutUtil.getCountPerPageInFolder(area)) {
      row = Math.ceil(length / rowSize);
      col = length % rowSize === 0 ? rowSize : length % rowSize;
    } else {
      row = rowSize;
      col = GridLayoutUtil.getCountPerColumnInFolder(area) - 1;
    }

    let conY = row * (appSize + gridGap) + (row === 0 ? 0 : gridPadding);
    let minX = col * (appSize + gridGap) + (col === 0 ? 0 : gridPadding);
    let minY = (row - 1) * (appSize + gridGap) +
      ((row - 1) === 0 ? 0 : gridPadding);

    log.showInfo(`grid onClick conY:${conY}, minX:${minX} ,minY:${minY}`);
    let isValid: boolean = curY > minY && curY < conY && curX > minX;
    if (row === rowSize) {
      // 行铺满的情况
      return isValid;
    } else {
      return curY > conY || isValid;
    }
  }

  /**
   * 获取显示的图标数
   *
   * @param size 行列占位数
   * @returns 显示的图标数
   */
  private static getItemsCount(size: number): number {
    return (ItemsCount[`SIZE_${size}`] as ItemsCount).valueOf();
  }

  /**
   * 根据文件夹大小获取每行图标数
   *
   * @param area 文件夹大小
   * @returns 文件夹每行图标数
   */
  public static getCountPerRowInFolder(area: number[]): number {
    return GridLayoutUtil.getItemsCount(area[0]);
  }

  /**
   * 根据文件夹大小获取每列图标数
   *
   * @param area 文件夹大小
   * @returns 文件夹每列图标数
   */
  public static getCountPerColumnInFolder(area: number[]): number {
    return GridLayoutUtil.getItemsCount(area[1]);
  }

  /**
   * 根据文件夹大小获取每页图标数(堆叠图标整体算一个图标)
   *
   * @param area 文件夹大小
   * @returns 文件夹每列图标数
   */
  public static getCountPerPageInFolder(area: number[]): number {
    let numPerRow: number = GridLayoutUtil.getItemsCount(area[0]);
    let numPerCol: number = GridLayoutUtil.getItemsCount(area[1]);
    return numPerRow * numPerCol;
  }

  /**
   * 文件夹展开态每页图标数
   *
   * @returns
   */
  public static getCountPerPageFolderOpen(): number {
    if (desktopUtil.isFoldExpandStatus() || DeviceHelper.isPad()) {
      return StyleConstants.DEFAULT_FOLDER_OPEN_ROW_SIZE_EXPENDED * StyleConstants.DEFAULT_FOLDER_OPEN_COL_SIZE;
    }
    let folderStatus: number = (AppStorage.get('folderStatus') ?? DeviceState.DEFAULT_STATE) as number;
    if (folderStatus === DeviceState.EXPAND_STATE) {
      log.showInfo('use storage to get expand status');
      return StyleConstants.DEFAULT_FOLDER_OPEN_ROW_SIZE_EXPENDED * StyleConstants.DEFAULT_FOLDER_OPEN_COL_SIZE;
    }
    return StyleConstants.DEFAULT_FOLDER_OPEN_ROW_SIZE * StyleConstants.DEFAULT_FOLDER_OPEN_COL_SIZE;
  }

  /**
   * 是否是图标类型
   *
   * @param typeId 元素类型
   * @returns 是否是图标类型
   */
  public static isIconType(typeId: number | undefined): boolean {
    return typeId === CommonConstants.TYPE_APP || typeId === CommonConstants.TYPE_SHORTCUT_ICON;
  }

  /**
   * 判断是否是应用内加桌的快捷方式
   *
   * @param item 布局信息
   * @returns 是否是应用内加桌的快捷方式
   */
  public static isShortcutToDesktopInApp(item: GridLayoutItemInfo | AppItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmpty(item.appIconId) ||
    CheckEmptyUtils.isEmpty(item.iconResource)) {
      return false;
    }
    const base64Str: string = 'base64';
    const isShortCutType: boolean = item.typeId === CommonConstants.TYPE_SHORTCUT_ICON;
    const iconResourceIsBase64: boolean = item.iconResource.includes(base64Str);
    const isEmptyAppIconId: boolean = item.appIconId === 0;
    return isShortCutType && iconResourceIsBase64 && isEmptyAppIconId;
  }

  /**
   * 是否是手机文件夹类型
   *
   * @param typeId 元素类型
   * @returns 是否是文件夹类型
   */
  public static isFolderType(typeId: number): boolean {
    return typeId === CommonConstants.TYPE_FOLDER;
  }

  /**
   * 是否是收纳夹类型
   *
   * @param item GridLayoutItemInfo元素
   * @returns 是否收纳夹类型
   */
  public static isRegionFolderType(item: GridLayoutItemInfo): boolean {
    return item && (item.typeId === CommonConstants.TYPE_REGION_FOLDER);
  }

  /**
   * 是否是文件系统中的文件
   *
   * @param item GridLayoutItemInfo元素
   * @returns 是/否
   */
  public static isFSFileFolderType(item: GridLayoutItemInfo): boolean {
    return item && (item.typeId === CommonConstants.TYPE_FILE_FOLDER);
  }

  /**
   * 是否是文件系统中的文件类型
   *
   * @param item GridLayoutItemInfo元素
   * @returns 是/否
   */
  public static isFSFileType(item: GridLayoutItemInfo): boolean {
    return item && (item.typeId === CommonConstants.TYPE_FILE_FOLDER) && (item.fileType === FileType.TYPE_FILE);
  }

  /**
   * 是否是文件系统中的文件夹类型
   *
   * @param item GridLayoutItemInfo元素
   * @returns 是/否
   */
  public static isFSFolderType(item: GridLayoutItemInfo): boolean {
    return item && (item.typeId === CommonConstants.TYPE_FILE_FOLDER) && (item.fileType === FileType.TYPE_FOLDER);
  }

  /**
   *
   * @param item  AppItemInfo
   * @param page  构建appItem到那一页
   * @param col   位置列col(positionX)
   * @param row   位置行row(positionY)
   * @returns GridLayoutItemInfo 数据网格对象,不包含container，默认为桌面的对象
   */
  public static buildGridLayoutInfoFromItemInfo(item: AppItemInfo | GridLayoutItemInfo, page: number, col: number,
    row: number): GridLayoutItemInfo {
    let gridlayoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    gridlayoutItem.bundleName = item.bundleName;
    gridlayoutItem.typeId = item.typeId;
    gridlayoutItem.abilityName = item.abilityName;
    gridlayoutItem.moduleName = item.moduleName;
    gridlayoutItem.keyName = item.keyName;
    gridlayoutItem.badgeNumber = item.badgeNumber;
    gridlayoutItem.area = item.area;
    gridlayoutItem.areaType = CommonConstants.TYPE_AREA_DESKTOP;
    gridlayoutItem.appName = item.appName;
    gridlayoutItem.appIconId = item.appIconId;
    gridlayoutItem.appLabelId = item.appLabelId;
    gridlayoutItem.kindId = item.kindId;
    gridlayoutItem.bundleType = item.bundleType;
    gridlayoutItem.applicationName = item.applicationName;
    gridlayoutItem.appStatus = item.appStatus;
    gridlayoutItem.downloadProgress = item.downloadProgress ?? 0;
    gridlayoutItem.iconResource = item.iconResource;
    gridlayoutItem.callerName = item.callerName;
    gridlayoutItem.installTime = item.installTime;
    gridlayoutItem.page = page;
    gridlayoutItem.column = col;
    gridlayoutItem.row = row;
    gridlayoutItem.isUninstallAble = item.isUninstallAble;
    gridlayoutItem.isSystemApp = item.isSystemApp;
    gridlayoutItem.applicationIconId = item.applicationIconId;
    gridlayoutItem.applicationLabelId = item.applicationLabelId;
    gridlayoutItem.intent = item.intent;
    gridlayoutItem.enableNewAppInstance = item.enableNewAppInstance;
    gridlayoutItem.infoId = RdbStoreManager.getInstance().generateRandomUUID();
    if (item instanceof GridLayoutItemInfo) {
      gridlayoutItem.layoutInfo = item.layoutInfo;
      gridlayoutItem.folderName = item.folderName;
      gridlayoutItem.folderId = item.folderId;
      gridlayoutItem.container = item.container;
      gridlayoutItem.extend1 = item.extend1;
    }
    gridlayoutItem.appIndex = item.appIndex;
    IconResourceManager.getInstance().getAppNameWithCallback(gridlayoutItem.appLabelId, gridlayoutItem.bundleName,
      gridlayoutItem.moduleName, gridlayoutItem.appName, (name: string) => {
        gridlayoutItem.infoName = name;
      }, gridlayoutItem.appIndex);
    return gridlayoutItem;
  }

  /**
   * 更新Item位置信息
   *
   * @param item GridLayoutItemInfo
   * @param page 构建appItem到那一页
   * @param col 位置列col(positionX)
   * @param row 位置行row(positionY)
   */
  public static updateGridLayoutInfoPosition(item: GridLayoutItemInfo, page: number, col: number, row: number):
    GridLayoutItemInfo {
    let newGridLayoutItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(item) as GridLayoutItemInfo;
    newGridLayoutItem.page = page;
    newGridLayoutItem.column = col;
    newGridLayoutItem.row = row;
    return newGridLayoutItem;
  }

  /**
   * GridLayoutItemInfo转换成DockItemInfo
   *
   * @param gridLayout 桌面布局
   * @returns dock区布局
   */
  public static gridLayoutToDockItem(gridLayout: GridLayoutItemInfo): DockItemInfo {
    let dockItem: DockItemInfo = new DockItemInfo();
    if (!gridLayout) {
      log.showError('gridLayout is null or undefined');
      return dockItem;
    }
    dockItem.itemType = gridLayout.typeId;
    dockItem.editable = false;
    dockItem.appId = gridLayout.infoId;
    if (gridLayout.typeId === CommonConstants.TYPE_FOLDER) {
      dockItem.appName = gridLayout.folderName ?? '';
      // 小文件夹bundleName为folderId
      dockItem.bundleName = gridLayout.infoId ?? '';
      // 小文件夹keyName为infoId
      dockItem.keyName = gridLayout.infoId;
    } else {
      dockItem.appName = gridLayout.appName ?? '';
      dockItem.bundleName = gridLayout.bundleName;
      dockItem.keyName = gridLayout.keyName;
    }
    dockItem.abilityName = gridLayout.abilityName;
    dockItem.moduleName = gridLayout.moduleName;
    dockItem.typeId = gridLayout.typeId ? gridLayout.typeId : CommonConstants.TYPE_APP;
    dockItem.iconId = gridLayout.appIconId + '';
    dockItem.appLabelId = gridLayout.appLabelId;
    dockItem.applicationLabelId = gridLayout.appLabelId;
    dockItem.applicationName = gridLayout.appName;
    dockItem.visible = true;
    dockItem.layoutInfo = gridLayout.layoutInfo;
    dockItem.badgeNumber = gridLayout.badgeNumber;
    dockItem.appIconId = gridLayout.appIconId;
    dockItem.row = gridLayout.row;
    dockItem.column = gridLayout.column;
    dockItem.area = gridLayout.area;
    dockItem.areaType = gridLayout.areaType;
    dockItem.appIndex = gridLayout.appIndex;
    dockItem.shortcutId = gridLayout.shortcutId;
    dockItem.appStatus = gridLayout.appStatus;
    dockItem.iconResource = gridLayout.iconResource;
    dockItem.intent = gridLayout.intent;
    dockItem.callerName = gridLayout.callerName;
    return dockItem;
  }

  /**
   * DockItemInfo转换成GridLayoutItemInfo
   *
   * @param dockItem dock区布局
   * @returns 桌面布局
   */
  public static dockItemToGridLayout(dockItem: DockItemInfo): GridLayoutItemInfo {
    let gridLayoutInfo = new GridLayoutItemInfo();
    gridLayoutInfo.itemType = dockItem.itemType;
    gridLayoutInfo.typeId = dockItem.typeId;
    gridLayoutInfo.infoId = dockItem.appId;
    gridLayoutInfo.bundleName = dockItem.bundleName;
    gridLayoutInfo.moduleName = dockItem.moduleName;
    gridLayoutInfo.abilityName = dockItem.abilityName;
    gridLayoutInfo.appIconId = dockItem.appIconId;
    gridLayoutInfo.appLabelId = dockItem.appLabelId;
    gridLayoutInfo.applicationLabelId = dockItem.applicationLabelId;
    gridLayoutInfo.appName = dockItem.appName;
    gridLayoutInfo.areaType = dockItem.areaType;
    gridLayoutInfo.keyName = dockItem.keyName;
    gridLayoutInfo.layoutInfo = dockItem.layoutInfo;
    gridLayoutInfo.badgeNumber = dockItem.badgeNumber;
    gridLayoutInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
    gridLayoutInfo.area = [1, 1];
    gridLayoutInfo.row = dockItem.row;
    gridLayoutInfo.column = dockItem.column;
    gridLayoutInfo.isUninstallAble = dockItem.isUninstallAble;
    gridLayoutInfo.appStatus = dockItem.appStatus;
    gridLayoutInfo.downloadProgress = dockItem.downloadProgress ?? 0;
    gridLayoutInfo.iconResource = dockItem.iconResource;
    gridLayoutInfo.callerName = dockItem.callerName;
    gridLayoutInfo.appIndex = dockItem.appIndex;
    gridLayoutInfo.shortcutId = dockItem.shortcutId ?? '';
    gridLayoutInfo.intent = dockItem.intent;
    gridLayoutInfo.folderId = dockItem.typeId === CommonConstants.TYPE_FOLDER ? dockItem.keyName : '';
    gridLayoutInfo.page = dockItem.page ?? 0;
    return gridLayoutInfo;
  }

  /**
   * appItemInfo转换成GridLayoutItemInfo
   *
   * @param dockItem dock区布局
   * @returns 桌面布局
   */
  public static appItemInfoToGridLayout(dockItem: AppItemInfo): GridLayoutItemInfo {
    let gridLayoutInfo = new GridLayoutItemInfo();
    gridLayoutInfo.typeId = dockItem.typeId;
    gridLayoutInfo.infoId = dockItem.appId;
    gridLayoutInfo.bundleName = dockItem.bundleName;
    gridLayoutInfo.moduleName = dockItem.moduleName;
    gridLayoutInfo.abilityName = dockItem.abilityName;
    gridLayoutInfo.appIconId = dockItem.appIconId;
    gridLayoutInfo.appLabelId = dockItem.appLabelId;
    gridLayoutInfo.applicationLabelId = dockItem.applicationLabelId;
    gridLayoutInfo.appName = dockItem.appName;
    gridLayoutInfo.areaType = dockItem.areaType;
    gridLayoutInfo.keyName = dockItem.keyName;
    gridLayoutInfo.badgeNumber = dockItem.badgeNumber;
    gridLayoutInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
    gridLayoutInfo.area = [1, 1];
    gridLayoutInfo.row = dockItem.row;
    gridLayoutInfo.column = dockItem.column;
    gridLayoutInfo.isUninstallAble = dockItem.isUninstallAble;
    gridLayoutInfo.appStatus = dockItem.appStatus;
    gridLayoutInfo.downloadProgress = dockItem.downloadProgress ?? 0;
    gridLayoutInfo.iconResource = dockItem.iconResource;
    gridLayoutInfo.callerName = dockItem.callerName;
    gridLayoutInfo.appIndex = dockItem.appIndex;
    gridLayoutInfo.shortcutId = dockItem.shortcutId;
    gridLayoutInfo.intent = dockItem.intent;
    return gridLayoutInfo;
  }

  /**
   * 如果是桌面布局是Proxy类型，需要转换成非Proxy类型，否则taskpool会序列化失败
   *
   * @param itemInfo 桌面布局
   * @returns 非Proxy类型桌面布局
   */
  public static mapProxyTypeGridLayout(itemInfo: GridLayoutItemInfo): GridLayoutItemInfo {
    if (GridLayoutUtil.isProxyTypeGridLayout(itemInfo)) {
      const itemInfoTemp = ObjectCopyUtil.simpleClone(itemInfo);
      return itemInfoTemp;
    }
    return itemInfo;
  }

  /**
   * 判断桌面布局是否为Proxy类型
   *
   * @param itemInfo 桌面布局
   * @returns 是否为Proxy类型
   */
  public static isProxyTypeGridLayout(itemInfo: Object): boolean {
    return TYPE_CHECKER.isProxy(itemInfo);
  }

  /**
   * 判断桌面布局是否为存在symbol类型
   *
   * @param itemInfo 桌面布局
   * @returns 是否为symbol类型
   */
  public static hasSymbol(obj: Object): boolean {
    if (typeof obj !== 'object' || obj === null) {
      return false;
    }
    // 检查当前对象的属性键是否为Symbol类型
    const keys = Reflect.ownKeys(obj);
    for (const key of keys) {
      if (typeof key === 'symbol') {
        log.showWarn(`obj has symbol key: ${key.toString()}, obj: ${JSON.stringify(obj)}`);
        return true;
      }
    }
    // 检查当前对象的属性值是否为Symbol类型
    const values: Object[] = Object.values(obj);
    for (const value of values) {
      if (typeof value === 'symbol') {
        log.showWarn(`obj has symbol value:${value.toString()},obj: ${JSON.stringify(obj)}`);
        return true;
      }
      // 递归检查属性值
      if (GridLayoutUtil.hasSymbol(value)) {
        return true;
      }
    }
    return false;
  }

  /**
   * check whether  app has been installed
   *
   * @param AppItemInfo  app info
   * @returns true has been installed false is not
   */
  public static isAppInstalled(appItem: AppItemInfo | GridLayoutItemInfo): boolean {
    if (appItem.appStatus === null || appItem.appStatus === undefined) {
      return true;
    }
    return (appItem.appStatus as AppStatus) === AppStatus.INSTALLED;
  }

  public static isImageSyncLoad(icon: string | image.PixelMap): boolean {
    if (!CheckEmptyUtils.isEmpty(icon) && (typeof icon === 'string' && icon.startsWith('http'))) {
      return false;
    }
    return true;
  }

  /**
   * 判断元素布局信息是否完整
   *
   * @param item the item on desktop
   * @returns true if the item is valid drag item
   */
  public static isValidLayoutItem(itemInfo?: GridLayoutItemInfo): boolean {
    if (itemInfo === undefined || CheckEmptyUtils.isEmpty(itemInfo)) {
      log.showError('dragItemInfo is null or undefined');
      return false;
    }

    if (itemInfo.typeId === CommonConstants.TYPE_FOLDER) {
      return !CheckEmptyUtils.isEmpty(itemInfo.folderId);
    } else if (itemInfo.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      return !CheckEmptyUtils.isEmpty(itemInfo.folderId);
    } else if (itemInfo.typeId === CommonConstants.TYPE_CARD) {
      // 卡片管理里的快捷方式没有cardId
      return !CheckEmptyUtils.isEmpty(itemInfo.cardId) || !CheckEmptyUtils.isEmpty(itemInfo.shortcutInfo);
    } else if (itemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      return !CheckEmptyUtils.isEmpty(itemInfo.ino);
    } else if (itemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      return !CheckEmptyUtils.isEmpty(itemInfo.formStackId);
    } else {
      return !CheckEmptyUtils.isEmpty(itemInfo.bundleName);
    }
  }

  /**
   * 判断布局重复
   *
   * @param item the item on desktop
   *
   */
  public static ifDuplicatePosition(layoutInfo: GridLayoutItemInfo[]): boolean {
    let mPositionInfo: number[][] = [];
    const pageIndex = 0;
    const rowIndex = 1;
    const columnIndex = 2;
    for (let i = 0; i < layoutInfo.length; i++) {
      let mArea = layoutInfo[i].area;
      let mPage = layoutInfo[i].page;
      let mRow = layoutInfo[i].row;
      let mColumn = layoutInfo[i].column;
      if (!mArea || mPage === undefined || mRow === undefined || mColumn === undefined) {
        continue;
      }
      for (let j = 0; j < mArea[1]; j++) {
        for (let k = 0; k < mArea[0]; k++) {
          const position: number[] = [];
          position[pageIndex] = mPage;
          position[rowIndex] = mRow + j;
          position[columnIndex] = mColumn + k;
          mPositionInfo.push(position);
        }
      }
    }
    for (let i = 0; i < mPositionInfo.length; i++) {
      for (let j = mPositionInfo.length - 1; j > 0 && j > i; j--) {
        if (mPositionInfo[i][pageIndex] === mPositionInfo[j][pageIndex] &&
          mPositionInfo[i][rowIndex] === mPositionInfo[j][rowIndex] &&
          mPositionInfo[i][columnIndex] === mPositionInfo[j][columnIndex]) {
          GridLayoutUtil.printDuplicateInfo(layoutInfo, mPositionInfo[i][pageIndex], mPositionInfo[i][rowIndex],
            mPositionInfo[i][columnIndex]);
          return true;
        }
      }
    }
    return false;
  }

  private static printDuplicateInfo(layoutInfo: GridLayoutItemInfo[], page: number, row: number, column: number): void {
    log.showError('[%{public}d, %{public}d] in page %{public}d is duplicate.', row, column, page);
    layoutInfo.forEach(layout => {
      let mArea = layout.area;
      let mRow = layout.row;
      let mColumn = layout.column;
      if (!mArea || mRow === undefined || mColumn === undefined) {
        log.showError('duplicateInfo error!');
        return;
      }
      if (layout.page === page && mRow <= row && mRow + mArea[1] > row &&
        mColumn <= column && mColumn + mArea[0] > column) {
        log.showError('layout has duplicate position. layout info is {page:%{public}d, column:%{public}d, row:%{public}d, ' +
          'width:%{public}d, height:%{public}d, typeId:%{public}d, bundleName:%{public}s, cardId:%{public}s, ' +
          'folderId:%{public}s, formStackId:%{public}s}', layout.page, layout.column, layout.row, mArea[0],
          mArea[1], layout.typeId, layout.bundleName, layout.cardId, layout.folderId, layout.formStackId);
      } else {
        log.showError('layout info is {page:%{public}d, column:%{public}d, row:%{public}d, ' +
          'width:%{public}d, height:%{public}d, typeId:%{public}d, bundleName:%{public}s, cardId:%{public}s, ' +
          'folderId:%{public}s, formStackId:%{public}s}', layout.page, layout.column, layout.row, mArea[0],
          mArea[1], layout.typeId, layout.bundleName, layout.cardId, layout.folderId, layout.formStackId);
      }
    });
  }

  /**
   * Check whether an item is 1*1
   *
   * @param item the item on desktop
   */
  public static isOneMultiplyOneItem(item: GridLayoutItemInfo): boolean {
    if (item.area && item.area.length === 2 && item.area[0] === 1 && item.area[1] === 1) {
      return true;
    }
    return false;
  }

  /**
   * 获取图标右下角点所在行
   *
   * @param itemInfo GridLayoutItemInfo
   * @returns the number of end row for GridLayoutItemInfo
   */
  public static calculateItemRowEnd(itemInfo: GridLayoutItemInfo): number {
    if (itemInfo && itemInfo.row !== undefined && itemInfo.row >= 0 && itemInfo.area) {
      return itemInfo.row + itemInfo.area[1] - 1;
    }
    log.showError(`calculateRowEnd itemInfo invalid, row=${itemInfo?.row}, areaLength=${itemInfo?.area?.length}`);
    return 0;
  }

  /**
   * 获取图标右下角点所在列
   *
   * @param itemInfo GridLayoutItemInfo
   * @returns the number of end col for GridLayoutItemInfo
   */
  public static calculateItemColEnd(itemInfo: GridLayoutItemInfo): number {
    if (itemInfo && itemInfo.column !== undefined && itemInfo.column >= 0 && itemInfo.area) {
      return itemInfo.column + itemInfo.area[0] - 1;
    }
    log.showError(`calculateColEnd itemInfo invalid, column=${itemInfo?.column}, areaLength=${itemInfo?.area?.length}`);
    return 0;
  }

  /**
   * 生成标识桌面元素的key
   *
   * @param item 桌面元素generateUniqueKey
   * @param isOuterDesktop 是否外屏桌面
   * @returns 标识桌面元素的key
   */
  public static generateUniqueKey(item?: GridLayoutItemInfo, isOuterDesktop: boolean = false): string {
    let key: string = '';
    if (!item) {
      return key;
    }
    // 卡片管理快捷图标
    if (!CheckEmptyUtils.isEmpty(item.shortcutInfo) && item.typeId === CommonConstants.TYPE_CARD) {
      return `${CommonConstants.TYPE_SHORTCUT_ICON}${item.keyName}`;
    }
    switch (item.typeId) {
      case CommonConstants.TYPE_APP:
        key = `${item.bundleName}${item.appIndex ?? 0}`;
        key = isOuterDesktop ? key + `_OuterDesktop` : key;
        break;
      case CommonConstants.TYPE_CARD:
        key = item.cardId ?? '';
        break;
      case CommonConstants.TYPE_FOLDER:
      case CommonConstants.TYPE_REGION_FOLDER:
        key = item.folderId ?? '';
        break;
      case CommonConstants.TYPE_FILE_FOLDER:
        key = item.ino ?? '';
        break;
      case CommonConstants.TYPE_FORM_STACK:
        key = item.formStackId ?? '';
        break;
      case CommonConstants.TYPE_SHORTCUT_ICON:
        key = item.keyName ?? '';
        break;
      default:
        log.showWarn(`generateUniqueKey invalid type:${item.typeId}, keyName:${item.keyName}`);
        break;
    }
    return `${item.typeId}${key}`;
  }

  /**
   * 判断两个桌面元素是否相同
   *
   * @param item 桌面元素
   * @param other 另一个桌面元素
   * @returns 两个桌面元素是否相同
   */
  public static checkGridItemEqual(item: GridLayoutItemInfo, other: GridLayoutItemInfo): boolean {
    return GridLayoutUtil.generateUniqueKey(item) === GridLayoutUtil.generateUniqueKey(other);
  }

  /**
   * 判断两个桌面元素位置以及大小是否相同
   *
   * @param firstItem 桌面元素
   * @param secItem 另一个桌面元素
   * @returns 两个桌面元素位置以及大小是否相同
   */
  public static checkPositionAndAreaEqual(firstItem: GridLayoutItemInfo, secItem: GridLayoutItemInfo): boolean {
    return (firstItem.row === secItem.row && firstItem.column === secItem.column &&
      secItem.page === firstItem.page && firstItem.area && secItem.area && firstItem.area[0] === secItem.area[0] &&
      firstItem.area[1] === secItem.area[1]) ?? false;
  }

  /**
   * 检测folderItem是否有效
   *
   * @param item 桌面元素
   * @returns foulderItem是否有效
   */
  public static isFolderItemValid(folderItem: FolderItemInfo | GridLayoutItemInfo | DockItemInfo | OpenFolderData):
    boolean {
    if (!folderItem || !folderItem.layoutInfo || folderItem.layoutInfo.length === 0) {
      log.showError('isFolderItemValid. item info invalid');
      return false;
    }
    for (let i = 0; i < folderItem.layoutInfo.length;) {
      let info = folderItem.layoutInfo[i];
      if (!info || info.length === 0) {
        folderItem.layoutInfo.splice(i, 1);
        log.showWarn('folderItem some page empty');
      } else {
        i++;
      }
    }
    return true;
  }

  /**
   * 获取当前应用名称
   * @param appItem 桌面元素
   */
  public static checkCurrentItemAppName(itemInfo: AppItemInfo | GridLayoutItemInfo): void {
    if (!CheckEmptyUtils.checkStrIsEmpty(itemInfo.appName)) {
      log.showWarn(`appName is not empty, appName: ${itemInfo.appName}`);
      return;
    }
    IconResourceManager.getInstance().getAppNameWithCallback(itemInfo.appLabelId, itemInfo.bundleName,
      itemInfo.moduleName, '', (appName: string): void => { itemInfo.appName = appName });
    log.showInfo(`get app name from resource manager: ${itemInfo.appName}`);
  }

  /**
   * 获取DH弹窗应用名称
   * @param bundleName 应用包名
   * @returns 应用名称
   */
  public static getdeliverAppName(bundleName: string | undefined): string {
    let appName = '';
    if (!bundleName || CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('bundleName is empty');
      return appName;
    }
    let appItems = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    if (!CheckEmptyUtils.isEmptyArr(appItems)) {
      GridLayoutUtil.checkCurrentItemAppName(appItems[0]);
      appName = appItems[0].appName as string;
    }
    log.showInfo(`getdeliverAppName: ${appName}`);
    return appName;
  }

  /**
   * 根据宫格参数初始化宫格位置工具类
   *
   * @param gridParam 宫格参数
   * @param foldScreenExpandPaddingLeft 折叠屏展开态左半屏宫格和右半屏宫格距屏幕左边缘的距离
   * @param screenWidth 屏幕宽度
   * @param centerX 宫格左上角到宫格元素中心点的x方向的距离，若不设置则默认为宫格宽度的一半
   * @param centerY 宫格左上角到宫格元素中心点的y方向的距离，若不设置则默认为宫格高度的一半
   */
  public static initGridPosition(gridParam: DragGridParam, foldScreenExpandPaddingLeft: number[], screenWidth: number,
    centerX?: number, centerY?: number): void {
    log.showInfo(`initGridPosition gridParam:${JSON.stringify(gridParam)} centerX:${centerX} centerY:${centerY}` +
      `foldScreenExpandPaddingLeft:${foldScreenExpandPaddingLeft} screenWidth:${screenWidth}`);
    GridLayoutUtil.positionUtil.initPosition(gridParam, centerX, centerY);
    GridLayoutUtil.foldScreenExpandPaddingLeft = [...foldScreenExpandPaddingLeft];
    GridLayoutUtil.screenWidth = screenWidth;
    GridLayoutUtil.columnCount = gridParam.column;
    GridLayoutUtil.rowCount = gridParam.row;
    GridLayoutUtil.isEditMode = false;
  }

  /**
   * 根据宫格参数初始化宫格位置工具类，如果是编辑模式更新编辑模式grid位置
   *
   * @param gridParam gridParam 宫格参数
   * @param foldScreenExpandPaddingLeft 折叠屏展开态左半屏宫格和右半屏宫格距屏幕左边缘的距离
   * @param centerX 宫格左上角到宫格元素中心点的x方向的距离，若不设置则默认为宫格宽度的一半
   * @param centerY 宫格左上角到宫格元素中心点的y方向的距离，若不设置则默认为宫格高度的一半
   */
  public static updateEditModeGridPosition(gridParam: DragGridParam,
    foldScreenExpandPaddingLeft: number[], centerX?: number, centerY?: number): void {
    log.showInfo(`updateEditModeGridPosition gridParam:${JSON.stringify(gridParam)} centerX:${centerX} centerY:${centerY}` +
      `foldScreenExpandPaddingLeft:${foldScreenExpandPaddingLeft}`);
    GridLayoutUtil.editModePositionUtil.initPosition(gridParam, centerX, centerY);
    GridLayoutUtil.foldScreenExpandPaddingLeftInEditMode = [...foldScreenExpandPaddingLeft];
    GridLayoutUtil.isEditMode = true;
  }

  /**
   *   获取布局元素所占的列数
   *
   * @param item 布局元素
   * @returns 返回布局元素所占的列
   */
  public static getColSpan(item: GridLayoutItemInfo): number {
    if (!item || !item.area) {
      return 1;
    }
    return item.area[0];
  }

  /**
   * 获取宫格左上角的坐标，行列无效时返回[-1,-1]
   *
   * @param row 所在宫格的行数
   * @param column 所在宫格的列数
   * @param page 宫格所在的页数，用来判断是在折叠屏的左半屏还是右半屏，若不传则默认是左半屏
   * @returns 宫格左上角的坐标
   */
  public static getGridItemPosition(row: number, column: number, page?: number): number[] {
    let positionUtil: GridItemPositionUtil =
      GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    let position: DragPosition =
      positionUtil.getPosition({ row: row, column: column }, GridLayoutUtil.getExpandPaddingLeft(page));
    GridLayoutUtil.updatePositionByRTL(position);
    return [position.x, position.y];
  }

  /**
   * 获取fold PC宫格左上角的坐标，行列无效时返回[-1,-1]
   * @param row 所在宫格的行数
   * @param column 所在宫格的列数
   * @param page 宫格所在的页数
   * @param isPortrait 是否为竖屏状态
   * @returns 宫格左上角的坐标
   */
  public static getSuperFoldGridItemPositionWithRTL(row: number, column: number, page: number, isPortrait: boolean): number[] {
    let positionUtil: GridItemPositionUtil =
      GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    let paddingLeft: number | undefined = isPortrait ? undefined : GridLayoutUtil.foldScreenExpandPaddingLeft[page % 2];
    let paddingTop: number | undefined = isPortrait ? GridLayoutUtil.foldScreenExpandPaddingLeft[page % 2] : undefined;
    let position: DragPosition = positionUtil.getPosition({ row: row, column: column }, paddingLeft, paddingTop);
    GridLayoutUtil.updatePositionByRTL(position);
    return [position.x, position.y];
  }

  /**
   * 获取fold PC宫格左上角的坐标，行列无效时返回[-1,-1]
   * @param row 所在宫格的行数
   * @param column 所在宫格的列数
   * @param page 宫格所在的页数
   * @param isPortrait 是否为竖屏状态
   * @returns 宫格左上角的坐标
   */
  public static getSuperFoldGridItemPosition(row: number, column: number, page: number, isPortrait: boolean): number[] {
    let positionUtil: GridItemPositionUtil =
      GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    let paddingLeft: number | undefined = isPortrait ? undefined : GridLayoutUtil.foldScreenExpandPaddingLeft[page % 2];
    let paddingTop: number | undefined = isPortrait ? GridLayoutUtil.foldScreenExpandPaddingLeft[page % 2] : undefined;
    let position: DragPosition = positionUtil.getPosition({ row: row, column: column }, paddingLeft, paddingTop);
    return [position.x, position.y];
  }

  /**
   * 不处理镜像模式：获取宫格左上角的坐标，行列无效时返回[-1,-1]
   *
   * @param row 所在宫格的行数
   * @param column 所在宫格的列数
   * @param page 宫格所在的页数，用来判断是在折叠屏的左半屏还是右半屏，若不传则默认是左半屏
   * @returns 宫格左上角的坐标
   */
  public static getGridItemPositionWithoutRTL(row: number, column: number, page?: number): number[] {
    let positionUtil: GridItemPositionUtil =
      GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    if (RTLUtil.isRTL()) {
      if (page !== undefined) {
        if (page & 1) {
          page--;
        } else {
          page++;
        }
      }
    }
    let position: DragPosition =
      positionUtil.getPosition({ row: row, column: column }, GridLayoutUtil.getExpandPaddingLeft(page));
    return [position.x, position.y];
  }

  /**
   * 获取宫格左上角的真实坐标（非编辑模式），行列无效时返回[-1,-1]
   *
   * @param item 布局元素
   * @returns 宫格左上角真实的坐标
   */
  public static getRealGridItemPosition(item: GridLayoutItemInfo): number[] {
    let column: number = item.column ?? 0;
    let row: number = item.row ?? 0;
    let page: number = item.page ?? 0;
    let span: number = GridLayoutUtil.getColSpan(item);
    column = RTLUtil.getColumnByRTL(column, GridLayoutUtil.columnCount, span);
    let paddingLeft: number | undefined = GridLayoutUtil.getExpandPaddingLeft(page, true);
    let position: DragPosition = GridLayoutUtil.positionUtil.getPosition({ row: row, column: column }, paddingLeft);
    log.showInfo('getRealGridItemPosition: column=%{public}d, paddingLeft=%{public}d, position.x=%{public}d, ' +
      'position.y=%{public}d, columnCount=%{public}d, span=%{public}d', column, paddingLeft, position.x, position.y,
      GridLayoutUtil.columnCount, span);
    return [position.x, position.y];
  }

  /**
   * 获取宫格中桌面元素中心点的坐标，行列无效时返回[-1,-1]
   * 与宫格的中心点不同，是桌面元素除名称之外部分的中心点，对于图标、卡片、文件夹等均有效
   *
   * @param row 桌面元素左上角宫格的行数
   * @param column 桌面元素左上角宫格的列数
   * @param area 桌面元素的宽高所占宫格数
   * @param page 桌面元素所在的页数
   * @returns 桌面元素中心点的坐标
   */
  public static getIconCenterPosition(row: number | undefined, column: number | undefined,
    area?: number[], page?: number, isVertical?: boolean, isRealCenter?: boolean): number[] {
    let positionUtil: GridItemPositionUtil = GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    const displayCount = PageInfoManager.getInstance().getDisplayCount();
    let isSuperFoldMachine = DeviceHelper.isSuperFoldMachine()
    if (RTLUtil.isRTL() && page !== undefined && !isSuperFoldMachine) {
      page = displayCount - 1 - page % displayCount + Math.floor(page / displayCount) * displayCount;
    }
    let paddingLeft = isSuperFoldMachine ? GridLayoutUtil.getExpandPaddingLeft(page) : undefined;
    log.showInfo(`getIconCenterPosition isSuperFoldMachine:${isSuperFoldMachine},page:${page},paddingLeft:${paddingLeft},displayCount:${displayCount}`);
    let position: DragPosition = positionUtil.getCenterPosition({ row: row, column: column, area: area }, paddingLeft, undefined, isRealCenter);
    if (DeviceHelper.isSuperFoldMachine()) {
      position = isVertical
        ? positionUtil.getCenterPosition({ row: row, column: column, area: area }, undefined, GridLayoutUtil.getExpandPaddingTop(0, page), isRealCenter)
        : positionUtil.getCenterPosition({ row: row, column: column, area: area }, GridLayoutUtil.getExpandPaddingTop(0, page), undefined, isRealCenter);
    }
    GridLayoutUtil.updatePositionByRTL(position);
    return [position.x, position.y];
  }

  /**
   * 不处理镜像模式：获取宫格中桌面元素中心点的坐标，行列无效时返回[-1,-1]
   * 与宫格的中心点不同，是桌面元素除名称之外部分的中心点，对于图标、卡片、文件夹等均有效
   *
   * @param row 桌面元素左上角宫格的行数
   * @param column 桌面元素左上角宫格的列数
   * @param area 桌面元素的宽高所占宫格数
   * @param page 桌面元素所在的页数
   * @returns 桌面元素中心点的坐标
   */
  public static getIconCenterPositionWithoutRTL(row: number, column: number, area?: number[], page?: number,
    isPortrait?: boolean): number[] {
    let positionUtil: GridItemPositionUtil =
      GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    let position: DragPosition =
      positionUtil.getCenterPosition({ row: row, column: column, area: area },
        GridLayoutUtil.getExpandPaddingLeft(page));
    if (DeviceHelper.isSuperFoldMachine()) {
      position = isPortrait ? positionUtil.getCenterPosition({ row: row, column: column, area: area },
        undefined, GridLayoutUtil.getExpandPaddingTop(0, page)) :
      positionUtil.getCenterPosition({ row: row, column: column, area: area },
        GridLayoutUtil.getExpandPaddingTop(0, page));
    }
    return [position.x, position.y];
  }

  /**
   * 获取宫格中桌面元素中心点的真实坐标（非编辑模式），行列无效时返回[-1,-1]
   * 与宫格的中心点不同，是桌面元素除名称之外部分的中心点，对于图标、卡片、文件夹等均有效
   *
   * @param row 桌面元素左上角宫格的行数
   * @param column 桌面元素左上角宫格的列数
   * @param area 桌面元素的宽高所占宫格数
   * @param page 桌面元素所在的页数
   * @returns 桌面元素中心点真实的坐标
   */
  public static getRealIconCenterPosition(row: number, column: number, area: number[], page: number): number[] {
    column = RTLUtil.getColumnByRTL(column, GridLayoutUtil.columnCount, area[0]);
    let position: DragPosition =
      GridLayoutUtil.positionUtil.getCenterPosition({ row: row, column: column, area: area },
        GridLayoutUtil.getExpandPaddingLeft(page, true));
    return [position.x, position.y];
  }

  /**
   * 根据页数获取折叠屏展开态宫格距屏幕左边缘的距离，若设备不是折叠屏或是折叠屏折叠态，则返回undefined
   *
   * @param page 页数
   * @returns 宫格距屏幕左边缘的距离
   */
  private static getExpandPaddingLeft(page?: number, isGettingRealPosition?: boolean): number | undefined {
    let currentPaddingLeft = GridLayoutUtil.isEditMode ?
      GridLayoutUtil.foldScreenExpandPaddingLeftInEditMode : GridLayoutUtil.foldScreenExpandPaddingLeft;
    if (isGettingRealPosition) {
      currentPaddingLeft = GridLayoutUtil.foldScreenExpandPaddingLeft;
    }
    let paddingLeft: number | undefined = undefined;
    const displayCount = PageInfoManager.getInstance().getDisplayCount();
    if (page === undefined) {
      return paddingLeft;
    }
    if (RTLUtil.isRTL()) {
      paddingLeft = currentPaddingLeft[displayCount - 1 - (page % displayCount)];
    } else {
      paddingLeft = currentPaddingLeft[page % displayCount];
    }
    log.showInfo(`getExpandPaddingLeft page:${page}%${displayCount}=${page %
      displayCount},currentPaddingLeft:${currentPaddingLeft.toString()},paddingLeft ${paddingLeft},`);
    return paddingLeft;
  }

  /**
   * hopper专属，初始化时foldScreenExpandPaddingLeft中竖屏传入paddingTop, 横屏传入paddingLeft
   * 根据页数获得折叠屏宫格上边缘的距离
   * @param position
   */

  private static getExpandPaddingTop(y: number, page?: number): number | undefined {
    if (page != null) {
      return page === 0 ? GridLayoutUtil.foldScreenExpandPaddingLeft[0] : GridLayoutUtil.foldScreenExpandPaddingLeft[1];
    }
    let paddingTop : number | undefined = undefined;
    log.showInfo(`GridLayoutUtil y ${y}, foldScreenExpandPaddingLeft ${JSON.stringify(GridLayoutUtil.foldScreenExpandPaddingLeft)}`);
    if (y < GridLayoutUtil.foldScreenExpandPaddingLeft[1]) {
      return paddingTop;
    }
    return GridLayoutUtil.foldScreenExpandPaddingLeft[1];
  }

  private static updatePositionByRTL(position: DragPosition): void {
    if (RTLUtil.isRTL()) {
      position.x = GridLayoutUtil.screenWidth - position.x;
    }
  }

  /**
   * ArkUI布局计算像素参数时会向下取整，故应用根据自己的参数计算布局位置时也要用像素向下取整后的参数，否则会和实际布局显示有偏差
   *
   * @param vp 布局参数的vp值
   * @returns 像素向下取整后的vp值
   */
  public static getFloorVp(vp: number): number {
    let px: number = vp2px(vp);
    return px2vp(Math.floor(px));
  }

  public static getCeilVp(vp: number): number {
    let px: number = vp2px(vp);
    return px2vp(Math.ceil(px));
  }

  /**
   * 针对vp对应的px进行四舍五入取证，通常用于宽高的像素计算
   *
   * @param vp 布局参数的vp值
   * @returns 像素四舍五入取整后的vp值
   */
  public static getRoundVp(vp: number): number {
    let px: number = vp2px(vp);
    return px2vp(Math.round(px));
  }

  /**
   * 根据坐标获取拖拽元素所在网格的行列
   *
   * @param x 拖拽元素x轴坐标
   * @param y 拖拽元素y轴坐标
   * @returns 拖拽元素所在宫格的行列
   */
  public static getRowAndColumn(x: number, y: number, page: number): DragGridPosition {
    let positionUtil: GridItemPositionUtil =
      GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    return positionUtil.getRowAndColumn(x, y, GridLayoutUtil.getExpandPaddingLeft(page));
  }

  public static getRowAndColumnAndPage(x: number, y: number, isPortrait?: boolean): DragGridPosition {
    let positionUtil: GridItemPositionUtil =
      GridLayoutUtil.isEditMode ? GridLayoutUtil.editModePositionUtil : GridLayoutUtil.positionUtil;
    return isPortrait ? positionUtil.getRowAndColumnAndPage(x, y, undefined,
      GridLayoutUtil.getExpandPaddingTop(y), isPortrait) :
      positionUtil.getRowAndColumnAndPage(x, y, GridLayoutUtil.getExpandPaddingTop(x), undefined, isPortrait);
  }

  public static changeDragGridPositionToExpand(position: DragGridPosition, isPortrait: boolean, rowCount: number,
    columnCount: number): DragGridPosition {
    let newPosition: DragGridPosition = position;
    if (isPortrait) {
      newPosition.row = position.row + (position.page ?? 0) * rowCount;
    } else {
      newPosition.column = position.column + (position.page ?? 0) * columnCount;
    }
    return newPosition;
  }

  public static changeDragGridPositionToFold(position: DragGridPosition, isPortrait: boolean, rowCount: number,
    columnCount: number): DragGridPosition {
    let newPosition: DragGridPosition = position;
    if (isPortrait) {
      newPosition.page = position.row >= rowCount ? 1 : 0;
      newPosition.row = newPosition.page === 1 ? position.row - rowCount : position.row;
    } else {
      newPosition.page = position.column >= columnCount ? 1 : 0;
      newPosition.column = newPosition.page === 1 ? newPosition.column - columnCount : newPosition.column;
    }
    return newPosition;
  }

  /**
   * 获取企业应用的URL
   * @param appItemInfo
   * @returns
   */
  public static getAppEnterpriseUrl(appItemInfo: AppItemInfo): string {
    let enterpriseUrl = '';
    if (appItemInfo.intent) {
      try {
        let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(appItemInfo.intent);
        enterpriseUrl = extendInfo.has('targetModuleUrl') ? String(extendInfo.get('targetModuleUrl')) : '';
      } catch (e) {
        log.showError('getAppEnterpriseUrl fail: ' + e);
      }
    }
    return enterpriseUrl;
  }

  /**
   * 获取单个拖拽元素
   * @returns
   */
  public static getSingleDragItemInfo(): GridLayoutItemInfo {
    const itemInfoList = AppStorage.get<GridLayoutItemInfo | GridLayoutItemInfo[]>('dragItemInfo');
    const dragItem: GridLayoutItemInfo | undefined = Array.isArray(itemInfoList) ? itemInfoList[0] : itemInfoList;
    return dragItem ?? new GridLayoutItemInfo();
  }

  /**
   * 获取多个拖拽元素数组
   *
   * @returns 拖拽元素数组
   */
  public static getDragItemList(): GridLayoutItemInfo[] {
    let dragObj = AppStorage.get<Object>('dragItemInfo');
    if (!dragObj) {
      log.showError(`drop without drag item`);
      return [];
    }
    let dragItems: GridLayoutItemInfo[];
    if (Array.isArray(dragObj)) {
      if (dragObj.length === 0) {
        log.showError(`drop with empty drag array`);
        return [];
      }
      dragItems = dragObj as GridLayoutItemInfo[];
    } else {
      dragItems = [dragObj as GridLayoutItemInfo];
    }
    return dragItems;
  }

  /**
   * 是否支持大卡片,当前最大的卡片为6*4
   *
   * @param cardDimension 卡片维度
   * @returns true支持大卡片
   */
  public static isSupportLargeForm(cardDimension: number): boolean {
    let formSize: number[] = CardItemInfo.getCardSize(cardDimension);
    if (DeviceHelper.isPad()) {
      let maxValue = Math.max(formSize[1], formSize[0]);
      return (GridLayoutUtil.rowCount >= maxValue && GridLayoutUtil.columnCount >= maxValue);
    } else {
      return (GridLayoutUtil.rowCount >= formSize[1] && GridLayoutUtil.columnCount >= formSize[0]);
    }
  }

  /**
   * 是否为大折叠展开态
   *
   * @returns 大折叠展开状态
   */
  public static isLargeFoldExpanded(): boolean {
    const folderStatus: DeviceState | undefined = AppStorage.get<DeviceState>('folderStatus');
    return GridLayoutUtil.isLargeFold && folderStatus === DeviceState.EXPAND_STATE;
  }

  /**
   * 是否为三折叠展开态
   *
   * @returns 三折叠展开状态
   */
  public static isTrifoldExpanded(): boolean {
    return DeviceHelper.isThreeFoldProduct() && !DeviceHelper.isFState();
  }

  public static isLargeFoldOrTrifoldExpanded(): boolean {
    return GridLayoutUtil.isLargeFoldExpanded() || GridLayoutUtil.isTrifoldExpanded();
  }

  /**
   * 判断应用是否是应用本体
   *
   * @param item 应用信息
   * @return 应用是否是本体
   */
  public static isMajorApp(item: GridLayoutItemInfo): boolean {
    return (item.appIndex === 0 || item.appIndex === undefined) &&
      item.typeId === CommonConstants.TYPE_APP;
  }

  public static isFileFolderItemModified(fileInfo: DesktopFileInfo, fileItem: GridLayoutItemInfo): boolean {
    return fileInfo.thumbnail !== fileItem.appIconId || fileItem.fileFolderName !== fileInfo.fileName ||
      fileItem.uri !== fileInfo.uri || fileItem.size !== fileInfo.size || fileItem.ctime !== fileInfo.ctime ||
      fileItem.mtime !== fileInfo.mtime;
  }


  /**
   * 判断应用是否是应用本体
   *
   * @param item 应用信息
   * @return 应用是否是本体
   */
  public static isValidArea(area: number[]): boolean {
    return (area && area.length === 2 && !Number.isNaN(area[0]) && area[0] > 0 &&
      !Number.isNaN(area[1]) && area[1] > 0);
  }

    /**
   * 获取宫格高度
   *
   * @return 宫格高度
   */
  public static getGridHeight(): number {
    return GridLayoutUtil.positionUtil.getItemHeight();
  }

  public static getSortRankByPageRowColumn(item: GridLayoutItemInfo, maxRow: number, maxColumn: number): number {
    if (item.page === undefined || item.row === undefined || item.column === undefined) {
      return NumberConstants.CONSTANT_NUMBER_THREE_THOUSAND;
    }
    return item.page * maxRow * maxColumn + item.row * maxColumn + item.column;
  }

  /**
   * 判断拖拽图标能否和桌面图标形成文件夹
   * @param iconSize 拖拽图长宽尺寸
   * @param dragItemPosition 拖拽图中心点位置
   * @param coverItemPosition 桌面图标中心点位置
   * @param avgVX 横轴上拖拽方向
   * @param avgVY 纵轴上拖拽方向
   *
   * @return 能否形成文件夹
   */
  public static canCreateFolder(
    iconSize: number,
    dragItemPosition: number[],
    coverItemPosition: number[],
    avgVX: number[],
    avgVY: number[]
  ): boolean {
    // 用求和采样的方式来稳定拖拽方向
    let vX = 0;
    for (let i = 0; i < avgVX.length; i++) {
      vX += avgVX[i];
    }
    let vY = 0;
    for (let i = 0; i < avgVY.length; i++) {
      vY += avgVY[i];
    }
    // 获取拖拽图和目标元素的上下左右坐标点
    const dragItemTop = dragItemPosition[1] - iconSize / CommonConstants.NUMBER_TWO;
    const dragItemBottom = dragItemPosition[1] + iconSize / CommonConstants.NUMBER_TWO;
    const dragItemLeft = dragItemPosition[0] - iconSize / CommonConstants.NUMBER_TWO;
    const dragItemRight = dragItemPosition[0] + iconSize / CommonConstants.NUMBER_TWO;
    log.showDebug(`canIconCover dragItemTop ${dragItemTop} dragItemBottom ${dragItemBottom} dragItemLeft ${dragItemLeft} dragItemRight ${dragItemRight}`);
    const coverItemTop = coverItemPosition[1] - iconSize / CommonConstants.NUMBER_TWO;
    const coverItemBottom = coverItemPosition[1] + iconSize / CommonConstants.NUMBER_TWO;
    const coverItemLeft = coverItemPosition[0] - iconSize / CommonConstants.NUMBER_TWO;
    const coverItemRight = coverItemPosition[0] + iconSize / CommonConstants.NUMBER_TWO;
    log.showDebug(`canIconCover coverItemTop ${coverItemTop} coverItemBottom ${coverItemBottom} coverItemLeft ${coverItemLeft} coverItemRight ${coverItemRight}`);
    // y轴上有接触，x轴上覆盖面积大于宽度的70%
    const xCover = dragItemRight > coverItemLeft &&
      dragItemLeft < coverItemRight &&
      (Math.min(Math.abs(coverItemRight - dragItemLeft), Math.abs(dragItemRight - coverItemLeft)) >= iconSize * 0.6);
    // x轴上有接触，y轴上覆盖面积大于宽度的70%
    const yCover = dragItemTop < coverItemBottom &&
      dragItemBottom > coverItemTop &&
      (Math.min(Math.abs(dragItemBottom - coverItemTop), Math.abs(coverItemBottom - dragItemTop)) >= iconSize * 0.6);
    log.showDebug(`canIconCover xCover ${xCover} yCover ${yCover}`);
    if (vX == null || vY == null) {
      return xCover || yCover;
    }
    log.showDebug(`canIconCover vX ${vX} vY ${vY} coverItemCenter ${coverItemPosition[0]} ${coverItemPosition[1]}`);
    // 接触面积足够时，判断下当前拖拽方向上是否正在拖拽离开目标图标
    const xMoveNotOver = yCover &&
      !((vX > 0 && dragItemLeft > coverItemPosition[0]) || (vX < 0 && dragItemRight < coverItemPosition[0]));
    const yMoveNotOver = xCover &&
      !((vY > 0 && dragItemTop > coverItemPosition[1]) || (vY < 0 && dragItemBottom < coverItemPosition[1]));
    return xMoveNotOver || yMoveNotOver;
  }
}

export enum ItemsCount {
  /**
   * 文件夹占位1时显示1个图标
   */
  SIZE_1 = 1,
  /**
   * 文件夹占位2时显示3个图标
   */
  SIZE_2 = 3,
  /**
   * 文件夹占位4时显示6个图标
   */
  SIZE_4 = 6,
}

export enum AreaSpan {
  SPAN_1 = 1,
  SPAN_2 = 2,
  SPAN_4 = 4
}