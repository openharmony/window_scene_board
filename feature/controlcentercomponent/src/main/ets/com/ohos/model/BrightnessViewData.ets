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
import { HoverConstants } from '@ohos/commonconstants';

/**
 * 亮度条滑动动效参数，暂态值
 */
// instrument ignore next
@Observed
export class BrightnessAnimViewData {
  public scaleX: number = 1;
  public brightnessBlurOpacity: number = 1;
  public shadowRadius: number = 0;
  public isHover: boolean = false;
  public animateScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  public showBlurLayer: boolean = false;

  public reset(): void {
    this.scaleX = 1;
    this.brightnessBlurOpacity = 1;
    this.shadowRadius = 0;
    this.isHover = false;
    this.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
    this.showBlurLayer = false;
  }
}

// instrument ignore next
@Observed
export class BackgroundOpacity {
  // 控制中心面板的透明度
  public backgroundOpacity: number = 1;
  // 横向亮度条透明度
  public horizontalBrightOpacity: number = 1;
  // 竖向亮度条透明度
  public verticalBrightOpacity: number = 1;

  public reset(): void {
    this.backgroundOpacity = 1;
    this.horizontalBrightOpacity = 1;
    this.verticalBrightOpacity = 1;
  }
}

// instrument ignore next
@Observed
export class BackgroundBlurOpacity {
  // 控制中心面板背板模糊的透明度
  public blurOpacity: number = 1;

  public reset(): void {
    this.blurOpacity = 1;
  }
}

// instrument ignore next
// 亮度条拖动相关参数，暂态值
@Observed
export class BrightnessDraggingViewData {
  public isDragging: boolean = false;
  // 范围: -25 ~ 331，包括亮度条超出范围的跟手位移距离
  public currentEndPositionX : number = 0;

  public reset(): void {
    this.isDragging = false;
    this.currentEndPositionX = 0;
  }
}

// instrument ignore next
// 亮度条进度值，常态值
@Observed
export class BrightnessProgress {
  public brightnessUIValue: number = 0;
}