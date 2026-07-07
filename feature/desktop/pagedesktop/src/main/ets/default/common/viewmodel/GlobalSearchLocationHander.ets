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
  AppStorageUtil,
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { EventType, scbEventExclusiveManager, launcherStatusUtil } from '@ohos/windowscene';
import { GlobalContext, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import {
  AppItemInfo,
  DockItemInfo,
  FolderDataModelManager,
  LauncherLayoutCacheUtil,
  FolderLayoutCacheManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  StyleConstants,
  CommonConstants,
  DockUtils,
  ResidentLayoutCacheMgr,
  FolderManager,
  ContractedFolderCommonViewModel,
  PageInfoManager
} from '@ohos/launchercommon';
import GlobalSearchLocationParam from './GlobalSearchLocationParam';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { DeviceState, SearchLocationType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { PageDesktopViewModel } from './PageDesktopViewModel';
import { systemDateTime } from '@kit.BasicServicesKit';
import { AppIconModel } from '@ohos/launchercommon/src/main/ets/launchericon/common/AppIconModel';

const TAG = 'GlobalSearchLocationHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class GlobalSearchLocationHandler extends SingleBase {
  public static singleName: string = 'GlobalSearchLocationHandler';
  private inPutBundleName: string = '';
  private inPutAbilityName: string = '';
  private inPutModuleName: string = '';
  private inPutTypeId: number = 0;
  private inPutKeyName: string = '';
  private gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
  private globalSearchAnimation: boolean = false;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private folderOpenFinishCallback: Function = (): void => {this.folderOpenFinish();};
  private pageJumpFinishCallback: Function = (): void => {this.pageJumpFinish();};
  private folderPageJumpFinishCallback: Function = (): void => {this.folderPageJumpFinish();};
  private mTimerId: number = 0;
  private appIconModel: AppIconModel = AppIconModel.getInstance();
  private startTime: number = 0;

  constructor(ctx?: SingleContext) {
    super(ctx);
    scbEventExclusiveManager.registerEventExclusive(EventType.GLOBALSEARCH_LOCATIONAPPSHOW, () => {
      let endTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
      log.showInfo(`globalSearchAnimation = ${this.globalSearchAnimation}`);
      if (this.mTimerId !== 0 && (endTime - this.startTime) > 10000 && this.globalSearchAnimation) {
        this.setGlobalSearchAnimation(false);
      }
    });

  }

  /**
   * 设置全搜动效状态
   *
   * @param isAnimating 动效状态
   */
  public setGlobalSearchAnimation(isAnimating: boolean): void {
    if (!isAnimating) {
      this.cancelTimer();
      AppStorage.setOrCreate('globalSearchLocationAppShow', false);
      log.showInfo(`finish flag  = ${AppStorage.get('globalSearchAnimation')} `);
      AppStorage.setOrCreate('globalSearchAnimation', false);
      scbEventExclusiveManager.setEventExclusive(EventType.GLOBALSEARCH_LOCATIONAPPSHOW, false);
      this.desktopContext?.eventHub.off(`globalSearchLocationFolderOpen`, this.folderOpenFinishCallback);
      this.desktopContext?.eventHub.off(`globalSearchLocationSwitchToPage`, this.pageJumpFinishCallback);
      this.desktopContext?.eventHub.off(`globalSearchLocationFolderSwitchToPage`, this.folderPageJumpFinishCallback);
    }
    this.globalSearchAnimation = isAnimating;
  }

  /**
   * 获取全搜动效状态
   *
   * @returns true表示动效进行中，false表示动效结束
   */
  public getGlobalSearchAnimation(): boolean {
    return this.globalSearchAnimation;
  }

  static getInstance(ctx?: SingleContext): GlobalSearchLocationHandler {
    return singleManager.get<GlobalSearchLocationHandler>(GlobalSearchLocationHandler, ctx);
  }

  /**
   * 获取全搜参数
   *
   * @returns GlobalSearchLocationParam，全搜参数
   */
  getGlobalSearchLocationParam(): GlobalSearchLocationParam {
    return this.gsParam;
  }

  private setProtectTimer(): void {
    this.cancelTimer();
    this.startTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    this.mTimerId = setTimeout(() => {
      log.showInfo(`globarSearchTimer trigger`);
      this.setGlobalSearchAnimation(false);
    }, 10000);
  }

  private cancelTimer(): void {
    if (this.mTimerId) {
      clearTimeout(this.mTimerId);
      this.mTimerId = 0;
    }
  }

  /**
   * 开始全搜定位动效
   *
   * @param bundleName 搜索定位参数
   * @param abilityName 搜索定位参数
   * @param moduleName 搜索定位参数
   * @param typeId 搜索定位参数
   */
  async beginLocationAnimation(bundleName: string, abilityName: string, moduleName: string, typeId: number,
    entityId: string): Promise<void> {
    log.showInfo(`searchParam bundleName:${bundleName}, abilityName:${abilityName}, moduleName:${moduleName},
    typeId:${typeId}, entityId:${entityId}`);
    this.setProtectTimer();

    let gridLayoutItemInfos: GridLayoutItemInfo[] =
      await LauncherLayoutCacheUtil.queryGridLayoutItemsByBundleName(bundleName);
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemInfos)) {
      log.showWarn('queryGridLayoutItemsByBundleName is empty.');
      this.setGlobalSearchAnimation(false);
      return;
    }

    let gridLayoutItemInfo: GridLayoutItemInfo | undefined =
      this.filterGridLayoutItemByEntityId(entityId, gridLayoutItemInfos);
    if (CheckEmptyUtils.isEmpty(gridLayoutItemInfo)) {
      log.showInfo(`filterGridLayoutItemByEntityId return null`);
      this.setGlobalSearchAnimation(false);
      return;
    }

    if (gridLayoutItemInfo) {
      this.inPutBundleName = gridLayoutItemInfo.bundleName;
      this.inPutAbilityName = gridLayoutItemInfo.abilityName;
      this.inPutModuleName = gridLayoutItemInfo.moduleName ?? '';
      this.inPutTypeId = gridLayoutItemInfo.typeId ?? 0;
      this.inPutKeyName = AppItemInfo.getKeyName(gridLayoutItemInfo);
      this.globalSearchAnimation = true;

      log.showInfo(`beginLocationAnimation, bundleName:${this.inPutBundleName}, abilityName:${this.inPutAbilityName
      }, moduleName:${this.inPutModuleName}, typeId:${this.inPutTypeId}, keyName:${this.inPutKeyName}`);

      HiSysEventUtil.reportSearchAppPosition(bundleName, gridLayoutItemInfo.shortcutId);
    }

    this.gsParam = this.calcGlobalSearchLocationParam(this.inPutBundleName, this.inPutAbilityName,
      this.inPutModuleName, this.inPutTypeId, this.inPutKeyName);
    if (this.gsParam.type === SearchLocationType.NULL_TYPE) {
      log.showInfo(`cannot get gsParam for this search!`);
      this.globalSearchAnimation = false;
      AppStorage.setOrCreate('globalSearchAnimation', false);
      scbEventExclusiveManager.setEventExclusive(EventType.GLOBALSEARCH_LOCATIONAPPSHOW, false);
      return;
    }
    log.showInfo(`beginLocationAnimation, page:${this.gsParam.page}`);
    if (this.gsParam.type === SearchLocationType.DOCK_TYPE) {
      this.pageJumpFinish();
      return;
    }

    if (this.isAtCurrentPage()) {
      this.pageJumpFinish();
    } else {
      this.desktopContext?.eventHub.on(`globalSearchLocationSwitchToPage`, this.pageJumpFinishCallback);
      PageDesktopViewModel.getInstance(this.singleContext).getSwiperController()?.changeIndex(this.gsParam.page, true);
    }
  }

  filterGridLayoutItemByEntityId(entityId: string, gridLayoutItemInfos: GridLayoutItemInfo[]):
    GridLayoutItemInfo | undefined {
    let gridLayoutItemInfo : GridLayoutItemInfo | undefined;
    if (gridLayoutItemInfos.length === 1) {
      if (entityId === gridLayoutItemInfos[0].id?.toString()) {
        return gridLayoutItemInfos[0];
      } else {
        log.showInfo(`id is not equal,local id is ${gridLayoutItemInfos[0].id}, entityId is ${entityId}`);
        return gridLayoutItemInfo;
      }
    }
    // 记录日志，便于排查搜索应用重复以及搜索定位不到的问题
    for (let item of gridLayoutItemInfos) {
      log.showInfo(`search db item:${item.appName},${item.bundleName},${item.abilityName},${item.moduleName},
        ${item.typeId},${item.shortcutId},${item.id},${item.appStatus}`);
      if (entityId === item.id?.toString()) {
        gridLayoutItemInfo = item;
      }
    }
    return gridLayoutItemInfo;
  }

  /**
   * 判断定位的app所在页面是否为当前页
   *
   * @returns true是当前页，false非当前页
   */
  isAtCurrentPage(): boolean {
    let currentPage: number = desktopUtil.getPageIndexValue() ?? 0;
    return PageInfoManager.getInstance().isCurrentPageShow(currentPage, this.gsParam.page);
  }

  /**
   * 定位到app，开始做动效
   */
  doIconAnimation(): void {
    log.showInfo(`doIconAnimation, globalSearchAnimation:${this.globalSearchAnimation}`);
    if (!this.globalSearchAnimation) {
      return;
    }
    AppStorage.setOrCreate('globalSearchLocationAppShow', true);
  }

  /**
   * 跳转到定位app所在页面
   */
  pageJumpFinish(): void {
    log.showInfo(`pageJumpFinish: ${this.globalSearchAnimation},
     page1:${this.gsParam.page}, page2:${desktopUtil.getPageIndexValue()}`);

    if (!this.globalSearchAnimation) {
      return;
    }
    if (this.gsParam.type === SearchLocationType.DOCK_TYPE) {
      this.doIconAnimation();
      return;
    }
    if (!this.isAtCurrentPage()) {
      return;
    }

    if (this.gsParam.type === SearchLocationType.BIG_FOLDER_ITEM_TYPE) {
      this.desktopContext?.eventHub.on(`globalSearchLocationFolderOpen`, this.folderOpenFinishCallback);
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
      this.openFolder();
    } else if (this.gsParam.type === SearchLocationType.SMALL_FOLDER_ITEM_TYPE) {
      this.desktopContext?.eventHub.on(`globalSearchLocationFolderOpen`, this.folderOpenFinishCallback);
      AppStorageUtil.setOrCreate(CommonConstants.OPEN_SOURCES, false);
      this.openFolder();
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
    } else if (this.gsParam.type === SearchLocationType.DOCK_FOLDER_ITEM_TYPE) {
      this.desktopContext?.eventHub.on(`globalSearchLocationFolderOpen`, this.folderOpenFinishCallback);
      this.openFolder();
    } else {
      this.doIconAnimation();
    }
  }

  private openFolder(): void {
    if (this.gsParam.type === SearchLocationType.BIG_FOLDER_ITEM_TYPE ||
      this.gsParam.type === SearchLocationType.SMALL_FOLDER_ITEM_TYPE) {
      ContractedFolderCommonViewModel.getInstance()
        .openFolder('open from globalSearch', this.gsParam.folderItem?.folderId, false);
    } else if (this.gsParam.type === SearchLocationType.DOCK_FOLDER_ITEM_TYPE) {
      ContractedFolderCommonViewModel.getInstance()
        .openFolder('open from globalSearch', this.gsParam.folderItem?.folderId, false);
    }
  }

  /**
   * 定位app所在文件夹打开结束
   */
  folderOpenFinish(): void {
    const openFolderIndex: number = FolderManager.getInstance().getPageIndex();
    log.showInfo(`folderOpenFinish, page1:${this.gsParam.appItem.page}, page2:${openFolderIndex}`);
    if (this.gsParam.appItem.page !== openFolderIndex) {
      let pagesOfFolder: number = this.gsParam.folderItem.layoutInfo?.length ?? 0;
      let targetPageIndex: number = this.gsParam.appItem.page ?? 0;
      if (targetPageIndex < pagesOfFolder) {
        this.desktopContext?.eventHub.on(`globalSearchLocationFolderSwitchToPage`, this.folderPageJumpFinishCallback);
        FolderDataModelManager.getInstance().getSwiperController()?.changeIndex(targetPageIndex, true);
      } else {
        this.setGlobalSearchAnimation(false);
        log.showError(`targetPageIndex is out of index`);
      }
      return;
    }

    if (this.globalSearchAnimation) {
      this.doIconAnimation();
    }
  }

  /**
   * 定位app所在文件夹内页面跳转结束
   */
  folderPageJumpFinish(): void {
    if (this.globalSearchAnimation) {
      this.doIconAnimation();
    }
  }

  /**
   * 计算全搜定位参数
   *
   * @param bundleName全搜定位参数
   * @param abilityName全搜定位参数
   * @param moduleName全搜定位参数
   * @param typeId全搜定位参数
   * @returns 全搜定位参数
   */
  calcGlobalSearchLocationParam(bundleName: string, abilityName: string,
                                moduleName: string, typeId: number, keyName: string): GlobalSearchLocationParam {
    let gsParam: GlobalSearchLocationParam = this.findAppInDock(bundleName, abilityName, moduleName, typeId, keyName);
    if (gsParam.type === SearchLocationType.NULL_TYPE) {
      gsParam = this.findAppInDesktop(bundleName, abilityName, moduleName, typeId, keyName);
    }
    if (gsParam.type === SearchLocationType.NULL_TYPE) {
      gsParam = this.findAppInFolder(bundleName, abilityName, moduleName, typeId, keyName);
    }
    return gsParam;
  }

  /**
   * 在dock中找全搜定位参数
   *
   * @param bundleName全搜定位参数
   * @param abilityName全搜定位参数
   * @param moduleName全搜定位参数
   * @param typeId全搜定位参数
   * @returns 在dock中全搜定位参数
   */
  findAppInDock(bundleName: string, abilityName: string,
                moduleName: string, typeId: number, keyName: string): GlobalSearchLocationParam {
    log.showInfo(`try to find app in dock`);
    let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
    let bottomAppList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    for (let i = 0; i < bottomAppList.length; i++) {
      if (bottomAppList[i].typeId === CommonConstants.TYPE_FOLDER) {
        const folderAppList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(bottomAppList[i]);
        BigFolderViewModel.getInstance().updateFolderAppLocation(folderAppList);
        let appItem: GridLayoutItemInfo | undefined = folderAppList.find(appItem =>
            this.isSame(appItem, bundleName, abilityName, moduleName, typeId, keyName));
        if (appItem !== undefined) {
          gsParam.page = desktopUtil.getPageIndexValue();
          gsParam.appItem = appItem as AppItemInfo;
          gsParam.folderItem = this.getFolderItem(bottomAppList[i]);
          gsParam.type = SearchLocationType.DOCK_FOLDER_ITEM_TYPE;
          gsParam.rectName =
            this.appIconModel.getIconId(gsParam.appItem, undefined, launcherStatusUtil.getShowOutLauncherStatus(),
              true);
          log.showInfo(`findAppInDock, folder, page:${gsParam.appItem.page}`);
        }
      } else {
        log.showInfo(`findAppInDock bundleName:${bottomAppList[i].bundleName},abilityName:
          ${bottomAppList[i].abilityName},moduleName:${bottomAppList[i].moduleName},typeId:${bottomAppList[i].typeId}`);
        if (this.isSame(bottomAppList[i], bundleName, abilityName, moduleName, typeId, keyName)) {
          gsParam.appItem = bottomAppList[i];
          gsParam.page = gsParam.appItem.page ?? 0;
          gsParam.type = SearchLocationType.DOCK_TYPE;
          gsParam.rectName = DockUtils.getDockItemId(gsParam.appItem as DockItemInfo);
          log.showInfo(`findAppInDock`);
        }
      }
    }
    return gsParam;
  }

  /**
   * 在桌面中找全搜定位参数
   *
   * @param bundleName全搜定位参数
   * @param abilityName全搜定位参数
   * @param moduleName全搜定位参数
   * @param typeId全搜定位参数
   * @returns 在桌面中找全搜定位参数
   */
  findAppInDesktop(bundleName: string, abilityName: string,
                   moduleName: string, typeId: number, keyName: string): GlobalSearchLocationParam {
    log.showInfo(`try to find app in desktop`);
    let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
    let apps: GridLayoutItemInfo[] = [];
    apps = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByBundleName(bundleName);
    apps = apps.filter((item) => {
      if (item.abilityName === abilityName &&
        item.moduleName === moduleName &&
        item.typeId === typeId &&
        item.keyName === keyName) {
        return true;
      }
      return false;
    });
    if (apps.length > 0) {
      gsParam.appItem = apps[0] as AppItemInfo;
      gsParam.page = gsParam.appItem.page ?? 0;
      gsParam.type = SearchLocationType.DESKTOP_ITEM;
      gsParam.rectName =
        this.appIconModel.getIconId(gsParam.appItem, undefined, launcherStatusUtil.getShowOutLauncherStatus());
      log.showInfo(`findAppInDesktop, page:${gsParam.appItem.page}`);
    }
    return gsParam;
  }

  /**
   * 在文件夹中找全搜定位参数
   *
   * @param bundleName全搜定位参数
   * @param abilityName全搜定位参数
   * @param moduleName全搜定位参数
   * @param typeId全搜定位参数
   * @returns 在文件夹中找全搜定位参数
   */
  findAppInFolder(bundleName: string, abilityName: string,
                  moduleName: string, typeId: number, keyName: string): GlobalSearchLocationParam {
    log.showInfo(`try to find app in folder`);
    let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
    let folderItem: GridLayoutItemInfo =
      FolderLayoutCacheManager.getInstance().selectFolderByKeyName(keyName) ?? new GridLayoutItemInfo();
    gsParam.folderItem = folderItem;
    gsParam.page = gsParam.folderItem.page ?? 0;
    const folderAppList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(folderItem);
    log.showInfo(`folderName = ${folderItem.folderName}, folderId = ${folderItem.folderId}`);
    BigFolderViewModel.getInstance().updateFolderAppLocation(folderAppList);
    let appItem: GridLayoutItemInfo | undefined = folderAppList.find(appItem =>
      this.isSame(appItem, bundleName, abilityName, moduleName, typeId, keyName));
    if (appItem !== undefined) {
      gsParam.appItem = appItem as AppItemInfo;
      let mArea: number[] = gsParam.folderItem.area ?? [0, 0];
      if (mArea[0] === 1 && mArea[1] === 1) {
        gsParam.type = SearchLocationType.SMALL_FOLDER_ITEM_TYPE;
      } else {
        gsParam.type = SearchLocationType.BIG_FOLDER_ITEM_TYPE;
      }
      gsParam.rectName = this.appIconModel.getIconId(gsParam.appItem, undefined, false, true);
      log.showInfo(`findAppInFolder, page0:${gsParam.page}, page1:${gsParam.appItem.page}`);
    }
    return gsParam;
  }

  private getFolderItem(appInfo: DockItemInfo): GridLayoutItemInfo {
    let retItem = new GridLayoutItemInfo();
    retItem.itemType = CommonConstants.TYPE_FOLDER + '';
    retItem.typeId = CommonConstants.TYPE_FOLDER;
    retItem.folderId = appInfo.keyName;
    retItem.bundleName = appInfo.bundleName;
    retItem.moduleName = appInfo.moduleName;
    retItem.abilityName = appInfo.abilityName;
    retItem.appIconId = appInfo.appIconId;
    retItem.appLabelId = appInfo.appLabelId;
    retItem.applicationLabelId = appInfo.applicationLabelId;
    retItem.appName = appInfo.appName;
    retItem.folderName = appInfo.appName;
    retItem.areaType = appInfo.areaType;
    retItem.keyName = appInfo.keyName;
    retItem.layoutInfo = appInfo.layoutInfo;
    retItem.container = CommonConstants.CONTAINER_SMARTDOCK;
    retItem.area = [1, 1];
    retItem.row = appInfo.row;
    retItem.column = appInfo.column;
    retItem.badgeNumber = appInfo.badgeNumber;
    retItem.isInDock = true;
    return retItem;
  }

  /**
   * 隐藏定位到的图标
   */
  hideIcon(): void {
    if (this.gsParam.type === SearchLocationType.DESKTOP_ITEM) {
      let iconOpacity: string = `Opacity_AppIconRelative_${this.gsParam.appItem.keyName}`;
      this.desktopContext?.eventHub.emit(iconOpacity, 0);
    } else if (this.gsParam.type === SearchLocationType.BIG_FOLDER_ITEM_TYPE ||
      this.gsParam.type === SearchLocationType.SMALL_FOLDER_ITEM_TYPE ||
      this.gsParam.type === SearchLocationType.DOCK_FOLDER_ITEM_TYPE) {
      let iconOpacity: string = `Opacity_AppIconRelative_${this.gsParam.appItem.keyName}`;
      this.desktopContext?.eventHub.emit(iconOpacity, 0);
    } else if (this.gsParam.type === SearchLocationType.DOCK_TYPE) {
      let iconOpacity: string = `Opacity_${DockUtils.getDockItemId(this.gsParam.appItem as DockItemInfo)}.` +
        `${this.gsParam.appItem.abilityName}.${this.gsParam.appItem.moduleName}.${this.gsParam.appItem.typeId}`;
      this.desktopContext?.eventHub.emit(iconOpacity, 0);
    }
  }

  /**
   * 恢复定位到的图标
   */
  restoreIcon(): void {
    if (this.gsParam.type === SearchLocationType.DESKTOP_ITEM) {
      let iconOpacity: string = `Opacity_AppIconRelative_${this.gsParam.appItem.keyName}`;
      this.desktopContext?.eventHub.emit(iconOpacity, 1);
    } else if (this.gsParam.type === SearchLocationType.BIG_FOLDER_ITEM_TYPE ||
      this.gsParam.type === SearchLocationType.SMALL_FOLDER_ITEM_TYPE ||
      this.gsParam.type === SearchLocationType.DOCK_FOLDER_ITEM_TYPE) {
      let iconOpacity: string = `Opacity_AppIconRelative_${this.gsParam.appItem.keyName}`;
      this.desktopContext?.eventHub.emit(iconOpacity, 1);
    } else if (this.gsParam.type === SearchLocationType.DOCK_TYPE) {
      let iconOpacity: string = `Opacity_${DockUtils.getDockItemId(this.gsParam.appItem as DockItemInfo)}.` +
        `${this.gsParam.appItem.abilityName}.${this.gsParam.appItem.moduleName}.${this.gsParam.appItem.typeId}`;
      this.desktopContext?.eventHub.emit(iconOpacity, 1);
    }
  }

  /*
   * 打断动效
   * */
  public stopGlobalSearchProcess(): void {
    this.setGlobalSearchAnimation(false);
    this.restoreIcon();
  }

  private isSame(appItem: GridLayoutItemInfo | DockItemInfo, bundleName: string, abilityName: string,
    moduleName: string, typeId: number, keyName: string): boolean {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      log.showInfo(`appItem is empty`);
      return false;
    }
    return appItem.bundleName === bundleName && appItem.abilityName === abilityName &&
      appItem.moduleName === moduleName && appItem.typeId === typeId && appItem.keyName === keyName;
  }
}