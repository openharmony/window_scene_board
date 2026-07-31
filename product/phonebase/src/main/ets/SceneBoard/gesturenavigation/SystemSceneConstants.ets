/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import { SCBNaviBarConstants } from '../naviBar/SCBNaviBarConstants';

export class SystemSceneConstants {
  // 导航条参数
  public static readonly WIDTH_THRESHOLD_SMALL = 600;
  public static readonly WIDTH_THRESHOLD_MIDDLE = 840;
  public static readonly DEFAULT_HEIGHT = SCBNaviBarConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT;
  // Phone底部导航横屏状态下窗口的宽度与屏幕的宽度比
  public static readonly LANDSCAPE_WINDOWWIDTH_PERCENT_PHONE = 0.7;
  // Pad底部导航横屏状态下窗口的宽度与屏幕的宽度比
  public static readonly LANDSCAPE_WINDOWWIDTH_PERCENT_PAD = 0.8;
  // 新形态小折叠，外屏手势热区需要增加4
  public static readonly OUTER_GESTURE_NAV_ADD_LENGTH = 4;
  public static readonly AREA_WIDTH = '35%';
  public static readonly AREA_REST_WIDTH = 0.65;
  public static readonly BAR_DEFAULT_WIDTH = SCBNaviBarConstants.GESTURE_NAV_NAVI_BAR_WIDTH_DEFAULT;
  public static readonly BAR_MARGIN_BOTTOM = 10;
  public static readonly CAPSULE_MARGIN = 48; // 24vp * 2，UX要求AI导航条宽度比锁屏胶囊两侧各少24vp
  public static readonly TWO = 2;
  public static readonly THREE = 3;
  public static readonly FOUR = 4;
  public static readonly OPACITY_ANIM_THRESHOLD_Y = SystemSceneConstants.TWO * SystemSceneConstants.BAR_MARGIN_BOTTOM;
  public static readonly OPACITY_ANIM_DEFAULT_THRESHOLD_X =
    SystemSceneConstants.BAR_DEFAULT_WIDTH / SystemSceneConstants.THREE;
  public static readonly DOCK_ANIM_HEIGHT: number = 100;
  public static readonly BAR_HEIGHT = SCBNaviBarConstants.GESTURE_NAV_NAVI_BAR_HEIGHT;
  public static readonly DEFAULT_BAR_RADIUS = SystemSceneConstants.BAR_HEIGHT / SystemSceneConstants.TWO;
  public static readonly GAME_FOCUS = 4;
  public static readonly ENTER_GAME = 1;
  public static readonly HOT_AREA_HEIGHT_IN_GAME = 16;
  public static readonly NAVI_BAR_DISPLAY_TIME = 2000;
  public static readonly GAME_EVENT_LISTENER_FIELD = 'usual.event.gameservice.GAME_STATUS_CHANGE_UNI';
  public static readonly PUBLISH_SYSTEM_COMMON_EVENT = 'ohos.permission.PUBLISH_SYSTEM_COMMON_EVENT';
  // 第一个触摸屏幕的手指ID
  public static readonly FIRST_FINGER_TOUCH_ID = 0;
  // 鼠标触摸屏幕的ID
  public static readonly MOUSE_TOUCH_ID = 1001;
  // 手写笔触摸屏幕的ID
  public static readonly PEN_TOUCH_ID = 102;
  // 第一个手指滑动的有效距离，单位px
  public static readonly FIRST_FINGER_MOVE_THRESHOLD = 20;
}