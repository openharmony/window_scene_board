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

export default class PrivacyConstant {
  // 入场动画播放完后停留5s
  public static readonly OPEN_PANEL_ABOUT_TO_DISAPPEAR_DELAY: number = 5000;
  // 退场动画播放完后停留3s
  public static readonly CLOSE_PANEL_ABOUT_TO_DISAPPEAR_DELAY: number = 3000;
  // 入场动画播放持续92帧
  public static readonly OPEN_ANIMATION_PLAYING_DURATION: number = 1533;
  // 退场动画播放持续47帧
  public static readonly CLOSE_ANIMATION_PLAYING_DURATION: number = 783;
  public static readonly RUN_COUNT_DEFAULT: number = 0;
  // 浅色模式与深色模式下是不同超级隐私状态栏，通过大桌面appStorage传递计数器值来在多个状态栏间共享数据（通过PluginComponent跨应用传数据）
  public static readonly SUPER_PRIVACY_PADDLE_STATUS_COUNTERS: string = 'SuperPrivacyPaddleStatusCounters';
  public static readonly SUPER_PRIVACY_PADDLE_STATUS_BAR_COUNTERS: string = 'SuperPrivacyPaddleStatusBarCounters';
  public static readonly SUPER_PRIVACY_PADDLE_PANEL_ANIMATION_ENABLE: string = 'superPrivacyPaddlePanelAnimationEnable';
  public static readonly SLOT_STATUS_SUPER_PRIVACY_PADDLE = 'status_bar_super_privacy_scene_board_paddle';
  public static readonly SLOT_STATUS_SUPER_PRIVACY_PC_SOFT = 'status_bar_super_privacy_scene_board_soft';
  public static readonly PANEL_UNIT: string = 'vp';
  public static readonly STATUS_BAR_ID: string = 'SuperPrivacyPaddleStatusBarIcon';
  public static readonly FULL_WIDTH: string = '100%';
  public static readonly FULL_HEIGHT: string = '100%';
  public static readonly VP_SMALL_COLUMN_LAYOUT_MARGIN: number = 16;
  public static readonly VP_BIG_COLUMN_LAYOUT_MARGIN: number = 24;
  public static readonly ANIMATION_CAMERA_NAME: string = 'camera';
  public static readonly ANIMATION_LOCATION_NAME: string = 'location';
  public static readonly ANIMATION_MICROPHONE_NAME: string = 'microphone';
  public static readonly OPEN_CAMERA_PANEL_ANIMATION_NAME: string =
    'resources/rawfile/lottie/ic_super_privacy_camera_open_panel.json';
  public static readonly CLOSE_CAMERA_PANEL_ANIMATION_NAME: string =
    'resources/rawfile/lottie/ic_super_privacy_camera_close_panel.json';
  public static readonly OPEN_LOCATION_PANEL_ANIMATION_NAME: string =
    'resources/rawfile/lottie/ic_super_privacy_location_open_panel.json';
  public static readonly CLOSE_LOCATION_PANEL_ANIMATION_NAME: string =
    'resources/rawfile/lottie/ic_super_privacy_location_close_panel.json';
  public static readonly OPEN_MICROPHONE_PANEL_ANIMATION_NAME: string =
    'resources/rawfile/lottie/ic_super_privacy_microphone_open_panel.json';
  public static readonly CLOSE_MICROPHONE_PANEL_ANIMATION_NAME: string =
    'resources/rawfile/lottie/ic_super_privacy_microphone_close_panel.json';
}