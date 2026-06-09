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

import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBSceneSession, SCBSceneSessionManager, SCBScreenProperty, SCBSpecificSession } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { DevSpecificScene } from './DevSpecificScene';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, 'DevScene');
const ACTIVE_STATUS_MAP: Map<sceneSessionManager.SessionState, boolean> = new Map([
  [sceneSessionManager.SessionState.STATE_CONNECT, false],
  [sceneSessionManager.SessionState.STATE_FOREGROUND, true],
  [sceneSessionManager.SessionState.STATE_ACTIVE, true],
  [sceneSessionManager.SessionState.STATE_INACTIVE, false],
  [sceneSessionManager.SessionState.STATE_BACKGROUND, false],
  [sceneSessionManager.SessionState.STATE_DISCONNECT, false]
]);
const SCENE_INDEX = 800;


@Component
export struct DevScene {
  @ObjectLink sceneSession: SCBSceneSession | undefined;
  @ObjectLink scbScreenProperty: SCBScreenProperty;
  @State @Watch('onChange') subSessionList: SCBSpecificSession[] = [];
  @State count: number = 1;

  private onChange(): void {
    if (this.sceneSession) {
      log.showInfo(`onChange`);
      this.sceneSession.subSessionList = [];
      this.sceneSession.subSessionList.push(...this.subSessionList);
    }
  }

  private subSessionStateChange = (parentId: number,
    persistentId: number, state: sceneSessionManager.SessionState): void => {
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

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    if (!this.sceneSession) {
      return;
    }
    if (this.sceneSession.subSessionList?.length > 0) {
      this.subSessionList.push(...this.sceneSession.subSessionList);
    }
    // 创建子窗
    this.sceneSession?.registerCreateSubSessionCallback(this.createSubSession);
  }

  private createSubSession = (sceneSession: SCBSceneSession, specificSession: sceneSessionManager.SceneSession) => {
    // 创建子窗口的绑定屏幕id默认为主屏id，需要修改
    if (this.sceneSession) {
      this.sceneSession.subSessionList = [];
    }
    let screenId = this.scbScreenProperty.screenId;
    SCBSceneSessionManager.getInstance().updateSessionDisplayId(specificSession.persistentId, screenId);
    if (this.sceneSession?.session?.persistentId === specificSession?.parentId) {
      const indexInAll = this.subSessionList.findIndex(item => {
        return item.session.persistentId === specificSession.persistentId;
      });
      if (indexInAll === -1) {
        let hwSceneSession = new SCBSpecificSession(specificSession, this.subSessionStateChange,
          this.subSessionRaiseToTop, this.subSessionRaiseAboveTarget);
        this.subSessionList.push(hwSceneSession);
        log.showInfo(`create subSession, id: ${specificSession.persistentId} parentId: ${specificSession.parentId}`);
        let persistentIds = [specificSession.persistentId]
        let zOrder = SCENE_INDEX;
        log.showInfo('refreshPcZOrder:' + zOrder);
        SCBSceneSessionManager.getInstance().refreshPcZOrder(zOrder, persistentIds);
      } else {
        log.showInfo(`already in subList, id: ${specificSession.persistentId} index: ${indexInAll}`);
      }
    }
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
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.sceneSession?.unRegisterAll();
  }

  build() {
    Stack() {
      WindowScene(this.sceneSession?.session.persistentId)
        .size({
          width: StyleConstants.PERCENTAGE_100,
          height: StyleConstants.PERCENTAGE_100,
        })
        .id(`session${this.sceneSession?.session.persistentId}`)
        .visibility(this.sceneSession?.visibility ? Visibility.Visible : Visibility.Hidden)
        .focusable(this.sceneSession && this.sceneSession.isFocusable || false)
        .hitTestBehavior(this.sceneSession?.isTouchable ? HitTestMode.Default : HitTestMode.None)
        .clip(this.sceneSession && this.sceneSession?.floatBorderRadius > 0 ? true : false)

      if (this.subSessionList.length > 0 ) {
        ForEach(this.subSessionList, (item: SCBSpecificSession) => {
          if (item !== null) {
            DevSpecificScene({
              specificSession: item,
              scbScreenProperty: this.scbScreenProperty
            })
          }
        }, (item: SCBSpecificSession) => item.session.persistentId.toString())
      }
    }
    .size({
      width: StyleConstants.PERCENTAGE_100,
      height: StyleConstants.PERCENTAGE_100
    })
    .translate({ x: this.sceneSession?.translateX })
    .position({ x: 0, y: 0 })
    .hitTestBehavior(HitTestMode.None)
  }
}
