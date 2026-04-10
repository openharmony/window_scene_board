/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import {
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSpecificSession,
  SCBRecentSessionInfo
} from '@ohos/windowscene';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { SCBRecentSessionsViewModel } from './SCBRecentSessionsViewModel';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
const TAG = 'SCBRecentCardViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentCardViewModel {
  public static setSceneTranslate(scene: SCBSceneContainerSession | SCBSpecificSession | undefined,
    translateX: number, translateY: number): boolean {
    if (!scene) {
      return false;
    }
    if (scene instanceof SCBSpecificSession) {
      scene.translateX = translateX;
      scene.translateY = translateY;
      return true;
    }
    log.showInfo(`SetSceneTranslate:[${translateX}, ${translateY}],
    primaryPos:${scene.primarySession?.currRect.printPx()},
    secondPos:${scene.secondarySession?.currRect.printPx()}, extra info: ${scene.getName()}`);
    if (scene instanceof SCBSceneContainerSession) {
      scene.primarySession?.setTran(translateX, translateY);
      scene.secondarySession?.setTran(translateX, translateY);
      scene.dividerParam.dividerTranslateX = translateX;
      scene.dividerParam.dividerTranslateY = translateY;
      return true;
    }
    return false;
  }

  public static setSceneScale(scene: SCBSceneContainerSession | SCBSpecificSession | undefined,
    scale: number): boolean {
    if (!scene) {
      return false;
    }
    if (scene instanceof SCBSpecificSession) {
      scene.scaleX = scale;
      scene.scaleY = scale;
      return true;
    }
    if (scene instanceof SCBSceneContainerSession) {
      scene.primarySession?.setScale(scale, scale);
      scene.primarySession?.resetAnimationProperty();
      scene.secondarySession?.setScale(scale, scale);
      scene.secondarySession?.resetAnimationProperty();
      scene.dividerParam.scaleX = scale;
      scene.dividerParam.scaleY = scale;
      return true;
    }
    return false;
  }

  public static setSceneOpacity(scene: SCBSceneContainerSession | SCBSpecificSession | undefined, opacity: number) {
    if (!scene) {
      return;
    }
    if (scene instanceof SCBSpecificSession) {
      scene.opacity = opacity;
      return;
    }
    if (scene.primarySession && scene.primarySession.opacity !== opacity) {
      scene.primarySession.opacity = opacity;
    }
    if (scene.isSplit && scene.secondarySession) {
      if (scene.secondarySession.opacity !== opacity) {
        scene.secondarySession.opacity = opacity;
      }
      if (scene.dividerParam.dividerOpacity !== opacity && !scene.isSplitStyleConversion) {
        scene.dividerParam.dividerOpacity = opacity;
      }
    }
  }

  public static setSceneAttraction(scene: SCBSceneContainerSession | SCBSpecificSession | undefined,
    attractionVal: number) {
    if (scene && scene instanceof SCBSceneContainerSession) {
      if (scene.primarySession !== null && scene.primarySession.attractionVal !== attractionVal) {
        scene.primarySession.attractionVal = attractionVal;
      }
      if (scene.isSplit && scene.secondarySession) {
        if (scene.secondarySession.attractionVal !== attractionVal) {
          scene.secondarySession.attractionVal = attractionVal;
        }
      }
    }
  }

  public static setSplitRecentCardOffSetX(sceneContainerSession: SCBSceneContainerSession, scale: number): void {
    if (!sceneContainerSession || !sceneContainerSession.primarySession || !sceneContainerSession.secondarySession) {
      return;
    }
    const priOffsetX = SCBRecentCardViewModel.getSplitRecentCardOffSetX(sceneContainerSession.primarySession, scale);
    const secOffsetX = SCBRecentCardViewModel.getSplitRecentCardOffSetX(sceneContainerSession.secondarySession, scale);
    if (sceneContainerSession.isSplitPrimaryMode()) {
      sceneContainerSession.primarySession.translateOffsetX = priOffsetX;
      sceneContainerSession.secondarySession.translateOffsetX = priOffsetX * 2 + secOffsetX;
    } else if (sceneContainerSession.isSplitSecondaryMode()) {
      sceneContainerSession.secondarySession.translateOffsetX = secOffsetX;
      sceneContainerSession.primarySession.translateOffsetX = secOffsetX * 2 + priOffsetX;
    }
  }

  public static getSplitRecentCardOffSetX(sceneSession: SCBSceneSession | null, newScale: number): number {
    if (!sceneSession) {
      return 0;
    }
    let offsetX: number = 0;
    let sceneWidth = sceneSession.currRect.width.getVp();
    let scaledWidth = sceneWidth * newScale;
    if (scaledWidth < SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH) {
      offsetX = (SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH - scaledWidth) / 2;
    }
    return offsetX;
  }

  public static getSplitRecentCardOffSetY(sceneSession: SCBSceneSession | null, newScale: number,
    ctx?: SingleContext): number {
    if (!sceneSession) {
      return 0;
    }
    let offsetY: number = 0;
    let sceneHeight = sceneSession.currRect.width.getVp();
    let scaledHeight = sceneHeight * newScale;
    let minSceneHeight = SCBRecentSessionsViewModel.getInstance(ctx).getRecentCardMinHeight();
    if (scaledHeight < minSceneHeight) {
      offsetY = (minSceneHeight - scaledHeight) / 2;
    }
    return offsetY;
  }

  public static getSceneContainerRecentRadius(sceneContainerSession: SCBSceneContainerSession, scale: number,
    ctx?: SingleContext): number {
    if (!sceneContainerSession || !sceneContainerSession.primarySession) {
      return 0;
    }
    let maxHeight = SCBRecentSessionsViewModel.getInstance(ctx).getRecentCardMaxHeight();
    let minHeight = SCBRecentSessionsViewModel.getInstance(ctx).getRecentCardMinHeight();
    let borderRadius =
      (SCBRecentStyleConstants.RECENT_IMAGE_MAX_RADIUS - SCBRecentStyleConstants.RECENT_IMAGE_MIN_RADIUS) /
        (maxHeight - minHeight) * (sceneContainerSession.primarySession?.currRect.height.getVp() * scale - minHeight) +
      SCBRecentStyleConstants.RECENT_IMAGE_MIN_RADIUS;

    borderRadius = Math.max(SCBRecentStyleConstants.RECENT_IMAGE_MIN_RADIUS, borderRadius);
    borderRadius = Math.min(borderRadius, SCBRecentStyleConstants.RECENT_IMAGE_MAX_RADIUS)

    let radius = borderRadius / scale;
    if (sceneContainerSession.isSplit && sceneContainerSession.secondarySession === null) {
      radius = 0;
    }
    return SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius || radius;
  }

  public static setSceneContainerBorderRadius(sceneContainerSession: SCBSceneContainerSession, scale: number,
    ctx?: SingleContext): void {
    if (!sceneContainerSession) {
      return;
    }
    const sceneBorderRadius = SCBRecentCardViewModel.getSceneContainerRecentRadius(sceneContainerSession,
      scale, ctx);
    sceneContainerSession.needRenderRecentSceneBorderRadius.borderRadius = sceneBorderRadius;
  }

  public static getSceneContainerRecentScale(sceneContainerSession: SCBSceneContainerSession,
    heightInRecent: number): number {
    if (!sceneContainerSession) {
      return 1.0;
    }
    const sceneContainerHeight = sceneContainerSession.getSceneContainerHeight();
    if (!sceneContainerHeight || sceneContainerHeight <= heightInRecent) {
      log.showWarn(`getSceneScale:${heightInRecent}/${sceneContainerHeight}, ${sceneContainerSession.getBundleName()}`);
    }
    return heightInRecent / sceneContainerHeight;
  }

  public static setShowInRecent(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'set show in recent',
      sceneContainerSession.getName());
  }

  public static resetShowInRecent(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'reset show in recent',
      sceneContainerSession.getName());
  }

  public static hideSceneShadow(sceneContainerSession: SCBSceneContainerSession): void {
    if (sceneContainerSession.primarySession) {
      sceneContainerSession.primarySession.shadowConfig.radius = 0;
      sceneContainerSession.primarySession.shadowConfig.offsetX = 0;
      sceneContainerSession.primarySession.shadowConfig.offsetY = 0;
    }
  }

  public static showSceneShadow(sceneContainerSession: SCBSceneContainerSession): void {
    if (sceneContainerSession && sceneContainerSession.primarySession) {
      sceneContainerSession.primarySession.setWindowShadowConfig();
    }
  }

  public static hideSceneStroke(sceneContainerSession: SCBSceneContainerSession): void {
    if (sceneContainerSession.primarySession) {
      sceneContainerSession.primarySession.isHideShadow = true;
      sceneContainerSession.primarySession?.resetWindowStrokeConfig();
    }
    if (sceneContainerSession.secondarySession) {
      sceneContainerSession.secondarySession.isHideShadow = true;
      sceneContainerSession.secondarySession.resetWindowStrokeConfig();
    }
  }

  public static showSceneStroke(sceneContainerSession: SCBSceneContainerSession): void {
    if (sceneContainerSession.primarySession) {
      sceneContainerSession.primarySession.isHideShadow = false;
      sceneContainerSession.primarySession.setWindowStrokeConfig();
    }
    if (sceneContainerSession.secondarySession) {
      sceneContainerSession.secondarySession.isHideShadow = false;
      sceneContainerSession.secondarySession.setWindowStrokeConfig();
    }
  }

  public static getSceneContainerWidthPrepareEnterRecent(sceneContainerSession: SCBSceneContainerSession): number {
    if (!sceneContainerSession) {
      return 0;
    }
    let currentScale = Number(sceneContainerSession.primarySession?.scaleX);
    return sceneContainerSession.getSceneContainerWidth() * currentScale;
  }

  /*
   * 1. 三指上滑松手进入多任务，窗口的宽高为缩放宽高；
   */
  public static getSceneContainerHeightPrepareEnterRecent(sceneContainerSession: SCBSceneContainerSession): number {
    if (!sceneContainerSession) {
      return 0;
    }
    let currentScale = Number(sceneContainerSession.primarySession?.scaleY);
    return sceneContainerSession.getSceneContainerHeight() * currentScale;
  }

  public static isRecentCardMinWidth(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): boolean {
    if (!recentSessionInfo) {
      return false;
    }
    let recentSceneWidth = 0;
    const widthScale = SCBRecentCardViewModel.getSceneContainerRecentScale(sceneContainerSession,
      recentSessionInfo.height);
    // 预分屏场景
    if (sceneContainerSession.dividerParam.isSplitRecentPair) {
      return SCBRecentCardViewModel.isSplitPairWindowBackgroundShow(sceneContainerSession, widthScale);
    }
    recentSceneWidth = recentSessionInfo.width;
    return SCBRecentCardViewModel.isLessMinCardWidth(recentSceneWidth);
  }

  /*
  * 预分屏场景二分屏窗口分别判断宽度再加背板
  */
  public static isSplitPairWindowBackgroundShow(sceneContainerSession: SCBSceneContainerSession,
    widthScale: number): boolean {
    let primarySceneWidth = 0;
    let secondarySceneWidth = 0;
    if (sceneContainerSession.primarySession) {
      primarySceneWidth = sceneContainerSession.primarySession.currRect.width.getVp() * widthScale;
    }
    if (sceneContainerSession.secondarySession) {
      secondarySceneWidth = sceneContainerSession.secondarySession.currRect.width.getVp() * widthScale;
    }
    if (SCBRecentCardViewModel.isLessMinCardWidth(primarySceneWidth)) {
      sceneContainerSession.needRenderRecentMinBackgroundShow.primarySessionShow = true;
    }
    if (SCBRecentCardViewModel.isLessMinCardWidth(secondarySceneWidth)) {
      sceneContainerSession.needRenderRecentMinBackgroundShow.secondSessionShow = true;
    }
    return sceneContainerSession.needRenderRecentMinBackgroundShow.primarySessionShow ||
    sceneContainerSession.needRenderRecentMinBackgroundShow.secondSessionShow;
  }

  public static isLessMinCardWidth(sessionWidth: number): boolean {
    // -1 for float numer compare
    return sessionWidth <= SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH - 1;
  }

  public static isRecentCardMinHeight(recentSessionInfo: SCBRecentSessionInfo, screenId: number): boolean {
    if (!recentSessionInfo) {
      return false;
    }
    // -1 for float numer compare
    let minHeight = SCBRecentSessionsViewModel.getInstance({ extendScreenId: screenId }).getRecentCardMinHeight() - 1;
    if (recentSessionInfo.height <= minHeight) {
      return true;
    }
    return false;
  }
}