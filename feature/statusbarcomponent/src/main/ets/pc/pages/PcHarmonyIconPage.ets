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
import { AnimatorResult } from '@kit.ArkUI';
import Animator, { AnimatorOptions } from '@ohos.animator'
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { SCBFoldStatePropertyChangeEvent } from '@ohos/windowscene/src/main/ets/events/SCBFoldStatePropertyChangeEvent';
import { SuperFoldStatus } from '../common/SuperFoldStatus';
import { util } from '@kit.ArkTS';

const TAG: string = 'PcHarmonyIconPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const HARMONY_RING_WIDTH = '40vp';
const GLOW_RING_WIDTH = '60vp';

@Component
export struct HarmonyRingPage {
  @Consume contentColor: string;
  @State inHover: boolean = false;
  @State iconScale: number = 1;
  @State refreshAngle: number = 0;
  @State glowOpacity: number = 0;
  @State ringOpacity: number = 1;
  private scaleAnimator?: AnimatorResult = undefined;
  private glowRotationAnimator?: AnimatorResult = undefined;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private blackRingBrightnessOptions: BrightnessOptions = {
    rate: 0.4,
    lightUpDegree: -25 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 2.0,
    posRGB: [1.9, 3.8, 1.3],
    negRGB: [0.5, 0.67, 1.3],
    fraction: 0
  }
  private superFoldStatus: SuperFoldStatus = SuperFoldStatus.getInstance();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear hash: ${util.getHash(this)}`);
    this.eventMgr
      .on(SCBFoldStatePropertyChangeEvent, this.onSuperFoldStatusChange);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear hash: ${util.getHash(this)}`);
    this.eventMgr.offAll();
    this.destroyAnimator();
  }

  destroyAnimator(): void {
    // 重置动效，防止风格切换时组件重复创建，导致的内存泄漏
    if (this.scaleAnimator) {
      this.scaleAnimator = undefined;
    }
    if (this.glowRotationAnimator) {
      this.glowRotationAnimator = undefined;
    }
  }

  onSuperFoldStatusChange = (superFoldStateProperty: SCBFoldStatePropertyChangeEvent) => {
    if (!this.inHover) {
      return;
    }
    log.showInfo(`onSuperFoldStatusChange property, bSideWidth: ${superFoldStateProperty.bSideWidth}, ` +
      `curState: ${superFoldStateProperty.curState}, tarState: ${superFoldStateProperty.tarState}`);
    // 横竖屏旋转时清除hover状态
    if (this.superFoldStatus.isRotateStatus(superFoldStateProperty)) {
      this.inHover = false;
    }
  }

  onImageError(error: ImageError, imageStr: string): void {
    log.showError(`harmony_ring image load error, imageStr: ${imageStr}, message: ${error?.message}`);
  }

  build() {
    Stack() {
      if (this.contentColor === '#000000') {
        this.blackRing()
      } else {
        this.WhiteRing()
      }
    }
    .id(`${TAG}_Stack`)
    .height(GLOW_RING_WIDTH)
    .width(GLOW_RING_WIDTH)
    .clickEffect({ level: ClickEffectLevel.MIDDLE, scale: 0.9 })
    .alignContent(Alignment.Center)
    .onAppear(() => {
      this.createAnimator();
    })
    .onHover((isHover) => {
      log.showInfo(`Harmony ring is in or out hover.`);
      this.inHover = isHover;
      if (isHover) {
        this.playHoverAnimation();
      } else {
        this.pauseHoverAnimation();
      }
    })
  }

  @Builder
  blackRing() {
    Image($r('app.media.system_ring_ori'))
      .objectFit(ImageFit.Contain)
      .height(HARMONY_RING_WIDTH)
      .width(HARMONY_RING_WIDTH)
      .scale({ x: this.iconScale, y: this.iconScale })
      .foregroundBrightness(this.blackRingBrightnessOptions)
      .draggable(false)
      .opacity(this.ringOpacity)
      .onError((error: ImageError) => {
        this.onImageError(error, 'blackRing_ori');
      })
    Image($r('app.media.system_ring_stroke'))
      .objectFit(ImageFit.Contain)
      .height(HARMONY_RING_WIDTH)
      .width(HARMONY_RING_WIDTH)
      .renderGroup(true)
      .draggable(false)
      .scale({ x: this.iconScale, y: this.iconScale })
      .onError((error: ImageError) => {
        this.onImageError(error, 'blackRing_stroke');
      })
    Image($r('app.media.system_glow_ori'))
      .objectFit(ImageFit.Contain)
      .height(HARMONY_RING_WIDTH)
      .width(HARMONY_RING_WIDTH)
      .scale({ x: this.iconScale, y: this.iconScale })
      .foregroundBrightness(this.blackRingBrightnessOptions)
      .draggable(false)
      .opacity(this.glowOpacity * 0.9)
      .interpolation(ImageInterpolation.Medium)
      .rotate({ centerX: '50%', centerY: '50%', angle: `${this.refreshAngle}deg` })
      .onError((error: ImageError) => {
        this.onImageError(error, 'blackRing_glow_ori');
      })
    Image($r('app.media.system_glow_stroke'))
      .objectFit(ImageFit.Contain)
      .height(HARMONY_RING_WIDTH)
      .width(HARMONY_RING_WIDTH)
      .draggable(false)
      .opacity(this.glowOpacity)
      .rotate({ centerX: '50%', centerY: '50%', angle: `${this.refreshAngle}deg` })
      .scale({ x: this.iconScale, y: this.iconScale })
      .interpolation(ImageInterpolation.High)
      .onError((error: ImageError) => {
        this.onImageError(error, 'blackRing_glow_stroke');
      })
  }

  @Builder
  WhiteRing() {
    Image($r('app.media.system_ring_black'))
      .objectFit(ImageFit.Contain)
      .fillColor(Color.Transparent)
      .height(HARMONY_RING_WIDTH)
      .width(HARMONY_RING_WIDTH)
      .renderGroup(true)
      .draggable(false)
      .scale({ x: this.iconScale, y: this.iconScale })
      .onError((error: ImageError) => {
        this.onImageError(error, 'whiteRing_black');
      })
    if (this.inHover) {
      Image($r('app.media.white_harmony_ring_glow'))
        .objectFit(ImageFit.Contain)
        .height(GLOW_RING_WIDTH)
        .width(GLOW_RING_WIDTH)
        .draggable(false)
        .opacity(this.glowOpacity)
        .rotate({ centerX: '50%', centerY: '50%', angle: `${this.refreshAngle}deg` })
        .scale({ x: this.iconScale, y: this.iconScale })
        .interpolation(ImageInterpolation.High)
        .onError((error: ImageError) => {
          this.onImageError(error, 'whiteRing_glow');
        })
    }
  }

  private createAnimator() {
    this.createScaleAnimator();
    this.createGlowRotationAnimator();
  }

  createScaleAnimator() {
    // 缩放动画
    let scaleOptions: AnimatorOptions = {
      duration: 2400,
      delay: 0,
      begin: 1,
      end: 1.05,
      easing: 'linear',
      fill: 'forwards',
      direction: 'alternate',
      iterations: -1
    };
    this.scaleAnimator = Animator.create(scaleOptions);
    this.scaleAnimator!.onFrame = (value) => {
      this.iconScale = value;
    };
  }

  createGlowRotationAnimator() {
    // 光效旋转动画
    this.glowRotationAnimator = Animator.create({
      duration: 3600,
      delay: 0,
      begin: 0,
      end: 360,
      easing: 'linear',
      fill: 'forwards',
      direction: 'normal',
      iterations: -1
    } as AnimatorOptions);
    this.glowRotationAnimator!.onFrame = (value) => {
      this.refreshAngle = value;
    }
  }

  playHoverAnimation() {
    this.glowRotationAnimator?.play();
    this.scaleAnimator?.play();
    animateTo({
      duration: 400,
      delay: 0,
      curve: Curve.Sharp,
      iterations: 1
    }, () => {
      this.glowOpacity = 1;
      this.ringOpacity = 0;
    })
  }

  pauseHoverAnimation() {
    this.scaleAnimator?.pause();
    this.glowRotationAnimator?.pause();
    animateTo({
      duration: 200,
      delay: 0,
      curve: Curve.Sharp
    }, () => {
      this.glowOpacity = 0;
      this.ringOpacity = 1;
      this.iconScale = 1;
    })
  }
}


export default HarmonyRingPage;