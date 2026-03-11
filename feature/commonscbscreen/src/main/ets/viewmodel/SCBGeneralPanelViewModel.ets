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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBScreenProperty,
  SCBContainerRotationReason,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBSceneContainerSession,
  SCBEventId,
  SCBBaseScenePanelViewModel,
  SCBSceneSessionManager,
  SystemSessionInfo,
  SCBSystemSceneSession
} from '@ohos/windowscene';
import {
  SCBGeneralScenePanelMissionHandler
} from '../missions/SCBGeneralScenePanelMissionHandler';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBZIndexOnGeneralScreen } from '../config/SCBZIndexOnGeneralScreen';
import { SCBScenePanelStateSession } from '../viewstates/SCBScenePanelStateSession';

const TAG: string = 'SCBGeneralPanelViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class SCBGeneralPanelViewModel extends SCBBaseScenePanelViewModel<SCBGeneralScenePanelMissionHandler> {
  private systemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: this.panelName,
    sceneZIndex: SCBZIndexOnGeneralScreen.SYSTEM_SCENE_PANEL,
    isFocusable: false,
    isTouchable: false,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.PANEL_SCENE,
    isRotatable: false,
  };
  public sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(this.systemSessionInfo,
    null, null, this.screenId);
  public panelSession = new SCBScenePanelStateSession();

  private onScreenRotationChange =
    (oldProperty: SCBScreenProperty, reason: SCBPropertyChangeReason, screenProperty: SCBScreenProperty) => {
      const session = this.missionHandler.getTopActiveSession();
      if (session) {
        this.updateContainerSession(screenProperty, session);
      }
    }
  private onOrientationChange = (persistentId: number, requestedOrientation: number) => {
    log.showInfo(`onOrientationChange ${persistentId} ${requestedOrientation}`);
    let containerSession = this.missionHandler.getContainerSessionByPersistentIdOrContainerId(persistentId);
    if (containerSession) {
      let rotation = containerSession.getTargetPageRotation(0, requestedOrientation, true) ?? 0;
      log.showInfo(`requestedRotation ${rotation} ${this.screenProperty.width}x${this.screenProperty.height}`);
      let displayProperty = new SCBScreenProperty();
      displayProperty.copy(this.screenProperty);
      displayProperty.rotateTo(rotation);
      this.updateContainerSession(displayProperty, containerSession);
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(displayProperty);
    }
  }

  /**
   * 构造函数
   *
   * @param screenProperty 屏幕属性
   */
  public constructor(screenProperty: SCBScreenProperty) {
    super(new SCBGeneralScenePanelMissionHandler(screenProperty), screenProperty);
  }

  public init(): void {
    log.showInfo('init.');
    this.registerCallbacks();
    this.laterInitOnPanelAppear();
  }

  public release(): void {
    log.showInfo('release.');
    this.unregisterCallbacks();
    this.laterReleaseOnPanelDisappear();
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.sysSceneSession, this.screenId);
  }

  private registerCallbacks(): void {
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListCallback(() => {
      return this.missionHandler.getContainerSessionList();
    }, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().on(SCBEventId.ORIENTATION_CHANGE,
      this.screenProperty.screenId, this.onOrientationChange);
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback(this.onScreenRotationChange,
      SCBPropertyChangeReason.ROTATION, this.screenProperty.screenId);
  }

  private unregisterCallbacks(): void {
    SCBSceneSessionManager.getInstance().unregisterGetContainerSessionListCallback(this.screenId);
    SCBSceneSessionManager.getInstance().off(SCBEventId.ORIENTATION_CHANGE,
      this.screenProperty.screenId, this.onOrientationChange);
    SCBScreenSessionManager.getInstance().unRegisterPropertyChangeScenePanelCallback(this.onScreenRotationChange,
      SCBPropertyChangeReason.ROTATION, this.screenProperty.screenId);
  }

  public updateContainerSession(screenProperty: SCBScreenProperty, containerSession: SCBSceneContainerSession) {
    let displayProperty = new SCBScreenProperty();
    displayProperty.copy(screenProperty);
    containerSession.updateContainerSessionWithRotation(displayProperty, SCBContainerRotationReason.SCREEN_ROTATION,
      true);
    containerSession.primarySession?.updateCurRectForMultiWindowToFull(displayProperty);
  }
}