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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ACTIVE_STATUS_MAP,
  SCBSceneInfo, SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSpecificSceneSessionList,
  SCBSpecificSession} from '@ohos/windowscene/src/main/ets/TsIndex';
import { GlassStatusManager } from '../../common/manager/GlassStatusManager';
import { VisionGlassResourceManager } from '../../IdlVisionGlassExtService/VisionGlassResourceManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { GlassSpecificScene } from '../../dialog/components/GlassSpecificScene';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassScene');

@Component
export struct GlassScene {
  @ObjectLink sceneSession: SCBSceneSession;
  @State @Watch('onChange') subSessionList: SCBSpecificSession[] = [];
  @Link screenProperty: SCBScreenProperty;
  @Consume screenId: number;

  private updateWant(sceneInfo: SCBSceneInfo): void {
    let want = sceneInfo.want;
    if (CheckEmptyUtils.isEmpty(want)) {
      sceneInfo.want = {
        bundleName: sceneInfo.bundleName,
        abilityName: sceneInfo.abilityName,
        moduleName: sceneInfo.moduleName,
        parameters: {}
      };
    } else {
      sceneInfo.want.parameters = {
        persistentId: this.sceneSession.sceneInfo.persistentId
      };
    }
  }

  private onChange(): void {
    this.sceneSession.subSessionList = [];
    this.sceneSession.subSessionList.push(...this.subSessionList);
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
    const isActive = ACTIVE_STATUS_MAP.get(state);
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

  private createSubSession = (sceneSession: SCBSceneSession, specificSession: sceneSessionManager.SceneSession) => {
    // 创建子窗口的绑定屏幕id默认为主屏id，需要修改
    SCBSceneSessionManager.getInstance().updateSessionDisplayId(specificSession.persistentId, this.screenId);
    if (this.sceneSession.session?.persistentId === specificSession?.parentId) {
      const indexInAll = this.subSessionList.findIndex(item => {
        return item.session.persistentId === specificSession.persistentId;
      });
      if (indexInAll === -1) {
        let hwSceneSession = new SCBSpecificSession(specificSession, this.subSessionStateChange,
          this.subSessionRaiseToTop, this.subSessionRaiseAboveTarget);
        this.subSessionList.push(hwSceneSession);
        log.showInfo(`create subSession, id: ${specificSession.persistentId} parentId: ${specificSession.parentId}`);
      } else {
        log.showInfo(`already in subList, id: ${specificSession.persistentId} index: ${indexInAll}`);
      }
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.updateWant(this.sceneSession.sceneInfo);
    VisionGlassResourceManager.getInstance().sendActiveWant(JSON.stringify(this.sceneSession.sceneInfo.want));
    log.showDebug(`GlassScene sendActiveWant: ${JSON.stringify(this.sceneSession.sceneInfo.want)}`);
    if (this.sceneSession.subSessionList.length > 0) {
      this.subSessionList.push(...this.sceneSession.subSessionList);
    }
    this.sceneSession.registerCreateSubSessionCallback(this.createSubSession);
  }

  aboutToDisappear(): void {
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      WindowScene(this.sceneSession.session.persistentId) {
        if (this.subSessionList.length > 0) {
          ForEach(this.subSessionList, (item: SCBSpecificSession) => {
            GlassSpecificScene({ specificSession: item })
          }, (item: SCBSpecificSession) => item.session.persistentId.toString())
        }
      }
        .width(this.sceneSession.width.getPx() === 0 ? '100%' : this.sceneSession.width.getPxStr())
        .height(this.sceneSession.height.getPx() === 0 ? '100%' : this.sceneSession.height.getPxStr())
        .position({
          x: this.sceneSession.positionX.getPxStr(),
          y: this.sceneSession.positionY.getPxStr()
        })
        .id(`session${this.sceneSession.session.persistentId}`)
        .focusable(this.sceneSession.isFocusable)
        .hitTestBehavior(this.sceneSession.isTouchable ? HitTestMode.Default : HitTestMode.None)
        .clip(true)
        .foregroundBlurStyle(BlurStyle.NONE)
    }
  }
}
