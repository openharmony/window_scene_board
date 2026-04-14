/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import { HashMap, util } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import {
  AppToHapMappingManager,
  FolderLayoutCacheManager,
  FolderManager,
  FolderModel,
  FoldersData,
  GridLayoutUtil,
  launcherAbilityManager,
  LauncherLayoutCacheUtil,
  LaunchLayoutCacheManager,
  LayoutDescription,
  ResidentLayoutCacheMgr,
  SceneMsgEnum
} from '@ohos/launchercommon';
import { AppStatus } from '@ohos/launchercommon';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import {
  AppItemInfo,
  DockItemInfo,
} from '@ohos/launchercommon';
import {
  LogDomain,
  Logger,
  CheckEmptyUtils,
  PixelMapUtil, CommonUtils
} from '@ohos/basicutils';
import {
  ResourceManager,
  GlobalContext,
  EvtBus,
  ContextModifyUtils
} from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { RdbStoreManager, NotHarmonyUtil } from '@ohos/launchercommon';
import {
  CommonConstants,
  CardItemInfo,
  StyleConstants,
  BadgeManager,
  AppModel,
  LayoutViewModel
} from '@ohos/launchercommon';
import { BusinessType, DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import type ctx from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';
import type { PageDesktopViewModel } from './PageDesktopViewModel';
import {
  CommonEvent,
  RgmStatusChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import common from '@ohos.app.ability.common';
import { Context, contextConstant } from '@kit.AbilityKit';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { ItemLocation } from '@ohos/launchercommon/Index';

const TAG = 'PageDeskTopViewModelUtils';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class PageDesktopViewModelUtils {
  private pageDesktopViewModel: PageDesktopViewModel;
  private preferences: preferences.Preferences | null = null;
  private preferencesFileName: string = 'rgmDefaultSortFile';
  private notHarmonyFolderName: string = '${not_harmony_apps}';

  constructor(viewModel: PageDesktopViewModel) {
    this.pageDesktopViewModel = viewModel;
  }

  appendFolderData(folderInfoList: GridLayoutItemInfo[], bundleInfoList: GridLayoutItemInfo[]): void {
    for (let i = 0; i < folderInfoList.length; i++) {
      let mLayoutInfo = folderInfoList[i].layoutInfo;
      if (!mLayoutInfo) {
        return;
      }
      for (let j = 0; j < mLayoutInfo.length; j++) {
        for (let k = 0; k < mLayoutInfo[j].length; k++) {
          const appIndex = bundleInfoList.findIndex(item => {
            return item.keyName === folderInfoList[i].layoutInfo?.[j][k].keyName;
          });
          if (appIndex !== CommonConstants.INVALID_VALUE) {
            bundleInfoList.splice(appIndex, 1);
          }
        }
      }
    }
  }

  updateFormId(formInfo: CardItemInfo | GridLayoutItemInfo, bundleInfoList: AppItemInfo[]): void {
    let appinfo: AppItemInfo[] = bundleInfoList.filter(item => {
      return item.bundleName === formInfo.bundleName;
    });
    if (!CheckEmptyUtils.isEmptyArr(appinfo)) {
      formInfo.appLabelId = appinfo[0].appLabelId;
    }
  }

  appendFormStackData(formStackInfoList: GridLayoutItemInfo[], bundleInfoList: GridLayoutItemInfo[]): void {
    for (let i = 0; i < formStackInfoList.length; i++) {
      let mLayoutInfo = formStackInfoList[i].layoutInfo;
      if (!mLayoutInfo || CheckEmptyUtils.isEmptyArr(mLayoutInfo)) {
        log.showWarn(TAG, 'the formStackInfoList is empty');
        return;
      }
      for (let j = 0; j < mLayoutInfo[0].length; j++) {
        const formIndex = bundleInfoList.findIndex(item => {
          return item.typeId === CommonConstants.TYPE_CARD &&
            item.container === formStackInfoList[i].layoutInfo?.[0][j].container &&
            item.cardId === formStackInfoList[i].layoutInfo?.[0][j].cardId;
        });
        if (formIndex !== CommonConstants.INVALID_VALUE) {
          mLayoutInfo[0][j] = bundleInfoList[formIndex];
          bundleInfoList.splice(formIndex, 1);
        }
      }
    }
  }

  ifColumnOrRowAreBigger(layoutInfo: GridLayoutItemInfo[], row: number, column: number): boolean {
    for (let i = 0; i < layoutInfo.length; i++) {
      let mColumn = layoutInfo[i].column;
      let mRow = layoutInfo[i].row;
      if (mColumn === undefined || mRow === undefined) {
        return false;
      }
      //column or row are bigger than legal num
      if ((mColumn >= column || mRow >= row) && layoutInfo[i].page !== CommonConstants.WATERFALL_PAGE_INDEX) {
        log.showError(TAG, 'layout has invalid column or row. maxColumn:%{public}d, maxRow:%{public}d. ' +
          'layout info is {page:%{public}d, column:%{public}d, row:%{public}d, width:%{public}d, height:%{public}d, ' +
          'typeId:%{public}d, bundleName:%{public}s, cardId:%{public}s, folderId:%{public}s, formStackId:%{public}s}',
          column, row, layoutInfo[i].page, layoutInfo[i].column, layoutInfo[i].row, layoutInfo[i].area?.[0],
          layoutInfo[i].area?.[1], layoutInfo[i].typeId, layoutInfo[i].bundleName, layoutInfo[i].cardId,
          layoutInfo[i].folderId, layoutInfo[i].formStackId);
        return true;
      }
    }
    return false;
  }

  getNeighborPage(page: number): number {
    if (page % StyleConstants.DEFAULT_2 === 0) {
      return page + StyleConstants.DEFAULT_1;
    } else {
      return page - StyleConstants.DEFAULT_1;
    }
  }

  /**
   * create new cardItemInfo by formItemInfo
   *
   * @param formCardItem
   */
  createNewCardItemInfo(formCardItem: CardItemInfo): CardItemInfo {
    const cardItemInfo = new CardItemInfo();
    cardItemInfo.cardId = formCardItem.cardId;
    cardItemInfo.cardName = formCardItem.name ?? '';
    cardItemInfo.appName = formCardItem.appName;
    cardItemInfo.bundleName = formCardItem.bundleName;
    cardItemInfo.abilityName = formCardItem.abilityName;
    cardItemInfo.moduleName = formCardItem.moduleName;
    cardItemInfo.formConfigAbility = formCardItem.formConfigAbility;
    cardItemInfo.appLabelId = formCardItem.appLabelId;
    cardItemInfo.cardDimension = formCardItem.dimension;
    cardItemInfo.isTransparent = formCardItem.isTransparent !== undefined ? formCardItem.isTransparent : false;
    cardItemInfo.extend1 = formCardItem.extend1;
    cardItemInfo.gameCardInfo = formCardItem.gameCardInfo;
    cardItemInfo.intent = formCardItem.intent;
    cardItemInfo.targetFormData = formCardItem.targetFormData;
    cardItemInfo.shortcutInfo = formCardItem.shortcutInfo;
    cardItemInfo.isFormDimension1x4 = formCardItem.isFormDimension1x4;
    return cardItemInfo;
  }


  addNewInstalledInfo(totalAppInfoList: AppItemInfo[], pageDesktopInfoList: GridLayoutItemInfo[]): void {
    let pageMap: HashMap<string, GridLayoutItemInfo> = new HashMap<string, GridLayoutItemInfo>();
    for (const one of pageDesktopInfoList) {
      pageMap.set(one.keyName, one);
    }
    for (const appItem of totalAppInfoList) {
      if (CheckEmptyUtils.isEmpty(pageMap.get(appItem.keyName))) {
        appItem.appStatus = AppStatus.INSTALLED;
        pageDesktopInfoList.push(appItem as GridLayoutItemInfo);
      }
    }
  }

  addOutNewInstalledInfo(outerLayoutInfoList: GridLayoutItemInfo[], pageDesktopInfo: GridLayoutItemInfo[]): void {
    for (const appInfo of outerLayoutInfoList) {
      let hasInstalled = false;
      for (const item of pageDesktopInfo) {
        let itemKeyName = item.bundleName + item.abilityName + item.moduleName;
        let curKeyName = appInfo.bundleName + appInfo.abilityName + appInfo.moduleName;
        if (curKeyName === itemKeyName || appInfo.appStatus !== AppStatus.INSTALLED ||
          appInfo.typeId === CommonConstants.TYPE_CARD || appInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
          hasInstalled = true;
          break;
        }
      };
      if (!hasInstalled) {
        pageDesktopInfo.push(appInfo);
      }
    }
  }

  initOuterInstalledInfo(totalAppInfoList: AppItemInfo[], pageDesktopInfo: GridLayoutItemInfo[],
    outerLayoutInfoList: GridLayoutItemInfo[]): void {
    // pageDesktopInfo为空按照配置的json文件初始化
    if (pageDesktopInfo === undefined || pageDesktopInfo.length !== 0) {
      return;
    }
    for (const appInfo of totalAppInfoList) {
      outerLayoutInfoList.forEach(item => {
        let itemKeyName = item.bundleName + item.abilityName + item.moduleName;
        let curKeyName = appInfo.bundleName + appInfo.abilityName + appInfo.moduleName;
        if (curKeyName === itemKeyName) {
          pageDesktopInfo.push(appInfo as GridLayoutItemInfo);
        }
      });
    }
  }

  async getFolderAppBadgeNumber(folderInfoList: GridLayoutItemInfo[]): Promise<void> {
    for (let i = 0; i < folderInfoList.length; i++) {
      let mLayoutInfo = folderInfoList[i].layoutInfo;
      if (!mLayoutInfo) {
        return;
      }
      for (let j = 0; j < mLayoutInfo.length; j++) {
        for (let k = 0; k < mLayoutInfo[j].length; k++) {
          let badgeNumber = await BadgeManager.getInstance().getBadgeDisplayNumberByBundleSync(mLayoutInfo[j][k])
          mLayoutInfo[j][k].badgeNumber = badgeNumber;
        }
      }
    }
  }

  /**
   *
   * @param item  AppItemInfo
   * @param page  构建appItem到那一页
   * @param col   位置列col(positionX)
   * @param row   位置行row(positionY)
   * @deprecated 后期请使用GridLayoutUtil.buildGridLayoutInfoFromItemInfo
   * @returns GridLayoutItemInfo 数据网格对象,不包含container，默认为桌面的对象
   */
  public buildGridLayoutInfoFromItemInfo(item: AppItemInfo | GridLayoutItemInfo, page: number, col: number,
    row: number): GridLayoutItemInfo {
    return GridLayoutUtil.buildGridLayoutInfoFromItemInfo(item, page, col, row);
  }

  /**
   *
   * @param item  AppItemInfo
   * @param page  构建appItem到那一页
   * @param col   位置列col(positionX)
   * @param row   位置行row(positionY)
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
   * 容器内应用临时方案，把新安装的容器app放在应用文件夹内
   * @param appItem 新安装应用的信息
   * @param isDeliverApp false未OpenHarmony化应用
   */
  public dealWithContainerApp(appItemInfo: AppItemInfo, isDeliverApp: boolean = true): void {
    let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let bundleName: string = appItemInfo.bundleName;
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (this.checkInLayout(residentList, bundleName)) {
      log.showInfo(TAG, 'container app check in dock = %{public}s', appItemInfo.bundleName);
      return;
    }
    // 容器数组，数组0是容器文件夹的index，数组1是容器应用的index
    let containerIndex: number[] = [-1, -1];
    let isSelectSuccess: boolean = this.selectContainerAppIndexInLayout(appItemInfo.bundleName, containerIndex,
      appItemInfo.installSource, isDeliverApp, appItemInfo.appIndex);
    if (isSelectSuccess === false) {
      log.showInfo(TAG, 'add container app to folder return, isSelectSuccess is false');
      return;
    }
    let containerFolderIndex = containerIndex[0];
    appItemInfo.area = [1, 1];
    appItemInfo.typeId = CommonConstants.TYPE_APP;
    let folderIndexInDock = CommonConstants.INVALID_VALUE;
    try {
      log.showWarn(TAG, 'container folderIndexInDock = %{public}d, folderIndex = %{public}d, bundleName = %{public}s',
        folderIndexInDock, containerFolderIndex, bundleName);
      if (containerFolderIndex !== CommonConstants.INVALID_VALUE) {
        this.addInfoToDeskTopFolder(layoutCacheManager, containerFolderIndex, bundleName, appItemInfo, isDeliverApp);
      } else if (folderIndexInDock !== CommonConstants.INVALID_VALUE) {
        this.addInfoToDockFolder(residentList, folderIndexInDock, appItemInfo);
      } else {
        this.makeContainerFolderToDesktop(appItemInfo, isDeliverApp);
      }
    } catch (err) {
      log.showError(TAG, 'add container app to folder error : %{public}s', err?.message);
    }
  }

  /**
   * 根据bundleName查询app所在缓存列表的index--用于容器应用
   *
   * @param bundleName 应用的bundleName
   * @param containerIndex 记录查找的index值
   * @param installSource 安装应用的来源
   * @param isDeliverApp false未OpenHarmony化应用
   * @returns true表示查询成功，false表示查询失败
   */
  public selectContainerAppIndexInLayout(bundleName: string, containerIndex: number[], installSource?: string,
    isDeliverApp: boolean = true, appIndex: number = 0): boolean {
    let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList(TAG, false);
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_FOLDER) {
        let mLayoutInfo = gridLayoutItemList[i].layoutInfo;
        let folderIndex = mLayoutInfo?.flat().findIndex(item => item.bundleName === bundleName &&
          item.appIndex === appIndex) ?? CommonConstants.INVALID_VALUE;
        if (mLayoutInfo && folderIndex !== CommonConstants.INVALID_VALUE) {
          log.showInfo(TAG, 'container app check in folder = %{public}s', bundleName);
          let folderOpenColumn: number = FolderModel.getInstance().getFolderOpenLayout().column;
          let folderOpenRow: number = FolderModel.getInstance().getFolderOpenLayout().row;
          let size: number = folderOpenColumn * folderOpenRow;
          let page: number = Math.floor(folderIndex / size);
          let appIndex: number = folderIndex % size;
          return false;
        }
      } else if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_APP) {
        if (gridLayoutItemList[i].bundleName === bundleName && gridLayoutItemList[i].appIndex === appIndex) {
          log.showInfo(TAG, 'container app check in desktop = %{public}s', bundleName);
          return false;
        }
      }
    }
    return true;
  }

  /**
   * 统计桌面应用数量（大小文件件除外），如果超过200个，就故障上报
   *
   * @param appListInfo 桌面的布局信息
   * @returns void
   */
  public itemNumMoreReport (appListInfo: GridLayoutItemInfo[]): void {
    let folderNum: number = 0;
    appListInfo.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        folderNum++;
      }
    });
    // 图标数量（大小文件夹除外）
    let itemNum: number = appListInfo.length - folderNum;
    log.showInfo(TAG, 'appListInfo exclude folder lenth: %{public}d', itemNum);
    if (itemNum > CommonConstants.ITEM_MAX_NUM) {
      // 桌面应用数量超过200个（文件夹除外） 故障上报
      HiDfxEventUtil.reportItemIsMore(itemNum);
    }
  }

  private addInfoToDeskTopFolder(layoutCacheManager: LaunchLayoutCacheManager, containerFolderIndex: number,
    bundleName: string, appItemInfo: AppItemInfo, isDeliverApp: boolean = true): void {
    let deliverAppShowOuter: boolean | undefined = isDeliverApp ? false : undefined;
    const folderInfo: GridLayoutItemInfo | undefined =
      layoutCacheManager.selectGridLayoutItemByIndex(containerFolderIndex, false);
    if (!folderInfo) {
      return;
    }
    this.addInfoToFolder(folderInfo, appItemInfo);
    const folderMgr = FolderManager.getInstance();
    if (!folderMgr.isFolderOpen()) {
      const layoutInfo: GridLayoutItemInfo[] = folderInfo.layoutInfo?.flat() ?? [];
      folderMgr.updateFolderLayoutWithDb('container app refresh', folderInfo.folderId, layoutInfo, false);
    }
  }

  /**
   * 更新文件夹应用位置
   *
   * @param layoutList 文件夹中应用列表
   */
  private updateFolderAppLocation(layoutList: GridLayoutItemInfo[]): void {
    let folderOpenColumn: number = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let folderOpenRow: number = FolderModel.getInstance().getFolderOpenLayout()?.row;
    for (let i = 0; i < layoutList.length; i++) {
      layoutList[i].column = i % folderOpenColumn;
      layoutList[i].row = Math.floor(i / folderOpenColumn % folderOpenRow);
      layoutList[i].page = Math.floor(i / (folderOpenColumn * folderOpenRow));
    }
  }

  private sortDeliverFolderApp(layoutInfo: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let newArr: GridLayoutItemInfo[] = [];
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      return newArr;
    }
    layoutInfo.forEach((item) => {
      newArr.push(item);
    });
    return newArr.filter(item => item.bundleName !== '');
  }

  private makeContainerFolderToDesktop(appItemInfo: AppItemInfo, isDeliverApp: boolean = true): void {
    // 优先在桌面上新增2x2的文件夹，空间不够就尝试1x1，再不够就弹toast提示
    let deliverAppShowOuter: boolean | undefined = isDeliverApp ? false : undefined;
    let containerFolder: GridLayoutItemInfo = this.makeFolder(appItemInfo, isDeliverApp);
    const layoutDescription: LayoutDescription =
      LaunchLayoutCacheManager.getInstance().selectLayoutDescription(deliverAppShowOuter);
    if (this.pageDesktopViewModel.updateElementLocation(layoutDescription, containerFolder, isDeliverApp)) {
      log.showInfo(TAG, `add containerFolder 2x2 to desktop`);
      return;
    }
    containerFolder.area = [1, 1];
    if (this.pageDesktopViewModel.updateElementLocation(layoutDescription, containerFolder, isDeliverApp)) {
      log.showInfo(TAG, `add containerFolder 1x1 to desktop`);
      return;
    }
    this.pageDesktopViewModel.showNoSpaceToast();
    log.showInfo(TAG, `not space to add containerFolder 1x1 to desktop`);
  }

  private checkInLayout(infoList: DockItemInfo[] | GridLayoutItemInfo[], bundleName: string): boolean {
    let appIndex: number = infoList.findIndex((item: DockItemInfo | GridLayoutItemInfo) => {
      if (item.itemType === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_APP) {

        return item.bundleName === bundleName;
      }
      if (item.itemType === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_FOLDER) {
        return item.layoutInfo?.flat().findIndex((item: DockItemInfo | GridLayoutItemInfo) =>
        item.bundleName === bundleName) !== CommonConstants.INVALID_VALUE;
      }
      return false;
    });
    log.showInfo(TAG, 'checkInLayout::appInDockIndex: %{public}d', appIndex);
    return appIndex !== CommonConstants.INVALID_VALUE;
  }

  private makeFolder(appItemInfo: AppItemInfo, isDeliverApp: boolean = true): GridLayoutItemInfo {
    // make folder used info position
    let gridLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    gridLayoutInfo.typeId = CommonConstants.TYPE_FOLDER;
    gridLayoutInfo.folderId = new Date().getTime().toString();
    gridLayoutInfo.bundleName = gridLayoutInfo.folderId;
    gridLayoutInfo.keyName = gridLayoutInfo.folderId;
    gridLayoutInfo.appStatus = AppStatus.INSTALLED;
    gridLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
    gridLayoutInfo.intent = appItemInfo.intent;
    if (!isDeliverApp) {
      gridLayoutInfo.folderName = this.notHarmonyFolderName;
      let intentMap = new Map<string, string>();
      intentMap.set(NotHarmonyUtil.NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT, gridLayoutInfo.folderId);
      gridLayoutInfo.intent = CommonUtils.mapToJonStr(intentMap);
      NotHarmonyUtil.setNotHarmonyFolderId(gridLayoutInfo.folderId);
    }
    // update info position
    gridLayoutInfo.area = [2, 2];
    appItemInfo.page = 0;
    appItemInfo.column = 0;
    appItemInfo.row = 0;
    let gridlayoutItem1: GridLayoutItemInfo = this.buildGridLayoutInfoFromItemInfo(appItemInfo, 0, 0, 0);
    log.showInfo(TAG, 'makeFolder bundleName = %{public}s, page = %{public}d, row = %{public}d, col = %{public}d',
      gridlayoutItem1.bundleName, gridlayoutItem1.page, gridlayoutItem1.row, gridlayoutItem1.column);
    gridLayoutInfo.layoutInfo = [[gridlayoutItem1]];
    log.showInfo(TAG, 'make folder in desktop');
    return gridLayoutInfo;
  }

  private addInfoToFolder(folderItemInfo: GridLayoutItemInfo, newAppItem: AppItemInfo): void {
    if (CheckEmptyUtils.isEmpty(folderItemInfo) || folderItemInfo.typeId !== CommonConstants.TYPE_FOLDER) {
      log.showWarn(TAG, `add to folder failure as the item is not folder`);
      return;
    }
    log.showInfo(TAG, 'addInfoToFolder start');
    let gridlayoutItem: GridLayoutItemInfo | undefined = this.getGridLayoutItemInfo(folderItemInfo, newAppItem);
  }

  private addInfoToDockFolder(residentList: DockItemInfo[], insertIndex: number, newAppItem: AppItemInfo): void {
    log.showInfo(TAG, 'addInfoToDockFolder start');
    const changFolder: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(residentList[insertIndex]);
    let gridlayoutItem: GridLayoutItemInfo | undefined = this.getGridLayoutItemInfo(changFolder, newAppItem);
    if (!gridlayoutItem) {
      return;
    }
    RdbStoreManager.getInstance().insertGridLayoutInfoWithCheck(gridlayoutItem).then(() => {
      RdbStoreManager.getInstance().addInfoToDockFolder(changFolder.folderId, [gridlayoutItem]).then(() => {
        if (!gridlayoutItem) {
          return;
        }
        residentList[insertIndex].layoutInfo?.[gridlayoutItem.page ?? 0].push(gridlayoutItem);
        residentList.splice(insertIndex, 1, GridLayoutUtil.gridLayoutToDockItem(changFolder));
        LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_add2'), residentList);
        // 解决dock区文件夹打开态下载应用不实时刷新问题
        FolderManager.getInstance().updateFolderItems('addInfoToDockFolder', changFolder, [gridlayoutItem])
      });
    });
  }

  private getGridLayoutItemInfo(info: DockItemInfo | GridLayoutItemInfo, newAppItem: AppItemInfo):
    GridLayoutItemInfo | undefined {
    if (!info.layoutInfo) {
      return undefined;
    }
    let array = info.layoutInfo.flat();
    let length: number = array.length;
    let addIconIndex = array.flat().findIndex(item => item.typeId === CommonConstants.TYPE_ADD);
    if (addIconIndex !== CommonConstants.INVALID_VALUE) {
      log.showInfo(TAG, 'getGridLayoutInfo addIconIndex = ' + addIconIndex);
      length--;
    }
    const openFolderConfig = FolderModel.getInstance().getFolderOpenLayout();
    const folderPageCol = openFolderConfig.column;
    const folderPageRow = openFolderConfig.row;
    let page: number = Math.floor(length / (folderPageRow * folderPageCol));
    let gridlayoutItem: GridLayoutItemInfo = this.buildGridLayoutInfoFromItemInfo(newAppItem, page,
      length % folderPageCol, Math.floor((length - page * folderPageRow * folderPageCol) / folderPageCol));
    if (gridlayoutItem.page === undefined) {
      return undefined;
    }
    if (!info.layoutInfo[gridlayoutItem.page]) {
      info.layoutInfo[gridlayoutItem.page] = [];
    }
    log.showInfo(TAG, 'addInfoToFolder bundleName = %{public}s, page = %{public}d, row = %{public}d, col = %{public}d',
      gridlayoutItem.bundleName, gridlayoutItem.page, gridlayoutItem.row, gridlayoutItem.column);
    return gridlayoutItem;
  }

  updateAppInFolderByInstalledApps(): void {
    log.showInfo(TAG, 'updateAppInFolderByInstalledApps start');
    LaunchLayoutCacheManager.getInstance().updateAppStatusInFolderByInstalledApps((info: GridLayoutItemInfo) => {
      this.updateFolderLayoutInfo(info);
    });
  }

  public updateFolderLayoutInfo(folderItem: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(folderItem)) {
      log.showWarn(TAG, 'updateFolderLayoutInfo failure as the item is empty');
      return;
    }
    let isNeedUpdateFolder: boolean = false;
    let updateItems: GridLayoutItemInfo[] = [];
    folderItem.layoutInfo?.flat().forEach((item: GridLayoutItemInfo) => {
      let isMultiIcon = AppModel.getInstance().checkIsMultiIcon(item.bundleName, item.appIndex);
      let tmpInfo = AppModel.getInstance().getAppInfoByBundleInfo({
        bundleName: item.bundleName,
        appIndex: item.appIndex ?? 0
      });
      if (!tmpInfo) {
        log.showWarn(TAG, 'getAppInfoByBundleInfo is null ');
        return;
      }

      if (item.keyName === tmpInfo.keyName) {
        item.appName = tmpInfo.appName;
        item.appIconId = tmpInfo.appIconId;
        item.appLabelId = tmpInfo.appLabelId;
        item.isSystemApp = tmpInfo.isSystemApp;
        item.isUninstallAble = tmpInfo.isUninstallAble;
        isNeedUpdateFolder = true;
        updateItems.push(item);
      } else if (item.typeId === CommonConstants.TYPE_APP && item.bundleName === tmpInfo.bundleName &&
        item.appIndex === tmpInfo.appIndex && !isMultiIcon) {
        LauncherLayoutCacheUtil.updateFolderAppPackageInfo(item, tmpInfo);
        isNeedUpdateFolder = true;
        updateItems.push(item);
      }
    });
    if (isNeedUpdateFolder) {
      this.updateFolderInfo('update folder info', folderItem);
    }
  }

  private async updateFolderInfo(msg: string, folderItem: GridLayoutItemInfo): Promise<void> {
    let items: GridLayoutItemInfo[] = folderItem.layoutInfo?.flat() ?? [];
    if (!folderItem.id) {
      RdbStoreManager.getInstance().queryRecordByInfoId(folderItem.folderId).then(
        (rdbItem: GridLayoutItemInfo | undefined) => {
          if (!rdbItem) {
            return;
          }
          folderItem.id = rdbItem.id;
          items.forEach(item => item.container = rdbItem.id);
          FolderManager.getInstance().updateFolderItems(msg, folderItem, items);
      });
    } else {
      FolderManager.getInstance().updateFolderItems(msg, folderItem, items);
    }
  }

  /**
   * Base64 string to pixelMap.
   *
   * @param base64Str str
   * @returns pixelMap
   */
  async base64ToPixelMap(base64Str: string): Promise<image.PixelMap | null> {
    if (!base64Str) {
      log.showInfo(TAG, 'add app form to desktop fail, snapshot param is invalid.');
      return null;
    }
    const base64Helper: util.Base64Helper = new util.Base64Helper();
    // 解码前先去掉前缀
    const prefix: string = 'data:image/jpeg;base64,';
    if (base64Str.startsWith(prefix)) {
      base64Str = base64Str.substring(prefix.length);
    }
    try {
      const data = base64Helper.decodeSync(base64Str, util.Type.BASIC);
      const imageSource = image.createImageSource(data.buffer);
      let pixelMap: image.PixelMap = await imageSource.createPixelMap({ editable: true });
      PixelMapUtil.addName(pixelMap, `PageDesktop_base64`);
      imageSource.release();
      return pixelMap;
    } catch (err) {
      log.showError(TAG, `decode base64 failed message is error.`);
    }
    return null;
  }

  async getAlignStatus(): Promise<boolean> {
    return true;
    /*let result: boolean = false;
    let desktopContext = GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
    if (desktopContext === undefined) {
      return result;
    }
    let context = desktopContext.getApplicationContext();
    if (context === undefined) {
      return result;
    }

    let callback: Function = async (contextCallback: Context) => {
      try {
        await preferences.removePreferencesFromCache(contextCallback, 'DesktopSetting');
        await preferences.getPreferences(contextCallback, 'DesktopSetting').then((preference) => {
          result = preference.getSync('autoAlignStatus', false) as boolean;
        }).catch((error: Error) => {
          log.showError(TAG, 'setCanLoadFromSp error with message %{public}s', error.message);
          result = false;
        });
      } catch (error) {
        result = false;
        log.showError(TAG, 'getAlignStatus error %{public}s', error.message);
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(context, contextConstant.AreaMode.EL1, callback, `${TAG}-getAlignStatus`);
    log.showInfo(TAG, `alignstatus is ${result}`);
    return result;*/
  }

  /**
   * 根据删除的应用调整后面应用的位置，从而实现自动补位
   *
   * @param itemList 当前页与删除应用同大小的item列表（需要调整顺序的item）
   * @param uninstallAppItem 删除应用的item属性
   * @returns 返回包含item属性，及开始和结束位置信息的对象集合，用于挤位动效
   */
  sortAndChangeForAutoAlign(itemList: GridLayoutItemInfo[], uninstallAppItemArr: AppItemInfo[]): SqueezeGridLayout[] {
    if (CheckEmptyUtils.isEmptyArr(itemList) || CheckEmptyUtils.isEmpty(uninstallAppItemArr)) {
      log.showWarn(TAG, `sortAndChange failure as parameter is empty `);
      return [];
    }
    let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let layoutDes = launchLayoutCacheManager.selectLayoutDescription();
    let col: number = layoutDes.column;
    itemList.sort((itemA: GridLayoutItemInfo, itemB: GridLayoutItemInfo) => {
      return this.compareGridLayoutItemByLocation(itemA, itemB, col);
    });
    let alignItem: SqueezeGridLayout[] = this.autoAlignGridLayoutItem(itemList, uninstallAppItemArr);
    return alignItem;
  }

  private compareGridLayoutItemByLocation(itemA: GridLayoutItemInfo, itemB: GridLayoutItemInfo, col: number): number {
    if (!itemA || !itemB) {
      log.showWarn(TAG, 'compareGridLayout failure as  item is null');
      return 0;
    }
    let valueA: number = (itemA.row ?? 0) * col + (itemA.column ?? 0);
    let valueB: number = (itemB.row ?? 0) * col + (itemB.column ?? 0);
    return valueA - valueB;
  }

  private autoAlignGridLayoutItem(itemList: GridLayoutItemInfo[], unstallAppItem: AppItemInfo[]): SqueezeGridLayout[] {
    let originalLocation: number[][] = [];
    itemList.forEach((layoutItem) => originalLocation.push([layoutItem.row ?? 0, layoutItem.column ?? 0]));
    let autoAlignGridLayout: GridLayoutItemInfo[] = [];
    itemList.forEach((layoutItem) => {
      let findIt:boolean = false;
      for (let i = 0; i < unstallAppItem.length; i++) {
        if (layoutItem.keyName === unstallAppItem[i].keyName) {
          findIt = true;
          break;
        }
      }
      if (!findIt) {
        autoAlignGridLayout.push(layoutItem);
      }
    });
    let alignAndSqueezeItem: SqueezeGridLayout[] = [];
    autoAlignGridLayout.forEach((alignGridLayoutItem: GridLayoutItemInfo, alignGridLayoutIdex: number) => {
      let endRow: number = originalLocation[alignGridLayoutIdex][0];
      let endColumn: number = originalLocation[alignGridLayoutIdex][1];
      if (endRow !== alignGridLayoutItem.row || endColumn !== alignGridLayoutItem.column) {
        let startPosition: number[] = GridLayoutUtil.getIconCenterPosition(alignGridLayoutItem.row,
          alignGridLayoutItem.column, alignGridLayoutItem.area, alignGridLayoutItem.page);
        let endPosition: number[] = GridLayoutUtil.getIconCenterPosition(endRow, endColumn, alignGridLayoutItem.area,
          alignGridLayoutItem.page);
        alignGridLayoutItem.row = endRow;
        alignGridLayoutItem.column = endColumn;
        let keyName: string = GridLayoutUtil.generateUniqueKey(alignGridLayoutItem);
        alignAndSqueezeItem.push(new SqueezeGridLayout(keyName, alignGridLayoutItem, startPosition, endPosition));
      }
    });
    return alignAndSqueezeItem;
  }

  isBundleNameAppExistInDock(bundleName: string, appIndex?: number): boolean {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (CheckEmptyUtils.isEmptyArr(residentList)) {
      log.showInfo(TAG, 'isBundleNameAppExistInDock residentList is empty');
      return false;
    }
    let appInDockIndex: number = residentList.findIndex(item => {
      if (item.itemType === CommonConstants.TYPE_APP) {
        return item.bundleName === bundleName && item.appIndex === (appIndex ?? 0);
      }
      if (item.itemType === CommonConstants.TYPE_FOLDER) {
        return item.layoutInfo?.flat().findIndex(item => item.typeId === CommonConstants.TYPE_APP &&
          item.bundleName === bundleName && item.appIndex === (appIndex ?? 0)) !== CommonConstants.INVALID_VALUE;
      }
      return false;
    });
    log.showInfo(TAG, 'SmartDockViewModel::isBundleNameExistInDock: %{public}d', appInDockIndex);
    return appInDockIndex !== CommonConstants.INVALID_VALUE;
  }

  public async initDeliverStatusChange(): Promise<void> {
    // 读取sp文件
    let options: preferences.Options = { name: this.preferencesFileName };
    try {
      this.preferences = preferences.getPreferencesSync(GlobalContext.getInstance()
        .getObject('desktopContext') as common.ApplicationContext, options);
    } catch (e) {
      log.showError(TAG, 'preferences create error : %{public}s', e?.message);
    }
  }

  private handleRgmStatusChangeEvent(event: CommonEvent): void {
    log.showInfo(TAG, 'handleRgmStatusChangeEvent rgmStatus = %{public}s', event.parameters?.rgmStatus);
    switch (event.parameters?.rgmStatus) {
      case 'rgm_user_unlocked':
        log.showInfo(TAG, 'rgm_user_unlocked refresh deliver list');
        this.refreshDeliverAppList(SceneMsgEnum.SCENE_MSG_RGM_STATUS_CHANGE);
        AppToHapMappingManager.getInstance().queryCloudAppMappingAndPersist();
        break;
      // 背景：
      // 1、容器管理提供公共事件：rgm_remove，代表的含义为：容器进入卸载流程中，和容器相关的模块需要清理容器的缓存数据；
      // 2、大桌面在监听到rgm_remove后，完成大文件夹的销毁，PMS模块在进行升级的应用恢复，还未触发rgm_remove的清理流程，仍有部分应用安装，
      // 导致定制大文件夹再次出现；
      // 优化: 容器管理增加一个rgm_removed公共事件，代表的含义为：容器完成卸载流程，业务方根据具体场景完成清理缓存的动作；
      case 'rgm_remove':
      case 'rgm_removed':
        log.showInfo(TAG, 'rgm_remove delete sp cache');
        this.preferences?.flush();
        this.deleteContainerFolderList();
        break;
      default:
        break;
    }
  }

  /**
   * 停止状态下，dh恢厂需删除定制文件夹及其内应用
   *
   */
  deleteContainerFolderList(): void {
    let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      return;
    }
  }

  public async refreshDeliverAppList(sceneMsg?: string): Promise<void> {
    try {
      let appList: AppItemInfo[] = await AppModel.getInstance().getLauncherAbilityList();
      if (CheckEmptyUtils.isEmptyArr(appList)) {
        return;
      }
      let deliverAppList: AppItemInfo[] = [];
      for (let i = 0; i < appList.length; i++) {
        if (appList[i]?.codePath === String(NumberConstants.CONSTANT_NUMBER_ONE)) {
          deliverAppList.push(appList[i]);
        }
      }
      if (CheckEmptyUtils.isEmpty(deliverAppList)) {
        return;
      }
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList(TAG, false);
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      deliverAppList.forEach(launcherAppInfo => {
        // 查找缓存是否存在这个应用 不存在则新增应用
        let bmsApp: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(launcherAppInfo.bundleName);
        log.showInfo(TAG, 'refresh deliver app bundleName = %{public}s', launcherAppInfo.bundleName);
        let itemIndex: number = gridLayoutItemList
          .findIndex(item => item?.bundleName === launcherAppInfo.bundleName);
        if (itemIndex !== CommonConstants.INVALID_VALUE) {
          gridLayoutItemList[itemIndex].isUninstallAble = launcherAppInfo.isUninstallAble;
        }
        itemIndex = residentList.findIndex(item => launcherAppInfo.bundleName === item.bundleName);
        if (itemIndex !== CommonConstants.INVALID_VALUE) {
          residentList[itemIndex].isUninstallAble = launcherAppInfo.isUninstallAble;
        }
      });
      LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_refresh'), residentList);
      this.pageDesktopViewModel.lightPagingFiltering(true, sceneMsg);
    } catch (error) {
      log.showError(TAG, 'refreshDeliverAppList error : %{public}s', error?.message);
    }
  }

  getCardDimension(launchLayout: number, cardLayout: GridLayoutItemInfo): number {
    if (launchLayout === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      cardLayout.area = CommonConstants.SIMPLE_MODEL_CARD_SIZE;
      return CommonConstants.CARD_DIMENSION_2x4;
    }
    return CardItemInfo.getCardDimension(cardLayout.area);
  }

  /**
   * 直接插入空位，新机空白页后找位使用
   *
   * @param maxRow 最大行
   * @param maxCol 最大列
   * @param itemLocation 存在位置信息
   */
  public findBlankPositionWithoutVerify(maxRow: number, maxCol: number, itemLocation: ItemLocation): void {
    if (maxRow <= 0 || maxCol <= 0) {
      return;
    }
    // 更新当前位置
    itemLocation.findRow = itemLocation.curRow;
    itemLocation.findCol = itemLocation.curCol;
    itemLocation.findPage = itemLocation.curPage;

    // 更新到下一个位置
    this.hasNextItemLocationInOnePage(maxRow, maxCol, itemLocation);
  }

  private hasNextItemLocationInOnePage(maxRow: number, maxCol: number, itemLocation: ItemLocation): boolean {
    let nextCol: number = itemLocation.curCol + 1;
    itemLocation.curCol = (nextCol) % maxCol;
    itemLocation.curRow = (itemLocation.curRow) + Math.floor(nextCol / maxCol);
    let isNeedFindNextPage: boolean = itemLocation.curRow >= maxRow;
    if (isNeedFindNextPage) {
      itemLocation.curPage = itemLocation.curPage + 1;
      itemLocation.curRow = 0;
      itemLocation.curCol = 0;
    }
    return !isNeedFindNextPage;
  }

  /**
   * 当前页找空位
   *
   * @param maxRow 最大行
   * @param maxCol 最大列
   * @param maxPage 最大页
   * @param item 找位元素item
   * @param itemLocation 保存找位的位置信息
   * @returns true找位成功，否则找位失败
   */
  public findBlankPositionFromOnePage(maxRow: number, maxCol:number, maxPage: number, item: GridLayoutItemInfo,
    itemLocation: ItemLocation): boolean {
    if (maxRow <= 0 || maxCol <= 0) {
      return false;
    }
    do {
      if (LaunchLayoutCacheManager.getInstance().isPositionValid(item, itemLocation.curPage % maxPage,
        itemLocation.curCol, itemLocation.curRow)) {
        itemLocation.findCol = itemLocation.curCol;
        itemLocation.findRow = itemLocation.curRow;
        itemLocation.findPage = itemLocation.curPage;
        log.showInfo(TAG, `findBlankPosition page:${itemLocation.curPage % maxPage} x:${itemLocation.findCol} y:${itemLocation.findRow},
         keyName: ${item?.bundleName} result: true`);
        this.hasNextItemLocationInOnePage(maxRow, maxCol, itemLocation);
        return true;
      }
    } while (this.hasNextItemLocationInOnePage(maxRow, maxCol, itemLocation));
    log.showInfo(TAG, `findBlankPosition false and change next page:${itemLocation.curPage}, keyName: ${item.bundleName}`);
    return false;
  }

  /**
   * 创建一个找位的起始位置
   *
   * @param startPage 开始页
   * @param sRow 行
   * @param sCol 列
   * @returns 起始位置的对象
   */
  public static getStartFindItemLocation(startPage: number, sRow: number, sCol: number): ItemLocation {
    let itemLocation: ItemLocation = new ItemLocation();
    itemLocation.curPage = startPage;
    itemLocation.curRow = sRow;
    itemLocation.curCol = sCol;
    itemLocation.findPage = startPage;
    itemLocation.findRow = 0;
    itemLocation.findCol = 0;
    return itemLocation;
  }

  /**
   * 应用找位
   *
   * @param item 元素item
   * @param isSupportDeliver 是否支持应用
   * @returns true找位成功,false失败
   */
  public findPositionForContainerApp(item: AppItemInfo, isSupportDeliver: boolean, isRetailEnable?: boolean): boolean {
    if (item.typeId === CommonConstants.TYPE_APP && !Number.isNaN(Number(item?.codePath))) {
      // 是否门店版本，配合门店版本清理功能需求，恢厂后加载布局
      if (isSupportDeliver || isRetailEnable) {
        this.dealWithContainerApp(item);
        return true;
      }
    }
    return false;
  }
}

export class SqueezeGridLayout {
  public keyName: string;

  public updateItemsInfo: GridLayoutItemInfo;

  public startPosition: number[];

  public endPosition: number[];

  constructor(keyName: string, updateItemsInfo: GridLayoutItemInfo, startPosition: number[], endPosition: number[]) {
    this.keyName = keyName;
    this.updateItemsInfo = updateItemsInfo;
    this.startPosition = startPosition;
    this.endPosition = endPosition;
  }
}