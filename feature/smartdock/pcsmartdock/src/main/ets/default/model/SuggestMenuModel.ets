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
  AppCenterModel,
  AppItemInfo,
  AppModel,
  CommonConstants,
  DockItemInfo,
  EventConstants,
  GetHideAppsFromConfig,
  KeyConstants,
  launcherAbilityManager,
  layoutConfigManager,
  MenuInfo,
  ReceiveEventInfo,
  SmartDockSuggestAppConfig,
  StyleConstants
} from '@ohos/launchercommon';
import dataStorage from '@ohos.data.storage';
import { CheckEmptyUtils, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { StartAbilityUtil, SCBSceneSessionManager, SCBSceneContainerSession } from '@ohos/windowscene';
import { ItemUtils } from '@ohos/componenthelper';
import { SCBConstants } from '@ohos/commonconstants';
import {
  GlobalContext,
  HiSysEventUtil,
  localEventManager
} from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import { DockItemPosition } from '@ohos/smartdock/src/main/ets/default/common/DockItemPosition';
import PresetSuggestAppItem from '../common/PresetSuggestAppItem';
import { PcDockRecentProxy } from '../manager/PcDockRecentProxy';

const TAG = 'SuggestMenuModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);
const GUIDE_BUNDLE_NAME = 'com.ohos.hwstartupguide';

/**
 * SuggestMenu Model
 */
export default class SuggestMenuModel {
  protected mRecentList: AppItemInfo[] = [];
  private static instance: SuggestMenuModel;
  private static SUGGEST_MAX_NUM = 10;
  private mSmartDockSuggestAppConfig: SmartDockSuggestAppConfig | null = null;
  private preferencePath: string = '';

  private constructor() {
    this.preferencePath = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).databaseDir + '/LauncherPreference';
    this.registerSuggestMenuListener();
    this.mSmartDockSuggestAppConfig =
      layoutConfigManager.getFunctionConfig(SmartDockSuggestAppConfig.SMART_DOCK_SUGGEST_APP_INFO);
    this.getDefaultSuggestList();
    log.showInfo('Launcher SuggestMenuModel constructor');
  }

  public static getInstance(): SuggestMenuModel {
    if (!SuggestMenuModel.instance) {
      SuggestMenuModel.instance = new SuggestMenuModel();
    }
    log.showInfo('Launcher SuggestMenuModel getInstance');
    return SuggestMenuModel.instance;
  }

  private registerSuggestMenuListener(): void {
    localEventManager.registerEventListener(this.mSuggestMenuListener, [
      EventConstants.EVENT_SUGGEST_MENU_REMOVED,
      EventConstants.EVENT_CONTAINER_SESSION_ADDED
    ]);
    log.showInfo('Launcher SuggestMenuModel local listener on create');
  }

  private async getDefaultSuggestList(): Promise<void> {
    await this.getPersistSuggestList();
    this.deleteSuggestInfoNotInAppList();
    await this.updateSuggestAppInfo();
  }

  private async updateSuggestAppInfo(): Promise<void> {
    let menuInfoList: MenuInfo[] = [];
    if (CheckEmptyUtils.isEmptyArr(this.mRecentList)) {
      let defaultAppList: DockItemInfo[] = [];
      if (SCBSceneSessionManager.getInstance().isPcMode()) {
        defaultAppList = PresetSuggestAppItem;
      } else {
        defaultAppList = this.mSmartDockSuggestAppConfig?.getSuggestAppInfo() as DockItemInfo[];
      }

      for (let i = 0; i < defaultAppList.length; i++) {
        if (defaultAppList[i].itemType === CommonConstants.TYPE_APP) {
          let appData = await launcherAbilityManager.getAppInfoByBundleName(defaultAppList[i].bundleName);
          if (CheckEmptyUtils.isEmpty(appData)) {
            continue;
          }
          let menu = new MenuInfo();
          menu.menuType = CommonConstants.MENU_TYPE_DYNAMIC;
          menu.menuText = appData == null ? defaultAppList[i].appName : appData.appName;
          menu.menuImgSrc = StyleConstants.DEFAULT_ICON;
          menu.shortcutIconId = appData == null ? menu.shortcutIconId : appData.appIconId;
          menu.shortcutLabelId = (appData == null ? menu.shortcutLabelId : appData.appLabelId) ?? 0;
          menu.bundleName = appData == null ? menu.bundleName : appData.bundleName;
          menu.moduleName = appData == null ? menu.moduleName : appData.moduleName;
          menu.onMenuClick = (screenId?: number): void => {
            HiSysEventUtil.reportDockMenuAppClick();
            this.onMenuClick(defaultAppList[i].abilityName, menu.bundleName ?? '', menu.moduleName ?? '', screenId);
          };
          log.showInfo(`TYPE_APP bundleName: ${menu.bundleName}, appName: ${menu.menuText}`);
          menuInfoList.push(menu);

          log.showInfo('add mRecentList');
          let recentInfo = new AppItemInfo();
          recentInfo.bundleName = menu.bundleName ?? '';
          recentInfo.moduleName = menu.moduleName;
          recentInfo.appIconId = menu.shortcutIconId;
          recentInfo.appLabelId = menu.shortcutLabelId;
          recentInfo.abilityName = appData == null ? defaultAppList[i].abilityName : appData.abilityName;
          recentInfo.appName = menu.menuText;
          this.mRecentList.push(recentInfo);
        }
      }
    } else {
      for (let i = 0; i < this.mRecentList.length; i++) {
        if (this.mRecentList[i].bundleName === GUIDE_BUNDLE_NAME) {
          continue;
        }
        if (this.isInMenuListByBundleName(this.mRecentList[i].bundleName, menuInfoList)) {
          continue;
        }
        let menu = new MenuInfo();
        menu.menuType = CommonConstants.MENU_TYPE_DYNAMIC;
        menu.menuText = this.mRecentList[i].appName;
        menu.menuImgSrc = StyleConstants.DEFAULT_ICON;
        menu.shortcutIconId = this.mRecentList[i].appIconId;
        menu.shortcutLabelId = this.mRecentList[i].appLabelId ?? 0;
        menu.bundleName = this.mRecentList[i].bundleName;
        menu.moduleName = this.mRecentList[i].moduleName;
        menu.onMenuClick = (screenId?: number): void => {
          HiSysEventUtil.reportDockMenuAppClick();
          this.onMenuClick(this.mRecentList[i].abilityName, menu.bundleName ?? '', menu.moduleName ?? '', screenId);
        };
        log.showInfo(`bundleName: ${menu.bundleName}, appName: ${menu.menuText}`);
        menuInfoList.push(menu);
      }
      if (menuInfoList.length >= SuggestMenuModel.SUGGEST_MAX_NUM) {
        menuInfoList.slice(0, SuggestMenuModel.SUGGEST_MAX_NUM);
      }
    }
    this.addFixedMenu(menuInfoList);
    AppStorage.setOrCreate('suggestAppMenuList', menuInfoList);
    this.updateAllSuggestList(menuInfoList);
  }

  public getSuggestMenuInfoList(screenId: number): Array<MenuInfo> {
    let menuList: MenuInfo[] = AppStorage.get('suggestAppMenuList') ?? [];
    this.updateFixedMenu(menuList, screenId);
    this.updateAllSuggestList(menuList);
    return menuList;
  }

  private persistSuggestList(): void {
    log.showInfo('persistSuggestList');
    try {
      let promise = dataStorage.getStorage(this.preferencePath);
      promise.then((storage) => {
        log.showInfo('persistSuggestList : put');
        let getPromise = storage.put('recentUsedList', JSON.stringify(this.mRecentList));
        getPromise.then(() => {
          log.showInfo(`Put the value of startup successfully`);
          storage.flushSync();
          log.showInfo('persistSuggestList : flushSync');
        }).catch((err: Error) => {
          log.showInfo(`Put the value of startup failed with err: ${err}`);
        });
      }).catch((err: Error) => {
        log.showInfo('Get the storage failed');
      });
    } catch (err) {
      log.error('[persistSuggestList] failed, error -> ', err);
    }
  }

  private readonly mSuggestMenuListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: SCBSceneContainerSession | DockItemInfo): void => {
      log.showInfo(`Launcher SmartDock receive event: ${event}`);
      if (event === EventConstants.EVENT_SUGGEST_MENU_REMOVED) {
        this.deleteSuggestInfo((params as DockItemInfo).bundleName);
        this.updateSuggestAppInfo();
      } else if (event === EventConstants.EVENT_CONTAINER_SESSION_ADDED) {
        this.addSuggestInfo(params as SCBSceneContainerSession).then(() => {
          this.updateSuggestAppInfo();
        });
      }
    }
  };

  private onMenuClick(abilityName: string, bundleName: string, moduleName: string, screenId?: number): void {
    if (abilityName === undefined || abilityName === null) {
      log.showInfo('onMenuClick abilityName is null');
      return;
    }
    if (bundleName === undefined || bundleName === null) {
      log.showInfo('onMenuClick bundleName is null');
      return;
    }
    const iconRect: RectInfo = ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
      'SmartDock_AppIcon', bundleName, abilityName));
    DockItemPosition.getInstance().setIconRect(iconRect);
    let params: Map<string, Object> =
      new Map<string, Object>([[KeyConstants.ITEM_RECT, DockItemPosition.getInstance().getIconRect()]]);
    params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
    log.showInfo(`onMenuClick bundleName: ${bundleName}, abilityName: ${abilityName}`);
    StartAbilityUtil.startLauncherAbility(abilityName, bundleName, moduleName, params, screenId);
  }

  private isInMenuListByBundleName(bundleName: string, menuInfo: MenuInfo[]): boolean {
    for (let i = 0; i < menuInfo.length; i++) {
      if (menuInfo[i].bundleName === bundleName) {
        return true;
      }
    }
    return false;
  }

  private isInAppListByBundleName(bundleName: string, menuInfo: AppItemInfo[]): boolean {
    for (let i = 0; i < menuInfo.length; i++) {
      if (menuInfo[i].bundleName === bundleName) {
        return true;
      }
    }
    return false;
  }

  private updateFixedMenu(menuInfoList: Array<MenuInfo>, screenId: number): void {
    if (menuInfoList === undefined || menuInfoList === null) {
      return;
    }
    for (let menuInfo of menuInfoList) {
      if (menuInfo.menuType === CommonConstants.MENU_TYPE_FIXED) {
        menuInfo.menuText = AppCenterModel.getInstance().isShow(screenId) ? $r('app.string.app_menu_exit') :
          $r('app.string.app_menu_open');
      }
    }
  }

  private addFixedMenu(recentMenuInfo: Array<MenuInfo>): void {
    let openMenu = new MenuInfo();
    openMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    openMenu.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
    openMenu.menuText = $r('app.string.app_menu_open');
    openMenu.onMenuClick = (screenId: number): void => {
      HiSysEventUtil.reportDockMenuOpen();
      HiSysEventUtil.reportPullAppCenter(HiSysEventUtil.APPCENTER_TYPE_CLICK);
      PcDockRecentProxy.getInstance().enterAppCenter(screenId);
    };
    recentMenuInfo.push(openMenu);
  }

  private async addSuggestInfo(sceneContainerSession: SCBSceneContainerSession): Promise<void> {
    let recentUsed: AppItemInfo[] = [];
    if (sceneContainerSession.primarySession && sceneContainerSession.primarySession.sceneInfo) {
      let primarySession = sceneContainerSession.primarySession.sceneInfo;
      let appDataPrimary = await launcherAbilityManager.getAppInfoByBundleName(primarySession.bundleName);
      if (appDataPrimary) {
        recentUsed.push(appDataPrimary);
      }
    }
    if (sceneContainerSession.secondarySession && sceneContainerSession.secondarySession.sceneInfo) {
      let secondarySession = sceneContainerSession.secondarySession.sceneInfo;
      let appDataSecondary = await launcherAbilityManager.getAppInfoByBundleName(secondarySession.bundleName);
      if (appDataSecondary) {
        recentUsed.push(appDataSecondary);
      }
    }
    for (let i = 0; i < this.mRecentList.length; i++) {
      if (this.isInAppListByBundleName(this.mRecentList[i].bundleName, recentUsed)) {
        continue;
      }
      recentUsed.push(this.mRecentList[i]);
      if (recentUsed.length >= SuggestMenuModel.SUGGEST_MAX_NUM) {
        break;
      }
    }
    this.mRecentList = recentUsed;
    this.persistSuggestList();
  }

  private deleteSuggestInfo(bundleName: string): void {
    if (bundleName === undefined || bundleName === null) {
      return;
    }
    this.mRecentList = this.mRecentList.filter(item => item.bundleName !== bundleName);
    this.persistSuggestList();
  }

  private async getPersistSuggestList(): Promise<void> {
    try {
      let storage = await dataStorage.getStorage(this.preferencePath);
      if (storage !== undefined && storage !== null) {
        log.showInfo('Get the storage success');
        let data = await storage.get('recentUsedList', 'default');
        if (typeof (data) === 'string' && data !== 'default') {
          this.mRecentList = JSON.parse(data);
        }
      }
    } catch (err) {
      log.error('[getPersistSuggestList] failed, error -> ', err);
    }
  }

  private isCollaboration(bundleName: string | undefined ): boolean {
    const collaborationDataList: DockItemInfo[] | undefined = AppStorage.get('collaborationDataList');
    if (collaborationDataList === undefined || bundleName === undefined) {
      return false;
    }
    for (let i = 0; i < collaborationDataList.length; i++) {
      if (bundleName === collaborationDataList[i].bundleName) {
        return true;
      }
    }
    return false;
  }

  private updateAllSuggestList(menuInfoList: Array<MenuInfo>): void {
    if (menuInfoList === undefined || menuInfoList === null) {
      return;
    }
    let fixedMenuList: MenuInfo[] = [];
    let dynamicMenuList: MenuInfo[] = [];
    for (let menuInfo of menuInfoList) {
      if (menuInfo.menuType === CommonConstants.MENU_TYPE_FIXED) {
        fixedMenuList.push(menuInfo);
      } else if (!GetHideAppsFromConfig.getInstance().isHideApp(menuInfo.bundleName) &&
        !this.isCollaboration(menuInfo.bundleName)) {
        dynamicMenuList.push(menuInfo);
      }
    }
    let isBothTypeMenuExist = fixedMenuList.length > 0 && dynamicMenuList.length > 0;
    AppStorage.setOrCreate('fixedMenuList', fixedMenuList);
    AppStorage.setOrCreate('dynamicMenuList', dynamicMenuList);
    AppStorage.setOrCreate('isBothTypeMenuExist', isBothTypeMenuExist);
  }

  private deleteSuggestInfoNotInAppList(): void {
    if (CheckEmptyUtils.isEmptyArr(this.mRecentList)) {
      return;
    }
    let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      return;
    }
    this.mRecentList = this.mRecentList.filter(item => this.isInAppList(item.bundleName));
    this.persistSuggestList();
  }

  private isInAppList(bundleName: string): boolean {
    let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      return true;
    }
    let index = appList.findIndex((appItem: AppItemInfo) => {
      return (appItem.bundleName === bundleName);
    });
    log.showInfo(`isInAppList ${bundleName}, ${index}`);
    if (index >= 0) {
      return true;
    }
    return false;
  }
}