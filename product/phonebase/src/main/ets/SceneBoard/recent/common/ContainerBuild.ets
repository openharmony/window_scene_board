/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogHelper, LogDomain, AnimateToScheduleUtils, } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  PreBuildStage,
  SCBScenePanelManager
} from '@ohos/windowscene';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { RecentLayoutManager } from './RecentLayoutManager';

const TAG = 'ContainerBuild';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class ContainerBuilderConfig {
  public _position?: Position;
  public _translate?: TranslateOptions;
  public _scale?: ScaleOptions;
  public _borderRadius?: number;
  public _alpha?: number;
  private _visibility?: boolean;

  public default(): ContainerBuilderConfig {
    this._position = { x: 0, y: 0 };
    this._translate = { x: 0, y: 0, z: 0 };
    this._scale = { x: 0, y: 0 };
    this._borderRadius = 0;
    this._alpha = 0;
    this._visibility = true;
    return this;
  }

  public get position(): Position | undefined {
    return this._position;
  }

  public get translate(): TranslateOptions | undefined {
    return this._translate;
  }

  public get scale(): ScaleOptions | undefined {
    return this._scale;
  }

  public get borderRadius(): number | undefined {
    return this._borderRadius;
  }

  public get alpha(): number | undefined {
    return this._alpha
  }

  public get visibility(): boolean | undefined {
    return this._visibility;
  }

  public setVisibility(value: boolean): ContainerBuilderConfig {
    this._visibility = value;
    return this;
  }

  public resetVisibility(): ContainerBuilderConfig {
    this._visibility = undefined;
    return this;
  }

  public setPosition(pos: Position): ContainerBuilderConfig {
    this._position = pos;
    return this;
  }

  public resetPosition(pos: Position): ContainerBuilderConfig {
    this._position = undefined;
    return this;
  }

  public setTranslate(translate: TranslateOptions): ContainerBuilderConfig {
    this._translate = translate;
    return this;
  }

  public resetTranslate(): ContainerBuilderConfig {
    this._translate = undefined;
    return this;
  }

  public setScale(scale: ScaleOptions): ContainerBuilderConfig {
    this._scale = scale;
    return this;
  }

  public resetScale(scale: ScaleOptions): ContainerBuilderConfig {
    this._scale = undefined;
    return this;
  }

  public setBorderRadius(borderRadius: number): ContainerBuilderConfig {
    this._borderRadius = borderRadius;
    return this;
  }

  public resetBorderRadius(borderRadius: number): ContainerBuilderConfig {
    this._borderRadius = undefined;
    return this;
  }

  public setAlpha(alpha: number): ContainerBuilderConfig {
    this._alpha = alpha;
    return this;
  }

  public resetAlpha(alpha: number): ContainerBuilderConfig {
    this._alpha = undefined;
    return this;
  }
}

export class ContainerBuilder {
  public static tryPreBuildContainer(containerSession: SCBSceneContainerSession, config: ContainerBuilderConfig,
    isScrollFollowing?: boolean): void {
    switch (containerSession.needPreBuild.preBuildStage) {
      case PreBuildStage.NOT_PRE_BUILD:
        ContainerBuilder.preBuildTitle(containerSession, isScrollFollowing);
        break;
      case PreBuildStage.PRE_BUILD_TITLE:
        ContainerBuilder.preBuildScene(containerSession, config, false);
        break;
      case PreBuildStage.PRE_BUILD_SCENE:
        ContainerBuilder.preBuildScene2(containerSession, config, false);
        break;
      default:
        break;
    }
  }

  public static tryBuildContainer(containerSession: SCBSceneContainerSession, config: ContainerBuilderConfig): void {
    if (!containerSession) {
      return;
    }
    ContainerBuilder.buildTitle(containerSession);
    ContainerBuilder.buildScene(containerSession, config);
  }

  public static tryDestroyContainer(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    ContainerBuilder.destroyScene(containerSession);
    ContainerBuilder.destroyTitle(containerSession);
  }

  private static preBuildTitle(containerSession: SCBSceneContainerSession, needRaiseSchedule: boolean = false): void {
    if (!containerSession) {
      return;
    }
    if (containerSession.needPreBuild.preBuildStage >= PreBuildStage.PRE_BUILD_TITLE) {
      log.showWarn(`container session ${containerSession.getName()} \
      preBuildStage ${containerSession.needPreBuild.preBuildStage}, no need preBuild title.`);
      return;
    }
    if (needRaiseSchedule) {
      AnimateToScheduleUtils.raiseBuildSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      AnimateToScheduleUtils.raiseRecentBuildSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    }
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(true);
    containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1.0);
    containerSession.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_TITLE);
  }

  public static buildTitle(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    if (containerSession.needPreBuild.preBuildStage >= PreBuildStage.PRE_BUILD_TITLE) {
      log.showWarn(`container session ${containerSession.getName()} \
      preBuildStage ${containerSession.needPreBuild.preBuildStage}, no need preBuild title.`);
      return;
    }
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(true);
    ContainerBuilder.showTitle(containerSession);
    containerSession.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_TITLE);
  }

  public static showTitle(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1.0);
  }

  public static destroyTitle(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    ContainerBuilder.hideTitle(containerSession);
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    containerSession.needPreBuild.setPreBuildStageWithDfx(PreBuildStage.NOT_PRE_BUILD);
  }

  public static hideTitle(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
  }

  private static preBuildScene(containerSession: SCBSceneContainerSession,
    config: ContainerBuilderConfig, needRaiseSchedule: boolean = false): void {
    if (!containerSession) {
      return;
    }
    if (containerSession.needPreBuild.preBuildStage >= PreBuildStage.PRE_BUILD_SCENE) {
      log.showWarn(`container session ${containerSession.getName()} \
      preBuildStage ${containerSession.needPreBuild.preBuildStage}, no need preBuild scene.`);
      return;
    }
    if (needRaiseSchedule) {
      AnimateToScheduleUtils.raiseBuildSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      AnimateToScheduleUtils.raiseRecentBuildSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    }
    // pre set property for container session
    if (!recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      if (config.position) {
        containerSession.needRenderPos.setPosX(config.position.x as number);
      }
      if (config.translate) {
        containerSession.needRenderTranslate.setTranslateX(config.translate.x as number);
        containerSession.needRenderTranslate.setTranslateY(config.translate.y as number);
      }
      if (config.borderRadius !== undefined) {
        containerSession.needRenderBorderRadius.setBorderRadius(config.borderRadius);
      }
    }
    if (config.scale) {
      let recentScale = config.scale.x;
      if (containerSession.isFloat) {
        let recentCardWidth = RecentLayoutManager.getCardWidth(SCBScenePanelManager.getInstance().getScreenProperty());
        recentScale = recentCardWidth / containerSession.width.getVp();
      }
      containerSession.needRenderScale.setScaleX(recentScale);
      containerSession.needRenderScale.setScaleY(recentScale);
    }
    containerSession.needRenderVisibility.setVisibility(true);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'preBuildScene');

    containerSession.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE);
    // be sure to pre build title
    ContainerBuilder.preBuildTitle(containerSession, needRaiseSchedule);
  }

  public static buildScene(containerSession: SCBSceneContainerSession, config: ContainerBuilderConfig): void {
    if (!containerSession) {
      return;
    }
    if (containerSession.needRenderShowInRecent.showInRecent && containerSession.needRenderScale.scaleX ===
      config.scale?.x) {
      log.showWarn(`container session ${containerSession.getName()} is already show in rencet, no need build scene.`);
      return;
    }
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'buildScene');
    if (!recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      if (config.position) {
        containerSession.needRenderPos.setPosX(config.position.x as number);
        containerSession.needRenderPos.setPosY(config.position.y as number);
      }
      if (config.translate) {
        containerSession.needRenderTranslate.setTranslateX(config.translate.x as number);
        containerSession.needRenderTranslate.setTranslateY(config.translate.y as number);
      }
      if (config.borderRadius !== undefined) {
        containerSession.needRenderBorderRadius.setBorderRadius(config.borderRadius);
      }
    }
    if (config.scale) {
      let recentScale = config.scale.x;
      if (containerSession.isFloat) {
        let recentCardWidth = RecentLayoutManager.getCardWidth(SCBScenePanelManager.getInstance().getScreenProperty());
        recentScale = recentCardWidth / containerSession.width.getVp();
      }
      containerSession.needRenderScale.setScaleX(recentScale);
      containerSession.needRenderScale.setScaleY(recentScale);
    }
    if (config.visibility !== undefined) {
      containerSession.needRenderVisibility.setVisibility(config.visibility);
    }
    if (config.alpha !== undefined) {
      containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(config.alpha, TAG, 'buildScene');
    }
    if (!containerSession.isActive) {
      containerSession.setShowRecent();
    }
    containerSession.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_DONE);
  }

  public static destroyScene(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    if (!containerSession.needRenderShowInRecent.showInRecent) {
      return;
    }
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'destroyScene');
    ContainerBuilder.restoreScene(containerSession);
    containerSession.needPreBuild.setPreBuildStageWithDfx(PreBuildStage.PRE_BUILD_TITLE);
  }

  public static restoreScene(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    containerSession.needRenderPos.setPosX(0);
    containerSession.needRenderPos.setPosY(0);
    containerSession.needRenderTranslate.setTranslateX(0);
    containerSession.needRenderTranslate.setTranslateY(0);
    containerSession.needRenderBorderRadius.setBorderRadius(0);
    containerSession.needRenderScale.setScaleX(0);
    containerSession.needRenderScale.setScaleY(0);
    containerSession.needRenderVisibility.setVisibility(false);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'restoreScene');
  }

  private static preBuildScene2(containerSession: SCBSceneContainerSession,
    config: ContainerBuilderConfig, needRaiseSchedule: boolean = false): void {
    if (!containerSession) {
      return;
    }
    if (containerSession.needPreBuild.preBuildStage >= PreBuildStage.PRE_BUILD_SCENE2) {
      log.showWarn(`container session ${containerSession.getName()} \
      preBuildStage ${containerSession.needPreBuild.preBuildStage}, no need preBuild scene2.`);
      return;
    }
    // containerSession.needPreBuild.preBuildStage will set to PRE_BUILD_DONE when showInRecent is set to true
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'preBuildScene2');
    if (!containerSession.isActive) {
      containerSession.setShowRecent();
      log.showWarn(`${containerSession.getName()} is show, posX ${config.position?.x}`);
    }
    containerSession.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_DONE);
    AnimateToScheduleUtils.raiseRecentBuildSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    // be sure to pre build scene
    ContainerBuilder.preBuildScene(containerSession, config, needRaiseSchedule);
  }

  public static resetAllContainerPreBuildStage(containerSessionList: SCBSceneContainerSessionArray) {
    if (!containerSessionList) {
      return;
    }
    containerSessionList?.forEach((containerSession) => {
      if (!containerSession.needRenderShowInRecent.showInRecent) {
        containerSession.needPreBuild.setPreBuildStageWithDfx(PreBuildStage.NOT_PRE_BUILD);
      }
    });
  }
}
