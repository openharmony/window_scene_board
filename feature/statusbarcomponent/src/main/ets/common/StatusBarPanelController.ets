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
import { CommonUtils, Log, SingletonHelper, LogHelper, LogDomain, } from '@ohos/basicutils';
import {
  EvtBus,
  EventManager,
  PluginSlot,
  WindowEvent,
  GlobalContext,
  viewMgrPolicy,
  ViewType,
  localEventManager,
  DeviceHelper,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import { SCBSceneContainerSessionArray, SCBSceneSessionManager, SCBSceneMode, windowMgr,
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSpecificSession} from '@ohos/windowscene';
import EventConstants from '@ohos/launchercommon/src/main/ets/constants/EventConstants';
import MultimodalInputManager from '@ohos/systemuicommon/src/main/ets/manager/MultimodalInputManager';
import display from '@ohos.display';
import { BusinessError } from '@ohos.base';
import lazy { PluginStyleUtil } from '../pc/common/PluginStyleUtil';

const TAG = 'StatusBarPanelController';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class StatusBarPanelController {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private statusBarPanelMap: Map<string, Boolean> = new Map([
    [PluginSlot.SLOT_STATUS_INPUT_PANEL, false],
    [PluginSlot.SLOT_STATUS_INPUT_METHOD, false],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, false],
    [PluginSlot.SLOT_STATUS_PERSONAL, false],
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, false],
    [PluginSlot.SLOT_STATUS_CLOCK_PANEL, false],
    [PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, false],
    [PluginSlot.SLOT_STATUS_CONTROL_CENTER, false],
    [PluginSlot.SLOT_STATUS_MICROPHONE_PANEL, false],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE, false],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT, false],
    [PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE, false],
    [PluginSlot.SLOT_STATUS_TRAY_PANEL, false],
    [PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE, false],
    [PluginSlot.SLOT_STATUS_USB, false],
    [PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL, false]
  ]);
  private statusBarIconPopUpIdMap: Map<string, number> = new Map();
  private curWindow: string = '';

  init() {
    log.showInfo('init StatusBarPanelController');
    this.eventMgr
      .on(WindowEvent, this.handleWindowEvent)
    MultimodalInputManager.initCombinationKey(this.eventMgr, () => this.hideWindow());
  }

  public getCurWindow(): string {
    return this.curWindow;
  }

  /**
   * 关闭弹窗
   */
  private hideWindow(): void {
    if (!windowMgr.isShowing(this.curWindow)) {
      return;
    }
    log.showInfo(`hide curWindow: ${this.curWindow}`);
    windowMgr.hideWindowWithAnim(this.curWindow);
  }

  registerPanelName(pluginSlot: string): void {
    log.showInfo(`register statusbarPanel ${pluginSlot}`);
    this.statusBarPanelMap.set(pluginSlot, false);
  }

  /**
   * 处理窗口显示/隐藏事件
   *
   * @param event 窗口事件
   */
  private handleWindowEvent = (event: WindowEvent): void => {
    if (CommonUtils.isInvalid(event)) {
      return;
    }
    if (!this.statusBarPanelMap.has(event.windowName)) {
      return;
    }
    // 窗口隐藏时，取消选中状态
    if (event.eventType == WindowEvent.EVENT_TYPE_HIDE &&
      event.eventState == WindowEvent.EVENT_STATE_END) {
      log.showInfo(`handleWindowEvent hide window: ${event.windowName}`);
      this.statusBarPanelMap.set(event.windowName, false);
      this.changeStatusBarOrDockVisibilityInImmersive(false);
      return;
    }
    if (event.eventType == WindowEvent.EVENT_TYPE_SHOW &&
      event.eventState == WindowEvent.EVENT_STATE_START) {
      this.curWindow = event.windowName;
      log.showInfo(`handleWindowEvent show window: ${event.windowName}`);
      this.statusBarPanelMap.set(event.windowName, true);
      this.changeStatusBarOrDockVisibilityInImmersive(true);
      return;
    }
  }
  /*
  是否有窗口打开
   */
  public isStatusBarPanelShowing = (): boolean => {
    for (let item of this.statusBarPanelMap.entries()) {
      if (item[1] === true) {
        log.showDebug(`register statusbarPanel ${item[0]} is showing`);
        return true;
      }
    }
    return false;
  }

  /**
   * 判断是否为沉浸式模式
   * 1、存在沉浸式窗口
   * 2、窗口最大化隐藏状态栏开关打开时的分屏场景
   * 3、窗口最大化隐藏状态栏开关打开时的窗口最大化场景
   */
  public isImmersiveModeEnabled(screenId: number): boolean | undefined {
    let topActiveContainerSession: SCBSceneContainerSession | null = null;
    let subSession: SCBSpecificSession | null = null;
    let sceneSessionMgr = SCBSceneSessionManager.getInstance();
    // 获取顶层沉浸式窗口或者最大化窗口容器（包含主窗和子窗）
    topActiveContainerSession = SCBSceneSessionManager.getInstance().getTopContainerSession(screenId);
    // 判断是否存在全屏的子窗（沉浸式或者最大化窗口），不会获取自由窗
    subSession = sceneSessionMgr.getTopFullScreenSubSession(screenId, topActiveContainerSession);
    // 如果子窗存在，只需要根据子窗的状态判断是否是沉浸式场景，子窗没有分屏场景
    if (subSession) {
      const isSubSessionFullScreen: boolean = subSession?.windowMode === SCBSceneMode.FULLSCREEN;
      const isSubSessionLayoutFullScreen: boolean | undefined = subSession?.layoutFullScreen;
      const isSubSessionImmersiveMode: boolean | undefined = (isSubSessionFullScreen && isSubSessionLayoutFullScreen);
      log.showInfo(`subSession, isImmersiveMode: ${isSubSessionImmersiveMode}, isFullScreen: ${isSubSessionFullScreen},
      isLayoutFullScreen: ${isSubSessionLayoutFullScreen}`);
      return isSubSessionImmersiveMode;
    }
    const session = topActiveContainerSession?.primarySession;
    const isFullScreen: boolean = session?.sceneInfo?.windowMode === SCBSceneMode.FULLSCREEN;
    const isLayoutFullScreen: boolean | undefined = session?.layoutFullScreen;
    // 窗口最大化隐藏状态栏开关是否打开
    const isDockAutoHide: boolean = AppStorage.get<boolean>('isDockAutoHide') ?? false;
    const isSplitView: boolean | undefined = topActiveContainerSession?.isSplitView();
    const isImmersiveMode: boolean | undefined = (isFullScreen && isLayoutFullScreen) ||
      (isSplitView && isDockAutoHide);
    log.showInfo(`isImmersiveMode: ${isImmersiveMode}, isFullScreen: ${isFullScreen},
      isLayoutFullScreen: ${isLayoutFullScreen}, isSplitView: ${isSplitView}`);
    return isImmersiveMode;
  }

  public changeStatusBarOrDockVisibilityInImmersive(show: boolean) {
    log.info(`changeStatusBarOrDockVisibilty ${show}`);
    const screenId = SCBSceneSessionManager.getInstance().mainScreenId;
    if (PluginStyleUtil.isWindowStyle()) {
      // 融合状态栏，控制dock栏显隐
      if (show) {
        if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
          let showDockViewWithAnimation = (GlobalContext.getInstance()
            .getObject('showDockViewWithAnimation')) as Function;
          showDockViewWithAnimation();
        } else {
          viewMgrPolicy.showView(ViewType.SMART_DOCK);
        }
      } else {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE,
          { 'isVisible': false, 'screenId': screenId });
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE, {
          'isVisible': false,
          'screenId': screenId
        });
      }
    }
  }

  /**
   * 判断前台窗口是否为最大化窗口
   */
  public isFullScreenWindowForeground(): boolean {
    let result = SCBSceneSessionManager.getInstance().getContainerSessionList()
      .getTopActiveSession()?.getContainerWindowMode() === SCBSceneMode.FULLSCREEN;
    log.showInfo('now the foreground windows is in maxsize mode :$' + result);
    return result;
  }

  canShowOrHideStatusBar(show: boolean): boolean {
    if (show) {
      return true;
    }
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (CommonUtils.isInvalid(sessionList)) {
      log.error('Failed to get containerSessionList');
      return false;
    }
    for (let i = sessionList.length - 1; i >= 0; i--) {
      let item = sessionList[i];
      let isHavePrimarySeeion = item !== null && item.isActive && item.primarySession !== null;
      let isFullScreen = item.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN;
      let isLayoutFullScreen = item.primarySession?.layoutFullScreen ?? false;
      if (isHavePrimarySeeion && !item.primarySession?.isMinimizing && isFullScreen) {
        return isLayoutFullScreen;
      }
    }
    return false;
  }

  getStatusBarPanelMap(): Map<string, Boolean> {
    return this.statusBarPanelMap;
  }

  /**
   * store the persistentId of a session with the key of sessionName without number
   * eg:sessionName like status_bar_quick_note3 => status_bar_quick_note
   * @param sessionName eg:status_bar_quick_note3
   * @param id: persistentId of a session
   */
  public setIdToStatusBarIconPopUpIdMap(sessionName: string, id: number): void {
    const key = sessionName.replace(/\d+$/, '');
    this.statusBarIconPopUpIdMap.set(key, id);
  }

  public getIdFromStatusBarIconPopUpIdMap(name: string): number | undefined {
    return this.statusBarIconPopUpIdMap.get(name);
  }

  public closeAllStatusBarPanel(): void {
    this.statusBarPanelMap.forEach((isOpen, viewType) => {
      if (isOpen) {
        log.showInfo(`hide window name :${viewType}`);
        windowMgr.hideWindowWithAnim(viewType);
      }
    });
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
  }
}

export const statusbarPlCtrl = SingletonHelper.getInstance(StatusBarPanelController, TAG);