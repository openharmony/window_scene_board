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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { WindowAnimationUtils } from '@ohos/windowscene/Index';
import {
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBKeyboardManager,
  KeyboardState,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSpecificSession,
  SCBSpecificSceneSessionList,
  ACTIVE_STATUS_MAP,
  FocusChangeReason,
  SCBWindowRaiseReason,
  SCBWindowShadowConfig,
  SCBSceneMode,
} from '@ohos/windowscene';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBDefaultZIndex } from './SCBScreen';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { SCBAiBarConstants } from '../aiBar/SCBAiBarConstants';
import curves from '@ohos.curves';
import { StyleConstants } from '@ohos/launchercommon'
import ViewManagerPolicy, { ViewType } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy'
import { viewMgrPolicy } from '@ohos/frameworkwrapper';
import { SCBSystemSceneUtils } from '@ohos/pcmode';

const TAG = 'SCBSpecificScene';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export enum SCBSpecificZIndex {
  INPUT_METHOD_ABOVE_SPLIT_SCENE = 1903,
}

interface SCBSpecificSceneBuilderParam {
  specificSceneSessionList: SCBSpecificSceneSessionList;
}

@Component
export struct SCBSpecificScene {
  @ObjectLink specificSession: SCBSpecificSession;
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink rect: SCBSessionRect;
  private windowAnimationUtils: WindowAnimationUtils = WindowAnimationUtils.getInstance();
  private resetAiPanelOpacityTimeoutTask: number = -1;
  @ObjectLink subSessionList: SCBSpecificSceneSessionList;
  @State isFollowParentWindowLayout: boolean = false;
  @ObjectLink parentRect: SCBSessionRect;

  private createSubSession = (sceneSession: SCBSpecificSession,
                              specificSession: sceneSessionManager.SceneSession): void =>
    this.onCreateSubSession(sceneSession, specificSession);

  private subSessionStateChange = (parentId: number, persistentId: number,
                                   state: sceneSessionManager.SessionState): void =>
    this.onSubSessionStateChange(parentId, persistentId, state);

  private subSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean,
                                  reason: FocusChangeReason = FocusChangeReason.DEFAULT): void =>
    this.onSubSessionRaiseToTop(parentId, persistentId, raiseParent, reason);
  private subSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void =>
    this.onSubSessionRaiseAboveTarget(parentId, persistentId, targetSubWindowId);

  private onCreateSubSession(sceneSession: SCBSpecificSession, 
                             specificSession: sceneSessionManager.SceneSession): void {
    if (this.specificSession.session?.persistentId === specificSession?.parentId) {
      let subList: SCBSpecificSceneSessionList = this.subSessionList;
      const indexInAll = subList.findIndex(item => {
        return item.session.persistentId === specificSession.persistentId;
      });
      if (indexInAll === -1) {
        let hwSceneSession = new SCBSpecificSession(specificSession, this.subSessionStateChange,
          this.subSessionRaiseToTop, this.subSessionRaiseAboveTarget);
        SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, subList);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        log.showInfo('[SCBSub] create subSession success, + id: ' + specificSession.persistentId +
          'parentId: ' + specificSession.parentId);
      } else {
        log.showInfo('[SCBSub] already in subList, id: ' + specificSession.persistentId + 'index: ' + indexInAll);
      }
    }
  }

  private onSubSessionStateChange(parentId: number, persistentId: number,
                                  state: sceneSessionManager.SessionState): void {
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      return;
    }
    let isActive = ACTIVE_STATUS_MAP.get(state)
    if (isActive === undefined || !subList[index]) {
      return;
    }
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      subList.splice(index, 1);
      SCBSceneSessionManager.getInstance().refreshZOrder();
      return;
    }

    let tempIndex = index;
    if (isActive) {
      // Update zorder of SubWindow when entering display.
      let curSession = subList[index];
      subList.splice(index, 1);
      tempIndex = SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
      log.showInfo('[SCBSub] update subwindow zorder. persistentId: ' + persistentId);
    }
    subList[tempIndex].isActive = isActive;
    subList[tempIndex].sessionData.sessionState = state;

    log.showInfo('[SCBSub] state change, persistentId: ' + persistentId + ', state: ' + state +
      ', isActive: ' + subList[tempIndex].isActive + ', length: ' + subList.length);
  }

  private onSubSessionRaiseToTop(parentId: number, persistentId: number, raiseParent: boolean,
                                 reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      return;
    }
    let curSession = subList[index];
    log.showInfo(`[SCBSub] onSubSessionRaiseToTop, index: ${index}, Id: ${curSession.session.persistentId}, reason: ${reason}`);
    if (index === subList.length - 1) {
      log.showInfo(`[SCBSub] onSubSessionRaiseToTop curSession does not need raise`);
      return;
    }
    subList.splice(index, 1);
    SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
    log.showInfo(`[SCBSub] onSubSessionRaiseToTop, index: ${index}, length: ${subList.length}`);
    const focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId);
    if (focusedSession?.session.persistentId === parentId || focusedSession?.session.parentId === parentId) {
      SCBSceneSessionManager.getInstance().requestFocus(persistentId, true, reason);
    }
    if (raiseParent) {
      let mainSession = SCBSceneSessionManager.getInstance().findMainSessionById(parentId);
      if (mainSession && mainSession instanceof SCBSceneSession) {
        SCBSceneSessionManager.getInstance().requestToTop((mainSession as SCBSceneSession).sceneInfo.screenId,
          (mainSession as SCBSceneSession).session.persistentId,
          SCBWindowRaiseReason.SUBSESSION_RAISE_UP);
        log.showInfo('onSubSessionRaiseToTop, raise parent for point down subWindow, id: ' +
          persistentId + ', mainId: ' + (mainSession as SCBSceneSession).session.persistentId);
      }
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  private onSubSessionRaiseAboveTarget(parentId: number, persistentId: number, targetSubWindowId: number): void {
    if (persistentId == targetSubWindowId) {
      return;
    }
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const currIndex = subList.findIndex(item => {
      return item.session.persistentId == persistentId;
    });
    if (currIndex != -1) {
      // Get CurrSession and delete it
      let currSession = subList[currIndex];
      subList.splice(currIndex, 1);

      // Get targetIndex and insert currSession behind targetSession
      const targetIndex = subList.findIndex(item => {
        return item.session.persistentId == targetSubWindowId;
      });
      if (targetIndex == -1) {
        return;
      }
      subList.splice(targetIndex + 1, 0, currSession);
      log.showInfo(`[SCBSub] onSubSessionRaiseAboveTarget, targetIndex: ${targetIndex}, length: ${subList.length}`);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  enableShow(): boolean {
    if (!this.specificSession) {
      log.showWarn('enable show is false, specificSession is null');
      return false;
    }

    if (this.specificSession.isCustomAnimationPlaying) {
      log.showInfo('enable show is true, is playing custom animation' + ', id: ' +
        this.specificSession?.session?.persistentId + ', type: ' + this.specificSession?.session?.type);
      return true;
    }

    if (this.specificSession.isActive) {
      log.showInfo('enable show is true, is in active state' + ', id: ' +
        this.specificSession?.session?.persistentId + ', type: ' + this.specificSession?.session?.type);
      return true;
    }

    log.showInfo('enable show is false, id: ' + this.specificSession?.session?.persistentId +
      ', type: ' + this.specificSession?.session?.type);
    return false;
  }

  private handleTargetPositionXWithLimit(newRect: SCBSessionRect): number {
    const screenWidth = this.screenProperty.width;
    let targetPositionX = newRect.left.getPx();
    const targetWidth = newRect.width.getPx();
    if (targetWidth >= screenWidth - 2) {
      return 0;
    }
    const leftThreshold = vp2px(StyleConstants.DEFAULT_AVOID_AREA) * 3;
    if (targetPositionX + targetWidth < leftThreshold) {
      log.showDebug(`onSessionRectChange, reaching left threshold: ${leftThreshold}`);
      targetPositionX = leftThreshold - targetWidth;
    }
    const rightThreshold = screenWidth - vp2px(StyleConstants.DEFAULT_AVOID_AREA) * 3;
    if (targetPositionX > rightThreshold) {
      log.showDebug(`onSessionRectChange, reaching right threshold: ${rightThreshold}`);
      targetPositionX = rightThreshold;
    }
    return targetPositionX;
  }

  private handleTargetPositionYWithLimit(newRect: SCBSessionRect): number {
    const screenHeight = this.screenProperty.height;
    let targetPositionY = newRect.top.getPx();
    // top area
    const targetHeight = newRect.height.getPx();
    if (targetHeight >= screenHeight - 2) {
      return 0;
    }
    const topArea = ViewManagerPolicy.getArea(ViewType.STATUS_BAR);
    const topThreshold = topArea ? vp2px(topArea.height + topArea.top) : 0;
    if (targetPositionY < topThreshold) {
      log.showInfo(`onSessionRectChange, reaching top threshold: ${topThreshold}`);
      targetPositionY = topThreshold;
    }
    // bottom area
    let bottomThreshold = this.screenProperty.height - vp2px(StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT);
    bottomThreshold -= 100; // height + bottom margin
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
    if (!(this.specificSession.isDialogWindow() || this.specificSession.isSubWindow())) {
      return;
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
      const targetPositionX: number = this.handleTargetPositionXWithLimit(newRect);
      const targetPositionY: number = this.handleTargetPositionYWithLimit(newRect);
      newRect.setPosNum(targetPositionX, targetPositionY);
    }
    if (this.specificSession.currRect.left.getPx() === newRect.left.getPx() &&
        this.specificSession.currRect.top.getPx() === newRect.top.getPx() &&
        this.specificSession.currRect.width.getPx() === newRect.width.getPx() &&
        this.specificSession.currRect.height.getPx() === newRect.height.getPx()) {
      const fixDistance = 1;
      newRect.setPosNum(newRect.left.getPx(), newRect.top.getPx() - fixDistance);
    }
    this.rect && this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
  }

  onSessionRectChange(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason): void {
    if (!this.specificSession) {
      log.showError('specificSession is null');
      return;
    }
    log.showInfo('onSessionRectChange start, id: ' + this.specificSession.session.persistentId + ' reason: ' +
      reason + ', rect: [' + rect.posX_ + ', ' + rect.posY_ + ', ' + rect.width_ + ', ' + rect.height_ + ']' +
      ', currRect: ' + this.specificSession.currRect?.printPx());
    if ((rect.posX_ == this.specificSession.currRect.left.getPx()) &&
      (rect.posY_ == this.specificSession.currRect.top.getPx()) &&
      (rect.width_ == this.specificSession.currRect.width.getPx()) &&
      (rect.height_ == this.specificSession.currRect.height.getPx())) {
      log.showInfo('session rect not change');
      return;
    }
    let newRect = this.specificSession.currRect.copy();
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      newRect.setPosNum(rect.posX_, rect.posY_);
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
      newRect.setSizeNum(rect.width_, rect.height_);
    } else {
      newRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
      // use 'animateTo' to force update rect immediately
      let uiContext: UIContext = this.getUIContext();
      if (uiContext && reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
        this.rect && this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
        let targetX = this.handleTargetPositionXWithLimit(newRect);
        let targetY = this.handleTargetPositionYWithLimit(newRect);
        newRect.setPosNum(targetX, targetY);
        uiContext.animateTo({
          duration: 250
        }, () => {
          this.rect && this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
        })
      }
    }
    // cal sub rect in MultiWindow
    let parentSession = this.specificSession.getParentSession();
    if (parentSession?.isInSplit() || parentSession?.isInFloat()) {
      this.onMultiSubRectChange(newRect, reason);
      return;
    }
    if (parentSession?.isPcAppInPad) {
      this.springBackIfNeeded(reason, newRect);
    }
    this.rect && this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
    log.showInfo('onSessionRectChange end, id: ' + this.specificSession.session.persistentId + ' reason: ' +
      reason + ', newRect: [' + newRect.left.getPx() + ', ' + newRect.top.getPx() + ', ' +
      newRect.width.getPx() + ', ' + newRect.height.getPx() + ']' + ', currRect: [' +
      this.specificSession.currRect.left.getPx() + ', ' + this.specificSession.currRect.top.getPx() + ', ' +
      this.specificSession.currRect.width.getPx() + ', ' + this.specificSession.currRect.height.getPx() + ']');
  }

  private updateOffsetIfNeed(): void {
    if (CommonUtils.isInvalid(this.specificSession)) {
      return;
    }
    if (!(this.specificSession.isDialogWindow() || this.specificSession.isSubWindow())) {
      return;
    }
    try {
      let floatContainer = SCBSceneSessionManager.getInstance().getFloatingSessionList().findByPersistentId(
        this.specificSession.session?.parentId);
      if (floatContainer) {
        let posX = floatContainer.needRenderPos.posX;
        let posY = floatContainer.needRenderPos.posY;
        if (CommonUtils.isInvalid(this.specificSession.session)) {
          log.showError('setWindowOffset null session');
          return;
        }
        posX = posX - this.specificSession.currRect.left.getVp() * (1 - floatContainer.floatingParam.scale);
        posY = posY - this.specificSession.currRect.top.getVp() * (1 - floatContainer.floatingParam.scale);
        this.specificSession?.session?.setOffset(vp2px(posX), vp2px(posY));
      }
      let parentSession = this.specificSession.getParentSession();
      if (parentSession?.isInSplit()) {
        let mainRect: SCBSessionRect = parentSession.currRect;
        this.specificSession?.session?.setOffset(mainRect.left.getPx(), mainRect.top.getPx());
      }
    } catch (err) {
      log.showError(`updateOffsetIfNeed error: ${JSON.stringify(err)}`);
    }
  }

  private onMultiSubRectChange(newRect: SCBSessionRect, reason: sceneSessionManager.SessionSizeChangeReason) {
    let needAnimate: boolean = (reason === sceneSessionManager.SessionSizeChangeReason.FULL_TO_FLOATING ||
                                reason === sceneSessionManager.SessionSizeChangeReason.FULL_TO_SPLIT) &&
                               !this.isFollowParentWindowLayout && this.specificSession.isSessionForeground() &&
                               !this.specificSession?.isSpecialCompatibleUECSubWindow();
    if (needAnimate) {
      let animationCurves = reason === sceneSessionManager.SessionSizeChangeReason.FULL_TO_FLOATING ?
      curves.springMotion(0.45, 0.75) : curves.springMotion(0.55, 0.85);
      let delay = reason === sceneSessionManager.SessionSizeChangeReason.FULL_TO_FLOATING ? 0 : 400;
      animateTo({
        curve: animationCurves,
        delay: delay
      }, () => {
        this.updateMultiSubRect(newRect, reason);
      })
    } else {
      this.updateMultiSubRect(newRect, reason);
    }

    log.showInfo('onSessionRectChange end by onMultiSubRectChange, id: ' + this.specificSession.session.persistentId +
      ' reason: ' + reason + ', newRect: [' + newRect.left.getPx() + ', ' + newRect.top.getPx() + ', ' +
    newRect.width.getPx() + ', ' + newRect.height.getPx() + ']' + ', currRect: [' +
    this.specificSession.currRect.left.getPx() + ', ' + this.specificSession.currRect.top.getPx() + ', ' +
    this.specificSession.currRect.width.getPx() + ', ' + this.specificSession.currRect.height.getPx() + ']');
  }

  private updateMultiSubRect(newRect: SCBSessionRect, reason: sceneSessionManager.SessionSizeChangeReason) {
    let subRectInSplit: SCBSessionRect | null = this.specificSession.calSubRectInMultiWindow(this.screenProperty);
    if (subRectInSplit) {
      newRect.copyFrom(subRectInSplit);
    }
    this.specificSession.updateSizeChangeReason(reason)
    this.rect && this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
    this.updateOffsetIfNeed();
  }

  /**
   * update sub rect when create sub session or dialog in multiWindow
   */
  private initRectInMultiWindow(): void {
    if (CommonUtils.isInvalid(this.specificSession)) {
      return;
    }
    let resRect: SCBSessionRect | null = this.specificSession.calSubRectInMultiWindow(this.screenProperty);
    if (resRect !== null) {
      this.rect.copyFrom(resRect);
    }
  }

  onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.specificSession?.setTouchable(isTouchable);
  }

  initSpecialWindowEffectConfig(): void {
    this.specificSession?.setSpecialWindowEffectConfig();
  }

  registerBufferAvailableChangeCallback() {
    this.specificSession?.session?.on('bufferAvailableChange', (isBufferAvailable: boolean) => {
      if (!this.specificSession) {
        log.showInfo(`specificSession is null`);
        return;
      }
      log.showInfo(`bufferAvailableChange, isBufferAvailable: ${isBufferAvailable}`);
      this.specificSession.isBufferAvailable = isBufferAvailable;
      if (isBufferAvailable === true) {
        this.specificSession.setSpecialWindowEffectConfig();
        this.specificSession.setIsSystemBarPropertyApplied();
      }
    });
  }

  private onUpdateMaximizeRect(): void {
    if (!this.specificSession) {
      log.showError(`specificSession is null`);
      return;
    }
    let isActive = ACTIVE_STATUS_MAP.get(this.specificSession?.sessionData?.sessionState);
    if (isActive === true && this.specificSession?.windowMode === SCBSceneMode.FULLSCREEN) {
      if (!this.screenProperty) {
        log.showWarn('screenProperty is null.');
        return;
      }
    }
    let screenHeight = this.screenProperty.height;
    let height = screenHeight;
    let posY = 0;
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
    if(!this.specificSession?.layoutFullScreen && systemSceneSession &&
    viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)){
      let statusbarHeight = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenProperty.screenId);
      posY = Math.floor(statusbarHeight)
      height = screenHeight - posY;
      SCBSceneSessionManager.getInstance().fullScreenLayoutChange(true, this.specificSession?.screenId)
    }
    this.specificSession?.currRect.setSizeNum(this.screenProperty.width, height);
    this.specificSession?.currRect.setPosNum(0, posY);
    SCBSceneSessionManager.getInstance().updateSystemBarProperty()
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear, id: ' + this.specificSession?.session.persistentId +
      ', currRect: [' + this.specificSession?.currRect.left.getPx() + ', ' + this.specificSession?.currRect.top.getPx() + ', ' +
      this.specificSession?.currRect.width.getPx() + ', ' + this.specificSession?.currRect.height.getPx() + ']');
    this.specificSession?.addRefCount();
    this.specificSession?.registerSessionRectChangeCallback((rect: sceneSessionManager.SessionRect,
                                                             reason: sceneSessionManager.SessionSizeChangeReason) => {
      this.onSessionRectChange(rect, reason);
    })
    this.specificSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    })
    this.specificSession?.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      log.showInfo('set isCustomAnimationPlaying ' + isPlaying);
      this.specificSession.isCustomAnimationPlaying = isPlaying;
    })
    this.specificSession?.registerSessionForceHideCallback((hide: boolean) => {
      this.specificSession.visibility = !hide;
    })
    this.specificSession?.registerCreateSubSessionCallback((sceneSession: SCBSpecificSession, specificSession:
      sceneSessionManager.SceneSession): void => {
        this.createSubSession(sceneSession, specificSession);
    });
    this.initSpecialWindowEffectConfig();
    this.specificSession?.registerSetWindowCornerRadiusCallback((cornerRadius: number) => {
      log.showInfo('onSetWindowCornerRadius in floating window: ' + cornerRadius);
      this.specificSession.specialBoarderRadius = cornerRadius;
    })
    this.registerBufferAvailableChangeCallback();
    this.initRectInMultiWindow();
    this.specificSession?.registerGetZIndexCallback(() => {
      return this.getZIndex();
    });
    this.specificSession?.registerFollowParentWindowLayout((isFollow: boolean) =>{
      this.onFollowParentWindowLayout(isFollow);
    });
    this.specificSession?.registerSetWindowShadowsCallback((shadowsInfo: SCBWindowShadowConfig) => {
      let shadowConfigTmp = this.specificSession.shadowConfig;
      this.specificSession.shadowConfig = new SCBWindowShadowConfig(); // trigger component update
      this.specificSession.shadowConfig.radius = shadowsInfo?.radius ?? shadowConfigTmp.radius;
      this.specificSession.shadowConfig.color = shadowsInfo?.color ?? shadowConfigTmp.color;
      this.specificSession.shadowConfig.offsetX = shadowsInfo?.offsetX ?? shadowConfigTmp.offsetX;
      this.specificSession.shadowConfig.offsetY = shadowsInfo?.offsetY ?? shadowConfigTmp.offsetY;
      log.showInfo('onSetWindowShadows in floating window, radius: ' + shadowsInfo.radius +
        'color: ' + shadowsInfo.color + 'offsetX: ' + shadowsInfo.offsetX + 'offsetY: ' + shadowsInfo.offsetY);
    });
    this.specificSession?.registerUpdateMaximizeRectCallback(() =>{
      this.onUpdateMaximizeRect();
    });
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear, id: ' + this.specificSession?.session?.persistentId);
    this.specificSession?.decRefCount();
    this.specificSession?.unRegisterAll();
  }

  getZIndex(): number {
    if (!this.specificSession || !this.specificSession.session) {
        return 0;
    }
    // input method need specific zOrder
    if (this.specificSession.session.type === sceneSessionManager.SessionType.TYPE_INPUT_METHOD) {
      switch (SCBKeyboardManager.getInstance().getKeyboardState()) {
        case KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE: {
          return SCBDefaultZIndex.INPUT_METHOD_BELOW_KEYGUARD;
        }
        case KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE: {
          return SCBDefaultZIndex.INPUT_METHOD_ABOVE_KEYGUARD;
        }
        case KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE: {
          return SCBSpecificZIndex.INPUT_METHOD_ABOVE_SPLIT_SCENE;
        }
        default:
          return 0;
      }
    }
    return 0;
  }

  onFollowParentWindowLayout(isFollow: boolean) {
    log.showInfo(`onFollowParentWindowLayout, isFollow: ${isFollow}`);
    this.isFollowParentWindowLayout = isFollow;
    this.specificSession?.session.activateDragBySystem(!isFollow);
  }

  getSize(): SizeOptions {
    if (this.isFollowParentWindowLayout) {
      return { width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 };
    }
    if (this.specificSession?.isSpecialCompatibleUECSubWindow()) {
      return { width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 };
    }
    return { width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() };
  }

  getPosition(): Position | Edges | LocalizedEdges {
    if (this.isFollowParentWindowLayout) {
      return { x: 0, y: 0 };
    }
    if (this.specificSession?.isSpecialCompatibleUECSubWindow()) {
      return { x: 0, y: 0 };
    }
    return { x: this.rect?.left.getPxStr(), y: this.rect?.top.getPxStr() };
  }

  @Builder
  specificSceneBuilder($$: SCBSpecificSceneBuilderParam) {
    ForEach($$.specificSceneSessionList, (item: SCBSpecificSession) => {
      if (item !== null) {
        SCBSpecificScene({
          specificSession: item,
          screenProperty: $screenProperty,
          rect: item.currRect,
          parentRect: this.rect,
          subSessionList: item.subSessionList
        })
      }
    }, (item: SCBSpecificSession) => item.session.persistentId.toString())
  }

  build() {
    if (this.enableShow()) {
      WindowScene(this.specificSession?.session.persistentId)
        .zIndex(this.getZIndex())
        .position(this.getPosition())
        .size(this.getSize())
        .id(`session${this.specificSession?.session.persistentId}`)
        .visibility(this.specificSession?.visibility ? Visibility.Visible : Visibility.Hidden)
        .focusable(this.specificSession?.isFocusable)
        .hitTestBehavior(this.specificSession?.isTouchable ? HitTestMode.Default : HitTestMode.None)
        .borderRadius(this.specificSession?.specialBoarderRadius)
        .clip(this.specificSession?.specialBoarderRadius > 0 ? true : false)
        .shadow({
          radius: this.specificSession?.shadowConfig.radius, color: this.specificSession?.shadowConfig.color,
          offsetX: this.specificSession?.shadowConfig.offsetX, offsetY: this.specificSession?.shadowConfig.offsetY
        })
        .transition(this.windowAnimationUtils.getTransitionEffect(this.specificSession, this.rect))
        .opacity(this.specificSession?.opacity)

        if (this.subSessionList.length !== 0) {
          this.specificSceneBuilder({ specificSceneSessionList: this.subSessionList })
        }
    }
  }
}
