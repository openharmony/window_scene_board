/*
 * Copyright (c) 2026 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { StartAndExitUtil, StartAndExitResponse } from "@ohos/launchercommon";
import {
  FloatingScenePortraitStyle,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneSessionManager,
} from "@ohos/windowscene";
import { curves } from "@kit.ArkUI";
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SceneBoardStateManager, CoreEventType } from "@ohos/frameworkwrapper/Index";

const TAG = 'SCBFloatManager';

export class SCBFloatManager {
  /**
   * Get the singleton of the SCBFloatManager.
   */
  static getInstance(): SCBFloatManager {
    if (!globalThis.SCBFloatManagerInstance) {
      globalThis.SCBFloatManagerInstance = new SCBFloatManager();
    }
    return globalThis.SCBFloatManagerInstance;
  }

  private constructor() {
  }

  private updateSubSession(containerSession: SCBSceneContainerSession): void {
    if (containerSession.primarySession instanceof SCBSceneSession) {
      let primarySession: SCBSceneSession = containerSession.primarySession as SCBSceneSession;
      primarySession.subSessionList.forEach((item) => {
        item.notifyParentRectChange(primarySession.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
          primarySession.sceneInfo.screenId);
      });
    }
  }

  public startFloatWithAnimator(floatingSession: SCBSceneContainerSession) {
    const screenProperty = floatingSession.screenProperty;
    SCBScenePanelManager.getInstance(screenProperty)
      .getBackgroundBlurSession()
      .setBgBlurScale(0, 'enterFloatView');
    SCBScenePanelManager.getInstance(screenProperty).raiseSceneToTop(floatingSession);
    floatingSession.requestActivation(true);
    SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.OPEN_APP);
    const baseW = screenProperty.width * FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
    const baseH = baseW / FloatingScenePortraitStyle.ASPECT_RATIO;
    const startPosX = px2vp((screenProperty.width - baseW) / 2);
    const startPosY = px2vp((screenProperty.height - baseH) / 2);
    floatingSession.needRenderClip.setClipWidth(baseW);
    floatingSession.needRenderClip.setClipHeight(baseH);
    floatingSession.needRenderPos.setPosX(startPosX);
    floatingSession.needRenderPos.setPosY(startPosY);
    floatingSession.needRenderAlpha.setNeedRenderAlpha(0);
    floatingSession.needRenderScale.setScaleX(0.1);
    floatingSession.needRenderScale.setScaleY(0.1);
    floatingSession.primarySession?.currRect.setPosNum(startPosX, startPosY);
    floatingSession.primarySession?.currRect.setSizeNum(baseW, baseH);
    this.updateSubSession(floatingSession);

    // 执行动画
    animateTo({
      duration: 400,
      curve: curves.springMotion(StartAndExitUtil.getResponse(StartAndExitResponse.NORMAL_START), 1.157, 0),
      onFinish: () => {
        floatingSession.needRenderScale.centerY = '0%';
        floatingSession.needRenderScale.centerX = '0%';
      }
    }, () => {
      floatingSession.needRenderAlpha.setNeedRenderAlpha(1);
      floatingSession.needRenderScale.setScaleX(1);
      floatingSession.needRenderScale.setScaleY(1);
    });

  }

  public exitFloatWithAnimator(floatingSession: SCBSceneContainerSession) {
    const targetScale: number = 0;
    const targetTranslateX: number =
      floatingSession.needRenderClip.clipWidth.getVp() * (floatingSession.needRenderScale.scaleX - targetScale) / 2;
    const targetTranslateY: number =
      floatingSession.needRenderClip.clipHeight.getVp() * (floatingSession.needRenderScale.scaleX - targetScale) / 2;

    // 执行动画
    animateTo({
      duration: 400,
      curve: Curve.FastOutSlowIn,
      onFinish: () => {
        let sceneSession = floatingSession.primarySession;
        if (sceneSession) {
          SCBSceneSessionManager.getInstance().requestSceneContainerDestruction(sceneSession.sceneInfo.screenId,
            sceneSession.sceneInfo.persistentId);
        }
      }
    }, () => {
      floatingSession.needRenderTranslate.setTranslateX(targetTranslateX);
      floatingSession.needRenderTranslate.setTranslateY(targetTranslateY);
      floatingSession.needRenderScale.setScaleX(targetScale);
      floatingSession.needRenderScale.setScaleY(targetScale);
      floatingSession.needRenderAlpha.setNeedRenderAlpha(0);
    });
  }
}