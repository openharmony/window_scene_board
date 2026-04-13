/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

export enum ArrowType {
  RESIDENT_LEFT = 0,
  RESIDENT_RIGHT = 1,
  RECENT_LEFT = 2,
  RECENT_RIGHT = 3
}

export enum PreviewScrollState {
  NORMAL = 0,
  REACH_START = 1,
  REACH_END = 2
}

export class FixedDockResource {
  public static readonly APP_CENTER_ICON_FOREGROUND = '/common/pics/ic_app_center_foreground.svg';
  public static readonly RECENT_CENTER_ICON_FOREGROUND = '/common/pics/ic_recent_ability_foreground.svg';

  public static readonly PREVIEW_ARROW_LEFT = '/common/pics/ic_light_arrow_left.svg';
  public static readonly PREVIEW_ARROW_RIGHT = '/common/pics/ic_light_arrow_right.svg';
  public static readonly PREVIEW_CLOSE_NORMAL = '/common/pics/ic_close_normal.svg';
  public static readonly SNAPSHOT_ITEM_HEIGHT = 200;
  public static readonly SNAPSHOT_ITEM_DEFAULT_WIDTH = 218;
  public static readonly SNAPSHOT_ITEM_MIN_WIDTH = 100;
  public static readonly SNAPSHOT_ITEM_MAX_WIDTH = 288;
  public static readonly SNAPSHOT_GAP = 16;
  public static readonly PREVIEW_MARGIN_WHEN_HAS_ARROW = 28;
  public static readonly PREVIEW_MARGIN_WHEN_NO_ARROW = 16;
  public static readonly PREVIEW_SCREEN_PADDING = 24;
  public static readonly PREVIEW_ARROW_MARGIN_LEFT = 2;
  public static readonly PREVIEW_ARROW_MARGIN_RIGHT = 2;
  public static readonly PREVIEW_ARROW_MARGIN_TOP = 86;
  public static readonly PREVIEW_ARROW_MARGIN_BOTTOM = 86;
  public static readonly PREVIEW_ARROW_SIZE = 24;
  public static readonly SNAPSHOT_ITEM_PADDING_TOP = 8;
  public static readonly SNAPSHOT_ITEM_PADDING_BOTTOM = 16;
  public static readonly SNAPSHOT_ITEM_PADDING_LEFT = 0;
  public static readonly SNAPSHOT_ITEM_PADDING_RIGHT = 0;
  public static readonly SNAPSHOT_CLOSE_BUTTON_SIZE = 24;
  public static readonly SNAPSHOT_TITLE_HEIGHT = 24;
  public static readonly SNAPSHOT_ITEM_TITLE_HEIGHT = 32;
  public static readonly SNAPSHOT_TITLE_MARGIN_BOTTOM = 8;
  public static readonly SNAPSHOT_IMAGE_HEIGHT = 144;
  public static readonly SNAPSHOT_IMAGE_INNER_BORDER_RADIUS = 10;
  public static readonly SNAPSHOT_IMAGE_OUTER_BORDER_RADIUS = 8;
  public static readonly SNAPSHOT_IMAGE_SHADOW_RADIUS = 4;
  public static readonly SNAPSHOT_IMAGE_SHADOW_COLOR = '#19000000';
  public static readonly LIGHT_CONTINUABLE_PREVIEW_BG_COLOR = '#99ffffff';
  public static readonly DARK_CONTINUABLE_PREVIEW_BG_COLOR = '#33ffffff';
  public static readonly CONTINUABLE_ITEM_PREVIEW_IMAGE_SIZE = 36;
  public static readonly PREVIEW_BORDER_RADIUS = 16;

  public static readonly TIPS_TEXT_HEIGHT = 20;
  public static readonly TIPS_TEXT_FONT_SIZE = 14;
  public static readonly TIPS_TEXT_MIN_WIDTH = 32;
  public static readonly TIPS_POPUP_HEIGHT = 32;
  public static readonly TIPS_POPUP_PADDING = 8;
  public static readonly TIPS_POPUP_BORDER_RADIUS = 16;
  public static readonly TIPS_TEXT_PADDING = 2;
  public static readonly POPUP_MIN_TEXT_WIDTH = 64;
  public static readonly POPUP_MIN_TEXT_HEIGHT = 24;
  public static readonly POPUP_COLOR = '#33000000';

  public static readonly MENU_TEXT_WIDTH = 140;
  public static readonly DOCK_MENU_MAX_WIDTH = 480;
  public static readonly DOCK_RESIDENT_AREA_ID = 'DOCK_RESIDENT_AREA';
  public static readonly DOCK_RECENT_AREA_ID = 'DOCK_RECENT_AREA';
  public static readonly CLEAR_RECYCLE_BIN_KEY_STRING = 'clearRecycleBin';
  public static readonly DOCK_MENU_OFFSET_X = 4;
  public static readonly DOCK_MENU_OFFSET_Y = 8;
  public static readonly TOGGLE_HOME_WIDTH = 16;
  public static readonly DOCK_MENU_SUB_TITLE_SIZE = 14;

  // hover 预览窗（竖向）
  public static readonly PREVIEW_TEXT_WIDTH = 128;
  public static readonly PREVIEW_TEXT_HEIGHT = 21;
  public static readonly PREVIEW_TEXT_MARGIN = 8;
  public static readonly PREVIEW_TITLE_IAMGE_SIZE = 24;
  public static readonly PREVIEW_TITLE_IAMGE_RADIUS = 4;
  public static readonly PREVIEW_LIST_ITEM_MAX_WIDTH = 480;
  public static readonly PREVIEW_LIST_ITEM_HEIGHT = 40;
  public static readonly PREVIEW_LIST_ITEM_RADIUS = 4;
  public static readonly PREVIEW_LIST_ITEM_PADDING = 12;
  public static readonly PREVIEW_LIST_SPACE = 2;
  public static readonly PREVIEW_LIST_MARGIN = 4;
  public static readonly PREVIEW_LIST_IAMGE_MARGIN = 96;
  public static readonly PREVIEW_LIST_TEXT_MARGIN = 88;
  public static readonly PREVIEW_SHOW_SNAPSHOT_TEXT_WIDTH = 204;
  public static readonly PREVIEW_SHOW_LIST_TEXT_WIDTH = 144;
  public static readonly PREVIEW_CONTAINER_WIDTH = 224;
  public static readonly PREVIEW_SCROLLBAR_HEIGHT = 482;
  public static readonly WINDOW_STYLE_SAFE_SPACE = 15;
  public static readonly MAC_STYLE_SAFE_SPACE = 3;
  public static readonly PANEL_BOTTOM_SPACE = 7;
  public static readonly BORDER_WIDTH = 1;
  public static readonly BORDER_COLOR = '#33ffffff';
  public static readonly OUTLINE_DART_COLOR = '#66000000';
  public static readonly ICON_SELECT_COLOR = '#66000000';
  public static readonly OUTLINE_LIGHT_COLOR = '#1a000000';
  public static readonly FRAME_BACKGROUND_DARK_COLOR = '#1affffff';
  public static readonly FRAME_BACKGROUND_LIGHT_COLOR = '#1a000000';

  public static readonly HOVER_ENTER_DOCK_DELAY_TIME_PREVIEW = 500; // 首次进入dock, hover出preview窗的等待时长
  public static readonly HOVER_ENTER_DELAY_TIME_TIPS = 1000; // 进入dock，hover出tips提示的等待时长
  public static readonly HOVER_ENTER_DELAY_TIME_PREVIEW = 200; // dock栏hover进图标，呼出preview窗的等待时长
  public static readonly HOVER_EXIT_DELAY_TIME_PREVIEW = 225; // 退出dock时，preview窗 & tips窗消失时长
  public static readonly HOVER_EXIT_DELAY_TIME_TIPS = 0; // tips窗消失延长时间
  public static readonly HOVER_PREVIEW_SHOW_ANIM_DURATION = 200; // preview窗显示动效时长
  public static readonly HOVER_ENTER_ANIM_DURATION = 150; // popup窗显示动效时长
  public static readonly HOVER_EXIT_ANIM_DURATION = 150; // popup窗消失动效时长

  // 任务中心和应用中心切换定时器
  public static readonly RECENT_AND_APP_CENTER_SWITCH_TIMER: string = 'recentAndAppCenterSwitchTimer';


  public static readonly DOCK_SYSTEM_AREA_ID = 'DOCK_SYSTEM_AREA';
  public static readonly DOCK_COMMON_AREA_ID = 'DOCK_COMMON_AREA';

  public static readonly ARROW_HOVER_DARK_COLOR = '#19FFFFFF';
  public static readonly ARROW_HOVER_LIGHT_COLOR = '#0C000000';
  public static readonly ARROW_CLICK_DARK_COLOR = '#26FFFFFF';
  public static readonly ARROW_CLICK_LIGHT_COLOR = '#19000000';

  public static readonly dockBackgroundBrightnessLightFullParam: BrightnessOptions = {
    rate: 0.0745,
    lightUpDegree: 0.886,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.6,
    posRGB: [1, 0.5, 1],
    negRGB: [2, 1.2, 1],
  };

  public static readonly dockBackgroundBrightnessDarkFullParam: BrightnessOptions = {
    rate: 0.0588,
    lightUpDegree: 15 / 255.0,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    posRGB: [1, 1, 0.5],
    negRGB: [0.2, 0.2, 0.5],
  };

  public static readonly dockBackgroundBrightnessLightParam: BrightnessOptions = {
    rate: 0.6613,
    lightUpDegree: 88.0 / 255.0,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.5,
    posRGB: [1.7, 1.5, 1.5],
    negRGB: [0.5, 0.5, 0.5],
  };

  public static readonly dockBackgroundBrightnessDarkParam: BrightnessOptions = {
    rate: 0.5991,
    lightUpDegree: 18.0 / 255.0,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.4,
    posRGB: [1, 1, 0.5],
    negRGB: [0.2, 0.2, 0.5],
  };

  public static readonly dockBackgroundBrightnessHuaParam: BrightnessOptions = {
    rate: 0.2873,
    lightUpDegree: 0.6793,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 2,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1.2, 1],
  };

  public static readonly fixedScrollerComponentLightParam: BrightnessOptions = {
    rate: 0.2873,
    lightUpDegree: 0.6793,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 2,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1.2, 1],
  };

  public static readonly fixedScrollerComponentDarkParam: BrightnessOptions = {
    rate: -0.2067,
    lightUpDegree: 0.14,
    cubicCoeff: -0.6667,
    quadCoeff: 1.3333,
    fraction: 0,
    saturation: 1.4,
    posRGB: [0.3, 0.5, 0.8],
    negRGB: [0.3, 1, 1],
  };

  public static readonly dockBackgroundEffectOptionsDarkParam: BackgroundEffectOptions = {
    radius: 120,
    saturation: 1.5,
    color: '#F21A1A1A',
  };

  public static readonly dockBackgroundEffectOptionsLightParam: BackgroundEffectOptions = {
    radius: 100,
    saturation: 1.9,
    color: '#CCFFFFFF',
  };

  public static readonly DEFAULT_DOCK_GAP = 16;
}

export class FixedDockConstants {
  public static readonly WPS_BUNDLE_NAME: string = 'cn.wps.office.hap';
}

export interface HoverItemInfo {
  hoverItemId: string,
  screenId: number,
}