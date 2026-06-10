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

@Observed
export class DeskTopItemStyle {
  public translateX: number = 0;
  public translateY: number = 0;
  public alpha: number = 0;
  public scale: number = 1;
  public centerX: string | number = '50%';
  public centerY: string | number = '50%';
  public unLockAnimate: boolean = false;

  constructor(translateX: number, translateY: number, alpha: number, scale: number, unLockAnimate: boolean,
    centerX?: string | number, centerY?: string | number) {
    this.translateX = translateX;
    this.translateY = translateY;
    this.alpha = alpha;
    this.scale = scale;
    this.centerX = centerX ? centerX : '50%';
    this.centerY = centerY ? centerY : '50%';
    this.unLockAnimate = unLockAnimate;
  }
}

