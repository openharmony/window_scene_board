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

import { CommonConstants } from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '@ohos/smartdock';
const DPI_RATIO = 1.16;

/**
 * Dock style configuration class
 */
export default class PhoneSmartDockStyleConfig extends SmartDockStyleConfig {

  /**
   * dock list height
   */
  public mDockHeight = 78 / DPI_RATIO;

  /**
   * dock list backgroundcolor
   */
  public mBackgroundColor = '#B8FAFAFA';

  /**
   * dock list radius
   */
  public mDockRadius = 22 / DPI_RATIO;

  /**
   * dock list back drop blur
   */
  public mBackdropBlur = 360 / DPI_RATIO;

  /**
   * dock list padding
   */
  public mDockPadding = 12 / DPI_RATIO;

  /**
   * dock list margin
   */
  public mDockMargin = 10 / DPI_RATIO;

  /**
   * list item width
   */
  public mListItemWidth = 54 / DPI_RATIO;

  /**
   * list item height
   */
  public mListItemHeight = 54 / DPI_RATIO;

  /**
   * list item gap
   */
  public mListItemGap = 33 / DPI_RATIO;

  /**
   * list icon size
   */
  public mIconSize = 54 / DPI_RATIO;

  /**
   * max display item count in dock list
   */
  // public mMaxDockNum = 4;
  private static phoneInstance: PhoneSmartDockStyleConfig;

  protected constructor() {
    super();
  }

  static getInstance(): PhoneSmartDockStyleConfig {
    if (PhoneSmartDockStyleConfig.phoneInstance == null) {
      PhoneSmartDockStyleConfig.phoneInstance = new PhoneSmartDockStyleConfig();
      PhoneSmartDockStyleConfig.phoneInstance.initConfig();
    }
    return PhoneSmartDockStyleConfig.phoneInstance;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }
}
