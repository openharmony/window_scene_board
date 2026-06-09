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

import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import { MirrorAnimState, MirrorsScene } from '../constants/MirrorToEndConst';
import IComponentMirrorCtrl from './IComponentMirrorCtrl';
import { aodHardwareConfig, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SlFormBindState } from '../../screenlockstate/model/data/SlFormBindState';
import { WidgetBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WBaseProperty } from '@ohos/screenlockcommon';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { ClockMirrorCtrl } from './ClockMirrorCtrl';

const TAG = 'FormMirrorCtrl';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const FORM_PART_AOD_SCALE = 0.8;
const FORM_SL_SCALE = 1;
const FORM_PART_AOD_ALPHA = 0;
const FORM_SL_ALPHA = 1;

/**
 * 由于锁屏卡片在其他一镜到底行为与时钟保持一致
 * 当前只有在局部AOD通用一镜到底才会有差异，
 */
export class FormMirrorCtrl implements IComponentMirrorCtrl {
  // 时钟组件动效状态管理
  private formAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlFormAnimState();
  // 时钟组件UI状态管理
  private formUiBindCtrl: SlFormBindState | undefined = slStateHelper.getSlFormBindState();
  private aodAlpha: number = 1;
  private defaultBackgroundColor: ResourceColor = '#FFFFFFFF';
  private aodBackgroundColor: ResourceColor = '#FFAFAFAF';
  // 时钟组件UI状态管理,依赖时钟避免重复代码
  private clockUiBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState();
  // 时钟组件静态状态管理
  private clockStaticCtrl: SlClockStaticState = slStateHelper.getSlClockStaticState();

  setUiBindState(scene: string): void {
    log.showInfo(TAG, `setUiBindState=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      if (!this.clockUiBindCtrl?.getClockDesktopToAod()) {
        this.formUiBindCtrl?.setLayoutOpacity(0);
        this.formUiBindCtrl?.setLayoutScale(1.2);
      } else {
        this.formUiBindCtrl?.setLayoutOpacity(1);
        this.formUiBindCtrl?.setLayoutScale(1);
      }
      return;
    }

    this.formUiBindCtrl?.setLayoutOpacity(1);

    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD) {
      let aodColor: ResourceColor = this.clockStaticCtrl.getAodClockColor() ?? this.aodBackgroundColor;
      if (aodHardwareConfig.isSupportBackgroundEffect()) {
        this.aodAlpha = 1;
      }
      log.showInfo(TAG, `ui update form color: ${aodColor}`);
      this.formUiBindCtrl?.setLayoutOpacity(this.aodAlpha);
    }
    // 黑屏到锁屏的第一帧
    if (this.isScreenOffToSLWithoutClockOneShot(scene)) {
      this.formUiBindCtrl?.setLayoutScale(0.7);
      this.formUiBindCtrl?.setLayoutOpacity(0);
      return;
    }
    this.formUiBindCtrl?.setLayoutScale(1);
  }

  setAnimState(scene: string): void {
    log.showInfo(TAG, `setAnimState state=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      if (!this.clockUiBindCtrl?.getClockDesktopToAod()) {
        this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 1.2);
        this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 1.2);
        this.formAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 0);
      }
      return;
    }

    // 黑屏到锁屏的第一帧
    if (this.isScreenOffToSLWithoutClockOneShot(scene)) {
      this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 0.7);
      this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 0.7);
      this.formAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 0);
      return;
    }

    this.formAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 1);
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD) {
      let aodColor: ResourceColor = this.clockStaticCtrl.getAodClockColor() ?? this.aodBackgroundColor;
      if (aodHardwareConfig.isSupportBackgroundEffect()) {
        this.aodAlpha = 1;
      }
      log.showInfo(TAG, `anim update form color: ${aodColor}, aplha: ${this.aodAlpha}`);
      this.formAnimCtrl?.setStateValue(WBaseProperty.ALPHA, this.aodAlpha);
    }

    if (scene === MirrorsScene.SCREEN_OFF_TO_SL_END) {
      this.formUiBindCtrl?.setLayoutOpacity(1);
      this.formUiBindCtrl?.setLayoutScale(1);
    }

    this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 1);
    this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 1);
  }

  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
    log.showInfo(TAG, `startAnim scene: ${scene}, isStart: ${isStart}`);
    if (isStart) {
      this.clearAnimating();
    }
    if (this.formAnimCtrl) {
      this.formAnimCtrl?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: true });
    }

  }

  isSceneAnimating(scene: string): boolean {
    return this.formAnimCtrl?.isSceneAnimating(scene) ?? false;
  }

  clearAnimating(): void {
    let scenes = this.formAnimCtrl?.getSceneValues();
    log.showInfo(TAG, `now clear all anim scenes, ${scenes}`)
    scenes?.split(',').forEach((scene) => {
      this.formAnimCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
    })
  }

  private isScreenOffToSLWithoutClockOneShot(scene: string): boolean {
    return scene === MirrorsScene.SCREEN_OFF_TO_SL && !this.clockUiBindCtrl?.isInDesktopAndAodClockOneShot();
  }

  setPartAodAnimState(scene: string): void {
    log.showInfo(TAG, `setPartAodAnimState: ${scene}`);
    if (scene === MirrorsScene.SL_TO_AOD || scene === MirrorsScene.DESKTOP_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, FORM_PART_AOD_SCALE);
      this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, FORM_PART_AOD_SCALE);
      this.formAnimCtrl?.setStateValue(WBaseProperty.ALPHA, FORM_PART_AOD_ALPHA);
      return;
    }
    this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, FORM_SL_SCALE);
    this.formAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, FORM_SL_SCALE);
    this.formAnimCtrl?.setStateValue(WBaseProperty.ALPHA, FORM_SL_ALPHA);
  }

  setPartAodUiBindState(scene: string): void {
    log.showInfo(TAG, `setPartAodUiBindState: ${scene}`);
    if (scene === MirrorsScene.SL_TO_AOD || scene === MirrorsScene.DESKTOP_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.formUiBindCtrl?.setSlState(WidgetBindStateType.LAYOUT_SCALE, FORM_PART_AOD_SCALE);
      this.formUiBindCtrl?.setSlState(WidgetBindStateType.LAYOUT_OPACITY, FORM_PART_AOD_ALPHA);
      return;
    }
    this.formUiBindCtrl?.setSlState(WidgetBindStateType.LAYOUT_SCALE, FORM_SL_SCALE);
    this.formUiBindCtrl?.setSlState(WidgetBindStateType.LAYOUT_OPACITY, FORM_SL_ALPHA);
  }
}