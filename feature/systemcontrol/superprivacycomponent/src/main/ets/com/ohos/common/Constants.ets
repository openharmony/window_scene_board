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

import systemParameterEnhance from '@ohos.systemParameterEnhance';

export default class Constants {
  public static readonly SUPER_PRIVACY_FEATURE: string = 'const.appsecurityprivacy.superprivacy.feature_enabled';
  public static readonly PROP_DEVICE_PADDLE: string = 'const.appsecurityprivacy.superprivacy.paddle_existed';
  public static readonly SUPER_PRIVACY_FEATURE_VALUE: string =
    systemParameterEnhance.getSync(Constants.SUPER_PRIVACY_FEATURE, '0');
  public static readonly DEVICE_PADDLE_EXISTED: string = '1';
  public static readonly SUPER_PRIVACY_FEATURE_ENABLE: string = '1';
  public static readonly SUPER_PRIVACY_FEATURE_SUPPORT_FOLD: string = '3';
  public static readonly IS_SUPPORT_SOFT_PROTECT: boolean =
    Constants.SUPER_PRIVACY_FEATURE_VALUE === Constants.SUPER_PRIVACY_FEATURE_ENABLE;
  public static readonly IS_SUPPORT_FOLD_PROTECT: boolean =
    Constants.SUPER_PRIVACY_FEATURE_VALUE === Constants.SUPER_PRIVACY_FEATURE_SUPPORT_FOLD;
  public static readonly IS_PADDLE_DEVICE =
    systemParameterEnhance.getSync(Constants.PROP_DEVICE_PADDLE, '0') === Constants.DEVICE_PADDLE_EXISTED;
  public static readonly SUB_PANEL_WINDOW_HEIGHT_ZH: number = 288;
  public static readonly SUB_PANEL_WINDOW_HEIGHT_EN: number = 320;
  public static readonly SUB_PANEL_WINDOW_HEIGHT_OTHERS: number = 304;
  public static readonly SUB_PANEL_WINDOW_HEIGHT_ZH_LARGE: number = 324;
  public static readonly SUB_PANEL_WINDOW_HEIGHT_EN_LARGE: number = 480;
  public static readonly SUB_PANEL_WINDOW_HEIGHT_OTHERS_LARGE: number = 380;
  public static readonly SUB_PANEL_WINDOW_HEIGHT_HUGE: number = 480;
  public static readonly CHINESE_LANGUAGE_CODE: string = 'zh';
  public static readonly ENGLISH_LANGUAGE_CODE: string = 'en';
}