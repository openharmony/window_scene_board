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

import audio from '@ohos.multimedia.audio';

export default class Constants {
  public static readonly LOTTIE_DATA_SILENT_TO_RING: string = 'silent_to_ring.json';
  public static readonly LOTTIE_DATA_RING_TO_VIBRATE: string = 'ring_to_vibrate.json';
  public static readonly LOTTIE_DATA_VIBRATE_TO_SILENT: string = 'vibrate_to_silent.json';

  public static readonly LOTTIE_DATA_SILENT_TO_RING_DARK: string = 'silent_to_ring_dark.json';
  public static readonly LOTTIE_DATA_RING_TO_VIBRATE_DARK: string = 'ring_to_vibrate_dark.json';
  public static readonly LOTTIE_DATA_RING_TO_SILENT_DARK: string = 'ring_to_silent_dark.json';
  public static readonly LOTTIE_DATA_VIBRATE_TO_SILENT_DARK: string = 'vibrate_to_silent_dark.json';

  public static readonly NEW_LOTTIE_DATA_SILENT_TO_RING: string = '03silent_to_ring.json';
  public static readonly NEW_LOTTIE_DATA_RING_TO_VIBRATE: string = '01ring_to_vibrate.json';
  public static readonly NEW_LOTTIE_DATA_VIBRATE_TO_SILENT: string = '02vibrate_to_silent.json';

  /**
   * 通知参数
   */
  public static readonly RING_MODE_NTF_ID = 1440;
  public static readonly RING_MODE_CAPSULE_ICON = 'ic_flashlight_on';
  public static readonly RINGER_MODE_SILENT = 'control_center_complex_toggle_ring_mode_title_off';
  public static readonly RINGER_MODE_VIBRATE = 'control_center_complex_toggle_ring_mode_title_vibration';
  public static readonly RINGER_MODE_NORMAL = 'control_center_complex_toggle_ring_mode_title_on';
  public static readonly RINGER_MODE_SILENT_ICON = 'ic_controlcenter_ring_off_filled';
  public static readonly RINGER_MODE_VIBRATE_ICON = 'ic_controlcenter_vibration_filled';
  public static readonly RINGER_MODE_NORMAL_ICON = 'ic_controlcenter_ring_on_filled';
  public static readonly VIBRATION_EFFECT_RING_NOTICE = 'haptic.notice.mode_ring';
}

export class RingModeData {
  public mode: number = audio.AudioRingMode.RINGER_MODE_NORMAL;
}