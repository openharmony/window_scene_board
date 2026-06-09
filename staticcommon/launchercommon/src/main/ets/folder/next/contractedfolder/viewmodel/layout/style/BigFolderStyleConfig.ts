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

import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { CommonConstants } from '../../../../../../constants/CommonConstants';
import { PresetStyleConstants } from '../../../../../../constants/PresetStyleConstants';
import { StyleConstants } from '../../../../../../constants/StyleConstants';
import { AppListStyleConfig } from '../../../../../../layoutconfig/AppListStyleConfig';
import { CalculateFolderRst, CalculateOpenFolderRst } from '../../../../../../viewmodel/LayoutRulesController';
import { LayoutViewModel } from '../../../../../../viewmodel/LayoutViewModel';
import FolderStyleConstants from '../../../../../common/FolderStyleConstants';
import { FolderModel } from '../../../../../FolderModel';
import { FolderCommonConstants } from '../../../../common/FolderCommonConstant';

/**
 * 文件夹布局配置
 */
export class BigFolderStyleConfig extends AppListStyleConfig {
  private static instance: BigFolderStyleConfig;
  private static isInPreviewMode: boolean = false;

  /**
   * folder grid size
   */
  mGridSize = StyleConstants.DEFAULT_FOLDER_GRID_SIZE;

  /**
   * folder grid item size
   */
  mGridItemSize = StyleConstants.DEFAULT_FOLDER_GRID_ITEM_SIZE;

  /**
   * folder app size
   */
  mFolderAppSize = StyleConstants.DEFAULT_FOLDER_APP_SIZE;

  /**
   * folder grid margin side
   */
  mGridMargin = StyleConstants.DEFAULT_FOLDER_GRID_MARGIN;

  /**
   * folder grid gap
   */
  mFolderGridGap = StyleConstants.DEFAULT_FOLDER_GRID_GAP;

  /**
   * margin of folder open
   */
  mFolderOpenMargin = StyleConstants.DEFAULT_OPEN_FOLDER_TITLE_HEIGHT;
  mFolderOpenTitle = StyleConstants.DEFAULT_OPEN_FOLDER_TITLE_TOP;

  /**
   * open folder grid row
   */
  mOpenFolderGridRow = StyleConstants.DEFAULT_OPEN_FOLDER_GRID_ROW;

  /**
   * open folder grid column
   */
  mOpenFolderGridColumn = StyleConstants.DEFAULT_OPEN_FOLDER_GRID_COLUMN;

  /**
   * open folder app size
   */
  mOpenFolderAppSize = StyleConstants.DEFAULT_OPEN_FOLDER_APP_SIZE;

  /**
   * icon size of open folder
   */
  mOpenFolderIconSize = StyleConstants.DEFAULT_OPEN_FOLDER_APP_SIZE;

  /**
   * add icon size of open folder
   */
  mOpenFolderAddIconSize = StyleConstants.DEFAULT_ADD_APP_SIZE;

  /**
   * open folder app size
   */
  mOpenFolderAppNameSize = StyleConstants.DEFAULT_OPEN_FOLDER_APP_NAME_SIZE;

  /**
   * open folder app name height
   */
  mOpenFolderAppNameHeight = StyleConstants.DEFAULT_OPEN_FOLDER_APP_NAME_HEIGHT;

  /**
   * open folder app name width
   */
  mOpenFolderAppNameWidth = StyleConstants.DEFAULT_OPEN_FOLDER_APP_NAME_WIDTH;

  /**
   * open folder grid width
   */
  mOpenFolderGridWidth = StyleConstants.DEFAULT_OPEN_FOLDER_GRID_WIDTH;

  /**
   * open folder tittle margin
   */
  mOpenFolderTittleMargin = StyleConstants.DEFAULT_OPEN_FOLDER_TITTLE_MARGIN;

  /**
   * open folder grid height
   */
  mOpenFolderGridHeight = StyleConstants.DEFAULT_OPEN_FOLDER_GRID_HEIGHT;

  /**
   * open folder swiper height
   */
  mOpenFolderSwiperHeight = StyleConstants.DEFAULT_OPEN_FOLDER_SWIPER_HEIGHT;

  /**
   * open folder grid col gap
   */
  mOpenFolderGridGap = StyleConstants.DEFAULT_OPEN_FOLDER_GRID_GAP;

  /**
   * open folder grid row gap
   */
  mOpenFolderGridRowGap = StyleConstants.DEFAULT_OPEN_FOLDER_GRID_ROW_GAP;

  /**
   * open folder swiper itemSpace
   */
  mOpenFolderSwiperItemSpace = StyleConstants.DEFAULT_OPEN_FOLDER_SWIPER_ITEM_SPACE;

  /**
   * padding of open folder layout
   */
  mOpenFolderGridPadding = PresetStyleConstants.DEFAULT_OPEN_FOLDER_PADDING;

  /**
   * padding of open folder icon
   */
  mOpenFolderGridIconTopPadding = PresetStyleConstants.DEFAULT_ICON_PADDING_TOP;
  /**
   * width of add app dialog
   */
  mAddFolderDialogWidth: number = FolderStyleConstants.DEFAULT_APP_ADD_DIALOG_WIDTH;

  /**
   * height of add app dialog
   */
  mAddFolderDialogHeight: number = FolderStyleConstants.DEFAULT_APP_ADD_DIALOG_HEIGHT;

  /**
   * width of add app container
   */
  mAddFolderGridWidth: number = FolderStyleConstants.DEFAULT_FOLDER_APP_GRID_LIST;

  /**
   * gap of add app container
   */
  mAddFolderGridGap: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_GAP;

  /**
   * margin of add app container
   */
  mAddFolderGridMargin: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_MARGIN;

  /**
   * maxHeight of add app container
   */
  mAddFolderMaxHeight: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_MAX_HEIGHT;

  /**
   * size of add app toggle
   */
  mFolderToggleSize: number = PresetStyleConstants.DEFAULT_APP_GRID_TOGGLE_SIZE;

  /**
   * title size of add app
   */
  mAddFolderTitleSize: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_TITLE_TEXT_SIZE;

  /**
   * text size of add app item
   */
  mAddFolderTextSize: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_GRID_TEXT_SIZE;

  /**
   * name lines of add app item
   */
  mAddFolderTextLines: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_TEXT_LINES;

  /**
   * line height of add app item
   */
  mAddFolderLinesHeight: number = PresetStyleConstants.DEFAULT_TEXT_LINES;

  /**
   * icon size of add app
   */
  mAddFolderIconSize: number = PresetStyleConstants.DEFAULT_ICON_SIZE;

  /**
   * size of add app item
   */
  mAddFolderItemSize: number = PresetStyleConstants.DEFAULT_APP_LAYOUT_SIZE;

  /**
   * padding top of add app icon
   */
  mAddFolderIconNameTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_TOP;

  /**
   * padding top of add app height top
   */
  mAddFolderIconNameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;

  /**
   * padding top of add app icon
   */
  mAddFolderIconPaddingTop: number = PresetStyleConstants.DEFAULT_ICON_PADDING_TOP;

  /**
   * button size of add app
   */
  mAddFolderButtonSize: number = PresetStyleConstants.DEFAULT_FOLDER_ADD_BUTTON_SIZE;

  /**
   * margin left of icon with add app item
   */
  mAddFolderIconMarginHorizontal = PresetStyleConstants.DEFAULT_ICON_PADDING_LEFT;
  /**
   * folder list blur
   */
  mBackdropBlur = 20;

  mFolderRadius = StyleConstants.DEFAULT_FOLDER_RADIUS;
  /**
   * big folder 1x2 2x1 radius
   */
  mFolderRadius1x2 = StyleConstants.DEFAULT_FOLDER_RADIUS;

  mFolderIconRadius = CommonConstants.DEFAULT_ICON_RADIUS;

  mFolderSuperposeIconRadius = CommonConstants.DEFAULT_ICON_RADIUS;

  mClosedFolderIconRadius = CommonConstants.DEFAULT_ICON_RADIUS;

  mBindSheetGridPadding = StyleConstants.DEFAULT_BIND_SHEET_GRID_PADDING;

  mBindSheetTitlePadding = StyleConstants.DEFAULT_BIND_SHEET_TITLE_PADDING;

  folderHorizontalPending = 0;

  private constructor() {
    super();
  }

  /**
   * get folder style config instance
   */
  public static getInstance(): BigFolderStyleConfig {
    if (BigFolderStyleConfig.instance == null) {
      BigFolderStyleConfig.instance = new BigFolderStyleConfig();
    }
    BigFolderStyleConfig.instance.initConfig();
    return BigFolderStyleConfig.instance;
  }

  /**
   * 设置是否是预览模式
   *
   * @param isInPreviewMode
   */
  public static setInPreviewMode(isInPreviewMode: boolean): void {
    BigFolderStyleConfig.isInPreviewMode = isInPreviewMode;
    BigFolderStyleConfig.instance?.initConfig();
  }

  public initConfig(): void {
    const desktopFolderLayoutInfo = FolderModel.getInstance().getBigFolderLayout();
    const folderResult =
      LayoutViewModel.getInstance().calculateFolder(desktopFolderLayoutInfo, BigFolderStyleConfig.isInPreviewMode);
    const openFolderLayoutInfo = FolderModel.getInstance().getFolderOpenLayout();
    const openResult =
      LayoutViewModel.getInstance().calculateOpenFolder(openFolderLayoutInfo, BigFolderStyleConfig.isInPreviewMode);
    // 初始化folder和openFolder的样式
    this.initFolderStyle(folderResult);
    this.initOpenFolderStyle(openResult);

    let column = FolderModel.getInstance()?.getFolderOpenLayout()?.column ?? 0;
    if (column <= 0) {
      column = NumberConstants.CONSTANT_NUMBER_THREE;
    }
    this.folderHorizontalPending =
      (this.mOpenFolderGridWidth / column - this.mOpenFolderIconSize) / NumberConstants.CONSTANT_NUMBER_TWO;

    this.calculateFolderAddList();
  }

  private initFolderStyle(folderResult: CalculateFolderRst): void {
    this.mGridSize = folderResult.mGridSize ?? 0;
    this.mFolderAppSize = folderResult.mFolderAppSize ?? 0;
    this.mFolderGridGap = folderResult.mFolderGridGap ?? 0;
    this.mGridItemSize = folderResult.mGridItemSize ?? 0;
    this.mGridMargin = folderResult.mGridMargin ?? 0;
    this.mNameHeight = folderResult.mNameHeight ?? 0;
    this.mNameLines = folderResult.mNameLines ?? 0;
    this.mIconNameMargin = folderResult.mIconNameMargin ?? 0;
    this.mIconNameMarginTop = folderResult.mIconNameMarginTop ?? 0;
    this.mFolderRadius = folderResult.mFolderRadius ?? 0;
    this.mFolderRadius1x2 = folderResult.mFolderRadius1x2 ?? 0;
    this.mClosedFolderIconRadius = folderResult.mFolderIconRadius ?? 0;
    this.mBindSheetGridPadding = folderResult.mBindSheetGridPadding ?? 0;
    this.mBindSheetTitlePadding = folderResult.mBindSheetTitlePadding ?? 0;
  }

  private initOpenFolderStyle(openResult: CalculateOpenFolderRst): void {
    this.mOpenFolderGridRow = openResult.mOpenFolderGridRow ?? 0;
    this.mOpenFolderGridColumn = openResult.mOpenFolderGridColumn ?? 0;
    this.mOpenFolderGridWidth = openResult.mOpenFolderGridWidth ?? 0;
    this.mOpenFolderGridHeight = openResult.mOpenFolderGridHeight ?? 0;
    this.mOpenFolderSwiperHeight = openResult.mOpenFolderSwiperHeight ?? 0;
    this.mOpenFolderIconSize = openResult.mOpenFolderIconSize ?? 0;
    this.mOpenFolderAddIconSize = openResult.mOpenFolderAddIconSize ?? 0;
    this.mOpenFolderAppSize = openResult.mOpenFolderAppSize ?? 0;
    this.mOpenFolderAppNameSize = openResult.mOpenFolderAppNameSize ?? 0;
    this.mOpenFolderAppNameHeight = openResult.mOpenFolderAppNameHeight ?? 0;
    this.mOpenFolderGridGap = openResult.mOpenFolderGridGap ?? 0;
    this.mOpenFolderGridPadding = openResult.mOpenFolderGridPadding ?? 0;
    this.mFolderOpenMargin = openResult.mFolderOpenMargin ?? 0;
    this.mFolderOpenTitle = openResult.mFolderOpenTitle ?? 0;
    this.mOpenFolderGridIconTopPadding = openResult.mOpenFolderGridIconTopPadding ?? 0;
    this.mOpenFolderSwiperItemSpace = openResult.mFolderOpenItemSpace ?? 0;
    this.mOpenFolderGridRowGap = openResult.mFolderOpenRowGap ?? 0;
    this.mOpenFolderTittleMargin = openResult.mFolderOpenTittleMargin ?? 0;
    this.mFolderIconRadius = openResult.mFolderIconRadius ?? 0;
  }

  private calculateFolderAddList(): void {
    const addAppLayoutInfo = FolderModel.getInstance().getFolderAddAppLayout();
    const addResult = LayoutViewModel.getInstance().calculateFolderAddList(addAppLayoutInfo);
    this.mAddFolderGridWidth = addResult.mAddFolderGridWidth ?? 0;
    this.mAddFolderDialogWidth = addResult.mAddFolderDialogWidth ?? 0;
    this.mAddFolderDialogHeight = addResult.mAddFolderDialogHeight ?? 0;
    this.mAddFolderGridGap = addResult.mAddFolderGridGap ?? 0;
    this.mAddFolderGridMargin = addResult.mAddFolderGridMargin ?? 0;
    this.mAddFolderMaxHeight = addResult.mAddFolderMaxHeight ?? 0;
    this.mFolderToggleSize = addResult.mFolderToggleSize ?? 0;
    this.mAddFolderTextSize = addResult.mAddFolderTextSize ?? 0;
    this.mAddFolderTextLines = addResult.mAddFolderTextLines ?? 0;
    this.mAddFolderLinesHeight = addResult.mAddFolderLinesHeight ?? 0;
    this.mAddFolderItemSize = addResult.mAddFolderItemSize ?? 0;
    this.mAddFolderIconPaddingTop = addResult.mAddFolderIconPaddingTop ?? 0;
    this.mAddFolderIconMarginHorizontal = addResult.mAddFolderIconMarginHorizontal ?? 0;
    this.mAddFolderIconSize = addResult.mAddFolderIconSize ?? 0;
    this.mAddFolderTitleSize = addResult.mAddFolderTitleSize ?? 0;
    this.mAddFolderButtonSize = addResult.mAddFolderButtonSize ?? 0;
  }

  public getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE;
  }

  public getFeatureName(): string {
    return FolderCommonConstants.FEATURE_NAME_BIG_FOLDER;
  }
}
