/*
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
import { LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { BaseConfig, CalculateAppCenterRst, CalculateDockRst, StyleConstants } from '@ohos/launchercommon';
import { PadLayoutRulesController } from './PadLayoutRulesController';

const TAG = 'PcDockLayoutRulesController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PcDockLayoutRulesController extends PadLayoutRulesController {
  public static singleName: string = 'PcDockLayoutRulesController';

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): PcDockLayoutRulesController {
    let instance = singleManager.get<PcDockLayoutRulesController>(PcDockLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    log.showInfo(`${PcDockLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
  }

  calculateDock(): CalculateDockRst {
    let result = super.calculateDock();
    result.mDockPadding = PcForPadPresetConstants.DEFAULT_DOCK_PADDING;
    result.mDockRadius = PcForPadPresetConstants.DEFAULT_DOCK_RADIUS_FIXED;
    result.mIconSize = PcForPadPresetConstants.DEFAULT_DOCK_ICON_SIZE_FIXED;
    result.mListItemGap = PcForPadPresetConstants.DEFAULT_DOCK_ITEM_GAP_FIXED;
    result.mListItemWidth = PcForPadPresetConstants.DEFAULT_DOCK_ICON_SIZE_FIXED;
    result.mListItemHeight = PcForPadPresetConstants.DEFAULT_DOCK_ICON_SIZE_FIXED;
    result.mBackgroundColor = PcForPadPresetConstants.DEFAULT_DOCK_BACKGROUND_COLOR;
    result.mBackdropBlur = PcForPadPresetConstants.DEFAULT_DOCK_BACKGROUND_DROP_BLUR;
    result.mBackSaturation = PcForPadPresetConstants.DEFAULT_BACKGROUND_SATURATION;
    result.mResidentSplitLineWidth = PcForPadPresetConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_WIDTH_FIXED;
    result.mResidentSplitLineHeight = PcForPadPresetConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_HEIGHT_FIXED;
    result.mResidentSplitLineColor = PcForPadPresetConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_COLOR;
    result.mResidentSplitLineGap = PcForPadPresetConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_GAP_FIXED;
    result.mRecentArrowWidth = PcForPadPresetConstants.DEFAULT_DOCK_RECENT_ARROW_WIDTH;
    result.mRecentArrowHeight = PcForPadPresetConstants.DEFAULT_DOCK_RECENT_ARROW_HEIGHT;
    result.mRecentArrowPadding = PcForPadPresetConstants.DEFAULT_DOCK_RECENT_ARROW_PADDING;
    result.mRecentArrowGap = PcForPadPresetConstants.DEFAULT_DOCK_RECENT_ARROW_GAP;
    result.mMaxRecentNum = PcForPadPresetConstants.DEFAULT_DOCK_MAX_RECENT_NUMBER;
    result.mMinResidentNum = PcForPadPresetConstants.DEFAULT_DOCK_MIN_RESIDENT_NUMBER;
    result.mDockHeight = PcForPadPresetConstants.DEFAULT_DOCK_HEIGHT_FIXED;
    result.mMarginBottom = PcForPadPresetConstants.DEFAULT_DOCK_MARGIN_BOTTOM;
    result.mDockGap = PcForPadPresetConstants.DEFAULT_DOCK_GUTTER_FIXED;
    result.mMarginBottom = PcForPadPresetConstants.DEFAULT_DOCK_MARGIN_BOTTOM_HIDE_BAR_FIXED;

    return result;
  }

  calculateAppCenter(): CalculateAppCenterRst {
    let appCenterMarginLeft: number = PcForPadPresetConstants.DEFAULT_APP_CENTER_MARGIN_LEFT;
    let gutter: number = PcForPadPresetConstants.DEFAULT_APP_CENTER_GRID_COL_ROW_GAP;
    let appItemSize = this.mLauncherLayoutStyleConfig.mAppCenterSize;
    let appCenterSizeWidth = this.mLauncherLayoutStyleConfig.mAppCenterSizeWidth;
    let appCenterItemWidth = PcForPadPresetConstants.DEFAULT_APP_CENTER_GRID_ITEM_WIDTH;
    let appCenterItemHeight = PcForPadPresetConstants.DEFAULT_APP_CENTER_GRID_ITEM_HEIGHT;
    let appCenterIconSize = PcForPadPresetConstants.DEFAULT_APP_CENTER_APP_ICON_SIZE;
    let appCenterBubbleMarginTop = this.mLauncherLayoutStyleConfig.mAppCenterBubbleMarginTop;
    let appCenterBubbleMarginBottom = this.mLauncherLayoutStyleConfig.mAppCenterBubbleMarginBottom;
    let width = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * appCenterMarginLeft;
    let appCenterMarginTop = PcForPadPresetConstants.DEFAULT_APP_CENTER_MARGIN_TOP;
    let appCenterMarginBottom = PcForPadPresetConstants.DEFAULT_APP_CENTER_MARGIN_BOTTOM;
    let height = this.mBaseConfig.getWorkSpaceHeight() - this.mLauncherLayoutStyleConfig.mDockMarginBottom -
      appCenterMarginTop - appCenterMarginBottom;
    let column = ~~((width + gutter) / (appCenterItemWidth + gutter));
    let row = ~~((height + gutter) / (appCenterItemHeight + gutter));
    log.showInfo(`calculateAppCenter columns=${column},rows=${row}, width:${width}, gutter: ${gutter} appCenterItemWidth:${appCenterItemWidth}   appCenterItemHeight:${appCenterItemHeight} this.mBaseConfig.getScreenWidth():${this.mBaseConfig.getScreenWidth()}`);
    log.showInfo(`calculateAppCenter appCenterMarginLeft=${appCenterMarginLeft},getScreenHeight:${this.mBaseConfig.getScreenHeight()}  getWorkSpaceHeight:${this.mBaseConfig.getWorkSpaceHeight()} vp2px: ${vp2px(1)}`);
    let padding = (height - row * (appCenterItemHeight + gutter) + gutter) / StyleConstants.DEFAULT_2;
    let ratio = this.mLauncherLayoutStyleConfig.mAppCenterRatio;
    let lines = this.mLauncherLayoutStyleConfig.mAppCenterNameLines;
    let appTextSize = PcForPadPresetConstants.DEFAULT_APP_CENTER_APP_NAME_SIZE;
    let nameHeight = lines * appTextSize;
    let iconMarginVertical = ratio * appItemSize;
    let result: CalculateAppCenterRst = {
      mColumnsGap: gutter,
      mRowsGap: gutter,
      mColumns: column,
      mRows: row,
      mGridWidth: width,
      mGridHeight: height,
      mPadding: padding,
      mNameSize: appTextSize,
      mNameHeight: nameHeight,
      mNameWidth: PcForPadPresetConstants.DEFAULT_APP_CENTER_APP_NAME_WIDTH,
      mIconSize: appCenterIconSize,
      mNameLines: lines,
      mAppItemSize:appItemSize,
      mIconMarginVertical: iconMarginVertical,
      mAppCenterSizeWidth: appCenterSizeWidth,
      mAppCenterSizeHeight: appCenterItemHeight,
      mAppCenterItemWidth: appCenterItemWidth,
      mAppCenterItemHeight: appCenterItemHeight,
      mAppCenterMarginLeft: appCenterMarginLeft,
      mAppCenterMarginTop: appCenterMarginTop,
      mAppCenterBubbleMarginTop: appCenterBubbleMarginTop,
      mAppCenterBubbleMarginBottom: appCenterBubbleMarginBottom,
      mIndicatorBottom: PcForPadPresetConstants.DEFAULT_APP_CENTER_INDICATOR_MARGIN_BOTTOM
    };
    return result;
  }
}

export class PcForPadPresetConstants {
  public static readonly DEFAULT_DOCK_PADDING = 12;
  public static readonly DEFAULT_DOCK_MARGIN_BOTTOM = 8;
  public static readonly DEFAULT_DOCK_MAX_RECENT_NUMBER = 7;
  public static readonly DEFAULT_DOCK_BACKGROUND_COLOR = '#66C2CEE6';
  public static readonly DEFAULT_DOCK_BACKGROUND_DROP_BLUR = 50;
  public static readonly DEFAULT_BACKGROUND_SATURATION = 2.1;
  public static readonly DEFAULT_DOCK_MIN_RESIDENT_NUMBER = 0;
  public static readonly DEFAULT_DOCK_RESIDENT_SPLIT_LINE_COLOR = '#33FFFFFF';
  public static readonly DEFAULT_DOCK_RECENT_ARROW_WIDTH = 32;
  public static readonly DEFAULT_DOCK_RECENT_ARROW_HEIGHT = 32;
  public static readonly DEFAULT_DOCK_RECENT_ARROW_PADDING = 8;
  public static readonly DEFAULT_DOCK_RECENT_ARROW_GAP = 8;
  public static readonly DEFAULT_DOCK_ICON_SIZE_FIXED = 40;
  public static readonly DEFAULT_DOCK_RADIUS_FIXED = 0;
  public static readonly DEFAULT_DOCK_ITEM_GAP_FIXED = 12;
  public static readonly DEFAULT_DOCK_GUTTER_FIXED = 24;
  public static readonly DEFAULT_DOCK_MARGIN_BOTTOM_HIDE_BAR_FIXED = 0;
  public static readonly DEFAULT_DOCK_RESIDENT_SPLIT_LINE_WIDTH_FIXED = 1;
  public static readonly DEFAULT_DOCK_RESIDENT_SPLIT_LINE_HEIGHT_FIXED = 32;
  public static readonly DEFAULT_DOCK_RESIDENT_SPLIT_LINE_GAP_FIXED = 12;
  public static readonly DEFAULT_DOCK_HEIGHT_FIXED = PcForPadPresetConstants.DEFAULT_DOCK_ICON_SIZE_FIXED +
    StyleConstants.DEFAULT_2 * PcForPadPresetConstants.DEFAULT_DOCK_ITEM_GAP_FIXED;

  public static readonly DEFAULT_APP_CENTER_GRID_COL_ROW_GAP = 32;
  public static readonly DEFAULT_APP_CENTER_GRID_ITEM_WIDTH = 149;
  public static readonly DEFAULT_APP_CENTER_GRID_ITEM_HEIGHT = 123;
  public static readonly DEFAULT_APP_CENTER_MARGIN_LEFT = 25;
  public static readonly DEFAULT_APP_CENTER_MARGIN_TOP = 70;
  public static readonly DEFAULT_APP_CENTER_MARGIN_BOTTOM = 48;
  public static readonly DEFAULT_APP_CENTER_APP_ICON_SIZE = 64;
  public static readonly DEFAULT_APP_CENTER_APP_NAME_SIZE = 15;
  public static readonly DEFAULT_APP_CENTER_APP_NAME_HEIGHT = 16;
  public static readonly DEFAULT_APP_CENTER_APP_NAME_WIDTH = 130;
  public static readonly DEFAULT_APP_CENTER_INDICATOR_MARGIN_BOTTOM = 20;
}