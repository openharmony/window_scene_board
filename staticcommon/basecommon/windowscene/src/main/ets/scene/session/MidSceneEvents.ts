/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
export class MidSceneEvents {
  // always
  static readonly EVENT_ALWAYS: string = 'always';
  // focus shift
  public static readonly EVENT_FOCUS_TRANSFER: string = 'focus_transfer';
  // enter mid scene
  public static readonly EVENT_ENTER: string = 'enterAlways';

  // enter mid scene by dragging divider
  public static readonly EVENT_ENTER_BY_SPLIT: string = 'enter_by_split';
  // enter mid scene by pinch
  public static readonly EVENT_ENTER_BY_PINCH: string = 'enter_by_pinch';
  // enter mid scene by one step
  public static readonly EVENT_ENTER_BY_ONE_STEP: string = 'enter_by_one_step';
  // enter mid scene batch
  public static readonly EVENT_ENTER_BATCH: string = 'enter_batch';

  // followings are interactive events in mid scene state
  // click add button
  public static readonly EVENT_MENU_ADD_CLICK: string = 'menu_add_click';
  // click add area
  public static readonly EVENT_ADD_AREA_CLICK: string = 'add_area_click';
  // click dock
  public static readonly EVENT_DOCK_CLICK: string = 'dock_click';
  // drag title bar
  public static readonly EVENT_TITLE_BAR_DRAG: string = 'title_bar_drag';
  // click replace button
  public static readonly EVENT_MENU_REPLACE_CLICK: string = 'menu_replace_click';
  // remove window
  public static readonly EVENT_REMOVE_WINDOW: string = 'menu_remove_window';
  // click max button
  public static readonly EVENT_MENU_MAX_CLICK: string = 'menu_max_click';
  // expand to fold
  public static readonly EVENT_EXPAND_TO_FOLD: string = 'expand_to_fold';
  // fold to expand
  public static readonly EVENT_FOLD_TO_EXPAND: string = 'fold_to_expand';
  // horizontal to vertivcal
  public static readonly EVENT_ROTATE_VERTICAL_PAD: string = 'horizontal_to_vertivcal';
  // vertivcal to horizontal
  public static readonly EVENT_ROTATE_HORIZONTAL_PAD: string = 'vertivcal_to_horizontal';
  // click window
  public static readonly EVENT_WINDOW_CLICK: string = 'window_click';
  // three finger slide
  public static readonly EVENT_THREE_FINGER_SLIDE: string = 'three_finger_slide';
  // adjust window size
  public static readonly EVENT_ADJUST_WINDOW_SIZE: string = 'adjust_window_size';
  // area out of dock
  public static readonly EVENT_OUT_OF_DOCK: string = 'onOutOfDock';

  // followings are desktop interactions click desktop icon
  public static readonly EVENT_CLICK_DESKTOP_ICON: string = 'click_desktop_icon';
  // click recent icon
  public static readonly EVENT_CLICK_RECENT_ICON: string = 'click_recent_icon';
  // back gesture
  public static readonly EVENT_CANCEL_WAITING_STATUS: string = 'cancel_waiting_status';
  // start ability
  public static readonly EVENT_START_ABILITY: string = 'start_ability';

  // followings are notification interactions
  // click notification
  public static readonly EVENT_NOTIFICATION_CLICK: string = 'notification_click';

  // Device on lock screen
  public static readonly EVENT_SCREEN_LOCK: string = 'screen_lock';

  // middle to full for gesture
  public static readonly EVENT_MIDDLE_TO_FULL: string = 'middle_to_full';
  // full to middle for gesture
  public static readonly EVENT_FULL_TO_MIDDLE: string = 'full_to_middle';
  // middle to middle for gesture
  public static readonly EVENT_MIDDLE_TO_MIDDLE: string = 'middle_to_middle';

  // pip restore
  public static readonly EVENT_PIP_RESTORE: string = 'pip_restore';

  // scene replace
  public static readonly EVENT_SCENE_REPLACE: string = 'scene_replace';

  // triple fold state change for m to g
  public static readonly EVENT_ULTRA_SCREEN_STATE_CHANGE_M_TO_G: string = 'triple_fold_state_change_m_to_g';

  // triple fold state change for g to m
  public static readonly EVENT_ULTRA_SCREEN_STATE_CHANGE_G_TO_M: string = 'triple_fold_state_change_g_to_m';
}