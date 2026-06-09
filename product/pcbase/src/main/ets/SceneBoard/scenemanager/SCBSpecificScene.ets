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

import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  Log,
  LogDomain,
  LogHelper, SingleContext,
} from '@ohos/basicutils';
import {
  ApsUtils,
  ViewArea,
  ViewType,
  viewMgrPolicy, localEventManager,
} from '@ohos/frameworkwrapper';
import {
  ExecuteCallbackExtraInfo,
  SCBSceneSessionManager,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SCBSpecificSceneSessionList,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSceneSession,
  windowMgr,
  ACTIVE_STATUS_MAP,
  INVALID_PID,
  FocusChangeReason,
  SessionDisplayChangeReason,
  SessionChangeInfo,
  SCBSessionEventId,
  SCBWindowRaiseReason,
  SCBSceneMode,
  sSCBOobeManager,
  SystemBarType,
  SCBWindowShadowConfig,
  SCBSubWindowAnchorInfo
} from '@ohos/windowscene';
import Curves from '@ohos.curves';
import { WindowAnimationUtils } from '@ohos/windowscene/Index';
import { EventConstants, LayoutViewModel, StyleConstants } from '@ohos/launchercommon'
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { styleMgr } from '@ohos/systemuicommon';
import {
  SystemAnimatedScene,
  systemAniSceneCtrl,
  SCBSessionListManager
} from '@ohos/pcmode';
import { PCUtils } from '../../common/utils/PCUtils';

const TAG = 'SCBSpecificScene';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Component
export struct SCBSpecificScene {
  @ObjectLink @Watch('buildSCBSpecificScene') specificSession: SCBSpecificSession;
  @Link screenProperty: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @ObjectLink @Watch('onRectChange') rect: SCBSessionRect;
  @ObjectLink parentRect: SCBSessionRect;
  @ObjectLink parentSceneSession: SCBSceneSession | null;
  @ObjectLink subWindowAnchorInfo: SCBSubWindowAnchorInfo;
  private windowAnimationUtils: WindowAnimationUtils = WindowAnimationUtils.getInstance();
  @State subList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  @State isFollowParentWindowLayout: boolean = false;
  private TYPE_FLOAT_START_Z_ORDER: number = 926;
  getScreenDpiDensity: Function = (): number => 0;
  isStartMove: boolean = false;
  isStartDrag: boolean = false;

  buildSCBSpecificScene(): void {
    log.showDebug('buildSCBSpecificScene id: ' + this.specificSession?.session.persistentId);
  }

  onRectChange(): void {
    this.cacheInputMethodRect(this.rect);
  }

  enableShow(): boolean {
    if (!this.specificSession) {
      log.showError('enable show is false, specificSession is null');
      return false;
    }

    if (this.specificSession.isCustomAnimationPlaying) {
      log.showDebug('enable show is true, is playing custom animation');
      return true;
    }

    if (this.specificSession.isActive) {
      log.showInfo('enable show is true' + ', id: ' + this.specificSession?.session?.persistentId +
        ', type: ' + this.specificSession?.session?.type);
      return true;
    }
    log.showInfo('enable show is false' + ', id: ' + this.specificSession?.session?.persistentId +
      ', type: ' + this.specificSession?.session?.type);

    return false;
  }

  private cacheInputMethodRect(rect: SCBSessionRect): void {
    if (this.specificSession.session.type === sceneSessionManager.SessionType.TYPE_INPUT_METHOD_STATUS_BAR) {
      log.showInfo(`TYPE_INPUT_METHOD:${this.specificSession.session.type}
        ${this.specificSession.session.persistentId} ${JSON.stringify(rect)}`);
      windowMgr.setInputMethodRectCache(this.specificSession.session.persistentId, rect?.copy());
    }
  }

  onSessionRectChangeRelativeParent(rect: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason, fromParent: boolean) {
    if (!this.specificSession) {
      log.showError('specificSession is null');
      return;
    }
    const currRect: SCBSessionRect = this.specificSession.currRect;
    log.showInfo('onSessionRectChangeRelativeParent start, id: ' + this.specificSession.session.persistentId +
      ' reason: ' +
      reason + ', rect: [' + rect.posX_ + ', ' + rect.posY_ + ', ' + rect.width_ + ', ' + rect.height_ + ']' +
      ', currRect: [' + currRect?.left.getPx() + ', ' + currRect?.top.getPx() + ', ' +
    currRect?.width.getPx() + ', ' + currRect?.height.getPx() + ']');
    if (this.isSessionRectChange(rect) === false) {
      log.showDebug('session rect not change');
      return;
    }
    const newRect: SCBSessionRect = this.specificSession.currRect.copy();
    if ((reason === sceneSessionManager.SessionSizeChangeReason.RESIZE ||
      reason === sceneSessionManager.SessionSizeChangeReason.RESIZE_BY_LIMIT) && !fromParent) {
      newRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
    } else {
      newRect.setPosNum(rect.posX_, rect.posY_);
    }
    let context: UIContext = this.getUIContext();
    if (context && this.specificSession.isCrossingScreen) {
      context.animateTo({
        duration: 0
      }, () => {
        if (this.rect) {
          this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
        }
      });
    } else {
      if (this.rect) {
        this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
      }
    }

    log.showInfo('onSessionRectChangeRelativeParent end, id: ' + this.specificSession.session.persistentId +
      ' reason: ' +
      reason + ',  this.rect: [' + this.rect?.left.getPx() + ', ' + this.rect?.top.getPx() + ', ' +
    this.rect?.width.getPx() + ', ' + this.rect?.height.getPx() + ']');
  }

  onSessionRectChange(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason,
    displayId: number) {
    if (!this.specificSession) {
      log.showError('specificSession is null');
      return;
    }
    const currRect: SCBSessionRect = this.specificSession.currRect;
    log.showInfo('onSessionRectChange start, id: ' + this.specificSession.session.persistentId + ' reason: ' +
      reason + ', rect: [' + rect.posX_ + ', ' + rect.posY_ + ', ' + rect.width_ + ', ' + rect.height_ + ']' +
      ', currRect: [' + currRect?.left.getPx() + ', ' + currRect?.top.getPx() + ', ' +
      currRect?.width.getPx() + ', ' + currRect?.height.getPx() + ']');
    if (this.isSessionRectChange(rect) === false) {
      log.showDebug('session rect not change');
      return;
    }
    const newRect: SCBSessionRect = this.createNewRectWithChangeReason(rect, reason, displayId);
    let parentSession: SCBSceneSession | null = this.specificSession?.getParentSession();
    let context: UIContext = this.getUIContext();
    if (this.specificSession.isCrossingScreen && context) {
      context.animateTo({
        duration: 0
      }, () => {
        this.springBackIfNeeded(reason, newRect);
      })
    } else {
      this.springBackIfNeeded(reason, newRect);
    }
    log.showInfo('onSessionRectChange end, id: ' + this.specificSession.session.persistentId + ' reason: ' +
      reason + ', currRect: [' + currRect?.left.getPx() + ', ' + currRect?.top.getPx() + ', ' +
      currRect?.width.getPx() + ', ' + currRect?.height.getPx() + ']');
  }

  private isSessionRectChange(rect: sceneSessionManager.SessionRect): boolean {
    const currRect: SCBSessionRect = this.specificSession.currRect;
    return (rect.posX_ !== currRect?.left.getPx()) ||
      (rect.posY_ !== currRect?.top.getPx()) ||
      (rect.width_ !== currRect?.width.getPx()) ||
      (rect.height_ !== currRect?.height.getPx());
  }

  private isSubWindowSamePidAsParent(parentSession: SCBSceneSession | null): boolean {
    if (parentSession && this.specificSession) {
      return parentSession.pid === this.specificSession.pid && this.specificSession.pid !== INVALID_PID;
    } else {
      log.showError('session invalid');
      return false;
    }
  }

  private createNewRectWithChangeReason(rect: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason, displayId: number): SCBSessionRect {
    const newRect: SCBSessionRect = this.specificSession.currRect.copy();
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      newRect.setPosNum(rect.posX_, rect.posY_);
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
      newRect.setSizeNum(rect.width_, rect.height_);
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END && displayId !== -1) {
      // 跨屏场景已在SCBPcScenePanelManager里处理
      log.showInfo(`createNewRectWithChangeReason cross screen drag`);
    } else {
      newRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
    }
    return newRect;
  }

  private handleTargetPositionXWithLimit(newRect: SCBSessionRect): number {
    const screenWidth = this.screenProperty.width;
    let targetPositionX = newRect.left.getPx();
    const targetWidth = newRect.width.getPx();
    const leftThreshold = vp2px(StyleConstants.DEFAULT_AVOID_AREA);
    if (targetPositionX + targetWidth < leftThreshold) {
      log.showDebug(`onSessionRectChange, reaching left threshold: ${leftThreshold}`);
      targetPositionX = leftThreshold - targetWidth;
    }
    const rightThreshold = screenWidth - vp2px(StyleConstants.DEFAULT_AVOID_AREA);
    if (targetPositionX > rightThreshold) {
      log.showDebug(`onSessionRectChange, reaching right threshold: ${rightThreshold}`);
      targetPositionX = rightThreshold;
    }
    return targetPositionX;
  }

  private handleTargetPositionYWithLimit(newRect: SCBSessionRect): number {
    let targetPositionY = newRect.top.getPx();
    // top area
    const screenId = this.screenProperty.screenId;
    let topThreshold = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar && statusBar.getVisibility()) {
      topThreshold = statusBar.currRect.height.getPx() + statusBar.currRect.top.getPx();
    }
    if (targetPositionY < topThreshold) {
      log.showInfo(`onSessionRectChange, reaching top threshold: ${topThreshold}`);
      targetPositionY = topThreshold;
    }
    // bottom area
    let bottomThreshold = this.screenProperty.height -
      PCUtils.vp2px(this.getUIContext(), StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT);
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    if (dock && dock.getVisibility()) {
      const dockHeight = dock.currRect.height.getPx();
      bottomThreshold = bottomThreshold - dockHeight;
    }
    if (targetPositionY > bottomThreshold) {
      log.showDebug(`onSessionRectChange, reaching bottom threshold: ${bottomThreshold}`);
      targetPositionY = bottomThreshold;
    }
    return targetPositionY;
  }

  private springBackIfNeeded(reason: sceneSessionManager.SessionSizeChangeReason, newRect: SCBSessionRect): void {
    if (!this.specificSession) {
      log.showError('springBackIfNeeded specificSession is null');
      return;
    }
    if (this.rect) {
      this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
    }
    const isValidWindow: boolean = this.specificSession?.isSubWindow() || this.specificSession?.isDialogWindow();
    if (isValidWindow === true && reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
      const lastTargetPositionX = newRect.left.getPx();
      const lastTargetPositionY = newRect.top.getPx();
      const targetPositionX: number = this.handleTargetPositionXWithLimit(newRect);
      let targetPositionY: number = this.handleTargetPositionYWithLimit(newRect);
      if (lastTargetPositionX !== targetPositionX || lastTargetPositionY !== targetPositionY) {
        newRect.setPosNum(targetPositionX, targetPositionY);
        this.getUIContext()?.animateTo({ curve: Curve.EaseOut, duration: 200 }, () => {
          if (this.rect) {
            this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
          }
        })
      }
    }
  }

  onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.specificSession?.setTouchable(isTouchable);
  }

  private onClickModalWindowOutside(): void {
    animateTo(
      {
        duration: 10,
        curve: Curve.Linear,
      }, () => {
        this.specificSession.translateX += 1;
    });
    animateTo(
      {
        delay: 10,
        duration: 1000,
        curve: Curves.interpolatingSpring(300, 1, 428, 13),
      }, () => {
        this.specificSession.translateX -= 1;
    });
  }

  initSpecialWindowEffectConfig() {
    this.specificSession.setSpecialWindowEffectConfig();
  }

  registerBufferAvailableChangeCallback() {
    this.specificSession?.session?.on('bufferAvailableChange', (isBufferAvailable: boolean) => {
      if (!this.specificSession) {
        log.showInfo(`specificSession is null`);
        return;
      }
      log.showInfo(`bufferAvailableChange, isBufferAvailable: ${isBufferAvailable}`);
      this.specificSession.isBufferAvailable = isBufferAvailable;
      if (isBufferAvailable === true && !this.specificSession.isCrossingScreen) {
        this.specificSession.setSpecialWindowEffectConfig();
      }
    });
  }

  private getSubWindowList(parentId: number): SCBSpecificSceneSessionList {
    if (this.specificSession?.session.persistentId !== parentId) {
      log.showError('Invalid scene session');
      return [];
    }
    return this.subList;
  }

  private onSubSessionStateChange = (parentId: number, persistentId: number,
                                     state: sceneSessionManager.SessionState): void => {
    let subList = this.getSubWindowList(parentId);
    this.onSubWindowStateChange(subList, persistentId, state);
  }

  private onSubWindowStateChange(subWindowList: SCBSpecificSceneSessionList, persistentId: number,
                                 state: sceneSessionManager.SessionState): void {
    const index: number = subWindowList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      return;
    }
    let isActive: boolean | undefined = ACTIVE_STATUS_MAP.get(state)
    if (isActive === undefined || !subWindowList[index]) {
      return;
    }
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      subWindowList.splice(index, 1);
      SCBSceneSessionManager.getInstance().refreshZOrder();
      return;
    }
    subWindowList[index].isActive = isActive;
    subWindowList[index].sessionData.sessionState = state;
    log.showInfo(`Status change, persistentId: ${persistentId}, length: ${subWindowList.length}}`);
  }

  private onSubSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void => {
    if (persistentId === targetSubWindowId) {
      return;
    }
    let subList = this.getSubWindowList(parentId);
    const targetIndex: number = subList.findIndex(item => {
      return item.session.persistentId === targetSubWindowId;
    });

    const currIndex: number = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (targetIndex !== -1 && currIndex !== -1) {
      let currSession: SCBSpecificSession = subList[currIndex];
      subList.splice(currIndex, 1);
      subList.splice(targetIndex, 0, currSession);
      log.showInfo(`onSubSessionRaiseAboveTarget, targetIndex: ${targetIndex}, length: ${subList.length}`);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  private onSubSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean): void => {
    log.showInfo('onSubSessionRaiseToTop, parentId: ' + parentId + ', id: ' + persistentId +
      ', raiseParent: ' + raiseParent);
    let subList = this.getSubWindowList(parentId);
    let index: number = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      return;
    }
    let curSession: SCBSpecificSession = subList[index];
    subList.splice(index, 1);
    SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
    log.showInfo(`onSubSessionRaiseToTop, index: ${index}, length: ${subList.length}`);
    if (SCBSceneSessionManager.getInstance().getFocusedSessionId(this.screenProperty.screenId) === parentId ||
      SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId)?.session.parentId ===
      parentId) {
      SCBSceneSessionManager.getInstance().requestFocus(persistentId, undefined, FocusChangeReason.MOVE_UP);
    }
    if (raiseParent) {
      let floatSession: SCBSpecificSession | null = this.getFloatInAncestorSession(curSession);
      let mainSession: SCBSceneSession | null = SCBSceneSessionManager.getInstance().findMainSessionById(parentId);
      if (mainSession == null) {
        return;
      }
      SCBSceneSessionManager.getInstance().requestToTop(mainSession.sceneInfo.screenId,
        mainSession.session.persistentId);
      let floatOrMainSession: SCBSceneSession | SCBSpecificSession = floatSession != null ? floatSession : mainSession;
      this.updateMultiSubSessionLevel(floatOrMainSession, persistentId);
    }
    SCBSessionListManager.refreshZOrder();
  }

  private onSubSessionZLevelChange = (parentId: number, persistentId: number, zLevel: number): void => {
    log.showInfo('onSubSessionZLevelChange, parentId: ' + parentId + ', id: ' + persistentId +
      ', zLevel: ' + zLevel);
    let subList = this.getSubWindowList(parentId);
    if (!subList) {
      log.showError('subList is empty');
      return;
    }

    let index: number = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showInfo(`onSubSessionZLevelChange find no subSession: ${persistentId}`);
      return;
    }

    let curSession = subList[index];
    let lastZLevel = curSession.session.zLevel;
    curSession.session.zLevel = zLevel;
    log.showInfo(`[SCBSub] onSubSessionZLevelChange, index: ${index}, Id: ${curSession.session.persistentId}`);
    if (index === subList.length - 1 && zLevel > lastZLevel) {
      log.showInfo(`[SCBSub] onSubSessionZLevelChange curSession does not need raise`);
      return;
    }
    subList.splice(index, 1);
    SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
    SCBSessionListManager.refreshZOrder();
    log.showInfo(`onSubSessionZLevelChange, index: ${index}, length: ${subList.length}`);
  }

  private onCreateSubSession = (sceneSession: SCBSpecificSession,
                                specificSession: sceneSessionManager.SceneSession): void => {
    let subList = this.getSubWindowList(sceneSession.session.persistentId);
    const indexInAll: number = subList.findIndex(item => {
      return item.session.persistentId === specificSession.persistentId;
    });
    if (indexInAll !== -1) {
      log.showInfo(`Session is already in subList, id: ${specificSession.persistentId}, index: ${indexInAll}`);
    } else {
      let hwSceneSession = new SCBSpecificSession(specificSession, {
        stateChangeCallback: this.onSubSessionStateChange,
        raiseToTopCallback: this.onSubSessionRaiseToTop,
        raiseAboveTargetCallback: this.onSubSessionRaiseAboveTarget,
        zLevelChangeCallback: this.onSubSessionZLevelChange,
        screenId: this.screenProperty.screenId
      });
      SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, subList);
      Log.showInfo(TAG, 'create subSession success, + id: ' + specificSession.persistentId);
      SCBSessionListManager.refreshZOrder();
    }
  }

  private updateMultiSubSessionLevel(floatOrMainSession: SCBSceneSession | SCBSpecificSession,
                                     persistentId: number): void {
    let needUpdateParentSessionList: SCBSpecificSession[] = [];
    this.getAncestorSCBSpecificSessions(floatOrMainSession, persistentId, needUpdateParentSessionList);
    let needHandlePersistentIds = needUpdateParentSessionList.map(item => item.session.persistentId);
    log.showInfo(`onSubSessionRaiseToTop, raise parent for point down subWindow, id: ${persistentId}, ` +
       `ancestorId: ${floatOrMainSession.session.persistentId} needHandlePersistentIds: ` +
       `${JSON.stringify(needHandlePersistentIds)}`);
    let parentSession: SCBSceneSession | SCBSpecificSession = floatOrMainSession;
    for (let i = needUpdateParentSessionList.length - 1; i >= 0; i--) {
      let index: number = parentSession.subSessionList.findIndex(item => {
        return item.session.persistentId === needUpdateParentSessionList[i].session.persistentId;
      });
      if (index === -1) {
        continue;
      }
      let curSession: SCBSpecificSession = parentSession.subSessionList[index];
      parentSession.subSessionList.splice(index, 1);
      SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, parentSession.subSessionList);
      parentSession = needUpdateParentSessionList[i];
    }
  }

  private getAncestorSCBSpecificSessions(parentSession: SCBSceneSession | SCBSpecificSession, persistentId: number,
                                         parentSessionList: Array<SCBSpecificSession>): boolean {
    if (!parentSession) {
      return false;
    }
    if (parentSession.session.persistentId === persistentId) {
      return true;
    }
    for (let i = parentSession.subSessionList.length - 1; i >= 0; --i) {
      if (this.getAncestorSCBSpecificSessions(parentSession.subSessionList[i], persistentId, parentSessionList)) {
        if (parentSession instanceof SCBSpecificSession) {
          parentSessionList.push(parentSession);
        }
        return true;
      }
    }
    return false;
  }

  private isHasModalApplicationSubSession(parentSession: SCBSceneSession | SCBSpecificSession): boolean {
    if (!parentSession) {
      return false;
    }
    for (let i = parentSession.subSessionList.length - 1; i >= 0; --i) {
      let subSession = parentSession.subSessionList[i];
      if (!subSession || !subSession.isSessionForeground()) {
        continue;
      }
      if (subSession.isModalApplication() || this.isHasModalApplicationSubSession(subSession)) {
        return true;
      }
    }
    return false;
  }

  private getFloatInAncestorSession(subSession: SCBSpecificSession): SCBSpecificSession | null {
    if (!subSession) {
      return null;
    }
    let parentSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSessionById(subSession.session.parentId);
    if (!parentSession) {
      return null;
    }
    if (parentSession instanceof SCBSpecificSession) {
      if (parentSession.isSubWindow()) {
        let floatSession = this.getFloatInAncestorSession(parentSession);
        if (floatSession) {
          return floatSession;
        }
      } else if (parentSession.isFloatWindow()) {
        return parentSession;
      } else {
        return null;
      }
    }
    return null;
  }

  private updateFloatOfSubSessionsZOrder(subSession: SCBSpecificSession, persistentIds: Array<number>): void {
    if (!subSession) {
      return;
    }
    for (let i = 0; i < subSession.subSessionList.length; ++i) {
      let subSessionItem = subSession.subSessionList[i];
      if (!subSessionItem || !subSessionItem.isSessionForeground()) {
        continue;
      }
      persistentIds.push(subSessionItem.session.persistentId);
      this.updateFloatOfSubSessionsZOrder(subSessionItem, persistentIds);
    }
  }

  private getUppermostModalSession(subSessionList: Array<SCBSpecificSession>): SCBSpecificSession | null {
    if (!subSessionList) {
      return null;
    }
    for (let i = subSessionList.length - 1; i >= 0; --i) {
      let subSession = subSessionList[i];
      if (!subSession || !subSession.isSessionForeground()) {
        continue;
      }
      let modelSession = this.getUppermostModalSession(subSession.subSessionList);
      if (modelSession) {
        return modelSession;
      }
      if (subSession.isModal()) {
        return subSession;
      }
    }
    return null;
  }

  private getFloatSessionZOrder(floatSession: SCBSpecificSession): number {
    let zOrder: number = this.TYPE_FLOAT_START_Z_ORDER;
    if (!floatSession || !floatSession.session) {
      log.showError('setParentSession floatSession is empty');
      return zOrder;
    }
    try {
      let result = floatSession.session.getZOrder();
      if (result != undefined) {
        zOrder = result;
      }
    } catch (e) {
      log.showError('setParentSession get getZOrder failed');
    }
    return zOrder;
  }

  private handleNewAncestorSessionHasFloat(subSession: SCBSpecificSession): SCBSpecificSession | null {
    let floatSession = this.getFloatInAncestorSession(subSession);
    if (!floatSession) {
      return floatSession;
    }
    // 存在悬浮窗，特殊处理层级刷新(包括悬浮窗在后台的情况)
    let startZOrder = this.getFloatSessionZOrder(floatSession) + 1;
    log.showInfo(`setParentSession floatSession id: ${floatSession.session.persistentId} ` +
      `startZOrder: ${startZOrder}`);
    let persistentIds: number[] = [];
    this.updateFloatOfSubSessionsZOrder(floatSession, persistentIds);
    SCBSceneSessionManager.getInstance().refreshPcZOrder(startZOrder, persistentIds);
    return floatSession;
  }

  private raiseToTopAndModalSessionRequestFocus(subSession: SCBSpecificSession,
                                                subSessionList: Array<SCBSpecificSession>,
                                                oldMainSession: SCBSceneSession | null,
                                                floatSession: SCBSpecificSession | null): void {
    let newIsModalApplication: boolean = false;
    if (floatSession) {
      this.updateMultiSubSessionLevel(floatSession, subSession.session.persistentId);
    } else {
      let mainSession: SCBSceneSession | null =
        SCBSceneSessionManager.getInstance().findMainSessionById(subSession.session.parentId);
      if (mainSession) {
        newIsModalApplication = this.isHasModalApplicationSubSession(mainSession);
        log.showInfo(`setParentSession mainSession requestToTop id: ${mainSession.session.persistentId} ` +
          `newIsModalApplication: ${newIsModalApplication}`);
        SCBSceneSessionManager.getInstance().requestToTop(mainSession.sceneInfo.screenId,
          mainSession.session.persistentId, SCBWindowRaiseReason.DEFAULT, newIsModalApplication);
        this.updateMultiSubSessionLevel(mainSession, subSession.session.persistentId);
      }
    }
    let modalSession: SCBSpecificSession | null = null;
    if (!newIsModalApplication && oldMainSession && this.isHasModalApplicationSubSession(oldMainSession)) {
      modalSession = this.getUppermostModalSession(oldMainSession.subSessionList);
    } else {
      modalSession = this.getUppermostModalSession(subSessionList);
    }
    if (modalSession) {
      log.showInfo(`setParentSession modalSession id: ${modalSession.session.persistentId}`);
      SCBSceneSessionManager.getInstance().requestFocus(modalSession.session.persistentId,
        undefined, FocusChangeReason.MOVE_UP);
    }
  }

  private onSetParentSession(oldParentWindowId: number, newParentWindowId: number): void {
    log.showInfo(`setParentSession subWindowId: ${this.specificSession?.session.persistentId}, ` +
      `oldParentWindowId: ${oldParentWindowId}, newParentWindowId ${newParentWindowId}`);
    if (this.specificSession == null) {
      log.showError(`setParentSession specificSession is null`);
      return;
    }
    let subWindowId: number = this.specificSession?.session.persistentId;
    let oldSceneSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSessionById(oldParentWindowId);
    if (oldSceneSession == null) {
      log.showError(`setParentSession oldParentWindowId: ${oldParentWindowId} session is null`);
      return;
    }
    let newSceneSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSessionById(newParentWindowId);
    if (newSceneSession == null) {
      log.showError(`setParentSession newSceneSession: ${newParentWindowId} session is null`);
      return;
    }
    let index = oldSceneSession.subSessionList.findIndex((item) => {
      return item.session.persistentId === subWindowId;
    });
    if (index === -1) {
      log.showError('setParentSession oldSceneSession find subWindowId failed');
      return;
    }
    let subSession: SCBSpecificSession = oldSceneSession.subSessionList[index];
    oldSceneSession.subSessionList.splice(index, 1);
    subSession.session.parentId = newSceneSession.session.persistentId;
    subSession.parentId = subSession.session.parentId;
    subSession.registerRaiseToTopCallback(newSceneSession.getSubSessionRaiseToTopCallback());
    subSession.registerRaiseAboveTargetCallback(newSceneSession.getSubSessionRaiseAboveTargetCallback());
    subSession.registerStateChangeCallback(newSceneSession.getSubSessionStateChangeCallback());
    subSession.registerZLevelChangeCallback(newSceneSession.getSubSessionZLevelChangeCallback());
    SCBSceneSessionManager.getInstance().insertToTopByModalType(subSession, newSceneSession.subSessionList);
    this.refreshSubSessionInExtendDisplay(subSession);
    let floatSession: SCBSpecificSession | null = this.handleNewAncestorSessionHasFloat(subSession);
    if (subSession.getFocused()) {
      if (newSceneSession.isSessionForeground()) {
        let oldMainSession: SCBSceneSession | null =
          SCBSceneSessionManager.getInstance().findMainSessionById(oldSceneSession.session.persistentId);
        this.raiseToTopAndModalSessionRequestFocus(subSession, newSceneSession.subSessionList, oldMainSession,
          floatSession);
      } else {
        let modalSession = this.getUppermostModalSession(oldSceneSession.subSessionList);
        if (modalSession) {
          log.showInfo(`setParentSession modalSession id: ${modalSession.session.persistentId}`);
          SCBSceneSessionManager.getInstance().requestFocus(modalSession.session.persistentId,
            undefined, FocusChangeReason.MOVE_UP);
        } else {
          SCBSceneSessionManager.getInstance().requestFocus(oldSceneSession.session.persistentId,
            undefined, FocusChangeReason.MOVE_UP);
        }
      }
    } else {
      log.showInfo(`setParentSession subWindowId id: ${subWindowId} unfocused`);
    }
    this.handleNewMainSessionIsBackgroundState(newParentWindowId);
    SCBSessionListManager.refreshZOrder();
  }

  private handleNewMainSessionIsBackgroundState(newParentWindowId: number) {
    let mainSession: SCBSceneSession | null =
      SCBSceneSessionManager.getInstance().findMainSessionById(newParentWindowId);
    if (mainSession && !mainSession.isSessionForeground()) {
      log.showInfo(`setParentSession mainSession id: ${mainSession.session.persistentId} in minimize`);
      const extraInfo: ExecuteCallbackExtraInfo = {
        isMinimizeFromSetParentSession: true
      };
      SCBSceneSessionManager.getInstance().minimize(mainSession.sceneInfo.screenId, mainSession.session.persistentId,
        undefined, false, extraInfo);
    }
  }

  private refreshSubSessionInExtendDisplay(subSession: SCBSpecificSession): void {
    if (!subSession) {
      log.showError('setParentSession subSession is invalid');
      return;
    }
    let mainSession: SCBSceneSession | null =
          SCBSceneSessionManager.getInstance().findMainSessionById(subSession.session?.parentId);
    if (!mainSession) {
      log.showError('setParentSession mainSession is invalid');
      return;
    }
    if (subSession.screenId === mainSession.sceneInfo?.screenId) {
      return;
    }
    log.showInfo(`setParentSession subSession screenId:${subSession.screenId} ` +
      `mainSession screenId:${mainSession.sceneInfo?.screenId}`);
    let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
    sessionChangeInfo.persistentIds.push(subSession.session.persistentId);
    sessionChangeInfo.curScreenId = mainSession.sceneInfo?.screenId;
    sessionChangeInfo.targetScreenId = subSession.screenId;
    SCBSceneSessionManager.getInstance()
      .sessionDisplayChange(SessionDisplayChangeReason.CHANGE_PARENT_SESSION, sessionChangeInfo);
  }

  private initRectInCompatibleMode(): void {
    if (!this.specificSession) {
      return;
    }
    let resRect: SCBSessionRect | null = this.specificSession.calSubRectInMultiWindow(this.screenProperty);
    if (resRect !== null) {
      this.rect.copyFrom(resRect);
    }
  }

  private doSessionTitleAction = (actionId: number, param?: sceneSessionManager.SessionEventParam) => {
    this.onSessionTitleAction(actionId, param);
  }

  onSessionTitleAction(actionId: number, param?: sceneSessionManager.SessionEventParam) {
    log.showInfo(`OnSessionTitleAction actionId:${actionId}, id:${this.specificSession.session.persistentId}, ` +
      `screenId:${this.specificSession.screenId}`);
    if (this.specificSession?.subWindowAnchorInfo.isFollowParent) {
      log.showInfo(`OnSessionTitleAction subWindowAnchorInfo inFollowParent return`);
      return;
    }
    let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
    sessionChangeInfo.persistentIds.push(this.specificSession.session.persistentId);
    sessionChangeInfo.curScreenId = this.specificSession.screenId;
    switch (actionId) {
      case SCBSessionEventId.EVENT_MAXIMIZE:
        if (!this.specificSession.isSessionMoving) {
          SCBSceneSessionManager.getInstance().setMaximizeFloatingMode(false);
          this.onMaximize();
        }
        break;
      case SCBSessionEventId.EVENT_RECOVER:
        this.onRecover();
        break;
      case SCBSessionEventId.EVENT_START_MOVE:
        this.specificSession.sessionData.isDragging = true;
        SCBSceneSessionManager.getInstance()
          .sessionDisplayChange(SessionDisplayChangeReason.START_MOVE, sessionChangeInfo);
        if (this.specificSession?.windowMode === SCBSceneMode.FULLSCREEN) {
          this.specificSession.windowMode = SCBSceneMode.FLOATING;
          this.specificSession.sessionData.isMaximizeFloating = false;
          sceneSessionManager.updateWindowMode(this.specificSession.session.persistentId, SCBSceneMode.FLOATING);
          this.specificSession.setSpecialWindowEffectConfig();
        }
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
        break;
      case SCBSessionEventId.EVENT_DRAG_START:
        this.specificSession.sessionData.isDragging = true;
        SCBSceneSessionManager.getInstance()
          .sessionDisplayChange(SessionDisplayChangeReason.DRAG_START, sessionChangeInfo);
        break;
      case SCBSessionEventId.EVENT_END_MOVE:
        this.specificSession.sessionData.isDragging = false;
        SCBSceneSessionManager.getInstance()
          .sessionDisplayChange(SessionDisplayChangeReason.END_MOVE, sessionChangeInfo);
        break;
    }
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  private onMaximize() {
    if (!this.specificSession) {
      log.showError('onMaximize sceneSession is undefined');
      return;
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE,
      { 'isVisible': false, 'screenId': this.screenProperty.screenId });
    this.specificSession.sessionData.lastDpi = this.getScreenDpiDensity();
    if (this.specificSession.windowMode !== SCBSceneMode.FULLSCREEN) {
      this.specificSession.saveLastRect();
    }
    this.specificSession.setWindowLastSafeRect(this.specificSession.lastRect.left.getPx(),
      this.specificSession.lastRect.top.getPx(), this.specificSession.lastRect.width.getPx(),
      this.specificSession.lastRect.height.getPx());
    this.specificSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_WINDOW_FULL_SCREEN);
    this.onMaximizeDefaultApp();
    this.specificSession.windowMode = SCBSceneMode.FULLSCREEN;
  }

  private onMaximizeDefaultApp(): void {
    this.specificSession.animActionId = SCBSessionEventId.EVENT_MAXIMIZE;
    this.specificSession.sessionData.isMaximizeFloating = false;
    this.specificSession.setGravity(sceneSessionManager.Gravity.RESIZE);
    sceneSessionManager.updateWindowMode(this.specificSession.session.persistentId, SCBSceneMode.FULLSCREEN);
    this.specificSession.windowMode = SCBSceneMode.FULLSCREEN;
    this.initAnimateParam(SCBSessionEventId.EVENT_MAXIMIZE);
    this.setCommonAnimate();
    this.getUIContext()?.animateToImmediately({
      curve: Curves.interpolatingSpring(0, 1, 300, 33),
      onFinish: () => {
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_WINDOW_FULL_SCREEN);
      }
    }, () => {
      this.specificSession.scaleX = 1;
      this.specificSession.scaleY = 1;
      this.specificSession.translateX = 0;
      this.specificSession.translateY = 0;
    })
  }

  private initAnimateParam(actionId: SCBSessionEventId) {
    const currRect: SCBSessionRect = this.specificSession.currRect
    const currentLeft = currRect.left.getPx();
    const currentTop = currRect.top.getPx();
    const currentWidth = currRect.width.getPx();
    const currentHeight = currRect.height.getPx();
    if (actionId === SCBSessionEventId.EVENT_MAXIMIZE) {
      const sessionRect = this.calculateMaxRect();
      const posY = sessionRect.top.getPx();
      const width = sessionRect.width.getPx();
      const height = sessionRect.height.getPx();
      this.specificSession.scaleX = currentWidth / width;
      this.specificSession.scaleY = currentHeight / height;
      this.specificSession.translateX = px2vp(currentLeft - width * 0.5 + currentWidth * 0.5);
      this.specificSession.translateY = px2vp(currentTop - height * 0.5 + currentHeight * 0.5 - posY);
      this.specificSession.currRect.setRectNum(0, posY, width, height);
    } else if (actionId === SCBSessionEventId.EVENT_RECOVER) {
      this.initRecoverAnimateParam();
    } else {
      log.showInfo('do nothing in actionId:' + actionId)
    }
  }

  private initRecoverAnimateParam(): void {
    const currRect: SCBSessionRect = this.specificSession.currRect
    const currentLeft = currRect.left.getPx();
    const currentTop = currRect.top.getPx();
    const currentWidth = currRect.width.getPx();
    const currentHeight = currRect.height.getPx();
    let statusBarHeight: number = 0;
    const topArea: ViewArea = viewMgrPolicy.getArea(ViewType.STATUS_BAR);
    if (topArea !== undefined) {
      statusBarHeight = styleMgr.vp2pxStatusBarPCHeight();
    }
    const dockHeight = AppStorage.get('dockHeight') as number;
    const lastLeft = this.specificSession.lastRect.left.getPx();
    const lastTop = this.specificSession.lastRect.top.getPx();
    let lastWidth = this.specificSession.lastRect.width.getPx();
    let lastHeight = this.specificSession.lastRect.height.getPx();
    const lastDpi: number = this.specificSession.sessionData.lastDpi;
    const currentDpi: number = this.getScreenDpiDensity();
    if (lastDpi != -1 && lastDpi != currentDpi) {
      lastWidth = lastWidth / lastDpi * currentDpi;
      lastHeight = lastHeight / lastDpi * currentDpi;
    }
    if (lastWidth > this.screenProperty.width) {
      lastWidth = this.screenProperty.width
    }
    if ((lastHeight > (this.screenProperty.height - statusBarHeight - vp2px(dockHeight))) &&
      !sSCBOobeManager.isEnable()) {
      lastHeight = this.screenProperty.height - statusBarHeight - vp2px(dockHeight);
    }
    const sessionLeft = currentLeft +
      0.5 * (1 - this.specificSession.scaleX) * currentWidth + vp2px(this.specificSession.translateX);
    const sessionTop = currentTop +
      0.5 * (1 - this.specificSession.scaleY) * currentHeight + vp2px(this.specificSession.translateY);
    const sessionWidth = currentWidth * this.specificSession.scaleX;
    const sessionHeight = currentHeight * this.specificSession.scaleY;
    if (!AppStorage.get('isLock')) {
      this.specificSession.scaleX = sessionWidth / lastWidth;
      this.specificSession.scaleY = sessionHeight / lastHeight;
      this.specificSession.translateX = px2vp(sessionLeft - (lastLeft + 0.5 * (lastWidth - sessionWidth)));
      this.specificSession.translateY = px2vp(sessionTop - (lastTop + 0.5 * (lastHeight - sessionHeight)));
    }
    this.specificSession.currRect.setRectNum(lastLeft, lastTop, lastWidth, lastHeight);
  }

  private calculateMaxRect(): SCBSessionRect {
    const layoutFullScreen = this.specificSession.layoutFullScreen;
    const screenId = this.screenProperty.screenId;
    let statusBarHeight: number = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (!layoutFullScreen && statusBar) {
      statusBarHeight = statusBar.currRect.height.getPx();
    }
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    let dockRect = new SCBSessionRect(0, 0, 0, 0);
    if (dock && !layoutFullScreen) {
      dockRect.copyFrom(dock.currRect);
      dockHeight = dock.currRect.height.getPx();
    } else {
      log.showError('calculateMaxRect SmartDock no exit');
    }

    let posY = layoutFullScreen ? 0 : statusBarHeight;
    let screenHeight = this.screenProperty.height;
    let width = this.screenProperty.width;
    let height = screenHeight - dockHeight - statusBarHeight;
    return new SCBSessionRect(0, posY, width, height);
  }

  private calculateMaxRectInUnfolded(statusBarHeight: number): SCBSessionRect {
    const layoutFullScreen = this.specificSession.layoutFullScreen;
    let width = this.screenProperty.width;
    let height = 0;
    if (layoutFullScreen) {
      height = this.screenProperty.height;
    } else {
      const dockHeight = AppStorage.get('dockHeight') as number;
      height = this.screenProperty.height - statusBarHeight - dockHeight;
    }
    let posY = statusBarHeight;
    return new SCBSessionRect(0, posY, width, height);
  }

  private setCommonAnimate() {
    this.specificSession.animVisible = true;
    this.specificSession.animSceneAlpha = 1;
    this.getUIContext()?.animateTo({
      curve: Curve.Friction,
      duration: 200,
      delay: 50,
      onFinish: () => {
        this.specificSession.animVisible = false;
        this.specificSession.animActionId = 0;
      }
    }, () => {
      this.specificSession.animSceneAlpha = 0;
    });
  }

  private onRecover() {
    if (!this.specificSession) {
      log.showError('onRecover sceneSession is undefined');
      return;
    }
    this.specificSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER);
    this.specificSession.windowMode = SCBSceneMode.FLOATING;
    this.specificSession.sessionData.isMaximizeFloating = false;
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_WINDOW_FULL_SCREEN);
    this.onRecoverDefaultApp(SCBSceneMode.FULLSCREEN);
  }

  private onRecoverDefaultApp(lastWindowMode: SCBSceneMode) {
    this.specificSession.animActionId = SCBSessionEventId.EVENT_RECOVER;
    this.initAnimateParam(SCBSessionEventId.EVENT_RECOVER);
    this.getUIContext()?.animateToImmediately({
      curve: Curves.interpolatingSpring(0, 1, 300, 33),
      onFinish: () => {
        performanceMonitor.end('WINDOW_TITLE_BAR_RECOVER');
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_WINDOW_FULL_SCREEN);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_MAX_WINDOW);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_SPLIT_WINDOW);
        this.specificSession.windowMode = SCBSceneMode.FLOATING;
      }
    }, () => {
      if (!AppStorage.get('isLock')) {
        this.specificSession.translateX = 0;
        this.specificSession.translateY = 0;
        this.specificSession.scaleX = 1;
        this.specificSession.scaleY = 1;
      }
    })
  }

  private onUpdateMaximizeRect = () => {
    if (!this.specificSession) {
      log.showError('specificSession is null');
      return;
    }
    const sessionRect = this.calculateMaxRect();
    const posY = sessionRect.top.getPx();
    const width = sessionRect.width.getPx();
    const height = sessionRect.height.getPx();
    log.showInfo(`onUpdateMaximizeRect rect: [0, ${posY}, ${width}, ${height}], id: ${this.specificSession?.session.persistentId}`);
    this.specificSession.currRect.setRectNum(0, posY, width, height);
  }

  aboutToAppear() {
    // 手机应用上PC，适配应用内的弹窗大小
    let parentSession: SCBSceneSession | null = this.specificSession?.getParentSession();
    log.showInfo('aboutToAppear, id: ' + this.specificSession?.session.persistentId +
      `, currRect: ${this.specificSession?.requestedRect.printPx()}`);
    this.subList = this.specificSession.subSessionList;
    this.specificSession?.addRefCount();
    this.specificSession?.registerSessionRectChangeCallback((rect: sceneSessionManager.SessionRect,
                                                             reason: sceneSessionManager.SessionSizeChangeReason,
                                                             displayId: number) => {
      this.onSessionRectChange(rect, reason, displayId);
    }, this.screenProperty.screenId);
    this.specificSession?.registerSessionRectChangeRelativeParentCallback((rect: sceneSessionManager.SessionRect,
      reason: sceneSessionManager.SessionSizeChangeReason, fromParent:boolean) => {
      this.onSessionRectChangeRelativeParent(rect, reason, fromParent);
    }, this.screenProperty.screenId);
    this.specificSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    })
    this.specificSession?.registerClickModalWindowOutsideCallback(() => {
      this.onClickModalWindowOutside();
    })
    this.specificSession?.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      this.specificSession.isCustomAnimationPlaying = isPlaying;
    })
    this.specificSession?.registerSessionForceHideCallback((hide: boolean) => {
      this.specificSession.visibility = !hide;
    })
    this.specificSession?.registerCreateSubSessionCallback(this.onCreateSubSession);
    this.initSpecialWindowEffectConfig();
    this.specificSession?.registerSetWindowCornerRadiusCallback((cornerRadius: number) => {
      log.showInfo('onSetWindowCornerRadius in pc: ' + cornerRadius);
      this.specificSession.specialBoarderRadius = cornerRadius;
    })
    this.registerBufferAvailableChangeCallback();
    this.specificSession?.registerSessionTitleActionCallback(this.doSessionTitleAction, this.screenProperty.screenId);
    this.specificSession?.registerFollowParentWindowLayout((isFollow: boolean) =>{
      this.onFollowParentWindowLayout(isFollow);
    }, this.screenProperty.screenId);
    this.specificSession?.registerSetParentSessionCallback((oldParentWindowId: number, newParentWindowId: number) => {
      this.onSetParentSession(oldParentWindowId, newParentWindowId);
    });
    this.specificSession?.registerSubSessionRaiseToTopCallback(this.onSubSessionRaiseToTop);
    this.specificSession?.registerSubSessionRaiseAboveTargetCallback(this.onSubSessionRaiseAboveTarget);
    this.specificSession?.registerSubSessionStateChangeCallback(this.onSubSessionStateChange);
    this.specificSession?.registerSubSessionZLevelChangeCallback(this.onSubSessionZLevelChange);
    this.specificSession?.registerScreenIdChangeCallback(this.onScreenIdChangeCallback);
    this.specificSession?.registerUpdateMaximizeRectCallback(this.onUpdateMaximizeRect);
    this.specificSession?.registerSetWindowShadowsCallback((shadowsInfo: SCBWindowShadowConfig) => {
      let shadowConfigTmp = this.specificSession.shadowConfig;
      this.specificSession.shadowConfig = new SCBWindowShadowConfig(); // trigger component update
      this.specificSession.shadowConfig.radius = shadowsInfo?.radius ?? shadowConfigTmp.radius;
      this.specificSession.shadowConfig.color = shadowsInfo?.color ?? shadowConfigTmp.color;
      this.specificSession.shadowConfig.offsetX = shadowsInfo?.offsetX ?? shadowConfigTmp.offsetX;
      this.specificSession.shadowConfig.offsetY = shadowsInfo?.offsetY ?? shadowConfigTmp.offsetY;
      log.showInfo('onSetWindowShadows in pc, radius: ' + shadowsInfo.radius +
        ' color: ' + shadowsInfo.color + ' offsetX: ' + shadowsInfo.offsetX + ' offsetY: ' + shadowsInfo.offsetY);
    });
    this.initFullScreenRect();
  }

  private initFullScreenRect(): void {
    if (this.specificSession.windowMode === SCBSceneMode.FULLSCREEN &&
      this.specificSession.screenId === this.screenProperty.screenId) {
      this.onUpdateMaximizeRect();
    }
  }

  private onScreenIdChangeCallback = (screenId: number) => {
    if (this.specificSession) {
      this.specificSession.screenId = screenId;
    } else {
      log.showError('onScreenIdChangeCallback with specificSession null');
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear, id: ${this.specificSession?.session.persistentId}}`);
    if (this.specificSession?.windowMode === SCBSceneMode.FULLSCREEN) {
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }
    this.specificSession?.decRefCount();
    this.specificSession?.unRegisterAll();
    this.specificSession?.unRegisterSessionTitleActionCallback(this.doSessionTitleAction, this.screenProperty.screenId);
    this.specificSession?.unregisterSessionRectChangeCallback(this.screenProperty.screenId);
    this.specificSession?.unregisterSessionRectChangeRelativeParentCallback(this.screenProperty.screenId);
    this.specificSession?.unRegisterUpdateMaximizeRectCallback();
  }

  private enableShowWindowScene(): boolean {
    log.showInfo(`enableShowWindowScene persistentId:${this.specificSession.session.persistentId}, ` +
      `screenId:${this.specificSession.screenId}, screenProperty:${this.screenProperty.screenId}, ` +
      `isCrossingScreen:${this.specificSession.isCrossingScreen}`);
    if (this.specificSession.screenId !== this.screenProperty.screenId) {
      return false;
    }

    // 非跨屏场景
    if (!this.specificSession.isCrossingScreen) {
      return true;
    }

    this.specificSession.isCrossingScreen = false;
    return true;
  }

  onFollowParentWindowLayout(isFollow: boolean) {
    log.showInfo(`onFollowParentWindowLayout, isFollow: ${isFollow}, screedId: ${this.specificSession.screenId}`);
    this.isFollowParentWindowLayout = isFollow;
    this.specificSession?.session.activateDragBySystem(!isFollow &&
      !this.specificSession?.subWindowAnchorInfo.isFollowParent);
  }

  getSize(): SizeOptions {
    if (this.isFollowParentWindowLayout) {
      return { width: this.parentRect?.width.getPxSizeStr(), height: this.parentRect?.height.getPxSizeStr() };
    }
    return { width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() };
  }

  getPosition(): Position | Edges | LocalizedEdges {
    if (!this.isFollowParentWindowLayout) {
      return { x: this.rect?.left.getPxStr(), y: this.rect?.top.getPxStr() };
    }
    if (!this.parentRect) {
      log.showError('parent rect is null, use self rect');
      return { x: this.rect?.left.getPxStr(), y: this.rect?.top.getPxStr() };
    }
    return { x: this.parentRect?.left.getPxStr(), y: this.parentRect?.top.getPxStr() };
  }

  getBoardRadiusNum(): number {
    if (!this.isFollowParentWindowLayout || !this.parentSceneSession) {
      return this.specificSession.windowMode === SCBSceneMode.FULLSCREEN ? 0 :
        this.specificSession.specialBoarderRadius;
    }
    const screenDpiDendity: number = this.getScreenDpiDensity();
    const scaleRatio: number = screenDpiDendity / 160;
    log.showInfo(`getBoardRadius parentBoarderRadius is ${this.parentSceneSession?.floatBorderRadius} ` +
      `scaleRatio is ${scaleRatio}`);
    let radius = this.parentSceneSession?.floatBorderRadius * scaleRatio;
    return radius;
  }

  getBoardRadius(): BorderRadiuses {
    const boardRadius = this.getBoardRadiusNum();
    return {
      topLeft: boardRadius + 'px',
      topRight: boardRadius + 'px',
      bottomLeft: boardRadius + 'px',
      bottomRight: boardRadius + 'px'
    };
  }

  build() {
    if (this.enableShow()) {
      Stack({ alignContent: Alignment.TopStart }) {
        if (this.enableShowWindowScene()) {
          WindowScene(this.specificSession.session.persistentId)
            .position(this.getPosition())
            .size(this.getSize())
            .id(`session${this.specificSession.session.persistentId}`)
            .visibility(this.specificSession.visibility ? Visibility.Visible : Visibility.Hidden)
            .focusable(this.specificSession.isFocusable)
            .hitTestBehavior(this.specificSession.isTouchable ? HitTestMode.Block : HitTestMode.None)
            .borderRadius((this.isFollowParentWindowLayout && this.parentSceneSession) ?
              this.getBoardRadius() : this.getBoardRadiusNum())
            .outline(this.specificSession.getOutline())
            .clip(this.getBoardRadiusNum() > 0 ? true : false)
            .shadow({
              radius: this.isFollowParentWindowLayout ? 0 : this.specificSession.shadowConfig.radius,
              color: this.isFollowParentWindowLayout ? '#00000000' : this.specificSession.shadowConfig.color,
              offsetX: this.specificSession.shadowConfig.offsetX,
              offsetY: this.specificSession.shadowConfig.offsetY
             })
            .opacity(this.specificSession.opacity)
            .scale({ x: this.specificSession.scaleX,
              y: this.specificSession.scaleY })
            .translate({ x: this.specificSession.translateX, y: this.specificSession.translateY })
            .onAppear(() => {
              this.specificSession.isCrossingScreen = false;
            })
        }
      }
      //build subwindow
      ForEach(this.subList, (item: SCBSpecificSession) => {
        SCBSpecificScene({
          specificSession: item,
          screenProperty: $screenProperty,
          rect: item.currRect,
          parentRect: this.rect,
          parentSceneSession: this.parentSceneSession,
          subWindowAnchorInfo: item.subWindowAnchorInfo
        })
      }, (item: SCBSpecificSession) => item.session.persistentId.toString())
    }
  }
}