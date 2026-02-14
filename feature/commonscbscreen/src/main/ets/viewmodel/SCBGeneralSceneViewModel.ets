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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSession, SCBSceneSessionManager, SCBScreenProperty,
  SCBSpecificSceneSessionList,
  SCBSpecificSession,
  SceneDataCategory, } from '@ohos/windowscene';
import { SCBBaseSceneViewModel } from '@ohos/windowscene/Index';

const TAG: string = 'SCBGeneralSceneViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const ACTIVE_STATUS_MAP: Map<sceneSessionManager.SessionState, boolean> = new Map([
  [sceneSessionManager.SessionState.STATE_CONNECT, false],
  [sceneSessionManager.SessionState.STATE_FOREGROUND, true],
  [sceneSessionManager.SessionState.STATE_ACTIVE, true],
  [sceneSessionManager.SessionState.STATE_INACTIVE, false],
  [sceneSessionManager.SessionState.STATE_BACKGROUND, false],
  [sceneSessionManager.SessionState.STATE_DISCONNECT, false]
]);

export class SCBGeneralSceneViewModel extends SCBBaseSceneViewModel {
  private subSessionList: SCBSpecificSceneSessionList;

  private subSessionStateChange = (parentId: number, persistentId: number,
    state: sceneSessionManager.SessionState): void => {
    const index = this.subSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showInfo(`can not find subSession with id ${persistentId}`);
      return;
    }
    const isActive = ACTIVE_STATUS_MAP.get(state)
    if (isActive === undefined) {
      log.showInfo(`can not find subSession with state ${state}`);
      return;
    }
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      this.subSessionList.splice(index, 1);
      return;
    }
    const curSession = this.subSessionList[index];
    if (isActive) {
      this.subSessionList.splice(index, 1, curSession);
    }
    curSession.isActive = isActive;
    curSession.sessionData.sessionState = state;
  }

  private subSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean): void => {
    log.showInfo(`subSessionRaiseToTop: ${persistentId} , ${raiseParent}` );
    const index = this.subSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showInfo(`can not find subSession with id ${persistentId}`);
      return;
    }
    const curSession = this.subSessionList[index];
    this.subSessionList.splice(index, 1, curSession);
  }

  private subSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void => {
    log.showInfo(`subSessionRaiseAboveTarget: ${persistentId} , ${targetSubWindowId}` );
    if (persistentId === targetSubWindowId) {
      return;
    }
    const index = this.subSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showInfo(`can not find subSession with id ${persistentId}`);
      return;
    }
    const curSession = this.subSessionList[index];
    this.subSessionList.splice(index, 1);
    const targetIndex = this.subSessionList.findIndex(item => {
      return item.session.persistentId === targetSubWindowId;
    });
    if (targetIndex === -1) {
      log.showInfo(`can not find subSession with targetSubWindowId ${persistentId}`);
    }
    this.subSessionList.splice(targetIndex + 1, 0, curSession);
  };

  private subSessionZLevelChange = (parentId: number, persistentId: number, zLevel: number): void => {
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showInfo(`[SCBSub] onSubSessionZLevelChange find no subSession: ${persistentId}`);
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
    log.showInfo(`[SCBSub] onSubSessionZLevelChange, index: ${index}, length: ${subList.length}`);
  };

  private createDialog = (specificSession: sceneSessionManager.SceneSession) => {
    this.onCreateDialog(specificSession);
  };

  private dialogStateChange = (parentId: number, persistentId: number, state: sceneSessionManager.SessionState) => {
    this.onDialogSessionStateChange(parentId, persistentId, state);
  };

  public constructor(screenProperty: SCBScreenProperty, sceneSession: SCBSceneSession) {
    super(screenProperty, sceneSession);
    this.subSessionList = sceneSession.subSessionList;
  }

  public init(): void {
    log.showInfo('init.');
    const mgmtData = this.sceneSession.getData(SceneDataCategory.MISSION_MANAGEMENT);
    this.sceneSession.registerCreateSubSessionCallback((session: SCBSceneSession,
      specificSession: sceneSessionManager.SceneSession) => {
      if (specificSession == null) {
        log.showError('null specific session create.');
        return;
      }
      if (this.sceneSession.persistentId !== specificSession.parentId) {
        log.showError(`onCreateSubSession but parent session not matched`);
        return;
      }
      log.showInfo(`onCreateSubSession, id: ${specificSession.persistentId} parentId: ${specificSession.parentId}`);
      const indexInAll: number = this.subSessionList.findIndex((item: SCBSpecificSession) => {
        return item.session.persistentId === specificSession.persistentId;
      });
      if (indexInAll !== -1) {
        log.showInfo(`already in subList, id: ${specificSession.persistentId} index: ${indexInAll}`);
        return;
      }
      // update display on general screen
      SCBSceneSessionManager.getInstance().updateSessionDisplayId(specificSession.persistentId,
        this.screenProperty.screenId);
      // create new specific session
      let hwSceneSession = new SCBSpecificSession(specificSession, { stateChangeCallback: this.subSessionStateChange,
        raiseToTopCallback: this.subSessionRaiseToTop, raiseAboveTargetCallback: this.subSessionRaiseAboveTarget,
        zLevelChangeCallback: this.subSessionZLevelChange});
      // add into list
      SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, this.subSessionList);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }, mgmtData ? mgmtData.onWhichPanel : undefined);
    this.sceneSession.registerCreateDialogCallback(this.createDialog, mgmtData ? mgmtData.onWhichPanel : undefined);
  }

  public release(): void {
    log.showInfo('release.');
    const mgmtData = this.sceneSession.getData(SceneDataCategory.MISSION_MANAGEMENT);
    this.sceneSession.unRegisterAll(mgmtData ? mgmtData.onWhichPanel : undefined);
  }

  private onCreateDialog(specificSession: sceneSessionManager.SceneSession): void {
    if (this.sceneSession.session?.persistentId === specificSession?.parentId) {
      const indexInAll = this.subSessionList?.findIndex(item => {
        return item.session?.persistentId === specificSession?.persistentId;
      });
      if (indexInAll == -1) {
        let hwSceneSession = new SCBSpecificSession(specificSession, this.dialogStateChange);
        SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, this.subSessionList);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        log.showInfo('[SCBDialog] primary create dialog success, + id: ' + specificSession.persistentId);
      } else {
        log.showInfo('[SCBDialog] primary dialog is created, id: ' +
        specificSession.persistentId + 'index: ' + indexInAll);
      }
    }
  }

  private onDialogSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState) {
    log.showInfo('dialog session state change');
    let dialogList = this.subSessionList;
    if (dialogList.length === 0) {
      log.showError('[SCBDialog] dialogList is empty');
      return;
    }
    const index = dialogList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index != -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive == undefined || !this.subSessionList[index]) {
        return;
      }
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        dialogList.splice(index, 1);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        return;
      }
      dialogList[index].isActive = isActive;
      dialogList[index].sessionData.sessionState = state;
      log.showInfo('[SCBDialog] state change, persistentId: ' + persistentId + ', state: ' + state +
        ', isActive: ' + dialogList[index].isActive + ', length: ' + dialogList.length);
    }
  }
}