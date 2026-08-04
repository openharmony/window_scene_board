/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
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