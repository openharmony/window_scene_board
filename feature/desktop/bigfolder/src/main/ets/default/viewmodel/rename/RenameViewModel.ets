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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { WallpaperConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import {
  DeviceHelper,
  GlobalContext,
  TextColor,
  WallpaperColorManager
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { FoldersData } from '@ohos/launchercommon/src/main/ets/folder/next/common/model/data/FoldersData';
import { AppCategoryInfoManager } from '@ohos/launchercommon/src/main/ets/manager/AppCategoryInfoManager';
import {
  ColorUtil,
  CommonConstants,
  ComponentPosShadowCache,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  DockItemInfo,
  FolderManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  IContractedFolderRenameViewModel,
  OBSERVER_SWITCH,
  SettingsModel,
  StyleConstants,
  textShadowMgr
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppCategoryUtils } from '@ohos/launchercommon/src/main/ets/utils/AppCategoryUtils';
import ServiceExtensionContext from 'application/ServiceExtensionContext';

const TAG = 'RenameViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件夹命名业务处理
 */
export class RenameViewModel implements IContractedFolderRenameViewModel {
  private static instance: RenameViewModel;

  private mFolderLayoutVm = ContractedFolderLayoutViewModel.getInstance();

  private mDesktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  private mDataMgr: FolderManager = FolderManager.getInstance();

  private constructor() {
  }

  static getInstance(): RenameViewModel {
    if (!RenameViewModel.instance) {
      RenameViewModel.instance = new RenameViewModel();
      ContractedFolderViewModelManager.getInstance()
        .register(ContractedFolderViewModelType.RENAME, RenameViewModel.instance);
    }
    return RenameViewModel.instance;
  }

  /**
   * 查询长按预览图的位置参数
   *
   * @param item
   * @param indexInSwiper
   * @returns
   */
  public getShadowOption(folderId: string, indexInSwiper: number): ShadowOptions {
    let shadow : ShadowOptions = {
      radius: StyleConstants.APP_NAME_SHADOW_RADIUS,
      color: ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0),
      fill: true
    };
    let folderItem: GridLayoutItemInfo = this.mDataMgr.getFolder(folderId).getGridInfo();
    if (!folderItem) {
      log.showError(TAG, 'get shadowOption of folderName error as null item');
      return shadow;
    }

    let textColor: TextColor | undefined = WallpaperColorManager?.getInstance()?.mTextColor;
    if (textColor && WallpaperConstants.WALLPAPER_TYPE_NO_NEED_TXT_SHADOW.includes(textColor.mWallpaperType)) {
      return shadow;
    }
    let colStart: number = folderItem.column ?? 0;
    let key: string = this.getShadowCacheKey(colStart, GridLayoutUtil.calculateItemColEnd(folderItem),
      GridLayoutUtil.calculateItemRowEnd(folderItem), indexInSwiper);
    let cache = ComponentPosShadowCache.getInstance().getCache(key);
    if (cache !== CommonConstants.INVALID_VALUE.toString()) {
      shadow.color = cache;
    }
    return shadow;
  }

  private getShadowCacheKey(colStart: number, colEnd: number, rowEnd: number, indexInSwiper: number): string {
    if (colEnd < colStart || colStart < 0 || colEnd < 0) {
      log.showWarn(TAG, `getShadowCacheKey fail! colStart ${colStart} colEnd ${colEnd}`);
      return CommonConstants.INVALID_SHADOW_CACHE_KEY;
    }
    let colTrans: number = colStart * StyleConstants.DEFAULT_2 + (colEnd - colStart);
    let textShadowScreen: number = 0;
    if (DeviceHelper.isFoldExpanded()) {
      textShadowScreen = textShadowMgr.getTextShadowScreenType(false,
        (indexInSwiper % StyleConstants.DEFAULT_2 === 0));
    } else {
      textShadowScreen = textShadowMgr.getTextShadowScreenType(true, true);
    }
    return textShadowMgr.generateShadowKey(textShadowScreen, rowEnd, colTrans);
  }

  /**
   * 更新文件夹名字
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public updateFolderName(msg: string, folderId: string, folderName: string): void {
    log.showInfo(TAG, '%{public}s :update folderName for folder %{public}s', msg, folderId);
    this.mFolderLayoutVm.getDataOsrMgr(folderId).setFolderName(folderName);
    this.mDataMgr.updateFolderName(folderId, folderName);
  }

  /**
   * 点击重命名
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public clickRename(msg: string, folderId: string): void {
    log.showInfo(TAG, '%{public}s for folder %{public}s', msg, folderId);
    AppStorage.setOrCreate('overlayMode', CommonConstants.OVERLAY_TYPE_HIDE);
    this.mDesktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
    if (!this.mFolderLayoutVm.getViewOsrMgr(folderId).getStatus(OBSERVER_SWITCH.MENU_SHOW)) {
      ContractedFolderCommonViewModel.getInstance().openFolder('click menu folder rename', folderId, true);
    } else {
      ContractedFolderCommonViewModel.getInstance().pushFolderMenuDisAppearAnimation(() =>
        ContractedFolderCommonViewModel.getInstance().openFolder('click menu folder rename', folderId, true));
    }
  }

  /**
   * 生成文件夹名字
   *
   * @param msg 用于DFX的日志打印
   */
  public generateFolderName(msg: string, endLayoutInfo: GridLayoutItemInfo,
    dragItems: GridLayoutItemInfo[] | DockItemInfo[]): string {
    log.showInfo(TAG, 'generateFolderName start: %{public}s', msg);
    let folderName: string = '';
    try {
      folderName = this.generateIntelFolderName(endLayoutInfo, dragItems);
    } catch (err) {
      log.showInfo(TAG, 'generate folder name %{public}s', err.message);
    }

    if (!folderName || folderName === '') {
      folderName = this.generateNormalFolderName();
    }
    log.showInfo(TAG, `generateFolderName folderName:${folderName}`);
    return folderName;
  }

  /**
   * 智能命名时，产生带资源字串的文件夹名称(名称格式为:'#'+应用分类名称的CodeID，如分类名称为 工具，则结果为 '#app_category_tools')
   *
   * @param targetItem 目标元素
   * @param dragItems 拖拽元素
   * @returns 智能命名后的文件夹名称
   */
  private generateIntelFolderName(targetItem: GridLayoutItemInfo, dragItems: GridLayoutItemInfo[] | DockItemInfo[]):
    string {
    let appCatIdList: number[] = this.getAppCatIdInFolder(targetItem, dragItems);
    if (CheckEmptyUtils.isEmptyArr(appCatIdList) || appCatIdList.length > 2) {
      log.showWarn(TAG, 'generateIntelFolderName, appCatIdList is invalid');
      return '';
    }
    let instance = AppCategoryInfoManager.getInstance();
    let itemCatName1: string = instance.getAppCatName(appCatIdList[0]) as string;
    if (CheckEmptyUtils.checkStrIsEmpty(itemCatName1)) {
      log.showWarn(TAG, 'generateIntelFolderName, itemCatName1 is invalid');
      return '';
    }
    let folderName: string = '';
    if (appCatIdList.length === 1) {
      folderName = '#' + itemCatName1;
    } else {
      let itemCatName2 = instance.getAppCatName(appCatIdList[1]);
      if (CheckEmptyUtils.checkStrIsEmpty(itemCatName2)) {
        log.showWarn(TAG, 'generateIntelFolderName, itemCatName2 is invalid');
        return '';
      }
      folderName = '#' + itemCatName1 + '#' + itemCatName2;
    }
    log.showInfo(TAG, `generateIntelFolderName folderName: ${folderName}`);
    return folderName;
  }

  private generateNormalFolderName(): string {
    const folderList: FoldersData[] = this.mDataMgr.getFolders();
    const folderNamePrefix: string = '${new_folder_name}';
    let folderName = folderNamePrefix;
    let suffixNumberList: number[] = [];
    const isNumberRegExp = new RegExp('^[1-9][0-9]*$');
    folderList.forEach((element) => {
      const folderName: string = element.getGridInfo().folderName as string;
      const suffixNumber = this.getFolderNameSuffixNumber(folderName, folderNamePrefix, isNumberRegExp);
      if (!Number.isNaN(suffixNumber)) {
        suffixNumberList.push(suffixNumber);
      }
    });

    const residentList = SettingsModel.getInstance().getResidentList();
    residentList.forEach((dockItem) => {
      if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
        const suffixNumber = this.getFolderNameSuffixNumber(dockItem.appName, folderNamePrefix, isNumberRegExp);
        if (!Number.isNaN(suffixNumber)) {
          suffixNumberList.push(suffixNumber);
        }
      }
    });

    // 去重后排序
    const uniqueSuffixNumberList = Array.from(new Set(suffixNumberList));
    uniqueSuffixNumberList.sort((suffix1: number, suffix2: number) => {
      return suffix1 - suffix2;
    });

    let nameNumber = 1;
    for (let i = 0; i < uniqueSuffixNumberList.length; i++) {
      if (uniqueSuffixNumberList[i] !== nameNumber) {
        break;
      }
      nameNumber++;
    }
    folderName = folderNamePrefix + nameNumber;
    return folderName;
  }

  /**
   * 获取合成文件夹的应用的二级分类id（id个数小于等于2时，返回有效的id集合）
   *
   * @param targetItem 目标元素
   * @param dragItems 拖拽元素
   * @returns 应用二级分类id的集合
   */
  private getAppCatIdInFolder(targetItem: GridLayoutItemInfo, dragItems: GridLayoutItemInfo[] | DockItemInfo[]):
    number[] {
    let instance = AppCategoryInfoManager.getInstance();
    if (targetItem === undefined) {
      log.showInfo(TAG, 'get app category erro as null targetItem');
      return [];
    }
    let targetItemCatId = instance.readCatIdFromCache(targetItem.bundleName);
    let bundleNames = AppCategoryUtils.getBundleNameList(dragItems);
    let appCatIdList: number[] = [];
    if (targetItemCatId == null || !bundleNames || bundleNames.length === 0) {
      log.showWarn(TAG, 'getAppCatIdInFolder, targetItemCatId or bundleName is null');
      return appCatIdList;
    }
    let catIdSet: Set<number> = new Set();
    catIdSet.add(targetItemCatId);
    for (let bundleName of bundleNames) {
      let catId = instance.readCatIdFromCache(bundleName);
      if (catId == null) {
        log.showWarn(TAG, `bundleName = ${bundleName}, categoryId is null`);
        return appCatIdList;
      }
      catIdSet.add(catId);
      if (catIdSet.size > 2) {
        log.showInfo(TAG, 'the number of categoryId in folder exceeds 2');
        return appCatIdList;
      }
    }
    let dragItemsCatId: number = -1;
    if (catIdSet.size === 1) {
      dragItemsCatId = targetItemCatId;
      appCatIdList = [targetItemCatId];
    } else if (catIdSet.size === 2) {
      dragItemsCatId = Array.from(catIdSet)[1];
      appCatIdList = [targetItemCatId, dragItemsCatId];
    }
    log.showInfo(TAG, `getAppCatIdInFolder, targetItemCatId: ${targetItemCatId}, dragItemsCatId: ${dragItemsCatId}`);
    return appCatIdList;
  }

  private getFolderNameSuffixNumber(folderName: string, folderNamePrefix: string, isNumberRegExp: RegExp): number {
    if (!folderName) {
      return Number.NaN;
    }
    if (folderName.startsWith(folderNamePrefix) && isNumberRegExp.test(folderName.substring(folderNamePrefix.length))) {
      return Number(folderName.substring(folderNamePrefix.length));
    }
    return Number.NaN;
  }
}