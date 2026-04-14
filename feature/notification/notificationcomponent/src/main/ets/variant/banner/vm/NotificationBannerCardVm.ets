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
import { NotificationCardVm } from '../../../viewmodel/NotificationCardVm';
import { BannerVm, INotificationCardVm } from '@ohos/systemuicommon/newIndex';
import { hideBannerNtfContentObj } from '../../../model/HideBannerNtfContentObj';
import { BannerShowStatusModel } from '@ohos/systemuicommon/src/main/ets/notification/model/BannerShowStatusModel';

@ObservedV2
export class NotificationBannerCardVm extends NotificationCardVm implements INotificationCardVm {
  /**
   * 卡片ZIndex，横幅设为0，避免盖住下拉横条
   */
  @Trace public zIndex: number = 0;

  /**
   * 圆角裁剪，横幅通知卡片不需要裁剪
   */
  @Trace public containerClip: boolean | RectAttribute = false;

  /**
   * 基类onOpacityChange带有onMonitor注解, 无法被覆写, 触发时, 会调用cardClip, 修改containerClip.
   * 通过覆写cardClip, 阻止横幅场景下containerClip被修改.
   */
  protected cardClip(): void {
    return;
  }

  /**
   * 卡片背景颜色
   */
  @Computed get cardBgColor(): ResourceColor {
    return this.vmInjector.getColorVm().bannerCardBgColor;
  }

  /**
   * 卡片提亮参数
   */
  @Computed get cardBgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().bannerCardBgBrightness;
  }

  @Computed get isPrivacy(): boolean {
    if (super.isPrivacy) {
      return super.isPrivacy;
    }
    return hideBannerNtfContentObj.isUseSwing() && !BannerShowStatusModel.instance.isShow;
  }

  @Computed get cardWidth(): number | string {
    if (this.vmInjector.getVerticalSwipeVm()?.isDeformFlag) {
      return '100%';
    } else {
      return this.vmInjector.getPanelVm().cardWidth;
    }
  }

  /**
   * 获取通知卡片转场动效
   *
   * @returns 动效参数
   */
  getTransitionAnimation(): TransitionEffect {
    return TransitionEffect.IDENTITY;
  }

  /**
   * 卡片模糊参数
   */
  public cardBgEffect: BackgroundEffectOptions | undefined = this.vmInjector.getColorVm().bannerBgEffect;

  @Computed get shadow(): ShadowStyle | undefined {
    if (this.ntf.isHeadsUp) {
      return ShadowStyle.OUTER_DEFAULT_MD;
    }
    return undefined;
  }

  /**
   * 横幅使用的卡片手势在根组件统一设置
   */
  public needGesture: boolean = false;

  /**
   * 卡片背景模糊
   */
  public cardBgBlurStyle: BlurStyle | undefined = this.vmInjector.getColorVm().bannerBgBlurStyle;

  onTouch(): void {}
}