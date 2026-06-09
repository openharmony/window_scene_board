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

import sceneSessionManager from '@ohos.sceneSessionManager'
import { LogDomain, LogHelper, CommonUtils, SingleContext } from '@ohos/basicutils';
import {
  SCBSpecificSession,
  SCBSpecificSceneSessionList,
  SCBScreenProperty,
  SCBSceneSessionManager,
  SpecificPanelZOrder,
  ACTIVE_STATUS_MAP,
  windowMgr,
  SCBPropertyChangeReason,
  ScbNumber,
  SCBScreenSessionManager,
  SCBSessionRect,
  SCBSceneMode,
} from '@ohos/windowscene';
import { SceneConstants } from '@ohos/commonconstants';
import { SCBSpecificScene } from './SCBSpecificScene'
import { StyleConstants } from '@ohos/launchercommon'
import { SCBDefaultZIndex, ZORDER_TO_DEFAULTZINDEX } from './SCBScreen';
import PowerStatusChangeAnimationController from './PowerStatusChangeAnimationController'
import { SCBPcScenePanelManager, LayoutPolicyHelper } from '@ohos/pcmode';
import { curves } from '@kit.ArkUI';
import { ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';

const TAG = 'SCBSpecificScenePanel'
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Component
export struct SCBSpecificScenePanel {
  @Link screenProperty: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProperty.screenId };
  private screenProp: SCBScreenProperty = new SCBScreenProperty();
  zorder: number = 0;
  @State @Watch('systemSceneListUpdate') systemSceneList: SCBSpecificSceneSessionList =
    new SCBSpecificSceneSessionList();
  private sessionStateChange = (parentId: number, persistentId: number,
                                state: sceneSessionManager.SessionState): void =>
  this.onSessionStateChange(parentId, persistentId, state);
  private createSpecificScene = (specificSession: sceneSessionManager.SceneSession): void =>
  this.onCreateSpecificScene(specificSession);
  private statusViewCallback: ViewCallback = {
    onHide: (): void => this.onStatusHide()
  };
  getSpecificContainerSessionList = (): SCBSpecificSceneSessionList => {
    log.showInfo(`get specific scene panel session list, zorder: ${this.zorder}`);
    return this.systemSceneList;
  }

  systemSceneListUpdate(): void {
    if (!CommonUtils.isInvalid(this.systemSceneList)) {
      log.showInfo(`system scene length: ${this.systemSceneList.length}`);
    }
  }

  onSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState) {
    const index = this.systemSceneList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index !== -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive === undefined || !this.systemSceneList[index]) {
        return;
      }
      this.systemSceneList[index].isActive = isActive;
      if (this.systemSceneList[index].session.type === sceneSessionManager.SessionType.TYPE_INPUT_METHOD_STATUS_BAR) {
        windowMgr.setInputMethodActiveCache(persistentId, isActive);
      }
      log.showInfo(`onSubSessionActiveStatueChange persistentId: ${persistentId} ` +
        `isActive: ${this.systemSceneList[index].isActive}, length: ${this.systemSceneList.length} ` +
        `zorder: ${this.zorder}, state: ${state}`);
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        if (this.systemSceneList[index].session.type === sceneSessionManager.SessionType.TYPE_INPUT_METHOD_STATUS_BAR) {
          windowMgr.delInputMethodCache(persistentId);
        }
        this.systemSceneList.splice(index, 1);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        log.showInfo('onSessionStateChange persistentId: ' + persistentId + ' state: ' + state);
        return;
      }
      if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
        const currSession = this.systemSceneList[index];
        this.systemSceneList.splice(index, 1);
        this.systemSceneList.push(currSession);
      }
    }
  }

  onCreateSpecificScene(specificSession: sceneSessionManager.SceneSession) {
    const indexInAll = this.systemSceneList.findIndex(item => {
      return item.session?.persistentId === specificSession?.persistentId;
    });
    if (indexInAll === -1) {
      const hwSceneSession = new SCBSpecificSession(specificSession, this.sessionStateChange);

      // Create first specific scene, register a callback for exit animation
      if (this.systemSceneList.length === 0) {
        this.registerPowerStatusChangeAnimation();
      }
      this.systemSceneList.push(hwSceneSession);
      SCBSceneSessionManager.getInstance().refreshZOrder();
      log.showInfo(`createSpecificScene, id: ${specificSession.persistentId} zorder: ${this.zorder} ` +
        `scene list length: ${this.systemSceneList.length}`);
    } else {
      log.showInfo(`Session is already in subList, id: ${specificSession.persistentId}, index: ${indexInAll}`);
    }
  }

  onDestroyFloatWindowFromSceneSession(sceneSession: sceneSessionManager.SceneSession) {
    this.systemSceneList = this.systemSceneList.filter(specificSession => {
      return specificSession.session?.parentId !== sceneSession?.persistentId;
    })
    log.showInfo(`onDestroyFloatWindowFromSceneSession`);
  }



  getZIndex(): number {
    return ZORDER_TO_DEFAULTZINDEX.get(this.zorder) || 0;
  }

  private registerPowerStatusChangeAnimation(): void {
    log.showDebug('scene length when init = ' + this.systemSceneList.length);
    const exitSpecificSceneAnimation = (): boolean => {
      if (this.systemSceneList.length === 0) {
        return false;
      }

      let result = false;
      animateTo({
        duration: PowerStatusChangeAnimationController.DIALOG_DURATION,
      }, () => {
        this.systemSceneList.forEach((session: SCBSpecificSession) => {
          if (session.isActive) {
            session.opacity = PowerStatusChangeAnimationController.OPACITY_RATIO;
            result = true;
          }
        })
      })
      if (result) {
        log.showDebug('there has some active scene when run animation.');
      }
      return result;
    }
    PowerStatusChangeAnimationController.getInstance().registerExitSpecificSceneCallback(exitSpecificSceneAnimation);
  }

  private recurveSubList(session: SCBSpecificSession, isVisibility: boolean): void {
    session.subSessionList.forEach(item => {
      this.recurveSubList(item, isVisibility);
      item.setVisibility(isVisibility);
      try {
        item.session.setTouchable(isVisibility);
      } catch (err) {
        log.showError(`setTouchable failed, reason: ${err?.message}`);
      }
    });
  }

  private hideLargeFloatWindowWhenEnterRecent(): void {
    this.systemSceneList.forEach((item: SCBSpecificSession) => {
      if (item.session?.type === sceneSessionManager.SessionType.TYPE_FLOAT) {
        log.showInfo('hideLargeFloatWindowWhenEnterRecent');
        this.recurveSubList(item, false);
        item.setVisibility(false);
        try {
          item.session.setTouchable(false);
        } catch (err) {
          log.showError(`setTouchable failed, reason: ${err?.message}`);
        }
      }
    });
  }

  private showLargeFloatWindowWhenExitRecent(): void {
    this.systemSceneList.forEach((item: SCBSpecificSession) => {
      if (item.session?.type === sceneSessionManager.SessionType.TYPE_FLOAT) {
        this.recurveSubList(item, true);
        log.showInfo('showLargeFloatWindowWhenExitRecent');
        item.setVisibility(true);
        try {
          item.session.setTouchable(true);
        } catch (err) {
          log.showError(`setTouchable failed, reason: ${err?.message}`);
        }
      }
    });
  }

  private updateSpecificSessionWithScreenPropertyChange(screenProperty: SCBScreenProperty,
    specificSession: SCBSpecificSession, reason: sceneSessionManager.SessionSizeChangeReason): void {
    if (SCBPcScenePanelManager.getInstance().isFullScreenSessionNeedFollowScreen(specificSession, this.screenProp)) {
      specificSession.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
        new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), reason);
    } else if (SCBPcScenePanelManager.getInstance().isNonFullScreenFloatSession(specificSession, this.screenProp)) {
      // process pip rotation which is implemented with TYPE_FLOAT
      specificSession.updateSizeChangeReason(reason);
      LayoutPolicyHelper.getInstance().handleFreeWindowRect(specificSession.currRect, this.screenProp,
        screenProperty);
    }
  }

  private onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    log.showInfo(`onScreenPropertyChange reason: ${reason}, screenProperty: ${screenProperty.getLogString()}`);
    switch (reason) {
      case SCBPropertyChangeReason.ROTATION:
        for (let specificSession of this.systemSceneList) {
          if (!specificSession || !specificSession.isActive) {
            continue;
          }
          const oldMainRect: SCBSessionRect = specificSession.currRect.copy();
          this.updateSpecificSessionWithScreenPropertyChange(screenProperty, specificSession,
            sceneSessionManager.SessionSizeChangeReason.ROTATION);
          log.showInfo(`ROTATION ${specificSession.getName()}, rect is ${specificSession.currRect.printPx()}` +
            `, at screen ${specificSession.screenId}, isFollowScreenChange ${specificSession.isFollowScreenChange}` +
            `, specific session type: ${specificSession.session?.type}`);
        }
        break;
      case SCBPropertyChangeReason.CHANGE_MODE:
        for (let specificSession of this.systemSceneList) {
          if (!specificSession || !specificSession.isActive) {
            continue;
          }
          const oldMainRect: SCBSessionRect = specificSession.currRect.copy();
          if (specificSession.screenId === this.screenProperty.screenId) {
            this.updateSpecificSessionWithScreenPropertyChange(screenProperty, specificSession,
              sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
            log.showInfo(`CHANGE_MODE ${specificSession.getName()}, rect is ${specificSession.currRect.printPx()}` +
              `, at screen ${specificSession.screenId}, isFollowScreenChange ${specificSession.isFollowScreenChange}` +
              `, specific session type: ${specificSession.session?.type}`);
          }
          SCBPcScenePanelManager.getInstance().updateSubSession(specificSession, this.screenProp, screenProperty,
            oldMainRect, specificSession.screenId);
        }
        break;
      default:
        break;
    }
    this.screenProp.copy(screenProperty);
  }

  /*
   * Layout all specificScenes when fold or expand
   */
  private layoutSpecificScenesToFoldOrExpend(screenProperty: SCBScreenProperty, isFold: boolean = true): void {
    animateTo({
      duration: 600,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, ()=>{
      for (let specificContainerSession of this.systemSceneList) {
        let session = specificContainerSession.getParentSession();
        if (!specificContainerSession || !session ||
          specificContainerSession.session?.type !== sceneSessionManager.SessionType.TYPE_FLOAT) {
          log.showInfo(`layoutSpecificScenesToFold continue`);
          continue;
        }
        log.showInfo(`specificContainerSession oldRect ${specificContainerSession.currRect.printPx()}`)
        specificContainerSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.ROTATION);
        let currRect = new SCBSessionRect();
        specificContainerSession.currRect.setRectNum(currRect.left.getPx(), currRect.top.getPx(),
          currRect.width.getPx(), currRect.height.getPx());
        log.showInfo(`specificContainerSession currRect ${specificContainerSession.currRect.printPx()}`)
      }
      if (isFold) {
        let subSessionList = SCBSceneSessionManager.getInstance().getFullScreenSubSessionList();
        for (let subSession of subSessionList) {
          subSession.onUpdateMaximizeRect();
        }
      }
    });
  }

  private onStatusHide(): void {
    let sceneSessionMgr = SCBSceneSessionManager.getInstance();
    let container = sceneSessionMgr.getSessionOfTopFullScreenSubSession(this.screenProperty.screenId);
    let subSession = sceneSessionMgr.getTopFullScreenSubSession(this.screenProperty.screenId, container);
    if (subSession && sceneSessionMgr.getIsStatusBarShownForHover()) {
      log.showInfo('hide subSession title when status bar has been hidden');
      sceneSessionManager.updateTitleInTargetPos(subSession.session.persistentId, false, 0);
    }
  }

  private propertyChangeScenePanelCallback = (
    screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason): void => {
    log.showDebug('SCBSpecificScenePanel screen callback is called');
    this.onScreenPropertyChange(screenProperty, reason);
  }

  private destroyFloatWindowCallback = (specificSession: sceneSessionManager.SceneSession): void => {
    this.onDestroyFloatWindowFromSceneSession(specificSession);
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, zorder: ${this.zorder}}`);
    this.systemSceneList = SCBPcScenePanelManager.getInstance().getSpecificSessionList(this.zorder);
    this.sessionStateChange = (parentId: number, persistentId: number,
                               state: sceneSessionManager.SessionState): void =>
    this.onSessionStateChange(parentId, persistentId, state);
    this.createSpecificScene = (specificSession: sceneSessionManager.SceneSession): void =>
      this.onCreateSpecificScene(specificSession);
    SCBSceneSessionManager.getInstance().registerCreateSpecificSceneCallback(
      (specificSession: sceneSessionManager.SceneSession) => {
        this.createSpecificScene(specificSession);
      }, this.zorder, this.screenProperty?.screenId
    );
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback(
      this.propertyChangeScenePanelCallback, this.zorder, this.screenProperty.screenId
    );
    log.showInfo(`specificScenePanel screen id is ${this.screenProperty?.screenId}`);
    SCBSceneSessionManager.getInstance().registerDestroyFloatWindowCallback(
      this.destroyFloatWindowCallback, this.zorder, this.screenProperty?.screenId
    );
    SCBSceneSessionManager.getInstance().registerGetSpecificContainerSessionListCallback(
      this.getSpecificContainerSessionList, this.zorder, this.screenProperty?.screenId
    );
    if ((this.zorder === SpecificPanelZOrder.ABOVE_SCENE_PANEL || this.zorder === SpecificPanelZOrder.TYPE_FLOAT) &&
      this.screenProperty?.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().registerEnterRecentForFloatCallback(
        () => {
          this.hideLargeFloatWindowWhenEnterRecent();
        }
      );
      SCBSceneSessionManager.getInstance().registerExitRecentForFloatCallback(
        () => {
          this.showLargeFloatWindowWhenExitRecent();
        }
      );
    }
    if (this.screenProperty) {
      this.screenProp.copy(this.screenProperty);
    }
    viewMgrPolicy.registerViewCallback(ViewType.STATUS_BAR, this.statusViewCallback);
  }

  aboutToDisappear(): void {
    log.showInfo(`[SCBSpecific] specificScenePanelAboutToDisapear, screen id: ${this.screenProperty?.screenId}, zorder: ${this.zorder}}`);
    if (this.screenProperty) {
      SCBPcScenePanelManager.getInstance().unRegisterSpecificSessionController(this.screenProperty.screenId,
        this.zorder);
    }
    viewMgrPolicy.unRegisterViewCallback(ViewType.STATUS_BAR, this.statusViewCallback);
    SCBScreenSessionManager.getInstance().unRegisterPropertyChangeScenePanelCallback(
      this.propertyChangeScenePanelCallback, this.zorder, this.screenProperty.screenId
    );
    SCBSceneSessionManager.getInstance().unregisterDestroyFloatWindowCallback(
      this.destroyFloatWindowCallback, this.zorder, this.screenProperty?.screenId
    );
  }


  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
        ForEach(this.systemSceneList, (item: SCBSpecificSession) => {
          SCBSpecificScene({
            specificSession: item,
            screenProperty: $screenProperty,
            singleContext: this.singleContext,
            rect: item.currRect,
            parentRect: item.currRect,
            parentSceneSession: item.getParentSession(),
            subWindowAnchorInfo: item.subWindowAnchorInfo
          })
        }, (item: SCBSpecificSession) => item.session?.persistentId.toString())
      }
      .id('SCBSpecificPanelTransformScene')
      .direction(Direction.Ltr)
      .size({ width: this.screenProperty.width + 'px', height: this.screenProperty.height + 'px' })
      .hitTestBehavior(HitTestMode.None)
      .zIndex(this.getZIndex())
    }
    .id('SCBSpecificScenePanelBackground')
    .direction(Direction.Ltr)
    .position({ x: 0, y: 0 })
    .size({ width: '100%', height: '100%' })
    .hitTestBehavior(HitTestMode.None)
    .zIndex(this.getZIndex())
  }
}
