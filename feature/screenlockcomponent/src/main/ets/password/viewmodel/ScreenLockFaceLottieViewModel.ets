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
import lottie, { AnimationItem } from '@ohos/lottie';
import { JSON } from '@kit.ArkTS';
import util from '@ohos.util';
import type common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { slWallpaperMgr, SLWallpaperState } from '@ohos/screenlockcommon';
import FaceLottieConstants from '../../common/anim/FaceLottieConstants';

const TAG = 'ScreenLockFaceLottieViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const FRAME_RATE = 60;

export class ScreenLockFaceLottieViewModel {
  public animationRotateLoop?: AnimationItem;
  public animationLock?: AnimationItem;
  public animationUnLockSuccess?: AnimationItem;
  public animationUnLockFail?: AnimationItem;
  public animationLoop?: AnimationItem;
  public animationItem?: AnimationItem;
  public animationDetected?: AnimationItem;
  public animationBreath?: AnimationItem;
  public animationFaceFail?: AnimationItem;
  public animationFaceSuccess?: AnimationItem;
  public psdRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  public psdCanvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.psdRenderingSettings);
  public mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  public mainCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.mainRenderingSettings);
  private slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  private onBreathLoaded: Callback<boolean> = (isLoad: boolean) => {
  };
  public isLoadLoopLottie: boolean = false;
  public isLoadRotateLoopLottie: boolean = false;
  public isAllLottieLoaded: boolean = false;
  public isAllPsdLottieLoaded: boolean = false;
  public lockFrames: number = 0;
  public loopFrames: number = 0;
  public unlockFailFrames: number = 0;

  public setBreathLoadedChanged(onBreathLoaded: Callback<boolean>): void {
    this.onBreathLoaded = onBreathLoaded;
  }

  /**
   * 加载锁屏首页所有人脸lottie动画
   */
  public loadAllLottieAnimation() {
    if (this.isAllLottieLoaded) {
      return;
    }
    log.showInfo('loadAllLottieAnimation');
    this.isAllLottieLoaded = true;
    this.loadLockLottie();
    this.loadRotateLoopLottie();
    this.loadLoopLottie();
    this.loadUnlockSuccessLottie();
    this.loadUnlockFailLottie();
  }

  /**
   * 刷新锁屏首页所有人脸lottie动画
   */
  public resizeAllLottieAnimation() {
    log.showInfo('resizeAllLottieAnimation');
    this.animationLock?.resize();
    this.animationRotateLoop?.resize();
    this.animationLoop?.resize();
    this.animationUnLockSuccess?.resize();
    this.animationUnLockFail?.resize();
  }

  /**
   * 加载密码界面所有人脸lottie动画
   */
  public loadAllPsdLottieAnimation() {
    if (this.isAllPsdLottieLoaded) {
      return;
    }
    log.showInfo('loadAllPsdLottieAnimation');
    this.isAllPsdLottieLoaded = true;
    this.loadBreathLottie(true);
    this.loadDetectedLottie();
    this.loadLottieAnimation(FaceLottieConstants.PSD_FACE_FAIL, FaceLottieConstants.PSD_FACE_FAIL_PATH, false,
      (animationItem) => {
        this.animationFaceFail = animationItem;
      });
    this.loadLottieAnimation(FaceLottieConstants.PSD_FACE_SUCCESS, FaceLottieConstants.PSD_FACE_SUCCESS_PATH, false,
      (animationItem) => {
        this.animationFaceSuccess = animationItem;
      });
  }

  /**
   * 刷新密码界面所有人脸lottie动画布局
   */
  public resizeAllPsdLottieAnimation() {
    log.showInfo('resizeAllPsdLottieAnimation');
    this.animationBreath?.resize();
    this.animationDetected?.resize();
    this.animationFaceFail?.resize();
    this.animationFaceSuccess?.resize();
  }

  /**
   * 加载首页人脸RotateLooplottie动画
   */
  public loadRotateLoopLottie(): void {
    try {
      if (this.isLoadRotateLoopLottie) {
        return;
      }
      this.animationRotateLoop = lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: false,
        packageName: 'ScreenLock_ScreenLockFaceLottie',
        name: FaceLottieConstants.FACE_ROTATE_LOOP,
        path: FaceLottieConstants.FACE_ROTATE_LOOP_PATH,
        frameRate: FRAME_RATE,
      });
      this.animationRotateLoop?.addEventListener('DOMLoaded', (): void => {
        this.animationRotateLoop?.setFrameRate(FRAME_RATE);
        this.animationRotateLoop?.changeColor(
          this.hexToRgb(this.slWallpaperState?.getWallpaperReverseColor() as string));
        log.showInfo(TAG, 'DOMLoaded success, animationRotateLoop');
        this.isLoadRotateLoopLottie = true;
      });
    } catch (e) {
      log.showError(`load Rotate Loop Lottie error: ${(e as BusinessError).code}`);
    }
  }

  /**
   * 加载首页锁变为人脸动画
   */
  public loadLockLottie(): void {
    try {
      this.animationLock = lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: false,
        packageName: 'ScreenLock_ScreenLockFaceLottie',
        name: FaceLottieConstants.FACE_LOCK,
        path: FaceLottieConstants.FACE_LOCK_PATH,
        frameRate: FRAME_RATE,
      });
      this.animationLock?.addEventListener('DOMLoaded', (): void => {
        this.animationLock?.setFrameRate(FRAME_RATE);
        this.animationLock?.changeColor(this.hexToRgb(
          this.slWallpaperState?.getWallpaperReverseColor() as string));
        this.lockFrames = this.animationLock?.getDuration(true) ?? 0;
        log.showInfo(`DOMLoaded success,getDuration lockFrames:${this.lockFrames}`);
      });
    } catch (e) {
      log.showError(`load Lock Lottie error: ${(e as BusinessError).code}`);
    }
  }

  /**
   * 加载锁屏首页人脸左右摇头lottie
   */
  public loadLoopLottie(): void {
    try {
      if (this.isLoadLoopLottie) {
        return;
      }
      this.animationLoop = lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: true,
        autoplay: false,
        packageName: 'ScreenLock_ScreenLockFaceLottie',
        name: FaceLottieConstants.FACE_LOOP,
        path: FaceLottieConstants.FACE_LOOP_PATH,
        frameRate: FRAME_RATE,
      });
      this.isLoadLoopLottie = true;
      this.animationLoop?.addEventListener('DOMLoaded', (): void => {
        this.animationLoop?.setFrameRate(FRAME_RATE);
        this.loopFrames = this.animationLoop?.getDuration(true) ?? 0;
        this.animationLoop?.changeColor(this.hexToRgb(
          this.slWallpaperState?.getWallpaperReverseColor() as string));
        log.showInfo(`DOMLoaded success,getDuration loopFrames:${this.lockFrames}`);
      });
    } catch (e) {
      log.showError(`load Loop Lottie error: ${(e as BusinessError).code}`);
    }
  }

  protected loadUnlockSuccessLottie(): void {
    try {
      this.animationUnLockSuccess = lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: false,
        packageName: 'ScreenLock_ScreenLockFaceLottie',
        name: FaceLottieConstants.FACE_UNLOCK_SUCCESS,
        path: FaceLottieConstants.FACE_UNLOCK_SUCCESS_PATH,
        frameRate: FRAME_RATE,
      });
      this.animationUnLockSuccess?.addEventListener('DOMLoaded', (): void => {
        this.animationUnLockSuccess?.setFrameRate(FRAME_RATE);
        this.animationUnLockSuccess?.changeColor(this.hexToRgb(
          this.slWallpaperState?.getWallpaperReverseColor() as string));
        log.showInfo(TAG, 'DOMLoaded success, animationUnLockSuccess');
      });
    } catch (e) {
      log.showError(`load Unlock Success Lottie error: ${(e as BusinessError).code}`);
    }
  }

  protected loadUnlockFailLottie(): void {
    try {
      this.animationUnLockFail = lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: false,
        packageName: 'ScreenLock_ScreenLockFaceLottie',
        name: FaceLottieConstants.FACE_UNLOCK_FAIL,
        path: FaceLottieConstants.FACE_UNLOCK_FAIL_PATH,
        frameRate: FRAME_RATE,
      });
      this.animationUnLockFail?.addEventListener('DOMLoaded', (): void => {
        this.animationUnLockFail?.setFrameRate(FRAME_RATE);
        this.animationUnLockFail?.changeColor(this.hexToRgb(
          this.slWallpaperState?.getWallpaperReverseColor() as string));
        this.unlockFailFrames = this.animationUnLockFail?.getDuration(true) ?? 0;
        log.showInfo(`DOMLoaded success,getDuration unlockFailFrames:${this.unlockFailFrames}`);
      });
    } catch (e) {
      log.showError(`load Unlock Fail Lottie error: ${(e as BusinessError).code}`);
    }
  }

  protected loadDetectedLottie() {
    this.getLottieData(FaceLottieConstants.PSD_FACE_DETECTED_PATH, (value) => {
      let animationData = value;
      try {
        this.animationDetected = lottie.loadAnimation({
          container: this.psdCanvasRenderingContext,
          renderer: 'canvas',
          loop: false,
          autoplay: false,
          contentMode: 'Contain',
          packageName: 'ScreenLock_ScreenLockFaceLottie',
          name: FaceLottieConstants.PSD_FACE_DETECTED,
          animationData: animationData,
          frameRate: FRAME_RATE,
        });
        this.animationDetected.setFrameRate(FRAME_RATE);
        this.animationDetected.changeColor(this.hexToRgb(this.slWallpaperState?.getWallpaperReverseColor() as string));
      } catch (e) {
        log.showError(`load Detected Lottie error: ${(e as BusinessError).code}`);
      }
    });
  }

  /**
   * 加载密码页面人脸左右摇头lottie
   */
  public loadBreathLottie(needPlay: boolean = false) {
    this.getLottieData(FaceLottieConstants.PSD_FACE_BREATH_PATH, (value) => {
      let animationData = value;
      try {
        this.animationBreath = lottie.loadAnimation({
          container: this.psdCanvasRenderingContext,
          renderer: 'canvas',
          loop: true,
          autoplay: false,
          contentMode: 'Contain',
          packageName: 'ScreenLock_ScreenLockFaceLottie',
          name: FaceLottieConstants.PSD_FACE_BREATH,
          animationData: animationData,
          frameRate: FRAME_RATE,
        });
        this.animationBreath.setFrameRate(FRAME_RATE);
        this.animationBreath.changeColor(this.hexToRgb(this.slWallpaperState?.getWallpaperReverseColor() as string));
        if (!this.isAllPsdLottieLoaded) {
          return;
        }
        this.onBreathLoaded(needPlay);
      } catch (e) {
        log.showError(`load Breath Lottie error: ${(e as BusinessError).code}`);
      }
    });
  }

  protected loadLottieAnimation(lottieName: string, lottiePath: string,
    loop: boolean | number = false, callback: (name: AnimationItem | undefined) => void): void {
    this.getLottieData(lottiePath, (value) => {
      let animationItem: AnimationItem | undefined = undefined;
      let animationData = value;
      try {
        animationItem = lottie.loadAnimation({
          container: this.psdCanvasRenderingContext,
          renderer: 'canvas',
          loop: loop,
          autoplay: false,
          contentMode: 'Contain',
          packageName: 'ScreenLock_ScreenLockFaceLottie',
          name: lottieName,
          animationData: animationData,
          frameRate: FRAME_RATE,
        });
        animationItem.setFrameRate(FRAME_RATE);
        animationItem.changeColor(this.hexToRgb(this.slWallpaperState?.getWallpaperReverseColor() as string));
        if (callback) {
          callback(animationItem);
        }
      } catch (e) {
        log.showError(`load Lottie error: ${(e as BusinessError).code}`);
      }
    });
  }

  /**
   * 销毁所有锁屏首页人脸lottie动画
   */
  public destroyLottie() {
    if (!this.isAllLottieLoaded) {
      return;
    }
    log.showInfo('destroyLottie');
    this.isAllLottieLoaded = false;
    this.animationRotateLoop?.removeEventListener('complete');
    this.animationLock?.removeEventListener('complete');
    this.isLoadLoopLottie = false;
    this.isLoadRotateLoopLottie = false;
    this.animationLoop?.removeEventListener('complete');
    this.animationLoop?.removeEventListener('loopComplete');
    this.animationUnLockSuccess?.removeEventListener('complete');
    this.animationUnLockFail?.removeEventListener('complete');
    for (let index = 0; index < FaceLottieConstants.FACE_LOTTIE_NAME.length; index++) {
      lottie.destroy(FaceLottieConstants.FACE_LOTTIE_NAME[index]);
    }
    this.animationRotateLoop?.destroy();
    this.animationLock?.destroy();
    this.animationLoop?.destroy();
    this.animationUnLockSuccess?.destroy();
    this.animationUnLockFail?.destroy();
  }

  /**
   * 销毁所有密码界面人脸lottie动画
   */
  public destroyPsdLottie() {
    if (!this.isAllPsdLottieLoaded) {
      return;
    }
    log.showInfo('destroyPsdLottie');
    this.isAllPsdLottieLoaded = false;
    this.animationBreath?.removeEventListener('complete');
    this.animationDetected?.removeEventListener('complete');
    for (let index = 0; index < FaceLottieConstants.PSD_FACE_LOTTIE_NAME.length; index++) {
      lottie.destroy(FaceLottieConstants.PSD_FACE_LOTTIE_NAME[index]);
    }
    this.animationBreath?.destroy();
    this.animationDetected?.destroy();
    this.animationFaceFail?.destroy();
    this.animationFaceSuccess?.destroy();
    this.onBreathLoaded(false);
  }

  protected hexToRgb(hex: string): number[] {
    // 判断16进制颜色是否合法
    const regex = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i;
    const result = regex.exec(hex);
    const rgb: number[] = [];
    if (!result) {
      return rgb;
    }
    if ((result as RegExpExecArray).length !== 4) {
      return rgb;
    }

    // 将16进制转换为10进制
    rgb.push(parseInt(result[1], 16));
    rgb.push(parseInt(result[2], 16));
    rgb.push(parseInt(result[3], 16));

    // 返回RGB颜色
    return rgb;
  }

  protected getLottieData(lottiePath: string, callback: (value: object) => void): void {
    try {
      let context = getContext(this) as common.UIAbilityContext;
      context.resourceManager.getRawFile(lottiePath, (err: Error, data: Uint8Array) => {
        if (data === null || data === undefined || data.buffer === undefined) {
          log.showError('get lottie data fail!');
          return;
        }
        let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
        let lottieStr = resStr.decode(new Uint8Array(data.buffer));
        let lottieData: object = JSON.parse(lottieStr) as object;
        if (callback) {
          callback(lottieData);
        }
      })
    } catch (e) {
      log.showError('getRawFile fail!');
    }
  }
}