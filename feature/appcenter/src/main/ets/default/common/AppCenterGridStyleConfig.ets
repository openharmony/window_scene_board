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

import { CommonConstants } from '@ohos/launchercommon';
import { PresetStyleConstants } from '@ohos/launchercommon';
import { LayoutViewModel } from '@ohos/launchercommon';
import { AppGridStyleConfig } from '@ohos/launchercommon';
import FeatureConstants from './constants/FeatureConstants';

/**
 * style config of AppCenter
 */
export class AppCenterGridStyleConfig extends AppGridStyleConfig {
  public static singleName: string = 'AppCenterGridStyleConfig';
  private mPadding = PresetStyleConstants.DEFAULT_APP_CENTER_PADDING;
  public mAppCenterMarginBottom: number = 0;

  public static APP_GRID_STYLE_CONFIG = 'AppGridStyleConfig';
  public static EXT_APP_GRID_STYLE_CONFIG = 'ExtAppGridStyleConfig';

  private configName: string = AppCenterGridStyleConfig.APP_GRID_STYLE_CONFIG;

  protected constructor() {
    super();
  }

  /**
    * Obtains the AppCenterGridStyleConfig instance.
    *
    * @return AppCenterGridStyleConfig
   */
  static getInstance(): AppCenterGridStyleConfig {
    if (globalThis.AppCenterGridStyleConfigInstance == null) {
      globalThis.AppCenterGridStyleConfigInstance = new AppCenterGridStyleConfig();
      let instance = globalThis.AppCenterGridStyleConfigInstance as AppCenterGridStyleConfig;
      instance.setConfigName(AppCenterGridStyleConfig.APP_GRID_STYLE_CONFIG);
    }
    globalThis.AppCenterGridStyleConfigInstance.initConfig();
    return globalThis.AppCenterGridStyleConfigInstance;
  }

  static getExtInstance(): AppCenterGridStyleConfig {
    if (globalThis.ExtAppCenterGridStyleConfigInstance == null) {
      globalThis.ExtAppCenterGridStyleConfigInstance = new AppCenterGridStyleConfig();
      let instance = globalThis.ExtAppCenterGridStyleConfigInstance as AppCenterGridStyleConfig;
      instance.setConfigName(AppCenterGridStyleConfig.EXT_APP_GRID_STYLE_CONFIG);
    }
    globalThis.ExtAppCenterGridStyleConfigInstance.initConfig();
    return globalThis.ExtAppCenterGridStyleConfigInstance;
  }

  initConfig(screenId: number = 0, isRefresh: boolean = false, width?: number, height?: number): void {
    const result = LayoutViewModel.getInstance().calculateAppCenter(screenId, isRefresh, width, height);
    this.mColumnsGap = result.mColumnsGap ?? this.mColumnsGap;
    this.mRowsGap = result.mRowsGap ?? this.mRowsGap;
    this.mColumns = result.mColumns ?? this.mColumns;
    this.mRows = result.mRows ?? this.mRows;
    this.mGridWidth = result.mGridWidth ?? this.mGridWidth;
    this.mGridHeight = result.mGridHeight ?? this.mGridHeight;
    this.mPadding = result.mPadding ?? this.mPadding;
    this.mNameSize = result.mNameSize ?? this.mNameSize;
    this.mNameHeight = result.mNameHeight ?? this.mNameHeight;
    this.mIconSize = result.mIconSize ?? this.mIconSize;
    this.mNameLines = result.mNameLines ?? this.mNameLines;
    this.mAppItemSize = result.mAppItemSize ?? this.mAppItemSize;
    this.mIconMarginVertical = result.mIconMarginVertical ?? this.mIconMarginVertical;
    this.mAppCenterMarginLeft = result.mAppCenterMarginLeft ?? this.mAppCenterMarginLeft;
    this.mAppCenterMarginTop = result.mAppCenterMarginTop ?? this.mAppCenterMarginTop;
    this.mAppCenterItemWidth = result.mAppCenterItemWidth ?? this.mAppCenterItemWidth;
    this.mAppCenterItemHeight = result.mAppCenterItemHeight ?? this.mAppCenterItemHeight;
    this.mIndicatorBottom = result.mIndicatorBottom ?? this.mIndicatorBottom;
    this.mAppCenterMarginBottom = result.mAppCenterMarginBottom ?? this.mAppCenterMarginBottom;
  }

  private setConfigName(configName: string): void {
    this.configName = configName;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE;
  }

  getFeatureName(): string {
    return FeatureConstants.FEATURE_NAME;
  }

  getConfigName(): string {
    return this.configName;
  }
}