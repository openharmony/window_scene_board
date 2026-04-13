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

import BundleManager from '@ohos.bundle.bundleManager';
import { CheckEmptyUtils, LogDomain, Logger, StartType } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, IconResourceManager } from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  AppLockUtils,
  AppModel,
  CommonConstants, DockItemInfo,
  IconType,
  MenuInfo,
  RecentBundleMissionInfo
} from '@ohos/launchercommon';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { SCBSceneSessionManager, StartAbilityUtil } from '@ohos/windowscene';
import { PCDockUtils } from '../utils/PCDockUtils';
import PcSmartDockViewModel from './SmartDockViewModel';
import { FixedDockConstants } from '../common/constants/FixedDockConstants';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import { DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';
import { DockMenuCategory, ParameterItem } from '../model/DockMenuCategory';
import { DockMenuTaskManager } from '../manager/DockMenuTaskManager';
import image from '@ohos.multimedia.image';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';

const CALLUI_BUNDLE = 'com.ohos.callui';
const TAG = 'PCDock-DockMenuViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class DockMenuViewModel {
  private smartDockViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private screenId: number = 0;
  private appInfo: DockItemInfo = new DockItemInfo();
  public wpsPreExitFunc: Function | undefined = undefined;
  private isInitComplete: boolean = false;
  private menuInfo: MenuInfo[] = [];
  private dynamicMenuList: MenuInfo[] = [];
  private shortcutMenuList: MenuInfo[] = [];
  private fixedMenuList: MenuInfo[] = [];
  private categoryList: DockMenuCategory[] = [];
  private defaultImg: image.PixelMap | undefined = undefined;
  private dockType: number = SmartDockConstants.RESIDENT_DOCK_TYPE;
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();

  /**
   * viewModel初始化
   * @param screenId
   * @param appInfo
   */
  public init(screenId: number, appInfo: DockItemInfo, dockType: number) {
    this.screenId = screenId;
    this.appInfo = appInfo;
    this.dockType = dockType;
  }

  /**
   * screenId
   * @returns
   */
  public getScreenId(): number {
    return this.screenId;
  }

  /**
   * appInfo 更新
   * @param appInfo
   */
  public updateAppInfo(appInfo: DockItemInfo): void {
    this.appInfo = appInfo;
  }

  /**
   * appInfo 获取菜单列表
   * @param appInfo
   */
  public getAllMenuInfoList(): MenuInfo[] {
    return this.menuInfo;
  }

  /**
   * 设置wps预关闭回调函数
   * @param wpsPreExitFunc
   */
  public setWpsPreExitFunc(wpsPreExitFunc: Function): void {
    this.wpsPreExitFunc = wpsPreExitFunc;
  }

  public isMenuInitComplete(): boolean {
    return this.isInitComplete;
  }

  public getDynamicMenuList(): MenuInfo[] {
    return this.dynamicMenuList;
  }

  public getShortcutMenuList(): MenuInfo[] {
    return this.shortcutMenuList;
  }

  public getFixedMenuList(): MenuInfo[] {
    return this.fixedMenuList;
  }

  public menuInfoInit(): void {
    this.menuInfo = this.smartDockViewModel.buildMenuInfoList(this.appInfo, this.dockType, undefined,
      undefined, this.screenId);
  }

  public getMenuInfoList(): MenuInfo[] {
    const appInfo = this.appInfo;
    const screenId = this.screenId;
    log.showInfo(TAG, `getMenuinfoList start appInfo:${appInfo.bundleName} screenId:${screenId}`);
    let menu: MenuInfo[] = [];
    const openAppNameList: string[] = [];
    const missionInfoList = AppStorage.get('missionInfoList') as Array<RecentBundleMissionInfo>;
    const item = missionInfoList.find(
      item => SmartDockModel.getInstance().isSameDockItem(item, appInfo));
    let queryKey = appInfo?.bundleName + appInfo?.moduleName + appInfo?.abilityName;
    const launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    let dynamicMenuList: MenuInfo[] = [];
    let shortcutMenuList: MenuInfo[] = [];
    this.menuInfo.forEach((item: MenuInfo) => {
      if (item.menuType === CommonConstants.MENU_TYPE_DYNAMIC) {
        shortcutMenuList.push(item);
      } else {
        dynamicMenuList.push(item);
      }
    })
    if (openAppNameList.includes(appInfo?.bundleName) || !CheckEmptyUtils.isEmpty(item)) {
      if (DockMenuViewModel.isNeedOpenNewWindow(appInfo, launchType) &&
        CheckEmptyUtils.isEmpty(appInfo?.persistentId)) {
        menu.push(this.smartDockViewModel.getOpenNewWindowMenu(appInfo, screenId));
      }
      menu.push(this.smartDockViewModel.getExitMenu(appInfo));
    } else if (DockMenuViewModel.isRecentCenter(appInfo)) {
      const isRecentShow: boolean = AppStorage.get<boolean>('showRecent') ?? false;
      if (isRecentShow) {
        menu.push(this.smartDockViewModel.getExitMenu(appInfo, screenId));
      } else {
        menu.push(this.smartDockViewModel.getOpenMenu(appInfo, screenId));
      }
    } else if (appInfo?.abilityName !== CommonConstants.RECYCLE_BIN_ABILITY) {
      menu.push(this.smartDockViewModel.getOpenMenu(appInfo, screenId));
    }
    this.dynamicMenuList = dynamicMenuList;
    this.shortcutMenuList = shortcutMenuList;
    let appLockMenu = AppLockUtils.getInstance().buildAppLockMenu(appInfo);
    if (appLockMenu !== undefined && this.needAddAppLock(appInfo)) {
      this.dynamicMenuList.unshift(appLockMenu);
    }
    this.fixedMenuList = menu.filter((item) => item.menuType === CommonConstants.MENU_TYPE_FIXED);
    this.isInitComplete = true;
    log.showInfo(TAG, `getMenuinfoList end appInfo:${appInfo.bundleName} screenId:${screenId} menu:${menu.length} ` +
      `dynamic:${dynamicMenuList.length} shortcut:${shortcutMenuList.length} fixed:${this.fixedMenuList.length}`);
    return menu;
  }

  private needAddAppLock(appInfo: DockItemInfo): boolean {
    if (appInfo?.bundleName === CALLUI_BUNDLE ) {
      return false;
    }

    let appItemInfo: AppItemInfo | undefined;
    if (appInfo?.keyName) {
      appItemInfo = AppModel.getInstance().getAppInfoByKeyName(appInfo.keyName);
    } else {
      appItemInfo = AppModel.getInstance().getAppInfoByBundleName(appInfo?.bundleName);
    }
    return !CheckEmptyUtils.isEmpty(appItemInfo);
  }

  public async initMenuTaskList(): Promise<void> {
    this.categoryList = await DockMenuTaskManager.getInstance().getCategoryList(this.appInfo.bundleName);
    this.defaultImg = await IconResourceManager.getInstance()
      .getCombIcon(this.appInfo.bundleName, this.appInfo.moduleName, this.appInfo.abilityName);
    log.showInfo(TAG, `this.categoryList: ${this.categoryList.length}`);
  }

  public updateMenuInfoList(): MenuInfo[] {
    const appInfo = this.appInfo;
    // pad的自由多窗，dock图标右键弹框只显示打开选项
    const res: MenuInfo[] = this.getMenuInfoList();
    const finalRes: MenuInfo[] = [];
    const index = res.findIndex(menu => menu.menuKeyString === 'appOpen');
    let formInfo = this.smartDockViewModel.getFormMenu(appInfo)
    if (formInfo.menuImgSrc !== null) {
      finalRes.push(this.smartDockViewModel.getFormMenu(appInfo));
    }
    if (index !== -1) {
      finalRes.push(res[index]);
    } else {
      finalRes.push(this.smartDockViewModel.getOpenMenu(appInfo));
    }
    if (appInfo?.bundleName === FixedDockConstants.WPS_BUNDLE_NAME) {
      // WPS应用图标打开状态右键定制列表
      const openAppNameList = AppStorage.get('openAppNameList') as Array<string>;
      if (openAppNameList.includes(appInfo?.bundleName)) {
        finalRes.push(this.smartDockViewModel.getWpsCloseMenu(appInfo, this.wpsPreExitFunc!));
      }
    }
    log.showInfo(TAG, `updateWpsMenuInfoList finalRes.length ${finalRes.length}`);
    return finalRes;
  }

  public async deleteMenuTask(task: DockMenuTaskInfo): Promise<void> {
    await DockMenuTaskManager.getInstance().deleteTask(task.bundleName, task.taskId);
  }

  private onMenuTaskClick(taskInfo: DockMenuTaskInfo): void {
    log.showInfo(TAG, 'onMenuTaskClick');
    this.desktopContext.eventHub.on(CommonConstants.EVENTHUB_MENU_DISAPPEAR, () => {
      this.desktopContext.eventHub.off(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
      let appItem = new AppItemInfo();
      appItem.bundleName = taskInfo.bundleName;
      appItem.appIndex = 0;
      try {
        const parametersRecord: Record<string, Object> = {};
        if (taskInfo.parameters) {
          taskInfo.parameters.forEach((item) => {
            parametersRecord[item.key] = item.value;
          });
        }
        StartAbilityUtil.startLauncherAbilityByWant({
          bundleName: taskInfo.bundleName,
          moduleName: taskInfo.moduleName,
          abilityName: taskInfo.abilityName,
          parameters: parametersRecord
        }, this.screenId);
        return;
      } catch (err) {
        log.showError(TAG, `onMenuTaskClick error, code: ${err?.code}  message: ${err?.message}`);
      }
    });
  }

  public getMenuInfo(taskInfo: DockMenuTaskInfo): MenuInfo {
    let openMenu: MenuInfo = {
      menuType: CommonConstants.MENU_TYPE_TASK,
      menuImgSrc: taskInfo.taskIconImg ?? this.defaultImg as image.PixelMap,
      menuText: taskInfo.taskName,
      menuEnabled: true,
      onMenuClick: () => this.onMenuTaskClick(taskInfo),
      shortcutIconId: -1,
      shortcutLabelId: -1,
      hoverTips: taskInfo.taskDetail,
      bundleName: taskInfo.bundleName,
      moduleName: taskInfo.moduleName,
      subMenuList: []
    };
    return openMenu;
  }

  public getCategoryList(): DockMenuCategory[] {
    log.showInfo(TAG, 'updateShowCategoryTaskList start');
    if (this.categoryList.length === 0) {
      return [];
    }

    let showCategoryList: DockMenuCategory[] = [];
    // 1、所有的任务列表存到一个列表
    let allTaskList: DockMenuTaskInfo[] = [];
    this.categoryList.forEach((item) => {
      allTaskList = allTaskList.concat(item.taskList);
      log.showInfo(TAG, `this.categoryList.taskList:${item.taskList.length} allTaskList:${allTaskList.length}`);
    });

    // 2、对所有任务做时间排序
    allTaskList.sort((a, b) => b.createTime - a.createTime);

    // 3、可以允许展示的任务数量
    let showCount = 19 - this.dynamicMenuList.length - this.shortcutMenuList.length - this.fixedMenuList.length;
    log.showInfo(TAG, `showCount:${showCount} allTaskList.length:${allTaskList.length} this.categoryList:${this.categoryList.length}`);

    // 4、遍历所有任务，逐渐占位
    for (let i = 0; i < allTaskList.length && showCount > 0; i++) {
      const task = allTaskList[i];
      let index = showCategoryList.findIndex((item) => item.categoryId === task.categoryId);
      if (index < 0 && showCount > 1) {
        let categoryIndex = this.categoryList.findIndex((item) => item.categoryId === task.categoryId);
        showCategoryList.push({
          bundleName: this.categoryList[categoryIndex].bundleName,
          categoryId: this.categoryList[categoryIndex].categoryId,
          categoryName: this.categoryList[categoryIndex].categoryName,
          categoryType: this.categoryList[categoryIndex].categoryType,
          createTime: this.categoryList[categoryIndex].createTime,
          taskList: [task]
        });
        showCount -= 2;
      } else if (index >= 0) {
        showCategoryList[index].taskList.push(task);
        --showCount;
      }
    }
    // 5、category再按时间排序
    showCategoryList.sort((a, b) => b.createTime - a.createTime);
    log.showInfo(TAG, 'updateShowCategoryTaskList end');
    return showCategoryList;
  }

  private static isRecentCenter(item: DockItemInfo): boolean {
    return item?.abilityName === CommonConstants.RECENT_ABILITY;
  }

  private static isNeedOpenNewWindow(appInfo: DockItemInfo, launchType: BundleManager.LaunchType): boolean {
    return launchType === BundleManager.LaunchType.MULTITON ||
      (!DeviceHelper.is2In1DevicePcType() && appInfo?.enableNewAppInstance) ||
      PCDockUtils.isPcFileManager(appInfo?.bundleName) ||
      appInfo?.bundleName === CommonConstants.BROWSER_BUNDLE ||
      appInfo?.bundleName === CommonConstants.HINOTEPAD_BUNDLE ||
      appInfo?.bundleName === CommonConstants.HISHELL ||
      appInfo?.bundleName === CommonConstants.HTRL_BROWSER_BUNDLE ||
      appInfo?.bundleName === CommonConstants.HT_BROWSER_BUNDLE;
  }
}