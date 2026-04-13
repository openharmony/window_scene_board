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

/**
 * 控制中心下拉收起动效参数
 */
// instrument ignore next
@Observed
export class ControlCenterAnimationData {
  /**
   * 控制中心元素进出场缩放
   */
  public scale: number;
  /**
   * 控制中心元素进出场透明度
   */
  public opacity: number;
  /**
   * 控制中心元素进出场位移
   */
  public translate: number;
  /**
   * 控制中心元素跟手位移
   */
  public itemTranslate: number;

  constructor(scale: number, opacity: number, translate: number, itemTranslate: number) {
    this.scale = scale;
    this.opacity = opacity;
    this.translate = translate;
    this.itemTranslate = itemTranslate;
  }
}

// instrument ignore next
@Observed
export class AnimationDataArray extends Array<ControlCenterAnimationData> {
}