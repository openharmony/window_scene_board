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

/**
 * 语音助手建议常量
 */
export class AiSuggestionConstants {
  // 默认格子数
  public static readonly DEFAULT_SCENE_SPAN = 2;

  // 场景模式默认宽
  public static readonly DEFAULT_PORTFOLIO_INFO_WIDTH = 150;

  // 场景模式默认高
  public static readonly DEFAULT_PORTFOLIO_INFO_HEIGHT = 156;

  // 描述默认字体大小
  public static readonly DEFAULT_DESC_FONT_SIZE = 20;

  // 标题默认字体大小
  public static readonly DEFAULT_TITLE_FONT_SIZE = 10;

  // 场景卡类型为2
  public static readonly TYPE_PORTFOLIO_CARD = 2;

  // 默认图标大小
  public static readonly ICON_DEFAULT_SIZE = 58;

  // 折叠屏横屏图标大小
  public static readonly ICON_LANDSCAPE_SIZE = 48;

  // 无效index
  public static readonly INVALID_INDEX = -1;

  // 语音助手建议子元素动画进/退场时间(ms)
  public static readonly ITEM_TRANSITION_TIME = 500;

  // 语音助手建议元素进昌透明度起始值,退场透明度终点值
  public static readonly ITEM_TRANSITION_TARGET_OPACITY = 0.001;

  // 一天的毫秒数
  public static readonly ONE_DAY_MILL = 86400000;

  // 一个小时的毫秒数
  public static readonly ONE_HOUR_MILL = 3600000;

  // 一分钟的毫秒数
  public static readonly ONE_MINUTE_MILL = 60000;

  // 一秒的毫秒数
  public static readonly ONE_SECOND_MILL = 1000;

  // 一周的天数，从0算起
  public static readonly ONE_WEEK_DAYS = 6;

  // 数组长度 2
  public static readonly ARRAY_LENGTH_TWO = 2;

  // 语音助手建议卡片的刷新次数
  public static readonly AI_SUGGESTION_REFRESH_TIMES = 'ai_suggestion_refresh_times';

  // 语音助手建议卡片重新尝试写入RDB的定时器时长
  public static readonly AI_SUGGESTION_REWRITE_TIME = 200;

  // 常规卡ID
  public static readonly PORTFOLIO_ID_DEFAULT = 'default';

  // 应用类型
  public static readonly TYPE_APP = 0;

  // 卡片类型
  public static readonly TYPE_CARD = 1;

  // 应用组类型
  public static readonly TYPE_APP_GROUP = 3;

  // 堆叠轮转
  public static readonly TYPE_RECOMMEND_CARD = 4;

  public static readonly FORM_WANT_INFO = 'formWantInfo';

  public static readonly REC_INFO = 'recInfo';

  // 动画刷新执行时长
  public static readonly REFRESH_ANIM_DURATION = 450;

  // 外屏标识
  public static readonly EXTERNAL_SCREEN: string = 'External';

  // 长按响应选中当前服务时长
  public static readonly LONG_PRESS_SELECT_ITEM_DURATION: number = 400;

  // 长按响应选中当前服务截图时长
  public static readonly LONG_PRESS_SELECT_ITEM_SNAP_DURATION: number = 450;

  // 长按选中透明度
  public static readonly ITEM_SELECTED_OPACITY = 1.0;

  // 长按未选中透明度
  public static readonly ITEM_NORMAL_OPACITY = 0.4;

  /**
   * 语音助手建议包名
   */
  public static readonly AI_SUGGESTION_BUNDLE_NAME = 'com.ohos.suggestion';

  /**
   * 语音助手建议abilityName
   */
  public static readonly AI_SUGGESTION_ABILITY_NAME = 'ParentFormAbility';

  /**
   * 应用组的columnGap值
   */
  public static APP_GROUP_COLUMN_GAP = 5.72;

  /**
   * 应用组默认图标大小
   */
  public static APP_GROUP_DEFAULT_ICON_SIZE = 42.64;

  /**
   * vde外屏图标大小
   */
  public static SMALL_FOLD_OUTER_ICON_SIZE = 52;

  /**
   * vde默认图标圆角
   */
  public static SMALL_FOLD_DEFAULT_ICON_RADIUS = 15.03;

  /**
   * vde外屏图标圆角
   */
  public static SMALL_FOLD_OUTER_ICON_RADIUS = 13.48;
}

/**
 * 语音助手建议长按类型
 */
export enum LongPressType {
  DEFAULT,

  GET_WALLPAPER,

  SHOW_WALLPAPER,

  SELECTED_ITEM,
}