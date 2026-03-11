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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneContainerSession, SCBSceneSession } from '@ohos/windowscene';

const TAG = 'SessionTempList';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export enum SessionTempListGroupNames {
  APP_RECOVER = 'appRecovery'
}

/**
 * a class that temporarily store sessions
 * those stored sessions will be removed after a few seconds, default 3s
 */
export class SessionTempList {
  private defaultDelay: number = 3000;
  private sessionGroupMap: Map<string, SCBSceneContainerSession[]> = new Map();
  private timeoutGroupMap: Map<string, Map<SCBSceneContainerSession, number>> = new Map();
  private afterRemoveCallbackGroupMap: Map<string, Function[]> = new Map();

  private registerTimeout(groupName: string, containerSession: SCBSceneContainerSession, timeoutCallback: Function,
    delay: number = this.defaultDelay): void {
    const timeoutNumber = setTimeout(() => {
      timeoutCallback();
    }, delay);
    const timeoutMap = this.timeoutGroupMap.get(groupName);
    if (timeoutMap) {
      const timeoutNumberFound = timeoutMap.get(containerSession);
      if (timeoutNumberFound) {
        clearTimeout(timeoutNumberFound);
      }
      timeoutMap.set(containerSession, timeoutNumber);
    } else {
      const timeoutMapNew = new Map([[containerSession, timeoutNumber]]);
      this.timeoutGroupMap.set(groupName, timeoutMapNew);
    }
    this.printLog('timeoutGroupMap');
  }

  private unRegisterTimeout(groupName: string, containerSession: SCBSceneContainerSession): void {
    const timeoutMap = this.timeoutGroupMap.get(groupName);
    if (timeoutMap) {
      const timeoutNumberFound = timeoutMap.get(containerSession);
      if (timeoutNumberFound) {
        clearTimeout(timeoutNumberFound);
      }
      timeoutMap.delete(containerSession);
      this.printLog('timeoutGroupMap');
    }
  }

  private triggerRemoveCallbacks(groupName: string, containerSession: SCBSceneContainerSession): void {
    const callbackGroup = this.afterRemoveCallbackGroupMap.get(groupName);
    if (!callbackGroup || callbackGroup.length === 0) {
      return;
    }
    callbackGroup.forEach(callback => {
      callback(containerSession);
    });
  }

  private printLog(type: string): void {
    if (type === 'sessionGroupMap' || type === 'all') {
      let str1 = '';
      this.sessionGroupMap.forEach((containerSessionList, groupName) => {
        const idList = containerSessionList.map((session) => session.containerId);
        str1 += `groupName: ${groupName}, sessionList: ${idList.toString()};`;
      });
      log.showDebug(`printLog sessionGroupMap: ${str1}`);
    }
    if (type === 'timeoutGroupMap' || type === 'all') {
      let str2 = '';
      this.timeoutGroupMap.forEach((containerSessionMap, groupName) => {
        const timeNumList = Array.from(containerSessionMap.values());
        str2 += `groupName: ${groupName}, timeoutNumList: ${timeNumList.toString()};`;
      });
      log.showDebug(`printLog timeoutGroupMap: ${str2}`);
    }
  }

  /**
   * register a callback for session removing
   * @param groupName: a self-defined name for grouping
   * @param callback
   */
  public registerAfterRemoveSession(groupName: string, callback: Function): void {
    if (!groupName) {
      return;
    }
    const callbackGroup = this.afterRemoveCallbackGroupMap.get(groupName);
    if (callbackGroup) {
      if (callbackGroup.indexOf(callback) === -1) {
        callbackGroup.push(callback);
      }
    } else {
      this.afterRemoveCallbackGroupMap.set(groupName, [callback]);
    }
  }

  /**
   * unregister a callback for session removing
   * @param groupName: a self-defined name for grouping
   * @param callback
   */
  public unRegisterAfterRemoveSession(groupName: string, callback: Function): void {
    if (!groupName) {
      return;
    }
    const callbackGroup = this.afterRemoveCallbackGroupMap.get(groupName);
    if (!callbackGroup || callbackGroup.length === 0) {
      return;
    }
    const idx = callbackGroup.indexOf(callback);
    if (idx !== -1) {
      callbackGroup.splice(idx, 1);
    }
  }

  /**
   * remove a session from sessionGroupMap
   * @param groupName: a self-defined name for grouping
   * @param containerSession: session that to be removed
   * @param doRemoveCallbacks: trigger (or not) callback functions that registered before
   */
  public removeSession(groupName: string, containerSession: SCBSceneContainerSession,
    doRemoveCallbacks: boolean = true): void {
    if (!groupName || !containerSession) {
      return;
    }
    const sessionGroup = this.sessionGroupMap.get(groupName);
    if (sessionGroup && sessionGroup.length) {
      const idx = sessionGroup.indexOf(containerSession);
      if (idx === -1) {
        return;
      }
      sessionGroup.splice(idx, 1);
    }
    this.printLog('sessionGroupMap');
    this.unRegisterTimeout(groupName, containerSession);
    if (doRemoveCallbacks) {
      this.triggerRemoveCallbacks(groupName, containerSession);
    }
  }

  /**
   * insert a session into sessionGroupMap
   * @param groupName: a self-defined name for grouping
   * @param containerSession
   */
  public insert(groupName: string, containerSession: SCBSceneContainerSession): void {
    if (!groupName || !containerSession) {
      return;
    }
    const sessionGroup = this.sessionGroupMap.get(groupName);
    let insertSuccess = false;
    if (sessionGroup) {
      const idx = sessionGroup.findIndex((session) => {
        return session.containerId === containerSession.containerId;
      });
      if (idx === -1) {
        sessionGroup.push(containerSession);
        insertSuccess = true;
      }
    } else {
      this.sessionGroupMap.set(groupName, [containerSession]);
      insertSuccess = true;
    }
    if (insertSuccess) {
      this.registerTimeout(groupName, containerSession, () => {
        this.removeSession(groupName, containerSession, true);
      });
    }
    this.printLog('sessionGroupMap');
  }

  /**
   * get a containerSession from sessionGroupMap by sceneSessionPersistentId
   * @param groupName: a self-defined name for grouping
   * @param sceneSessionPersistentId
   * @param removeAfterGet: remove (or not) the session from group after this session is get
   * @param doRemoveCallbacks: if removeAfterGet is true, trigger (or not) the callback functions
   * @returns containerSession
   */
  public getSession(groupName: string, sceneSessionPersistentId: number, removeAfterGet?: boolean,
    doRemoveCallbacks?: boolean): SCBSceneContainerSession | undefined {
    if (!groupName || !sceneSessionPersistentId) {
      return undefined;
    }
    const sessionGroup = this.sessionGroupMap.get(groupName);
    if (!sessionGroup || sessionGroup.length === 0) {
      return undefined;
    }
    const sessionFound: SCBSceneContainerSession | undefined = sessionGroup.find((containerSession) => {
      const hasPrimarySession = containerSession.primarySession?.session.persistentId === sceneSessionPersistentId;
      const hasSecondarySession =
        containerSession.secondarySession?.session.persistentId === sceneSessionPersistentId;
      return hasPrimarySession || hasSecondarySession;
    });
    if (removeAfterGet && sessionFound) {
      this.removeSession(groupName, sessionFound, doRemoveCallbacks);
    }
    return sessionFound;
  }

  /**
   * get a sceneSession from sessionGroupMap by sceneSessionPersistentId
   * @param groupName: a self-defined name for grouping
   * @param sceneSessionPersistentId
   * @returns sceneSession
   */
  public getSceneSession(groupName: string, sceneSessionPersistentId: number): SCBSceneSession | undefined {
    if (!groupName || !sceneSessionPersistentId) {
      return undefined;
    }
    const containerSession = this.getSession(groupName, sceneSessionPersistentId);
    if (!containerSession) {
      return undefined;
    }
    let sceneSession: SCBSceneSession | undefined;
    const primarySession = containerSession.primarySession;
    if (primarySession?.session.persistentId === sceneSessionPersistentId) {
      sceneSession = primarySession;
    }
    const secondarySession = containerSession.secondarySession;
    if (secondarySession?.session.persistentId === sceneSessionPersistentId) {
      sceneSession = secondarySession;
    }
    return sceneSession;
  }
}