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
import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AnimationBase, AnimateParams } from '../../../animation/AnimationBase';
import { ILiveCapsuleFaceLockVm } from '../../interface/ILiveCapsuleFaceLockVm';
import { LiveStyle } from '../../constants/LiveStyle';

const TAG = 'LiveCapsuleFaceLockAnimation';
const log = Logger.getLogHelper(LogDomain.SYS_UI);

export class LiveCapsuleFaceLockAnimation extends AnimationBase {
  protected faceLockVm: ILiveCapsuleFaceLockVm;

  constructor(faceLockVm: ILiveCapsuleFaceLockVm) {
    super(AnimationBase.NAMES.LIVE_HEADS_UP_FACE_LOCK_ANIMATION, true);
    this.faceLockVm = faceLockVm;
  }

  // 人脸认证中
  public async swipeEnterFaceAnimation(): Promise<void> {
    log.showInfo(TAG, 'swipeEnterFaceAnimation begins');
    this.faceLockVm.playShowAnimation();
  }

  //人脸认证成功
  public async swipeDoingFaceSuccessAnimation(): Promise<void> {
    log.showInfo(TAG, 'swipeDoingFaceSuccessAnimation begins');
    let animalParam = this.getFaceLockSwipeSuccessHoleAnimation();
    await this.executeAnimation(animalParam);
    this.faceLockVm.destroyAnimation(this.faceLockVm.showAnimateName);
  }

  public getFaceLockSwipeSuccessHoleAnimation(): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    this.faceLockVm.successOpacity = 0;
    animateParams.push(
      {
        curve: Curve.Linear,
        duration: 200,
        event: () => {
          this.faceLockVm.showOpacity = 0;
          this.faceLockVm.successOpacity = 1;
          this.faceLockVm.playSuccessAnimation();
        },
      },
    )
    return animateParams;
  }

  public setFaceLockSwipeHideHoleAnimation(): void {
    this.faceLockVm.successOpacity = 1;
    this.faceLockVm.successScaleX = LiveStyle.FACE_LOCK_SUCCESS_CAPSULE_SCALE;
    this.faceLockVm.successScaleY = LiveStyle.FACE_LOCK_SUCCESS_CAPSULE_SCALE;
    this.faceLockVm.showScaleX = LiveStyle.FACE_LOCK_SHOW_CAPSULE_SCALE;
    this.faceLockVm.showScaleY = LiveStyle.FACE_LOCK_SHOW_CAPSULE_SCALE;
    this.faceLockVm.showOpacity = 1;
  }
}