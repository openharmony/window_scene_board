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

export class GlassLayoutColor {
  public static readonly BORDER_COLOR: string = '#3F808080';
  public static readonly BACKGROUND_TOAST_COLOR: string = 'rgba(255, 255, 255, 0.8)';
  public static readonly BACKGROUND_REGULAR_COLOR: string = 'rgba(255, 255, 255, 0.6)';
  public static readonly TEXT_CONTENT_COLOR: string = 'rgba(0, 0, 0, 0.6)';
  public static readonly TEXT_TITLE_COLOR: string = 'rgba(0, 0, 0, 0.9)';
  public static readonly TEXT_TIME_COLOR: string = 'rgba(0, 0, 0, 0.4)';
  public static readonly TEXT_TOAST_COLOR: string = 'rgba(0, 0, 0, 0.9)';
  public static readonly STATUSBAR_COMPONENT_COLOR: string = '#303030';
  // 折叠类型消息折叠展开图标色值
  public static readonly NTF_EXPAND_ICON_COLOR: string = 'rgb(92,92,92)';
  public static readonly NTF_EXPAND_ICON_BG_COLOR: string = 'rgba(0, 0, 0, 0.05)'
}

export class GlassLayoutSize {
  // 面板阴影
  public static readonly SHADOW_BACKGROUND_REGULAR: ShadowOptions =
    { radius: 40, offsetY: 4, color: 'rgba(0, 0, 0, 0.2)' };
  // 图标尺寸
  public static readonly ICON_SIZE_58: string = '58px';
  public static readonly ICON_SIZE_64: string = '64px';
  public static readonly ICON_SIZE_80: string = '80px';
  public static readonly ICON_SIZE_66: string = '66.7px';
  // 字体大小行高尺寸
  public static readonly FONT_SIZE_24: string = '24px';
  public static readonly FONT_SIZE_28: string = '28px';
  public static readonly FONT_SIZE_32: string = '32px';
  public static readonly FONT_SIZE_33: string = '33px';
  public static readonly FONT_SIZE_36: string = '36px';
  public static readonly FONT_SIZE_37: string = '37px';
  public static readonly FONT_SIZE_72: string = '72px';
  // 字符间距
  public static readonly LETTERSPACING_SIZE_0: string = '0px';
  // 字体列表
  public static readonly HARMONYOS_SANS_SC: string = 'HarmonyOS Sans SC';
  // 字体粗细
  public static readonly FONT_WEIGHT_400: number = 400;
  public static readonly FONT_WEIGHT_500: number = 500;
  public static readonly FONT_WEIGHT_700: number = 700;
  // 折叠类型消息 折叠图标
  public static readonly NTF_EXPAND_ICON_HEIGHT: string = '10px';
  public static readonly NTF_EXPAND_ICON_WIDTH: string = '20px';
  public static readonly NTF_EXPAND_ICON_BG_SIZE: string = '40px';
}

export class NtfColor {
  // 文字内容色值
  public static readonly NTF_TITLE_FONT_COLOR: string = 'rgba(0, 0, 0, 0.9)';
  public static readonly NTF_CONTENT_FONT_COLOR: string = 'rgba(0, 0, 0, 0.6)';
  // 折叠类型消息折叠展开图标色值
  public static readonly NTF_EXPAND_ICON_COLOR: string = 'rgb(92,92,92)';
  public static readonly NTF_EXPAND_ICON_BG_COLOR: string = 'rgba(0, 0, 0, 0.05)';
  // 短信类型消息按钮文字色值
  public static readonly NTF_BUTTON_FONT_COLOR: string = 'rgba(0, 0, 0, 0.9)';
  public static readonly NTF_TIME_FONT_COLOR: string = 'rgba(0, 0, 0, 0.4)';
  public static readonly NTF_BACKGROUND_COLOR: string = 'rgba(255, 255, 255, 0.6)';
  public static readonly NTF_DIVIDER_COLOR: string = 'rgba(255, 255, 255, 0.5)';
  public static readonly NTF_CLEAR_BUTTON_COLOR: string = 'rgba(0, 0, 0, 0.3)';
  public static readonly NTF_COLLAPSE_NUM_COLOR: string = 'rgba(0, 0, 0, 0.6)';
  public static readonly NTF_COLLAPSE_NUM_BG_COLOR: string = 'rgba(0, 0, 0, 0.05)';
  public static readonly NTF_TITLE_TIME_COLOR: string = 'rgba(255, 255, 255, 0.6)';
  public static readonly NTF_TITLE_DATE_COLOR: string = 'rgba(255, 255, 255, 0.6)';
}

export class NtfSize {
  public static readonly NTF_TITLE_DATE_FONT_SIZE: string = '24px';
  public static readonly NTF_COLLAPSE_NUM_BUTTON_HEIGHT: Length = '30px';
  public static readonly NTF_COLLAPSE_NUM_BUTTON_WIDTH: Length = '60px';
  public static readonly NTF_COLLAPSE_NUM_BUTTON_BORDER_RADIUS: Length = '30px';
  public static readonly NTF_GROUP_ITEM_BORDER_RADIUS: number = 0;
  public static readonly NTF_BUTTON_ITEM_BLUR: number = 280;
  public static readonly NTF_TITLE_BOTTOM_MARGIN: string = '35px';
  public static readonly NTF_TITLE_FONT_WEIGHT: number = 600;
  public static readonly NTF_CONTENT_FONT_WEIGHT: number = 500;
  public static readonly NTF_HIDE_CONTENT_WIDTH: string = '70%';
  public static readonly NTF_SINGLE_ITEM_HEIGHT: string = '38px';
  public static readonly NTF_BUTTON_DISTANCE: string = '30px';
  // 通知与横幅图标size
  public static readonly APP_ICON_SIZE: string = '29px';
  public static readonly CLEAR_BG_SIZE: string = '96px';
  // 简化来电图标size
  public static readonly HINT_CALL_APP_SIZE: string = '32px';
}

export class GlassToastCommon {
  // TOAST底部距离
  public static readonly TOAST_BOTTOM: number = 300;
  // TOAST显示时长
  public static readonly TOAST_DURATION: number = 3000;
}

export class NtfToastCommon extends GlassToastCommon {
  public static CAN_NOT_OPEN_MSG: ResourceStr = $r('app.string.banner_toast_message');
  public static CAN_NOT_OPEN_MSG_WID: number = 800;
}

export class GlassInputToastCommon extends GlassToastCommon {
  public static INPUT_METHOD_PROMPT: ResourceStr = $r('app.string.Input_prompt');
  public static INPUT_METHOD_PROMPT_WID: number = 1300;
}

export class GlassAppWhiteListToastCommon extends GlassToastCommon {
  public static ADD_APP_TO_GLASS_WID: number = 800;

  public static getAddMsg(appName: string): ResourceStr {
    return $r('app.string.add_app_to_glass_msg', appName);
  }
}
