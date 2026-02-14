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

import { SCBSpecificSession } from '../../session/SCBSpecificSession';
import {
  SCBScreenProperty,
  SCBSpecificSceneSessionList,
  FocusChangeReason,
  SCBSceneSessionManager,
  SCBSceneSession,
  ACTIVE_STATUS_MAP,
  SCBWindowRaiseReason,
  SCBWindowShadowConfig
} from '../../../TsIndex.ts';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { Logger, LogDomain, CommonUtils } from '@ohos/basicutils';
import { SCBSessionRectUtils } from '../../utils/SCBSessionRectUtils';

const TAG = 'SCBBaseSpecificSceneViewModel';
const log = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * Base SpecificScene ViewModel
 */
export class SCBBaseSpecificSceneViewModel {
  public specificSession: SCBSpecificSession;
  public screenProperty: SCBScreenProperty;
  public uiContext?: UIContext;

  protected subSessionList: SCBSpecificSceneSessionList;

  // session listeners
  protected sessionRectChange = (rect: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason) => {
    this.onSessionRectChange(rect, reason);
  };
  protected sessionTouchableChange = (isTouchable: boolean) => {
    this.onSessionTouchableChange(isTouchable);
  };
  protected createSubSession = (sceneSession: SCBSpecificSession,
    specificSession: sceneSessionManager.SceneSession): void => {
    this.onCreateSubSession(specificSession);
  };

  // sub session listeners
  private subSessionStateChange = (parentId: number, persistentId: number,
    state: sceneSessionManager.SessionState): void => {
    this.onSubSessionStateChange(parentId, persistentId, state);
  };
  private subSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean,
    reason: FocusChangeReason = FocusChangeReason.DEFAULT): void => {
    this.onSubSessionRaiseToTop(parentId, persistentId, raiseParent, reason);
  };
  private subSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void => {
    this.onSubSessionRaiseAboveTarget(parentId, persistentId, targetSubWindowId);
  };

  constructor(session: SCBSpecificSession, screenProperty: SCBScreenProperty) {
    this.specificSession = session;
    this.screenProperty = screenProperty;
    this.subSessionList = session.subSessionList;
  }

  /**
   * init when view aboutToAppear
   */
  public init(): void {
    log.showInfo(TAG, 'init');
    this.specificSession.addRefCount();
    this.registerSpecificSessionListeners();
    this.initSpecialWindowEffectConfig();
    this.initRectInMultiWindow();
  }

  /**
   * release when view aboutToDisappear
   */
  public release(): void {
    log.showInfo(TAG, 'release');
    this.specificSession.decRefCount();
    const curScreenId = this.screenProperty.screenId;
    this.specificSession.unregisterSessionRectChangeCallback(curScreenId);
    this.specificSession.unregisterFollowParentWindowLayout(curScreenId);
    this.specificSession.unRegisterAll();
  }

  protected registerSpecificSessionListeners(): void {
    this.specificSession.registerSessionRectChangeCallback(this.sessionRectChange);
    this.specificSession.registerSessionTouchableChangeCallback(this.sessionTouchableChange);
    this.specificSession.registerCreateSubSessionCallback(this.createSubSession);
    this.specificSession.registerFollowParentWindowLayout((isFollow: boolean) =>{
      this.onFollowParentWindowLayout(isFollow);
    });
    this.specificSession.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      log.showInfo(TAG, 'set isCustomAnimationPlaying ' + isPlaying);
      this.specificSession.isCustomAnimationPlaying = isPlaying;
    })
    this.specificSession.registerSessionForceHideCallback((hide: boolean) => {
      this.specificSession.visibility = !hide;
    })
    this.specificSession.registerSetWindowCornerRadiusCallback((cornerRadius: number) => {
      log.showInfo(TAG, 'onSetWindowCornerRadius in floating window: ' + cornerRadius);
      this.specificSession.specialBoarderRadius = cornerRadius;
    })
    this.specificSession.session?.on('bufferAvailableChange', (isBufferAvailable: boolean) => {
      if (!this.specificSession) {
        log.showInfo(TAG, `specificSession is null`);
        return;
      }
      log.showInfo(TAG, `bufferAvailableChange, isBufferAvailable: ${isBufferAvailable}`);
      this.specificSession.isBufferAvailable = isBufferAvailable;
      if (isBufferAvailable === true) {
        this.specificSession.setSpecialWindowEffectConfig();
      }
    });
    this.specificSession.registerSetWindowShadowsCallback((shadowsInfo: SCBWindowShadowConfig) => {
      let shadowConfigTmp = this.specificSession.shadowConfig;
      this.specificSession.shadowConfig = new SCBWindowShadowConfig(); // trigger component update
      this.specificSession.shadowConfig.radius = shadowsInfo?.radius ?? shadowConfigTmp.radius;
      this.specificSession.shadowConfig.color = shadowsInfo?.color ?? shadowConfigTmp.color;
      this.specificSession.shadowConfig.offsetX = shadowsInfo?.offsetX ?? shadowConfigTmp.offsetX;
      this.specificSession.shadowConfig.offsetY = shadowsInfo?.offsetY ?? shadowConfigTmp.offsetY;
      log.showInfo(TAG, `onSetWindowShadows in floating window, radius:${shadowsInfo.radius}` +
        `color:${shadowsInfo.color} offsetX:${shadowsInfo.offsetX} offsetY:${shadowsInfo.offsetY}`);
    });
    this.specificSession.registerGetZIndexCallback(() => {
      return 0;
    });
  }

  protected initSpecialWindowEffectConfig(): void {
    this.specificSession?.setSpecialWindowEffectConfig();
  }

  /**
   * update sub rect when create sub session or dialog in multiWindow
   */
  protected initRectInMultiWindow(): void {
    if (CommonUtils.isInvalid(this.specificSession)) {
      return;
    }
    let resRect = this.specificSession.calSubRectInMultiWindow(this.screenProperty);
    if (resRect !== null) {
      this.specificSession.currRect.copyFrom(resRect);
    }
  }

  protected onSessionRectChange(rect: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason): void {
    if (!this.specificSession) {
      log.showError(TAG, 'specificSession is null');
      return;
    }
    log.showInfo(TAG, `onSessionRectChange start, id: ${this.specificSession.session.persistentId}` +
      `reason: ${reason}, rect: ${SCBSessionRectUtils.sessionRectToString(rect)}` +
      `, currRect: ${this.specificSession.currRect?.printPx()}`);
    if (SCBSessionRectUtils.rectEqualsWithSessionRect(this.specificSession.currRect, rect)) {
      log.showInfo(TAG, 'session rect not change');
      return;
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      this.specificSession.currRect.setPosNum(rect.posX_, rect.posY_);
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
      this.specificSession.currRect.setSizeNum(rect.width_, rect.height_);
    } else {
      let newRect = this.specificSession.currRect.copy();
      newRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
      // use 'animateTo' to force update rect immediately
      if (this.uiContext && reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
        this.uiContext.animateTo({
          duration: 0
        }, () => {
          this.specificSession.currRect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
        })
      } else {
        this.specificSession.currRect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
      }
    }
    log.showInfo(TAG, 'onSessionRectChange end, id: ' + this.specificSession.session.persistentId + ' reason: ' +
      reason + ', currRect:' + this.specificSession.currRect.printPx());
  }

  protected onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(TAG, `onSessionTouchableChange, touchable: ${isTouchable}`);
    this.specificSession?.setTouchable(isTouchable);
  }

  protected onCreateSubSession(specificSession: sceneSessionManager.SceneSession): void {
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
        log.showInfo(TAG, '[SCBSub] create subSession success, id:' + specificSession.persistentId +
          'parentId:' + specificSession.parentId);
      } else {
        log.showInfo(TAG, '[SCBSub] already in subList, id:' + specificSession.persistentId + 'index:' + indexInAll);
      }
    }
  }

  protected onFollowParentWindowLayout(isFollow: boolean) {
    log.showInfo(TAG, `onFollowParentWindowLayout, isFollow: ${isFollow}`);
    this.specificSession.session.activateDragBySystem(!isFollow);
  }

  protected onSubSessionStateChange(parentId: number, persistentId: number,
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
      log.showInfo(TAG, '[SCBSub] update subwindow zorder. persistentId: ' + persistentId);
    }
    subList[tempIndex].isActive = isActive;
    subList[tempIndex].sessionData.sessionState = state;

    log.showInfo(TAG, '[SCBSub] state change, persistentId: ' + persistentId + ', state: ' + state +
      ', isActive: ' + subList[tempIndex].isActive + ', length: ' + subList.length);
  }

  protected onSubSessionRaiseToTop(parentId: number, persistentId: number, raiseParent: boolean,
    reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      return;
    }
    let curSession = subList[index];
    log.showInfo(TAG, `[SCBSub] onSubSessionRaiseToTop, index: ${index}, Id: ${curSession.session.persistentId}, ` +
      `reason: ${reason}`);
    if (index === subList.length - 1) {
      log.showInfo(TAG, `[SCBSub] onSubSessionRaiseToTop curSession does not need raise`);
      return;
    }
    subList.splice(index, 1);
    SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
    log.showInfo(TAG, `[SCBSub] onSubSessionRaiseToTop, index: ${index}, length: ${subList.length}`);
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
        log.showInfo(TAG, 'onSubSessionRaiseToTop, raise parent for point down subWindow, id: ' +
          persistentId + ', mainId: ' + (mainSession as SCBSceneSession).session.persistentId);
      }
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  protected onSubSessionRaiseAboveTarget(parentId: number, persistentId: number, targetSubWindowId: number): void {
    if (persistentId === targetSubWindowId) {
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
      log.showInfo(TAG, `[SCBSub]onSubSessionRaiseAboveTarget, targetIndex:${targetIndex}, length:${subList.length}`);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }
}