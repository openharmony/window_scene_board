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

export default class Constants {
  static readonly WINDOW_MARGIN_LEFT = 1357;
  static readonly WINDOW_MARGIN_TOP = 60;
  static readonly WINDOW_WIDTH = 360;
  static readonly WINDOW_HEIGHT = 176;
  static readonly WINDOW_HEIGHT_UNCHARGING = 160;

  static readonly DEFAULT_WINDOW_WIDTH = 1706;

  static readonly WINDOW_NAME = 'battery';

  static readonly LOW_BATTERY_NTF_ID = 1122;
  static readonly LOW_BATTERY_NTF_ICON = 'lowBattery_light';
  static readonly LOW_BATTERY_NTF_VALUE = '10%';

  static readonly SHUTDOWN_NTF_ID = 1123;
}