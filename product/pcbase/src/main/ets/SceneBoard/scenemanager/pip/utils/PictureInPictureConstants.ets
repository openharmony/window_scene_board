/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import curves from '@ohos.curves';
import { OverlayButtonModifier } from '../style/OverlayButtonModifier';

export class Constants {
  public static readonly ACTION_CLOSE = 'close';
  public static readonly ACTION_REQUEST_CLOSE = 'request_close';
  public static readonly ACTION_PANEL_CLOSE = 'panel_close';
  public static readonly ACTION_PRE_RESTORE = 'pre_restore';
  public static readonly ACTION_RESTORE = 'restore';
  public static readonly ACTION_PREPARE_SOURCE = 'prepare_source';
  public static readonly ACTION_LOCATE_SOURCE = 'locate_source';
  public static readonly ACTION_DESTROY = 'destroy';
  public static readonly PLAY_BACK_STATE_CHANGE = 'playbackStateChanged';
  public static readonly HANG_UP = 'hangUp';
  public static readonly MIC_STATE_CHANGE = 'micStateChanged';
  public static readonly VIDEO_STATE_CHANGE = 'videoStateChanged';
  public static readonly VOICE_STATE_CHANGE = 'voiceStateChanged';
  public static readonly PREVIOUS_VIDEO = 'previousVideo';
  public static readonly NEXT_VIDEO = 'nextVideo';
  public static readonly FAST_FORWARD = 'fastForward';
  public static readonly FAST_BACKWARD = 'fastBackward';

  public static readonly ACTION_DOCK_CLOSE = 'dock_close';
  public static readonly ACTION_DOCK_RESTORE = 'dock_restore';
  public static readonly ACTION_DOCK_STEP_RESTORE = 'dock_step_restore';

  public static readonly ACTION_STATUS_UNDEFINED = -1;
  public static readonly ACTION_STATUS_OFF = 0;
  public static readonly ACTION_STATUS_ON = 1;

  public static readonly DEFAULT_PIP_TOP_AVOID_AREA = 150;
  public static readonly DEFAULT_PIP_BOTTOM_AVOID_AREA = 150;
  public static readonly DEFAULT_PIP_LEFT_AVOID_AREA = 12;
  public static readonly DEFAULT_PIP_STRIP_AVOID_AREA = 4;
  public static readonly DEFAULT_PIP_MINIMIZE_WIDTH = 24;
  public static readonly DEFAULT_PIP_STRIP_BOARDER_RADIUS = 12;
  public static readonly DEFAULT_PIP_MOVE_DISTANCE = 2;
  public static readonly DEFAULT_PIP_CONTENT_AVOID_AREA = 12;
  public static readonly SAFE_PADDING_HOR = 150;
  public static readonly DEFAULT_PIP_RADIUS = 16;

  public static readonly SAFE_PADDING_HORIZONTAL_VP = 12;
  public static readonly SAFE_PADDING_VERTICAL_TOP = 150;
  public static readonly SAFE_PADDING_VERTICAL_BOTTOM = 150;
  public static readonly DEFAULT_PROPORTION = 0.3;
  public static readonly DEFAULT_EXPAND_PROPORTION = 0.15;
  public static readonly PAD_DEFAULT_PROPORTION = 0.8;
  public static readonly NUMBER_TWO = 2;
  public static readonly NUMBER_THREE = 3;
  public static readonly NUMBER_FOUR = 4;
  public static readonly NUMBER_FIVE = 5;
  public static readonly NUMBER_SEVEN = 7;

  public static readonly PREVIOUS_NEXT = 101;
  public static readonly FAST_FORWARD_BACKWARD = 102;
  public static readonly CALL_MICROPHONE_SWITCH = 201;
  public static readonly CALL_HANGUP = 202;
  public static readonly CALL_CAMERA_SWITCH = 203;
  public static readonly CALL_MUTE_SWITCH = 204;

  public static readonly MEETING_HANGUP = 301;
  public static readonly MEETING_CAMERA_SWITCH = 302;
  public static readonly MUTE_SWITCH = 303;
  public static readonly RESET_PIP_RESTORE_TIMEOUT = 500;
  public static readonly MEETING_MUTE_SWITCH = 303;
  public static readonly MEETING_MICROPHONE_SWITCH = 304;

  public static readonly LIVE_PLAY_PAUSE = 401;
  public static readonly LIVE_MUTE_SWITCH = 402;
  public static readonly KEY_PIP_SCALE = 'key_pip_scale_level';
  public static readonly KEY_PIP_WINDOW_POS_X = 'pip_window_pos_x';
  public static readonly KEY_PIP_WINDOW_POS_Y = 'pip_window_pos_y';
  public static readonly KEY_PIP_WINDOW_WIDTH = 'pip_window_width';
  public static readonly KEY_PIP_WINDOW_HEIGHT = 'pip_window_height';
  public static readonly PIP_OLD_SCREEN_STATUS = 'pip_old_screen_status';
  public static readonly SIZE_ARRAY = [1.0, 1.5];
  public static readonly ITEM_SPACE = [[24, 36], [8, 24]];
  public static readonly BOTTOM_PADDING_ARRAY = [12, 24];

  public static readonly DEFAULT_SPACE = 8;
  public static readonly DEFAULT_SMALL_BUTTON_SIZE = 16;
  public static readonly DEFAULT_BIG_IMAGE_SIZE = 12;
  public static readonly DEFAULT_BIG_BUTTON_SIZE = 24;
  public static readonly DEFAULT_BOTTOM_PADDING = 12;
  public static readonly DEFAULT_GRADIENT_HEIGHT = 48;
  public static readonly MAX_ICON_NUM = 3;
  public static readonly LARGE_ICON_PIP_WIDTH_MINIMUM = [68, 140, 188];
  public static readonly DELAY_CLOSE_FOR_SNAPSHOT = 16;
  public static readonly DELAY_GET_LOCATE_SOURCE = 64;
  public static readonly RESTORE_TIME_OUT = 1500;
  public static readonly MINI_VALUE = 0.1;

  public static readonly DRAG_MOVE_SCALE = 1.05;
  public static readonly DRAG_MOVE_CURVE = curves.responsiveSpringMotion(0.15, 0.86, 0.25);
  public static readonly DRAG_MOVE_SCALE_CURVE = curves.responsiveSpringMotion(0.4, 1)
  public static readonly DRAG_MOVE_INERTIAL_SLIDING_PERCENTAGE = 0.08;
  public static readonly DRAG_MOVE_INERTIAL_SLIDING_CURVE = curves.responsiveSpringMotion(0.6, 1);
  public static readonly OVERLAY_BUTTON_CLICK_EFFECT_CURVE = curves.interpolatingSpring(10, 1, 410, 38);
  public static readonly OVERLAY_BUTTON_MODIFIER: OverlayButtonModifier = new OverlayButtonModifier();

  public static readonly DRAG_MOVE_DUMPSTER_CLOSE_SCALE = 0.8;
  public static readonly DRAG_MOVE_DUMPSTER_CLOSE_OPACITY = 0.4;
  public static readonly DRAG_MOVE_DUMPSTER_CLOSE_CURVE = curves.springMotion(0.55, 1);
}

export enum PipRectUpdateReason {
  DEFAULT,
  REASON_PIP_START,
  REASON_PIP_MOVE,
  REASON_PIP_RATIO_CHANGE,
  REASON_PIP_SCALE_CHANGE,
  REASON_PIP_DESTROY,
  REASON_ROTATION_CHANGE,
  REASON_PIP_EXPAND,
  REASON_PIP_FOLD,
};

export enum PipTemplate {
  TYPE_VIDEO_PLAY,
  TYPE_VIDEO_CALL,
  TYPE_VIDEO_MEETING,
  TYPE_LIVE,
};
