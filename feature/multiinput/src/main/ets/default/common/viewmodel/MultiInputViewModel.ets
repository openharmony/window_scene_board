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

import {
  LogDomain,
  LogHelper,
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  DomainName,
  TraceUtil,
  SingletonHelper
} from '@ohos/basicutils';
import {
  localEventManager,
  sOutSideWindowMgr,
  viewMgrPolicy,
  DeviceHelper,
  DropDownPanelManagerWrapper,
  GlobalContext,
  GlobalSearchStatus,
  HiSysEventUtil,
  PluginSlot,
  PluginPosition,
  SCBWindowSceneConfig,
  ViewController,
  ViewManagerPolicy,
  ViewType,
  WindowPositionChangeEvent,
  EvtBus
} from '@ohos/frameworkwrapper';
import { ExtAppConstants, SCBConstants, WindowConstants } from '@ohos/commonconstants';
import {
  SCBSpecificSessionSource,
  FocusChangeReason,
  INVALID_SCREEN_ID,
  sSampleManager,
  ResUtils,
  StartAbilityUtil,
  ScenePanelState,
  SCBSceneContainerSessionArray,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSpecificSession,
  windowMgr,
  SCBSceneMode,
  SCBSystemSceneSession,
  SCBKeyboardSession,
  SCBKeyboardManager,
  SCBSessionEventId,
  SCBOobeManager,
  SCBScreenSessionManager,
  ControlType
} from '@ohos/windowscene';
import type { SCBSceneContainerSession } from '@ohos/windowscene';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import screenSessionManager from '@ohos.screenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import EventConstants from '../constants/EventConstants';
import { multiInputManager } from '../MultiInputManager';
import { MouseEvent } from '@ohos.multimodalInput.mouseEvent';
import { Action } from '@ohos.multimodalInput.mouseEvent';
import { LayoutViewModel, FormCenterViewManager } from '@ohos/launchercommon';
import { styleMgr } from '@ohos/systemuicommon';
import Constants from '../constants/Constants';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import commonEventManager from '@ohos.commonEventManager';
import type common from '@ohos.app.ability.common';
import rpc from '@ohos.rpc';
import inputMethod from '@ohos.inputMethod';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import {
  screenLockInnerStateManager as screenLockStateManager
} from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockInnerStateManager';
import settings from '@ohos.settings';
import { BusinessError } from '@ohos.base';
import audio from '@ohos.multimedia.audio';
import { TimerUtil } from '../util/TimerUtil';
import { MultimodalInputManager } from '@ohos/systemuicommon';
import { MultiInputRecentProxy } from './MultiInputRecentProxy';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { osAccount, screenLock } from '@kit.BasicServicesKit';
import { ReceiveEventInfo, VisibleInfo } from '../constants/ReceiveEventInfo';
import context from '@ohos.app.ability.common';
import { OpenLinkOptions } from '@kit.AbilityKit';

const TAG = 'MultiInputViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DELAY_CALL_OUT_DOCK_MS = 100; // Delayed calling out the dock to prevent accidental touch
const DELAY_TIME_SHOW_APP_CENTER_WHEN_NEED_EXIT_RECENT = 400;
const TITLE_POPUP_DISTANCE = 37;
const C_SIDE_TITLE_HOT = 30;
const HOTAREA_DISTANCE = 0.002;
const TRIGGER_TYPE = 'trigger_type';
const SHOT_TYPE = 'shot_type';
let callOutDelayTimer: number | null = null;
const ENTER_RECENT_DELAY = 220;
const PLUGIN_TOGGLE_CLICK_CODE = 1001;
const PUBLISH_EVENT_CAST_DISCONNECTED: string = 'ohcast.event.CAST_DISCONNECTED';
const SCREEN_LOCK_WALL_PAPER_ZINDEX = 1999;
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

/**
 * MultiInput Model
 */
export class MultiInputViewModel {
  private mLayoutViewModel: LayoutViewModel;
  public dockHeight: number = 0;
  private altTabCount: number = -1;
  private timerId: number = -1;
  private hosKeyShowCallbacks: Array<Function> = [];
  private eventNotCloseShcutPannel: string[] = [
    EventConstants.EVENT_FN_BRIGHTNESS_DOWN,
    EventConstants.EVENT_FN_BRIGHTNESS_UP,
    EventConstants.EVENT_FN_MUTE,
    EventConstants.EVENT_FN_MEDIA_RECORD,
    EventConstants.EVENT_WIN_UP,
    EventConstants.EVENT_TAB_UP,
    EventConstants.EVENT_WIN_SLASH,
    EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE,
    EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE,
    EventConstants.EVENT_WIN_SPACE_UP,
    EventConstants.EVENT_WIN_SHIFT_S,
    EventConstants.EVENT_WIN_SHIFT_R
  ];
  private eventNotCloseFAPanel: string[] = [
    EventConstants.EVENT_WIN_SHIFT_S,
    EventConstants.EVENT_WIN_SHIFT_R,
    EventConstants.EVENT_FN_MEDIA_RECORD,
    EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE,
  ];
  private mFirstFullOrSplitContainer: SCBSceneContainerSession | null = null;
  private mTopFullScreenSubSession: SCBSpecificSession | null = null;
  private mIsSplit: boolean = false;
  private mHideTitleSessionList: Set<SCBSceneContainerSession> = new Set();
  private deskGestureParam: number = Constants.DEFAULT_DESK_GESTURE_PARAM;
  private statusBarVisibleCallback: Function | null = null;
  // only for pcmode
  private isPreventHideTitleBar: boolean = false;
  private currentMouseEvent: MouseEvent | null = null;
  private recentAndAppCenterSwitchTimer: TimerUtil = SingletonHelper.getInstance(TimerUtil,
    Constants.RECENT_AND_APP_CENTER_SWITCH_TIMER);
  // 由于多模无法识别组合键 标注是否是组合键
  public isHandleWinEvent: boolean = false;
  // 用于判断沉浸式场景鼠标从标题栏平移到另一个屏幕的场景
  private lastScreenId: number | undefined = undefined;

  private constructor() {
    this.registerMultiInputEvent();
    this.mLayoutViewModel = LayoutViewModel.getInstance();
    this.dockHeight = vp2px(this.mLayoutViewModel.getDockHeight());
    this.getDeskGestureParam();
    try {
      this.registerKeyObserver();
    } catch (error) {
      log.showError(`Failed to registerKeyObserver, error:  ${error?.message}`);
    }
  }


  /**
   * Obtains the multiinput data model object.
   *
   * @return MultiInputModel
   */
  static getInstance(): MultiInputViewModel {
    if (globalThis.MultiInputViewModel == null) {
      globalThis.MultiInputViewModel = new MultiInputViewModel();
    }
    return globalThis.MultiInputViewModel;
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: object): void => {
      const isLocked: boolean = ScreenLockApi.getLock();
      const isOobeEnable: boolean = SCBOobeManager.isOobeActivated();
      let isCtrlAltDelPanelShow: boolean = AppStorage.get<boolean>('isCtrlAltDelPanelShow') ?? false;
      log.showInfo(`localEventListener receive event: ${event}, isOobeEnable: ${isOobeEnable}, isLocked: ${isLocked},` +
        `isCtrlAltDelPanelShow: ${isCtrlAltDelPanelShow}`);
      multiInputManager.hisearchShortcutExcuted = viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH);
      if (isLocked || isOobeEnable || SCBSceneSessionManager.getInstance().isScreenLocked() ||
      sSampleManager.isSampleManagerChecked() || isCtrlAltDelPanelShow) {
        return;
      }
      let isHandleThreeFingersSwipe: boolean = SCBSceneSessionManager.getInstance().getIsHandleThreeFingerSwiper();
      let isHandMultiPinch: boolean | undefined = AppStorage.get('isHandMultiPinch');
      if (isHandleThreeFingersSwipe || isHandMultiPinch) {
        log.showInfo('not handle multi input event for isHandleThreeFingersSwipe:' + isHandleThreeFingersSwipe +
          ', isHandMultiPinch:' + isHandMultiPinch);
        return;
      }
      this.isHandleWinEvent = true;
      this.handleCloseShcutPannel(event);
      this.handleCloseFAPanel(event);
      this.judgeEvent(event, params);
      this.judgeEventExt(event, params);
      this.judgeEventFnKey(event, params);
      this.handleSpecialEvent(event, params);
      this.judgeMetaEventExt(event, params);
    }
  };

  private judgeEvent(event: string, params: object): void {
    switch (event) {
      case EventConstants.EVENT_WIN_SHIFT_R:
        this.winShiftRCallBack();
        break;
      case EventConstants.EVENT_WIN_SHIFT_S:
      case EventConstants.EVENT_FN_SYSRQ:
        this.winShiftSCallBack();
        break;
      case EventConstants.EVENT_WIN_S:
        this.searchPanelChangeCallBack(event);
        break;
      case EventConstants.EVENT_FN_SEARCH:
        this.searchPanelChangeCallBack(event);
        break;
      case EventConstants.EVENT_ALT_TAB:
        this.altTabCallBack();
        break;
      case EventConstants.EVENT_WIN_TAB:
        this.winTabCallBack();
        break;
      case EventConstants.EVENT_WIN_UP:
        this.winUpCallBack();
        break;
      case EventConstants.EVENT_WIN_D:
        this.winDCallBack();
        break;
      case EventConstants.EVENT_ALT_UP:
        this.altUpCallBack();
        break;
      case EventConstants.EVENT_TAB_UP:
        this.tabUpCallBack();
        break;
      case EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE:
        this.updateStatusAndFloatingTitle(params as MouseEvent);
        this.dockDisplayStatusChangeCallback(params as MouseEvent);
        break;
      case EventConstants.EVENT_WIN_SLASH:
        this.winSlashCallBack();
        break;
      case EventConstants.EVENT_WIN_L:
        this.winLCallBack();
        break;
      default:
        break;
    }
  }

  private judgeEventExt(event: string, params: object): void {
    switch (event) {
      case EventConstants.EVENT_WIN_N:
        this.winNCallBack();
        break;
      case EventConstants.EVENT_WIN_C:
        this.winCCallBack();
        break;
      case EventConstants.EVENT_WIN_A:
        this.winACallBack();
        break;
      case EventConstants.EVENT_WIN_M:
        this.winMCallBack();
        break;
      case EventConstants.EVENT_ALT_F4:
        this.altF4CallBack();
        break;
      case EventConstants.EVENT_ALT_SHIFT_F4:
        this.exitApplicationCallBack(event);
        break;
      case EventConstants.EVENT_WIN_F:
        this.winFCallBack();
        break;
      case EventConstants.EVENT_CTRL_SHIFT_ESC:
        this.winOpenTaskManagerCallBack();
        break;
      case EventConstants.EVENT_WIN_SPACE_UP:
        HiSysEventUtil.reportKey(event);
        break;
      case EventConstants.EVENT_CTRL_SHIFT:
        HiSysEventUtil.reportKey(event);
        break;
      case EventConstants.EVENT_WIN_BACKSPACE:
        this.winBackSpaceCallBack();
        break;
      case EventConstants.EVENT_FN_BROWSER:
        this.browserCallBack();
        break;
      case EventConstants.EVENT_FN_CALCULATOR:
        this.calculatorCallBack();
        break;
      case EventConstants.EVENT_FN_MUSIC:
        this.configCallBack();
        break;
      case EventConstants.EVENT_FN_EMAIL:
        this.emailCallBack();
        break;
      default:
        break;
    }
  }

  private judgeEventFnKey(event: string, params: object): void {
    switch (event) {
      case EventConstants.EVENT_FN_BRIGHTNESS_DOWN:
        HiSysEventUtil.reportKey(event);
        break;
      case EventConstants.EVENT_FN_BRIGHTNESS_UP:
        HiSysEventUtil.reportKey(event);
        break;
      case EventConstants.EVENT_FN_MUTE:
        this.fnMicMuteCallBack();
        break;
      case EventConstants.EVENT_FN_SWITCHVIDEOMODE:
        this.fnSwitchVideoModeCallBack();
        break;
      case EventConstants.EVENT_FN_MEDIA_RECORD:
        this.fnMediaRecordCallBack();
        break;
    }
  }

  private judgeMetaEventExt(event: string, params: object): void {
    switch (event) {
      case EventConstants.EVENT_WIN_DPAD_UP:
        this.winDpadUpCallBack();
        break;
      case EventConstants.EVENT_WIN_DPAD_DOWN:
        this.winDpadDownCallBack();
        break;
      case EventConstants.EVENT_WIN_DPAD_LEFT:
        this.winDpadLeftCallBack();
        break;
      case EventConstants.EVENT_WIN_DPAD_RIGHT:
        this.winDpadRightCallBack();
        break;
      default:
        break;
    }
  }

  private findMainSceneSessionForFocusedScene(
    focusedSession: SCBSpecificSession | SCBSceneSession | SCBSystemSceneSession):
  SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession {
    if (focusedSession instanceof SCBSceneSession) {
      return focusedSession;
    }
    let sceneSessionID: number = focusedSession.session.parentId;
    let parentSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSessionById(sceneSessionID);
    if (parentSession === undefined || parentSession === null) {
      return focusedSession;
    }
    return this.findMainSceneSessionForFocusedScene(parentSession);

  }

  private handleSpecialEvent(event: string, params: object): void {
    switch (event) {
      case EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE:
        this.dockDisplayVisibleChangeCallback(params as VisibleInfo);
        break;
    }
  }

  private exitApplicationCallBack(event: string): void {
    log.showInfo('exitApplicationCallBack');
    if (this.isSpilt()) {
      return;
    }
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if (focusedSession === undefined || focusedSession === null || !(focusedSession instanceof SCBSceneSession)) {
      return;
    }
    log.showDebug(`altF4CallBack, focusedSession: ${JSON.stringify(focusedSession)}`);
    if (focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_APP &&
      focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_SUB_APP) {
      log.showInfo('not app, return');
      return;
    }
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (containerSessionList === undefined || containerSessionList === null) {
      return;
    }
    HiSysEventUtil.reportKey(event);
    if (this.closePadPairedSplitScene(focusedSession)) {
      log.showInfo('close pad double split scene, return');
      return;
    }
    let sessionList: SCBSceneSession[] = [];
    for (const scene of containerSessionList) {
      if (scene.primarySession && focusedSession.sceneInfo.bundleName === scene.primarySession.sceneInfo.bundleName) {
        sessionList.push(scene.primarySession);
      }
      if (scene.secondarySession &&
        focusedSession.sceneInfo.bundleName === scene.secondarySession.sceneInfo.bundleName) {
        sessionList.push(scene.secondarySession);
      }
    }
    for (const session of sessionList) {
      try {
        SCBSceneSessionManager.getInstance().asyncPrepareTerminate(session.sceneInfo.persistentId,
          (err, isPrepareTerminate) => {
            if (isPrepareTerminate) {
              log.showInfo(`isPrepareTerminate: ${isPrepareTerminate}, persistentID: ${session.sceneInfo.persistentId}`);
              return;
            }
            log.showError(`[ERROR]PrepareTerminate Callback:${err}`);
            SCBSceneSessionManager.getInstance().close(session.sceneInfo.screenId, session.sceneInfo.persistentId);
          });
      } catch (error) {
        log.showError(`[ERROR]asyncPrepareTerminate: ${error}`);
      }
    }
    localEventManager.sendLocalEvent(EventConstants.EVENT_REQUEST_DOCK_CTRL_Q_CALLBACK, focusedSession.sceneInfo);
  }

  private searchPanelChangeCallBack(event: string): void {
    log.showInfo('searchPanelChangeCallBack');
    if (DeviceHelper.isPC()) {
      MultimodalInputManager.dealWithShortcutKeyInFA = true;
      this.closeAll();
      this.exitActiveSplit();
      this.hideNotifyContolCenter();
      this.hideStatusBarPanel();
      AppStorage.setOrCreate('showRecent', false);
      if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
        if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
          let hideAppCenterWithAnimation = (GlobalContext.getInstance()
            .getObject('hideAppCenterWithAnimation')) as Function;
          if (hideAppCenterWithAnimation) {
            hideAppCenterWithAnimation();
          }
        }
      }
      HiSysEventUtil.reportKey(event);
      performanceMonitor.begin('PC_SHORTCUT_GLOBAL_SEARCH', performanceMonitor.ActionType.LAST_DOWN);
      performanceMonitor.begin(HiSysEventUtil.INTO_SEARCH, performanceMonitor.ActionType.LAST_DOWN);
      if (DeviceHelper.is2In1DevicePcType()) {
        this.changeGlobalSearchStateInDevicePcType();
      } else {
        const wantInfo: Want = {
          bundleName: 'com.ohos.hisearch',
          abilityName: 'MainAbility',
        };
        try {
          (getContext() as common.UIAbilityContext).startAbility(wantInfo);
        } catch (error) {
          log.showError(`[ERROR]startAbilit: ${error}`);
        }
      }
    } else if (DeviceHelper.isPad() || DeviceHelper.isThreeFoldProduct()) {
      let scenePanelState: ScenePanelState | undefined = AppStorage.get('scenePanelState');
      if (scenePanelState === ScenePanelState.FULLSCENE) {
        return;
      }
      HiSysEventUtil.reportKey(event);
      this.closeAll();
      this.hideStatusBarPanel();
      const lastGlobalSearchState = sOutSideWindowMgr.isShowGlobalSearch();
      const isDropDownViewShow: boolean = viewMgrPolicy.isViewShowing(ViewType.DROPDOWN);
      const isGlobalSearchViewShow: boolean = viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH);
      if (isDropDownViewShow) {
        DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
      }
      AppStorage.setOrCreate('showRecent', false);
      if (lastGlobalSearchState === true && isGlobalSearchViewShow && !isDropDownViewShow &&
        scenePanelState !== ScenePanelState.RECENT) {
        this.hideGlobalSearch();
      } else if (lastGlobalSearchState === false || isGlobalSearchViewShow === false) {
        this.showGlobalSearch();
      }
    }
  }

  private changeGlobalSearchStateInDevicePcType(): void {
    const lastGlobalSearchState = sOutSideWindowMgr.isShowGlobalSearch();
    const isGlobalSearchViewShow: boolean = viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH);
    if (lastGlobalSearchState && isGlobalSearchViewShow) {
      this.hideGlobalSearch();
    } else if (!lastGlobalSearchState || !isGlobalSearchViewShow) {
      this.showGlobalSearch();
    }
  }

  private handleCloseShcutPannel(event: string): void {
    if (this.eventNotCloseShcutPannel.includes(event)) {
      return;
    }
    this.closeShortcutkeyPanel();
  }

  private handleCloseFAPanel(event: string): void {
    if (DeviceHelper.isPad()) {
      if (this.eventNotCloseFAPanel.includes(event)) {
        return;
      }
      FormCenterViewManager.getInstance().closeFormCenterView();
      return;
    }
  }

  private dockDisplayVisibleChangeCallback(param: VisibleInfo): void {
    if (CheckEmptyUtils.isEmpty(param)) {
      return;
    }
    const dockShow: boolean = param.isVisible;
    if (param?.screenId !== undefined && SCBSceneSessionManager.getInstance().mainScreenId !== param.screenId) {
      log.showInfo(`dockDisplayVisibleChangeCallback ignore extScreen event, screenId: ${param.screenId}`);
      return;
    }
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || AppStorage.get('showRecent')) {
      log.showInfo('app_center or recent showing, dock not change');
      return;
    }
    if (DeviceHelper.isPC()) {
      let curScreenId = param?.screenId === undefined ? SCBSceneSessionManager.getInstance().mainScreenId :
        param?.screenId;
      if (SCBSceneSessionManager.getInstance().isScenePanelInState(curScreenId, ScenePanelState.SPLIT)) {
        log.showInfo('split, dock not change');
        return;
      }
    }
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (sessionList === undefined || sessionList === null) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    let canUpdateDock = this.canUpdateSmartDockForSubWindow(sessionList,
      SCBSceneSessionManager.getInstance().mainScreenId) || this.canUpdateSmartDock(sessionList);
    log.showInfo(`dockDisplayVisibleChangeCallback ${dockShow}, canUpdateDock: ${canUpdateDock}`);
    if (canUpdateDock && dockShow) {
      log.showInfo('dockDisplayVisibleChangeCallback callOutDockWithDelay');
      this.callOutDockWithDelay(DELAY_CALL_OUT_DOCK_MS);
      return;
    }

    this.clearCallOutDelayTimer();
    if (!dockShow && canUpdateDock) {
      this.callHideSmartDock();
      return;
    }
  }

  /**
   * pad pc模式dock隐藏后, 判断鼠标是否在屏幕底部2px热区, 在就显示dock
   * @param mouseEvent 鼠标事件
   * @returns
   */
  private isInDockVisibleRegion(mouseEvent: MouseEvent): boolean {
    const screenHeight: number = vp2px(this.mLayoutViewModel?.getScreenHeight());
    const dockMouseDelta: number = 2;
    return mouseEvent?.screenY >= (screenHeight - dockMouseDelta);
  }

  private dockDisplayStatusChangeCallback(mouseEvent: MouseEvent): void {
    if (CheckEmptyUtils.isEmpty(mouseEvent)) {
      return;
    }
    this.currentMouseEvent = mouseEvent;
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || AppStorage.get('showRecent')) {
      log.showInfo('app_center or recent showing, dock not change');
      return;
    }
    if (SCBSceneSessionManager.getInstance().isPcOrPcMode()) {
      let isSplit: boolean | undefined = AppStorage.get('split');
      if (isSplit) {
        log.showInfo('split, dock not change');
        return;
      }
    }
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (sessionList === undefined || sessionList === null) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    //split scene or pc layoutfullscreen can update dock
    let canUpdateDock = this.canUpdateSmartDockForSubWindow(sessionList,
      SCBSceneSessionManager.getInstance().mainScreenId) || this.canUpdateSmartDock(sessionList, mouseEvent?.screenY);
    log.showInfo(`canUpdateDock: ${canUpdateDock}`);
    let screenHeight = vp2px(this.mLayoutViewModel?.getScreenHeight());
    this.dockHeight = vp2px(this.mLayoutViewModel?.getDockHeight());
    if (!viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK) && canUpdateDock &&
    this.isInDockVisibleRegion(mouseEvent)) {
      this.callOutDockWithDelay(DELAY_CALL_OUT_DOCK_MS);
      return;
    }

    if (mouseEvent.screenY >= (screenHeight - this.dockHeight)) {
      return;
    }

    this.clearCallOutDelayTimer();
    if (viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK) &&
      mouseEvent.screenY < (screenHeight - this.dockHeight) &&
      canUpdateDock) {
      this.callHideSmartDock();
      return;
    }
  }

  private callHideSmartDock(): void {
    log.showInfo('dockDisplayStatusChangeCallback callHideSmartDock');
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || AppStorage.get('showRecent')) {
      // 任务中心或者应用中心界面不隐藏
      log.showInfo('app_center or recent showing, dock not hide');
      return;
    }
    if (GlobalContext.getInstance().hasObject('hideDockViewWithAnimation')) {
      let hideDockViewWithAnimation = (GlobalContext.getInstance().getObject('hideDockViewWithAnimation')) as Function;
      hideDockViewWithAnimation();
    } else {
      viewMgrPolicy.hideView(ViewType.SMART_DOCK);
    }
  }

  private updateStatusAndFloatingTitle(mouseEvent: MouseEvent): void {
    this.mTopFullScreenSubSession = null;
    if (!DeviceHelper.isPC()) {
      return;
    }

    let curScreenId = mouseEvent.screenId;
    if (this.lastScreenId === undefined) {
      this.lastScreenId = curScreenId;
    }
    let isAppCenterShow: boolean = curScreenId !== SCBSceneSessionManager.getInstance().mainScreenId ?
      viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT) : viewMgrPolicy.isViewShowing(ViewType.APP_CENTER);
    let isDropDown: boolean = viewMgrPolicy.isViewShowing(ViewType.DROPDOWN);
    let notShowStatus: boolean = isAppCenterShow || AppStorage.get('showRecent') || isDropDown ||
    SCBSceneSessionManager.getInstance().isScenePanelInState(curScreenId, ScenePanelState.SPLIT);
    if (CheckEmptyUtils.isEmpty(mouseEvent) || notShowStatus) {
      return;
    }

    log.showInfo(`updateStatusAndFloatingTitle curScreenId:${curScreenId}`);
    let sessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(curScreenId);
    if (sessionList === undefined || sessionList === null) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, curScreenId);
    let statusHeight = this.getStatusHeight(systemSceneSession);
    let floatingTitleHeight = vp2px(TITLE_POPUP_DISTANCE);
    const screenHeight: number | undefined = AppStorage.get('screenHeight');
    let popupHotArea = vp2px((screenHeight ? screenHeight : 0) * HOTAREA_DISTANCE);
    let canUpdateStatusBar = this.canUpdateStatusBar(sessionList, curScreenId);
    let isStatusBarVisiable = viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR);
    let mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    log.showInfo(`statusbar visiable :${isStatusBarVisiable}, floatingTitleHeight:${floatingTitleHeight},\
    canUpdateStatusBar:${canUpdateStatusBar}, mouseEvent.screenY:${mouseEvent.screenY}, popupHotArea:${popupHotArea},\
    curScreenId:${curScreenId}, mainScreenId:${mainScreenId}`);
    if (mouseEvent.screenY <= popupHotArea && (!isStatusBarVisiable ||
      curScreenId !== mainScreenId) && canUpdateStatusBar) {
      this.hoverShowStatusBarAndTitle(systemSceneSession, statusHeight);
      if (systemSceneSession === null) {
        this.registerOrRecoverMouseEvent(true);
      }
      if (curScreenId === this.lastScreenId) {
        return;
      }
    }
    this.isPreventHideTitleBar = true;
    let floatingTitleRealHeight = 0;
    if (this.mFirstFullOrSplitContainer?.primarySession?.getRealLayoutFullScreen() ||
    this.mFirstFullOrSplitContainer?.primarySession?.sessionData.isMaximizeFullScreen) {
      floatingTitleRealHeight = floatingTitleHeight;
    }
    if (this.canHideStatusBar(systemSceneSession, sessionList, curScreenId) && mouseEvent.screenY >
      (statusHeight + floatingTitleRealHeight) && curScreenId === this.lastScreenId) {
      this.isPreventHideTitleBar = false;
      this.hoverHideStatusBarAndTitle(systemSceneSession, statusHeight, mouseEvent);
      return;
    }
    if (curScreenId === this.lastScreenId) {
      return;
    }
    let lastSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(this.lastScreenId);
    let lastSystemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, this.lastScreenId);
    if (lastSessionList === undefined || lastSessionList === null) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    if (this.canHideStatusBar(lastSystemSceneSession, lastSessionList, this.lastScreenId)) {
      this.hoverHideStatusBarAndTitle(lastSystemSceneSession, statusHeight, mouseEvent);
    }
    if (this.lastScreenId !== undefined) {
      this.lastScreenId = curScreenId;
    }
  }

  private canHideStatusBar(systemSceneSession: SCBSystemSceneSession,
    sessionList: SCBSceneContainerSessionArray, curScreenId: number): boolean {
    const isTitleShownForHover = systemSceneSession === null ? true :
      SCBSceneSessionManager.getInstance().getIsStatusBarShownForHover();
    const canUpdateStatusBar = this.canUpdateStatusBar(sessionList, curScreenId);
    const isStatusBarRightMenuOpen: boolean | undefined = AppStorage.get('isPluginMenuOpen');
    log.showInfo(`isTitleShownForHover :${isTitleShownForHover}, canUpdateStatusBar:${canUpdateStatusBar},\
      isStatusBarRightMenuOpen: ${isStatusBarRightMenuOpen}`);
    return isTitleShownForHover && canUpdateStatusBar && !isStatusBarRightMenuOpen;
  }

  private canUpdateCSideFloatTitle(sessionList: SCBSceneContainerSessionArray): boolean {
    this.mTopFullScreenSubSession = null;
    for (let i = sessionList.length - 1; i >= 0; i--) {
      let item = sessionList[i];
      if (item !== null && item.isActive && item.primarySession !== null) {
        // judge is sub session
        let topSubSession = SCBSceneSessionManager.getInstance()
          .getTopFullScreenSubSession(SCBSceneSessionManager.getInstance().mainScreenId, item);
        const screenHeight = this.mLayoutViewModel?.getScreenHeight();
        if (topSubSession && topSubSession.titleHoverShowEnabled &&
          topSubSession.currRect.top.getPx() >= screenHeight / 2) {
          this.mTopFullScreenSubSession = topSubSession;
          return topSubSession.titleHoverShowEnabled;
        }
      }
      if (item !== null && item.isActive && item.primarySession !== null &&
        ((item.isSplit && item.secondarySession !== null) || item.primarySession.layoutFullScreen)) {
        if (item.primarySession.currRect.top.getPx() < vp2px(this.mLayoutViewModel.getScreenHeight() / 2)) {
          continue;
        }
        if (this.mHideTitleSessionList.has(item)) {
          return false;
        }
        this.mFirstFullOrSplitContainer = item;
        return true;
      }
    }
    return false;
  }

  private getStatusHeight(systemSceneSession: SCBSystemSceneSession): number {
    let statusHeight: number = systemSceneSession !== null ? styleMgr.vp2pxStatusBarPCHeight() : 0;
    return statusHeight;
  }

  showCSideFloatingTitle(): void {
    if (!SCBSceneSessionManager.getInstance().isInSuperFoldStatus()) {
      return;
    }
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (sessionList === undefined || sessionList === null) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    if (this.canUpdateCSideFloatTitle(sessionList)) {
      const screenHeight = vp2px(this.mLayoutViewModel?.getScreenHeight());
      if (this.mTopFullScreenSubSession && this.mTopFullScreenSubSession.layoutFullScreen &&
        this.mTopFullScreenSubSession.currRect.top.getPx() > screenHeight / 2) {
        this.updateTitleForSubWindow(true, 0);
      } else if (!this.mTopFullScreenSubSession) {
        this.updateTitleForContainer(true, 0);
      }
      multiInputManager.registerCSideTitleMouseEvent();
      viewMgrPolicy.hideView(ViewType.C_SIDE_GUSTURE_TOP_BAR);
    }
  }

  updateCSideTitleFromGesture(isShow: boolean): void {
    if (!SCBSceneSessionManager.getInstance().isInSuperFoldStatus()) {
      return;
    }
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (sessionList === undefined || sessionList === null) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    if (isShow && this.canUpdateCSideFloatTitle(sessionList)) {
      if (this.mTopFullScreenSubSession && this.mTopFullScreenSubSession.layoutFullScreen) {
        this.updateTitleForSubWindow(true, 0);
      } else if (!this.mTopFullScreenSubSession) {
        this.updateTitleForContainer(true, 0);
      }
      viewMgrPolicy.hideView(ViewType.C_SIDE_GUSTURE_TOP_BAR);
    }
  }

  updateStatusAndFloatingTitleFromGestureTopBar(isShow: boolean, screenId?: number): void {
    log.showInfo('hover status bar and title');
    this.mTopFullScreenSubSession = null;
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || AppStorage.get('showRecent') ||
    AppStorage.get('split')) {
      return;
    }
    screenId = screenId === undefined ? SCBSceneSessionManager.getInstance().mainScreenId : screenId;
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance()
      .getContainerSessionList(screenId);
    if (!sessionList) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
    if (!systemSceneSession) {
      log.showError('Failed to get systemSceneSession of the statusBar');
      return;
    }
    if (!this.canUpdateStatusBar(sessionList, screenId)) {
      return;
    }
    let statusHeight = styleMgr.vp2pxStatusBarPCHeight()

    if (isShow && !viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
      this.hoverShowStatusBarAndTitle(systemSceneSession, statusHeight);
    } else if (!isShow && SCBSceneSessionManager.getInstance().getIsStatusBarShownForHover()) {
      this.updateTitleForContainer(false, statusHeight);
      this.updateTitleForSubWindow(false, statusHeight);
      this.statusBarVisibleCallback?.(false);
      this.updateTitleForSubWindow(false, statusHeight);
      SCBSceneSessionManager.getInstance().setIsStatusBarShownForHover(false);
    }
  }

  updateFloatingTitleFromGestureTopBar(isShow: boolean, screenId?: number): void {
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || AppStorage.get('showRecent') ||
    AppStorage.get('split')) {
      return;
    }
    screenId = screenId === undefined ? SCBSceneSessionManager.getInstance().mainScreenId : screenId;
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance()
      .getContainerSessionList(screenId);
    if (!sessionList) {
      log.showError('Failed to get containerSessionList');
      return;
    }
    if (!this.canUpdateStatusBar(sessionList, screenId)) {
      return;
    }
    //show sub window floating title
    if (this.mTopFullScreenSubSession) {
      this.updateTitleForSubWindow(isShow, 0);
      return;
    }
    this.updateTitleForContainer(isShow, 0);
  }

  // is title bar menu sub window for pc
  private isTitleBarMenuSubWindow(session: SCBSpecificSession): boolean {
    if (!SCBSceneSessionManager.getInstance().isPc()) {
      return true;
    }
    if (!session) {
      log.showError('session is null');
    }
    let screenProperty = SCBScreenSessionManager.getInstance().getScreenSession(session.screenId)?.scbScreenProperty;
    if (screenProperty) {
      return session.windowMode === SCBSceneMode.UNDEFINED &&
        screenProperty.width === session.currRect.width.getPx() &&
        screenProperty.height === session.currRect.height.getPx();
    }
    return false;
  }

  private hoverHideStatusBarAndTitle(systemSceneSession: SCBSystemSceneSession, statusHeight: number,
    mouseEvent: MouseEvent): void {
    // skip hide status and floating when maximize menu toast
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if (!this.mTopFullScreenSubSession && focusedSession instanceof SCBSpecificSession &&
    this.isTitleBarMenuSubWindow(focusedSession) &&
      focusedSession.session?.type === sceneSessionManager.SessionType.TYPE_SUB_APP &&
      mouseEvent?.action === Action.MOVE && this.judgsSubwindowIsTargetSub(focusedSession.session.parentId)) {
      this.isPreventHideTitleBar = true;
      return;
    }

    //skip hide status and floating when status bar has toast
    let isStatusBarPanelShowing = statusbarPlCtrl.isStatusBarPanelShowing as Function;
    if (isStatusBarPanelShowing()) {
      return;
    }
    //hide floating title
    if (this.mTopFullScreenSubSession && this.mTopFullScreenSubSession.layoutFullScreen &&
    this.isInTargetSide(mouseEvent.screenY, this.mTopFullScreenSubSession.currRect.top.getPx())) {
      this.updateTitleForSubWindow(false, statusHeight);
    } else {
      this.updateTitleForContainer(false, statusHeight);
    }
    //hide status bar
    if (systemSceneSession !== null) {
      if (this.statusBarVisibleCallback) {
        this.statusBarVisibleCallback(false);
      } else {
        viewMgrPolicy.hideView(ViewType.STATUS_BAR);
        SCBSceneSessionManager.getInstance().resetLastStatusBarProperty();
      }
      // hide status bar background animation need play in SCBStatusBar.
      SCBSceneSessionManager.getInstance().setIsStatusBarShownForHover(false);
    }
    if (systemSceneSession === null && this.lastScreenId === mouseEvent.screenId) {
      this.registerOrRecoverMouseEvent(false);
    }
    if (this.lastScreenId !== undefined) {
      this.lastScreenId = undefined;
    }
  }

  private hoverShowStatusBarAndTitle(systemSceneSession: SCBSystemSceneSession, statusHeight: number): void {
    //skip show status and floating when window is drag moving
    let isWindowMoving: boolean = AppStorage.get<boolean>('isWindowMoving') as boolean;
    if (isWindowMoving) {
      return;
    }
    //show sub window floating title
    if (this.mTopFullScreenSubSession) {
      if (this.mTopFullScreenSubSession.layoutFullScreen && this.mTopFullScreenSubSession.titleHoverShowEnabled) {
        //show status bar
        if (systemSceneSession) {
          SCBSceneSessionManager.getInstance().setIsStatusBarShownForHover(true);
          viewMgrPolicy.showView(ViewType.STATUS_BAR);
          this.statusBarVisibleCallback?.(true);
        }
        this.updateTitleForSubWindow(true, statusHeight);
      }
      return;
    }
    if (this.mFirstFullOrSplitContainer && this.mFirstFullOrSplitContainer.primarySession) {
      let isLayoutFullScreen = this.mFirstFullOrSplitContainer.primarySession.layoutFullScreen;
      let isTitleHoverShowEnabled = this.mFirstFullOrSplitContainer.primarySession.titleHoverShowEnabled;
      if (isLayoutFullScreen && !isTitleHoverShowEnabled) {
        log.showInfo('need not hover show status bar');
        return;
      }
    }
    //show status bar
    if (systemSceneSession !== null) {
      SCBSceneSessionManager.getInstance().setIsStatusBarShownForHover(true);
      viewMgrPolicy.showView(ViewType.STATUS_BAR);
      this.statusBarVisibleCallback?.(true);
    }
    //show main window floating title
    this.updateTitleForContainer(true, statusHeight);
  }

  // mouseEvent is in target session top area
  private isInTargetSide(mouseY: number, top: number): boolean {
    if (!SCBSceneSessionManager.getInstance().isInSuperFoldStatus()) {
      return true;
    }
    const screenHeight = this.mLayoutViewModel?.getScreenHeight();
    return (top <= screenHeight / 2 && mouseY <= screenHeight / 2) ||
      (top >= screenHeight / 2 && mouseY >= screenHeight / 2);
  }

  public setPreventHideTitleBarStatusBar(isHold: boolean): void {
    this.isPreventHideTitleBar = isHold;
  }

  public isPreventHideTitleBarStatusBar(): boolean {
    let isSplitSubwindowShown = false;
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if (focusedSession instanceof SCBSpecificSession &&
      focusedSession.session?.type === sceneSessionManager.SessionType.TYPE_SUB_APP) {
      isSplitSubwindowShown = this.judgsSubwindowIsTargetSub(focusedSession.session.parentId);
    }
    return isSplitSubwindowShown || this.isPreventHideTitleBar;
  }

  private isClickSplitSubwindow(mouseEvent: MouseEvent): boolean {
    if (CheckEmptyUtils.isEmpty(mouseEvent)) {
      return false;
    }
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if ((mouseEvent?.action === Action.BUTTON_DOWN || mouseEvent?.action === Action.BUTTON_UP) &&
      focusedSession instanceof SCBSpecificSession && focusedSession.isSubWindow() &&
      focusedSession.session.persistentId === mouseEvent?.windowId &&
    this.judgsSubwindowIsTargetSub(focusedSession.session.parentId)) {
      this.isPreventHideTitleBar = true;
      return true;
    }
    return false;
  }

  /**
   * Determine whether the current sub-window is the sub-window of the target hover title bar window
   *
   * @param parentId
   * @returns
   */
  private judgsSubwindowIsTargetSub(parentId: number): boolean {
    if (this.mFirstFullOrSplitContainer !== null) {
      if (this.mFirstFullOrSplitContainer.primarySession !== null &&
        this.mFirstFullOrSplitContainer.primarySession.session.persistentId === parentId) {
        log.showInfo('judgsSubwindowIsTargetSub primarySession subwindow');
        return true;
      }
      if (this.mFirstFullOrSplitContainer.secondarySession !== null &&
        this.mFirstFullOrSplitContainer.secondarySession.session.persistentId === parentId) {
        log.showInfo('judgsSubwindowIsTargetSub secondarySession subwindow');
        return true;
      }
    }
    log.showInfo('judgsSubwindowIsTargetSub return false');
    return false;
  }

  private canUpdateStatusBar(sessionList: SCBSceneContainerSessionArray, curScreenId?: number): boolean {
    this.mTopFullScreenSubSession = null;
    for (let i = sessionList.length - 1; i >= 0; i--) {
      let item = sessionList[i];
      // update status for sub window
      curScreenId = curScreenId === undefined ? item?.screenProperty?.screenId : curScreenId;
      let topFullScreenSubSession = SCBSceneSessionManager.getInstance()
        .getTopFullScreenSubSession(curScreenId, item);
      if (SCBSceneSessionManager.getInstance().isPcOrPcMode() && topFullScreenSubSession) {
        this.mTopFullScreenSubSession = topFullScreenSubSession;
        return topFullScreenSubSession.titleHoverShowEnabled && topFullScreenSubSession.layoutFullScreen;
      }
      if (item !== null && item.isActive && item.primarySession !== null &&
        ((item.isSplit && item.secondarySession !== null) ||
          item.primarySession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) &&
        curScreenId === item.screenProperty.screenId) {
        if (SCBSceneSessionManager.getInstance().isInSuperFoldStatus() &&
          item.primarySession.currRect.top.getPx() > vp2px(this.mLayoutViewModel.getScreenHeight() / 2)) {
          continue;
        }
        if (this.mHideTitleSessionList.has(item)) {
          return false;
        }
        this.mFirstFullOrSplitContainer = item;
        return true;
      }
    }
    return false;
  }

  private canUpdateSmartDock(sessionList: SCBSceneContainerSessionArray, pointerY: number = 0): boolean {
    if (this.mTopFullScreenSubSession) {
      log.showInfo('has fullscreen sub window in main screen.');
      return false;
    }
    const isPc = SCBSceneSessionManager.getInstance().isPc();
    for (let i = sessionList.length - 1; i >= 0; i--) {
      let item = sessionList[i];
      let isHavePrimarySession = item !== null && (isPc ? item.needRenderVisibility.visibility : item.isActive) &&
        item.primarySession !== null;
      if (item?.screenProperty.screenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
        continue;
      }
      let isSplitScreen = (item.isSplit && item.secondarySession !== null);
      let isFullScreen = item.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN;
      let isLayoutFullScreen = item.primarySession?.layoutFullScreen;
      if (isHavePrimarySession &&
        !this.mHideTitleSessionList.has(item) &&
        !item.primarySession?.isMinimizing) {
        if (isSplitScreen) {
          return !(SCBSceneSessionManager.getInstance().isPc() && !AppStorage.get<boolean>('isDockAutoHide'));
        }
        // pad pc模式在非全屏场景还要判断是否有窗口与dock重叠, 重叠时dock隐藏需要能唤出dock; 非pad pc模式返回false
        if (!isFullScreen) {
          continue;
        }
        if (isLayoutFullScreen) {
          this.mFirstFullOrSplitContainer = item;
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  private canUpdateSmartDockForSubWindow(sessionList: SCBSceneContainerSessionArray, curScreenId?: number): boolean {
    if (!SCBSceneSessionManager.getInstance().isPcOrPcMode()) {
      return false;
    }
    this.mTopFullScreenSubSession = null;
    for (let i = sessionList.length - 1; i >= 0; i--) {
      let item = sessionList[i];
      curScreenId = curScreenId === undefined ? item?.screenProperty?.screenId : curScreenId;
      let topFullScreenSubSession = SCBSceneSessionManager.getInstance()
        .getTopFullScreenSubSession(curScreenId, item);
      if (topFullScreenSubSession) {
        log.showInfo('update dock for sub window, layoutFullScreen: ' + topFullScreenSubSession.layoutFullScreen +
          ', id: ' + topFullScreenSubSession.session?.persistentId);
        this.mTopFullScreenSubSession = topFullScreenSubSession;
        return topFullScreenSubSession.layoutFullScreen && topFullScreenSubSession.dockHoverShowEnabled;
      }
    }
    return false;
  }

  private updateTitleForSubWindow(isShow: Boolean, statusHeight: number): void {
    if (!this.mTopFullScreenSubSession) {
      log.showInfo('mTopFullScreenSubSession is null.');
      return;
    }
    // 如果当前不是真正的沉浸式窗口则不显示标题栏
    if (!this.mTopFullScreenSubSession.getRealLayoutFullScreen()) {
      return;
    }
    log.showInfo('updateTitleForSubWindow isShow: ' + isShow + ' statusHeight: ' + statusHeight);
    sceneSessionManager.updateTitleInTargetPos(
      this.mTopFullScreenSubSession.session?.persistentId, isShow, statusHeight);
  }

  private updateTitleForContainer(isShow: Boolean, statusHeight: number): void {
    // 如果当前不是真正的沉浸式窗口则不显示标题栏
    if (!this.mFirstFullOrSplitContainer?.primarySession?.getRealLayoutFullScreen() &&
      !this.mFirstFullOrSplitContainer?.primarySession?.sessionData.isMaximizeFullScreen) {
      log.showWarn('need not update title for container.');
      return;
    }
    if (this.mFirstFullOrSplitContainer !== null && this.mFirstFullOrSplitContainer.primarySession !== null) {
      if (this.needRecoverStatusBar(this.mFirstFullOrSplitContainer.primarySession)) {
        sceneSessionManager.updateTitleInTargetPos(
          this.mFirstFullOrSplitContainer.primarySession.session.persistentId, isShow, 0);
      } else {
        sceneSessionManager.updateTitleInTargetPos(
          this.mFirstFullOrSplitContainer.primarySession.session.persistentId, isShow, statusHeight);
      }
      if (this.mFirstFullOrSplitContainer.secondarySession !== null) {
        sceneSessionManager.updateTitleInTargetPos(
          this.mFirstFullOrSplitContainer.secondarySession.session.persistentId, isShow, statusHeight);
      }
    }
  }

  private needRecoverStatusBar(sceneSession: SCBSceneSession): boolean {
    if (!sceneSession) {
      return false;
    }
    if (sceneSession.currRect) {
      return false;
    }
    return false;
  }

  private clearCallOutDelayTimer(): void {
    if (callOutDelayTimer) {
      clearTimeout(callOutDelayTimer);
      callOutDelayTimer = null;
    }
  }

  private callOutDockWithDelay(delay: number): void {
    if (this.mTopFullScreenSubSession) {
      this.callOutDockWithDelayInner(delay);
      return;
    }
    if (this.mFirstFullOrSplitContainer && this.mFirstFullOrSplitContainer.primarySession) {
      let isLayoutFullScreen = this.mFirstFullOrSplitContainer.primarySession.layoutFullScreen;
      let isDockHoverShowEnabled = this.mFirstFullOrSplitContainer.primarySession.dockHoverShowEnabled;
      if (isLayoutFullScreen && !isDockHoverShowEnabled) {
        return;
      }
      this.callOutDockWithDelayInner(delay);
      return;
    }
    this.callOutDockWithDelayInner(delay);
  }

  private callOutDockWithDelayInner(delay: number): void {
    this.clearCallOutDelayTimer();
    callOutDelayTimer = setTimeout(() => {
      if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
        let showDockViewWithAnimation =
          (GlobalContext.getInstance().getObject('showDockViewWithAnimation')) as Function;
        showDockViewWithAnimation();
      } else {
        viewMgrPolicy.showView(ViewType.SMART_DOCK);
      }
    }, delay);
  }

  private fnMicMuteCallBack(): void {
    log.showInfo('fnMicMuteCallBack invoke');
    HiSysEventUtil.reportKey(EventConstants.EVENT_FN_MUTE);
    let audioManager = audio.getAudioManager();
    let audioVolumeManager: audio.AudioVolumeManager = audioManager.getVolumeManager();
    const groupId = audio.DEFAULT_VOLUME_GROUP_ID;
    log.showInfo('Mic group ID: ' + groupId);
    let audioVolumeGroupManager: audio.AudioVolumeGroupManager = audioVolumeManager.getVolumeGroupManagerSync(groupId);
    let micMuteStatus: boolean = audioVolumeGroupManager.isMicrophoneMuteSync();
    audioVolumeGroupManager.setMicMute(!micMuteStatus).then(() => {
      log.showInfo(`Muted Microphone: ${!micMuteStatus}`);
      if (!DeviceHelper.isThreeFoldProduct()) {
        log.showInfo('Set Microphone Reminder');
        AppStorage.setOrCreate('isMicMuteState', !micMuteStatus);
      }
    }).catch((error: BusinessError) => {
      log.showError(`handleClick error: ${error.code}`);
    });
  }

  private fnSwitchVideoModeCallBack(): void {
    log.showInfo('fnSwitchVideoModeCallBack invoke');
    const options: common.ConnectOptions = {
      onConnect(elementName, remote) {
        /* 此处的入参remote为ServiceExtensionAbility在onConnect生命周期回调中返回的对象 */
        log.showInfo(TAG, 'onConnect callback');
        if (remote === null) {
          log.error(TAG, 'onConnect remote is null');
          return;
        }
        let option = new rpc.MessageOption();
        let data = rpc.MessageSequence.create();
        let reply = rpc.MessageSequence.create();
        remote.sendMessageRequest(PLUGIN_TOGGLE_CLICK_CODE, data, reply, option).then((result: rpc.RequestResult) => {
          log.showInfo('sendMessageRequest result: ' + JSON.stringify(result.code));
        })
          .finally(() => {
            data.reclaim();
            reply.reclaim();
          });
      },
      onDisconnect(elementName) {
        log.showInfo(TAG, 'onDisconnect callback');
        commonEventManager.publish(PUBLISH_EVENT_CAST_DISCONNECTED, (err: BusinessError) => {
          if (err) {
            log.showError('commonEvent publish err' + JSON.stringify(err));
          } else {
            log.showInfo('commonEvent publish success onDisconnect');
          }
        });
      },
      onFailed(code) {
        log.showInfo(TAG, 'onFailed callback');
      }
    };
    this.closeAll();
    this.hideStatusBarPanel();
    AppStorage.setOrCreate('showRecent', false);
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        hideAppCenterWithAnimation();
      }
    }
    HiSysEventUtil.reportKey(EventConstants.EVENT_FN_SWITCHVIDEOMODE);
    (getContext() as common.UIAbilityContext).connectServiceExtensionAbility({
      bundleName: 'com.ohos.ohcast',
      abilityName: 'CastSourceServiceAbility',
    }, options);
    log.showInfo('f8_callback done');
  }

  private startAbilityWithAccountNum(want: Want, accountId: number): void {
    try {
      GlobalContext.getContext().startAbilityWithAccount(want, accountId);
    } catch (err) {
      log.showError(`startAbilityWithAccount: ${err}`);
    }
  }

  private fnMediaRecordCallBack(): void {
    log.showInfo('fnMediaRecordCallBack invoke');
    HiSysEventUtil.reportKey(EventConstants.EVENT_FN_MEDIA_RECORD);
    const want: Want = {
      bundleName: 'com.ohos.screenrecorder',
      abilityName: 'com.ohos.screenrecorder.ServiceExtAbility',
      parameters: {
        TRIGGER_TYPE: 'hot-key',
      }
    }
    try {
      osAccount.getAccountManager().getForegroundOsAccountLocalId().then((userId: number) => {
        this.startAbilityWithAccountNum(want, userId);
      }).catch((err: BusinessError) => {
        log.showError(`getForegroundOsAccountLocalId err: ${err}`);
      });
    } catch (err) {
      log.showError(`getForegroundOsAccountLocalId exception: ${err}`);
    }
  }

  private winUpCallBack(): void {
    log.showInfo('winUpCallback invoke');
    if (multiInputManager.winCtrlLogoRightStatus === true) {
      multiInputManager.winCtrlLogoRightStatus = false;
      return;
    }
    MultimodalInputManager.dealWithShortcutKeyInFA = true;
    this.closeAll();
    this.hideStatusBarPanel();
    let isShortcutKeyPanelShow: boolean | undefined = AppStorage.get('isShortcutKeyPanelShow');
    if (isShortcutKeyPanelShow) {
      AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    }
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_UP);
    setTimeout(() => {
      AppStorage.setOrCreate('showRecent', false);
    }, 20);
    this.hoskeyLaunch();
  }

  private hoskeyLaunch(): void {
    log.showInfo(`uiType is ${uiType}`);
    if (uiType !== SCBConstants.UITYPE_PAD && !DeviceHelper.isThreeFoldProduct()) {
      this.dealHosKeyShortCutKey();
    }
  }

  private winACallBack(): void {
    log.showInfo('winACallBack invoke');
    this.closeAll();
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_A);
    AppStorage.setOrCreate('winAShowAppCenter', true);
    setTimeout(() => {
      AppStorage.setOrCreate('winAShowAppCenter', false);
    }, 160);
    this.dealAppCenterShortCutKey();
    MultiInputRecentProxy.getInstance().enterAppCenter();
  }

  private dealAppCenterShortCutKey(): void {
    const isShow = viewMgrPolicy.isViewShowing(ViewType.APP_CENTER);
    const isAppCenterShow = AppStorage.get<boolean>('isAppCenterShow');
    log.showInfo(`dealAppCenterShortCutKey. appCenter is show: ${isShow}, isAppCenterHiding: ${!isAppCenterShow}`);
    if (isShow) {
      if (isAppCenterShow) {
        performanceMonitor.begin(HiSysEventUtil.PC_SHORTCUT_EXIT_APP_CENTER, performanceMonitor.ActionType.LAST_UP);
      }
    } else {
      this.exitActiveSplit();
      this.hideNotifyContolCenter();
      HiSysEventUtil.reportPullAppCenter(HiSysEventUtil.APPCENTER_TYPE_INPUT);
      if (AppStorage.get<boolean>('showRecent')) {
        performanceMonitor.begin(HiSysEventUtil.PC_SHORTCUT_TO_APP_CENTER_ON_RECENT,
          performanceMonitor.ActionType.LAST_UP);
      } else {
        performanceMonitor.begin(HiSysEventUtil.PC_SHORTCUT_TO_APP_CENTER, performanceMonitor.ActionType.LAST_UP);
      }
      this.closeShortcutkeyPanel();
    }
  }

  private tabUpCallBack(): void {
    log.showInfo('tabUpCallBack invoke');
    this.altTabCount = -1;
    let isFirstIn: boolean = this.timerId > 0;
    this.clearTimer();
    multiInputManager.unRegisterTabUpEvent();
    AppStorage.setOrCreate('winTab', false);
    let altTabStatus: boolean | undefined = AppStorage.get('altTab');
    if (altTabStatus === true) {
      this.hideNotifyContolCenter();
      this.moveSessionToFront(isFirstIn);
      this.updateRecentSelectedIndex(-1);
      AppStorage.setOrCreate('altTab', false);
    }
  }

  private clearTimer(): void {
    if (this.timerId > 0) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
  }

  private enterRecent(): void {
    MultiInputRecentProxy.getInstance().enterRecent();
    if (AppStorage.get('showRecent') !== true) {
      HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_TAB);
      performanceMonitor.begin(HiSysEventUtil.PC_SHORTCUT_TO_RECENT, performanceMonitor.ActionType.LAST_DOWN);
    }
  }

  private async winTabCallBack(): Promise<void> {
    log.showInfo('winTabCallBack');
    MultimodalInputManager.dealWithShortcutKeyInFA = true;
    this.closeAll();
    this.hideSearchPanel();
    this.hideStatusBarPanel();
    this.hideNotifyContolCenter();
    this.updateRecentSelectedIndex(-1);
    this.recentAndAppCenterSwitchTimer.clearTimer();
    if (SCBSceneSessionManager.getInstance().isPc()) {
      this.enterRecent();
      return;
    }

    if (AppStorage.get('showRecent') === true) {
      AppStorage.setOrCreate('showRecent', false);
    } else {
      HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_TAB);
      performanceMonitor.begin(HiSysEventUtil.PC_SHORTCUT_TO_RECENT, performanceMonitor.ActionType.LAST_DOWN);
      AppStorage.setOrCreate('showRecent', true);
    }
  }

  private isFormEditSession(session: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null): boolean {
    if (CheckEmptyUtils.isEmpty(session)) {
      return false;
    }
    if (!(session instanceof SCBSceneSession)) {
      return false;
    }
    if (session.sceneInfo.bundleName === Constants.SCENE_BOARD_BUNDLE_NAME &&
      session.sceneInfo.abilityName === Constants.FORM_EDIT_ABILITY_NAME) {
      return true;
    }
    return false;
  }

  private getFocusedSession(): SCBSceneSession | null {
    let focusedSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null =
      SCBSceneSessionManager.getInstance().findMainSessionById(AppStorage.get<number>('focusedSessionId'));
    if (AppStorage.has('focusedSessionId')) {
      focusedSession =
        SCBSceneSessionManager.getInstance().findMainSessionById(AppStorage.get<number>('focusedSessionId'));
    }
    if (!focusedSession) {
      focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    }
    if (focusedSession && focusedSession instanceof SCBSceneSession) {
      return focusedSession;
    }
    return null;
  }

  private checkSessionOperable(focusedSession: SCBSceneSession): boolean {
    if (focusedSession.useControlList?.[0] === ControlType.PARENT_CONTROL ||
      focusedSession.useControlList?.[0] === ControlType.APP_LOCK) {
      log.showInfo('session has been controlled, return');
      return false;
    }
    if (focusedSession.isSessionMoving) {
      log.showInfo('is moving, return');
      return false;
    }
    if (this.isFormEditSession(focusedSession)) {
      log.showInfo('isFormEditSession, cant support winDpadUp');
      return false;
    }
    return true;
  }

  private async winDpadUpCallBack(): Promise<void> {
    log.showInfo('winDpadUpCallBack invoke');
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }
    let focusedSession: SCBSceneSession | null = this.getFocusedSession();
    if (focusedSession === null) {
      log.showInfo('can not find focused session, return');
      return;
    }
    if (!this.checkSessionOperable(focusedSession)) {
      return;
    }
    if (this.isSpilt()) {
      // 待分屏场景直接最大化
      focusedSession.windowLayoutEvent(SCBSessionEventId.EVENT_MAXIMIZE);
    }
    if (!focusedSession.sessionData.isFocused) {
      SCBSceneSessionManager.getInstance().startSceneFromRecent(focusedSession.sceneInfo.screenId,
        focusedSession.sceneInfo.persistentId);
    } else if (focusedSession.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
    focusedSession.isSupportFullScreenMode()) {
      focusedSession.windowLayoutEvent(SCBSessionEventId.EVENT_MAXIMIZE);
    }
    AppStorage.setOrCreate('focusedSessionId', focusedSession.sceneInfo.persistentId);
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_DPAD_UP);
  }

  private async winDpadDownCallBack(): Promise<void> {
    log.showInfo('winDpadDownCallBack invoke');
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }
    let focusedSession: SCBSceneSession | null = this.getFocusedSession();
    if (focusedSession === null) {
      log.showInfo('can not find focused session, return');
      return;
    }
    if (!this.checkSessionOperable(focusedSession)) {
      return;
    }
    let eventId: SCBSessionEventId = SCBSessionEventId.EVENT_UNDEFINED;
    if (this.isSpilt()) {
      eventId = SCBSessionEventId.EVENT_MINIMIZE;
      focusedSession.windowLayoutEvent(eventId);
      return;
    }
    if (focusedSession.layoutFullScreen) {
      eventId = SCBSessionEventId.EVENT_MINIMIZE;
    } else if (focusedSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      eventId = focusedSession.isSupportFloatingMode() && !focusedSession.isMinimizing ?
        SCBSessionEventId.EVENT_RECOVER : SCBSessionEventId.EVENT_MINIMIZE;
    } else if (focusedSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      eventId = SCBSessionEventId.EVENT_MINIMIZE;
    }
    focusedSession.windowLayoutEvent(eventId);
    AppStorage.setOrCreate('focusedSessionId', focusedSession.sceneInfo.persistentId);
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_DPAD_DOWN);
  }

  private splitPreCheck(focusedSession: SCBSceneSession): boolean {
    if (focusedSession.isClosing || focusedSession.isMinimizing || !focusedSession.isActive ||
    focusedSession.getRealLayoutFullScreen()) {
      log.showInfo(`can not enter split-mode in the current state of the Session.`);
      return false;
    }
    if (!focusedSession.isSupportSplitMode()) {
      log.showInfo(`it is not Support SplitMode :${focusedSession.sceneInfo.bundleName}`);
      return false;
    }
    let containerSession: SCBSceneContainerSession | null = SCBSceneSessionManager.getInstance()
      .getSceneContainerSessionFromScenePanel(focusedSession.sceneInfo.persistentId, focusedSession.sceneInfo.screenId);
    if (!containerSession || containerSession.secondarySession) {
      log.showInfo(`is already two-split, return`);
      return false;
    }
    if (focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_APP &&
      focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_SUB_APP) {
      log.showInfo('not app, return');
      return false;
    }
    return true;
  }

  private async winDpadLeftCallBack(): Promise<void> {
    log.showInfo(`winDpadLeftCallBack invoke`);
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }
    let focusedSession: SCBSceneSession | null = this.getFocusedSession();
    if (focusedSession === null) {
      log.showInfo('can not find focused session, return');
      return;
    }
    if (!this.checkSessionOperable(focusedSession)) {
      return;
    }
    if (!this.splitPreCheck(focusedSession)) {
      return;
    }
    if (this.isSpilt() && focusedSession.sceneInfo?.windowMode === SCBSceneMode.SECONDARY) {
      //当焦点窗口是右预分屏，执行log+左就退出预分屏，否则就执行左预分屏
      SCBSceneSessionManager.getInstance().exitActiveSplit(focusedSession.sceneInfo.screenId);
      return;
    }
    focusedSession.windowLayoutEvent(SCBSessionEventId.EVENT_SPLIT_PRIMARY);
    AppStorage.setOrCreate('focusedSessionId', focusedSession.sceneInfo.persistentId);
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_DPAD_LEFT);
  }

  private async winDpadRightCallBack(): Promise<void> {
    log.showInfo(`winDpadRightCallBack invoke`);
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }
    let focusedSession: SCBSceneSession | null = this.getFocusedSession();
    if (focusedSession === null) {
      log.showInfo('can not find focused session, return');
      return;
    }
    if (!this.checkSessionOperable(focusedSession)) {
      return;
    }
    if (!this.splitPreCheck(focusedSession)) {
      return;
    }
    if (this.isSpilt() && focusedSession.sceneInfo?.windowMode === SCBSceneMode.PRIMARY) {
      //若当焦点窗口是左预分屏，执行log+右就退出预分屏，否则就执行右预分屏
      SCBSceneSessionManager.getInstance().exitActiveSplit(focusedSession.sceneInfo.screenId);
      return;
    }
    focusedSession.windowLayoutEvent(SCBSessionEventId.EVENT_SPLIT_SECONDARY);
    AppStorage.setOrCreate('focusedSessionId', focusedSession.sceneInfo.persistentId);
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_DPAD_RIGHT);
  }

  private async altTabCallBack(): Promise<void> {
    log.showInfo('altTabCallback invoke');
    AppStorage.setOrCreate('altTabKeyEvent', true);
    TraceUtil.startTrace(DomainName.SCB, 'REGISTER ALT TAB respectively');
    multiInputManager.registerTabUpEvent();
    multiInputManager.registerAltUpEvent();
    TraceUtil.endTrace(DomainName.SCB, 'REGISTER ALT TAB respectively');
    HiSysEventUtil.reportKey(EventConstants.EVENT_ALT_TAB);
    performanceMonitor.begin(HiSysEventUtil.PC_ALT_TAB_TO_RECENT, performanceMonitor.ActionType.LAST_DOWN);
    MultimodalInputManager.dealWithShortcutKeyInFA = true;
    this.closeAll();
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    }
    this.altTabCount++;
    if (this.altTabCount === 0) {
      this.timerId = setTimeout(() => {
        this.doRecent();
        this.timerId = -1;
      }, 200);
    } else {
      this.clearTimer();
      this.doRecent();
    }
  }

  private doSelectIndexInRecent(): void {
    let index: number = this.getRecentSelectedIndex();
    let recentCloseCnt: number = 0;
    if (index === undefined || index === -1) {
      index = 0;
    } else {
      index++;
    }
    let sessionList = this.getShowInCurRecentSessionList();
    for (const containerSession of Array.from(sessionList.values())) {
      if (containerSession.primarySession?.isClosing) {
        recentCloseCnt++;
      }
    }
    log.showInfo(`doRecent index: ${index}, sessionList: ${sessionList.length}, recentCloseCnt: ${recentCloseCnt}`);
    if (sessionList !== undefined && sessionList !== null && index >= sessionList.length - recentCloseCnt) {
      if (!MultiInputRecentProxy.getInstance().isCrossScreenFocusable()) {
        index = 0;
      } else {
        this.focusToNextScreen();
        return;
      }
    }
    this.updateRecentSelectedIndex(index);
  }

  private doRecent(): void {
    GlobalContext.getInstance().getObject('memoryRefresh');
    if (AppStorage.get<boolean>('showRecent')) {
      this.doSelectIndexInRecent();
    } else {
      this.openRecent();
    }
  }

  private async openRecent(): Promise<void> {
    AppStorage.setOrCreate('showRecent', true);
    let recentCloseCnt: number = 0;
    let recentSessionInfoList = this.getShowInCurRecentSessionList();
    for (const containerSession of Array.from(recentSessionInfoList.values())) {
      if (containerSession.primarySession?.isClosing) {
        recentCloseCnt++;
      }
    }
    if (recentSessionInfoList !== undefined && recentSessionInfoList !== null) {
      if (recentSessionInfoList.length - recentCloseCnt === 0) {
        log.showInfo('recentSessionInfoList is empty');
      } else if (recentSessionInfoList.length - recentCloseCnt === 1) {
        log.showInfo('recentSessionInfoList is 1');
        this.updateRecentSelectedIndex(0);
      } else {
        let activeNum = 0;
        recentSessionInfoList.forEach((item) => {
          if (item.isActive) {
            activeNum++;
          }
          if (item.tabSelected) {
            this.updateRecentSelectedIndex(-1);
          }
        });
        log.showInfo(`active number ${activeNum}`);
        if (activeNum === 0) {
          this.updateRecentSelectedIndex(0);
        } else {
          this.updateRecentSelectedIndex(1);
        }
      }
    } else {
      this.updateRecentSelectedIndex(1);
    }
  }

  private altUpCallBack(): void {
    log.showInfo('altUpCallBack invoke');
    multiInputManager.unRegisterAltUpEvent();
    this.altTabCount = -1;
    let isFirstIn: boolean = this.timerId > 0;
    this.clearTimer();
    multiInputManager.unRegisterTabUpEvent();
    let altTabStatus: boolean | undefined = AppStorage.get('altTab');
    if (altTabStatus === true) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        hideAppCenterWithAnimation();
      }
      this.hideNotifyContolCenter();
      this.moveSessionToFront(isFirstIn);
      this.updateRecentSelectedIndex(-1);
      AppStorage.setOrCreate('altTab', false);
      performanceMonitor.end(HiSysEventUtil.PC_ALT_TAB_TO_RECENT);
    }
  }

  private moveSplitSessionToFrontIfNeed(): boolean {
    let scenePanelState: ScenePanelState | undefined = AppStorage.get('scenePanelState');
    if (scenePanelState === ScenePanelState.SPLIT) {
      let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
      if (focusedSession && focusedSession instanceof SCBSceneSession) {
        SCBSceneSessionManager.getInstance().maximizeSplit(focusedSession.sceneInfo.screenId,
          focusedSession.sceneInfo.persistentId);
        return true;
      }
    }
    return false;
  }

  private whetherFocusObtainedByIndex(sessionList: SCBSceneContainerSessionArray, index: number): boolean {
    let result: boolean = false;
    if (!sessionList || sessionList.isEmpty()) {
      return result;
    }
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if (!focusedSession) {
      return result;
    }
    let focusedIndex = sessionList.findIndexByPersistentId(focusedSession.session.persistentId);
    result = (focusedIndex === index);
    log.showInfo(`whetherFocusObtainedByIndex ${result}`);
    return result;
  }

  private moveSessionToFront(isFirstIn: boolean): void {
    log.showInfo('moveSessionToFront:' + isFirstIn);
    // 桌面快切场景 需要全量窗口快切
    let recentSessionInfoList = isFirstIn ? this.getSessionList() : this.getShowInCurRecentSessionList();
    if (recentSessionInfoList !== undefined && recentSessionInfoList !== null && recentSessionInfoList.length === 0) {
      AppStorage.setOrCreate('showRecent', false);
      return;
    }
    if (this.moveSplitSessionToFrontIfNeed()) {
      log.showInfo('moveSessionToFront: current is in split scene, exit split scene success');
      return;
    }
    let session: SCBSceneContainerSession | undefined | null;
    if (isFirstIn) {
      let activeNum = 0;
      recentSessionInfoList.forEach((item) => {
        if (item.isActive) {
          activeNum++;
        }
      });
      let moveIndex: number = 0;
      if (activeNum > 0) {
        moveIndex = recentSessionInfoList.length > 1 ? recentSessionInfoList.length - 2 : 0;
      } else {
        moveIndex = recentSessionInfoList.length > 1 ? recentSessionInfoList.length - 1 : 0;
      }
      // alt+tab快切，若要提的倒数第二个窗口已是前台获焦窗口，则提倒数第一个.打开多个应用到前台，最小化最上层的应用后，alt+tab快切场景
      if (this.whetherFocusObtainedByIndex(recentSessionInfoList, moveIndex)) {
        log.showInfo(`moveIndex containerSession has obtain the focus, reset the value to the last `);
        moveIndex = recentSessionInfoList.length - 1;
      }
      session = recentSessionInfoList[moveIndex];
    } else {
      session = this.getRecentSelectedItem();
    }
    if (session !== undefined && session !== null) {
      if (DeviceHelper.isPC()) {
        let isSplit: boolean | undefined = AppStorage.get('split');
        if (isSplit) {
          SCBSceneSessionManager.getInstance().exitActiveSplit(INVALID_SCREEN_ID);
          return;
        }
      }
      let showRecent: boolean | undefined = AppStorage.get('showRecent');
      if (showRecent || isFirstIn) {
        AppStorage.setOrCreate('altTabKeyEvent', false);
        SCBSceneSessionManager.getInstance().startSceneFromRecent(
          MultiInputRecentProxy.getInstance().getCurrentScreenId(), session.primarySession?.session.persistentId);
        SCBSceneSessionManager.getInstance().requestFocus(
          session.primarySession?.session.persistentId, undefined, FocusChangeReason.REQUEST_WITH_CHECK_SUB_WINDOW);
      }
    }
  }

  private winDCallBack(): void {
    log.showInfo('winDcallback invoke');
    this.closeAll();
    this.hideNotifyContolCenter();
    this.hideSearchPanel();
    this.hideStatusBarPanel();
    AppStorage.setOrCreate('winD', true);
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        hideAppCenterWithAnimation();
      }
    } else {
      if (AppStorage.get('toggleHomeShow') === true) {
        AppStorage.setOrCreate('toggleHomeShow', false);
      } else {
        HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_D);
        AppStorage.setOrCreate('toggleHomeShow', true);
      }
    }
  }

  private closeAll(): void {
    ContextMenu.close();
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
    FormCenterViewManager.getInstance().closeFormCenterView();
    AppStorage.setOrCreate('isRecentPopupShow', false);
    AppStorage.setOrCreate('openFolderStatus', 0);
    AppStorage.setOrCreate('showUninstallDialog', false);
    AppStorage.setOrCreate('isPopupMenuShow', false);
  }

  private winShiftSCallBack(): void {
    log.showInfo('winShiftSCallBack');
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_SHIFT_S);
    let screenshotParameters: Record<string, Object> = {};
    screenshotParameters[TRIGGER_TYPE] = 'hot-key';
    screenshotParameters[SHOT_TYPE] = 'smart-shot';
    StartAbilityUtil.startServiceExtensionAbility({
      bundleName: 'com.ohos.screenshot',
      abilityName: 'com.ohos.screenshot.ServiceExtAbility',
      parameters: DeviceHelper.isThreeFoldProduct() ? undefined : screenshotParameters
    });
  }

  private winShiftRCallBack(): void {
    log.showInfo('winShiftRCallBack');
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_SHIFT_R);
    StartAbilityUtil.startServiceExtensionAbility({
      bundleName: 'com.ohos.screenrecorder',
      abilityName: 'com.ohos.screenrecorder.ServiceExtAbility',
      parameters: undefined
    });
  }

  public winOpenTaskManagerCallBack(): void {
    log.showInfo(`winOpenTaskManagerCallBack, ${uiType}`);
    if (uiType === SCBConstants.UITYPE_PC || DeviceHelper.isPC()) {
      log.showInfo(`winOpenTaskManagerCallBack success`);
      this.closeAll();
      this.hideStatusBarPanel();
      this.hideNotifyContolCenter();
      if (uiType === SCBConstants.UITYPE_PAD || DeviceHelper.isThreeFoldProduct()) {
        AppStorage.setOrCreate('showRecent', false);
      }
      let isSplit: boolean | undefined = AppStorage.get('split');
      if (isSplit) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
      }
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      context.startAbility({
        bundleName: 'com.ohos.taskmanager',
        abilityName: 'MainAbility',
        parameters: {
          TRIGGER_TYPE: 'hot-key',
        }
      });
      HiSysEventUtil.reportStartApp('com.ohos.taskmanager');
      AnimateToScheduleUtils.reportStartAppToRss('com.ohos.taskmanager');
    } else {
      log.showInfo(`winOpenTaskManagerCallBack failed`);
    }
  }

  private winFCallBack(): void {
    log.showInfo('winFCallBack');
    if (uiType === SCBConstants.UITYPE_PAD || DeviceHelper.isThreeFoldProduct()) {
      this.hideGlobalSearch();
      this.hideNotifyContolCenter();
      AppStorage.setOrCreate('showRecent', false);
    } else if (DeviceHelper.isPC()) {
      this.closeAll();
      this.hideStatusBarPanel();
      this.hideNotifyContolCenter();
      let isSplit: boolean | undefined = AppStorage.get('split');
      if (isSplit) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
      }
    }
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let link: string = 'filemanager://openDirectory';
    let openLinkOptions: OpenLinkOptions = {
      parameters: {
        'fileUri': ''
      }
    };
    try {
      context.openLink(link, openLinkOptions)
        .then(() => {
          log.showInfo('open link success.');
        }).catch((err: BusinessError) => {
        log.showError(`open link failed. Code: ${err.code}, message: ${err.message}`);
      });
    } catch (paramError) {
      log.showError(`Failed to start link. Code: ${paramError.code}, message: ${paramError.message}`);
    }
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_F);
  }

  public winLCallBack(): void {
    log.showInfo('winLCallBack');
    if (DeviceHelper.isPad() || DeviceHelper.is2In1DevicePcType() || DeviceHelper.isThreeFoldProduct()) {
      HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_L);
      screenLock.lock().then((result: Boolean) => {
        if (!AppStorage.get<boolean>('isScreenOn') || ScreenLockApi.isScreenLockShow()) {
          log.showInfo('screen is locked or screen is off');
          return;
        }
        this.setWallPaperToHideDesktop();
        if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
          let hideAppCenterWithAnimation = (GlobalContext.getInstance()
            .getObject('hideAppCenterWithAnimation')) as Function;
          hideAppCenterWithAnimation();
        }
        screenLockStateManager.onEnterHost(true);
        sOutSideWindowMgr.hideGlobalSearch(true);
        log.showInfo(`Succeeded in locking the screen. result: ${result}`);
      }).catch((err: BusinessError) => {
        log.showError(`Failed to lock the screen, Code: ${err.code}, message: ${err.message}`);
      });
    }
  }

  private setWallPaperToHideDesktop: Function = () => {
    let controller: ViewController | undefined = viewMgrPolicy.getViewController(ViewType.WALLPAPER);
    controller?.show();
    controller?.setZIndex(SCREEN_LOCK_WALL_PAPER_ZINDEX);
  };

  private winSlashCallBack(): void {
    log.showInfo('winSlashCallBack');
    if (DeviceHelper.isThreeFoldProduct() && !DeviceHelper.isGState()) {
      log.showInfo('winSlashCallBack, ThreeFoldProduct but not G state');
      return;
    }
    this.closeAll();
    this.hideNotifyContolCenter();
    if (AppStorage.get('isShortcutKeyPanelShow')) {
      AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    } else {
      HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_SLASH);
      AppStorage.setOrCreate('isShortcutKeyPanelShow', true);
    }
  }

  private closeShortcutkeyPanel(): void {
    if (AppStorage.get('isShortcutKeyPanelShow')) {
      AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    }
  }

  private winNCallBack(): void {
    log.showInfo('winNCallBack');
    this.closeAll();
    if (windowMgr.isShowing(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL)) {
      this.closeStatusBarSecondaryPanel(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
    } else {
      this.exitActiveSplit();
      setTimeout(() => {
        AppStorage.setOrCreate('showRecent', false);
      }, 20);
      if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
        if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
          let hideAppCenterWithAnimation = (GlobalContext.getInstance()
            .getObject('hideAppCenterWithAnimation')) as Function;
          hideAppCenterWithAnimation();
        }
      }
      HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_N);
      EvtBus.post(WindowPositionChangeEvent, {
        windowName: PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
        position: PluginPosition.POSITION_RIGHT,
        area: windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL)
      });
      windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
    }
  }

  private winCCallBack(): void {
    log.showInfo('winCCallBack');
    this.closeAll();
    if (windowMgr.isShowing(PluginSlot.SLOT_STATUS_CONTROL_CENTER)) {
      this.closeStatusBarSecondaryPanel(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    } else {
      this.exitActiveSplit();
      setTimeout(() => {
        AppStorage.setOrCreate('showRecent', false);
      }, 20);
      if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
        if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
          let hideAppCenterWithAnimation = (GlobalContext.getInstance()
            .getObject('hideAppCenterWithAnimation')) as Function;
          hideAppCenterWithAnimation();
        }
      }
      HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_C);
      EvtBus.post(WindowPositionChangeEvent, {
        windowName: PluginSlot.SLOT_STATUS_CONTROL_CENTER,
        position: PluginPosition.POSITION_RIGHT,
        area: windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER)
      });
      windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    }
  }

  private winMCallBack(): void {
    log.showInfo('winMCallBack');
    if (this.isSpilt()) {
      return;
    }
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }

    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if (focusedSession === undefined || focusedSession === null ||
      !(focusedSession instanceof SCBSceneSession || focusedSession instanceof SCBSpecificSession)) {
      return;
    }
    focusedSession = this.findMainSceneSessionForFocusedScene(focusedSession);
    if (focusedSession instanceof SCBSpecificSession) {
      return;
    }
    if (this.isFormEditSession(focusedSession)) {
      log.showInfo('isFormEditSession, cant support minimize');
      return;
    }
    if (focusedSession instanceof SCBSceneSession) {
      log.showDebug(`winMCallBack, focusedSession: ${focusedSession.sceneInfo.bundleName}`);
      if (focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_APP &&
        focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_SUB_APP) {
        log.showInfo('not app, return');
        return;
      }
      SCBSceneSessionManager.getInstance().minimize(focusedSession.sceneInfo.screenId,
        focusedSession.sceneInfo.persistentId);
    }
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_M);
  }

  private altF4CallBack(): void {
    log.showInfo('altF4CallBack');
    if (this.isSpilt()) {
      log.showInfo('split window exist');
      return;
    }
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if (focusedSession === undefined || focusedSession === null || focusedSession instanceof SCBSystemSceneSession) {
      log.showInfo('No focusedSession');
      return;
    }
    if (focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_APP &&
      focusedSession.session.type !== sceneSessionManager.SessionType.TYPE_SUB_APP) {
      log.showInfo('not app, return');
      return;
    }
    focusedSession = this.findAltF4OperableSession(focusedSession);
    if (focusedSession === undefined || focusedSession === null) {
      log.showInfo('No operable session');
      return;
    }
    HiSysEventUtil.reportKey(EventConstants.EVENT_ALT_F4);
    if (focusedSession instanceof SCBSceneSession && this.closePadPairedSplitScene(focusedSession)) {
      log.showInfo('close pad double split scene, return');
      return;
    }
    if (focusedSession instanceof SCBSceneSession) {
      if (focusedSession.useControlList?.[0] === ControlType.PARENT_CONTROL ||
        focusedSession.useControlList?.[0] === ControlType.APP_LOCK) {
        log.showInfo('session has been controlled, return');
        return;
      }
      SCBSceneSessionManager.getInstance().asyncPrepareTerminate(focusedSession.sceneInfo.persistentId,
        (err, isPrepareTerminate) => {
          if (isPrepareTerminate) {
            if (focusedSession instanceof SCBSceneSession) {
              log.showInfo(`isPrepareTerminate: ${isPrepareTerminate},
            persistentID: ${focusedSession?.sceneInfo.persistentId}`);
            }
            return;
          }
          if (focusedSession instanceof SCBSceneSession) {
            SCBSceneSessionManager.getInstance().close(focusedSession.sceneInfo.screenId,
              focusedSession.sceneInfo.persistentId);
          }
        });
    } else if (focusedSession instanceof SCBSpecificSession) {
      SCBSceneSessionManager.getInstance().asyncPrepareTerminate(focusedSession.session.persistentId,
        (err, isPrepareTerminate) => {
          if (isPrepareTerminate) {
            if (focusedSession instanceof SCBSpecificSession) {
              log.showInfo(`isPrepareTerminate: ${isPrepareTerminate},
              persistentID: ${focusedSession.session.persistentId}`);
            }
            return;
          }
          if (focusedSession instanceof SCBSpecificSession) {
            focusedSession.requestSpecificSessionClose();
          }
        });
    }
  }

  private findAltF4OperableSession(session: SCBSpecificSession | SCBSceneSession | SCBSystemSceneSession):
  SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null {
    if (session === undefined || session === null || session instanceof SCBSystemSceneSession) {
      return null;
    }
    if (session instanceof SCBSceneSession || (session instanceof SCBSpecificSession &&
      session.source !== SCBSpecificSessionSource.TYPE_ARKUI)) {
      return session;
    }
    let sceneSessionID: number = session.session.parentId;
    let parentSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSessionById(sceneSessionID);
    if (parentSession && session.session.persistentId === parentSession.session.persistentId) {
      return null;
    }
    return this.findAltF4OperableSession(parentSession);
  }

  private closePadPairedSplitScene(focusedSession: SCBSceneSession): boolean {
    if (DeviceHelper.isPad() &&
    SCBSceneSessionManager.getInstance().isSplitMode(focusedSession.sceneInfo.persistentId)) {
      log.showInfo(`closePadPairedSplitScene persistentId ${focusedSession.sceneInfo.persistentId}`);
      SCBSceneSessionManager.getInstance().minimize(focusedSession.sceneInfo.screenId,
        focusedSession.sceneInfo.persistentId);
      return true;
    }
    return false;
  }

  private winBackSpaceCallBack(): void {
    log.showInfo('winBackSpaceCallBack');
    if (this.isSpilt()) {
      return;
    }
    if (AppStorage.get<boolean>('showRecent') || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('Recent or APP CENTER is showing, return!');
      return;
    }
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    if (focusedSession === undefined || focusedSession === null || !(focusedSession instanceof SCBSceneSession)) {
      return;
    }
    HiSysEventUtil.reportKey(EventConstants.EVENT_WIN_BACKSPACE);
    sceneSessionManager.processBackEvent();
  }

  private browserCallBack(): void {
    log.showInfo('browserCallBack');
    if (DeviceHelper.isPC()) {
      this.closeAll();
      this.hideStatusBarPanel();
      this.hideNotifyContolCenter();
      let isSplit: boolean | undefined = AppStorage.get('split');
      if (isSplit) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
      }
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      context.startAbility({
        bundleName: 'com.ohos.browser',
        abilityName: 'MainAbility',
        parameters: {
          TRIGGER_TYPE: 'HOT_KEY',
        }
      });
      HiSysEventUtil.reportStartApp('com.ohos.browser');
      AnimateToScheduleUtils.reportStartAppToRss('com.ohos.browser');
    }
  }

  private calculatorCallBack(): void {
    log.showInfo('calculatorCallBack');
    if (DeviceHelper.is2In1DevicePcType()) {
      this.closeAll();
      this.hideStatusBarPanel();
      this.hideNotifyContolCenter();
      setTimeout(() => {
        let want: Want = {
          bundleName: 'com.ohos.calculator',
          abilityName: 'CalculatorAbility',
          moduleName: 'phone'
        };
        StartAbilityUtil.startLauncherAbility(want.abilityName, want.bundleName, want.moduleName);
      }, ENTER_RECENT_DELAY);
      HiSysEventUtil.reportStartApp('com.ohos.calculator');
      AnimateToScheduleUtils.reportStartAppToRss('com.ohos.calculator');
    } else if (DeviceHelper.isPC()) {
      this.closeAll();
      this.hideStatusBarPanel();
      this.hideNotifyContolCenter();
      let isSplit: boolean | undefined = AppStorage.get('split');
      if (isSplit) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
      }
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      context.startAbility({
        bundleName: 'com.ohos.calculator',
        abilityName: 'com.ohos.calculator.CalculatorAbility',
        parameters: undefined
      });
      HiSysEventUtil.reportStartApp('com.ohos.calculator');
      AnimateToScheduleUtils.reportStartAppToRss('com.ohos.calculator');
    }
  }

  private configCallBack(): void {
    log.showInfo('configCallBack');
    if (DeviceHelper.isPC()) {
      this.closeAll();
      this.hideStatusBarPanel();
      this.hideNotifyContolCenter();
      let isSplit: boolean | undefined = AppStorage.get('split');
      if (isSplit) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
      }
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      context.startAbility({
        bundleName: 'com.ohos.music',
        abilityName: 'MainAbility',
        parameters: {
          TRIGGER_TYPE: 'HOT_KEY',
        }
      });
      HiSysEventUtil.reportStartApp('com.ohos.music');
      AnimateToScheduleUtils.reportStartAppToRss('com.ohos.music');
    }
  }

  private emailCallBack(): void {
    log.showInfo('emailCallBack');
    if (DeviceHelper.isPC()) {
      this.closeAll();
      this.hideStatusBarPanel();
      this.hideNotifyContolCenter();
      let isSplit: boolean | undefined = AppStorage.get('split');
      if (isSplit) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
      }
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      context.startAbility({
        bundleName: 'com.ohos.email',
        abilityName: 'EntryAbility',
        parameters: {
          TRIGGER_TYPE: 'HOT_KEY',
        }
      });
      HiSysEventUtil.reportStartApp('com.ohos.email');
      AnimateToScheduleUtils.reportStartAppToRss('com.ohos.email');
    }
  }

  private hideNotifyContolCenter(): void {
    if (windowMgr.isShowing(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL)) {
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
    }
    if (windowMgr.isShowing(PluginSlot.SLOT_STATUS_CONTROL_CENTER)) {
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    }
    if (windowMgr.isShowing(PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL)) {
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL);
    }
    if (uiType === SCBConstants.UITYPE_PAD || DeviceHelper.isThreeFoldProduct()) {
      DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
    }
  }

  public hideGlobalSearch(): void {
    log.showInfo('hideGlobalSearchWithoutAnim');
    let viewController: ViewController | undefined = viewMgrPolicy.getViewController(ViewType.GLOBAL_SEARCH);
    if (!sOutSideWindowMgr.isShowGlobalSearch()) {
      return;
    }
    sOutSideWindowMgr.setDesktopEnabled(true, TAG);
    sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.HIDE);
    log.showInfo('exitSearch:start');
    sOutSideWindowMgr.setIsHidingGlobalSearch(true);
    viewController?.hide();
    sOutSideWindowMgr.setIsHidingGlobalSearch(false);
    let duration: number = new Date().getTime() - sOutSideWindowMgr.getIntoSearchTime();
    HiSysEventUtil.reportExitSearch(duration);
    sOutSideWindowMgr.hideGlobalSearchDirectly();
    log.showInfo('exitSearch:end');
  }

  private showGlobalSearch(): void {
    sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.SHOW);
    ViewManagerPolicy.showView(ViewType.GLOBAL_SEARCH);
    setTimeout(() => {
      sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.SHOW);
    }, 50);
    sOutSideWindowMgr.showGlobalSearchDirectly();
  }

  private hideSearchPanel(): void {
    commonEventManager.publish(EventConstants.EVENT_PCSETTING_HIDE_SEARCH_PANEL, (err) => {
      if (err) {
        console.error(`publish failed, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info('publish success');
      }
    });
  }

  private isSpilt(): boolean {
    if (DeviceHelper.isPC()) {
      if (this.mIsSplit || AppStorage.get('split')) {
        log.showInfo('isSplit');
        return true;
      }
    }
    let scenePanelState: ScenePanelState | undefined = AppStorage.get('scenePanelState');
    if (scenePanelState === ScenePanelState.SPLIT) {
      return true;
    }
    return false;
  }

  private exitActiveSplit(): void {
    if (DeviceHelper.isPC()) {
      if (this.mIsSplit) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(INVALID_SCREEN_ID);
      }
    }
  }

  private hideStatusBarPanel(): void {
    let statusBarPanelMap = statusbarPlCtrl.getStatusBarPanelMap();
    for (let item of statusBarPanelMap.entries()) {
      if (item[1] === true) {
        windowMgr.hideWindowWithAnim(item[0]);
      }
    }
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
  }

  /**
   * 注册多模输入（快捷键、鼠标）添加事件
   *
   */
  registerMultiInputEvent(): void {
    localEventManager.registerEventListener(this.mLocalEventListener, [
      EventConstants.EVENT_FN_BRIGHTNESS_DOWN,
      EventConstants.EVENT_FN_BRIGHTNESS_UP,
      EventConstants.EVENT_FN_MUTE,
      EventConstants.EVENT_FN_SWITCHVIDEOMODE,
      EventConstants.EVENT_FN_SEARCH,
      EventConstants.EVENT_FN_MEDIA_RECORD,
      EventConstants.EVENT_ALT_TAB,
      EventConstants.EVENT_WIN_TAB,
      EventConstants.EVENT_WIN_UP,
      EventConstants.EVENT_ESC,
      EventConstants.EVENT_WIN_D,
      EventConstants.EVENT_ALT_UP,
      EventConstants.EVENT_TAB_UP,
      EventConstants.EVENT_D_WIN,
      EventConstants.EVENT_WIN_SHIFT_S,
      EventConstants.EVENT_WIN_SHIFT_R,
      EventConstants.EVENT_WIN_S,
      EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE,
      EventConstants.EVENT_C_SIDE_TITLE_STATUS_CHANGE,
      EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE,
      EventConstants.EVENT_WIN_SLASH,
      EventConstants.EVENT_WIN_N,
      EventConstants.EVENT_WIN_C,
      EventConstants.EVENT_WIN_A,
      EventConstants.EVENT_WIN_DPAD_UP,
      EventConstants.EVENT_WIN_DPAD_DOWN,
      EventConstants.EVENT_WIN_DPAD_LEFT,
      EventConstants.EVENT_WIN_DPAD_RIGHT,
      EventConstants.EVENT_WIN_M,
      EventConstants.EVENT_ALT_F4,
      EventConstants.EVENT_WIN_F,
      EventConstants.EVENT_CTRL_SHIFT_ESC,
      EventConstants.EVENT_CTRL_ALT_DEL,
      EventConstants.EVENT_WIN_SPACE_UP,
      EventConstants.EVENT_CTRL_SHIFT,
      EventConstants.EVENT_WIN_BACKSPACE,
      EventConstants.EVENT_WIN_L,
      EventConstants.EVENT_ALT_SHIFT_F4,
      EventConstants.EVENT_FN_BROWSER,
      EventConstants.EVENT_FN_CALCULATOR,
      EventConstants.EVENT_FN_MUSIC,
      EventConstants.EVENT_FN_EMAIL,
      EventConstants.EVENT_FN_SYSRQ
    ]);
  }

  /**
   * Unregister application list change listener.
   *
   */
  unregisterEventListener(): void {
    localEventManager.unregisterEventListener(this.mLocalEventListener);
    try {
      this.unregisterKeyObserver();
    } catch (error) {
      log.showInfo(`Failed to unregisterKeyObserver, error:  ${(error as BusinessError).message}`);
    }
  }

  setSpiltState(splitState: boolean): void {
    this.mIsSplit = splitState;
  }

  public addHideTitleSessionList(hideTitleSession: SCBSceneContainerSession): void {
    this.mHideTitleSessionList.add(hideTitleSession);
  }

  public deleteHideTitleSessionList(hideTitleSession: SCBSceneContainerSession): void {
    this.mHideTitleSessionList.delete(hideTitleSession);
  }

  registerKeyObserver(): void {
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    try {
      settings.registerKeyObserver(context, Constants.DESK_GESTURE_KEY, settings.domainName.DEVICE_SHARED,
        this.deskGestureParamChanged);
    } catch (error) {
      log.showInfo(`Failed to registerKeyObserver, error: ${(error as BusinessError).message}`);
    }

  }

  registerStatusBarVisibleCallback(callback: Function): void {
    this.statusBarVisibleCallback = callback;
  }

  unregisterStatusBarVisibleCallback(callback: Function): void {
    // 解注册函数对象与当前持有对象相同时才进行解注册，避免新的函数对象被置空
    if (this.statusBarVisibleCallback === callback) {
      this.statusBarVisibleCallback = null;
    }
  }

  deskGestureParamChanged(): void {
    log.showInfo(`${TAG}, deskGestureParamChanged`);
    MultiInputViewModel.getInstance()?.getDeskGestureParam();
  }

  unregisterKeyObserver(): void {
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    try {
      settings.unregisterKeyObserver(context, Constants.DESK_GESTURE_KEY, settings.domainName.DEVICE_SHARED);
    } catch (error) {
      log.showInfo(`Failed to unregisterKeyObserver, error: ${(error as BusinessError).message}`);
    }
  }

  /**
   * 以5个2进制位保存5个手势的开关值（从右到左）：
   * 第一位 代表：显示桌面或恢复窗口
   * 第二位 代表：多桌面切换
   * 第三位 代表：进入多任务
   * 第四位 代表：打开或关闭应用中心
   * 第五位 代表：全局搜索
   */
  getDeskGestureParam(): void {
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    try {
      let param: string = settings.getValueSync(context, Constants.DESK_GESTURE_KEY, '');
      log.showInfo(`getDeskGestureParam : ${param} - ${param.toString()}`);
      if (param.length === 0) {
        return;
      }
      if (isNaN(Number(param))) {
        log.showError(`getDeskGestureParam : ${param} not number`);
      } else {
        let paramTmp: number = Number(param);
        if (paramTmp < 0 || paramTmp > Constants.DEFAULT_DESK_GESTURE_PARAM) {
          log.showError(`getDeskGestureParam : ${paramTmp} invaild!`);
          return;
        }
        this.deskGestureParam = paramTmp;
      }
      return;
    } catch (error) {
      log.showError('Failed to getValueSync.');
    }
  }

  isMultiDeskSwitchEnable(): boolean {
    return ((this.deskGestureParam & (1 << 1)) > 0);
  }

  isSwipeEnterRecentEnable(): boolean {
    return ((this.deskGestureParam & (1 << 2)) > 0);
  }

  isPinchOpenAppCenterEnable(): boolean {
    return ((this.deskGestureParam & (1 << 3)) > 0);
  }

  isTapGlobalSearchEnable(): boolean {
    return ((this.deskGestureParam & (1 << 4)) > 0);
  }

  public getHideTitleSessionList(): Set<SCBSceneContainerSession> {
    log.showDebug(`getHideTitleSessionList size is ${this.mHideTitleSessionList?.size}`);
    return this.mHideTitleSessionList;
  }

  private dealHosKeyShortCutKey(): void {
    HiSysEventUtil.reportPullHosKey(HiSysEventUtil.HOSKEY_TYPE_INPUT);
    log.showInfo('HoskeyLog: begin pull hoskey');
    this.closeAll();
    this.exitActiveSplit();
    this.hideNotifyContolCenter();
    this.hideStatusBarPanel();
    AppStorage.setOrCreate('showRecent', false);
    StartAbilityUtil.startServiceExtensionAbility({
      bundleName: ExtAppConstants.ohosKEY_BUNDLENAME,
      abilityName: ExtAppConstants.ohosKEY_ABILITYNAME,
      parameters: {
        screenId: SCBSceneSessionManager.getInstance().mainScreenId
      }
    });
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        log.showInfo('hide appCenter By hosKey');
        hideAppCenterWithAnimation();
      }
    }
    this.hosKeyShow();
  }

  /**
   * register hosKey show callback
   * @param callback
   */
  public registerHosKeyShowCallback(callback: Function): void {
    if (callback) {
      this.hosKeyShowCallbacks.push(callback);
    }
    log.showInfo(`registerHosKeyShowCallback callbacks len:${this.hosKeyShowCallbacks.length}`);
  }

  /**
   * unregister hosKey show callback
   * @param callback
   */
  public unregisterHosKeyShowCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`unregisterHosKeyShowCallback failed. callback is null`);
      return;
    }

    let index: number = this.hosKeyShowCallbacks.indexOf(callback);
    if (index !== -1) {
      this.hosKeyShowCallbacks.splice(index, 1);
    }
    log.showInfo(`unregisterHosKeyShowCallback callbacks len:${this.hosKeyShowCallbacks.length}`);
  }

  private hosKeyShow(): void {
    log.showInfo(`hosKeyShow`);
    this.hosKeyShowCallbacks.forEach((callback) => {
      if (callback) {
        callback();
      }
    });
  }

  private registerOrRecoverMouseEvent(needMouseEvent: boolean): void {
    if (needMouseEvent) {
      multiInputManager.registerPcMouseEvent();
    } else {
      multiInputManager.recoverMouseEvent();
    }
  }

  private updateRecentSelectedIndex(index: number): void {
    if (DeviceHelper.isPC()) {
      MultiInputRecentProxy.getInstance().setCurrentSelectedIndex(index);
      return;
    }
    AppStorage.setOrCreate('selectedIndex', index);
  }

  private getRecentSelectedIndex(): number {
    if (DeviceHelper.isPC()) {
      return MultiInputRecentProxy.getInstance().getCurrentSelectedIndex();
    }
    return AppStorage.get('selectedIndex') as number;
  }

  private focusToNextScreen(): void {
    if (DeviceHelper.isPC()) {
      MultiInputRecentProxy.getInstance().crossFocusToNextScreenRecentByAltTab();
      return;
    }
  }

  private getShowInCurRecentSessionList(): SCBSceneContainerSessionArray {
    return MultiInputRecentProxy.getInstance().getShowInCurRecentContainerSessionList();
  }

  private getSessionList(): SCBSceneContainerSessionArray {
    if (DeviceHelper.isPC()) {
      return MultiInputRecentProxy.getInstance().getCurrContainerSessionList();
    }
    return SCBSceneSessionManager.getInstance().getContainerSessionList();
  }

  private getRecentSelectedItem(): SCBSceneContainerSession | null | undefined {
    if (DeviceHelper.isPC()) {
      return MultiInputRecentProxy.getInstance().getCurrentSelectedItem();
    }
    return AppStorage.get('recentSelectedItem');
  }

  private closeStatusBarSecondaryPanel(slot: string): void {
    windowMgr.hideWindowWithAnim(slot);
    statusbarPlCtrl.changeStatusBarOrDockVisibilityInImmersive(false);
  }
}
