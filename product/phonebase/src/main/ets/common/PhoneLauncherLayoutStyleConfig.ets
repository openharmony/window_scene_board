/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { CommonConstants } from '@ohos/launchercommon';
import { PresetStyleConstants } from '@ohos/launchercommon';
import { LauncherLayoutStyleConfig } from '@ohos/launchercommon';
import PadPresetConstants from './constants/PadPresetConstants';
import PhonePresetConstants from './constants/PhonePresetConstants';

/**
 * Phone launcher config
 */
export default class PhoneLauncherLayoutStyleConfig extends LauncherLayoutStyleConfig {
  /**
   * UninstallDialog width
   */
  public mUninstallDialogWidth = PhonePresetConstants.DEFAULT_UNINSTALLDIALOG_WIDTH;

  /**
   * systemUI top height
   */
  public mSysTopHeight = PhonePresetConstants.DEFAULT_SYS_TOP_HEIGHT;

  /**
   * systemUI bottom height
   */
  public mSysBottomHeight = PhonePresetConstants.DEFAULT_SYS_BOTTOM_HEIGHT;

  /**
   * systemUI height (top + bottom)
   */
  public mSystemUIHeight = PresetStyleConstants.DEFAULT_PHONE_SYSTEM_UI;

  /**
   * Status bottom padding
   */
  public mSystemUIBottomPadding = PhonePresetConstants.DEFAULT_SYSTEM_UI_BOTTOM_PADDING;

  /**
   * indicator height
   */
  public mIndicatorHeight = PhonePresetConstants.DEFAULT_PHONE_INDICATOR_HEIGHT;

  /**
   * desktop item Size
   */
  public mAppItemSize = PhonePresetConstants.DEFAULT_APP_LAYOUT_SIZE;

  /**
   * desktop space margin
   */
  public mMargin = PhonePresetConstants.DEFAULT_LAYOUT_MARGIN;

  /**
   * grid item padding
   */
  public mItemPadding = PhonePresetConstants.DEFAULT_LAYOUT_ITEM_PADDING;

  /**
   * desktop grid gap
   */
  public mGridGutter = PhonePresetConstants.DEFAULT_APP_LAYOUT_MIN_GUTTER;

  /**
   * icon name lines
   */
  public mNameLines: number = PhonePresetConstants.DEFAULT_APP_NAME_LINES;

  /**
   * icon ratio
   */
  public mIconRatio: number = PhonePresetConstants.DEFAULT_APP_TOP_RATIO;

  /**
   * icon name margin
   */
  public mIconNameGap: number = PhonePresetConstants.DEFAULT_ICON_NAME_GAP;

  /**
   * desktop icon name margin top
   */
  public mIconNameMarginTop: number = PhonePresetConstants.DEFAULT_ICON_NAME_MARGIN_TOP;

  /**
   * icon name text size
   */
  public mNameSize: number = PhonePresetConstants.DEFAULT_APP_NAME_TEXT_SIZE;

  /**
   * name height
   */
  public mNameHeight: number = PhonePresetConstants.DEFAULT_DESKTOP_NAME_HEIGHT;

  /**
   * name width
   */
  public mNameWidth: number = PhonePresetConstants.DEFAULT_DESKTOP_NAME_WIDTH;

  //folder
  /**
   * ratio of gutter with folder
   */
  public mFolderGutterRatio: number = PhonePresetConstants.DEFAULT_FOLDER_GUTTER_RATIO;

  /**
   * ratio of margin with folder
   */
  public mFolderMarginRatio: number = PhonePresetConstants.DEFAULT_FOLDER_PADDING_RATIO;

  /**
   * gutter of open folder
   */
  public mFolderOpenGutter: number = PhonePresetConstants.DEFAULT_OPEN_FOLDER_GUTTER;

  /**
   * margin of open folder tittle
   */
  public mFolderOpenTittleMargin: number = PhonePresetConstants.DEFAULT_OPEN_FOLDER_TITTLE_MARGIN;

  /**
   * padding of open folder
   */
  public mFolderOpenPADDING: number = PhonePresetConstants.DEFAULT_OPEN_FOLDER_PADDING;

  /**
   * margin of open folder
   */
  public mFolderOpenMargin: number = PhonePresetConstants.DEFAULT_OPEN_FOLDER_MARGIN_TOP;

  /**
  * margin top of open folder
  */
  public mFolderOpenTitle: number = PhonePresetConstants.DEFAULT_OPEN_FOLDER_TITLE_TOP;

  /**
   * gutter of add app
   */
  public mFolderAddGridGap: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_GAP;

  /**
   * margin of add app and padding of add app
   */
  public mFolderAddGridMargin: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_MARGIN;

  /**
   * max height of add app
   */
  public mFolderAddMaxHeight: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_MAX_HEIGHT;

  /**
   * toggle size of add app
   */
  public mFolderToggleSize: number = PhonePresetConstants.DEFAULT_APP_GRID_TOGGLE_SIZE;

  /**
   * name lines of add app
   */
  public mFolderAddTextLines: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_TEXT_LINES;

  /**
   * text size of add app
   */
  public mFolderAddTextSize: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_GRID_TEXT_SIZE;

  /**
   * title size of add app
   */
  public mFolderAddTitleSize: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_TITLE_TEXT_SIZE;

  /**
   * ratio of padding top with icon in add app
   */
  public mFolderAddIconRatio: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_ICON_TOP_RATIO;

  /**
   * button size of add app
   */
  public mFolderAddButtonSize: number = PhonePresetConstants.DEFAULT_FOLDER_ADD_BUTTON_SIZE;

  //App Center
  /**
   * margin of app center
   */
  public mAppCenterMargin: number = PhonePresetConstants.DEFAULT_APP_CENTER_MARGIN;

  /**
   * gutter of app center
   */
  public mAppCenterGutter: number = PhonePresetConstants.DEFAULT_APP_CENTER_GUTTER;

  /**
   * size of app center container
   */
  public mAppCenterSize: number = PhonePresetConstants.DEFAULT_APP_CENTER_SIZE;

  /**
   * ratio of padding top with icon in app center
   */
  public mAppCenterRatio: number = PhonePresetConstants.DEFAULT_APP_CENTER_TOP_RATIO;

  /**
   * name lines of app center
   */
  public mAppCenterNameLines: number = PhonePresetConstants.DEFAULT_APP_CENTER_NAME_LINES;

  /**
   * name size of app center
   */
  public mAppCenterNameSize: number = PhonePresetConstants.DEFAULT_APP_CENTER_NAME_TEXT_SIZE;

  //dock
  /**
   * padding of dock
   */
  public mDockPadding: number =
    DeviceHelper.isPad() ? PadPresetConstants.DOCK_PADDING : PhonePresetConstants.DEFAULT_DOCK_PADDING;

  /**
   * phone icon size of dock
   */
  public mPhoneDockIconSize: number =
    DeviceHelper.isUltraScreenGPortrait() ? PhonePresetConstants.DEFAULT_PORTRAIT_DOCK_ICON_SIZE :
    PhonePresetConstants.DEFAULT_DOCK_ICON_SIZE;

  /**
   * icon size of dock
   */
  public mDockIconSize: number =
    DeviceHelper.isPad() ? PadPresetConstants.DOCK_ICON_SIZE : this.mPhoneDockIconSize;

  /**
   * gap of icon and icon
   */
  public mDockItemGap: number = PhonePresetConstants.DEFAULT_DOCK_ITEM_GAP;

  /**
   * gap of dock and dock
   */
  public mDockGutter: number = PhonePresetConstants.DEFAULT_DOCK_GUTTER;

  /**
   * save margin of dock
   */
  public mDockSaveMargin: number = PhonePresetConstants.DEFAULT_DOCK_SAVE_MARGIN;

  /**
   * margin bottom of dock
   */
  public mDockMarginBottom: number = PhonePresetConstants.DEFAULT_DOCK_MARGIN_BOTTOM;

  /**
   * margin bottom of dock (Immersive navigation bar)
   */
  public mDockMarginBottomHideBar: number =
    DeviceHelper.isPhone() ? PhonePresetConstants.DEFAULT_DOCK_MARGIN_BOTTOM_HIDE_BAR :
    PadPresetConstants.DEFAULT_DOCK_MARGIN_BOTTOM_HIDE_BAR;

  /**
   * open folder grid height
   */
  public mOpenFolderGridHeight: number = PhonePresetConstants.DEFAULT_OPEN_FOLDER_GRID_HEIGHT;

  /**
   * open folder swiper height
   */
  public mOpenFolderSwiperHeight: number = PhonePresetConstants.DEFAULT_OPEN_FOLDER_SWIPER_HEIGHT;

  private static phoneInstance: PhoneLauncherLayoutStyleConfig;

  private constructor() {
    super();
  }

  /**
   * PhoneLauncherLayoutStyleConfig of instance
   */
  static getInstance(): PhoneLauncherLayoutStyleConfig {
    if (PhoneLauncherLayoutStyleConfig.phoneInstance == null) {
      PhoneLauncherLayoutStyleConfig.phoneInstance = new PhoneLauncherLayoutStyleConfig();
    }
    return PhoneLauncherLayoutStyleConfig.phoneInstance;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }

  getFeatureName(): string {
    return LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG;
  }
}
