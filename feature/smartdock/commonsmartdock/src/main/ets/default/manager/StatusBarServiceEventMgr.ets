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

import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  ResourceManager,
  WindowEvent,
  sEventManager,
  obtainLocalEvent,
  IconResourceManager,
  EventManager,
  EvtBus,
  GlobalContext,
  ProcessStateChangeEvent
} from '@ohos/frameworkwrapper';
import { DockItemInfo, MenuInfo, CommonConstants, ResidentLayoutCacheMgr,
  RecentLayoutCacheMgr } from '@ohos/launchercommon';
import {
  BundleInfo,
  StatusBarConnectEvent,
  StatusBarServiceEventManager,
  StatusBarServiceInfo,
  TrayManager } from '@ohos/statusbarextensionservice/src/main/ets/TsIndex';
import type ctx from '@ohos.app.ability.common';
// import statusBar from '@hms.pcService.statusBar';
import Want from '@ohos.app.ability.Want';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import SmartDockViewModel from '../viewmodel/SmartDockViewModel';
import { SCBSceneSessionManager } from '@ohos/windowscene';

const TAG = 'StatusBarServiceEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppManager {
  private appPidList: number[] = [];
  private tokenId: number = -1;
  private bundleName: string = '';
  private appInfo: DockItemInfo | undefined = undefined;
  private isEventRegistered: boolean = false;
  private statusBarGroupMenu?: ESObject[] = [];
  private isOnExit: boolean = false;

  constructor(bundleName: string, pid?: number) {
    this.bundleName = bundleName;
    if (pid !== undefined) {
      this.addPid(pid);
    }
  }

  getTokenId(): number {
    return this.tokenId;
  }

  getBundleName(): string {
    return this.bundleName;
  }

  getPidList(): number[] {
    return this.appPidList;
  }

  getPidListLength(): number {
    return this.appPidList.length;
  }

  getAppInfo(): DockItemInfo | undefined {
    if (!this.appInfo) {
      const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      for (let i = 0; i < residentList.length; i++) {
        if (residentList[i].bundleName === this.bundleName) {
          this.appInfo = residentList[i] as DockItemInfo;
          break;
        }
      }
      const recentDockList: DockItemInfo[] = RecentLayoutCacheMgr.getInstance().getAllDockItems();
      for (let i = 0; i < recentDockList.length; i++) {
        if (recentDockList[i].bundleName === this.bundleName) {
          this.appInfo = recentDockList[i];
          break;
        }
      }
    }
    return this.appInfo;
  }

  getIsOnExit(): boolean {
    return this.isOnExit;
  }

  setIsOnExit(isOnExit: boolean): void {
    this.isOnExit = isOnExit;
  }

  setTokenId(tokenId: number): void {
    this.tokenId = tokenId;
  }

  addPid(pid: number): void {
    if (!this.appPidList.includes(pid)) {
      this.appPidList.push(pid);
    }
  }

  deletePid(pid: number): void {
    if (this.appPidList.includes(pid)) {
      this.appPidList.splice(this.appPidList.indexOf(pid), 1);
    }
  }

  setStatusBarGroupMenu(groupMenu: ESObject[]): void {
    log.showInfo(`setStatusBarGroupMenu length: ${groupMenu?.length}`);
    this.statusBarGroupMenu = groupMenu;
  }

  private onExtendedMenuClick(menuAction?: ESObject): void {
    if (!menuAction) {
      return;
    }
    try {
      const want: Want = {
        bundleName: this.bundleName,
        abilityName: menuAction.abilityName,
        moduleName: menuAction.moduleName,
      };
      GlobalContext.getContext().startAbility(want);
      log.showInfo(`onExtendedMenuClick start ability succeed`);
    } catch (error) {
      log.showError(`onExtendedMenuClick start ability failed with ${error.code}`);
    }
  }

  private setSubMenu(menuList: ESObject[]): MenuInfo[] {
    const menuInfos: MenuInfo[] = [];
    if (!ArrayUtils.isEmpty(menuList)) {
      menuList.forEach((subMenu: ESObject) => {
        let menu: MenuInfo = new MenuInfo();
        menu.menuType = CommonConstants.MENU_TYPE_FIXED;
        menu.menuText = subMenu.subTitle;
        menu.onMenuClick = (params: Map<string, Object>): void => {
          log.showInfo(`click extendedMenu for app ${this.bundleName}`);
          this.onExtendedMenuClick(subMenu?.menuAction);
        };
        menuInfos.push(menu);
      });
    }
    return menuInfos;
  }

  private setMenuInfo(groupMenuList: ESObject): MenuInfo[] {
    const menuInfos: MenuInfo[] = [];
    if (!ArrayUtils.isEmpty(groupMenuList)) {
      groupMenuList.forEach((groupMenu: ESObject) => {
        if (!groupMenu) {
          return;
        }
        let menu: MenuInfo = new MenuInfo();
        menu.menuType = CommonConstants.MENU_TYPE_FIXED;
        menu.menuText = groupMenu.title;
        if (groupMenu.subMenu) {
          menu.subMenuList = this.setSubMenu(groupMenu.subMenu);
        }
        menu.onMenuClick = (params: Map<string, Object>): void => {
          log.showInfo(`click extendedMenu for app ${this.bundleName}`);
          this.onExtendedMenuClick(groupMenu.menuAction);
        };
        menuInfos.push(menu);
      });
    }
    return menuInfos;
  }

  private getExtendedMenu(): MenuInfo[] {
    const menuInfos: MenuInfo[] = [];
    if (this.statusBarGroupMenu) {
      this.statusBarGroupMenu.forEach((groupMenu: ESObject) => {
        menuInfos.push(...this.setMenuInfo(groupMenu));
      });
    }
    return menuInfos;
  }

  private getMoreMenu(): MenuInfo {
    let more: MenuInfo = new MenuInfo();
    more.menuType = CommonConstants.MENU_TYPE_FIXED;
    more.menuImgSrc = '/common/pics/ic_public_more.svg';
    more.menuText = $r('app.string.app_menu_more');
    more.onMenuClick = (params: Map<string, Object>): void => {
      log.showInfo(`click moreMenu for app ${this.bundleName}`);
      let event = new WindowEvent();
      event.windowName = this.bundleName;
      event.eventType = WindowEvent.EVENT_TYPE_SHOW;
      event.eventState = WindowEvent.EVENT_STATE_START;
      EvtBus.post(WindowEvent, event);
    };
    return more;
  }

  private getExitMenu(): MenuInfo {
    let exitMenu: MenuInfo = new MenuInfo();
    exitMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    exitMenu.menuImgSrc = '/common/pics/ic_public_quit.svg';
    exitMenu.menuText = $r('app.string.app_menu_exit');
    exitMenu.onMenuClick = (params: Map<string, Object>): void => {
      log.showInfo(`click exitMenu for app ${this.bundleName}`);
      StatusBarServiceEventMgr.getInstance().preExit(this.bundleName);
    };
    return exitMenu;
  }

  getMenu(): MenuInfo[] {
    return [...this.getExtendedMenu(), this.getMoreMenu(), this.getExitMenu()];
  }
}

export default class StatusBarServiceEventMgr {
  private static mInstance: StatusBarServiceEventMgr;
  private appInfoList: AppManager[] = [];
  private eventMgr: EventManager = EvtBus.createEventManager();

  static getInstance(): StatusBarServiceEventMgr {
    if (StatusBarServiceEventMgr.mInstance == null) {
      StatusBarServiceEventMgr.mInstance = new StatusBarServiceEventMgr();
    }
    return StatusBarServiceEventMgr.mInstance;
  }

  public getRegisterBundleNameList(): string[] {
    return this.appInfoList.map((item: AppManager) => item.getBundleName());
  }

  public isRegisterApp(bundleName: string): boolean {
    return this.appInfoList.map((item: AppManager) => item.getBundleName()).includes(bundleName);
  }

  private deleteAppInfoByTokenId(tokenId: number): void {
    this.appInfoList.splice(this.appInfoList.findIndex((item: AppManager) => item?.getTokenId() === tokenId), 1);
  }

  public getAppInfoByBundleName(bundleName: string): AppManager | undefined {
    return this.appInfoList.find((item: AppManager) => item.getBundleName() === bundleName);
  }

  private getAppInfoByTokenId(tokenId: number): AppManager | undefined {
    return this.appInfoList.find((item: AppManager) => item.getTokenId() === tokenId);
  }

  /**
   * pad的自由多窗模式下，进程监听事件
   */
  private appProcessChange = (event: ProcessStateChangeEvent): void => {
    log.showInfo(`appProcessChange : ${event.bundleName}, ${event.requestPid}, ${event.visible}`);
    if (!event.requestPid) {
      return;
    }

    let appManager: AppManager | undefined = this.getAppInfoByBundleName(event.bundleName);
    if (!appManager) {
      appManager = new AppManager(event.bundleName, event.requestPid);
      this.appInfoList.push(appManager);
    }

    let sendStatus: boolean = true;
    if (appManager.getPidListLength() > 0 && event.visible) {
      sendStatus = false;
      appManager.setIsOnExit(false);
    }

    let openAppNameList = AppStorage.get('openAppNameList') as Array<string>;

    // 打开
    if (event.visible) {
      appManager.addPid(event.requestPid);
    }
    // 关闭
    if (!event.visible) {
      appManager.deletePid(event.requestPid);
      TrayManager.getOrCreateTrayManager().tokenIdProcessExit(appManager.getTokenId(), event.requestPid);
    }
    log.showInfo(`pidLength: ${appManager.getPidListLength()}`);
    if (appManager.getPidListLength() > 0 && !appManager.getIsOnExit()) {
      this.updateAppNameListByBundleName(event.bundleName);
    } else if (appManager.getPidListLength() === 0) {
      // wps的所有进程全部关闭
      if (!CheckEmptyUtils.isEmptyArr(openAppNameList) && openAppNameList.includes(event.bundleName)) {
        openAppNameList.splice(openAppNameList.indexOf(event.bundleName), 1);
        AppStorage.setOrCreate('openAppNameList', openAppNameList);
        const containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
        SmartDockViewModel.getInstance().initRecentDataList(containerSessionList, TAG);
      }

      const tokenId: number = appManager.getTokenId();
      TrayManager.getOrCreateTrayManager().deleteTrayForApp(tokenId);
      this.deleteAppInfoByTokenId(tokenId);
    }
    if (sendStatus) {
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(
        SmartDockConstants.DOCK_MENU_CHANGE_EVENT, event.bundleName);
    }
  };

  /**
   * wps窗口启动的监听事件
   */
  private windowInfoCallback = (serviceInfo: StatusBarServiceInfo): void => {
    if (!serviceInfo) {
      log.showError(`serviceInfo is undefined`);
      return;
    }
    log.showInfo(`windowInfoCallback bundleName: ${serviceInfo.bundleName}`);

    if (serviceInfo.type === StatusBarConnectEvent.UPDATE_QUICK_OPERATION_HEIGHT) {
      log.showWarn('serviceInfo update height');
      this.updateUnreadMessageWindow('updateHeight', serviceInfo);
      return;
    }
    if (serviceInfo.type !== StatusBarConnectEvent.ADD_TO_STATUS_BAR) {
      log.showWarn(`serviceInfo type is ${serviceInfo.type}, not add`);
      return;
    }

    const appManager: AppManager | undefined = this.getAppInfoByBundleName(serviceInfo.bundleName);
    if (!appManager) {
      log.showError('windowInfoCallback error: appManager is undefined');
      return;
    }
    if (serviceInfo?.data?.statusBarItem?.statusBarGroupMenu) {
      appManager.setStatusBarGroupMenu(serviceInfo?.data?.statusBarItem?.statusBarGroupMenu);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(
        SmartDockConstants.DOCK_MENU_CHANGE_EVENT, serviceInfo.bundleName);
    }
    const tokenId: number = appManager.getTokenId();
    if (tokenId !== serviceInfo.tokenId) {
      if (tokenId !== -1) {
        // 删除旧托盘
        TrayManager.getOrCreateTrayManager().deleteTrayForApp(tokenId);
      }
      TrayManager.getOrCreateTrayManager().createTrayForApp(serviceInfo.tokenId, serviceInfo.bundleName,
        [serviceInfo.pid]);
      appManager.setTokenId(serviceInfo.tokenId);
    }
    this.updateUnreadMessageWindow('add', serviceInfo);
    appManager.addPid(serviceInfo.pid);
    this.updateAppNameListByBundleName(serviceInfo.bundleName);
  };

  private updateUnreadMessageWindow(updateState: string, serviceInfo: StatusBarServiceInfo): void {
    let height: number | undefined;
    if (updateState === 'add') {
      height = serviceInfo.data?.statusBarItem?.quickOperation.height;
    } else if (updateState === 'updateHeight') {
      height = serviceInfo.data?.operationHeight;
    } else {
      height = undefined;
    }
    this.publishUnreadMessageTitleInfo(updateState, height,
      serviceInfo.data?.statusBarItem?.quickOperation?.abilityName,
      serviceInfo.data?.statusBarItem?.quickOperation?.moduleName, serviceInfo.bundleName);
  }

  private publishUnreadMessageTitleInfo(updateState: string, height: number | undefined,
    abilityName: string | undefined, moduleName: string | undefined, bundleName: string): void {
    log.showInfo(`publishUnreadMessageTitleInfo: ${bundleName}`);
    const appManager: AppManager | undefined = this.getAppInfoByBundleName(bundleName);
    if (!appManager) {
      log.showError('publishUnreadMessageTitleInfo error: appManager is undefined');
      return;
    }
    const appInfo = appManager.getAppInfo();
    if (!appInfo) {
      log.showError(`appInfo is undefintd`);
      return;
    }
    // 先异步获取名称和图标，然后传递wps的信息到“未读消息”窗口，用于窗口的标题
    ResourceManager.getInstance().getAppNameWithCache(
      appInfo?.appLabelId, appInfo?.bundleName, appInfo?.moduleName, appInfo?.appName,
      (name: string): void => {
        IconResourceManager.getInstance().getCombIcon(
          appInfo?.bundleName, appInfo?.moduleName, appInfo?.abilityName, undefined, 'CombIcon_publishUnreadMessage'
        ).then((iconResource: string | PixelMap) => {
          log.showInfo(`updateWpsInfo state: ${updateState}, label: ${name}, height: ${height}`);
          sEventManager.publish(obtainLocalEvent('FloatingSceneEvent', {
            bundleName: appInfo?.bundleName,
            abilityName: abilityName,
            moduleName: moduleName,
            dockBundleName: appInfo?.bundleName,
            dockAbilityName: appInfo?.abilityName,
            dockModuleName: appInfo?.moduleName,
            label: name,
            height: height,
            state: updateState,
            icon: iconResource,
          }));
        });
      });
  }

  /**
   * 服务启动的监听事件
   */
  private trayServiceCallback = (tokenId: number, pid: number, instanceKey: string, isDetached: boolean): void => {
    const appManager: AppManager | undefined = this.getAppInfoByTokenId(tokenId);
    if (!appManager) {
      log.showError('trayServiceCallback error: appManager is undefined');
      return;
    }
    this.updateAppNameListByBundleName(appManager.getBundleName());
  };

  private updateAppNameListByBundleName(bundleName: string): void {
    let openAppNameList = AppStorage.get('openAppNameList') as Array<string>;
    if (!openAppNameList) {
      openAppNameList = [];
    }
    if (!openAppNameList.includes(bundleName)) {
      openAppNameList.push(bundleName);
      AppStorage.setOrCreate('openAppNameList', openAppNameList);
    }
    log.showInfo(`now openAppNameList size : ${openAppNameList.length}`);
  }

  /**
   * 一步直达退出
   */
  public preExit(bundleName: string): void {
    const appManager: AppManager | undefined = this.getAppInfoByBundleName(bundleName);
    if (!appManager) {
      log.showError('preExit error: appManager is undefined');
      return;
    }
    TrayManager.exitTrayProcess(appManager.getPidList());
    let openAppNameList = AppStorage.get('openAppNameList') as Array<string>;
    const isInList: boolean = !CheckEmptyUtils.isEmptyArr(openAppNameList) && openAppNameList.includes(bundleName);
    log.showInfo(`preExit bundleName: ${bundleName}, isInList: ${isInList}`);
    if (isInList) {
      openAppNameList.splice(openAppNameList.indexOf(bundleName), 1);
      AppStorage.setOrCreate('openAppNameList', openAppNameList);
    }
    appManager.setIsOnExit(true);
  }

  private callbackfn = (bundleInfo: BundleInfo, key: number, instanceKey: string) : void => {
    let appManager: AppManager | undefined = this.getAppInfoByBundleName(bundleInfo.bundleName);
    if (!appManager) {
      appManager = new AppManager(bundleInfo.bundleName);
    }
    appManager.setTokenId(key);
    bundleInfo.pids.forEach((pid: number) => {
      appManager?.addPid(pid);
    });
    bundleInfo.backPids.forEach((pid: number) => {
      appManager?.addPid(pid);
    });
    if (appManager.getPidListLength() > 0) {
      this.updateAppNameListByBundleName(bundleInfo.bundleName);
      // 延迟发送消息，需等待dock图标列表已经更新，才能获取wps图标信息
      setTimeout(() => {
        this.publishUnreadMessageTitleInfo('add',
          bundleInfo.data?.quickOperation.height,
          bundleInfo.data?.quickOperation.abilityName,
          bundleInfo.data?.quickOperation.moduleName,
          bundleInfo.bundleName);
      }, 200);
    }
  }

  private queryExistingPid(): void {
    TrayManager.getOrCreateTrayManager().forEach(this.callbackfn);
  }

  // 是否是wps且已注册一步直达
  public isWpsAndRegister(bundleName: string): boolean {
    if (!DeviceHelper.isPad() && !DeviceHelper.isLargeScreenDevice()) {
      return false;
    }
    return bundleName === 'cn.wps.office.hap' && this.isRegisterApp(bundleName);
  }

  public registerStatusBarServiceEventListener(): void {
    log.showInfo('register statusBarService event listener');
    this.eventMgr.on(ProcessStateChangeEvent, this.appProcessChange);
    // 注册整体托盘后台进程创建回调
    TrayManager.getOrCreateTrayManager().registerTrayManagerListener(this.trayServiceCallback);
    // 注册窗口创建信息监听
    StatusBarServiceEventManager.getInstance().registerStatusBarServiceEvent(this.windowInfoCallback);
    // 查询"监听注册之前"已经存在的进程
    this.queryExistingPid();
  }

  public unregisterStatusBarServiceEventListener(): void {
    log.showInfo('unregister statusBarService event listener');
    this.eventMgr.offAll();
    StatusBarServiceEventManager.getInstance().unRegisterStatusBarEvent(this.windowInfoCallback);
    TrayManager.getOrCreateTrayManager().unRegisterTrayManagerListener(this.trayServiceCallback);
  }

  public getAppManagerMenuByBundleName(bundleName: string): MenuInfo[] {
    if (!DeviceHelper.isPad() && !DeviceHelper.isLargeScreenDevice()) {
      return [];
    }
    if (!this.isRegisterApp(bundleName)) {
      log.showError(`getAppManagerMenuByBundleName error: ${bundleName} is not register`);
      return [];
    }
    const appManager: AppManager | undefined = this.getAppInfoByBundleName(bundleName);
    if (!appManager) {
      log.showError('getAppManagerMenuByBundleName error: appManager is undefined');
      return [];
    }
    return appManager.getMenu();
  }
}