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

import Window from '@ohos.window';
import {
  ResUtils,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  sSCBOobeManager,
  windowMgr,
  scbEventExclusiveManager,
  EventType,
  SCBSessionRect,
  SCBSceneMode
} from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import {
  ViewArea,
  viewMgrPolicy,
  ViewType,
  localEventManager,
  SCBWindowSceneConfig,
  DeviceHelper,
  sEventManager,
  obtainLocalEvent,
  EventConstants as CommonEventConstants,
  EventManager,
  EvtBus,
  ViewCallback,
} from '@ohos/frameworkwrapper';
import { RotationConstants, SCBConstants, } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { RectItem, LogDomain, LogHelper, Trace, CommonUtils } from '@ohos/basicutils';
import display from '@ohos.display';
import { MultiInputViewModel } from '@ohos/multiinput';
import { EventConstants } from '@ohos/launchercommon/src/main/ets/constants/EventConstants';
import { SystemBarChangeType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { scbStatusBarVM } from './viewmodel/SCBStatusBarVM';
import { SystemParameterHelper } from '@ohos/systemuicommon/src/main/ets/utils/SystemParameterHelper';
import { ScenePanelState } from '../scenemanager/SCBScenePanel';
import { MmiTestRunningManager } from './common/MmiTestRunningManager';
import { AbilityState, ForegroundAppEvent,
  NotifyStatusBarShowHideEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ScreenRecordSensorVm, ScreenRecordSensorStatus, ScreenRecordSensorOpacity } from './viewmodel/ScreenRecordSensorVm'
import { ForbiddenGestureVm } from './viewmodel/ForbiddenGestureVm';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';

const TAG = 'GestureTopBar-Index'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const gestureTopBarBackgroundColor: string = '#00000000';
const sScreenRecordSensorVm = ScreenRecordSensorVm.get();

/**
 * 最小滑动距离
 */
const TOUCH_SLOP = 20;

/**
 * 窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_GESTURE_TOP_BAR;
const TITLE_RESPONSE_WIDTH = 172;
const TITLE_RESPONSE_HEIGHT = 32;
const OUTER_HOME_EXTRA_HEIGHT = 4;

@Component
export struct SCBGestureTopBar {
  @StorageLink('scenePanelState') scenePanelState: ScenePanelState = ScenePanelState.HOME;
  @State viewController: BaseViewController = new BaseViewController(ViewType.GESTURE_TOP_BAR);
  @State mScreenRecordSensorStatus: ScreenRecordSensorStatus = sScreenRecordSensorVm.getScreenRecordSensorStatus();
  @State mScreenRecordSensorOpacity: ScreenRecordSensorOpacity = sScreenRecordSensorVm.getScreenRecordSensorOpacity();
  @Link screenProp: SCBScreenProperty;
  persistentId: number = 0;
  startX: number = 0
  startY: number = 0
  speed: number = 0
  lastY: number = 0
  displayHeight: number = 0
  rotateAngle: number = 0;

  private isShowedStatusBar: boolean = false;

  /**
   * 判断设备是否为折叠态（直板机状态为非折叠态）
   */
  private isFolded: boolean = this.getFolded(display.getFoldStatus());
  /**
   * DFX-DFM产线模式
   */
  private isFactoryMode: boolean = SystemParameterHelper.getCompareResult('const.runmode', 'normal', 'factory');
  
  private mmiTestRunningManager: MmiTestRunningManager = new MmiTestRunningManager();
  /**
   * 是否正在发送touch事件
   */
  private isPublishTouchEvent: boolean = false;
  /**
   * 应用是否在前台
   */
  private isAppForegroundForVerde: boolean = false;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * topbar出现消失回调
   */
  private viewCallback?: ViewCallback;

  onBackPress(): boolean {
    return true;
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear, start');
    this.viewCallback = {
      onShow: this.onViewShow,
      onHide: this.onViewHide
    };
    this.viewController.registerCallback(this.viewCallback);
    viewMgrPolicy.registerViewController(ViewType.GESTURE_TOP_BAR, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    try {
      log.showInfo('SetSnapshotSkip');
      SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.session?.setSnapshotSkip(true);
    } catch (err) {
      log.showError('SetSnapshotSkip failed, reason: ' + err.message);
    }

    // loadContent之前vp2px无效，此处更新窗口高度
    let winRect: Window.Rect = windowMgr.getWindowPosition(WINDOW_NAME);
    winRect.height = vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));
    winRect.width = this.screenProp.width;
    windowMgr.updateWindowPosition(WINDOW_NAME, winRect);
    windowMgr.startBindWinAnimOnFrame(WINDOW_NAME);
    this.initDisplayHeight();
    sScreenRecordSensorVm.init();

    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        this.rotateAngle = screenProperty.rotation;
        log.showInfo(`rotateAngle is ${this.rotateAngle}`);
        // relative position with screen
        let area: ViewArea = {
          left: 0,
          top: 0,
          width: px2vp(screenProperty.width),
          height: ResUtils.getNumber($r('app.float.status_bar_phone_height'))
        }
        log.showInfo(`area left: ${area.left}, top: ${area.top}, width: ${area.width}, height: ${area.height}`);
        this.viewController.updateArea(area);
        this.viewController.updateRect(area);
        // 热区赋值
        let region: Rectangle[] = [];
        let rect: Rectangle = {
          x: 0,
          y: 0,
          width: screenProperty.width,
          height: vp2px(this.getResponseHeight())
        };
        region.push(rect);
        this.viewController.setResponseRegion(region);
        this.displayHeight = Number(area.width) * this.screenProp.height / this.screenProp.width;
      });
    // 折叠屏状态监听
    try {
      display.on('foldStatusChange', this.folderStatusChangeCallback);
    } catch (error) {
      log.showError(`register fold change listener failed: ${error?.code}`);
    }
    // 监听应用前后台状态改变
    this.eventMgr.on(ForegroundAppEvent, this.onForegroundAppEvent);
  }

  private initDisplayHeight() {
    if (this.screenProp.width <= 0) {
      log.showError(`screen prop width(${this.screenProp.width}) is invalid.`);
      return;
    }
    try {
      this.displayHeight = display.getDefaultDisplaySync().width * this.screenProp.height / this.screenProp.width;
    } catch (err) {
      log.showError(`getDefaultDisplaySync failed, message : ${err.message}, code : ${err.code}`);
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    //注销折叠屏状态监听
    try {
      display.off('foldStatusChange', this.folderStatusChangeCallback);
    } catch (error) {
      log.showError(`unRegister fold change listener failed: ${error?.code}`);
    }
    sScreenRecordSensorVm.unInit();
  }

  /**
   * 判断设备是否是折叠态
   */
  private getFolded(foldStatus: display.FoldStatus): boolean {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      return true;
    }
    return false;
  }

  private folderStatusChangeCallback = (newFoldStatus: display.FoldStatus) => {
    this.isFolded = this.getFolded(newFoldStatus);
    log.showInfo(`folderStatusChangeCallback newFoldStatus: ${newFoldStatus}, isFolded: ${this.isFolded}`);
  };

  /**
   * 是否横屏
   *
   * @return true横屏
   */
  private isDisplayLand(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_90 || this.rotateAngle === RotationConstants.ROTATION_270;
  }

  /**
   * 坐标大小是否反转
   *
   * @return true反转
   */
  private isDisplayReverse(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_180 || this.rotateAngle === RotationConstants.ROTATION_270;
  }

  build() {
    Row() {
      Circle()
        .fill(this.mScreenRecordSensorStatus.backgroundColor)
        .width(CommonUtils.spliceVp(sScreenRecordSensorVm.screenRecordSensorSize))
        .height(CommonUtils.spliceVp(sScreenRecordSensorVm.screenRecordSensorSize))
        .opacity(this.mScreenRecordSensorOpacity.opacity)
        .position({
          x: CommonUtils.spliceVp(this.mScreenRecordSensorStatus.paddingLeft),
          y: CommonUtils.spliceVp(this.mScreenRecordSensorStatus.positionY)
        })
    }
    .position(this.initPosition())
    .width(px2vp(this.screenProp.width))
    .height(this.getResponseHeight())
    .backgroundColor(gestureTopBarBackgroundColor)
    .hitTestBehavior(HitTestMode.Transparent)
    .onTouch((event?: TouchEvent) => this.onTouchEvent(event))
  }

  private getResponseHeight(): number {
    let defaultHeight: number = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
    return defaultHeight;
  }

  private initPosition(): Position {
    return { x: 0, y: 0 };
  }

  private handleTouchEventForPad(posX: number, posY: number): void {
    if (uiType != SCBConstants.UITYPE_PAD) {
      return;
    }
    let x: number = (this.screenProp.width - vp2px(TITLE_RESPONSE_WIDTH)) / 2;
    let titleBarRegion: SCBSessionRect =
      new SCBSessionRect(x, 0, vp2px(TITLE_RESPONSE_WIDTH), vp2px(TITLE_RESPONSE_HEIGHT));
    if (titleBarRegion.contains(posX, posY)) {
      let topSession = SCBSceneSessionManager.getInstance().getContainerSessionList().getTopActiveSession();
      if (topSession?.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN && !this.isShowedStatusBar) {
        SCBSceneSessionManager.getInstance()
          .notifyImmersiveSceneTitleBarStateChange(topSession?.primarySession?.sceneInfo.persistentId);
      }
    }
  }

  /**
   * 应用前台
   */
  private onForegroundAppEvent = (event?: ForegroundAppEvent): void => {
      return;
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
    this.publishEventToStatusbar(event);
    // oobe intercept
    if (sSCBOobeManager.isEnable()) {
      return;
    }
    // DFX-DFM产线模式下
    if (this.isFactoryMode) {
      log.showInfo('now is isDFXDFMLineMode, disable the drop-down top bar!');
      return;
    }
    // 手势防误触开启时，屏蔽手写笔的下拉呼出状态栏
    if (event.sourceTool === SourceTool.Pen && ForbiddenGestureVm.instance.isForbiddenGestureEnable()) {
      log.showInfo('isForbiddenGestureEnable = true!');
      return;
    }

    if (this.mmiTestRunningManager.checkIsMmiTestRunningForbidden(event, 'topBarOnTouchEvent')) {
      return;
    }

    switch (event.type) {
      case TouchType.Down:
        log.showInfo('onTouchEvent Down');
        Trace.start(Trace.CORE_METHOD_START_TOUCH_EVENT);
        this.startX = event.changedTouches[0].screenX;
        this.startY = event.changedTouches[0].screenY;
        this.handleTouchEventForPad(vp2px(this.startX), vp2px(this.startY));
        this.isShowedStatusBar = false;
        log.showWarn(`onTouchEvent touchStart, startX: ${this.startX}, startY: ${this.startY}`);
        break;
      case TouchType.Move:
        this.touchMove(event);
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        log.showInfo('onTouchEvent touchEnd');
        this.isShowedStatusBar = false;
        Trace.end(Trace.CORE_METHOD_START_TOUCH_EVENT);
        break;
    }
  }

  /**
   *
   * @param event
   */
  private publishEventToStatusbar(event?: TouchEvent): void {
      return;
  }

  private touchMove(event: TouchEvent): void {
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_TOPBAR_MOVE)) {
      return;
    }
    let newY = event.changedTouches[0].screenY;
    let startY = this.startY;

    let moveY = newY - startY;
    log.showDebug(`onTouchEvent Move moveY: ${moveY}`);
    // 滑动距离过小
    if (moveY < TOUCH_SLOP) {
      return;
    }
    log.showInfo(`screenProp.width is ${this.screenProp.width}, startX is ${this.startX}`);
    if (!viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
      SCBSceneSessionManager.getInstance().setIsShowStatusBarTemporary(true);
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      // move达到2.25s状态栏消失后不会再重新显示状态栏导致状态栏闪烁
      if (this.isShowedStatusBar) {
        return;
      }
      this.isShowedStatusBar = true;
      if (SCBSceneSessionManager.getInstance().isPcMode()) {
        MultiInputViewModel.getInstance().updateStatusAndFloatingTitleFromGestureTopBar(true);
      } else {
        InnerEventUtil.post(NotifyStatusBarShowHideEvent, new NotifyStatusBarShowHideEvent(true, true));
        localEventManager.sendLocalEvent(EventConstants.SYSTEM_BAR_CHANGE, SystemBarChangeType.AI_BAR_IMMERSE_TASK);
      }
    }
  }

  private onViewShow = (): void => {
    log.showInfo('onShow is coming');
    sScreenRecordSensorVm.onViewChange(true);
  }
  private onViewHide = (): void => {
    log.showInfo('onHide is coming');
    sScreenRecordSensorVm.onViewChange(false);
  }
}
