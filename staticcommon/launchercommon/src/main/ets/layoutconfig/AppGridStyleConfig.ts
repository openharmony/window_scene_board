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

import { ILayoutConfig } from './ILayoutConfig';
import { CommonConstants } from '../constants/CommonConstants';
import { StyleConstants } from '../constants/StyleConstants';
import { PresetStyleConstants } from '../constants/PresetStyleConstants';
import { SingleContext, singleManager } from '@ohos/basicutils/src/main/ets/utils/SingleManager';

/**
 * Style config for app grid.
 */
export class AppGridStyleConfig extends ILayoutConfig {
  public static singleName: string = 'AppGridStyleConfig';
  /**
   * Style config symbol for app grid
   */
  public static APP_GRID_STYLE_CONFIG = 'AppGridStyleConfig';

  /**
   * 列数
   */
  public mColumns = StyleConstants.DEFAULT_APP_GRID_COLUMN;

  /**
   * 行数
   */
  public mRows = StyleConstants.DEFAULT_APP_GRID_ROW;

  /**
   * 类间隙
   */
  public mColumnsGap = StyleConstants.DEFAULT_APP_GRID_COLUMN_GAP;

  /**
   * 行间隙
   */
  public mRowsGap = StyleConstants.DEFAULT_APP_GRID_ROW_GAP;

  /**
   * grid margin
   */
  public mMargin = PresetStyleConstants.DEFAULT_LAYOUT_MARGIN;

  /**
   * grid item padding
   */
  public mItemPadding = PresetStyleConstants.DEFAULT_LAYOUT_ITEM_PADDING;

  /**
   * grid minimum gutter
   */
  public mGridGutter = PresetStyleConstants.DEFAULT_APP_LAYOUT_MIN_GUTTER;

  /**
   * grid width
   */
  public mGridWidth: number = 0;

  /**
   * grid height
   */
  public mGridHeight: number = 0;

  /**
   * grid 实际的高宽，由表格实际变动时通知过来的值
   */
  public realGridWidth: number = 0;
  public realGridHeight: number = 0;
  public realPaddingTop?: number;
  public realPaddingLeft?: number;

  /**
   * app width
   */
  public mAppItemSize: number = 0;

  /**
   * icon size
   */
  public mIconSize = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;

  /**
   * preview icon size
   */
  public mIconSizePreview = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;

  /**
   * app name font size
   */
  public mNameSize = StyleConstants.DEFAULT_APP_NAME_SIZE;

  /**
   * app name font color
   */
  public mNameFontColor = StyleConstants.DEFAULT_FONT_COLOR;

  /**
   * app name font height
   */
  public mNameHeight = StyleConstants.DEFAULT_APP_NAME_HEIGHT;

  /**
   * 名称宽度
   */
  public mNameWidth = StyleConstants.DEFAULT_APP_NAME_WIDTH;

  /**
   * app name lines
   */
  public mNameLines = PresetStyleConstants.DEFAULT_APP_NAME_LINES;

  /**
   * app max name lines
   */
  public mMaxNameLines = PresetStyleConstants.DEFAULT_APP_NAME_LINES;

  /**
   * app icon margin top
   */
  public mIconMarginVertical = PresetStyleConstants.DEFAULT_ICON_PADDING_TOP;

  /**
   * size of app center item width
   */
  public mAppCenterItemWidth: number = PresetStyleConstants.DEFAULT_APP_CENTER_ITEM_WIDTH;

  /**
   * size of app center item height
   */
  public mAppCenterItemHeight: number = PresetStyleConstants.DEFAULT_APP_CENTER_ITEM_HEIGHT;

  /**
   * item size width of app center
   */
  public mAppCenterSizeWidth: number = PresetStyleConstants.DEFAULT_APP_CENTER_SIZE_WIDTH;

  /**
   * item size height of app center
   */
  public mAppCenterSizeHeight: number = PresetStyleConstants.DEFAULT_APP_CENTER_SIZE_HEIGHT;

  /**
   * left margin of app center
   */
  public mAppCenterMarginLeft: number = PresetStyleConstants.DEFAULT_APP_CENTER_MARGIN_LEFT;

  /**
   * top margin of app center
   */
  public mAppCenterMarginTop: number = PresetStyleConstants.DEFAULT_APP_CENTER_MARGIN_TOP;

  /**
   * app icon margin horizontal
   */
  public mIconMarginHorizontal: number = PresetStyleConstants.DEFAULT_ICON_PADDING_LEFT;

  /**
   * icon name margin
   */
  public mIconNameMargin: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;

  /**
   * border width of app center
   */
  public mAppCenterBorderWidth: number = PresetStyleConstants.DEFAULT_APP_CENTER_BORDER_WIDTH;

  /**
   * desktop icon name margin top
   */
  public mIconNameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;

  /**
   * Indicator to swiper content bottom
   */
  public mIndicatorBottom: number = PresetStyleConstants.DEFAULT_INDICATOR_MARGIN_TOP;

  public mAppIconShadowRadius = StyleConstants.APP_ICON_SHADOW_RADIUS;
  public mAppIconShadowColor = StyleConstants.APP_ICON_SHADOW_COLOR;
  public mAppIconShadowOffsetY = StyleConstants.APP_ICON_SHADOW_OFFSETY;

  public mFormShadowRadius = StyleConstants.FORM_SHADOW_RADIUS;
  public mFormShadowColor = StyleConstants.FORM_SHADOW_COLOR;
  public mFormShadowOffsetY = StyleConstants.FORM_SHADOW_OFFSETY;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.initConfig();
  }

  /**
   * Get single instance.
   */
  static getInstance(ctx?: SingleContext): AppGridStyleConfig {
    return singleManager.get<AppGridStyleConfig>(AppGridStyleConfig, ctx);
  }

  initConfig(): void {
  }

  getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_STYLE;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  getConfigName(): string {
    return AppGridStyleConfig.APP_GRID_STYLE_CONFIG;
  }

  public getPersistConfigJson(): string {
    return JSON.stringify({});
  }
}
