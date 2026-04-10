/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
  LogHelper,
  LogDomain,
  TraceUtil,
  DomainName,
  SingleContext,
} from '@ohos/basicutils';
import {
  GlobalContext,
  localEventManager,
  HiSysEventUtil,
  viewMgrPolicy,
  ViewType,
  ViewArea,
  ViewCallback,
  SettingsUtil,
  DeviceHelper,
  HiDfxEventUtil,
  EventManager,
  EvtBus,
  OobeActivatedEvent
} from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason,
  SCBScreenProperty,
  sSCBOobeManager,
  SCBEventId,
  SCBSceneContainerSession,
  SCBScreenSessionManager,
  SCBSceneSessionManager,
  SCBKeyboardManager,
  INVALID_SCREEN_ID,
  SCBRotateChangeReason,
  SCBSceneInfo,
  EventType,
  scbEventExclusiveManager
} from '@ohos/windowscene';
import { PowerStatus, RotationConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { DockBackgroundView, FixedSmartDock, DockBackgroundMgr } from '@ohos/pcsmartdock';
import PowerStatusChangeAnimationController from '../scenemanager/PowerStatusChangeAnimationController';
import { ReceiveEventInfo, LayoutViewModel, FormCenterViewManager } from '@ohos/launchercommon';
import LockScreenAnimationController from '../screenlock/common/LockScreenAnimationController';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import EventConstants from '@ohos/multiinput/src/main/ets/default/common/constants/EventConstants';
import { PCUtils } from '../../common/utils/PCUtils';
import ScreenLockService from '../screenlock/refactor/ScreenLockService';
import HashMap from '@ohos.util.HashMap';
import { AnimationConstants } from '@ohos/commonconstants/Index';
import { curves } from '@kit.ArkUI';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { PcSmartDockModel } from '@ohos/pcsmartdock/src/main/ets/default/model/PcSmartDockModel';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { SCBFoldStatePropertyChangeEvent } from '@ohos/windowscene/src/main/ets/events/SCBFoldStatePropertyChangeEvent';
import { FoldSceneKeyboardStateChangeMgr } from '../../common/manager/FoldSceneKeyboardStateChangeMgr';
import { FoldKeyboardConstant } from '../../common/constants/FoldKeyboardConstant';
import { PCDockDragMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PCDockDragMgr';
import { PcDockPopupMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockPopupMgr';
import { VisibleInfo } from './SCBSmartDockMask';
import { SCBInputMethod } from '../scenemanager/SCBInputMethod';
import { PcDockAnimationMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockAnimationMgr';
import { PcStatusBarDragMgr } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/PcStatusBarDragMgr';
import { NavbarPanGesture, SCBGestureNavBarViewModel } from '../gesturenavigation/viewmodel/SCBGestureNavBarViewModel';
import {
  PcDockStyleConfig,
  PcSmartDockStyleManager } from '@ohos/pcsmartdock/src/main/ets/default/common/PcSmartDockStyleManager';
import { DesktopSwitchController, VmStateCallBack } from '../virtualmachine/DesktopSwitchController';

let delayHideDock: number | null = null;
let delayHideLight: number | null = null;
const TAG = 'SCBSmartDock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DOCK_LIGHT_EFFECT_UPDATE_INTERVAL = 5;
const DOCK_DELAY_TO_HIDE = 100;
const LIGHT_DELAY_TO_HIDE = 3000;

enum SCBSmartDockViewState {
  VIEW_INITIAL = 0,
  VIEW_SHOWING = 1,
  VIEW_HIDING = 2,
}

/**
 * hopper dock 位置变化动效时序控制枚举类
 */
enum DockPosition {
  NONE,
  CENTRAL,
  CENTRAL_ANIMATING,
  BOTTOM,
  BOTTOM_ANIMATING
}

@Component
export struct SCBSmartDock {
  private persistentId: number = 0;
  private finalState: number = SCBSmartDockViewState.VIEW_INITIAL;
  private lightAnimationDuration: number = 300;
  private innerLightIntensity: number = 0.15;
  private innerLightHeight: number = 100;
  private dockHoverConfig: HashMap<string, Object> = new HashMap();
  private onMouseTimes: number = 0;
  @Link screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  @State smartDockController: BaseViewController =
    new BaseViewController(ViewType.SMART_DOCK, this.screenProp.screenId);
  @State scaleRatio: number = 1;
  private dockOpacity: number = 1;
  private translateY: number = 0;
  @State blurRadius: number = 0;
  @State needHideDockAfterPopupExit: boolean = false;
  @State lightPositionX: number = 0;
  @State lightPositionY: number = 0;
  @State lightPositionZ: number = 150;
  @State intensityValue: number = 0;
  @State isMouseInDock: boolean = false;
  // 控制dock背板变换
  @StorageLink('dockColorMode') currColorMode: number = 0;
  // 控制图标以及状态栏变换
  @StorageLink('itemColorMode') itemColorMode: number = 0;
  // 状态变量
  @State isFullScreenLayout: boolean = false;
  @State dockHeight: number = 0;
  @StorageLink('powerStatus') @Watch('onPowerStatusChange') powerStatus: PowerStatus = PowerStatus.RUNNING;
  @StorageLink('clearDelayHideDock') @Watch('onClearDelayHideDock') clearDelayHideDock: VisibleInfo = new VisibleInfo();
  @StorageLink('isAppCenterShow') @Watch('onAppCenterViewChange') isAppCenterShow: boolean = false;
  @StorageLink('showRecent') @Watch('onRecentCenterViewChange') isRecentCenterShow: boolean = false;
  @StorageLink('currColorMode') @Watch('onSystemColorModeChange') systemColorMode: number = 0;
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  @Provide isDesktopEnabled: boolean = true;
  private dockAnimate: ICurve = curves.interpolatingSpring(0, 1, 300, 33)
  private positionState: DockPosition = DockPosition.NONE; // hopper dock 位置变化动效时序控制参数
  private isRotating: boolean = false;
  private dockVisibleState: boolean = true;

  private viewCallback: ViewCallback = {
    onShow: (): void => this.onViewShow(),
    onHide: (): void => this.onViewHide()
  }
  private isDockHover: boolean = false;

  @StorageLink('isInNavBarGesture') isInNavBarGesture: boolean = false;
  private readonly navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private navbarPanGesture: NavbarPanGesture = new NavbarPanGesture(this.navBarViewModel);
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State isGestureEnabled: boolean = false;

  private dockVisibleCallback = (visible: boolean) => {
    log.showInfo(`dockVisibleCallback: ${visible}`);
    this.dockVisibleState = visible;
    let isRecentPanel: boolean = AppStorage.get<boolean>('showRecent') as boolean;
    if (visible || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || isRecentPanel) {
      // 任务中心或者应用中心界面不隐藏
      if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
        let showDockViewWithAnimation = (GlobalContext.getInstance()
          .getObject('showDockViewWithAnimation')) as Function;
        showDockViewWithAnimation();
      } else {
        this.setOpacity(1);
        this.setTranslateY(0);
        viewMgrPolicy.showView(ViewType.SMART_DOCK);
        if (this.isSupportNavGesture()) {
          localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_VISABLE_CHANGE, true);
        }
      }
    } else {
      if (GlobalContext.getInstance().hasObject('hideDockViewWithAnimation')) {
        let hideDockViewWithAnimation = (GlobalContext.getInstance()
          .getObject('hideDockViewWithAnimation')) as Function;
        hideDockViewWithAnimation();
      } else {
        viewMgrPolicy.hideView(ViewType.SMART_DOCK);
        if (this.isSupportNavGesture()) {
          localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_VISABLE_CHANGE, false);
        }
      }
    }
  };

  onClearDelayHideDock(): void {
    log.showInfo(`onClearDelayHideDock ${this.clearDelayHideDock.isHover}, ${this.clearDelayHideDock.screenId}`);
    if (this.clearDelayHideDock.screenId === this.screenProp.screenId) {
      if (this.clearDelayHideDock.isHover) {
        this.clearTimer();
      } else {
        this.delayHideDock();
      }
    }
  }

  onPowerStatusChange(): void {
    if (this.powerStatus === PowerStatus.RUNNING) {
      this.setOpacity(PowerStatusChangeAnimationController.DEFAULT_OPACITY_RATIO);
      this.setTranslateY(0, 'onPowerStatusChange');
      return;
    }
    PowerStatusChangeAnimationController.closeSmartDock(() => {
      this.closeSmartDockCallback();
    });
  }

  private onLock(): void {
    log.showInfo(`onLock:${this.isLock} isOobe:${sSCBOobeManager.isOobeActivated()}`);
    // Do not handle when oobe is enabled
    if (sSCBOobeManager.isOobeActivated()) {
      return;
    }

    if (this.isLock) {
      this.lockSmartDockCallback();
    } else {
      if (this.isSupportNavGesture()) {
        log.showInfo('onLock isGestureEnabled true');
        this.isGestureEnabled = true;
      }
      if (this.isDockHover) {
        log.showInfo('onLock needHideDockAfterPopupExit false');
        this.needHideDockAfterPopupExit = false;
      }
    }
  }

  private registerLockScreenAnimation(): void {
    LockScreenAnimationController.getInstance().registerCallback(LockScreenAnimationController.DOCK_CALLBACK,
      () => {
        if (this.finalState === SCBSmartDockViewState.VIEW_SHOWING) {
          this.setOpacity(1);
          this.setTranslateY(0, 'unlock screen animation');
        }
        log.showInfo('unlock showing dock opacity: %{public}d', this.dockOpacity);
      }, () => {
        if (this.dockOpacity !== 1) {
          log.showInfo(`unlock show dock opacity: ${this.dockOpacity}`);
          animateTo({ duration: 400 }, () => {
            this.setOpacity(1);
          })
        }
        HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_DOCK_ANIMATION_END, 0);
      });
  }

  private updateHoverConfig(): void {
    this.dockHoverConfig.set('lightPositionX', this.lightPositionX);
    this.dockHoverConfig.set('lightPositionY', this.lightPositionY);
    this.dockHoverConfig.set('lightPositionZ', this.lightPositionZ);
    this.dockHoverConfig.set('intensityValue', this.intensityValue);
    AppStorage.setOrCreate('dockHoverConfig', this.dockHoverConfig);
  }

  private registerAfterUpdateRectCallback() {
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
    systemSceneSession?.registerAfterUpdateRectCallback((rect)=>{
      SCBSceneSessionManager.getInstance().refreshAvailableArea(this.screenProp.screenId);
    });
  }

  private unRegisterAfterUpdateRectCallback() {
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
    systemSceneSession?.unregisterAfterUpdateRectCallback();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    const screenId: number = this.screenProp.screenId;
    SCBSceneSessionManager.getInstance()?.on(SCBEventId.START_SCENE_FROM_OTHER, screenId, this.doStartSceneFromOther);
    SCBSceneSessionManager.getInstance()?.on(SCBEventId.CLOSE_SCENE, screenId, this.doCloseScene);
    SCBSceneSessionManager.getInstance()?.on(SCBEventId.TERMINATE_SCENE, screenId, this.doTerminate);
    SCBSceneSessionManager.getInstance()?.on(SCBEventId.SESSION_EXCEPTION, screenId, this.doSessionException);
    this.registerAfterUpdateRectCallback();
    viewMgrPolicy.registerViewController(ViewType.SMART_DOCK, this.smartDockController);
    this.smartDockController.registerCallback(this.viewCallback);
    this.smartDockController.updateId(this.persistentId);
    if (this.persistentId) {
      this.setShadow(true);
      this.setOpacity(0);
    }
    let ctx: UIContext = this.getUIContext();
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    config.updateConfigUiContext(ctx, this.screenProp);
    let dockHeightVp: number = config.mDockHeight;
    this.dockHeight = dockHeightVp;
    AppStorage.setOrCreate('dockHeight', this.dockHeight);
    this.positionState = DockPosition.BOTTOM;
    this.updateDockArea(this.screenProp);
    this.initGlobalAnimation();
    DockBackgroundMgr.getInstance().setDockRegion(screenId, this.screenProp.height, ctx.vp2px(dockHeightVp));
    DockBackgroundMgr.getInstance().init(screenId, this.backgroundChangeCallback, this.itemColorChangeCallback);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChange, screenId);
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.screenRotateChange, screenId);
    LayoutViewModel.getInstance(this.singleContext)
      .registerRefreshLayoutCallback(this.screenProp.screenId, this.refreshDockLayout);
    // 注册变化函数
    SCBSceneSessionManager.getInstance().registerDockVisibleCallback(this.dockVisibleCallback);
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();

    this.registerLockScreenAnimation();
    localEventManager.registerEventListener(this.localEventListener,
      [EventConstants.EVENT_VM_SWITCH_TO_DESKTOP_CALLBACK,
        EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK,
        EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK]);

    DesktopSwitchController.getInstance().registerVmStateCallback(this.vmStateCallback);

    if (this.isSupportNavGesture()) {
      scbEventExclusiveManager.registerEventExclusive(EventType.GESTURE_NAVBAR, () => {
        if (this.isInNavBarGesture) {
          this.navbarPanGesture.handleOnActionCancel();
        }
        scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, false);
      });
      this.eventMgr.on(OobeActivatedEvent, this.onOobeChangeEvent);
    }
  }

  private onOobeChangeEvent = (event: OobeActivatedEvent): void => {
    if (event && event.isActivated !== undefined) {
      log.showInfo(`onOobeChangeEvent event:${event.isActivated}`);
      this.isGestureEnabled = !event.isActivated;
    }
  }

  private onSystemColorModeChange(): void {
    DockBackgroundMgr.getInstance().setSystemColor(this.systemColorMode);
  }

  private onAppCenterViewChange(): void {
    DockBackgroundMgr.getInstance().setAppCenterShow(
      this.isAppCenterShow && viewMgrPolicy.isViewShowing(ViewType.APP_CENTER), this.screenProp.screenId);
  }

  private onRecentCenterViewChange(): void {
    DockBackgroundMgr.getInstance().setRecentViewShow(this.isRecentCenterShow);
  }

  private backgroundChangeCallback = (colorMode: number, isFullScreen: boolean) => {
    log.showInfo(`DockBackgroundMgr screenId:${this.screenProp.screenId} colorMode:${colorMode} fullScreen:${isFullScreen}`);
    if (this.currColorMode != colorMode) {
      this.currColorMode = colorMode;
    }
    if (this.isFullScreenLayout !== isFullScreen) {
      this.isFullScreenLayout = isFullScreen;
      this.setShadow(!isFullScreen);
    }
  }

  private itemColorChangeCallback = (colorMode: number) => {
    if ((colorMode > 0 && this.itemColorMode === 0) || (colorMode === 0 && this.itemColorMode > 0)) {
      this.itemColorMode = colorMode;
    }
  }

  private vmStateCallback: VmStateCallBack = (isVm: boolean, tarVmScreenId: number) => {
    let isVmDesktop = isVm && tarVmScreenId === this.screenProp.screenId;
    log.showInfo(`vmStateCallback, isVmDesktop: ${isVmDesktop}, screenId: ${this.screenProp.screenId},` +
      ` dockVisibleState: ${this.dockVisibleState}`);
    if (isVmDesktop) {
      viewMgrPolicy.hideView(ViewType.SMART_DOCK);
    } else if (this.dockVisibleState) {
      viewMgrPolicy.showView(ViewType.SMART_DOCK);
      if (this.isSupportNavGesture()) {
        localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_VISABLE_CHANGE, true);
      }
    }
  }

  private refreshDockLayout = () => {
    if (!FoldSceneKeyboardStateChangeMgr.getInstance().isNoNeedUpdateDockArea(
      this.screenProp, this.smartDockController, this.dockHeight, this.getUIContext())) {
      // 遮挡磁吸态, 忽略刷新组件范围
      log.showInfo('refreshDockLayout');
      this.updateDockArea(this.screenProp);
    }
  }

  private screenRotateChange = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void => {
    if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
      this.isRotating = true;
      if (this.translateY === 0 && this.isFullScreenLayout) {
        this.setTranslateY(this.getUIContext()?.px2vp(-1), 'ROTATE_BEGIN'); // 规避最大化窗口在旋转时dock和窗口之间漏缝问题
      }
    } else if (reason === SCBRotateChangeReason.ROTATE_END) {
      this.isRotating = false;
      if (this.isFullScreenLayout && this.finalState === SCBSmartDockViewState.VIEW_SHOWING) {
        this.setTranslateY(0, 'ROTATE_END');
      }
    }
  }

  private screenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screenProperty is change reason: ${reason} screenProperty.rotation:${screenProperty.rotation}`);
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.dockHeight = config.mDockHeight;
    AppStorage.setOrCreate('dockHeight', this.dockHeight);
    if (reason === SCBPropertyChangeReason.ROTATION) {
      // dock旋转, 关闭预览窗
      PcDockPopupMgr.getInstance().hide(screenProperty.screenId);
    }
    if (FoldSceneKeyboardStateChangeMgr.getInstance().isNoNeedUpdateDockArea(
      screenProperty, this.smartDockController, this.dockHeight, this.getUIContext())) {
      log.showWarn(`no need change updateDockArea, width: ${screenProperty.width}. height: ${screenProperty.height}`);
      return;
    }
    const bottomOffset: number = 0;
    this.updateDockArea(screenProperty, bottomOffset);
  }

  private setOpacity(alpha: number) {
    log.showInfo(`setOpacity from:${this.dockOpacity} to:${alpha}`);
    if (this.dockOpacity === alpha) {
      return;
    }
    this.dockOpacity = alpha;
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setOpacity(alpha);
  }

  private setTranslateY(dy: number, reason?: string) {
    log.showInfo(`setTranslateY from:${this.translateY} to:${dy} reason:${reason}`);
    if (this.translateY === dy) {
      return;
    }
    this.translateY = dy;
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setTranslate(0, dy, 0);
  }

  private setShadow(shadowEnable: boolean): void {
    if (shadowEnable) {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)
        ?.setShadowChange(20, '#1a000000', 0, -2);
    } else {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)
        ?.setShadowChange(0, '#00000000', 0, 0);
    }
  }

  private leaveKeyboardAnimateCb = (): void => {
    this.updateDockArea(this.screenProp);
  }

  private leaveKeyboardAnimateFinishCB = (): void => {
    this.positionState = DockPosition.BOTTOM;
    TraceUtil.endTrace(DomainName.SCB, 'OUT_BIG_SCREEN_KEYBOARD_STATE');
  }

  /**
   * 是否支持底部上滑手势
   * @returns
   */
  private isSupportNavGesture(): boolean {
    return DeviceHelper.is2In1DevicePcType();
  }

  private updateDockArea(screenProperty: SCBScreenProperty, bottomOffset: number = 0): void {
    // 窗口向下取整
    const dockHeightPx: number = Math.floor(this.getUIContext()?.vp2px(this.dockHeight));
    const newVpRect: ViewArea = {
      left: 0,
      top: this.getUIContext()?.px2vp(screenProperty.height) - this.dockHeight,
      width: this.getUIContext()?.px2vp(screenProperty.width),
      height: this.dockHeight
    };
    const newVpRectPx: ViewArea = {
      left: 0,
      top: screenProperty.height - dockHeightPx,
      width: screenProperty.width,
      height: dockHeightPx
    };
    this.smartDockController.updateArea(newVpRect);
    this.smartDockController.updateRectInPx(newVpRectPx);
  }

  private doSessionException = (persistentId?: number, containerId?: number) => {
    log.showInfo(`doSessionException : persistentId: ${persistentId}, containerId: ${containerId}`);
    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId);

    // 更新回收站状态
    if (PcSmartDockModel.getInstance().getRecycleBinStatus().persistentId === persistentId) {
      PcSmartDockModel.getInstance().updateRecycleBinStatus();
    }
  }

  private doTerminate = (persistentId?: number, containerId?: number) => {
    log.showInfo(`doTerminate : persistentId: ${persistentId}, containerId: ${containerId}`);
    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId);

    // 更新回收站状态
    if (PcSmartDockModel.getInstance().getRecycleBinStatus().persistentId === persistentId) {
      PcSmartDockModel.getInstance().updateRecycleBinStatus();
    }
  }

  private doStartSceneFromOther = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo, isBackTransition?: boolean,
    isFromClient?: boolean) => {
    const screenId = toInfo.screenId;
    const persistentId = toInfo.persistentId;
    const bundleName = toInfo.bundleName;
    const abilityName = toInfo.abilityName;
    const moduleName = toInfo.moduleName;
    const fileManagerMode = toInfo.want?.parameters?.fileManagerMode;

    log.showInfo(`doStartSceneFromOther : persistentId: ${persistentId}, bundleName: ${bundleName}, ` +
      `abilityName: ${abilityName}, moduleName: ${moduleName}, fileManagerMode: ${fileManagerMode}`);

    // 更新回收站状态
    const is2In1DevicePcType = DeviceHelper.is2In1DevicePcType();
    if (bundleName === (is2In1DevicePcType ? 'com.ohos.files' : 'com.ohos.filemanager') &&
      abilityName === (is2In1DevicePcType ? 'EntryAbility' : 'MainAbility') &&
      moduleName === (is2In1DevicePcType ? 'entry' : 'pc') &&
      fileManagerMode === 'RecycleBin') {
      PcSmartDockModel.getInstance().updateRecycleBinStatus({
        'screenId': screenId,
        'persistentId': persistentId,
      });
    }
  }

  private doCloseScene = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    isSaveSnapshot?: boolean) => {
    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    log.showInfo(`doCloseScene : persistentId: ${persistentId}, containerId: ${containerId}, ` +
      `containerSessionListLength: ${containerSessionList.length}`);

    // 更新回收站状态
    if (PcSmartDockModel.getInstance().getRecycleBinStatus().persistentId === persistentId) {
      PcSmartDockModel.getInstance().updateRecycleBinStatus();
    }

    let appName: string = '';
    for (let i = 0; i < containerSessionList.length; i++) {
      let item = containerSessionList[i];
      if (item?.primarySession?.sceneInfo.persistentId === persistentId) {
        appName = item?.primarySession?.sceneInfo.bundleName ?? '';
        break;
      }
      if (item?.secondarySession?.sceneInfo.persistentId === persistentId) {
        appName = item?.secondarySession?.sceneInfo.bundleName ?? '';
        break;
      }
    }
    if (appName === '') {
      log.showWarn('doCloseScene : return : appName is null');
      return;
    }
    let entryNum = 0;
    containerSessionList.forEach((item) => {
      if (appName === item?.primarySession?.sceneInfo.bundleName ?? '') {
        entryNum++;
      }
      if (appName === item?.secondarySession?.sceneInfo.bundleName ?? '') {
        entryNum++;
      }
    });
    log.showInfo(`doCloseScene ${appName}, entryNum: ${entryNum}`);
    if (entryNum > 1) {
      return;
    }
    // 如果entryNum=1，则表示待关闭的应用只有1个，此时需要清理AppInstanceKey
    PcSmartDockModel.getInstance().clearAppInstanceKeyInResident(appName);
    SmartDockModel.getInstance()
      .deleteDockItem({ bundleName: appName, keyName: '' }, SmartDockConstants.RECENT_DOCK_TYPE);
  }

  private onViewShow(): void {
    log.showDebug(TAG, 'onViewShow');
    AppStorage.setOrCreate('smartDockVisible', true);
  }

  private onViewHide(): void {
    log.showDebug(TAG, 'onViewHide');
    AppStorage.setOrCreate('smartDockVisible', false);
  }

  showDockWithNoAnimation(): void {
    log.showInfo('showDockWithNoAnimation');
    PcDockPopupMgr.getInstance().setIsDockMenuShow(this.screenProp.screenId, false);
    this.needHideDockAfterPopupExit = false;
    viewMgrPolicy.showView(ViewType.SMART_DOCK);
    this.setTranslateY(0, 'showDockWithNoAnimation');
    this.scaleRatio = 1;
    if (this.isSupportNavGesture()) {
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_VISABLE_CHANGE, true);
    }
  }

  initGlobalAnimationLog() {
    log.showInfo(`not show dock, powerStatus: ${AppStorage.get('powerStatus')}, dy: ${this.translateY}, ` +
      `isShowing: ${viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK)}, finalState: ${this.finalState},` +
      `isVmDesktop: ${DesktopSwitchController.getInstance().isVmDesktop(this.screenProp.screenId)},` +
      ` isOobeActivated: ${sSCBOobeManager.isOobeActivated()}, this screenId: ${this.screenProp.screenId}`);
  }

  private initGlobalAnimation(): void {
    let showDockViewWithAnimation = ((): void => {
      this.needHideDockAfterPopupExit = false;
      if (AppStorage.get('powerStatus') !== PowerStatus.RUNNING ||
        (viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK) && this.finalState === SCBSmartDockViewState.VIEW_SHOWING) ||
      DesktopSwitchController.getInstance().isVmDesktop(this.screenProp.screenId) ||
      FormCenterViewManager.getInstance().isFormCenterViewShowing() ||
      sSCBOobeManager.isOobeActivated()) {
        this.initGlobalAnimationLog();
        return;
      }
      if (this.isLock) {
        this.onLock();
        return;
      }
      log.showInfo(`show dock start, state:${this.finalState} opacity:${this.dockOpacity} trans:${this.translateY}`);
      this.setOpacity(LockScreenAnimationController.DEFAULT_OPACITY_RATIO);
      this.finalState = SCBSmartDockViewState.VIEW_SHOWING;
      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_SHOW_ANIMATION);
      viewMgrPolicy.showView(ViewType.SMART_DOCK);
      this.initGlobalAnimationAnimateTo();
      if (this.isSupportNavGesture()) {
        localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_VISABLE_CHANGE, true);
      }
    });
    GlobalContext.getInstance().setObject('showDockViewWithAnimation', showDockViewWithAnimation);

    let hideDockViewWithAnimation = ((): void => {
      if (AppStorage.get('powerStatus') !== PowerStatus.RUNNING ||
        (!viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK) && this.finalState === SCBSmartDockViewState.VIEW_HIDING)) {
        log.showInfo(`not hide dock, powerStatus: ${AppStorage.get('powerStatus')}, isShowing: ${viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK)}, finalState: ${this.finalState}`);
        return;
      }
      let isDragging: boolean = PCDockDragMgr.getInstance().isDockDragging;
      const isDockMenuShow: boolean = PcDockPopupMgr.getInstance().isDockMenuShow(this.screenProp.screenId);
      const isDockPopupShow: boolean = PcDockPopupMgr.getInstance().isDockPopupShow(this.screenProp.screenId);
      let levelTwoMenuShowDockStatus: boolean = AppStorage.get('levelTwoMenuShowDockStatus') as boolean;
      log.showInfo(`isDockPopupShow: ${isDockPopupShow}, isDockMenuShow: ${isDockMenuShow}, isDragging: ${isDragging}, ` +
      `levelTwoMenuShowDockStatus: ${levelTwoMenuShowDockStatus}`);
      // 当鼠标在dock栏上时，不隐藏dock，避免关闭状态栏二级菜单时，dock栏直接隐藏
      if (!FormCenterViewManager.getInstance().isFormCenterViewShowing() &&
        (isDockMenuShow || isDockPopupShow || levelTwoMenuShowDockStatus || isDragging ||
        this.needHideDockForStatusBar())) {
        log.showInfo('dock menu or snapshot showing, not hide dock now');
        this.needHideDockAfterPopupExit = true;
        return;
      }
      this.needHideDockAfterPopupExit = false;
      log.showInfo(`hide dock start, finalState:${this.finalState}, transY:${this.translateY}`);
      this.finalState = SCBSmartDockViewState.VIEW_HIDING;
      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_HIDE_ANIMATION);
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
      this.getUIContext()?.animateTo({
        curve: this.dockAnimate,
        onFinish: () => {
          log.showInfo(`hide dock end, finalState: ${this.finalState}`);
          if (this.finalState != SCBSmartDockViewState.VIEW_SHOWING) {
            viewMgrPolicy.hideView(ViewType.SMART_DOCK);
            if (this.isSupportNavGesture()) {
              localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_VISABLE_CHANGE, false);
            }
          }
          TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_HIDE_ANIMATION);
        }
      }, () => {
        if (this.finalState === SCBSmartDockViewState.VIEW_HIDING) {
          this.setTranslateY(this.dockHeight, 'hideDockViewWithAnimation');
        }
        this.scaleRatio = 1;
      })
    });
    GlobalContext.getInstance().setObject('hideDockViewWithAnimation', hideDockViewWithAnimation);
  }

  private needHideDockForStatusBar(): boolean {
    let isStatusBarPanelShowing: boolean = false;
    // 状态栏图标拖拽时dock栏不消失
    let isStatusBarDragging: boolean = false;
    let isStatusBarRightMenuOpen: boolean = false;
    // 避免分离模式下，打开右键，然后鼠标hover上dock栏，然后退出dock栏，dock栏不消失
    isStatusBarRightMenuOpen = AppStorage.get('isPluginMenuOpen') as boolean;
    isStatusBarDragging = PcStatusBarDragMgr.getInstance().isStatusBarDragging;
    // 避免分离模式下，打开二级面板，然后鼠标hover上dock栏，然后退出dock栏，dock栏不消失
    isStatusBarPanelShowing = statusbarPlCtrl.isStatusBarPanelShowing();
    log.showInfo(`isStatusBarRightMenuOpen: ${isStatusBarRightMenuOpen}, isStatusBarDragging: ${isStatusBarDragging}, \
    isStatusBarPanelShowing: ${isStatusBarPanelShowing}}`);
    return isStatusBarPanelShowing || isStatusBarDragging || isStatusBarRightMenuOpen || this.isDockHover;
  }

  private initGlobalAnimationAnimateTo(): void {
    this.getUIContext()?.animateTo({
      curve: this.dockAnimate,
      onFinish: () => {
        log.showInfo(`show dock end, finalState: ${this.finalState}`);
        this.onLock();
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_SHOW_ANIMATION);
      }
    }, () => {
      if (this.finalState === SCBSmartDockViewState.VIEW_SHOWING) {
        this.setTranslateY(0, 'showDockAnimation');
        this.setOpacity(1);
      }
      this.scaleRatio = 1;
    })
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    viewMgrPolicy.unregisterViewController(ViewType.SMART_DOCK);
    this.unRegisterAfterUpdateRectCallback();
    const screenId: number = this.screenProp.screenId;
    localEventManager.unregisterEventListener(this.localEventListener);
    DesktopSwitchController.getInstance().unregisterVmStateCallback(this.vmStateCallback);
    SCBSceneSessionManager.getInstance().unregisterDockVisibleCallback(screenId);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChange, screenId);
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.screenRotateChange, screenId);
    LayoutViewModel.getInstance(this.singleContext).unregisterRefreshLayoutCallback(screenId, this.refreshDockLayout);
    SCBSceneSessionManager.getInstance()?.off(SCBEventId.START_SCENE_FROM_OTHER, screenId, this.doStartSceneFromOther);
    SCBSceneSessionManager.getInstance()?.off(SCBEventId.CLOSE_SCENE, screenId, this.doCloseScene);
    SCBSceneSessionManager.getInstance()?.off(SCBEventId.TERMINATE_SCENE, screenId, this.doTerminate);
    SCBSceneSessionManager.getInstance()?.off(SCBEventId.SESSION_EXCEPTION, screenId, this.doSessionException);
    DockBackgroundMgr.getInstance().deInit(screenId);

    if (this.isSupportNavGesture()) {
      scbEventExclusiveManager.unRegisterEventExclusive(EventType.GESTURE_NAVBAR);
      this.eventMgr.offAll();
    }
  }

  private clearTimer(): void {
    if (delayHideDock) {
      clearTimeout(delayHideDock);
      delayHideDock = null;
    }
  }

  private delayHideDock(): void {
    this.clearTimer();
    delayHideDock = setTimeout(() => {
      log.showInfo('SCBSmartDock onHover false trigger');
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE, {
        'isVisible': false,
        'screenId': this.screenProp.screenId
      });
      this.DockLightEffectReset();
    }, DOCK_DELAY_TO_HIDE);
  }

  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: object | number) => {
      log.showInfo(`onReceiveEvent ${event}`);
      if (event === EventConstants.EVENT_VM_SWITCH_TO_DESKTOP_CALLBACK && this.dockVisibleState) {
        this.showDockWithNoAnimation();
      } else if (event === EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK) {
        this.hideDockAfterPopupExit(params as number);
      } else if (event === EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK) {
        if (params === undefined || this.screenProp.screenId === (params as number)) {
          this.needHideDockAfterPopupExit = false;
        }
      }
    }
  }

  private hideDockAfterPopupExit(screenId?: number): void {
    log.showInfo(`hideDockAfterPopupExit needHideDockAfterPopupExit:${this.needHideDockAfterPopupExit} ${screenId}`);
    if (screenId !== undefined && screenId !== this.screenProp.screenId) {
      return;
    }
    if (this.needHideDockAfterPopupExit) {
      if (GlobalContext.getInstance().hasObject('hideDockViewWithAnimation')) {
        let hideDockViewWithAnimation = (GlobalContext.getInstance()
          .getObject('hideDockViewWithAnimation')) as Function;
        hideDockViewWithAnimation();
      } else {
        viewMgrPolicy.hideView(ViewType.SMART_DOCK);
        if (this.isSupportNavGesture()) {
          localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_VISABLE_CHANGE, false);
        }
      }
      this.needHideDockAfterPopupExit = false;
    }
  }

  /**
   * onMouse 报点频率太高，报点10次更新一次
   *
   * @returns
   */
  private checkDockEffectUpdate(): boolean {
    this.onMouseTimes++;
    if (this.onMouseTimes % DOCK_LIGHT_EFFECT_UPDATE_INTERVAL === 0) {
      log.showDebug(`Satisfaction times interval,do dockEffectUpdate`);
      this.onMouseTimes = 0;
      return true;
    }
    return false;
  }

  private dockLightEffectUpdate(params: MouseEvent): void {
    let isShortcutKeyPanelShow: boolean = AppStorage.get<boolean>('isShortcutKeyPanelShow') as boolean;
    if (isShortcutKeyPanelShow) {
      return;
    }

    const smartDockArea = this.smartDockController.getArea();
    const curLightPositionX = params.windowX;
    const curLightPositionY = params.windowY - smartDockArea.top;

    if (this.lightPositionX === curLightPositionX && this.lightPositionY === curLightPositionY) {
      return;
    }

    this.lightPositionX = curLightPositionX;
    this.lightPositionY = curLightPositionY;
    this.getUIContext()?.animateTo({
      duration: this.lightAnimationDuration,
      curve: Curve.Linear
    }, () => {
      this.lightPositionZ = this.innerLightHeight;
      this.intensityValue = this.innerLightIntensity;
    })
    log.showDebug(`dockLightEffectUpdate ${this.lightPositionX}, ${this.lightPositionY}, ${this.lightPositionZ}, ${this.intensityValue}`);

    clearTimeout(delayHideLight);
    delayHideLight = setTimeout(() => {
      log.showInfo('SCBSmartDock delay hide light');
      this.DockLightEffectReset();
    }, LIGHT_DELAY_TO_HIDE);
  }

  private DockLightEffectReset(): void {
    this.getUIContext()?.animateTo({
      duration: this.lightAnimationDuration,
      curve: Curve.Linear
    }, () => {
      this.intensityValue = 0;
    })
  }

  private closeSmartDockCallback(): void {
    log.showInfo('transparent by closeSmartDockCallback');
    this.setOpacity(PowerStatusChangeAnimationController.OPACITY_RATIO);
    this.setTranslateY(this.dockHeight, 'closeSmartDockCallback');
  }

  private lockSmartDockCallback(): void {
    if (!LockScreenAnimationController.getInstance().isPlayDefaultUnlockAnimation()) {
      return;
    }
    log.showInfo('transparent by lockSmartDockCallback');
    this.setTranslateY(this.dockHeight, 'lockSmartDockCallback');
  }

  @Builder
  navGestureBuilder() {
    if (this.isSupportNavGesture() && this.isGestureEnabled) {
      Stack({ alignContent: Alignment.Center }) {
      }
      .width('100%')
      .height('100%')
      .align(Alignment.Bottom)
      .enabled(!this.isInNavBarGesture)
      .mouseResponseRegion({
        x: 0,
        y: 0,
        width: 0,
        height: 0
      })
      .onTouchIntercept(() => {
        return HitTestMode.Transparent;
      })
      .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
        recognizers: Array<GestureRecognizer>) => {
        if (current.getType() === GestureControl.GestureType.PAN_GESTURE && event.source === SourceType.Mouse) {
          return GestureJudgeResult.REJECT;
        }
        return GestureJudgeResult.CONTINUE;
      })
      .priorityGesture(
        GestureGroup(GestureMode.Exclusive,
          PanGesture({ distance: this.getUIContext()?.px2vp(20), direction: PanDirection.Vertical & PanDirection.Up })
            .onActionStart((event?: GestureEvent) => {
              log.showInfo(`onActionStart Math.abs(event.velocityY) ${Math.abs(event?.velocityY)}`);
              this.navbarPanGesture.handleOnActionStart(event);
            })
            .onActionUpdate((event?: GestureEvent) => {
              this.navbarPanGesture.handleOnActionUpdate(event);
            })
            .onActionEnd((event?: GestureEvent) => {
              log.showInfo(`onActionEnd Math.abs(event.velocityY):${Math.abs(event?.velocityY)}` +
                ` panGestureType:${this.navbarPanGesture.panGestureType}`);
              this.navbarPanGesture.handleOnActionEnd(event);
            })
            .onActionCancel((event?: GestureEvent) => {
              log.showInfo(`onActionCancel Math.abs(event.velocityY):${Math.abs(event?.velocityY)}` +
                ` panGestureType:${this.navbarPanGesture.panGestureType}`);
              this.navbarPanGesture.handleOnActionCancel();
            })
        )
      )
    }
  }

  build() {
    Stack() {
      DockBackgroundView({
        currColorMode: this.currColorMode,
        isFullScreenLayout: this.isFullScreenLayout
      })
      FixedSmartDock({
        screenProp: this.screenProp,
        singleContext: this.singleContext,
        currColorMode: this.itemColorMode
      })
        .scale({ x: this.scaleRatio, y: this.scaleRatio })
        .id(`${TAG}_SmartDock_${this.persistentId}`)
        .onMouse((mouseEvent) => {
          if (this.checkDockEffectUpdate()) {
            this.dockLightEffectUpdate(mouseEvent);
            this.updateHoverConfig();
          }
        })
        .onTouch((event: TouchEvent) => {
          if (event?.type === TouchType.Down) {
            statusbarPlCtrl.closeAllStatusBarPanel();
          }
        })
      this.navGestureBuilder()
    }
    .onHover((isHover) => {
      this.isDockHover = isHover;
      AppStorage.setOrCreate<boolean>('enableRenderGroup', !isHover);
      if (!isHover) {
        // 鼠标hover时更新this.isDockHover，确保沉浸式下鼠标移出dock栏时dock栏消失
        this.isDockHover = isHover;
        log.showInfo('SCBSmartDock onHover false trigger');
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE, {
          'isVisible': false,
          'screenId': this.screenProp.screenId
        });
        this.DockLightEffectReset();
      } else {
        localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK,
          this.screenProp.screenId);
        this.clearTimer();
      }
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
      performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
      if (event) {
        event.useCustomDropAnimation = true;
        event.setResult(DragResult.DRAG_FAILED);
      }
    })
    .onDragLeave(() => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE, {
        'isVisible': false,
        'screenId': this.screenProp.screenId
      });
    })
    .width('100%')
    .height(this.dockHeight)
    .pointLight({
      lightSource: PCUtils.is2D() ? {
        positionX: 0,
        positionY: 0,
        positionZ: 0,
        intensity: 0
      } : {
        positionX: this.lightPositionX,
        positionY: this.lightPositionY,
        positionZ: this.lightPositionZ,
        intensity: this.intensityValue
      }
    })
  }
}