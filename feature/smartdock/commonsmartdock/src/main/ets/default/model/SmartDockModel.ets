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

import Prompt from '@ohos.promptAction';
import type image from '@ohos.multimedia.image';
import lazy { FixedDockResource } from '../common/constants/PcModeDockConstants';
import {
  DeliverUtil,
  AppItemInfo,
  Cache2RdbHelper,
  LauncherLayoutCacheUtil,
  ShortcutViewModel,
  GrayAppListManager,
  ResidentLayoutCacheMgr,
  DockUtils,
  FolderManager,
  ContractedFolderCommonViewModel,
  FolderCommonUtil,
  DragViewModelUtil,
  FolderDropType,
  FolderDragItem,
  ReceiveEventInfo,
  BadgeItemInfo,
  DeleteDockItem,
  AtomicServiceAppModel
} from '@ohos/launchercommon';
import {
  AppModel,
  CloseAppManager,
  CommonConstants,
  DockItemInfo,
  EventConstants,
  FolderModel,
  launcherAbilityManager,
  LayoutViewModel,
  RdbStoreManager,
  RecentBundleMissionInfo,
  StyleConstants
} from '@ohos/launchercommon';
import {
  CommonUtils,
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  ObjUtil,
  SingleBase,
  SingleContext,
  singleManager,
  PixelMapUtil
} from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { NumberConstants } from '@ohos/commonconstants';
import { SCBSceneSessionManager, SCBSceneContainerSession, SCBSceneSession, ResUtils,
  SCBSceneInfo, SceneInfoAdapterUtil } from '@ohos/windowscene';
import {
  DeviceHelper,
  HiSysEventUtil,
  localEventManager,
  ResourceManager
} from '@ohos/frameworkwrapper';
import lazy { PcModeDockUtils } from '../utils/PcModeDockUtils';
import SmartDockCloseAppHandler
  from '../common/SmartDockCloseAppHandler';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import type { SnapshotInfo } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { GridLayoutUtil } from '@ohos/launchercommon';
import { ShortcutInfo } from '@ohos/launchercommon';
import lazy PcModeContinuableModel from '../pcmode/model/PcModeContinuableModel';
import RecentDockModel from './RecentDockModel';
import { DockContinuableInfo } from '@ohos/launchercommon';
import { bundle, bundleManager } from '@kit.AbilityKit';
import StatusBarServiceEventMgr from '../manager/StatusBarServiceEventMgr';
import { DownloadInfoItem, AppStatus } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { SnapshotNodeType } from '@ohos/windowscene/src/main/ets/common/SnapshotNodeType';
import { CollaborationLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/dock/cache/CollaborationLayoutCacheMgr';

const TAG = 'SmartDockModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const KEY_NAME = 'name';
const FIRST_LOADED_SNAPSHOT_NUMBER = 15;
const GUIDE_BUNDLE_NAME = 'com.ohos.startupguide';

/**
 * SmartDock Model
 */
export default class SmartDockModel extends SingleBase {
  public static singleName: string = 'SmartDockModel';
  protected mAppModel: AppModel;
  private mResidentCacheMgr: ResidentLayoutCacheMgr;
  private mRecentDataList: RecentBundleMissionInfo[] = new Array<RecentBundleMissionInfo>();
  private readonly mCloseAppManager: CloseAppManager;
  private readonly mDevice = CommonConstants.DEFAULT_DEVICE_TYPE;
  private readonly mResourceManager: ResourceManager;
  private mRecentDockModel: RecentDockModel;
  protected mMissionInfoList: RecentBundleMissionInfo[] = [];
  protected appList: AppItemInfo[] = [];
  protected processCmdId: number = 0; // 外部调用指令id，用于指令打断，某些异步任务的指令被打断后，后续任务不再执行
  private isMobileOrTvDevice: boolean = DeviceHelper.isPhoneOrPad();

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mDevice = AppStorage.get('device') ?? CommonConstants.DEFAULT_DEVICE_TYPE;
    log.showDebug(`dockDevice: ${this.mDevice}`);
    this.mCloseAppManager = CloseAppManager.getInstance();
    if (this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.mCloseAppManager.registerCloseAppHandler(SmartDockCloseAppHandler.getInstance(this.singleContext));
    }
    this.mAppModel = AppModel.getInstance();
    this.mResourceManager = ResourceManager.getInstance();
    this.registerDockListener();
    log.showInfo(`start to getAppList to load SmartDock dockDevice: ${this.mDevice}`);
    this.mResidentCacheMgr = ResidentLayoutCacheMgr.getInstance();
    this.mRecentDockModel = RecentDockModel.getInstance(this.singleContext);
    AppStorage.setOrCreate('isFirstInit', true);
  }

  static getInstance(ctx?: SingleContext): SmartDockModel {
    return singleManager.get<SmartDockModel>(SmartDockModel, ctx);
  }

  // 其他地方不要调，这个要删掉的，临时给窗口用一下，若是要调，直接调用里面的方法
  async getResidentList(): Promise<void> {
    await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit(TAG);
  }

  /**
   * 更新resident dock item
   * @param bundleName
   * @param type 1: 普通安装场景(无需考虑快捷图标)
   * @param appIndex
   * @returns
   */
  async updateResidentDockItem(bundleName: string, appIndex?: number): Promise<void> {
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('bundleName is empty');
      return;
    }
    let bottomAppList: DockItemInfo[] = Array.from(this.mResidentCacheMgr.getAllDockItems());
    // 兼容克隆场景，安装和更新都需要更新dock内对应快捷图标
    this.updateDockShortcutWhenAppUpdate(bottomAppList, bundleName, appIndex);
    let appItemInfo: GridLayoutItemInfo | DockItemInfo | undefined =
      this.mResidentCacheMgr.getAppTypeItemByBundleName(bundleName, appIndex);
    if (!appItemInfo) {
      // 解决克隆场景，应用在桌面，快捷方式在dock不刷新的问题
      this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_updateDock'), bottomAppList, false);
      return;
    }
    let appDataFromSystem = await launcherAbilityManager.getAppInfoByBundleName(bundleName, '', appIndex);
    if (CheckEmptyUtils.isEmpty(appDataFromSystem)) {
      log.showWarn('appDataFromSystem is empty');
      return;
    }

    // 更新对应的数据到appItemInfo
    this.mResidentCacheMgr.fillDockItemByAppInfo(appItemInfo, appDataFromSystem);
    DeliverUtil.checkInstallSource(appItemInfo);
    // 更新对应的数据到数据库
    DockUtils.updateNewInstalledApp(appItemInfo);
    // 更新缓存
    this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_updateDock'), bottomAppList, false);
    const isDockApp: boolean = bottomAppList.findIndex(item => item.typeId === CommonConstants.TYPE_APP &&
      appItemInfo && item.bundleName === appItemInfo.bundleName && item.appIndex === appItemInfo.appIndex) >= 0;
    if (!isDockApp) {
      this.updateDockFolder(bottomAppList, appItemInfo);
    }
  }

  private updateDockFolder(bottomAppList: DockItemInfo[], appItemInfo: GridLayoutItemInfo | DockItemInfo): void {
    for (let i = 0; i < bottomAppList.length; i++) {
      if (bottomAppList[i].typeId === CommonConstants.TYPE_FOLDER) {
        let isFind: boolean =
          (bottomAppList[i].layoutInfo?.flat().findIndex(item => item.typeId === CommonConstants.TYPE_APP &&
            item.bundleName === appItemInfo.bundleName && item.appIndex === appItemInfo.appIndex) ?? -1) >= 0;
        if (isFind) {
          this.updateFolderItem(GridLayoutUtil.dockItemToGridLayout(bottomAppList[i]));
          break;
        }
      }
    }
  }

  private updateFolderItem(folderInfo: GridLayoutItemInfo): void {
    const folderMgr: FolderManager = FolderManager.getInstance();
    if (folderMgr.isFolderOpen() && folderMgr.getOpenFolderId() === folderInfo.folderId) {
      folderMgr.updateOpenFolderLayout('update opened dock folder item after BMS update',
        folderInfo.layoutInfo?.flat() ?? [], true);
    } else {
      folderMgr.updateFolderItems('update dock folder item after BMS update', folderInfo,
        folderInfo.layoutInfo?.flat() ?? []);
    }
  }

  /**
   * 更新dock内的shortcut
   * @param bottomAppList resident区应用list
   * @param bundleName
   * @returns
   */
  private updateDockShortcutWhenAppUpdate(bottomAppList: DockItemInfo[], bundleName: string,
    appIndex: number = 0): void {
    let shortcutInfoList: ShortcutInfo[] | undefined = AppModel.getInstance().getAllShortcutInfo(bundleName);
    if (CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
      // 兼容克隆场景，应用无拖拽加桌快捷方式，有应用内加桌快捷方式
      log.showWarn(`The app ${bundleName} does not have static shortcut.`);
    }
    if (CheckEmptyUtils.isEmptyArr(bottomAppList)) {
      log.showInfo('getAppTypeItem residentList is empty');
      return;
    }
    let updateFolderMaps: Map<DockItemInfo, GridLayoutItemInfo[]> = new Map();
    for (let i = 0; i < bottomAppList.length; i++) {
      let updateShortcuts: GridLayoutItemInfo[] = []
      if (bottomAppList[i].typeId === CommonConstants.TYPE_FOLDER) {
        this.updateShortcutInFolder(bottomAppList[i], bundleName, appIndex, updateShortcuts);
      } else if (bottomAppList[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        if (bottomAppList[i].bundleName === bundleName && (bottomAppList[i].appIndex ?? 0) === appIndex) {
          // 更新shortcut
          this.updateDockShortcut(bottomAppList[i], true);
        }
      }
      if (updateShortcuts.length > 0) {
        updateFolderMaps.set(bottomAppList[i], updateShortcuts);
      }
    }
    updateFolderMaps.forEach((updateItems: GridLayoutItemInfo[], folderItem: DockItemInfo) => {
      let dockFolder: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(folderItem);
      FolderManager.getInstance().updateFolderItems('update shortcut in folder', dockFolder, updateItems);
    })
  }

  private updateShortcutInFolder(folder: DockItemInfo, bundleName: string, appIndex: number = 0,
    updateShortcuts: GridLayoutItemInfo[]): void {
    folder.layoutInfo?.flat().forEach(appItem => {
      if (appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON &&
        appItem.bundleName === bundleName && (appItem.appIndex ?? 0) === appIndex) {
        updateShortcuts.push(appItem);
        this.updateDockShortcut(appItem, true);
      }
    })
  }

  /**
   * 更新dock区快捷图标
   *
   * @param dockItemInfo 待赋值的dock区元素
   * @param index 位置信息
   */
  private updateDockShortcut(dockItemInfo: GridLayoutItemInfo | DockItemInfo, isOperateDb: boolean = false): void {
    let shortcutInfoList: ShortcutInfo[] | undefined =
      AppModel.getInstance().getAllShortcutInfo(dockItemInfo.bundleName);
    if (CheckEmptyUtils.isEmpty(shortcutInfoList)) {
      shortcutInfoList = launcherAbilityManager.getShortcutInfoByBundleNameSync(dockItemInfo.bundleName);
      AppModel.getInstance().setShortcutInfo(dockItemInfo.bundleName, shortcutInfoList);
    }
    let shortcut: ShortcutInfo | undefined =
      shortcutInfoList?.find(shortcut => shortcut.id === dockItemInfo.shortcutId);
    if (shortcut) {
      dockItemInfo.appIconId = shortcut.iconId ?? 0;
      dockItemInfo.appLabelId = shortcut.labelId;
      dockItemInfo.badgeNumber = 0;
      dockItemInfo.appStatus = AppStatus.INSTALLED;
      dockItemInfo.keyName = DockItemInfo.getKeyName(dockItemInfo);

      let addShortcut: ShortcutInfo = ObjectCopyUtil.simpleClone(shortcut);
      addShortcut.appIndex = dockItemInfo.appIndex ?? CommonConstants.MAIN_APP_INDEX;
      ShortcutViewModel.getInstance().addShortcutToBMS(addShortcut);
    } else {
      // 克隆场景应用内加桌的快捷方式，BMS查询不到，需要点亮
      dockItemInfo.appStatus = AppStatus.INSTALLED;
    }
    if (isOperateDb) {
      // 更新本地数据库
      RdbStoreManager.getInstance().updateShortcutItemInfo(dockItemInfo);
    }
  }

  /**
   * pad自由多窗检测运行区的应用窗口, 如果常驻区已有应用图标显示则运行区不重复显示应用图标
   *
   * @param recentMissionsList 正在运行的应用实例列表
   */
  private removeResidentAppsFromRecent(recentMissionsList: RecentBundleMissionInfo[]): void {
    const collaborationList = CollaborationLayoutCacheMgr.getInstance().getAllDockItems();
    collaborationList?.forEach((item: DockItemInfo) => {
      const index = recentMissionsList.findIndex((missionInfo: RecentBundleMissionInfo) => {
        return missionInfo.bundleName === item.bundleName && missionInfo.appIndex === item.appIndex;
      });
      if (index != -1) {
        recentMissionsList.splice(index, 1);
      }
    });

    let mResidentList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
    for (let i = 0; i < mResidentList.length; i++) {
      const folderItemLength: number | undefined = mResidentList[i]?.layoutInfo?.flat().length;
      let folderItemList: GridLayoutItemInfo[] = [];
      if (folderItemLength && folderItemLength > 0) {
        mResidentList[i]?.layoutInfo?.flat().forEach((folderItem: GridLayoutItemInfo) => {
          folderItemList.push(folderItem);
        });
      }
      // 从常驻区文件夹中剔除掉已存在的运行应用
      folderItemList?.forEach((folderItem) => {
        const index = recentMissionsList.findIndex((missionInfo) =>
        missionInfo.bundleName === folderItem.bundleName && missionInfo.appIndex === folderItem.appIndex
        );
        if (index !== -1) {
          recentMissionsList.splice(index, 1);
        }
      });
      // 从常驻区非文件夹图标中剔除掉已存在的运行应用
      const index = recentMissionsList.findIndex((missionInfo: RecentBundleMissionInfo) => {
        return missionInfo.bundleName === mResidentList[i].bundleName &&
          missionInfo.appIndex === mResidentList[i].appIndex;
      });
      if (index != -1) {
        recentMissionsList.splice(index, 1);
      }
    }
  }

  public async initRecentDataList(containerSessionList: SCBSceneContainerSession[], tag?: string): Promise<void> {
    log.showInfo(`initRecentDataList invoked from ${tag}, containerSessionList length: ${containerSessionList?.length}`);
    const recentMissionsList = new Array<RecentBundleMissionInfo>();
    const missionInfos: RecentBundleMissionInfo[] = [];

    let appList = await this.mAppModel.getAppList();
    this.appList = appList;
    this.fillRecentMissionInfoList(appList, containerSessionList, recentMissionsList);

    recentMissionsList.forEach(item => {
      let missionInfo = new RecentBundleMissionInfo();
      missionInfo.appName = item.appName;
      missionInfo.bundleName = item.bundleName;
      missionInfo.appIndex = item.appIndex;
      missionInfo.missionInfoList = item.missionInfoList;
      missionInfos.push(missionInfo);
    });

    let lastRecentList: DockItemInfo[] | undefined = AppStorage.get('recentList');
    let lastRecentListLength: number = 0;
    if (lastRecentList) {
      lastRecentListLength = lastRecentList.length;
    }

    let reOrderRecentList = this.reOrderRecentList(recentMissionsList);
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      PcModeContinuableModel.getInstance().updateDisappearContinuableItem(reOrderRecentList);
    }
    AppStorage.setOrCreate('recentList', reOrderRecentList);
    AppStorage.setOrCreate('missionInfoList', missionInfos);
    this.mMissionInfoList = missionInfos;
    log.showInfo('init recentList.length:' + reOrderRecentList.length + 'missionInfoList.length:' + missionInfos.length);

    if (!this.isShowContinuableItem() && reOrderRecentList.length === 1 && lastRecentListLength === 0) {
      AppStorage.setOrCreate('showRecentAnimAppItem', reOrderRecentList[0]);
      AppStorage.setOrCreate<string>('showRecentAnimState', 'open');
    } else if (!this.isShowContinuableItem() && reOrderRecentList.length === 0 && lastRecentListLength === 1) {
      if (lastRecentList) {
        AppStorage.setOrCreate('showRecentAnimAppItem', lastRecentList[0]);
      }
      AppStorage.setOrCreate<string>('showRecentAnimState', 'close');
    } else {
      AppStorage.setOrCreate<string>('showRecentAnimState', 'none');
    }
  }

  fillRecentMissionInfoList(appList: AppItemInfo[], containerSessionList: SCBSceneContainerSession[],
                                  recentMissionsList: Array<RecentBundleMissionInfo>): void {
    let noAppDesktopIconList: string[] = [];
    for (let i = 0; i < containerSessionList.length; ++i) {
      let primarySession = containerSessionList[i].primarySession;
      let secondSession = containerSessionList[i].secondarySession;
      let allSession = new Array<SCBSceneSession>();
      if (primarySession?.sceneInfo) {
        log.showInfo('init primarySession:' + JSON.stringify(primarySession.sceneInfo) + ' i = ' + i);
      }

      if (primarySession) {
        allSession.push(primarySession);
      }
      if (secondSession) {
        allSession.push(secondSession);
      }
      if (CheckEmptyUtils.isEmptyArr(allSession)) {
        continue;
      }

      for (let j = 0; j < allSession.length; j++) {
        let currentSession = allSession[j];
        if (currentSession.sceneInfo.bundleName === GUIDE_BUNDLE_NAME) {
          continue;
        }
        // pad自由多窗语音助手壳应用包名和实际运行的应用包名不一致, 这里需要单独适配下
        const sessionBundleName: string = SceneInfoAdapterUtil.getAdapterBundleName(currentSession.sceneInfo.bundleName);
        const localMissionInfo: RecentBundleMissionInfo | undefined = recentMissionsList.find((item) =>
          item.bundleName === sessionBundleName && item.appIndex === currentSession.sceneInfo.appIndex);
        if (localMissionInfo) {
          localMissionInfo.missionInfoList?.push(containerSessionList[i]);
        } else {
          let appItem = appList.find(item => item.bundleName === sessionBundleName &&
            item.appIndex === currentSession.sceneInfo.appIndex);
          if (!appItem && currentSession.sceneInfo.isAtomicService) {
            appItem = AtomicServiceAppModel.getInstance().getAtomicInfoByBundleName(sessionBundleName);
          }
          let recentTaskInfo: RecentBundleMissionInfo | undefined = new RecentBundleMissionInfo();
          if (!appItem) {
            log.showInfo(`app not found in appList: ${sessionBundleName}`);
            recentTaskInfo = this.getAbilityItemInfo(currentSession);
            if (!recentTaskInfo) {
              log.showError(`getAbilityItemInfo failed, bundleName: ${sessionBundleName}, ` +
                `moduleName: ${currentSession.sceneInfo.moduleName}, ` +
                `abilityName: ${currentSession.sceneInfo.abilityName}`);
              continue;
            }
            noAppDesktopIconList.push(sessionBundleName);
          } else {
            this.appItemCopyToRecentTaskInfo(appItem, recentTaskInfo);
          }
          recentTaskInfo.missionInfoList = new Array<SCBSceneContainerSession>();
          recentTaskInfo.missionInfoList.push(containerSessionList[i]);
          recentMissionsList.push(recentTaskInfo);
        }
      }
    }
    AppStorage.setOrCreate('noAppDesktopIconList', noAppDesktopIconList);
  }

  /**
   * 查询找到对应AppItemInfo数据
   *
   * @param abilityInfoMap 总的应用数据map
   * @param bundleName 包名
   * @param moduleName 模块名
   * @param abilityName abilityName
   * @returns 对应的AppItemInfo数据
   */
  public getAbilityItemInfo(currentSession: SCBSceneSession): RecentBundleMissionInfo | undefined {
    const abilityItemInfo = SCBSceneSessionManager.getInstance().getAbilityInfo(currentSession.sceneInfo.bundleName,
      currentSession.sceneInfo.moduleName, currentSession.sceneInfo.abilityName);
    if (abilityItemInfo) {
      const appItemInfo = new RecentBundleMissionInfo();
      appItemInfo.appLabelId = abilityItemInfo.appLabelId;
      appItemInfo.appIconId = abilityItemInfo.appIconId;

      const cacheKey = appItemInfo.appLabelId + currentSession.sceneInfo.bundleName + currentSession.sceneInfo.moduleName;
      const appName: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, 'name') as string;
      if (!CheckEmptyUtils.isEmpty(appName)) {
        appItemInfo.appName = appName;
      } else {
        appItemInfo.appName = '';
      }
      appItemInfo.abilityName = abilityItemInfo.name;
      appItemInfo.moduleName = abilityItemInfo.moduleName;
      appItemInfo.bundleName = abilityItemInfo.bundleName;
      appItemInfo.appLabelId = abilityItemInfo.appLabelId;
      appItemInfo.appIconId = abilityItemInfo.appIconId;
      appItemInfo.keyName = RecentBundleMissionInfo.getKeyName(appItemInfo);
      return appItemInfo;
    }
    log.showWarn('getAbilityItemInfo find no key');
    return undefined;
  }

  initOpenAppNameList(appList: AppItemInfo[], recentMissionsList: Array<RecentBundleMissionInfo>): Array<string> {
    let openAppNameList: string[] = [];
    let lastMissionInfos: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');

    if (CheckEmptyUtils.isEmptyArr(openAppNameList)) {
      openAppNameList = [];
    }
    if (CheckEmptyUtils.isEmptyArr(lastMissionInfos)) {
      lastMissionInfos = [];
    }
    if (lastMissionInfos && lastMissionInfos.length < recentMissionsList.length) { // 应用首个窗口打开
      let items = recentMissionsList.filter(item => {
        let lastItem = lastMissionInfos?.find(lastItem => lastItem.bundleName === item.bundleName);
        return CheckEmptyUtils.isEmpty(lastItem);
      });
      if (items.length !== 1) {
        log.showError(`The window change is abnormal, item.length: ${items.length}}`);
        return openAppNameList;
      }

      items.forEach(async item => {
        let appItem = appList.find(appItem => appItem.bundleName === item.bundleName);
        let isAttentionItem: boolean = ((!CheckEmptyUtils.isEmpty(appItem)) && (appItem?.codePath !== '2'));
        let isEnabledItem: boolean = await bundle.isApplicationEnabled(item.bundleName);
        if (isAttentionItem && isEnabledItem && (!openAppNameList.includes(item.bundleName))) {
          log.showInfo(`openAppNameList update add: ${item.bundleName}`);
          openAppNameList.push(item.bundleName);
        }
      });
    }

    return openAppNameList;
  }

  reOrderRecentList(recentMissionsList: Array<RecentBundleMissionInfo>): Array<RecentBundleMissionInfo> {
    let recentList = AppStorage.get('recentList') as Array<RecentBundleMissionInfo>;
    let openAppNameList = AppStorage.get('openAppNameList') as Array<string>;
    let reOrderRecentList = new Array<RecentBundleMissionInfo>();

    if (!CheckEmptyUtils.isEmptyArr(recentList)) {
      recentList.forEach(item => {
        let newItem = recentMissionsList?.find(newItem => newItem.bundleName === item.bundleName &&
          newItem?.appIndex === item.appIndex);
        if (!CheckEmptyUtils.isEmptyArr(openAppNameList) && openAppNameList.includes(item.bundleName) &&
          CheckEmptyUtils.isEmpty(newItem)) {
          item.missionInfoList = [];
          reOrderRecentList.push(item);
        } else if (newItem) {
          reOrderRecentList.push(newItem);
        }
      });
    }

    if (!CheckEmptyUtils.isEmptyArr(recentMissionsList)) {
      recentMissionsList.forEach(item => {
        if (!reOrderRecentList.includes(item)) {
          reOrderRecentList.push(item);
        }
      });
    }

    // 常驻区存在的app, 运行区剔除
    this.removeResidentAppsFromRecent(reOrderRecentList);
    return reOrderRecentList;
  }

  fillReOrderRecentList(name: string, reOrderRecentList: Array<RecentBundleMissionInfo>): void {
    let appItem = this.appList.find(item => item.bundleName === name);
    if (!appItem) {
      log.showError(`app not found in appList: ${name}`);
      return;
    }
    let openAppInfo = new RecentBundleMissionInfo();
    openAppInfo.bundleName = appItem.bundleName;
    openAppInfo.abilityName = appItem.abilityName;
    openAppInfo.moduleName = appItem.moduleName;
    openAppInfo.appLabelId = appItem.appLabelId;
    openAppInfo.appIconId = appItem.appIconId;
    openAppInfo.appName = appItem.appName;
    openAppInfo.badgeNumber = appItem.badgeNumber;
    openAppInfo.appIndex = appItem.appIndex;
    openAppInfo.keyName = appItem.keyName;
    openAppInfo.missionInfoList = [];
    reOrderRecentList.push(openAppInfo);
  }

  /**
   * delete app from smartdock
   *
   * @param appInfo
   * @param dockType
   */
  deleteDockItem(dockItem: DeleteDockItem, dockType: number): boolean {
    log.showInfo(`deleteDockItem dockType ${dockType}, dockItem: ${dockItem?.bundleName}，appIndex:${dockItem?.appIndex}`);
    ++this.processCmdId;
    if (SmartDockConstants.RESIDENT_DOCK_TYPE === dockType) {
      if (dockItem.bundleName) {
        if (this.isMobileOrTvDevice && !this.isDockItemExistInDock(dockItem as AppItemInfo)) {
          return false;
        }
        if (!this.isMobileOrTvDevice || dockItem.isDeleteAppToUninstallFolder) {
          log.showInfo(`deleteDockItem in smartdock, bundleName: ${dockItem.bundleName}`);
          RdbStoreManager.getInstance().deleteSmartDockItem(dockItem.bundleName, dockItem.appIndex, dockItem.shortcutId, false);
        }
        return this.deleteResistDockItem(dockItem);
      }
    } else if (SmartDockConstants.RECENT_DOCK_TYPE === dockType) {
      if (this.isMobileOrTvDevice && !this.isBundleNameAppExistInRecent(dockItem.bundleName)) {
        return false;
      }
      return this.deleteRecentDockItem(dockItem);
    } else if (SmartDockConstants.RESIDENT_DOCK_NOT_INSTALL_TYPE === dockType) {
      if (this.isMobileOrTvDevice && !this.isDockItemExistInDock(dockItem as AppItemInfo)) {
        return false;
      }
      RdbStoreManager.getInstance().deleteSmartDockItem(dockItem.bundleName, dockItem.appIndex, dockItem.shortcutId, false);
      return this.deleteResistDockItem(dockItem);
    } else if (SmartDockConstants.RESIDENT_DOCK_REMOVE_TYPE === dockType) {
      if (this.isMobileOrTvDevice && !this.isDockItemExistInDock(dockItem as AppItemInfo)) {
        return false;
      }
      RdbStoreManager.getInstance().deleteSmartDockItem(dockItem.bundleName, dockItem.appIndex, dockItem.shortcutId, false);
      let res = this.deleteResistDockItem(dockItem);
      return res;
    }
    return false;
  }

  /**
   * add appItem to smartdock
   *
   * @param appInfo
   * @param index
   */
  addToSmartDock(appInfo: AppItemInfo | DockItemInfo, index?: number): boolean {
    log.showInfo(`addToSmartDock appInfo: ${appInfo?.bundleName}`);
    ++this.processCmdId;
    if (!GridLayoutUtil.isIconType(appInfo.typeId) && !GridLayoutUtil.isSmallFolder(appInfo as DockItemInfo)) {
      log.showInfo('the typeId of appInfo is not app or small folder and cannot be added to the smart dock!');
      return false;
    }
    let mResidentList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();

    // 上限检查
    if (this.isBeyond(mResidentList)) {
      log.showWarn('addToSmartDock isBeyond: true');
      return false;
    }

    const isDuplicateAdd: boolean = this.isDuplicate(mResidentList, appInfo);
    log.showDebug(`addToSmartDock flag: ${isDuplicateAdd}`);
    if (isDuplicateAdd) {
      return false;
    }
    const dockItemCount = mResidentList.length;
    const dockItemInfo = this.buildDockItemInfo(appInfo);
    const dragItemType: number = AppStorage.get('dragItemType') ?? CommonConstants.DRAG_FROM_UNKNOWN;
    this.getResidentListElement(mResidentList, dockItemCount, dockItemInfo, dragItemType, index);
    mResidentList.forEach((element, index) => {
      element.row = 0;
      element.column = index;
      element.visible = true;
      element.borderVisible = false;
      element.shake = 0;
    });
    // 更新dock items
    this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_add'), mResidentList, true);
    this.mRecentDataList = AppStorage.get('recentList') ?? [];
    for (let i = 0; i < this.mRecentDataList.length; i++) {
      for (let j = 0; j < mResidentList.length; j++) {
        let recentKeyName = AppItemInfo.getKeyName(this.mRecentDataList[i]);
        let residentKeyName = AppItemInfo.getKeyName(mResidentList[j]);
        if (recentKeyName === residentKeyName &&
          CheckEmptyUtils.isEmpty(this.mRecentDataList[i]?.persistentId) &&
          this.checkAppInstanceKey(this.mRecentDataList[i]?.appInstanceKey, mResidentList[j]?.appInstanceKey)) {
          this.mRecentDataList.splice(i, 1);
          i--;
          break;
        }
      }
    }
    AppStorage.setOrCreate('recentList', this.mRecentDataList);
    log.showDebug(`addToSmartDock appInfo: ${appInfo.bundleName}`);
    return true;
  }

  public checkAppInstanceKey(appInstanceKey?: string, toAppInstanceKey?: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(appInstanceKey) && CheckEmptyUtils.checkStrIsEmpty(toAppInstanceKey)) {
      return true;
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(appInstanceKey) && CheckEmptyUtils.checkStrIsEmpty(toAppInstanceKey)) {
      return false;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(appInstanceKey) && !CheckEmptyUtils.checkStrIsEmpty(toAppInstanceKey)) {
      return false;
    }
    return appInstanceKey === toAppInstanceKey;
  }

  public buildDockItemInfo(appInfo: AppItemInfo | DockItemInfo): DockItemInfo {
    let isFolder: boolean = appInfo.typeId === CommonConstants.TYPE_FOLDER;
    const dockItemInfo = new DockItemInfo();
    dockItemInfo.itemType = appInfo.typeId;
    dockItemInfo.typeId = appInfo.typeId;
    dockItemInfo.editable = true;
    dockItemInfo.appId = RdbStoreManager.getInstance().generateRandomUUID(false);
    dockItemInfo.appName = appInfo.appName;
    dockItemInfo.bundleName = appInfo.bundleName;
    dockItemInfo.moduleName = appInfo.moduleName;
    dockItemInfo.abilityName = appInfo.abilityName;
    dockItemInfo.keyName = appInfo.keyName;
    dockItemInfo.appIconId = appInfo.appIconId;
    dockItemInfo.appLabelId = appInfo.appLabelId;
    dockItemInfo.applicationLabelId = appInfo.applicationLabelId;
    dockItemInfo.applicationName = appInfo.applicationName;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.isUninstallAble = appInfo.isUninstallAble;
    dockItemInfo.codePath = appInfo?.codePath;
    dockItemInfo.visible = true;
    dockItemInfo.row = 0;
    dockItemInfo.iconResource = appInfo?.iconResource;
    dockItemInfo.column = appInfo.column;
    dockItemInfo.area = [1, 1];
    dockItemInfo.badgeNumber = appInfo.badgeNumber;
    dockItemInfo.layoutInfo = isFolder ? (appInfo as DockItemInfo).layoutInfo : undefined;
    dockItemInfo.appIndex = appInfo.appIndex;
    dockItemInfo.shortcutId = appInfo.shortcutId;
    dockItemInfo.enableNewAppInstance = appInfo.enableNewAppInstance;
    dockItemInfo.appInstanceKey = appInfo?.appInstanceKey;
    return dockItemInfo;
  }

  /**
   * send requset to add appItem to pageDesktop
   *
   * @param appInfo
   */
  addToPageDesk(appInfo: DockItemInfo): void {
    if (appInfo.itemType === CommonConstants.TYPE_APP || appInfo.itemType === CommonConstants.TYPE_SHORTCUT_ICON || appInfo.itemType === undefined) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD, appInfo).then(() => {
      }, () => {
      });
    } else {
      try {
        Prompt.showToast({
          message: $r('app.string.disable_add_to_dock')
        });
      } catch (err) {
        log.error('[addToPageDesk showToast] failed, error -> ', err);
      }
    }
  }

  /**
   * move appItem from itemIndex to insertIndex
   *
   * @param insertIndex
   * @param itemIndex
   */
  insertItemToIndex(insertIndex: number, itemIndex: number): void {
    log.showInfo(`insertItemToIndex insertIndex: ${insertIndex}, itemIndex: ${itemIndex}, mDevice: ${this.mDevice}`);
    const dockResidentNum = 2;
    if ((insertIndex < dockResidentNum || itemIndex < dockResidentNum) &&
      this.mDevice === CommonConstants.PAD_DEVICE_TYPE) {
      try {
        Prompt.showToast({
          message: $r('app.string.disable_to_move')
        });
      } catch (err) {
        log.error('[insertItemToIndex showToast] failed, error -> ', err);
      }
      return;
    }
    let mResidentList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
    if (itemIndex < insertIndex) {
      const selectItem = mResidentList[itemIndex];
      mResidentList.splice(insertIndex, 0, selectItem);
      mResidentList.splice(itemIndex, 1);
    }
    if (itemIndex > insertIndex) {
      const selectItem = mResidentList[itemIndex];
      mResidentList.splice(itemIndex, 1);
      mResidentList.splice(insertIndex, 0, selectItem);
    }
    this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_insertItem'), mResidentList, true);
  }

  /**
   * register residentList dock ADD ITEM Listener
   * local listener for model to model send and receive msg
   */
  registerDockListener(): void {
  /**
   * 开发快捷方式需求时，开发不熟悉PC桌面代码，为了不引入问题，拆分了一个PcSmarkDockModel新类继承当前父类进行引用，构造函数也进行了继承
   * 系统在进行父类构造函数初始化的时候，进行了事件注册，在子类构造函数进行初始化也进行了事件注册，导致事件重复注册，
   * 后面在事件消费过程中进行了事件重复消费，进行dock栏快捷方式添加的时候，会提示重复添加
   * 增加全局变量registerDockListenerFlag = true时，不进行事件重复注册，进行问题规避
   * */
    if (AppStorage.get('registerDockListenerFlag')) {
      return;
    }
    localEventManager.registerEventListener(this.mAddToDockListener, [
      EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD,
      EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE,
      EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REMOVE,
      EventConstants.EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE,
      EventConstants.EVENT_BADGE_UPDATE,
      EventConstants.EVENT_REQUEST_APPGALLERY_CREATED,
      EventConstants.EVENT_REQUEST_RESIDENT_DOCK_NOT_INSTALL_ITEM_DELETE
    ]);
    AppStorage.setOrCreate('registerDockListenerFlag', true);
    log.showDebug('local listener on create');
  }

  /**
   * unregister residentList dock ADD ITEM Listener
   */
  unregisterDockListener(): void {
    localEventManager.unregisterEventListener(this.mAddToDockListener);
    AppStorage.setOrCreate('registerDockListenerFlag', false);
    log.showDebug('local listener on destroy');
  }

  /**
   * ??bundleName??shortcutInfo
   *
   * @param bundleName
   */
  getShortcutInfo(bundleName: string): ShortcutInfo[] | undefined {
    return this.mAppModel.getShortcutInfo(bundleName);
  }

  async getShortcutInfoFromManager(bundleName: string): Promise<ShortcutInfo[] | undefined> {
    let shortcut = this.mAppModel.getShortcutInfo(bundleName);
    if (CheckEmptyUtils.isEmptyArr(shortcut)) {
      shortcut = await this.mAppModel.getShortcutInfoFromManager(bundleName);
    }
    return shortcut;
  }

  /**
   * @param cacheKey
   * @return cache
   */
  getAppName(itemInfo: AppItemInfo): string {
    let cacheKey: string = `${itemInfo.appLabelId}${itemInfo.bundleName}${itemInfo.moduleName}`;
    let resName: string = this.mResourceManager.getAppResourceCache(cacheKey, KEY_NAME) as string;
    if (!CommonUtils.isInvalid(resName) && ((itemInfo.appIndex ?? 0) > 0)) {
      return `${resName}${itemInfo.appIndex}`;
    }
    return resName;
  }

  async getSnapshot(missionInfos: RecentBundleMissionInfo): Promise<SnapshotInfo[]> {
    const snapshotList: SnapshotInfo[] = [];
    if (this.mDevice !== CommonConstants.PAD_DEVICE_TYPE && !SCBSceneSessionManager.getInstance().isPcMode()) {
      return snapshotList;
    }
    AppStorage.setOrCreate('gettingSnapshotStatus', true);
    let isMultipleInstanceSplit: boolean = false;
    log.showInfo(`getSnapshot start, missionInfoList.length: ${missionInfos.missionInfoList.length}`);
    let currWidth: number = 0;
    for (const item of missionInfos.missionInfoList) {
      // 在应用窗口最小化时才会自动截图，需要调用SceneSession提供的getSnapshot获取前台应用截图，获取PixelMap设置到image中
      let imagePixelMap: image.PixelMap | undefined;
      let snapshot: SnapshotInfo = {
        name: '',
        left: StyleConstants.DEFAULT_12,
        missionId: -1,
        image: imagePixelMap,
        boxSize: StyleConstants.DEFAULT_SMART_DOCK_MISSION_IMAGE_WIDTH,
        bundleName: '',
        shortcutId: missionInfos.shortcutId,
        appLabelId: -1
      };
      let sceneInfo: SCBSceneInfo | undefined = undefined;
      if (item.secondarySession?.sceneInfo?.bundleName === missionInfos.bundleName) {
        if (item.primarySession?.sceneInfo?.bundleName === missionInfos.bundleName) {
          if (isMultipleInstanceSplit === false) {
            isMultipleInstanceSplit = true;
            sceneInfo = item.primarySession?.sceneInfo;
            snapshot.missionId = item.primarySession?.session?.persistentId;
          } else {
            isMultipleInstanceSplit = false;
            sceneInfo = item.secondarySession?.sceneInfo;
            snapshot.missionId = item.secondarySession?.session?.persistentId;
          }
        } else {
          sceneInfo = item.secondarySession?.sceneInfo;
          snapshot.missionId = item.secondarySession?.session?.persistentId;
        }
      } else {
        sceneInfo = item.primarySession?.sceneInfo;
        snapshot.missionId = item.primarySession?.session?.persistentId ?? -1;
      }
      snapshot.bundleName = item.secondarySession?.sceneInfo?.bundleName === missionInfos.bundleName ?
        (item.secondarySession?.sceneInfo?.bundleName ?? '') :
        (item.primarySession?.sceneInfo?.bundleName ?? '');
      const appIndex = item.secondarySession?.sceneInfo?.bundleName === missionInfos.bundleName ?
        item.secondarySession?.sceneInfo?.appIndex :
        item.primarySession?.sceneInfo?.appIndex;
      const nodeType = GrayAppListManager.getInstance().isGrayAppIcon({bundleName: snapshot.bundleName, appIndex: appIndex}) ?
      SnapshotNodeType.LEASH_NODE : SnapshotNodeType.DEFAULT_NODE;
      imagePixelMap = await this.getSnapShotImagePixelMap(snapshot.missionId, nodeType) as image.PixelMap;
      snapshot.sceneSession = item;
      snapshot.image = imagePixelMap;
      snapshot.nodeType = nodeType;
      let imageSize: image.Size | undefined = await this.getImageInfo(imagePixelMap);
      if (imageSize) {
        log.showInfo(`getSnapshot, bundleName: ${snapshot.bundleName}, ${imageSize.height}, ${imageSize.width}`);
        snapshot.boxSize = Math.ceil(StyleConstants.DEFAULT_SMART_DOCK_MISSION_IMAGE_HEIGHT / imageSize.height * imageSize.width);
        if (snapshot.boxSize > FixedDockResource.SNAPSHOT_ITEM_MAX_WIDTH) {
          snapshot.boxSize = FixedDockResource.SNAPSHOT_ITEM_MAX_WIDTH;
        }
      }
      // the minimum width
      snapshot.name = missionInfos.appName;
      await PcModeDockUtils.getRecentAppInfo(sceneInfo, snapshot);
      snapshotList.push(snapshot);
      currWidth += snapshot.boxSize < 100 ? 100 : snapshot.boxSize;
      // 当前hover的应用与当前加载的应用不一致，则中止刷新
      let hoverItemBundleName: string | undefined = AppStorage.get<string>('hoverItemBundleName');
      if (hoverItemBundleName && hoverItemBundleName !== missionInfos.bundleName) {
        log.showInfo('getSnapshot end, ' +
          `hoverItemBundleName: ${hoverItemBundleName}, missionInfos.bundleName: ${missionInfos.bundleName}`);
        AppStorage.setOrCreate('gettingSnapshotStatus', false);
        return snapshotList;
      }
    }

    if (currWidth !== 0) {
      currWidth = 0;
      AppStorage.setOrCreate('snapshotList', snapshotList);
    }

    AppStorage.setOrCreate('gettingSnapshotStatus', false);
    log.showInfo(`getSnapshot end, snapshotList.length: ${snapshotList.length}`);
    return snapshotList;
  }

  private findDeleteApp(appList: GridLayoutItemInfo[], deleteItemInfo: DeleteDockItem): boolean {
    let index = this.getDeleteIndex(appList, deleteItemInfo);
    if (index < 0) {
      log.showError(`delDockItemInFolder item is not in folder ${deleteItemInfo.bundleName}`);
      return false;
    }
    this.spliceAppList(appList, deleteItemInfo);
    return true;
  }

  private spliceAppList(appList: GridLayoutItemInfo[], deleteItemInfo: DeleteDockItem): void {
    let tempAppList: GridLayoutItemInfo[] = [];
    tempAppList = JSON.parse(JSON.stringify(appList));
    tempAppList = tempAppList.filter((item) => {return this.compareDelInfo(item, deleteItemInfo)});
    tempAppList.forEach((item) => {
      let index = this.getDeleteIndex(appList, item as DeleteDockItem);
      if (index >= 0) {
        appList.splice(index, 1);
      }
    });
  }

  private getDeleteIndex(appList: GridLayoutItemInfo[] | DockItemInfo[], deleteItemInfo: DeleteDockItem): number {
    return appList.findIndex((item: GridLayoutItemInfo | DockItemInfo) => {
      return this.compareDelInfo(item as GridLayoutItemInfo, deleteItemInfo);
    });
  }

  private compareDelInfo(item: GridLayoutItemInfo, deleteItemInfo: DeleteDockItem): boolean {
    if (!CheckEmptyUtils.isEmpty(deleteItemInfo.shortcutId)) {
      return item.bundleName === deleteItemInfo.bundleName && item.shortcutId === deleteItemInfo.shortcutId &&
        item.appIndex === deleteItemInfo.appIndex;
    } else if (!CheckEmptyUtils.isEmpty(deleteItemInfo.keyName)) {
      return item.keyName === deleteItemInfo.keyName;
    } else if (!CheckEmptyUtils.isEmpty(deleteItemInfo.appIndex)) {
      return item.bundleName === deleteItemInfo.bundleName && item.appIndex === deleteItemInfo.appIndex;
    } else {
      return item.bundleName === deleteItemInfo.bundleName;
    }
  }

  /**
   * 从dock区文件夹中删除应用
   *
   * @param dockItem 待删除的应用
   * @param deleteItemInfo 删除的应用item
   * @param residentIndex dock栏索引值
   * @return 是否需要立即刷新dock栏列表
   */
  public delDockItemInFolder(dockItem: DockItemInfo, deleteItemInfo: DeleteDockItem, residentIndex: number): boolean {
    if (CheckEmptyUtils.isEmpty(dockItem)) {
      return true;
    }

    // 将文件夹内应用展开成一维数组
    let appList: GridLayoutItemInfo[] = dockItem.layoutInfo ? dockItem.layoutInfo.flat() : new Array<GridLayoutItemInfo>();

    // 删除应用
    this.findDeleteApp(appList, deleteItemInfo)

    // 删除文件夹中的加号
    let len: number = appList.length - 1;
    if (appList[len]?.typeId === CommonConstants.TYPE_ADD) {
      appList.splice(len, 1);
    }
    return this.releaseNewFolder(dockItem, deleteItemInfo, residentIndex, appList);
  }

  private releaseNewFolder(dockItem: DockItemInfo, deleteItemInfo: DeleteDockItem, residentIndex: number,
    appList: GridLayoutItemInfo[]): boolean {
    // 文件夹解散
    let deleteItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    deleteItem.keyName = deleteItemInfo.keyName;
    let dragParam: FolderDragItem = DragViewModelUtil.getDragParams([deleteItem]);
    dragParam.setAppList(appList);
    ContractedFolderCommonViewModel.getInstance()
      .drop('delDockItemInFolder', dockItem.keyName, FolderDropType.DROP_REFRESH_DOCK, dragParam);
    if (FolderCommonUtil.isNeedReleased(appList, dockItem.keyName)) {
      if (dockItem.layoutInfo) {
        // dock文件夹解散，删除对应的recent应用
        RecentDockModel.getInstance().deleteRecentDockItem(dockItem.layoutInfo[0][0] as DeleteDockItem);
      }
      let folderDescription: string =
        deleteItemInfo.isDeleteAppToUninstallFolder ? 'appRemovedInFolder' : 'iconDroppedOut';
      HiSysEventUtil.reportDissolveFolder(NumberConstants.CONSTANT_NUMBER_TWO, false, folderDescription,
        dockItem?.keyName);
    }
    log.showInfo(`delDockItemInFolder: remove ${deleteItemInfo.bundleName} from folder ${dockItem.keyName}`);
    return false;
  }

  protected appItemCopyToRecentTaskInfo(appItem: AppItemInfo, recentTaskInfo: RecentBundleMissionInfo): void {
    recentTaskInfo.bundleName = appItem.bundleName;
    recentTaskInfo.abilityName = appItem.abilityName;
    recentTaskInfo.moduleName = appItem.moduleName;
    recentTaskInfo.keyName = appItem.keyName;
    recentTaskInfo.appLabelId = appItem.appLabelId;
    recentTaskInfo.appIconId = appItem.appIconId;
    recentTaskInfo.appName = appItem.appName;
    recentTaskInfo.codePath = appItem?.codePath;
    recentTaskInfo.badgeNumber = appItem.badgeNumber;
    recentTaskInfo.appIndex = appItem.appIndex;
    recentTaskInfo.enableNewAppInstance = appItem.enableNewAppInstance;
    recentTaskInfo.appInstanceKey = appItem?.appInstanceKey;
  }

  private delDockItemInFolderWhenTimeout(appList: GridLayoutItemInfo[], dockItem: DockItemInfo,
                                         residentList?: DockItemInfo[], residentIndex?: number): void {
    if (appList.length > 0) {
      dockItem.layoutInfo = [appList];
      DockUtils.formatFolderInfo(dockItem);
      // 移除解散文件夹数据
      RdbStoreManager.getInstance().deleteItemByInfoId(dockItem.appId);
      const lastItem: DockItemInfo = AppModel.getInstance().gridLayoutToDockItem(dockItem?.layoutInfo[0][0]);
      if (residentList) {
        residentList.splice(residentIndex ?? 0, 1, lastItem);
        this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_del_if'), residentList, true);
      } else {
        let mResidentList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
        mResidentList.splice(residentIndex ?? 0, 1, lastItem);
        this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_del_else'), mResidentList, true);
      }
    } else {
      if (residentList) {
        residentList.splice(residentIndex ?? 0, 1);
        this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_else_if'), residentList, true);
      } else {
        let mResidentList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
        mResidentList.splice(residentIndex ?? 0, 1);
        this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_else_else'), mResidentList, true);
      }
    }
  }

  /**
   * 刷新resident list
   * @returns
   */
  async refreshDockResidentList(): Promise<void> {
    this.mResidentCacheMgr.refreshDockResidentList();
  }

  /**
   *
   * @param persistentId
   * @returns
   */
  async getSnapShotImagePixelMap(persistentId: number, snapNode: SnapshotNodeType): Promise<image.PixelMap | undefined> {
    let imagePixelMap: image.PixelMap | undefined;
    const mainSession: SCBSceneSession = SCBSceneSessionManager.getInstance().findMainSessionById(persistentId);
    let useNewSnapshot: boolean = true;
    if (!mainSession.isActive && snapNode === SnapshotNodeType.LEASH_NODE) {
      useNewSnapshot = false;
    }
    log.showInfo(`getSnapShotImagePixelMap snapNode: ${snapNode}, ${mainSession?.isActive}, ${persistentId}, ${useNewSnapshot}`);
    await sceneSessionManager.getSessionSnapshotPixelMap(persistentId, SmartDockConstants.IMAGE_SAMPLING_RATIO,
      SnapshotNodeType.LEASH_NODE, useNewSnapshot).then((result: image.PixelMap) => {
      if (result) {
        imagePixelMap = result;
        PixelMapUtil.addName(imagePixelMap, `smartDockSnapImage_${persistentId}`);
      } else {
        log.error('==imageimagePixelMap is null...');
      }
    }).catch((err: Error) => {
      log.showError('Failed to snapshot window.:%{public}s', err.message);
    });
    return imagePixelMap;
  }

  private getResidentListElement(mResidentList: DockItemInfo[], dockItemCount: number, dockItemInfo: DockItemInfo, dragItemType: number, index?: number): void {
    if (AppStorage.get('device') === CommonConstants.DEFAULT_DEVICE_TYPE &&
      dragItemType === CommonConstants.DRAG_FROM_DOCK) {
      mResidentList.splice(dockItemInfo.column ?? 0, 0, dockItemInfo);
    } else {
      if (dockItemCount === 0 || index === undefined || index >= dockItemCount || index < 0) {
        this.checkInRecent(dockItemInfo);
        mResidentList.push(dockItemInfo);
      } else {
        mResidentList.splice(index, 0, dockItemInfo);
      }
    }
  }

  private checkInRecent(dockItemInfo: DockItemInfo): void {
    let recentList: RecentBundleMissionInfo[] | undefined = AppStorage.get('recentList');
    if (!recentList || recentList.length !== 1 || recentList[0].bundleName !== dockItemInfo.bundleName) {
      return;
    }
    if (!this.isShowContinuableItem()) {
      AppStorage.setOrCreate('showRecentAnimAppItem', dockItemInfo);
      AppStorage.setOrCreate<string>('showRecentAnimState', 'close');
    }
  }

  protected isShowContinuableItem(): boolean {
    let deviceInfo: DockContinuableInfo | undefined = AppStorage.get('continueDeviceInfo');
    let isShowContinuableItem: boolean = false;
    if (deviceInfo && ObjUtil.isValid(deviceInfo.bundleName) &&
    ObjUtil.isValid(deviceInfo.sourceDeviceName)) {
      isShowContinuableItem = true;
    }
    return isShowContinuableItem;
  }

  /**
   * check app exist in list
   *
   * @param list
   * @param appInfo
   * @return true: not exit, editable
   * @return false: exited
   */
  protected isDuplicate(list: AppItemInfo[], appInfo: AppItemInfo | DockItemInfo): boolean {
    let duplicateAddTips = ResUtils.getInnerString($r('app.string.duplicate_add'));

    // shortcutIdTemp === shortcutId 支持快捷方式和主应用同时添加dock栏
    const shortcutId = appInfo?.shortcutId ?? '';
    for (let i = 0; i < list.length; i++) {
      let shortcutIdTemp = list[i].shortcutId ?? '';
      if (list[i].keyName === appInfo.keyName &&
        list[i].appIndex === appInfo.appIndex && shortcutIdTemp === shortcutId) {
        if (AppStorage.get('device') !== CommonConstants.DEFAULT_DEVICE_TYPE) {
          try {
            Prompt.showToast({
              message: duplicateAddTips,
              bottom: this.getToastBottom()
            });
          } catch (err) {
            log.error('[isDuplicate showToast] failed, error -> ', err);
          }
        }
        return true;
      }
    }
    return false;
  }

  private isBeyond(list: AppItemInfo[]): boolean {
    log.showInfo(`isBeyond length: ${list.length}`);
    let isBeyoud: boolean = list.length >= CommonConstants.RESIDENT_ITEM_MAX_NUM;

    if (isBeyoud) {
      try {
        Prompt.showToast({
          message: $r('app.string.add_beyond_max'),
          bottom: this.getToastBottom()
        });
      } catch (err) {
        log.error('[isBeyond showToast] failed, error -> ', err);
      }
    }

    return isBeyoud;
  }

  protected getToastBottom(): number {
    return ResUtils.getNumber($r('app.float.dock_toast_bottom')) * Number(AppStorage.get('screenHeight'));
  }

  /**
   * resident local Listener
   */
  private readonly mAddToDockListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: AppItemInfo | DockItemInfo[] | BadgeItemInfo): void => {
      log.showDebug(`receive event: ${event}, params: ${JSON.stringify(params)}`);
      if (event === EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD) {
        this.addToSmartDock(params as AppItemInfo);
      } else if (event === EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE) {
        this.deleteDockItem(params as DeleteDockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
      } else if (event === EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REMOVE) {
        this.deleteDockItem(params as DeleteDockItem, SmartDockConstants.RESIDENT_DOCK_REMOVE_TYPE);
      } else if (event === EventConstants.EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE) {
        this.deleteDockItem(params as DeleteDockItem, SmartDockConstants.RECENT_DOCK_TYPE);
      } else if (event === EventConstants.EVENT_REQUEST_RESIDENT_DOCK_NOT_INSTALL_ITEM_DELETE) {
        this.deleteDockItem(params as DeleteDockItem, SmartDockConstants.RESIDENT_DOCK_NOT_INSTALL_TYPE);
      } else if (event === EventConstants.EVENT_BADGE_UPDATE) {
        this.updateBadgeNum(params as BadgeItemInfo);
      } else if (event === EventConstants.EVENT_REQUEST_APPGALLERY_CREATED) {
        this.updateDockAppInfos(params as DockItemInfo[]);
      }
    }
  };

  private updateBadgeNum(badgeInfo: BadgeItemInfo): void {
    log.showInfo(`updateBadgeNum badgeInfo is ${JSON.stringify(badgeInfo)}`);
    let residentListTemp: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
    if (!CheckEmptyUtils.isEmptyArr(residentListTemp)) {
      for (let i = 0; i < residentListTemp.length; i++) {
        if (this.checkSameDockItem(badgeInfo, residentListTemp[i]) &&
          residentListTemp[i].itemType === CommonConstants.TYPE_APP) {
          this.dealDockItemWithNewBadge(residentListTemp[i], badgeInfo.isShow ? (badgeInfo.badgeNumber ?? 0) : 0);
          LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_updateBadgeNum'), residentListTemp);
          break;
        }
      }
    }

    // 刷新角标时，同步刷新最近任务区
    this.mRecentDockModel.updateBadgeNum(badgeInfo);

    // 角标消息发送处理时，要进行分身逻辑区分，避免dock栏运行区分身图标信息被刷成与主应用一直情况
    if (this.mDevice === CommonConstants.PAD_DEVICE_TYPE || SCBSceneSessionManager.getInstance().isPcMode()) {
      this.mRecentDataList = AppStorage.get('recentList') ?? [];
      log.showDebug('updateBadgeNum recent ');
      if (!CheckEmptyUtils.isEmptyArr(this.mRecentDataList)) {
        for (let i = 0; i < this.mRecentDataList.length; i++) {
          let curRecentData: RecentBundleMissionInfo = this.mRecentDataList[i];
          if (this.checkSameDockItem(curRecentData, badgeInfo)) {
            let recentBundleMission: RecentBundleMissionInfo = new RecentBundleMissionInfo();
            recentBundleMission.appId = curRecentData.appId;
            recentBundleMission.appName = curRecentData.appName;
            recentBundleMission.bundleName = curRecentData.bundleName;
            recentBundleMission.abilityName = curRecentData.abilityName;
            recentBundleMission.moduleName = curRecentData.moduleName;
            recentBundleMission.keyName = curRecentData.keyName;
            recentBundleMission.appIconId = curRecentData.appIconId;
            recentBundleMission.appLabelId = curRecentData.appLabelId;
            recentBundleMission.installTime = curRecentData.installTime;
            recentBundleMission.isSystemApp = curRecentData.isSystemApp;
            recentBundleMission.isUninstallAble = curRecentData.isUninstallAble;
            recentBundleMission.badgeNumber = badgeInfo.badgeNumber;
            recentBundleMission.appIndex = badgeInfo.appIndex;
            recentBundleMission.appInstanceKey = curRecentData?.appInstanceKey;
            this.mRecentDataList[i] = recentBundleMission;
            log.showDebug(`updateBadgeNum dockItemInfo is ${JSON.stringify(recentBundleMission)}`);
            AppStorage.setOrCreate('recentList', this.mRecentDataList);
          }
        }
      }
    }
  }

  private dealDockItemWithNewBadge(itemInfo: DockItemInfo, badgeNumber: number): void {
    log.showInfo(`bundleName: ${itemInfo.bundleName}, update badgeNumber: ${badgeNumber}`);
    itemInfo.typeId = CommonConstants.TYPE_APP;
    itemInfo.badgeNumber = badgeNumber;
  }

  private async getImageInfo(path: image.PixelMap): Promise<image.Size | undefined> {
    let imageSize: image.Size | undefined;
    if (path) {
      await path.getImageInfo().then((rst) => {
        if (rst) {
          imageSize = rst.size;
        }
      }).catch((err: Error) => {
        log.showError('getImageInfo :%{public}s', err.message);
      });
    }
    log.error('getImageInfo null');
    return imageSize;
  }

  private cleanContinueInfo(deleteDockItem: DockItemInfo): void {
    if (ObjUtil.isInvalid(deleteDockItem)) {
      return;
    }
    let deviceInfo = AppStorage.get<DockContinuableInfo>('continueDeviceInfo');
    if (deviceInfo && deleteDockItem.appIndex === 0 &&
      deleteDockItem.typeId === CommonConstants.TYPE_APP && deviceInfo.bundleName === deleteDockItem.bundleName) {
      AppStorage.setAndRef('continueDeviceInfo', new DockContinuableInfo()).set(new DockContinuableInfo());
    }
  }

  private deleteResistDockItem(deleteDockItem: DeleteDockItem): boolean {
    let res = false;
    let mResidentList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
    let paramBefore = DockUtils.getPrintParam(mResidentList);
    log.showInfo(`deleteResistDockItem mResidentList before: ${paramBefore}`);
    if (!CheckEmptyUtils.isEmptyArr(mResidentList)) {
      let index = this.getDeleteIndex(mResidentList, deleteDockItem);
      log.showInfo(`deleteResistDockItem index:${index}`);
      while (index > -1) {
        if (AppStorage.get('device') === CommonConstants.DEFAULT_DEVICE_TYPE) {
          if (AppStorage.get('addDockAppFromDialog')) {
            this.deleteAppByIndex(mResidentList, index);
            AppStorage.setOrCreate('addDockAppFromDialog', false);
          } else {
            if (AppStorage.get('pagedesktopDelDockAppInfo') !== deleteDockItem.bundleName) {
              this.deleteAppByIndex(mResidentList, index);
              res = true;
            }
          }
        } else {
          this.deleteAppByIndex(mResidentList, index);
        }
        res = true;
        index = this.getDeleteIndex(mResidentList, deleteDockItem);
      }
      let needUpdate: boolean = true;
      for (let residentIndex = mResidentList.length - 1; residentIndex >= 0; residentIndex--) {
        let dockItem = mResidentList[residentIndex];
        if (dockItem?.itemType === CommonConstants.TYPE_FOLDER) {
          needUpdate = this.delDockItemInFolder(dockItem, deleteDockItem, residentIndex);
        }
      }
      if (needUpdate) {
        this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_delResis'), mResidentList);
      }
      if (deleteDockItem.shortcutId && deleteDockItem.isDeleteAppToUninstallFolder) {
        // 在dock中删除快捷方式所属的应用或者直接移除快捷方式时才需要删除对应的bms数据
        log.showInfo(`deleteResistDockItem, deleteDockItem bundleName: ${deleteDockItem.bundleName}, ` +
          `shortcutId: ${deleteDockItem.shortcutId}, appIndex: ${deleteDockItem.appIndex}`);
        ShortcutViewModel.getInstance().deleteShortcutFromBMS({ bundleName: deleteDockItem.bundleName,
          appIndex: deleteDockItem.appIndex, id: deleteDockItem.shortcutId });
      }
      return true;
    }
    return res;
  }

  private deleteAppByIndex(mResidentList: DockItemInfo[], index: number, isNeedUpdate: boolean = true): void {
    this.cleanContinueInfo(mResidentList[index]);
    const bundleName: string = mResidentList[index]?.bundleName;
    mResidentList.splice(index, 1);
    log.showInfo(`this.mResidentList length: ${mResidentList.length}`);
    if (isNeedUpdate) {
      this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_updateLayout'), mResidentList);
    }
    if (StatusBarServiceEventMgr.getInstance().isWpsAndRegister(bundleName)) {
      RecentDockModel.getInstance(this.singleContext).addToRecentDockList(bundleName);
    }
  }

  /**
   * 删除自由多窗dock运行区的图标信息
   * @param dockItem
   * @returns
   */
  public deletePcModeRecentDockItem(dockItem: DeleteDockItem): boolean {
    this.mRecentDataList = AppStorage.get('recentList') ?? [];
    const beforeLength: number = this.mRecentDataList.length;
    log.showDebug(`deleteRecentDockItem recent dockItem: ${dockItem?.bundleName}`);
    if (!CheckEmptyUtils.isEmptyArr(this.mRecentDataList)) {
      this.mRecentDataList = this.mRecentDataList.filter(item => {
        if (dockItem.bundleName) {
          return !this.checkSameDockItem(dockItem, item);
        } else if (dockItem.keyName) {
          return dockItem.keyName !== item.keyName;
        }
        return true;
      });
      const afterLength: number = this.mRecentDataList.length;
      if (beforeLength === afterLength) {
        return false;
      }
      AppStorage.setOrCreate('recentList', this.mRecentDataList);
      return true;
    }
    return false;
  }

  private deleteRecentDockItem(dockItem: DeleteDockItem): boolean {
    if (CheckEmptyUtils.isEmpty(dockItem.appIndex)) {
      dockItem.appIndex = 0;
    }
    this.mRecentDockModel.deleteRecentDockItem(dockItem);

    return this.deletePcModeRecentDockItem(dockItem);
  }

  private updateDockAppInfos(items: DockItemInfo[]): void {
    for (let i = 0; i < items.length; i++) {
      let item = items[i];
      log.showInfo('updateOneAppInfo item keyName:' + item.keyName);
      let residentList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
      let isFindInDock: boolean = this.findItemInDock(residentList, item.keyName ? item.keyName : AppItemInfo.getKeyName(item), item);
      if (!isFindInDock && item.oldBundleNames && !CheckEmptyUtils.isEmptyArr(item.oldBundleNames)) {
        isFindInDock = this.findItemInDock(residentList, item.oldBundleNames[0] + item.appIndex, item);
      }
      if (isFindInDock) {
        this.mResidentCacheMgr.updateAllDockItems(TAG.concat('_update'), residentList);
      }
    }
  }

  private findItemInDock(residentList: DockItemInfo[], keyName: string, item: DockItemInfo): boolean {
    let isFindInDock: boolean = false;
    log.showInfo('updateOneAppInfo findItemInDock keyName : %{public}s ', keyName);
    let appInDockIndex: number = residentList.findIndex(dockItem => dockItem.keyName === keyName);
    if (appInDockIndex !== -1) {
      isFindInDock = true;
      let cloneDockItem: DockItemInfo = ObjectCopyUtil.deepClone(residentList[appInDockIndex]);
      this.updateDockItem(item, cloneDockItem);
      residentList[appInDockIndex] = cloneDockItem;
    } else {
      isFindInDock = this.findAppItemInDockFolder(item, keyName, residentList);
    }
    return isFindInDock;
  }

  private findAppItemInDockFolder(item: DockItemInfo, keyName: string, residentList: DockItemInfo[]): boolean {
    let isFindInDock: boolean = false;
    residentList.forEach((dockItem, index) => {
      if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
        let cloneDockItem: DockItemInfo = ObjectCopyUtil.deepClone(dockItem);
        let inFolderIndex: number =
          dockItem.layoutInfo?.flat().findIndex(itemInFolder => itemInFolder.keyName === keyName) ?? -1;
        if (inFolderIndex !== -1) {
          isFindInDock = true;
          //计算在第几页第几个
          let column: number = FolderModel.getInstance().getFolderOpenLayout()?.column;
          let row: number = FolderModel.getInstance().getFolderOpenLayout()?.row;
          let size = column * row ?? CommonConstants.NUM_OPEN_FOLDER_ICON_PRE_PAGE;
          log.showInfo('findAppItemInDockFolder size %{public}d', size);
          const page: number = Math.floor(inFolderIndex / size);
          const appIndex: number = inFolderIndex % size;
          const dockItem: GridLayoutItemInfo | undefined = cloneDockItem.layoutInfo?.[page][appIndex];
          if (!dockItem) {
            return;
          }
          this.updateDockItem(item, dockItem as object as DockItemInfo);
          residentList[index] = cloneDockItem;
          let downloadInfo: DownloadInfoItem = {
            bundleName: item.bundleName,
            appStatus: item.appStatus,
            iconResource: item.iconResource,
            appIndex: item.appIndex
          };
          LauncherLayoutCacheUtil.updateDownloadAppCallBack(downloadInfo);
          FolderManager.getInstance().updateFolderItems('refresh open folder in dock',
            GridLayoutUtil.dockItemToGridLayout(cloneDockItem), [dockItem]);
        }
      }
    });
    return isFindInDock;
  }

  private updateDockItem(item: DockItemInfo, cloneDockItem: DockItemInfo): void {
    if (!item.iconResource) {
      item.iconResource = cloneDockItem.iconResource;
    }
    cloneDockItem.bundleName = item.bundleName ? item.bundleName : cloneDockItem.bundleName;
    cloneDockItem.appName = item.appName ? item.appName : cloneDockItem.appName;
    cloneDockItem.applicationName = item.applicationName ? item.applicationName : cloneDockItem.applicationName;
    cloneDockItem.applicationLabelId = item.applicationLabelId ? item.applicationLabelId : cloneDockItem.applicationLabelId;
    cloneDockItem.appIconId = item.appIconId ? item.appIconId : cloneDockItem.appIconId;
    cloneDockItem.appLabelId = item.appLabelId ? item.appLabelId : cloneDockItem.appLabelId;
    cloneDockItem.isUninstallAble = item.isUninstallAble ? item.isUninstallAble : cloneDockItem.isUninstallAble;
    cloneDockItem.isSystemApp = item.isSystemApp ? item.isSystemApp : cloneDockItem.isSystemApp;
    cloneDockItem.installTime = item.installTime ? item.installTime : cloneDockItem.installTime;
    cloneDockItem.moduleName = item.moduleName ? item.moduleName : cloneDockItem.moduleName;
    cloneDockItem.abilityName = item.abilityName ? item.abilityName : cloneDockItem.abilityName;
    if (!CheckEmptyUtils.isEmpty(item.appIndex)) {
      cloneDockItem.appIndex = item.appIndex;
    }
    if (!CheckEmptyUtils.isEmpty(item.appStatus)) {
      cloneDockItem.appStatus = item.appStatus;
    }
    cloneDockItem.intent = item.intent ? item.intent : cloneDockItem.intent;
    log.showInfo(`updateDockItem: ${JSON.stringify(cloneDockItem)}`);
  }

  public checkAppIsRunning(appInfo: DockItemInfo | AppItemInfo): boolean {
    let result: boolean = false;
    let list = AppStorage.get('missionInfoList') as RecentBundleMissionInfo[];
    if (CheckEmptyUtils.isEmpty(appInfo?.bundleName) || CheckEmptyUtils.isEmptyArr(list)) {
      return result;
    }
    // dock栏小黑点判断要增加分身逻辑
    for (let i = 0; i < list.length; i++) {
      if (this.checkSameDockItem(appInfo, list[i])) {
        result = true;
        return result;
      }
    }
    log.showInfo(`checkAppIsRunning: ${result}`);
    return result;
  }

  public isBundleNameAppExistInRecent(bundleName: string): boolean {
    let recentDockList: RecentBundleMissionInfo[] = AppStorage.get('recentDockList') ?? [];
    if (CheckEmptyUtils.isEmptyArr(recentDockList)) {
      log.showInfo('not find in recent:' + bundleName);
      return false;
    }
    let rst: RecentBundleMissionInfo | undefined = recentDockList.find(item => item?.bundleName === bundleName);
    if (CheckEmptyUtils.isEmpty(rst)) {
      log.showInfo('not find in recent:::' + bundleName);
      return false;
    }
    return true;
  }

  public isDockItemExistInDock(dockItem: AppItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(dockItem) || CheckEmptyUtils.isEmpty(dockItem.bundleName)) {
      log.showInfo('dockItem is empty');
      return false;
    }

    if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
      // 文件夹类型无需拦截，直接放行
      return true;
    }
    return this.isBundleNameAppExistInDock(dockItem.bundleName, dockItem.appIndex);
  }

  public isBundleNameAppExistInDock(bundleName: string, appIndex?: number): boolean {
    const rst: GridLayoutItemInfo | DockItemInfo | undefined =
      SmartDockModel.getInstance(this.singleContext).getDockItemByBundleName(bundleName, appIndex);
    return !CheckEmptyUtils.isEmpty(rst);
  }

  /**
   * 通过bundleName，appIndex，appInstanceKey判断是否同一个应用图标
   *
   * @param fromItem
   * @param toItem
   * @returns bundleName，appIndex，appInstanceKey均相同返回true，否则返回false
   * */
  public checkSameDockItem(fromItem?: DockItemInfo | AppItemInfo | DeleteDockItem | SCBSceneInfo | BadgeItemInfo,
    toItem?: DockItemInfo | AppItemInfo | RecentBundleMissionInfo | BadgeItemInfo): boolean {
    if (!fromItem || !toItem) {
      return false;
    }
    return fromItem.bundleName === toItem.bundleName &&
      fromItem.appIndex === toItem.appIndex &&
      this.checkAppInstanceKey(fromItem.appInstanceKey, toItem.appInstanceKey);
  }

  /**
   * 通过bundleName，appIndex，appInstanceKey,shortcutId,persistentId判断是否同一个应用图标
   *
   * @param fromItem
   * @param toItem
   * @returns bundleName，appIndex，appInstanceKey均相同返回true，否则返回false
   * */
  public isSameDockItem(itemInfo: DockItemInfo | RecentBundleMissionInfo | AppItemInfo | undefined,
    other: DockItemInfo | RecentBundleMissionInfo | AppItemInfo | undefined): boolean {
    if (!itemInfo || !other) {
      return false;
    }
    const itemShortcutId = itemInfo.shortcutId || '';
    const otherShortcutId = other?.shortcutId || '';
    const itemPersistentId = itemInfo.persistentId || '';
    const otherPersistentId = other?.persistentId || '';
    return itemShortcutId === otherShortcutId &&
      itemPersistentId === otherPersistentId &&
      this.checkSameDockItem(itemInfo, other);
  }

  /**
   *
   * @param bundleName 应用包名
   * @param appIndex 分身索引
   * @returns 返回应用是否在dock区被  GridLayoutItemInfo 文件夹中 DockItemInfo在桌面
   */
  protected getDockItemByBundleName(bundleName: string, appIndex: number = 0):
    GridLayoutItemInfo | DockItemInfo | undefined {
    let bottomAppList: DockItemInfo[] = this.mResidentCacheMgr.getAllDockItems();
    if (CheckEmptyUtils.isEmptyArr(bottomAppList)) {
      log.showInfo('isBundleNameAppExistInDock residentList is empty');
      return undefined;
    }
    for (let i = 0; i < bottomAppList.length; i++) {
      if (bottomAppList[i].typeId === CommonConstants.TYPE_FOLDER) {
        let folderAppItem: GridLayoutItemInfo | undefined =
          bottomAppList[i].layoutInfo?.flat().find(appItem => appItem.bundleName === bundleName &&
            appItem.appIndex === appIndex);
        if (folderAppItem !== undefined) {
          log.showInfo('SmartDockViewModel::getDockItemByBundleName: in dock folder');
          return folderAppItem;
        }
      } else if (bottomAppList[i].typeId === CommonConstants.TYPE_APP) {
        if (bottomAppList[i].bundleName === bundleName && bottomAppList[i].appIndex === appIndex) {
          log.showInfo('SmartDockViewModel::getDockItemByBundleName: in dock');
          return bottomAppList[i];
        }
      } else if (bottomAppList[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        log.showInfo(`bottomAppList[i].bundleName = ${bottomAppList[i].bundleName}, bundleName = ${bundleName}, bottomAppList[i].appIndex = ${bottomAppList[i].appIndex}, appIndex = ${appIndex}`);
        if (bottomAppList[i].bundleName === bundleName && bottomAppList[i].appIndex === appIndex) {
          log.showInfo('SmartDockViewModel::getDockItemByBundleName: in dock');
          return bottomAppList[i];
        }
      }
    }
    log.showInfo('SmartDockViewModel::getDockItemByBundleName: not find in dock');
    return undefined;
  }
}