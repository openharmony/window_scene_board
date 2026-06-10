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
import { CommonData } from '@ohos/controlcentercommon/Index';

export default class Constants {

  public static DEFAULT_WIFI_STATUS: boolean = false;
  public static DEFAULT_CELLULA_STATUS: boolean = false;
  /* status bsr real time network speed setting  */
  public static SHOW_REAL_TIME_NETWORK_SPEED: boolean = false;

  public static SPEED_THRESHOLD = 900;
  public static BYTE = 1024;

  public static BYTE_SHORT = 'B';
  public static KILO_BYTE_SHORT = 'K';
  public static MEGA_BYTE_SHORT = 'M';
  public static GIGA_BYTE_SHORT = 'G';

  public static DEFAULT_SCREENOFF_STATUS = false;
}

export class LinkSpeedData extends CommonData {
  public isWifiConnected: boolean = Constants.DEFAULT_WIFI_STATUS;
  public isCellularConnected: boolean = Constants.DEFAULT_CELLULA_STATUS;
  public showNetWorkSpeed: boolean = Constants.SHOW_REAL_TIME_NETWORK_SPEED;
  public isScreenOff: boolean = Constants.DEFAULT_SCREENOFF_STATUS;
}
