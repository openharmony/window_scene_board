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
import { AnimateToScheduleUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { WidgetAnimState, WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import {
  WAnimScene,
  WBaseProperty,
  WidgetBindStateType
} from '@ohos/screenlockcommon';
import {
  SlStateBaseMgr,
  SlStateId,
  SlStateMgr,
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { immersiveKgMgr, ImmersiveState } from '@ohos/systemuicommon';
import { slStateHelper } from '../../screenlockstate/model/helper/SlStateHelper'
import { SlV2StateHelper } from '../../screenlockstate/model/helper/v2/SlV2StateHelper';
import { MirrorAnimState, MirrorsScene, MirrorToEndConst } from '../constants/MirrorToEndConst';
import IComponentMirrorCtrl from './IComponentMirrorCtrl';

const TAG = 'immersiveMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 默认属性集
const DEFAULT_PT_ARR: WBaseProperty[] = [WBaseProperty.ALPHA, WBaseProperty.SCALE_X, WBaseProperty.SCALE_Y];

// AOD一镜到底属性场景
export enum MirrorPtScene {
  PT_NORMAL = 'normal',
  PT_DESKTOP_TO_AOD_START = 'desktop_to_aod_start',
  PT_PART_AOD = 'part_aod',
  PT_IMMERSIVE_PART_AOD = 'IMMERSIVE_PART_AOD',
}

// 透明度默认配置
const DEFAULT_PT_ALPHA: Map<MirrorPtScene, number | undefined> = new Map([
  [MirrorPtScene.PT_NORMAL, 1],
  [MirrorPtScene.PT_DESKTOP_TO_AOD_START, 0],
  [MirrorPtScene.PT_PART_AOD, 0],
  [MirrorPtScene.PT_IMMERSIVE_PART_AOD, 0],
]);

// 缩放度默认配置
const DEFAULT_PT_SCALE: Map<MirrorPtScene, number | undefined> = new Map([
  [MirrorPtScene.PT_NORMAL, 1],
  [MirrorPtScene.PT_DESKTOP_TO_AOD_START, 1.2],
  [MirrorPtScene.PT_PART_AOD, 0],
  [MirrorPtScene.PT_IMMERSIVE_PART_AOD, 0],
]);

export abstract class ImmersiveMirrorCtrl implements IComponentMirrorCtrl {
  // UI状态
  protected uiBindCtrl: ISlState | undefined = slStateHelper.getImmersiveListBindState();
  // 状态管理
  protected animCtrl: WidgetAnimState | undefined = slStateHelper.getImmersiveListAnimState();
  // 沉浸状态
  protected readonly immState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
  // 上一次开始动效的场景
  protected lastStartScene: string = '';
  // 是否GC避让
  protected isGCSchedule: boolean = false;

  protected getPropertyArr(): WBaseProperty[] {
    // 参与动效的属性集
    return DEFAULT_PT_ARR;
  }

  protected getV2StMgrName(): SlStateMgr {
    // v2状态管理器名称，默认通用管理器
    return SlStateMgr.MGR_COMMON;
  }

  protected getV2StHelper(): SlV2StateHelper {
    // v2状态辅助工具
    return SlV2StateHelper.getInstance(this.getV2StMgrName());
  }

  // v2状态ID标识
  protected abstract getV2Id(): SlStateId;

  protected getV2ImmAnim(): WidgetAnimStateV2 | undefined {
    // v2沉浸模块动效
    return this.getV2StHelper()?.getAnimSt(this.getV2Id());
  }

  protected getV2ImmStyle(): WidgetStyleStateV2 | undefined {
    // V2沉浸模块样式
    return this.getV2StHelper()?.getStyleSt(this.getV2Id());
  }

  protected isV2(): boolean {
    // v2判断
    return SlStateBaseMgr.isV2Enable();
  }

  protected getMirrorPtAlphaCfg(): Map<MirrorPtScene, number | undefined> {
    // 默认透明度配置
    return DEFAULT_PT_ALPHA;
  }

  protected getMirrorPtScaleCfg(): Map<MirrorPtScene, number | undefined> {
    // 默认缩放度配置
    return DEFAULT_PT_SCALE;
  }

  protected getMirrorPtAlpha(ptScene: MirrorPtScene): number | undefined {
    // 取值透明度
    return this.getMirrorPtAlphaCfg()?.get(ptScene);
  }

  protected getMirrorPtScale(ptScene: MirrorPtScene): number | undefined {
    // 取值缩放度
    return this.getMirrorPtScaleCfg()?.get(ptScene);
  }

  protected setAnimPt(ptScene: MirrorPtScene): void {
    // 动效对应场景赋值
    let alpha = this.getMirrorPtAlpha(ptScene);
    let scale = this.getMirrorPtScale(ptScene);
    if (this.isV2()) {
      this.getV2ImmAnim()?.setAlpha(alpha)
        .setScaleX(scale).setScaleY(scale);
      return;
    }
    this.animCtrl?.setAlpha(alpha)
      .setScaleX(scale).setScaleY(scale);
  }

  protected setStylePt(ptScene: MirrorPtScene): void {
    // 样式对应场景赋值
    let alpha = this.getMirrorPtAlpha(ptScene);
    let scale = this.getMirrorPtScale(ptScene);
    if (this.isV2()) {
      this.getV2ImmStyle()?.setAlpha(alpha)
        .setScaleX(scale).setScaleY(scale);
    }
    this.setV1StyleAlpha(alpha);
    this.setV1StyleScale(scale);
  }

  protected setV1StyleAlpha(alpha: number | undefined): void {
    // 子类复写，默认用LAYOUT_OPACITY
    this.uiBindCtrl?.setSlState(WidgetBindStateType.LAYOUT_OPACITY, alpha);
  }

  protected setV1StyleScale(scale: number | undefined): void {
    // 子类复写，默认用LAYOUT_SCALE
    this.uiBindCtrl?.setSlState(WidgetBindStateType.LAYOUT_SCALE, scale);
  }

  protected setAnimatingSt(scene: WAnimScene): void {
    // 动效开始/结束状态
    if (this.isV2()) {
      this.getV2ImmAnim()?.setAnimScene(scene);
      return;
    }
    this.animCtrl?.setAnimScene(scene);
  }

  setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);
  }

  setAnimState(scene: string): void {
    log.showInfo(`setAnimState state=${scene}`);
  }

  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
  }

  setPartAodUiBindState(scene: string): void {
  }

  setPartAodAnimState(scene: string): void {
  }

  clearAnimating(): void {
    if (this.isV2()) {
      let scenes = this.getV2ImmAnim()?.getSceneValues();
      scenes?.split(',').forEach((scene) => {
        this.getV2ImmAnim()?.setAnimScene({ isAnimating: false, animScene: scene });
      });
      return;
    }
    let scenes = this.animCtrl?.getSceneValues();
    log.showInfo(`now clear all anim scenes, ${scenes}`)
    scenes?.split(',').forEach((scene) => {
      this.animCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
    })
  }

  protected isIntoAod(scene: string): boolean {
    return scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL ||
      scene === (MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
  }

  isSceneAnimating(scene: string): boolean {
    return this.lastStartScene === scene && this.isAnimating(MirrorToEndConst.IMMERSIVE_ONE_MIRROR_SCENE);
  }

  protected switchGCSchedule(): void {
    let isOneMirrorAnimating = this.isAnimating(MirrorToEndConst.IMMERSIVE_ONE_MIRROR_SCENE);
    if (this.isGCSchedule && !isOneMirrorAnimating) {
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
      this.isGCSchedule = false;
    }
    if (!this.isGCSchedule && isOneMirrorAnimating) {
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      this.isGCSchedule = true;
    }
  }

  protected isNeedChangeCardState(scene: string): boolean {
    return scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL || scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START
  }

  protected clearAnimProperty(): void {
    this.getPropertyArr()?.forEach((pt) => {
      if (this.isV2()) {
        this.getV2ImmAnim()?.clearProperty(pt);
        return;
      }
      this.animCtrl?.clearProperty(pt);
    });
  }

  protected isAnimating(scene: string): boolean {
    if (this.isV2()) {
      return this.getV2ImmAnim()?.isSceneAnimating(scene) ?? false;
    }
    return this.animCtrl?.isSceneAnimating(scene) ?? false;
  }
}