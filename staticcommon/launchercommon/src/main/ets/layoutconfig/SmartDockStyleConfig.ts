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

import { AppListStyleConfig } from './AppListStyleConfig';
import { CommonConstants } from '../constants/CommonConstants';

/**
 * Dock style configuration class
 */
export default class SmartDockStyleConfig extends AppListStyleConfig {
  private static mInstance: SmartDockStyleConfig;

  /**
   * dock list height
   */
  public mDockHeight = 78;

  /**
   * dock list background color
   */
  public mBackgroundColor = '#85FAFAFA';

  /**
   * dock list rounded corner value
   */
  public mDockRadius = 22;

  /**
   * dock list background blur
   */
  public mBackdropBlur = 0;

  /**
   * dock list padding
   */
  public mDockPadding = 9;

  /**
   * dock list margin
   */
  public mDockMargin = 10;

  /**
   * List item width
   */
  public mListItemWidth = 60;

  /**
   * List item height
   */
  public mListItemHeight = 60;

  /**
   * List item spacing
   */
  public mListItemGap = 2;

  /**
   * list direction
   */
  public mListDirection: Axis = Axis.Horizontal;

  /**
   * Whether the list name is displayed next to
   */
  public mNameDisplaySide = true;

  /**
   * Whether to display the application name
   */
  public mWithAppName = false;

  /**
   * list icon size
   */
  public mIconSize = 54;

  /**
   * the inner margin of the entry
   */
  public mItemPadding = 3;

  /**
   * the background color of the entry
   */
  public mItemBackgroundColor = '';

  /**
   * the rounded corner value of the entry
   */
  public mItemBorderRadius = 0;

  /**
   * Residential area and non-residential area gap
   */
  public mDockGap = 12;

  /**
   * The maximum number of displays in the resident area
   */
  public mMaxDockNum = 16;

  /**
   * The maximum number of non-resident areas displayed
   */
  public mMaxRecentNum = 3;

  protected constructor() {
    super();
  }

  /**
   * Get the dock style instance
   */
  static getInstance(): SmartDockStyleConfig {
    if (SmartDockStyleConfig.mInstance == null) {
      SmartDockStyleConfig.mInstance = new SmartDockStyleConfig();
      SmartDockStyleConfig.mInstance.initConfig();
    }
    return SmartDockStyleConfig.mInstance;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }
}
