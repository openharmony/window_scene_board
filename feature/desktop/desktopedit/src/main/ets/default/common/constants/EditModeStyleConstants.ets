/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
 * 编辑模式常量
 */
export class EditModeDockConstants {
  /**
   * 卡片
   */
  public static readonly FORM_SERVICE_KEY: string = 'form_service';

  /**
   * 壁纸
   */
  public static readonly WALLPAPER_KEY: string = 'wallpaper';

  /**
   * 图标
   */
  public static readonly ICON_KEY: string = 'icon';

  /**
   * 主题画廊
   */
  public static readonly THEME_KEY: string = 'edit_theme';

  /**
   * 外屏卡片
   */
  public static readonly OUTER_FORM_KEY: string = 'add_form_to_outer_page';

  /**
   * 外屏应用
   */
  public static readonly OUTER_APP_KEY: string = 'add_apps_to_outer_page';

  /**
   * 外屏主题画廊
   */
  public static readonly OUTER_THEME_KEY: string = 'outer_edit_theme';

  /**
   * outer edit mode button height
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_HEIGHT = 32;

  /**
   * outer edit mode button width
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_WIDTH = 78;

  /**
   * outer edit mode button radius
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_RADIUS: number = 18;

  /**
   * outer edit mode button padding start
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_PADDING_START = 14;

  /**
   * outer edit mode button padding end
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_PADDING_END = 12;

  /**
   * outer edit mode button padding top and bottom
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_PADDING_TOP_BOTTOM = 8;

  /**
   * outer edit mode button margin right
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_MARGIN_RIGHT = 6;

  /**
   * outer edit mode button margin min right
   */
  public static readonly OUTER_EDIT_MODE_BUTTON_MIN_MARGIN_RIGHT = 3;

  /**
   * outer edit mode font size
   */
  public static readonly OUTER_EDIT_MODE_FONT_SIZE = 14;

  /**
   * outer edit mode language `EN` font size
   */
  public static readonly OUTER_EDIT_MODE_EN_FONT_SIZE = 13;

  /**
   * outer edit mode common param
   */
  public static readonly OUTER_EDIT_COMMON_PARAM = 20;

  /**
   * outer edit mode line height
   */
  public static readonly OUTER_EDIT_LINE_HEIGHT = 19;
}

/**
 * 编辑模式样式常量
 */
export default class EditModeStyleConstants {
  /**
   * 编辑态页面缩放比例
   */
  public static readonly SWIPER_EDIT_SCALE_RATE: number = 0.76;

  /**
   * 编辑态页面透明度
   */
  public static readonly SWIPER_EDIT_OPACITY: number = 0.20;

  /**
   * 编辑态页面饱和度
   */
  public static readonly SWIPER_EDIT_SATURATE: number = 1.3;

  /**
   * 编辑态dock背景透明度
   */
  public static readonly EDIT_DOCK_BACKGROUND_OPACITY: number = 0.20;

  /**
   * desktopMode 改变动效延迟时间
   */
  public static readonly DESKTOP_MODE_CHANGE_DELAY: number = 50;

  /**
   * iconEditPageDelay 图标编辑延迟时间
   */
  public static readonly ICON_EDIT_PAGE_DELAY: number = 150;

  /*
   * 编辑模式切换动效时长
   */
  public static readonly EDIT_MODE_CHANGE_DURATION: number = 550;

  /**
   * 编辑模式底部按钮图标大小
   */
  public static readonly EDIT_SWIPER_ICON_SIZE: number = 24;

  /**
   * 编辑模式底部按钮大小
   */
  public static readonly EDIT_SWIPER_BUTTON_SIZE: number = 48;

  /**
   * 编辑模式底部按钮+文字大小
   */
  public static readonly EDIT_SWIPER_BUTTON_WIDTH: number = 60;

  /**
   * 编辑模式底部文字高度
   */
  public static readonly EDIT_MODE_BUTTON_TEXT_HEIGHT: number = 24;

  /**
   * 编辑模式按钮文字的marginTop
   */
  public static readonly EDIT_SWIPER_BUTTON_NAME_MARGIN_TOP: number = 2;
  /**
   * 编辑模式底部间距
   */
  public static readonly EDIT_BUTTON_SPACE: number = 16;

  /**
   * 新形态小折叠外屏编辑模式小语种底部间距
   */
  public static readonly OUTER_EDIT_BUTTON_MINORITY_LANGUAGE_SPACE: number = 12;

  /**
   * 新形态小折叠外屏编辑模式英文底部间距
   */
  public static readonly OUTER_EDIT_BUTTON_ENGLISH_SPACE: number = 8;

  /**
   * 编辑模式图标、名称的间距
   */
  public static readonly EDIT_BUTTON_IMAGE_FONT_SPACE: number = 4;

  /**
   * 常量100%
   */
  public static readonly PERCENTAGE_100: string = '100%';

  /*
   * dock栏编辑模式切换动效时长
   */
  public static readonly DOCK_TRANSITION_DURATION: number = 400;

  /*
   * dock栏编辑模式按钮位移动效
   */
  public static readonly DOCK_TRANSLATE_Y: number = 60;

  /*
   * dock栏高度
   */
  public static readonly DOCK_TRANSLATE_HEIGHT: number = 45;

  /*
   * 扩展新形态小折叠产品外屏dock栏底部距离
   */
  public static readonly OUTER_EDIT_MODE_DOCK_TRANSLATE: number = 42;

  /*
   * dock栏编辑模式切换动效延迟
   */
  public static readonly DOCK_TRANSITION_DELAY: number = 150;

  /*
   * 编辑模式背板颜色
   */
  public static readonly EDIT_MODE_BACKGROUND_OPACITY: number = 0.1;

  /*
   * 编辑模式背板上滑触发距离
   */
  public static readonly EDIT_MODE_BACKPLANE_PAN_GESTURE_MIN_DISTANCE = 5;

  /**
   * button default background color
   */
  public static readonly EDIT_MODE_BUTTON_DEFAULT_BG_COLOR = '#40ffffff';

  /**
   * button default margin top
   */
  public static readonly EDIT_MODE_BUTTON_DEFAULT_MARGIN_TOP = 16;

  /**
   * button shadow radius
   */
  public static readonly EDIT_MODE_BUTTON_SHADOW_RADIUS = 100;

  /**
   * button shadow color
   */
  public static readonly EDIT_MODE_BUTTON_SHADOW_COLOR = '#0d000000';

  /**
   * button shadow offsetY
   */
  public static readonly EDIT_MODE_BUTTON_SHADOW_OFFSET = 10;

  /**
   * delete button background color
   */
  public static readonly EDIT_MODE_BUTTON_DELETE_BG_COLOR = $r('sys.color.ohos_id_color_warning');

  /**
   * remove button background color
   */
  public static readonly EDIT_MODE_BUTTON_REMOVE_BG_COLOR = $r('sys.color.ohos_id_color_alert');

  /**
   * left and right margin of button in edit mode
   */
  public static readonly EDIT_MODE_BUTTON_MARGIN_LEFT_RIGHT = 32;

  /**
   * white space border color alpha
   */
  public static readonly WHITE_SPACE_BORDER_COLOR_ALPHA = '#1affffff';

  /**
   * white space background color alpha
   */
  public static readonly WHITE_SPACE_BACKGROUND_COLOR_ALPHA = '#00FFFFFF';

  /**
   * white fall space outside border color alpha
   */
  public static readonly WHITE_FALL_SPACE_INSIDE_BORDER_COLOR_ALPHA = '#33ffffff';

  /**
   * white fall space outside border color alpha
   */
  public static readonly WHITE_FALL_SPACE_OUTSIDE_BORDER_COLOR_ALPHA_LIGHT = '#1a000000';

  /**
   * drag item background color when enter hot area
   */
  public static readonly ENTER_HOT_AREA_APP_BG_COLOR = '#33E84026';

  /**
   * drag card background color when enter hot area
   */
  public static readonly ENTER_HOT_AREA_CARD_BG_COLOR = '#33ED6F21';

  /**
   * drag item background color when leave hot area
   */
  public static readonly LEAVE_HOT_AREA_BG_COLOR = '#00000000';

  /**
   * white fall space outside border width
   */
  public static readonly SQUEEZE_BORDER_WIDTH = 1;

  /**
   * opacity fully visible
   */
  public static readonly OPACITY_FULLY_VISIBLE = 1;

  /**
   * opacity fully invisible
   */
  public static readonly OPACITY_FULLY_INVISIBLE = 0;

  /**
   * canvas height and width
   */
  public static readonly EDIT_MODE_DEFAULT_29: number = 29;
  public static readonly EDIT_MODE_DEFAULT_22: number = 22;

  /**
   * lottie file: uninstall open
   */
  public static readonly LOTTIE_UNINSTALL_OPEN = 'editmode_uninstall_open.json';

  /**
   * lottie file: uninstall close
   */
  public static readonly LOTTIE_UNINSTALL_CLOSE = 'editmode_uninstall_close.json';

  /**
   * lottie file: uninstall close to ok
   */
  public static readonly LOTTIE_UNINSTALL_CLOSE_TO_OK = 'editmode_uninstall_close_to_ok.json';

  /**
   * lottie file: remove to ok
   */
  public static readonly LOTTIE_REMOVE_TO_OK = 'editmode_remove_to_ok.json';

  /**
   * 浅色版本的落位白框边框颜色，用于深色壁纸的场景，透明度为25%
   */
  public static readonly WHITE_BOX_BORDER_COLOR_LIGHT = '#40FFFFFF';

  /**
   * 深色版本的落位白框边框颜色，用于浅色壁纸的场景，透明度为10%
   */
  public static readonly WHITE_BOX_BORDER_COLOR_DARK = '#19000000';

  /**
   * 浅色版本的落位白框填充颜色，用于深色壁纸的场景，透明度为10%
   */
  public static readonly WHITE_BOX_BG_COLOR_LIGHT = '#1AFFFFFF';

  /**
   * 深色版本的落位白框填充颜色，用于浅色壁纸的场景，透明度为3%
   */
  public static readonly WHITE_BOX_BG_COLOR_DARK = '#07000000';

  /**
   * 外屏编辑模式APP管理页标题Y轴偏移量
   */
  public static readonly OUTER_EDIT_APP_MANAGE_TITLE_OFFSET_Y = 14;

  /**
   * 外屏编辑模式分类标题大小
   */
  public static readonly OUTER_EDIT_CATEGORIZE_APP_FONT_SIZE = 14;

  /**
   * 外屏编辑模式分类标题高度
   */
  public static readonly OUTER_EDIT_CATEGORIZE_TITLE_HEIGHT = 20;

  /**
   * 外屏编辑模式分类距离屏幕左侧距离
   */
  public static readonly OUTER_EDIT_CATEGORIZE_APP_TITLE_MARGIN_LEFT = 16;

  /**
   * 外屏编辑模式实验应用提示图标大小
   */
  public static readonly OUTER_EDIT_EXPERIMENTAL_APP_IMAGE_SIZE = 16;

  /**
   * 外屏编辑模式实验应用提示图标边距
   */
  public static readonly OUTER_EDIT_EXPERIMENTAL_APP_IMAGE_MARGIN = 8;

  /**
   * 外屏编辑模式实验应用提示语字体大小
   */
  public static readonly OUTER_EDIT_EXPERIMENTAL_APP_PROMPT_MESSAGE_SIZE = 14;

  /**
   * 外屏编辑模式实验应用提示语字体X轴偏移量
   */
  public static readonly OUTER_EDIT_EXPERIMENTAL_APP_PROMPT_MESSAGE_OFFSET_X = 5;

  /**
   * 外屏编辑模式实验应用顶部间距(存在精选应用)
   */
  public static readonly OUTER_EDIT_EXPERIMENTAL_APP_TITLE_DEFAULT_TOP_MANAGE = 16;

  /**
   * 外屏编辑模式分类标题顶部间距(无精选应用)
   */
  public static readonly OUTER_EDIT_CATEGORIZE_APP_TITLE_MANAGE = -8;

  /**
   * 外屏编辑模式APP管理页滚动条宽度
   */
  public static readonly OUTER_EDIT_APP_MANAGE_SCROLL_BAR_WIDTH = 4;

  /**
   * 外屏编辑模式APP管理页滚动条摩擦力
   */
  public static readonly OUTER_EDIT_APP_MANAGE_SCROLL_BAR_FRICTION = 0.6;

  /**
   * 外屏编辑模式APP管理页滚动条弧度
   */
  public static readonly OUTER_EDIT_APP_MANAGE_SCROLL_BAR_BORDER_RADIUS = 30;

  /**
   * 外屏编辑模式App管理页列表规格
   */
  public static readonly OUTER_EDIT_APP_MANAGE_GRID_COLUMNS_TEMPLATE = '1fr 1fr 1fr 1fr';

  /**
   * 外屏编辑模式App管理页列距离
   */
  public static readonly OUTER_EDIT_APP_MANAGE_GRID_COLUMNS_GAP = 28.5;

  /**
   * 外屏编辑模式App管理页行距离
   */
  public static readonly OUTER_EDIT_APP_MANAGE_GRID_ROWS_GAP = 16;

  /**
   * 外屏编辑模式App管理页顶部内间距
   */
  public static readonly OUTER_EDIT_APP_MANAGE_GRID_PADDING_TOP = 8;

  /**
   * 外屏编辑模式App管理页内侧边距
   */
  public static readonly OUTER_EDIT_APP_MANAGE_GRID_PADDING_SIDES: number = 16;

  /**
   * 外屏编辑模式半模态页面默认高度
   */
  public static readonly OUTER_EDIT_HALF_MODE_DEFAULT_HEIGHT: number = 322;

  /**
   * 外屏编辑模式App管理页底部边距
   */
  public static readonly OUTER_EDIT_APP_MANAGE_GRID_MARGIN_BOTTOM: number = 20;

  /**
   * 扩展新形态小折叠产品应用分类页面 应用名称高度
   */
  public static readonly OUTER_APP_ITEM_TITLE_HEIGHT: number = 16;

  /**
  * 外屏编辑模式AppItem opacity
  */
  public static readonly OUTER_APP_ITME_IMAGE_OPACITY: number = 0.005;

  /**
   * 外屏编辑模式AppItem text字体大小
   */
  public static readonly OUTER_APP_ITME_TEXT_FONTSIZE: number = 12;

  /**
   * 外屏编辑模式AppItem text文本高度
   */
  public static readonly OUTER_APP_ITME_TEXT_LINE_HEIGHT: number = 16;

  /**
   * 外屏编辑模式AppItem text文本最大行数
   */
  public static readonly OUTER_APP_ITME_TEXT_MAX_LINES: number = 1;

  /**
   * 外屏编辑模式AppItem text向上偏移值
   */
  public static readonly OUTER_APP_ITME_TEXT_MARGIN_TOP: number = 4;

  /**
   * 外屏编辑模式AppItem height
   */
  public static readonly OUTER_APP_ITME_HEIGHT: number = 72;

  /**
   * 外屏编辑模式AppItem text最大行数
   */
  public static readonly OUTER_APP_ITEM_TEXT_MAX_LINES: number = 2;

  /**
   * 外屏编辑模式AppItem默认放大倍率
   */
  public static readonly DEFAULT_ZOOM_ANIMATE_SCALE: number = 1.31;

  /**
   * 外屏编辑模式show Animate delay
   */
  public static readonly SHOW_ANIMATE_DELAY_TIME: number = 2000;

  /**
   * 外屏编辑模式runLater delay
   */
  public static readonly RUNLATER_DELAY_TIME: number = 200;

  /**
   * 外屏编辑模式Animate duration
   */
  public static readonly CREATE_APP_ITEM_ANIMATION_DURATION: number = 350;

  /**
   * 外屏编辑模式 num 2
   */
  public static readonly NUM_2: number = 2;

  /**
   * 外屏编辑模式cubicBezier x1
   */
  public static readonly CUBIC_BEZIER_X1: number = 0.57;

  /**
   * 外屏编辑模式cubicBezier y1
   */
  public static readonly CUBIC_BEZIER_Y1: number = 0.00;

  /**
   * 外屏编辑模式cubicBezier x2
   */
  public static readonly CUBIC_BEZIER_X2: number = 0.71;

  /**
   * 外屏编辑模式cubicBezier y2
   */
  public static readonly CUBIC_BEZIER_Y2: number = 1.00;

  /**
   * 外屏编辑模式animate response
   */
  public static readonly SPRING_MOTION_RESPONSE: number = 0.468;

  /**
   * 外屏编辑模式animate dampingFraction
   */
  public static readonly SPRING_MOTION_DAMPING_FRACTION_ZOOM: number = 0.63;

  /**
   * 外屏编辑模式animate dampingFraction
   */
  public static readonly SPRING_MOTION_DAMPING_FRACTION_MOVE: number = 0.82;

  /**
   * 外屏编辑模式默认放大倍率
   */
  public static readonly DEFAULT_ANIMATE_SCALE: number = 1.0;

  /**
   * 外屏编辑模式放大倍率
   */
  public static readonly ZOOM_ANIMATE_SCALE: number = 1.2;

  /**
   * outer edit mode default opacity
   */
  public static readonly OUTER_EDIT_DEFAULT_OPACITY = 1;

  /**
   * 外屏编辑模式Press Animate duration
   */
  public static readonly OUTER_PRESS_ANIMATE_DURATION: number = 250;

  /**
   * 外屏编辑模式interpolatingSpring velocity
   */
  public static readonly OUTER_INTER_POLATING_SPRING_VELOCITY: number = 1;

  /**
   * 外屏编辑模式interpolatingSpring mass
   */
  public static readonly OUTER_INTER_POLATING_SPRING_MASS: number = 1;

  /**
   * 外屏编辑模式interpolatingSpring stiffness
   */
  public static readonly OUTER_INTER_POLATING_SPRING_STIFFNESS: number = 410;

  /**
   * 外屏编辑模式interpolatingSpring damping
   */
  public static readonly OUTER_INTER_POLATING_SPRING_DAMPING: number = 38;

  /**
   * 外屏编辑模式interpolatingSpring scale
   */
  public static readonly OUTER_ICON_ANIM_SCALE: number = 1;

  /**
   * 外屏编辑模式图标最大模糊值
   */
  public static readonly OUTER_ICON_MAX_BLUR: number = 1000;

  /**
   * 外屏编辑模式图标倍率系数
   */
  public static readonly OUTER_ICON_SCALE_RESPONSE: number = 0.363;

  /**
   * 外屏编辑模式图标倍率阻尼系数
   */
  public static readonly OUTER_ICON_SCALE_DAMPING_FRACTION: number = 1;

  /**
   * 外屏编辑模式AppItem倍率系数
   */
  public static readonly OUTER_APP_ITEM_SCALE_RESPONSE: number = 0.363;

  /**
   * 外屏编辑模式按钮内部样式大小
   */
  public static readonly OUTER_BUTTON_ICON_SIZE: number = 18;

  /**
   * 外屏编辑模式按钮大小
   */
  public static readonly OUTER_BUTTON_SIZE: number = 40;

  /**
   * 外屏编辑模式搜索栏高度
   */
  public static readonly OUTER_SEARCH_HEIGHT: number = 40;

  /**
   * 外屏编辑模式搜索栏宽度
   */
  public static readonly OUTER_SEARCH_WIDTH: number = 246;

  /**
   * 外屏编辑模式搜索栏左边距
   */
  public static readonly OUTER_SEARCH_START_MARGIN: number = 8;

  /**
   * 外屏编辑模式搜索栏按钮右边距
   */
  public static readonly OUTER_SEARCH_BUTTON_END_MARGIN: number = 8;

  /**
   * 外屏应用中心添加提示底部距离
   */
  public static readonly OUTER_SEARCH_BUTTON_MARGIN: number = 88;

  /**
   * 外屏应用中心应用列表高度
   */
  public static readonly OUTER_APP_CENTER_LIST_HEIGHT: number = 255;

  /**
   * 外屏应用中心scrollBar底部距离
   */
  public static readonly OUTER_APP_CENTER_SCROLL_BAR_BOTTOM_MARGIN: number = 28;

  /**
   * 外屏应用中心grid起始index
   */
  public static readonly OUTER_APP_CENTER_GRID_START: number = 0;

  /**
   * 外屏应用中心grid结尾index
   */
  public static readonly OUTER_APP_CENTER_GRID_END: number = 3;

  /**
   * 外屏应用中心grid末尾空白高度
   */
  public static readonly OUTER_APP_CENTER_END_SPACE_HEIGHT: number = 4;

  /**
   * 无障碍模式下默认走焦焦点id
   */
  public static readonly DEFAULT_ACCESSIBILITY_WHEN_NOT_FOUNT_ID: string = 'notFound';
}

/**
 * Drag status
 */
export enum DragStatus {
  NO_DRAG = 0,
  DRAGING = 1,
  DRAG_ENTER = 2,
  DRAG_LEAVE = 3,
  DRAG_DROP = 4,
}