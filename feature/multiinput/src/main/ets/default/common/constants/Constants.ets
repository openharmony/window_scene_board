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

export class Constants {
  // 提示面板宽度
  public static readonly PANNEL_WIDTH = 1380;
  // 提示面板高度
  public static readonly PANNEL_HEIGHT = 969;
  // 提示面板宽度 - Hopper悬浮态
  public static readonly PANNEL_WIDTH_HALF_FOLD = 1106;
  // 提示面板高度 - Hopper悬浮态
  public static readonly PANNEL_HEIGHT_HALF_FOLD = 745;
  // 列间距
  public static readonly COLUMN_INTERVAL = 48;
  // 列间距
  public static readonly COLUMN_INTERVAL_HALF_FOLD = 32;
  // 平板快捷键窗口宽度
  public static readonly PAD_PANEL_WIDTH = 906;
  // 平板快捷键窗口高度
  public static readonly PAD_PANEL_HEIGHT = 384;
  // 平板快捷键窗口背景宽度
  public static readonly PAD_COLUMN_WIDTH = 381;
  // 平板快捷键窗口背景宽度
  public static readonly PAD_COLUMN_SEGMENT_BUTTON_WIDTH = 301;
  // 平板快捷键窗口背景宽度
  public static readonly PAD_COLUMN_SEGMENT_BUTTON_HEIGHT = 40;
  // 平板快捷键flex和窗口间隔宽度
  public static readonly PAD_PANEL_BOTTOM_SPACE_HEIGHT = 24;
  // 平板快捷键窗口底部间隔宽度
  public static readonly PAD_PANEL_FLEX_TOP_SPACE_HEIGHT = 8;
  public static readonly DEFAULT_2 = 2;
  public static readonly DEFAULT_3 = 3;
  public static readonly DEFAULT_4 = 4;
  // 快捷键窗口中间部分间距
  public static readonly COLUMN_MARGIN = 48;
  // 双快捷键描述文字宽度
  public static readonly DOUBLE_SHORTCUT_KEY_ITEM_WIDTH = 260;
  // 双快捷键描述文字宽度 - Hopper悬浮态
  public static readonly DOUBLE_SHORTCUT_KEY_ITEM_HF_WIDTH = 220;
  // 单快捷键描述文字宽度
  public static readonly SINGLE_SHORTCUT_KEY_ITEM_WIDTH = 172;
  // 走焦方向键宽度
  public static readonly DIRECTIONAL_KEY_WIDTH = 144;
  // 走焦方向键宽度 - Hopper悬浮态
  public static readonly DIRECTIONAL_KEY_WIDTH_HALF_FOLD = 120;
  // 全局搜索框位置
  public static readonly HISEARCH_TEXT_MARGIN_LEFT = 265;
  public static readonly HISEARCH_TEXT_MARGIN_TOP = 145;
  // 关闭按钮背景圆圈宽度
  public static readonly CLOSE_BTN_CIRCLE_BCOLOR_WIDTH = '24vp';
  // 闭按钮背景圆圈高度
  public static readonly CLOSE_BTN_CIRCLE_BCOLOR_HEIGHT = '24vp';
  public static readonly PCSETTING_SYSTEM_BASIC_PERMISSION:string = 'ohos.permission.ACCESS_SYSTEM_SETTINGS';
  public static readonly PCSETTING_BUNDLENAME:string = 'com.ohos.pcsettings';
  public static readonly SETTING_BUNDLE_NAME:string = 'com.ohos.settings';
  public static readonly DESK_GESTURE_KEY: string = 'settings.deskGesture.switch';
  public static readonly DEFAULT_DESK_GESTURE_PARAM: number = 31;
  // 任务中心和应用中心切换定时器
  public static readonly RECENT_AND_APP_CENTER_SWITCH_TIMER: string = 'recentAndAppCenterSwitchTimer';
  // 麦克风提示语宽度 - 最大宽度为400（字体语言自适应）
  public static readonly MIC_REMINDER_WIDTH = 400;
  // 麦克风提示语高度
  public static readonly MIC_REMINDER_HEIGHT = 88;
  // 麦克风提示语边距
  public static readonly MIC_REMINDER_MARGIN = 32;
  // 麦克风提示语消失时间
  public static readonly MIC_REMINDER_TIMEOUT_SHORT = 2000;
  // 麦克风提示语底部与dock的距离
  public static readonly MIC_REMINDER_BOTTOM_PADDING = 60;
  // 麦克风提示语底部与Pad屏幕底部的距离
  public static readonly MIC_REMINDER_BOTTOM_PADDING_PAD = 141;
  // 麦克风提示语浅色模式模糊
  public static readonly MIC_REMINDER_BLUR_RADIUS_LG = 100;
  // 麦克风提示语深色模式模糊
  public static readonly MIC_REMINDER_BLUR_RADIUS_DK = 120;
  // 状态栏高度
  public static readonly STATUS_BAR_HEIGHT = 40;
  // 扩展屏缩放比例
  public static readonly EXTEND_SCREEN_SCALED_RATIO = 0.8;
  // 默认缩放比例
  public static readonly DEFAULT_SCALED_RATIO = 1;

  public static readonly SCENE_BOARD_BUNDLE_NAME = 'com.ohos.sceneboard';

  public static readonly FORM_EDIT_ABILITY_NAME = 'FormEditAbility';
}

export enum SCBFoldState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
};

export default Constants;