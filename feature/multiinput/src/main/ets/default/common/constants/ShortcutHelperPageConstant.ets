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

export interface SingleShortcutKeyItemProp {
  description: ResourceStr,
  isMulti: boolean,
  firstKeyList: ResourceStr[],
  secondKeyList?: ResourceStr[]
}

export default class ShortcutHelperPanelKeyItemConstants {
  public static readonly PAD_SYSTEM_FUNCTION_KEY_ITEM_PART_ONE: SingleShortcutKeyItemProp[] = [
    {
      description: $r('app.string.system_function_go_home'),
      // description: Re.getStringSync,
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_d')]
    },
    {
      description: $r('app.string.system_function_screen_lock'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_l')]
    },
    {
      description: $r('app.string.system_function_screen_shot'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_shift'),
        $r('app.string.system_function_show_desktop_key_s')]
    },
    {
      description: $r('app.string.system_function_screen_record'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_shift'),
        $r('app.string.system_function_show_desktop_key_r')]
    },
    {
      description: $r('app.string.system_function_voice_search'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_s')]
    },
    {
      description: $r('app.string.system_function_shortcut_key_pannel'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_question_mark')]
    }
  ];
  public static readonly PAD_SYSTEM_FUNCTION_KEY_ITEM_PART_TWO: SingleShortcutKeyItemProp[] = [
    {
      description: $r('app.string.system_function_notification_center'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_n')],
    },
    {
      description: $r('app.string.system_function_control_center'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_c')],
    },
    {
      description: $r('app.string.system_function_task_center'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_tab')],
    },
    {
      description: $r('app.string.system_function_back'),
      isMulti: false,
      firstKeyList: ['logo', 'backSpace']
    },
    {
      description: $r('app.string.system_function_switch_inputmethod'),
      isMulti: true,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_space')],
      secondKeyList: [$r('app.string.system_function_show_desktop_key_ctrl'),
        $r('app.string.system_function_show_desktop_key_shift')]
    },
    {
      description: $r('app.string.system_function_open_file_manager'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_f')]
    }
  ];
  public static readonly PAD_WINDOW_MANAGER_KEY_ITEM: SingleShortcutKeyItemProp[] = [
    {
      description: $r('app.string.window_manager_switch_application'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_alt'),
        $r('app.string.system_function_show_desktop_key_tab')]
    },
    {
      description: $r('app.string.window_manager_min_window'),
      isMulti: false,
      firstKeyList: ['logo', $r('app.string.system_function_show_desktop_key_m')]
    },
    {
      description: $r('app.string.window_manager_close_window'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_alt'),
        $r('app.string.system_function_show_desktop_key_f4')]
    },
  ];
  public static readonly PAD_FOCUS_NAVIGATION_ITEM_PART_ONE: SingleShortcutKeyItemProp[] = [
    {
      description: $r('app.string.focus_navigation_active'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_tab')],
    },
    {
      description: $r('app.string.focus_navigation_move_to_next'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_tab')],
    },
    {
      description: $r('app.string.focus_navigation_move_to_pre'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_shift'),
        $r('app.string.system_function_show_desktop_key_tab')]
    },
    {
      description: $r('app.string.focus_navigation_move_to_top'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_home'), 'directionLeft']
    },
    {
      description: $r('app.string.focus_navigation_move_to_end'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_end'), 'directionRight']
    },
    {
      description: $r('app.string.focus_navigation_direction_keys_move_focus'),
      isMulti: false,
      firstKeyList: ['direction']
    }
  ];
  public static readonly PAD_FOCUS_NAVIGATION_ITEM_PART_TWO: SingleShortcutKeyItemProp[] = [
    {
      description: $r('app.string.focus_navigation_active_action'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_space')]
    },
    {
      description: $r('app.string.focus_navigation_enter_and_focus'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_enter')]
    },
    {
      description: $r('app.string.focus_navigation_cancel_current_operation'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_esc')]
    },
    {
      description: $r('app.string.focus_navigation_open_context_menu'),
      isMulti: false,
      firstKeyList: [$r('app.string.system_function_show_desktop_key_shift'),
        $r('app.string.system_function_show_desktop_key_f10')]
    }
  ];
}