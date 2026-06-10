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

export class CardUtils {
  /**
   * 卡片背景颜色
   */
  public static readonly ITEM_BG_COLOR = $r('app.color.live_view_card_action_bg_selected_color');

  /**
   * 卡片圆角
   */
  public static readonly ITEM_BG_RADIUS = $r('app.float.live_view_card_border_radius');

  /**
   * 卡片背景模糊半径
   */
  public static readonly ITEM_BG_BLUR = 30;

  /**
   * 进度的最大值
   */
  public static readonly MAX_PROGRESS = 100;

  /**
   * 深色模式富文本颜色
   */
  public static readonly DARK_RICH_CONTEXT_COLOR = 'rgba(255,255,255,0.6)';

  /**
   * 内描宽度
   */
  public static readonly BORDER_WIDTH_COLOR = 0.4;

  /**
   * 按钮宽度
   */
  public static readonly BUTTON_LENGTH = 40;

  /**
   * 三方进度背景色
   */
  public static readonly OTHER_PROGRESS_BLACK_COLOR = $r('app.color.live_view_other_progress_black_color')

  /**
   * 三方进度前景色
   */
  public static readonly OTHER_PROGRESS_COLOR = $r('app.color.live_view_other_progress_color')

  /**
   * 三方进度条最小节点数
   */
  public static readonly MIN_ICON_LENGTH = 2;

  /**
   * 卡片padding值
   */
  public static readonly LIVE_VIEW_CARD_PADDING = $r('app.float.live_view_card_padding');
}