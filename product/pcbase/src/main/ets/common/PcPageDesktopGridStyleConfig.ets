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

import { CommonConstants, GridLayoutUtil, IconCommonUtil } from '@ohos/launchercommon';
import { LayoutViewModel } from '@ohos/launchercommon';
import { LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBScreenSessionManager } from '@ohos/windowscene';
import { PageDesktopGridStyleConfig } from '@ohos/pagedesktop';
import StyleConstants from './constants/StyleConstants';
import {
  RadiusUtil,
  ThemeStyleInfo,
  ThemeStyleManager,
  ThemeStylePreviewManager
} from '@ohos/launchercommon';
import { DesktopMode } from '@ohos/launchercommon';
import PcPresetStyleConstants from './constants/PcPresentConstants';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PCUtils } from './utils/PCUtils';

const TAG = 'PcPageDesktopGridStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Pad grid style config class
 */
export default class PcPageDesktopGridStyleConfig extends PageDesktopGridStyleConfig {
  public static singleName: string = 'PcPageDesktopGridStyleConfig';
  /**
   * icon size
   */
  mIconSize = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;

  /**
   * preview icon size
   */
  mIconSizePreview = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;

  /**
   * name size
   */
  mNameSize = StyleConstants.DEFAULT_APP_NAME_SIZE;

  /**
   * margin
   */
  mMargin = StyleConstants.DEFAULT_MARGIN_SIZE;

  /**
   * name height
   */
  mNameHeight = StyleConstants.DEFAULT_APP_NAME_HEIGHT;

  /**
   * item padding
   */
  mPaddingTop = StyleConstants.DEFAULT_APP_TOP_RATIO;

  /**
   * is Support Indicator
   */
  mIsSupportIndicator = StyleConstants.DEFAULT_SUPPORT_INDICATOR;

  mScreenPadding = StyleConstants.DEFAULT_SCREEN_PADDING;

  mScreenPaddingTop = StyleConstants.DEFAULT_SCREEN_PADDING_TOP;

  public mAppIconShadowRadius = PcPresetStyleConstants.APP_ICON_SHADOW_RADIUS;
  public mAppIconShadowColor = PcPresetStyleConstants.APP_ICON_SHADOW_COLOR;
  public mAppIconShadowOffsetY = PcPresetStyleConstants.APP_ICON_SHADOW_OFFSETY;

  public mFormShadowRadius = PcPresetStyleConstants.FORM_SHADOW_RADIUS;
  public mFormShadowColor = PcPresetStyleConstants.FORM_SHADOW_COLOR;
  public mFormShadowOffsetY = PcPresetStyleConstants.FORM_SHADOW_OFFSETY;

  public mFoldCreaseRegionHeight: number = 0;

  public mPhysicalAxisArea: number = 0;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.initConfig();
  }

  /**
   * get PcPageDesktopGridStyleConfig instance
   */
  static getInstance(ctx?: SingleContext): PcPageDesktopGridStyleConfig {
    return singleManager.get<PcPageDesktopGridStyleConfig>(PcPageDesktopGridStyleConfig, ctx);
  }

  initConfig(callerTag?: string): void {
    log.showInfo(`initConfig: ${callerTag}`);
    this.mGridSwiperMarginBottom = StyleConstants.DEFAULT_GRID_SWIPER_MARGIN_BOTTOM
    // PageDesktopLayout.ets落位点计算时，状态栏高度和状态栏到宫格顶部分别取整px，在计算getFloorVp（40）与预期值有差异，在这里弥补
    this.mWorkSpaceMarginTop =
      GridLayoutUtil.getFloorVp(LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight());
    const result = LayoutViewModel.getInstance(this.singleContext).calculateDesktop();
    log.showInfo(`initConfig ========================================= , ${JSON.stringify(result)}`);
    if (result.mMargin != undefined) {
      this.mMargin = result.mMargin;
      this.mWorkSpacePadding = this.mMargin;
    }
    if (result.mItemPadding != undefined) {
      this.mItemPadding = result.mItemPadding;
    }
    if (result.mColumnsGap != undefined) {
      this.mColumnsGap = result.mColumnsGap;
    }
    if (result.mRowsGap != undefined) {
      this.mRowsGap = result.mRowsGap;
    }
    if (result.mColumns != undefined) {
      this.mColumns = result.mColumns;
    }
    if (result.mRows != undefined) {
      this.mRows = result.mRows;
    }
    if (result.mDesktopMarginTop != undefined) {
      this.mDesktopMarginTop = result.mDesktopMarginTop;
    }
    if (result.mGridWidth != undefined) {
      this.mGridWidth = result.mGridWidth;
    }
    if (result.mWorkSpaceWidth != undefined) {
      this.mWorkSpaceWidth = result.mWorkSpaceWidth;
    }
    if (result.mWorkSpaceHeight != undefined) {
      this.mWorkSpaceHeight = result.mWorkSpaceHeight;
    }
    if (result.mWorkSpacePaddingTop != undefined) {
      this.mWorkSpacePaddingTop = result.mWorkSpacePaddingTop;
    }
    if (result.mWorkSpacePaddingBottom != undefined) {
      this.mWorkSpacePaddingBottom = result.mWorkSpacePaddingBottom;
    }
    if (result.mGridHeight != undefined) {
      this.mGridHeight = result.mGridHeight;
    }
    if (result.mAppItemSize != undefined) {
      this.mAppItemSize = result.mAppItemSize;
    }
    if (result.mNameSize != undefined) {
      this.mNameSize = result.mNameSize;
    }
    if (result.mNameHeight != undefined) {
      this.mNameHeight = result.mNameHeight;
    }
    if (result.mNameWidth != undefined) {
      this.mNameWidth = result.mNameWidth;
    }
    if (result.mIconNameMargin != undefined) {
      this.mIconNameMargin = result.mIconNameMargin;
    }
    if (result.mIconNameMarginTop != undefined) {
      this.mIconNameMarginTop = result.mIconNameMarginTop;
    }
    if (result.mIconSize != undefined) {
      this.mIconSize = result.mIconSize;
    }
    if (result.mNameLines != undefined) {
      this.mNameLines = result.mNameLines;
    }
    if (result.mIconMarginHorizontal != undefined) {
      this.mIconMarginHorizontal = result.mIconMarginHorizontal;
    }
    if (result.mIconMarginVertical != undefined) {
      this.mIconMarginVertical = result.mIconMarginVertical;
    }
    this.updateIconSize();
    if (result.mIconSize != undefined) {
      this.mIconSizePreview = result.mIconSize;
    }
    this.updatePreviewIconSize();
    this.updateIconSizeFromSetting();
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
    if (themeInfo.iconSizeScale) {
      this.mIconSize += themeInfo.iconSizeScale;
      this.mItemPadding -= themeInfo.iconSizeScale / NumberConstants.CONSTANT_NUMBER_TWO;
      this.mItemPadding = Math.max(this.mItemPadding, 0);
    }
    this.mIconRadius = RadiusUtil.calculateRadius(this.mIconSize);
  }

  private updateIconSizeFromSetting(): void {
    let desktopIconChangeSize: number | undefined = AppStorage.get<number>('settingIconChange');
    if (desktopIconChangeSize && IconCommonUtil.isValidIconSizeChange(desktopIconChangeSize)) {
      this.mIconSize += desktopIconChangeSize;
      this.mItemPadding -= desktopIconChangeSize / NumberConstants.CONSTANT_NUMBER_TWO;
      this.mItemPadding = Math.max(this.mItemPadding, 0);
    }
  }

  private updatePreviewIconSize(): void {
    let themeInfo: ThemeStyleInfo = ThemeStylePreviewManager.getInstance().getThemeStyle();
    if (themeInfo.iconSizeScale !== undefined) {
      this.mIconSizePreview += themeInfo.iconSizeScale;
    }
    this.mIconRadiusPreview = RadiusUtil.calculateRadius(this.mIconSizePreview, DesktopMode.PREVIEW_MODE);
  }
}