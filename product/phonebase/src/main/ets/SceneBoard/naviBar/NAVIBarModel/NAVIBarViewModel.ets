/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  ArrayUtils,
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  PixelMapUtil,
  RectInfo
} from '@ohos/basicutils';
import type { SCBSystemSceneSession } from '@ohos/windowscene';
import {
  NAVIBarConstants,
  EventType,
  GestureType,
  INVALID_SCREEN_ID,
  launcherStatusUtil,
  scbEventExclusiveManager,
  scbGestureManager,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';
import {
  CEManager,
  DeviceHelper,
  EvtBus,
  HiSysEventUtil,
  ViewArea,
  WallpaperColorManager,
  WallpaperManager,
  WallpaperType
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  ScenePanelState,
  SpecificPanelZOrder
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { CommonConstants, DesktopModeEnum, NavBarHideAndShowManager, vibratorMgr } from '@ohos/launchercommon';
import { DesktopModeChangeFunc, DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DragEventType, SCBGestureNavBarViewModel } from '../../gesturenavigation/SCBGestureNavBarViewModel';
import { SystemSceneConstants } from '../../gesturenavigation/SystemSceneConstants';
import { SCBNaviBarConstants } from '../SCBNaviBarConstants';
import UDC from '@ohos.data.unifiedDataChannel';
import UniformTypeDescriptor from '@ohos.data.uniformTypeDescriptor';
import uriPermissionManager from '@ohos.application.uriPermissionManager';
import WantConstant from '@ohos.app.ability.wantConstant';
import { inputMonitor } from '@kit.InputKit';
import {
  BusinessError,
  commonEventManager,
  power,
  systemDateTime,
  systemParameterEnhance,
  thermal
} from '@kit.BasicServicesKit';
import {
  NaviBarShowParam,
  NaviBarStatusFlag,
  NAVIBarViewData,
  WeakNotifyState
} from './NAVIBarViewData';
import { NAVIBarData } from './NAVIBarData';
import { TouchEvent as InputTouch } from '@ohos.multimodalInput.touchEvent';
import {
  animateExBreak,
  animateExDelete,
  animateExNew,
  animateExStart,
  SendState,
  SendTouchEventController
} from '@ohos/windowscene/Index';
import { NAVIBarAnimate } from './NAVIBarAnimate';
import {
  NaviBarRegisterFunc,
  SCBNaviBarProxyManager
} from '../proxy/SCBNaviBarProxyManager';
import { curves, display } from '@kit.ArkUI';
import singletonBackViewModel from '../../gesturenavigation/back/viewmodel/SCBGestureBackViewModel';
import { HiSysLongPressMisTouchType } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import {
  CommonConstants as lockCommonConstants,
  slWallpaperMgr,
  SwitchEventData,
  UserSwitchListener,
  UserSwitchService
} from '@ohos/screenlockcommon';
import { aodHardwareConfig } from '@ohos/screenlockcommon/Index';
import { NAVIBarClickBackgroundData } from './NAVIBarClickBackgroundData';
import { SwitchType } from '../settings/preference/PreferenceType';
import { PowerStatusEnum, PowerStatusMonitor } from '@ohos/screenlockcommon/src/main/ets/monitor/PowerStatusMonitor';
import { FloatingNavigationManager } from '../proxy/FloatingNavigationManager';
import { ScreenLockThemeChangeEvent } from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { slStateHelper } from '../../screenlock/model/helper/SlStateHelper';
import { image } from '@kit.ImageKit';
import effectKit from '@ohos.effectKit';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';
import { PowerButton, powerButtonManager } from '@ohos/componenthelper/src/main/ets/manager/PowerButtonManager';
import { SCBWindowInputType } from '../../scenemanager/SCBScreen';
import { NavbarWindowManager } from '../../gesturenavigation/navbar/viewmodel/NavbarWindowManager';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { CloneStatusCallbackManager } from '@ohos/launchercommon/src/main/ets/manager/CloneStatusCallbackManager';
import { NaviBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/NaviBarVisualEffectManager';

const TAG = 'NAVIBarViewModel';
const BREAKPOINT_WIDTH = ArkUIAdapter.vp2px(840);
const BREAKPOINT_SCALE = 9 / 7.2;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);


export class NAVIBarViewModel {
  public naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
  public naviBarData: NAVIBarData = NAVIBarData.getInstance();
  public naviBarAnimate: NAVIBarAnimate = NAVIBarAnimate.getInstance();
  public naviBarClickBackgroundData: NAVIBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
  public readonly navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private readonly navbarWindowManager: NavbarWindowManager = this.navBarViewModel.windowManager;
   public static mInstance: NAVIBarViewModel;
   private screenProperty: SCBScreenProperty;
  private sendTouchEventController?: SendTouchEventController;
  private haveAvoid: boolean = true;
  private inputMonitorCallback = (touchEvent: InputTouch) => {
    if (CheckEmptyUtils.isEmpty(touchEvent) || CheckEmptyUtils.isEmpty(touchEvent.touches[0])) {
      log.showInfo('touchEvent or touchEvent.touches[0] is empty')
      return false;
    }
    return false;
  };
  private _userSwitchListener: UserSwitchListener = {
    onSwitched: this.handleSwitchedEvent.bind(this),
  };

  private handleSwitchedEvent(switchData: SwitchEventData): void {
    log.showInfo(`receive user switched, <${switchData?.fromAccountId} -> ${switchData?.toAccountId}>`);
    this.naviBarData.naviBarSettingsDataMgr.setGestureBottomHeight(switchData?.toAccountId);
    this.naviBarData.naviBarSettingsDataMgr.checkPrivateThreeButtonDataMoving();
  }

  static getInstance(screenProperty: SCBScreenProperty): NAVIBarViewModel {
    if (NAVIBarViewModel.mInstance == null) {
      NAVIBarViewModel.mInstance = new NAVIBarViewModel(screenProperty);
    }
    return NAVIBarViewModel.mInstance;
  }

  constructor(screenProperty: SCBScreenProperty) {
    this.screenProperty = screenProperty;
  }

  /**
   * 注册导航栏代理回调函数
   * 注册导航栏的各种功能回调，包括退出、显示、隐藏等
   * @param {number} persistentId - 持久化标识符，用于识别特定的视图控制器
   * @param {BaseViewController} viewController - 基础视图控制器，用于在注册过程中进行相关操作
   */
  public registerNaviBarProxyCallback(persistentId: number, viewController: BaseViewController) {
    // 注册导航栏退出功能的回调函数
    SCBNaviBarProxyManager.getInstance().registerProxyCallback(NaviBarRegisterFunc.NAVIBAR_EXIT_FUNC, this.naviBarExitFunc);
    // 注册导航栏显示功能的回调函数
    SCBNaviBarProxyManager.getInstance().registerProxyCallback(NaviBarRegisterFunc.NAVIBAR_SHOW_FUNC, this.naviBarShowFunc);
    // 注册导航栏隐藏功能的回调函数
    SCBNaviBarProxyManager.getInstance().registerProxyCallback(NaviBarRegisterFunc.NAVIBAR_HIDE_FUNC, this.naviBarHideFunc);
  }

  private naviBarExitFunc: Function = () => {
    log.showInfo(`NAVIBAR_EXIT_FUNC`);
    if (this.naviBarViewData.getNavibarOpacity() !== 0) {
      log.showInfo('return with naviBarOpacity');
      return;
    }
    // 改变胶囊的高度和宽度
    this.naviBarAnimate.changeCapsule(SCBNaviBarConstants.CAPSULE_HEIGHT_INIT, this.naviBarData.naviBarWidth);
    // 重置导航栏底部边距
    this.naviBarViewData.naviBarBottomMargin = gestureNavBarSettings.getNaviBarMarginBottom();
  }
  private naviBarShowFunc: Function = () => {
    log.showInfo(`NAVIBAR_SHOW_FUNC`);
    if (this.naviBarViewData.getNavibarOpacity() !== 0) {
      log.showInfo('return with naviBarOpacity');
      return;
    }
    this.barShowResetParam();
    // 设置导航栏的透明度
    this.naviBarViewData.barOpacityParam.barOpacity = 1;
    this.naviBarViewData.naviBarOpacity = 1;
  }
  private naviBarHideFunc: Function = () => {
    log.showInfo(`NAVIBAR_HIDE_FUNC`);
    // 设置导航栏的透明度为0
    this.naviBarViewData.naviBarOpacity = 0;
  }

  /**
   * 注销导航栏代理回调函数
   * 注销导航栏的各种功能回调，包括退出、显示、隐藏等
   */
  public unRegisterNaviBarProxyCallback() {
    // 注销导航栏退出功能的回调函数
    SCBNaviBarProxyManager.getInstance().unRegisterProxyCallback(NaviBarRegisterFunc.NAVIBAR_EXIT_FUNC);
    // 注销导航栏显示功能的回调函数
    SCBNaviBarProxyManager.getInstance().unRegisterProxyCallback(NaviBarRegisterFunc.NAVIBAR_SHOW_FUNC);
    // 注销导航栏隐藏功能的回调函数
    SCBNaviBarProxyManager.getInstance()
      .unRegisterProxyCallback(NaviBarRegisterFunc.NAVIBAR_HIDE_FUNC);
  }

  /**
   * 监听热安全或者应急模式
   */
  public registerDesktopModeCallback() {
    DesktopModeManager.getInstance().registerModeChangeCallback(TAG, this.desktopModeCallback);
  }

  private desktopModeCallback: DesktopModeChangeFunc =
    (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
      log.showInfo(`${TAG} Notify preDesktopMode: ${preDesktopMode} to targetDesktopMode: ${targetDesktopMode}`);
      FloatingNavigationManager.getInstance().setDesktopMode(targetDesktopMode);
      if (targetDesktopMode === DesktopModeEnum.EMERGENCY_MODE ||
        targetDesktopMode === DesktopModeEnum.THERMAL_SAFE_MODE) {
        this.naviBarViewData.isInEmergencyOrThermalSafeMode = true;
        // 应急或热安全模式下，重置导航条拖拽状态。
        this.naviBarAnimate.resetNaviBarParam();
        this.naviBarViewData.isOffInputMonitor = true;
        inputMonitor.off('touch', this.inputMonitorCallback);
      } else {
        this.naviBarViewData.isInEmergencyOrThermalSafeMode = false;
      }
      // 应急模式&热安全模式和普通模式切换场景下，按需拉起悬浮导航
      if (targetDesktopMode === DesktopModeEnum.BASE_MODE) {
        log.showInfo('enter BASE_MODE and restart FloatingNav');
        FloatingNavigationManager.getInstance().connectFloatingNavAbility();
        FloatingNavigationManager.getInstance().setFloatingNavStatus(true, false);
      }
    }

  /**
   * 在游戏中重置热区高度
   * 根据屏幕属性和持久化标识符，设置热区的高度
   */
  public resetHotAreaHeightInGame() {
    this.setWindowInputTypeAndGameSign();
    // 只有游戏有状态才进行热区重置操作，过滤非游戏场景
    const currentHotAreaHeight = this.navbarWindowManager.responseRegionHeight;
    if (currentHotAreaHeight === SystemSceneConstants.DEFAULT_HEIGHT ||
      currentHotAreaHeight === SystemSceneConstants.HOT_AREA_HEIGHT_IN_GAME) {
      const hotAreaHeight = this.naviBarViewData.isShowingNaviBar ?
      SystemSceneConstants.DEFAULT_HEIGHT : SystemSceneConstants.HOT_AREA_HEIGHT_IN_GAME;
      if (currentHotAreaHeight !== hotAreaHeight) {
        this.navbarWindowManager.setResponseRegionHeight(hotAreaHeight).update();
        log.showInfo(`hotAreaHeight is ${hotAreaHeight}, currentHotAreaHeight is ${currentHotAreaHeight}`);
      }
    }
  }

  /**
   * 设置窗口类型及游戏标记
   */
  public setWindowInputTypeAndGameSign(): void {
    let systemSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.navbarWindowManager.persistentId);
    if (this.isAntiAccidentalTouch()) {
      // 增加游戏内标记，即双发标记， 60为双发标记
      if (this.naviBarData.isInGameSign) {
        log.showDebug('no need set DUALTRIGGER_TOUCH');
        return;
      }
      systemSceneSession?.session?.setWindowInputType(SCBWindowInputType.DUALTRIGGER_TOUCH);
      this.naviBarData.isInGameSign = true;
      log.showInfo('setWindowInputTypeAndGameSign inputType is 60, isInGameSign is true');
    } else {
      // 标记恢复 19为正常标记
      if (!this.naviBarData.isInGameSign) {
        log.showDebug('no need set MIX_BUTTOM_ANTI_AXIS_MOVE');
        return;
      }
      systemSceneSession?.session?.setWindowInputType(SCBWindowInputType.MIX_BUTTOM_ANTI_AXIS_MOVE);
      this.naviBarData.isInGameSign = false;
      log.showInfo('setWindowInputTypeAndGameSign inputType is 19, isInGameSign is false');
    }
  }

  private isAntiAccidentalTouch(): boolean {
    return !this.naviBarViewData.isTempShowNaviBar && (this.isConfigureMisTouchAppActive() ||
    this.navBarViewModel.checkEnableAntiTouchStatus());
  }

  private barShowResetParam() {
    this.naviBarViewData.barOpacityParam.barOpacity = 1;
  }

  private registerPowerStatusListener(): void {
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.END_WAKE_UP, this.powerStatusWakeUp);
    if (aodHardwareConfig.isSupportAOD()) {
      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_SLEEP, this.powerStatusSleep);
    }
  }

  /**
   * 初始化游戏事件监听器
   * 初始化游戏事件监听器，订阅游戏事件和系统公共事件
   */
  public initGameEventListener(): void {
    // Subscribed Information.
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [SystemSceneConstants.GAME_EVENT_LISTENER_FIELD,
        commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED],
      publisherPermission: SystemSceneConstants.PUBLISH_SYSTEM_COMMON_EVENT
    }
    // Creating a Subscriber
    try {
      this.createSubscriber(subscribeInfo);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.showError(`Subscribing game event failed, message is ${err.message}`);
    }
  }

  private createSubscriber(subscribeInfo: commonEventManager.CommonEventSubscribeInfo) {
    let subscriber: commonEventManager.CommonEventSubscriber | null = null;
    commonEventManager.createSubscriber(subscribeInfo,
      (err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
        if (err) {
          log.showError(`Failed to create game subscriber, code is ${err.code}, message is ${err.message}`);
          return;
        }
        subscriber = commonEventSubscriber;
        // Subscribing to Common Event Callbacks.
        commonEventManager.subscribe(subscriber,
          (err: BusinessError, commonEventData: commonEventManager.CommonEventData) =>
          this.subscriberFunc(err, commonEventData));
      });
  }

  private subscriberFunc(err: BusinessError, commonEventData: commonEventManager.CommonEventData): void {
    if (err) {
      log.showError(`Failed to subscribe game event, code is ${err.code}, message is ${err.message}`);
      return;
    }
    if (commonEventData.event === commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED &&
      (commonEventData.code === power.DevicePowerMode.MODE_POWER_SAVE ||
        commonEventData.code === power.DevicePowerMode.MODE_NORMAL)) {
      log.showInfo(`powerMode changed to ${commonEventData.code}`);
      this.naviBarViewData.powerMode = commonEventData.code;
    }
    if (commonEventData.event === SystemSceneConstants.GAME_EVENT_LISTENER_FIELD && commonEventData.parameters) {
      this.setNaviBarStatusInGame(commonEventData.parameters['type'], commonEventData.parameters['bundleName']);
    } else {
      log.showError(`Game event data parameters are null`);
    }
  }

  /**
   * 更新手势区域
   * 根据屏幕属性、持久化标识符和视图控制器更新区域信息
   * @param {SCBScreenProperty} screenProperty - 屏幕属性对象，包含屏幕的宽度、高度等信息
   * @param {number} persistentId - 持久化标识符，用于识别特定的视图控制器
   * @param {BaseViewController} viewController - 基础视图控制器，用于处理视图相关操作
   */
  public updateArea(screenProperty: SCBScreenProperty): void {
    const widthVp = ArkUIAdapter.px2vp(screenProperty.width);
    // 计算导航栏的宽度并设置导航栏的宽度
    this.naviBarData.naviBarWidth = this.calculateNaviBarWidth(widthVp);
    this.naviBarViewData.capsuleWidth = this.naviBarData.naviBarWidth;
    this.naviBarViewData.weakNotifyParam.weakNotifyPlayPosition = -3 * this.naviBarViewData.capsuleWidth;
    this.naviBarClickBackgroundData.naviBarBackgroundWidth =
      this.naviBarViewData.capsuleWidth + 2 * SCBNaviBarConstants.NAVI_BAR_GAP_BETWEEN_BACKGROUND_AND_BAR;
    AppStorage.setOrCreate('gestureNavNaviBarWidth', this.naviBarData.naviBarWidth);
    // 设置透明度动画阈值X
    this.naviBarData.opacityAnimThresholdX = this.naviBarData.naviBarWidth / SystemSceneConstants.THREE;
    // 定义导航条区域
    const barRect: ViewArea = {
      left: (widthVp - this.naviBarData.naviBarWidth) / SystemSceneConstants.TWO,
      top: px2vp(screenProperty.height) - gestureNavBarSettings.getNaviBarMarginBottom() -
      SCBNaviBarConstants.GESTURE_NAV_NAVI_BAR_HEIGHT,
      width: this.naviBarData.naviBarWidth,
      height: SCBNaviBarConstants.GESTURE_NAV_NAVI_BAR_HEIGHT
    }
    // 打印导航条矩形信息
    log.showInfo(`set barRect=${JSON.stringify(barRect)}`);
    // 设置导航栏矩形
    scbGestureManager.setNaviBarRect(barRect);
    // 更新导航栏热区矩形
    this.updateNaviBarHotAreaRect(screenProperty, this.screenProperty);
    this.whetherEndWeakNavigationAnimation(this.naviBarViewData.capsuleWidth);
    this.naviBarAnimate.resetNaviBarParam();
    this.naviBarViewData.naviBarOpacity = 1;
    this.navbarWindowManager.isWindowFullScreen(false, false);
    this.naviBarViewData.isOffInputMonitor = true;
    inputMonitor.off('touch', this.inputMonitorCallback);
    // 若为新形态小折叠折叠态，手势窗口高度+4，热区高度+4
    const extraHeight = Math.floor(vp2px(0));
    const heightVp = px2vp(screenProperty.height);
    this.navbarWindowManager.setScreenProperty(screenProperty)
      .setWindowHeight(this.naviBarData.windowHeight)
      .setExtraHeight(extraHeight)
      .update(true);
  }

  /**
   * 决定是否唤醒AI导航条
   * @param naviBarShowParam 决策导航条是否消失的参数实体类
   */
  public notifyNaviBarShowStatusDecide(naviBarShowParam: NaviBarShowParam) {
    this.naviBarViewData.isShowingNaviBar = this.judgeShowNAVIBar(naviBarShowParam);
    this.notifyNaviBarShowStatus(naviBarShowParam.screenProperty);
  }

  private judgeShowNAVIBar(naviBarShowParam: NaviBarShowParam): boolean {
    // 提供给其它模块控制导航条显示和隐藏
    if (!naviBarShowParam.navBarIsShow) {
      return false;
    }
    if (naviBarShowParam.isInOutLauncher) {
      return false;
    }
    // 默认打开导航条，用命令行set系统参数的方式关闭导航条
    let isNaviBarConfigShow = 'true';
    try {
      isNaviBarConfigShow = systemParameterEnhance.getSync('persist.sceneboard.navibar.enable', 'true');
    } catch (error) {
      log.showError('get ai bar system param error');
    }
    if (this.checkModeAndShowController(naviBarShowParam)) {
      return false;
    }
    if (isNaviBarConfigShow !== 'true') {
      log.showInfo('return with cmd closed');
      return false;
    }
    if (naviBarShowParam.scenePanelState === ScenePanelState.SPLIT ||
      naviBarShowParam.scenePanelState === ScenePanelState.RECENT) {
      log.showInfo('show with SPLIT or RECENT');
      return true;
    }
    if (!this.checkNAVIBarShowParam(naviBarShowParam)) {
      return false;
    }
    return true;
  }

  private checkNAVIBarShowParam(naviBarShowParam: NaviBarShowParam): boolean {
    if (!naviBarShowParam.isNavigationBarEnable && !naviBarShowParam.isTempShowNaviBar) {
      log.showInfo(`return with SystemBarEnable isNavigationBarEnable:${naviBarShowParam.isNavigationBarEnable} isTempShowNaviBar：${naviBarShowParam.isTempShowNaviBar}`);
      return false;
    }
    return true;
  }

  private checkModeAndShowController(naviBarShowParam: NaviBarShowParam): boolean {
    if (naviBarShowParam.isInEmergencyOrThermalSafeMode) {
      log.showInfo('return with In EmergencyOrThermalSafe Mode');
      return true;
    }
    return false;
  }

  private setNaviBarStatusInGame(lastGameStatus: number, bundleName: string) {
    log.showInfo(`last game status code is ${lastGameStatus}, bundleName is ${bundleName}`);
    this.naviBarData.gameStatusMap.set(bundleName, lastGameStatus);
    if (lastGameStatus === SystemSceneConstants.GAME_FOCUS) {
      this.naviBarViewData.isTempShowNaviBar = true;
      this.naviBarData.isTimerRunning = true;
      clearTimeout(this.naviBarData.hideNaviBarTimer);
      clearTimeout(this.naviBarData.immerseHideNaviBarTimer);
      this.naviBarData.hideNaviBarTimer = setTimeout(() => {
        this.naviBarData.isTimerRunning = false;
        this.naviBarViewData.isTempShowNaviBar = false;
      }, SystemSceneConstants.NAVI_BAR_DISPLAY_TIME);
      FloatingNavigationManager.getInstance().checkShowFloatingNavigation(false, true);
    } else if (lastGameStatus !== SystemSceneConstants.ENTER_GAME) {
      this.naviBarViewData.isTempShowNaviBar = false;
      this.naviBarData.gameStatusMap.delete(bundleName);
    }
    this.setWindowInputTypeAndGameSign();
  }


  /**
   * 执行回退事件
   * @param event 操作事件
   */
  public processBackEvent(event?: GestureEvent): void {
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_SLIDE_TYPE6,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    let backViewModel = singletonBackViewModel;
    backViewModel.processBackEvent(GestureType.BACK, event);
  }

  /**
   * 更新AI导航条热区
   * @param curScreenProperty 当前屏幕参数
   * @param lastScreenProperty 之前屏幕参数
   */
  public updateNaviBarHotAreaRect(curScreenProperty: SCBScreenProperty, lastScreenProperty: SCBScreenProperty): void {
    const horizontalMargin = Math.trunc(curScreenProperty.width *
    SystemSceneConstants.AREA_REST_WIDTH / SystemSceneConstants.TWO);
    const newRectInfo: RectInfo = new RectInfo();
    newRectInfo.left = horizontalMargin;
    newRectInfo.top = Math.trunc(curScreenProperty.height - this.naviBarData.windowHeight);
    newRectInfo.right = curScreenProperty.width - horizontalMargin;
    newRectInfo.bottom = curScreenProperty.height;
    if (this.naviBarViewData.naviBarHotAreaRect.right !== newRectInfo.right ||
      this.naviBarViewData.naviBarHotAreaRect.top !== newRectInfo.top ||
      this.naviBarViewData.naviBarHotAreaRect.bottom !== newRectInfo.bottom ||
      this.naviBarViewData.naviBarHotAreaRect.left !== newRectInfo.left) {
      this.naviBarViewData.naviBarHotAreaRect = newRectInfo;
      this.notifyNaviBarShowStatus(lastScreenProperty, true);
    }
  }

  /**
   * 供多任务启动场景调用的接口，用于提前通知窗口侧navibar的位置
   *
   * @param screenProperty 屏幕信息
   * @param targetRotation 应用目标的旋转角度
   */
  public updateNaviBarHotAreaRectForRecent(screenProperty: SCBScreenProperty, targetRotation?: number): void {
    if (targetRotation === undefined) {
      log.showInfo(`updateNaviBarHotAreaRectForRecent targetRotation is undefined`);
      this.updateNaviBarHotAreaRect(this.screenProperty, this.screenProperty);
      return;
    }
    let screenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(screenProperty.screenId);
    log.showInfo(`updateNaviBarHotAreaRectForRecent targetRotation：${targetRotation} screenRotation:${screenRotation}`);
    let diffRotation = Math.abs(targetRotation - screenRotation);
    // 当目标角度和屏幕不一致时才需要通知窗口侧刷新
    if (diffRotation === RotationConstants.ROTATION_90 || diffRotation === RotationConstants.ROTATION_270) {
      let newScreenProperty = new SCBScreenProperty();
      newScreenProperty.copy(screenProperty);
      newScreenProperty.width = screenProperty.height;
      newScreenProperty.height = screenProperty.width;
      this.updateNaviBarHotAreaRect(newScreenProperty, this.screenProperty);
    }
  }

  /**
   * 判断是否完成导航动效
   * @param capsuleWidth 胶囊宽度
   */
  public whetherEndWeakNavigationAnimation(capsuleWidth: number): void {
    if (this.naviBarViewData.weakNotifyParam.weakNotifyState !== WeakNotifyState.STATIC) {
      log.showInfo(`this weakNotifyState is not STATIC`);
      this.naviBarAnimate.endWeakNavigationAnimation(capsuleWidth);
    }
  }

  /**
   * AI横条显隐变化，或显示时尺寸变化，则通知窗口侧
   * @param lastScreenProperty 之前屏幕参数
   * @param needToAvoid 是否必须需要设置避让区 true：无论之前是否设置，现在都要重新设置 false：只有之前与现在的不同才要设置
   */
  public notifyNaviBarShowStatus(lastScreenProperty: SCBScreenProperty, needToAvoid = false): void {
    const curHaveAvoid = this.naviBarViewData.isShowingNaviBar && this.naviBarViewData.isNavigationBarEnable;
    if (!needToAvoid && this.haveAvoid === curHaveAvoid) {
      return;
    }
    this.haveAvoid = curHaveAvoid;
    log.showInfo('notifyNaviBarShowStatus：curHaveAvoid: %{public}s, naviBarHotAreaRect: ' +
      '[left:%{public}d, right:%{public}d, top:%{public}d, bottom:%{public}d], screenId: %{public}d',
      curHaveAvoid, this.naviBarViewData.naviBarHotAreaRect.left, this.naviBarViewData.naviBarHotAreaRect.right,
      this.naviBarViewData.naviBarHotAreaRect.top, this.naviBarViewData.naviBarHotAreaRect.bottom, lastScreenProperty.screenId);
    let barRect = scbGestureManager.getNaviBarRect();
    let publishData = curHaveAvoid ? `1#${vp2px(barRect.left)},${vp2px(barRect.top)},` +
      `${vp2px(barRect.left + barRect.width)},${vp2px(barRect.top + barRect.height)}` : '0#0,0,0,0';
    log.showInfo('send msg GESTURE_NAV_BAR_EVENT ' + publishData);
    CEManager.publishCommentEvent('GESTURE_NAV_BAR_EVENT', {
      data: 'GESTURE_NAV_BAR_STATE_CHANGE',
      parameters: {
        'barRect': publishData
      }
    });
    SCBSceneSessionManager.getInstance().notifyAINavigationBarShowStatus(
      curHaveAvoid, this.naviBarViewData.naviBarHotAreaRect, lastScreenProperty.screenId);
    let portraitRect: RectInfo;
    let horizontalRect: RectInfo;
    if (lastScreenProperty.isScreenVertical()) {
      portraitRect = this.naviBarViewData.naviBarHotAreaRect;
      horizontalRect = this.calcNaviBarHotArea(lastScreenProperty.height, lastScreenProperty.width);
    } else {
      horizontalRect = this.naviBarViewData.naviBarHotAreaRect;
      portraitRect = this.calcNaviBarHotArea(lastScreenProperty.height, lastScreenProperty.width);
    }
    SCBSceneSessionManager.getInstance().notifyNextAINavigationBarRectInfo(lastScreenProperty.screenId,
      portraitRect, horizontalRect);
  }

  /**
   * 通过屏幕属性计算导航条热区
   * @param screenProperty 屏幕属性
   * @param naviBarHotAreaRect 导航条热区
   */
  public calcNaviBarHotArea(screenWidth: number, screenHeight: number): RectInfo {
    const horizontalMargin = Math.trunc(screenWidth * SystemSceneConstants.AREA_REST_WIDTH / SystemSceneConstants.TWO);
    // 定义导航条区域
    const naviBarHotAreaRect: RectInfo = new RectInfo();
    naviBarHotAreaRect.left = horizontalMargin;
    naviBarHotAreaRect.top = Math.trunc(screenHeight - this.naviBarData.windowHeight);
    naviBarHotAreaRect.right = screenWidth - horizontalMargin;
    naviBarHotAreaRect.bottom = screenHeight;
    return naviBarHotAreaRect;
  }

  /**
   * 导航条返回
   *
   * @param {HiSysLongPressMisTouchType} type - 报点类型
   */
  public naviBarRetract(type: HiSysLongPressMisTouchType): void {
    log.showInfo('SCBAiNavBar longPress Retract');
    this.naviBarData.isNaviBarRetract = false;
    HiSysEventUtil.reportLongPressMisTouch(type);
    this.naviBarViewData.weakNotifyParam.weakNotifyState = WeakNotifyState.STATIC;
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LIGHT,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    SCBNaviBarProxyManager.getInstance().destroy();
  }

  /**
   * 清除定时器
   */
  public clearTimeout() {

  }

  /**
   * 导航栏触摸事件处理
   * 根据触摸事件和按下事件，处理导航栏的触摸事件
   * @param {TouchEvent} event - 触摸事件
   * @param {TouchEvent | null} downEvent - 按下事件
   */
  public naviBarOnTouchEvent(event: TouchEvent, downEvent: TouchEvent | null) {
    this.whetherEndWeakNavigationAnimation(this.naviBarViewData.capsuleWidth);
    const isNewEffectsDestroy: boolean = this.isNewEffectsDestroy();
    if (!this.naviBarData.isNaviBarRetract && !isNewEffectsDestroy) {
      return;
    }
    let absDisplay = 0;
    if (downEvent) {
      let absDisplayY = Math.abs(downEvent?.changedTouches[0].displayY - event.changedTouches[0].displayY);
      let absDisplayX = Math.abs(downEvent?.changedTouches[0].displayX - event.changedTouches[0].displayX);
      absDisplay = absDisplayX ** 2 + absDisplayY ** 2;
    }
    if (isNewEffectsDestroy) {
      log.showInfo('out of NAVIBar long press distance by newEffects');
      this.clearTimeout();
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LIGHT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    } else {
      log.showInfo('out of NAVIBar long press distance');
      this.naviBarRetract(HiSysLongPressMisTouchType.MOVE);
      this.naviBarAnimate.onActionEndAndCancelAnimal();
      this.clearTimeout();
    }
  }

  public isNewEffectsDestroy(): boolean {
    return NaviBarVisualEffectManager.getInstance().isFullEffect();
  }

  /**
   * 计算AI导航条的宽度
   * @param widthVp 像素宽度
   * @returns AI导航条的宽度
   */
  public calculateNaviBarWidth(widthVp: number) {
    if (widthVp <= SystemSceneConstants.WIDTH_THRESHOLD_SMALL) {
      return SystemSceneConstants.BAR_DEFAULT_WIDTH;
    } else if (widthVp <= SystemSceneConstants.WIDTH_THRESHOLD_MIDDLE) {
      return widthVp / SystemSceneConstants.THREE - SystemSceneConstants.CAPSULE_MARGIN;
    } else {
      return widthVp / SystemSceneConstants.FOUR - SystemSceneConstants.CAPSULE_MARGIN;
    }
  }

  /**
   * 判断当前前台应用是否配置防误触
   * @returns
   */
  public isConfigureMisTouchAppActive(): boolean {
    if (!DeviceHelper.isPad() || this.naviBarViewData.scenePanelState !== ScenePanelState.FULLSCENE) {
      return false;
    }
    for (let appKeyName of SCBNaviBarConstants.MIS_TOUCH_APP_LIST) {
      let sessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance()
        .getContainerSessionList().getActiveSessionList();
      if (this.checkKeyNameIsInCurPanel(appKeyName, sessionList) && !this.naviBarViewData.isShowingNaviBar) {
        return true;
      }
    }
    return false;
  }

  /**
   * 根据应用keyName查找是否存在于前台
   * @param keyName 应用keyName
   * @returns true：存在 false：不存在
   */
  public selectAppInFrontDesk(keyName: string): boolean {
    let sessionManager = SCBSceneSessionManager.getInstance();
    let sessionList = sessionManager.getContainerSessionList().getActiveSessionList();
    if (this.checkKeyNameIsInCurPanel(keyName, sessionList)) {
      return true;
    }
    sessionList = sessionManager.getSpecialContainerSessionList().getActiveSessionList();
    if (this.checkKeyNameIsInCurPanel(keyName, sessionList)) {
      return true;
    }
    sessionList = sessionManager.getFloatingSessionList().getActiveSessionList();
    if (this.checkKeyNameIsInCurPanel(keyName, sessionList)) {
      return true;
    }
    log.showInfo('selectAppInFrontDesk is false');
    return false;
  }

  private checkKeyNameIsInCurPanel(keyName: string, sessionList?: Array<SCBSceneContainerSession>): boolean {
    if (sessionList === undefined || sessionList === null || sessionList.length === 0) {
      log.showInfo('checkKeyNameIsInCurPanel sessionList is null');
      return false;
    }
    for (let session of sessionList) {
      if (!session) {
        continue;
      }
      if (this.checkKeyNameBySceneInfo(keyName, session.primarySession?.sceneInfo)) {
        log.showInfo('checkKeyNameIsInCurPanel primary is true');
        return true;
      }
      if (this.checkKeyNameBySceneInfo(keyName, session.secondarySession?.sceneInfo)) {
        log.showInfo('checkKeyNameIsInCurPanel secondary is true');
        return true;
      }
      if (!session.isMidScene) {
        continue;
      }
      // 全景多窗的session会放到midSceneMap内
      for (let midScene of session.midSceneMap.values()) {
        if (this.checkKeyNameBySceneInfo(keyName, midScene?.sceneInfo)) {
          log.showInfo('checkKeyNameIsInCurPanel sceneInfo is true');
          return true;
        }
      }
    }
    return false;
  }

  private checkKeyNameBySceneInfo(keyName: string, sceneInfo?: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      return false;
    }
    return keyName === `${sceneInfo.bundleName}${sceneInfo.abilityName}${sceneInfo.moduleName}`;
  }

  /**
   * 前后台切换时是否中景模式判断
   */
  public checkIsInMidScene(): void {
    let isInMidScene = SCBSceneSessionManager.getInstance().IsTopContainerInMidScene();
    if (this.naviBarViewData.isInMidScene != isInMidScene) {
      log.showInfo(`isInMidScene: ${isInMidScene}`);
      this.naviBarViewData.isInMidScene = isInMidScene;
    }
  }

  /**
   * naviBarView组件创建需要执行的内容
   * @param persistentId
   * @param viewController
   */
  public naviBarViewAppear(persistentId: number, viewController: BaseViewController,
    sendTouchEventController: SendTouchEventController): void {
    this.naviBarData.naviBarSettingsDataMgr.registerCallback(SwitchType.CHANGE_CLICK_BACK_STATUS,
      (clickBackStatus: boolean): void => {
        this.naviBarViewData.clickBackStatus = clickBackStatus;
      }
    );
    this.notifyWallpaperDarkness();
    // naviBarView里面的appear代码迁移
    this.sendTouchEventController = sendTouchEventController;
    this.registerNaviBarProxyCallback(persistentId, viewController);
    this.naviBarData.viewController = viewController;
    this.registerDesktopModeCallback();
    SCBSceneSessionManager.getInstance().registerNavigationBarCallback(this.screenProperty.screenId,
      (navigationBarEnable: boolean, screenId: number = INVALID_SCREEN_ID) => {
        if (this.naviBarViewData.isNavigationBarEnable !== navigationBarEnable) {
          log.showInfo(`${TAG} NavigationBarCallback ${navigationBarEnable}`);
        }
        // 仅处理本屏幕窗口的显隐通知
        if (screenId !== INVALID_SCREEN_ID && screenId != this.screenProperty.screenId &&
          this.naviBarData.foldDisplayMode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_COORDINATION) {
          log.showInfo('screenId is different');
          return;
        }
        FloatingNavigationManager.getInstance().checkShowFloatingNavigation(navigationBarEnable);
        // 如果存在计时器置导航条显示为 FALSE, 则由计时器置 FALSE, 短时间内重复置FALSE可能导致导航条位置跳变问题
        if (navigationBarEnable || !this.naviBarData.isTimerRunning) {
          if (!navigationBarEnable) {
            // 隐藏导航条时统一延迟2s
            clearTimeout(this.naviBarData.immerseHideNaviBarTimer);
            this.naviBarData.isAppHide = true;
            this.naviBarData.immerseHideNaviBarTimer = setTimeout(() => {
              this.naviBarViewData.isTempShowNaviBar = navigationBarEnable;
            }, SystemSceneConstants.NAVI_BAR_DISPLAY_TIME);
          } else {
            clearTimeout(this.naviBarData.immerseHideNaviBarTimer);
            this.naviBarViewData.isTempShowNaviBar = navigationBarEnable;
          }
        }
        this.naviBarViewData.isNavigationBarEnable = navigationBarEnable;
        this.notifyNaviBarShowStatus(this.screenProperty);
      })

    SCBSceneSessionManager.getInstance().registerMidSceneStateChangeCallBack(() => {
      log.showInfo(`${TAG} MidSceneStateChangeCallBack`);
      this.checkIsInMidScene();
    })

    SCBSceneSessionManager.getInstance().registerWindowModeChangeCallback((isFullOrSplit: boolean) => {
      log.showInfo(`${TAG} WindowModeChangeCallback`);
      this.naviBarViewData.isInWindowModeFullScreen = isFullOrSplit;
      FloatingNavigationManager.getInstance().setIsInMultiWindowMode(isFullOrSplit &&
        this.naviBarViewData.isInMultiWindowMode);
    }, this.screenProperty.screenId)

    FloatingNavigationManager.getInstance().registersSwitchChangeCallBack((switchStatus: boolean) => {
      log.showInfo(`${TAG} FloatingNavSwitchChangeCallBack`);
      this.naviBarViewData.isFloatingNavShow = switchStatus;
      this.naviBarViewData.isToastShow = false;
    })


    this.registerThermalLevel();

    scbGestureManager.registerNaviBarChangeAnim((type: number) => {
      log.showInfo(`change type:${type}`);
      this.naviBarData.currentGestureNAVIBarType = type;
      this.naviBarAnimate.naviBarChangeAnim(type);
    });

    scbGestureManager.registerGestureEnableStateChange((isEnable: boolean, caller: string) => {
      FloatingNavigationManager.getInstance().setIsGestureEnable(isEnable, caller);
    });

    WallpaperColorManager.getInstance().registerDegreeChangeCallBack((degree: number) => {
      log.showInfo(`degree change: ${degree}`);
      this.setNaviBarAreaDegree();
    });

    this.registerPowerStatusListener();
    this.initGameEventListener();
    this.naviBarData.naviBarAllowDropType = this.naviBarData.allDropType();
    this.naviBarData.naviBarSettingsDataMgr.initData();
    this.naviBarData.naviBarSettingsDataMgr.registerKeyObserver();

    NavBarHideAndShowManager.getInstance().registerNavBarHideAndShowCallback(TAG,
      (navBarIsShow: boolean) => {
        this.naviBarViewData.navBarIsShow = navBarIsShow;
      });
    this.createNaviBarEndAnimate(persistentId, viewController);
    EvtBus.on(ScreenLockThemeChangeEvent, this.notifyWallpaperDarkness);
    this.naviBarData.desktopContext?.eventHub.on('NaviBarUseAppColor', (naviBarUseAppColor: boolean) => {
      log.showInfo(`naviBarUseAppColor is:${naviBarUseAppColor}`);
      this.naviBarViewData.naviBarUseAppColor = naviBarUseAppColor;
    });
    // 用户切换监听
    UserSwitchService.getInstance().registerObserver(this._userSwitchListener);
    NaviBarVisualEffectManager.getInstance().init();
     this.naviBarData.naviBarSettingsDataMgr.checkPrivateThreeButtonDataMoving();
     CloneStatusCallbackManager.getInstance().registerCloneStatusMonitor();
   }

   /**
    * 通知导航条是否需要压黑
   */
  private notifyWallpaperDarkness = (): void => {
    NAVIBarData.getInstance().notifyWallpaperDarkeness(this.getClockNeedToDarken() ?? false,
      this.screenProperty?.width ?? 1, this.screenProperty?.height ?? 1);
  }

  private getClockNeedToDarken(): boolean {
    if (slStateHelper.getSlBindState().getImmersiveWallPaperUsing()) {
      return slWallpaperMgr.getSlWallpaperState().isLightWallpaper ?? false;
    }
    return slStateHelper.getSlClockStaticState().getBrightness() < lockCommonConstants.BRIGHT_NESS_DEFAULT;
  }

  private powerStatusWakeUp = () => {
    log.showInfo('subscribe END_WAKE_UP');
    scbGestureManager.naviBarChange(NAVIBarConstants.GESTURE_NAVI_BAR_TYPE_SCREEN_LOCK);
  }
  private powerStatusSleep = () => {
    log.showInfo('subscribe BEGIN_SLEEP');
    scbGestureManager.naviBarChange(NAVIBarConstants.GESTURE_NAVI_BAR_TYPE_AOD);
  }

  private registerThermalLevel() {
    try {
      thermal.registerThermalLevelCallback((level: thermal.ThermalLevel) => {
        log.showInfo(`Thermal level ${level}`);
        if (this.naviBarViewData.thermalLevel !== level) {
          this.naviBarViewData.thermalLevel = level;
        }
      });
      log.showInfo('register thermal level callback success.');
    } catch (err) {
      log.showError(`register thermal level callback failed, error: ${err}`);
    }
  }

  private createNaviBarEndAnimate(persistentId: number, viewController: BaseViewController): void {
    animateExNew('MSG_NAVIBAR_END_ANIMATION',
      { curve: curves.springMotion(0.4, 1.11) },
      () => {
        this.naviBarAnimate.changeToDefaultNaviBar();
      },
      () => {
        this.navbarWindowManager.setWindowHeight(this.naviBarData.windowHeight).update();
      }
    );
  }

  /**
   * naviBarView组件销毁需要执行的内容
   */
  public naviBarViewDisAppear(): void {
    // naviBarView里面的disappear代码迁移
    this.unRegisterNaviBarProxyCallback();
    DesktopModeManager.getInstance().unRegisterModeChangeCallback(TAG);
    SCBSceneSessionManager.getInstance().unRegisterNavigationBarCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unRegisterMidSceneStateChangeCallBack();
    FloatingNavigationManager.getInstance().unregistersSwitchChangeCallBack();
    SCBSceneSessionManager.getInstance().unregisterWindowModeChangeCallback(this.screenProperty.screenId);
    scbGestureManager.unRegisterNaviBarChangeAnim();
    scbGestureManager.unRegisterGestureEnableStateChange();
    WallpaperColorManager.getInstance().unRegisterDegreeChangeCallBack();
    this.naviBarData.naviBarSettingsDataMgr.unregisterKeyObserver();
    NavBarHideAndShowManager.getInstance().unRegisterNavBarHideAndShowCallback(TAG);
    this.unRegisterThermalLevel();
    this.unRegisterPowerStatusListener();
    EvtBus.off(ScreenLockThemeChangeEvent, this.notifyWallpaperDarkness);
    UserSwitchService.getInstance().unRegisterObserver(this._userSwitchListener);
    this.naviBarData.naviBarSettingsDataMgr.unRegisterCallback(SwitchType.CHANGE_CLICK_BACK_STATUS);
    CloneStatusCallbackManager.getInstance().unregisterCloneStatusMonitor();
  }

  private unRegisterThermalLevel() {
    try {
      thermal.unregisterThermalLevelCallback(() => {
        log.showInfo('unsubscribe thermal level success.');
      });
      log.showInfo('unregister thermal level callback success.');
    } catch (err) {
      log.showError('unregister thermal level callback failed, err: ' + err);
    }
  }

  private unRegisterPowerStatusListener() {
    PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.BEGIN_WAKE_UP, this.powerStatusWakeUp);
    if (aodHardwareConfig.isSupportAOD()) {
      PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.BEGIN_SLEEP, this.powerStatusSleep);
    }
  }

  /**
   *
   * @returns 导航条位置是否有位移
   */
  public isNaviBarTranslate(): boolean {
    return this.naviBarViewData.barTranslateParam.barTranslateY !== 0 ||
      this.naviBarViewData.barTranslateParam.barTranslateX !== 0;
  }

  private async setNaviBarAreaDegree(): Promise<void> {
    let degree = await this.getNaviBarAreaPaperDegree();
    FloatingNavigationManager.getInstance().setWallpaperDegree(degree);
  }

  private async getNaviBarAreaPaperDegree(): Promise<number> {
    try {
      // 获取壁纸
      let desktopWallpaperImg = await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.DESKTOP, TAG);
      PixelMapUtil.addName(desktopWallpaperImg, 'WallPaperMgr_getNaviBarAreaPaperDegree');
      let wallpaperWidth = 0;
      let wallpaperHeight = 0;
      await desktopWallpaperImg.getImageInfo().then((info: image.ImageInfo) => {
        wallpaperWidth = info.size.width;
        wallpaperHeight = info.size.height;
        log.showInfo('info.width = ' + info.size.width);
        log.showInfo('info.height = ' + info.size.height);
      }).catch((err: BusinessError) => {
        log.showInfo(`Failed getImageInfo.And the error code is: ${err.code}`);
      });
      if (wallpaperHeight <= vp2px(SystemSceneConstants.DEFAULT_HEIGHT)) {
        return SCBNaviBarConstants.EXTREMELY_FLOWERY_PICTURE;
      }
      // 调整成算式
      const xEnd: number = wallpaperWidth
      const yStart: number = wallpaperHeight - vp2px(SystemSceneConstants.DEFAULT_HEIGHT);
      const yEnd: number = wallpaperHeight;
      let resVal = SCBNaviBarConstants.EXTREMELY_FLOWERY_PICTURE;
      let colorPicker = await effectKit.createColorPicker(desktopWallpaperImg,
        [0, yStart / wallpaperHeight, xEnd / wallpaperWidth, yEnd / wallpaperHeight]);
      resVal = colorPicker.discriminatePitureLightDegree();
      // MemoryUtils.removeNapiWrap(colorPicker, false);
      log.showInfo(`getWallpaper degree :  ${resVal}`);
      return resVal;
    } catch (error) {
      log.showError('getNaviBarAreaPaperDegree is fail');
      return SCBNaviBarConstants.EXTREMELY_FLOWERY_PICTURE;
    }
  }
}
