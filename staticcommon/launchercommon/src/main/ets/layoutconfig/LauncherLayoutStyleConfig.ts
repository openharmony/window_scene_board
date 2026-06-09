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
import { SingleContext, singleManager } from '@ohos/basicutils/src/main/ets/utils/SingleManager';
import { ILayoutConfig } from './ILayoutConfig';
import { CommonConstants } from '../constants/CommonConstants';
import { PresetStyleConstants } from '../constants/PresetStyleConstants';

/**
 * Launcher_layout style
 */
export class LauncherLayoutStyleConfig extends ILayoutConfig {

  public static singleName: string = 'LauncherLayoutStyleConfig';

  static LAUNCHER_COMMON_STYLE_CONFIG: string = 'launcherStyleCommon';

  static LAUNCHER_PRODUCT_STYLE_CONFIG: string = 'launcherStyleProduct';

  mIconMarginTOP = PresetStyleConstants.DEFAULT_ICONMARGIN_TOP;
  /**
     * UninstallDialog width
   */
  mUninstallDialogWidth = PresetStyleConstants.DEFAULT_UNINSTALLDIALOG_WIDTH;

  /**
   * systemUI top height
   */
  mSysTopHeight = PresetStyleConstants.DEFAULT_SYS_TOP_HEIGHT;

  /**
   * systemUI bottom height
   */
  mSysBottomHeight = PresetStyleConstants.DEFAULT_SYS_BOTTOM_HEIGHT;

  mSystemUIHeight = PresetStyleConstants.DEFAULT_PAD_SYSTEM_UI;

  /**
   * Status bottom padding
   */
  mSystemUIBottomPadding = PresetStyleConstants.DEFAULT_SYSTEM_UI_BOTTOM_PADDING;

  /**
   * Indicator height of swiper
   */
  mIndicatorHeight = PresetStyleConstants.DEFAULT_PAD_INDICATOR_HEIGHT;

  /**
   * Indicator width of swiper
   */
  mIndicatorWidth = PresetStyleConstants.sDefaultPhoneIndicatorWidth;

  /**
   * desktop item Size
   */
  mAppItemSize = PresetStyleConstants.DEFAULT_APP_LAYOUT_SIZE;

  /**
   * desktop space margin
   */
  mMargin = PresetStyleConstants.DEFAULT_LAYOUT_MARGIN;

  /**
   * grid item padding
   */
  mItemPadding = PresetStyleConstants.DEFAULT_LAYOUT_ITEM_PADDING;

  /**
   * app bubble icon size
   */
  mAppBubbleIconSize = PresetStyleConstants.DEFAULT_DOCK_ICON_SIZE;

  /**
   * desktop grid gap
   */
  mGridGutter = PresetStyleConstants.DEFAULT_APP_LAYOUT_MIN_GUTTER;

  /**
   * icon name lines
   */
  mNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;

  /**
   * icon max name lines
   */
  mMaxNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;

  /**
   * icon ratio
   */
  mIconRatio: number = PresetStyleConstants.DEFAULT_APP_TOP_RATIO;

  /**
   * icon name margin
   */
  mIconNameGap: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;

  /**
   * desktop icon name margin top
   */
  mIconNameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;

  /**
   * icon name text size
   */
  mNameSize: number = PresetStyleConstants.DEFAULT_APP_NAME_TEXT_SIZE;

  /**
   * name height
   */
  mNameHeight: number = PresetStyleConstants.DEFAULT_DESKTOP_NAME_HEIGHT;

  /**
   * name width
   */
  mNameWidth: number = PresetStyleConstants.DEFAULT_DESKTOP_NAME_WIDTH;

  /**
   * desktop grid gap
   */
  mMarginTop = PresetStyleConstants.DEFAULT_APP_MARGIN_TOP;

  /**
   * workspace padding top
   */
  mWorkSpacePaddingTop: number = 0;

  /**
   * workspace padding top
   */
  mWorkSpacePaddingBottom: number = 0;

  //folder
  /**
   * ratio of gutter with folder
   */
  mFolderGutterRatio: number = PresetStyleConstants.DEFAULT_FOLDER_GUTTER_RATIO;

  /**
   * ratio of margin with folder
   */
  mFolderMarginRatio: number = PresetStyleConstants.DEFAULT_FOLDER_PADDING_RATIO;

  /**
   * ratio of gutter with small folder
   */
  mSmallFolderGutterRatio: number = PresetStyleConstants.DEFAULT_SMALL_FOLDER_GUTTER_RATIO;

  /**
   * ratio of margin with small folder
   */
  mSmallFolderMarginRatio: number = PresetStyleConstants.DEFAULT_SMALL_FOLDER_PADDING_RATIO;

  /**
   * gutter of open folder
   */
  mFolderOpenGutter: number = PresetStyleConstants.DEFAULT_OPEN_FOLDER_GUTTER;

  /**
   * margin of open folder tittle
   */
  mFolderOpenTittleMargin: number = PresetStyleConstants.DEFAULT_OPEN_FOLDER_TITTLE_MARGIN;

  /**
   * padding of open folder
   */
  mFolderOpenPADDING: number = PresetStyleConstants.DEFAULT_OPEN_FOLDER_PADDING;

  /**
   * margin of open folder
   */
  mFolderOpenMargin: number = PresetStyleConstants.DEFAULT_OPEN_FOLDER_MARGIN_TOP;

  /**
  * margin top of open folder
  */
  mFolderOpenTitle: number = PresetStyleConstants.DEFAULT_OPEN_FOLDER_TITLE_TOP;

  /**
   * column num of app center
   */
  mAppCenterColNum: number = PresetStyleConstants.DEFAULT_APP_CENTER_GRID_COL_NUM;

  /**
   * row num of app center
   */
  mAppCenterRowNum: number = PresetStyleConstants.DEFAULT_APP_CENTER_GRID_ROW_NUM;

  /**
   * gutter of add app
   */
  mFolderAddGridGap: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_GAP;

  /**
   * margin of add app and padding of add app
   */
  mFolderAddGridMargin: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_MARGIN;

  /**
   * max height of add app
   */
  mFolderAddMaxHeight: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_MAX_HEIGHT;

  /**
   * toggle size of add app
   */
  mFolderToggleSize: number = PresetStyleConstants.DEFAULT_APP_GRID_TOGGLE_SIZE;

  /**
   * name lines of add app
   */
  mFolderAddTextLines: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_TEXT_LINES;

  /**
   * text size of add app
   */
  mFolderAddTextSize: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_GRID_TEXT_SIZE;

  /**
   * title size of add app
   */
  mFolderAddTitleSize: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_TITLE_TEXT_SIZE;

  /**
   * ratio of padding top with icon in add app
   */
  mFolderAddIconRatio: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_ICON_TOP_RATIO;

  /**
   * button size of add app
   */
  mFolderAddButtonSize: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_BUTTON_SIZE;

  //App Center
  /**
   * left margin of app center
   */
  mAppCenterMarginLeft: number = PresetStyleConstants.DEFAULT_APP_CENTER_MARGIN_LEFT;

  /**
 * top margin of app center
 */
  mAppCenterMarginTop: number = PresetStyleConstants.DEFAULT_APP_CENTER_MARGIN_TOP;

  /**
   * margin bottom of app center
   */
  mAppCenterMarginBottom: number = PresetStyleConstants.DEFAULT_APP_CENTER_MARGIN_BOTTOM;

  /**
   * bubble margin top of app center
   */
  mAppCenterBubbleMarginTop: number = PresetStyleConstants.DEFAULT_APP_CENTER_BUBBLE_MARGIN_TOP;

  /**
   * bubble margin bottom of app center
   */
  mAppCenterBubbleMarginBottom: number = PresetStyleConstants.DEFAULT_APP_CENTER_BUBBLE_MARGIN_BOTTOM;

  /**
   * gutter of app center
   */
  mAppCenterGutter: number = PresetStyleConstants.DEFAULT_APP_CENTER_GUTTER;

  /**
   * size of app center item width
   */
  mAppCenterItemWidth: number = PresetStyleConstants.DEFAULT_APP_CENTER_ITEM_WIDTH;

  /**
   * size of app center item height
   */
  mAppCenterItemHeight: number = PresetStyleConstants.DEFAULT_APP_CENTER_ITEM_HEIGHT;

  /**
   * size of app center item width
   */
  mAppCenterIconSize: number = PresetStyleConstants.DEFAULT_APP_CENTER_ICON_SIZE;

  /**
   * radius of app center item
   */
  mAppCenterIconRadius: number = PresetStyleConstants.DEFAULT_APP_CENTER_ICON_RADIUS;

  /**
   * size of app center container
   */
  mAppCenterSize: number = PresetStyleConstants.DEFAULT_APP_CENTER_SIZE;

  /**
   * item size width of app center
   */
  mAppCenterSizeWidth: number = PresetStyleConstants.DEFAULT_APP_CENTER_SIZE_WIDTH;

  /**
   * item size height of app center
   */
  mAppCenterSizeHeight: number = PresetStyleConstants.DEFAULT_APP_CENTER_SIZE_HEIGHT;

  /**
   * ratio of padding top with icon in app center
   */
  mAppCenterRatio: number = PresetStyleConstants.DEFAULT_APP_CENTER_TOP_RATIO;

  /**
   * name lines of app center
   */
  mAppCenterNameLines: number = PresetStyleConstants.DEFAULT_APP_CENTER_NAME_LINES;

  /**
   * name size of app center
   */
  mAppCenterNameSize: number = PresetStyleConstants.DEFAULT_APP_CENTER_NAME_TEXT_SIZE;

  /**
   * name size of app center name width
   */
  mAppCenterNameWidth: number = PresetStyleConstants.DEFAULT_APP_CENTER_NAME_WIDTH;

  //dock
  /**
   * padding of dock
   */
  mDockPadding: number = PresetStyleConstants.DEFAULT_DOCK_PADDING;

  /**
   * radius of dock back plane
   */
  mDockRadius: number = PresetStyleConstants.sDefaultDockRadius;

  /**
   * radius of fold radius back plane
   */
  mFolderRadius: number = PresetStyleConstants.sDefaultFolderDockRadius;

  /**
   * icon size of dock
   */
  mDockIconSize: number = PresetStyleConstants.DEFAULT_DOCK_ICON_SIZE;

  /**
   * icon background size of dock
   */
  mIconBackgroundSize: number = PresetStyleConstants.DEFAULT_ICON_BACKGROUND_SIZE;

  /**
   * gap of icon and icon
   */
  mDockItemGap: number = PresetStyleConstants.DEFAULT_DOCK_ITEM_GAP;

  /**
   * gap of dock and dock
   */
  mDockGutter: number = PresetStyleConstants.DEFAULT_DOCK_GUTTER;

  /**
   * save margin of dock
   */
  mDockSaveMargin: number = PresetStyleConstants.DEFAULT_DOCK_SAVE_MARGIN;

  /**
   * margin bottom of dock
   */
  mDockMarginBottom: number = PresetStyleConstants.DEFAULT_DOCK_MARGIN_BOTTOM;

  /**
   * margin bottom of dock (Immersive navigation bar)
   */
  mDockMarginBottomHideBar: number = PresetStyleConstants.DEFAULT_DOCK_MARGIN_BOTTOM_HIDE_BAR;

  /**
   *  G status portrait margin
   */
  mGPortraitMargin: number = PresetStyleConstants.DEFAULT_G_PORTRAIT_MARGIN;

  /**
   *  G status Landscape item gap
   */
  mGLandscapeItemGap: number = PresetStyleConstants.DEFAULT_G_LANDSCAPE_ITEM_GAP;

  /**
   *  G status Landscape split line gap
   */
  mGSplitLineGap: number = PresetStyleConstants.DEFAULT_G_LANDSCAPE_SPLIT_LINE_GAP;

  /**
   * max recent number of dock
   */
  mDockMaxRecentNumber: number = PresetStyleConstants.DEFAULT_DOCK_MAX_RECENT_NUMBER;

  /**
   * dock list background color, default value is used to phone
   */
  mBackgroundColor = '#85FAFAFA';

  /**
   * dock list background color, default value is used to phone
   */
  mFolderDockBackgroundColor: string = '#4DFFFFFF';

  /**
   * dock list background blur
   */
  mBackdropBlur = 0;

  /**
   * folder dock list background blur
   */
  mFolderDockBackdropBlur: number = 100;

  /**
   * dock background saturation
   */
  mBackSaturation = 1.4;

  /**
   * min resident num
   */
  mMinResidentNumber: number = 0;

  /**
   * resident split line width of dock, only use in pc and pad
   */
  mDockResidentSplitLineWidth: number = 0;

  /**
   * resident split line height of dock, only use in pc and pad
   */
  mDockResidentSplitLineHeight: number = 0;

  /**
   * resident split line color of dock, only use in pc and pad
   */
  mDockResidentSplitLineColor: string = '#33FFFFFF';

  /**
   * resident split line gap of dock, only use in pc and pad
   */
  mDockResidentSplitLineGap: number = 0;

  /**
   * recent arrow width of dock, only use in pc and pad
   */
  mDockRecentArrowWidth: number = 0;

  /**
   * recent arrow height of dock, only use in pc and pad
   */
  mDockRecentArrowHeight: number = 0;

  /**
   * recent arrow padding of dock, only use in pc and pad
   */
  mDockRecentArrowPadding: number = 0;

  /**
   * recent arrow gap of dock, only use in pc and pad
   */
  mDockRecentArrowGap: number = 0;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * LauncherLayoutStyleConfig of instance
   */
  public static getInstance(ctx?: SingleContext): LauncherLayoutStyleConfig {
    return singleManager.get<LauncherLayoutStyleConfig>(LauncherLayoutStyleConfig, ctx);
  }

  initConfig(): void {
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_STYLE;
  }

  getConfigName(): string {
    return LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG;
  }

  public getPersistConfigJson(): string {
    return JSON.stringify({});
  }

  setDockIconSize(dockIconSize: number): void {
    this.mDockIconSize = dockIconSize;
  }
}