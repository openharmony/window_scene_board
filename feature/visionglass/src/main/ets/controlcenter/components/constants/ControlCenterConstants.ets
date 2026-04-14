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

import { GlassLayoutColor } from '../../../common/constants/GlassLayoutConstants';

export class ControlCenterConstants extends GlassLayoutColor {
  public static FONT_WEIGHT = '700px';
  public static FULL_SIZE: Dimension = '100%';
  public static FONT_SIZE = '20px';
  public static CONTROL_CENTER_BACKGROUND_BACKDROP_BLUE = 360;
  // 胶囊与其中内容宽高比例
  public static CAPSULE_HEIGHT_SCALE: number = 0.116;
  public static CAPSULE_WIDTH_SCALE: number = 0.267;
  public static CIRCLE_NAME_TOP_MARGIN: number = 0.008;
  public static CAPSULE_ICON_BG_SIZE_SCALE: number = 0.089;
  public static CAPSULE_ICON_SIZE_SCALE: number = 0.052;
  // 滑动条
  public static SLIDER_HEIGHT_SCALE: number = 0.103;
  // 控制面板宽高比例
  public static BANNER_HEIGHT_SCALE: number = 0.57;
  public static BANNER_WIDTH_SCALE: number = 0.563;
  // 控制面板按钮色值
  public static BUTTON_BACKGROUND_COLOR: string = 'rgba(255, 255, 255, 0.7)';
  public static CAPSULE_OPEN_COLOR: string = 'rgb(10, 89, 247)';
  public static CAPSULE_CLOSE_COLOR: string = 'rgba(255, 0, 0, 0)';
  public static CAPSULE_ICON_OPEN_COLOR: string = '#ffffff';
  public static CAPSULE_ICON_CLOSE_COLOR: string = 'rgba(0, 0, 0, 0.7)';
}