/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
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