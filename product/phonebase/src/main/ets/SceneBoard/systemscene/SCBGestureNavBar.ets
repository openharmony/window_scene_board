/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
  NAVIBarConstants,
  EventType,
  GestureNavigationState,
  GestureType,
  scbEventExclusiveManager,
  scbGestureManager,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBTransitionManager,
  SCBUnlockTransitionController,
} from '@ohos/windowscene';
import { OutdoorConfig, CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { GlobalContext, localEventManager, viewMgrPolicy } from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { DropAnimationCancelReason } from '@ohos/componentanimator';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { DeliverUtil, ASCFWindowMgrListener, EventConstants, ReceiveEventInfo, StyleConstants, } from '@ohos/launchercommon';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import { SendClickEventController, SendState, SendTouchEventController } from '@ohos/windowscene/Index';
import {
  NavbarPanGesture,
  PanGestureType,
  SCBGestureNavBarViewModel,
} from '../gesturenavigation/SCBGestureNavBarViewModel';
import { SystemSceneConstants } from '../gesturenavigation/SystemSceneConstants';

import NAVIBarView from '../naviBar/view/NAVIBarView';
import { NAVIBarViewModel } from '../naviBar/NAVIBarModel/NAVIBarViewModel';
import { naviBarSettingsDataMgr, NaviBarSettingsDataMgr } from '../naviBar/settings/preference/NaviBarSettingsDataMgr';
import { GestureDockViewModel } from '../gestureDock/dock/viewmodel/GestureDockViewModel';
import { FloatingNavigationManager } from '../naviBar/proxy/FloatingNavigationManager';
import { NavbarWindowManager } from '../gesturenavigation/navbar/viewmodel/NavbarWindowManager';
import { SCBGestureNavSetMgr } from '@ohos/componenthelper';
import { threeButtonAccessibilityMgr } from '../naviBar/settings/preference/ThreeButtonAccessibilityManager';
import { GameOperationManager } from '../gesturenavigation/navbar/model/GameOperationManager';

const TAG = 'SCBGestureNavBar';
const NAVIBAR_TAG = 'NAVIBAR';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const FUN_NUM = 'SF-20005714_f301';

@Component
export struct SCBGestureNavBar {
  persistentId: number = 0;
  sendTouchEventController: SendTouchEventController | null = null;
  sendClickEventController: SendClickEventController | null = null;
  // 不需要透传事件标记
  private noSendEvent: boolean = true;
  // 需要透传抬手事件标记，在noSendEvent=true时，如果sendUpEvent=true，要传抬手事件，在noSendEvent=false时所有事件都要传
  private sendUpEvent: boolean = true;
  @Link screenProperty: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(TAG);
  @State isGestureEnabled: boolean = true;
  private readonly navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private readonly navbarWindowManager: NavbarWindowManager = this.navBarViewModel.windowManager;
  private navbarPanGesture: NavbarPanGesture =
    new NavbarPanGesture(this.navBarViewModel, this.sendTouchEventController);
  @StorageLink('isInNavBarGesture') isInNavBarGesture: boolean = false;
  @StorageProp('isAccessibilityMode') @Watch('onChangeAccessibilityModeState') isAccessibilityMode: boolean = false;
  private readonly naviBarViewModel: NAVIBarViewModel = NAVIBarViewModel.getInstance(this.screenProperty);
  private gameOperationManager: GameOperationManager = new GameOperationManager(this.naviBarViewModel);
  @State isUnLockReceived: boolean = false;
  @StorageProp('currColorMode') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  private downEvent: TouchEvent | null = null;
  private upEvent: TouchEvent | null = null;
  private moveEvent: TouchEvent | null = null;
  private isIgnoreNavBarGesture: boolean = false;
  private isGestureNavBarCancel: boolean = false;
  private lastUpdateEvent: GestureEvent | null = null;
  private isOuterSideSlip: boolean = false;
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_SCBGestureNavBar`,
    onLock: (): void => this.onLockReceived(),
    onUnlock: (): void => this.onUnLockReceived()
  };
  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: number | boolean): void => {
      switch (event) {
        case EventConstants.EVENT_APP_EXIT_LANDSCAPE:
          log.showInfo(`[${NAVIBAR_TAG}] receive APP_EXIT_LANDSCAPE event, params=${params}`);
          if (typeof params !== 'boolean') {
            log.showInfo('params is not boolean');
            break;
          }
          if (params === this.naviBarViewModel.naviBarViewData.isInExitLandScape) {
            log.showInfo('isInExitLandScape is not change');
            break;
          }
          animateTo({
            curve: Curve.Linear,
            duration: 200
          }, () => {
            this.naviBarViewModel.naviBarViewData.isInExitLandScape = params;
          });
          break;
        case EventConstants.EVENT_NAV_BAR_GESTURE_CANCEL:
          log.showInfo(`[${NAVIBAR_TAG}] receive EVENT_NAV_BAR_GESTURE_CANCEL event, params=${params},` +
            `this.isInNavBarGesture is ${this.isInNavBarGesture}`);
          if (this.isInNavBarGesture) {
            this.onPanGestureActionCancel();
          }
          break;
        default:
          break;
      }
    }
  };

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    SCBGestureNavSetMgr.init();
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      log.showInfo(`isInOutdoorMode`);
      FloatingNavigationManager.getInstance().setIsHiddenScene(true);
    }
    this.sendTouchEventController = new SendTouchEventController(TAG, this.persistentId,
      SCBDefaultZIndex.GESTURE_NAVIGATION);
    this.navbarPanGesture = new NavbarPanGesture(this.navBarViewModel, this.sendTouchEventController);
    this.sendClickEventController = new SendClickEventController(TAG, this.persistentId,
      SCBDefaultZIndex.GESTURE_NAVIGATION);
    scbEventExclusiveManager.registerEventExclusive(EventType.GESTURE_NAVBAR, () => {
      if (this.isInNavBarGesture) {
        this.onPanGestureActionCancel();
      }
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, false);
    });
    this.navbarWindowManager.init(this.viewController, this.persistentId);
    viewMgrPolicy.registerViewController(TAG, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.naviBarViewModel.updateArea(this.screenProperty);
    this.viewController.show();
    this.initScreenPropertyListener();
    ASCFWindowMgrListener.registerAppUpdateListener();
    this.navBarViewModel.registerRotateAnimaChangeCallBack();
    this.navBarViewModel.registerSingleHandStatusChangeCallback();
    this.registerGestureEnabledCallBack();
    this.navBarViewModel.registerDockAnimation(() => {
      GestureDockViewModel.getInstance().getViewEvent()?.resetDockPosition(false);
    })
    localEventManager.registerEventListener(this.localEventListener,
      [EventConstants.EVENT_APP_EXIT_LANDSCAPE, EventConstants.EVENT_NAV_BAR_GESTURE_CANCEL]);
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    this.naviBarViewModel.naviBarViewAppear(this.persistentId, this.viewController, this.sendTouchEventController);
  }

  private registerGestureEnabledCallBack() {
    scbGestureManager.registerGestureEnabledCallback(GestureType.NAVIGATION, (isEnable: boolean) => {
      if (this.isGestureEnabled !== isEnable) {
        log.showInfo(`${TAG} registerGestureEnabledCallback ${isEnable}`);
      }
      this.isGestureEnabled = isEnable;
      if (!this.isGestureEnabled && this.isInNavBarGesture) {
        this.onPanGestureActionCancel();
      }
      let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
      if (systemSceneSession) {
        systemSceneSession.setSessionTouchable(isEnable);
      }
    });
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.sendTouchEventController = null;
    scbGestureManager.unRegisterGestureEnabledCallback(GestureType.NAVIGATION);
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockTransitionController, false);
    this.navBarViewModel.unRegisterRotateAnimaChangeCallBack();
    this.navBarViewModel.unRegisterSingleHandStatusChangeCallback();
    this.naviBarViewModel.naviBarViewDisAppear();
    ASCFWindowMgrListener.unRegisterAppUpdateListener();
    this.navbarWindowManager.release();
  }

  private initScreenPropertyListener(): void {
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        log.showInfo(`screenPropertyChange ${reason} ${this.persistentId} ${JSON.stringify(screenProperty)}`);
        if (reason === SCBPropertyChangeReason.ROTATION && this.isInNavBarGesture) {
          this.onPanGestureActionCancel();
        }
        this.naviBarViewModel.naviBarViewData.isToastShow = false;
        this.naviBarViewModel.naviBarAnimate.whetherEndWeakNavigationAnimationImmediate(
          this.naviBarViewModel.naviBarViewData.capsuleWidth);
        this.naviBarViewModel.updateArea(screenProperty);
        this.naviBarViewModel.resetHotAreaHeightInGame();
      }, undefined, true, this.persistentId);
  }

  private onChangeAccessibilityModeState(): void {
    log.showInfo(`AccessibilityMode has change to ${this.isAccessibilityMode}`);
    // 进入无障碍模式，设置悬浮导航为开启，并重置悬浮导航位置
    threeButtonAccessibilityMgr.onChangeAccessibilityModeStateChange(this.isAccessibilityMode);
  }

  private onLockReceived(): void {
    log.showInfo('onLockReceived');
    this.naviBarViewModel.naviBarData.gameStatusMap = new Map();
    this.naviBarViewModel.setWindowInputTypeAndGameSign();
    this.naviBarViewModel.naviBarViewData.isToastShow = false;
    this.navBarViewModel.enableScreenRotate();
    this.isUnLockReceived = false;
    this.naviBarViewModel.naviBarViewData.isScreenLock = true;
  }

  private onUnLockReceived(): void {
    log.showInfo('onUnLockReceived');
    this.naviBarViewModel.naviBarViewData.isToastShow = false;
    this.isUnLockReceived = true;
    this.naviBarViewModel.naviBarViewData.isScreenLock = false;
    FloatingNavigationManager.getInstance().setIsScreenLock(false);
    scbGestureManager.naviBarChange(NAVIBarConstants.GESTURE_NAVI_BAR_TYPE_DESKTOP);
    // 同步preference到settings,AreaMode.EL2需解锁之后再获取
    // 更改为原来逻辑一样。收到解锁通知，延迟一秒去同步preference到settings
    setTimeout(() => {
      if (this.isUnLockReceived) {
        naviBarSettingsDataMgr.initData();
      }
    }, 1000);
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      this.buildNavBar();
    }
    .accessibilityLevel('no')
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .align(Alignment.Bottom)
    .id('SCBGestureNavBar')
    // 底部上滑过程中，1. 不再响应另一根手指上滑事件，2.不响应导航条相关事件
    .enabled(!this.isInNavBarGesture)
  }

  @Builder
  buildNavBar() {
    if (this.isGestureEnabled) {
      Stack({ alignContent: Alignment.Bottom }) {
        if (!OutdoorConfig.getInstance().isInOutdoorMode()) {
          NAVIBarView({
            screenProperty: this.screenProperty,
            persistentId: this.persistentId,
            viewController: this.viewController
          });
        }
      }
      .accessibilityLevel('no')
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
      .align(Alignment.Bottom)
      .id('buildNavBar')
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          LongPressGesture({ repeat: false })
            .onAction((event?: GestureEvent) => {
              this.navBarViewModel.recordLongPressLog('LongPress onAction', event);
              this.sendTouchEventController?.sendALLTouchModeEvent();
              this.sendTouchEventController?.setSendState(SendState.SEND_EVENT);
            })
            .onActionEnd((event?: GestureEvent) => {
              this.navBarViewModel.recordLongPressLog('LongPress onActionEnd', event);
              this.sendTouchEventController?.setSendState(SendState.NONE);
            })
            .onActionCancel((event?: GestureEvent) => {
              this.navBarViewModel.recordLongPressLog('LongPress onActionCancel', event);
              this.sendTouchEventController?.setSendState(SendState.NONE);
            }),
          PanGesture({ distance: px2vp(20) })
            .onActionStart((event?: GestureEvent) => {
              log.showInfo(`onActionStart Math.abs(event.velocityY) ${Math.abs(event?.velocityY)}`);
              this.isOuterSideSlip = false;
              this.sendTouchEventController?.setSendState(SendState.NOT_SEND_EVENT);
              if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_NAVBAR)) {
                if (event?.fingerList.length === 1) {
                  scbEventExclusiveManager.restoreAllEventExclusive(EventType.GESTURE_NAVBAR);
                }
                this.isIgnoreNavBarGesture = true;
                return;
              }
              this.isGestureNavBarCancel = false;
              dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_NAV_BAR);
              scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, true);
              this.isInNavBarGesture = true;
              log.showInfo(`isTempShowNaviBar:${this.naviBarViewModel.naviBarViewData.isTempShowNaviBar}`);
              this.navbarPanGesture.initParam(this.naviBarViewModel.naviBarViewData.isTempShowNaviBar);
              this.navbarPanGesture.checkAndSetPerationType(this.screenProperty);
              switch (this.navbarPanGesture.panGestureType) {
                case PanGestureType.GAME_OPERATE:
                  this.downEvent = null;
                  break;
                case PanGestureType.DEFAULT:
                  this.navbarPanGesture.defaultPeration(event);
                  this.naviBarViewModel.naviBarAnimate.checkInitAnimParam(event);
                  break;
              }
            })
            .onActionUpdate((event?: GestureEvent) => {

              this.navbarPanGesture.gestureNavigationState = GestureNavigationState.UPDATE;
              if (this.isIgnoreNavBarGesture) {
                return;
              }
              if (this.isGestureNavBarCancel) {
                if (this.naviBarViewModel.isNaviBarTranslate()) {
                  this.naviBarViewModel.naviBarAnimate.playBarResetAnim();
                }
                SCBGestureNavBarViewModel.getInstance().enableScreenRotate();
                return;
              }
              switch (this.navbarPanGesture.panGestureType) {
                case PanGestureType.GAME_OPERATE:
                  this.moveEvent = null;
                  // 游戏场景，第一个手指滑动无效，不触发呼出导航条
                  if (!this.gameOperationManager.isFirstFingerMoveValid()) {
                    log.showInfo(`panGesture firstFingerMove is invalid.`);
                    break;
                  }
                  if (!this.navbarPanGesture.isFirstUpSlide) {
                    // 首次上滑，呼出导航条
                    this.checkFirstUpSlide(event);
                  }
                  break;
                case PanGestureType.DEFAULT:
                  this.navbarPanGesture.defaultPeration(event);
                  this.naviBarViewModel.naviBarAnimate.checkPlayBarFollowHandAnim(event);
                  this.lastUpdateEvent = event;
                  break;
              }
            })
            .onActionEnd((event?: GestureEvent) => {
              log.showInfo(`onActionEnd Math.abs(event.velocityY):${Math.abs(event?.velocityY)}` +
                ` panGestureType:${this.navbarPanGesture.panGestureType}`);
              this.sendTouchEventController?.setSendState(SendState.NONE);
              this.navbarPanGesture.gestureNavigationState = GestureNavigationState.END;
              if (this.isIgnoreNavBarGesture) {
                log.showInfo(`isIgnoreNavBarGesture is ${this.isIgnoreNavBarGesture}`);
                this.isIgnoreNavBarGesture = false;
                return;
              }
              if (this.isGestureNavBarCancel) {
                log.showInfo(`pan gesture has been cancel.`);
                return;
              }
              DeliverUtil.closeSystemWindows();
              this.isGestureNavBarCancel = true;
              this.isInNavBarGesture = false;
              scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, false);
              switch (this.navbarPanGesture.panGestureType) {
                case PanGestureType.GAME_OPERATE:
                  this.upEvent = null;
                  break;
                case PanGestureType.DEFAULT:
                  this.navbarPanGesture.defaultPeration(event);
                  this.naviBarViewModel.naviBarAnimate.playBarResetAnim();
                  break;
              }
              this.gameOperationManager.reset();
              this.navbarWindowManager.update();
            })
            .onActionCancel((event?: GestureEvent) => {
              log.showInfo(`onActionCancel Math.abs(event.velocityY):${Math.abs(event?.velocityY)}` +
                ` panGestureType:${this.navbarPanGesture.panGestureType}`);
              DeliverUtil.closeSystemWindows();
              this.onPanGestureActionCancel();
            })
        )
      )
      .onAccessibilityHoverTransparent((event: TouchEvent) => {
        log.showInfo(`onAccessibilityHoverTransparent event:fingerId=${event?.changedTouches[0]?.id},type:${event?.type}`);
        this.sendTouchEventController?.sendTouchEvent(event);
      })
      .onTouch((event: TouchEvent) => {
        if (CheckEmptyUtils.isEmpty(event)) {
          log.showInfo('onTouch event is null');
          return;
        }
        this.gameOperationManager.onTouchEvent(event);
        if (event.type === TouchType.Down) {
          const sendNum: number = this.sendTouchEventController?.getSendNum() ?? 0;
          this.downEvent = event;
          // 防误触状态且已没有透传事件时，不再透传
          this.noSendEvent = this.naviBarViewModel.naviBarData.isInGameSign && sendNum === 0;
          log.showInfo(`onTouch noSendEvent is ${this.noSendEvent}`);
        }

        if (this.navBarViewModel.upOrCancelTouch(event.type)) {
          const sendNum: number = this.sendTouchEventController?.getSendNum() ?? 0;
          this.sendUpEvent = !this.noSendEvent;
          this.noSendEvent = sendNum <= 1;
          log.showInfo(`onTouch noSendEvent is ${this.noSendEvent}, sendUpEvent is ${this.sendUpEvent}`);
        }

        this.sendTouchEventController?.receiveTouchEvent(event, this.noSendEvent);

        if (event.type === TouchType.Move) {
          this.moveEvent = event;
        }

        if (this.navBarViewModel.upOrCancelTouch(event.type)) {
          this.upEvent = event;
          log.showInfo(`event up, touches: ${event.touches.length}`);
          if (event.touches.length === 1) {
            this.sendTouchEventController?.setSendState(SendState.NONE);
            this.sendTouchEventController?.clearSendTouchModelList();
          }
        }
        //锁屏状态下，将touch事件传给锁屏
        if (!this.isUnLockReceived &&
          (this.navBarViewModel.upOrCancelTouch(event.type))) {
          scbGestureManager.onTouchEvent(GestureType.NAVIGATION, 'SCBScreenLock', event);
        }
        this.naviBarViewModel.naviBarOnTouchEvent(event, this.downEvent);
      })
      .onClick(() => {
        if (!this.noSendEvent || (this.sendUpEvent && this.upEvent)) {
          log.showInfo('onClick sendMoveEvent');
          // 仅在游戏时，不满足防误触其他条件，发送一个move事件
          this.sendMoveEventInGameClick();
          const delayTime: number = this.navBarViewModel.checkGameStatus() ? 0 : 20;
          this.sendClickEventController?.sendClickEvent(this.downEvent, this.upEvent, delayTime);
        }
        this.downEvent = null;
        this.upEvent = null;
      })
    }
  }

  private onPanGestureActionCancel() {
    this.sendTouchEventController?.setSendState(SendState.NONE);
    this.navbarPanGesture.gestureNavigationState = GestureNavigationState.CANCEL;
    log.showInfo(`onActionCancel`);
    if (this.isIgnoreNavBarGesture) {
      this.isIgnoreNavBarGesture = false;
      return;
    }
    if (this.isGestureNavBarCancel) {
      log.showInfo(`pan gesture has been cancel.`);
      return;
    }
    this.isGestureNavBarCancel = true;
    scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, false);
    this.isInNavBarGesture = false;
    switch (this.navbarPanGesture.panGestureType) {
      case PanGestureType.GAME_OPERATE:
        this.upEvent = null;
        break;
      case PanGestureType.DEFAULT:
        this.navbarPanGesture.defaultPeration(this.lastUpdateEvent);
        this.naviBarViewModel.naviBarAnimate.playBarResetAnim();
        this.lastUpdateEvent = null;
        break;
    }
    this.navbarWindowManager.update();
    this.gameOperationManager.reset();
  }

  private checkFirstUpSlide(event: GestureEvent): void {
    if (Math.abs(event?.offsetY) > SystemSceneConstants.HOT_AREA_HEIGHT_IN_GAME) {
      this.navbarPanGesture.isFirstUpSlide = true;
      this.naviBarViewModel.naviBarData.isTimerRunning = true;
      clearTimeout(this.naviBarViewModel.naviBarData.hideNaviBarTimer);
      clearTimeout(this.naviBarViewModel.naviBarData.immerseHideNaviBarTimer);
      this.naviBarViewModel.naviBarData.hideNaviBarTimer = setTimeout(() => {
        this.naviBarViewModel.naviBarData.isTimerRunning = false;
        this.naviBarViewModel.naviBarViewData.isTempShowNaviBar = false;
      }, SystemSceneConstants.NAVI_BAR_DISPLAY_TIME);
      this.naviBarViewModel.naviBarViewData.isTempShowNaviBar = true;
      FloatingNavigationManager.getInstance().slideShowFloatingNavigation();
      log.showInfo(`isTempShowNaviBar is ${this.naviBarViewModel.naviBarViewData.isTempShowNaviBar}, naviBar is displaying.`);
    }
  }

  private sendMoveEventInGameClick(): void {
    if (this.navBarViewModel.checkGameStatus() && this.naviBarViewModel.naviBarViewData.isShowingNaviBar) {
      log.showInfo('Send the move event in game when click.');
      if (this.downEvent && this.upEvent && this.sendTouchEventController) {
        this.sendTouchEventController.sendTouchEvent(this.downEvent);
        this.sendTouchEventController.sendTouchEvent(this.moveEvent);
        this.sendTouchEventController.sendTouchEvent(this.upEvent);
        this.downEvent = null;
        this.moveEvent = null;
        this.upEvent = null;
      }
    }
  }
}
