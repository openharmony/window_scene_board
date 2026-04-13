/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import FeatureConstants from './constants/FeatureConstants';
import { StyleConstants, CommonConstants, AppListStyleConfig } from '@ohos/launchercommon';

/**
 * App center list style configuration class
 */
export default class AppCenterListStyleConfig extends AppListStyleConfig {
  /**
   * List item width
   */
  public mListItemWidth: string | number = StyleConstants.PERCENTAGE_100;

  /**
   * List item height
   */
  public mListItemHeight: string | number = StyleConstants.DEFAULT_80;

  /**
   * List item spacing
   */
  public mListItemGap = 12;

  /**
   * Whether the list name is displayed next to
   */
  public mNameDisplaySide = true;

  /**
   * list icon size
   */
  public mIconSize: number = StyleConstants.DEFAULT_APP_ITEM_WIDTH;

  /**
   * list name size
   */
  public mNameSize: number = StyleConstants.DEFAULT_APP_NAME_SIZE;

  /**
   * Spacing between list icons and names
   */
  public mNameIconGap: number = StyleConstants.DEFAULT_NUMBER;

  /**
   * the inner margin of the entry
   */
  public mItemPadding = 8;

  /**
   * the background color of the entry
   */
  public mItemBackgroundColor: string = StyleConstants.LIGHT_BLACK;

  /**
   * the rounded corner value of the entry
   */
  public mItemBorderRadius: number = StyleConstants.DEFAULT_20;

  protected constructor() {
    super();
  }

  /**
   * Get an instance of the app center list style
   */
  static getInstance(): AppCenterListStyleConfig {
    if (globalThis.AppCenterListStyleConfig == null) {
      globalThis.AppCenterListStyleConfig = new AppCenterListStyleConfig();
      globalThis.AppCenterListStyleConfig.initConfig();
    }
    return globalThis.AppCenterListStyleConfig;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE;
  }

  getFeatureName(): string {
    return FeatureConstants.FEATURE_NAME;
  }
}