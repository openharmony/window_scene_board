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

import image from '@ohos.multimedia.image';
import curves from '@ohos.curves';

export class StartAbilityOverlayAnimateConstants {
  // mainLayout param
  public static readonly MAIN_LAYOUT_SCALE: number = 0.88; // 控制中心面板缩放变化终点参数
  public static readonly MAIN_LAYOUT_OPACITY: number = 0.2; // 控制中心透明度变化终点参数
  public static readonly MAIN_LAYOUT_ANIM_TIME: number = 167; // 控制中心淡出动效时长
  public static readonly MAIN_LAYOUT_STAY_TIME: number = 600; // 控制中心停留下拉状态时长

  // app window param
  public static readonly APP_WINDOW_OPACITY_TIME: number = 166; // 透明度变化动效时长
  public static readonly APP_WINDOW_CURVE: ICurve = curves.interpolatingSpring(0, 1, 439, 48); // 应用窗口展开动画曲线
  public static readonly APP_WINDOW_BORDER_RADIUS_TIME: number = 166; // 圆角变化动效时长
  public static readonly APP_WINDOW_MASK_COLOR: ResourceColor = '#66000000'; // 应用窗口上方蒙层颜色
  public static readonly APP_WINDOW_MASK_STAY_TIME: number = 166; // 应用窗口上方蒙层停留持续时长

  // icon param
  public static readonly ICON_OPACITY_TIME: number = 83; // icon透明度变化动效时长
  public static readonly ICON_BORDER_RADIUS: number = 20; // icon圆角初始值
}

/**
 * 跳转应用动效-控制中心部分的动效参数
 */
// instrument ignore next
@Observed
export class StartAbilityOverlayAnimateData {
  public mainLayoutScale: number = 1;

  public mainLayoutOpacity: number = 1;

  // 是否阻止监听startAbility之后进行的收起动效
  public shouldInterceptHideAnim: boolean = false;

  // 跳转应用过程中是否需要遮挡底部内容
  public shouldCoverBelow: boolean = false;

  // 用于遮盖下方内容的截图
  public snapshot?: image.PixelMap;

  // 恢复初始值
  initData() {
    this.mainLayoutScale = 1;
    this.mainLayoutOpacity = 1;
    this.shouldCoverBelow = false;
    this.shouldInterceptHideAnim = false;
    if (this.snapshot) {
      this.snapshot.release();
    }
    this.snapshot = undefined;
  }
}