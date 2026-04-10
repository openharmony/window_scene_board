/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  LogHelper,
  LogDomain,
} from '@ohos/basicutils';
import {
  SCBRecentSessionInfo,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray
} from '@ohos/windowscene';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';

const TAG = 'SCBRecentDelete';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentDelete {
  public static restoreMoveUpAnimateImmediately(session: SCBSceneContainerSession): void {
    SCBRecentDelete.restoreMoveUpAnimate(session, 0);
  }

  public static restoreMoveUpAnimateNormally(session: SCBSceneContainerSession): void {
    SCBRecentDelete.restoreMoveUpAnimate(session, 200);
  }

  public static restoreScaleCenter(containerSession: SCBSceneContainerSession): void {
    // restore zIndex only when the container no rotate any more
    if (containerSession.needRenderBlurRadius.blurRadius > 0) {
      return;
    }
    containerSession.needRenderRecentDeleteScale.centerX = '50%';
    containerSession.needRenderRecentDeleteScale.centerY = '50%';
    log.showInfo(`restore center: ${containerSession.needRenderRecentDeleteScale.centerX}, \
      ${containerSession.needRenderRecentDeleteScale.centerY}`);
  }

  public static restoreMoveUpAnimate(session: SCBSceneContainerSession, duration: number = 200): void {
    if (session.needRenderBlurRadius.blurRadius <= 0) {
      return;
    }
    animateTo({
      duration: duration,
      curve: Curve.Friction,
      onFinish: () => {
        SCBRecentDelete.restoreScaleCenter(session);
      }
    }, () => {
      session.needRenderBlurRadius.reset();
      session.needRenderRecentDeleteScale.scaleX = 1;
      session.needRenderRecentDeleteScale.scaleY = 1;
    })
  }

  public static restoreMoveUpNoAnimate(session: SCBSceneContainerSession): void {
    if (session.needRenderBlurRadius.blurRadius <= 0) {
      return;
    }
    session.needRenderBlurRadius.reset();
    session.needRenderRecentDeleteScale.scaleX = 1;
    session.needRenderRecentDeleteScale.scaleY = 1;
    SCBRecentDelete.restoreScaleCenter(session);
  }

  public static restoreRecentCloseScene(containerSession: SCBSceneContainerSession | null): void {
    if (!containerSession) {
      return;
    }
    SCBRecentDelete.restoreMoveUpNoAnimate(containerSession);
    containerSession.needRenderBackgroundAlpha.backgroundAlpha = 1;
    containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1);
  }

  public static restoreAllSessionMoveUpAnimate(containerSessionList: SCBSceneContainerSessionArray,
    recentSessionInfo: SCBRecentSessionInfo[]): void {
    containerSessionList.forEach((item) => {
      const recentSession = recentSessionInfo.find(
        (element) => element.sessionId == item.primarySession?.session.persistentId);
      if (recentSession) {
        SCBRecentDelete.restoreMoveUpAnimateNormally(item);
      }
    });
  }

  public static getScaleWhenDelete(blurRadius: number): number {
    blurRadius = Math.max(0, blurRadius);
    return 1 - Math.min(0.5, 0.5 * (blurRadius / SCBRecentStyleConstants.RECENT_DELETE_BLUR_RADIUS));
  }

  public static getAlphaWhenDelete(blurRadius: number): number {
    if (blurRadius >= SCBRecentStyleConstants.RECENT_DELETE_BLUR_RADIUS) {
      return 0;
    }
    if (blurRadius <= 0) {
      return 1;
    }
    return 1 - blurRadius / SCBRecentStyleConstants.RECENT_DELETE_BLUR_RADIUS;
  }

  public static getBlurRadiusWhenDelete(offsetY: number, recentScale: number): number {
    // 15vp / blurRadius
    // recent card is smaller, blurRadius is bigger
    if (recentScale <= 0) {
      log.showWarn(`getBlurRadiusWhenDelete, ${recentScale} is exception`);
      return 0;
    }
    let blurRadius = -offsetY / (SCBRecentStyleConstants.RECENT_DELETE_DISTANCE_BLUR_RATE * recentScale);
    blurRadius = Math.min(blurRadius, SCBRecentStyleConstants.RECENT_DELETE_BLUR_RADIUS);
    return Math.max(0, blurRadius);
  }

  public static setScaleCenter(containerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo[], isGestureAni: boolean): void {
    let centerX = SCBRecentDelete.getCenterXWhenDelete(containerSession, recentSessionInfo);
    let centerY = SCBRecentDelete.getCenterYWhenDelete(containerSession, recentSessionInfo, isGestureAni);
    containerSession.needRenderRecentDeleteScale.centerX = centerX;
    containerSession.needRenderRecentDeleteScale.centerY = centerY;
    log.showInfo(`set center: ${centerX}, ${centerY}, ${isGestureAni}`);
  }

  public static isGestureDelete(containerSession: SCBSceneContainerSession): boolean {
    log.showInfo(`isGestureDelete:${containerSession.needRenderBlurRadius.blurRadius}`);
    return containerSession.needRenderBlurRadius.blurRadius > 0;
  }

  public static getCenterYWhenDelete(containerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo[], isGestureAni: boolean): number | string {
    if (!containerSession) {
      log.showError('Error containerSession');
      return '50%';
    }
    let recentSession = recentSessionInfo.find((element) =>
    element.sessionId === containerSession.primarySession?.session.persistentId);
    if (!recentSession) {
      return '50%';
    }
    return (recentSession?.top as number) + (isGestureAni ? 0 : recentSession.height / 2);
  }

  public static getCenterXWhenDelete(containerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo[]): number | string {
    if (!containerSession) {
      return '50%';
    }
    let recentSession = recentSessionInfo.find((element) =>
    element.sessionId === containerSession.primarySession?.session.persistentId);
    if (!recentSession) {
      return '50%';
    }
    return (recentSession?.left as number) + (recentSession?.width as number) / 2;
  }
}
