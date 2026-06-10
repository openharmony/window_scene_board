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

import curves from '@ohos.curves';
import { DomainName, LogDomain, Logger, TraceUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { UIEffectZOrderType } from '@ohos/windowscene';
import { display } from '@kit.ArkUI';
import { CustomUIEffectType, SCBCustomUIEffectManager } from '@ohos/windowscene/Index';

// 坚盾模式解锁动效打点
export const SHIELD_ANIMATION_TRACE_NAME = 'LOCK_TO_DESKTOP_SHIELD_ANIMATION';

@Observed
export class ShieldAnimParam {
  public startShieldAnim: boolean = false;
  public imagesScale: number = 1.0;
  public imagesOpacity: number = 1.0;
  public showContainerBg: boolean = false;
  public containerOpacity: number = 0;
}

const TAG: string = 'ShieldAnimViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const START_SHIELD_DELAY: number = 282.67;
const SHIELD_ANIMATE_DELAY: number = 1482.67;
const SCALE_ANIMATE_FIRST: number = 350;
const SCALE_ANIMATE_SECOND: number = 500;
const OPACITY_ANIMATE: number = 300;
const MAX_IMAGE_NUM: number = 60;
const IMAGE_ANIMATOR_RATIO: number = 0.8;

/**
 * 坚盾模式桌面动效
 */
export class ShieldAnimViewModel {
  private images: ImageFrameInfo[] = [];
  private whiteImages: ImageFrameInfo[] = [];
  private shieldAnimParam: ShieldAnimParam;
  private _containerWidth: number = 0;
  private _containerHeight: number = 0;
  private _shieldImageAnimatorSize: number = 0;
  private _heightWidthRatio: number = 1;
  private _isLand: boolean = false;

  constructor(param: ShieldAnimParam) {
    this.shieldAnimParam = param;
  }

  public get containerWidth(): number {
    return this._containerWidth;
  }

  public get containerHeight(): number {
    return this._containerHeight;
  }

  public get heightWidthRatio(): number {
    return this._heightWidthRatio;
  }

  public get isLand(): boolean {
    return this._isLand;
  }

  public get shieldImageAnimatorSize(): number {
    return this._shieldImageAnimatorSize;
  }

  public getShieldAnimParam(): ShieldAnimParam {
    return this.shieldAnimParam;
  }

  public getImages(): ImageFrameInfo[] {
    return this.images;
  }

  public getWhiteImages(): ImageFrameInfo[] {
    return this.whiteImages;
  }

  /**
   * 播放盾牌序列帧动效
   */
  public playShieldImageAnimator(): void {
    this.images = this.getShieldLogoResource('shield-logo');
    this.whiteImages = this.getShieldLogoResource('shield-logo-white');
    this.shieldAnimParam.imagesScale = 1;
    this.shieldAnimParam.imagesOpacity = 1;
    this.shieldAnimParam.showContainerBg = true;
    setTimeout(() => {
      this.shieldAnimParam.startShieldAnim = true;
      // 盾牌蒙层遮罩出现透明性动效
      animateTo({
        duration: 800,
        curve: curves.cubicBezierCurve(0.33, 0.00, 0.67, 1.00),
      }, () => {
        this.shieldAnimParam.containerOpacity = 1;
      });
    }, START_SHIELD_DELAY);
    setTimeout(() => {
      this.doImagesAnimate();
    }, SHIELD_ANIMATE_DELAY);
  }

  /**
   * 初始化坚盾动效的信息
   */
  public InitShieldContainerProperty(): void {
    // 普通模式PC
    try {
      this._containerWidth = display.getDefaultDisplaySync().width;
      this._containerHeight = display.getDefaultDisplaySync().height;
    } catch (e) {
      log.showWarn(TAG, 'getDefaultDisplaySync error')
      this._containerWidth = AppStorage.get('ScreenWidth') ?? 0;
      this._containerHeight = AppStorage.get('ScreenHeight') ?? 0;
    }
    this._shieldImageAnimatorSize = px2vp(Math.min(this._containerWidth, this._containerHeight)) * IMAGE_ANIMATOR_RATIO;
    this._heightWidthRatio =
      Math.max(this._containerWidth / this._containerHeight, this._containerHeight / this._containerWidth);
    this._isLand = this._containerWidth > this._containerHeight;
  }

  public destroy(): void {
    log.showWarn(TAG, 'destroy');
    TraceUtil.endTrace(DomainName.SCB, SHIELD_ANIMATION_TRACE_NAME);
    this.preHeatingAppCenter();
    this.shieldAnimParam.startShieldAnim = false;
    this.shieldAnimParam.showContainerBg = false;
    this.images = [];
    this.whiteImages = [];
    SCBCustomUIEffectManager.getInstance().destroyUIEffectController(UIEffectZOrderType.ABOVE_SCREEN_LOCK,
      CustomUIEffectType.TYPE_SHIELD);
  }

  private getShieldLogoResource(suffix: string): ImageFrameInfo[] {
    let images: ImageFrameInfo[] = [];
    for (let index = 0; index < MAX_IMAGE_NUM; index++) {
      const frameInfo: ImageFrameInfo = {
        src: $rawfile(`${suffix}${index.toString().padStart(2, '0')}.png`),
      }
      images.push(frameInfo);
    }
    return images;
  }

  private doImagesAnimate(): void {
    animateTo({
      duration: SCALE_ANIMATE_FIRST,
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.51, 1.43),
      onFinish: () => {
        this.doImagesAnimateCallback();
      }
    }, () => {
      this.shieldAnimParam.imagesScale = 1.05;
    })
  }

  private doImagesAnimateCallback(): void {
    animateTo({
      duration: SCALE_ANIMATE_SECOND,
      curve: curves.cubicBezierCurve(0.35, 0.03, 0.50, 1.00),
      onFinish: () => {
        this.destroy();
      }
    }, () => {
      this.shieldAnimParam.imagesScale = 0.3;
    })
    animateTo({
      duration: OPACITY_ANIMATE,
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.67, 1.00),
    }, () => {
      this.shieldAnimParam.imagesOpacity = 0;
      this.shieldAnimParam.containerOpacity = 0;
    })
  }

  private preHeatingAppCenter(): void {
    const preHeatingAppCenter: Object | undefined = AppStorage.get('preHeatingAppCenter');
    if (preHeatingAppCenter === undefined) {
      log.showInfo(TAG, 'preHeatingAppCenter');
      AppStorage.setOrCreate<boolean>('preHeatingAppCenter', true);
      ViewManagerPolicy.showView(ViewType.APP_CENTER);
    }
  }
}
