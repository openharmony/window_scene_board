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
  public static readonly LOTTIE_DATA_OPEN: string = 'flashlight_on.json';
  public static readonly LOTTIE_DATA_CLOSE: string = 'flashlight_off.json';
  public static readonly LOTTIE_DATA_OPEN_DARK: string = 'flashlight_on_dark.json';
  public static readonly LOTTIE_DATA_CLOSE_DARK: string = 'flashlight_off_dark.json';

  public static readonly NEW_LOTTIE_DATA_OPEN: string = 'flashlight_on.json';
  public static readonly NEW_LOTTIE_DATA_CLOSE: string = 'flashlight_off.json';

  /**
   * 意图参数
   */
  public static readonly FLASH_LIGHT_UNAVAILABLE_OPEN: number = 10080001;
  public static readonly FLASH_LIGHT_UNAVAILABLE_CLOSE: number = 10080002;

  public static readonly intentNameSet: Set<string> = new Set(['CloseFlashlight', 'OpenFlashlight']);

  /**
   * 通知参数
   */
  public static readonly NTF_ID: number = 1227;
  public static readonly APP_ICON: string = 'ic_flashlight_app_icon';
  public static readonly BUTTON_ICON: string = 'ic_flashlight_button_icon';
  public static readonly BTN_NAME: string = 'flashlightOffBtn';
}