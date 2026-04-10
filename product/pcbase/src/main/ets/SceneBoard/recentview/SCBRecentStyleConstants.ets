/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

import curves from '@ohos.curves';

export class SCBRecentStyleConstants {

  // image resources
  public static readonly DEFAULT_BG_COLOR = '#00000000';
  public static readonly DEFAULT_APP_ICON_IMAGE: Resource = $r('app.media.icon');
  public static readonly DEFAULT_APP_IMAGE: Resource = $r('app.media.img_app_default');
  public static readonly DEFAULT_APP_IMAGE_PATH: string = '/common/pics/img_app_default.png';
  public static readonly DEFAULT_LOCKED_IMAGE = '/common/pics/ic_public_lock.svg';
  public static readonly DEFAULT_CLOSE_IMAGE: Resource = $r('sys.symbol.xmark');
  public static readonly DEFAULT_CLOSE_COLOR: ResourceColor[] = [$r('sys.color.ohos_id_color_primary_contrary')];

  // font style resources
  public static readonly DEFAULT_FONT_COLOR = '#ffffff';
  public static readonly DEFAULT_FONT_SIZE = 20;
  public static readonly DEFAULT_APP_NAME_SIZE = 16;
  public static readonly DOUBLE_LIST_DEFAULT_APP_ICON_SIZE = 32;
  public static readonly LOCK_CLOSE_ICON_SIZE = 20;
  public static readonly SESSION_SHADOW_SPACE_SIZE = 16;
  public static readonly SESSION_OUTER_SIZE = 2;
  public static readonly DEFAULT_NAME_LINE = 1;
  public static readonly SPLIT_UP_DOWN_SPACE = 10;
  public static readonly HOVER_VIEW_PADDING = 8;

  // image size resources
  public static readonly DEFAULT_APP_IMAGE_WIDTH = 564;
  public static readonly DEFAULT_APP_IMAGE_HEIGHT = 352;
  public static readonly DEFAULT_APP_RADIO =
    SCBRecentStyleConstants.DEFAULT_APP_IMAGE_WIDTH / SCBRecentStyleConstants.DEFAULT_APP_IMAGE_HEIGHT;

  // style resources
  public static readonly APP_NAME_MARGIN = 8;
  public static readonly RECENT_SHADOW_RADIUS = 16;
  public static readonly GRADUALLY_HIDE_AREA = 80;
  public static readonly PC_USABLE_WIDTH = 0.84;
  public static readonly PC_USABLE_WIDTH_HPR = 0.8;
  public static readonly CARD_MAX_HEIGHT_PERCENT = 0.4;
  public static readonly CARD_MAX_HEIGHT_PERCENT_VERTICAL = 0.2;
  public static readonly CARD_MIN_HEIGHT_PERCENT = 0.18;
  public static readonly CARD_MIN_HEIGHT_PERCENT_HORIZONTAL = 0.13;
  public static readonly CARD_MIN_HEIGHT_PERCENT_VERTICAL = 0.09;
  public static readonly CARD_TITLE_MIN_WIDTH = 142;
  public static readonly CARD_MARING_PERCENT = 0.025;
  public static readonly CARD_BOTTOM_MARGIN_RATIO = 0.1;
  public static readonly CARD_ROW_SPACE_PERCENT = 0.07;
  public static readonly CARD_LINE_SPACE_PERCENT = 0.05;
  public static readonly SCROLL_BAR_HEIGHT_PERCENT = 0.44;
  public static readonly SCROLL_BAR_HEIGHT_PERCENT_VERTICAL = 0.22;
  public static readonly SCROLL_BAR_MARGIN_RIGHT = 48;
  public static readonly SCROLL_BAR_MARGIN_RIGHT_PERCENT_HPR = 0.6;
  public static readonly SCROLL_BAR_MARGIN_RIGHT_PERCENT_HPR_HOR = 0.05;
  public static readonly SCROLL_BAR_MARGIN_RIGHT_HORIZONTAL = 100;
  public static readonly SCROLL_BAR_MARGIN_RIGHT_VERTICAL = 60;
  public static readonly DOUBLE_LIST_APP_INFO_LAYOUT_WEIGHT = 2;
  public static readonly DOUBLE_LIST_VIEW_TOP_MARGIN = 120;
  public static readonly DOUBLE_LIST_LEFT_MARGIN = 24;
  public static readonly DOUBLE_LIST_RIGHT_MARGIN = 24;
  public static readonly DOUBLE_LIST_TOP_MARGIN = 54;
  public static readonly DOUBLE_LIST_LOCKED_IMAGE_RIGHT_MARGIN = 8;
  public static readonly DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN = 8;
  public static readonly DOUBLE_LIST_APP_INFO_LEFT_MARGIN = 0;
  public static readonly DOUBLE_LIST_APP_INFO_RIGHT_MARGIN = 8;
  public static readonly TITLE_SPLIT_BLANK_WIDTH = 8;
  public static readonly DOUBLE_LIST_APP_GAP = 16;

  public static readonly TAB_SELECTED_BORDER_COLOR: ResourceColor = $r('sys.color.ohos_id_color_focused_outline');
  public static readonly HOVERED_BORDER_COLOR = '#CCFFFFFF';
  public static readonly BORDER_WIDTH = 1;
  public static readonly INNER_BORDER_WIDTH = 0;
  public static readonly OUTER_BORDER_WIDTH = 2;
  public static readonly HOVERED_BACKGROUND_COLOR: ResourceColor = $r('sys.color.ohos_id_color_component_normal');
  public static readonly SELECTED_BACKGROUND_COLOR = 'rgba(0,0,0,0)';
  public static readonly TAB_SELECTED_CARD_BG_COLOR: ResourceColor = $r('sys.color.ohos_id_color_component_normal');
  public static readonly INNER_BORDER_COLOR: ResourceColor = $r('app.color.hovered_inner_border_color');
  public static readonly OUTER_BORDER_COLOR: ResourceColor = $r('app.color.hovered_outer_border_color');

  public static readonly RECENT_ICON_SIZE = 28;

  public static readonly RECENT_IMAGE_MIN_RADIUS = 8;
  public static readonly RECENT_IMAGE_MAX_RADIUS = 16;
  public static readonly RECENT_IMAGE_OUTER_ADD_RADIUS = 2;
  public static readonly HOVERED_INNER_BORDER_COLOR = '#33ffffff';
  public static readonly HOVERED_OUTER_BORDER_COLOR = '#1a000000';

  // recent session animation type
  public static readonly RECENT_ANIM_TYPE_DEFAULT = 0;
  public static readonly RECENT_ANIM_TYPE_FADE_OUT = 1;
  public static readonly RECENT_ANIM_TYPE_CHAIN = 2;

  public static readonly CARD_MAX_WIDTH = 384;

  // close icon
  public static readonly RECENT_CLOSE_ICON_BACKGROUND_WIDTH = 32;
  public static readonly RECENT_CLOSE_ICON_BACKGROUND_HEIGHT = 32;
  public static readonly RECENT_CLOSE_ICON_BACKGROUND_RADIUS = 32;
  public static readonly RECENT_CLOSE_ICON_BACKGROUND_COLOR: ResourceColor = $r('app.color.transparent');
  public static readonly RECENT_CLOSE_ICON_BACKGROUND_HOVER_COLOR: ResourceColor = $r('sys.color.ohos_id_color_hover');
  public static readonly RECENT_CLOSE_ICON_BACKGROUND_PRESS_COLOR: ResourceColor = $r('sys.color.ohos_id_color_click_effect');


  public static readonly RECENT_TRANSPARENT_COLOR = '#00000000';

  public static readonly RECENT_BACKGROUND_COLOR_FOR_MIN_WIDTH: ResourceColor = $r('sys.color.ohos_id_color_sub_background');
  public static readonly RECENT_BACKGROUND_MIN_ROTATE_ANGLE = -30;

  public static readonly DELETE_RECENT_DELAY: number = 150;
  public static readonly RECENT_ANIM_RATIO = 1.1;
  public static readonly ENTER_RECENT_BASE_DELAY = 5;
  public static readonly EXIT_RECENT_BASE_DELAY = 32;
  public static readonly LIST_MARGIN_TOP: number = 36;
  public static readonly MIN_MARGIN_TOP_HPR = 20;
  public static readonly RECENT_BACK_PANEL_BLUR: number = 50;

  public static readonly RECENT_VIEW_TITLE = 'SCBRecentSessionAppName';
  public static readonly RECENT_LOCK_SCREEN_ROTATE = 'RecentLock';

  public static readonly RECENT_DELETE_BLUR_RADIUS = 60;
  public static readonly RECENT_DELETE_DISTANCE_BLUR_RATE = 15;
  public static readonly RECENT_APP_ICON_BORDER_RADIUS = 6;
  public static readonly CARD_THIRD_ROW = 3;
  public static readonly CARD_SIXTH_ROW = 6;
  public static readonly CARDS_SHOW_ROW_NUM = 4;
  public static readonly CARDS_SHOW_ROW_NUM_HOR = 5;
  public static readonly CARDS_SHOW_ROW_NUM_VER = 7;

  public static readonly RECENT_EXIT_CHAIN_ANIMATION_DURATION: number = 200;
  public static readonly FOLD_MACHINE_RECENT_EXIT_CHAIN_ANIMATION_DURATION: number = 200;
  public static readonly SCROLL_BAR_HEIGHT_HPR = 360;
  public static readonly RECENT_BACKGROUND_HIDE_TIME: number = 300;
  public static readonly RECENT_BACKGROUND_HIDE_ANIMATION_CURVE: ICurve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
  public static readonly FOLD_MACHINE_RECENT_BACKGROUND_HIDE_TIME: number = 350;
  public static readonly FOLD_MACHINE_RECENT_BACKGROUND_HIDE_ANIMATION_CURVE: ICurve =
    curves.cubicBezierCurve(0.4, 0, 1, 1);
}