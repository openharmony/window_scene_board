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

// 沉浸卡片模块常量
export enum ImmersiveCardConst {
  CARD_RADIUS = 32, // 卡片圆角
  CARD_LR_PADDING = 16, // 卡片左右边距
  // 小外屏卡片圆角
  CARD_RADIUS_SMALL_FOLD = 20,
  // 截图缩放值
  SCREEN_SNAPSHOT_SCALE = 0.1,
  // 小外屏卡片外边距
  CARD_MARGIN_SMALL_FOLD = 24,
  // 小外屏授权页提示语与卡片顶部外边距
  CARD_NO_PERMISSION_MARGIN_SMALL_FOLD = 63,
  // 截图取色定时器时间
  GET_COLOR_DEGREE_TIME = 500,
  // 截图取色获取颜色错误码
  ERROR_LIGHT_COLOR_DEGREE_PICTURE = 404,
  // 状态栏取色上边距
  STATUS_BAR_OFFSET_Y = 0,
}

// 小外屏沉浸卡片返回按钮参数
export enum ImmersiveCardBackButtonParam {
  BACKGROUND_DIAMETER = 28,
  BACKGROUND_OPACITY = 0.1,
  ARROW_SIZE = 16,
  MARGIN_TOP = 36,
  MARGIN_BOTTOM = 264,
  MARGIN_START = 16,
  MARGIN_END = 284,
  BLUR_NUM = 50,
  EFFECT_RADIUS = 10,
  EFFECT_BRIGHTNESS = 1.01,
  BUTTON_RADIUS = 14,
  // 返回按钮透明度动效时长
  BACK_BTN_OPACITY_DURATION = 300
}

// 沉浸卡片UIExtention正在加载组件常量
export class ImmersiveCardUIExtentionNoLocationConst {
  /**
   * 图片尺寸
   */
  public static readonly IMG_SIZE = 94;
  /**
   * 小外屏上边距
   */
  public static readonly MARGIN_TOP = 48;
  /**
   * 图片和文字间距
   */
  public static readonly IMG_TEXT_SPACE = '8vp';
}

// 卡片的UI占位属性
export enum ImmersiveCardNameParam {
  DEFAULT_ITEM = 'defaultItem',
  ANIM_ITEM = 'animItem',
}