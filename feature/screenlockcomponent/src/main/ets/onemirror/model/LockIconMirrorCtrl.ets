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
import { WBaseProperty } from '@ohos/screenlockcommon';

import { slStateHelper } from '../../common/helper/SlStateHelper';
import { SlLockIconBindState } from '../../password/viewmodel/SlLockIconBindState';
import { MirrorAnimState, MirrorsScene } from '../constants/MirrorToEndConst';
import IComponentMirrorCtrl from './IComponentMirrorCtrl';

const TAG = 'LockIconMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const AOD_SCALE = 0.7; // AOD下缩放值
const AOD_ALPHA = 0; // AOD下透明度
const SL_SCALE = 1; // 锁屏下缩放值
const SL_ALPHA = 1; // 锁屏下透明度

// 锁头、签名一镜到底动效管理
export class LockIconMirrorCtrl implements IComponentMirrorCtrl {
  // 锁头动效状态管理
  private lockIconAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlLockAnimState();
  // 锁头UI状态管理
  private lockIconUiBindCtrl: SlLockIconBindState | undefined = slStateHelper.getSlLockBindState();

  setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);
    if (scene === MirrorsScene.AOD_TO_SL || scene === MirrorsScene.SCREEN_OFF_TO_SL_END ||
      scene === MirrorsScene.SL_UNLOCKING_TO_DESKTOP ||
      scene === MirrorsScene.DESKTOP_TO_SL) {
      this.lockIconUiBindCtrl?.setLayoutScale(SL_SCALE);
      this.lockIconUiBindCtrl?.setLayoutOpacity(SL_ALPHA);
    }
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.lockIconUiBindCtrl?.setLayoutScale(AOD_SCALE);
      this.lockIconUiBindCtrl?.setLayoutOpacity(AOD_ALPHA);
    }
  }

  setPartUiBindState(scene: string): void {
    log.showInfo(`setPartUiBindState=${scene}`);
    this.setUiBindState(scene);
  }

  setAnimState(scene: string): void {
    log.showInfo(`setAnimState=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.lockIconAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, AOD_SCALE);
      this.lockIconAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, AOD_SCALE);
      this.lockIconAnimCtrl?.setStateValue(WBaseProperty.ALPHA, AOD_ALPHA);
      return;
    }
    this.lockIconAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, SL_SCALE);
    this.lockIconAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, SL_SCALE);
    this.lockIconAnimCtrl?.setStateValue(WBaseProperty.ALPHA, SL_ALPHA);
  }

  setPartAodUiBindState(scene: string): void {
    log.showInfo(`setPartUiBindState=${scene}`);
    this.setUiBindState(scene);
  }

  setPartAodAnimState(scene: string): void {
    log.showInfo(`setPartAodAnimState=${scene}`);
    this.setAnimState(scene);
  }

  setAnimEmoji(scene: string): void {
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.lockIconAnimCtrl?.setAlpha(AOD_ALPHA);
      return;
    }
    this.lockIconAnimCtrl?.setAlpha(SL_ALPHA);
  }

  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
    if (isStart) {
      this.clearAnimating();
    }

    this.lockIconAnimCtrl?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: true });
  }

  clearAnimating(): void {
    let scenes = this.lockIconAnimCtrl?.getSceneValues();
    log.showInfo(`now clear all anim scenes, ${scenes}`)
    scenes?.split(',').forEach((scene) => {
      this.lockIconAnimCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
    })
  }

  isSceneAnimating(scene: string): boolean {
    return this.lockIconAnimCtrl?.isSceneAnimating(scene) ?? false;
  }
}