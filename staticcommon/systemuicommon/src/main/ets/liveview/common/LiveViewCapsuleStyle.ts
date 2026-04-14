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
import DeviceInfo from '@ohos.deviceInfo';

const RATE: number = 1;
const isCYB: boolean = DeviceInfo.productSeries.includes('CYB');

export class LiveViewCapsuleStyle {
  /**
   * 单胶囊默认态，外边缘宽度
   */
  static readonly CAPSULE_BORDER_WIDTH: number = isCYB ? 84 : 86;
  /**
   * 多胶囊默认态，外边缘宽度
   */
  static readonly CAPSULE_STACK_BORDER_WIDTH: number = isCYB ? 76 : 78;
  /**
   * 胶囊拓展态，外边缘宽度
   */
  static readonly CAPSULE_EXTEND_BORDER_WIDTH: number = 128;
  /**
   * 胶囊高度
   */
  static readonly CAPSULE_HEIGHT: number = 28;
  /**
   * 外屏胶囊高度
   */
  static readonly OUTER_CAPSULE_HEIGHT: number = 24;
  /**
   * 单胶囊文本左右边距
   */
  static readonly CAPSULE_TEXT_MARGIN: number = 6;
  /**
   * 多胶囊文本左右边距
   */
  static readonly CAPSULE_TEXT_MARGIN_MUL: number = 4;

  /**
   * 胶囊主副文本默认间距
   */
  static readonly CAPSULE_TEXT_SPACE: number = 6;

  /**
   * 胶囊主文本区宽度
   */
  static readonly CAPSULE_MAIN_TEXT_WIDTH: number = isCYB ? 49 : 51;
  /**
   * 外屏胶囊主文本区宽度
   */
  static readonly OUTER_CAPSULE_MAIN_TEXT_WIDTH: number = 54;
  /**
   * 多胶囊胶囊主文本区宽度
   */
  static readonly CAPSULE_MAIN_TEXT_WIDTH_MUL: number = isCYB ? 45 : 47;
  /**
   * 外屏多胶囊胶囊主文本区宽度
   */
  static readonly OUTER_CAPSULE_MAIN_TEXT_WIDTH_MUL: number = 50;
  /**
   * 胶囊副文本区宽度
   */
  static readonly CAPSULE_EXTEND_TEXT_WIDTH: number = 36;
  /**
   * 外屏胶囊副文本区宽度
   */
  static readonly OUTER_CAPSULE_EXTEND_TEXT_WIDTH: number = 39;
  /**
   * 胶囊文本区高度
   */
  static readonly CAPSULE_TEXT_HEIGHT: number = 16;
  /**
   * 胶囊图片宽度
   */
  static readonly CAPSULE_IMAGE_WIDTH: number = 18;
  /**
   * 胶囊图片宽度vde fold
   */
  static readonly OUTER_CAPSULE_IMAGE_WIDTH: number = 16;
  /**
   * 胶囊图片高度
   */
  static readonly CAPSULE_IMAGE_HEIGHT: number = 18;
  /**
   * 胶囊图片宽度
   */
  static readonly CAPSULE_IMAGE_BORDER_WIDTH: number = 12;
  /**
   * 胶囊外边缘弧度
   */
  static readonly CAPSULE_RADIUS: number = 16;
  /**
   * 胶囊文字大小
   */
  static readonly TEXT_FONT_SIZE: number = 14;
  /**
   * 胶囊文字超出大小
   */
  static readonly TEXT_SMALL_FONT_SIZE: number = 12;
  /**
   * 胶囊文字左对齐
   */
  static readonly TEXT_MARGIN_LEFT: number = 10;
  /**
   * 胶囊图片左对齐 单胶囊
   */
  static readonly CAPSULE_ICON_LEFT_MARGIN: number = 5;
  /**
   * 外屏胶囊图片左对齐 单胶囊
   */
  static readonly OUTER_CAPSULE_ICON_LEFT_MARGIN: number = 4;
  /**
   * 胶囊图片左边距  多胶囊
   */
  static readonly CAPSULE_ICON_MARGIN_LEFT_MUL: number = 4;
  /**
   * 胶囊阴影默认边距
   */
  static readonly CAPSULE_SHADOW_LEFT_MARGIN: number = 8;
  /**
   * 胶囊阴影默认颜色
   */
  static readonly CAPSULE_SHADOW_COLOR_BLACK: string = '#4D000000';
  /**
   * 胶囊录屏阴影颜色
   */
  static readonly CAPSULE_SHADOW_COLOR_RED: string = '#66E84026';
  /**
   * 胶囊文字颜色
   */
  static readonly CAPSULE_TEXT_COLOR: string = '#FFFFFFFF';
  /**
   * 胶囊文字跑马灯步长
   */
  static readonly CAPSULE_TEXT_STEP: number = 2;
  /**
   * 胶囊文字跑马灯次数
   */
  static readonly CAPSULE_TEXT_LOOP: number = 2;

  /**
   * 胶囊默认背景色
   */
  static readonly CAPSULE_DEFAULT_BG_COLOR: string = '#FFFFFFFF';

  /**
   * 低层级胶囊强提醒时放大
   */
  static readonly CAPSULE_REMIND_SCALE_MAX: number = 1.1;

  /**
   * 低层级胶囊强提醒时缩小
   */
  static readonly CAPSULE_REMIND_SCALE_MIN: number = 0.9;

  /**
   * 低层级胶囊强提醒X轴偏移
   */
  static readonly CAPSULE_REMIND_TRANS_X: number = 11.5;

  /**
   * 低层级胶囊强提醒透明度
   */
  static readonly CAPSULE_REMIND_ALPHA: number = 0;

  static readonly FONT_FAMILY: string = 'HarmonyHeiTi';

  static readonly FONT_WEIGHT: FontWeight = FontWeight.Medium;

  /**
   * 胶囊距离时间间隔
   */
  static readonly CAPSULE_MARGIN: number = 2;
}