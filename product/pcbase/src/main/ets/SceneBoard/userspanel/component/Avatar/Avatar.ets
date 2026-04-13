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

import { AvatarVM } from './AvatarViewModel';

const TAG = 'UserPanel-Avatar';

/**
 * 自定义头像组件
 * @since 2024-07-25
 */
@Component
export struct Avatar {
  @ObjectLink vm: AvatarVM;

  @Builder
  ImageBuilder() {
    Image(this.vm.src)
      .autoResize(false)
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
      .size({
        width: this.vm.imgSize,
        height: this.vm.imgSize
      })
      .margin({
        right: $r('sys.float.margin_left_none'),
        bottom: $r('sys.float.margin_right_none'),
      })
      .clip(new Circle({ width: this.vm.imgSize, height: this.vm.imgSize }))
  }

  @Builder
  BadgeBuilder() {
    Circle()
      .attributeModifier(this.vm.badgeModifier)
  }

  build() {
    Stack() {
      this.ImageBuilder()
      this.BadgeBuilder()
    }
    .align(Alignment.BottomEnd)
  }
}

export * from './AvatarViewModel';