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
 * 音量条滑动动效参数
 */
// instrument ignore next
@Observed
export class VolumeAnimViewData {
  public scaleX: number = 1;
  public volumeBlurOpacity: number = 1;
  public shadowRadius: number = 0;
}

// instrument ignore next
@Observed
export class BackgroundOpacity {
  // 控制中心面板的透明度
  public backgroundOpacity: number = 1;
}

// instrument ignore next
@Observed
export class BlurOpacity {
  // 控制中心面板背板模糊的透明度
  public blurOpacity: number = 1;
}

// instrument ignore next
@Observed
export class VolumeDraggingViewData {
  public isDragging: boolean = false;
  // 范围: -25 ~ 331，包括音量条超出范围的跟手位移距离
  public currentEndPositionX: number = 0;
}

// instrument ignore next
@Observed
export class VolumeViewData {
  public volumeUIValue: number = 0;
  public isHover: boolean = false;
  public animateScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  public showBlurLayer: boolean = false;
}