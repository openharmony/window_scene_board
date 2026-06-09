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
import { SettingsUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { PresetStyleConstants, CommonConstants, GridLayoutUtil } from '@ohos/launchercommon';
import { LauncherLayoutStyleConfig } from '@ohos/launchercommon';
import PcPresetStyleConstants from './constants/PcPresentConstants';
import display from '@ohos.display';
import DeviceInfo from '@ohos.deviceInfo';

const TAG = 'PcLauncherLayoutStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Pc launcher config
 */
export default class PcLauncherLayoutStyleConfig extends LauncherLayoutStyleConfig {
  public static singleName: string = 'PcLauncherLayoutStyleConfig';

  private mDefaultDisplay?: display.Display;

  /**
   * ratio of padding top with icon in add app
   */
  public mFolderAddIconRatio: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_ICON_TOP_RATIO;

  /**
   * button size of add app
   */
  public mFolderAddButtonSize: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_BUTTON_SIZE;

  //App Center
  /**
   * margin of app center
   */
  public mAppCenterMargin: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_MARGIN;

  /**
   * margin left of app center
   */
  public mAppCenterMarginTop: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_MARGIN_TOP;

  /**
   * margin left of app center
   */
  public mAppCenterMarginBottom: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_MARGIN_BOTTOM;

  /**
   * gutter of app center
   */
  public mAppCenterGutter: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_GUTTER;

  /**
   * size of app center container
   */
  public mAppCenterSize: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_SIZE;

  /**
   * icon margin top
   */
  public mIconMarginVertical: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_ICON_MARGIN;

  /**
   * item size width of app center
   */
  public mAppCenterSizeWidth: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_SIZE_WIDTH;

  /**
   * item size height of app center
   */
  public mAppCenterSizeHeight: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_SIZE_HEIGHT;

  /**
   * size of app center item width
   */
  public mAppCenterItemWidth: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_ITEM_WIDTH;

  /**
   * size of app center item width
   */
  public mAppCenterIconSize: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_ICON_SIZE;

  /**
   * radius of app center item
   */
  public mAppCenterIconRadius: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_ICON_RADIUS;

  /**
   * size of app center item height
   */
  public mAppCenterItemHeight: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_ITEM_HEIGHT;

  /**
   * ratio of padding top with icon in app center
   */
  public mAppCenterRatio: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_TOP_RATIO;

  /**
   * name lines of app center
   */
  public mAppCenterNameLines: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_NAME_LINES;

  /**
   * name size of app center
   */
  public mAppCenterNameSize: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_NAME_TEXT_SIZE;

  /**
   * name size of app center name width
   */
  public mAppCenterNameWidth: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_NAME_WIDTH;

  /**
   * bubble margin top of app center
   */
  public mAppCenterBubbleMarginTop: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_BUBBLE_MARGIN_TOP;

  /**
   * bubble margin bottom of app center
   */
  public mAppCenterBubbleMarginBottom: number = PcPresetStyleConstants.DEFAULT_APP_CENTER_BUBBLE_MARGIN_BOTTOM;
  //dock
  /**
   * padding of dock
   */
  public mDockPadding: number = PcPresetStyleConstants.DEFAULT_DOCK_PADDING;

  /**
   * radius of dock back plane
   */
  public mDockRadius: number = PcPresetStyleConstants.DEFAULT_DOCK_RADIUS_FIXED;

  /**
   * icon size of dock
   */
  public mDockIconSize: number = PcPresetStyleConstants.DEFAULT_DOCK_ICON_SIZE_FIXED;

  /**
   * gap of icon and icon
   */
  public mDockItemGap: number = PcPresetStyleConstants.DEFAULT_DOCK_ITEM_GAP_FIXED;

  /**
   * gap of dock and dock
   */
  public mDockGutter: number = PcPresetStyleConstants.DEFAULT_DOCK_GUTTER_FIXED;

  /**
   * save margin of dock
   */
  public mDockSaveMargin: number = PcPresetStyleConstants.DEFAULT_DOCK_SAVE_MARGIN;

  /**
   * margin bottom of dock
   */
  public mDockMarginBottom: number = PcPresetStyleConstants.DEFAULT_DOCK_MARGIN_BOTTOM;

  /**
   * margin bottom of dock (Immersive navigation bar)
   */
  public mDockMarginBottomHideBar: number = PcPresetStyleConstants.DEFAULT_DOCK_MARGIN_BOTTOM_HIDE_BAR_FIXED;

  /**
   * max recent number of dock
   */
  public mDockMaxRecentNumber: number = PcPresetStyleConstants.DEFAULT_DOCK_MAX_RECENT_NUMBER;

  /**
   * dock list background color
   */
  public mBackgroundColor = PcPresetStyleConstants.DEFAULT_DOCK_BACKGROUND_COLOR;

  /**
   * dock list background blur
   */
  public mBackdropBlur = PcPresetStyleConstants.DEFAULT_DOCK_BACKGROUND_DROP_BLUR;

  /**
   * dock background saturation
   */
  public mBackSaturation = PcPresetStyleConstants.DEFAULT_BACKGROUND_SATURATION;

  /**
   * min resident num
   */
  public mMinResidentNumber: number = PcPresetStyleConstants.DEFAULT_DOCK_MIN_RESIDENT_NUMBER;

  /**
   * resident split line width of dock, only use in pc and pad
   */
  public mDockResidentSplitLineWidth: number = PcPresetStyleConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_WIDTH_FIXED;

  /**
   * resident split line height of dock, only use in pc and pad
   */
  public mDockResidentSplitLineHeight: number = PcPresetStyleConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_HEIGHT_FIXED;

  /**
   * resident split line color of dock, only use in pc and pad
   */
  public mDockResidentSplitLineColor: string = PcPresetStyleConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_COLOR;

  /**
   * resident split line gap of dock, only use in pc and pad
   */
  public mDockResidentSplitLineGap: number = PcPresetStyleConstants.DEFAULT_DOCK_RESIDENT_SPLIT_LINE_GAP_FIXED;

  /**
   * recent arrow width of dock
   */
  public mDockRecentArrowWidth: number = PcPresetStyleConstants.DEFAULT_DOCK_RECENT_ARROW_WIDTH;

  /**
   * recent arrow height of dock
   */
  public mDockRecentArrowHeight: number = PcPresetStyleConstants.DEFAULT_DOCK_RECENT_ARROW_HEIGHT;

  /**
   * recent arrow padding of dock
   */
  public mDockRecentArrowPadding: number = PcPresetStyleConstants.DEFAULT_DOCK_RECENT_ARROW_PADDING;

  /**
   * recent arrow gap of dock
   */
  public mDockRecentArrowGap: number = PcPresetStyleConstants.DEFAULT_DOCK_RECENT_ARROW_GAP;

  /**
   * Grid icon top margin
   */
  public mIconMarginTOP = PcPresetStyleConstants.DEFAULT_ICONMARGIN_TOP;
  /**
   * UninstallDialog width
   */
  public mUninstallDialogWidth = PcPresetStyleConstants.DEFAULT_UNINSTALLDIALOG_WIDTH;

  /**
   * systemUI top height
   */
  public mSysTopHeight = PcPresetStyleConstants.DEFAULT_SYS_TOP_HEIGHT;

  /**
   * systemUI bottom height
   */
  public mSysBottomHeight = PcPresetStyleConstants.DEFAULT_SYS_BOTTOM_HEIGHT;

  /**
   * systemUI height (top + bottom)
   */
  public mSystemUIHeight = PresetStyleConstants.DEFAULT_PAD_SYSTEM_UI;

  /**
   * indicator height
   */
  public mIndicatorHeight = PcPresetStyleConstants.DEFAULT_PC_INDICATOR_HEIGHT;

  /**
   * desktop item Size
   */
  public mAppItemSize = PcPresetStyleConstants.DEFAULT_APP_LAYOUT_SIZE;

  /**
   * desktop space margin
   */
  public mMargin = PcPresetStyleConstants.DEFAULT_LAYOUT_MARGIN;

  /**
   * grid item padding
   */
  public mItemPadding = PcPresetStyleConstants.DEFAULT_LAYOUT_ITEM_PADDING;

  /**
   * desktop app bubble icon size, added to differ with dock icon
   */
  public mAppBubbleIconSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_BUBBLE_ICON_SIZE;

  /**
   * desktop grid gap
   */
  public mGridGutter = PcPresetStyleConstants.DEFAULT_APP_LAYOUT_MIN_GUTTER;

  /**
   * icon name lines
   */
  public mNameLines: number = PcPresetStyleConstants.DEFAULT_APP_NAME_LINES;

  /**
   * icon max name lines
   */
  public mMaxNameLines: number = PcPresetStyleConstants.DEFAULT_APP_MAX_NAME_LINES;

  /**
   * icon ratio
   */
  public mIconRatio: number = PcPresetStyleConstants.DEFAULT_APP_TOP_RATIO;

  /**
   * icon name margin
   */
  public mIconNameGap: number = PcPresetStyleConstants.DEFAULT_ICON_NAME_GAP;

  /**
   * desktop icon name margin top
   */
  public mIconNameMarginTop: number = PcPresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;

  /**
   * icon name text size
   */
  public mNameSize: number = PcPresetStyleConstants.DEFAULT_APP_NAME_TEXT_SIZE;

  /**
   * name height
   */
  public mNameHeight: number = PcPresetStyleConstants.DEFAULT_DESKTOP_NAME_HEIGHT;

  /**
   * name width
   */
  public mNameWidth: number = PcPresetStyleConstants.DEFAULT_DESKTOP_NAME_WIDTH;

  /**
   * desktop grid gap
   */
  public mMarginTop = PcPresetStyleConstants.DEFAULT_APP_MARGIN_TOP;

  /**
   * workspace padding top
   */
  public mWorkSpacePaddingTop: number = PcPresetStyleConstants.DEFAULT_WORK_SPACE_PADDING_TOP;

  /**
   * workspace padding top
   */
  public mWorkSpacePaddingBottom: number = PcPresetStyleConstants.DEFAULT_WORK_SPACE_PADDING_BOTTOM;
  //folder
  /**
   * ratio of gutter with folder
   */
  public mFolderGutterRatio: number = PcPresetStyleConstants.DEFAULT_FOLDER_GUTTER_RATIO;

  /**
   * ratio of margin with folder
   */
  public mFolderMarginRatio: number = PcPresetStyleConstants.DEFAULT_FOLDER_PADDING_RATIO;

  /**
   * gutter of open folder
   */
  public mFolderOpenGutter: number = PcPresetStyleConstants.DEFAULT_OPEN_FOLDER_GUTTER;

  /**
   * padding of open folder
   */
  public mFolderOpenPADDING: number = PcPresetStyleConstants.DEFAULT_OPEN_FOLDER_PADDING;

  /**
   * margin of open folder
   */
  public mFolderOpenMargin: number = PcPresetStyleConstants.DEFAULT_OPEN_FOLDER_MARGIN_TOP;

  /**
   * margin top of open folder
   */
  public mFolderOpenTitle: number = PcPresetStyleConstants.DEFAULT_OPEN_FOLDER_TITLE_TOP;

  /**
   * gutter of add app
   */
  public mFolderAddGridGap: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_GAP;

  /**
   * margin of add app and padding of add app
   */
  public mFolderAddGridMargin: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_MARGIN;

  /**
   * max height of add app
   */
  public mFolderAddMaxHeight: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_MAX_HEIGHT;

  /**
   * toggle size of add app
   */
  public mFolderToggleSize: number = PcPresetStyleConstants.DEFAULT_APP_GRID_TOGGLE_SIZE;

  /**
   * name lines of add app
   */
  public mFolderAddTextLines: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_TEXT_LINES;

  /**
   * text size of add app
   */
  public mFolderAddTextSize: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_GRID_TEXT_SIZE;

  /**
   * title size of add app
   */
  public mFolderAddTitleSize: number = PcPresetStyleConstants.DEFAULT_FOLDER_ADD_TITLE_TEXT_SIZE;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.initStyle();
  }

  /**
   * PadLauncherLayoutStyleConfig of instance
   */
  public static getInstance(ctx?: SingleContext): PcLauncherLayoutStyleConfig {
    return singleManager.get<PcLauncherLayoutStyleConfig>(PcLauncherLayoutStyleConfig, ctx);
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }

  getFeatureName(): string {
    return LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG;
  }

  private initStyle(): void {
    try {
      this.mDefaultDisplay = display.getDefaultDisplaySync();
    } catch (exception) {
      log.showError('Failed to obtain the default display object. Code: ' + exception?.code);
    }
    log.showInfo('initStyle dpi -s : ' + this.mDefaultDisplay?.densityDPI);
    // KLV
    if (DeviceHelper.isHYM()) {
      this.initHYMStyle();
    }
    // HAD
    if (DeviceHelper.isHAD()) {
      this.initHADStyle();
    }
  }

  private initHYMStyle(): void {
    // 桌面左右两侧margin
    this.mMargin = PcPresetStyleConstants.DEFAULT_MDPI_MARGIN;
    // 桌面顶部margin
    this.mMarginTop = PcPresetStyleConstants.DEFAULT_MDPI_MARGIN_TOP;
    // 桌面网格顶部margin
    this.mWorkSpacePaddingTop = PcPresetStyleConstants.DEFAULT_WORK_SPACE_PADDING_TOP;
    // 桌面网格底部margin
    this.mWorkSpacePaddingBottom = PcPresetStyleConstants.DEFAULT_WORK_SPACE_PADDING_BOTTOM;


    // 格子大小
    this.mAppItemSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_LAYOUT_SIZE;
    // 桌面图标大小，和dock图标大小不一样，需要单独处理
    this.mAppBubbleIconSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_BUBBLE_ICON_SIZE;
    this.mGridGutter = PcPresetStyleConstants.DEFAULT_MDPI_APP_LAYOUT_MIN_GUTTER;

    // 应用名称字体大小
    this.mNameSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_NAME_TEXT_SIZE;
    this.mNameWidth = PcPresetStyleConstants.DEFAULT_MDPI_DESKTOP_NAME_WIDTH;
    this.mNameHeight = PcPresetStyleConstants.DEFAULT_MDPI_DESKTOP_NAME_HEIGHT;

    // appCenter
    this.mAppCenterIconSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ICON_SIZE;
    this.mAppCenterItemWidth = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ITEM_WIDTH;
    this.mAppCenterItemHeight = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ITEM_HEIGHT;
    this.mAppCenterMarginTop = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_MARGIN_TOP;
    this.mAppCenterMarginLeft = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_MARGIN_LEFT;
    this.mAppCenterMarginBottom = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_MARGIN_BOTTOM;
    this.mAppCenterNameWidth = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_NAME_WIDTH;
    this.mIconMarginVertical = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ICON_MARGIN;
    this.mAppCenterBubbleMarginTop = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_BUBBLE_MARGIN_TOP;
    this.mAppCenterBubbleMarginBottom = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_BUBBLE_MARGIN_BOTTOM;
  }

  private initHADStyle(): void {
    // 柔屏默认304DPI
    // 桌面左右两侧margin
    this.mMargin = PcPresetStyleConstants.HAD_MDPI_MARGIN;
    // 桌面顶部margin
    this.mMarginTop = PcPresetStyleConstants.HAD_DEFAULT_MDPI_MARGIN_TOP;
    // 桌面网格顶部margin
    this.mWorkSpacePaddingTop = GridLayoutUtil.getFloorVp(
      PcPresetStyleConstants.NEW_HAD_DEFAULT_WORK_SPACE_PADDING_TOP);
    // 桌面网格底部margin
    this.mWorkSpacePaddingBottom = PcPresetStyleConstants.NEW_HAD_DEFAULT_WORK_SPACE_PADDING_BOTTOM;

    this.mIndicatorHeight = PcPresetStyleConstants.NEW_HAD_PC_INDICATOR_HEIGHT;

    // 格子大小
    this.mAppItemSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_LAYOUT_SIZE;
    // 桌面图标大小，和dock图标大小不一样，需要单独处理
    this.mAppBubbleIconSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_BUBBLE_ICON_SIZE;
    this.mGridGutter = PcPresetStyleConstants.DEFAULT_MDPI_APP_LAYOUT_MIN_GUTTER;

    // 应用名称字体大小
    this.mNameSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_NAME_TEXT_SIZE;
    this.mNameWidth = PcPresetStyleConstants.DEFAULT_MDPI_DESKTOP_NAME_WIDTH;
    this.mNameHeight = PcPresetStyleConstants.DEFAULT_MDPI_DESKTOP_NAME_HEIGHT;

    // appCenter
    this.mAppCenterIconSize = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ICON_SIZE;
    this.mAppCenterItemWidth = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ITEM_WIDTH;
    this.mAppCenterItemHeight = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ITEM_HEIGHT;
    this.mAppCenterMarginTop = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_MARGIN_TOP;
    this.mAppCenterMarginLeft = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_MARGIN_LEFT;
    this.mAppCenterMarginBottom = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_MARGIN_BOTTOM;
    this.mAppCenterNameWidth = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_NAME_WIDTH;
    this.mIconMarginVertical = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_ICON_MARGIN;
    this.mAppCenterBubbleMarginTop = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_BUBBLE_MARGIN_TOP;
    this.mAppCenterBubbleMarginBottom = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_BUBBLE_MARGIN_BOTTOM;

    log.showInfo('had win style status bar');
    this.mSysTopHeight = PcPresetStyleConstants.WIN_STYLE_SYS_TOP_HEIGHT;
    this.mMarginTop = PcPresetStyleConstants.WIN_STYLE_HAD_DEFAULT_WORK_SPACE_TOP;
    this.mWorkSpacePaddingTop = GridLayoutUtil.getFloorVp(
      PcPresetStyleConstants.WIN_STYLE_HAD_DEFAULT_WORK_SPACE_TOP);
    this.mWorkSpacePaddingBottom = PcPresetStyleConstants.WIN_STYLE_HAD_DEFAULT_WORK_SPACE_BOTTOM;
    this.initAppCenterConfigOnSoftHAD();
  }

  public initSysTopHeight(): void {
    log.showInfo('win style status bar');
    this.mSysTopHeight = PcPresetStyleConstants.WIN_STYLE_SYS_TOP_HEIGHT;
  }

  private initAppCenterConfigOnSoftHAD(): void {
    log.showInfo('initAppCenterConfigOnSoftHAD');
    this.mAppCenterIconSize = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_ICON_SIZE;
    this.mAppCenterItemWidth = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_ITEM_WIDTH;
    this.mAppCenterItemHeight = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_ITEM_HEIGHT;
    this.mAppCenterMarginTop = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_MARGIN_TOP;
    this.mAppCenterMarginLeft = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_MARGIN_LEFT;
    this.mAppCenterMarginBottom = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_MARGIN_BOTTOM;
    this.mAppCenterNameWidth = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_NAME_WIDTH;
    this.mIconMarginVertical = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_ICON_MARGIN;
    this.mAppCenterBubbleMarginTop = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_BUBBLE_MARGIN_TOP;
    this.mAppCenterBubbleMarginBottom = PcPresetStyleConstants.DEFAULT_HAD_MDPI_APP_CENTER_BUBBLE_MARGIN_BOTTOM;
  }

  private initAppCenterConfigForHopper(): void {
    log.showInfo('initAppCenterConfig4Hopper');
    this.mAppCenterItemWidth = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_ITEM_WIDTH;
    this.mAppCenterItemHeight = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_ITEM_HEIGHT;
    this.mAppCenterMarginTop = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_MARGIN_TOP;
    this.mAppCenterMarginLeft = PcPresetStyleConstants.DEFAULT_MDPI_APP_CENTER_MARGIN_LEFT;
    this.mAppCenterMarginBottom = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_MARGIN_BOTTOM_P_UF;
    this.mAppCenterIconSize = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_ICON_SIZE;
    this.mAppCenterNameSize = PcPresetStyleConstants.DEFAULT_HPR_APP_CENTER_APPNAME_SIZE;
    this.mAppCenterIconRadius = PcPresetStyleConstants.DEFAULT_HPR_APP_CENTER_ICON_RADIUS;
  }
}