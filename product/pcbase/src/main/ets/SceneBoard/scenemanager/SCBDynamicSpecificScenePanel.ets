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

import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSpecificSession,
  SCBSpecificSceneSessionList,
  SCBDynamicSystemScene,
  SCBDynamicSystemSceneList,
  SCBScreenProperty,
  SCBSceneSessionManager,
  ACTIVE_STATUS_MAP
} from '@ohos/windowscene';
import { SCBDynamicSpecificScene } from './SCBDynamicSpecificScene';
import PowerStatusChangeAnimationController from './PowerStatusChangeAnimationController';
import { SCBPcScenePanelManager } from '@ohos/pcmode';
import { ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';

const TAG = 'SCBDynamicSpecificScenePanel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);


@Component
export struct SCBDynamicSpecificScenePanel {
  @Link screenProperty: SCBScreenProperty;
  zorder: number = 0;
  @State dynamicSystemSceneList: SCBDynamicSystemSceneList = new SCBDynamicSystemSceneList();
  @State @Watch('systemSceneListUpdate') systemSceneList: SCBSpecificSceneSessionList =
    new SCBSpecificSceneSessionList();
  private sessionStateChange = (parentId: number, persistentId: number, state: sceneSessionManager.SessionState,
    zIndex: number): void => this.onSessionStateChange(parentId, persistentId, state, zIndex);
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

  addSpecificSceneSession(hwSceneSession: SCBSpecificSession) {
    this.systemSceneList.push(hwSceneSession);
    // 添加到渲染数组中
    let indexInDynamicList = this.dynamicSystemSceneList.findIndex((item: SCBDynamicSystemScene) => {
      return item.zIndex === hwSceneSession.session.zIndex;
    })
    if (indexInDynamicList === -1) {
      const curDynamicSystemScene = new SCBDynamicSystemScene(hwSceneSession.session.zIndex);
      curDynamicSystemScene.systemSceneList.push(hwSceneSession);
      this.dynamicSystemSceneList.push(curDynamicSystemScene);
    } else {
      this.dynamicSystemSceneList[indexInDynamicList].systemSceneList.push(hwSceneSession);
    }
    log.showInfo(`addSpecificSceneSession success. zIndex: ${hwSceneSession.session.zIndex}`);
  }

  removeSpecificSceneSession(persistentId: number, zIndex: number) {
    log.showInfo(`removeSpecificSceneSession, id: ${persistentId}, zIndex: ${zIndex}`);
    const index = this.systemSceneList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index !== -1) {
      this.systemSceneList.splice(index, 1);
      log.showInfo(`systemSceneList success remove id: ${persistentId}, zIndex: ${zIndex}, index: ${index}`);
    }
    for (let i = 0; i < this.dynamicSystemSceneList.length; i++) {
      if (this.dynamicSystemSceneList[i].zIndex !== zIndex) {
        continue;
      }
      const indexOfItem = this.dynamicSystemSceneList[i].systemSceneList.findIndex(dynamicSystemSceneItem => {
        return dynamicSystemSceneItem.session.persistentId === persistentId;
      });
      if (indexOfItem !== -1) {
        this.dynamicSystemSceneList[i].systemSceneList.splice(indexOfItem, 1);
        log.showInfo(`remove specificSession success. id: ${persistentId}, zIndex: ${zIndex}`);
        return;
      }
    }
  }

  onSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState,
    zIndex: number) {
    const index = this.systemSceneList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index !== -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive === undefined || !this.systemSceneList[index]) {
        return;
      }
      this.systemSceneList[index].isActive = isActive;
      log.showInfo(`onSubSessionActiveStatueChange persistentId: ${persistentId} ` +
        `isActive: ${this.systemSceneList[index].isActive}, length: ${this.systemSceneList.length} ` +
        `zorder: ${this.zorder}, state: ${state}`);
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        this.removeSpecificSceneSession(persistentId, zIndex);
        return;
      }
      if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
        // 层级抬升 调整窗口在list中的顺序
        this.dynamicSystemSceneList.forEach((item: SCBDynamicSystemScene) => {
          if (item.zIndex !== zIndex) {
            return;
          }
          const indexInDynamicList = item.systemSceneList.findIndex(dynamicSystemSceneItem => {
            return dynamicSystemSceneItem.session.persistentId === persistentId;
          });
          if (indexInDynamicList !== -1) {
            const currSession = item.systemSceneList[indexInDynamicList];
            item.systemSceneList.splice(indexInDynamicList, 1);
            item.systemSceneList.push(currSession);
            log.showInfo(`raiseToTop id: ${persistentId}, zIndex: ${zIndex}`);
          }
        })
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
      this.addSpecificSceneSession(hwSceneSession);
    } else {
      log.showInfo(`Session is already in subList, id: ${specificSession.persistentId}, index: ${indexInAll}`);
    }
  }

  private handleDestroyFloatWindow = (specificSession: sceneSessionManager.SceneSession) => {
    this.onDestroyFloatWindowFromSceneSession(specificSession);
  }

  onDestroyFloatWindowFromSceneSession(sceneSession: sceneSessionManager.SceneSession) {
    // 监听窗口destroy 移除对应的session
    this.removeSpecificSceneSession(sceneSession.persistentId, sceneSession.zIndex);
    log.showInfo(`onDestroyFloatWindowFromSceneSession`);
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

  private onStatusHide(): void {
    let sceneSessionMgr = SCBSceneSessionManager.getInstance();
    let container = sceneSessionMgr.getSessionOfTopFullScreenSubSession(this.screenProperty.screenId);
    let subSession = sceneSessionMgr.getTopFullScreenSubSession(this.screenProperty.screenId, container);
    if (subSession && sceneSessionMgr.getIsStatusBarShownForHover()) {
      log.showInfo('hide subSession title when status bar has been hidden');
      sceneSessionManager.updateTitleInTargetPos(subSession.session.persistentId, false, 0);
    }
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, zorder: ${this.zorder}}`);
    this.systemSceneList = SCBPcScenePanelManager.getInstance().getSpecificSessionList(this.zorder);
    this.sessionStateChange = (parentId: number, persistentId: number,
                               state: sceneSessionManager.SessionState, zIndex: number): void =>
      this.onSessionStateChange(parentId, persistentId, state, zIndex);
    this.createSpecificScene = (specificSession: sceneSessionManager.SceneSession): void =>
      this.onCreateSpecificScene(specificSession);
    SCBSceneSessionManager.getInstance().registerCreateSpecificSceneCallback(
      (specificSession: sceneSessionManager.SceneSession) => {
        this.createSpecificScene(specificSession);
      }, this.zorder, this.screenProperty?.screenId
    );
    log.showInfo(`specificScenePanel screen id is ${this.screenProperty?.screenId}`);
    SCBSceneSessionManager.getInstance().registerDestroyFloatWindowCallback(
      this.handleDestroyFloatWindow, this.zorder, this.screenProperty?.screenId
    );
    SCBSceneSessionManager.getInstance().registerGetSpecificContainerSessionListCallback(
      this.getSpecificContainerSessionList, this.zorder, this.screenProperty?.screenId
    );
  }

  aboutToDisappear(): void {
    log.showInfo(`[SCBSpecific]AboutToDisapear, screenId: ${this.screenProperty?.screenId}, zorder: ${this.zorder}}`);
    SCBSceneSessionManager.getInstance().unregisterDestroyFloatWindowCallback(
      this.handleDestroyFloatWindow, this.zorder, this.screenProperty?.screenId
    );
  }

  build() {
    ForEach(this.dynamicSystemSceneList, (dynamicSystemSceneItem: SCBDynamicSystemScene) => {
      SCBDynamicSpecificScene({
        screenProperty: $screenProperty,
        systemSceneList: dynamicSystemSceneItem.systemSceneList,
        zIndexValue: dynamicSystemSceneItem.zIndex,
      })
    }, (dynamicSystemSceneItem: SCBDynamicSystemScene) => dynamicSystemSceneItem.zIndex.toString())
  }
}
