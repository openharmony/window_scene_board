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
import { LogDomain, Logger } from '@ohos/basicutils';
import { SCBSceneSessionManager, SCBSpecificSceneSessionList } from '../session/SCBSceneSessionManager';
import { InnerScreenStateChangeListener, SCBSceneMissionManager } from './SCBSceneMissionManager';

const TAG = 'SCBSpecificSceneManager';
const log = Logger.getLogHelper(LogDomain.WINDOW);

export interface SCBSpecificScenePanelHandler {
  screenId: number;
  zorder: number;

  getSpecificSceneSessionList(): SCBSpecificSceneSessionList;
  pushInSpecificSession(session: SCBSpecificSceneSessionList, fromScreenId: number): void;
}

export class SCBSpecificSceneManager implements InnerScreenStateChangeListener {
  private static sInstance: SCBSpecificSceneManager;

  // <screenId-zOrder, SCBSpecificScenePanelHandler>>
  private specificPanelMap: Map<string, SCBSpecificScenePanelHandler> = new Map();

  public static getInstance(): SCBSpecificSceneManager {
    if (!SCBSpecificSceneManager.sInstance) {
      SCBSpecificSceneManager.sInstance = new SCBSpecificSceneManager();
    }
    return SCBSpecificSceneManager.sInstance;
  }

  private constructor() {
    SCBSceneMissionManager.getInstance().registerInnerScreenStateChangeListener(this);
  }

  public notifyScreenStateChange(screenId: number, connected: boolean): void {
    log.showInfo(TAG, `[screen:${screenId}] connected state change to ${connected}`);
    if (!connected) {
      this.moveSpecificSceneToMainScreen(screenId);
    }
  }

  public registerSpecificScenePanelHandler(handler: SCBSpecificScenePanelHandler): void {
    log.showInfo(TAG, `[screen:${handler?.screenId}][zorder:${handler?.zorder}] SpecificScenePanel handler registered`);
    if (!handler) {
      return;
    }
    const handlerKey = `${handler.screenId}-${handler.zorder}`;
    this.specificPanelMap.set(handlerKey, handler);
  }

  public unregisterSpecificScenePanelHandler(handler: SCBSpecificScenePanelHandler): void {
    log.showInfo(TAG, `[screen:${handler?.screenId}][zorder:${handler?.zorder}]` +
      ` SpecificScenePanel handler unregistered`);
    if (!handler) {
      return;
    }
    this.moveSpecificSceneToMainScreen(handler.screenId); // move session firstly
    const handlerKey = `${handler.screenId}-${handler.zorder}`;
    this.specificPanelMap.delete(handlerKey); // clear panel map
  }

  private moveSpecificSceneToMainScreen(fromScreenId: number): void {
    let mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    if (fromScreenId === mainScreenId) {
      log.showInfo(TAG, 'main screen disconnect, no need move');
      return;
    }
    this.specificPanelMap.forEach((eachPanel: SCBSpecificScenePanelHandler) => {
      if (!eachPanel || eachPanel.screenId !== fromScreenId) {
        return;
      }
      log.showInfo(TAG, `[screen:${eachPanel.screenId}][zorder:${eachPanel.zorder}]will move sessions to main screen`);
      const specificSceneSessionList = eachPanel.getSpecificSceneSessionList() ?? null;
      if (!specificSceneSessionList || specificSceneSessionList.length === 0) {
        log.showWarn(TAG, 'empty specific scene session list to move');
        return;
      }
      const targetPanelKey = `${mainScreenId}-${eachPanel.zorder}`;
      let targetPanelOnMainScreen = this.specificPanelMap.get(targetPanelKey);
      if (targetPanelOnMainScreen) {
        targetPanelOnMainScreen.pushInSpecificSession(specificSceneSessionList, fromScreenId);
      } else {
        log.showWarn(TAG, 'can not move, fallback to update display id');
        specificSceneSessionList.forEach((item) => {
          item?.updateDisplayIdRecursively(mainScreenId, fromScreenId);
        });
      }
      specificSceneSessionList.length = 0;
    });
  }
}
