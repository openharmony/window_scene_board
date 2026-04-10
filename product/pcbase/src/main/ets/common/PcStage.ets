/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { BaseStage, DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { LauncherLayoutCacheConfig, layoutConfigManager } from '@ohos/launchercommon';
import { formPreLoader } from '@ohos/form';
import { appCenterPreLoader } from '@ohos/appcenter';
import { pageDesktopPreLoader } from '@ohos/pagedesktop';
import { smartDockPreLoader } from '@ohos/smartdock';
import { NumBadgeManager } from '@ohos/numbadge';
import { LauncherLayoutPreLoader } from './LauncherLayoutPreLoader';
import PcSmartDockLayoutConfig from './PcSmartDockLayoutConfig';
import PcFolderLayoutConfig from './PcFolderLayoutConfig';
import PcFormLayoutConfig from './PcFormLayoutConfig';
import PcPageDesktopGridStyleConfig from './PcPageDesktopGridStyleConfig';
import PcSmartDockSuggestAppConfig from './PcSmartDockSuggestAppConfig';
import PcPageDesktopLayoutConfig from './PcPageDesktopLayoutConfig';
import { fileFolderManagerFactory } from '@ohos/desktopfilefolder';
import PcFileFolderManager from './controller/PcFileFolderManager';
import { LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { ntfListener } from '@ohos/notificationcomponent/src/main/ets/model/NotificationListener';
import PcFileAccess from './controller/PcFileAccess';
import context from '@ohos.app.ability.common';
import { PcResourceManager } from './manager/ResourceManager';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SettingsUtil } from '@ohos/frameworkwrapper';
import { SCBSessionListManager } from '@ohos/pcmode';
import StatusBarResUtils from './utils/StatusBarResourceUtils';
import { PcStatusBarIconManager } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/PcStatusBarIconManager';
import lazy StatusBarManager from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StatusBarManager';
import { ControlCenterPcModePluginPanelMgr } from '../SceneBoard/controlpanel/pcMode/ControlCenterPcModePluginPanelMgr';
import { PcLayoutCacheManager } from '../desktop/cache/PcLayoutCacheManager';

const TAG = 'PcStage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SETTINGS_KEY = 'settings_in_status_bar_type';
/**
 * Pc product stage
 */
export default class PcStage extends BaseStage {

  public static singleName: string = 'PcStage';

  public pcSmartDockLayoutConfig: PcSmartDockLayoutConfig;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.pcSmartDockLayoutConfig = singleManager.get<PcSmartDockLayoutConfig>(PcSmartDockLayoutConfig, this.singleContext);
  }

  /**
   * Stage onCreate callback
   */
  onCreate(): void {
    log.showInfo('onCreate');
    super.onCreate();
    this.setStatusBarType();
    this.initPcConfig();
    singleManager.get<LauncherLayoutPreLoader>(LauncherLayoutPreLoader, this.singleContext).load();
    smartDockPreLoader.load();
    pageDesktopPreLoader.load();
    layoutConfigManager.addConfigToManager(PcPageDesktopGridStyleConfig.getInstance());
    appCenterPreLoader.load();
    formPreLoader.load();
    PcFileAccess.setContext(GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext);
    fileFolderManagerFactory.setFileFolderManager(PcFileFolderManager.getInstance(this.singleContext));
    NumBadgeManager.getInstance().registerNumBadge();
    ntfListener.registerNotification();
    ControlCenterPcModePluginPanelMgr.getInstance().init();
    StatusBarManager.getInstance().init(new PcResourceManager());
    StatusBarManager.getInstance().registerGetRemotePluginIconCallback(() => {
      return StatusBarResUtils.getIcon;
    })
    StatusBarManager.getInstance().registerGetActiveWifiIconCallbackCallback(() => {
      return StatusBarResUtils.getActiveWifiIcon;
    })

    PcStatusBarIconManager.getInstance().registerGetContainerSessionListCallback(() => {
      return SCBSessionListManager.allContainerSessionList;
    });

  }

  /**
   * Stage onDestroy callback
   */
  onDestroy(): void {
    super.onDestroy();
    smartDockPreLoader.releaseConfigAndData();
    appCenterPreLoader.releaseConfigAndData();
    pageDesktopPreLoader.releaseConfigAndData();
    formPreLoader.releaseConfigAndData();
    singleManager.get<LauncherLayoutPreLoader>(LauncherLayoutPreLoader, this.singleContext).releaseConfigAndData();
    NumBadgeManager.getInstance().unRegisterNumBadge();
    ntfListener.unRegisterNotification();
    PcStatusBarIconManager.getInstance().unregisterGetContainerSessionListCallback();
    StatusBarManager.getInstance().onDestroy();
    StatusBarManager.getInstance().unregisterGetRemotePluginIconCallback();
    StatusBarManager.getInstance().unregisterGetActiveWifiIconCallbackCallback();
  }

  /**
   * 设置settings里的状态栏类型信息
   *
   * @returns 状态栏类型
   */
  private setStatusBarType(): void {
    let statusBarTypeStr = SettingsUtil.getSecureValue(SETTINGS_KEY);
    let statusBarType = Number(statusBarTypeStr);
    // 默认融合风格
    if (!this.isValidStatusBar(statusBarType)) {
      statusBarType = StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR;
      SettingsUtil.setSecureValue(SETTINGS_KEY, String(statusBarType));
      // 这里不能随便改，告知xts状态栏是否存在, 融合模式为0
      SettingsUtil.setSystemValue('isStatusBarExist', '0');
    }
    AppStorage.setOrCreate('statusBarType', statusBarType);
  }

  /**
   * 是否是合法状态栏类型
   *
   * @param statusBarType 状态栏类型
   * @returns 是否合法
   */
  private isValidStatusBar(statusBarType: number): boolean {
    return StatusBarType.isMacStyle(statusBarType) || StatusBarType.isWindowStyle(statusBarType);
  }

  /**
   * init Pc layout config
   */
  private initPcConfig(): void {
    layoutConfigManager.addConfigToManager(this.pcSmartDockLayoutConfig);
    layoutConfigManager.addConfigToManager(PcFolderLayoutConfig.getInstance());
    layoutConfigManager.addConfigToManager(PcFormLayoutConfig.getInstance());
    layoutConfigManager.addConfigToManager(PcSmartDockSuggestAppConfig.getInstance());
    layoutConfigManager.addConfigToManager(PcPageDesktopLayoutConfig.getInstance());
    LauncherLayoutCacheConfig.getInstance().addLayoutCacheManager(PcLayoutCacheManager.getInstance());
  }
}
