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
import { SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { slStateHelper } from '../../screenlockstate/model/helper/SlStateHelper'
import { MirrorAnimState, MirrorsScene, MirrorToEndConst } from '../constants/MirrorToEndConst';
import { ImmersiveMirrorCtrl, MirrorPtScene } from './ImmersiveMirrorCtrl';

const TAG = 'immersiveListMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ImmersiveListMirrorCtrl extends ImmersiveMirrorCtrl {
  constructor() {
    super();
    this.uiBindCtrl = slStateHelper.getImmersiveListBindState();
    this.animCtrl = slStateHelper.getImmersiveListAnimState();
  }

  protected getV2Id(): SlStateId {
    return SlStateId.SL_LIST_STATE;
  }

  setAnimEmoji(scene: string): void {
    log.showInfo(`setAnimEmoji state=${scene}`);
    if (!this.immState.isShowList()) {
      return;
    }

    if (this.isIntoAod(scene)) {
      this.setAnimPt(MirrorPtScene.PT_PART_AOD);
      return;
    }
    this.setAnimPt(MirrorPtScene.PT_NORMAL);
  }

  setPartUiBindState(scene: string): void {
    log.showInfo(`setPartUiBindState=${scene}`);
    if (!this.immState.isShowList()) {
      return;
    }

    if (this.isIntoAod(scene)) {
      this.setStylePt(MirrorPtScene.PT_PART_AOD);
      return;
    }
    this.setStylePt(MirrorPtScene.PT_NORMAL);
  }

  setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);

    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START && this.immState.isShowList()) {
      this.setStylePt(MirrorPtScene.PT_DESKTOP_TO_AOD_START);
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
    if (!this.immState.isShowList()) {
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
    if (!this.immState.isShowList()) {
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
    if (!this.immState.isShowList() && isStart) {
      this.lastStartScene = '';
      return;
    }
    log.showInfo(`start anim, scene=${scene} isStart=${isStart}`);
    if (isStart) {
      this.clearAnimating();
    } else {
      this.clearAnimProperty();
    }

    this.lastStartScene = isStart ? scene : '';
    this.setAnimatingSt({ isAnimating: isStart, animScene: MirrorToEndConst.IMMERSIVE_ONE_MIRROR_SCENE,
      isForceRemove: true });

    this.switchGCSchedule();
  }
}