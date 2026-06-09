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
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  Trace,
} from '@ohos/basicutils';
import {
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSessionRect,
} from '@ohos/windowscene';

const TAG = 'SceneAnimationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SceneAnimationManager {
  constructor() {
  }

  /**
   * init scene animation params, default scale center is ('50%', '50%')
   *
   * @param sceneSession scene session
   * @param destRect destination rectangle
   */
  public initAnimatePara(sceneSession: SCBSceneSession, destRect: SCBSessionRect) {
    const sessionLeft = sceneSession.currRect.left.getPx();
    const sessionTop = sceneSession.currRect.top.getPx();
    const sessionWidth = sceneSession.currRect.width.getPx();
    const sessionHeight = sceneSession.currRect.height.getPx();
    const destLeft = destRect.left.getPx();
    const destTop = destRect.top.getPx();
    const destWidth = destRect.width.getPx();
    const destHeight = destRect.height.getPx();
    const currentLeft = sessionLeft + 0.5 * (1 - sceneSession.scaleX) * sessionWidth + vp2px(sceneSession.translateX);
    const currentTop = sessionTop + 0.5 * (1 - sceneSession.scaleY) * sessionHeight + vp2px(sceneSession.translateY);
    const currentWidth = sessionWidth * sceneSession.scaleX;
    const currentHeight = sessionHeight * sceneSession.scaleY;
    sceneSession.scaleX = currentWidth / destRect.width.getPx();
    sceneSession.scaleY = currentHeight / destRect.height.getPx();
    sceneSession.translateX = px2vp(currentLeft - (destLeft + 0.5 * (destWidth - currentWidth)));
    sceneSession.translateY = px2vp(currentTop - (destTop + 0.5 * (destHeight - currentHeight)));
    sceneSession.currRect.copyFrom(destRect);
  }

  /**
   * get session snapshot
   *
   * @param sceneSession scene session
   */
  public getSessionAnimSnapshot(sceneSession: SCBSceneSession): void {
    log.showInfo('getAnimSnapshot start persistentId:%{public}s' + sceneSession.sceneInfo.persistentId.toString());
    Trace.start('getSessionSnapshotWithId:' + sceneSession.sceneInfo.persistentId.toString());
    sceneSession.needRenderSnapShotAnimConfig.animSnapshot =
      SCBSceneSessionManager.getInstance().getSessionSnapshotPixelMapSync(sceneSession.sceneInfo.persistentId, 1);
    Trace.end('getSessionSnapshotWithId:' + sceneSession.sceneInfo.persistentId.toString());
    log.showInfo('getAnimSnapshot end persistentId:%{public}s' + sceneSession.sceneInfo.persistentId.toString());
  }

  /**
   * get session snapshot with freeze.
   *
   * @param sceneSession scene session
   * @param isFreeze
   */
  public setFreezeImmediately(sceneSession: SCBSceneSession, isFreeze: boolean = false): void {
    const id = sceneSession.sceneInfo.persistentId.toString();
    log.showInfo('setFreezeImmediately start persistentId:%{public}s' + id);
    Trace.start('setFreezeImmediately:' + id + '_' + isFreeze);
    const blurRadius: number = sceneSession.sessionData.isPrivacyWindow ? 20 : -1;
    if (isFreeze) {
      sceneSession.needRenderSnapShotAnimConfig.animSnapshot =
        sceneSession.setFreezeImmediately(1, isFreeze, blurRadius);
    } else {
      sceneSession.setFreezeImmediately(1, isFreeze, blurRadius);
    }
    Trace.end('setFreezeImmediately:' + id + '_' + isFreeze);
    log.showInfo('setFreezeImmediately end persistentId:%{public}s' + id);
  }

}

export const sceneAnimationManager = SingletonHelper.getInstance(SceneAnimationManager, TAG);