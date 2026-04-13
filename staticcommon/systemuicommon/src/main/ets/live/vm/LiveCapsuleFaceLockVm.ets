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
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { LiveCapsuleVm } from './LiveCapsuleVm';
import { ILiveCapsuleFaceLockVm, ShowStage } from '../interface/ILiveCapsuleFaceLockVm';
import util from '@ohos.util';
import { common } from '@kit.AbilityKit';
import lottie from '@ohos/lottie';
import { LiveCapsuleFaceLockAnimation } from '../animation/faceLock/LiveCapsuleFaceLockAnimation';
import { LiveStyle } from '../constants/LiveStyle';

const TAG = 'LiveCapsuleFaceLockVm';
const log = Logger.getLogHelper(LogDomain.SYS_UI);

@ObservedV2
export class LiveCapsuleFaceLockVm extends LiveCapsuleVm implements ILiveCapsuleFaceLockVm {
  @Trace public successWidth: number = 0;
  @Trace public successHeight: number = 0;
  @Trace public showScaleX: number = LiveStyle.FACE_LOCK_SHOW_CAPSULE_SCALE;
  @Trace public showScaleY: number = LiveStyle.FACE_LOCK_SHOW_CAPSULE_SCALE;
  @Trace public showOpacity: number = 1;
  @Trace public successScaleX: number = LiveStyle.FACE_LOCK_SUCCESS_CAPSULE_SCALE;
  @Trace public successScaleY: number = LiveStyle.FACE_LOCK_SUCCESS_CAPSULE_SCALE;
  @Trace public successOpacity: number = 1;
  public showRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  public showCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.showRenderingSettings);
  public successRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  public successCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.successRenderingSettings);

  public showAnimateName: string = 'showLottieAnimation' + this.live.key;
  private successAnimateName: string = 'successLottieAnimation' + this.live.key;
  private lottieData?: object;
  public showStage: ShowStage = ShowStage.HIDE;
  public isOnTree: boolean = false;

  /**
   * 人脸出场
   */
  public async showFaceLock(isNeedAnimation?: boolean): Promise<void> {
    log.showInfo(TAG, `show face lock stage ${this.showStage}`);
    const capsuleAnimation = new LiveCapsuleFaceLockAnimation(this);
    if (this.showStage === ShowStage.SHOW) {
      this.lottieData = this.geLottieData('face_lock_recognition.json');
      await capsuleAnimation.swipeEnterFaceAnimation();
      return;
    }
    if (this.showStage === ShowStage.UPDATE) {
      this.lottieData = this.geLottieData('face_lock_success.json');
      if (isNeedAnimation) {
        await capsuleAnimation.swipeDoingFaceSuccessAnimation();
      } else {
        this.playSuccessAnimation(true);
      }
    }
    return;
  }

  /**
   * 人脸退场
   */
  public hideFaceLock(): void {
    this.destroyAnimation();
    const capsuleAnimation = new LiveCapsuleFaceLockAnimation(this);
    capsuleAnimation.setFaceLockSwipeHideHoleAnimation();
    return;
  }

  public geLottieData(jsonName: string): object | undefined {
    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    try {
      let context = getContext(this) as common.UIAbilityContext;
      let data = context?.resourceManager.getRawFileContentSync(jsonName);
      if (!data) {
        return undefined;
      }
      let lottieStr = resStr.decodeToString(new Uint8Array(data));
      let lottieData: object | null = JSON.parse(lottieStr);
      log.showInfo(TAG, `loadLottieData, lottieData: ${jsonName} ${lottieData}`);
      if (!lottieData) {
        return undefined;
      }
      return lottieData;
    } catch (err) {
      log.showError(TAG, `context is undefined ${err}`);
      return undefined;
    }
  }

  public playShowAnimation(): void {
    log.showInfo(TAG, 'start play faceLock show animation')
    this.destroyAnimation(this.showAnimateName);
    if (!this.lottieData) {
      return;
    }
    const animateItem = lottie.loadAnimation({
      container: this.showCanvasRenderingContext,
      renderer: 'canvas',
      loop: true,
      autoplay: true,
      autoSkip: false,
      name: this.showAnimateName,
      contentMode: 'Contain',
      animationData: this.lottieData,
    });
    animateItem.addEventListener('DOMLoaded', (args: Object): void => {
      log.showInfo(TAG, `load ${this.showAnimateName} animation success`);
      this.vmInjector.getCapsuleVm(this.live).setCapsuleOpacity(true);
    })
  }

  public playSuccessAnimation(playFrame?: boolean): void {
    log.showInfo(TAG, `start play faceLock success animation, ${playFrame}`);
    this.destroyAnimation(this.successAnimateName);
    if (!this.lottieData) {
      return;
    }
    lottie.loadAnimation({
      container: this.successCanvasRenderingContext,
      renderer: 'canvas',
      autoplay: true,
      loop: false,
      autoSkip: false,
      name: this.successAnimateName,
      contentMode: 'Contain',
      initialSegment: playFrame ? [6, 7] : [0, 7],
      animationData: this.lottieData,
    });
  }

  public destroyAnimation(name?: string): void {
    log.showInfo(TAG, `destroy name: ${name}`);
    if (name === this.showAnimateName) {
      lottie.destroy(name);
      return;
    }
    if (name === this.successAnimateName) {
      lottie.destroy(name);
      return;
    }
    this.vmInjector.getCapsuleVm(this.live).faceLockLottieNode?.destroy();
    lottie.destroy(this.showAnimateName);
    lottie.destroy(this.successAnimateName);
  }
}