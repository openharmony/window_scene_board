/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

export class IntentCodeConstants {
  public static readonly DEFAULT_CODE_SUCCESS = 0; /* 执行成功 */
  public static readonly DEFAULT_CODE_FAILED = 10010001; /* 执行失败 */
}

export class IntentNameConstants {
  /**
   * 桌面下滑
   */
  public static readonly DESKTOP_SLIDE: string = 'desktop_slide';
  /**
   * 判断是否支持能力
   */
  public static readonly CHECK_SETTING_ITEM: string = 'CheckSettingItem';
  /**
   * 读取开关项
   */
  public static readonly GET_SETTING_SWITCH: string = 'GetSettingSwitch';
  /**
   * 设置开关项
   */
  public static readonly SET_SETTING_SWITCH: string = 'SetSettingSwitch';
}