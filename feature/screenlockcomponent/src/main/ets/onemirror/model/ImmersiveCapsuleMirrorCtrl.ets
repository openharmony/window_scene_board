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
import { CapWgBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlCapStaticStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { slStateHelper } from '../../screenlockstate/model/helper/SlStateHelper'
import { MirrorAnimState, MirrorsScene, MirrorToEndConst } from '../constants/MirrorToEndConst';
import { ImmersiveMirrorCtrl, MirrorPtScene } from './ImmersiveMirrorCtrl';

const TAG = 'immersiveCapsuleMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ImmersiveCapsuleMirrorCtrl extends ImmersiveMirrorCtrl {
  constructor() {
    super();
    this.uiBindCtrl = slStateHelper.getImmersiveCapBindState();
    this.animCtrl = slStateHelper.getImmersiveCapAnimState();
  }

  protected getV2Id(): SlStateId {
    return SlStateId.SL_CAP_STATE;
  }

  protected setV1StyleAlpha(alpha: number | undefined): void {
    this.uiBindCtrl?.setSlState(CapWgBindStateType.CAPSULE_ALPHA, alpha);
  }

  protected setV1StyleScale(scale: number | undefined): void {
    this.uiBindCtrl?.setSlState(CapWgBindStateType.CAPSULE_SCALE, scale);
  }

  setAnimEmoji(scene: string): void {
    if (!this.immState.isShowCapsule()) {
      return;
    }
    log.showInfo(`setAnimEmoji state=${scene}`);
    if (this.isIntoAod(scene)) {
      this.setAnimPt(MirrorPtScene.PT_PART_AOD);
      return;
    }
    this.setAnimPt(MirrorPtScene.PT_NORMAL);
  }

  setPartUiBindState(scene: string): void {
    if (!this.immState.isShowCapsule()) {
      return;
    }
    log.showInfo(`setPartUiBindState=${scene}`);
    if (this.isIntoAod(scene)) {
      this.setStylePt(MirrorPtScene.PT_PART_AOD);
      return;
    }
    this.setStylePt(MirrorPtScene.PT_NORMAL);
  }

  setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);

    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      // 胶囊态才允许设置初始值
      if (this.immState.isShowCapsule()) {
        this.setStylePt(MirrorPtScene.PT_DESKTOP_TO_AOD_START);
      }
    } else {
      this.setStylePt(MirrorPtScene.PT_NORMAL);
    }
  }

  setAnimState(scene: string): void {
    log.showInfo(`setAnimState state=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      this.setAnimPt(MirrorPtScene.PT_NORMAL);
      return;
    }

    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.setAnimPt(MirrorPtScene.PT_DESKTOP_TO_AOD_START);
    }
  }

  setPartAodUiBindState(scene: string): void {
    log.showInfo(`setPartUiBindState=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.setStylePt(MirrorPtScene.PT_IMMERSIVE_PART_AOD);
      return;
    }
    if (!this.immState.isShowCapsule()) {
      this.setStylePt(MirrorPtScene.PT_NORMAL);
      return;
    }
    if (this.isIntoAod(scene)) {
      this.setStylePt(MirrorPtScene.PT_IMMERSIVE_PART_AOD);
      return;
    }
    this.setStylePt(MirrorPtScene.PT_NORMAL);
  }

  setPartAodAnimState(scene: string): void {
    if (!this.immState.isShowCapsule()) {
      return;
    }
    log.showInfo(`setPartAodAnimState state=${scene}`);
    if (this.isIntoAod(scene)) {
      this.setAnimPt(MirrorPtScene.PT_IMMERSIVE_PART_AOD);
      return;
    }
    this.setAnimPt(MirrorPtScene.PT_NORMAL);
  }

  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
    if (!this.immState.isShowCapsule() && isStart) {
      this.lastStartScene = '';
      this.setUiBindState(scene);
      return;
    }

    log.showInfo(`start anim, scene=${scene} isStart=${isStart}`);
    if (isStart) {
      this.clearAnimating();
      // 添加动效打断器
      this.addAnimInterrupt(scene);
    } else {
      this.clearAnimProperty();
      // 清除动效打断器
      this.delAnimInterrupt();
    }

    this.lastStartScene = isStart ? scene : '';
    this.setAnimatingSt({ isAnimating: isStart, animScene: MirrorToEndConst.IMMERSIVE_ONE_MIRROR_SCENE,
      isForceRemove: true });

    this.switchGCSchedule();
  }

  private addAnimInterrupt(scene: string): void {
    if (this.isV2()) {
      // 添加动效打断器
      let capSt = this.getV2StHelper()?.getImmCapStatic();
      capSt?.setStateValue(SlCapStaticStPt.PT_AOD_MIRROR_INTERRUPT, () => {
        this.setUiBindState(scene);
        this.startAnim(scene, MirrorAnimState.NONE, false);
      });
    }
  }

  private delAnimInterrupt(): void {
    if (this.isV2()) {
      // 移除动效打断器
      let capSt = this.getV2StHelper()?.getImmCapStatic();
      capSt?.setStateValue(SlCapStaticStPt.PT_AOD_MIRROR_INTERRUPT, undefined);
    }
  }
}