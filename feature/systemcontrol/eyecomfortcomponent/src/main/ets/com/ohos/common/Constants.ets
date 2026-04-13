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

import { SettingsConstants } from '@ohos/commonconstants/src/main/ets/constants/Constants';

export default class Constants {
  public static readonly LOTTIE_DATA_DAY: string = 'eyecomfort_day.json';
  public static readonly LOTTIE_DATA_SCHEDULE: string = 'eyecomfort_schedule.json';
  public static readonly LOTTIE_DATA_SWING: string = 'eyecomfort_swing.json';
  public static readonly LOTTIE_DATA_SCHEDULE_CLOSE: string = 'eyecomfort_schedule_close.json';
  public static readonly LOTTIE_DATA_SCHEDULE_OPEN: string = 'eyecomfort_schedule_open.json';
  public static readonly LOTTIE_DATA_SWING_CLOSE: string = 'eyecomfort_swing_close.json';
  public static readonly LOTTIE_DATA_SWING_OPEN: string = 'eyecomfort_swing_open.json';

  public static readonly ITEM_OPEN_ALL_DAY: string = 'ITEM_OPEN_ALL_DAY';
  public static readonly ITEM_OPEN_SCHEDULE: string = 'ITEM_OPEN_SCHEDULE';
  public static readonly ITEM_OPEN_SWING: string = 'ITEM_OPEN_SWING';

  public static readonly modelToLottieMap: Map<string, string> = new Map([
    [this.ITEM_OPEN_ALL_DAY, this.LOTTIE_DATA_DAY],
    [this.ITEM_OPEN_SCHEDULE, this.LOTTIE_DATA_SCHEDULE],
    [this.ITEM_OPEN_SWING, this.LOTTIE_DATA_SWING]
  ]);

  public static readonly modeToSubpageUImap: Map<string, string> = new Map([
    [SettingsConstants.EYE_SHIELD_MODE_OPEN_ALL_DAY, this.ITEM_OPEN_ALL_DAY],
    [SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_CUSTOM, this.ITEM_OPEN_SCHEDULE],
    [SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET, this.ITEM_OPEN_SCHEDULE],
    [SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SWING, this.ITEM_OPEN_SWING]
  ]);
}

export class EyeComfortToggleData {
  /**
   * 上次开启的护眼模式
   */
  public eyeComfortLastMode: string = SettingsConstants.EYE_SHIELD_MODE_DEFAULT;
}