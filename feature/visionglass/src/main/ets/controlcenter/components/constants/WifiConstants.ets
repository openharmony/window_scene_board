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

import { ControlCenterConstants } from './ControlCenterConstants';

export class WifiConstants extends ControlCenterConstants {
  public static DEFAULT_WIFI_NAME: string = 'WLAN';
  public static DEFAULT_WIFI_INFO: number = 0;
  public static DEFAULT_WIFI_STATUS: boolean = false;
  public static DEFAULT_WIFI_NETID: number = -1;
  public static WIFI_SIGNAL_NO: number = 0;
  public static WIFI_SIGNAL_LOW: number = 1;
  public static WIFI_SIGNAL_MID: number = 2;
  public static WIFI_SIGNAL_HIGH: number = 3;
  public static WIFI_SIGNAL_FULL: number = 4;
  public static readonly CATEGORY_DEFAULT = 1;
  public static readonly CATEGORY_WIFI6 = 2;
  public static readonly CATEGORY_WIFI6_PLUS = 3;
  public static readonly CATEGORY_DOUBLE = 4;
  public static readonly CATEGORY_DOUBLE_WIFI6 = 5;
  public static readonly CATEGORY_DOUBLE_WIFI6_PLUS = 6;
}

export function calculateSize(windowHeight: number, scale: number): string {
  return ((windowHeight as number) * scale) + 'px';
}