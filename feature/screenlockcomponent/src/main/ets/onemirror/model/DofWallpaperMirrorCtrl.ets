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
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { slStateHelper } from '../../screenlockstate/model/helper/SlStateHelper';
import { MirrorAnimState, MirrorsScene } from '../constants/MirrorToEndConst';
import IComponentMirrorCtrl from './IComponentMirrorCtrl';
import { SlDofWallpaperBindState } from '../../screenlockstate/model/data/SlDofWallpaperBindState';

const TAG = 'DofWallpaperMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const LIGHT_UP_EFFECT = 0.32;
const AOD_SCALE = 1.015;
const AOD_ALPHA = 0;
const SL_ALPHA = 1;
const SL_SCALE = 1;
const SL_LIGHT = 0.98;
const SPLIT_CHAR = ',';

/**
 * 景深壁纸一镜到底动效管理器
 */
export class DofWallpaperMirrorCtrl implements IComponentMirrorCtrl {
  // 景深壁纸动效状态管理
  private dofAnimCtrl: WidgetAnimState | undefined = slStateHelper.getDofWallpaperAnimState();
  // 景深壁纸UI状态管理
  private dofUiBindCtrl: SlDofWallpaperBindState | undefined = slStateHelper.getDofWallpaperBindState();

  public setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD) {
      this.dofUiBindCtrl?.setLayoutOpacity(AOD_ALPHA);
      this.dofUiBindCtrl?.setLight(LIGHT_UP_EFFECT);
      this.dofUiBindCtrl?.setLayoutScale(SL_SCALE);
      return;
    }

    if (scene === MirrorsScene.SL_TO_AOD || scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.dofUiBindCtrl?.setLayoutOpacity(AOD_ALPHA);
      this.dofUiBindCtrl?.setLight(LIGHT_UP_EFFECT);
      this.dofUiBindCtrl?.setLayoutScale(AOD_SCALE);
    } else {
      this.dofUiBindCtrl?.setLayoutOpacity(SL_ALPHA);
      this.dofUiBindCtrl?.setLight(SL_LIGHT);
      this.dofUiBindCtrl?.setLayoutScale(SL_SCALE);
    }
  }

  public setAnimState(scene: string): void {
    log.showInfo(`setAnimState state=${scene}`)
    if (scene === MirrorsScene.DESKTOP_TO_AOD) {
      this.dofAnimCtrl?.setAlpha(AOD_ALPHA);
      this.dofAnimCtrl?.setScaleX(SL_SCALE);
      this.dofAnimCtrl?.setScaleY(SL_SCALE);
      this.dofAnimCtrl?.setLightUpEffect(LIGHT_UP_EFFECT);
      return;
    }

    if (scene === MirrorsScene.SL_TO_AOD || scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.dofAnimCtrl?.setAlpha(AOD_ALPHA);
      this.dofAnimCtrl?.setScaleX(AOD_SCALE);
      this.dofAnimCtrl?.setScaleY(AOD_SCALE);
      this.dofAnimCtrl?.setLightUpEffect(LIGHT_UP_EFFECT);
      return;
    }

    this.dofAnimCtrl?.setAlpha(SL_ALPHA);
    this.dofAnimCtrl?.setScaleX(SL_SCALE);
    this.dofAnimCtrl?.setScaleY(SL_SCALE);
    this.dofAnimCtrl?.setLightUpEffect(SL_LIGHT);
  }

  setPartAodUiBindState(scene: string): void {
    log.showInfo(`setPartAodUiBindState: ${scene}`);
    if (scene === MirrorsScene.SL_TO_AOD || scene === MirrorsScene.DESKTOP_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL ||
      scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.dofUiBindCtrl?.setLayoutOpacity(AOD_ALPHA);
      this.dofUiBindCtrl?.setLayoutScale(SL_SCALE);
      this.dofUiBindCtrl?.setLight(SL_LIGHT);
      return;
    }
    this.dofUiBindCtrl?.setLayoutOpacity(SL_ALPHA);
    this.dofUiBindCtrl?.setLayoutScale(SL_SCALE);
    this.dofUiBindCtrl?.setLight(SL_LIGHT);
  }

  setPartAodAnimState(scene: string): void {
    log.showInfo(`setPartAodAnimState: ${scene}`);
    if (scene === MirrorsScene.SL_TO_AOD || scene === MirrorsScene.DESKTOP_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL ||
      scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.dofAnimCtrl?.setScaleX(SL_SCALE);
      this.dofAnimCtrl?.setScaleY(SL_SCALE);
      this.dofAnimCtrl?.setAlpha(AOD_ALPHA);
      this.dofAnimCtrl?.setLightUpEffect(SL_LIGHT);
      return;
    }
    this.dofAnimCtrl?.setScaleX(SL_ALPHA);
    this.dofAnimCtrl?.setScaleY(SL_SCALE);
    this.dofAnimCtrl?.setAlpha(SL_SCALE);
    this.dofAnimCtrl?.setLightUpEffect(SL_LIGHT);
  }

  public startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
    if (isStart) {
      this.clearAnimating();
    }

    this.dofAnimCtrl?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: true });
  }

  public clearAnimating(): void {
    let scenes = this.dofAnimCtrl?.getSceneValues();
    log.showInfo(`now clear all anim scenes, ${scenes}`)
    scenes?.split(SPLIT_CHAR).forEach((scene) => {
      this.dofAnimCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
    })
  }

  public isSceneAnimating(scene: string): boolean {
    return this.dofAnimCtrl?.isSceneAnimating(scene) ?? false;
  }
}