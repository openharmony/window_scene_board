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
import { BaseViewController } from '@ohos/frameworkcommon';
import { WindowConstants } from '@ohos/commonconstants';
import {
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  Observer,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  PluginSlot,
  PluginWindowType,
  RequestWindowEvent,
  ScreenOnOffEvent,
  ViewArea,
  viewMgrPolicy,
  ViewType,
  WindowEvent,
  HiSysEventUtil,
  PluginPosition,
  ViewCallback,
  GlobalContext,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSystemSceneSession,
  SystemSessionInfo,
  windowMgr,
  SCBSessionRect,
  SCBKeyboardSession,
  SCBKeyboardManager,
  SCBScreenSessionManager,
  SCBPropertyChangeReason
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager'
import { NotificationListComponentPc } from './view/NotificationListComponentPc';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { SCBSystemSceneLayout } from '../statusbar/SCBSceneLayout';
import MainPage from '../calendarpanel/pages/MainPage';
import {
  LocalWindowManager,
  MultiKeyCode,
  MultimodalInputManager,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ntfSettingsDC } from '@ohos/notificationcomponent/src/main/ets/controller/NtfSettingsDialogController';
import { pinTopLimitDC } from '@ohos/notificationcomponent/src/main/ets/controller/PinTopLimitDialogController';
import screenLockMediator from '../screenlock/refactor/ScreenLockMediator';
import { ntfListener } from '@ohos/notificationcomponent/src/main/ets/model/NotificationListener';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { LengthMetrics } from '@ohos.arkui.node';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper';
import Constants from '../../common/constants/StatusBarPanelConstants';
import { Constants as StatusbarConstants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';
import { PcSmartDockStyleManager } from '@ohos/pcsmartdock/src/main/ets/default/common/PcSmartDockStyleManager';
import {
  PluginWindowManager
} from '@ohos/statusbarcomponent/src/main/ets/pc/pluginwindow/PluginWindowManager';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';


const TAG = 'SCBAssemblyPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const TOP_WINDOW_SPACE: number = 4;

/**
 * 右键弹框窗口名
 */
const CLICK_MENU_WINDOW_NAME = WindowConstants.WINDOW_NAME_PC_NTY_SETTING;

/**
 * 组合通知窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;

const PANEL_SHADOW_OPTIONS: ShadowOptions = {
  color: '#00000000',
  radius: 0,
  offsetX: 0,
  offsetY: 0,
};

const STATUS_BAR_HEIGHT = 40;

@Component
export struct SCBAssemblyPanel {
  persistentId: number = 0;
  @State isAssemblyPanelShow: boolean = false;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenLockObserver: Observer | null = null;
  private lastShowTime: number = 0;
  private defaultSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: TAG,
    sceneZIndex: 0,
    hitTestMode: HitTestMode.Default,
  };
  private touchOutsideSession: SCBSystemSceneSession =
    SCBSceneSessionManager.getInstance().requestSystemSceneSession(this.defaultSessionInfo);
  @Link screenProp: SCBScreenProperty;
  @State assemblyCtrl: BaseViewController = new BaseViewController(ViewType.NOTIFICATION_CENTER);
  @State notificationMaxHeight: Length = Infinity;
  @Provide isNtfSettingShow: boolean = false;
  @Provide ntfSettingRect: ViewArea = {
    left: 0,
    top: 0,
    width: 0,
    height: 0
  };
  @Provide ntfSettingsDialogClose: boolean = true;
  @Provide closeNtfDialogClose: boolean = true;
  @Provide pinTopLimitDialogClose: boolean = true;
  windowMaxHeight: number = Infinity;
  @Provide menuArea: Area | undefined = undefined;
  mTimeMeterOfAssemblyPanel: number = 0;
  defaultCalendarHeight: number = LocalWindowManager.PC_CALENDAR_PANEL_EXPAND_HEIGHT;
  /**
   * 是否回收资源
   */
  @Provide trimMemory: boolean = false;
  visibleCallback: ViewCallback = {
    onHide: () => {
      this.viewHideCallback();
    },
    onShow: () => {
      this.viewShowCallback();
    }
  };
  @State calendarHeight: number = this.defaultCalendarHeight;
  @State isCollapseCalendarPanel: boolean = false;
  isFocus: boolean = false;
  subWindowVisible: boolean = false;
  subWindowVisibleChange: Function = (viewType?: ViewType | string, visible?: boolean) => {
    if (viewType === undefined || visible === undefined || viewType !== ViewType.NOTIFICATION_CENTER) {
      return;
    }
    log.info(`subWindowVisibleChange, visible:${visible}`);
    this.subWindowVisible = visible;
    if (!this.subWindowVisible) {
      this.checkWindowShow();
    }
  }
  checkWindowShowTimer?: number = undefined;
  private calenderArea?: Area = undefined;
  private notificationArea?: Area = undefined;

  /**
   * 设置窗口可响应区域，防止用来显示阴影的区域阻挡用户操作
   */
  private updateResponseArea(): void {
    if (!this.calenderArea || !this.notificationArea) {
      return;
    }
    let winPos = windowMgr.getWindowPosition(WINDOW_NAME);
    let calenderRegion: Rectangle = {
      x: vp2px(this.calenderArea.globalPosition.x as number) - winPos.left,
      y: vp2px(this.calenderArea.globalPosition.y as number) - winPos.top,
      width: vp2px(this.calenderArea.width as number),
      height: vp2px(this.calenderArea.height as number)
    };
    let notificationRegion: Rectangle = {
      x: vp2px(this.notificationArea.globalPosition.x as number) - winPos.left,
      y: vp2px(this.notificationArea.globalPosition.y as number) - winPos.top,
      width: vp2px(this.notificationArea.width as number),
      height: vp2px(this.notificationArea.height as number)
    };
    this.assemblyCtrl.setResponseRegion([calenderRegion, notificationRegion]);
  }

  viewHideCallback(): void {
    log.showInfo(`viewHideCallback`);
    this.isAssemblyPanelShow = false;
    if (this.mTimeMeterOfAssemblyPanel) {
      clearTimeout(this.mTimeMeterOfAssemblyPanel);
    }
  }

  viewShowCallback(): void {
    log.showInfo(`viewShowCallback`);
    this.isAssemblyPanelShow = true;
    this.mTimeMeterOfAssemblyPanel = setTimeout(() => {
      log.showInfo('onViewShow');
      focusControl.requestFocus(Constants.COMPONENT_ID_NTF_MANAGER);
    }, 20);
    this.updateAssemblyPanelPosition();
  }

  /**
   * 通知中心二级菜单
   * @param persistentId 入参
   */
  @Builder
  notificationPanelBuilder(persistentId: number) {
    if (this.notificationPanelBuilderLog()) {
    }
    Column() {
      SCBSystemSceneLayout({
        persistentId: persistentId,
        panelShadowOptions: PANEL_SHADOW_OPTIONS,
        needShadow: true
      }) {
        NotificationListComponentPc({
          notificationType: NotificationType.TYPE_PC,
          viewOpacity: 1,
          ntfComponentWidth: this.getNtfWidth(),
          ntfComponentHeight: this.getNtfHeight(),
          windowMaxHeight: this.notificationMaxHeight,
          isAssemblyPanelShow: this.isAssemblyPanelShow,
          updateHeight: (height: number): void => {
            this.updateAssemblyPanelPosition();
          },
        })
      }
    }
    .id(`${TAG}_Column_NotificationPanel`)
    .margin({ top: 0 })
    .width('100%')
    .height(this.getNtfHeight())
    .onAreaChange((_oldArea, newArea) => {
      this.notificationArea = newArea;
      this.updateResponseArea();
    })
  }

  /**
   * 日历二级菜单
   * @param persistentId 入参
   */
  @Builder
  calenderPanelBuilder(persistentId: number) {
    if (this.calenderPanelBuilderLog()) {
    }
    Column() {
      SCBSystemSceneLayout({
        persistentId: persistentId,
        panelShadowOptions: PANEL_SHADOW_OPTIONS,
        needShadow: true
      }) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          MainPage({
            isAssemblyPanelShow: this.isAssemblyPanelShow,
            isCollapse: this.isCollapseCalendarPanel,
            updateHeight: (): void => {
              this.updateCalendarHeight();
            }
          }
          )
        }
        .width('100%')
        .height(this.calendarHeight)
        .clip(true)
        .borderRadius($r('sys.float.corner_radius_level6'))
      }
    }
    .id(`${TAG}_Column_CalenderPanel`)
    .width('100%')
    .height(this.calendarHeight)
    .onAreaChange((_oldArea, newArea) => {
      this.calenderArea = newArea;
      this.updateResponseArea();
    })
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear, start');
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipSelfWhenShowOnVirtualScreen(true);
    }
    viewMgrPolicy.registerViewController(ViewType.NOTIFICATION_CENTER, this.assemblyCtrl);
    viewMgrPolicy.registerViewCallback(ViewType.NOTIFICATION_CENTER, this.visibleCallback);
    this.assemblyCtrl.updateId(this.persistentId);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack,
      this.screenProp?.screenId);
    this.onPanelPositionFlush();
    this.initWindowPolicy();
    // 窗口动画绑定onFrame
    windowMgr.startBindWinAnimOnFrame(WINDOW_NAME);

    // 锁屏监听
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo('onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);

    if (CommonUtils.isInvalid(this.touchOutsideSession)) {
      this.touchOutsideSession =
        SCBSceneSessionManager.getInstance().requestSystemSceneSession(this.defaultSessionInfo);
    }
    this.touchOutsideSession?.registerTouchOutsideCallback(this.onTouchOutside);
    GlobalContext.getContext().eventHub.on('SubWindowVisible', this.subWindowVisibleChange);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    if (this.screenLockObserver !== null) {
      screenLockMediator.deleteObserver(this.screenLockObserver);
    }
    if (!CommonUtils.isInvalid(this.touchOutsideSession)) {
      SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.touchOutsideSession);
    }
    GlobalContext.getContext().eventHub.off('SubWindowVisible', this.subWindowVisibleChange);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack,
      this.screenProp?.screenId);
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipSelfWhenShowOnVirtualScreen(false);
    }
  }

  checkWindowShow() {
    clearTimeout(this.checkWindowShowTimer);
    this.checkWindowShowTimer = setTimeout(() => {
      log.info(`checkWindowShowImmediately isFocus:${this.isFocus} subWindowVisible:${this.subWindowVisible}`);
      if (this.subWindowVisible || this.isFocus) {
        log.info('no need to hide window');
        return;
      }
      windowMgr.hideWindowWithAnimByPersistentId(this.persistentId);
      this.checkWindowShowTimer = undefined;
    }, 250);
  }

  /**
   * 融合模式和分离模式热切
   */
  onStatusBarChange() {
    log.showInfo(`onStatusBarChange start`);
    this.onPanelPositionFlush();
  }

  screenPropertyChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screenPropertyChangeCallBack reason: ${reason}`);
    if (reason && (reason === SCBPropertyChangeReason.CHANGE_MODE ||
      reason === SCBPropertyChangeReason.SCREEN_CONNECT)) {
      this.onScreenPropertyChange();
    }
  }

  async onScreenPropertyChange(): Promise<void> {
    this.onPanelPositionFlush();
    if (windowMgr.isShowing(WINDOW_NAME)) {
      this.updateAssemblyPanelPosition();
    }
  }

  onPanelPositionFlush() {
    log.showInfo(`onPanelPositionFlush start`);
    this.windowMaxHeight = this.getMaxWindowHeight();
    windowMgr.updateWindowPosition(WINDOW_NAME, {
      left: 0,
      top: 0,
      width: PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE),
      height: vp2px(this.windowMaxHeight)
    });
  }

  updateAssemblyPanelPosition(): void {
    this.notificationMaxHeight = this.windowMaxHeight - StatusbarConstants.NTF_PANEL_SPACE - this.calendarHeight;
    log.showInfo(`updateNotificationHeight,calendarHeight: ${this.calendarHeight} notificationMaxHeight:${this.notificationMaxHeight}`);
    let position = windowMgr.getWindowPosition(WINDOW_NAME);
    EvtBus.post(WindowPositionChangeEvent,
      {
        windowName: PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
        position: PluginPosition.POSITION_RIGHT,
        area: position
      });
  }

  getNtfWidth(): number {
    return PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE);
  }

  getNtfHeight(): number {
    return this.assemblyCtrl.getArea().height - this.calendarHeight - StatusbarConstants.NTF_PANEL_SPACE -
      StatusbarConstants.NTF_SHADOW_MARGIN * 2;
  }

  updateCalendarHeight() {
    log.showInfo(`updateCalendarHeight, ${this.isCollapseCalendarPanel},calendarHeight: ${this.calendarHeight}`);
    this.calendarHeight = this.isCollapseCalendarPanel ? LocalWindowManager.PC_CALENDAR_PANEL_COLLAPSE_HEIGHT :
    this.defaultCalendarHeight;
    this.updateAssemblyPanelPosition();
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  hideNtfDialog() {
    ntfSettingsDC.hideDialog(NotificationType.TYPE_PC);
    pinTopLimitDC.hideDialog(NotificationType.TYPE_PC);
  }

  getMaxWindowHeight(): number {
    if (!this.screenProp?.height) {
      log.showError(`screenProp height error`);
      return 0;
    }
    let maxHeight: number = 0;
    const dockHeight = PcSmartDockStyleManager.getStyle(this.screenProp).mDockHeight;
    maxHeight = px2vp(this.screenProp?.height) - dockHeight - StatusbarConstants.DEFAULT_DOCK_GAP * 2;
    log.showInfo(`screenPropHeight: ${this.screenProp?.height}, maxHeight: ${maxHeight}, dockHeight: ${dockHeight}`);
    return maxHeight;
  }

  /**
   * 组合隐藏通知面板窗口
   */
  private async hideWindow(): Promise<void> {
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      log.showInfo('hideWindow skiped, window not showing');
      return;
    }
    // 当前如果menu弹框存在，则不隐藏
    if (windowMgr.isShowing(CLICK_MENU_WINDOW_NAME)) {
      log.showInfo('hideWindow skiped, menu window showing');
      return;
    }
    // 当前如果弹框，则不隐藏
    this.hideNtfDialog();
    log.showDebug('hide anim start');
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
  }

  /**
   * 请求窗口show/hide事件
   *
   * @param event 事件
   */
  private onRequestWindowEvent(event: RequestWindowEvent): void {
    // 处理窗口hide事件
    if (event.windowName == WINDOW_NAME && event.isRequestHide()) {
      this.hideWindow();
    }
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      this.hideNtfDialog();
      windowMgr.hideWindowImmediately(WINDOW_NAME);
    }
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    log.showInfo('WINDOW_SHOW_HIDE_EVENT windowName: ' + event.windowName + ', isShow: ' + event.isWindowShow());
    // 其他窗口显示，则隐藏当前窗口
    if (event.isWindowStartShow() && !event.isMatchName(WINDOW_NAME) && !event.isMatchName(CLICK_MENU_WINDOW_NAME)) {
      this.hideWindow();
    }
    if (event.isWindowStartHide() || event.isWindowStartShow() && event.isMatchName(WINDOW_NAME)) {
      ntfSettingsDC.hideDialog(NotificationType.TYPE_PC);
    }
    if (!event.isMatchName(WINDOW_NAME)) {
      return;
    }
    if (event.isWindowStartShow()) {
      TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_SHOW);
      HiSysEventUtil.reportNotificationPanelShow({
        POINTX: 0,
        POINTY: 0,
        RESOLUTION: `${DropDownPanelManager.getScreenInfo().width}x${DropDownPanelManager.getScreenInfo().height}`,
        TIMESTAMP: `${this.updateLastShowTime()}`,
        ORIENTATION: 0,
        NUM: ntfListener.getCurrentUserNtfCount(),
        IMPORTANTNUM: 0,
        MORENUM: 0
      }, SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
      log.showInfo('IntoNC start');
    } else if (event.isWindowEndShow()) {
      log.showInfo('IntoNC end');
      TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_SHOW);
    } else if (event.isWindowStartHide()) {
      log.showInfo('ExitNC start');
      TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_HIDE);
      HiSysEventUtil.reportNotificationPanelHide({
        TIMESTAMP: `${this.lastShowTime}`,
        ORIENTATION: 0,
        DURATION: `${new Date().getTime() - this.lastShowTime}`
      }, SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
    } else if (event.isWindowEndHide()) {
      log.showInfo('ExitNC/ClearNtAni end');
      TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_HIDE);
      TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_DELETE_NOTIFICATION);
    }
  }

  private updateLastShowTime(): number {
    this.lastShowTime = new Date().getTime();
    return this.lastShowTime;
  }

  /**
   * 初始化
   */
  private initWindowPolicy(): void {
    log.showDebug('init notification panel window Policy');
    // 窗口show/hide事件监听
    // win键统一到feature\multiinput\src\main\ets\default\common\viewmodel\MultiInputViewModel.ts中处理
    // win + n键移至feature\multiinput\src\main\ets\default\common\viewmodel\MultiInputViewModel.ts中处理
    this.eventMgr.on(WindowEvent, (event: WindowEvent): void => {
      this.onWindowEvent(event)
    })// 请求窗口show/hide事件
      .on(RequestWindowEvent, (event: RequestWindowEvent): void => {
        this.onRequestWindowEvent(event)
      })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
        this.onScreenOnOffEvent(event)
      })
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.showInfo('on CombinationKeyEvent: data: ' + JSON.stringify(data));
        this.hideWindow();
      }));
  }

  private isClickNtfSettingArea(screenX: number, screenY: number): boolean {
    if (!this.isNtfSettingShow) {
      return false;
    }
    return (screenX >= this.ntfSettingRect.left &&
      screenX <= this.ntfSettingRect.left + this.ntfSettingRect.width &&
      screenY >= this.ntfSettingRect.top &&
      screenY <= this.ntfSettingRect.top + this.ntfSettingRect.height);
  }

  private onTouchOutside = (x: number, y: number): void => {
    let rect = this.assemblyCtrl.getArea();
    if (x >= vp2px(rect.left) && x <= (vp2px(rect.left + rect.width)) &&
      y >= vp2px(rect.top) && y <= vp2px(rect.top + rect.height)) {
      return;
    }

    if (this.isInArea(x, y, windowMgr.getAllStatusIconCaches()?.get(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL))) {
      return;
    }
    if (this.isInArea(x, y, this.menuArea)) {
      return;
    }
    if (!this.assemblyCtrl.isShowing()) {
      return;
    }
    if (this.isClickOnSoftInput(x, y) || this.isClickOnKeyBoardPanel(x, y)) {
      log.showInfo(`onTouchOutside click on softInput or click on keyboard panel`);
      return;
    }
    if (this.isInArea(x, y, windowMgr.getAllStatusIconCaches()?.get(PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT))) {
      setTimeout(() => {
        ContextMenu.close();
        windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
      }, 150);
      return;
    }
    ContextMenu.close();
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
    setTimeout(() => {
      if (!statusbarPlCtrl.isStatusBarPanelShowing()) {
        statusbarPlCtrl.changeStatusBarOrDockVisibilityInImmersive(false);
      }
    }, 150)
  };

  private isClickOnSoftInput(x: number, y: number): boolean {
    const inputRect: SCBSessionRect = windowMgr.getActiveInputMethodRect();
    return inputRect && inputRect.contains(x, y);
  }

  private isClickOnKeyBoardPanel(x: number, y: number): boolean {
    if (!SCBKeyboardManager.getInstance().getKeyboardSession()?.isKeyboardShowing()) {
      return false;
    }
    let rect = (SCBKeyboardManager.getInstance().getKeyboardSession() as SCBKeyboardSession).currRect;
    return rect && rect.contains(x, y);
  }

  private isInArea(x: number, y: number, targetArea: Area | undefined): boolean {
    if (targetArea === undefined || targetArea === null) {
      return false;
    }
    let tmp = targetArea?.globalPosition;
    if (x >= vp2px(tmp?.x as number) && x <= vp2px((tmp?.x as number +
      (targetArea?.width as number))) && y >= vp2px(tmp?.y as number) &&
      y <= vp2px((tmp?.y as number + (targetArea?.height as number)))) {
      log.showInfo('touch on area:' + JSON.stringify(targetArea));
      return true;
    }
    return false;
  }

  calenderPanelBuilderLog(): Boolean {
    log.showInfo(`isWindowStyle true, calenderPanelBuilderLog`);
    return true;
  }

  notificationPanelBuilderLog(): Boolean {
    log.showInfo(`isWindowStyle true, notificationPanelBuilderLog`);
    return true;
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      space: { main: LengthMetrics.vp(StatusbarConstants.NTF_PANEL_SPACE) },
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Start
    }) {
      this.notificationPanelBuilder(this.persistentId)
      this.calenderPanelBuilder(this.persistentId)
    }
    .id(`${TAG}_Flex`)
    .height(this.assemblyCtrl.getArea().height)
    .width(this.assemblyCtrl.getArea().width)
    .defaultFocus(true)
    .onKeyEvent((keyEvent: KeyEvent) => {
      if ((keyEvent.keyCode === MultiKeyCode.ESC || keyEvent.keyCode === MultiKeyCode.BACK) &&
        keyEvent.type === KeyType.Up) {
        this.hideWindow();
      }
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down &&
        !this.isClickNtfSettingArea(event.touches[0].screenX, event.touches[0].screenY)) {
        this.isNtfSettingShow = false;
      }
    })
    .onFocus(() => {
      log.info('onFocus');
      this.isFocus = true;
    })
    .onBlur(() => {
      log.info('onBlur');
      this.isFocus = false;
      this.checkWindowShow();
    })
    .padding(StatusbarConstants.NTF_SHADOW_MARGIN)
  }
}