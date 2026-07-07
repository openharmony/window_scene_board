/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  CEManager,
  localEventManager,
  NavBarEventType,
  SCBDesktopCacheManager,
  ViewArea as ScreenRect,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import {
  EventType,
  GestureNavigationState,
  GestureType,
  RecentsStyleConstants,
  scbEventExclusiveManager,
  scbGestureManager,
  SCBRotateChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { CommonConstants, EventConstants, SystemBarChangeType, vibratorMgr } from '@ohos/launchercommon';
import { SCBAiBarConstants } from '../aiBar/SCBAiBarConstants';
import { SendTouchEventController } from '@ohos/windowscene/Index';
import { SCBSingleHandController, SingleHandStatusChangeCallback, SingleHandMode } from '../scenemanager/onehandmode/SCBSingleHandController';
import singletonBackViewModel from './back/viewmodel/SCBGestureBackViewModel';
import { AIBarViewData } from '../aiBar/AIBarModel/AIBarViewData';
import { AIBarData } from '../aiBar/AIBarModel/AIBarData';
import { AIBarViewModel } from '../aiBar/AIBarModel/AIBarViewModel';
import { SCBScenePanelFSM } from '../recent/scenepanel/SCBScenePanelFSM';
import { ScenePanelStates } from '../recent/scenepanel/ScenePanelStates';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { NavbarWindowManager } from './navbar/viewmodel/NavbarWindowManager';

const TAG = 'SCBGestureNavBarViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const AIBarWindowHeight: number = 44;

export enum DragEventType {
  INIT,
  RESPONSE,
  CANCEL,
  IN_HOT_AREA,
  OUT_HOT_AREA,
  DRAG_FINISH,
}

export enum PanGestureType {
  DEFAULT = 0,
  GAME_OPERATE = 1
}

export class NavbarPanGesture {
  public isFirstUpSlide: boolean = false;
  private aiBarIsShowInStart_: boolean = false;
  private gestureNavigationState_: GestureNavigationState = GestureNavigationState.START;
  private panGestureType_: PanGestureType = PanGestureType.DEFAULT;
  private sendTouchEventController_: SendTouchEventController | null = null;
  private navBarViewModel_: SCBGestureNavBarViewModel;

  constructor(navBarViewModel: SCBGestureNavBarViewModel,
    sendTouchEventController: SendTouchEventController | null) {
    this.initParam(false);
    this.navBarViewModel_ = navBarViewModel;
    this.sendTouchEventController_ = sendTouchEventController;
  }

  public get panGestureType(): PanGestureType {
    return this.panGestureType_;
  }

  public set gestureNavigationState(gestureNavigationState: GestureNavigationState) {
    this.gestureNavigationState_ = gestureNavigationState;
  }

  /**
   * PanGesture.start时初始化参数
   * @param aiBarIsShowInStart PanGesture.start时的导航条状态
   */
  public initParam(aiBarIsShowInStart: boolean): void {
    this.isFirstUpSlide = false;
    this.aiBarIsShowInStart_ = aiBarIsShowInStart;
    this.gestureNavigationState_ = GestureNavigationState.START;
    this.panGestureType_ = PanGestureType.DEFAULT;
  }

  /**
   * PanGesture.start时检查并记录操作类型，配置支持防误触功能的应用复用游戏操作逻辑
   * @param screenProperty PanGesture.start时的屏幕参数
   */
  public checkAndSetPerationType(screenProperty: SCBScreenProperty): void {
    if (!this.aiBarIsShowInStart_ && (this.navBarViewModel_.checkEnableAntiTouchStatus() ||
    AIBarViewModel.getInstance(screenProperty).isConfigureMisTouchAppActive())) {
      log.showInfo('panGestureType is GAME_OPERATE');
      this.panGestureType_ = PanGestureType.GAME_OPERATE;
    } else {
      log.showInfo('panGestureType is DEFAULT');
      this.panGestureType_ = PanGestureType.DEFAULT;
    }
  }

  /**
   * 默认操作（上滑多任务/快切）
   * @param gestureEvent 滑动事件
   */
  public defaultPeration(gestureEvent: GestureEvent | null): void {
    if (!gestureEvent) {
      log.showInfo(`pan gesture ${this.gestureNavigationState_} event is null.`);
      return;
    }
    this.navBarViewModel_.processNavigationEvent(this.gestureNavigationState_, gestureEvent);
  }

  /**
   * 防误触操作
   * @param touchEvent 滑动事件
   */
  public accidentalTouchPeration(touchEvent: TouchEvent | null): void {
    this.sendTouchEventController_?.sendTouchEvent(touchEvent);
  }
}

/**
 * SCBGestureNavBar  拆分函数
 *
 * @since 2024-04-16
 */
export class SCBGestureNavBarViewModel {
  private static mInstance: SCBGestureNavBarViewModel;
  private isSendToSCBScenePanel: boolean = false;
  private hasDisabledScreenRotate: boolean = false;
  private gestureDockCallback: Function | undefined;
  private windowManager_: NavbarWindowManager = new NavbarWindowManager();
  private aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
  private aiBarData: AIBarData = AIBarData.getInstance();
  public screenRotation: number = CommonConstants.INVALID_VALUE;

  static getInstance(): SCBGestureNavBarViewModel {
    if (SCBGestureNavBarViewModel.mInstance == null) {
      SCBGestureNavBarViewModel.mInstance = new SCBGestureNavBarViewModel();
    }
    return SCBGestureNavBarViewModel.mInstance;
  }

  public registerRotateAnimaChangeCallBack() {
    scbEventExclusiveManager.registerEventExclusive(EventType.ANIMATION_SCREENROTATE, () => {
      scbEventExclusiveManager.setEventExclusive(EventType.ANIMATION_SCREENROTATE, false);
    });
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.rotateAnimaChangeCallBack);
  }

  private rotateAnimaChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
    switch (reason) {
      case SCBRotateChangeReason.ROTATE_BEGIN:
        log.showInfo(`ROTATE_BEGIN`);
        scbEventExclusiveManager.setEventExclusive(EventType.ANIMATION_SCREENROTATE, true);
        SCBDesktopCacheManager.getInstance().resetFreezeStateAndReady('ROTATE_BEGIN');
        break;
      case SCBRotateChangeReason.ROTATE_END:
        log.showInfo(`ROTATE_END`);
        scbEventExclusiveManager.setEventExclusive(EventType.ANIMATION_SCREENROTATE, false);
        SCBDesktopCacheManager.getInstance().setWallPaperFreezeReady(true, 'ROTATE_END');
        break;
      default:
        break;
    }
  }

  public unRegisterRotateAnimaChangeCallBack() {
    scbEventExclusiveManager.unRegisterEventExclusive(EventType.ANIMATION_SCREENROTATE);
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.rotateAnimaChangeCallBack);
  }

  /**
   * 注册侧边dock的监听
   * @param callback callback
   */
  public registerDockAnimation(callback: () => void) {
    log.showInfo('registerDockAnimation');
    this.gestureDockCallback = callback;
  }

  /**
   * 反注册侧边dock的监听
   */
  public unRegisterDockAnimation() {
    log.showInfo('unRegisterDockAnimation');
    this.gestureDockCallback = undefined;
  }

  public notifyDockAnimation() {
    log.showInfo(`notifyDockAnimation gestureDockCallback is ${this.gestureDockCallback}`);
    this.gestureDockCallback?.();
  }

  /**
   * 获取窗口管理器
   *
   * @returns 窗口管理器
   */
  public get windowManager(): NavbarWindowManager {
    return this.windowManager_;
  }

  /**
   * 检查是否满足防误触条件(新形态小折叠外屏默认满足防误触)
   * @returns 判断结果
   */
  public checkEnableAntiTouchStatus(): boolean {
    log.showInfo(`checkGameStatus:${this.checkGameStatus()}, isShowingAiBar:${!this.aiBarViewData.isShowingAiBar}`);
    return this.checkGameStatus() && !this.aiBarViewData.isShowingAiBar;
  }

  /**
   * 检查是否进入游戏
   * @param gameStatus 游戏状态
   * @returns 判断结果
   */
  public checkGameStatus(): boolean {
    return this.aiBarData.gameStatusMap.size > 0;
  }

  /**
   * 获取dock区高度
   * @param animMaxHeight 动效最大高度
   * @returns dock区高度
   */
  public getWindowHeight(animMaxHeight: number): number {
    // dock区高度与导航条长按高度比较
    return Math.max(animMaxHeight, Math.floor(vp2px(AIBarWindowHeight)));
  }

  /**
   * 开启导航
   * @param navState 手势导航类型
   * @param event
   */
  public processNavigationEvent(navState: GestureNavigationState, event: GestureEvent): void {
    switch (navState) {
      case GestureNavigationState.START:
        if (viewMgrPolicy.isViewShowing(ViewType.KEYGUARD)) {
          this.isSendToSCBScenePanel = false;
          scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'SCBSpecialScenePanel', navState, event);
          scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'InputPwdTip', navState, event);
        } else {
          this.isSendToSCBScenePanel = true;
          this.sendNavigationEventToSCBScenePanel(event, navState);
        }
        break;
      case GestureNavigationState.UPDATE:
        this.sendNavigationEvent(navState, event);
        break;
      case GestureNavigationState.END:
      case GestureNavigationState.CANCEL:
        scbGestureManager.publishScenePanelEventMsg(CEManager.CUSTOM_NAVBAR_EVENT, NavBarEventType.NAVBAR_UP);
        this.sendNavigationEvent(navState, event);
        this.isSendToSCBScenePanel = false;
        break;
    }
  }

  private sendNavigationEvent(navState: GestureNavigationState, event: GestureEvent): void {
    if (!this.isSendToSCBScenePanel) {
      scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'SCBSpecialScenePanel', navState, event);
      scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'InputPwdTip', navState, event);
    } else {
      this.sendNavigationEventToSCBScenePanel(event, navState);
    }
  }

  private sendNavigationEventToSCBScenePanel(event: GestureEvent, navState: GestureNavigationState) {
    scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'SCBScenePanel', navState, event);
    scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'SCBIntegratedDock', navState, event);
    scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'SCBPadShortcutPanel', navState, event);
    scbGestureManager.onGestureEvent(GestureType.NAVIGATION, 'SCBGestureDock', navState, event);
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
   * 打印SCBGestureStack的长按事件日志
   *
   * @param tag 事件名称
   * @param event 手势事件
   */
  public recordLongPressLog(tag: String, event?: GestureEvent): void {
    if (!event || CheckEmptyUtils.isEmptyArr(event.fingerList)) {
      log.showInfo('event is null');
      return;
    }
    event.fingerList.forEach((fingerElement: FingerInfo) => {
      log.showInfo('%{public}s:fgInfo == fingerId: %{public}i, fingerGlobalX: %{public}i, fingerGlobalY: %{public}i' +
        ', offsetX: %{public}i, offsetY: %{public}i, timestamp: %{public}i, pressure: %{public}i',
        tag, fingerElement.id, fingerElement.globalX, fingerElement.globalY, event.offsetX, event.offsetY,
        event.timestamp, event.pressure);
    });
  }

  /**
   * 导航条触摸事件处理
   * @param event
   * @param isSystemBarEnable 是否允许导航条唤醒
   */
  public navBarOnTouch(event: TouchEvent, isSystemBarEnable: boolean) {
    if (isSystemBarEnable) {
      return;
    }
    if (event.type === TouchType.Down) {
      localEventManager.sendLocalEvent(EventConstants.SYSTEM_BAR_CHANGE, SystemBarChangeType.CANCEL_TASK);
    } else if (this.upOrCancelTouch(event.type)) {
      localEventManager.sendLocalEvent(EventConstants.SYSTEM_BAR_CHANGE, SystemBarChangeType.SET_TASK);
    }
  }

  /**
   * 是否上滑或取消
   * @param type
   * @returns
   */
  public upOrCancelTouch(type: TouchType): boolean {
    return type === TouchType.Up || type === TouchType.Cancel
  }

  /**
   * 解禁窗口旋转
   */
  public enableScreenRotate(): void {
    if (this.hasDisabledScreenRotate) {
      log.showInfo(`enableScreenRotate:${this.hasDisabledScreenRotate}`);
      let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      screenSession.setRotatoinExclusive(true, 'navbar');
      this.hasDisabledScreenRotate = false;
    }
  }

  /**
   * 禁用窗口旋转
   *
   * @param event 手势操作
   * @param screenHeight 屏幕高度
   */
  public disableScreenRotate(event: GestureEvent, screenHeight: number): void {
    if (this.hasDisabledScreenRotate) {
      return;
    }
    let currentState = SCBScenePanelFSM.getInstance().currentState;
    if (currentState.equalTo(ScenePanelStates.STATE_HOME_IDLE || ScenePanelStates.STATE_APP_IDLE)) {
      return;
    }
    if (currentState.equalTo(ScenePanelStates.STATE_ZOOM_FOLLOWING_FROM_APP) &&
      (Math.abs(event.offsetY) / screenHeight) < RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MIN) {
      return;
    }
    log.showInfo('navbar disable screen rotate.');
    let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    screenSession.setRotatoinExclusive(false, 'navbar');
    this.hasDisabledScreenRotate = true;
  }

  /**
   * 监听单手模式状态变化
   *
   * @param event 手势操作
   * @param screenHeight 屏幕高度
   */
  public registerSingleHandStatusChangeCallback(): void {
    SCBSingleHandController.getInstance().registerSingleHandStatusChangeCallback(TAG,
      this.singleHandStatusChangeCallback);
  }

  /**
   * 反注册监听单手模式状态
   *
   * @param event 手势操作
   * @param screenHeight 屏幕高度
   */
  public unRegisterSingleHandStatusChangeCallback(): void {
    SCBSingleHandController.getInstance().unregisterSingleHandStatusChangeCallback(TAG);
  }

  private singleHandStatusChangeCallback: SingleHandStatusChangeCallback = {
    onSingleHandEntered: (mode: SingleHandMode): void => {
      log.showInfo(`onSingleHandEntered`);
    },
    onSingleHandExited: (): void => {
      log.showInfo(`onSingleHandExited`);
      this.enableScreenRotate();
    }
  }
}
