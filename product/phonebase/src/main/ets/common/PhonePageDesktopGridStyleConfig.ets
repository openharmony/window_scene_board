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

import { CommonConstants, LayoutViewModel, IconCommonUtil } from '@ohos/launchercommon';
import { NumberConstants } from '@ohos/commonconstants';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import StyleConstants from './constants/StyleConstants';
import type { ThemeStyleInfo } from '@ohos/launchercommon';
import { ThemeStyleManager } from '@ohos/launchercommon';
import { RadiusUtil } from '@ohos/launchercommon';
import { ThemeStylePreviewManager } from '@ohos/launchercommon';
import { DesktopMode } from '@ohos/launchercommon';
import { FolderResizeUtil } from '@ohos/launchercommon/Index';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';

/**
 * Phone grid style config class
 */
export default class PhonePageDesktopGridStyleConfig extends PageDesktopGridStyleConfig {
  /**
   * icon size
   */
  public mIconSize = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;

  /**
   * preview icon size
   */
  public mIconSizePreview = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;

  /**
   * name size
   */
  public mNameSize = StyleConstants.DEFAULT_APP_NAME_SIZE;

  /**
   * name height
   */
  public mNameHeight = StyleConstants.DEFAULT_APP_NAME_HEIGHT;

  /**
   * item padding
   */
  public mPaddingTop = StyleConstants.DEFAULT_APP_TOP_RATIO;

  /**
   * is Support Indicator
   */
  public mIsSupportIndicator = StyleConstants.DEFAULT_SUPPORT_INDICATOR;

  /**
   * 行间距
   */
  public mSpaceOfRow: number = 0;

  /**
   * 列间距
   */
  public mSpaceOfColumn: number = 0;

  private static phoneInstance: PhonePageDesktopGridStyleConfig;

  protected constructor() {
    super();
  }

  /**
   * get PhonePageDesktopGridStyleConfig instance
   */
  static getInstance(): PhonePageDesktopGridStyleConfig {
    if (PhonePageDesktopGridStyleConfig.phoneInstance == null) {
      PhonePageDesktopGridStyleConfig.phoneInstance = new PhonePageDesktopGridStyleConfig();
    }
    PhonePageDesktopGridStyleConfig.phoneInstance.initConfig();
    return PhonePageDesktopGridStyleConfig.phoneInstance;
  }

  initConfig(): void {
    const result = LayoutViewModel.getInstance().calculateDesktop();
    this.mMargin = result.mMargin ?? 0;
    this.mWorkSpaceMargin = result.mMargin ?? 0;
    this.mItemPadding = result.mItemPadding ?? 0;
    this.mColumnsGap = result.mColumnsGap ?? 0;
    this.mRowsGap = result.mRowsGap ?? 0;
    this.mColumns = result.mColumns ?? 0;
    this.mRows = result.mRows ?? 0;
    this.mDesktopMarginTop = result.mDesktopMarginTop ?? 0;
    this.mWorkSpaceMarginTop = result.mDesktopMarginTop ?? 0;
    this.mGridWidth = result.mGridWidth ?? 0;
    this.mGridHeight = result.mGridHeight ?? 0;
    this.mWorkSpaceWidth = result.mGridWidth ?? 0;
    this.mWorkSpaceHeight = result.mGridHeight ?? 0;
    this.mAppItemSize = result.mAppItemSize ?? 0;
    this.mNameSize = result.mNameSize ?? 0;
    this.mNameHeight = result.mNameHeight ?? 0;
    this.mNameWidth = result.mNameWidth ?? 0;
    this.mIconNameMargin = result.mIconNameMargin ?? 0;
    this.mIconSize = result.mIconSize ?? 0;
    this.mNameLines = result.mNameLines ?? 0;
    this.mIconMarginHorizontal = result.mIconMarginHorizontal ?? 0;
    this.mIconMarginVertical = result.mIconMarginVertical ?? 0;
    this.mMarginBottomOfIndicator = result.marginBottomOfIndicator ?? 0;
    this.mHeightOfIndicator = result.mHeightOfIndicator ?? 0;
    this.mWidthOfIndicator = result.mWidthOfIndicator ?? 0;
    this.mFoldPaddingSide = result.mPaddingSideFold ?? 0;
    this.mIconNameMarginTop = result.mIconNameMarginTop ?? 0;
    this.mSpaceOfRow = LayoutViewModel.getInstance().calculateSpaceOfRow();
    this.mSpaceOfColumn = LayoutViewModel.getInstance().calculateSpaceOfColumn();

    this.updateIconSize();
    this.updateIconSizeFromSecure();
    this.mIconSizePreview = result.mIconSize ?? 0;
    this.updatePreviewIconSize();
    // 重新初始化后，清空缓存动画参数
    FolderResizeUtil.release();
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }

  /**
   * 是否支持挤位
   */
  isSupportSqueeze(): boolean {
    return false;
  }

  private updateIconSize(): void {
    let themeInfo: ThemeStyleInfo = ThemeStyleManager.getInstance().getThemeStyle();
    if (themeInfo.iconSizeScale !== undefined) {
      this.mIconSize += themeInfo.iconSizeScale;
      this.mItemPadding -= themeInfo.iconSizeScale / NumberConstants.CONSTANT_NUMBER_TWO;
    }
    this.mIconRadius = RadiusUtil.calculateRadius(this.mIconSize);
  }

  private updateIconSizeFromSecure(): void {
    let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 0;
    if (IconCommonUtil.isValidIconSizeChange(desktopIconChangeSize) && !launcherStatusUtil.getShowOutLauncherStatus()) {
      this.mIconSize += desktopIconChangeSize;
      this.mItemPadding -= desktopIconChangeSize / NumberConstants.CONSTANT_NUMBER_TWO;
    }
    this.mIconRadius = RadiusUtil.calculateRadius(this.mIconSize);
  }

  private updatePreviewIconSize(): void {
    let themeInfo: ThemeStyleInfo = ThemeStylePreviewManager.getInstance().getThemeStyle();
    if (themeInfo.iconSizeScale !== undefined) {
      this.mIconSizePreview += themeInfo.iconSizeScale;
    }
    this.mIconRadiusPreview = RadiusUtil.calculateRadius(this.mIconSizePreview, DesktopMode.PREVIEW_MODE);
  }
}
