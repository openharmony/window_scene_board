/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
  ACTIVE_STATUS_MAP,
  scbGestureManager,
  SCBPropertyChangeReason,
  SCBEventId,
  scbEventExclusiveManager,
  EventType,
  SCBSpecificSession,
  SCBSpecificSceneSessionList,
  SCBScreenProperty,
  SCBSceneSessionManager,
  SCBWindowRotateController,
  SCBSceneSession,
  SCBRotateChangeReason
} from '@ohos/windowscene';
import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { RotationConstants, SceneConstants } from '@ohos/commonconstants';
import { SCBPictureInPictureScene } from './SCBPictureInPictureScene';
import { SCBDefaultZIndex } from '../SCBScreen';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { GestureType } from '@ohos/windowscene';
import Curves from '@ohos.curves';
import { Constants } from './utils/PictureInPictureConstants';
import { Queue } from '@kit.ArkTS';
import { RectChangeItem } from './utils/PiPUtils';
import { SCBPiPManager } from './SCBPiPManager';
import { systemDateTime } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { SCBPcScenePanelManager, SpecificSessionController } from '@ohos/pcmode';

const TAG = 'SCBPictureInPictureScenePanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const RECOVER_EVENT_TIME_OUT = 1500;

@Component
export struct SCBPictureInPictureScenePanel {
  @Link screenProperty: SCBScreenProperty;
  zorder: number = 0;
  @State panelZIndex: number = SCBDefaultZIndex.PIP_SCENE_PANEL;
  @State pipSceneList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  private sessionStateChange = (parentId: number, persistentId: number,
    state: sceneSessionManager.SessionState): void => this.onSessionStateChange(parentId, persistentId, state);
  private createSpecificScene =
    (specificSession: sceneSessionManager.SceneSession): void => this.onCreateSpecificScene(specificSession);

  private sessionRectChange = (rect: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason): void => this.onSessionRectChange(rect, reason);

  @State panelRotate: RotateOptions = {
    x: 0,
    y: 0,
    z: 1,
    angle: -this.screenProperty.rotation,
    centerX: '50%',
    centerY: '50%'
  };

  @State backgroundRotate: RotateOptions = {
    x: 0,
    y: 0,
    z: 1,
    angle: -this.screenProperty.rotation,
    centerX: '50%',
    centerY: '50%'
  };

  @State panelTranslate: TranslateOptions = {
    x: !SCBWindowRotateController.getInstance().isFullScreenRotatePolicy() ? (0 + 'px') :
      (this.screenProperty.getTranslateX() + 'px'),
    y: !SCBWindowRotateController.getInstance().isFullScreenRotatePolicy() ? (0 + 'px') :
      (this.screenProperty.getTranslateY() + 'px')
  };

  @State panelSize: SizeOptions = {
    width: px2vp(this.screenProperty.width),
    height: px2vp(this.screenProperty.height)
  }

  @State delayRotation: boolean = false;
  @State backgroundOpacity: number = 0;
  @State propChangeReason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
  @State msgQueue: Queue<RectChangeItem> = new Queue();
  @State avoidHeight: number = vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA);
  getPipSessionList = (): SCBSpecificSceneSessionList => {
    return this.pipSceneList;
  }

  onSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState): void {
    const index = this.pipSceneList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index !== -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive === undefined || this.pipSceneList[index] === null || this.pipSceneList[index] === undefined) {
        return;
      }
      this.pipSceneList[index].isActive = isActive;
      SCBSceneSessionManager.getInstance().updateHomeOccludedState(this.pipSceneList, this.zorder);
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        this.pipSceneList.splice(index, 1);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        SCBPiPManager.getInstance().detachPiPWindowSession(persistentId)
        SCBPiPManager.getInstance().detachPiPWindowSceneSession(parentId);
        return;
      }
      log.showInfo('onSubSessionActiveStatueChange persistentId: ' + persistentId + ', isActive: ' +
      this.pipSceneList[index].isActive + ', length: ' + this.pipSceneList.length + ', state:' + state);
    }
  }

  onCreateSpecificScene(specificSession: sceneSessionManager.SceneSession): void {
    const indexInAll = this.pipSceneList.findIndex(item => {
      return item.session?.persistentId === specificSession?.persistentId;
    });
    if (indexInAll === -1) {
      let hwSceneSession = new SCBSpecificSession(specificSession, this.sessionStateChange);
      specificSession?.setFocusable(false);
      hwSceneSession.registerSessionRectChangeCallback(this.sessionRectChange, this.screenProperty.screenId);
      this.delayRotation = false;
      this.pipSceneList.push(hwSceneSession);
      SCBPiPManager.getInstance().isActiveStartPiP = true;
      SCBPiPManager.getInstance().attachPiPWindowSession(hwSceneSession);
      let scbSceneSession = SCBSceneSessionManager.getInstance().getSessionById(specificSession.parentId);
      if (scbSceneSession instanceof SCBSceneSession) {
        SCBPiPManager.getInstance().attachPiPWindowSceneSession(scbSceneSession);
      }
      hwSceneSession.enableSessionStateChange();
      SCBSceneSessionManager.getInstance().refreshZOrder();
      log.showInfo(`onCreateSpecificScene: TemplateInfo = ${this.getPiPTemplateInfo(hwSceneSession)}`);
    } else {
      log.showInfo(`Session is already in subList, id: ${specificSession.persistentId}, index: ${indexInAll}`);
    }
    log.showInfo(`onCreateSpecificScene, curRotation: ${this.screenProperty.rotation}`);
  }

  onSessionRectChange(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason) {
    log.showInfo(`cache sessionRectChange msg, reason:${reason}`);
    this.msgQueue.add(new RectChangeItem(rect, reason));
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.pipSceneList = SCBPcScenePanelManager.getInstance().getSpecificSessionList(this.zorder);
    this.sessionStateChange = (parentId: number, persistentId: number,
      state: sceneSessionManager.SessionState): void => this.onSessionStateChange(parentId, persistentId, state);
    this.createSpecificScene =
      (specificSession: sceneSessionManager.SceneSession): void => this.onCreateSpecificScene(specificSession);
    SCBSceneSessionManager.getInstance().registerCreateSpecificSceneCallback(
      (specificSession: sceneSessionManager.SceneSession) => {
        this.createSpecificScene(specificSession);
      }, this.zorder, this.screenProperty?.screenId
    );

    SCBSceneSessionManager.getInstance().registerGetSpecificContainerSessionListCallback(
      this.getPipSessionList, this.zorder, this.screenProperty?.screenId
    );

    scbGestureManager.registerGestureEvent(GestureType.BACK, TAG, () => {
      let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId);
      if (focusedSession?.session.type !== sceneSessionManager.SessionType.TYPE_PIP) {
        return;
      }
      SCBSceneSessionManager.getInstance()?.requestUnfocus(focusedSession?.session.persistentId);
    });

    SCBSceneSessionManager.getInstance().on(SCBEventId.PIP_SCENE_PANEL_ROTATION, this.screenProperty.screenId,
      this.onPipScenePanelRotationChange);

    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(
      this.prepareRotationBeforeAnimation, this.screenProperty?.screenId);

    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback(
      this.onScreenPropertyChange, SCBDefaultZIndex.PIP_SCENE_PANEL, this.screenProperty.screenId);

    SCBSceneSessionManager.getInstance().registerNavChangeCallback((isVisible: boolean, barArea: RectInfo) => {
        this.avoidHeight = vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA) + (barArea.bottom - barArea.top);
    })
    scbEventExclusiveManager.registerEventExclusive(EventType.PIP_RESTORE, () => {
      let isPipGesture: boolean = scbEventExclusiveManager.getEventExclusiveByCaller(EventType.PIP_RESTORE);
      log.showInfo(`recover eventExclusive state isPipGesture: ${isPipGesture}`);
      if (!isPipGesture) {
        return;
      }
      let endTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
      if ((endTime - SCBPiPManager.getInstance().startExcludeEventTimeStamp) < RECOVER_EVENT_TIME_OUT) {
        log.showInfo(`invalid recover request`);
        return;
      }
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
    });
    SCBSceneSessionManager.getInstance().registerStartPiPFailedCallback(() => {
      this.showPipFailedToast();
    }, this.screenProperty.screenId);
    if (this.screenProperty.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().registerAutoStartPiPCallback(
        SCBPiPManager.getInstance().autoStartPiPCallback);
    }
  }

  private activeRotation: () => void = () => {
    this.doDelayRotation();
  };

  private recoverRotation: () => void = () => {
    this.doDelayRotation();
    if (SCBPiPManager.getInstance().isNeedRotation) {
      log.showInfo(`recoverRotation set propChangeReason = ROTATION`);
      this.propChangeReason = SCBPropertyChangeReason.ROTATION;
    }
  };

  doDelayRotation() {
    if (!this.delayRotation) {
      log.showWarn(`doDelayRotation: rotation delay is not config`);
      return;
    }
    this.delayRotation = false;
    if (this.screenProperty.rotation === this.panelRotate.angle) {
      log.showInfo(`doDelayRotation: don't need rotation`);
      return;
    }
    log.showInfo(`doDelayRotation, curRotation: ${this.screenProperty.rotation}`);
    if (this.screenProperty.rotation === RotationConstants.ROTATION_0 &&
      this.panelRotate.angle === -RotationConstants.ROTATION_270) {
      // avoid animation 270->0
      this.panelRotate.angle = RotationConstants.ROTATION_90;
    } else if (this.screenProperty.rotation === RotationConstants.ROTATION_270 &&
      this.panelRotate.angle === RotationConstants.ROTATION_0) {
      // avoid animation 0->270
      this.panelRotate.angle = -RotationConstants.ROTATION_360;
    }
    this.notifyRotation(this.screenProperty);
  }

  private prepareRotationBeforeAnimation = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
    if (!SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
      return;
    }
    if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
      if (screenProperty.rotation === RotationConstants.ROTATION_0 &&
        this.panelRotate.angle === -RotationConstants.ROTATION_270) {
        // avoid animation 270->0
        this.panelRotate.angle = RotationConstants.ROTATION_90;
      } else if (screenProperty.rotation === RotationConstants.ROTATION_270 &&
        this.panelRotate.angle === RotationConstants.ROTATION_0) {
        // avoid animation 0->270
        this.panelRotate.angle = -RotationConstants.ROTATION_360;
      }
    }
  }

  private onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (reason === SCBPropertyChangeReason.ROTATION || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD ||
      reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      if (this.delayRotation) {
        SCBPiPManager.getInstance().isNeedRotation = true;
        return;
      }
    }
    this.propChangeReason = reason;
    log.showInfo(`onScreenPropertyChange reason: ${reason}, curRotation: ${screenProperty.rotation}`);
    if (reason === SCBPropertyChangeReason.ROTATION || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD ||
      reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      if (screenProperty.rotation === RotationConstants.ROTATION_0 &&
        this.panelRotate.angle === -RotationConstants.ROTATION_270) {
        // avoid animation 270->0
        this.panelRotate.angle = RotationConstants.ROTATION_90;
      } else if (screenProperty.rotation === RotationConstants.ROTATION_270 &&
        this.panelRotate.angle === RotationConstants.ROTATION_0) {
        // avoid animation 0->270
        this.panelRotate.angle = -RotationConstants.ROTATION_360;
      }
      this.notifyRotation(screenProperty);
    }
    this.propChangeReason = SCBPropertyChangeReason.UNDEFINED;
  }

  private onPipScenePanelRotationChange = (persistentId?: number, containerId?: number) => {
    this.onScreenPropertyChange(this.screenProperty, SCBPropertyChangeReason.ROTATION);
  }

  notifyRotation(screenProperty: SCBScreenProperty): void {
    this.backgroundRotate.angle = -screenProperty.rotation;
    if (this.pipSceneList.length > 0) {
      animateTo({
        curve: Curves.springMotion(0.4, 1) }, () => {
        this.updatePanelProperty(screenProperty);
      });
    } else {
      this.updatePanelProperty(screenProperty);
    }
  }

  private updatePanelProperty(screenProperty: SCBScreenProperty) {
    this.panelRotate.angle = -screenProperty.rotation;
    log.showInfo(`updatePanelProperty panelRotate.angle: ${this.panelRotate.angle}`);
    if (!SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
      this.panelTranslate = { x: 0, y: 0 };
    } else {
      this.panelTranslate = {
        x: screenProperty.getTranslateX() + 'px',
        y: screenProperty.getTranslateY() + 'px'
      };
    }
    this.panelSize = { width: px2vp(screenProperty.width), height: px2vp(screenProperty.height) };
  }

  getPiPTemplateInfo(scbSession: SCBSpecificSession): string {
    let res: string = 'pipTemplateInfo = [ ';
    if (scbSession === null || scbSession === undefined) {
      return res + ' ]';
    }
    let pipTemplateInfo: sceneSessionManager.PipTemplateInfo = scbSession.session?.pipTemplateInfo;
    if (pipTemplateInfo === null || pipTemplateInfo === undefined) {
      return res + ' ]';
    }
    res += `${pipTemplateInfo.pipTemplateType}, ${pipTemplateInfo.priority}, `;
    res += `[ ${pipTemplateInfo.controlGroup.toString()} ] ]`;
    return res;
  }

  aboutToDisappear() {
    SCBSceneSessionManager.getInstance().unregisterCreateSpecificSceneCallback(
      this.zorder, this.screenProperty?.screenId);
    SCBSceneSessionManager.getInstance().unregisterGetSpecificContainerSessionListCallback(
      this.zorder, this.screenProperty?.screenId);
    SCBSceneSessionManager.getInstance().off(SCBEventId.PIP_SCENE_PANEL_ROTATION, this.screenProperty.screenId,
      this.onPipScenePanelRotationChange);
    SCBScreenSessionManager.getInstance().unRegisterPropertyChangeScenePanelCallback(
      this.onScreenPropertyChange, SCBDefaultZIndex.PIP_SCENE_PANEL, this.screenProperty.screenId);
    scbGestureManager.unRegisterGestureEvent(GestureType.BACK, TAG);
    SCBSceneSessionManager.getInstance().unRegisterNavChangeCallback();
    scbEventExclusiveManager.unRegisterEventExclusive(EventType.PIP_RESTORE);
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.prepareRotationBeforeAnimation,
      this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unregisterStartPiPFailedCallback(this.screenProperty.screenId);
    if (this.screenProperty.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().unregisterAutoStartPiPCallback();
    }
  }

  private showPipFailedToast(): void {
    log.showInfo(`onStartPiPFailed, isActiveStartPiP: ${SCBPiPManager.getInstance().isActiveStartPiP}`);
    if (SCBPiPManager.getInstance().isActiveStartPiP) {
      this.getUIContext().getPromptAction().showToast({
        showMode: 2,
        message: $r('app.string.already_exist_pip_window_toast'),
        alignment: Alignment.Center,
        bottom: 108,
      });
      return;
    }
    SCBPiPManager.getInstance().isActiveStartPiP = true;
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Stack()
        .size({ width: '400%', height: '400%' })
        .rotate(this.backgroundRotate)
        .opacity(this.backgroundOpacity)
        .backgroundColor(Color.Black)
      WindowScene(SceneConstants.TRANSFORM_SCENE) { // transformScene, always full screen
        ForEach(this.pipSceneList, (item: SCBSpecificSession) => {
          SCBPictureInPictureScene({
            specificSession: item,
            screenProperty: $screenProperty,
            rect: item.currRect,
            propChangeReason: this.propChangeReason,
            msgQueue: this.msgQueue,
            delayRotation: this.delayRotation,
            activeRotation: this.activeRotation,
            recoverRotation: this.recoverRotation,
            pipBackgroundOpacity: this.backgroundOpacity,
            panelZIndex: this.panelZIndex,
          })
        }, (item: SCBSpecificSession) => item.session?.persistentId.toString())
      }
      .zIndex(this.panelZIndex)
      .position({ x: this.screenProperty.left + 'px', y: this.screenProperty.top + 'px' })
      .translate(this.panelTranslate)
      .size(this.panelSize)
      .hitTestBehavior(HitTestMode.None)
    }
    .zIndex(this.panelZIndex)
    .position({x: this.screenProperty.left + 'px', y: this.screenProperty.top + 'px'})
    .size(this.panelSize)
    .hitTestBehavior(HitTestMode.None)
    .visibility(this.pipSceneList.length > 0 ? Visibility.Visible : Visibility.Hidden)
  }
}