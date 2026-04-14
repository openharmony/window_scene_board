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
import { LengthMetrics } from '@kit.ArkUI';

export default class SmartDockConstants {
  public static readonly FEATURE_NAME = 'featureSmartDock';

  public static readonly LIST_DIRECTION: Axis = Axis.Horizontal;

  public static readonly PERCENTAGE_100 = '100%';

  /**
   * residentList type docklist
   */
  public static readonly RESIDENT_DOCK_TYPE = 0;

  /**
   * recentdock type docklist
   */
  public static readonly RECENT_DOCK_TYPE = 1;

  /**
   * recentdock type docklist
   */
  public static readonly RESIDENT_DOCK_NOT_INSTALL_TYPE = 2;

  public static readonly CONTINUABLE_ICON_INSERT_OPACITY = 0.4;

  public static readonly RESIDENT_DOCK_REMOVE_TYPE = 3;

  public static readonly CONTINUABLE_ICON_TOAST_DURATION = 1500;

  public static readonly CONTINUABLE_ICON_SHOW_DURATION = 550;

  public static readonly CONTINUABLE_ICON_TOAST_PC_BOTTOM = 52;

  // 避免接续动效图标消失过程中与其他图标重合
  public static readonly CONTINUABLE_ICON_MOVE_DURATION = 400;

  public static readonly CONTINUABLE_ICON_MOVE_DELAY = 150;

  public static readonly CONTINUABLE_ICON_SHOW_ANIMATION = curves.cubicBezierCurve(0.33, 0, 0.67, 1);

  public static readonly CONTINUABLE_ICON_POPUP_MASK_COLOR = 'rgba(250,250,250,0)';

  public static readonly CONTINUABLE_ICON_POPUP_POPUP_COLOR = 'rgba(250,250,250,0.6)';

  public static readonly CONTINUABLE_ICON_POPUP_TITLE_SIZE = '16fp';

  public static readonly CONTINUABLE_ICON_POPUP_DESC_SIZE = '14fp';

  public static readonly CONTINUABLE_ICON_POPUP_TITLE_COLOR = '#E5000000';

  public static readonly CONTINUABLE_ICON_POPUP_DESC_COLOR = '#99000000';

  public static readonly CONTINUABLE_ICON_POPUP_TEXT_MARGIN = 2;

  public static readonly CONTINUABLE_ICON_POPUP_PADDING: Padding = {
    top: 10, bottom: 10, left: 14, right: 14
  };

  public static readonly HOVER_DELAY_TIME = 300; // 300,500,750

  public static readonly HOVER_GAP_TIME = 150; //鼠标从Dock栏图标到缩略图的时间间隔

  public static readonly MISSION_INFO_LIST = 'missionInfoList'; //截取appitem json串的必需值作为foreach 的 key

  public static readonly DIVIDER_COLOR = '#99FFFFFF';
  public static readonly DOCK_ITEM_SHADOW_OFFSETY_TWO = 2;

  public static readonly DOCK_ITEM_SHADOW_RADIUS = 2;
  public static readonly DOCK_ITEM_SHADOW_COLOR = '#40000000';
  public static readonly DOCK_ITEM_SHADOW_OFFSETY_ONE = 1;

  public static readonly DOCK_ITEM_HOVER_SHADOW_RADIUS = 1;
  public static readonly DOCK_ITEM_HOVER_SHADOW_COLOR = '#40000000';
  public static readonly DOCK_ITEM_HOVER_SHADOW_OFFSETX_ONE = -1;
  public static readonly DOCK_ITEM_HOVER_SHADOW_OFFSETY_ONE = 1;

  public static readonly RUNNING_SHADOW_RADIUS = 2;
  public static readonly RUNNING_SHADOW_COLOR = '#A6000000';
  public static readonly RUNNING_SHADOW_OFFSETY = 1;
  public static readonly RUNNING_PADDINT_TOP = 5;

  public static readonly DOCK_ITEM_EXTRA_PADDING = 10;
  /*
   * dock栏背板动效事件
   */
  public static readonly RESIDENT_RESHAPE_EVENT = 'resident_reshape';

  /**
   * dock栏落位框显示事件
   */
  public static readonly DOCK_HOLDER_NOTIFY_EVENT = 'dock_holder_notify';

  /**
   * dock栏元素挤位事件
   */
  public static readonly DOCK_ITEM_SQUEEZE_START = 'dock_item_squeeze_start_';

  /**
   * dock栏图标大小改变事件
   */
  public static readonly ICON_SIZE_CHANGE_EVENT = 'icon_size_change';

  /**
   * dock栏图标菜单改变事件
   */
  public static readonly DOCK_MENU_CHANGE_EVENT = 'dock_menu_change';

  /*
   * 退出自由多窗，重新计算dock宽度.适配打开应用，切换自由多窗，卸载应用，关闭自由多窗场景
   */
  public static readonly MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT = 'dock_reshape';

  /*
   * dock区整体缩放事件
   */
  public static readonly DOCK_ZOOM_EVENT = 'dock_zoom';

  /*
   * dock栏的占位应用名
   */
  public static readonly DOCK_TEMP_ITEM_NAME = 'temp';
  /**
   * default image sampling ratio
   */
  public static readonly IMAGE_SAMPLING_RATIO: number = 0.4;

  public static readonly DEFAULT_DOCK_ICON_MARGIN_TOP = 10;

  //Divider Layout
  public static readonly RECENT_DOCK_DIVIDER_WIDTH = 2;
  public static readonly RECENT_DOCK_DIVIDER_HEIGHT = 24;
  public static readonly RECENT_DOCK_DIVIDER_MARGIN = 28;
  public static readonly RECENT_DOCK_EDGE_BLUR_WIDTH = 12;

  public static readonly DOCK_RESIDENT_BG_ID = 'DOCK_RESIDENT_BG';
  public static readonly DOCK_RECENT_BG_ID = 'DOCK_RECENT_BG';
  public static readonly PC_MODE_DOCK_RECENT_BG_ID = 'PC_MODE_DOCK_RECENT_BG';
  public static readonly DOCK_COLLABORATION_BG_ID = 'DOCK_COLLABORATION_BG';

  //DockEvent delay time
  public static readonly DELAY_TIME = 20;
  public static readonly DELAY_TIME_SHOW_APP_CENTER_WHEN_NEED_EXIT_RECENT = 400;

  public static readonly DOCK_DROP_FRAME_BORDER_COLOR = '#33ffffff';
  public static readonly DOCK_DROP_FRAME_OUTLINE_COLOR_LIGHT = '#1a000000';
  public static readonly DOCK_DROP_FRAME_OUTLINE_COLOR_DARK = '#66000000';

  //接续图标常量
  public static readonly DEVICE_TYPE_BG_SIZE_DEFAULT = 18;
  public static readonly DEVICE_TYPE_ICON_SIZE_DEFAULT = 12;
  static readonly DEVICE_TYPE_BG_TV_SIZE_DEFAULT = 24;
  static readonly DEVICE_TYPE_ICON_TV_SIZE_DEFAULT = 15;
  public static readonly DEVICE_TYPE_SIMPLE_BG_SIZE_DEFAULT = 24;
  public static readonly DEVICE_TYPE_SIMPLE_ICON_SIZE_DEFAULT = 20;
  public static readonly TYPE_ICON_MARGIN = 6;
  static readonly TYPE_ICON_MARGIN_TV = 5;
  public static readonly SIMPLE_TYPE_ICON_MARGIN = 8;
  public static readonly CONTINUABLE_DELAY_DURATION = 100;
  public static readonly CONTINUABLE_BADGE_PADDING = -6;
  static readonly CONTINUABLE_BADGE_PADDING_TV = -5;
}
