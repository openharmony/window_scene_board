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
import { image } from '@kit.ImageKit';
import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenLockAniParam, ScreenLockFormAniData } from './ScreenLockFormAniData';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { CcmOption, SlAreaType, SlVisualControl } from '@ohos/screenlockcommon';

const TAG = 'ScreenLockAnimationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Observed
export class ScreenLockFormAniModel {
  public data: ScreenLockFormAniData = new ScreenLockFormAniData();
  private onFinish?: () => void;

  constructor(data: ScreenLockFormAniData) {
    this.data = data;
  }

  public setSnapshot(snapshot?: image.PixelMap): ScreenLockFormAniModel {
    this.data.snapshot = snapshot;
    return this;
  }

  public setWidth(width: number): ScreenLockFormAniModel {
    this.data.width = width;
    return this;
  }

  public setHeight(height: number): ScreenLockFormAniModel {
    this.data.height = height;
    return this;
  }

  public setRadius(radius: number): ScreenLockFormAniModel {
    this.data.radius = radius;
    return this;
  }

  public setGridWidth(gridWidth: number): ScreenLockFormAniModel {
    this.data.gridWidth = gridWidth;
    return this;
  }

  public setDimensionX(dimensionX: number): ScreenLockFormAniModel {
    this.data.dimensionX = dimensionX;
    return this;
  }

  public prepareAnimation(snapshot?: image.PixelMap): ScreenLockFormAniModel {
    this.data.snapshot = snapshot;
    return this;
  }

  public playAnimation(aniData: ScreenLockAniParam, onFinish: () => void): void {
    this.data.position = aniData.startPosition;
    this.onFinish = onFinish;
    this.data.isAnimationViewShow = true;
    log.showInfo(`snapshot = ${this.data.snapshot} playAnimation from (${aniData.startPosition.x}, ${aniData.startPosition.y}) to (${aniData.endPosition.x}, ${aniData.endPosition.y})`);
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30),
      onFinish: () => {
        this.onFinish?.();
        this.data.isAnimationViewShow = false;
        this.data.snapshot?.release();
        this.data.snapshot = undefined;
        this.onFinish = undefined;
      }
    }, () => {
      this.data.position = aniData.endPosition;
      this.data.width = this.data.gridWidth * this.data.dimensionX - 24;
      this.data.height = this.data.gridWidth - 24;
      this.data.radius = this.data.gridWidth / 2 - 12;
      this.data.scaleX = aniData.scaleX;
      this.data.scaleY = aniData.scaleY;
      if (aniData.color !== '#ffffff' &&
        SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CAPSULE)) {
        this.data.color = BrightnessOptionUtils.changeColor(aniData.color);
      } else {
        this.data.color = aniData.color;
      }
      this.data.isLightWallpaper = aniData.isLightWallpaper;
    });
  }

  public cancelAnimation(onFinish?: () => void) {
    this.onFinish?.();
    this.onFinish = undefined;
    onFinish?.();
  }
}