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
  public static readonly WINDOW_MARGIN_LEFT = 8;
  public static readonly WINDOW_MARGIN_TOP = 60;
  public static readonly WINDOW_WIDTH = 180;
  public static readonly DEFAULT_SYSTEM_PANEL_HEIGHT = 225;
  public static readonly HAD_SYSTEM_PANEL_HEIGHT = 222.8;
  public static readonly EMULATOR_SYSTEM_PANEL_HEIGHT = 90;
  public static readonly DEFAULT_WINDOW_WIDTH = 1706;
  public static readonly WINDOW_NAME = 'system';
  public static readonly REQUEST_FOCUS_MENU: string = 'request_focus_menu';
}

export enum MenuType {
  INVAILD_MENU = 0,
  INFO_MENU = 1,
  SETTINGS_MENU = 2,
  SLEEP_MENU = 3,
  LOCK_MENU = 4,
  SHUTDOWN_MENU = 5,
  REBOOT_MENU = 6,
}

export interface InputDeviceInfo {
  id: number;
  name: string;
  deviceSource: string;
  deviceChangeType: string;
}

export interface StateChangeListener { onStateChange: Function }