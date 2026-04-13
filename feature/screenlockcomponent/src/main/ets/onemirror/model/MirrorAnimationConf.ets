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

export default class MirrorAniConfig {
  public scaleX: number = 1;
  public scaleY: number = 1;
  public alpha: number = 1;
  public blur: number = 0;
  public marginLeft: number = 0;
  public marginTop: number = 0;

  public constructor() {
  }

  public isVisible(): boolean {
    return this.getAlpha() > 0;
  }

  public getScaleX(): number {
    return this.scaleX;
  }

  public getScaleY(): number {
    return this.scaleY;
  }

  public getBlur(): number {
    return this.blur;
  }

  public getAlpha(): number {
    return this.alpha;
  }

  public setScale(scale: number): void {
    this.scaleX = scale;
    this.scaleY = scale;
  }

  public setBlur(blur: number): void {
    this.blur = blur;
  }

  public setAlpha(alpha: number): void {
    this.alpha = alpha;
  }

  public setMarginLeft(marginLeft: number): void {
    this.marginLeft = marginLeft;
  }

  public setMarginTop(marginTop: number): void {
    this.marginTop = marginTop;
  }

  public getMarginLeft(): number {
    return this.marginLeft;
  }

  public getMarginTop(): number {
    return this.marginTop;
  }
}

/**
 * 锁屏元素位置
 * 从上到下，依次增大
 */
export enum MirrorElemType {
  Mirror_LOCK_ICON = 0,
  Mirror_CLOCK_VIEW = 1,
  Mirror_FORM = 2,
  Mirror_FINGERPRINT = 3,
  Mirror_NOTIFICATION = 4,
  Mirror_LOW_POSITION = 5,
  Mirror_AI_BAR = 6,
  Mirror_SCREEN_LOCK = 7,
}




