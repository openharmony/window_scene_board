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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { Logger, LogDomain } from '@ohos/basicutils';
import {
  ACTIVE_STATUS_MAP,
  OccludeKeygaurdScene,
  SCBSceneSessionManager,
  SCBSpecificScenePanelDebugCommands,
  SCBSpecificSceneSessionList,
  SCBSpecificSession
} from '@ohos/windowscene';
import { SCBBaseSpecificScenePanelViewModel } from '@ohos/windowscene/Index';
import { SCBDefaultZIndex, ZORDER_TO_DEFAULTZINDEX } from '../SCBScreen';

const TAG = 'SCBSpecificScenePanelViewModel';
const log = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * ViewModel of SCBSpecificScenePanel View.
 */
export class SCBSpecificScenePanelViewModel extends SCBBaseSpecificScenePanelViewModel {
  public hiddenFloatWindowList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();

  public getZIndex(): number {
    return ZORDER_TO_DEFAULTZINDEX.get(this.zorder) || 0;
  }

  protected onSessionStateChange(persistentId: number, state: sceneSessionManager.SessionState): void {
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      // remove item from hiddenFloatWindowList when the window is destroyed.
      let hiddenIndex = this.hiddenFloatWindowList.findIndex((item) => {
        return item?.session?.persistentId === persistentId;
      });
      if (hiddenIndex !== -1) {
        log.showInfo(TAG, `[SCBSystem]Remove hidden floatWindow When disconnect`);
        this.hiddenFloatWindowList.splice(hiddenIndex, 1);
      }
    }

    const index = this.specificSceneSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index !== -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive == undefined || !this.specificSceneSessionList[index]) {
        return;
      }
      this.specificSceneSessionList[index].isActive = isActive;
      this.updateKeyguardOccludedIfNeed();
      SCBSceneSessionManager.getInstance().updateHomeOccludedState(this.specificSceneSessionList, this.zorder);
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        this.specificSceneSessionList.splice(index, 1);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        return;
      }
      log.showInfo(TAG, `onSubSessionActiveStatueChange persistentId:${persistentId}, isActive:${isActive}` +
        `, length:${this.specificSceneSessionList.length}, state:${state}`);
    }
  }

  private updateKeyguardOccludedIfNeed(): void {
    if (this.getZIndex() < SCBDefaultZIndex.SCREEN_LOCK_BOUNCER) {
      return;
    }
    let isVoiceInteractionActive = false;
    let isWalletInteractionActive = false;
    this.specificSceneSessionList.forEach((item: SCBSpecificSession) => {
      if (!item.isActive) {
        return;
      }
      if (item.session?.type === sceneSessionManager.SessionType.TYPE_VOICE_INTERACTION) {
        isVoiceInteractionActive = true;
      }
      if (item.session?.type === sceneSessionManager.SessionType.TYPE_WALLET_SWIPE_CARD) {
        isWalletInteractionActive = true;
      }
    });

    SCBSceneSessionManager.getInstance()
      .updateKeyguardOccludedState(OccludeKeygaurdScene.SPECIFIC_TYPE_VOICE_INTERACTION, isVoiceInteractionActive);
    SCBSceneSessionManager.getInstance()
      .updateKeyguardOccludedState(OccludeKeygaurdScene.SPECIFIC_TYPE_WALLET_SWIPE_CARD, isWalletInteractionActive);
  }

  protected onParentSessionGoDestroy(sceneSession: sceneSessionManager.SceneSession): void {
    log.showInfo(TAG, `onDestroyFloatWindowFromSceneSession`);
    let index = this.specificSceneSessionList.findIndex((specificSession) => {
      return specificSession.session?.parentId === sceneSession?.persistentId;
    });
    if (index !== -1) {
      this.specificSceneSessionList.splice(index, 1);
    }

    let hiddenIndex = this.hiddenFloatWindowList.findIndex((specificSession) => {
      return specificSession?.session?.parentId === sceneSession?.persistentId;
    });
    if (hiddenIndex !== -1) {
      this.hiddenFloatWindowList.splice(hiddenIndex, 1);
    }
    this.updateKeyguardOccludedIfNeed();
  }

  public pushInSpecificSession(sessionList: SCBSpecificSceneSessionList, fromScreenId: number): void {
    log.showInfo(TAG, `push in specificSceneSession in: ${sessionList?.length} from screen: ${fromScreenId}`);
    if (!sessionList || sessionList.length === 0) {
      return;
    }
    sessionList.forEach((session) => {
      if (!session) {
        log.showError(TAG, 'null session to push in');
        return;
      }
      if (fromScreenId !== this.screenId) {
        session?.updateDisplayIdRecursively(this.screenId, fromScreenId);
      }
      session.updateSessionStateChangeFunc(this.sessionStateChange);
      this.specificSceneSessionList.push(session);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    });
  }
}