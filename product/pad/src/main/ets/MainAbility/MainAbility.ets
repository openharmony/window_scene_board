/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import Want from '@ohos.application.Want';
import { appManager } from '@kit.AbilityKit';
import {
  AppGalleryDownloadManager,
  AppLockManager,
  CommonConstants,
  desktopFontScaleManager,
  DesktopModeManager,
  EditModeCloneHelper,
  FormConstants,
  FormListInfoCacheManager,
  GrayAppListManager,
  IconChangeSizeManager,
  DesktopManager,
  launcherAbilityManager,
  RdbStoreStarter,
  RecentBundleMissionInfo,
  SceneMsgEnum,
  SearchEvents
} from '@ohos/launchercommon';
import { LogCollectUtil } from '@ohos/basecommon';
import { ScreenLockSetUpService } from '@ohos/screenlockcommon/Index';
import StyleConstants from '@ohos/phonebase/src/main/ets/common/constants/StyleConstants';
import { PageDesktopViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import SessionManagerService from '@ohos.sessionManagerService';
import type rpc from '@ohos.rpc';
import type { IInitialized } from '@ohos/systemuicommon';
import { SystemUIGlobalHelper } from '@ohos/systemuicommon';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
// import backupEventManager from '@ohos/phonebase/src/main/ets/backup/BackupEventManager';
import { ScbServiceRemoteObject } from '@ohos/screenlockcomponent/src/main/ets/common/SCBServiceRemoteObject';
import {
  AnimateToScheduleUtils,
  AppStorageUtil,
  DomainName,
  LogDomain,
  LogHelper,
  // MemoryUtils,
  TraceUtil,
  CheckEmptyUtils,
  FileUtils
} from '@ohos/basicutils';
import {
  CurrentCpuScene,
  CurrentMemScene,
  MemoryManager,
  MemoryMonitor,
  PerformanceReporter
} from '@ohos/frameworkcommon';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBGestureNavSetMgr, SCBVisualEffectMgr } from '@ohos/componenthelper';
import {
  ASCFWindowMgr,
  SCBDeviceScreenConfig,
  scbEventExclusiveManager,
  scbGestureManager,
  SCBRecoverManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  sSCBOobeManager
} from '@ohos/windowscene';
import {
  bundleManagerFwk,
  dbCache,
  DebugCommandManager,
  DeviceHelper,
  GlobalContext,
  HiSysReportEvent,
  IconCacheInterface,
  IconResourceManager,
  localEventManager,
  memoryCache,
  ResourceManager,
  SCBWindowSceneConfig,
  WallpaperColorManager,
  WallpaperManager,
  AccountMgr
} from '@ohos/frameworkwrapper';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import call from '@ohos.telephony.call';
import CommonEventManager from '@ohos.commonEventManager';
import { immersiveKgInit } from '@ohos/immersivekeyguard/src/main/ets/model/service/ImmersiveKgInitializeService';
import { List } from '@kit.ArkTS';
import { WallpaperModel } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/model/WallpaperModel';
import { multiInputManager } from '@ohos/multiinput/src/main/ets/default/common/MultiInputManager';
import { ntfThemeActiveMgr } from '@ohos/notificationcomponent/src/main/ets/common/NotificationThemeActiveManager';
import { RestoreLauncherDataManager } from '@ohos/launchercommon/src/main/ets/manager/RestoreLauncherDataManager';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { AppCategoryInfoManager } from '@ohos/launchercommon/src/main/ets/manager/AppCategoryInfoManager';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import MultiModalInputUtil from '@ohos/multimodalinput/src/main/ets/MultiModalInputUtil';
import { NotificationIpc } from '@ohos/systemuicommon/src/main/ets/remote/Constant';
import { NotificationRemoteObject } from '@ohos/notificationcomponent/src/main/ets/remote/NotificationRemoteObject';
import {
  NaviBarSettingsDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/settings/preference/NaviBarSettingsDataMgr';
import { recentLockModel } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/settings/RecentLockModel';
import sceneSessionManager from '@ohos.sceneSessionManager';
import PhonePageDesktopLayoutConfig from '@ohos/phonebase/src/main/ets/common/PhonePageDesktopLayoutConfig';
import type { Configuration } from '@ohos.app.ability.Configuration';
import lazy MainAbilityProxy from '@ohos/pcbase/src/main/ets/MainAbility/MainAbilityProxy';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { MatchCardDataManager } from '@ohos/launchercommon/src/main/ets/model/MatchCardDataManager';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import osAccount from '@ohos.account.osAccount';
import { overlay } from '@kit.AbilityKit';
import { powerButtonManager } from '@ohos/componenthelper/src/main/ets/manager/PowerButtonManager';
import { TaskPool, BaseTask } from '@ohos/basicutils/src/main/ets/taskpool/TaskPool';
import util from '@ohos.util';
import lazy { NotificationInitiator } from '@ohos/notificationcomponent/src/main/ets/NotificationInitiator';
import { ReportFileSizeTimerUtil } from '@ohos/recents/src/main/ets/default/common/ReportFileSizeTimerUtil';
import fs from '@ohos.file.fs';
import { IconSettingsEvents } from '@ohos/desktopedit';
import { DesktopIconShowNameManager } from '@ohos/launchercommon/Index';
import { PadMemoryManager } from '../common/memory/PadMemoryManager';
import { PadStrategyFactory } from '../common/memory/PadStrategyFactory';
import { ToggleDataBridger } from '../SceneBoard/controlpanel/model/ToggleDataBridger';

const TAG = 'SceneBoardMainAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DATABASE_PATH = '/data/storage/el1/database';
const RDB_PATH = '/rdb/Launcher.db';


/**
 * 特性初始化服务集
 */
const FEATURE_INIT_LIST: IInitialized[] = [
  immersiveKgInit
];
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const OOBE_TIMEOUT = 4 * 60 * 1000;
const INITRDB_TIMEOUT = 3 * 60 * 1000;

/**
 * worker默认路径
 */
const WORK_URL: string = 'pad_sceneboard/ets/workers/PluginWorker.ts';
/**
 * overlay hsp 路径
 */
const OVERLAY_URL: string = '/system/app/SceneBoard/pcresourcesoverlay.hsp';

/**
 * EntryPage 路径
 */
const ENTRY_PAGE_URL: string = 'pages/pc/EntryView';

/**
 * module name pad
 */
const MODULE_NAME_PAD: string = '/pad_sceneboard';

/**
 * module name phone
 */
const MODULE_NAME_PHONE: string = '/phone_sceneboard';

export default class MainAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    log.showInfo('onCreate start');
    systemParameterEnhance.setSync('persist.sceneboard.restart', '0');
    if (ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      GlobalContext.getInstance().setObject('initToggleDataBridger', ToggleDataBridger.getInstance().init);
    }

    this.context.area = 0;

    // Save the context of SceneBoard.
    globalThis.desktopContext = this.context;
    GlobalContext.getInstance().setObject('desktopContext', this.context);
    ControlCenterPluginMgr.isPcMode = false;

    PerformanceReporter.getInstance().reportEnterCpuScene(CurrentCpuScene.START_SCENEBOARD);
    PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.START_SCENEBOARD);
    AnimateToScheduleUtils.raiseBootGCPriority();
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    this.initSceneBoard(want).catch((reason: string) => {
      this.setSystemParameterForInitSceneboardFinish('false');
      log.showError(`initSceneBoard faild. ${reason}`);
    });
  }

  async initSceneBoard(want: Want): Promise<void> {
    log.showWarn('LaunchHomeCold start');
    this.initTaskPool();
    // 视效参数初始化
    SCBVisualEffectMgr.init();
    ASCFWindowMgr.init();

    desktopFontScaleManager.initSetFontScale();
    AppStorage.setOrCreate('launcherTime', Date.now());
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_LAUNCH_HOME_COLD);

    // 特性初始化
    this.startFeatureInitList();

    // Register AppLock listener.
    this.initAppLockManager();

    // activate osAccount
    if (DeviceHelper.is2In1DevicePadType()) {
      this.activateCurUserOsAccount();
    }

    // Init theme service.
    this.initThemeService();

    AppCategoryInfoManager.getInstance().init();

    // Save the context.
    GlobalContext.setContext(this.context);

    // 同步数据库dir
    this.initRdbDir();

    SCBGestureNavSetMgr.init();
    powerButtonManager.init();

    await HiSysReportEvent
      .watchTaskTimeout(() => sSCBOobeManager.init(this.context), OOBE_TIMEOUT, 'SCBOobeManager init timeout');
    SystemUIGlobalHelper.appInit(this.context);

    // Init screen lock common service
    ScreenLockSetUpService.getInstance().init();

    // Init SCBSceneSessionManager, session manager service, Init screen session manager.
    this.initSessionManager();

    // Init icon resource manager
    this.initIconResourceCache();

    // Init notification listener.
    log.showWarn('Init notification');
    NotificationInitiator.get().init();

    // Init global const.
    this.initGlobalConst();

    // Init device type and language
    this.initDeviceTypeAndLanguage();

    // Init rdb.
    log.showWarn('initRdbConfig start');
    await HiSysReportEvent
      .watchTaskTimeout(() => RdbStoreStarter.initRdbConfig(), INITRDB_TIMEOUT, 'RdbStoreManager init timeout');
    await RestoreLauncherDataManager.getInstance().dealCloneIconsCompatibility(this.context);
    await RestoreLauncherDataManager.getInstance().dealUpgradeIconsCompatibility(this.context);

    //随卡预装数据初始化
    log.showWarn('Matchcard Init Start');
    MatchCardDataManager.init();
    log.showWarn('Matchcard Init End');

    // Begin recovering
    this.scbBeginRecovering(want);

    // Init device screen config.
    this.loadDeviceScreenConfig();

    // init font size scale setting
    AppStorageUtil.setOrCreate('fontSizeScale', this.context?.config.fontSizeScale || 1);

    // Init recent list.
    log.showWarn('AppStorage setOrCreate recentList start');
    AppStorage.setOrCreate('recentList', new Array<RecentBundleMissionInfo>());

    log.showWarn('GrayAppListManager init start');
    GrayAppListManager.getInstance().init();

    log.showWarn('IconChangeSizeManager init start');
    IconChangeSizeManager.getInstance().init();

    log.showWarn('DesktopIconShowNameManager init start');
    DesktopIconShowNameManager.getInstance().init();

    // Load ui content of SceneBoard.
    ASCFWindowMgr.initPreference();
    this.loadContentAndInitState();

    // Register wallpaper listener.
    this.initWallpaperManager();

    // set ohos_gesture_bottom_height
    this.initGestureBottomHeight();

    // set lock Preference for recent.
    this.initRecentLockPreference();

    // Init gesture navigation manager.
    log.showWarn('initGestureNavigationManager start');
    scbGestureManager.initGestureNavigationManager();
    scbEventExclusiveManager.initEventExclusiveManager();

    // Init the scene state with render service.
    log.showWarn('initWithRenderServiceAdded start');
    SCBSceneSessionManager.getInstance().initWithRenderServiceAdded();
    log.showWarn('createBackupSubscriber start');
    // backupEventManager.createBackupSubscriber();
    EditModeCloneHelper.getInstance().createBackupSubscriber();
    IconSettingsEvents.getInstance().createSubscriber();

    // Create collect log interval.
    log.showWarn('createCollectLogInterval start');
    LogCollectUtil.getInstance().createCollectLogInterval();

    // Init memory manager
    this.initMemoryManager();

    // Init appgallery download manager
    log.showWarn('AppGalleryDownloadManager start');
    AppGalleryDownloadManager.getInstance().setEnableNextDownload(true);

    PhonePageDesktopLayoutConfig.getInstance().setIsPadProduct(true);
    log.showWarn('DebugCommandManager subscribe start');
    DebugCommandManager.getInstance().subscribe();

    // Send InitS ceneBoard Event
    this.sendInitSceneBoardEvent();

    // Report Exit Scene
    this.reportExitScene();

    // Init DesktopModeManager
    log.showWarn('DesktopModeManager start');
    DesktopModeManager.getInstance();

    // raise multimodalinput thread priority
    this.raiseMultiModalInputPriority();

    // Init FileSize Timer
    this.initFileSizeTimer();

    log.showWarn('initSceneBoard ok');
  }

  /**
   * 初始化导航条默认高度，外settingsData数据同步
   */
  private initGestureBottomHeight(): void {
    NaviBarSettingsDataMgr.getInstance().setGestureBottomHeight();
  }

  /**
   * pad拆分后，OTA升级数据库同步
   */
  private initRdbDir(): void {
    let dbDir = GlobalContext.getContext()?.databaseDir;
    let phoneDir = DATABASE_PATH + "/phone_sceneboard/";
    if (!FileUtils.isExistFs(dbDir + RDB_PATH) && FileUtils.isExistFs(phoneDir)) {
      log.showWarn('rdb Dir rename');
      fs.renameSync(DATABASE_PATH + MODULE_NAME_PAD, DATABASE_PATH + "/pad_sceneboard_rename");
      fs.renameSync(DATABASE_PATH + MODULE_NAME_PHONE, DATABASE_PATH + MODULE_NAME_PAD);
    }
  }

  /**
   * 初始化sceneboard上报文件打点的时钟
   */
  private async initFileSizeTimer(): Promise<void> {
    await ReportFileSizeTimerUtil.setTimer();
  }

  /**
   * 初始化recent中默认加锁且已经解锁过的APP名单
   */
  private initRecentLockPreference(): void {
    recentLockModel.initRecentLockList();
  }

  private startFeatureInitList(): void {
    log.showWarn('startFeatureInitList start');
    // 特性模块中数据解析器、组件节点生成器等初始化
    FEATURE_INIT_LIST.forEach((initialize) => {
      initialize?.init(this.context);
    });
  }

  private async initThemeService(): Promise<void> {
    log.showWarn('initThemeService start');
    let serviceWant: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'ThemeServiceAbility'
    };
    try {
      this.context.startServiceExtensionAbility(serviceWant).then(() => {
      });
      log.showInfo('initThemeService ok');
    } catch (error) {
      log.showError('initThemeService error');
    }
  }
  private initGlobalConst(): void {
    // init create window global function
    log.showWarn('SCBSceneSessionManager start');
    globalThis.createWindowWithName = ((windowName: string, windowRank: number): void => {
      log.showWarn('createWindowWithName begin windowName: ${windowName}');
    });
  }

  private raiseMultiModalInputPriority(): void {
    try {
      const threadName = 'OS_mmi_EventHdr';
      let tid: number | undefined = MultiModalInputUtil.getMultiModalTid(threadName);
      log.showInfo(`raiseMultiModalInputPriority tid ${tid}`);
      if (!tid) {
        return;
      }
      AnimateToScheduleUtils.raiseThreadPriority(Number(tid));
    } catch (err) {
      log.showError(`raiseMultiModalInputPriority fail, ${err.code} - ${err.message}`);
    }
  }

  private sendInitSceneBoardEvent(): void {
    log.showWarn('sendInitSceneBoardEvent start');
    this.setSystemParameterForInitSceneboardFinish('true');
    this.setSystemParameterForPowerOffVerify();

    const options: CommonEventManager.CommonEventPublishData = {
      isSticky: true,
    };
    try {
      CommonEventManager.publish('initSceneBoard_event', options, (err) => {
        if (err) {
          log.showWarn('initSceneBoard_event Publish failed');
        } else {
          log.showWarn('initSceneBoard_event Publish success');
        }
      });
    } catch (error) {
      log.showWarn('initSceneBoard_event Publish failed');
    }
  }

  private setSystemParameterForInitSceneboardFinish(flag: string): void {
    try {
      systemParameterEnhance.set('init.sceneboard.finish', flag);
    } catch (error) {
      log.showError(`init.sceneboard.finish error: ${error}`);
    }
  }

  /**
   * 设置系统参数，给关机查找那边判断是否屏蔽关机验密的开关
   */
  private setSystemParameterForPowerOffVerify(): void {
    try {
      systemParameterEnhance.set('systemui.poweroff.verify', 'true');
    } catch (error) {
      log.error('set systemui.poweroff.verify error', error);
    }
  }

  private loadDeviceScreenConfig(): void {
    log.showWarn('loadDeviceScreenConfig start');
    SCBDeviceScreenConfig.getInstance().loadDeviceScreenConfig();
  }

  onDestroy(): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      MainAbilityProxy.getInstance().onDestroy(this.context);
      return;
    }

    WallpaperModel.getInstance().unRegisterWallpaperChange();
    WallpaperManager.getInstance().unregisterEventChange();
    WallpaperColorManager.getInstance().unregisterWallPaperChange();
    MatchCardDataManager.unRegisterBmsAppListChangeListener();
    SystemUIGlobalHelper.appUnInit(this.context);
    LogCollectUtil.getInstance().clearCollectLogInterval();
    scbGestureManager.destroyGestureNavigationManager();
    if (uiType === SCBConstants.UITYPE_PAD) {
      multiInputManager.unRegisterPadInputEvent();
    }
    AppLockManager.getInstance().unregisterAppLock();
    AppCategoryInfoManager.getInstance().release();
    CardLockManager.getInstance().unregisterAppLock();
    EditModeCloneHelper.getInstance().unSubscribeBackEvent();
    IconSettingsEvents.getInstance().unSubscribeEvent();
    log.showInfo('onDestroy success');

    // Release screen lock common service
    ScreenLockSetUpService.getInstance().release();
    recentLockModel.unregisterLockListener();
    ReportFileSizeTimerUtil.cancelTimer();
  }

  onRequest(want: Want, startId: number): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      MainAbilityProxy.getInstance().onRequest(want, startId);
      return;
    }

    if (want) {
      log.showInfo(`onRequest, want:${want.abilityName} action: ${want.action}`);
      const isDesktopLoadFinished: boolean | undefined = AppStorage.get<boolean>('isDesktopLoadFinished');
      if (isDesktopLoadFinished === undefined || isDesktopLoadFinished === false) {
        log.showInfo('desktop loading is not finished, can not execute request');
        return;
      }
      // if app publish card to launcher
      if (want.action === FormConstants.ACTION_PUBLISH_FORM && want.parameters) {
        PageDesktopViewModel.getInstance().publishCardToDesktop(want.parameters);
      }
    } else {
      log.showWarn('onRequest, want is invalid');
    }
    this.closeFolder();
  }

  private closeFolder(): void {
    AppStorage.setOrCreate('openFolderPageIndex', StyleConstants.DEFAULT_NUMBER_0);
    AppStorage.setOrCreate('openFolderStatus', StyleConstants.DEFAULT_NUMBER_0);
  }

  private initIconResourceCache(): void {
    log.showWarn('initIconResourceCache start');
    let cacheList: List<IconCacheInterface> = new List();
    cacheList.add(memoryCache);
    cacheList.add(dbCache);
    IconResourceManager.getInstance().initCacheList(cacheList, bundleManagerFwk);
  }

  async onConfigurationUpdated(config: Configuration): Promise<void> {
    if (DeviceHelper.is2In1DevicePcType()) {
      MainAbilityProxy.getInstance().onConfigurationUpdated(config, this.context);
      return;
    }

    log.showInfo('onConfigurationUpdated, config.language:%{public}s', config.language);
    //深色模式colorMode：0， 浅色模式colorMode：1
    AppStorage.setOrCreate('currColorMode', config.colorMode);
    // 长辈关怀字体变化
    log.showInfo(`onConfigurationUpdated, config.fontSizeScale: ${config.fontSizeScale}`);
    AppStorageUtil.setOrCreate('fontSizeScale', config.fontSizeScale || 1);
    desktopFontScaleManager.setSysFontScale(config.fontSizeScale || 1);
    const systemLanguage: string | undefined = AppStorage.get('systemLanguage');
    if (systemLanguage !== config.language) {
      PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.ACTION_LANGUAGE_CHANGE);
      this.clearCacheWhenLanguageChange();
      localEventManager.sendLocalEvent(SearchEvents.EVENT_SEARCH_PACKAGE_LANGUAGE_CHANGED);
      PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.ACTION_LANGUAGE_CHANGE);
    }
    AppStorage.setOrCreate('systemLanguage', config.language);
    ntfThemeActiveMgr.onThemeActive();
    DesktopManager.getInstance().saveDesktopParam();
  }

  private clearCacheWhenLanguageChange(): void {
    log.showWarn('clearCacheWhenLanguageChange');
    const isDesktopLoadFinished: boolean | undefined = AppStorage.get<boolean>('isDesktopLoadFinished');
    if (isDesktopLoadFinished === undefined || isDesktopLoadFinished === false) {
      log.showWarn('desktop loading is not finished, do not clear cache');
      return;
    }
    FormListInfoCacheManager.getInstance().clearCache();
    ResourceManager.getInstance().clearAppResourceCache();
    IconResourceManager.getInstance().clearAllAppNameCache();
    launcherAbilityManager.cleanAppMapCache();
    SmartDockModel.getInstance().refreshDockResidentList();
    PageDesktopViewModel.getInstance().updateDesktopInfo(SceneMsgEnum.SCENE_MSG_SYSTEM_LANGUAGE_CHANGE);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    if (DeviceHelper.is2In1DevicePcType()) {
      return MainAbilityProxy.getInstance().onConnect(want);
    }

    if (want) {
      log.showInfo(`onConnect bundleName:${want.bundleName}, onConnect abilityName:${want.abilityName}`);
    } else {
      log.showWarn('onConnect with invalid params: ' + want);
    }
    if (want?.parameters?.[NotificationIpc.KEY] === NotificationIpc.VALUE) {
      return new NotificationRemoteObject();
    }
    return new ScbServiceRemoteObject();
  }

  onDisconnect(want: Want): void | Promise<void> {
    if (DeviceHelper.is2In1DevicePcType()) {
      return MainAbilityProxy.getInstance().onDisconnect(want);
    }

    if (want) {
      log.showInfo(`onDisconnect bundleName:${want.bundleName}, onDisconnect abilityName:${want.abilityName}`);
    } else {
      log.showWarn('onDisconnect with invalid params: ' + want);
    }
  }

  private initSessionManager(): void {
    // Init SCBSceneSessionManager
    log.showWarn('SCBSceneSessionManager init start');
    SCBSceneSessionManager.getInstance().init();
    SCBSceneSessionManager.getInstance().setSupportFunctionType(sceneSessionManager.SupportFunctionType.ALLOW_KEYBOARD_WILL_ANIMATION_NOTIFICATION);

    // Enable sub window to follow the parent window
    SCBSceneSessionManager.getInstance().supportFollowParentWindowLayout();
    SCBSceneSessionManager.getInstance().supportFollowRelativePositionToParent();

    // Enable zlevel
    log.showWarn('phone supportZLevel');
    SCBSceneSessionManager.getInstance().supportZLevel();

    // Enable create float window.
    SCBSceneSessionManager.getInstance().supportCreateFloatWindow();

    // Init session manager service.
    log.showWarn('initSessionManagerService start');
    SessionManagerService.initSessionManagerService();

    // Init screen session manager.
    log.showWarn('SCBScreenSessionManager init start');
    SCBScreenSessionManager.getInstance().init();
  }

  private initDeviceTypeAndLanguage(): void {
    // Init device type
    log.showWarn('AppStorage setOrCreate start');
    AppStorage.setOrCreate('deviceType', CommonConstants.DEFAULT_DEVICE_TYPE);
    AppStorage.setOrCreate('device', CommonConstants.DEFAULT_DEVICE_TYPE);
    AppStorage.setOrCreate('hasVoiceCapability', call.hasVoiceCapability());

    // Init language
    log.showWarn('AppStorage setOrCreate systemLanguage start');
    AppStorage.setOrCreate<string | undefined>('systemLanguage', this.context.config.language);
  }

  private scbBeginRecovering(want: Want): void {
    if (want && want.parameters) {
      log.showWarn(`[WMSRecover] Want recovery parameter = ${want.parameters[FormConstants.RECOVERY_PARAM]}`);
      if (want.parameters[FormConstants.RECOVERY_PARAM]) {
        log.showWarn('SCBRecoverManager beginRecovering start called by RECOVERY_PARAM');
        SCBRecoverManager.getInstance().beginRecovering();
      } else if (want.parameters[FormConstants.LOGOUT_RECOVERY_PARAM]) {
        log.showWarn('SCBRecoverManager beginRecovering start called by LOGOUT_RECOVERY_PARAM');
        SCBRecoverManager.getInstance().beginLogoutRecovering();
      }
    } else {
      log.showWarn('Unknown want recovery parameter');
    }
  }

  private loadContentAndInitState(): void {
    // Load ui content of SceneBoard.
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    SCBSceneSessionManager.getInstance().loadContent('pages/EntryView', this.context);
  }

  private initWallpaperManager(): void {
    // Register wallpaper change event.
    log.showWarn('WallpaperManager registerEventChange start');
    WallpaperManager.getInstance().registerEventChange();
    log.showWarn('WallpaperModel registerWallpaperChange start');
    WallpaperModel.getInstance().registerWallpaperChange();
  }

  private initAppLockManager(): void {
    log.showWarn('AppLockManager cache init');
    AppLockManager.getInstance().init();
    CardLockManager.getInstance().init();
    log.showWarn('AppLockManager registerEventChange start');
    AppLockManager.getInstance().registerAppLock();
    CardLockManager.getInstance().registerAppLock();
  }

  async activateCurUserOsAccount(): Promise<void> {
    try {
      let currentUserId: number = await AccountMgr.getCurrentAccountId();
      osAccount.getAccountManager().activateOsAccount(currentUserId);
    } catch (err) {
      log.showError('getCurrentAccountId catch error');
        // userId查询失败直接返回
      return;
    }
  }

  private initMemoryManager(): void {
    /*if (MemoryUtils.isMemoryManagerEnable()) {
      log.showWarn('initManager start');
      MemoryManager.getInstance().initManager(new PadStrategyFactory());
      log.showWarn('startMonitor start');
      MemoryMonitor.getInstance().startMonitor();
      if (DeviceHelper.is2In1DevicePadType()) {
        // pc/pad 2in1下的pad模式 进行黑屏3min进行gc
        PadMemoryManager.getInstance().init();
      }
    }*/
  }

  private reportExitScene(): void {
    log.showWarn('reportExitCpuScene start');
    PerformanceReporter.getInstance().reportExitCpuScene(CurrentCpuScene.START_SCENEBOARD);
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.START_SCENEBOARD);
  }

  private initTaskPool() {
    log.showWarn('initTaskPool start');
    try {
      this.context.resourceManager.getRawFileContent('basicutils_taskpool.json')
        .then(value => {
          let textDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
          const configFromFile = textDecoder.decodeWithStream(value, { stream: false });
          if (!CheckEmptyUtils.isEmpty(configFromFile)) {
            let cfg: Array<BaseTask> = JSON.parse(configFromFile);
            cfg.forEach((ci: BaseTask) => {
              TaskPool.config.set(ci.taskType, ci);
            });
          } else {
            log.showInfo(`get defaultFile null`);
          }
        })
    } catch (error) {
      log.showError(`promise getRawFileContent failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }
}
