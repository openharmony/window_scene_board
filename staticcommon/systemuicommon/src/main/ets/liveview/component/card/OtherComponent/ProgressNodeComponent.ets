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
import { LiveButtonData } from '../../../data/extend/LiveButtonData';

/**
 * 扩展区为进度可视化模板组件：进度条节点数组成员
 */
@Component
export struct ProgressNodeComponent {
  @ObjectLink nodeIcon: LiveButtonData;

  build() {
    if (this.nodeIcon) {
      Image(this.nodeIcon?.icon)
        .width('12vp')
        .height('12vp')
        .objectFit(ImageFit.Contain)
        .margin({
          left: 4,
          bottom: 4,
          top: 4,
          right: 4
        })
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
    }
  }
}