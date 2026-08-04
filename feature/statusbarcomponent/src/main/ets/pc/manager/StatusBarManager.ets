/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 *
 * 图标接入流程：
 * 1、图标接入：遵循 ConfigAccess（配置文件接入） 或 MessageAccess （一步直达接入） 的接入规范
 * 2、图标显隐：基于当前图标显隐控制方式 PluginVisibleControlManager#getPluginType 放到对应 control 对象中控制显隐
 * 3、图标分组：若需要显示在指定分组，需要在 PluginGroupCalculateBase 的 mac 与 win 风格子类中 slotInWhereMap 进行配置
 * 4、图标排序：分离模式下，需要在 PluginSlot.STATUS_BAR_PC 中配置图标显示顺序
 * 5、图标不支持拖拽：需要在 DISABLE_DRAG_PLUGIN 中配置
 */
import { appMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PcStatusBarIconManager } from './PcStatusBarIconManager';
import { StyleManager } from '../style/PluginStyleManager';
import { StateManager } from './StateManager';
import { AnimManager } from './AnimManager';
import { StatusBarPluginAccessManager } from '../pluginaccess/StatusBarPluginAccessManager';
import { PluginVisibleControlManager } from '../pluginvisible/PluginVisibleControlManager';
import { PluginGroupingManager } from '../plugingroup/PluginGroupingManager';
import { StyleSwitchManager } from '../pluginstyleswitch/StyleSwitchManager';
import { PluginEventManager } from '../pluginevent/PluginEventManager';
import { PluginWindowManager } from '../pluginwindow/PluginWindowManager';
import { HiSysUtil } from '../utils/HiSysUtil';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AbsResourceManager as ResourceManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SCBSceneSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { PcStatusBarDragMgr } from './PcStatusBarDragMgr';

const TAG = 'StatusBarManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export default class StatusBarManager {
  private static mInstance: StatusBarManager;
  /**
   * 本地图标资源管理
   */
  private resourceManager: ResourceManager | null = null;
  /**
   * 是否已经初始化
   */
  private isStart: boolean = false;
  /**
   * 获取系统接入图标的资源文件
   */
  public getRemotePluginIconCallback?: Function;
  /**
   * 获取ActiveWifiIcon图片
   * @returns
   */
  public getActiveWifiIcon: Function = () => {
  };

  public static getInstance(): StatusBarManager {
    if (!StatusBarManager.mInstance) {
      StatusBarManager.mInstance = new StatusBarManager();
    }
    return StatusBarManager.mInstance;
  }

  /**
   * 初始化
   */
  public init(resourceManager: ResourceManager): void {
    if (this.isStart) {
      log.showError('status bar manager already init');
      return;
    }
    this.isStart = true;
    log.showInfo('init start status bar manager');
    PcStatusBarDragMgr.getInstance().init();
    StyleSwitchManager.getInstance().init();
    StatusBarPluginAccessManager.getInstance().init();
    PluginVisibleControlManager.getInstance().init();
    PluginGroupingManager.getInstance().init();
    PluginEventManager.getInstance().init();
    PluginWindowManager.getInstance().init();
    StyleManager.getInstance().init();
    appMgr.init();
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    HiSysUtil.getInstance().init();

    this.resourceManager = resourceManager;
  }

  /**
   * 销毁
   */
  public onDestroy(): void {
    log.showDebug('onDestroy destroy StatusBarGroupManager');
    PcStatusBarIconManager.getInstance().unregisterGetContainerSessionListCallback();
    StateManager.getInstance().clear();
    AnimManager.getInstance().clear();
    StyleManager.getInstance().clear();

    PcStatusBarDragMgr.getInstance().deInit();
    StyleSwitchManager.getInstance().deInit();
    StatusBarPluginAccessManager.getInstance().deInit();
    PluginVisibleControlManager.getInstance().deInit();
    PluginGroupingManager.getInstance().deInit();
    PluginEventManager.getInstance().deInit();
    PluginWindowManager.getInstance().deInit();
    StyleManager.getInstance().deInit();
    this.isStart = false;
  }

  /**
   * 获取静态图标资源管理
   */
  public getResourceManager(): ResourceManager | null {
    return this.resourceManager;
  }

  public registerGetRemotePluginIconCallback(callback: Function): void {
    log.showDebug('registerGetRemotePluginIconCallback.');
    this.getRemotePluginIconCallback = callback;
  }

  public unregisterGetRemotePluginIconCallback(): void {
    log.showDebug('unregisterGetRemotePluginIconCallback.');
    this.getRemotePluginIconCallback = undefined;
  }

  public registerGetActiveWifiIconCallbackCallback(callback: Function): void {
    log.showDebug('registerGetActiveWifiIconCallbackCallback.');
    this.getActiveWifiIcon = callback;
  }

  public unregisterGetActiveWifiIconCallbackCallback(): void {
    log.showDebug('unregisterGetActiveWifiIconCallbackCallback.');
    this.getActiveWifiIcon = ()=>{};
  }
}