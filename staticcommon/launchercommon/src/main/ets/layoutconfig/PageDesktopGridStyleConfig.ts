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
import { SingleContext, singleManager } from '@ohos/basicutils';
import { CommonConstants } from '../constants/CommonConstants';
import { PresetStyleConstants } from '../constants/PresetStyleConstants';
import { AppGridStyleConfig } from './AppGridStyleConfig';

/**
 * Work control grid style configuration class
 */
export class PageDesktopGridStyleConfig extends AppGridStyleConfig {

  public static singleName: string = 'PageDesktopGridStyleConfig';
  /**
   * margin
   */
  public mMargin = PresetStyleConstants.DEFAULT_LAYOUT_MARGIN;

  /**
   * grid item padding
   */
  public mItemPadding = PresetStyleConstants.DEFAULT_LAYOUT_ITEM_PADDING;

  public mDesktopMarginTop = PresetStyleConstants.DEFAULT_ICON_PADDING_TOP;

  public mPaddingTop = PresetStyleConstants.DEFAULT_APP_TOP_RATIO;

  /**
   * is Support Indicator
   */
  public mIsSupportIndicator = CommonConstants.DEFAULT_SUPPORT_INDICATOR;

  /**
   * Height of indicator
   */
  public mHeightOfIndicator = PresetStyleConstants.DEFAULT_PHONE_INDICATOR_HEIGHT;

  public mWidthOfIndicator = PresetStyleConstants.sDefaultPhoneIndicatorWidth;

  /**
   * Margin bottom of indicator
   */
  public mMarginBottomOfIndicator = PresetStyleConstants.DEFAULT_INDICATOR_MARGIN_BOTTOM;

  public mScreenPadding = PresetStyleConstants.DEFAULT_LAYOUT_PADDING;

  public mScreenPaddingTop = PresetStyleConstants.DEFAULT_LAYOUT_PADDING_TOP;

  public mScreenPaddingBottom = PresetStyleConstants.DEFAULT_LAYOUT_PADDING_BOTTOM;

  public mFoldPaddingSide = PresetStyleConstants.DEFAULT_FOLD_PADDING_SIZE;

  public mIconRadius = CommonConstants.DEFAULT_ICON_RADIUS;

  public mIconRadiusPreview = CommonConstants.DEFAULT_ICON_RADIUS;

  public mGridSwiperMarginBottom = PresetStyleConstants.DEFAULT_GRID_SWIPER_MARGIN_BOTTOM;

  /**
   * WorkSpace
   */
  public mWorkSpaceMarginTop: number = this.mDesktopMarginTop;

  public mWorkSpaceMargin: number = this.mMargin;

  public mWorkSpaceWidth: number = 0;

  public mWorkSpaceHeight: number = 0;

  public mWorkSpacePadding: number = this.mScreenPadding;

  public mWorkSpacePaddingTop: number = this.mScreenPaddingTop;

  public mWorkSpacePaddingBottom: number = this.mScreenPaddingBottom;

  public mSpaceOfRow: number = 0;

  public mSpaceOfColumn: number = 0;

  public mFoldCreaseRegionHeight: number = 0;

  public mPhysicalAxisAreaHeight: number = 0;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.initConfig();
  }

  /**
   * Get workspace style instance
   */
  static getInstance(ctx?: SingleContext): PageDesktopGridStyleConfig {
    return singleManager.get<PageDesktopGridStyleConfig>(PageDesktopGridStyleConfig, ctx);
  }

  initConfig(): void {
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE;
  }

  getFeatureName(): string {
    return CommonConstants.PAGE_DESKTOP_FEATURE_NAME;
  }

  /**
   * 是否支持挤位
   */
  isSupportSqueeze(): boolean {
    return true;
  }
}