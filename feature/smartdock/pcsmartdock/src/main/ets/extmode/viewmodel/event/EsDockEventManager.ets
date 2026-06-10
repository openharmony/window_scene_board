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
import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBSceneSessionManager,
  SCBScreenSession,
  SCBSceneContainerSessionArray,
  SCBSceneMode,
  SCBSpecificSession,
  ScenePanelState
} from '@ohos/windowscene';
import {
  DeviceHelper,
  GlobalContext,
  localEventManager,
  viewMgrPolicy,
  ViewType,
  DockInfo,
  DockInfoEventListener
} from '@ohos/frameworkwrapper';
import { ExtendScreenDockEvent } from './ExtendScreenDockEvent';
import { PcDockAnimationMgr } from '../../../default/manager/PcDockAnimationMgr';
import { AppCenterModel, DockItemInfo, EventConstants } from '@ohos/launchercommon';

const TAG = 'EsDockEventManager';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export type EsDockEventListener = (evt: ExtendScreenDockEvent) => void;

export type ArrowChangeCallback = () => void;
export type WidthChangeCallback = () => void;

/**
 * Dock栏跨组件事件管理器
 */
export class EsDockEventManager {
  private static instance: EsDockEventManager | null;
  private mListeners: Map<number, Set<EsDockEventListener>> = new Map();
  private mScreenModes: Map<number, boolean> = new Map();
  private mArrowChangeCallbacks: Set<ArrowChangeCallback> = new Set();
  private mWidthChangeCallbacks: Set<WidthChangeCallback> = new Set();
  private showDockDelayTimerId: number | null = null;
  private mTopFullScreenSubSession: SCBSpecificSession | null = null;
  private readonly BUILT_IN_SCREEN_ID = 0;
  private needHideDockAfterPopupExit: boolean = false;
  private readonly mLocalEventListener: DockInfoEventListener = {
    onReceiveEvent: (event: string, params: object | number): void => {
      logger.showInfo(`onReceiveEvent ${event} ${JSON.stringify(params)}`);
      switch (event) {
        case EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE:
          this.handleDockVisibilityChange(params as DockInfo);
          break;
        case EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK:
          this.hideDockAfterPopupExit(params as number);
          break;
        case EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK:
          this.setNeedHideDockAfterPopupExit(params as number, false);
          break;
      }
    }
  };

  private constructor() {
    this.mListeners.clear();
    this.mArrowChangeCallbacks.clear();
    this.mWidthChangeCallbacks.clear();
  }

  public handleScreenConnect(screenSession: SCBScreenSession): void {
    logger.showInfo(`onScreenConnect ${screenSession.session?.screenId}-${this.mScreenModes.size}`);

    let sid = screenSession.session?.screenId;
    this.mScreenModes.set(sid, screenSession.isExtendScreen);
    logger.showInfo(`update screen modes ${this.mScreenModes.size}-${screenSession.isExtendScreen}`);

    if (!this.isFromMainScreen(sid)) {
      localEventManager.registerEventListener(this.mLocalEventListener,
        [EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE,
         EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK,
         EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK]);
    }
  }

  public handleScreenDisconnect(screenId: number): void {
    logger.showInfo(`onScreenDisconnect ${screenId}`);
    this.mListeners.clear();
    this.mArrowChangeCallbacks.clear();
    this.mWidthChangeCallbacks.clear();
    localEventManager.unregisterEventListener(this.mLocalEventListener);
    if (this.mScreenModes.has(screenId)) {
      this.mScreenModes.delete(screenId);
      PcDockAnimationMgr.release(screenId);
      logger.showInfo(`screen modes ${this.mScreenModes.size}`);
    }
  }

  public handleScreenModeChange(mainScreenId: number, extendScreenId: number): void {
    logger.showInfo(`handleScreenModeChange ${mainScreenId}-${extendScreenId}`);
    if (this.mScreenModes.has(mainScreenId)) {
      if (this.mScreenModes.get(mainScreenId)) {
        logger.showInfo(`screen ${mainScreenId} mode change from extend to main`);
        PcDockAnimationMgr.release(mainScreenId);
        this.mScreenModes.set(mainScreenId, false);
      }
    }
    if (this.mScreenModes.has(extendScreenId)) {
      if (!this.mScreenModes.get(extendScreenId)) {
        logger.showInfo(`screen ${extendScreenId} mode change from main to extend`);
        PcDockAnimationMgr.release(extendScreenId);
        this.mScreenModes.set(extendScreenId, true);
      }
    }
  }

  private isFromMainScreen(screenId: number): boolean {
    return SCBSceneSessionManager.getInstance().mainScreenId === screenId || screenId === undefined;
  }

  private handleDockVisibilityChange(param: DockInfo): void {
    if (CheckEmptyUtils.isEmpty(param)) {
      return;
    }
    // 如果发送过来的param只是一个bool值，扩展屏不处理
    if (this.isFromMainScreen(param.screenId) || (typeof param === 'boolean')) {
      logger.showInfo(`handleDockVisibilityChange ignore main screen param:${param}`);
      return;
    }
    const dockShow: boolean = param.isVisible;
    const screenId: number = param.screenId;
    logger.showInfo(`handleDockVisibilityChange ${dockShow} screenId:${screenId}`);
    if (AppCenterModel.getInstance().isShow(screenId) || AppStorage.get('showRecent')) {
      logger.showInfo('app_center or recent showing, dock not change');
      return;
    }
    let isPreSplit: boolean = SCBSceneSessionManager.getInstance().isScenePanelInState(screenId, ScenePanelState.SPLIT);
    if (isPreSplit) {
      logger.showInfo('split, dock not change');
      return;
    }
    let sessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
    if (sessionList === undefined || sessionList === null) {
      logger.showError('Failed to get containerSessionList');
      return;
    }
    let canShow =
      this.canUpdateSmartDockForSubWindow(sessionList, screenId) || this.whetherShowSmartDock(sessionList, screenId);
    if (canShow && dockShow) {
      logger.showInfo('handleDockVisibilityChange callOutDockWithDelay');
      const DELAY_CALL_OUT_DOCK_MS = 200;
      this.doShowDockWithDelay(DELAY_CALL_OUT_DOCK_MS, screenId);
      return;
    }
    this.clearShowDockDelayTimer();
    if (!dockShow && canShow) {
      this.doHideSmartDock(screenId);
      return;
    }
  }

  public setNeedHideDockAfterPopupExit(screenId: number, needHideDock: boolean): void {
    logger.showInfo('setNeedHideDockAfterPopupExit:' + needHideDock + ' screenId:' + screenId);
    if (!this.isFromMainScreen(screenId)) {
      this.needHideDockAfterPopupExit = needHideDock;
    }
  }

  private hideDockAfterPopupExit(screenId: number): void {
    logger.showInfo(`hideDockAfterPopupExit: ${this.needHideDockAfterPopupExit} screenId:${screenId}`);
    if (this.isFromMainScreen(screenId)) {
      return;
    }
    if (this.needHideDockAfterPopupExit) {
      this.doHideSmartDock(screenId);
      this.needHideDockAfterPopupExit = false;
    }
  }

  private canUpdateSmartDockForSubWindow(sessionList: SCBSceneContainerSessionArray, curScreenId?: number): boolean {
    this.mTopFullScreenSubSession = null;
    for (let i = sessionList.length - 1; i >= 0; i--) {
      let item = sessionList[i];
      curScreenId = curScreenId === undefined ? item?.screenProperty?.screenId : curScreenId;
      let topFullScreenSubSession = SCBSceneSessionManager.getInstance()
        .getTopFullScreenSubSession(curScreenId, item);
      if (topFullScreenSubSession) {
        this.mTopFullScreenSubSession = topFullScreenSubSession;
        logger.showInfo('update dock for sub window, layoutFullScreen: ' + topFullScreenSubSession.layoutFullScreen +
          ', id: ' + topFullScreenSubSession.session?.persistentId);
        return topFullScreenSubSession.layoutFullScreen && topFullScreenSubSession.dockHoverShowEnabled;
      }
    }
    return false;
  }

  private clearShowDockDelayTimer(): void {
    if (this.showDockDelayTimerId) {
      clearTimeout(this.showDockDelayTimerId);
      this.showDockDelayTimerId = null;
    }
  }

  private doHideSmartDock(screenId: number): void {
    logger.showInfo('handleDockVisibilityChange callHideSmartDock');
    if (AppCenterModel.getInstance().isShow(screenId) || AppStorage.get('showRecent')) {
      // 任务中心或者应用中心界面不隐藏
      logger.showInfo('app_center or recent showing, dock not hide');
      return;
    }
    if (GlobalContext.getInstance().hasObject('setWholeDockVisibilityWithAnimation')) {
      let setWholeDockVisibilityWithAnimation =
        (GlobalContext.getInstance().getObject('setWholeDockVisibilityWithAnimation')) as Function;
      setWholeDockVisibilityWithAnimation(screenId, false);
    } else {
      viewMgrPolicy.hideView(this.getDockViewType(screenId));
    }
  }

  private doShowDockWithDelay(delay: number, screenId: number): void {
    this.clearShowDockDelayTimer();
    this.showDockDelayTimerId = setTimeout(() => {
      if (GlobalContext.getInstance().hasObject('setWholeDockVisibilityWithAnimation')) {
        let setWholeDockVisibilityWithAnimation =
          (GlobalContext.getInstance().getObject('setWholeDockVisibilityWithAnimation')) as Function;
        setWholeDockVisibilityWithAnimation(screenId, true);
      } else {
        viewMgrPolicy.showView(this.getDockViewType(screenId));
      }
    }, delay);
  }

  private getDockViewType(screenId: number): ViewType {
    return this.isFromMainScreen(screenId) ? ViewType.SMART_DOCK : ViewType.SMART_DOCK_EXT_SCREEN;
  }

  private whetherShowSmartDock(sessionList: SCBSceneContainerSessionArray, screenId?: number): boolean {
    if (this.mTopFullScreenSubSession) {
      logger.showInfo('has fullscreen sub window in extend screen.');
      return false;
    }
    if (screenId === undefined) {
      logger.showWarn('whetherShowSmartDock screenId is undefined');
      screenId = SCBSceneSessionManager.getInstance().mainScreenId;
    }
    for (let i = sessionList.length - 1; i >= 0; i--) {
      let item = sessionList[i];
      if (screenId !== item?.screenProperty?.screenId) {
        logger.showWarn(`screenId not same. screenId = ${screenId}, ` +
          `container = [${item?.primarySession?.sceneInfo?.bundleName}, ${item?.screenProperty?.screenId}]`);
        continue;
      }
      let isHavePrimarySession = item !== null && item.isActive && item.primarySession !== null;
      let isSplitScreen = (item.isSplit && item.secondarySession !== null);
      let isFullScreen = item.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN;
      let isLayoutFullScreen = item.primarySession?.layoutFullScreen;
      logger.showInfo(`sceneInfo, Name: ${item.getBundleName()}, ${isHavePrimarySession}, ${isSplitScreen}, ` +
        `${isFullScreen}, ${isLayoutFullScreen}`)
      if (isHavePrimarySession && !item.primarySession?.isMinimizing) {
        if (isSplitScreen) {
          return DeviceHelper.isPC() && !AppStorage.get<boolean>('isDockAutoHide') ? false : true;
        }
        if (!isFullScreen) {
          continue;
        }
        if (SCBSceneSessionManager.getInstance().isPcMode() || isLayoutFullScreen) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  public static getInstance(): EsDockEventManager {
    if (!EsDockEventManager.instance) {
      EsDockEventManager.instance = new EsDockEventManager();
    }
    return EsDockEventManager.instance;
  }

  public registerArrowChangeCallback(cb: ArrowChangeCallback): void {
    logger.showInfo('registerArrowChangeCallback');

    if (!cb) {
      logger.showInfo('cb null');
      return;
    }

    if (!this.mArrowChangeCallbacks.has(cb)) {
      this.mArrowChangeCallbacks.add(cb);
    }
  }

  public unregisterArrowChangeCallback(cb: ArrowChangeCallback): void {
    logger.showInfo(`unregisterArrowChangeCallback`);

    if (this.mArrowChangeCallbacks.has(cb)) {
      this.mArrowChangeCallbacks.delete(cb);
    }
  }

  public doArrowChangeCallback(): void {
    logger.showInfo('doArrowChangeCallback');

    this.mArrowChangeCallbacks.forEach((cb: ArrowChangeCallback) => {
      cb();
    });
  }

  public registerWidthChangeCallback(cb: WidthChangeCallback): void {
    logger.showInfo('registerWidthChangeCallback');

    if (!cb) {
      logger.showInfo('cb null');
      return;
    }

    if (!this.mWidthChangeCallbacks.has(cb)) {
      this.mWidthChangeCallbacks.add(cb);
    }
  }

  public unregisterWidthChangeCallback(cb: WidthChangeCallback): void {
    logger.showInfo(`unregisterWidthChangeCallback`);

    if (this.mWidthChangeCallbacks.has(cb)) {
      this.mWidthChangeCallbacks.delete(cb);
    }
  }

  public doWidthChangeCallback(): void {
    logger.showInfo('doWidthChangeCallback');

    this.mWidthChangeCallbacks.forEach((cb: WidthChangeCallback) => {
      cb();
    });
  }

  public registerEsDockEventListener(evtCode: number, listener: EsDockEventListener): void {
    logger.showInfo('registerEsDockEventListener');

    if (!ExtendScreenDockEvent.isValid(evtCode)) {
      logger.showWarn(`Invalid event code = ${evtCode}`);
      return;
    }

    let listenerSet: Set<EsDockEventListener> | undefined = this.mListeners.get(evtCode);
    if (CommonUtils.isInvalid(listenerSet)) {
      listenerSet = new Set<EsDockEventListener>();
      this.mListeners.set(evtCode, listenerSet);
    }

    listenerSet?.add(listener);
  }

  public unregisterEsDockEventListener(evtCode: number, listener: EsDockEventListener): void {
    logger.showInfo(`unregisterEsDockEventListener`);

    if (!ExtendScreenDockEvent.isValid(evtCode)) {
      logger.showWarn(`Invalid event code = ${evtCode}`);
      return;
    }

    let result = this.mListeners.get(evtCode)?.delete(listener);
    logger.showInfo(`off result ${result}, event ${evtCode}`);
  }


  public unregisterEsDockEventListeners(evtCode: number): void {
    logger.showInfo(`unregisterEsDockEventListeners`);

    if (!ExtendScreenDockEvent.isValid(evtCode)) {
      logger.showWarn(`Invalid event code = ${evtCode}`);
      return;
    }

    this.mListeners.delete(evtCode);
    logger.showInfo(`unregisterEsDockEventListeners end ${this.mListeners.size}`);
  }

  public unregisterAllEsDockEventListeners(): void {
    logger.showInfo(`unregisterAllEsDockEventListeners`);

    this.mListeners.clear();
    logger.showInfo(`unregisterAllEsDockEventListeners end ${this.mListeners.size}`);
  }

  public postEsDockEvent(evtCode: number, params?: DockItemInfo[]): void {
    logger.showInfo(`postEsDockEvent-${evtCode}`);

    if (!ExtendScreenDockEvent.isValid(evtCode)) {
      logger.showWarn(`Invalid event code = ${evtCode}`);
      return;
    }

    let event: ExtendScreenDockEvent = this.createEsDockEvent(evtCode, params);
    this.mListeners.get(evtCode)?.forEach((listener) => {
      listener(event);
    });
  }

  private createEsDockEvent(eventType: number, params?: DockItemInfo[]): ExtendScreenDockEvent {
    let event = new ExtendScreenDockEvent();
    event.eventType = eventType;
    event.eventParams = params ?? [];
    return event;
  }

  public static destroy(): void {
    EsDockEventManager.instance?.doDestroy();
    EsDockEventManager.instance = null;
  }

  private doDestroy(): void {
    this.mListeners.clear();
    this.clearShowDockDelayTimer();
  }
}