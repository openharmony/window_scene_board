/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import {
  GlobalContext,
  HiSysEventUtil,
  WallpaperManager,
  ResourceManager,
  viewMgrPolicy,
  ViewType,
  DebugCommandManager,
  reportIntervalMgr,
  IconCacheInterface,
  memoryCache,
  dbCache,
  IconResourceManager,
  WallpaperType,
  bundleManagerFwk,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import {
  SCBRecoverManager,
  sSCBOobeManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import {
  FormConstants,
  FormListInfoCacheManager,
  RdbStoreStarter,
  launcherAbilityManager,
  GrayAppListManager,
  AppLockManager
} from '@ohos/launchercommon';
import { CommonConstants, AppGalleryDownloadManager } from '@ohos/launchercommon';
import StyleConstants from '../common/constants/StyleConstants';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
import { AppCenterModel } from '@ohos/launchercommon';
import SessionManagerService from '@ohos.sessionManagerService';
import { SystemUIGlobalHelper } from '@ohos/systemuicommon';
import { PluginParseMgr } from '@ohos/systemuicommon';
import { ntfListener } from '@ohos/notificationcomponent/src/main/ets/model/NotificationListener';
import { AppGridPresenter } from '@ohos/appcenter';
import { ScbServiceRemoteObject } from '@ohos/screenlockcomponent';
import rpc from '@ohos.rpc';
import { BusinessError } from '@ohos.base';
import type { Configuration } from '@ohos.app.ability.Configuration';
import { multiInputManager } from '@ohos/multiinput';
import CommonEventManager from '@ohos.commonEventManager';
import { List } from '@kit.ArkTS';
import { WallpaperModel } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/model/WallpaperModel';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
// import backupEventManager from '../backup/BackupEventManager';
import { PcStrategyFactory } from '../common/memory/PcStrategyFactory';
import { PcMemoryManager } from '../common/memory/PcMemoryManager';
import { MemoryManager, MemoryMonitor } from '@ohos/frameworkcommon/src/main/ets/TsIndex';
import MultiModalInputUtil from '@ohos/multimodalinput/src/main/ets/MultiModalInputUtil';
import { pinTopDialogConfigManager } from '@ohos/systemuicommon/src/main/ets/notification/vm/PinTopDialogConfigManager';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { NtfPinTopLimitDialogConfigPc } from '@ohos/systemuicommon/src/main/ets/notification/vm/NtfPinTopLimitDialogConfigPc';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { common } from '@kit.AbilityKit';
import { ReportFileSizeTimerUtil } from '@ohos/recents/src/main/ets/default/common/ReportFileSizeTimerUtil';
import lazy { ScreenLockSetUpService } from '@ohos/screenlockcommon/Index';
import screenSessionManager from '@ohos.screenSessionManager';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import call from '@ohos.telephony.call';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';

const TAG = 'SceneBoardMainAbilityProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export default class MainAbilityProxy {
  private static mInstance: MainAbilityProxy;
  private is2In1Device: boolean = ModeChangeUtils.isSupportWindowPcModeSwitch();

  public static getInstance(): MainAbilityProxy {
    if (!MainAbilityProxy.mInstance) {
      MainAbilityProxy.mInstance = new MainAbilityProxy();
    }
    return MainAbilityProxy.mInstance;
  }

  private storage?: LocalStorage;

  public onCreate(want: Want, pageName: string, workUrl: string, context: common.ServiceExtensionContext): void {
    log.showInfo('onCreate start');
    pinTopDialogConfigManager.setConfig(new NtfPinTopLimitDialogConfigPc());
    try {
      context.area = 0;
      this.storage = new LocalStorage();
      this.initSceneBoard(want, pageName, workUrl, context).catch((reason: BusinessError) => {
        log.showError(`initSceneBoard faild. ${reason}`);
      });
      if (this.is2In1Device) {
        ControlCenterPluginMgr.isPcMode = true;
      }
      this.initAppLockManager();
      HiSysEventUtil.hiSysReadStorage();
    } catch (err) {
      log.error('registerInputEvent faild, error -> ', err);
    }
  }

  async initSceneBoard(want: Want, pageName: string, workUrl: string,
    context: common.ServiceExtensionContext): Promise<void> {
    // Save the context.
    log.showWarn('setContext start');
    GlobalContext.setContext(context);
    log.showWarn('sSCBOobeManager init context start');
    AppStorage.setOrCreate('currColorMode', GlobalContext.getContext().config.colorMode);
    await sSCBOobeManager.init(context);
    log.showWarn('SystemUIGlobalHelper appInit context start');
    SystemUIGlobalHelper.appInit(context);

    if (DeviceHelper.is2In1DevicePcType()) {
      // Init screen lock common service & init Numpad
      AppStorage.setOrCreate('hasVoiceCapability', call.hasVoiceCapability());
      ScreenLockSetUpService.getInstance().init();
    }

    // Init theme service.
    this.initThemeService(context);

    // Init SCBSceneSessionManager, session manager service, Init screen session manager.
    this.initSessionManager();

    // Init icon resource manager
    this.initIconResourceCache();

    // Init notification listener.
    log.showWarn('ntfListener init start');
    ntfListener.init(want);

    // init param service listener
    log.showWarn('register ParamService');

    // Init plugin manager.
    log.showWarn('PluginParseMgr initWorker start');
    PluginParseMgr.initWorker(workUrl);

    // Save the context of SceneBoard and Init global const.
    this.initGlobalContext(context);

    // Init device type and language
    this.initDeviceTypeAndLanguage(context);

    // Init rdb.
    log.showWarn('RdbStoreStarter initRdbConfig start');
    await RdbStoreStarter.initRdbConfig();

    // Begin recovering
    this.scbBeginRecovering(want);

    // Load ui content of SceneBoard.
    log.showWarn('SCBSceneSessionManager loadContent start');
    SCBSceneSessionManager.getInstance().loadContent(pageName, context, this.storage);

    log.showWarn('GrayAppListManager init start');
    GrayAppListManager.getInstance().init();

    // Register wallpaper listener.
    this.initWallpaperManager();

    // Create report interval.
    log.showWarn('createReportInterval start');
    reportIntervalMgr.createReportInterval();

    // Init the scene state with render service.
    log.showWarn('initWithRenderServiceAdded start');
    SCBSceneSessionManager.getInstance().initWithRenderServiceAdded();

    // Init memory manager
    this.initMemoryManager();

    // Init appgallery download manager
    log.showWarn('AppGalleryDownloadManager start');
    AppGalleryDownloadManager.getInstance().init();

    // Init Common EventManager
    this.initCommonEventManager();

    log.showWarn('DebugCommandManager subscribe start');
    DebugCommandManager.getInstance().subscribe();

    log.showInfo('createBackupSubscriber start');
    // backupEventManager.createBackupSubscriber();

    // raise multimodalinput thread priority
    this.raiseMultiModalInputPriority();

    // Init FileSize Timer
    this.initFileSizeTimer();

    log.showWarn('initSceneBoard ok');
  }

  onDestroy(context: common.ServiceExtensionContext): void {
    try {
      multiInputManager.unRegisterInputEvent();
      SystemUIGlobalHelper.appUnInit(context);
      WallpaperModel.getInstance().unRegisterWallpaperChange();
      WallpaperManager.getInstance().unregisterEventChange();
      reportIntervalMgr.clearReportInterval();
      // backupEventManager.destroyBackupSubscriber();
      ReportFileSizeTimerUtil.cancelTimer();
      if (DeviceHelper.is2In1DevicePcType()) {
        ScreenLockSetUpService.getInstance().release();
      }
      AppLockManager.getInstance().unregisterAppLock();
      CardLockManager.getInstance().unregisterAppLock();
      log.showInfo('onDestroy success');
    } catch (err) {
      log.error('onDestroy failed, error -> ', err);
    }
  }

  onRequest(want: Want, startId: number): void {
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

  async onConfigurationUpdated(config: Configuration, context: common.ServiceExtensionContext) {
    log.showInfo('onConfigurationUpdated, config?.language:%{public}s:', config?.language);
    //深色模式colorMode：0， 浅色模式colorMode：1
    AppStorage.setOrCreate('currColorMode', config.colorMode);
    const systemLanguage: string = AppStorage.get('systemLanguage') as string ?? context.config.language;
    if (systemLanguage !== config.language) {
      this.clearCacheWhenLanguageChange();
    }
    AppStorage.setOrCreate<string | undefined>('systemLanguage', config.language);
    log.showInfo(`onConfigurationUpdated, config.fontSizeScale: ${config?.fontSizeScale}`);
    AppStorage.setOrCreate('fontSizeScale', config?.fontSizeScale || 1);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.showInfo(`onConnect bundleName:${want.bundleName}, onConnect abilityName:${want.abilityName}`);
    return new ScbServiceRemoteObject();
  }

  onDisconnect(want: Want): void | Promise<void> {
    log.showInfo(`onConnect bundleName:${want.bundleName}, onConnect abilityName:${want.abilityName}`);
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

  private async initThemeService(context: common.ServiceExtensionContext): Promise<void> {
    log.showWarn('initThemeService start');
    let serviceWant: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'ThemeServiceAbility'
    };
    try {
      context.startServiceExtensionAbility(serviceWant).then(() => {
        log.showInfo('startServiceExtensionAbility success');
      }).catch((error: BusinessError) => {
        log.showInfo('startServiceExtensionAbility failed: ' + error);
      });
    } catch (error) {
      log.showError('initThemeService error: ' + error);
    }
  }

  private initGlobalConst(): void {
    // init create window global function
    let createWindowWithName = ((windowName: string, windowRank: number): void => {
      log.showWarn(`createWindowWithName begin windowName: ${windowName}`);
    });
    GlobalContext.getInstance().setObject('createWindowWithName', createWindowWithName);

    let hideAppCenterWithAnimation: () => void = ((): void => {
      viewMgrPolicy.hideView(ViewType.APP_CENTER);
    });
    GlobalContext.getInstance().setObject('hideAppCenterWithAnimation', hideAppCenterWithAnimation);
    AppCenterModel.getInstance().setHideAppCenterFunc(hideAppCenterWithAnimation);

    let hideDockViewWithAnimation = ((): void => {
      viewMgrPolicy.hideView(ViewType.SMART_DOCK);
    });
    GlobalContext.getInstance().setObject('hideDockViewWithAnimation', hideDockViewWithAnimation);
  }

  private closeFolder(): void {
    AppStorage.setOrCreate('openFolderPageIndex', StyleConstants.DEFAULT_NUMBER_0);
    AppStorage.setOrCreate('openFolderStatus', StyleConstants.DEFAULT_NUMBER_0);
  }

  /**
   * 初始化sceneboard上报文件打点的时钟
   */
  private async initFileSizeTimer(): Promise<void> {
    await ReportFileSizeTimerUtil.setTimer();
  }

  private clearCacheWhenLanguageChange() {
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
    PageDesktopViewModel.getInstance().updateDesktopInfo().then(() => {
      AppGridPresenter.getInstance().loadAppCenterData();
    });
  }

  private initIconResourceCache(): void {
    let cacheList: List<IconCacheInterface> = new List();
    cacheList.add(memoryCache);
    cacheList.add(dbCache);
    IconResourceManager.getInstance().initCacheList(cacheList, bundleManagerFwk);
  }

  private initGlobalContext(context: common.ServiceExtensionContext): void {
    // Save the context of SceneBoard.
    log.showWarn('GlobalContext setObject start');
    GlobalContext.getInstance().setObject('desktopContext', context);

    // Init global const.
    log.showWarn('initGlobalConst start');
    this.initGlobalConst();
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

  private initWallpaperManager(): void {
    // Register wallpaper listener.
    log.showWarn('WallpaperManager registerEventChange start');
    WallpaperManager.getInstance().registerEventChange();

    log.showWarn('registerWallpaperChange start');
    WallpaperModel.getInstance().registerWallpaperChange();
    log.showWarn('setWallpaper SCEENLOCK start');
    WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
    log.showWarn('setWallpaper DESKTOP start');
    WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
  }

  private initCommonEventManager(): void {
    const options: CommonEventManager.CommonEventPublishData = {
      isSticky: true
    };
    log.showWarn('CommonEventManager publish start');
    try {
      CommonEventManager.publish('initSceneBoard_event', options, (err) => {
        if (err) {
          log.showWarn('initSceneBoard_event Publish failed');
        } else {
          log.showWarn('initSceneBoard_event Publish success');
        }
      });
    } catch (error) {
      log.showWarn('initSceneBoard_event publish failed');
    }
  }

  private initDeviceTypeAndLanguage(context: common.ServiceExtensionContext): void {
    // Init device type
    log.showWarn('AppStorage setOrCreate start');
    AppStorage.setOrCreate('deviceType', CommonConstants.PAD_DEVICE_TYPE);
    AppStorage.setOrCreate('device', CommonConstants.PAD_DEVICE_TYPE);

    //Init language
    log.showWarn('AppStorage setOrCreate systemLanguage start');
    AppStorage.setOrCreate<string | undefined>('systemLanguage', context.config.language);
  }

  private initSessionManager(): void {
    // Init SCBSceneSessionManager
    log.showWarn('SCBSceneSessionManager init start');
    SCBSceneSessionManager.getInstance().init();
    SCBSceneSessionManager.getInstance().setSupportFunctionType(
      sceneSessionManager.SupportFunctionType.ALLOW_KEYBOARD_WILL_ANIMATION_NOTIFICATION);
    // Enable sub window to follow the parent window
    SCBSceneSessionManager.getInstance().supportFollowParentWindowLayout();
    SCBSceneSessionManager.getInstance().supportFollowRelativePositionToParent();

    // Enable zlevel
    log.showWarn('pc supportZLevel');
    SCBSceneSessionManager.getInstance().supportZLevel();

    // Init session manager service.
    log.showWarn('initSessionManagerService start');
    SessionManagerService.initSessionManagerService();

    // Init screen session manager.
    log.showWarn('SCBScreenSessionManager init start');
    SCBScreenSessionManager.getInstance().init();
  }

  private initMemoryManager(): void {
    /*if (MemoryUtils.isMemoryManagerEnable()) {
      log.showWarn('initManager start');
      MemoryManager.getInstance().initManager(new PcStrategyFactory());
      log.showWarn('startMonitor start');
      MemoryMonitor.getInstance().startMonitor();
      PcMemoryManager.getInstance().init();
    }*/
  }

  private initAppLockManager(): void {
    AppLockManager.getInstance().init();
    CardLockManager.getInstance().init();
    AppLockManager.getInstance().registerAppLock();
    CardLockManager.getInstance().registerAppLock();
  }
}