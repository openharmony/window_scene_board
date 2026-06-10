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
export default class FormStyleConstants {
  //image resources
  public static readonly DEFAULT_ICON_IMAGE = '/common/pics/form_app_icon_default.png';

  // style
  public static readonly DEFAULT_FORM_MARGIN = 12;
  public static readonly FORM_MANAGER_VIEW_CARD_WIDTH = 328;
  public static readonly FORM_MANAGER_VIEW_CARD_HEIGHT = 328;
  public static readonly FORM_MANAGER_VIEW_WIDTH = 394;
  public static readonly FORM_MANAGER_VIEW_FORM_NAME_HEIGHT = 28;
  public static readonly FORM_MANAGER_VIEW_FORM_SUB_NAME_HEIGHT = 22;
  public static readonly FORM_MANAGER_RECOMMEND_TITLE = 40;

  // font resources
  public static readonly DEFAULT_FORM_MGR_TEXT_FONT_SIZE = 18;
  public static readonly DEFAULT_FORM_DES_TEXT_FONT_SIZE = 14;
  public static readonly DEFAULT_FORM_MGR_FONT_COLOR = '#e5ffffff';
  public static readonly DEFAULT_FORM_DIALOG_BUTTON_COLOR = '#007dff';

  // layout percentage adaptation resources
  public static readonly DEFAULT_LAYOUT_PERCENTAGE = '100%';
  public static readonly FORM_MGR_BOTTOM_WIDTH_PERCENTAGE = '80%';
  public static readonly FORM_MGR_BOTTOM_HEIGHT_PERCENTAGE = '10%';
  public static readonly FORM_MGR_SWIPER_WIDTH_PERCENTAGE = '80%';
  public static readonly FORM_MGR_SWIPER_HEIGHT_PERCENTAGE = '50%';
  public static readonly FORM_MGR_TEXT_HEIGHT_PERCENTAGE = '20%';
  public static readonly FORM_MGR_TOP_HEIGHT_PERCENTAGE = '10%';

  // scale point
  public static readonly FORM_PORTRAIT_SCALE_X = '50%';
  public static readonly FORM_PORTRAIT_SCALE_Y = '0%';
  public static readonly PC_FORM_PORTRAIT_SCALE_Y = '50%';

  // parameters for form manager page in phone
  public static readonly FORM_MGR_STATUS_BAR_HEIGHT = 24;
  public static readonly FORM_MGR_APP_BAR_HEIGHT = 56;
  public static readonly FORM_MGR_BACK_ICON_HEIGHT = 24;
  public static readonly FORM_MGR_BACK_ICON_WIDTH = 24;
  public static readonly FORM_MGR_BACK_ICON_LEFT_MARGIN = 24;
  public static readonly FORM_MGR_ADD_TO_DESKTOP_BUTTON_HEIGHT = 40;
  public static readonly FORM_MGR_ADD_TO_DESKTOP_BUTTON_PADDING = 8;
  public static readonly FORM_MGR_ADD_TO_DESKTOP_BUTTON_LINE_HEIGHT = 19;
  public static readonly FORM_MGR_ADD_TO_DESKTOP_BUTTON_HEIGHT_TEXT = 24;
  public static readonly FORM_MGR_BUTTON_SPACE = 16;
  public static readonly FORM_MGR_ADD_TO_DESKTOP_BUTTON_BOTTOM_MARGIN = 24;
  public static readonly FORM_MGR_FORM_SIZE = 270;
  public static readonly FORM_MGR_BUTTON_BORDER_WIDTH = 1;
  public static readonly FORM_MGR_BUTTON_BORDER_COLOR = 'rgba(255,255,255,0.4)';
  public static readonly FORM_MGR_BUTTON_BACKGROUND_COLOR = 'rgba(255,255,255,0.2)';
  public static readonly FORM_MGR_FORM_NAME_LINE_HEIGHT = 26;
  public static readonly FORM_MGR_FORM_DESCRIPTION_LINE_HEIGHT = 21;
  public static readonly OUTER_FORM_MGR_TITLE_WIDTH = 198;

  // the dpi of phone should be 480, but it is 320 currently.
  // so all dimensions have to be multiplied by 1.5
  public static readonly DPI_RATIO = 1;

  public static readonly SIZE_RATIO = 1.05;

  public static readonly WIDTH_RATIO = 10;

  public static readonly FORM_SERVICE_MARGIN_HORIZONTAL = 16;

  public static readonly FORM_SERVICE_BAR_HEIGHT = 56;
  public static readonly FORM_SERVICE_BACK_ICON_WIDTH = 24;
  public static readonly FORM_SERVICE_BACK_ICON_HEIGHT = 24;
  public static readonly FORM_SERVICE_BAR_TEXT_MARGIN_LEFT = 16;

  public static readonly FORM_SERVICE_GRID_ROW_COLUMNS = 4;
  public static readonly FORM_SERVICE_GRID_ROW_GUTTER_X = 16;
  public static readonly FORM_SERVICE_FORM_NAME_LINE_HEIGHT = 20;
  public static readonly FORM_SERVICE_FORM_NAME_NUM_LINE_HEIGHT = 16;
  public static readonly FORM_SERVICE_FORM_ICON_NAME_MARGIN_TOP = 4;
  public static readonly FORM_SERVICE_FROM_NAME_NUMBER_MARGIN = 4;

  public static readonly FORM_SERVICE_APP_LIST_MARGIN_BOTTOM = 19;
  public static readonly FORM_SERVICE_APP_LIST_PADDING_HORIZONTAL = 12;
  public static readonly FORM_SERVICE_APP_LIST_PADDING_VERTICAL = 4;
  public static readonly FORM_SERVICE_APP_LIST_BACKGROUND_COLOR = 'rgba(255,255,255,0.1)';
  public static readonly FORM_SERVICE_APP_ITEM_HEIGHT = 64;
  public static readonly FORM_SERVICE_APP_ICON_SIZE_WIDTH = 48;
  public static readonly FORM_SERVICE_APP_NAME_LINE_HEIGHT = 21;
  public static readonly FORM_SERVICE_APP_NAME_MARGIN_LEFT = 16;
  public static readonly SERVICE_FORM_APP_ITEM_RIGHT_ARROW_WIDTH = 12;
  public static readonly SERVICE_FORM_APP_ITEM_RIGHT_ARROW_HEIGHT = 24;
  public static readonly SERVICE_FORM_APP_ITEM_GROUP_DIVIDER_MARGIN_LEFT =
    FormStyleConstants.FORM_SERVICE_APP_ICON_SIZE_WIDTH +
    FormStyleConstants.FORM_SERVICE_APP_NAME_MARGIN_LEFT;
  public static readonly SERVICE_FORM_APP_ITEM_GROUP_DIVIDER_WIDTH = 0.5;

  public static readonly SWIPE_UP_FORM_SHADOW_COLOR = 'rgba(0, 0, 30, 0.3)';
  public static readonly SWIPE_UP_FORM_SHADOW_OFFSET_Y = 10;
  public static readonly SWIPE_UP_FORM_SHADOW_RADIUS = 50;
  public static readonly SWIPE_UP_FORM_BACKGROUND_COLOR = '#33182431';
  public static readonly SWIPE_UP_FORM_PIN_BACKGROUND_COLOR = '#FFFFFF';
  public static readonly SWIPE_UP_FORM_PIN_BACKGROUND_OPACITY = 0.8;
  public static readonly FORM_SERVICE_APP_LIST_DIVIDER_COLOR = 'rgba(255,255,255,0.05)';
  public static readonly SCALE_PERCENTAGE_PC = 0.797;
  public static readonly SCALE_PERCENTAGE_PHONE = 0.897;
  public static readonly FORM_DIALOG_RADIUS = 16;
  public static readonly FORM_BORDER_RADIUS_PC = 16;

  public static readonly FORM_SERVICE_HEIGHT = 747;
  public static readonly FORM_MANAGER_MARGIN_HORIZONTAL = 16;
  public static readonly FORM_MANAGER_TITLE_MARGIN = 16;
  public static readonly FORM_MANAGER_TITLE_MARGIN_SINGLE_DISPLAY_POCKET = 28;
  public static readonly FORM_MANAGER_TITLE_TOP_MARGIN = 8;
  public static readonly BREAKPOINT_4_COLUMN = 520;
  public static readonly BREAKPOINT_8_COLUMN = 840;
  public static readonly GRID_SMALL_SIZE = 600;
  public static readonly GRID_MEDIUM_SIZE = 840;
  public static readonly GRID_LARGE_SIZE = 1440;
  public static readonly FORM_DIMENSION_2x4_SPAN = 4;
  public static readonly FORM_DIMENSION_2x2_SPAN = 2;
  public static readonly FORM_MANAGER_SWIPER_HEIGHT = 336;
  public static readonly FORM_MANAGER_SWIPER_INDICATOR_HEIGHT = 32;
  public static readonly FORM_MANAGER_APP_ICON_SIZE = 32;
  public static readonly FORM_MANAGER_TITLE_BAR_MARGIN = 8;
  public static readonly FORM_MANAGER_MARGIN_VERTICAL = 24;
  public static readonly FORM_MANAGER_FORM_DESC_LINE_HEIGHT = 20;
  public static readonly FORM_MANAGER_APP_NAME_LINE_HEIGHT = 32;
  public static readonly FORM_MANAGER_SINGLE_FORM_MARGIN = 48;
  public static readonly FORM_MANAGER_BUTTON_MARGIN_TOP = 8;
  public static readonly FORM_MANAGER_BUTTON_MARGIN_BOTTOM = 32;
  public static readonly FORM_MANAGER_TITLE_MARGIN_TOP = 2;
  public static readonly FORM_MANAGER_DEFAULT_HEIGHT = 622;
  public static readonly FORM_SERVICE_STACK_MARGIN = 12;
  public static readonly FORM_MANAGER_BUTTON_MARGIN = 16;
  public static readonly FORM_SERVICE_GRIDROW_MARGIN_TOP = 16;
  // 服务卡片界面右侧list滑动条会被设备物理圆角截断，按照ux要求list底部添加margin规避
  public static readonly FORM_SERVICE_LIST_MARGIN_BOTTOM = 28;
  public static readonly FORM_MANAGER_SINGLE_FORM_OFFSETY = 4;
  public static readonly FORM_MANAGER_PANEL_GUTTER_DEFAULT = 12;
  public static readonly FORM_MANAGER_PANEL_COLUMNS = 6;
  public static readonly FORM_MANAGER_PANEL_GUTTERS = 7;
  public static readonly FORM_MANAGER_PANEL_SCALE_90 = 0.90;
  public static readonly FORM_MANAGER_PANEL_SCALE_95 = 0.95;
  public static readonly CREATE_CARD_BY_DRAG = 0;
  public static readonly CREATE_CARD_BY_BUTTON = 1;
  public static readonly FORM_APP_LIST_TOP_MARGIN = 16;
  public static readonly FORM_APP_LIST_BOTTOM_MARGIN = 28;
  public static readonly FORM_APP_LIST_ITEM_MARGIN = 4;
  public static readonly FORM_APP_LIST_ITEM_PADDING = 8;
  public static readonly FORM_APP_LIST_ITEM_RADIUS = 12;
  // 标题栏高度
  public static readonly FORM_CENTER_TITLE_HEIGHT = 64;

  // 导航栏36 距离导航栏8
  public static readonly FORM_CENTER_VIEW_TOP_HEIGHT = 44;
  public static readonly OUTER_FORM_CENTER_VIEW_TOP_HEIGHT = 8;
  public static readonly FORM_CENTER_FORM_TOP_MARGIN = 8;

  // 分栏应用卡片面板数据
  public static readonly BUTTON_MAX_WIDTH = 448;
  public static readonly FORM_MANAGER_VIEW_HEIGHT = 618;
  public static readonly FORM_MANAGER_VIEW_HEIGHT_SCREEN_LOCK = 402;
  public static readonly FORM_NAME_TOP_BOTTOM_MARGIN = 24;
  public static readonly FORM_NAME_TEXT_HEIGHT = 32;
  public static readonly FORM_NAME_GAP = 2;
  public static readonly FORM_DESCRIPTION_TEXT_HEIGHT = 20;
  // 横屏应用卡片管理参数
  public static readonly FORM_MANAGER_VIEW_HEIGHT_LAND = 352;
  public static readonly FORM_MANAGER_VIEW_WIDTH_LAND = 480;
  public static readonly FORM_MANAGER_BUTTON_MARGIN_LAND = 12;

  public static readonly FORM_SWIPER_INDICATOR_TOP_MARGIN = 12;
  public static readonly FORM_SWIPER_INDICATOR_HEIGHT = 32;
  public static readonly FORM_ADD_BUTTON_TOP = 16;
  public static readonly FORM_ADD_BUTTON_HEIGHT = 40;
  public static readonly FORM_ADD_BUTTON_BOTTOM_MARGIN = 28;
  public static readonly FORM_ADD_BUTTON_BOTTOM_MARGIN_INSIDE_APP = 16;
  public static readonly MULTI_WINDOWS_DOCK_HEIGHT = 64;
  public static readonly FORM_DESCRIPTION_DEFAULT_MARGIN = 32;
  public static readonly FORM_SWIPER_FORMS_TOP_HEIGHT = FormStyleConstants.FORM_NAME_TOP_BOTTOM_MARGIN * 2 +
  FormStyleConstants.FORM_NAME_TEXT_HEIGHT + FormStyleConstants.FORM_NAME_GAP +
  FormStyleConstants.FORM_DESCRIPTION_TEXT_HEIGHT;
  public static readonly FORM_SWIPER_FORMS_BOTTOM_HEIGHT = FormStyleConstants.FORM_SWIPER_INDICATOR_TOP_MARGIN +
  FormStyleConstants.FORM_SWIPER_INDICATOR_HEIGHT + FormStyleConstants.FORM_ADD_BUTTON_TOP +
  FormStyleConstants.FORM_ADD_BUTTON_HEIGHT + FormStyleConstants.FORM_ADD_BUTTON_BOTTOM_MARGIN;
  public static readonly FORM_SWIPER_FORMS_BOTTOM_HEIGHT_INSIDE_APP =
    FormStyleConstants.FORM_SWIPER_INDICATOR_TOP_MARGIN +
    FormStyleConstants.FORM_SWIPER_INDICATOR_HEIGHT + FormStyleConstants.FORM_ADD_BUTTON_TOP +
    FormStyleConstants.FORM_ADD_BUTTON_HEIGHT + FormStyleConstants.FORM_ADD_BUTTON_BOTTOM_MARGIN_INSIDE_APP;
  public static readonly FORM_CENTER_DEFAULT_ITEM = 'suggestion';

  public static readonly DEFAULT_FORM_HIDDEN_OPACITY_VALUE = 0.001;

  // 元服务面板拉起卡片管理双按钮布局
  public static readonly BUTTON_COLUMN_GAP_BY_ASDE = 12;
  public static readonly FORM_NAME_TOP_BOTTOM_MARGIN_BY_ASDE = 12;
  public static readonly FORM_ADD_BUTTON_TOP_BY_ASDE = 10;
  public static readonly FORM_CONTENT_EMPTY_AREA_BY_ASDE = 10;
  public static readonly FORM_SWIPER_INDICATOR_TOP_MARGIN_BY_ASDE = 10;
  public static readonly FORM_SWIPER_FORMS_TOP_HEIGHT_BY_ASDE =
    FormStyleConstants.FORM_NAME_TOP_BOTTOM_MARGIN_BY_ASDE * 2 +
    FormStyleConstants.FORM_NAME_TEXT_HEIGHT + FormStyleConstants.FORM_NAME_GAP +
    FormStyleConstants.FORM_DESCRIPTION_TEXT_HEIGHT;
  public static readonly FORM_SWIPER_TWO_BOTTOM_HEIGHT = FormStyleConstants.FORM_ADD_BUTTON_HEIGHT * 2 +
    FormStyleConstants.BUTTON_COLUMN_GAP_BY_ASDE;
  public static readonly FORM_SWIPER_TWO_BUTTON_AREA_HEIGHT =
    FormStyleConstants.FORM_ADD_BUTTON_TOP_BY_ASDE + FormStyleConstants.FORM_ADD_BUTTON_HEIGHT * 2 +
    FormStyleConstants.BUTTON_COLUMN_GAP_BY_ASDE + FormStyleConstants.FORM_ADD_BUTTON_BOTTOM_MARGIN;
  public static readonly FORM_SWIPER_TWO_BUTTON_AREA_HEIGHT_INSIDE_APP =
    FormStyleConstants.FORM_ADD_BUTTON_TOP_BY_ASDE +
      FormStyleConstants.FORM_ADD_BUTTON_HEIGHT * 2 +
    FormStyleConstants.BUTTON_COLUMN_GAP_BY_ASDE +
    FormStyleConstants.FORM_ADD_BUTTON_BOTTOM_MARGIN_INSIDE_APP;
  public static readonly FORM_SWIPER_INDICATOR_AREA_HEIGHT_BY_ASDE =
    FormStyleConstants.FORM_SWIPER_INDICATOR_TOP_MARGIN_BY_ASDE +
    FormStyleConstants.FORM_SWIPER_INDICATOR_HEIGHT;

  // 搜索相关
  public static readonly SEARCH_COMPONENT_HEIGHT = 40;
  public static readonly SEARCH_NO_RESULT_MARGIN_TOP = 99;
  public static readonly SEARCH_COMPONENT_SPLIT_BOTTOM_MARGIN = 16;
  public static readonly SEARCH_COMPONENT_SPLIT_TOP_MARGIN = 8;
  public static readonly SEARCH_RESULT_EMPTY_LENGTH = 150;
  public static readonly OUTER_SEARCH_RESULT_EMPTY_LENGTH = 120;
  public static readonly OUTER_SEARCH_NO_RESULT_TOP_MARGIN = 34;
  public static readonly SEARCH_RESULT_EMPTY_MARGIN_BOTTOM = 8;
  public static readonly SEARCH_COMPONENT_FONT_SIZE = 16;
  public static readonly SEARCH_RESULT_EMPTY_FONT_SIZE = 16;
  public static readonly SEARCH_COMPONENT_HEIGHT_MARGIN_VERTICAL = 16;

  // 外屏编辑模式卡片添加按钮宽度
  public static readonly OUTER_FORM_ADD_BUTTON_WIDTH = 140;
  // 外屏编辑模式导航条顶部间距
  public static readonly OUTER_FORM_SWIPER_INDICATOR_TOP_MARGIN = 12;
  // 外屏编辑模式导航条高度
  public static readonly OUTER_FORM_SWIPER_INDICATOR_HEIGHT = 8;
  // 外屏编辑模式添加卡片按钮顶部间距
  public static readonly OUTER_FORM_ADD_BUTTON_TOP = 12;
  // 外屏编辑模式添加卡片按钮高度
  public static readonly OUTER_FORM_ADD_BUTTON_HEIGHT = 32;
  // 外屏编辑模式添加卡片按钮底部间距
  public static readonly OUTER_FORM_ADD_BUTTON_BOTTOM_MARGIN = 12;
  // 外屏编辑模式底部区域总高(导航到底部全部区域)
  public static readonly OUTER_FORM_SWIPER_FORMS_BOTTOM_HEIGHT = FormStyleConstants.OUTER_FORM_SWIPER_INDICATOR_HEIGHT +
  FormStyleConstants.OUTER_FORM_ADD_BUTTON_TOP + FormStyleConstants.OUTER_FORM_ADD_BUTTON_HEIGHT +
  FormStyleConstants.OUTER_FORM_ADD_BUTTON_BOTTOM_MARGIN;

  // 外屏编辑模式Title style
  public static readonly OUTER_TITLE_BUTTON_IMAGE_WIDTH: number = 24;
  public static readonly OUTER_TITLE_BUTTON_IMAGE_HEIGHT: number = 24;
  public static readonly OUTER_TITLE_BUTTON_WIDTH: number = 40;
  public static readonly OUTER_TITLE_BUTTON_HEIGHT: number = 40;
  public static readonly OUTER_TITLE_BLANK_WIDTH: number = 8;

  /**
   * 外屏编辑模式卡片添加按钮两边距离
   */
  public static readonly OUTER_FORM_MANAGER_BUTTON_MARGIN: number = 93;

  /**
   * 外屏卡片中心添加至桌面按钮最长宽度
   */
  public static readonly OUTER_ADD_FORM_BUTTON_WIDTH: number = 294;

  // 卡片编辑布局参数
  // 标题栏高度
  public static readonly FORM_EDIT_VIEW_TITLE_HEIGHT: number = 56;
  public static readonly FORM_EDIT_VIEW_CARD_NAME_HEIGHT: number = 32;
  public static readonly FORM_EDIT_TITLE_MARGIN: number = 8;

  // 导航栏36 距离导航栏12
  public static readonly FORM_EDIT_VIEW_MARGIN_TOP_SCREEN: number = 48;
  public static readonly FORM_EDIT_VIEW_TOP_MARGIN_SYSTEM_BAR: number = 12;
  // 内部元素左右边距
  public static readonly FORM_EDIT_VIEW_INNER_MARGIN: number = 16;
  // 卡片应用编辑页高度
  public static readonly FORM_EDIT_VIEW_PROVIDER_PAGE_HEIGHT: number = 208;
  // 完成按钮上边距
  public static readonly FORM_EDIT_VIEW_BUTTON_MARGIN_TOP: number = 128;
  // 完成按钮下边距
  public static readonly FORM_EDIT_VIEW_BUTTON_MARGIN_BOTTOM: number = 28;

  // 折叠屏展开态、平板参数
  // 编辑页面距离屏幕上下边距
  public static readonly FORM_EDIT_VIEW_FOLD_MARGIN_TOP_BOTTOM: number = 84;
  // 编辑页面距离屏幕左右边距
  public static readonly FORM_EDIT_VIEW_FOLD_MARGIN_LEFT_RIGHT: number = 130;
  // 卡片应用编辑页高度
  public static readonly FORM_EDIT_VIEW_FOLD_PROVIDER_PAGE_HEIGHT: number = 218;
  // 完成按钮上边距
  public static readonly FORM_EDIT_VIEW_FOLD_BUTTON_MARGIN_TOP: number = 59;
  // 完成按钮下边距
  public static readonly FORM_EDIT_VIEW_FOLD_BUTTON_MARGIN_BOTTOM: number = 16;
  // 直板机卡片中心推荐卡片按压缩放
  public static readonly RECOMMEND_FORM_SCALE = 0.75;
  public static readonly FORM_EDIT_TO_TOP_DISTANCE: number = FormStyleConstants.FORM_EDIT_VIEW_TITLE_HEIGHT +
  FormStyleConstants.FORM_EDIT_TITLE_MARGIN + FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN +
  FormStyleConstants.FORM_DESCRIPTION_DEFAULT_MARGIN + FormStyleConstants.FORM_NAME_TEXT_HEIGHT;
  public static readonly FORM_EDIT_TO_TOP_DISTANCE_SPLIT: number =
    FormStyleConstants.FORM_EDIT_VIEW_FOLD_MARGIN_TOP_BOTTOM +
    FormStyleConstants.FORM_EDIT_TITLE_MARGIN + FormStyleConstants.FORM_EDIT_VIEW_TITLE_HEIGHT +
    FormStyleConstants.FORM_NAME_TEXT_HEIGHT + FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN +
    FormStyleConstants.FORM_DESCRIPTION_DEFAULT_MARGIN;
}