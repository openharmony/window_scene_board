/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  LogDomain,
  LogHelper,
  RectItem,
  SingleContext
} from '@ohos/basicutils';
import dataPreferences from '@ohos.data.preferences';
import { DeviceHelper, GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import { GridOccupyStatus, GridOccupyStatusEnum } from '@ohos/componentdrag';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { PageUpdateItem } from '../../bean/PageUpdateItem';
import BadgeItemInfo from '../../bean/BadgeItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AppStatus, CommonConstants, SuperFoldConstants, DeleteItemType, DownloadInfoItem } from '../../constants/CommonConstants';
import { ExtraInfo, RdbStoreManager } from '../../db/RdbStoreManager';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { SmallFolderIconFileUtil } from '../../utils/SmallFolderIconFileUtil';
import GridLayoutInfoColumns from '../../db/column/GridLayoutInfoColumns';
import { CardItemInfo } from '../../bean/CardItemInfo';
import LayoutDescription from '../../bean/LayoutDescription';
import { ArrayList, HashMap, HashSet } from '@kit.ArkTS';
import DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import { BaseBundleInfo } from '../../bean/BaseBundleInfo';
import lazy { Widget, LayoutRotatePacking } from 'libLayoutRotatePacking.so';
import { DockItemInfo } from '../../bean/DockItemInfo';
import { launcherStatusUtil } from '@ohos/windowscene';
import { CardNodeControllerManager } from '../../manager/CardNodeControllerManager';
import { SceneMsgEnum } from '../../TsIndex';

const SORT_TYPE_REGULAR: string = 'regular'; // 一字排序
const SORT_TYPE_FINAL: string = 'final'; // 兜底排序
const TYPE_ID: string = 'typeId';
const CARD_ID: string = 'cardId';
const STACK_ID: string = 'stackId';
const INFO_ID: string = 'infoId';
const FOLDER_NAME: string = 'folderName';
const FOLDER_ID: string = 'folderId';
const LARGE_CARD_COLUMN: number = 4;
const LARGE_CARD_AREA: number = 16;
const DEFAULT_CLOCK_CARD_HEIGHT: number = 2;
const DEFAULT_CLOCK_CARD_WIDTH: number = 4;
const MID_CARD_AREA: number = 8;
const MAX_ROW: number = 32;
const CLOCK_ROW: number = 2;
const MAX_UPDOWN_ROW: number = 3;
const PAGE_SCALE: number = 10000;
const ROW_SCALE: number = 100;
const OUTER_DESKTOP_GRIDLAYOUT: number = 4;
const CLOCK_WEATHER_CARD_NAME: string = 'ClockWeatherCard';
const CLOCK_WEATHER_BUNDLE_NAME: string = 'com.ohos.totemweather';
const ROTATE_DEVICE_FIRST_ROTATE: string = 'ROTATE_DEVICE_FIRST_ROTATE';
const TAG = 'LauncherLayoutCacheUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum LayoutRotateType {
  VERTICAL_TO_LANDSCAPE = 0,
  LANDSCAPE_TO_VERTICAL = 1
}
//LauncherLayoutCacheUtil 待后续产品解耦，去除方法中掺杂的多种设备判断
export class LauncherLayoutCacheUtil {
  /**
   * 双缓存转屏规格，首次竖转横才使用算法，非首次则横竖屏使用各自单独缓存
   */
  private static isLazyRotate: boolean = false;
  private static isPadPortrait: boolean = false;
  private static isDefaultPortrait: boolean = false;
  private static padRotateAfterBackup: boolean = false;
  private static isFirstRotate: boolean | undefined = undefined;
  private static portraitDesktopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
  private static landscapeDesktopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
  private static updateLandscapeCacheData: (info: DefaultDesktopLayoutInfo) => void = () => {};
  private static updatePortraitCacheData: (info: DefaultDesktopLayoutInfo) => void = () => {};

  /**
   * isLazyRotate: 双缓存转屏规格，首次竖转横才使用算法，非首次则横竖屏使用各自单独缓存
   */
  static setIsLazyRotate(isLazyRotate: boolean): void {
    LauncherLayoutCacheUtil.isLazyRotate = isLazyRotate;
  }

  /**
   * isLazyRotate: 双缓存转屏规格，首次竖转横才使用算法，非首次则横竖屏使用各自单独缓存
   */
  static getIsLazyRotate(): boolean {
    return LauncherLayoutCacheUtil.isLazyRotate;
  }

  static setIsDefaultPortrait(isPortrait: boolean): void {
    LauncherLayoutCacheUtil.isDefaultPortrait = isPortrait;
    LauncherLayoutCacheUtil.firstRotateTagCorrect();
  }

  static setIsPadPortrait(isPortrait: boolean): void {
    LauncherLayoutCacheUtil.isPadPortrait = isPortrait;
  }

  static getIsPadPortrait(): boolean {
    return LauncherLayoutCacheUtil.isPadPortrait;
  }

  static setPortraitDesktopLayoutInfo(portraitDesktopLayoutInfo: DefaultDesktopLayoutInfo): void {
    LauncherLayoutCacheUtil.portraitDesktopLayoutInfo = portraitDesktopLayoutInfo;
  }

  static setLandscapeDesktopLayoutInfo(landscapeDesktopLayoutInfo: DefaultDesktopLayoutInfo): void {
    LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo = landscapeDesktopLayoutInfo;
  }

  static setUpdateLandscapeCacheCb(updateLandscapeCacheData: (info: DefaultDesktopLayoutInfo) => void): void {
    LauncherLayoutCacheUtil.updateLandscapeCacheData = updateLandscapeCacheData;
  }

  static setUpdatePortraitCacheCb(updatePortraitCacheData: (info: DefaultDesktopLayoutInfo) => void): void {
    LauncherLayoutCacheUtil.updatePortraitCacheData = updatePortraitCacheData;
  }

  static setPadRotateAfterBackup(padRotateAfterBackup: boolean): void {
    LauncherLayoutCacheUtil.padRotateAfterBackup = padRotateAfterBackup;
  }

  static getPadRotateAfterBackup(): boolean {
    return LauncherLayoutCacheUtil.padRotateAfterBackup;
  }

  static getSuperFoldLazyRotate(): boolean {
    return LauncherLayoutCacheUtil.isLazyRotate && DeviceHelper.isSuperFoldMachine();
  }

  static dealWithRotateAfterBackup(isExist: boolean, backupUrl?: string, copyUrl?: string): boolean {
    if (!DeviceHelper.isPad()) {
      log.showWarn(`dealWithRotateAfterBackup is not Pad return!`);
      return false;
    }
    if (!isExist) {
      LauncherLayoutCacheUtil.putIsFirstRotate(true);
      return false;
    }
    if (backupUrl && copyUrl) {
      return true;
    }
    return false;
  }

  /**
   * 更新页数的数据库回调
   */
  static updatePageCountCallBack: Function = (pageCount: number, isOuter?: boolean): void => {
    RdbStoreManager.getInstance().updateDesktopPageCount(pageCount, isOuter);
  };

  /**
   * 批量更新布局元素信息的数据库操作回调
   */
  static patchUpdateGridLayoutPositionCallBack: Function = (updateInfo: GridLayoutItemInfo[], isOuter?: boolean): void => {
    log.showInfo(`patchUpdateGridLayoutPositionCallBack length:${updateInfo?.length}, isOuter:${isOuter}`);
    let targetInfo: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getChangeItems(updateInfo);
    RdbStoreManager.getInstance().updateGridLayoutPositionBatch(targetInfo, isOuter);
  };

  /**
   * 更新布局元素信息的数据库操作回调
   */
  static updateRegionFolderAndSubItemsCallBack: Function = (folder: GridLayoutItemInfo): void => {
    log.showInfo(`updateRegionFolderAndSubItemsCallBack id:${folder?.infoId}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([folder])[0];
    RdbStoreManager.getInstance().updateRegionFolderAndSubItemsInfo(targetInfo);
  };

  /**
   * 更新应用下载状态的数据库操作回调
   */
  static updateDownloadAppCallBack: Function = (downloadInfo: DownloadInfoItem): void => {
    RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
  };

  /**
   * 更新文件夹位置信息的回调
   */
  static updateFolderSizeCallBack: Function = (updateInfoList: GridLayoutItemInfo[], isConvertToSmall: boolean,
    isOuter?: boolean): void => {
    log.showInfo(`updateFolderSizeCallBack length:${updateInfoList?.length}, isConvertToSmall:${isConvertToSmall}`);
    let targetInfo: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getChangeItems(updateInfoList);
    RdbStoreManager.getInstance().updateInfoPosition(targetInfo, 'updateFolderSize',
      new ExtraInfo(CommonConstants.CONTAINER_DESKTOP, isConvertToSmall, isOuter));
  };

  /**
   * 通过info_id唯一键更新元素到桌面，若参数列表中存在对象特性ID(cardId、folderId等)为空，则全部不更新
   */
  static updateItemToDesktopCallBack: Function = (updateInfoList: GridLayoutItemInfo[], isOuter?: boolean): void => {
    log.showInfo(`updateItemToDesktopCallBack length:${updateInfoList?.length}`);
    let targetInfo: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getChangeItems(updateInfoList);
    RdbStoreManager.getInstance().updateInfoPosition(targetInfo, 'updateItemToDesktop',
      new ExtraInfo(undefined, undefined, isOuter));
  };

  /**
   * 更新元素的位置和container
   */
  static updateItemWithContainerCallBack: Function = (updateInfoList: GridLayoutItemInfo[], container?: number, isOuter?: boolean): void => {
    log.showInfo(`updateItemWithContainerCallBack length:${updateInfoList?.length}`);
    let targetInfo: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getChangeItems(updateInfoList);
    RdbStoreManager.getInstance().updateInfoPosition(targetInfo, 'updateItemWithContainer',
      new ExtraInfo(container, undefined, isOuter));
  };


  /**
   * 通过id主键删除元素
   */
  static deleteLayoutInfoById(deleteList: GridLayoutItemInfo[], isOuter?: boolean): void {
    log.showInfo(`deleteLayoutInfoById length:${deleteList?.length}`);
    deleteList.forEach(targetInfo => {
      RdbStoreManager.getInstance().deleteLayoutInfoById(targetInfo, isOuter);
    });
  }

  /**
   * 根据bundleName更新角标
   */
  static updateBadgeByBundleNameCallBack: Function = (bundleInfo: BaseBundleInfo, badgeNum: number): void => {
    RdbStoreManager.getInstance().updateBadgeNumByBundle(bundleInfo, badgeNum);
  };

  /**
   * 插入一个布局元素的数据库操作回调
   */
  static insertGridLayoutItemCallBack: Function = async (item: GridLayoutItemInfo, isOuter?: boolean, ctx?: SingleContext): Promise<void> => {
    log.showInfo(`insertGridLayoutItemCallBack isOuter:${isOuter}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([item])[0];
    if (DeviceHelper.isPC()) {
      await RdbStoreManager.getInstance().insertGridLayoutInfoIfNotExist(targetInfo, ctx);
    } else {
      await RdbStoreManager.getInstance().insertLayoutInfoNotExist(targetInfo, isOuter);
    }
  };
  /**
   * 插入布局元素到数据库（仅支持手机，pad)
   * @param item
   * @param isOuter
   * @returns 插入元素的id（行号）
   */
  static async insertItemWithoutLayoutInfo(item: GridLayoutItemInfo, isOuter?: boolean): Promise<number> {
    log.showInfo(`insertItemWithoutLayoutInfo isOuter:${isOuter}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([item])[0];
    return RdbStoreManager.getInstance().insertItemWithoutLayoutInfo(targetInfo, isOuter);
  }

  /**
   * 插入文件夹到数据库
   *
   * @param item 文件夹元素
   * @param isOuter 是否是小外屏桌面
   * @returns 文件夹主键id
   */
  static async insertFolderLayoutInfo(item: GridLayoutItemInfo, isOuter?: boolean): Promise<number> {
    log.showInfo(`insertFolderLayoutInfo isOuter:${isOuter}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([item])[0];
    return await RdbStoreManager.getInstance().insertFolderLayoutInfo(targetInfo, isOuter);
  }

  /**
   * 插入分区文件夹到数据库
   *
   * @param item 文件夹元素
   * @returns 是否插入成功
   */
  static async insertRegionFolderLayout(item: GridLayoutItemInfo): Promise<boolean> {
    log.showInfo(`insertRegionFolderLayout folderId:${item.folderId}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([item])[0];
    let subItems = targetInfo.layoutInfo?.flat() ?? [];
    return await RdbStoreManager.getInstance().insertFolderLayout(targetInfo, subItems);
  }

  /**
   * 插入新卡片到堆叠
   */
  static insertNewFormStackInfoCallBack: Function = (formStackInfo: GridLayoutItemInfo,
    cardListInfo: GridLayoutItemInfo[], needInsertLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void => {
    this.insertNewFormStackInfoCallBackFun(formStackInfo, cardListInfo, needInsertLayoutInfo, isOuter);
  };

  static async insertNewFormStackInfoCallBackFun(formStackInfo: GridLayoutItemInfo,
    cardListInfo: GridLayoutItemInfo[], needInsertLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): Promise<void> {
    log.showInfo(`insertNewFormStackInfoCallBackFun length:${cardListInfo?.length}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([formStackInfo])[0];
    RdbStoreManager.getInstance().insertFormStackLayout(targetInfo, cardListInfo, needInsertLayoutInfo, isOuter);
  }

  /**
   * 插入元素且添加到数据库回调
   */
  static insertGridLayoutListCallBack: Function = (gridlayoutItems: GridLayoutItemInfo[], isOuter?: boolean, ctx?: SingleContext): void => {
    log.showInfo(`insertGridLayoutListCallBack length:${gridlayoutItems?.length} isOuter:${isOuter}`);
    RdbStoreManager.getInstance().insertGridLayoutInfo(gridlayoutItems, true, isOuter, ctx);
  };

  /**
   * 插入新安装应用的数据库回调
   */
  static insertNewInstalledAppCallBack: Function = (appItem: GridLayoutItemInfo): void => {
    log.showInfo('insertNewInstalledAppCallBack');
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([appItem])[0];
    RdbStoreManager.getInstance().updateNewInstalledGridInfo(targetInfo, false);
  };

  /**
   * 添加应用到文件夹
   */
  static addInfoToFolderCallBack: Function = (folderId: string, items: GridLayoutItemInfo[]): void => {
    log.showInfo(`addInfoToFolderCallBack length:${items?.length}`);
    RdbStoreManager.getInstance().addInfoToFolder(folderId, items);
  };

  /**
   * 删除文件夹item的回调
   */
  static deleteFolderItemCallBack: Function = (folderItem: GridLayoutItemInfo, isUpdateLandscape: boolean = false) => {
    if (CheckEmptyUtils.isEmpty(folderItem)) {
      log.showWarn('deleteFolderItemCallBack failure as the folderItem is null');
      return;
    }
    log.showWarn(`deleteFolderItemCallBack ${folderItem.folderId}`);
    RdbStoreManager.getInstance().deleteItemByInfoId(folderItem.folderId ?? '', false);
    ResourceManager.getInstance().deleteAppResourceCache(folderItem.folderId, '');
    if (GridLayoutUtil.isSmallFolder(folderItem)) {
      SmallFolderIconFileUtil.deleteFolderIcon(folderItem.folderId ?? '');
    }
  };

  /**
   * 快捷图标移除的回调: PAD横竖屏布局转换和删除数据库
   */
  static deleteShortcutItemCallBack: Function = (deleteAppItems: GridLayoutItemInfo[], isOuter?: boolean): void => {
    if (!LauncherLayoutCacheUtil.isDefaultPortrait && LauncherLayoutCacheUtil.isPadPortrait) {
      LauncherLayoutCacheUtil.updateLandscapeCacheFromPortrait(this.getAppItemListPage(deleteAppItems));
    } else if (LauncherLayoutCacheUtil.isDefaultPortrait && !LauncherLayoutCacheUtil.isPadPortrait) {
      LauncherLayoutCacheUtil.updatePortraitCacheFromLandscape(this.getAppItemListPage(deleteAppItems));
    }
    for (const item of deleteAppItems) {
      RdbStoreManager.getInstance()
        .deleteShortcutItem(item.bundleName, item.shortcutId ?? '', item.appIndex ?? 0, isOuter);
    }
  };

  /**
   * 删除应用的回调
   */
  static deleteAppItemCallBack: Function =
    (appItem: DeleteItemType, deleteAppItems: GridLayoutItemInfo[], isOuter?: boolean): void => {
    if (!DeviceHelper.isPhone()) {
      RdbStoreManager.getInstance().deleteGridLayoutByCondition({
        bundleName: appItem.bundleName ?? '',
        abilityName: appItem.abilityName ?? '',
        moduleName: appItem.moduleName,
        appIndex: appItem.appIndex,
        typeId: appItem.typeId
      }, undefined, false, SceneMsgEnum.DELETE_APP_ITEM_CALLBACK);
    }

    for (const item of deleteAppItems) {
      if (DeviceHelper.isPhone() && !appItem.deleteByDockDrop) {
        RdbStoreManager.getInstance().deleteInfoByBundle(item.bundleName, 0, item.appIndex, isOuter);
      }
      if (this.isPadPortrait && DeviceHelper.isPad()) {
        this.landscapeDesktopLayoutInfo.layoutInfo = this.landscapeDesktopLayoutInfo.layoutInfo.filter(layoutItem => {
          return !(layoutItem.bundleName === item.bundleName && layoutItem.appIndex === item.appIndex);
        });
      }
    }
  };

  /**
   * 根据keyName删除item
   */
  static deleteGridLayoutItemByKeyNameCallBack: Function = (item: GridLayoutItemInfo, containId?: number): void => {
    RdbStoreManager.getInstance()
      .deleteGridLayoutByCondition(item, containId, false, SceneMsgEnum.DELETE_GRID_LAYOUT_BY_KEYNAME);
  };

  /**
   * 批量删除item的接口
   */
  static patchDeleteGridLayoutItemCallBack: Function = (deleteItems: GridLayoutItemInfo[]): void => {
    for (const item of deleteItems) {
      RdbStoreManager.getInstance().deleteItemByInfoId(item.infoId ?? '');
    }
  };

  /**
   * 根据infoId和container批量删除item的接口
   */
  static patchDeleteGridLayoutItemByContainerCallBack: Function = (deleteItems: GridLayoutItemInfo[]): void => {
    RdbStoreManager.getInstance().deleteItemsByInfoIdAndContainer(deleteItems);
  };

  /**
   * 根据infoId删除item
   */
  static deleteGridLayoutItemByInfoIdCallBack: Function = (infoId: string, updatePages: number[], isOuter?: boolean): void => {
    RdbStoreManager.getInstance().deleteItemByInfoId(infoId, isOuter);
  };

  /**
   * 根据卡片id删除卡片
   */
  static deleteFormByFormIdCallback: Function = (formId: string, updatePages: number[], isOuter?: boolean): void => {
    RdbStoreManager.getInstance().deleteFormInfoById(formId, isOuter);
  };

  /**
   * 根据卡片bundleName删除卡片
   */
  static deleteFormInfoByBundleCallback: Function = (bundleName: string, typeId?: number, isOuter?: boolean): void => {
    RdbStoreManager.getInstance().deleteInfoByBundle(bundleName, typeId, undefined, isOuter);
  };

  /**
   * 根据卡片位置删除卡片
   */
  static deleteFormInfoByPositionCallback: Function = (page: number, column: number, row: number,
    isOuter: boolean): void => {
    if (LauncherLayoutCacheUtil.isLazyRotate) {
      log.showInfo('deleteFormInfoByPositionCallback isLazyRotate');
      RdbStoreManager.getInstance().deleteFormInfoByPosition(page, column, row, isOuter);
      return;
    }
    if (LauncherLayoutCacheUtil.isDefaultPortrait !== LauncherLayoutCacheUtil.isPadPortrait) {
      let item = LauncherLayoutCacheUtil.getItemByPosition(page, column, row);
      if (item) {
        let newItem: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([item])[0];
        page = newItem.page ?? -1;
        column = newItem.column ?? 0;
        row = newItem.row ?? 0;
      }
    }
    RdbStoreManager.getInstance().deleteFormInfoByPosition(page, column, row, isOuter);
  };

  /**
   * 删除和替换元素的回调
   */
  static deleteAndReplaceItemCallBack: Function = (deleteItem: GridLayoutItemInfo, replaceItem: GridLayoutItemInfo, ctx?: SingleContext): void => {
    if (deleteItem.typeId === CommonConstants.TYPE_FOLDER) {
      log.showWarn(`folder cannot be deleted, folderId:${deleteItem.folderId}, bundleName:${deleteItem.bundleName}`);
      return;
    }
    log.showInfo('deleteAndReplaceItemCallBack');
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([replaceItem])[0];
    RdbStoreManager.getInstance().deleteGridLayoutByCondition(deleteItem).then(() => {
      let gridlayoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      ObjectCopyUtil.deepClone(targetInfo, gridlayoutItem);
      let mGridLayoutItemInfo: GridLayoutItemInfo[] | undefined = targetInfo.layoutInfo?.flat();
      if (mGridLayoutItemInfo) {
        gridlayoutItem.layoutInfo = [mGridLayoutItemInfo];
      }
      RdbStoreManager.getInstance().insertGridLayoutInfo([gridlayoutItem], true, undefined, ctx);
    });
  };

  /**
   * 删除文件夹并更新应用到桌面或dock
   */
  static deleteFolderAndUpdateAppToDesktopCallBack: Function = (folderItem: GridLayoutItemInfo, appItem: GridLayoutItemInfo): void => {
    log.showInfo('deleteFolderAndUpdateAppToDesktopCallBack');
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([appItem])[0];
    this.deleteFolderItemCallBack(folderItem, true);
    RdbStoreManager.getInstance().updateInfoPosition([targetInfo], 'deleteFolderAndUpdateAppToDesktop',
      new ExtraInfo(targetInfo.container === CommonConstants.CONTAINER_DOCK ?
      targetInfo.container : CommonConstants.CONTAINER_DESKTOP, undefined, false));
  };

  /**
   * 更新文件夹名字的callback
   */
  static updateFolderNameCallBack: Function = (folderItem: GridLayoutItemInfo, isInit: boolean): void => {
    if (isInit) {
      RdbStoreManager.getInstance().insertFolderLayout(folderItem, folderItem.layoutInfo?.flat() ?? []);
    } else {
      RdbStoreManager.getInstance().updateGridInfoById(folderItem.folderId ?? '',
        GridLayoutInfoColumns.INFO_NAME, folderItem.folderName ?? '');
    }
  };

  /**
   * 更新卡片位置数据库操作
   */
  static updateFormPositionCallBack: Function = async (layoutItem: GridLayoutItemInfo, isOuter?: boolean): Promise<boolean> => {
    log.showInfo(`updateFormPositionCallBack isOuter:${isOuter}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([layoutItem])[0];
    let updateResult: boolean = await RdbStoreManager.getInstance().updateFormInfoByPosition(targetInfo, isOuter);
    return updateResult;
  };

  /**
   * 添加卡片到堆叠
   */
  static addInfoToFormStackCallBack: Function = (updateItem: GridLayoutItemInfo, newFormItem: GridLayoutItemInfo[], isOuter?: boolean) => {
    log.showInfo(`addInfoToFormStackCallBack newFormItem:${newFormItem?.length}`);
    let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([updateItem])[0];
    RdbStoreManager.getInstance().addInfoToFormStack(targetInfo, newFormItem, undefined, isOuter);
  };

  /**
   * 更新卡片信息
   */
  public static async updateFormInfoByIdChange(cardItemInfo: CardItemInfo, isOuter?: boolean, ctx?: SingleContext): Promise<void> {
    if (CheckEmptyUtils.isEmpty(cardItemInfo)) {
      return;
    }

    if (LauncherLayoutCacheUtil.isLazyRotate) {
      let newItem: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([cardItemInfo as object as GridLayoutItemInfo])[0];
      await RdbStoreManager.getInstance().updateFormInfoById(newItem as object as CardItemInfo, undefined, ctx);
      return;
    }
    if (LauncherLayoutCacheUtil.isDefaultPortrait !== LauncherLayoutCacheUtil.isPadPortrait) {
      let item = LauncherLayoutCacheUtil.getItemByPosition(cardItemInfo.page ?? -1, cardItemInfo.column ?? 0,
        cardItemInfo.row ?? 0, cardItemInfo.typeId);
      if (item) {
        let newItem: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([item])[0];
        await RdbStoreManager.getInstance().updateFormInfoById(newItem as object as CardItemInfo, undefined, ctx);
      }
    } else {
      await RdbStoreManager.getInstance().updateFormInfoById(cardItemInfo, isOuter, ctx);
    }
  };

  /**
   * 更新元素到桌面
   */
  static updateItemToFormStackCallback: Function = (formStack: GridLayoutItemInfo, updateInfoList: GridLayoutItemInfo[],
                                                    needInsertDbList: GridLayoutItemInfo[], isOuter?: boolean): void => {
    this.updateItemToFormStackCallbackFunc(formStack, updateInfoList, needInsertDbList, isOuter);
  };

  static updateItemToFormStackCallbackFunc: Function = async (formStack: GridLayoutItemInfo,
    updateInfoList: GridLayoutItemInfo[], needInsertDbList: GridLayoutItemInfo[], isOuter?: boolean, ctx?: SingleContext): Promise<void> => {
    if (!CheckEmptyUtils.isEmptyArr(needInsertDbList)) {
      const mapList = needInsertDbList.map(item => GridLayoutUtil.mapProxyTypeGridLayout(item));
      await RdbStoreManager.getInstance().insertGridLayoutInfo(mapList, false, isOuter);
    }

    RdbStoreManager.getInstance().addInfoToFormStack(formStack, updateInfoList, undefined, isOuter);
  };

  /**
   * 更新堆叠里面的卡片的ID
   */
  static updateCardIdOfFormStack: Function = async (oldCardId: string, layoutItem: GridLayoutItemInfo,
    isOuter?: boolean): Promise<boolean> => {
    let result: boolean = await RdbStoreManager.getInstance().updateCardIdOfFormStack(oldCardId, layoutItem, isOuter);
    return result;
  };

  /**
   * 根据 formStackId 获取数据库对应的堆叠主键id
   *
   * @param formStackId 堆叠卡片id
   * @returns 主键id
   */
  public static async selectIdByFormStackId(formStackId: string, isOuter?: boolean): Promise<number> {
    if (CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
      return CommonConstants.INVALID_VALUE;
    }
    let formRdbLayout: GridLayoutItemInfo | undefined;
    try {
      let formRdbLayoutList: GridLayoutItemInfo[] =
        await RdbStoreManager.getInstance().queryGridLayoutByType(CommonConstants.TYPE_FORM_STACK, isOuter);
      log.showInfo(`selectIdByFormStackId res = ${formRdbLayoutList.map(i => i.formStackId)}`);
      formRdbLayout = formRdbLayoutList.find((item) => item.formStackId === formStackId);
    } catch (error) {
      log.showError(`selectIdByFormStackId error, query formRdbLayoutList fail.${error?.code}: ${error?.message}`);
    }
    if (!formRdbLayout) {
      log.showError('cant find formRdbLayout');
      return CommonConstants.INVALID_VALUE;
    }
    return formRdbLayout.id ?? CommonConstants.INVALID_VALUE;
  };

  /**
   * 调用删deleteFormInFormStackByNameAndContainer的数据库的接口
   *
   * @param formItem 删除的卡片
   * @param container 堆叠里的container
   */
  public static deleteFormInFormStackByNameAndContainer(formItem: GridLayoutItemInfo, container: number): void {
    if (CheckEmptyUtils.isEmpty(formItem)) {
      log.showWarn('deleteFormInFormStackByNameAndContainer failure as the form is empty');
      return;
    }
    RdbStoreManager.getInstance().deleteFormInFormStackByNameAndContainer(formItem, container);
  }

  /**
   * 批量整页更新元素页数的数据库接口
   *
   * @param pageUpdateItems 页数更新列表
   * @param updateItems 更新完页数后重新更新的item信息
   */
  public static async patchUpdateGridLayoutPages(pageUpdateItems: PageUpdateItem[],
    updateItems?: GridLayoutItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(pageUpdateItems)) {
      log.showWarn('patchUpdateGridLayoutPages for the parameter is error');
      return;
    }
    RdbStoreManager.getInstance().updateGridLayoutInfoPositionByPage(pageUpdateItems).then(() => {
      if (updateItems) {
        log.showWarn('patchUpdateGridLayoutPages item %{public}d after add page', updateItems?.length);
        LauncherLayoutCacheUtil.patchUpdateGridLayoutPositionCallBack(updateItems);
      }
    });
  }

  /**
   * 返回页数更新的参数item信息
   *
   * @param startPage 开始页
   * @param endPage 结束页
   * @param step 更新步长
   * @returns PageUpdateItem
   */
  public static buildPageUpdateItem(startPage: number, endPage: number, step: number): PageUpdateItem {
    let pageUpdateItem: PageUpdateItem = new PageUpdateItem();
    pageUpdateItem.startPage = startPage;
    pageUpdateItem.endPage = endPage;
    pageUpdateItem.step = step;
    return pageUpdateItem;
  }

  /**
   * 判断是否是相同的app或者文件夹
   *
   * @param itemInfo GridLayoutItemInfo
   * @param appItem app
   * @returns true表示相同
   */
  public static isSameAppOrSmallFolder(itemInfo: GridLayoutItemInfo, bundleName: string, keyName: string,
    folderId: string, appIndex?: number, shortcutId?: string): boolean {
    if (CheckEmptyUtils.isEmpty(itemInfo)) {
      log.showWarn('isSameAppOrSmallFolder false as the item is empty');
      return false;
    }
    if (itemInfo.typeId === CommonConstants.TYPE_APP) {
      return itemInfo.bundleName === bundleName && itemInfo.appIndex === appIndex || itemInfo.keyName === keyName;
    } else if (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return itemInfo.bundleName === bundleName && itemInfo.appIndex === appIndex &&
        itemInfo.shortcutId === shortcutId || itemInfo.keyName === keyName;
    } else if (GridLayoutUtil.isSmallFolder(itemInfo)) {
      return folderId !== undefined && itemInfo.folderId === folderId;
    }
    return false;
  }

  /**
   * 判断是否是相同的快捷图标
   *
   * @param itemInfo GridLayoutItemInfo
   * @param bundleName 图标bundleName
   * @param shortcutId 图标shortcutId
   * @returns true: 相同， false：不同
   */
  public static isSameShortcutApp(itemInfo: GridLayoutItemInfo, bundleName: string, shortcutId: string, appIndex: number): boolean {
    if (CheckEmptyUtils.isEmpty(itemInfo)) {
      log.showWarn('isSameAppOrSmallFolder false as the item is empty');
      return false;
    }
    return (itemInfo.bundleName === bundleName && itemInfo.shortcutId === shortcutId && itemInfo.appIndex === appIndex);
  }

  /**
   * 判断是否是相同的应用
   *
   * @param itemInfo GridLayoutItemInfo
   * @param bundleName 图标bundleName
   * @returns true: 相同， false：不同
   */
  public static isSameAppByBundleName(itemInfo: GridLayoutItemInfo, bundleName: string, appIndex: number): boolean {
    return (itemInfo.typeId === CommonConstants.TYPE_APP || itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) &&
      itemInfo.bundleName === bundleName && itemInfo.appIndex === (appIndex ?? 0);
  }

  /**
   * 是否相关的应用:分身或快捷方式
   *
   * @param item 待判断应用
   * @param originItem 原始应用
   * @returns true关联的应用：分身或快捷方式
   */
  public static isRelatedApp(item: GridLayoutItemInfo, originItem: GridLayoutItemInfo): boolean {
    return (originItem.appIndex === 0 ? item.bundleName === originItem.bundleName :
      item.bundleName === originItem.bundleName && item.appIndex === originItem.appIndex);
  }

  /**
   * make the folder layoutInfo into list
   *
   * @param folderInfo
   */
  public static layoutInfoToList(folderInfo: GridLayoutItemInfo | DockItemInfo): GridLayoutItemInfo[] {
    let appInfo: GridLayoutItemInfo[] = [];
    if (!folderInfo.layoutInfo) {
      return appInfo;
    }
    for (let i = 0; i < folderInfo.layoutInfo.length; i++) {
      for (let j = 0; j < folderInfo.layoutInfo[i].length; j++) {
        if (CheckEmptyUtils.isEmpty(folderInfo.layoutInfo[i][j])) {
          continue;
        }
        if (folderInfo.layoutInfo[i][j].typeId !== CommonConstants.TYPE_ADD) {
          appInfo = appInfo.concat(folderInfo.layoutInfo[i][j]);
        }
      }
    }
    return appInfo;
  }

  /**
   * 打印重复信息
   *
   * @param page 页数
   * @param row 行
   * @param column 列
   * @param gridList item列表
   */
  public static printDuplicateInfo(page: number, row: number, column: number, gridList: GridLayoutItemInfo[]): void {
    log.showError('[%{public}d, %{public}d] in page %{public}d is duplicate.', row, column, page);
    gridList.forEach(layout => {
      if (layout.row === undefined || !layout.area || layout.column === undefined) {
        return;
      }
      if (layout.page === page && layout.row <= row && layout.row + layout.area[1] >= row &&
        layout.column <= column && layout.column + layout.area[0] >= column) {
        log.showError('layout has duplicate position. layout info is {page:%{public}d, column:%{public}d, row:%{public}d, ' +
          'width:%{public}d, height:%{public}d, typeId:%{public}d, bundleName:%{public}s, cardId:%{public}s, ' +
          'folderId:%{public}s, formStackId:%{public}s}', layout.page, layout.column, layout.row, layout.area[0],
          layout.area[1], layout.typeId, layout.bundleName, layout.cardId, layout.folderId, layout.formStackId);
      }
    });
  }

  /**
   * 更新文件夹中应用和文件夹的角标
   *
   * @param folderItem 文件夹
   * @param appInfo 应用
   * @param badgeInfo 角标信息
   */
  public static updateAppBadgeInFolder(folderItem: GridLayoutItemInfo, appInfo: GridLayoutItemInfo,
    badgeInfo: BadgeItemInfo): void {
    if (CheckEmptyUtils.isEmpty(folderItem) || CheckEmptyUtils.isEmpty(appInfo) || CheckEmptyUtils.isEmpty(badgeInfo)) {
      log.showWarn('updateAppBadgeInFolder failure as the object is null');
      return;
    }
    let oldBadge = 0;
    if (folderItem.badgeNumber && folderItem.badgeNumber > 0) {
      if (appInfo.badgeNumber && appInfo.badgeNumber > 0) {
        oldBadge = folderItem.badgeNumber - appInfo.badgeNumber;
      } else {
        oldBadge = folderItem.badgeNumber;
      }
    }
    folderItem.badgeNumber = oldBadge + (badgeInfo.badgeNumber ?? 0);
    appInfo.badgeNumber = badgeInfo.badgeNumber;
  }

  static updateFolderAppPackageInfo(originItem: GridLayoutItemInfo, itemUpdate: AppItemInfo): void {
    log.showInfo(`update folderApp packageInfo ${originItem.keyName} ${itemUpdate.keyName}`);
    let isUpdate: boolean =
      originItem.appStatus === AppStatus.WAIT_FOR_HARMONY && itemUpdate.appStatus === AppStatus.INSTALLED;
    originItem.appName = itemUpdate.appName;
    originItem.applicationName = itemUpdate.applicationName;
    originItem.applicationLabelId = itemUpdate.applicationLabelId;
    originItem.appIconId = itemUpdate.appIconId;
    originItem.appLabelId = itemUpdate.appLabelId;
    originItem.isUninstallAble = itemUpdate?.isUninstallAble;
    originItem.isSystemApp = itemUpdate?.isSystemApp;
    originItem.installTime = itemUpdate.installTime;
    originItem.moduleName = itemUpdate.moduleName;
    originItem.abilityName = itemUpdate.abilityName;
    originItem.keyName = itemUpdate.keyName;
    originItem.appStatus = AppStatus.INSTALLED;
    if (isUpdate) {
      LauncherLayoutCacheUtil.insertNewInstalledAppCallBack(originItem);
    }
  }

  /**
   * 过滤重复元素
   *
   * @param gridItemList 布局元素列表
   * @param layoutDescription 布局面so信息
   * @returns 位置重叠元素列表
   */
  public static filterDuplicateElement(gridItemList: GridLayoutItemInfo[], layoutDescription: LayoutDescription): GridLayoutItemInfo[] {
    let row: number = layoutDescription.row;
    let col: number = layoutDescription.column;
    let pageNum: number = layoutDescription.maxPage;
    let gridOccupyList: GridOccupyStatus[] = [];
    let duplicateElements: GridLayoutItemInfo[] = [];
    for (let i = 0; i < pageNum; i++) {
      gridOccupyList.push(new GridOccupyStatus(col, row, GridOccupyStatusEnum.FREE));
    }

    log.showInfo('filterDuplicateElement duplicate element maxPageCount %{public}d, col %{public}d, row %{public}d',
      pageNum, col, row);
    for (const item of gridItemList) {
      if (item.page === undefined || item.page < 0) {
        log.showWarn('item bundleName %{public}s, page %{public}d is negative error', item.bundleName, item.page);
        duplicateElements.push(item);
        continue;
      }
      if (item.page >= gridOccupyList.length || !item.area || CheckEmptyUtils.isEmptyArr(item.area)) {
        log.showWarn('item bundleName %{public}s, page %{public}d is out of the maxPageCount', item.bundleName, item.page);
        continue;
      }
      if (LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(item)) {
        log.showWarn(`the outer from bundleName ${item.bundleName}, type ${item.typeId}, page ${item.page}, ` +
          `row ${item.row}, col ${item.column}, width ${item.area?.[0]}, height ${item.area?.[1]}`);
        continue;
      }
      if (!LauncherLayoutCacheUtil.isOutOfLayoutBound(item, row, col) &&
        LauncherLayoutCacheUtil.isFreeForGridLayoutItem(item, gridOccupyList[item.page])) {
        gridOccupyList[item.page].markGridForRect(new RectItem(item.column, item.row, (item.column ?? 0) + item.area[0],
          (item.row ?? 0) + item.area[1]), GridOccupyStatusEnum.OCCUPIED);
      } else {
        log.showWarn(`the duplicateElement bundleName ${item.bundleName}, type ${item.typeId}, page ${item.page}, ` +
          `row ${item.row}, col ${item.column}, width ${item.area[0]}, height ${item.area[1]},`);
        duplicateElements.push(item);
      }
    }

    return duplicateElements;
  }

  /**
   * 检测元素是否在布局边界外
   *
   * @param item 元素
   * @param layoutRow 当前布局行
   * @param layoutCol 当前布局列
   * @returns 是否超出布局
   */
  public static isOutOfLayoutBound(item: GridLayoutItemInfo, layoutRow: number, layoutCol: number): boolean {
    if (item.row === undefined || !item.area || item.column === undefined) {
      return true;
    }
    return (item.row < 0 || item.row + item.area[1] - 1 >= layoutRow) ||
      (item.column < 0 || item.column + item.area[0] - 1 >= layoutCol);
  }

  /**
   * 检测元素大小是否在超出布局
   *
   * @param item 元素
   * @param isOuter 是否外屏桌面
   * @returns 是否超出布局
   */
  public static isOuterFormOutOfLayoutBound(item: GridLayoutItemInfo | CardItemInfo, isOuter?: boolean): boolean {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (showOuter && item && item.typeId === CommonConstants.TYPE_CARD) {
      if (item.row === undefined || !item.area || item.column === undefined) {
        return true;
      }
      return (item.row < 0 || item.area[1] > OUTER_DESKTOP_GRIDLAYOUT) ||
        (item.column < 0 || item.area[0] > OUTER_DESKTOP_GRIDLAYOUT);
    }
    return false;
  }

  /**
   * 是否可以放置元素
   *
   * @param item item信息
   * @returns true for valid
   */
  private static isFreeForGridLayoutItem(item: GridLayoutItemInfo, gridOccupy: GridOccupyStatus): boolean {
    if (item.row === undefined || !item.area || item.column === undefined) {
      return false;
    }
    for (let i = item.row; i < item.row + item.area[1]; i++) {
      for (let j = item.column; j < item.column + item.area[0]; j++) {
        if (gridOccupy.isOccupied(j, i)) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * 判断新放入元素旋转之后页面是否放得下
   *
   * @param defaultDesktopLayoutInfo 布局信息
   * @param page 页数
   * @param length 元素宽
   * @param height 元素高
   * @returns true for valid
   */
  public static isAddableForRotate(defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo, page: number, length: number, height: number): boolean {
    log.showInfo('isAddableForRotate');
    if (!defaultDesktopLayoutInfo || !defaultDesktopLayoutInfo.layoutDescription) {
      return false;
    }
    let deskTopLayoutInfo: DefaultDesktopLayoutInfo =
      JSON.parse(JSON.stringify(defaultDesktopLayoutInfo)) as DefaultDesktopLayoutInfo;
    let row: number = deskTopLayoutInfo.layoutDescription.row;
    let column: number = deskTopLayoutInfo.layoutDescription.column;
    let addNewItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    addNewItem.area = [length, height];
    addNewItem.page = page;
    // 待检查元素项，放到布局中调整看
    deskTopLayoutInfo.layoutInfo.push(addNewItem);
    // 检查兜底布局是否放得下
    let res = LauncherLayoutCacheUtil.getFinalSortLayout(deskTopLayoutInfo, page);
    let legal = LauncherLayoutCacheUtil.updateIconPosition(column, row, res, SORT_TYPE_FINAL);
    log.showWarn(`isAddableForRotate, input pages legel: ${legal}`);
    return legal;
  }

  private static getLargeCardArea(deskTopLayoutInfo: DefaultDesktopLayoutInfo, page: number): number {
    let area: number = 0;
    let layoutInfo: GridLayoutItemInfo[] = deskTopLayoutInfo.layoutInfo;
    for (let i = 0; i < layoutInfo.length; i++) {
      let mArea = layoutInfo[i].area;
      if (layoutInfo[i].page === page && mArea) {
        if (mArea[0] * mArea[1] >= MID_CARD_AREA) {
          area += mArea[0] * mArea[1];
        }
      }
    }
    return area;
  }

  private static getVerticalMergeWidgets(gridLayoutItemInfo: GridLayoutItemInfo[],
    verticalLayout: LayoutDescription): Widget[] {
    let widgets: Widget[] = [];
    gridLayoutItemInfo.forEach((item) => {
      let widget: Widget = {
        id: LauncherLayoutCacheUtil.generateWidgetId(item),
        x: (item.column ?? 0) + 1,
        y: (item.page === 0) ? (item.row ?? 0) + 1 : (item.row ?? 0) + 1 + verticalLayout.row,
        width: item.area?.[0],
        height: item.area?.[1],
        isEmpty: false,
      };
      widgets.push(widget);
    });
    // sort by Mode N
    widgets.sort((a: Widget, b: Widget) => {
      if (a.x !== b.x) {
        return a.x - b.x;
      }
      if (a.x === b.x) {
        return a.y - b.y;
      }
      return 0;
    });
    return widgets;
  }

  private static splitWidgets(widgets: Widget[], gridLayoutItemInfo: GridLayoutItemInfo[],
    rotatedLayout: LayoutDescription): void {
    const layoutWidth: number = rotatedLayout.column;
    gridLayoutItemInfo.forEach((item) => {
      const found: Widget = widgets.find((widget: Widget) => widget.id === LauncherLayoutCacheUtil.generateWidgetId(item));
      if (found) {
        item.page = (found.x <= layoutWidth ? 0 : 1);
        item.column = (found.x > layoutWidth ? found.x - 1 - layoutWidth : found.x - 1);
        item.row = found.y - 1;
      }
    });
  }

  private static getNextPosByReverseN(curPos: number[], outputLayout: LayoutDescription): number[] {
    let nextPos: number[] = [];
    if (curPos[1] < outputLayout.row) {
      nextPos[0] = curPos[0];
      nextPos[1] = curPos[1] + 1;
      return nextPos;
    }
    nextPos[0] = curPos[0] - 1;
    nextPos[1] = 1;
    return nextPos;
  }

  private static presetAtomicWidgetsByReverseN(layoutRotatePackingInstance: LayoutRotatePacking, widgets: Widget[],
    outputLayout: LayoutDescription): void {
    let pos: number[] = [outputLayout.column, 1];
    widgets.forEach((item) => {
      if ((item.width === 1) && (item.height === 1)) {
        layoutRotatePackingInstance.addPreset(item.id, pos[0], pos[1]);
        pos = LauncherLayoutCacheUtil.getNextPosByReverseN(pos, outputLayout);
      }
    });
  }

  private static flipWidgetsVertical(widgets: Widget[], flipCenter: number): void {
    widgets.forEach((item) => {
      item.x = 2 * flipCenter - item.x - item.width;
    });
  }

  private static doLayoutRotatePacking(deskTopLayoutInfo: DefaultDesktopLayoutInfo,
    rotatedLayout: LayoutDescription, rotateType: LayoutRotateType): DefaultDesktopLayoutInfo {
    let mergedWidgets: Widget[] = [];
    if (rotateType === LayoutRotateType.VERTICAL_TO_LANDSCAPE) {
      mergedWidgets = LauncherLayoutCacheUtil.getVerticalMergeWidgets(deskTopLayoutInfo.layoutInfo,
        deskTopLayoutInfo.layoutDescription);
      const rotatedLayoutWidth: number = rotatedLayout.column;
      const rotatedLayoutHeight: number = rotatedLayout.row;
      let mergedRotatedLayoutWidth: number = rotatedLayoutWidth * 2;
      let mergedRotatedLayoutHeight: number = rotatedLayoutHeight;

      let layoutRotatePackingInstance: LayoutRotatePacking = new LayoutRotatePacking(1,
        mergedRotatedLayoutWidth, mergedRotatedLayoutHeight);
      layoutRotatePackingInstance.addVerticalRuler(rotatedLayoutWidth + 1);

      let mergedRotateLayout: LayoutDescription = {
        column: mergedRotatedLayoutWidth,
        row: mergedRotatedLayoutHeight,
        maxPage: 0,
        maxForm: 0,
        pageCount: 1
      };
      LauncherLayoutCacheUtil.presetAtomicWidgetsByReverseN(layoutRotatePackingInstance, mergedWidgets,
        mergedRotateLayout);
      let outputWidgets: Widget[] = layoutRotatePackingInstance.sortedRotate(mergedWidgets);
      LauncherLayoutCacheUtil.flipWidgetsVertical(outputWidgets, rotatedLayoutWidth + 1);
      LauncherLayoutCacheUtil.splitWidgets(outputWidgets, deskTopLayoutInfo.layoutInfo, rotatedLayout);
    }
    return deskTopLayoutInfo;
  }

  private static generateWidgetId(item: GridLayoutItemInfo): number {
    return (item.page ?? 0) * PAGE_SCALE + (item.row ?? 0) * ROW_SCALE + (item.column ?? 0);
  }

  private static getLazyRotateLayout(defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo, isPadPortrait: boolean,
    newGrid?: number[], forceRotate?: boolean): DefaultDesktopLayoutInfo {
    let deskTopLayoutInfo: DefaultDesktopLayoutInfo = ObjectCopyUtil.deepClone(defaultDesktopLayoutInfo);
    if (deskTopLayoutInfo.layoutInfo.length === 0) {
      let row: number = deskTopLayoutInfo.layoutDescription.row;
      let column: number = deskTopLayoutInfo.layoutDescription.column;
      deskTopLayoutInfo.layoutDescription.row = newGrid ? newGrid[0] : column;
      deskTopLayoutInfo.layoutDescription.column = newGrid ? newGrid[1] : row;
      return deskTopLayoutInfo;
    }
    let row: number = deskTopLayoutInfo.layoutDescription.row;
    let column: number = deskTopLayoutInfo.layoutDescription.column;
    if ((LauncherLayoutCacheUtil.getIsFirstRotate() || forceRotate) && !isPadPortrait) {
      LauncherLayoutCacheUtil.dealCacheLandscape(deskTopLayoutInfo, newGrid);
    } else {
      LauncherLayoutCacheUtil.dealDeskTopLayoutInfo(deskTopLayoutInfo, isPadPortrait)
    }
    deskTopLayoutInfo.layoutDescription.row = newGrid ? newGrid[0] : column;
    deskTopLayoutInfo.layoutDescription.column = newGrid ? newGrid[1] : row;
    return deskTopLayoutInfo;
  }

  private static dealCacheLandscape(deskTopLayoutInfo: DefaultDesktopLayoutInfo, newGrid?: number[]): void {
    const layout: LayoutDescription = {
      pageCount: 0,
      row: newGrid?.[0] ?? deskTopLayoutInfo.layoutDescription.column,
      column: newGrid?.[1] ?? deskTopLayoutInfo.layoutDescription.row,
      maxPage: 0,
      maxForm: 0
    };
    log.showInfo('doLayoutRotatePacking start');
    deskTopLayoutInfo = LauncherLayoutCacheUtil.doLayoutRotatePacking(deskTopLayoutInfo, layout,
      LayoutRotateType.VERTICAL_TO_LANDSCAPE);
    log.showInfo('doLayoutRotatePacking end');
    LauncherLayoutCacheUtil.changeCacheLandscape(deskTopLayoutInfo.layoutInfo);
  }

  private static dealDeskTopLayoutInfo(deskTopLayoutInfo: DefaultDesktopLayoutInfo, isPadPortrait: boolean): void {
    deskTopLayoutInfo.layoutInfo.forEach(item => {
      if (isPadPortrait) {
        item.row = item.portraitRow;
        item.column = item.portraitColumn;
        item.page = item.portraitPage;
        // 1、只有大文件夹area可变
        // 2、OTA升级场景下， portraitArea可能无效
        if (GridLayoutUtil.isRegionFolderType(item) && GridLayoutUtil.isValidArea(item.portraitArea ?? [])) {
          item.area = [item.portraitArea?.[0] ?? 0, item.portraitArea?.[1] ?? 0];
          log.showInfo(`change item ${item.folderName} area to portrait area ${item.area[0]}, ${item.area[1]}`);
        }
      } else {
        item.row = item.landscapeRow;
        item.column = item.landscapeColumn;
        item.page = item.landscapePage;
        // 1、只有大文件夹area可变
        // 2、OTA升级场景下, landscapeArea可能无效
        if (GridLayoutUtil.isRegionFolderType(item) && GridLayoutUtil.isValidArea(item.landscapeArea ?? [])) {
          item.area = [item.landscapeArea?.[0] ?? 0, item.landscapeArea?.[1] ?? 0];
          log.showInfo(`change item ${item.folderName} area to landscape area ${item.area[0]}, ${item.area[1]}`);
        }
      }
    })
  }

  /**
   * 计算转屏后布局
   * @param defaultDesktopLayoutInfo
   * @isPadPortrait pad旋转后屏幕所处状态，true-竖屏，false-横屏。(this.isPadPortrait变量是pad旋转前屏幕所处状态，竖屏重启时该变量异常，故增加isPadPortrait变量)
   * @param updatePages 指定更新页码组
   * @param newGrid 指定目标行列数
   * @param forceRotate 是否强制旋转
   * @returns
   */
  public static getRotateLayout(defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo, isPadPortrait: boolean,
    updatePages?: number[], newGrid?: number[], forceRotate?: boolean): DefaultDesktopLayoutInfo {
    if (!LauncherLayoutCacheUtil.isLazyRotate) {
      log.showWarn(`Rotate LazyRotateMode fail return`);
      return defaultDesktopLayoutInfo;
    }
    // hopper设备
    if (DeviceHelper.isSuperFoldMachine()) {
      return LauncherLayoutCacheUtil.getLazyRotateLayout(defaultDesktopLayoutInfo, isPadPortrait, newGrid,
        forceRotate);
    } else if (DeviceHelper.isPad()) {
      return LauncherLayoutCacheUtil.getPadLazyRotateLayout(defaultDesktopLayoutInfo, isPadPortrait, updatePages, forceRotate);
    } else {
      log.showWarn('unkown device type lazy rotate');
      return defaultDesktopLayoutInfo;
    }
  }

  private static getPadLazyRotateLayout(defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo, isPadPortrait: boolean,
    updatePages?: number[], forceRotate?: boolean): DefaultDesktopLayoutInfo {
    let deskTopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
    try {
      deskTopLayoutInfo = ObjectCopyUtil.deepClone(defaultDesktopLayoutInfo);
    } catch (e) {
      log.showError('get deepClone deskTopLayoutInfo failed!');
    }
    let row: number = deskTopLayoutInfo.layoutDescription.row;
    let column: number = deskTopLayoutInfo.layoutDescription.column;
    log.showInfo(`Rotate row: ${row}, column:${column}`);
    if (deskTopLayoutInfo.layoutInfo.length === 0) {
      deskTopLayoutInfo.layoutDescription.row = column;
      deskTopLayoutInfo.layoutDescription.column = row;
      log.showWarn('Rotate return layoutInfo length 0');
      return deskTopLayoutInfo;
    }
    // pad设备首次旋转状态走入旋转算法计算竖屏布局，否则只更新元素页数以及坐标
    if (LauncherLayoutCacheUtil.getIsFirstRotate() || forceRotate) {
      let pages: number[] = [];
      if (updatePages && !CheckEmptyUtils.isEmptyArr(updatePages)) {
        pages = updatePages;
      } else {
        for (let i = 0; i < deskTopLayoutInfo.layoutDescription.pageCount; i++) {
          pages.push(i);
        }
      }
      log.showInfo(`padRotateAlgorithms pages:${pages.toString()}`);
      LauncherLayoutCacheUtil.padRotateAlgorithms(deskTopLayoutInfo, isPadPortrait, pages);
      if (isPadPortrait) {
        LauncherLayoutCacheUtil.changeCachePortrait(deskTopLayoutInfo.layoutInfo);
      } else {
        LauncherLayoutCacheUtil.changeCacheLandscape(deskTopLayoutInfo.layoutInfo);
      }
    } else {
      deskTopLayoutInfo.layoutInfo.forEach(item => {
        if (isPadPortrait) {
          item.row = item.portraitRow;
          item.column = item.portraitColumn;
          item.page = item.portraitPage;
        } else {
          item.row = item.landscapeRow;
          item.column = item.landscapeColumn;
          item.page = item.landscapePage;
        }
      })
    }
    deskTopLayoutInfo.layoutDescription.row = column;
    deskTopLayoutInfo.layoutDescription.column = row;
    return deskTopLayoutInfo;
  }

  private static padRotateAlgorithms(deskTopLayoutInfo: DefaultDesktopLayoutInfo, isPadPortrait: boolean,
    updatePages?: number[]): DefaultDesktopLayoutInfo {
    log.showInfo('PadDevice Rotate Algorithms start');
    let row: number = deskTopLayoutInfo.layoutDescription.row;
    let column: number = deskTopLayoutInfo.layoutDescription.column;
    let pageCount: number = deskTopLayoutInfo.layoutDescription.pageCount;
    let gridLayoutItemInfo: GridLayoutItemInfo[] = [];
    let isPagesLegal: boolean = true;
    let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
    if (updatePages && updatePages.length > 0) {
      log.showInfo(`getRotateLayout, input pages: ${updatePages.join(',')}`);
      for (let i = 0; i < updatePages.length; i++) {
        if (updatePages[i] >= pageCount) {
          isPagesLegal = false;
          break;
        }
      }
    }
    if (isPagesLegal) {
      const cachedLayout: DefaultDesktopLayoutInfo =
        LauncherLayoutCacheUtil.isPadPortrait ?
        LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo : LauncherLayoutCacheUtil.portraitDesktopLayoutInfo;
      for (let i = 0; i < deskTopLayoutInfo.layoutDescription.pageCount; i++) {
        if (updatePages?.includes(i)) {
          LauncherLayoutCacheUtil.updateLayoutInfo(deskTopLayoutInfo, i, gridLayoutItemInfo, extraItemMap);
        } else {
          // 不在指定更新布局内，直接从缓存拿上次页的布局
          LauncherLayoutCacheUtil.addLayoutInfoFromCache(deskTopLayoutInfo, i, gridLayoutItemInfo);
        }
      }
    } else {
      log.showWarn('getRotateLayout, rotate for all pages');
      for (let i = 0; i < deskTopLayoutInfo.layoutDescription.pageCount; i++) {
        LauncherLayoutCacheUtil.updateLayoutInfo(deskTopLayoutInfo, i, gridLayoutItemInfo, extraItemMap);
      }
    }
    deskTopLayoutInfo.layoutInfo = gridLayoutItemInfo;
    if (!extraItemMap.isEmpty()) {
      //拿到初始横屏布局
      let copiedLayout: DefaultDesktopLayoutInfo =
        JSON.parse(JSON.stringify(deskTopLayoutInfo)) as DefaultDesktopLayoutInfo;
      LauncherLayoutCacheUtil.setExtraItemPosition(deskTopLayoutInfo, copiedLayout, extraItemMap);
      //如果横转竖发生加页，在返回加页的竖屏布局同时要更新横屏缓存
      LauncherLayoutCacheUtil.setLandscapeDesktopLayoutInfo(copiedLayout);
    }
    deskTopLayoutInfo.layoutDescription.row = column;
    deskTopLayoutInfo.layoutDescription.column = row;
    // 只有pad转屏下移
    if (!LauncherLayoutCacheUtil.isDefaultPortrait) {
      LauncherLayoutCacheUtil.padPortraitToLandscapeDown(deskTopLayoutInfo, isPadPortrait, updatePages);
    }
    return deskTopLayoutInfo;
  }

  //横屏转竖屏下移
  private static padPortraitToLandscapeDown(deskTopLayoutInfo: DefaultDesktopLayoutInfo, isPadPortrait: boolean,
    updatePages?: number[]): void {
    //pad横屏转竖屏下移
    if (!updatePages?.includes(0)) {
      log.showWarn('PortraitToLandscapeDown return because updatePages excluding page 0');
      return;
    }
    if (CheckEmptyUtils.isEmpty(LauncherLayoutCacheUtil.checkClockCardExistAndRowExclusive(deskTopLayoutInfo, 0))) {
      log.showWarn('PortraitToLandscapeDown return because mismatch default clockCard center');
      return;
    }
    let layoutItemInfos: GridLayoutItemInfo[] = deskTopLayoutInfo.layoutInfo.filter(item => item.page === 0);
    let iconMaxRow: number = 0;
    for (let i = 0; i < layoutItemInfos.length; i++) {
      let mBaseGrid = LauncherLayoutCacheUtil.getGridSize(layoutItemInfos[i]);
      let gridRow = mBaseGrid.gridRow;
      let iconRealRow = (layoutItemInfos[i].row ?? 0) + gridRow;
      if (iconRealRow > iconMaxRow) {
        iconMaxRow = iconRealRow;
      }
    }
    if (iconMaxRow >= deskTopLayoutInfo.layoutDescription.row) {
      log.showWarn('blank is not enough, cancle down');
      return;
    }
    //横屏转竖屏最多下移3行
    if (isPadPortrait) {
      let downRowNum: number = deskTopLayoutInfo.layoutDescription.row - iconMaxRow;
      for (let i = 0; i < layoutItemInfos.length; i++) {
        let mRow = layoutItemInfos[i].row;
        if (mRow === undefined) {
          continue;
        }
        if (mRow >= CLOCK_ROW) {
          downRowNum = downRowNum > MAX_UPDOWN_ROW ? MAX_UPDOWN_ROW : downRowNum;
          layoutItemInfos[i].row = mRow + downRowNum;
        }
      }
      //横屏转竖屏导致竖屏缓存数据变化，但是数据库只存横屏数据，不需要将数据同步至数据库
      log.showInfo(`horizontal screen to Vertical screen, move down ${downRowNum} line`);
    } else {
      //竖屏转横屏最多下移1行
      let changedItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < layoutItemInfos.length; i++) {
        let mRow = layoutItemInfos[i].row;
        if (mRow === undefined) {
          continue;
        }
        if (mRow >= CLOCK_ROW) {
          layoutItemInfos[i].row = mRow + 1;
          changedItems.push(layoutItemInfos[i]);
        }
      }
      log.showInfo('Vertical screen to horizontal screen, move down 1 line');
      //竖屏转横屏导致横屏缓存有变化，此时将横屏数据存库，保持缓存和数据库数据一致
      RdbStoreManager.getInstance().updateInfoPosition(changedItems, 'padPortraitToLandscapeDown');
    }
  }

  private static addLayoutInfoFromCache(deskTopLayoutInfo: DefaultDesktopLayoutInfo, page: number,
    gridLayoutItemInfo: GridLayoutItemInfo[]): void {
    log.showInfo(`addItemsFromLayoutCache page: ${page}`);
    if (!LauncherLayoutCacheUtil.isPadPortrait) {
      for (let i = 0; i < deskTopLayoutInfo.layoutInfo.length; i++) {
        if (deskTopLayoutInfo.layoutInfo[i].page === page) {
          deskTopLayoutInfo.layoutInfo[i].row = deskTopLayoutInfo.layoutInfo[i].portraitRow;
          deskTopLayoutInfo.layoutInfo[i].column = deskTopLayoutInfo.layoutInfo[i].portraitColumn;
          deskTopLayoutInfo.layoutInfo[i].page = deskTopLayoutInfo.layoutInfo[i].portraitPage;
          gridLayoutItemInfo.push(deskTopLayoutInfo.layoutInfo[i]);
        }
      }
    } else {
      for (let i = 0; i < deskTopLayoutInfo.layoutInfo.length; i++) {
        if (deskTopLayoutInfo.layoutInfo[i].page === page) {
          deskTopLayoutInfo.layoutInfo[i].row = deskTopLayoutInfo.layoutInfo[i].landscapeRow;
          deskTopLayoutInfo.layoutInfo[i].column = deskTopLayoutInfo.layoutInfo[i].landscapeColumn;
          deskTopLayoutInfo.layoutInfo[i].page = deskTopLayoutInfo.layoutInfo[i].landscapePage;
          gridLayoutItemInfo.push(deskTopLayoutInfo.layoutInfo[i]);
        }
      }
    }
  }

  private static addItemsFromLayoutCache(deskTopLayoutInfo: DefaultDesktopLayoutInfo,
    cachedLayout: DefaultDesktopLayoutInfo, page: number,
    gridLayoutItemInfo: GridLayoutItemInfo[], extraItemMap: HashMap<string, GridLayoutItemInfo>): void {
    log.showInfo(`addItemsFromLayoutCache page: ${page}`);
    if (cachedLayout?.layoutInfo?.length !== 0) {
      log.showWarn(`addItemsFromLayoutCache legal cache from Portrait: ${LauncherLayoutCacheUtil.isPadPortrait}`);
      // 获取到有效缓存
      for (let i = 0; i < cachedLayout.layoutInfo.length; i++) {
        if (cachedLayout.layoutInfo[i].page === page) {
          gridLayoutItemInfo.push(cachedLayout.layoutInfo[i]);
        }
      }
    } else {
      // 无有效缓存，需要按规则计算重新布局
      LauncherLayoutCacheUtil.updateLayoutInfo(deskTopLayoutInfo, page, gridLayoutItemInfo, extraItemMap);
    }
  }

  private static sortLayoutInfo(deskTopLayoutInfo: DefaultDesktopLayoutInfo, page: number): ArrayList<GridLayoutItemInfo> {
    let res: ArrayList<GridLayoutItemInfo> = new ArrayList();
    // 只排序当前页面
    for (let i = 0; i < deskTopLayoutInfo.layoutInfo.length; i++) {
      if (deskTopLayoutInfo.layoutInfo[i].page === page) {
        res.add(deskTopLayoutInfo.layoutInfo[i]);
      }
    }
    LauncherLayoutCacheUtil.regularSort(res);
    return res;
  }

  private static regularSort(res: ArrayList<GridLayoutItemInfo>): void {
    res.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo): number => {
      // 非空校验
      if (!a && !b) {
        return 0; // a和b都未定义，相等
      }
      if (!a) {
        return -1; // 只有a未定义，a较小
      }
      if (!b) {
        return 1; // 只有b未定义，b较小
      }
      let aRow = typeof a.row !== 'undefined' ? a.row : Infinity;
      let bRow = typeof b.row !== 'undefined' ? b.row : Infinity;

      if (aRow < bRow) {
        return -1;
      } else if (aRow > bRow) {
        return 1;
      } else {
        let aColumn = typeof a.column !== 'undefined' ? a.column : Infinity;
        let bColumn = typeof b.column !== 'undefined' ? b.column : Infinity;

        if (aColumn < bColumn) {
          return -1;
        } else if (aColumn > bColumn) {
          return 1;
        } else {
          return 0;
        }
      }
    });
  }

  /**
   * 检查是否为天气卡片
   *
   * @param item
   * @returns
   */
  public static checkIfWeatherCard(item: GridLayoutItemInfo): boolean {
    return item &&　item.typeId === CommonConstants.TYPE_CARD && item.bundleName === CLOCK_WEATHER_BUNDLE_NAME;
  }

  /**
   * 检查是否为天气时钟卡片
   *
   * @param item
   * @returns
   */
  public static checkIfClockCard(item: GridLayoutItemInfo): boolean {
    return item &&　item.typeId === CommonConstants.TYPE_CARD && item.bundleName === CLOCK_WEATHER_BUNDLE_NAME &&
      item.cardName === CLOCK_WEATHER_CARD_NAME;
  }

  /**
   * 时钟存在且独占行
   * @param gridItems
   * @returns 如果存在则返回时钟卡片
   */
  private static checkClockCardExistAndRowExclusive(deskTopLayoutInfo: DefaultDesktopLayoutInfo,
    page: number): GridLayoutItemInfo | undefined {
    if (!deskTopLayoutInfo || !deskTopLayoutInfo.layoutDescription) {
      return undefined;
    }
    let row: number = deskTopLayoutInfo.layoutDescription.row;
    log.showInfo(`checkClockCardExistAndRowExclusive rowNum: ${row}, page idx: ${page}`);
    let occupiedRow: number[] = new Array(MAX_ROW).fill(0);
    let clockCardExist: boolean = false;
    let clockCardItem: GridLayoutItemInfo | undefined;
    for (const gridItem of deskTopLayoutInfo.layoutInfo) {
      if (!gridItem || gridItem.page !== page || gridItem.row === undefined) {
        continue;
      }
      occupiedRow[gridItem.row]++;
      log.showDebug(`row ${gridItem.row}, rowCount: ${occupiedRow[gridItem.row]}, bundleName: ${gridItem.bundleName}`);
      if (LauncherLayoutCacheUtil.checkIfClockCard(gridItem)) {
        clockCardExist = true;
        clockCardItem = gridItem;
      }
    }
    if (clockCardExist) {
      // 不在首行，不满足要求
      if (!clockCardItem || clockCardItem.row !== 0) {
        log.showInfo('clock item not on row 0');
        return undefined;
      }
      let cardHeight: number = clockCardItem.area ? clockCardItem.area[1] : DEFAULT_CLOCK_CARD_HEIGHT;
      for (let start = 0; start < cardHeight; start++) {
        log.showInfo(`checkClockCardExistAndRowExclusive:clock exists ${start},  ${occupiedRow[start]}`);
        // 首行仅自己，其他行无元素
        if ((start === 0 && occupiedRow[start] > 1) || (start !== 0 && occupiedRow[start] > 0)) {
          return undefined;
        }
      }
      return clockCardItem;
    }
    return undefined;
  }

  private static updateLayoutInfo(deskTopLayoutInfo: DefaultDesktopLayoutInfo, page: number,
    gridLayoutItemInfo: GridLayoutItemInfo[], extraItemMap: HashMap<string, GridLayoutItemInfo>,
    newGrid?: number[]): void {
    // 一字排序
    let res: ArrayList<GridLayoutItemInfo> = LauncherLayoutCacheUtil.sortLayoutInfo(deskTopLayoutInfo, page);
    // 是否是时钟卡片独占一行，此情况转屏后时钟卡片单独处理独占居中
    let clockCard: GridLayoutItemInfo | undefined =
      LauncherLayoutCacheUtil.checkClockCardExistAndRowExclusive(deskTopLayoutInfo, page);
    log.showInfo(`updateLayoutInfo clockCardAndRowExclusive: ${clockCard ? true : false}, page: ${page}`);
    // 翻转后宽高交换
    let column: number = newGrid ? newGrid[1] : deskTopLayoutInfo.layoutDescription.column;
    let row: number = newGrid ? newGrid[0] : deskTopLayoutInfo.layoutDescription.row;
    log.showInfo(`updateLayoutInfo column: ${column}, row: ${row}`);
    let legal: boolean = false;
    if (clockCard) {
      // 先按时钟居中放
      legal = LauncherLayoutCacheUtil.updateIconPositionClockExclusive(clockCard.area, column, row, res,
        SORT_TYPE_REGULAR, extraItemMap);
      if (!legal) {
        // 时钟居中放不下，占用时钟区域放
        LauncherLayoutCacheUtil.clearExtraItemMapOnPage(page, extraItemMap);
        legal = LauncherLayoutCacheUtil.updateIconPosition(column, row, res, SORT_TYPE_REGULAR, extraItemMap);
      }
    } else {
      legal = LauncherLayoutCacheUtil.updateIconPosition(column, row, res, SORT_TYPE_REGULAR, extraItemMap);
    }
    // 能放下就往里加
    if (legal) {
      res.forEach(item => {
        gridLayoutItemInfo.push(item);
      });
      log.showInfo('updateLayoutInfo find new position for all gridInfos successfully');
    } else {
      // 一字排序排不下，兜底排序
      log.showInfo('start final sort');
      res = LauncherLayoutCacheUtil.getFinalSortLayout(deskTopLayoutInfo, page);
      legal = LauncherLayoutCacheUtil.updateIconPosition(column, row, res, SORT_TYPE_FINAL, extraItemMap);
      LauncherLayoutCacheUtil.startFinalSort(legal, page, res, gridLayoutItemInfo, extraItemMap);
    }
  }

  private static clearExtraItemMapOnPage(page: number, extraItemMap: HashMap<string, GridLayoutItemInfo>): void {
    log.showInfo(`clearExtraItemMapOnPage: ${page}`);
    let currentPageItem: string[] = [];
    extraItemMap.forEach((value, key) => {
      if (!value || !key) {
        return;
      }
      if (value.page === page) {
        currentPageItem.push(key);
      }
    });
    for (let i = 0; i < currentPageItem.length; i++) {
      extraItemMap.remove(currentPageItem[i]);
    }
  }

  private static startFinalSort(legal: boolean, page: number, res: ArrayList<GridLayoutItemInfo>,
    gridLayoutItemInfo: GridLayoutItemInfo[], extraItemMap: HashMap<string, GridLayoutItemInfo>): void {
    log.showInfo(`gridInfosLength: ${gridLayoutItemInfo.length}`);
    if (!legal) {
      // 仅保留不在 extraItemMap 中的元素
      for (let i = 0; i < res.length; i++) {
        const item = res[i];
          if (!extraItemMap.hasKey(LauncherLayoutCacheUtil.getKey(item))) {
            gridLayoutItemInfo.push(item);
          }
        }
      log.showError('can not find proper position for all gridInfos');
    } else {
      LauncherLayoutCacheUtil.clearExtraItemMapOnPage(page, extraItemMap);
      res.forEach(item => {
        gridLayoutItemInfo.push(item);
      });
      log.showInfo('startFinalSort find new position for all gridInfos successfully');
    }
  }

  /**
   * 将暂存元素放到新页的对应位置
   *
   *  @param deskTopLayoutInfo 排序后的竖屏布局
   *  @param copyDeskTopLayoutInfo 初始横屏布局
   *  @param extraItemMap 暂存元素集
   */
  private static setExtraItemPosition(deskTopLayoutInfo: DefaultDesktopLayoutInfo,
    copyDeskTopLayoutInfo: DefaultDesktopLayoutInfo, extraItemMap: HashMap<string, GridLayoutItemInfo>): void {
    let pageMap: Map<number, GridLayoutItemInfo[]> = new Map();
    //根据页码将暂存元素分组
    extraItemMap.forEach((item) => {
      if (!item || item.page === undefined) {
        return;
      }
      if (!pageMap.has(item.page)) {
        pageMap.set(item.page, []);
      }
      pageMap.get(item.page)!.push(item);
    });
    let pageList: Array<Array<GridLayoutItemInfo>> = Array.from(pageMap.keys())
      .sort((a, b) => a - b)
      .map(page => pageMap.get(page)!);
    //分别处理每一页放不下的元素
    for (let i = 0; i < pageList.length; i++) {
      if (deskTopLayoutInfo.layoutDescription.maxPage > deskTopLayoutInfo.layoutDescription.pageCount + 1) {
        LauncherLayoutCacheUtil.addPageAndSetPosition(pageList, i, deskTopLayoutInfo, copyDeskTopLayoutInfo);
      } else {
        LauncherLayoutCacheUtil.showErrorInfo(i, pageList);
      }
    }
  }

  private static showErrorInfo(i: number, pageList: Array<Array<GridLayoutItemInfo>>): void {
    for (let j = i + 1; j < pageList.length; j++) {
      for (let k = 0; k < pageList[j].length; k++) {
        log.showError('can not add new Pages, bundleName: ' + pageList[j][k].bundleName + 'can not set position');
      }
    }
  }

  private static addPageAndSetPosition(pageList: GridLayoutItemInfo[][], i: number,
    deskTopLayoutInfo: DefaultDesktopLayoutInfo, copyDeskTopLayoutInfo: DefaultDesktopLayoutInfo): void {
    let mPage = pageList[i][0].page;
    if (mPage === undefined) {
      return;
    }
    let nextPage: number = mPage + 1;
    //将后面的页依次后移，腾出一个新增页
    copyDeskTopLayoutInfo.layoutInfo.forEach(item => {
      if (item.page === undefined) {
        return;
      }
      if (item.page >= nextPage) {
        item.page += 1;
      }
    });
    deskTopLayoutInfo.layoutInfo.forEach(item => {
      if (item.page === undefined) {
        return;
      }
      if (item.page >= nextPage) {
        item.page += 1;
      }
    });
    for (let j = i + 1; j < pageList.length; j++) {
      pageList[j].forEach(item => {
        if (item.page === undefined) {
          return;
        }
        item.page++;
      });
    }
    let sortPageList: ArrayList<GridLayoutItemInfo> = new ArrayList();
    let sortPageList2: ArrayList<GridLayoutItemInfo> = new ArrayList();
    pageList[i].forEach(item => {
      sortPageList.add(item);
    });
    LauncherLayoutCacheUtil.regularSort(sortPageList);
    pageList[i].forEach(item => {
      sortPageList2.add(item);
    });
    //将暂存元素按序放入空白页
    LauncherLayoutCacheUtil.regularSort(sortPageList2);
    LauncherLayoutCacheUtil.updateIconPosition(deskTopLayoutInfo.layoutDescription.row,
      deskTopLayoutInfo.layoutDescription.column, sortPageList, SORT_TYPE_REGULAR);
    LauncherLayoutCacheUtil.updateIconPosition(copyDeskTopLayoutInfo.layoutDescription.column,
      copyDeskTopLayoutInfo.layoutDescription.row, sortPageList2, SORT_TYPE_REGULAR);
    sortPageList.forEach(item => {
      item.page = nextPage;
      deskTopLayoutInfo.layoutInfo.push(item);
    });
    sortPageList2.forEach(item => {
      for (let i = 0; i < copyDeskTopLayoutInfo.layoutInfo.length; i++) {
        if (LauncherLayoutCacheUtil.getKey(copyDeskTopLayoutInfo.layoutInfo[i]) ===
          LauncherLayoutCacheUtil.getKey(item)) {
          copyDeskTopLayoutInfo.layoutInfo.splice(i, 1);
        }
      }
      item.page = nextPage;
      copyDeskTopLayoutInfo.layoutInfo.push(item);
    });
    copyDeskTopLayoutInfo.layoutDescription.pageCount++;
    deskTopLayoutInfo.layoutDescription.pageCount++;
  }

  private static updateIconPositionClockExclusive(area: number[] | undefined, column: number, row: number,
    res: ArrayList<GridLayoutItemInfo>, sortType: string, extraItemMap: HashMap<string, GridLayoutItemInfo>): boolean {
    log.showInfo('updateIconPositionClockExclusive');
    let desktop: number[][] = LauncherLayoutCacheUtil.initializeDesktop(row, column);
    let clockHeight: number = area ? area[1] : DEFAULT_CLOCK_CARD_HEIGHT;
    let clockWidth: number = area ? area[0] : DEFAULT_CLOCK_CARD_WIDTH;
    // 时钟所在行尽量不放其他元素, 此处需要翻转: eg: column 10, row 6 => column 10, row 6
    for (let cIdx = 0; cIdx < row; cIdx++) {
      for (let rIdx = 0; rIdx < clockHeight; rIdx++) {
        log.showDebug(`updateIconPositionClockExclusive occpied at column: ${cIdx}, row: ${rIdx}`);
        desktop[cIdx][rIdx] = 1;
      }
    }
    for (const gridInfo of res) {
      if (LauncherLayoutCacheUtil.checkIfClockCard(gridInfo)) {
        gridInfo.column = (row - clockWidth) / 2;
        log.showInfo(`placeClockCard at column: ${gridInfo.column}`);
        continue;
      }
      let mBaseGrid = LauncherLayoutCacheUtil.getGridSize(gridInfo);
      let gridColumn = mBaseGrid.gridColumn;
      let gridRow = mBaseGrid.gridRow;
      let position = LauncherLayoutCacheUtil.findPositionForIcon(desktop, gridColumn, gridRow, row, column);
      if (position) {
        LauncherLayoutCacheUtil.placeIcon(desktop, position, gridColumn, gridRow, gridInfo);
      } else {
        log.showWarn('updateIconPositionClockExclusive not find suitable position');
        if (sortType === SORT_TYPE_REGULAR) {
          extraItemMap.set(LauncherLayoutCacheUtil.getKey(gridInfo), gridInfo);
        }
        return false;
      }
    }
    return true;
  }

  private static updateIconPosition(column: number, row: number, res: ArrayList<GridLayoutItemInfo>, sortType: string,
    extraItemMap?: HashMap<string, GridLayoutItemInfo>): boolean {
    let legal: boolean = true;
    let desktop: number[][] = LauncherLayoutCacheUtil.initializeDesktop(row, column);
    for (const gridInfo of res) {
      let mBaseGrid = LauncherLayoutCacheUtil.getGridSize(gridInfo);
      let gridColumn = mBaseGrid.gridColumn;
      let gridRow = mBaseGrid.gridRow;
      let position = LauncherLayoutCacheUtil.findPositionForIcon(desktop, gridColumn, gridRow, row, column);
      if (position) {
        LauncherLayoutCacheUtil.placeIcon(desktop, position, gridColumn, gridRow, gridInfo);
      } else {
        if (sortType === SORT_TYPE_FINAL && extraItemMap) {
          // 将放不下的元素放入 extraItemMap
          extraItemMap.set(LauncherLayoutCacheUtil.getKey(gridInfo), gridInfo);
        }
        legal = false;
        break;
      }
    }
    return legal;
  }

  private static initializeDesktop(row: number, column: number): number[][] {
    return new Array(row).fill(0).map(() => new Array(column).fill(0));
  }

  private static getGridSize(gridInfo: GridLayoutItemInfo): BaseGrid {
    let gridColumn = gridInfo.area ? gridInfo.area[0] : 0;
    let gridRow = gridInfo.area ? gridInfo.area[1] : 0;
    return { gridColumn, gridRow };
  }

  private static findPositionForIcon(desktop: number[][], gridColumn: number, gridRow: number, row: number,
    column: number): BasePosition | null {
    for (let j = 0; j <= column - gridRow; j++) {
      for (let i = 0; i <= row - gridColumn; i++) {
        if (LauncherLayoutCacheUtil.canPlaceIcon(desktop, i, j, gridColumn, gridRow)) {
          return { i, j };
        }
      }
    }
    return null;
  }

  private static canPlaceIcon(desktop: number[][], i: number, j: number, gridColumn: number, gridRow: number): boolean {
    for (let x = i; x < i + gridColumn; x++) {
      for (let y = j; y < j + gridRow; y++) {
        if (desktop[x][y] !== 0) {
          return false;
        }
      }
    }
    return true;
  }

  private static placeIcon(desktop: number[][], position: BasePosition, gridColumn: number, gridRow: number, gridInfo: GridLayoutItemInfo): void {
    for (let x = position.i; x < position.i + gridColumn; x++) {
      for (let y = position.j; y < position.j + gridRow; y++) {
        desktop[x][y] = 1; // 标记为已占用
      }
    }
    gridInfo.row = position.j;
    gridInfo.column = position.i;
  }

  private static getFinalSortLayout(deskTopLayoutInfo: DefaultDesktopLayoutInfo, page: number): ArrayList<GridLayoutItemInfo> {
    log.showInfo(`getFinalSortLayout at page: ${page}`);
    let res: ArrayList<GridLayoutItemInfo> = LauncherLayoutCacheUtil.findPageItems(deskTopLayoutInfo, page);
    res.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo): number => {
      // 检查a或b本身是否为null或undefined
      if (!a && !b) {
        return 0; // a和b都未定义，视为相等
      }
      if (!a) {
        return 1; // 只有a未定义，认为a较小
      }
      if (!b) {
        return -1; // 只有b未定义，认为b较小
      }
      let aArea = (a.area && a.area.length === 2) ? a.area[0] * a.area[1] : 0;
      let bArea = (b.area && b.area.length === 2) ? b.area[0] * b.area[1] : 0;
      if (aArea < bArea) {
        return 1;
      } else if (aArea > bArea) {
        return -1;
      } else {
        return LauncherLayoutCacheUtil.tryRegularSort(a, b);
      }
    });
    return res;
  }

  private static tryRegularSort(a: GridLayoutItemInfo, b: GridLayoutItemInfo): number {
    let aRow = typeof a.row !== 'undefined' ? a.row : Infinity;
    let bRow = typeof b.row !== 'undefined' ? b.row : Infinity;
    if (aRow < bRow) {
      return -1;
    } else if (aRow > bRow) {
      return 1;
    } else {
      let aColumn = typeof a.column !== 'undefined' ? a.column : Infinity;
      let bColumn = typeof b.column !== 'undefined' ? b.column : Infinity;
      if (aColumn < bColumn) {
        return -1;
      } else if (aColumn > bColumn) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  private static findPageItems(deskTopLayoutInfo: DefaultDesktopLayoutInfo, page: number): ArrayList<GridLayoutItemInfo> {
    let res: ArrayList<GridLayoutItemInfo> = new ArrayList();
    for (let i = 0; i < deskTopLayoutInfo.layoutInfo.length; i++) {
      if (deskTopLayoutInfo.layoutInfo[i].page === page) {
        res.add(deskTopLayoutInfo.layoutInfo[i]);
      }
    }
    return res;
  }

  public static getChangedLayout(defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo,
    currentDesktopLayoutInfo: DefaultDesktopLayoutInfo): GridLayoutItemInfo[] {
    let originalLayout: DefaultDesktopLayoutInfo =
      JSON.parse(JSON.stringify(defaultDesktopLayoutInfo)) as DefaultDesktopLayoutInfo;
    let currentLayout: DefaultDesktopLayoutInfo =
      JSON.parse(JSON.stringify(currentDesktopLayoutInfo)) as DefaultDesktopLayoutInfo;
    let changedPages: HashSet<number> = new HashSet();
    let layoutMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
    LauncherLayoutCacheUtil.createLayoutMap(originalLayout, layoutMap);
    let layoutInfo: GridLayoutItemInfo[] = currentLayout.layoutInfo;
    LauncherLayoutCacheUtil.getDiff(layoutInfo, layoutMap, changedPages);
    layoutMap.clear();
    LauncherLayoutCacheUtil.createLayoutMap(currentLayout, layoutMap);
    layoutInfo = originalLayout.layoutInfo;
    LauncherLayoutCacheUtil.getDiff(layoutInfo, layoutMap, changedPages);
    return LauncherLayoutCacheUtil.getChangedPagesItems(changedPages, currentLayout);
  }

  private static getDiff(layoutInfo: GridLayoutItemInfo[], layoutMap: HashMap<string, GridLayoutItemInfo>, changedPages: HashSet<number>): void {
    for (let i = 0; i < layoutInfo.length; i++) {
      // 避免重复计算
      if (!changedPages.has(layoutInfo[i].page)) {
        if (!LauncherLayoutCacheUtil.isSameLayout(layoutInfo[i], layoutMap)) {
          changedPages.add(layoutInfo[i].page);
        }
      }
    }
  }

  private static getChangedPagesItems(changedPages: HashSet<number>, currentLayout: DefaultDesktopLayoutInfo): GridLayoutItemInfo[] {
    let changedLayout: GridLayoutItemInfo[] = [];
    currentLayout.layoutInfo.forEach(item => {
      if (changedPages.has(item.page)) {
        changedLayout.push(item);
      }
    });
    return changedLayout;
  }

  private static createLayoutMap(deskTopLayoutInfo: DefaultDesktopLayoutInfo, layoutMap: HashMap<string, GridLayoutItemInfo>): void {
    let layoutInfo = deskTopLayoutInfo.layoutInfo;
    for (let i = 0; i < layoutInfo.length; i++) {
      let key: string = LauncherLayoutCacheUtil.getKey(layoutInfo[i]);
      layoutMap.set(key, layoutInfo[i]);
    }
  }

  private static getKey(gridLayoutItemInfo: GridLayoutItemInfo): string {
    return gridLayoutItemInfo.bundleName + gridLayoutItemInfo.moduleName + TYPE_ID + gridLayoutItemInfo?.typeId +
      CARD_ID + gridLayoutItemInfo?.cardId + FOLDER_NAME + gridLayoutItemInfo?.folderName + FOLDER_ID + gridLayoutItemInfo?.folderId +
      STACK_ID + gridLayoutItemInfo?.formStackId + INFO_ID + gridLayoutItemInfo?.infoId;
  }

  private static isSameLayout(item: GridLayoutItemInfo, layoutMap: HashMap<string, GridLayoutItemInfo>): boolean {
    if (!layoutMap.hasKey(LauncherLayoutCacheUtil.getKey(item))) {
      return false;
    }
    let originalLayout = layoutMap.get(LauncherLayoutCacheUtil.getKey(item));
    if (!originalLayout) {
      return false;
    } else {
      if (item.page !== originalLayout.page) {
        return false;
      }
      if (item.row !== originalLayout.row || item.column !== originalLayout.column) {
        return false;
      }
      if (item.area && originalLayout.area && item.area.length === 2 && originalLayout.area.length === 2) {
        if (item.area[0] !== originalLayout.area[0] || item.area[1] !== originalLayout.area[1]) {
          return false;
        }
      } else {
        return false;
      }
    }
    return true;
  }

  static getChangeItems(items: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (!items) {
      log.showError('getChangeItems error');
      return [];
    }
    let targetInfo: GridLayoutItemInfo[] = items;
    if (LauncherLayoutCacheUtil.isLazyRotate) {
      targetInfo = LauncherLayoutCacheUtil.getLazyRotateChangeItems(targetInfo);
      return targetInfo;
    }
    if (!LauncherLayoutCacheUtil.isDefaultPortrait && LauncherLayoutCacheUtil.isPadPortrait) {
      targetInfo = LauncherLayoutCacheUtil.changeItemsIfPortrait(items);
    }
    if (LauncherLayoutCacheUtil.isDefaultPortrait && !LauncherLayoutCacheUtil.isPadPortrait) {
      targetInfo = LauncherLayoutCacheUtil.changeItemsIfLandscape(items);
    }
    return targetInfo;
  }

  /**
   * 默认横屏时，更新items信息
   */
  public static changeItemsIfPortrait(items: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let result: GridLayoutItemInfo[] = [];
    if (!LauncherLayoutCacheUtil.isDefaultPortrait && LauncherLayoutCacheUtil.isPadPortrait) {
      log.showWarn('Portrait Mode changeItems');
      LauncherLayoutCacheUtil.updateLandscapeCacheFromPortrait(LauncherLayoutCacheUtil.getAppItemListPage(items));
      let keySet: HashSet<string> = new HashSet();
      for (let item of items) {
        keySet.add(LauncherLayoutCacheUtil.getKey(item));
      }
      for (let item of LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo.layoutInfo) {
        if (keySet.has(LauncherLayoutCacheUtil.getKey(item))) {
          result.push(item);
        }
      }
    }
    return result;
  }

  /**
   * 默认竖屏时，更新items信息
   */
  private static changeItemsIfLandscape(items: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let result: GridLayoutItemInfo[] = [];
    if (LauncherLayoutCacheUtil.isDefaultPortrait && !LauncherLayoutCacheUtil.isPadPortrait) {
      log.showWarn('Landscape Mode changeItems');
      LauncherLayoutCacheUtil.updatePortraitCacheFromLandscape(LauncherLayoutCacheUtil.getAppItemListPage(items));
      let keySet: HashSet<string> = new HashSet();
      for (let item of items) {
        keySet.add(LauncherLayoutCacheUtil.getKey(item));
      }
      for (let item of LauncherLayoutCacheUtil.portraitDesktopLayoutInfo.layoutInfo) {
        if (keySet.has(LauncherLayoutCacheUtil.getKey(item))) {
          result.push(item);
        }
      }
    }
    return result;
  }

  /**
   * 更新数据库前，获取item非默认方向的位置信息
   */
  private static getItemByPosition(page: number, column: number, row: number, typeId?: number):
    GridLayoutItemInfo | null {
    let layoutInfo = LauncherLayoutCacheUtil.isDefaultPortrait ? LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo.layoutInfo :
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo.layoutInfo;
    for (let item of layoutInfo) {
      if (item.page === page && item.column === column && item.row === row) {
        if (typeId === undefined || typeId === item.typeId) {
          return item;
        }
      }
    }
    return null;
  }

  private static addOldUpdatePage(updatePages: number[], fromPage: number): number[] {
    log.showInfo(`fromPage: ${fromPage}}`);
    for (let i = 0; i < updatePages.length; i++) {
      if (fromPage < updatePages[0]) {
        updatePages = [fromPage, ...updatePages];
        break;
      } else if (fromPage > updatePages[i] && fromPage < updatePages[i + 1]) {
        updatePages.splice(i, 0, fromPage);
        break;
      } else if (fromPage > updatePages[updatePages.length - 1]) {
        updatePages.push(fromPage);
        break;
      }
    }
    log.showInfo(`updatePages: ${JSON.stringify(updatePages)}`);
    return updatePages;
  }

  private static getAppItemListPage(appItemsList: GridLayoutItemInfo[]): number[] {
    let updatePages: number[] = [];
    appItemsList.forEach((item) => {
      if (item.page !== undefined && updatePages.indexOf(item.page) === -1) {
        updatePages.push(item.page);
      }
    });
    return updatePages;
  }

  /**
   * 默认横屏时更新内部缓存
   */
  private static updateLandscapeCacheFromPortrait(updatePages?: number[]): void {
    log.showWarn('updateLandscapeCacheFromPortrait');
    let isOperateDb: boolean = true;
    if (!LauncherLayoutCacheUtil.isDefaultPortrait && LauncherLayoutCacheUtil.isPadPortrait) {
      let tempLayoutInfo = LauncherLayoutCacheUtil.getRotateLayout(LauncherLayoutCacheUtil.portraitDesktopLayoutInfo, false, updatePages);
      let changedItems: GridLayoutItemInfo[] =
        LauncherLayoutCacheUtil.getChangedLayout(this.landscapeDesktopLayoutInfo, tempLayoutInfo);
      this.changedItemsLog(changedItems);
      RdbStoreManager.getInstance().updateInfoPosition(changedItems, 'updateLandscapeCacheFromPortrait');
      this.landscapeDesktopLayoutInfo.layoutInfo = tempLayoutInfo.layoutInfo;
      this.landscapeDesktopLayoutInfo.layoutDescription = tempLayoutInfo.layoutDescription;
      this.updateLandscapeCacheData(this.landscapeDesktopLayoutInfo);
    }
  }

  private static changedItemsLog(changedItems: GridLayoutItemInfo[]): void {
    if (changedItems.length === 0) {
      log.showWarn(`updateLandscapeCacheFromPortrait has no changedItems return!`);
      return;
    }
    log.showWarn(`updateLandscapeCacheFromPortrait changedItems length: ${changedItems.length}`);
    let changedItemsLogList: string[] = [];
    for (let i = 0; i < changedItems.length; i++) {
      let mPage = changedItems[i].page;
      let mRow = changedItems[i].row;
      let mColumn = changedItems[i].column;
      let mArea = changedItems[i].area;
      if (mPage === undefined || mRow === undefined || mColumn === undefined || !mArea) {
        continue;
      }
      let changedItemsLog: (number | string)[] = [changedItems[i].bundleName, mPage, mRow,
        mColumn, mArea[0], mArea[1]];
      changedItemsLogList.push(changedItemsLog.join(','));
    }
    log.showWarn(`updateLandscapeCacheFromPortrait changedItems: ${changedItemsLogList.join(',')}`);
  }

  /**
   * 默认竖屏时更新内部缓存
   */
  private static updatePortraitCacheFromLandscape(updatePages?: number[]): void {
    log.showWarn('updatePortraitCacheFromLandscape');
    let isOperateDb: boolean = true;
    if (LauncherLayoutCacheUtil.isDefaultPortrait && !LauncherLayoutCacheUtil.isPadPortrait) {
      let tempLayoutInfo = LauncherLayoutCacheUtil.getRotateLayout(LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo, true, updatePages);
      if (isOperateDb) {
        let changedItems: GridLayoutItemInfo[] =
          LauncherLayoutCacheUtil.getChangedLayout(LauncherLayoutCacheUtil.portraitDesktopLayoutInfo, tempLayoutInfo);
        RdbStoreManager.getInstance().updateInfoPosition(changedItems, 'updatePortraitCacheFromLandscape');
      }
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo.layoutInfo = tempLayoutInfo.layoutInfo;
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo.layoutDescription = tempLayoutInfo.layoutDescription;
      LauncherLayoutCacheUtil.updatePortraitCacheData(LauncherLayoutCacheUtil.portraitDesktopLayoutInfo);
    }
  }

  /**
   * 根据当前场景，更新CacheData需要的items
   * 竖屏更新竖屏缓存，横屏更新横屏缓存
   * @param items 用户布局操作的items
   */
  public static getLazyRotateChangeItemsForCache(items: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (!LauncherLayoutCacheUtil.isLazyRotate) {
      log.showWarn('getLazyRotateChangeItemsForCache not lazyRotate');
      return items;
    }
    if (LauncherLayoutCacheUtil.isPadPortrait) {
      LauncherLayoutCacheUtil.changeCachePortrait(items);
    } else {
      LauncherLayoutCacheUtil.changeCacheLandscape(items);
    }
    log.showInfo(`getLazyRotateChangeItemsForCache ${items.length}`);
    items.forEach(LauncherLayoutCacheUtil.padDeviceItemPositionLog);
    return items;
  }

  /**
   * 根据当前场景，计算入库需要的items
   * 横屏时入库前需要更新items信息
   * @param items cacheData的items
   */
  private static getLazyRotateChangeItems(items: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (!LauncherLayoutCacheUtil.isLazyRotate) {
      log.showWarn('getLazyRotateChangeItems not lazyRotate');
      return items;
    }
    if (LauncherLayoutCacheUtil.isPadPortrait !== LauncherLayoutCacheUtil.isDefaultPortrait) {
      // 深拷贝防止改掉cacheData的位置信息
      let list: GridLayoutItemInfo[] = ObjectCopyUtil.deepClone(items);
      list.forEach(item => {
        if (LauncherLayoutCacheUtil.isDefaultPortrait) {
          item.row = item.portraitRow;
          item.column = item.portraitColumn;
          item.page = item.portraitPage;
          item.area = [item.portraitArea?.[0] ?? 0, item.portraitArea?.[1] ?? 0];
        } else {
          item.row = item.landscapeRow;
          item.column = item.landscapeColumn;
          item.page = item.landscapePage;
        }
      });
      return list;
    }
    if (LauncherLayoutCacheUtil.getIsFirstRotate()) {
      LauncherLayoutCacheUtil.updateCacheIfFirstRotate();
      let result: GridLayoutItemInfo[] = [];
      let keySet: HashSet<string> = new HashSet();
      log.showInfo(`getLazyRotateChangeItems ${LauncherLayoutCacheUtil.isDefaultPortrait}, items len: ${items.length}`);
      const layoutInfo: DefaultDesktopLayoutInfo = LauncherLayoutCacheUtil.isDefaultPortrait ?
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo : LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo;
      for (let item of items) {
        keySet.add(LauncherLayoutCacheUtil.getKey(item));
      }
      for (let item of layoutInfo.layoutInfo) {
        if (keySet.has(LauncherLayoutCacheUtil.getKey(item))) {
          result.push(item);
        }
      }
      log.showInfo(`getLazyRotateChangeItemsForCache ${result.length}`);
      return result;
    } else {
      // 默认方向非首次旋转不用修改
      return items;
    }
  }

  /**
   * 默认方向首次旋转的更改，需要额外更新非默认方向重排布局
   */
  private static updateCacheIfFirstRotate(): void {
    let tempLayoutInfo: DefaultDesktopLayoutInfo;
    let changedItems: GridLayoutItemInfo[];
    let changeMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
    if (LauncherLayoutCacheUtil.isDefaultPortrait) {
      const newGrid: number[] = [SuperFoldConstants.DEFAULT_NON_PORTRAIT_ROW,
        SuperFoldConstants.DEFAULT_NON_PORTRAIT_COLUMN];
      tempLayoutInfo = LauncherLayoutCacheUtil.getRotateLayout(LauncherLayoutCacheUtil.portraitDesktopLayoutInfo,
        false, [], newGrid);
      changedItems = LauncherLayoutCacheUtil.getChangedLayout(LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo,
        tempLayoutInfo);
      changedItems.forEach(item => {
        item.row = item.portraitRow;
        item.column = item.portraitColumn;
        item.page = item.portraitPage;
        item.area = [item.portraitArea?.[0] ?? 0, item.portraitArea?.[1] ?? 0];
        changeMap.set(LauncherLayoutCacheUtil.getKey(item), item);
      })
      LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo.layoutInfo = tempLayoutInfo.layoutInfo;
      LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo.layoutDescription = tempLayoutInfo.layoutDescription;
      LauncherLayoutCacheUtil.updateLandscapeCacheData(LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo);
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo.layoutInfo.forEach(item => {
        if (changeMap.hasKey(LauncherLayoutCacheUtil.getKey(item))) {
          const changeItem: GridLayoutItemInfo = changeMap.get(LauncherLayoutCacheUtil.getKey(item));
          item.landscapeRow = changeItem.landscapeRow;
          item.landscapeColumn = changeItem.landscapeColumn;
          item.landscapePage = changeItem.landscapePage;
          item.landscapeArea = [changeItem.area?.[0] ?? 0, changeItem.area?.[1] ?? 0];
        }
      });
    } else {
      tempLayoutInfo = LauncherLayoutCacheUtil.getRotateLayout(LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo,
        true);
      changedItems = LauncherLayoutCacheUtil.getChangedLayout(LauncherLayoutCacheUtil.portraitDesktopLayoutInfo,
        tempLayoutInfo);
      changedItems.forEach(item => {
        item.row = item.landscapeRow;
        item.column = item.landscapeColumn;
        item.page = item.landscapePage;
        changeMap.set(LauncherLayoutCacheUtil.getKey(item), item);
      })
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo.layoutInfo = tempLayoutInfo.layoutInfo;
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo.layoutDescription = tempLayoutInfo.layoutDescription;
      LauncherLayoutCacheUtil.updatePortraitCacheData(LauncherLayoutCacheUtil.portraitDesktopLayoutInfo);
      LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo.layoutInfo.forEach(item => {
        if (changeMap.hasKey(LauncherLayoutCacheUtil.getKey(item))) {
          const changeItem: GridLayoutItemInfo = changeMap.get(LauncherLayoutCacheUtil.getKey(item));
          item.portraitRow = changeItem.portraitRow;
          item.portraitColumn = changeItem.portraitColumn;
          item.portraitPage = changeItem.portraitPage;
        }
      });
    }
  }

  private static updateHorizontalPosition(gridList: GridLayoutItemInfo[],
    cardInfo: CardItemInfo | GridLayoutItemInfo): boolean {
    const row: number = SuperFoldConstants.DEFAULT_NON_PORTRAIT_ROW;
    const column: number = SuperFoldConstants.DEFAULT_NON_PORTRAIT_COLUMN;
    const page: number = SuperFoldConstants.DEFAULT_PAGE_COUNT;
    for (let i = page - 1; i >= 0; i--) {
      for (let x = column; x >= 0; x--) {
        if (LauncherLayoutCacheUtil.isRowValidCycle(gridList, cardInfo, column, row, i, x)) {
          return true;
        }
      }
    }
    return false;
  }

  private static updatePortraitPosition(gridList: GridLayoutItemInfo[],
    cardInfo: CardItemInfo | GridLayoutItemInfo): boolean {
    const row: number = SuperFoldConstants.DEFAULT_PORTRAIT_ROW;
    const column: number = SuperFoldConstants.DEFAULT_PORTRAIT_COLUMN;
    const page: number = SuperFoldConstants.DEFAULT_PAGE_COUNT;
    for (let x = column; x >= 0; x--) {
      for (let i = 0; i < page; i++) {
        if (LauncherLayoutCacheUtil.isRowValidCycle(gridList, cardInfo, column, row, i, x)) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * hpr双缓存机制 查找并更新另一状态（竖屏对应横屏/横屏对应竖屏）卡片位置
   * @param gridList
   * @param cardInfo
   * @returns
   */
  public static updateCardAnotherStatusPosition(gridList: GridLayoutItemInfo[],
    cardInfo: CardItemInfo | GridLayoutItemInfo): boolean {
    if (!LauncherLayoutCacheUtil.isLazyRotate) {
      log.showWarn('findCardAnotherStatusPosition, is not lazyRotate');
      return false;
    }
    if (CheckEmptyUtils.isEmpty(cardInfo) || CheckEmptyUtils.isEmptyArr(cardInfo.area)) {
      log.showWarn('findCardAnotherStatusPosition error, info is null');
      return false;
    }
    if (!DeviceHelper.isSuperFoldMachine()) {
      log.showWarn('isSuperFoldMachine device mismatch return!')
      return true;
    }
    if (LauncherLayoutCacheUtil.isPadPortrait) {
      // 竖屏去横屏寻找空位
      return LauncherLayoutCacheUtil.updateHorizontalPosition(gridList, cardInfo);
    } else {
      // 横屏去竖屏寻找空位
      return LauncherLayoutCacheUtil.updatePortraitPosition(gridList, cardInfo);
    }
  }

  /**
   * 添加元素时，计算另一屏的空位
   */
  public static findLazyRotatePosition(gridList: GridLayoutItemInfo[], info: GridLayoutItemInfo | CardItemInfo,
    overPage?: number): boolean {
    if (!LauncherLayoutCacheUtil.isLazyRotate) {
      log.showWarn('findLazyRotatePosition not lazyRotate');
      return false;
    }
    if (!info || !info.area || CheckEmptyUtils.isEmptyArr(info.area)) {
      log.showWarn('findPosition error as the item is null');
      return false;
    }
    let row: number = 0;
    let column: number = 0;
    let page: number = 0;
    if (LauncherLayoutCacheUtil.isPadPortrait) {
      row = SuperFoldConstants.DEFAULT_NON_PORTRAIT_ROW;
      column = SuperFoldConstants.DEFAULT_NON_PORTRAIT_COLUMN;
      page = 2;
    } else {
      row = SuperFoldConstants.DEFAULT_PORTRAIT_ROW;
      column = SuperFoldConstants.DEFAULT_PORTRAIT_COLUMN;
      page = 2;
    }
    if (DeviceHelper.isPad()) {
      gridList.forEach(LauncherLayoutCacheUtil.padDeviceItemPositionLog);
      const layoutInfo = LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo;
      row = LauncherLayoutCacheUtil.isPadPortrait ? layoutInfo.layoutDescription.row : layoutInfo.layoutDescription.column;
      column = LauncherLayoutCacheUtil.isPadPortrait ? layoutInfo.layoutDescription.column : layoutInfo.layoutDescription.row;
      overPage = overPage !== undefined ? overPage : info.page;
      for (let y = 0; y <= row - info.area[1]; y++) {
        if (LauncherLayoutCacheUtil.isColumnValidCycle(gridList, info, column, row, overPage ?? 0, y)) {
          LauncherLayoutCacheUtil.padDeviceItemPositionLog(info);
          return true;
        }
      }
      return false;
    }
    return LauncherLayoutCacheUtil.findBlank(page, column, info, gridList, row);
  }

  private static findBlank(page: number, column: number, info: GridLayoutItemInfo | CardItemInfo,
    gridList: GridLayoutItemInfo[], row: number): boolean {
    if (LauncherLayoutCacheUtil.isPadPortrait) {
      // 竖屏去横屏寻找空位
      for (let i = 0; i < page; i++) {
        for (let x = 0; x <= column - info.area[0]; x++) {
          if (LauncherLayoutCacheUtil.isRowValidCycle(gridList, info, column, row, i, x)) {
            return true;
          }
        }
      }
    } else {
      // 横屏去竖屏寻找空位
      for (let x = 0; x <= column - info.area[0]; x++) {
        for (let i = 0; i < page; i++) {
          if (LauncherLayoutCacheUtil.isRowValidCycle(gridList, info, column, row, i, x)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  private static isColumnValidCycle(gridList: GridLayoutItemInfo[], info: GridLayoutItemInfo | CardItemInfo, column: number,
    row: number, page: number, startRow: number): boolean {
    for (let x = 0; x <= column - (info.area?.[0] ?? 0); x++) {
      if (LauncherLayoutCacheUtil.isLazyRotatePositionValid(gridList, column, row, info, page, x, startRow)) {
        LauncherLayoutCacheUtil.changeInfoCache(info, page, x, startRow);
        return true;
      }
    }
    return false;
  }

  private static isRowValidCycle(gridList: GridLayoutItemInfo[], info: GridLayoutItemInfo | CardItemInfo, column: number,
    row: number, page: number, col: number): boolean {
    for (let y = 0; y <= row - (info.area?.[1] ?? 0); y++) {
      if (LauncherLayoutCacheUtil.isLazyRotatePositionValid(gridList, column, row, info, page, col, y)) {
        LauncherLayoutCacheUtil.changeInfoCache(info, page, col, y);
        return true;
      }
    }
    return false;
  }

  private static changeInfoCache(info: GridLayoutItemInfo | CardItemInfo, page: number, column: number, row: number): void {
    if (LauncherLayoutCacheUtil.isPadPortrait) {
      info.landscapePage = page;
      info.landscapeRow = row;
      info.landscapeColumn = column;
      info.landscapeArea = [info.area?.[0] ?? 0, info.area?.[1] ?? 0];
    } else {
      info.portraitPage = page;
      info.portraitRow = row;
      info.portraitColumn = column;
      info.portraitArea = [info.area?.[0] ?? 0, info.area?.[1] ?? 0];
    }
  }

  public static isAddable(gridList: GridLayoutItemInfo[], item: GridLayoutItemInfo | CardItemInfo, page: number): boolean {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmptyArr(item.area)) {
      log.showWarn('isPositionValid error as the item is null');
      return false;
    }
    const layoutInfo = LauncherLayoutCacheUtil.isPadPortrait ? LauncherLayoutCacheUtil.portraitDesktopLayoutInfo :
    LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo;
    let row: number = layoutInfo.layoutDescription.row;
    let column: number = layoutInfo.layoutDescription.column;
    for (let y = 0; y <= row - (item.area?.[1] ?? 0); y++) {
      if (LauncherLayoutCacheUtil.isPositionOccupied(gridList, item, column, row, page, y)) {
        return true;
      }
    }
    return false;
  }

  private static isPositionOccupied(gridList: GridLayoutItemInfo[], info: GridLayoutItemInfo | CardItemInfo, column: number,
    row: number, page: number, startRow: number): boolean {
    for (let x = 0; x <= column - (info.area?.[0] ?? 0); x++) {
      if (LauncherLayoutCacheUtil.isRotatePositionValid(gridList, column, row, info, page, x, startRow)) {
        return true;
      }
    }
    return false;
  }

  /**
   * 检查LazyRotate时，另一屏是否有空白位置
   */
  private static isRotatePositionValid(gridList: GridLayoutItemInfo[], column: number, row: number,
    item : GridLayoutItemInfo | CardItemInfo, page: number, startColumn: number, startRow: number): boolean {
    if ((startColumn + (item.area?.[0] ?? 0)) > column || (startRow + (item.area?.[1] ?? 0)) > row) {
      return false;
    }
    let isValid: boolean = true;
    for (let x = startColumn; x < startColumn + (item.area?.[0] ?? 0); x++) {
      for (let y = startRow; y < startRow + (item.area?.[1] ?? 0); y++) {
        if (LauncherLayoutCacheUtil.isRotatePositionOccupied(gridList, page, x, y)) {
          isValid = false;
          break;
        }
      }
    }
    return isValid;
  }

  private static isRotatePositionOccupied(gridList: GridLayoutItemInfo[], page: number, column: number, row: number): boolean {
    for (const item of gridList) {
      if (!item.area) {
        continue;
      }
      if (!LauncherLayoutCacheUtil.isPadPortrait) {
        if (item.landscapePage !== page || item.landscapeColumn === undefined || item.landscapeRow === undefined) {
          continue;
        }
        const xMatch = (column >= item.landscapeColumn) && (column < item.landscapeColumn + item.area[0]);
        const yMatch = (row >= item.landscapeRow) && (row < item.landscapeRow + item.area[1]);
        if (xMatch && yMatch) {
          return true;
        }
      } else {
        if (item.portraitPage !== page || item.portraitColumn === undefined || item.portraitRow === undefined) {
          continue;
        }
        const xMatch = (column >= item.portraitColumn) && (column < item.portraitColumn + item.area[0]);
        const yMatch = (row >= item.portraitRow) && (row < item.portraitRow + item.area[1]);
        if (xMatch && yMatch) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 更新旋转屏位置入库
   * @param RotatePositionList
   */
  public static updateRotatePositionToDB(RotatePositionList: GridLayoutItemInfo[]): void {
    RdbStoreManager.getInstance().updateGridLayoutPositionBatch(RotatePositionList);
  }

  public static updateListIfLazyRotateMode(updateList: GridLayoutItemInfo[], layoutList: GridLayoutItemInfo[],
    label: string): GridLayoutItemInfo[] {
    log.showInfo(`updateListIfLazyRotateMode ${label}`);
    if (!DeviceHelper.isPad() || LauncherLayoutCacheUtil.getIsFirstRotate()) {
      log.showWarn('LazyRotateMode false or device mismatch return!')
      return updateList;
    }
    try {
      let insertGridItemList: GridLayoutItemInfo[] = [];
      let checkLayoutList: GridLayoutItemInfo[] = ObjectCopyUtil.deepClone(layoutList);
      updateList.forEach(item => {
        let updateItemList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.updateRotatePositionOperation(checkLayoutList, item);
        if (CheckEmptyUtils.isEmptyArr(updateItemList)) {
          log.showWarn(`insertGridLayoutItemList return cannot find rotate positon!`);
          return;
        }
        insertGridItemList.push(updateItemList[0]);
        checkLayoutList.push(updateItemList[0]);
      })
      updateList = insertGridItemList;
      updateList.forEach(item => {
        LauncherLayoutCacheUtil.padDeviceItemPositionLog(item);
      })
    } catch (e) {
      log.showError('updateListIfLazyRotateMode error!');
    }
    return updateList;
  }

  public static padDeviceItemPositionLog(item: GridLayoutItemInfo | CardItemInfo): void {
    let pageStr: string = 'page:' + item.page;
    let rowStr: string = 'row:' + item.row;
    let columnStr: string = 'column:' + item.column;
    let landscapePageStr: string = 'landscapePage:' + item.landscapePage;
    let landscapeRowStr: string = 'landscapeRow:' + item.landscapeRow;
    let landscapeColumnStr: string = 'landscapeColumn:' + item.landscapeColumn;
    let portraitPageStr: string = 'portraitPage:' + item.portraitPage;
    let portraitRowStr: string = 'portraitRow:' + item.portraitRow;
    let portraitColumnStr: string = 'portraitColumn:' + item.portraitColumn;
    log.showInfo(`${item.bundleName},area:${item.area?.toString()},${pageStr},${rowStr},${columnStr},${landscapePageStr},${landscapeRowStr},${landscapeColumnStr},` +
      `${portraitPageStr},${portraitRowStr},${portraitColumnStr}`);
  }

  /**
   * 校验pad当前屏能否添加元素
   * @param page 当前添加页数
   * @param itemRow 元素宽度
   * @param itemColumn 元素高度
   * @returns 是否能添加，true能，false不能
   */
  public static isAddableDefault(defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo, page: number, itemRow: number, itemColumn: number): boolean {
    let deskTopLayoutInfo: DefaultDesktopLayoutInfo = JSON.parse(JSON.stringify(defaultDesktopLayoutInfo)) as DefaultDesktopLayoutInfo;
    if (itemRow * itemColumn < MID_CARD_AREA) {
      return true;
    }
    let row = deskTopLayoutInfo.layoutDescription.row;
    let column = deskTopLayoutInfo.layoutDescription.column;
    let leftRow: number = row % LARGE_CARD_COLUMN;
    let leftColumn: number = column % LARGE_CARD_COLUMN;
    let rowIntegerPart: number = Math.floor(row / LARGE_CARD_COLUMN);
    let columnIntegerPart: number = Math.floor(column / LARGE_CARD_COLUMN);
    let cardArea: number = LauncherLayoutCacheUtil.getLargeCardArea(deskTopLayoutInfo, page) + itemRow * itemColumn;

    if (leftRow === 0 && leftColumn === 0) {
      return true;
    }
    if ((leftRow === 0 && leftColumn === 2) || (leftRow === 2 && leftColumn === 0)) {
      return cardArea <= LARGE_CARD_AREA * columnIntegerPart * rowIntegerPart;
    }
    if (leftRow === 2 && leftColumn === 2) {
      return cardArea <= LARGE_CARD_AREA * columnIntegerPart * rowIntegerPart + MID_CARD_AREA * Math.min(columnIntegerPart, rowIntegerPart);
    } else {
      return true;
    }
  }


  /**
   * 校验pad横竖屏添加元素是否合理
   * @param page 当前添加页数
   * @param length 元素宽度
   * @param height 元素高度
   * @returns
   */
  public static checkIfElementsIsAddable(layoutInfoList: GridLayoutItemInfo[], page: number, item: GridLayoutItemInfo | CardItemInfo): boolean {
    let isAddableCurrent: boolean = LauncherLayoutCacheUtil.isAddable(layoutInfoList, item, page);
    if (!isAddableCurrent) {
      log.showWarn(`PadDevice isAddableCurrent: ${isAddableCurrent},page: ${page}`);
      return false;
    }
    let isAddableForRotate: boolean = LauncherLayoutCacheUtil.findLazyRotatePosition(layoutInfoList, item, page);
    if (!isAddableForRotate) {
      log.showWarn(`PadDevice isAddableForRotate: ${isAddableForRotate},page: ${page}`);
      return false;
    }
    log.showWarn(`PadDevice isAddable true,page: ${page}`);
    return true;
  }

  /**
   * 重排某页布局
   * @param gridLayoutList 缓存列表
   * @param page 页数
   * @param item 新增元素
   * @param isNeedAddItem 新增元素是否需要加入布局中进行重排
   */
  public static forceRotatePage(gridLayoutList: GridLayoutItemInfo[], page: number, item: GridLayoutItemInfo,
    isNeedAddItem: boolean = true): boolean {
    log.showWarn(`forceRotatePage page: ${page}`);
    let desktopLayoutInfo: DefaultDesktopLayoutInfo = LauncherLayoutCacheUtil.isPadPortrait ?
      LauncherLayoutCacheUtil.portraitDesktopLayoutInfo : LauncherLayoutCacheUtil.landscapeDesktopLayoutInfo;
    if (CheckEmptyUtils.isEmptyArr(desktopLayoutInfo.layoutInfo) || CheckEmptyUtils.isEmptyArr(gridLayoutList)) {
      log.showWarn('layoutInfo length is empty!');
      return false;
    }
    let cacheLayoutInfo: DefaultDesktopLayoutInfo = ObjectCopyUtil.deepClone(desktopLayoutInfo);
    let cacheItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(item);
    cacheItem.page = page;
    if (isNeedAddItem) {
      cacheLayoutInfo.layoutInfo.push(cacheItem);
    }
    LauncherLayoutCacheUtil.fillItemPosition(desktopLayoutInfo, gridLayoutList);
    let forceRotateLayoutInfo: DefaultDesktopLayoutInfo =
      LauncherLayoutCacheUtil.getPadLazyRotateLayout(cacheLayoutInfo, !LauncherLayoutCacheUtil.isPadPortrait,
        [page], true);
    let changeItem: GridLayoutItemInfo[] = [];
    gridLayoutList.forEach(item => {
      if (item.page !== page) {
        return;
      }
      if (LauncherLayoutCacheUtil.isPadPortrait) {
        let updateItem: GridLayoutItemInfo | undefined = forceRotateLayoutInfo.layoutInfo.find(rotateItem => {
          return rotateItem.portraitRow === item.portraitRow && rotateItem.portraitColumn === item.portraitColumn &&
            rotateItem.portraitPage === item.portraitPage;
        });
        if (!updateItem) {
          log.showWarn(`forceRotatePage find updateItem Portrait: ${JSON.stringify(item)}`);
          return;
        }
        item.landscapeRow = updateItem.landscapeRow;
        item.landscapeColumn = updateItem.landscapeColumn;
        item.landscapePage = updateItem.landscapePage;
      } else {
        let updateItem: GridLayoutItemInfo | undefined = forceRotateLayoutInfo.layoutInfo.find(rotateItem => {
          return rotateItem.landscapeRow === item.landscapeRow && rotateItem.landscapeColumn === item.landscapeColumn &&
            rotateItem.landscapePage === item.landscapePage;
        });
        if (!updateItem) {
          log.showWarn(`forceRotatePage find updateItem land: ${JSON.stringify(item)}`);
          return;
        }
        item.portraitRow = updateItem.portraitRow;
        item.portraitColumn = updateItem.portraitColumn;
        item.portraitPage = updateItem.portraitPage;
      }
      changeItem.push(ObjectCopyUtil.deepClone(item));
    });
    changeItem.forEach(item => {
      item.row = item.landscapeRow;
      item.column = item.landscapeColumn;
      item.page = item.landscapePage;
    })
    LauncherLayoutCacheUtil.updateRotatePositionToDB(changeItem);
    return true;
  }

  private static fillItemPosition(desktopLayoutInfo: DefaultDesktopLayoutInfo, gridLayoutList: GridLayoutItemInfo[]): void {
    desktopLayoutInfo.layoutInfo.forEach(item => {
      if (LauncherLayoutCacheUtil.isPadPortrait) {
        item.portraitRow = item.row;
        item.portraitColumn = item.column;
        item.portraitPage = item.page;
      } else {
        item.landscapeRow = item.row;
        item.landscapeColumn = item.column;
        item.landscapePage = item.page;
      }
    })
    gridLayoutList.forEach(item => {
      if (LauncherLayoutCacheUtil.isPadPortrait) {
        item.portraitRow = item.row;
        item.portraitColumn = item.column;
      } else {
        item.landscapeRow = item.row;
        item.landscapeColumn = item.column;
        item.landscapePage = item.page;
      }
    })
  }
  /**
   * 检查LazyRotate时，另一屏是否有空白位置
   */
  private static isLazyRotatePositionValid(gridList: GridLayoutItemInfo[], column: number, row: number,
    item : GridLayoutItemInfo | CardItemInfo, page: number, startColumn: number, startRow: number): boolean {
    if (!item || !item.area || CheckEmptyUtils.isEmptyArr(item.area)) {
      log.showWarn('isPositionValid error as the item is null');
      return false;
    }
    if ((startColumn + item.area[0]) > column || (startRow + item.area[1]) > row) {
      return false;
    }
    let isValid: boolean = true;
    for (let x = startColumn; x < startColumn + item.area[0]; x++) {
      for (let y = startRow; y < startRow + item.area[1]; y++) {
        if (LauncherLayoutCacheUtil.isLazyRotatePositionOccupied(gridList, page, x, y)) {
          isValid = false;
          break;
        }
      }
    }
    return isValid;
  }

  /**
   * 判断另一屏位置是否合理
   */
  private static isLazyRotatePositionOccupied(gridList: GridLayoutItemInfo[], page: number, column: number, row: number): boolean {
    const isSuperFold = DeviceHelper.isSuperFoldMachine();
    for (const item of gridList) {
      if (!item.area) {
        continue;
      }
      if (LauncherLayoutCacheUtil.isPadPortrait) {
        if (LauncherLayoutCacheUtil.checkLandEmpty(item, page)) {
          continue;
        }
        const xMatch = (column >= item.landscapeColumn)
          && (column < item.landscapeColumn + (isSuperFold ? item.landscapeArea[0] : item.area[0]));
        const yMatch = (row >= item.landscapeRow)
          && (row < item.landscapeRow + (isSuperFold ? item.landscapeArea[1] : item.area[1]));
        if (xMatch && yMatch) {
          return true;
        }
      } else {
        if (LauncherLayoutCacheUtil.checkPortraitEmpty(item, page)) {
          continue;
        }
        const xMatch = (column >= item.portraitColumn)
          && (column < item.portraitColumn + (isSuperFold ? item.portraitArea[0] : item.area[0]));
        const yMatch = (row >= item.portraitRow)
          && (row < item.portraitRow + (isSuperFold ? item.portraitArea[1] : item.area[1]));
        if (xMatch && yMatch) {
          return true;
        }
      }
    }
    return false;
  }

  private static checkLandEmpty(item: GridLayoutItemInfo, page: number): boolean {
    if (item.landscapePage !== page || item.landscapeColumn === undefined || item.landscapeRow === undefined ||
      !item.landscapeArea) {
      return true;
    }
    return false;
  }

  private static checkPortraitEmpty(item: GridLayoutItemInfo, page: number) {
    if (item.portraitPage !== page || item.portraitColumn === undefined || item.portraitRow === undefined ||
      !item.portraitArea) {
      return true;
    }
    return false;
  }

  /**
   * 用当前位置信息，更新lazyRotate的竖屏缓存
   */
  public static changeCachePortrait(list: GridLayoutItemInfo[]): void {
    list.forEach(item => {
      item.portraitRow = item.row;
      item.portraitColumn = item.column;
      item.portraitPage = item.page;
      item.portraitArea = [item.area?.[0] ?? 0, item.area?.[1] ?? 0];
    })
  }

  private static changeCacheLandscape(list: GridLayoutItemInfo[]): void {
    list.forEach(item => {
      item.landscapeRow = item.row;
      item.landscapeColumn = item.column;
      item.landscapePage = item.page;
      item.landscapeArea = [item.area?.[0] ?? 0, item.area?.[1] ?? 0];
    })
  }

  /**
   * 开机时校验替换首次旋转标志位
   * 新值为true的场景读取旧值，旧值为false则替换新值
   */
  public static firstRotateTagCorrect(): void {
    try {
      let preferences: dataPreferences.Preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: TAG });
      let newFirstRotateTag = preferences.getSync(ROTATE_DEVICE_FIRST_ROTATE, true) as boolean;
      log.showInfo(`newFirstRotateTag from ROTATE_DEVICE_FIRST_ROTATE ${newFirstRotateTag}`);
      if (newFirstRotateTag) {
        let oldFirstRotateTag = preferences.getSync('isFirstRotate', true) as boolean;
        if (!oldFirstRotateTag) {
          log.showInfo(`oldFirstRotateTag:${oldFirstRotateTag} replace newFirstRotateTag`);
          LauncherLayoutCacheUtil.putIsFirstRotate(oldFirstRotateTag);
        }
      }
    } catch (error) {
      log.showError(`getIsFirstRotate error ${error?.message}`);
    }
  }

  public static getIsFirstRotate(): boolean {
    try {
      if (LauncherLayoutCacheUtil.isFirstRotate !== undefined) {
        log.showInfo(`getIsFirstRotate, value exist, return directly: ${LauncherLayoutCacheUtil.isFirstRotate}`);
        return LauncherLayoutCacheUtil.isFirstRotate;
      }
      let preferences: dataPreferences.Preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: TAG });
      LauncherLayoutCacheUtil.isFirstRotate = preferences.getSync(ROTATE_DEVICE_FIRST_ROTATE, true) as boolean;
      log.showInfo(`getIsFirstRotate ${LauncherLayoutCacheUtil.isFirstRotate}`);
      return LauncherLayoutCacheUtil.isFirstRotate;
    } catch (error) {
      log.showError(`getIsFirstRotate error ${error?.message}`);
    }
    return false;
  }

  /**
   * 修改是否首次旋转标记位
   * @param isFirstRotate 是否首次旋转
   * @returns 修改结果
   */
  public static async putIsFirstRotate(isFirstRotate: boolean): Promise<boolean> {
    try {
      if (LauncherLayoutCacheUtil.isFirstRotate === isFirstRotate) {
        log.showWarn('same value, no need to update');
        return true;
      }
      LauncherLayoutCacheUtil.isFirstRotate = isFirstRotate;
      let preferences: dataPreferences.Preferences =
        dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: TAG });
      preferences.putSync(ROTATE_DEVICE_FIRST_ROTATE, isFirstRotate);
      await preferences.flush();
      log.showInfo(`putIsFirstRotate ${isFirstRotate}`);
      return true;
    } catch (error) {
      log.showError(`putIsFirstRotate error ${error?.message}`);
      // 异常时回到默认赋值
      LauncherLayoutCacheUtil.isFirstRotate = true;
    }
    return false;
  }

  /**
   * 修改lazyRotate相关设置，横屏时修改布局需要设置为非首次旋转状态
   */
  public static changeLazyRotateSettings(curItems: GridLayoutItemInfo[]): void {
    log.showInfo(`changeLazyRotateSettings: ${curItems?.length}`);
    if (DeviceHelper.isSuperFoldMachine()
      && LauncherLayoutCacheUtil.isLazyRotate && LauncherLayoutCacheUtil.isDefaultPortrait !==
      LauncherLayoutCacheUtil.isPadPortrait && LauncherLayoutCacheUtil.getIsFirstRotate()) {
      LauncherLayoutCacheUtil.putIsFirstRotate(false).then((ret: boolean) => {
        log.showInfo(`updateFirstRotate: ${ret}`);
        if (ret && curItems) {
          const itemsForDb: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getLazyRotateChangeItems(curItems);
          RdbStoreManager.getInstance().updateInfoPosition(itemsForDb, 'changeLazyRotateSettings');
        }
      });
    }
  }

  private static updateRotatePositionOperation(gridLayoutItemList: GridLayoutItemInfo[],
    updateItem: GridLayoutItemInfo): GridLayoutItemInfo[] {
    log.showWarn(`updateItem:${JSON.stringify(updateItem)}`);
    let gridLayoutItemListFilterUpdateItem: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => {
      return !(updateItem.bundleName === item.bundleName && updateItem.typeId === item.typeId &&
        updateItem.infoId === item.infoId && updateItem.cardId === item.cardId);
    });
    if (!LauncherLayoutCacheUtil.findLazyRotatePosition(gridLayoutItemListFilterUpdateItem, updateItem)) {
      log.showWarn('updateRotatePosition is not addable!');
      return [];
    }
    const newItems: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache([updateItem]);
    if (CheckEmptyUtils.isEmptyArr(newItems)) {
      log.showError('updateRotatePosition newItems is empty after getLazyRotateChange!');
      return [];
    }
    return newItems;
  }

  /**
   * 文件夹更新接口是否需要在对应旋转屏找位，如果当前屏文件夹的位置没变则不需要重新找位
   * @param gridLayoutItemList 布局列表
   * @param folderItem 文件夹缓存信息
   * @returns 是否需要找位 true: 需要   false: 不需要
   */
  public static checkIfNeedFindRotatePosition(gridLayoutItemList: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): boolean {
    let checkItem: GridLayoutItemInfo = gridLayoutItemList.find(item => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showWarn('gridLayoutItemList item is empty!');
        return false;
      }
      return item.typeId === CommonConstants.TYPE_FOLDER && item.folderId === folderItem.folderId;
    });
    let ifNeedFindRotatePosition: boolean = !CheckEmptyUtils.isEmpty(checkItem) && checkItem.page === folderItem.page &&
      checkItem.row === folderItem.row && checkItem.column === folderItem.column;
    log.showWarn(`ifNeedFindRotatePosition: ${ifNeedFindRotatePosition}`);
    return ifNeedFindRotatePosition;
  }

  /**
   * 从数据库删除元素
   * @param deleteItem 待删除元素
   */
  public static deleteItemInRdb(deleteItem: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(deleteItem)) {
      log.showWarn('deleteItemInRdb item is empty!');
      return;
    }
    try {
      if (deleteItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        LauncherLayoutCacheUtil.deleteShortcutItemCallBack([deleteItem])
      } else {
        RdbStoreManager.getInstance().deleteInfoByBundle(deleteItem.bundleName, undefined, deleteItem.appIndex);
      }
    } catch (error) {
      log.showError(`deleteItemInRdb error, error code:${error?.code}: ${error?.message}`);
    }
  }

  /**
   * 根据卡片id更新卡片信息
   * @param cardItemInfo 卡片信息
   * @returns 是否更新成功 true: 成功   false: 失败
   */
  public static async updateFormInfoById(cardItemInfo: CardItemInfo): Promise<boolean> {
    return await RdbStoreManager.getInstance().updateFormInfoById(cardItemInfo);
  }

  /**
   * 更新卡片信息
   * @param relationCards 关联卡片信息
   * @param layoutInfo 布局信息
   * @param stackLayoutInfo 堆叠信息
   */
  public static updateCardLayoutInfo(relationCards: CardItemInfo[], layoutInfo: GridLayoutItemInfo,
    stackLayoutInfo?: GridLayoutItemInfo): void {
    let cardItem: CardItemInfo | undefined = relationCards.find((item) => {
      return item.cardId === layoutInfo.cardId;
    });
    if (!cardItem) {
      return;
    }
    layoutInfo.bundleName = cardItem.bundleName;
    layoutInfo.moduleName = cardItem.moduleName;
    layoutInfo.abilityName = cardItem.abilityName;
    layoutInfo.cardName = cardItem.cardName;
    layoutInfo.appName = cardItem.appName;
    layoutInfo.cardId = cardItem.thirdAppRelationCardId;
    layoutInfo.infoId = cardItem.thirdAppRelationCardId;
    if (stackLayoutInfo) {
      stackLayoutInfo.formRefreshDate = String(Date());
    } else {
      layoutInfo.formRefreshDate = String(Date());
    }
  }

  /**
   * 根据entityId查询全搜定位信息
   * @param entityId 数据库主键ID
   * @returns gridLayoutItemInfo
   */
  public static async queryLocationInfoById(entityId: string): Promise<GridLayoutItemInfo | null> {
    let gridLayoutItemInfo: GridLayoutItemInfo | null =
      await RdbStoreManager.getInstance().queryLocationInfoById(entityId);
    return gridLayoutItemInfo;
  }

  /**
   * 根据bundleName查询布局信息
   * @param bundleName 包名
   * @returns 根据包名查询到的布局信息集合
   */
  public static async queryGridLayoutItemsByBundleName(bundleName: string): Promise<GridLayoutItemInfo[]> {
    return await RdbStoreManager.getInstance().queryGridLayoutItemsByBundleName(bundleName);
  }
}

export interface BaseGrid {
  gridColumn: number,
  gridRow: number
}

export interface BasePosition {
  i: number,
  j: number
}