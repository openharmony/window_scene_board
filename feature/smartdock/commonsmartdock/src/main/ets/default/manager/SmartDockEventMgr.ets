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

import {
  StartType,
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  ObjUtil,
  RectInfo,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { DeviceHelper, GlobalContext, HiSysEventUtil, ResourceManager } from '@ohos/frameworkwrapper';
import {
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  StartAbilityUtil,
  FocusChangeReason,
  SCBSceneContainerSessionArray,
  SCBSceneSession,
  SCBScreenProperty,
  SceneInfoAdapterUtil,
  INVALID_SCREEN_ID
} from '@ohos/windowscene';
import {
  AppGalleryDownloadManager,
  AppItemInfo,
  CardItemInfo,
  GridLayoutItemInfo,
  LayoutViewModel,
  layoutLockUtil,
  ShortcutViewModel,
  DockContinuableInfo,
  DesktopUtils,
  editModeManager,
  lockLayoutManager,
  DeleteDockItem,
  DragCoveredItem,
} from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { MenuInfo } from '@ohos/launchercommon';
import type { DockItemInfo } from '@ohos/launchercommon';
import { FormModel } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import { CloseAppManager, StartSubtype } from '@ohos/launchercommon';
import SmartDockModel from '../model/SmartDockModel';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import { ViewManager, FormCenterViewManager } from '@ohos/launchercommon';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import type { RecentBundleMissionInfo } from '@ohos/launchercommon';
import type { SnapshotInfo } from '@ohos/launchercommon';
import { DeviceState, KeyConstants } from '@ohos/launchercommon';
import { AppStatus } from '@ohos/launchercommon';
import { DockItemPosition } from '../common/DockItemPosition';
import type { SmartDockEventInterface } from '../common/interfaces/SmartDockEventInterface';
import SmartDockViewModel from '../viewmodel/SmartDockViewModel';
import StatusBarServiceEventMgr from './StatusBarServiceEventMgr';
import { DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { AppLockUtils } from '@ohos/launchercommon';
import lazy { DockHiSysEventMgr } from './DockHiSysEventMgr';
import { UIContext } from '@kit.ArkUI';
import { FormHiSysEventUtil } from '@ohos/form/src/main/ets/default/util/FormHiSysEventUtil';
import lazy PcModeContinuableModel from '../pcmode/model/PcModeContinuableModel';

const TAG = 'SmartDockEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * SmartDock event interface impl
 */
export class SmartDockEventMgr extends SingleBase implements SmartDockEventInterface {
  public static singleName: string = 'SmartDockEventMgr';
  private static mInstance: SmartDockEventMgr;
  mSmartDockModel: SmartDockModel;
  private readonly mFormModel: FormModel;
  mSelectedItem: DockItemInfo | undefined;
  mSelectedDockType = 0;
  private mDevice = CommonConstants.DEFAULT_DEVICE_TYPE;
  private mViewManager: ViewManager;
  private uiContext?: UIContext;
  private isRemove: boolean = false;
  private curItem: DockItemInfo | undefined;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mSmartDockModel = SmartDockModel.getInstance(ctx);
    this.mFormModel = FormModel.getInstance();
    this.mViewManager = ViewManager.getInstance();

    log.showInfo('Launcher SmartDockEventMgr constructor!');
  }

  static getInstance(ctx?: SingleContext): SmartDockEventMgr {
    return singleManager.get<SmartDockEventMgr>(SmartDockEventMgr, ctx);
  }

  /**
   * 设置UIContext
   *
   * @param uiContext 页面UIContext
   */
  public setUIContext(uiContext: UIContext): void {
    if (uiContext) {
      this.uiContext = uiContext;
    }
  }

  private showRecentCenter(item: AppItemInfo): void {
    if (AppStorage.get('showRecent') === true) {
      AppStorage.setOrCreate('showRecent', false);
    } else {
      AppStorage.setOrCreate('showRecent', true);
      DockHiSysEventMgr.reportStartAppFromDockData(item.bundleName + '_' + item.abilityName);
      SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
    }
  }

  /**
   * resident dock item onClick function
   * @param event
   * @param item
   * @param callback
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  residentOnClick(event: ClickEvent | null, item: DockItemInfo, startNewAbility: boolean = false,
    callback?: Function | null, params?: Map<string, Object>): boolean {
    if (!this.canClick()) {
      // 拖拽过程中不响应dock点击
        return false;
    }
    if (item?.abilityName === CommonConstants.RECENT_ABILITY) {
      this.showRecentCenter(item);
      return false;
    }
    // app entry
    if (startNewAbility) {
      // set start app info
      log.showWarn(`Start new application item bundleName: ${item.bundleName}`);
      this.setStartAppInfo(item);
      if (item.appIndex && item.appIndex > 0 && params) {
        params.set(SCBConstants.START_APP_CLONE_INDEX, item.appIndex);
        let mItemRect: RectInfo | undefined = DockItemPosition.getInstance().getIconRect();
        if (mItemRect) {
          params.set(KeyConstants.ITEM_RECT, mItemRect);
        }
      }
      StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params);
      return false;
    } else {
      return this.recentOnClick(event, item, startNewAbility, callback);
    }

  }

  /**
   * 文件夹打开状态, 窗口会挡住文件夹
   * 自由多窗模式打开文件夹最小化前台窗口来避让文件夹
   */
  closeFrontWindow(): void {
    // 过滤得到在前台的窗口
    let missionInfoActiveList = this.getMissionInfoActiveList();
    AppStorage.setOrCreate<SCBSceneContainerSession[]>('missionInfoActiveList', missionInfoActiveList);
    SCBSceneSessionManager.getInstance().minimizeAllScene(INVALID_SCREEN_ID);
  }

  /**
   *  自由多窗模式文件夹关闭后, 将之前最小化的窗口还原到前台
   */
  openFrontWindow(): void {
    const showList = AppStorage.get<SCBSceneContainerSession[]>('missionInfoActiveList');
    if (!showList) {
      return;
    }
    const sessionList: SCBSceneContainerSession[] = this.getMissionInfoActiveList();
    const maxWindow:ESObject = sceneSessionManager.getFreeMultiWindowConfig().maxMainFloatingWindowNumber;
    // 根据前台窗口数量判断需要拉起的窗口数量
    if (sessionList.length < maxWindow) {
      const addableWindowNumber: number = Math.min((maxWindow - sessionList.length), showList.length);
      const startIndex = Math.max(0, (showList.length - addableWindowNumber));
      const changeSessionList: SCBSceneContainerSession[] = showList.slice(startIndex, showList.length);
      for (let i = 0; i < changeSessionList.length; i++) {
        let mPrimarySession: SCBSceneSession | null = changeSessionList[i].primarySession;
        if (mPrimarySession) {
          log.showInfo(`changeSessionList bundleName: ${mPrimarySession.sceneInfo.bundleName}`);
          this.moveToFront(mPrimarySession, changeSessionList[i].containerId);
        }
      }
      log.showInfo(`sessionList.length: ${sessionList.length}, showList.length: ${showList.length}`);
      // 如果文件打开期间存在已打开的前台窗口, 将这些窗口置顶显示
      if (!CheckEmptyUtils.isEmptyArr(sessionList)) {
        for (let i = 0; i < sessionList.length; i++) {
          SCBSceneSessionManager.getInstance().requestToTop(sessionList[i]?.primarySession?.sceneInfo?.screenId,
            sessionList[i]?.primarySession?.sceneInfo?.persistentId);
        }
        // 置顶的窗口前台获焦
        const focusWindowId = sessionList[sessionList.length - 1]?.primarySession?.sceneInfo?.persistentId;
        SCBSceneSessionManager.getInstance().requestFocus(focusWindowId, false, FocusChangeReason.MOVE_UP);
      }
    }
  }

  private getMissionInfoActiveList(): SCBSceneContainerSession[] {
    const session: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    const activeSessionList = session.filter((session) => {
      // 过滤得到在前台的窗口, 且前台窗口根据层级有序
      return session.isActive;
    })
    return activeSessionList;
  }

  public recentOnClickWithDisplay(screenId: number, event: ClickEvent, item: DockItemInfo, startNewAbility: boolean = false, callback?: Function): boolean {
    return this.recentOnClick(event, item, startNewAbility, callback);
  }

  public residentOnClickWithDisplay(screenId: number, event: ClickEvent | null, item: DockItemInfo,
    startNewAbility: boolean = false, callback?: Function | null, params?: Map<string, Object>): boolean {
    return this.residentOnClick(event, item, startNewAbility, callback, params);
  }

  private canClick(): boolean {
    if (AppStorage.get<boolean>('isDrag')) {
      log.showError('residentOnClick isDrag: true');
      return false;
    }
    // dock栏中图标位移动效
    if (AppStorage.get<boolean>('isDockItemMove')) {
      log.showError('residentOnClick isDockItemMove: true');
      return false;
    }
    // 创建小文件夹动效期间不允许点击
    let dragCoveredItem: DragCoveredItem = AppStorage.get<DragCoveredItem>('DragCoveredItem') as DragCoveredItem;
    if (dragCoveredItem && dragCoveredItem.isCreateSmallFolder) {
      log.showError('residentOnClick isCreateSmallFolder: true');
      return false;
    }
    return true;
  }

  /**
   * set start app info
   */
  protected setStartAppInfo(item: AppItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('setStartAppInfo without item');
      return;
    }
    let startType: StartType = StartType.APP;
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      startType = StartType.SHORTCUT_APP;
    } else if (AppStorage.get('device') !== CommonConstants.DEFAULT_DEVICE_TYPE) {
      startType = StartType.DOCK_APP;
    }
    log.showInfo(`setStartAppType: ${startType}`);
    CloseAppManager.getInstance().setStartAppType(startType, undefined, undefined, item.shortcutId);
  }

  /**
   * recent dock item onClick function
   * @param event
   * @param item
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  public recentOnClick(event: ClickEvent | null, item: AppItemInfo, startNewAbility: boolean = false,
    callback?: Function | null): boolean {
    // 支持pad模式和自由多窗模式的快捷方式打开
    const isPcMode: boolean = SCBSceneSessionManager.getInstance().isPcMode();
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && !isPcMode) {
      this.setStartAppInfo(item);
      ShortcutViewModel.getInstance().onShortcutAppClick(item);
      return false;
    }
    if (isPcMode) {
      const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
      log.showInfo(`recentOnClick bundleName: ${item.bundleName}, missionInfoList.length: ${missionInfoList?.length}`);
      if (missionInfoList && !CheckEmptyUtils.isEmptyArr(missionInfoList) && item.bundleName !== CommonConstants.DISTRIBUTED_ASSIST) {
        const frontContainerSession = this.queryFrontSession();
        for (let i = 0; i < missionInfoList.length; i++) {
          if (missionInfoList[i].bundleName === item.bundleName && missionInfoList[i].appIndex === item.appIndex) {
            const missionList: SCBSceneContainerSession[] = missionInfoList[i]?.missionInfoList as SCBSceneContainerSession[];
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
            if ((missionList.length > 1 || PcModeContinuableModel.getInstance().isOpenPopupOnContinuableItem) && callback) {
              log.showInfo('recentOnClick callback recentOnClickWithPopup');
              callback();
              return true;
            }
            if (missionList.length === 1 && missionList[0]) {
              if (missionList[0].isSplit) {
                this.moveSplitToFront(missionList[0], item);
                return false;
              }
              this.setStartAppInfo(item);
              if (missionList[0].isActive) {
                SCBSceneSessionManager.getInstance().minimize(missionList[0].primarySession?.sceneInfo.screenId,
                  missionList[0].primarySession?.sceneInfo.persistentId, missionList[0].containerId);
              } else {
                if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
                  this.setStartAppInfo(item);
                  ShortcutViewModel.getInstance().onShortcutAppClick(item);
                } else {
                  let mPrimarySession: SCBSceneSession | null = missionList[0].primarySession;
                  if (mPrimarySession) {
                    this.moveToFront(mPrimarySession, missionList[0].containerId);
                  }
                }
              }
            }
            return false;
          }
        }
      }
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.setStartAppInfo(item);
        ShortcutViewModel.getInstance().onShortcutAppClick(item);
        return false;
      }

      if (!startNewAbility) {
        this.setStartAppInfo(item);
        let params: Map<string, Object> = new Map();
        params.set(SCBConstants.START_APP_CLONE_INDEX, item.appIndex ?? 0);
        let mItemRect: RectInfo | undefined = DockItemPosition.getInstance().getIconRect();
        if (mItemRect) {
          params.set(KeyConstants.ITEM_RECT, mItemRect);
        }
        StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params);
      }
      return false;
    } else {
      // set start app info
      this.setStartAppInfo(item);
      log.showWarn(`Start new application item bundleName: ${item.bundleName}`);
        let params: Map<string, Object> = new Map();
        params.set(SCBConstants.START_APP_CLONE_INDEX, item.appIndex ?? 0);
        let mItemRect: RectInfo | undefined = DockItemPosition.getInstance().getIconRect();
        if (mItemRect) {
          params.set(KeyConstants.ITEM_RECT, mItemRect);
        }
        StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params);
      return false;
    }
  }

  protected queryFrontSession(): SCBSceneContainerSession | undefined {
    let containerSession: SCBSceneContainerSession | undefined = undefined;
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (containerSessionList === undefined || containerSessionList === null) {
      return containerSession;
    }
    let frontScenes: Array<SCBSceneContainerSession> = [];
    for (const scene of containerSessionList) {
      if (scene.isActive && !scene.primarySession?.isMinimizing && scene.primarySession?.isFocused) {
        frontScenes.push(scene);
      }
    }
    if (frontScenes.length > 0) {
      return frontScenes[frontScenes.length - 1];
    }
    return containerSession;
  }

  moveToFront(scbSceneSession: SCBSceneSession, containerId: number): void {
    log.showInfo('screenId: %{public}d, persistentId: %{public}d, containerId: %{public}d',
      scbSceneSession?.sceneInfo?.screenId, scbSceneSession?.sceneInfo?.persistentId, containerId);
    SCBSceneSessionManager.getInstance().startSceneFromRecent(scbSceneSession?.sceneInfo?.screenId,
      scbSceneSession?.sceneInfo?.persistentId, containerId);
    SCBSceneSessionManager.getInstance().requestFocus(scbSceneSession?.sceneInfo?.persistentId,
      true, FocusChangeReason.MOVE_UP);
  }

  moveSplitToFront(containerSession: SCBSceneContainerSession, item: AppItemInfo): void {
    if (!containerSession) {
      return;
    }
    log.showInfo('click split item: %{public}s, primary: %{public}s, secondary: %{public}s',
      item?.bundleName, containerSession.primarySession?.sceneInfo?.bundleName,
      containerSession.secondarySession?.sceneInfo?.bundleName);
    if (containerSession.primarySession?.sceneInfo?.bundleName === item?.bundleName &&
      containerSession.primarySession?.sceneInfo?.appIndex === item?.appIndex) {
      this.moveToFront(containerSession.primarySession, containerSession.containerId);
    } else {
      if (containerSession.secondarySession) {
        this.moveToFront(containerSession.secondarySession, containerSession.containerId);
      }
    }
  }

  /**
   * build menu for @Component CustomOverlay
   * @param appInfo
   * @param dockType
   * @param callback
   */
  buildMenuInfoList(appInfo: DockItemInfo, dockType: number, formDialog?: CustomDialogController | null,
    callback?: Function ): MenuInfo[] {
    this.mDevice = AppStorage.get('device') ?? '';
    const menuInfoList = new Array<MenuInfo>();

    menuInfoList.push(...StatusBarServiceEventMgr.getInstance().getAppManagerMenuByBundleName(appInfo.bundleName));

    if (appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      // 定制联系人快捷图标无法移除;演示样机dock栏及dock栏文件夹内的快捷方式无法移除
      if (ShortcutViewModel.getInstance().isContactsApp(appInfo.bundleName) ||
        layoutLockUtil.isLocked('get shortcut remove menu')) {
        return [];
      }
      if (!lockLayoutManager.isLockLayout()) {
        const shortcutMenu = new MenuInfo();
        shortcutMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
        shortcutMenu.menuImgSrc = '/common/pics/ic_public_remove.svg';
        shortcutMenu.menuText = ResourceManager.getInstance().getStringByName('delete_form');
        shortcutMenu.onMenuClick = (): void => {
          log.showInfo('remove shortcut icon in dock');
          let mAppInfo = appInfo as DeleteDockItem;
          mAppInfo.isDeleteAppToUninstallFolder = true;
          this.mSmartDockModel.deleteDockItem(mAppInfo, SmartDockConstants.RESIDENT_DOCK_TYPE);
          HiSysEventUtil.reportDeleteShortcutMenu(appInfo.bundleName, appInfo.appName);
        };
        menuInfoList.push(shortcutMenu);
      }
      return menuInfoList;
    }

    ShortcutViewModel.getInstance().checkShortCutInfo(appInfo, menuInfoList);

    if (this.mDevice === CommonConstants.PAD_DEVICE_TYPE) {
      let open = new MenuInfo();
      open.menuType = CommonConstants.MENU_TYPE_FIXED;
      open.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
      open.menuText = $r('app.string.app_menu_open');
      open.onMenuClick = (params: Map<string, Object>): void => {
        CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.DOCK_RIGHT_MENU);
        if (!params) {
          let mIconRect: RectInfo | undefined = DockItemPosition.getInstance().getIconRect();
          if (mIconRect) {
            params = new Map<string, Object>([[KeyConstants.ITEM_RECT, mIconRect]]);
          }
        }
        this.residentOnClick(null, appInfo, true, null, params);
        CloseAppManager.getInstance().resetStartAppSubtype();
      };
      menuInfoList.push(open);
    }

    if (this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE && dockType === SmartDockConstants.RESIDENT_DOCK_TYPE) {
      const uninstallMenu = new MenuInfo();
      uninstallMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      uninstallMenu.menuImgSrc = '/common/pics/ic_public_delete.svg';
      uninstallMenu.menuText = (appInfo.appIndex ?? 0) > 0 ? $r('app.string.delete') : $r('app.string.uninstall');
      uninstallMenu.onMenuClick = (): void => {
        log.showDebug(`onMenuClick item remove:` +
          ` bundleName: ${appInfo?.bundleName}, abilityName: ${appInfo?.abilityName}, dockType: ${dockType}`);
        appInfo.keyName = AppItemInfo.getKeyName(appInfo);
        const appName = this.mSmartDockModel.getAppName(appInfo);
        log.showInfo(`onMenuClick item remove appName: ${appName}`);
        if (!CheckEmptyUtils.isEmpty(appName)) {
          appInfo.appName = appName;
          appInfo.applicationName = appName;
        }
        this.mSelectedItem = appInfo;
        this.mSelectedDockType = dockType;
        AppStorage.setOrCreate('uninstallAppInfo', appInfo);
        AppStorage.setOrCreate('showUninstallDialog', true);
        if (callback) {
          callback();
        }
      };
      uninstallMenu.menuEnabled = (appInfo.isUninstallAble && !layoutLockUtil.isLocked('get app removeMenu') &&
        !lockLayoutManager.isLockLayout()) ?? false;
      let isPad = this.mDevice === CommonConstants.PAD_DEVICE_TYPE;
      if (isPad || (!isPad && uninstallMenu.menuEnabled)) {
        menuInfoList.push(uninstallMenu);
      }
    }

    let appLockMenu: MenuInfo | undefined = AppLockUtils.getInstance().buildAppLockMenu(appInfo);
    if (appLockMenu !== undefined) {
      menuInfoList.push(appLockMenu);
    }


    if (formDialog != null && this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE &&
      LayoutViewModel.getInstance().getDesktopModel() !== DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      const formInfoList: CardItemInfo[] | undefined = this.mFormModel.getAppItemFormInfo(appInfo.bundleName as string,
        item => this.mFormModel.isFormCenterSupportCard(item));
      if (formInfoList && !CheckEmptyUtils.isEmptyArr(formInfoList)) {
        let addFormToDeskTopMenu = new MenuInfo();
        addFormToDeskTopMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
        addFormToDeskTopMenu.menuImgSrc = '/common/pics/ic_form_center.svg';
        addFormToDeskTopMenu.menuText = $r('app.string.add_form_to_desktop');
        addFormToDeskTopMenu.onMenuClick = (): void => {
          log.showInfo('Launcher click menu item into add form to desktop view');
          FormHiSysEventUtil.reportIntoFormManagerFromAppShortcutMenu(appInfo.bundleName as string);
          FormHiSysEventUtil.reportIntoFormType('0');
          const appName = this.mSmartDockModel.getAppName(appInfo);
          log.showInfo(`buildMenuInfoList appName: ${appName}`);
          if (appName != null) {
            appInfo.appName = appName;
          }
          AppStorage.setOrCreate('formAppInfo', appInfo);
          if (this.mDevice !== CommonConstants.PAD_DEVICE_TYPE) {
            this.mFormModel.doBeforeJumpToFormManager(String(appInfo.bundleName)).then(() => {
              let addFormViewSource: number = dockType === SmartDockConstants.RECENT_DOCK_TYPE ?
                FormConstants.FORM_MANAGER_SHOW_FROM_RECENT_APP_RIGHT_MENU :
                FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU;
              this.mViewManager.jumpToFormManagerView(appInfo, addFormViewSource);
            });
          } else {
            log.showInfo('Launcher AppStorage.SetOrCreate formAppInfo');
            formDialog.open();
          }
        };
        menuInfoList.push(addFormToDeskTopMenu);
      }

    }

    if (appInfo.itemType !== CommonConstants.TYPE_FUNCTION) {
      if (this.mDevice === CommonConstants.PAD_DEVICE_TYPE && dockType === SmartDockConstants.RESIDENT_DOCK_TYPE) {
        const addToWorkSpaceMenu = new MenuInfo();
        addToWorkSpaceMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
        addToWorkSpaceMenu.menuImgSrc = '/common/pics/ic_public_copy.svg';
        addToWorkSpaceMenu.menuText = $r('app.string.app_center_menu_add_desktop');
        addToWorkSpaceMenu.onMenuClick = (): void => {
          log.showInfo('onMenuClick item add to pageDesk:' + appInfo?.bundleName);
          this.mSmartDockModel.addToPageDesk(appInfo);
        };
        menuInfoList.push(addToWorkSpaceMenu);
      }

      if (this.mDevice === CommonConstants.PAD_DEVICE_TYPE && dockType === SmartDockConstants.RESIDENT_DOCK_TYPE &&
        appInfo.bundleName !== CommonConstants.FILE_MANAGER_BUNDLE &&
        !lockLayoutManager.isLockLayout()) {
        const removeMenu = new MenuInfo();
        removeMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
        removeMenu.menuImgSrc = this.mDevice === CommonConstants.PAD_DEVICE_TYPE ? '/common/pics/ic_public_remove.svg' : '/common/pics/ic_public_delete.svg';
        removeMenu.menuText = this.mDevice === CommonConstants.PAD_DEVICE_TYPE ? $r('app.string.remove_from_dock') : $r('app.string.uninstall');
        removeMenu.onMenuClick = (): void => {
          log.showInfo(`onMenuClick item remove: ${appInfo?.bundleName}, dockType: ${dockType}`);

          // 规避方案，待dialog窗口化需求落地修改
          this.mSelectedItem = appInfo;
          this.mSelectedDockType = dockType;
          const dockItem: DeleteDockItem = {bundleName: appInfo.bundleName, keyName: ''};
          this.deleteDockItem(dockItem, this.mSelectedDockType);
        };
        removeMenu.menuEnabled = appInfo.isUninstallAble ?? false;
        menuInfoList.push(removeMenu);
      }
    }
    if (appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      let clear = new MenuInfo();
      clear.menuType = CommonConstants.MENU_TYPE_FIXED;
      clear.menuImgSrc = '/common/pics/ic_public_clean.svg';
      clear.menuText = $r('app.string.app_menu_clean');
      clear.onMenuClick = (): void => {
        let want: Want = {
          'bundleName': 'com.ohos.filemanager',
          'abilityName': 'RecycleBinServiceExtAbility',
          'parameters': {
            'mode': 'clear'
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
      menuInfoList.push(clear);
    }
    if ((AppStorage.get<number>('folderStatus') !== DeviceState.DEFAULT_STATE || DeviceHelper.isPad() ||
      DeviceHelper.isLargeScreenDevice()) && dockType === SmartDockConstants.RECENT_DOCK_TYPE &&
      !StatusBarServiceEventMgr.getInstance().isRegisterApp(appInfo.bundleName) &&
      !lockLayoutManager.isLockLayout()) {
      let removeFormRecent = new MenuInfo();
      removeFormRecent.menuType = CommonConstants.MENU_TYPE_FIXED;
      removeFormRecent.menuImgSrc = '/common/pics/ic_public_delete.svg';
      removeFormRecent.menuText = $r('app.string.delete_app');
      removeFormRecent.onMenuClick = (params: Map<string, Object>): void => {
        log.showDebug(`onMenuClick item removeFormRecent: ${appInfo?.bundleName}, dockType: ${dockType}`);
        HiSysEventUtil.reportDockDeleteRecentApp(appInfo.bundleName);
        this.cleanContinueItem(appInfo);
        this.mSmartDockModel.deleteDockItem(appInfo as DeleteDockItem, SmartDockConstants.RECENT_DOCK_TYPE);
      };
      menuInfoList.push(removeFormRecent);
    }
    return menuInfoList;
  }

  private cleanContinueItem(appInfo: DockItemInfo): void {
  }

  protected closeSceneSession(appInfo: AppItemInfo): void {
    const appInfoBundleName: string = appInfo.bundleName;
    log.showInfo(`menu closeSceneSession bundleName:${appInfoBundleName}, appIndex:${appInfo?.appIndex}`);
    let containerSessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance().getContainerSessionList();
    containerSessionList.forEach((item) => {
      if (appInfoBundleName === item.primarySession?.sceneInfo.bundleName &&
        appInfo.appIndex === item.primarySession?.sceneInfo.appIndex) {
        this.close(item.primarySession);
      }
      if (appInfoBundleName === item.secondarySession?.sceneInfo.bundleName &&
        appInfo.appIndex === item.secondarySession?.sceneInfo.appIndex) {
        this.close(item.secondarySession);
      }
    });
  }

  protected close(item: SCBSceneSession):void {
    if (!item) {
      return;
    }
    let missionId: number = item.session?.persistentId;
    let screenId: number = item.sceneInfo?.screenId;
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

  public getOpenMenu(appInfo: AppItemInfo): MenuInfo {
    let openMenu = new MenuInfo();
    openMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    openMenu.menuText = $r('app.string.app_menu_open');
    openMenu.menuKeyString = 'appOpen';
    openMenu.menuImgSrc = '/common/pics/ic_public_open.svg';
    openMenu.onMenuClick = (params: Map<string, Object>): void => {
      CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.DOCK_RIGHT_MENU);
      if (!params) {
        let mIconRect: RectInfo | undefined = DockItemPosition.getInstance().getIconRect();
        if (mIconRect) {
          params = new Map<string, Object>([[KeyConstants.ITEM_RECT, mIconRect]]);
        }
      }
      params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
      if (appInfo?.enableNewAppInstance) {
        params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
      }
      this.residentOnClick(null, appInfo as DockItemInfo, true, null, params);
    };
    return openMenu;
  }

  public getExitMenu(appInfo: AppItemInfo): MenuInfo {
    let exitMenu = new MenuInfo();
    exitMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    exitMenu.menuText = $r('app.string.app_menu_exit');
    exitMenu.menuKeyString = 'appExit';
    exitMenu.menuImgSrc = '/common/pics/ic_public_quit.svg';
    exitMenu.onMenuClick = async (): Promise<void> => {
      this.closeSceneSession(appInfo);
    };
    return exitMenu;
  }

  public getOpenNewWindowMenu(appInfo: DockItemInfo): MenuInfo {
    let openMenu = new MenuInfo();
    openMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    openMenu.menuText = $r('app.string.app_menu_open_new_window');
    openMenu.menuKeyString = 'appOpenNewWindow';
    openMenu.menuImgSrc = '/common/pics/ic_public_open.svg';
    openMenu.onMenuClick = (params: Map<string, Object>): void => {
      CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.DOCK_RIGHT_MENU);
      if (!params) {
        let mIconRect: RectInfo | undefined = DockItemPosition.getInstance().getIconRect();
        if (mIconRect) {
          params = new Map<string, Object>([[KeyConstants.ITEM_RECT, mIconRect]]);
        }
      }
      params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
      params.set(SCBConstants.OPEN_IN_NEW_WINDOW, true);
      if (appInfo?.enableNewAppInstance) {
        params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
      }
      this.residentOnClick(null, appInfo, true, null, params);
    };
    return openMenu;
  }

  /**
   * 构建非安装状态应用长按菜单Map
   * @param bundleName 应用bundleName
   * @returns Map<AppStatus, MenuInfo[]>
   */
  public buildNotInstalledAppMenu(item: DockItemInfo, dialog: CustomDialogController): Map<AppStatus, MenuInfo[]> {
    let notInstalledMenuMap: Map<AppStatus, MenuInfo[]> = new Map();
    let removeInfo: MenuInfo = this.getRemoveInfo(item, true, dialog);
    notInstalledMenuMap.set(AppStatus.PENDING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.WAITING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.DOWNLOADING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.WIFI_WAITING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.PAUSING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.INSTALL_WAITING, []);
    notInstalledMenuMap.set(AppStatus.INSTALLING, []);
    notInstalledMenuMap.set(AppStatus.WAIT_FOR_HARMONY, [this.getRemoveInfo(item, false, dialog)]);
    notInstalledMenuMap.set(AppStatus.UPDATING, [removeInfo]);
    return notInstalledMenuMap;
  }

  private getRemoveInfo(item: DockItemInfo, isRemove: boolean, dialog: CustomDialogController): MenuInfo {
    let removeInfo: MenuInfo = new MenuInfo();
    removeInfo.menuType = CommonConstants.MENU_TYPE_FIXED;
    if (isRemove) {
      removeInfo.menuImgSrc = '/common/pics/ic_public_remove.svg';
      removeInfo.menuText = $r('app.string.delete_app');
    } else {
      removeInfo.menuImgSrc = '/common/pics/ic_public_delete.svg';
      removeInfo.menuText = $r('app.string.uninstall');
    }
    removeInfo.onMenuClick = (): void => {
      this.curItem = item;
      this.isRemove = isRemove;
      if (item.callerName === CommonConstants.SOURCE_CLONE ||
        item.callerName === CommonConstants.SOURCE_UPGRADE) {
        let moveItemData: AppItemInfo = new AppItemInfo();
        moveItemData.iconResource = item.iconResource;
        AppStorage.setOrCreate('uninstallAppInfo', moveItemData);
        //弹出移除提示框
        dialog?.open();
      } else {
        this.deleNotInstallApp();
      }
    };
    return removeInfo;
  }

  public deleNotInstallApp(): void {
    if (!this.curItem) {
      return;
    }
    if (this.curItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let dockItem: DeleteDockItem = new DeleteDockItem();
      dockItem.bundleName = this.curItem.bundleName;
      dockItem.appIndex = this.curItem.appIndex;
      dockItem.shortcutId = this.curItem.shortcutId;
      dockItem.isDeleteAppToUninstallFolder = true;
      SmartDockModel.getInstance().deleteDockItem(dockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
      return;
    }
    SmartDockViewModel.getInstance(this.singleContext).deleteNotInstallApp(this.isRemove,
      this.curItem.bundleName, this.curItem.appIndex);
  }

  public getRemoveDialogName(): string | Resource {
    return $r('app.string.is_remove', this.curItem?.appName);
  }

  deleteDockItem(dockItem: DeleteDockItem, dockType: number): void {
    this.mSmartDockModel.deleteDockItem(dockItem, dockType); //
    let containerSessionList = this.getContainerSessionList();
    this.initRecentDataList(containerSessionList, TAG + '_deleteDockItem');
  }

  protected getContainerSessionList(): SCBSceneContainerSessionArray {
    log.showInfo('getContainerSessionList common');
    return SCBSceneSessionManager.getInstance().getContainerSessionList();
  }

  getSelectedItem(): DockItemInfo | undefined {
    log.showDebug(`getSelectedItem:` +
      ` bundleName: ${this.mSelectedItem?.bundleName}, abilityName: ${this.mSelectedItem?.abilityName}`);
    return this.mSelectedItem;
  }

  getSelectedDockType(): number {
    log.showDebug(`getSelectedDockType: ${this.mSelectedDockType}`);
    return this.mSelectedDockType;
  }

  /**
   * 初始化数据列表
   *
   * @param containerSessionList 会话列表
   */
  initRecentDataList(containerSessionList: SCBSceneContainerSession[], tag?: string): void {
    this.mSmartDockModel.initRecentDataList(containerSessionList, tag).catch((reason: Error) => {
      log.showError(`initRecentDataList failed ${reason?.toString()}`);
    });
  }

  /**
   * 更新数据列表
   *
   * @param containerSessionList 全屏会话列表
   * @param floatSceneSessionList 悬浮窗会话列表
   */
  updateRecentDataList(containerSessionList: Array<SCBSceneContainerSession>,
    floatSceneSessionList: Array<SCBSceneSession>, screenProperty: SCBScreenProperty): void {}

  /**
   * get snapshot
   *
   * @param missionIds missionid list
   * @return snapshot list
   */
  async getSnapshot(missionInfos: RecentBundleMissionInfo): Promise<SnapshotInfo[]> {
    const snapshotList: SnapshotInfo[] = await this.mSmartDockModel.getSnapshot(missionInfos);
    log.showDebug(`getSnapshot ${snapshotList?.length}`);
    return snapshotList;
  }

}