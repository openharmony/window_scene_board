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
  AIBarConstants,
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
import { SCBAiBarConstants } from '../SCBAiBarConstants';
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
  AiBarShowParam,
  AiBarStatusFlag,
  AIBarViewData,
  WeakNotifyState
} from './AIBarViewData';
import { AIBarData } from './AIBarData';
import { TouchEvent as InputTouch } from '@ohos.multimodalInput.touchEvent';
import {
  animateExBreak,
  animateExDelete,
  animateExNew,
  animateExStart,
  SendState,
  SendTouchEventController
} from '@ohos/windowscene/Index';
import { AIBarAnimate } from './AIBarAnimate';
import {
  AiBarRegisterFunc,
  SCBAiBarProxyManager
} from '../proxy/SCBAiBarProxyManager';
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
import { AIBarClickBackgroundData } from './AIBarClickBackgroundData';
import { SwitchType } from '../settings/preference/PreferenceType';
import { PowerStatusEnum, PowerStatusMonitor } from '@ohos/screenlockcommon/src/main/ets/monitor/PowerStatusMonitor';
import { FloatingNavigationManager } from '../proxy/FloatingNavigationManager';
import { ScreenLockThemeChangeEvent } from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { slStateHelper } from '../../screenlock/model/helper/SlStateHelper';
import { image } from '@kit.ImageKit';
import effectKit from '@ohos.effectKit';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';
import { PowerButton, powerButtonManager } from '@ohos/componenthelper/src/main/ets/manager/PowerButtonManager';
import { VoiceConstant, SystemEvent } from '@ohos/voiceagent';
import { SCBWindowInputType } from '../../scenemanager/SCBScreen';
import { NavbarWindowManager } from '../../gesturenavigation/navbar/viewmodel/NavbarWindowManager';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { CloneStatusCallbackManager } from '@ohos/launchercommon/src/main/ets/manager/CloneStatusCallbackManager';
import { AiBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/AiBarVisualEffectManager';

const TAG = 'AIBarViewModel';
const BREAKPOINT_WIDTH = ArkUIAdapter.vp2px(840);
const BREAKPOINT_SCALE = 9 / 7.2;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);


export class AIBarViewModel {
  public aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
  public aiBarData: AIBarData = AIBarData.getInstance();
  public aiBarAnimate: AIBarAnimate = AIBarAnimate.getInstance();
  public aiBarClickBackgroundData: AIBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
  public readonly navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private readonly navbarWindowManager: NavbarWindowManager = this.navBarViewModel.windowManager;
  public static mInstance: AIBarViewModel;
  private bundleChangeEvent: SystemEvent = new SystemEvent();
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
    this.aiBarData.aiBarSettingsDataMgr.setGestureBottomHeight(switchData?.toAccountId);
    this.aiBarData.aiBarSettingsDataMgr.checkPrivateThreeButtonDataMoving();
  }

  static getInstance(screenProperty: SCBScreenProperty): AIBarViewModel {
    if (AIBarViewModel.mInstance == null) {
      AIBarViewModel.mInstance = new AIBarViewModel(screenProperty);
    }
    return AIBarViewModel.mInstance;
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
  public registerAiBarProxyCallback(persistentId: number, viewController: BaseViewController) {
    // 注册导航栏退出功能的回调函数
    SCBAiBarProxyManager.getInstance().registerProxyCallback(AiBarRegisterFunc.AIBAR_EXIT_FUNC, this.aiBarExitFunc);
    // 注册导航栏显示功能的回调函数
    SCBAiBarProxyManager.getInstance().registerProxyCallback(AiBarRegisterFunc.AIBAR_SHOW_FUNC, this.aiBarShowFunc);
    // 注册导航栏隐藏功能的回调函数
    SCBAiBarProxyManager.getInstance().registerProxyCallback(AiBarRegisterFunc.AIBAR_HIDE_FUNC, this.aiBarHideFunc);
  }

  private aiBarExitFunc: Function = () => {
    log.showInfo(`AIBAR_EXIT_FUNC`);
    if (this.aiBarViewData.getAibarOpacity() !== 0) {
      log.showInfo('return with aiBarOpacity');
      return;
    }
    // 改变胶囊的高度和宽度
    this.aiBarAnimate.changeCapsule(SCBAiBarConstants.CAPSULE_HEIGHT_INIT, this.aiBarData.aiBarWidth);
    // 重置导航栏底部边距
    this.aiBarViewData.aiBarBottomMargin = gestureNavBarSettings.getAiBarMarginBottom();
  }
  private aiBarShowFunc: Function = () => {
    log.showInfo(`AIBAR_SHOW_FUNC`);
    if (this.aiBarViewData.getAibarOpacity() !== 0) {
      log.showInfo('return with aiBarOpacity');
      return;
    }
    this.barShowResetParam();
    // 设置导航栏的透明度
    this.aiBarViewData.barOpacityParam.barOpacity = 1;
    this.aiBarViewData.aiBarOpacity = 1;
  }
  private aiBarHideFunc: Function = () => {
    log.showInfo(`AIBAR_HIDE_FUNC`);
    // 设置导航栏的透明度为0
    this.aiBarViewData.aiBarOpacity = 0;
  }

  /**
   * 注销导航栏代理回调函数
   * 注销导航栏的各种功能回调，包括退出、显示、隐藏等
   */
  public unRegisterAiBarProxyCallback() {
    // 注销导航栏退出功能的回调函数
    SCBAiBarProxyManager.getInstance().unRegisterProxyCallback(AiBarRegisterFunc.AIBAR_EXIT_FUNC);
    // 注销导航栏显示功能的回调函数
    SCBAiBarProxyManager.getInstance().unRegisterProxyCallback(AiBarRegisterFunc.AIBAR_SHOW_FUNC);
    // 注销导航栏隐藏功能的回调函数
    SCBAiBarProxyManager.getInstance()
      .unRegisterProxyCallback(AiBarRegisterFunc.AIBAR_HIDE_FUNC);
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
        this.aiBarViewData.isInEmergencyOrThermalSafeMode = true;
        // 应急或热安全模式下，重置导航条拖拽状态。
        this.aiBarAnimate.resetAiBarParam();
        this.aiBarViewData.isOffInputMonitor = true;
        inputMonitor.off('touch', this.inputMonitorCallback);
      } else {
        this.aiBarViewData.isInEmergencyOrThermalSafeMode = false;
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
      const hotAreaHeight = this.aiBarViewData.isShowingAiBar ?
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
      if (this.aiBarData.isInGameSign) {
        log.showDebug('no need set DUALTRIGGER_TOUCH');
        return;
      }
      systemSceneSession?.session?.setWindowInputType(SCBWindowInputType.DUALTRIGGER_TOUCH);
      this.aiBarData.isInGameSign = true;
      log.showInfo('setWindowInputTypeAndGameSign inputType is 60, isInGameSign is true');
    } else {
      // 标记恢复 19为正常标记
      if (!this.aiBarData.isInGameSign) {
        log.showDebug('no need set MIX_BUTTOM_ANTI_AXIS_MOVE');
        return;
      }
      systemSceneSession?.session?.setWindowInputType(SCBWindowInputType.MIX_BUTTOM_ANTI_AXIS_MOVE);
      this.aiBarData.isInGameSign = false;
      log.showInfo('setWindowInputTypeAndGameSign inputType is 19, isInGameSign is false');
    }
  }

  private isAntiAccidentalTouch(): boolean {
    return !this.aiBarViewData.isTempShowAiBar && (this.isConfigureMisTouchAppActive() ||
    this.navBarViewModel.checkEnableAntiTouchStatus());
  }

  private barShowResetParam() {
    this.aiBarViewData.barOpacityParam.barOpacity = 1;
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
      this.aiBarViewData.powerMode = commonEventData.code;
    }
    if (commonEventData.event === SystemSceneConstants.GAME_EVENT_LISTENER_FIELD && commonEventData.parameters) {
      this.setAiBarStatusInGame(commonEventData.parameters['type'], commonEventData.parameters['bundleName']);
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
    this.aiBarData.aiBarWidth = this.calculateAiBarWidth(widthVp);
    this.aiBarViewData.capsuleWidth = this.aiBarData.aiBarWidth;
    this.aiBarViewData.weakNotifyParam.weakNotifyPlayPosition = -3 * this.aiBarViewData.capsuleWidth;
    this.aiBarClickBackgroundData.aiBarBackgroundWidth =
      this.aiBarViewData.capsuleWidth + 2 * SCBAiBarConstants.AI_BAR_GAP_BETWEEN_BACKGROUND_AND_BAR;
    AppStorage.setOrCreate('gestureNavAiBarWidth', this.aiBarData.aiBarWidth);
    // 设置透明度动画阈值X
    this.aiBarData.opacityAnimThresholdX = this.aiBarData.aiBarWidth / SystemSceneConstants.THREE;
    // 定义导航条区域
    const barRect: ViewArea = {
      left: (widthVp - this.aiBarData.aiBarWidth) / SystemSceneConstants.TWO,
      top: px2vp(screenProperty.height) - gestureNavBarSettings.getAiBarMarginBottom() -
      SCBAiBarConstants.GESTURE_NAV_AI_BAR_HEIGHT,
      width: this.aiBarData.aiBarWidth,
      height: SCBAiBarConstants.GESTURE_NAV_AI_BAR_HEIGHT
    }
    // 打印导航条矩形信息
    log.showInfo(`set barRect=${JSON.stringify(barRect)}`);
    // 设置导航栏矩形
    scbGestureManager.setAiBarRect(barRect);
    // 更新导航栏热区矩形
    this.updateAiBarHotAreaRect(screenProperty, this.screenProperty);
    this.whetherEndWeakNavigationAnimation(this.aiBarViewData.capsuleWidth);
    this.aiBarAnimate.resetAiBarParam();
    this.aiBarViewData.aiBarOpacity = 1;
    this.navbarWindowManager.isWindowFullScreen(false, false);
    this.aiBarViewData.isOffInputMonitor = true;
    inputMonitor.off('touch', this.inputMonitorCallback);
    // 若为新形态小折叠折叠态，手势窗口高度+4，热区高度+4
    const extraHeight = Math.floor(vp2px(0));
    const heightVp = px2vp(screenProperty.height);
    this.navbarWindowManager.setScreenProperty(screenProperty)
      .setWindowHeight(this.aiBarData.windowHeight)
      .setExtraHeight(extraHeight)
      .update(true);
  }

  /**
   * 决定是否唤醒AI导航条
   * @param aiBarShowParam 决策导航条是否消失的参数实体类
   */
  public notifyAiBarShowStatusDecide(aiBarShowParam: AiBarShowParam) {
    this.aiBarViewData.isShowingAiBar = this.judgeShowAIBar(aiBarShowParam);
    this.notifyAiBarShowStatus(aiBarShowParam.screenProperty);
  }

  private judgeShowAIBar(aiBarShowParam: AiBarShowParam): boolean {
    // 提供给其它模块控制导航条显示和隐藏
    if (!aiBarShowParam.navBarIsShow) {
      return false;
    }
    if (aiBarShowParam.isInOutLauncher) {
      return false;
    }
    // 默认打开导航条，用命令行set系统参数的方式关闭导航条
    let isAiBarConfigShow = 'true';
    try {
      isAiBarConfigShow = systemParameterEnhance.getSync('persist.sceneboard.aibar.enable', 'true');
    } catch (error) {
      log.showError('get ai bar system param error');
    }
    if (this.checkModeAndShowController(aiBarShowParam)) {
      return false;
    }
    if (isAiBarConfigShow !== 'true') {
      log.showInfo('return with cmd closed');
      return false;
    }
    if (aiBarShowParam.scenePanelState === ScenePanelState.SPLIT ||
      aiBarShowParam.scenePanelState === ScenePanelState.RECENT) {
      log.showInfo('show with SPLIT or RECENT');
      return true;
    }
    if (!this.checkAIBarShowParam(aiBarShowParam)) {
      return false;
    }
    return true;
  }

  private checkAIBarShowParam(aiBarShowParam: AiBarShowParam): boolean {
    if (!aiBarShowParam.isNavigationBarEnable && !aiBarShowParam.isTempShowAiBar) {
      log.showInfo(`return with SystemBarEnable isNavigationBarEnable:${aiBarShowParam.isNavigationBarEnable} isTempShowAiBar：${aiBarShowParam.isTempShowAiBar}`);
      return false;
    }
    return true;
  }

  private checkModeAndShowController(aiBarShowParam: AiBarShowParam): boolean {
    if (aiBarShowParam.isInEmergencyOrThermalSafeMode) {
      log.showInfo('return with In EmergencyOrThermalSafe Mode');
      return true;
    }
    return false;
  }

  private setAiBarStatusInGame(lastGameStatus: number, bundleName: string) {
    log.showInfo(`last game status code is ${lastGameStatus}, bundleName is ${bundleName}`);
    this.aiBarData.gameStatusMap.set(bundleName, lastGameStatus);
    if (lastGameStatus === SystemSceneConstants.GAME_FOCUS) {
      this.aiBarViewData.isTempShowAiBar = true;
      this.aiBarData.isTimerRunning = true;
      clearTimeout(this.aiBarData.hideAiBarTimer);
      clearTimeout(this.aiBarData.immerseHideAiBarTimer);
      this.aiBarData.hideAiBarTimer = setTimeout(() => {
        this.aiBarData.isTimerRunning = false;
        this.aiBarViewData.isTempShowAiBar = false;
      }, SystemSceneConstants.AI_BAR_DISPLAY_TIME);
      FloatingNavigationManager.getInstance().checkShowFloatingNavigation(false, true);
    } else if (lastGameStatus !== SystemSceneConstants.ENTER_GAME) {
      this.aiBarViewData.isTempShowAiBar = false;
      this.aiBarData.gameStatusMap.delete(bundleName);
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
  public updateAiBarHotAreaRect(curScreenProperty: SCBScreenProperty, lastScreenProperty: SCBScreenProperty): void {
    const horizontalMargin = Math.trunc(curScreenProperty.width *
    SystemSceneConstants.AREA_REST_WIDTH / SystemSceneConstants.TWO);
    const newRectInfo: RectInfo = new RectInfo();
    newRectInfo.left = horizontalMargin;
    newRectInfo.top = Math.trunc(curScreenProperty.height - this.aiBarData.windowHeight);
    newRectInfo.right = curScreenProperty.width - horizontalMargin;
    newRectInfo.bottom = curScreenProperty.height;
    if (this.aiBarViewData.aiBarHotAreaRect.right !== newRectInfo.right ||
      this.aiBarViewData.aiBarHotAreaRect.top !== newRectInfo.top ||
      this.aiBarViewData.aiBarHotAreaRect.bottom !== newRectInfo.bottom ||
      this.aiBarViewData.aiBarHotAreaRect.left !== newRectInfo.left) {
      this.aiBarViewData.aiBarHotAreaRect = newRectInfo;
      this.notifyAiBarShowStatus(lastScreenProperty, true);
    }
  }

  /**
   * 供多任务启动场景调用的接口，用于提前通知窗口侧aibar的位置
   *
   * @param screenProperty 屏幕信息
   * @param targetRotation 应用目标的旋转角度
   */
  public updateAiBarHotAreaRectForRecent(screenProperty: SCBScreenProperty, targetRotation?: number): void {
    if (targetRotation === undefined) {
      log.showInfo(`updateAiBarHotAreaRectForRecent targetRotation is undefined`);
      this.updateAiBarHotAreaRect(this.screenProperty, this.screenProperty);
      return;
    }
    let screenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(screenProperty.screenId);
    log.showInfo(`updateAiBarHotAreaRectForRecent targetRotation：${targetRotation} screenRotation:${screenRotation}`);
    let diffRotation = Math.abs(targetRotation - screenRotation);
    // 当目标角度和屏幕不一致时才需要通知窗口侧刷新
    if (diffRotation === RotationConstants.ROTATION_90 || diffRotation === RotationConstants.ROTATION_270) {
      let newScreenProperty = new SCBScreenProperty();
      newScreenProperty.copy(screenProperty);
      newScreenProperty.width = screenProperty.height;
      newScreenProperty.height = screenProperty.width;
      this.updateAiBarHotAreaRect(newScreenProperty, this.screenProperty);
    }
  }

  /**
   * 判断是否完成导航动效
   * @param capsuleWidth 胶囊宽度
   */
  public whetherEndWeakNavigationAnimation(capsuleWidth: number): void {
    if (this.aiBarViewData.weakNotifyParam.weakNotifyState !== WeakNotifyState.STATIC) {
      log.showInfo(`this weakNotifyState is not STATIC`);
      this.aiBarAnimate.endWeakNavigationAnimation(capsuleWidth);
    }
  }

  /**
   * AI横条显隐变化，或显示时尺寸变化，则通知窗口侧
   * @param lastScreenProperty 之前屏幕参数
   * @param needToAvoid 是否必须需要设置避让区 true：无论之前是否设置，现在都要重新设置 false：只有之前与现在的不同才要设置
   */
  public notifyAiBarShowStatus(lastScreenProperty: SCBScreenProperty, needToAvoid = false): void {
    const curHaveAvoid = this.aiBarViewData.isShowingAiBar && this.aiBarViewData.isNavigationBarEnable;
    if (!needToAvoid && this.haveAvoid === curHaveAvoid) {
      return;
    }
    this.haveAvoid = curHaveAvoid;
    log.showInfo('notifyAiBarShowStatus：curHaveAvoid: %{public}s, aiBarHotAreaRect: ' +
      '[left:%{public}d, right:%{public}d, top:%{public}d, bottom:%{public}d], screenId: %{public}d',
      curHaveAvoid, this.aiBarViewData.aiBarHotAreaRect.left, this.aiBarViewData.aiBarHotAreaRect.right,
      this.aiBarViewData.aiBarHotAreaRect.top, this.aiBarViewData.aiBarHotAreaRect.bottom, lastScreenProperty.screenId);
    let barRect = scbGestureManager.getAiBarRect();
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
      curHaveAvoid, this.aiBarViewData.aiBarHotAreaRect, lastScreenProperty.screenId);
    let portraitRect: RectInfo;
    let horizontalRect: RectInfo;
    if (lastScreenProperty.isScreenVertical()) {
      portraitRect = this.aiBarViewData.aiBarHotAreaRect;
      horizontalRect = this.calcAiBarHotArea(lastScreenProperty.height, lastScreenProperty.width);
    } else {
      horizontalRect = this.aiBarViewData.aiBarHotAreaRect;
      portraitRect = this.calcAiBarHotArea(lastScreenProperty.height, lastScreenProperty.width);
    }
    SCBSceneSessionManager.getInstance().notifyNextAINavigationBarRectInfo(lastScreenProperty.screenId,
      portraitRect, horizontalRect);
  }

  /**
   * 通过屏幕属性计算导航条热区
   * @param screenProperty 屏幕属性
   * @param aiBarHotAreaRect 导航条热区
   */
  public calcAiBarHotArea(screenWidth: number, screenHeight: number): RectInfo {
    const horizontalMargin = Math.trunc(screenWidth * SystemSceneConstants.AREA_REST_WIDTH / SystemSceneConstants.TWO);
    // 定义导航条区域
    const aiBarHotAreaRect: RectInfo = new RectInfo();
    aiBarHotAreaRect.left = horizontalMargin;
    aiBarHotAreaRect.top = Math.trunc(screenHeight - this.aiBarData.windowHeight);
    aiBarHotAreaRect.right = screenWidth - horizontalMargin;
    aiBarHotAreaRect.bottom = screenHeight;
    return aiBarHotAreaRect;
  }

  /**
   * 导航条返回
   *
   * @param {HiSysLongPressMisTouchType} type - 报点类型
   */
  public aiBarRetract(type: HiSysLongPressMisTouchType): void {
    log.showInfo('SCBAiNavBar longPress Retract');
    this.aiBarData.isAiBarRetract = false;
    HiSysEventUtil.reportLongPressMisTouch(type);
    this.aiBarViewData.weakNotifyParam.weakNotifyState = WeakNotifyState.STATIC;
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LIGHT,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    SCBAiBarProxyManager.getInstance().destroy();
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
  public aiBarOnTouchEvent(event: TouchEvent, downEvent: TouchEvent | null) {
    this.whetherEndWeakNavigationAnimation(this.aiBarViewData.capsuleWidth);
    const isNewEffectsDestroy: boolean = this.isNewEffectsDestroy();
    if (!this.aiBarData.isAiBarRetract && !isNewEffectsDestroy) {
      return;
    }
    let absDisplay = 0;
    if (downEvent) {
      let absDisplayY = Math.abs(downEvent?.changedTouches[0].displayY - event.changedTouches[0].displayY);
      let absDisplayX = Math.abs(downEvent?.changedTouches[0].displayX - event.changedTouches[0].displayX);
      absDisplay = absDisplayX ** 2 + absDisplayY ** 2;
    }
    if (isNewEffectsDestroy) {
      log.showInfo('out of AIBar long press distance by newEffects');
      this.clearTimeout();
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LIGHT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    } else {
      log.showInfo('out of AIBar long press distance');
      this.aiBarRetract(HiSysLongPressMisTouchType.MOVE);
      this.aiBarAnimate.onActionEndAndCancelAnimal();
      this.clearTimeout();
    }
  }

  public isNewEffectsDestroy(): boolean {
    return AiBarVisualEffectManager.getInstance().isFullEffect();
  }

  /**
   * 计算AI导航条的宽度
   * @param widthVp 像素宽度
   * @returns AI导航条的宽度
   */
  public calculateAiBarWidth(widthVp: number) {
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
    if (!DeviceHelper.isPad() || this.aiBarViewData.scenePanelState !== ScenePanelState.FULLSCENE) {
      return false;
    }
    for (let appKeyName of SCBAiBarConstants.MIS_TOUCH_APP_LIST) {
      let sessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance()
        .getContainerSessionList().getActiveSessionList();
      if (this.checkKeyNameIsInCurPanel(appKeyName, sessionList) && !this.aiBarViewData.isShowingAiBar) {
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
    if (this.aiBarViewData.isInMidScene != isInMidScene) {
      log.showInfo(`isInMidScene: ${isInMidScene}`);
      this.aiBarViewData.isInMidScene = isInMidScene;
    }
  }

  /**
   * aiBarView组件创建需要执行的内容
   * @param persistentId
   * @param viewController
   */
  public aiBarViewAppear(persistentId: number, viewController: BaseViewController,
    sendTouchEventController: SendTouchEventController): void {
    this.aiBarData.aiBarSettingsDataMgr.registerCallback(SwitchType.CHANGE_CLICK_BACK_STATUS,
      (clickBackStatus: boolean): void => {
        this.aiBarViewData.clickBackStatus = clickBackStatus;
      }
    );
    this.notifyWallpaperDarkness();
    // aiBarView里面的appear代码迁移
    this.sendTouchEventController = sendTouchEventController;
    this.registerAiBarProxyCallback(persistentId, viewController);
    this.aiBarData.viewController = viewController;
    this.registerDesktopModeCallback();
    SCBSceneSessionManager.getInstance().registerNavigationBarCallback(this.screenProperty.screenId,
      (navigationBarEnable: boolean, screenId: number = INVALID_SCREEN_ID) => {
        if (this.aiBarViewData.isNavigationBarEnable !== navigationBarEnable) {
          log.showInfo(`${TAG} NavigationBarCallback ${navigationBarEnable}`);
        }
        // 仅处理本屏幕窗口的显隐通知
        if (screenId !== INVALID_SCREEN_ID && screenId != this.screenProperty.screenId &&
          this.aiBarData.foldDisplayMode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_COORDINATION) {
          log.showInfo('screenId is different');
          return;
        }
        FloatingNavigationManager.getInstance().checkShowFloatingNavigation(navigationBarEnable);
        // 如果存在计时器置导航条显示为 FALSE, 则由计时器置 FALSE, 短时间内重复置FALSE可能导致导航条位置跳变问题
        if (navigationBarEnable || !this.aiBarData.isTimerRunning) {
          if (!navigationBarEnable) {
            // 隐藏导航条时统一延迟2s
            clearTimeout(this.aiBarData.immerseHideAiBarTimer);
            this.aiBarData.isAppHide = true;
            this.aiBarData.immerseHideAiBarTimer = setTimeout(() => {
              this.aiBarViewData.isTempShowAiBar = navigationBarEnable;
            }, SystemSceneConstants.AI_BAR_DISPLAY_TIME);
          } else {
            clearTimeout(this.aiBarData.immerseHideAiBarTimer);
            this.aiBarViewData.isTempShowAiBar = navigationBarEnable;
          }
        }
        this.aiBarViewData.isNavigationBarEnable = navigationBarEnable;
        this.notifyAiBarShowStatus(this.screenProperty);
      })

    SCBSceneSessionManager.getInstance().registerMidSceneStateChangeCallBack(() => {
      log.showInfo(`${TAG} MidSceneStateChangeCallBack`);
      this.checkIsInMidScene();
    })

    SCBSceneSessionManager.getInstance().registerWindowModeChangeCallback((isFullOrSplit: boolean) => {
      log.showInfo(`${TAG} WindowModeChangeCallback`);
      this.aiBarViewData.isInWindowModeFullScreen = isFullOrSplit;
      FloatingNavigationManager.getInstance().setIsInMultiWindowMode(isFullOrSplit &&
        this.aiBarViewData.isInMultiWindowMode);
    }, this.screenProperty.screenId)

    FloatingNavigationManager.getInstance().registersSwitchChangeCallBack((switchStatus: boolean) => {
      log.showInfo(`${TAG} FloatingNavSwitchChangeCallBack`);
      this.aiBarViewData.isFloatingNavShow = switchStatus;
      this.aiBarViewData.isToastShow = false;
    })


    this.registerThermalLevel();

    scbGestureManager.registerAiBarChangeAnim((type: number) => {
      log.showInfo(`change type:${type}`);
      this.aiBarData.currentGestureAIBarType = type;
      this.aiBarAnimate.aiBarChangeAnim(type);
    });

    scbGestureManager.registerGestureEnableStateChange((isEnable: boolean, caller: string) => {
      FloatingNavigationManager.getInstance().setIsGestureEnable(isEnable, caller);
    });

    WallpaperColorManager.getInstance().registerDegreeChangeCallBack((degree: number) => {
      log.showInfo(`degree change: ${degree}`);
      this.setAiBarAreaDegree();
    });

    this.registerPowerStatusListener();
    this.initGameEventListener();
    this.aiBarData.aiBarAllowDropType = this.aiBarData.allDropType();
    this.aiBarData.aiBarSettingsDataMgr.initData();
    this.aiBarData.aiBarSettingsDataMgr.registerKeyObserver();

    NavBarHideAndShowManager.getInstance().registerNavBarHideAndShowCallback(TAG,
      (navBarIsShow: boolean) => {
        this.aiBarViewData.navBarIsShow = navBarIsShow;
      });
    this.createAiBarEndAnimate(persistentId, viewController);
    EvtBus.on(ScreenLockThemeChangeEvent, this.notifyWallpaperDarkness);
    this.aiBarData.desktopContext?.eventHub.on('AiBarUseAppColor', (aiBarUseAppColor: boolean) => {
      log.showInfo(`aiBarUseAppColor is:${aiBarUseAppColor}`);
      this.aiBarViewData.aiBarUseAppColor = aiBarUseAppColor;
    });
    // 用户切换监听
    UserSwitchService.getInstance().registerObserver(this._userSwitchListener);
    AiBarVisualEffectManager.getInstance().init();
    this.upgradeVassistant();
    this.aiBarData.aiBarSettingsDataMgr.checkPrivateThreeButtonDataMoving();
    CloneStatusCallbackManager.getInstance().registerCloneStatusMonitor();
  }

  private upgradeVassistant(): void {
    this.bundleChangeEvent.subscriber(commonEventManager.Support.COMMON_EVENT_PACKAGE_CHANGED,
      (commonEvent?: commonEventManager.CommonEventData) => {
        if (commonEvent?.bundleName === VoiceConstant.BUNDLE_NAME) {
          AiBarVisualEffectManager.getInstance().upgradeVass();
        }
      });
  }

  /**
   * 通知导航条是否需要压黑
   */
  private notifyWallpaperDarkness = (): void => {
    AIBarData.getInstance().notifyWallpaperDarkeness(this.getClockNeedToDarken() ?? false,
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
    scbGestureManager.aiBarChange(AIBarConstants.GESTURE_AI_BAR_TYPE_SCREEN_LOCK);
  }
  private powerStatusSleep = () => {
    log.showInfo('subscribe BEGIN_SLEEP');
    scbGestureManager.aiBarChange(AIBarConstants.GESTURE_AI_BAR_TYPE_AOD);
  }

  private registerThermalLevel() {
    try {
      thermal.registerThermalLevelCallback((level: thermal.ThermalLevel) => {
        log.showInfo(`Thermal level ${level}`);
        if (this.aiBarViewData.thermalLevel !== level) {
          this.aiBarViewData.thermalLevel = level;
        }
      });
      log.showInfo('register thermal level callback success.');
    } catch (err) {
      log.showError(`register thermal level callback failed, error: ${err}`);
    }
  }

  private createAiBarEndAnimate(persistentId: number, viewController: BaseViewController): void {
    animateExNew('MSG_AIBAR_END_ANIMATION',
      { curve: curves.springMotion(0.4, 1.11) },
      () => {
        this.aiBarAnimate.changeToDefaultAiBar();
      },
      () => {
        this.navbarWindowManager.setWindowHeight(this.aiBarData.windowHeight).update();
      }
    );
  }

  /**
   * aiBarView组件销毁需要执行的内容
   */
  public aiBarViewDisAppear(): void {
    // aiBarView里面的disappear代码迁移
    this.unRegisterAiBarProxyCallback();
    DesktopModeManager.getInstance().unRegisterModeChangeCallback(TAG);
    SCBSceneSessionManager.getInstance().unRegisterNavigationBarCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unRegisterMidSceneStateChangeCallBack();
    FloatingNavigationManager.getInstance().unregistersSwitchChangeCallBack();
    SCBSceneSessionManager.getInstance().unregisterWindowModeChangeCallback(this.screenProperty.screenId);
    scbGestureManager.unRegisterAiBarChangeAnim();
    scbGestureManager.unRegisterGestureEnableStateChange();
    WallpaperColorManager.getInstance().unRegisterDegreeChangeCallBack();
    this.aiBarData.aiBarSettingsDataMgr.unregisterKeyObserver();
    NavBarHideAndShowManager.getInstance().unRegisterNavBarHideAndShowCallback(TAG);
    this.unRegisterThermalLevel();
    this.unRegisterPowerStatusListener();
    EvtBus.off(ScreenLockThemeChangeEvent, this.notifyWallpaperDarkness);
    UserSwitchService.getInstance().unRegisterObserver(this._userSwitchListener);
    this.aiBarData.aiBarSettingsDataMgr.unRegisterCallback(SwitchType.CHANGE_CLICK_BACK_STATUS);
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
  public isAiBarTranslate(): boolean {
    return this.aiBarViewData.barTranslateParam.barTranslateY !== 0 ||
      this.aiBarViewData.barTranslateParam.barTranslateX !== 0;
  }

  private async setAiBarAreaDegree(): Promise<void> {
    let degree = await this.getAiBarAreaPaperDegree();
    FloatingNavigationManager.getInstance().setWallpaperDegree(degree);
  }

  private async getAiBarAreaPaperDegree(): Promise<number> {
    try {
      // 获取壁纸
      let desktopWallpaperImg = await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.DESKTOP, TAG);
      PixelMapUtil.addName(desktopWallpaperImg, 'WallPaperMgr_getAiBarAreaPaperDegree');
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
        return SCBAiBarConstants.EXTREMELY_FLOWERY_PICTURE;
      }
      // 调整成算式
      const xEnd: number = wallpaperWidth
      const yStart: number = wallpaperHeight - vp2px(SystemSceneConstants.DEFAULT_HEIGHT);
      const yEnd: number = wallpaperHeight;
      let resVal = SCBAiBarConstants.EXTREMELY_FLOWERY_PICTURE;
      let colorPicker = await effectKit.createColorPicker(desktopWallpaperImg,
        [0, yStart / wallpaperHeight, xEnd / wallpaperWidth, yEnd / wallpaperHeight]);
      resVal = colorPicker.discriminatePitureLightDegree();
      // MemoryUtils.removeNapiWrap(colorPicker, false);
      log.showInfo(`getWallpaper degree :  ${resVal}`);
      return resVal;
    } catch (error) {
      log.showError('getAiBarAreaPaperDegree is fail');
      return SCBAiBarConstants.EXTREMELY_FLOWERY_PICTURE;
    }
  }
}
