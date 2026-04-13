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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, EventManager, EvtBus, WallpaperManager, } from '@ohos/frameworkwrapper';
import { CoreEventType, StateType as FsmStateType } from '@ohos/frameworkwrapper/Index';
import {
  AnimationInfo,
  InteractiveEvent,
  WallPaperAnimationParam,
  WallpaperProxy,
  AodElemPosition,
  MainPageStateEvent,
  themeWallpaperAniMgr
} from '@ohos/themeservice';
import { ThemeActivationEvent } from '@ohos/frameworkwrapper';
import { EventEmitter, TsEvent, TsEventId } from '@ohos/themeservicekit/Index';
import { ThemeStyleManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { dtWallpaperStateMgr } from '../wallpaper/model/DesktopWallpaperModel';
import { curves } from '@kit.ArkUI';
import commonEventManager from '@ohos.commonEventManager';
import base from '@ohos.base';
import { BusinessError, power, systemDateTime } from '@kit.BasicServicesKit';
import { TsActivationStrategy } from './TsActivationStrategy';
import { TsProxyHandler } from './handler/TsProxyHandler';
import { TsAnimationDelegate } from './delegate/TsAnimationDelegate';
import { ScbState, ThemeConstant, ThemeType, ThemeFreezeReason } from './ThemeConstant';
import { TsAnimationHandler } from './handler/TsAnimationHandler';
import fs from '@ohos.file.fs';
import { notificationManager } from '@kit.NotificationKit';
import { MultiProxyHandler } from './handler/MultiProxyHandler';
import { DesktopModeEnum, DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  OnStateChangeListener,
  StateType } from '@ohos/systemuicommon';
import {
  immersiveKgMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import {
  NotificationEvent,
  NotificationEventForBridge } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { NotificationBaseForBridge } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { TsSceneBoardStateListenerManager } from './TsSceneBoardStateListenerManager';

const TAG: string = 'ThemeServiceHelper';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const WALLPAPER_SCALE_AOD: number = 1.05;
const WALLPAPER_SCALE_LOCK: number = 1.1;
const WALLPAPER_SCALE_HOME: number = 1.0;

const WALLPAPER_SCALE_MAP: Map<ScbState, number> = new Map([
  [ScbState.LOCKSCREEN, WALLPAPER_SCALE_LOCK],
  [ScbState.DESKTOP, WALLPAPER_SCALE_HOME],
  [ScbState.SLEEP, WALLPAPER_SCALE_AOD],
]);

const FREEZE_STATES: Set<ScbState> = new Set([ScbState.PROXIMITY_SCREEN_ON, ScbState.PROXIMITY_SCREEN_OFF,
  ScbState.DROPDOWN_PANEL_DOWN, ScbState.DROPDOWN_PANEL_UP,
  ScbState.GLOBAL_SEARCH_PANEL_DOWN, ScbState.GLOBAL_SEARCH_PANEL_UP]);

const SPRING_VELOCITY: number = 0;
const SPRING_MASS: number = 1;
const SPRING_STIFFNESS: number = 228;
const SPRING_DAMPING: number = 30;

const AVAILABLE_CLICK_TYPE: string[] = ['wallpaper', 'theme', 'aodStyle', 'personalize', 'desktopEdit'];

// Spring curve definition used for scaling animation
const SPRING_CURVE: ICurve = curves.interpolatingSpring(SPRING_VELOCITY, SPRING_MASS, SPRING_STIFFNESS, SPRING_DAMPING);

const GESTURE_ERROR: number = 0;
const GESTURE_SUCCESS: number = 1;

/**
 * 主题服务帮助类
 *
 * @since 2024-04-29
 */
export class ThemeServiceHelper {
  private static serviceInstance: ThemeServiceHelper | undefined = undefined;
  private scbSwitchAnimation?: AnimateParam;
  private disableUiFirst: Function | undefined = undefined;
  private eventMgr: EventManager = EvtBus.createEventManager();
  // 实况通知场景 TAXI: 出行打车，DELIVERY: 外卖, PICK_UP: 取餐, WORKOUT: 运动锻炼
  private readonly liveEventSet: Set<string> = new Set();
  private subscribeLiveViewStatus: boolean = false;
  private baseImageCallback: Function | undefined = undefined;
  private uiContext: UIContext | undefined = undefined;
  private activeThemePath: string = this.initActiveThemePath();
  // 桌面应用状态 true: 桌面打开了应用，false: 桌面无应用
  private isAppOpenedOnDesktop: boolean = false;

  /**
   * 实况通知数据新增、更新、删除回调
   */
  private onLiveViewEntryEvent = (event?: NotificationEventForBridge): void => {
    if (!event) {
      LOG.warn('on live view entry event is undefined');
      return;
    }
    LOG.info(`event Type ${event.eventType}`);
    for (let item of event.notificationList) {
      if (!this.checkIsNeedNotification(item)) {
        continue;
      }
      if (event.eventType === NotificationEvent.EVENT_TYPE_ADD ||
        event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
        themeWallpaperAniMgr.sendLiveViewEvent(event.eventType, item?.hashCode, item.liveViewData?.event,
          item.liveViewData?.status);
      }
    }
  };

  /**
   * 监听桌面应用打开状态
   */
  private desktopAppStateListener = (oldState: FsmStateType, newState: FsmStateType, event: CoreEventType): void => {
    LOG.info(`listen desktop app state change to ${event}`);
    let desktopAppState: boolean = false;
    if (event === CoreEventType.OPEN_APP) {
      desktopAppState = true;
    } else if (event === CoreEventType.CLOSE_APP) {
      desktopAppState = false;
    } else {
      return;
    }
    if (this.isAppOpenedOnDesktop !== desktopAppState) {
      this.isAppOpenedOnDesktop = desktopAppState;
      this.updateDesktopAppState();
    }
  }

  /**
   * 发送桌面应用打开状态, 即桌面是否打开了应用，一般在进入退出应用或者壁纸启动完成时执行
   *
   */
  public updateDesktopAppState(): void {
    this.proxyHandler?.sendDesktopAppState(this.isAppOpenedOnDesktop);
  }

  /**
   * 判断输入的事件，是否为需要通知给主题引擎的事件
   *
   * @param {NotificationBaseForBridge} notification - 包含请求内容和额外信息的数据对象
   * @return {boolean} - 如果需要发送通知则返回 true，否则返回 false
   */
  private checkIsNeedNotification(notification: NotificationBaseForBridge): boolean {
    let event: string = notification.liveViewData?.event ?? '';
    return notification.slotType === notificationManager.SlotType.LIVE_VIEW && this.liveEventSet.has(event);
  }

  /**
   * 检查当前主题是否支持实况通知
   *
   * @return {boolean} 如果当前支持实况通知，返回true，否则返回false
   */
  public checkThemeSupportLiveView(): boolean {
    let isLiveViewTheme: boolean = false;
    try {
      let descriptionPath: string = '';
        descriptionPath = this.getActiveThemePath() + ThemeConstant.DESCRIPTION_CUTE_PET_PATH;
      const descriptionString: string = fs.readTextSync(descriptionPath);
      let description: object = JSON.parse(descriptionString);
      const supportModes: string[] = description['supportedModes'] as string[];
      isLiveViewTheme = supportModes.includes('ONGOING_NOTICE');
    } catch (err) {
      LOG.error(`checkThemeSupportLiveView error ${err?.message}`);
    }
    return isLiveViewTheme;
  }

  /**
   * 订阅实况通知事件监听
   */
  public subscribeLiveViewEvent(): void {
    LOG.info('subscribe live view event');
    this.eventMgr.on(NotificationEventForBridge, this.onLiveViewEntryEvent);
    this.subscribeLiveViewStatus = true;
  }

  /**
   * 取消订阅实况通知事件监听
   */
  public unsubscribeLiveViewEvent(): void {
    this.eventMgr.offAll();
    this.subscribeLiveViewStatus = false;
    LOG.info('unsubscribe live view event');
  }

  /**
   * 返回当前live view事件的订阅状态
   *
   * @return {boolean} - 如果已订阅则返回 true，否则返回 false
   */
  public isSubscribeLiveView(): boolean {
    return this.subscribeLiveViewStatus;
  }

  /**
   * 主题引擎通信代理实现
   */
  private wallpaperProxy: WallpaperProxy = {
    sendCmd: (param: WallPaperAnimationParam): void => this.updateScbState(
      param.curState as number, param.tarState as number, param.onFinish, param.isPlayingAnimation, param.isSafeMode),
    sendInteractiveEvent: (event: InteractiveEvent): void => this.handleInteractiveEvent(
      event.interactiveType as number, event.x, event.y),
    sendHomeInteractiveEvent: (event: InteractiveEvent): void => this.handleHomeInteractiveEvent(
      event.interactiveType as number, event.x, event.y),
    sendMainPageStateChangeEvent: (event: MainPageStateEvent):
      void => this.handleMainPageStateChangeEvent(event.mainPageStateType),
    sendAnimation: (info: AnimationInfo): void => this.handleAnimationEvent(
      info.animationType as number),
    aodUpdate: (): void => this.onAodUpdate(),
    enableGesture: (enable: boolean, gestureMotionCallback: (clockCollapse: boolean) => void): number =>
      this.handleGestureMotion(enable, gestureMotionCallback),
    syncAodPosition: (aodPosition: AodElemPosition): void => this.syncAodPosition(aodPosition),
    sendUpdateThemeSceneEvent: (event: string, completeCallBackFunc: () => void): void =>
    this.updateThemeScene(event, completeCallBackFunc),
    sendLiveViewEvent: (eventType: number, hashCode: string, event: string, status: number): void =>
    this.liveViewEventChange(eventType, hashCode, event, status),
    updateClockBaseImage: (callBack: () => void): void => this.updateClockBaseImage(callBack),
    freezeThemeEngine: (freezeReason?: ThemeFreezeReason): void => this.freezeThemeEngine(freezeReason),
    unfreezeThemeEngine: (freezeReason?: ThemeFreezeReason): void => this.unfreezeThemeEngine(freezeReason),
  }

  /**
   * 主题前后台监听
   *
   * @param sceneState 0 前台 else 后台
   */
  public onWindowSceneStateChange(sceneState: number): void {
    this.proxyHandler?.sendWindowSceneState(sceneState);
  }

  public setUiFirstCallback(callback: Function | undefined): void {
    this.disableUiFirst = callback;
    LOG.info(TAG, 'setUiFirstCallback success.');
  }

  private scaleAnimation: AnimateParam = {
    curve: SPRING_CURVE,
    onFinish: () => {
      if (!this.isUseStaticWallpaper()) {
        return;
      }
      this.onAnimationFinish();
    },
  };

  private immediateAnimation: AnimateParam = {
    duration: 0,
    tempo: 0,
    iterations: 0,
  }
  private themeType: ThemeType = ThemeType.DEFAULT;
  private outerThemeType: ThemeType = ThemeType.DEFAULT;
  private proxyHandler?: TsProxyHandler;
  private activationStrategy: TsActivationStrategy = new TsActivationStrategy();
  private animationHandler?: TsAnimationHandler;
  private scbState: ScbState = ScbState.LOCKSCREEN;
  private animationDelegate?: TsAnimationDelegate;
  private subscriber?: commonEventManager.CommonEventSubscriber;
  private readonly subscriberInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: ['editToolClickType'],
    publisherPermission: 'ohos.permission.ACTIVATE_THEME_PACKAGE',
    publisherBundleName: 'com.ohos.sceneboard',
  };
  public isEnableGestureMotionCallback: boolean = false;
  private gestureMotionCallback?: (clockCollapse: boolean) => void;
  private themeSceneSwitchCallback?: () => void;

  private constructor() {
    this.activationStrategy.updateActiveThemePath(this.getActiveThemePath());
    this.themeType = this.activationStrategy.getActivationType();
    AppStorage.setOrCreate<boolean>('engineThemeStatic', this.themeType === ThemeType.STATIC);
    // 监听TS主题使能事件
    EventEmitter.on(TsEventId.EVENT_THEME_ACTIVATE, (event: TsEvent) => this.notifyThemeActivation(event));

    // 监听锁屏界面编辑模式进入壁纸、主题、熄屏显示选择界面的事件
    this.initSubscriber();

    // 注册应急模式和热安全模式监听
    DesktopModeManager.getInstance().registerModeChangeCallback(TAG, this.modeChangeCallBack);

    // 注册桌面应用打开状态监听
    TsSceneBoardStateListenerManager.getInstance().registerDesktopFsmListener(this.desktopAppStateListener, TAG);
  }

  private modeChangeCallBack = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum): void => {
    LOG.info(TAG, `modeChangeCallBack preDesktopMode: ${preDesktopMode}, targetDesktopMode: ${targetDesktopMode}`);
    this.proxyHandler?.sendDesktopModeUpdate(preDesktopMode, targetDesktopMode);
  };

  private initSubscriber(): void {
    commonEventManager.createSubscriber(this.subscriberInfo).then((res) => {
      this.subscriber = res;
      if (!this.subscriber) {
        LOG.error(TAG, `Failed to subscribe to freeze ThemeEngine, subscriber is undefined.`);
        return;
      }
      try {
        commonEventManager.subscribe(this.subscriber, (err, data) => this.handleSubscriberCallback(err, data));
        LOG.info(TAG, 'Successfully subscribe themeEngine.');
      } catch (error) {
        LOG.error(TAG, `Subscribe themeEngine error, message = ${error?.message}; code = ${error?.code}.`)
      }
    }).catch((error: BusinessError) => {
      LOG.error(TAG, `commonEventManager.createSubscriber error: ${error?.code}`);
    });
    // 添加主题实况通知监听
    this.updateLiveViewEventSubscriber();
  }

  /**
   * 更新主题实况通知监听状态
   */
  private updateLiveViewEventSubscriber(): void {
    if (!this.checkThemeSupportLiveView()) {
      this.unsubscribeLiveViewEvent();
    } else if (!this.isSubscribeLiveView()) {
      this.subscribeLiveViewEvent();
    } else {
      LOG.info(TAG, 'no need to updateLiveViewEventSubscriber');
    }
  }

  private handleSubscriberCallback(err: base.BusinessError, data: commonEventManager.CommonEventData): void {
    if (err) {
      LOG.error(TAG, `Failed to receive commonEvent ${data?.event}. Code is ${err.code}`);
      return;
    }
    if (!data) {
      LOG.error(TAG, 'No data received in subscriber callback.');
      return;
    }
    if (!this.subscriberInfo.events.includes(data.event)) {
      LOG.error(TAG, `Event ${data.event} is invalid.`);
      return;
    }
    if (!data.parameters) {
      LOG.error(TAG, 'No parameters received.');
      return;
    }
    let clickTypeValue: string = data.parameters['clickType'];
    if (!AVAILABLE_CLICK_TYPE.includes(clickTypeValue)) {
      LOG.error(TAG, `Invalid clickType ${clickTypeValue}.`);
      return;
    }
    let stageValue: string = data.parameters['stage'];
    LOG.info(TAG, `Handle editToolClickType event, target stage = ${stageValue}.`);
    if (stageValue === 'enter') {
      this.freezeThemeEngine(ThemeFreezeReason.ENTER_EDIT_TOOL);
    } else if (stageValue === 'exit') {
      this.unfreezeThemeEngine(ThemeFreezeReason.ENTER_EDIT_TOOL);
    } else {
      LOG.debug(TAG, 'Invalid stageValue.');
    }
  }

  public static getInstance(): ThemeServiceHelper {
    if (!ThemeServiceHelper.serviceInstance) {
      ThemeServiceHelper.serviceInstance = new ThemeServiceHelper();
    }
    return ThemeServiceHelper.serviceInstance;
  }

  /**
   * 获取当前主题是加载为静态主题还是动态主题。
   *
   * @returns True:静态主题, false：其他动态主题
   */
  public isUseStaticWallpaper(): boolean {
    if (this.isOuterEngineService()) {
      return this.outerThemeType === ThemeType.STATIC;
    }
    return this.themeType === ThemeType.STATIC;
  }

  /**
   * 获取当前proxy对应的主题时加载为静态主题还是动态主题
   *
   * @param proxyId: InnerProxy为内屏，OuterProxy为外屏
   * @returns True: 静态主题，false: 其他动态主题
   */
  public isStaticWallpaperMultiProxy(proxyId: string): boolean {
    if (proxyId === 'InnerProxy') {
      return this.themeType === ThemeType.STATIC;
    } else {
      return this.outerThemeType === ThemeType.STATIC;
    }
  }

  /**
   * 使用 SCB 提供的回调通知动画完成
   * 注意：仅在合适的场景中调用一次，因为多次调用会导致 AOD 无法启动或屏幕故障。
   *
   * @param taskId 动效结束所对应的动效任务ID，针对静态主题改为可选
   */
  public onAnimationFinish(taskId?: number): void {
    LOG.info(`onAnimationFinish ${taskId}`);
    let animationHandler: TsAnimationHandler | undefined = this.getAnimationHandler();
    if (animationHandler) {
      animationHandler.onAnimationFinish(taskId);
      this.lockAnimationFinishSend();
    }
  }

  /**
   * 通过 DesktopWallpaper 的 WallpaperProxy 接收状态更新，包括 SCB 状态和启动 AOD 的相应回调。 需要 prev 和 cur SCB 状态来确定动态主题的动画。
   *
   * @param srcState 以前的 SCB 状态
   * @param dstState 目标/当前 SCB 状态
   * @param finishCallback AOD 回调，将在 lock->aod 动画末尾调用。
   * @param isPlayAnimation 是否播放动画
   * @param isSafeMode Used to identify is safe mode
   */
  public updateScbState(srcState: number, dstState: number, finishCallback: (() => void) | undefined,
    isPlayAnimation: boolean = true, isSafeMode: boolean = false): void {
    LOG.info(`Updating SCB state from ${srcState} to ${dstState}`);
    if (this.isFreezeStatus(srcState, dstState)) {
      this.doFreeze(srcState, dstState);
      return;
    }
    if (AppStorage.get('screenlockFreezeEngine') === true &&
      srcState === ScbState.SLEEP && dstState === ScbState.UNKNOWN) {
      LOG.info(`Proximity screen on to proximity screen off but on phone call scenario, reset screenlockFreezeEngine`);
      AppStorage.setOrCreate<boolean>('screenlockFreezeEngine', false);
    }
    if (!this.isUseStaticWallpaper() || dstState === ScbState.SLEEP) {
      this.scbSwitchAnimation = this.immediateAnimation;
    } else {
      this.scbSwitchAnimation = this.scaleAnimation;
    }
    if (this.isUseStaticWallpaper()) {
      if (this.uiContext) {
        this.uiContext.animateTo(this.scbSwitchAnimation, () => {
          this.refreshWallpaperScale(dstState as ScbState);
        });
      } else {
        LOG.error(TAG, 'uiContext not set.');
      }
    } else {
      // Forcibly set this parameter to 1.0 when the screen is locked in the app
      WallpaperManager.getInstance().wallpaperData.wallpaperScale = 1.0;
    }
    this.onDesktopUpdate(srcState, dstState, finishCallback, isPlayAnimation, isSafeMode);
  }

  /**
   * 响应TS发送的主题使能事件
   * @param event
   * @returns
   */
  private async notifyThemeActivation(event: TsEvent): Promise<void> {
    LOG.info(`notifyThemeActivationt , target =  ${event.target}`);

    if (dtWallpaperStateMgr.getDtWallpaperState().isShowDefaultsWallpaper() && this.isUseEngineWallpaper()) {
      LOG.warn('Attempt to recover ThemeEngine from previous error.');
      dtWallpaperStateMgr.setDesktopWallpaperMode(true);
    }
    // 更新当前使能的主题路径
    this.activeThemePath = event.activeThemePath;
    this.activationStrategy.updateActiveThemePath(event.activeThemePath);
    this.updateLiveViewEventSubscriber();
    // 获取当前主题类型
    this.themeType = this.activationStrategy.getActivationType();
    LOG.info(`notifyThemeActivationt , themeType = ${this.themeType}, outerThemeType = ${this.outerThemeType}}`);
    AppStorage.setOrCreate<boolean>('engineThemeStatic', this.themeType === ThemeType.STATIC);
    // 使用EventBus发送事件，通知AOD、锁屏、桌面等接收主题使能事件
    const themeActivationEvent: ThemeActivationEvent = {
      target: event.target,
      themeType: this.themeType,
      themeOwnership: event.themeOwnership,
      activeThemePath: event.activeThemePath,
    };
    EvtBus.post(ThemeActivationEvent, themeActivationEvent);
  }

  /**
   * 获取主题引擎通信代理实例
   *
   * @returns 主题引擎通信代理实例
   */
  public getWallpaperProxy(): WallpaperProxy {
    LOG.info(`getWallpaperProxy`);
    return this.wallpaperProxy;
  }

  /**
   * Provide the animation instance on scb switch, a scaling animation
   * Undefined will be provided if target state is SLEEP, to avoid unnecessary animation run
   *
   * @returns Undefined if target state is sleep, otherwise the scale animation with spring curve.
   */
  public getScbSwitchAnimation(): AnimateParam | undefined {
    LOG.info(`getScbSwitchAnimation`);
    return this.scbSwitchAnimation;
  }

  /**
   * Wallpaper scale following such principles
   *  1. If using static wallpaper, lock 110%, AOD 105%
   *  2. If using dynamic wallpaper, 100% across all scenarios
   *  3. If using dynamic wallpaper and wallpaper is exposed, forcibly set 100%
   *
   * @param scbState Incoming SceneBoard state
   */
  private refreshWallpaperScale(scbState: ScbState): void {
    if (!WALLPAPER_SCALE_MAP.has(scbState)) {
      LOG.warn(TAG, `State ${scbState} should not affect wallpaper scale.`);
      return;
    }
    LOG.info(`refreshWallpaperScale ` + scbState);
    WallpaperManager.getInstance().wallpaperData.wallpaperScale =
      this.isUseStaticWallpaper() ? (WALLPAPER_SCALE_MAP.get(scbState) ?? 1.0) : 1.0;
  }

  /**
   * refresh wallpaper scale only for multi proxy handler to extinguish inner
   * and outer proxy to make sure refreshing wallpaper scale to the correct
   * corresponding proxy.
   *
   * @param scbState Incoming SceneBoard state
   * @param proxyId current proxy --> InnerProxy内屏, OuterProxy外屏
   */
  public refreshWallpaperScaleMultiProxy(scbState: ScbState, proxyId: string): void {
    if (!WALLPAPER_SCALE_MAP.has(scbState)) {
      LOG.warn(TAG, `State ${scbState} should not affect wallpaper scale in ${proxyId}.`);
      return;
    }
    LOG.info(`refreshWallpaperScale ${scbState} in proxy ${proxyId}`);
    WallpaperManager.getInstance().wallpaperData.wallpaperScale =
      this.isStaticWallpaperMultiProxy(proxyId) ? (WALLPAPER_SCALE_MAP.get(scbState) ?? 1.0) : 1.0;
  }

  /**
   * Get current active theme path
   *
   * @returns Current active theme path
   */
  public getActiveThemePath(): string {
    return this.activeThemePath;
  }

  /**
   * Init current active theme path, which may be A or B
   *
   * @returns Current active theme path
   */
  private initActiveThemePath(): string {
    LOG.info(TAG, 'initActiveThemePath.');
    if (this.isFileExists(ThemeConstant.THEME_A_FLAG)) {
      return ThemeConstant.THEME_A_PATH;
    } else if (this.isFileExists(ThemeConstant.THEME_B_FLAG)) {
      return ThemeConstant.THEME_B_PATH;
    } else {
      return '';
    }
  }

  /**
   * Get current outer screen active theme path, which may be A or B
   *
   * @returns Current active theme path
   */
  public getOuterScreenActiveThemePath(): string {
    let path: string = this.getActiveThemePath();
    if ( path ) {
      path += '/sub_screen';
    }
    return path;
  }

  /**
   * Get current theme id from description.json
   *
   * @returns Current theme id
   */
  public getThemeId(path: string): string {
    const themeDesc: string = `${path}/description.json`;
    let id: string = 'default';
    try {
      let themeInfo: object = JSON.parse(fs.readTextSync(themeDesc));
      let searchResult: string = themeInfo['id'];
      LOG.info(`Search result ${searchResult} during searching for 'id' key.`);
      id = searchResult;
    } catch (err) {
      LOG.error(`Error on parsing theme desc JSON file, ${err.code} - ${err.message}`);
    }
    return id;
  }

  /**
   * Get current theme type from description.json
   *
   * @returns Current theme type
   */
  public getThemeType(path: string): string {
    const manifestFile: string = `${path}/manifest.json`;
    let type: string = 'Unknown';
    try {
      let manifestInfo: object = JSON.parse(fs.readTextSync(manifestFile));
      let searchResult: string = manifestInfo['type'];
      LOG.info(`Search result ${searchResult} during searching for 'type' key.`);
      type = searchResult;
    } catch (err) {
      LOG.error(`Error on parsing manifest desc JSON file, ${err.code} - ${err.message}`);
    }
    return type;
  }

  /**
   * Get if current theme is personalized theme
   *
   * @returns true if personalized theme else false
   */
  private isPersonalizedTheme(path: string): boolean {
    const themeDesc: string = `${path}/description.json`;
    try {
      let description: object = JSON.parse(fs.readTextSync(themeDesc));
      let searchResult: string = 'personalize';
      return Object.keys(description).includes(searchResult) && description[searchResult] === 'true'
    } catch (err) {
      LOG.error(`Error on parsing theme description JSON file, ${err?.code} - ${err?.message}`);
    }
    return false;
  }

  /**
   * 通过theme id 判断是否是套系化主题
   */

  public isWholeSetTheme() : boolean {
    return false;
  }

  /**
   * Get current active theme is online theme or not
   *
   * @returns True: Online Theme; False: Local Theme
   */
  public isOnlineTheme(): boolean {
    let isOnlineTheme: boolean = false;
    const themeDesc: string = this.getActiveThemePath() + `/description.json`;
    let origin: string = '';
    try {
      let themeInfo: object = JSON.parse(fs.readTextSync(themeDesc));
      let searchResult: string = themeInfo['origin'];
      LOG.info(`Search result ${searchResult} during searching for 'type' key.`);
      origin = searchResult;
      isOnlineTheme = origin === 'online';
    } catch (err) {
      LOG.error(`Error on parsing theme desc JSON file, ${err.code} - ${err.message}`);
    }
    return isOnlineTheme;
  }

  /**
   * Get the animation handler for the extension component to notify animation finish
   *
   * @returns Animation handler instance
   */
  public getAnimationHandler(): TsAnimationHandler | undefined {
    return this.animationHandler;
  }

  /**
   * Update proxy instance on theme change, which would invoke proxy instance to be changed
   *
   * @param proxyHandler The current proxy handler instance
   */
  public updateProxyInstance(proxyHandler: TsProxyHandler): void {
    if (!(proxyHandler instanceof TsProxyHandler)) {
      return;
    }
    LOG.showInfo(`updateProxyInstance`);

    this.proxyHandler = proxyHandler;
    if (this.animationHandler) {
      this.animationHandler.setProxyHandler(this.proxyHandler);
    } else {
      this.animationHandler = new TsAnimationHandler(this.proxyHandler);
    }
    LOG.info(`updateProxyInstance finish, finish type ${this.animationHandler === undefined}`);
  }

  /**
   * Handle SceneBoard changes status scenario, which would notify ThemeEngine to update view and play animation
   *
   * @param srcState Source SceneBoard state
   * @param dstState Destination SceneBoard state
   * @param finishCallback Animation finish callback that would be called when animation finishes
   * @param isPlayAnimation 是否播放动画
   * @param isSafeMode Used to identify is safe mode
   */
  private onDesktopUpdate(srcState: number, dstState: number, finishCallback: (() => void) | undefined,
    isPlayAnimation: boolean, isSafeMode: boolean): void {
    if (dstState !== ScbState.UNKNOWN) {
      LOG.info(`onDesktopUpdate src: ${srcState}, dst: ${dstState}`);
      this.scbState = dstState as ScbState;
    }
    if (this.animationHandler) {
      this.animationHandler?.setAnimationFinishCallback(finishCallback);
    }
    this.proxyHandler?.sendScbStateUpdate(srcState, dstState, isSafeMode);

    if (this.disableUiFirst) {
      this.disableUiFirst();
    }

    LOG.info(`onDesktopUpdate type ${this.themeType}, outer type ${this.outerThemeType},
     isOuterEngine:${this.isOuterEngineService()}`);

    let isDynamic: boolean = this.isOuterEngineService() ?
      this.activationStrategy.isOuterDynamicInvolved() : this.activationStrategy.isDynamicInvolved();
    if (isDynamic) {
      const epochTime: number = systemDateTime.getTime();
      LOG.info(`update animation type ${srcState} ${dstState}, taskId ${epochTime}`);
      this.animationHandler?.playAnimationWithScbState(srcState, dstState, isPlayAnimation, epochTime, finishCallback);
      this.animationDelegate?.onAnimationStarted();
    }
  }

  /**
   * Distinguish whether current proxy is outer proxy for VDE
   *
   * @returns True if proxy is outer proxy, False otherwise.
   */
  public isOuterEngineService(): boolean {
     return false;
  }

  /**
   * Allow other instance to implement their on delegate instance to receive animation lifecycle notification
   *
   * @param delegate Self-implemented TsAnimationDelegate instance
   */
  public setAnimationDelegate(delegate: TsAnimationDelegate): void {
    this.animationDelegate = delegate;
  }

  /**
   * Check whether current platform would use ThemeEngine for wallpaper display
   *
   * @returns False for Foldables, true for others.
   */
  public isUseEngineWallpaper(): boolean {
    let isThemeEngine: boolean =
      DeviceHelper.isPhone() || DeviceHelper.isPad() || DeviceHelper.isPC();
    LOG.info(`themeEngine state is ${isThemeEngine}`);
    return isThemeEngine;
  }

  /**
   * Handling Animation change SCB to ThemeEngine
   *
   * @param AnimationInfo for ThemeEngine
   */
  public handleAnimationEvent(animationType: number): void {
    let isDynamic: boolean = this.isOuterEngineService() ?
      this.outerThemeType === ThemeType.DYNAMIC : this.themeType === ThemeType.DYNAMIC;
    if (isDynamic) {
      if (this.disableUiFirst) {
        this.disableUiFirst();
      }
      this.animationHandler?.playEngineAnimation(animationType);
      this.animationDelegate?.onAnimationStarted();
    }
  }

  /**
   * AOD dark coefficient update
   */
  public onAodUpdate(): void {
    this.proxyHandler?.sendAodStateUpdate();
  }

  /**
   * Handling interactive event from SCB to ThemeEngine
   *
   * @param event Incl. interactive event for ThemeEngine
   */
  public handleInteractiveEvent(interactiveType: number, x: number, y: number): void {
    this.proxyHandler?.sendInteractiveUpdate(interactiveType, x, y, 'lock');
  }

  public handleHomeInteractiveEvent(interactiveType: number, x: number, y: number): void {
    if (!ThemeStyleManager.getInstance().getIsWallpaperTouchable()) {
      LOG.info(TAG, 'handleHomeInteractiveEvent isWallpaperTouchable=false');
      return;
    }
    LOG.info(TAG, 'enter handleHomeInteractiveEvent');
    this.proxyHandler?.sendInteractiveUpdate(interactiveType, x, y, 'home');
  }

  /**
   * Handling modeChange event from SCB to ThemeEngine
   *
   * @param displayMode
   */
  public handleMainPageStateChangeEvent(mpState: number): void {
    this.proxyHandler?.sendMainPageStateUpdate(mpState);
  }

  /**
   * Handling gesture motion from SCB to ThemeEngine
   *
   * @param gesture motion callback
   */
  public handleGestureMotion(enable: boolean, callback: (clockCollapse: boolean) => void): number {
    LOG.info(TAG, `received handleGestureMotion, enable is ${enable}`);
    this.isEnableGestureMotionCallback = enable;
    this.gestureMotionCallback = callback;
    if (!this.proxyHandler) {
      LOG.error(TAG, `proxyHandler is null`);
      return GESTURE_ERROR;
    }
    this.proxyHandler.sendGestureMotionEnable(enable);
    return GESTURE_SUCCESS;
  }

  private syncAodPosition(aodPosition: AodElemPosition): void {
    if (!aodPosition || !aodPosition.background) {
      LOG.error(TAG, 'Syncing aodPosition failed');
      return;
    }

    LOG.info(TAG, `Syncing AOD info, type is ${aodPosition.type}`);
    this.proxyHandler?.sendAodPosition(aodPosition);
  }

  private updateThemeScene(event: string, callback: () => void): void {
    this.themeSceneSwitchCallback = callback;
    this.proxyHandler?.updateThemeScene(event);
  }

  private liveViewEventChange(eventType: number, hashCode: string, event: string, status: number): void {
    this.proxyHandler?.sendLiveViewEvent(eventType, hashCode, event, status);
  }

  /**
   * get AOD Clock base image
   */
  public updateClockBaseImage(callBack: () => void): void {
    if (!callBack) {
      return;
    }
    this.baseImageCallback = callBack;
    this.proxyHandler?.updateClockBaseImage();
  }

  /**
   * handle AOD Clock base image
   */
  public handleBaseImageCallBack(): void {
    if (this.baseImageCallback) {
      this.baseImageCallback();
    }
  }

  /**
   * gesture motion callback
   *
   * @param clockCollapse 是否需要折叠时钟
   */
  public onGestureMotionEvent(clockCollapse: boolean): void {
    LOG.info(TAG, `onGestureMotionEvent clockCollapse: ${clockCollapse}`);
    if (!this.gestureMotionCallback) {
      LOG.warn(TAG, 'gesture motion callback disabled, will return');
      return;
    }
    LOG.info(TAG, `do gestureMotionCallback for clockCollapse: ${clockCollapse}`);
    this.gestureMotionCallback(clockCollapse);
  }

  /**
   * update theme scene callback
   */
  public onThemeSceneSwitchFinishEvent(): void {
    LOG.info(TAG, 'on theme scene switch finish event');
    if (this.themeSceneSwitchCallback) {
      this.themeSceneSwitchCallback();
    } else {
      LOG.error(TAG, 'theme scene switch callback is null');
    }
  }

  /**
   * 设置萌宠实况通知集合
   *
   * @param {string[]} liveViewList - 实况通知列表，元素为实况通知事件名称
   */
  public setCutePetLiveViewSet(liveViewList: string[]): void {
    liveViewList.forEach((liveViewEntity) => {
      this.liveEventSet.add(liveViewEntity);
      LOG.info(`setLiveViewSet liveViewEntity: ${liveViewEntity}`);
    });
  }

  /**
   * Get current SceneBoard state
   *
   * @returns Current SceneBoard State
   */
  public getScbState(): ScbState {
    LOG.info(`getScbState: ${this.scbState}`);
    return this.scbState;
  }

  /**
   * Animation finish callback is strictly limited to be called only once on each SceneBoard status change
   */
  public lockAnimationFinishSend(): void {
    this.animationDelegate?.onAnimationCompleted();
  }

  /**
   * Release resource usage on SceneBoard die
   */
  public destructor(): void {
    EventEmitter.off(TsEventId.EVENT_THEME_ACTIVATE);
    ThemeServiceHelper.serviceInstance = undefined;
    this.unsubscribeLiveViewEvent();
    DesktopModeManager.getInstance().unRegisterModeChangeCallback(TAG);
    if (!this.subscriber) {
      return;
    }
    try {
      commonEventManager.unsubscribe(this.subscriber);
    } catch (error) {
      LOG.error(TAG, `Unsubscribe freeze ThemeEngine error, message = ${error?.message}; code = ${error?.code}.`)
    }
    TsSceneBoardStateListenerManager.getInstance().unRegisterDesktopFsmListener(this.desktopAppStateListener, TAG);
  }

  /**
   * 检查文件是否存在
   * @param path 文件路径
   * @return 如果文件存在返回true，否则返回false
   */
  private isFileExists(path: string): boolean {
    let exist = false;
    if (!path || !path.trim()) {
      return false;
    }
    try {
      exist = fs.accessSync(path);
    } catch (e) {
      LOG.error(TAG, `isFileExists error: ${e}`);
    }
    return exist;
  }

  /**
   * 冻结主题引擎
   *
   * @param freezeReason 冻结原因
   */
  public freezeThemeEngine(freezeReason?: ThemeFreezeReason): void {
    LOG.info(TAG, 'Freeze ThemeEngine, freezeReason: ', freezeReason);
    this.proxyHandler?.sendEngineFreezeStatusUpdate(true, false, freezeReason);
  }

  /**
   * 解冻主题引擎
   *
   * @param freezeReason 冻结原因
   */
  public unfreezeThemeEngine(freezeReason?: ThemeFreezeReason): void {
    LOG.info(TAG, 'Unfreeze ThemeEngine, freezeReason: ', freezeReason);
    this.proxyHandler?.sendEngineFreezeStatusUpdate(false, false, freezeReason);
  }

  /**
   * 设置uiContext用于播放动画
   * @param uiContext UI上下文对象
   */
  public setUIContext(uiContext: UIContext): void {
    this.uiContext = uiContext;
  }

  private isFreezeStatus(srcState: number, dstState: number): boolean {
    return FREEZE_STATES.has(srcState) && FREEZE_STATES.has(dstState);
  }

  private doFreeze(srcState: number, dstState: number): void {
    if (srcState === ScbState.PROXIMITY_SCREEN_ON && dstState === ScbState.PROXIMITY_SCREEN_OFF) {
      LOG.info('PROXIMITY_SCREEN_ON to PROXIMITY_SCREEN_OFF, freezeThemeEngine');
      AppStorage.setOrCreate<boolean>('screenlockFreezeEngine', true);
      this.freezeThemeEngine(ThemeFreezeReason.PROXIMITY_SCREEN_OFF);
      return;
    }
    if (srcState === ScbState.PROXIMITY_SCREEN_OFF && dstState === ScbState.PROXIMITY_SCREEN_ON) {
      LOG.info('PROXIMITY_SCREEN_OFF to PROXIMITY_SCREEN_ON, unfreezeThemeEngine');
      AppStorage.setOrCreate<boolean>('screenlockFreezeEngine', false);
      this.unfreezeThemeEngine(ThemeFreezeReason.PROXIMITY_SCREEN_OFF);
      return;
    }
    if (srcState === ScbState.DROPDOWN_PANEL_UP && dstState === ScbState.DROPDOWN_PANEL_DOWN) {
      LOG.info('DROPDOWN_PANEL_UP to DROPDOWN_PANEL_DOWN, freezeThemeEngine');
      this.freezeThemeEngine(ThemeFreezeReason.DROPDOWN_PANEL);
      return;
    }
    if (srcState === ScbState.DROPDOWN_PANEL_DOWN && dstState === ScbState.DROPDOWN_PANEL_UP) {
      LOG.info('DROPDOWN_PANEL_DOWN to DROPDOWN_PANEL_UP, unfreezeThemeEngine');
      this.unfreezeThemeEngine(ThemeFreezeReason.DROPDOWN_PANEL);
    }
    if (srcState === ScbState.GLOBAL_SEARCH_PANEL_UP &&
      dstState === ScbState.GLOBAL_SEARCH_PANEL_DOWN) {
      LOG.info('GLOBAL_SEARCH_PANEL_UP to GLOBAL_SEARCH_PANEL_DOWN, freezeThemeEngine');
      this.freezeThemeEngine(ThemeFreezeReason.GLOBAL_SEARCH_PANEL);
      return;
    }
    if (srcState === ScbState.GLOBAL_SEARCH_PANEL_DOWN &&
      dstState === ScbState.GLOBAL_SEARCH_PANEL_UP) {
      LOG.info('GLOBAL_SEARCH_PANEL_DOWN to GLOBAL_SEARCH_PANEL_UP, unfreezeThemeEngine');
      this.unfreezeThemeEngine(ThemeFreezeReason.GLOBAL_SEARCH_PANEL);
    }
  }
}