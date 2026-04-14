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

import curves from '@ohos.curves';

export default class EditModeConstants {
  /**
   * 进出编辑模式文件夹背板透明度动画、GridSwiper/SinglePage缩放动效曲线
   */
  static readonly CHANGE_DESKMODE_CURVE = curves.springMotion(0.497, 0.79, 0);

  /**
   * 编辑态页面缩放比例
   */
  static readonly SWIPER_EDIT_SCALE_RATE: number = 0.76;

  /**
   * 编辑态页面距离导航点高度
   */
  static readonly SWIPER_EDIT_BOTTOM_INDICATOR: number = 32;

  /**
   * 编辑模式页面圆角
   */
  static readonly EDIT_MODE_BORDER_RADIUS: number = 24;

  /**
   * 编辑态页面添加的高度
   */
  static readonly SWIPER_EDIT_ADD_HEIGHT: number = 52;

  /**
   * PAD编辑态页面横屏添加的高度
   */
  static readonly SWIPER_ADD_HEIGHT_PAD_LANDSCAPE: number = 44;

  /**
   * PAD编辑态页面竖屏添加的高度
   */
  static readonly SWIPER_ADD_HEIGHT_PAD: number = 120;

  /**
   * 编辑态页面itemSpace
   */
  static readonly SWIPER_PREV_NEXT_MARGIN_PAD: number = 40;

  /**
   * 编辑态页面itemSpace
   */
  static readonly SWIPER_PREV_NEXT_MARGIN: number = 0.01;

  /**
   * 编辑态页面itemSpace
   */
  static readonly SWIPER_PRE_ITEM_SPACE: number = 16;

  /**
   * 编辑模式右侧addPage按钮尺寸
   */
  static readonly PAGE_EDIT_BUTTON_SIZE: number = 40;

  /**
   * 编辑模式右侧addPage按钮内图片尺寸
   */
  static readonly PAGE_EDIT_BUTTON_ICON_SIZE: number = 24;

  /**
   * 编辑模式右侧addPage按钮呼吸动效scale
   */
  static readonly PAGE_EDIT_BUTTON_BREARHE_SCALE: number = 0.75;

  /**
   * 编辑模式右侧addPage按钮非深色背景颜色
   */
  static readonly PAGE_EDIT_BUTTON_BG_COLOR: string = '#33000000';

  /**
   * 编辑模式右侧addPage按钮深色背景透明度
   */
  static readonly PAGE_EDIT_BUTTON_DEEP_BG_OPACITY: number = 0.2;

  /**
   * 编辑模式删除页面按钮底边距
   */
  static readonly PAGE_EDIT_DELETE_ICON_MARGIN_BOTTOM: number = 24;

  /**
   * 编辑模式上方拖拽页面提示语高度尺寸
   */
  static readonly EDIT_MODE_DRAG_PAGE_TIP_HEIGHT: number = 21;

  /**
   * 编辑模式上方拖拽页面提示语距离背景板间隔
   */
  static readonly EDIT_MODE_DRAG_PAGE_TIP_BOTTOM_MARGIN: number = 16;

  /**
   * 小折叠设备内屏编辑模式上方拖拽页面提示语距离背景板间隔
   */
  static readonly EDIT_MODE_DRAG_PAGE_TIP_BOTTOM_MARGIN_IN_SMALL_FOLD: number = 8;

  /**
   * 编辑模式上方拖拽页面提示语左右padding
   */
  static readonly EDIT_MODE_DRAG_PAGE_TIP_PADDING: number = 24;

  /**
   * 编辑模式上方拖拽页面提示语最大行数
   */
  static readonly EDIT_MODE_DRAG_PAGE_TIP_MAX_LINE: number = 1;

  /**
   * 编辑模式上方拖拽页面提示语距离背景板间隔
   */
  static readonly EDIT_MODE_DRAG_GRID_BOTTOM_MARGIN: number = 16;

  /**
   * 编辑模式上方拖拽页面提示语隐藏时间
   */
  static readonly HIDE_DRAG_PAGE_TIP_TIME: number = 5000;

  /**
   * 编辑模式上方拖拽页面提示语透明度
   */
  static readonly DRAG_PAGE_TIP_OPACITY: number = 0.6;

  /**
   * 扩展新形态小折叠产品外屏编辑态页面itemSpace
   */
  static readonly OUTER_PREV_NEXT_MARGIN: number = 21;

  /**
   * 桌面编辑字体最大放大倍数
   */
  static readonly MAX_FONT_SIZE_SCALE = 1.45;

  /**
   * 桌面编辑APP_NAME字体最大放大倍数
   */
  static readonly APP_NAME_MAX_FONT_SIZE_SCALE = 1.15;
  /**
   * edit mode drop event
   */
  static readonly EVENT_PAGEDESK_DROP_FINISHED = 'launcher.event.PAGEDESK_DROP_FINISHED';

  /**
   * edit mode refresh finish event
   */
  static readonly EVENT_REQUEST_PAGEDESK_REFRESH_FINISHED = 'launcher.event.EVENT_REQUEST_PAGEDESK_REFRESH_FINISHED';

  /**
   * edit mode component drop event
   */
  static readonly EVENT_EDIT_MODE_COMPONENT_DROP = 'launcher.event.EDIT_MODE_COMPONENT_DROP';

  /**
   * edit mode component drag item into hot area
   */
  static readonly EVENT_EDIT_MODE_ENTER_HOT_AREA = 'launcher.event.EDIT_MODE_ENTER_HOT_AREA';

  /**
   * edit mode component drag item to delete
   */
  static readonly EVENT_EDIT_MODE_DROP_TO_DELETE = 'launcher.event.EVENT_EDIT_MODE_DROP_TO_DELETE-';

  /**
   * edit mode component recover dragged item
   */
  static readonly EVENT_EDIT_MODE_FOLDER_ITEM_RECOVER = 'launcher.event.EVENT_EDIT_MODE_FOLDER_ITEM_RECOVER';

  /** 进入编辑模糊震动类型 */
  static readonly VIBRATOR_TYPE_OF_ENTER_EDITMODE: string = 'haptic.upglide';

  /**
   * edit mode component drop item to delete button hot area
   */
  static readonly EVENT_EDIT_MODE_DROP_TO_DELETE_BUTTON = 'launcher.event.EVENT_EDIT_MODE_DROP_TO_DELETE_BUTTON';

  /**
   * 折叠屏展开态元素跨屏挤位
   */
  static readonly EVENT_FOLD_EXPAND_DUAL_SQUEEZED = 'launcher.event.EVENT_FOLD_EXPAND_DUAL_SQUEEZED';

  /**
   * 外屏添加APP时存储的APP信息
   */
  static readonly ADD_OUTER_APP_ITEM = 'addOuterAppItem';

  /**
   * icon multi select limit
   */
  public static readonly MULTI_SELECT_LIMIT = 100;

  /**
   * 编辑模式设置主屏按钮尺寸
   */
  public static readonly HOME_PAGE_BUTTON_SIZE: number = 32;

  /**
   * 编辑模式右侧加号页新增空白页的动效总时长
   */
  static readonly PAGE_EDIT_ANIMATE_TIME: number = 600;

  /**
   * 编辑模式右侧加号页删除空白页的动效总时长
   */
  static readonly PAGE_EDIT_DELETE_ANIMATE_TIME: number = 200;

  /**
   * 编辑模式新增空白页的动效中用于避免背板重叠的时延
   */
  static readonly PAGE_EDIT_ANIMATE_DELAY_TIME: number = 100;

  /**
   * 编辑模式右侧加号页删除空白页的动效中用于避免背板重叠的时延
   */
  static readonly PAGE_EDIT_DELETE_ANIMATE_DELAY_TIME: number = 50;

  /**
   * 编辑模式下页面编辑中整页移动动效时长
   */
  static readonly PAGE_SQUEEZE_DURATION = 350;

  /**
   * 编辑模式下页面编辑中整页移动动效曲线
   */
  static readonly PAGE_SQUEEZE_CURVE = curves.springMotion(0.397, 0.89);
  /**
   * 编辑模式下页面缩放默认尺寸
   */
  static readonly PAGE_ZOOM_IN_SCALE = 1.05;

  /**
   * 编辑模式下页面缩放目标尺寸
   */
  static readonly PAGE_ZOOM_OUT_SCALE = 0.95;

  /**
   * 编辑模式下页面按压缩放动效时长
   */
  static readonly PAGE_SCALE_DURATION = 200;

  /**
   * 编辑模式下页面按压缩放动效曲线
   */
  static readonly PAGE_SCALE_CURVE = curves.cubicBezierCurve(0.33, 0, 0.67, 1);

  /**
   * 页面缩放事件头
   */
  static readonly PAGE_SCALE_ANIMATION_EVENT: string = 'page_scale_animation_';

  /**
   * 页面信息变化后更新当前页是否为空白页
   */
  static readonly UPDATE_BLANK_PAGE_LIST: string = 'updateBlankPageList';

  /**
   * 小折叠初始化参数事件
   */
  static readonly OUTER_RESET_SEARCH_COMPONENT: string = 'resetEditModeSearchComponent';

  /**
   * 小折叠外屏搜索栏返回到title事件
   */
  static readonly OUTER_RETURN_TO_TITLE: string = 'returnToTitle';

  /**
   * 小折叠外屏搜索栏返回到title事件
   */
  static readonly OUTER_SET_REQUEST_FOCUS: string = 'setRequestFocus';

  /**
   * 关闭搜索栏的编辑状态(收起键盘)
   */
  static readonly CLOSE_KEY_BOARD_OF_OUTER_EDIT_CENTER: string = 'closeKeyBoardOfOuterEditCenter';

  /**
   * 小折叠外屏应用中心和卡片中心数据高度(存在搜索栏时)
   */
  static readonly OUTER_CENTER_DATA_HEIGHT: number = 258;

  /**
   * 显示底部导航栏事件
   */
  static readonly AI_BAR_SHOW_EVENT: string = 'AIBarShow';

  /**
   * 编辑模式APP分类文件路径
   */
  static readonly OUTER_APP_CATEGORIZE_PATH: string = '/sys_prod/etc/app_categorize/app_categorize.xml';

  /**
   * 获取屏幕高度的表格名称
   */
  static readonly SCREEN_LOCK_BIND_SHEET_HEIGHT: string = 'sceneboard.screenLockBindSheetHeight';

  /**
   * 获取屏幕锁定状态的表格名称
   */
  static readonly SCREEN_LOCK_BIND_SHEET: string = 'sceneboard.screenLockBindSheet';

  /**
   * 设置卡片搜索栏数据
   */
  static readonly SET_FORM_SEARCH_VALUE: string = 'setFormSearchValue';

  /**
   * 小折叠外屏刷新搜索栏数据
   */
  static readonly OUTER_RESET_SEARCH_DATA: string = 'resetSearchData';

  /**
   * 小折叠外屏搜索栏组件返回title消失所需要的动效时间
   */
  static readonly OUTER_SEARCH_BACK_ACTION_DURATION: number = 50;

  /**
   * 小折叠外屏搜索栏组件返回title title显示所需要的动效时间
   */
  static readonly OUTER_TITLE_SHOW_ACTION_DURATION: number = 100;

  /**
   * 小折叠外屏title切换为搜索栏组件 搜索栏显示所需要的动效时间
   */
  static readonly OUTER_SEARCH_SHOW_ACTION_DURATION: number = 200;

  /**
   * 小折叠外屏title切换为搜索栏组件 title消失所需要的动效时间
   */
  static readonly OUTER_TITLE_TO_SEARCH_DURATION: number = 150;

  /**
   * 小折叠外屏搜索字体大小
   */
  static readonly OUTER_EDIT_SEARCH_COMPONENT_TEXT_SIZE: number = 16;

  /**
   * 小折叠外屏搜索无结果
   */
  static readonly OUTER_EDIT_SEARCH_NO_RESULT: string = 'noResult';

  /**
   * 小折叠外屏应用已经被添加到外屏
   */
  static readonly OUTER_EDIT_SEARCH_NO_RESULT_BY_IN_DESKTOP: string = 'noResultByInDeskTop';

  /**
   * 小折叠外屏搜索栏为空
   */
  static readonly OUTER_EDIT_SEARCH_NO_VALUE: string = 'noValue';

  /**
   * 小折叠外屏搜索结果提示图片大小
   */
  static readonly OUTER_TIPS_IMAGE_SIZE: number = 120;

  /**
   * 小折叠外屏搜索结果提示字体大小
   */
  static readonly OUTER_TIPS_TEXT_SIZE: number = 16;

  /**
   * 小折叠外屏搜索Icon大小
   */
  static readonly OUTER_SEARCH_ICON_SIZE: number = 16;

  /**
   * 小折叠外屏搜索组件高度
   */
  static readonly OUTER_SEARCH_COMPONENT_HEIGHT: number = 56;

  /**
   * 小折叠外屏搜索组件宽度
   */
  static readonly OUTER_SEARCH_COMPONENT_WIDTH: number = 294;

  /**
   * 小折叠外屏搜索组件顶部边距
   */
  static readonly OUTER_SEARCH_COMPONENT_TOP_MARGIN: number = 8;

  /**
   * 小折叠外屏搜索组件向上偏移量
   */
  static readonly OUTER_SEARCH_COMPONENT_OFFSET_Y: number = -8;

  /**
   * 外屏应用分身标识图偏移量
   */
  static readonly APP_INDEX_IMAGE_OFFSET: number = 3;

  /**
   * 外屏应用分身标识图大小
   */
  static readonly APP_INDEX_IMAGE_SIZE: number = 18;

  /**
   * 小外屏編輯模式背板弧度
   */
  static readonly OUTER_EDIT_MODE_BORDER_RADIUS: number = 18;

  /**
   * 小外屏编辑模式右侧addPage按钮尺寸
   */
  static readonly OUTER_PAGE_EDIT_BUTTON_SIZE: number = 32;

  /**
   * 小外屏编辑模式背景板左上角相对于桌面左上角的Y坐标
   */
  static readonly OUTER_EDIT_MODE_BG_TOP_POINT_Y = 43;

  /**
   * 小外屏编辑模式背景板中心点位置
   */
  static readonly OUTER_EDIT_MODE_BG_TARGET_Y = 152.5;

  /**
   * 应用分身角标资源Map
   */
  public static readonly APP_INDEX_RESOURCE_MAP: Map<number, Resource> = new Map([
    [1, $r('app.media.app_icon_clone_index_1')],
    [2, $r('app.media.app_icon_clone_index_2')],
    [3, $r('app.media.app_icon_clone_index_3')],
    [4, $r('app.media.app_icon_clone_index_4')],
    [5, $r('app.media.app_icon_clone_index_5')],
  ]);

  static readonly PAGE_DRAG_SKIP_GESTURE_TIME = 240;

  static readonly LONG_PRESS_TIME_FOR_SMALL_FOLDER_SNAPSHOT = 150;

  /** 编辑模式页面拖拽截图时间*/
  static readonly PAGE_DRAG_SNAPSHOT_TIME = 250;

  /** 页面拖拽长按触发缩放动效 */
  static readonly PAGE_DRAG_ANI_TIME = 300;

  /** 页面拖拽trace grid截图 */
  static readonly PAGE_DRAG_TRACE_SNAPSHOT_GRID = 'PAGE_DRAG_TRACE_SNAPSHOT_GRID';

  /** 页面拖拽trace builder截图 */
  static readonly PAGE_DRAG_TRACE_SNAPSHOT_BUILDER = 'PAGE_DRAG_TRACE_SNAPSHOT_BUILDER';

  /** 页面拖拽trace createDragAction */
  static readonly PAGE_DRAG_TRACE_CREATE_DRAG = 'PAGE_DRAG_TRACE_CREATE_DRAG';

  /**
   * 外屏编辑模式搜索栏高度
   */
  static readonly OUTER_SEARCH_HEIGHT: number = 40;

  /**
   * 外屏编辑模式搜索栏宽度
   */
  static readonly OUTER_SEARCH_WIDTH: number = 246;

  /**
   * 外屏编辑模式按钮内部样式大小
   */
  static readonly OUTER_BUTTON_ICON_SIZE: number = 18;

  /**
   * 外屏编辑模式按钮大小
   */
  static readonly OUTER_BUTTON_SIZE: number = 40;

  /**
   * 外屏编辑模式搜索栏边距
   */
  static readonly OUTER_SEARCH_MARGIN: number = 8;

  /**
   * 编辑模式顶部删除按钮上边距
   */
  static readonly PAGE_EDIT_REMOVE_BAR_MARGIN_TOP: number = 16;

  /**
   * 编辑态页面透明度
   */
  static readonly SWIPER_EDIT_OPACITY: number = 0.20;
}

/**
 * Uninstall Dialog status
 */
export enum UninstallDialogStatus {
  INITIAL_STATE = 0,
  CONFIRM_STATE = 1,
  CANCEL_STATE = 2,
  UNINSTALLING_STATE = 3
}