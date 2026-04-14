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
  CloseAppManager,
  CommonConstants,
  MenuInfo,
  StartSubtype,
  DockItemInfo,
  RecentBundleMissionInfo,
  EventConstants,
  AppModel,
  AppItemInfo,
  AppCenterModel,
  ResidentLayoutCacheMgr,
  DeleteDockItem
} from '@ohos/launchercommon';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  StartType,
  SingletonHelper,
  RectInfo
} from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { ItemUtils } from '@ohos/componenthelper';
import {
  DeviceHelper,
  GlobalContext,
  HiSysEventUtil,
  EvtBus,
  WindowEvent,
  viewMgrPolicy,
  ViewType,
  localEventManager,
  ResourceManager,
  sOutSideWindowMgr
} from '@ohos/frameworkwrapper';
import {
  FocusChangeReason,
  SCBSceneSessionManager,
  StartAbilityUtil,
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBSceneContainerSessionArray,
  ExecuteCallbackExtraInfo,
  SCBSceneInfo,
  SCBSceneResourceManager,
} from '@ohos/windowscene';

import {
  FormModel,
  FormCenterViewManager
} from '@ohos/launchercommon';

import { KeyConstants } from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';

import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import { DockItemPosition } from '@ohos/smartdock/src/main/ets/default/common/DockItemPosition';
import { SmartDockEventMgr } from '@ohos/smartdock/src/main/ets/default/manager/SmartDockEventMgr';

import SmartDockCloseAppHandler from '@ohos/smartdock/src/main/ets/default/common/SmartDockCloseAppHandler';
import { PcDockHiSysEventMgr } from './PcDockHiSysEventMgr';
import { appManager } from '@kit.AbilityKit';
import { TrayManager } from '@ohos/statusbarextensionservice/src/main/ets/TsIndex';
import { FixedDockResource } from '../common/constants/FixedDockConstants';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { ShortcutViewModel} from '@ohos/launchercommon/src/main/ets/TsIndex';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { PcSmartDockModel, RecycleBinRecord } from '../model/PcSmartDockModel';
import PcModeContinuableModel from '@ohos/smartdock/src/main/ets/default/pcmode/model/PcModeContinuableModel';
import { PcDockRecentProxy } from './PcDockRecentProxy';
import { PcDockIndepentIconMgr } from './PcDockIndependentIconMgr';
import { BusinessError } from '@kit.BasicServicesKit';
import { IconType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { PCDockUtils } from '../utils/PCDockUtils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { HashMap } from '@kit.ArkTS';

const TAG = 'PcSmartDockEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);
const LINUX_APPLICATION = '2';

const CALLUI_BUNDLE = 'com.ohos.callui';

/**
 * PcSmartDockEventMgr 暂时以phone的manager为基类，后面抽出公用类之后，替换基类
 */
export class PcSmartDockEventMgr extends SmartDockEventMgr {
  private static instance: PcSmartDockEventMgr;
  private clickBundleName: string = '';
  private persistentId: number = 0;
  private readonly mPcSmartDockCloseAppHandler: SmartDockCloseAppHandler;

  private constructor() {
    super();
    if (DeviceHelper.isPC()) {
      super.mSmartDockModel = PcSmartDockModel.getInstance();
    }
    super.mSmartDockModel = PcSmartDockModel.getInstance();
    this.mPcSmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
    CloseAppManager.getInstance().registerCloseAppHandler(this.mPcSmartDockCloseAppHandler);
    SCBSceneSessionManager.getInstance()?.registerDestroyFloatWindowCallback(this.doDestroyFloatCallback, 0);
    log.showInfo('Launcher PcSmartDockEventMgr constructor!');
  }

  public static getInstance(): PcSmartDockEventMgr {
    if (!PcSmartDockEventMgr.instance) {
      PcSmartDockEventMgr.instance = new PcSmartDockEventMgr();
    }
    return PcSmartDockEventMgr.instance;
  }

  /**
   * build menu for @Component CustomOverlay
   * @param appInfo
   * @param dockType
   * @param callback
   * @param screenId
   */
  public buildMenuInfoList(appInfo: DockItemInfo, dockType: number, formDialog?: CustomDialogController | null,
    callback?: Function, screenId?: number): MenuInfo[] {
    const menuInfoList: MenuInfo[] = [];
    const isNeedAddToDesktop = this.needAddToDesktop(appInfo);
    if (appInfo.abilityName !== CommonConstants.RECYCLE_BIN_ABILITY &&
      appInfo.abilityName !== CommonConstants.RECENT_ABILITY) {
      let formMenu: MenuInfo = this.getFormMenu(appInfo);
      if (formMenu.menuImgSrc) {
        menuInfoList.push(formMenu);
      }
    }

    // 非快捷方式，普通应用图标，右键菜单中包含快捷方式
    const isShortcut = this.isShortcut(appInfo);
    if (!isShortcut) {
      ShortcutViewModel.getInstance().checkShortCutInfo(appInfo, menuInfoList, screenId);
    }
    if (appInfo.itemType !== CommonConstants.TYPE_FUNCTION && CheckEmptyUtils.isEmpty(appInfo.persistentId) &&
      isNeedAddToDesktop) {
      menuInfoList.push(this.buildMenuAddToDesktop(appInfo));
    }
    if (this.needRemoveFromDock(appInfo, dockType)) {
      menuInfoList.push(this.buildMenuRemoveFromDock(appInfo, dockType));
    }
    let noAppDesktopIconList: string[] | undefined = AppStorage.get('noAppDesktopIconList');
    if (appInfo.itemType !== CommonConstants.TYPE_FUNCTION &&
      dockType === SmartDockConstants.RECENT_DOCK_TYPE &&
      !noAppDesktopIconList?.includes(appInfo.bundleName) && CheckEmptyUtils.isEmpty(appInfo.persistentId) &&
      !isShortcut) {
      menuInfoList.push(this.addToDockMenu(appInfo));
    }
    if (appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      menuInfoList.push(this.getRecycleBinClearMenu(screenId));
    }
    return menuInfoList;
  }

  private needRemoveFromDock(appInfo: DockItemInfo, dockType: number): boolean {
    if (appInfo.itemType !== CommonConstants.TYPE_FUNCTION && dockType === SmartDockConstants.RESIDENT_DOCK_TYPE &&
      !PCDockUtils.isPcFileManager(appInfo.bundleName)) {
      return true;
    }
    return false;
  }

  private needAddToDesktop(appInfo: DockItemInfo): boolean {
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

  public residentOnClickWithDisplay(screenId: number, event: ClickEvent | null, item: DockItemInfo,
    startNewAbility: boolean = false, callback?: Function | null, params?: Map<string, Object>): boolean {
    if (!item) {
      log.showInfo(`item is invalid`);
      return false;
    }
    log.showInfo(`residentOnClick bundleName:${item?.bundleName}, abilityName:${item?.abilityName} - ${screenId}`);
    if (DeviceHelper.is2In1DevicePcType() && viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
      sOutSideWindowMgr.hideGlobalSearch();
    }
    if (item?.abilityName === CommonConstants.APPCENTER_ABILITY) {
      this.appCenterEntry(item, screenId);
      return false;
    }

    if (item?.abilityName === CommonConstants.RECENT_ABILITY) {
      const dType = screenId === SCBSceneSessionManager.getInstance().mainScreenId ? PcDockHiSysEventMgr.PRIMARY_SCREEN
        : PcDockHiSysEventMgr.SECONDARY_SCREEN;
      this.recentEntry(item, dType);
      return false;
    }

    viewMgrPolicy.hideView(ViewType.RECENT);

    if (item?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      this.handleClickRecycleBin(screenId, item, params);
      return false;
    }

    // app entry
    if (startNewAbility) {
      // set start app info
      log.showDebug(`start new application`);
      this.setStartAppInfo(item);
      if (this.isShortcut(item)) {
        this.shortcutOnClick(item);
      } else {
        params?.set(SCBConstants.START_APP_CLONE_INDEX, item.appIndex ?? 0);
        params?.set(KeyConstants.ITEM_RECT, ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
          'SmartDock_AppIcon', item.bundleName as string, item.abilityName as string, item.appIndex as number, item.appInstanceKey as string)));
        StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params, screenId);
      }
      return false;
    } else {
      return this.recentOnClickWithDisplay(screenId, event, item, startNewAbility, callback);
    }
  }

  public recentOnClickWithDisplay(screenId: number, event: ClickEvent | null, item: DockItemInfo,
    startNewAbility: boolean = false, callback?: Function | null): boolean {
    log.showInfo(`recentOnClick, item.shortcutId: ${item?.shortcutId} - ${screenId}`);
    if (this.isShortcut(item)) {
      this.shortcutOnClick(item);
      return false;
    }
    const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
    const appInstanceKey: string = item?.appInstanceKey ?? '';
    log.showInfo(`recentOnClick bundleName: ${item.bundleName}, appInstanceKey: ${appInstanceKey}, missionInfoList.length: ${missionInfoList?.length}`);
    if (missionInfoList && !CheckEmptyUtils.isEmptyArr(missionInfoList)) {
      for (let i = 0; i < missionInfoList.length; i++) {
        if (this.mSmartDockModel.checkSameDockItem(missionInfoList[i], item) &&
          (missionInfoList[i].persistentId ?? '') === (item.persistentId ?? '') &&
          missionInfoList[i].missionInfoList.length === 1) {
          this.persistentId = missionInfoList[i].missionInfoList[0].getPersistentId();
          break;
        }
      }
      this.clickBundleName = item.bundleName;
      const frontContainerSession: SCBSceneContainerSession | undefined = this.queryFrontSession(screenId);
      const frontBundleName = frontContainerSession?.primarySession?.sceneInfo?.bundleName;
      if (frontBundleName !== undefined) {
        log.showInfo(`clickBundleName and frontBundleName are same: ${frontBundleName === this.clickBundleName}`);
        log.showInfo(`frontBundleName : ${frontBundleName}`);
      }
      for (let i = 0; i < missionInfoList.length; i++) {
        if (this.mSmartDockModel.isSameDockItem(missionInfoList[i], item) &&
          (missionInfoList[i].persistentId ?? '') === (item.persistentId ?? '')) {
          const missionList: SCBSceneContainerSession[] =
            missionInfoList[i]?.missionInfoList as SCBSceneContainerSession[];
          log.showInfo(`recentOnClick missionList.length: ${missionList?.length}, bundleName: ${item?.bundleName}, appIndex: ${item?.appIndex}`);
          if (DeviceHelper.is2In1DevicePcType() && viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
            sOutSideWindowMgr.hideGlobalSearch();
          }
          if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
            let hideAppCenterWithAnimation = (GlobalContext.getInstance()
              .getObject('hideAppCenterWithAnimation')) as Function;
            hideAppCenterWithAnimation();
          }
          if (CheckEmptyUtils.isEmptyArr(missionList)) {
            log.showInfo('recentOnClick missionList is empty');
            return false;
          }
          if ((missionList.length > 1 || PcModeContinuableModel.getInstance().isOpenPopupOnContinuableItem) &&
            callback) {
            log.showInfo('recentOnClick callback recentOnClickWithPopup');
            callback();
            return true;
          }
          if (this.checkOnClickDlpStartApp(missionList, item)) {
            break;
          }
          if (missionList.length === 1 && missionList[0]) {
            this.handleSingleMission(missionList[0], item, screenId, frontContainerSession);
          }
          return false;
        }
      }
    }

    if (!startNewAbility) {
      let lastInstanceKey: string = sceneSessionManager.getLastInstanceKey(item?.bundleName);
      log.showInfo(`recentOnClick New ${screenId} ${lastInstanceKey}`);
      this.setStartAppInfo(item);
      let params = new Map<string, Object>();
      params.set(SCBConstants.START_APP_CLONE_INDEX, item.appIndex ?? 0);
      params.set(KeyConstants.ITEM_RECT, ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
        'SmartDock_AppIcon', item.bundleName as string, item.abilityName as string, item.appIndex as number, item.appInstanceKey as string)));
      if (item?.enableNewAppInstance && CheckEmptyUtils.checkStrIsEmpty(lastInstanceKey)) {
        params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
      }
      StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params, screenId);
    }
    return false;
  }

  private handleClickRecycleBin(screenId: number, item: DockItemInfo, params?: Map<string, Object>): void {
    log.showInfo('handleClickRecyleBin');
    this.setStartAppInfo(item);
    const status: RecycleBinRecord = PcSmartDockModel.getInstance().getRecycleBinStatus();
    if (status.persistentId !== -1 && (AppStorage.get('showRecent') || AppCenterModel.getInstance().isShow(screenId))) {
      log.showInfo(`move scene to front : recyclebin status: ${JSON.stringify(status)}`);
      if (AppCenterModel.getInstance().isShow(screenId)) {
        AppCenterModel.getInstance().hideAppCenterWithAnimation(screenId);
      }
      SCBSceneSessionManager.getInstance().startSceneFromRecent(status.screenId, status.persistentId);
      SCBSceneSessionManager.getInstance().requestFocus(status.screenId, false);
    } else {
      if (DeviceHelper.is2In1DevicePcType() && PCDockUtils.isFilesBundleExist()) {
        StartAbilityUtil.startLauncherAbilityByWant({
          bundleName: 'com.ohos.files',
          abilityName: 'EntryAbility',
          moduleName: 'entry',
          parameters: {
            'fileManagerMode': 'RecycleBin',
            startParams: params,
          }
        }, screenId);
      } else {
        StartAbilityUtil.startLauncherAbilityByWant({
          bundleName: 'com.ohos.filemanager',
          abilityName: 'MainAbility',
          moduleName: 'pc',
          parameters: {
            'fileManagerMode': 'RecycleBin',
            startParams: params,
          }
        }, screenId);
      }
    }
  }

  private handleSingleMission(mission: SCBSceneContainerSession, item: DockItemInfo,
    screenId: number, frontContainerSession: SCBSceneContainerSession | undefined): void {
    if (mission.isSplit) {
      this.moveSessionUpFrontSplit(mission, item);
      return;
    }
    this.setStartAppInfo(item);
    let extraInfo: ExecuteCallbackExtraInfo = {};
    if (PCDockUtils.isPcFileManager(item?.bundleName)) {
      extraInfo.isClickByPcDockFileManager = true;
      log.showInfo('is Click on file manager');
    }
    if (this.needMinimizeMission(mission, item, screenId, frontContainerSession)) {
      SCBSceneSessionManager.getInstance().minimize(mission.primarySession?.sceneInfo.screenId,
        mission?.primarySession?.sceneInfo.persistentId, mission.containerId, undefined, extraInfo);
    } else {
      this.moveSessionUpFront(mission?.primarySession, mission.containerId, undefined, extraInfo);
    }
  }

  private needMinimizeMission(mission: SCBSceneContainerSession,
    item: DockItemInfo, evtScreenId: number,
    frontContainerSession: SCBSceneContainerSession | undefined): boolean {
    if (!mission.isActive) {
      return false;
    }
    if (this.checkSameDockItemBySceneInfo(frontContainerSession?.primarySession?.sceneInfo, item)) {
      return true;
    }

    if (mission.primarySession?.sceneInfo?.screenId === evtScreenId ) {
      return false;
    }
    let frontContainerSession2 = this.queryFrontSession(mission?.primarySession?.sceneInfo.screenId);
    log.showInfo(`1needMinimizeMission ${mission.primarySession?.sceneInfo?.screenId}-${evtScreenId}`);
    return this.checkSameDockItemBySceneInfo(frontContainerSession2?.primarySession?.sceneInfo, item);
  }

  public checkSameDockItemBySceneInfo(sceneInfo?: SCBSceneInfo,
    item?: RecentBundleMissionInfo | DockItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(sceneInfo) || CheckEmptyUtils.isEmpty(item)) {
      return false;
    }
    if (PCDockUtils.isDlpIndex(sceneInfo?.appIndex ?? 0)) {
      return sceneInfo?.bundleName === item?.bundleName &&
        item?.appIndex === 0 &&
        this.mSmartDockModel.checkAppInstanceKey(sceneInfo?.appInstanceKey, item?.appInstanceKey);
    } else {
      return PCDockUtils.isSameBundle(sceneInfo?.bundleName, item?.bundleName) &&
        sceneInfo?.appIndex === item?.appIndex &&
        this.mSmartDockModel.checkAppInstanceKey(sceneInfo?.appInstanceKey, item?.appInstanceKey);
    }
  }

  /**
   * 应用图标在常驻区，未通过点击dock栏图标拉起主窗口，此时通过dlp拉起该应用的窗口(dlp窗口是一个独立进程)，该窗口会绑定到常驻区应用图标，
   * 此时再点击常驻区应用图标则只能将dlp窗口推前台会置后台，故常驻区图标只绑定有一个dlp窗口时，应该允许点击该常驻区应用图标
   * 拉起主窗口(主窗口也是一个独立进程)
   * 当前IT版本，cn.wps.office.hap.ent.openharmony应用有该场景
   */
  private checkOnClickDlpStartApp(missionList: SCBSceneContainerSession[], item: AppItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmptyArr(missionList)) {
      return false;
    }
    if (missionList.length === 1 && missionList[0] && this.isClickResidentDlpItem(item, missionList[0])) {
      return true;
    }
    return false;
  }

  private isClickResidentDlpItem(item: AppItemInfo, mission: SCBSceneContainerSession): boolean {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmpty(mission) ||
      CheckEmptyUtils.isEmpty(mission.primarySession) || CheckEmptyUtils.isEmpty(mission?.primarySession?.sceneInfo)) {
      return false;
    }
    let itemList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const index = itemList.findIndex((dockItem: DockItemInfo) => {
      return this.mSmartDockModel.isSameDockItem(dockItem, item);
    });
    if (index < 0) {
      return false;
    }
    if (PCDockUtils.isDlpIndex(mission?.primarySession?.sceneInfo.appIndex ?? 0)) {
      log.showInfo(`isClickResidentDlpItem dlp item:${item.bundleName}-${item.abilityName}-${item.appIndex},${mission?.primarySession?.sceneInfo.appIndex}`);
      return true;
    }
    return false;
  }

  private buildMenuAddToDesktop(appInfo: DockItemInfo): MenuInfo {
    if (!appInfo) {
      throw new Error('appInfo is required to build the menu.');
    }
    const addToWorkSpaceMenu = new MenuInfo();
    addToWorkSpaceMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    addToWorkSpaceMenu.menuImgSrc = '/common/pics/ic_public_copy.svg';
    addToWorkSpaceMenu.menuText = $r('app.string.app_center_menu_add_desktop');
    addToWorkSpaceMenu.onMenuClick = async (): Promise<void> => {
      log.showInfo(`onMenuClick item add to pageDesk: ${appInfo?.bundleName}`);
      this.mSmartDockModel.addToPageDesk(appInfo);
    };
    return addToWorkSpaceMenu;
  }

  private buildMenuRemoveFromDock(appInfo: DockItemInfo, dockType: number): MenuInfo {
    const removeMenu = new MenuInfo();
    removeMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    removeMenu.menuImgSrc = '/common/pics/ic_public_remove.svg';
    removeMenu.menuText = $r('app.string.remove_from_dock');
    removeMenu.onMenuClick = (): void => {
      log.showInfo(`onMenuClick item remove: ${appInfo?.bundleName}, dockType: ${dockType}`);
      // 规避方案，待dialog窗口化需求落地修改
      this.mSelectedItem = appInfo;
      this.mSelectedDockType = dockType;
      const dockItem: DeleteDockItem =
        {
          bundleName: appInfo.bundleName,
          keyName: appInfo.keyName,
          shortcutId: appInfo.shortcutId,
          appIndex: appInfo.appIndex
        };
      this.deleteDockItem(dockItem, this.mSelectedDockType);
    };
    removeMenu.menuEnabled = appInfo.isUninstallAble ?? false;
    return removeMenu;
  }

  protected getContainerSessionList(): SCBSceneContainerSessionArray {
    log.showInfo('getContainerSessionList pc');
    return SCBSceneSessionManager.getInstance().getAllContainerSessionList();
  }

  /**
   * resident dock item onClick function
   * @param event
   * @param item
   * @param callback
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  public residentOnClick(event: ClickEvent | null, item: DockItemInfo, startNewAbility: boolean = false,
    callback?: Function | null, params?: Map<string, Object>): boolean {
    if (!item) {
      log.showInfo(`item is invalid`);
      return false;
    }
    log.showInfo(`residentOnClick bundleName:${item?.bundleName}, abilityName:${item?.abilityName}`);
    if (item?.abilityName === CommonConstants.APPCENTER_ABILITY) {
      this.appCenterEntry(item);
      return false;
    }

    if (item?.abilityName === CommonConstants.RECENT_ABILITY) {
      this.recentEntry(item, PcDockHiSysEventMgr.PRIMARY_SCREEN);
      return false;
    }

    viewMgrPolicy.hideView(ViewType.RECENT);

    if (item?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      this.setStartAppInfo(item);
      StartAbilityUtil.startAbility({
        bundleName: 'com.ohos.filemanager',
        abilityName: 'MainAbility',
        moduleName: 'pc',
        parameters: {
          'fileManagerMode': 'RecycleBin',
          startParams: params,
        }
      });
      return false;
    }

    // app entry
    if (startNewAbility) {
      // set start app info
      log.showDebug(`start new application`);
      this.setStartAppInfo(item);
      if (this.isShortcut(item)) {
        this.shortcutOnClick(item);
      } else {
        StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params);
      }
      return false;
    } else {
      return this.recentOnClick(event, item, startNewAbility, callback);
    }
  }

  public recentOnClick(event: ClickEvent | null, item: DockItemInfo, startNewAbility: boolean = false,
    callback?: Function | null): boolean {
    log.showInfo(`recentOnClick, item.shortcutId: ${item?.shortcutId}`);
    if (this.isShortcut(item)) {
      this.shortcutOnClick(item);
      return false;
    }
    const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
    log.showInfo(`recentOnClick bundleName: ${item.bundleName},appIndex:${item?.appIndex}, missionInfoList.length: ${missionInfoList?.length}`);
    if (missionInfoList && !CheckEmptyUtils.isEmptyArr(missionInfoList)) {
      this.clickBundleName = item.bundleName;
      const frontContainerSession = this.queryFrontSession();
      const frontBundleName = frontContainerSession?.primarySession?.sceneInfo?.bundleName;
      const appIndex = frontContainerSession?.primarySession?.sceneInfo?.appIndex;
      if (frontBundleName !== undefined) {
        log.showInfo(`clickBundleName and frontBundleName are same: ${frontBundleName === this.clickBundleName}`);
      }
      for (let i = 0; i < missionInfoList.length; i++) {
        if (missionInfoList[i].bundleName === item.bundleName && missionInfoList[i]?.appIndex === item?.appIndex) {
          const missionList: SCBSceneContainerSession[] =
            missionInfoList[i]?.missionInfoList as SCBSceneContainerSession[];
          log.showInfo(`recentOnClick missionList.length: ${missionList?.length}, bundleName: ${item?.bundleName}`);
          if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
            let hideAppCenterWithAnimation = (GlobalContext.getInstance()
              .getObject('hideAppCenterWithAnimation')) as Function;
            hideAppCenterWithAnimation();
          }
          if (CheckEmptyUtils.isEmptyArr(missionList)) {
            log.showInfo('recentOnClick missionList is empty');
            return false;
          }
          if (missionList.length > 1 && callback) {
            log.showInfo('recentOnClick callback recentOnClickWithPopup');
            callback();
            return true;
          }
          if (missionList.length === 1 && missionList[0]) {
            if (missionList[0].isSplit) {
              this.moveSessionUpFrontSplit(missionList[0], item);
              return false;
            }
            this.setStartAppInfo(item);
            if (missionList[0].isActive && frontBundleName === item.bundleName && appIndex === item?.appIndex) {
              let extraInfo: ExecuteCallbackExtraInfo = {};
              if (PCDockUtils.isPcFileManager(item?.bundleName)) {
                extraInfo.isClickByPcDockFileManager = true;
              }

              let sceneInfo: SCBSceneInfo | undefined = missionList[0]?.primarySession?.sceneInfo;
              SCBSceneSessionManager.getInstance().minimize(sceneInfo?.screenId,
                sceneInfo?.persistentId, missionList[0].containerId, undefined, extraInfo);
            } else {
              this.moveSessionUpFront(missionList[0].primarySession, missionList[0].containerId);
            }
          }
          return false;
        }
      }
    }

    if (!startNewAbility) {
      this.setStartAppInfo(item);
      let params = new Map<string, Object>();
      params.set(SCBConstants.START_APP_CLONE_INDEX, item.appIndex ?? 0);
      params.set(KeyConstants.ITEM_RECT, ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
        'SmartDock_AppIcon', item.bundleName as string, item.abilityName as string, item.appIndex as number, item.appInstanceKey as string)));
      StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params);
    }
    return false;
  }

  /**
   * set start app info
   */
  protected setStartAppInfo(item: DockItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('setStartAppInfo without item');
      return;
    }
    log.showDebug('setStartAppType: DOCK_APP');
    CloseAppManager.getInstance().setStartAppType(StartType.DOCK_APP);
  }

  public getWpsUnreadMessageMenu(appInfo: DockItemInfo): MenuInfo {
    let currentMenu = new MenuInfo();
    currentMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    currentMenu.menuText = $r('app.string.app_menu_exit');
    currentMenu.menuKeyString = 'appWpsUnreadMessage';
    currentMenu.onMenuClick = (params: Map<string, Object>): void => {
      log.showInfo(`click unreadMessageMenu for app ${appInfo?.appName}`);
      let event = new WindowEvent();
      event.windowName = appInfo.bundleName;
      event.eventType = WindowEvent.EVENT_TYPE_SHOW;
      event.eventState = WindowEvent.EVENT_STATE_START;
      EvtBus.post(WindowEvent, event);
    };
    return currentMenu;
  }

  public getWpsCloseMenu(appInfo: DockItemInfo, preExitCallback: Function): MenuInfo {
    let currentMenu = new MenuInfo();
    currentMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    currentMenu.menuText = $r('app.string.app_menu_exit');
    currentMenu.menuKeyString = 'appWpsClose';
    currentMenu.onMenuClick = (params: Map<string, Object>): void => {
      log.showInfo(`wps click closeMenu`);
      preExitCallback();
    };
    return currentMenu;
  }

  public getFormMenu(appInfo: DockItemInfo): MenuInfo {
    let mFormModel: FormModel = FormModel.getInstance();
    let addFormToDeskTopMenu = new MenuInfo();
    const formInfoList = mFormModel.getAppItemFormInfo(appInfo.bundleName as string,
      item => mFormModel.isFormCenterSupportCard(item));
    if (!CheckEmptyUtils.isEmptyArr(formInfoList)) {
      addFormToDeskTopMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      addFormToDeskTopMenu.menuImgSrc = '/common/pics/ic_form_center.svg';
      addFormToDeskTopMenu.menuText = $r('app.string.add_form_to_desktop');
      addFormToDeskTopMenu.onMenuClick = (appParams?: Map<string, Object>): void => {
        let formCenterViewParam = new FormCenterViewParam();
        let itemRect = DockItemPosition.getInstance().getIconRect();
        formCenterViewParam.bundleName = appInfo.bundleName;
        formCenterViewParam.entrancePosition = FormCenterViewManager.getInstance().getEntrancePos(undefined, {
          x: itemRect.left + (itemRect.width ?? 0) / 2,
          y: itemRect.top + (itemRect.height ?? 0) / 2,
        });
        FormCenterViewManager.getInstance().openFormCenterView(formCenterViewParam);
        if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
          let hideAppCenterWithAnimation = (GlobalContext.getInstance()
            .getObject('hideAppCenterWithAnimation')) as Function;
          hideAppCenterWithAnimation();
        }
      };
    }
    return addFormToDeskTopMenu;
  }

  public getOpenMenu(appInfo: DockItemInfo, screenId?: number): MenuInfo {
    let openMenu = new MenuInfo();
    openMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    openMenu.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
    openMenu.menuText = $r('app.string.app_menu_open');
    openMenu.menuKeyString = 'appOpen';
    openMenu.onMenuClick = (params: Map<string, Object>): void => {
      CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.DOCK_RIGHT_MENU);
      if (!params) {
        params = new Map<string, Object>([[KeyConstants.ITEM_RECT, DockItemPosition.getInstance().getIconRect()]]);
      }
      params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
      params.set(SCBConstants.START_APP_CLONE_INDEX, appInfo.appIndex ?? 0);
      if (appInfo?.enableNewAppInstance) {
        params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
      }
      this.residentOnClickWithDisplay(screenId ?? 0, null, appInfo, true, null, params);
    };
    return openMenu;
  }

  public getOpenNewWindowMenu(appInfo: DockItemInfo, screenId?: number): MenuInfo {
    let openMenu = new MenuInfo();
    openMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    openMenu.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
    openMenu.menuText = $r('app.string.app_menu_open_new_window');
    openMenu.menuKeyString = 'appOpenNewWindow';
    openMenu.onMenuClick = (params: Map<string, Object>): void => {
      CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.DOCK_RIGHT_MENU);
      if (!params) {
        params = new Map<string, Object>([[KeyConstants.ITEM_RECT, DockItemPosition.getInstance().getIconRect()]]);
      }
      params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
      params.set(SCBConstants.START_APP_CLONE_INDEX, appInfo.appIndex ?? 0);
      params.set(SCBConstants.OPEN_IN_NEW_WINDOW, true);
      if (appInfo?.enableNewAppInstance) {
        params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
      }
      this.residentOnClickWithDisplay(screenId ?? 0, null, appInfo, true, null, params);
    };
    return openMenu;
  }

  private closeIndependentIconAbilitySession(appInfo: DockItemInfo): void {
    log.showInfo(`menu closeIndependentIconAbilitySession ${appInfo.bundleName} ${appInfo.persistentId}`);
    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    containerSessionList.forEach((item) => {
      if (appInfo.bundleName !== item.primarySession?.sceneInfo.bundleName) {
        return;
      }
      if (appInfo.persistentId === String(item?.getPersistentId())) {
        PcDockIndepentIconMgr.getInstance().removeIndependentIconAbility(appInfo.bundleName, appInfo.persistentId);
        SCBSceneResourceManager.getInstance().deleteSessionIconCache(appInfo.persistentId);
        this.close(item.primarySession);
        return;
      }
    });
  }

  private closeIndependentIconAbilitySessionWithCheck(appInfo: DockItemInfo): boolean {
    const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
    if (!missionInfoList) {
      return false;
    }

    // 判断进程是否还有其他独立图标的窗口 或 非独立图标的窗口存在，存在则不退出进程
    for (let i = 0; i < missionInfoList.length; i++) {
      let isExist: boolean = (missionInfoList[i].bundleName === appInfo.bundleName &&
        (CheckEmptyUtils.isEmpty(missionInfoList[i].persistentId) ||
          (!CheckEmptyUtils.isEmpty(missionInfoList[i].persistentId) &&
            (missionInfoList[i].persistentId !== appInfo.persistentId))));
      if (isExist) {
        this.closeIndependentIconAbilitySession(appInfo);
        return true;
      }
    }
    return false;
  }

  // 判断进程是否还有其他独立图标的窗口存在，存在则不退出进程,只关闭非独立图标的窗口
  private closeSceneSessionWithCheckPersistentId(appInfo: DockItemInfo): boolean {
    const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
    let hasIndependent: boolean = false;

    if (missionInfoList) {
      for (let i = 0; i < missionInfoList.length; i++) {
        if (missionInfoList[i].bundleName === appInfo.bundleName &&
          !CheckEmptyUtils.isEmpty(missionInfoList[i].persistentId)) {
          hasIndependent = true;
          break;
        }
      }
    }

    if (!hasIndependent) {
      return hasIndependent;
    }
    log.showInfo(`menu closeSceneSessionWithCheckPersistentId ${appInfo.bundleName}`);
    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    containerSessionList.forEach((item) => {
      let needClosePrimarySession: boolean = (appInfo.bundleName === item.primarySession?.sceneInfo.bundleName &&
        appInfo.appIndex === item.primarySession?.sceneInfo.appIndex &&
        !PcDockIndepentIconMgr.getInstance().isIndependentIconAbility(appInfo.bundleName,
          String(item.primarySession?.sceneInfo.persistentId)));
      if (needClosePrimarySession) {
        this.close(item.primarySession);
      }
      let needCloseSecondarySession: boolean = (appInfo.bundleName === item.secondarySession?.sceneInfo.bundleName &&
        appInfo.appIndex === item.secondarySession?.sceneInfo.appIndex &&
        !PcDockIndepentIconMgr.getInstance().isIndependentIconAbility(appInfo.bundleName,
          String(item.primarySession?.sceneInfo.persistentId)));
      if (needCloseSecondarySession) {
        this.close(item.secondarySession);
      }
    });
    return true;
  }

  private exitMenuCheckPersistentId(appInfo: DockItemInfo): boolean {
    if (!CheckEmptyUtils.isEmpty(appInfo.persistentId) && this.closeIndependentIconAbilitySessionWithCheck(appInfo)) {
      return true;
    }
    if (CheckEmptyUtils.isEmpty(appInfo.persistentId) && this.closeSceneSessionWithCheckPersistentId(appInfo)) {
      return true;
    }
    return false;
  }

  public getExitMenu(appInfo: DockItemInfo, screenId?: number): MenuInfo {
    const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
    let missionLength = 0;

    if (missionInfoList) {
      for (let i = 0; i < missionInfoList.length; i++) {
        if (missionInfoList[i].bundleName === appInfo.bundleName &&
          (missionInfoList[i].persistentId ?? '') === (appInfo.persistentId ?? '')) {
          const missionList: SCBSceneContainerSession[] =
            missionInfoList[i]?.missionInfoList as SCBSceneContainerSession[];
          missionLength = missionList.length;
          break;
        }
      }
    }

    let exitMenu = new MenuInfo();
    exitMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    if (appInfo?.abilityName === CommonConstants.RECENT_ABILITY) {
      exitMenu.menuText = $r('app.string.app_menu_exit');
    } else {
      exitMenu.menuText = missionLength > 1 ?
        $r('app.string.app_menu_exit_multiple') : $r('app.string.app_menu_exit_single');
    }
    exitMenu.menuKeyString = 'appExit';
    exitMenu.onMenuClick = async (): Promise<void> => {
      if (appInfo?.shortcutId) {
        this.closeShortcutSession(appInfo);
        return;
      }
      if (this.exitMenuCheckPersistentId(appInfo)) {
        return;
      }
      if (appInfo?.abilityName === CommonConstants.RECENT_ABILITY) {
        const dType =
          screenId === SCBSceneSessionManager.getInstance().mainScreenId ? PcDockHiSysEventMgr.PRIMARY_SCREEN
            : PcDockHiSysEventMgr.SECONDARY_SCREEN;
        this.recentEntry(appInfo, dType);
        return;
      }
      let pidList: number[] = [];
      if (appInfo?.codePath !== LINUX_APPLICATION) {
        try {
          // !CheckEmptyUtils.isEmpty(badgeInfo?.appInstanceKey) 应用多开实例,查询多开的进程，进行进程关闭
          if (!CheckEmptyUtils.checkStrIsEmpty(appInfo?.appInstanceKey)) {
            await this.getAppInstancePids(appInfo, pidList);
          } else {
            await this.getAppPids(appInfo, pidList);
          }
        } catch (error) {
          log.error(`get pidList error:${error.message}`);
        }
      }
      if (pidList.length !== 0) {
        log.showError(`exit ${appInfo.bundleName} app pid list size : ${pidList.length}`);
        try {
          TrayManager.exitTrayProcess(pidList);
        } catch (error) {
          log.showError(`exitTrayProcess error= ${error}`);
          return;
        }
      } else {
        this.closeSceneSession(appInfo);
      }
    };
    return exitMenu;
  }

  private async getAppPids(appInfo: DockItemInfo, pidList: number[]): Promise<void> {
    let processInfoList: appManager.ProcessInformation[] =
      await appManager.getRunningProcessInfoByBundleName(appInfo.bundleName);
    // qxs fileManager is merged into files pidList
    if (appInfo.bundleName === CommonConstants.PHONE_FILE_MANAGER_BUNDLE && DeviceHelper.is2In1DevicePcType()) {
      const fileManagerProcessList: appManager.ProcessInformation[] =
        await appManager.getRunningProcessInfoByBundleName(CommonConstants.FILE_MANAGER_BUNDLE);
      processInfoList.push(...fileManagerProcessList);
    }
    processInfoList.forEach(item => {
      if (PCDockUtils.isSameBundle(item.bundleNames[0], appInfo.bundleName) &&
        (CheckEmptyUtils.isEmpty(item.appCloneIndex) || item.appCloneIndex === appInfo.appIndex)) {
        pidList.push(item.pid);
      }
    });
  }

  private async getAppInstancePids(appInfo: DockItemInfo, pidList: number[]): Promise<void> {
    await appManager.getRunningMultiAppInfo(appInfo.bundleName).then((info: appManager.RunningMultiAppInfo) => {
      if (!info.runningMultiInstances) {
        return;
      }
      info.runningMultiInstances.forEach(item => {
        if (SmartDockModel.getInstance().checkAppInstanceKey(appInfo?.appInstanceKey, item?.instanceKey)) {
          item.pids.forEach(pid => {
            pidList.push(pid);
          });
        }
      });
    }).catch((err: BusinessError) => {
      log.error(`getRunningMultiAppInfo error:${err.message}`);
    });
  }

  public levelTwoMenuShowDock(showDockStatus: boolean): void {
    if (showDockStatus) {
      AppStorage.setOrCreate('levelTwoMenuShowDockStatus', true);
      if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
        let showDockViewWithAnimation = (GlobalContext.getInstance()
          .getObject('showDockViewWithAnimation')) as Function;
        showDockViewWithAnimation();
      } else {
        viewMgrPolicy.showView(ViewType.SMART_DOCK);
      }
    } else {
      AppStorage.setOrCreate('levelTwoMenuShowDockStatus', false);
      const screenId = SCBSceneSessionManager.getInstance().mainScreenId;
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE,
        { 'isVisible': false, 'screenId': screenId });
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE, {
        'isVisible': false,
        'screenId': screenId
      });
    }
  }

  protected closeSceneSession(appInfo: DockItemInfo): void {
    log.showInfo(`menu closeSceneSession bundleName:${appInfo.bundleName}，appIndex:${appInfo?.appIndex}`);
    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getAllContainerSessionList();
    containerSessionList.forEach((item) => {
      if (SmartDockModel.getInstance().checkSameDockItem(item.primarySession?.sceneInfo, appInfo)) {
        this.close(item.primarySession);
      }
      if (SmartDockModel.getInstance().checkSameDockItem(item.secondarySession?.sceneInfo, appInfo)) {
        this.close(item.secondarySession);
      }
    });
  }

  protected close(item: SCBSceneSession | null): void {
    if (!item) {
      return;
    }
    let missionId = item.session?.persistentId;
    let screenId = item.sceneInfo?.screenId;
    SCBSceneSessionManager.getInstance().asyncPrepareTerminate(missionId, (err, isPrepareTerminate) => {
      if (isPrepareTerminate) {
        log.showInfo('deleteRecentSession isPrepareTerminate');
        return;
      }
      try {
        SCBSceneSessionManager.getInstance().close(screenId, missionId);
      } catch (error) {
        log.showError(`close error= ${error}`);
        return;
      }
    });
  }

  private isShortcut(item: DockItemInfo): boolean {
    return item.typeId === CommonConstants.TYPE_SHORTCUT_ICON || !!item.shortcutId;
  }

  private async shortcutOnClick(item: DockItemInfo): Promise<void> {
    log.showInfo(`shortcutOnClick, bundleName=${item.bundleName} shortcutId=${item.shortcutId}, keyName=${item.keyName}`);
    const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
    let recentTaskList: RecentBundleMissionInfo | undefined;
    if (missionInfoList && !CheckEmptyUtils.isEmptyArr(missionInfoList)) {
      recentTaskList = missionInfoList.find(mission => {
        log.showWarn(`shortcutOnClick mission.bundleName=${mission.bundleName}, missionInfoList.cnt=${mission.missionInfoList.length}`);
        return mission.bundleName === item.bundleName && mission.shortcutId === item.shortcutId;
      });
    }
    this.tryHideAppCenterWithAnimation();
    // 同bundle下无已启动ability窗口，启动
    this.setStartAppInfo(item);
    if (!recentTaskList) {
      log.showInfo('shortcutOnClick, no started ability bind, start new');
      ShortcutViewModel.getInstance().onShortcutAppClick(item);
      return;
    }
    const shortcutInfo = await ShortcutViewModel.getInstance().getShortcutInfo(item);
    const shortcutAbilityName = shortcutInfo?.wants?.[0].targetAbility;
    // 同容器下任务为空，
    let missionList = recentTaskList.missionInfoList as SCBSceneContainerSession[];
    if (CheckEmptyUtils.isEmptyArr(missionList)) {
      log.showInfo('shortcutOnClick missionList is empty');
      return;
    }
    let shortcutSession = missionList.find(session => {
      if (session.primarySession?.sceneInfo.abilityName === shortcutAbilityName) {
        return true;
      }
      return session.secondarySession?.sceneInfo.abilityName === shortcutAbilityName;
    });
    if (!shortcutSession) {
      log.showInfo('shortcutOnClick missionList is empty, to startApp');
      ShortcutViewModel.getInstance().onShortcutAppClick(item);
      return;
    }
    // 分屏场景，
    if (shortcutSession.isSplit) {
      log.showInfo('shortcutOnClick shortcutSession is split, move to front');
      this.moveSessionUpFrontSplit(shortcutSession, item);
      return;
    }
    const frontContainerSession = this.queryFrontSession();
    const frontBundleName = frontContainerSession?.primarySession?.sceneInfo?.bundleName;
    if (shortcutSession.isActive && frontBundleName === item.bundleName) {
      log.showInfo('shortcutOnClick shortcutSession is normal, minimize');
      const sceneInfo: SCBSceneInfo | undefined = shortcutSession.primarySession?.sceneInfo;
      SCBSceneSessionManager.getInstance()
        .minimize(sceneInfo?.screenId, sceneInfo?.persistentId, shortcutSession.containerId);
    } else {
      log.showInfo('shortcutOnClick shortcutSession is normal, move to front');
      this.moveSessionUpFront(shortcutSession.primarySession, shortcutSession.containerId);
    }
  }

  private tryHideAppCenterWithAnimation(): void {
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    }
  }

  /**
   * 添加到快捷栏
   *
   * @param appInfo app信息
   */
  private addToDockMenu(appInfo: AppItemInfo): MenuInfo {
    const addToDockMenu: MenuInfo = new MenuInfo();
    appInfo.keyName = AppItemInfo.getKeyName(appInfo);
    addToDockMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    addToDockMenu.menuImgSrc = '/common/pics/ic_public_copy.svg';
    addToDockMenu.menuText = $r('app.string.app_center_menu_add_dock');
    addToDockMenu.onMenuClick = (): void => {
      HiSysEventUtil.reportEventById(appInfo.bundleName, 'recent add to dock');
      if (typeof(appInfo.typeId) === 'undefined') {
        appInfo.typeId = CommonConstants.TYPE_APP;
      }
      log.showInfo('click menu item add to smartDock entry, bundleName = ' + appInfo.bundleName);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD, appInfo);
    };
    return addToDockMenu;
  }

  private getRecycleBinClearMenu(screenId?: number): MenuInfo {
    let clearMenu = new MenuInfo();
    clearMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    clearMenu.menuImgSrc = '/common/pics/ic_public_clean.svg';
    clearMenu.menuText = $r('app.string.app_menu_clean');
    clearMenu.menuKeyString = FixedDockResource.CLEAR_RECYCLE_BIN_KEY_STRING;
    clearMenu.onMenuClick = (): void => {
      let want: Want = {
        'bundleName': 'com.ohos.filemanager',
        'abilityName': 'RecycleBinServiceExtAbility',
        'parameters': {
          'mode': 'clear',
          'displayId': screenId ?? 0
        }
      };
      try {
        GlobalContext.getContext().startServiceExtensionAbility(want).then(() => {
          log.showInfo('startServiceExtensionAbility success');
        }).catch((error: Error) => {
          log.showInfo('startServiceExtensionAbility failed: ' + error);
        });
      } catch (error) {
        log.showError('startAbilityForResult error : ' + error);
      }
    };
    return clearMenu;
  }

  private async closeShortcutSession(appInfo: AppItemInfo): Promise<void> {
    log.showInfo(`menu closeShortcutSession which is opened from shortcut`);
    const shortcutInfo = await ShortcutViewModel.getInstance().getShortcutInfo(appInfo);
    const targetAbilityName = shortcutInfo?.wants?.[0]?.targetAbility;
    if (!targetAbilityName) {
      throw new Error('Target ability name is not defined in shortcut info.');
    }

    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    containerSessionList.forEach((item) => {
      if (appInfo.bundleName !== item.primarySession?.sceneInfo.bundleName) {
        return;
      }
      if (targetAbilityName === item?.companionIconInfo?.abilityName) {
        this.close(item.primarySession);
      }
    });
  }

  private appCenterEntry(item: DockItemInfo, screenId: number = 0): void {
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) && AppStorage.get('isAppCenterShow') !== false) {
      performanceMonitor.begin(HiSysEventUtil.PC_DOCK_EXIT_APP_CENTER, performanceMonitor.ActionType.LAST_UP);
    } else {
      PcDockHiSysEventMgr.reportStartAppFromDockData(this.getKeyName(item));
      HiSysEventUtil.reportPullAppCenter(HiSysEventUtil.APPCENTER_TYPE_CLICK);
      if (AppStorage.get('showRecent') === true) {
        performanceMonitor.begin(HiSysEventUtil.PC_INTO_APP_CENTER_ON_RECENT, performanceMonitor.ActionType.LAST_UP);
      } else {
        performanceMonitor.begin(HiSysEventUtil.PC_DOCK_INTO_APP_CENTER, performanceMonitor.ActionType.LAST_UP);
        let isSplit = AppStorage.get<boolean>('split');
        if (isSplit) {
          SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
        }
      }
    }
    PcDockRecentProxy.getInstance().enterAppCenter(screenId);
  }

  private recentEntry(item: DockItemInfo, dType: number): void {
    if (AppStorage.get('showRecent') === true && AppStorage.get('recentToAppCenter') !== true) {
      performanceMonitor.begin(HiSysEventUtil.PC_EXIT_RECENT, performanceMonitor.ActionType.LAST_UP);
    } else {
      performanceMonitor.begin(HiSysEventUtil.PC_INTO_RECENT, performanceMonitor.ActionType.LAST_UP);
      PcDockHiSysEventMgr.reportStartAppFromDockData(this.getKeyName(item), dType);
      SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
    }
    PcDockRecentProxy.getInstance().enterRecent();
  }

  private getKeyName(item: DockItemInfo): string {
    return item.bundleName + '_' + item.abilityName;
  }

  protected queryFrontSession(screenId?: number): SCBSceneContainerSession | undefined {
    let containerSession: SCBSceneContainerSession | undefined = undefined;
    let isClickTopMostScene: boolean = false;
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
    if (containerSessionList === undefined || containerSessionList === null) {
      return containerSession;
    }
    let frontScenes: SCBSceneContainerSession[] = [];
    let topMostScenes: SCBSceneContainerSession[] = [];
    for (const scene of containerSessionList) {
      if (scene.isActive && !scene.primarySession?.isMinimizing) {
        frontScenes.push(scene);
        if (scene.isTopmost() || scene.isMainWindowTopmost()) {
          if (this.clickBundleName === scene.getBundleName() && this.persistentId === scene.getPersistentId()) {
            isClickTopMostScene = true;
          }
          topMostScenes.push(scene);
        }
      }
    }
    // 点击一个非置顶topMost窗口
    if (frontScenes.length > 1 && !isClickTopMostScene) {
      if (topMostScenes.length > 0) {
        return frontScenes[frontScenes.length - topMostScenes.length - 1];
      } else {
        return frontScenes[frontScenes.length - 1];
      }
    } else {
      // 点击一个置顶topMost窗口
      for (const topMostScene of topMostScenes) {
        if (topMostScene.primarySession?.isFocused) {
          return topMostScene;
        }
      }
    }

    if (frontScenes.length === 1 ) {
      return frontScenes[0];
    } else {
      return containerSession;
    }
  }

  private moveSessionUpFront(scbSceneSession: SCBSceneSession | null, containerId: number, shouldBackToCaller?: boolean,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    if (!scbSceneSession) {
      return;
    }

    SCBSceneSessionManager.getInstance().exitActiveSplit(scbSceneSession.sceneInfo?.screenId);
    SCBSceneSessionManager.getInstance().startSceneFromRecent(scbSceneSession.sceneInfo?.screenId,
      scbSceneSession.sceneInfo?.persistentId, containerId, shouldBackToCaller, extraInfo);
    SCBSceneSessionManager.getInstance().requestFocus(scbSceneSession.sceneInfo?.persistentId,
      true, FocusChangeReason.MOVE_UP);
  }

  private moveSessionUpFrontSplit(containerSession: SCBSceneContainerSession, item: DockItemInfo): void {
    if (this.mSmartDockModel.checkSameDockItem(containerSession?.primarySession?.sceneInfo, item)) {
      this.moveSessionUpFront(containerSession?.primarySession, containerSession.containerId);
    } else {
      this.moveSessionUpFront(containerSession?.secondarySession, containerSession.containerId);
    }
  }

  private doDestroyFloatCallback = (sceneSession: sceneSessionManager.SceneSession): void => {
    log.showInfo(`doDestroyFloatCallback : sceneSession: ${sceneSession.persistentId}`);

    // 更新回收站状态
    if (PcSmartDockModel.getInstance().getRecycleBinStatus().persistentId === sceneSession.persistentId) {
      PcSmartDockModel.getInstance().updateRecycleBinStatus();
    }
  }

  public async appExit(appInfo: DockItemInfo): Promise<void> {
    let pidList: number[] = [];
    if (appInfo?.codePath !== LINUX_APPLICATION) {
      try {
        await this.getAppPids(appInfo, pidList);
      } catch (error) {
        log.error(`get pidList error:${error.message}`);
      }
    }
    if (pidList.length !== 0) {
      log.showError(`exit ${appInfo?.bundleName} app pid list size : ${pidList.length}`);
      try {
        TrayManager.exitTrayProcess(pidList);
      } catch (error) {
        log.showError(`exitTrayProcess error= ${error}`);
        return;
      }
    } else {
      this.closeSceneSession(appInfo);
    }
  }
}