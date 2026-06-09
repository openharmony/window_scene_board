/**
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
import SettingItemOption from './SettingItemOption';

/**
 * Item info for launcher settings.
 */
export class SettingItemInfo {
  /**
   * Index for setting item.
   */
  public ida: number | undefined;

  /**
   * Setting item name
   */
  public settingName: string | undefined;

  /**
   * Current value of this item.
   */
  public settingValue: string | undefined;

  /**
   * Option list for this item.
   */
  public valueList: SettingItemOption[] = [];

  /**
   * settings option type.
   */
  public settingType: number | undefined;
}