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

interface IAvatarConfig {
  src?: ResourceStr;
  imgSize?: number;
  badge?: boolean;
}

/**
 * Avatar 组件的 ViewModel 类
 * @since 2024-07-25
 */
@Observed
export class AvatarVM {
  public static DEFAULT_IMG_SIZE: number = 48;
  public static DEFAULT_IMG_SRC: Resource = $r('app.media.ic_user_head_portrait');
  public static BADGE_SCALE: number = 0.25; // 角标相对图像的大小比例

  public src: ResourceStr;
  public imgSize: number;
  public badge: boolean;
  public readonly badgeModifier: AvatarBadgeModifier = new AvatarBadgeModifier();

  constructor(config: IAvatarConfig) {
    this.src = config.src || AvatarVM.DEFAULT_IMG_SRC;
    this.imgSize = config.imgSize || AvatarVM.DEFAULT_IMG_SIZE;
    this.badge = config.badge || false;
    this.badgeModifier.diameter = this.imgSize;
    this.badgeModifier.visible = this.badge;
  }
}

export class AvatarBadgeModifier implements AttributeModifier<CircleAttribute> {
  public scale: number = AvatarVM.BADGE_SCALE;
  public diameter: number = AvatarVM.DEFAULT_IMG_SIZE;
  public visible: boolean = true;
  public fill: ResourceColor = $r('sys.color.confirm');
  public stroke: ResourceColor | undefined = $r('sys.color.icon_on_primary');
  public strokeWidth: Length | undefined = 2;

  applyNormalAttribute(instance: CircleAttribute): void {
    instance.size({
      width: this.diameter * this.scale,
      height: this.diameter * this.scale,
    });
    instance.visibility(this.visible ? Visibility.Visible : Visibility.Hidden);
    instance.fill(this.fill);
    instance.stroke(this.stroke);
    instance.strokeWidth(this.strokeWidth);
  }
}