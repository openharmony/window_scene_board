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

import { HashMap } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppIconCheckAndFixIface } from '../interface/AppIconCheckAndFixIface';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { BusinessType, CommonConstants } from '../../constants/CommonConstants';
import { DockItemInfo } from '../../bean/DockItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { launcherAbilityManager } from '../../TsIndex';
import { LaunchLayoutCacheManager } from '../../cache/layout/LaunchLayoutCacheManager';
import { INVALID_REASON, LostBundleInfo } from '../viewmodel/AppIconCheckAndFixManager';
import { ResidentLayoutCacheMgr } from '../../dock/cache/ResidentLayoutCacheMgr';
import SystemApplication from '../../configs/SystemApplication';

const TAG = 'AppIconChecker';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 默认dock区的检测返回页面page 18, 与正常页面区分
const DOCK_PAGE_NUMBER: number = 18;
const INVALID_PAGE_NUMBER: number = -1;

const UNSUPPORT_CACHE_CHECK_BUNDLE: string[] = [
  'com.ohos.sceneboard',
  'com.ohos.emergencycommunication'
];

/**
 * 图标检测器
 * 用于检测图标是否丢失，包含图标Image是否正常、opacity是否正常以及桌面图标缓存是否缺失
 */
export class AppIconChecker {
  private systemApplicationName: string[] = SystemApplication.systemApplicationName.split(',');
  private checkResultCache: HashMap<number, LostBundleInfo[]> = new HashMap<number, LostBundleInfo[]>();

  /**
   * 当前检测的结果
   */
  public getCheckResultCache(): HashMap<number, LostBundleInfo[]> {
    return this.checkResultCache;
  }

  /**
   * 清空缓存
   */
  public clearCheckResultCache(): void {
    this.checkResultCache.clear();
  }

  /**
   * 检查对应应用的Image是否正常
   *
   * @param bundleName 应用包名
   * @returns 异常的应用信息
   */
  public checkIconImage(bundleName: string = '', appIconCheckAndFix: HashMap<string, AppIconCheckAndFixIface[]>): LostBundleInfo[] {
    let checkResult: LostBundleInfo[] = [];
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      appIconCheckAndFix.forEach((ifaces: AppIconCheckAndFixIface[], key: string) => {
        checkResult = checkResult.concat(this.getInvalidImageIcon(ifaces));
      })
      this.checkResultCache.set(INVALID_REASON.INVALID_ICON_IMAGE, checkResult);
      return checkResult;
    }
    if (appIconCheckAndFix.hasKey(bundleName)) {
      let iface: AppIconCheckAndFixIface[] = appIconCheckAndFix.get(bundleName);
      checkResult = this.getInvalidImageIcon(iface);
    }
    this.checkResultCache.set(INVALID_REASON.INVALID_ICON_IMAGE, checkResult);
    return checkResult;
  }

  private getInvalidImageIcon(iface: AppIconCheckAndFixIface[]): LostBundleInfo[] {
    let invalidOpacityIcon: LostBundleInfo[] = [];
    iface.forEach((item) => {
      if (!item.isValidImage()) {
        let appItemInfo: AppItemInfo = item.getCheckItemInfo();
        let page: number = this.getAppIconPage(appItemInfo.bundleName, appItemInfo.appIndex);
        let lostBundleInfo: LostBundleInfo =
          new LostBundleInfo(appItemInfo.bundleName, appItemInfo.moduleName ?? '', appItemInfo.abilityName,
            appItemInfo.appIndex ?? 0, page);
        invalidOpacityIcon.push(lostBundleInfo);
      }
    });
    return invalidOpacityIcon;
  }

  /**
   * 检查对应应用的不透明度是否正常
   *
   * @param bundleName 应用包名
   * @returns 异常的应用信息
   */
  public checkIconOpacity(bundleName: string = '', appIconCheckAndFix: HashMap<string, AppIconCheckAndFixIface[]>): LostBundleInfo[] {
    let checkResult: LostBundleInfo[] = [];
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      appIconCheckAndFix.forEach((ifaces: AppIconCheckAndFixIface[], key: string) => {
        checkResult = checkResult.concat(this.getInvalidOpacityIcon(ifaces));
      })
      this.checkResultCache.set(INVALID_REASON.INVALID_ICON_OPACITY, checkResult);
      return checkResult;
    }
    if (appIconCheckAndFix.hasKey(bundleName)) {
      let iface: AppIconCheckAndFixIface[] = appIconCheckAndFix.get(bundleName);
      checkResult = this.getInvalidOpacityIcon(iface);
    }
    this.checkResultCache.set(INVALID_REASON.INVALID_ICON_OPACITY, checkResult);
    return checkResult;
  }

  private getInvalidOpacityIcon(iface: AppIconCheckAndFixIface[]): LostBundleInfo[] {
    let invalidOpacityIcon: LostBundleInfo[] = [];
    iface.forEach((item) => {
      if (!item.isValidOpacity()) {
        let appItemInfo: AppItemInfo = item.getCheckItemInfo();
        let page: number = this.getAppIconPage(appItemInfo.bundleName, appItemInfo.appIndex);
        let lostBundleInfo: LostBundleInfo =
          new LostBundleInfo(appItemInfo.bundleName, appItemInfo.moduleName ?? '', appItemInfo.abilityName,
            appItemInfo.appIndex ?? 0, page);
        invalidOpacityIcon.push(lostBundleInfo);
      }
    });
    return invalidOpacityIcon;
  }

  /**
   * 检查对应应用的缓存是否正常
   *
   * @param bundleName 应用包名
   */
  public async checkIconInLayoutCache(bundleName: string = ''): Promise<void> {
    let lostResult: LostBundleInfo[] = [];
    let installedApps: AppItemInfo[] =
      await launcherAbilityManager.getLauncherAbilityList(launcherAbilityManager.getUserId());
    log.showWarn(`installedApps from bms length: ${installedApps.length}`);

    let dockItemList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    log.showWarn(`dockItemList length: ${dockItemList.length}`);
    let desktopItemList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
    log.showWarn(`desktopItemList length: ${desktopItemList.length}`);
    let allApps: (GridLayoutItemInfo | DockItemInfo)[] = this.getDesktopOrDockAllApp(desktopItemList, dockItemList);

    // 收集BMS存在但在桌面缓存不存在的应用(不含scb)
    installedApps.forEach((app: AppItemInfo) => {
      if (this.isSupportInLayoutCheck(app.bundleName) &&
        allApps.findIndex((item: GridLayoutItemInfo | DockItemInfo) =>
        item.bundleName === app.bundleName) === CommonConstants.INVALID_VALUE) {
        lostResult.push(new LostBundleInfo(app.bundleName, app.moduleName ?? '', app.abilityName,
          app.appIndex ?? 0, INVALID_PAGE_NUMBER));
      }
    });
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      this.checkResultCache.set(INVALID_REASON.INVALID_ICON_LAYOUT_CACHE, lostResult);
      log.showWarn(`lostResult length: ${lostResult.length}`);
      return;
    }

    // 指定包名时只返回对应的对应包名的检测结果
    lostResult = lostResult.filter((item: LostBundleInfo) => item.bundleName === bundleName);
    log.showWarn(`lostResult length: ${lostResult.length}`);
    this.checkResultCache.set(INVALID_REASON.INVALID_ICON_LAYOUT_CACHE, lostResult);
  }

  private isSupportInLayoutCheck(bundleName: string): boolean {
    return !UNSUPPORT_CACHE_CHECK_BUNDLE.includes(bundleName) &&
      !this.systemApplicationName.includes(bundleName);
  }

  /**
   * 查询图标所在哪一页
   *
   * @param bundleName 包名
   * @param appIndex appIndex
   * @returns 页数
   */
  private getAppIconPage(bundleName: string, appIndex?: number): number {
    // 查询并过滤布局缓存(桌面+dock)中所有同包名app(不含快捷方式)
    let sameAppItem: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().
    getAllSameBundleNameAppItem(bundleName).filter((item) => {
      return item.appIndex === (appIndex ?? 0);
    });

    if (CheckEmptyUtils.isEmptyArr(sameAppItem)) {
      log.showWarn(`can not find bundleName: ${bundleName}, appIndex: ${appIndex ?? 0} in desktop and dock`);
      return INVALID_PAGE_NUMBER;
    }

    if (sameAppItem[0].container === CommonConstants.CONTAINER_DOCK) {
      return DOCK_PAGE_NUMBER;
    }
    if (sameAppItem[0].container === CommonConstants.CONTAINER_DESKTOP) {
      return sameAppItem[0].page ?? INVALID_PAGE_NUMBER;
    }

    // 查找当前应用所在文件夹的当前页
    let page: number | undefined = INVALID_PAGE_NUMBER;
    let desktopFolders: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByType(CommonConstants.TYPE_FOLDER);
    page = this.getDesktopOrDockFolderPage(desktopFolders, bundleName, appIndex ?? 0);
    if (page === INVALID_PAGE_NUMBER) {
      let dockFolderItem: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems().filter((item) =>{
        return item.typeId === CommonConstants.TYPE_FOLDER;
      });
      page = this.getDesktopOrDockFolderPage(dockFolderItem, bundleName, appIndex ?? 0, DOCK_PAGE_NUMBER);
    }
    return page;
  }

  /**
   * 查询在文件夹内的某个应用, 对应的文件夹所在的页面
   *
   * @param folders 桌面和dock区的所有文件夹
   * @param bundleName 包名
   * @param appIndex appIndex
   * @param defaultPage 查询成功时的默认页数，如在dock区默认返回page为0
   * @returns 对应的页面
   */
  private getDesktopOrDockFolderPage(folders: GridLayoutItemInfo[] | DockItemInfo[], bundleName: string,
    appIndex: number, defaultPage?: number): number {
    let page: number | undefined;
    if (!folders || folders.length === 0) {
      log.showInfo('getDesktopOrDockFolderPage fail');
      return INVALID_PAGE_NUMBER;
    }
    for (let i = 0; i < folders.length; i++) {
      let index: number | undefined = folders[i]?.layoutInfo?.flat().findIndex(
        item => item.bundleName === bundleName && item.appIndex === appIndex);
      if (index !== undefined && index > CommonConstants.INVALID_VALUE) {
        page = defaultPage ?? folders[i].page;
        break;
      }
    }
    return page ?? INVALID_PAGE_NUMBER;
  }

  /**
   * 获取桌面和dock区全部应用
   *
   * @param desktopItems 桌面全部元素
   * @param dockItems dock全部元素
   * @returns 桌面和dock区全部应用
   */
  private getDesktopOrDockAllApp(desktopItems: GridLayoutItemInfo[],
    dockItems: DockItemInfo[]):Array<GridLayoutItemInfo | DockItemInfo> {
    let allApp: (GridLayoutItemInfo | DockItemInfo)[] = [];
    this.filterAppFromItemInfo(desktopItems).forEach((item) => {
      allApp.push(item);
    })
    this.filterAppFromItemInfo(dockItems).forEach((item) => {
      allApp.push(item);
    })
    return allApp;
  }

  private filterAppFromItemInfo(items: GridLayoutItemInfo[] | DockItemInfo[]):
    Array<GridLayoutItemInfo | DockItemInfo> {
    let apps: (GridLayoutItemInfo | DockItemInfo)[] = [];
    items.forEach((item: GridLayoutItemInfo | DockItemInfo) => {
      if (item.typeId === CommonConstants.TYPE_APP) {
        apps.push(item);
        return;
      }
      if (item.typeId !== CommonConstants.TYPE_FOLDER) {
        return;
      }
      item.layoutInfo?.flat().forEach((itemInFolder: GridLayoutItemInfo) => {
        if (itemInFolder.typeId === CommonConstants.TYPE_APP) {
          apps.push(itemInFolder);
        }
      });
    });
    return apps;
  }
}