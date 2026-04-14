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
import { CardWgBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WBaseProperty } from '@ohos/screenlockcommon';
import { SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { slStateHelper } from '../../screenlockstate/model/helper/SlStateHelper'
import { MirrorAnimState, MirrorsScene, MirrorToEndConst } from '../constants/MirrorToEndConst';
import { ImmersiveMirrorCtrl } from './ImmersiveMirrorCtrl';

const TAG = 'ImmersiveCardMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const NORMAL_ALPHA = 1;

export class ImmersiveCardMirrorCtrl extends ImmersiveMirrorCtrl {

  constructor() {
    super();
    this.uiBindCtrl = slStateHelper.getImmersiveCardBindState();
    this.animCtrl = slStateHelper.getImmersiveCardAnimState();
  }

  protected getV2Id(): SlStateId {
    return SlStateId.SL_CARD_STATE;
  }

  setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);
    if (scene === MirrorsScene.SCREEN_OFF_TO_SL_END) {
      if (!this.isV2()) {
        this.uiBindCtrl?.setSlState(CardWgBindStateType.BACKGROUND_ALPHA, NORMAL_ALPHA);
        this.uiBindCtrl?.setSlState(CardWgBindStateType.PREVIEW_ALPHA, NORMAL_ALPHA);
      }
    }
    if (this.isNeedChangeCardState(scene) && immersiveKgMgr.getImmersiveKeyguardState().immersiveState.isShowCard()) {
    }
  }

  setAnimState(scene: string): void {
    log.showInfo(`setAnimState state=${scene}`);
    if (scene === MirrorsScene.SCREEN_OFF_TO_SL) {
      return;
    }

    if (scene === MirrorAnimState.START) {
    } else {
      if (!this.isV2()) {
        this.animCtrl?.setStateValue(WBaseProperty.ALPHA, NORMAL_ALPHA);
        this.animCtrl?.setStateValue(WBaseProperty.LIGHT_UP_EFFECT, NORMAL_ALPHA);
      }
    }
  }

  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
    log.showInfo(`start anim, scene=${scene} isStart=${isStart}, ${this.isV2()}`);
    // V2无需动效
    if (this.isV2()) {
      return;
    }
    if (isStart) {
      this.clearAnimating();
    } else {
      this.clearAnimProperty();
    }

    this.lastStartScene = isStart ? scene : '';
    this.setAnimatingSt({ isAnimating: isStart,
      animScene: MirrorToEndConst.IMMERSIVE_ONE_MIRROR_SCENE, isForceRemove: true });

    this.switchGCSchedule();
  }
}