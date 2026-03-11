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
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  ACTIVE_STATUS_MAP,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSpecificSceneSessionList,
  SCBSpecificSession,
  SCBDynamicSystemScene,
  SCBDynamicSystemSceneList,
  SCBPropertyChangeReason,
  SCBSessionRect,
  ScbNumber,
  SCBSpecificScenePanelDebugCommands,
} from '@ohos/windowscene';
import { SCBDynamicSpecificScene } from './SCBDynamicSpecificScene';
import { SCBDefaultZIndex, ZORDER_TO_DEFAULTZINDEX } from './SCBScreen';

const TAG = 'SCBDynamicSpecificScenePanel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBDynamicSpecificScenePanel {
  @Link screenProperty: SCBScreenProperty;
  zorder: number = 0;
  @State dynamicSystemSceneList: SCBDynamicSystemSceneList = new SCBDynamicSystemSceneList();
  @State systemSceneList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  private sessionStateChange = (parentId: number, persistentId: number, state: sceneSessionManager.SessionState,
    zIndex: number): void => this.onSessionStateChange(parentId, persistentId, state, zIndex);
  private createSpecificScene = (specificSession: sceneSessionManager.SceneSession):
    void => this.onCreateSpecificScene(specificSession);
  private debugCommands: SCBSpecificScenePanelDebugCommands =
    new SCBSpecificScenePanelDebugCommands(this.systemSceneList, SCBDefaultZIndex.DYNAMIC);
  private currSpecificSessionRect: SCBSessionRect = new SCBSessionRect();
  getSpecificContainerSessionList = (): SCBSpecificSceneSessionList => {
    return this.systemSceneList;
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

  onSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState,
    zIndex: number): void {
    log.showInfo(`dynamic onSessionStateChange, id: ${persistentId}`);
    const index = this.systemSceneList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index !== -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive == undefined || !this.systemSceneList[index]) {
        return;
      }
      this.systemSceneList[index].isActive = isActive;
      SCBSceneSessionManager.getInstance().updateHomeOccludedState(this.systemSceneList, this.zorder);
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        this.removeSpecificSceneSession(persistentId, zIndex);
        return;
      }
      log.showInfo('onSessionStateChange persistentId: ' + persistentId + ', isActive: ' +
      this.systemSceneList[index].isActive + ', length: ' + this.systemSceneList.length + ', state:' + state);
    } else {
      log.showInfo(`onSessionStateChange not in systemSceneList, id: ${persistentId}, zIndex: ${zIndex}`);
    }
  }

  onCreateSpecificScene(specificSession: sceneSessionManager.SceneSession): void {
    const indexInAll = this.systemSceneList.findIndex(item => {
      return item.session?.persistentId === specificSession?.persistentId;
    });
    if (indexInAll === -1) {
      const hwSceneSession = new SCBSpecificSession(specificSession, this.sessionStateChange);
      this.addSpecificSceneSession(hwSceneSession);
    } else {
      log.showInfo(`Session is already in systemSceneList, id: ${specificSession.persistentId}, index: ${indexInAll}`);
    }
    log.showInfo(`createSpecificScene`);
  }

  private onDestroyFloatWindowFromSceneSession(sceneSession: sceneSessionManager.SceneSession): void {
    // 监听窗口destroy 移除对应的session
    this.removeSpecificSceneSession(sceneSession.persistentId, sceneSession.zIndex);
    log.showInfo(`onDestroyFloatWindowFromSceneSession`);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear SCBDynamicSpecificScenePanel zorder: ${this.zorder}`);
    this.sessionStateChange =
      (parentId: number, persistentId: number, state: sceneSessionManager.SessionState, zIndex: number):
        void => this.onSessionStateChange(parentId, persistentId, state, zIndex);
    this.createSpecificScene = (specificSession: sceneSessionManager.SceneSession):
      void => this.onCreateSpecificScene(specificSession);
    SCBSceneSessionManager.getInstance().registerCreateSpecificSceneCallback(
      (specificSession: sceneSessionManager.SceneSession) => {
        this.createSpecificScene(specificSession);
      }, this.zorder
    );
    SCBSceneSessionManager.getInstance().registerDestroyFloatWindowCallback(
      (specificSession: sceneSessionManager.SceneSession) => {
        this.onDestroyFloatWindowFromSceneSession(specificSession);
      }, this.zorder
    );
    SCBSceneSessionManager.getInstance().registerGetSpecificContainerSessionListCallback(
      this.getSpecificContainerSessionList, this.zorder
    );
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback((
      screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason) => {
      log.showDebug('SCBSpecificScenePanel screen callback is called');
      this.onScreenPropertyChange(screenProperty, reason);
    }, this.zorder, this.screenProperty.screenId);

    this.debugCommands.register();
    this.currSpecificSessionRect = new SCBSessionRect(this.screenProperty.left, this.screenProperty.top,
      this.screenProperty.width, this.screenProperty.height);
  }

  private onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    log.showInfo('SCBSpecificScenePanel onScreenPropertyChange reason:' + reason +
      ' screenProperty:[' + screenProperty.left + ',' + screenProperty.top + ',' +
      screenProperty.width + ',' + screenProperty.height + ',' + screenProperty.rotation + ']');
    this.currSpecificSessionRect = new SCBSessionRect(screenProperty.left, screenProperty.top,
      screenProperty.width, screenProperty.height);
  }

  aboutToDisappear(): void {
    this.debugCommands.unregister();
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
