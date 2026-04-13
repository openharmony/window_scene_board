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

import curves from '@ohos.curves';
import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';

@Observed
export class ShieldAnimParam {
  public startShieldAnim: boolean = false;
  public imagesScale: number = 1.0;
  public imagesOpacity: number = 1.0;
}

const TAG: string = 'ShieldAnimViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const START_SHIELD_DELAY: number = 266.67;
const SHIELD_AINMATE_DELAY: number = 1116.67;
const SCALE_AINMATE_FIRST: number = 350;
const SCALE_AINMATE_SECOND: number = 500;
const OPACITY_AINMATE: number = 250;

/**
 * 坚盾模式桌面动效
 */
export class ShieldAnimViewModel {
  private images: ImageFrameInfo[] = [];
  private whiteImages: ImageFrameInfo[] = [];
  private shieldAnimParam: ShieldAnimParam = new ShieldAnimParam();

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
   * 监听解锁桌面
   */
  public onUnLockReceived(): void {
    this.images = this.getShieldLogoResource('shield-logo');
    this.whiteImages = this.getShieldLogoResource('shield-logo-white');
    this.shieldAnimParam.imagesScale = 1;
    this.shieldAnimParam.imagesOpacity = 1;
    setTimeout(() => {
      this.shieldAnimParam.startShieldAnim = true;
    }, START_SHIELD_DELAY);
    setTimeout(() => {
      this.doImagesAnimate();
    }, SHIELD_AINMATE_DELAY);
  }

  private getShieldLogoResource(suffix: string): ImageFrameInfo[] {
    let images: ImageFrameInfo[] = [];
    for (let index = 0; index < 30; index++) {
      let frameInfo: ImageFrameInfo = {
        src: $rawfile(`${suffix}${index.toString().padStart(2, '0')}.png`),
      }
      images.push(frameInfo);
    }
    return images;
  }

  private doImagesAnimate(): void {
    animateTo({
      duration: SCALE_AINMATE_FIRST,
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
      duration: SCALE_AINMATE_SECOND,
      curve: curves.cubicBezierCurve(0.35, 0.03, 0.50, 1.00),
      onFinish: () => {
        this.shieldAnimParam.startShieldAnim = false;
        this.images = [];
        this.whiteImages = [];
      }
    }, () => {
      this.shieldAnimParam.imagesScale = 0.3;
    })
    animateTo({
      duration: OPACITY_AINMATE,
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.67, 1.00),
    }, () => {
      this.shieldAnimParam.imagesOpacity = 0;
    })
  }
}
