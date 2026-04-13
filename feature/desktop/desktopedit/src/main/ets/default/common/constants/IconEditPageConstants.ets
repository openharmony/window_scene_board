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
import { StyleConstants } from '@ohos/launchercommon';

/**
 * 编辑模式图标编辑常量类
 */
export default class IconEditPageConstants {
  /**
   * EditModeIconAbilityPhone Ability名称
   */
  public static readonly EDIT_MODE_ICON_ABILITY_NAME: string = 'EditModeIconAbilityPhone';

  /**
   * 图标编辑页面卡片margin
   */
  public static readonly BOTTOMSHEET_LABEL_MARGIN: number = 12;

  /**
   * 图标编辑页面标题margin
   */
  public static readonly BOTTOMSHEET_TITLE_MARGIN: number = 8;

  /**
   * 图标编辑页面label高度
   */
  public static readonly BOTTOMSHEET_LABEL_HEIGHT: number = 48;

  /**
   * 图标编辑页面标题栏高度
   */
  public static readonly ICON_EDIT_TITLE_HEIGHT: number = 56;

  /**
   * 图标风格每块的间距
   */
  public static readonly ICON_STYLE_SCROLL_SPACE: number = 10;

  /**
   * bottomSheet 高度
   */
  public static readonly BOTTOM_SHEET_HEIGHT: number = 418;

  /**
   * bottomSheet scroll 的高度
   */
  public static readonly BOTTOM_SHEET_SCROLL_HEIGHT: number = 340;

  /**
   * bottomSheet 图标风格大小
   */
  public static readonly ICON_STYLE_BUTTON_SIZE: number = 100;

  /**
   * bottomSheet 滑动条高度
   */
  public static readonly SLIDER_SLIDER_HEIGHT: number = 20;

  /**
   * bottomSheet 滑动条底部margin
   */
  public static readonly CUSTOMSLIDER_SLIDER_MARGIN_BOTTOM: number = 18;

  /**
   * bottomSheet 滑动条左右margin
   */
  public static readonly CUSTOMSLIDER_SLIDER_MARGIN: number = 6;

  /**
   * bottomSheet 上下边缘margin
   */
  public static readonly BOTTOM_SHEET_LABEL_INNER_MARGIN: number = 17;

  /**
   * bottomSheet应用按钮上 下padding
   */
  public static readonly APPLY_BUTTON_PADDING: number = 11;

  /**
   * bottomSheet应用按钮margin top
   */
  public static readonly APPLY_BUTTON_MARGIN_TOP: number = 16;

  /**
   * bottomSheet应用按钮margin bottom
   */
  public static readonly APPLY_BUTTON_MARGIN_BOTTOM: number = 28;

  /**
   * 图标大小最小值
   */
  public static readonly APP_IMAGE_SIZE_MIN: number = -6;

  /**
   * 图标大小最大值
   */
  public static readonly APP_IMAGE_SIZE_MAX: number = 8;

  /**
   * 图标大小调节step
   */
  public static readonly APP_IMAGE_SIZE_STEP: number = 0.01;

  /**
   * 图标大小默认值
   */
  public static readonly APP_IMAGE_SIZE_DEFAULT: number = 0;

  /**
   * 图标大小小值索引
   */
  public static readonly APP_IMAGE_SIZE_SMALL_INDEX: number = 0;

  /**
   * 图标大小标准索引
   */
  public static readonly APP_IMAGE_SIZE_NORMAL_INDEX: number = 1;

  /**
   * 图标大小大值索引
   */
  public static readonly APP_IMAGE_SIZE_LARGE_INDEX: number = 2;

  /**
   * 图标大小默认值范围
   */
  public static readonly APP_IMAGE_CIRCLE_SIZE: number = 4;

  /**
   * BindSheet title padding
   */
  public static readonly BIND_SHEET_TITLE_PADDING: number = 5;

  /**
   * 图标风格选中边框
   */
  public static readonly ICON_STYLE_BUTTON_BORDER_WIDTH: number = 2;

  /**
   * 图标风格中的图标大小
   */
  public static readonly ICON_STYLE_BUTTON_INNER_ICON_SIZE: number = 28;

  /**
   * 图标风格中的图标圆角大小
   */
  public static readonly ICON_STYLE_BUTTON_INNER_RADIUS: number = 8;

  /**
   * 图标风格中的图标margin
   */
  public static readonly ICON_STYLE_BUTTON_INNER_MARGIN: number = 12;

  /**
   * 图标风格中多选框大小
   */
  public static readonly ICON_EDIT_CHECKBOX_SIZE: number = 20;

  /**
   * 图标风格中多选框距离右边框margin
   */
  public static readonly ICON_EDIT_CHECKBOX_MARGIN_RIGHT: number = 8;

  /**
   * 图标风格中多选框大小
   */
  public static readonly ICON_EDIT_BACK_ICON_SIZE: number = 40;

  /**
   * 图标风格中多选框大小
   */
  public static readonly ICON_EDIT_BACK_IMAGE_SIZE: number = 24;

  /**
   * BOTTOM SHEET 圆角
   */
  public static readonly BOTTOM_SHEET_RADIUS: number = 32;

  /**
   * 图标名称大小
   */
  public static readonly ICON_NAME_TEXT_SIZE: number = 12;

  /**
   * 简易布局图标名称大小
   */
  public static readonly ICON_NAME_TEXT_SIZE_SIMPLE: number = 18;

  /**
   * 默认icon path
   */
  public static readonly PREVIEW_PATH_DEFAULT: string = '/sys_prod/resource/themes/icon/Icon_01';

  /**
   * 应用按钮宽度
   */
  public static readonly APPLY_BUTTON_WIDTH: number = 448;

  /**
   * 折叠屏展开态、PAD loading的宽度
   */
  public static readonly FOLD_PAD_DIALOG_WIDTH: number = 432;

  /**
   * 小屏幕宽度
   */
  public static readonly GRID_SMALL_SIZE: number = 600;

  /**
   * 中屏幕宽度
   */
  public static readonly GRID_MEDIUM_SIZE: number = 840;

  /**
   * 大屏幕宽度
   */
  public static readonly GRID_LARGE_SIZE: number = 1440;

  public static readonly PREVIEW_ICONS_HEIGHT: number = 256;
  public static readonly PREVIEW_ICONS_MARGIN_BOTTOM: number = 14;
  public static readonly PREVIEW_ICONS_SIZE_TEXT_PADDING: number = 15;
  public static readonly ICONSTYLE_BUTTON_LABEL_MARGIN_TOP: number = 8;
  public static readonly ICONSTYLE_BUTTON_LABEL_MARGIN: number = 16;
  public static readonly BOTTOMSHEET_HEADER_MARGIN_BOTTOM: number = 8;
  public static readonly BOTTOMSHEET_LABEL_PADDING: number = 16;
  public static readonly BOTTOMSHEET_HEIGHT: number = 455;
  public static readonly BOTTOMSHEET_TOGGLE_WIDTH: number = 36;
  public static readonly BOTTOMSHEET_TOGGLE_HEIGHT: number = 20;
  public static readonly FAKEICON_ICON_ADAPTIVE: number = 1.5;

  /**
   * 图标风格栏小图标描边颜色
   */
  public static readonly FAKEICON_ICON_BORDER_COLOR: string = '#33808080';

  /**
   * 图标风格栏小图标描边宽度
   */
  public static readonly FAKEICON_ICON_BORDER_WIDTH: number = 0.5;

  /**
   * 图标预览区域文本大小边界，与AppName保持一致
   */
  public static readonly FAKEICON_ICON_NAME_MAX_SIZE: number = 1.45;

  public static readonly SPACE_OF_COLUMN: number = StyleConstants.DEFAULT_FOLD_PHONE_EXPANDED_LANDSCAPE_COLUMN_GAP;

  // 半模态标题高度
  public static readonly BINDSHEET_TITLE_HEIGHT: number = 56;
}