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
import { CutoutVm } from '../../../statusbar/vm/CutoutVm';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AnimationBase, AnimateParams } from '../../../animation/AnimationBase';
import { ILiveHeadsUpFaceLockVm } from '../../interface/ILiveHeadsUpFaceLockVm';
import { curves } from '@kit.ArkUI';
import { SystemUICommonUtil } from '../../../utils/SystemUICommonUtil';
import { LiveStyle } from '../../constants/LiveStyle';
import { StatusBarCapsulePosition } from '../../../statusbar/model/StatusBarCapsulePosition';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveHeadsUpFaceLockAnimation');

export class LiveHeadsUpFaceLockAnimation extends AnimationBase {
  protected faceLockVm: ILiveHeadsUpFaceLockVm;
  private position: StatusBarCapsulePosition;

  constructor(faceLockVm: ILiveHeadsUpFaceLockVm, position: StatusBarCapsulePosition) {
    super(AnimationBase.NAMES.LIVE_HEADS_UP_FACE_LOCK_ANIMATION, true);
    this.faceLockVm = faceLockVm;
    this.position = position;
  }

  // 人脸横幅弹出动画
  public async swipeEnterFaceAnimation(): Promise<void> {
    log.showInfo(`swipeEnterFaceAnimation begins`);
    //等待融球变大后吐出的时机
    await SystemUICommonUtil.sleep(350);
    let animalParam = CutoutVm.instance.isMiddleCutout() ? this.getFaceLockSwipeEnterHoleAnimation() :
    this.getFaceLockSwipeEnterNoHoleAnimation();
    await this.executeAnimation(animalParam);
  }

  //人脸认证成功lotti动画
  public async swipeDoingFaceSuccessAnimation(): Promise<void> {
    log.showInfo(`swipeDoingFaceSuccessAnimation begins`);
    let animalParam = this.faceLockVm.isSupport3DFace ? this.get3DFaceLockSwipeSuccessHoleAnimation() :
    this.get2DFaceLockSwipeSuccessHoleAnimation();
    await this.executeAnimation(animalParam, 'faceSuccessAnimation', 500);
  }

  //人脸认证结束动画
  public async swipeHideFaceAnimation(): Promise<void> {
    log.showInfo(`swipeHideFaceAnimation begins`);
    let animalParam = this.getFaceLockSwipeHideHoleAnimation();
    await this.executeAnimation(animalParam);
    this.faceLockVm.destroyAnimation();
  }

  public getFaceLockSwipeEnterHoleAnimation(): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    this.faceLockVm.width = 8;
    this.faceLockVm.height = 16;
    this.faceLockVm.borderRadius = 8;
    this.faceLockVm.translateY = -(this.position.top + (this.position.height) / 2 + 8);
    animateParams.push(
      {
        duration: 50,
        curve: Curve.Linear,
        event: () => {
          this.faceLockVm.borderRadius = 12;
          this.faceLockVm.translateY = -10;
          this.faceLockVm.width = 24;
          this.faceLockVm.height = 24;
          this.faceLockVm.opacity = 1;
        },
      },
      {
        curve: curves.springCurve(0, 1, 200, 21),
        delay: 50,
        event: () => {
          this.faceLockVm.showScaleX = 1;
          this.faceLockVm.showScaleY = 1;
          this.faceLockVm.showOpacity = 1;
          this.faceLockVm.borderRadius = 24;
          this.faceLockVm.translateY = 0;
          this.faceLockVm.width = LiveStyle.FACE_LOCK_BANNER_SIZE;
          this.faceLockVm.height = LiveStyle.FACE_LOCK_BANNER_SIZE;
          this.faceLockVm.playShowAnimation();
        },
      },
      {
        duration: 150,
        onFinish: () => {
          this.faceLockVm.backgroundColor = true;
        },
        event: () => {
        }
      },
      {
        delay: 350,
        event: () => {
          this.faceLockVm.showAnimateItem?.play();
        }
      },
    )
    return animateParams;
  }

  public getFaceLockSwipeEnterNoHoleAnimation(): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    this.faceLockVm.width = 16;
    this.faceLockVm.height = 16;
    this.faceLockVm.borderRadius = 24;
    this.faceLockVm.translateY = -(this.position.top + (this.position.height) / 2 + 8);
    this.faceLockVm.opacity = 0;
    this.faceLockVm.showOpacity = 0;
    animateParams.push(
      {
        duration: 250,
        curve: Curve.Linear,
        event: () => {
          this.faceLockVm.borderRadius = 24;
          this.faceLockVm.opacity = 1;
          this.faceLockVm.showOpacity = 1;
          this.faceLockVm.translateY = 0;
        },
      },
      {
        curve: curves.springCurve(0, 1, 214, 22),
        event: () => {
          this.faceLockVm.showScaleX = 1;
          this.faceLockVm.showScaleY = 1;
          this.faceLockVm.width = LiveStyle.FACE_LOCK_BANNER_SIZE;
          this.faceLockVm.height = LiveStyle.FACE_LOCK_BANNER_SIZE;
          this.faceLockVm.playShowAnimation();
        },
        onFinish: () => {
          this.faceLockVm.backgroundColor = true;
        },
      },
      {
        delay: 350,
        event: () => {
          this.faceLockVm.showAnimateItem?.play();
        }
      },
    )
    return animateParams;
  }

  public get2DFaceLockSwipeSuccessHoleAnimation(): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    this.faceLockVm.successScaleX = 1;
    this.faceLockVm.successScaleY = 1;
    this.faceLockVm.successOpacity = 0;
    animateParams.push(
      {
        curve: curves.springCurve(0, 1, 439, 21),
        event: () => {
          this.faceLockVm.scaleX = 0.9;
          this.faceLockVm.scaleY = 0.9;
          this.faceLockVm.successScaleX = 0.8;
          this.faceLockVm.successScaleY = 0.8;
        },
      },
      {
        curve: curves.springCurve(0, 1, 439, 21),
        delay: 30,
        event: () => {
          this.faceLockVm.showScaleX = 0.8;
          this.faceLockVm.showScaleY = 0.8;
        },
      },
      {
        curve: curves.springCurve(0, 1, 439, 21),
        delay: 100,
        event: () => {
          this.faceLockVm.scaleX = 1;
          this.faceLockVm.scaleY = 1;
          this.faceLockVm.successScaleX = 1;
          this.faceLockVm.successScaleY = 1;
        },
      },
      {
        curve: curves.cubicBezierCurve(0.20, 0.00, 0.20, 1.00),
        duration: 100,
        event: () => {
          this.faceLockVm.showOpacity = 0;
          this.faceLockVm.successOpacity = 1;
          this.faceLockVm.playSuccessAnimation();
        },
      },
    )
    return animateParams;
  }

  public get3DFaceLockSwipeSuccessHoleAnimation(): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    this.faceLockVm.successScaleX = 1;
    this.faceLockVm.successScaleY = 1;
    this.faceLockVm.successOpacity = 0;
    animateParams.push(
      {
        curve: curves.springCurve(0, 1, 439, 21),
        event: () => {
          this.faceLockVm.scaleX = 0.9;
          this.faceLockVm.scaleY = 0.9;
          this.faceLockVm.successScaleX = 0.8;
          this.faceLockVm.successScaleY = 0.8;
          this.faceLockVm.showScaleX = 0.8;
          this.faceLockVm.showScaleY = 0.8;
        },
      },
      {
        curve: curves.springCurve(0, 1, 439, 21),
        delay: 100,
        event: () => {
          this.faceLockVm.scaleX = 1;
          this.faceLockVm.scaleY = 1;
          this.faceLockVm.successScaleX = 1;
          this.faceLockVm.successScaleY = 1;
        },
      },
      {
        curve: curves.cubicBezierCurve(0.20, 0.00, 0.20, 1.00),
        duration: 100,
        event: () => {
          this.faceLockVm.showOpacity = 0;
          this.faceLockVm.successOpacity = 1;
          this.faceLockVm.playSuccessAnimation();
        },
      },
    )
    return animateParams;
  }

  public getFaceLockSwipeHideHoleAnimation(): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        duration: 300,
        curve: Curve.Linear,
        event: () => {
          this.faceLockVm.borderRadius = 8;
          this.faceLockVm.translateY = -20;
          this.faceLockVm.width = 0;
          this.faceLockVm.height = 0;
        },
      },
      {
        duration: 250,
        curve: Curve.Linear,
        event: () => {
          this.faceLockVm.successOpacity = 0;
          this.faceLockVm.successScaleX = 0;
          this.faceLockVm.successScaleY = 0;
          this.faceLockVm.showScaleX = 0;
          this.faceLockVm.showScaleY = 0;
        },
      },
    )
    return animateParams;
  }
}