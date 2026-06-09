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

import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import {
  ViewArea,
  viewMgrPolicy,
  ViewType,
  localEventManager,
  EvtBus,
  EventManager,
  WindowEvent,
} from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason,
  SCBScreenProperty,
  sSCBOobeManager,
  windowMgr,
  DisplayMgr,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBOobeManager,
} from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { multiInputManager, MultiInputViewModel } from '@ohos/multiinput';
import EventConstants from '@ohos/multiinput/src/main/ets/default/common/constants/EventConstants';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { ReceiveEventInfo } from '@ohos/launchercommon';
import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { DesktopSwitchController, VmStateCallBack } from '../virtualmachine/DesktopSwitchController';

const TAG = 'SCBGestureBar';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const HOTAREA_DISTANCE = 0.009;
const HOVER_HOTAREA_DISTANCE = 0.009;

// px
const DEFAULT_HEIGHT = 3;
const DEFAULT_HOVER_HEIGHT = 5;

/**
 * vp, 防止状态栏呼出热区过高,遮挡三键点击
 */
const MAX_HOVER_HEIGHT = 9;

/**
 * 窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_GESTURE_TOP_BAR;

const HIDE_STATUS_BAR_DELAY = 2500;

const SCREEN_INDEX = 1000;

/**
 * gesture bar和状态栏沉浸式场景是一致的，即沉浸式hover出状态栏，二分屏hover出状态栏等
 * 因此gesture bar添加一个组件接收mouse事件
 */
@Component
export struct SCBGestureBar {
  @State mHeight: number = 0;
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController =
    new BaseViewController(ViewType.GESTURE_TOP_BAR, this.screenProp.screenId);
  persistentId: number = 0;
  startX: number = 0;
  startY: number = 0;
  /**
   * 最小滑动距离
   */
  touchSlop: number = 0;
  lastStateShowing: boolean = false;
  @State mHoverHeight: number = 0;
  private hideStatusBarTimerId: number = 0;
  private mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: MouseEvent): void => {
      log.showInfo(`onReceiveEvent ${event}, ${params.action}`);
      // 当前手势不会收到此事件了
      if (event !== EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE) {
        return;
      }
      if (params.action === MouseAction.Release) {
        // 鼠标移动
        this.clearStatusBarTimer();
      } else {
        // 鼠标其他, 延时取消自动隐藏，用于取消鼠标单击收起二级菜单引起的自动隐藏
        setTimeout(() => {
          this.clearStatusBarTimer();
        }, 100);
      }
    }
  };
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear() {
    log.showInfo('aboutToAppear, start');
    this.initGestureBar();
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyCallback);
    SCBSceneSessionManager.getInstance().registerGestureBarVisibleCallback((isShow: boolean) => {
      let isVmDesktop = DesktopSwitchController.getInstance().isVmDesktop(this.screenProp.screenId);
      log.showInfo(`GestureBarVisibleCallback isShow:${isShow}, screenId:${this.screenProp.screenId},` +
        ` isVmDesktop: ${isVmDesktop}`);
      if (isShow && !isVmDesktop) {
        this.viewController.show();
        this.eventMgr.on(WindowEvent, this.handleWindowEvent);
      } else {
        log.showInfo(`do hide GestureBar, screenId:${this.screenProp.screenId}`);
        this.viewController.hide();
        // 因为gesturebar只有全屏和二分屏等沉浸式场景才会显示，因此注销mouse事件跟随其生命周期
        multiInputManager.recoverMouseEvent();
        this.eventMgr.offAll();
      }
    }, this.screenProp.screenId);
    localEventManager.registerEventListener(this.mLocalEventListener,
      [EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE]);
    DesktopSwitchController.getInstance().registerVmStateCallback(this.vmStateCallback);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyCallback);
    SCBSceneSessionManager.getInstance().unregisterGestureBarVisibleCallback(this.screenProp.screenId);
    localEventManager.unregisterEventListener(this.mLocalEventListener);
    DesktopSwitchController.getInstance().unregisterVmStateCallback(this.vmStateCallback);
  }

  private vmStateCallback: VmStateCallBack = (isVm: boolean, tarVmScreenId: number) => {
    let isVmDesktop = isVm && tarVmScreenId === this.screenProp.screenId;
    const curShowing = viewMgrPolicy.isViewShowing(ViewType.GESTURE_TOP_BAR + this.screenProp.screenId * SCREEN_INDEX);
    log.showInfo(`vmStateCallBack GestureBar lastStateShowing: ${this.lastStateShowing}, curShowing: ${curShowing}` +
      `isVmDesktop: ${isVmDesktop}, screenId: ${this.screenProp.screenId}, `);
    if (isVmDesktop) {
      this.lastStateShowing = curShowing;
      log.showInfo(`hide gestureBar lastStateShowing: ${this.lastStateShowing}, screenId: ${this.screenProp.screenId}`);
      if (this.lastStateShowing) {
        viewMgrPolicy.hideView(ViewType.GESTURE_TOP_BAR + this.screenProp.screenId * SCREEN_INDEX);
      }
    } else {
      //从虚拟机切出后，有沉浸式窗口才show GestureBar
      const isImmersive = statusbarPlCtrl.isImmersiveModeEnabled(this.screenProp.screenId);
      if (this.lastStateShowing && isImmersive) {
        log.showInfo(`do show gestureBar, curShowing: ${curShowing}, screenId: ${this.screenProp.screenId}`);
        viewMgrPolicy.showView(ViewType.GESTURE_TOP_BAR + this.screenProp.screenId * SCREEN_INDEX);
      }
      log.showInfo(`directly return. curShowing: ${curShowing}, screenId: ${this.screenProp.screenId},` +
        ` isImmersive: ${isImmersive}`);
    }
  }

  /**
   * 处理窗口显示/隐藏事件
   *
   * @param event 窗口事件
   */
  private handleWindowEvent = (event: WindowEvent): void => {
    log.showInfo(`handleWindowEvent ${event.windowName}`);
    if (CommonUtils.isInvalid(event)) {
      log.showInfo('event is invalid');
      return;
    }
    if (!statusbarPlCtrl.getStatusBarPanelMap()?.has(event.windowName)) {
      return;
    }
    // 窗口隐藏时，自动隐藏状态栏
    if (event.eventType == WindowEvent.EVENT_TYPE_HIDE &&
      event.eventState == WindowEvent.EVENT_STATE_END) {
      log.showInfo(`handleWindowEvent hide window: ${event.windowName}`);
      this.hideStatusbarWithDelay();
      return;
    }
    // 窗口显示时，取消自动隐藏状态栏
    if (event.eventType == WindowEvent.EVENT_TYPE_SHOW &&
      event.eventState == WindowEvent.EVENT_STATE_START) {
      log.showInfo(TAG, `handleWindowEvent show window: ${event.windowName}`);
      this.clearStatusBarTimer();
      return;
    }
  }

  private updateStatusBarLayout(screenProperty: SCBScreenProperty): void {
    this.mHeight = Math.floor(px2vp(screenProperty.height) * HOTAREA_DISTANCE);
    this.mHoverHeight = Math.floor(px2vp(screenProperty.height) * HOVER_HOTAREA_DISTANCE);
    if (this.mHeight === 0 || this.mHeight / 2 === 0) {
      this.mHeight = Math.floor(px2vp(DEFAULT_HEIGHT));
    }
    if (this.mHoverHeight < this.mHeight) {
      this.mHoverHeight = Math.floor(px2vp(DEFAULT_HOVER_HEIGHT));
    }
    if (this.mHoverHeight > MAX_HOVER_HEIGHT) {
      this.mHoverHeight = MAX_HOVER_HEIGHT;
    }
    this.touchSlop = this.mHeight / 2;
    let area: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(screenProperty.width),
      height: this.mHoverHeight
    }
    this.viewController.updateArea(area);
    this.viewController.updateRect(area);
  }

  private initGestureBar(): void {
    viewMgrPolicy.registerViewController(
      ViewType.GESTURE_TOP_BAR + this.screenProp.screenId * SCREEN_INDEX, this.viewController);
    this.viewController.updateId(this.persistentId);

    // loadContent之前vp2px无效，此处更新窗口高度
    let winRect = windowMgr.getWindowPosition(WINDOW_NAME);
    winRect.width = DisplayMgr.getCacheDisplay()?.bounds?.width;
    this.mHeight = Math.floor(px2vp(this.screenProp.height) * HOTAREA_DISTANCE);
    this.mHoverHeight = Math.floor(px2vp(this.screenProp.height) * HOVER_HOTAREA_DISTANCE);
    if (this.mHeight === 0 || this.mHeight / 2 === 0) {
      this.mHeight = Math.floor(px2vp(DEFAULT_HEIGHT));
    }
    if (this.mHoverHeight < this.mHeight) {
      this.mHoverHeight = Math.floor(px2vp(DEFAULT_HOVER_HEIGHT));
    }
    this.touchSlop = this.mHeight / 2;
    winRect.height = Math.floor(vp2px(this.mHoverHeight));
    windowMgr.updateWindowPosition(WINDOW_NAME, winRect);
    this.updateStatusBarLayout(this.screenProp);
  }

  private initPosition(): Position {
    return { x: 0, y: 0 };
  }

  screenPropertyCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.updateStatusBarLayout(screenProperty);
  }

  build() {
    Row() {
      Row()
        .position(this.initPosition())
        .width(px2vp(this.screenProp.width))
        .height(this.mHeight)
        .opacity(0)
        .onTouch((event?: TouchEvent) => this.onTouchEvent(event))
    }
    .position(this.initPosition())
    .width(px2vp(this.screenProp.width))
    .height(this.mHoverHeight)
    .opacity(0)
    .onMouse((event) => {
      if (event.action === MouseAction.Move) {
        let mouseEvent: InputEvent = event as InputEvent;
        mouseEvent.screenId = this.screenProp.screenId;
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE, mouseEvent);
      }
    })
  }

  /**
   * 触摸事件处理
   *
   * @param event 事件
   */
  private onTouchEvent(event?: TouchEvent): void {
    if (!event) {
      log.showError('touchEvent is invalid');
      return;
    }

    // oobe intercept
    if (SCBOobeManager.isOobeActivated()) {
      return;
    }
    switch (event.type) {
      case TouchType.Down:
        this.startX = event.changedTouches[0].windowX;
        this.startY = event.changedTouches[0].windowY;
        log.showDebug(`onTouchEvent touchStart, startX: ${this.startX}, startY: ${this.startY}`);
        break;
      case TouchType.Move:
        this.touchMove(event);
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        break;
    }
  }

  private touchMove(event: TouchEvent): void {
    let newY = event.changedTouches[0].windowY;
    let startY = this.startY;

    let moveY = newY - startY;
    log.showDebug(`onTouchEvent Move moveY: ${moveY}`);
    log.showDebug(`onTouchEvent touchSlop: ${this.touchSlop}`);
    // 滑动距离过小
    if (moveY < this.touchSlop) {
      log.showDebug(`onTouchEvent enter into touchSlop`);
      return;
    }
    log.showDebug(`screenProp.width is ${this.screenProp.width}, startX is ${this.startX}`);
    let mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    if (this.screenProp.screenId === mainScreenId && !viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
      MultiInputViewModel.getInstance().updateFloatingTitleFromGestureTopBar(true, this.screenProp.screenId);
      this.hideStatusbarWithDelay();
    } else if (this.screenProp.screenId !== mainScreenId) {
      MultiInputViewModel.getInstance().updateFloatingTitleFromGestureTopBar(true, this.screenProp.screenId);
      this.hideStatusbarWithDelay();
    }
  }

  private clearStatusBarTimer(): void {
    log.showInfo('clearStatusBarTimer');
    if (this.hideStatusBarTimerId > 0) {
      clearTimeout(this.hideStatusBarTimerId);
      this.hideStatusBarTimerId = 0;
    }
  }

  private hideStatusbarWithDelay(): void {
    this.clearStatusBarTimer();
    let mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    if (this.screenProp.screenId === mainScreenId) {
      log.showInfo('hideStatusbarWidthDelay');
      this.hideStatusBarTimerId = setTimeout(() => {
        MultiInputViewModel.getInstance().updateFloatingTitleFromGestureTopBar(false, this.screenProp.screenId);
      }, HIDE_STATUS_BAR_DELAY);
    } else if (this.screenProp.screenId !== mainScreenId) {
      log.showInfo('hideFloatingTitleWithDelay');
      this.hideStatusBarTimerId = setTimeout(() => {
        MultiInputViewModel.getInstance().updateFloatingTitleFromGestureTopBar(false, this.screenProp.screenId);
      }, HIDE_STATUS_BAR_DELAY);
    }
  }
}

/**
 * 增加screenId，区分是哪个屏幕的鼠标事件
 */
interface InputEvent extends MouseEvent {
  screenId: number;
}
