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

import preferences from '@ohos.data.preferences';
import { LogDomain, LogHelper, SingleBase, SingleContext, singleManager } from '@ohos/basicutils';
import { SettingsModel } from '../model/SettingsModel';
import { PresetStyleConstants } from '../constants/PresetStyleConstants';
import { StyleConstants } from '../constants/StyleConstants';
import type { LauncherLayoutStyleConfig } from '../layoutconfig/LauncherLayoutStyleConfig';
import type { BaseConfig } from './LayoutViewModel';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { FolderLayoutStruct, OpenFolderStyle, OpenFolderStyleParam } from '../TsIndex';

const TAG = 'LayoutRulesControllers';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const L_DPI_DENSITY = 200;

/**
 * Layout rules controller
 * 布局规则控制器基类，产品侧差异规则可复写该类
 */
export class LayoutRulesController extends SingleBase {
  public static singleName: string = 'LayoutRulesController';

  protected mLauncherLayoutStyleConfig: LauncherLayoutStyleConfig;

  protected mBaseConfig: BaseConfig;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): LayoutRulesController {
    let instance = singleManager.get<LayoutRulesController>(LayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    log.showInfo(`${LayoutRulesController.singleName} initBaseConfig start`);
    this.mBaseConfig = baseConfig;
    this.mLauncherLayoutStyleConfig = baseConfig.getLauncherLayoutStyleConfig();
  }

  calculateProductConfig(): void {
    log.showInfo('calculate product config');
  }

  /**
   * calculate dock
   */
  calculateDock(): CalculateDockRst {
    log.showInfo('calculateDock start');
    let listItemGap = this.mLauncherLayoutStyleConfig.mDockItemGap;
    let marginBottom = this.mLauncherLayoutStyleConfig.mDockMarginBottomHideBar;
    if (!this.mBaseConfig.getNavigationBarStatus()) {
      marginBottom = this.mLauncherLayoutStyleConfig.mDockMarginBottom;
    }
    log.showInfo(`calculateDock iconSize ${this.mLauncherLayoutStyleConfig.mDockIconSize}`);
    let maxNum = 0;
    let maxDockNum = 0;
    let dockSpaceWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockSaveMargin;
    let maxRecentNum = this.mLauncherLayoutStyleConfig.mDockMaxRecentNumber;
    let allMaxNum = this.calculateRecentArea(maxRecentNum, maxDockNum, maxNum, dockSpaceWidth);
    maxNum = allMaxNum.maxNum;
    maxDockNum = allMaxNum.maxDockNum;
    maxRecentNum = allMaxNum.maxRecentNum;
    if (!this.mBaseConfig.getIsPad()) {
      listItemGap = this.mBaseConfig.getDesktopGap() + StyleConstants.DEFAULT_2 * this.mBaseConfig.getItemPadding() + this.mBaseConfig.getNameHeight() +
        this.mBaseConfig.getIconNameMarginTop();
    }
    AppStorage.setOrCreate('pcUsableScreenHeight', this.mBaseConfig.getWorkSpaceHeight() - StyleConstants.DEFAULT_PC_BAR_HEIGHT);
    log.showInfo(`calculateDock DockHeight: ${this.mBaseConfig.getDockHeight()}, mSysUIBottomHeight: ${this.mBaseConfig.getSysUIBottomHeight()}`);
    let result: CalculateDockRst = {
      mDockGap: this.mLauncherLayoutStyleConfig.mDockGutter,
      mDockRadius : this.mLauncherLayoutStyleConfig.mDockRadius,
      mIconSize: this.mLauncherLayoutStyleConfig.mDockIconSize,
      mBackgroundColor: this.mLauncherLayoutStyleConfig.mBackgroundColor,
      mBackdropBlur: this.mLauncherLayoutStyleConfig.mBackdropBlur,
      mBackSaturation: this.mLauncherLayoutStyleConfig.mBackSaturation,
      mListItemWidth: this.mLauncherLayoutStyleConfig.mDockIconSize,
      mListItemHeight: this.mLauncherLayoutStyleConfig.mDockIconSize,
      mListItemGap: listItemGap,
      mDockPadding: this.mLauncherLayoutStyleConfig.mDockPadding,
      mMaxNum: maxNum,
      mMaxRecentNum: maxRecentNum,
      mMaxDockNum: maxDockNum,
      mMinResidentNum: this.mLauncherLayoutStyleConfig.mMinResidentNumber,
      mDockHeight: this.mLauncherLayoutStyleConfig.mDockIconSize + StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockPadding,
      mMarginBottom: marginBottom,
      mResidentSplitLineWidth: this.mLauncherLayoutStyleConfig.mDockResidentSplitLineWidth,
      mResidentSplitLineHeight: this.mLauncherLayoutStyleConfig.mDockResidentSplitLineHeight,
      mResidentSplitLineColor: this.mLauncherLayoutStyleConfig.mDockResidentSplitLineColor,
      mResidentSplitLineGap: this.mLauncherLayoutStyleConfig.mDockResidentSplitLineGap,
      mRecentArrowWidth: this.mLauncherLayoutStyleConfig.mDockRecentArrowWidth,
      mRecentArrowHeight: this.mLauncherLayoutStyleConfig.mDockRecentArrowHeight,
      mRecentArrowPadding: this.mLauncherLayoutStyleConfig.mDockRecentArrowPadding,
      mRecentArrowGap: this.mLauncherLayoutStyleConfig.mDockRecentArrowGap
    };
    return result;
  }

  private calculateRecentArea(maxRecentNum: number, maxDockNum: number, maxNum: number,
    dockSpaceWidth: number): RecentArea {
    if (this.mBaseConfig.getScreenWidth() < PresetStyleConstants.DEFAULT_DOCK_RECENT_WIDTH || !this.mBaseConfig.getIsPad()) {
      maxRecentNum = 0;
      maxDockNum = ~~((dockSpaceWidth - StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockPadding +
      this.mLauncherLayoutStyleConfig.mDockItemGap) / (this.mLauncherLayoutStyleConfig.mDockIconSize + this.mLauncherLayoutStyleConfig.mDockItemGap));
      maxNum = maxDockNum;
    } else {
      maxNum = ~~((dockSpaceWidth - this.mLauncherLayoutStyleConfig.mDockGutter - StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockPadding -
        StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockRecentArrowPadding - this.mLauncherLayoutStyleConfig.mDockResidentSplitLineWidth -
        StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockResidentSplitLineGap - StyleConstants.DEFAULT_2 *
        this.mLauncherLayoutStyleConfig.mDockRecentArrowWidth - StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockRecentArrowGap +
        StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockItemGap) /
        (this.mLauncherLayoutStyleConfig.mDockIconSize + this.mLauncherLayoutStyleConfig.mDockItemGap));
      maxDockNum = maxNum - maxRecentNum;
    };
    return {
      maxDockNum,
      maxNum,
      maxRecentNum
    };
  }

  /**
   * calculate desktop
   */
  calculateDesktop(): CalculateDesktopRst {
    let itemPadding = this.mBaseConfig.getItemPadding();
    let realWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mMargin;
    let realHeight = this.mBaseConfig.getWorkSpaceHeight() - this.mBaseConfig.getIndicatorHeight() -
      this.mBaseConfig.getSysUITopHeight();
    let itemSize = this.mBaseConfig.getIsPad() ? this.mBaseConfig.getItemSize() :
      this.mBaseConfig.getItemSize() + (this.mLauncherLayoutStyleConfig.mNameLines - 1) * this.mBaseConfig.getNameHeight();
    const baseColumn = (realWidth + this.mLauncherLayoutStyleConfig.mGridGutter) / (itemSize + this.mLauncherLayoutStyleConfig.mGridGutter);
    let column = ((this.mBaseConfig.getDefaultDisplay()?.densityDPI ?? 0) > L_DPI_DENSITY) ? ~~baseColumn : Math.ceil(baseColumn);
    let userWidth = (realWidth + this.mLauncherLayoutStyleConfig.mGridGutter - (itemSize + this.mLauncherLayoutStyleConfig.mGridGutter) * column);
    let gutter = (userWidth / (column - 1)) + this.mLauncherLayoutStyleConfig.mGridGutter;
    const baseRow = (realHeight + gutter) / (itemSize + gutter);
    let row = ((this.mBaseConfig.getDefaultDisplay()?.densityDPI ?? 0) > L_DPI_DENSITY) ? ~~baseRow : Math.ceil(baseRow);
    realHeight = (itemSize + gutter) * row - gutter + StyleConstants.DEFAULT_2 * itemPadding;
    realWidth = realWidth + StyleConstants.DEFAULT_2 * itemPadding;
    let iconMarginVertical = this.mLauncherLayoutStyleConfig.mIconMarginTOP;
    let iconMarginHorizontal = (itemSize - this.mLauncherLayoutStyleConfig.mDockIconSize) / StyleConstants.DEFAULT_2;
    this.updateGrid(row, column);
    let gutterReality = gutter - StyleConstants.DEFAULT_2 * itemPadding;
    if (gutterReality < 0) {
      gutterReality = 0;
      itemPadding = gutter / StyleConstants.DEFAULT_2;
    }
    if (!this.mBaseConfig.getIsPad()) {
      iconMarginVertical = 0;
    }
    iconMarginHorizontal = (itemSize - this.mLauncherLayoutStyleConfig.mIconBackgroundSize) / StyleConstants.DEFAULT_2;
    iconMarginVertical = iconMarginHorizontal;
    let result: CalculateDesktopRst = {
      mMargin: this.mLauncherLayoutStyleConfig.mMargin - itemPadding,
      mItemPadding: itemPadding,
      mColumnsGap: gutterReality,
      mRowsGap: gutterReality,
      mColumns: column,
      mRows: row,
      mDesktopMarginTop: this.mLauncherLayoutStyleConfig.mMarginTop,
      mGridWidth: realWidth,
      mGridHeight: realHeight,
      mAppItemSize: itemSize,
      mNameSize: this.mLauncherLayoutStyleConfig.mNameSize,
      mNameHeight: this.mBaseConfig.getNameHeight(),
      mNameWidth: this.mLauncherLayoutStyleConfig.mNameWidth,
      mIconNameMargin: this.mLauncherLayoutStyleConfig.mIconNameGap,
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      mIconSize: this.mLauncherLayoutStyleConfig.mDockIconSize,
      mNameLines: this.mLauncherLayoutStyleConfig.mNameLines,
      mIconMarginHorizontal: iconMarginHorizontal,
      mIconMarginVertical: iconMarginVertical
    };
    return result;
  }

  /**
   * update gridConfig info
   *
   * @param {number} row row of grid
   * @param {number} column column of grid
   */
  protected updateGrid(row: number, column: number): void {
    log.showDebug(`updateGrid row ${row} column ${column}`);
    SettingsModel.getInstance().updateGridConfigInfo(row, column);
  }

  /**
   * calculate desktop folder
   *
   * @param layoutInfo folder layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateFolder(layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateFolderRst {
    let itemSize = this.mLauncherLayoutStyleConfig.mAppItemSize;
    let gap = this.mBaseConfig.getDesktopGap();
    let gridRow = SettingsModel.getInstance().getGridConfig().row;
    log.showInfo(`calculateFolder itemSize ${itemSize} gridRow ${gridRow}`);
    let folderSize = (this.mBaseConfig.getGridRealHeight() + gap) / gridRow + this.mBaseConfig.getDesktopIconSize();
    let folderGutter = this.mLauncherLayoutStyleConfig.mFolderGutterRatio * folderSize;
    let folderMargin = this.mLauncherLayoutStyleConfig.mFolderMarginRatio * folderSize;

    let column = layoutInfo.column;
    let iconSize = (folderSize - folderGutter * StyleConstants.DEFAULT_2 - folderMargin * StyleConstants.DEFAULT_2) / column;
    log.showInfo(`calculateFolder folderSize: ${folderSize}, folderGutter: ${folderGutter},
      folderMargin: ${folderMargin}, iconSize: ${iconSize}`);
    let nameHeight = this.mBaseConfig.getNameHeight();
    let nameLines = this.mBaseConfig.getDesktopNameLines();
    let iconNameMargin = this.mBaseConfig.getDesktopIconNameMargin();
    let iconNameMarginTop = this.mBaseConfig.getIconNameMarginTop();
    let folderItemSize = folderSize + nameHeight * nameLines + iconNameMarginTop;
    let mFolderRadius = CommonConstants.DEFAULT_ICON_RADIUS;
    let mFolderRadius1x2 = CommonConstants.DEFAULT_ICON_RADIUS;
    let mSmallFolderRadius = CommonConstants.DEFAULT_ICON_RADIUS;
    let mFolderIconRadius = CommonConstants.DEFAULT_ICON_RADIUS;
    let result: CalculateFolderRst = {
      mGridSize: folderSize,
      mGridItemSize: folderItemSize,
      mFolderAppSize: iconSize,
      mFolderGridGap: folderGutter,
      mGridMargin: folderMargin,
      mNameHeight: nameHeight,
      mNameLines: nameLines,
      mIconNameMargin: iconNameMargin,
      mIconNameMarginTop: iconNameMarginTop,
      mFolderRadius: mFolderRadius,
      mSmallFolderRadius: mSmallFolderRadius,
      mFolderIconRadius: mFolderIconRadius,
      mFolderRadius1x2: mFolderRadius1x2
    };
    return result;
  }

  /**
   * calculate open folder
   *
   * @param openFolderConfig layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateOpenFolder(openFolderConfig: GridLayoutItemInfo | FolderLayoutStruct,
    isInPreviewMode?: boolean): CalculateOpenFolderRst {
    log.showInfo('calculateOpenFolder start');
    let row = openFolderConfig.row ?? 0;
    let column = openFolderConfig.column ?? 0;
    let gutter = this.mLauncherLayoutStyleConfig.mFolderOpenGutter;
    let padding = this.mLauncherLayoutStyleConfig.mFolderOpenPADDING;
    let margin = this.mLauncherLayoutStyleConfig.mFolderOpenMargin;
    let itemSize = this.mBaseConfig.getDesktopItemSize();
    let layoutWidth = column * itemSize + (column - 1) * gutter + StyleConstants.DEFAULT_2 * padding;
    let layoutHeight = row * itemSize + (row - 1) * gutter + StyleConstants.DEFAULT_2 * padding;
    let layoutSwiperHeight = row * itemSize + (row - 1) * gutter + StyleConstants.DEFAULT_2 * padding + itemSize;
    let title = (this.mBaseConfig.getScreenHeight() - layoutHeight) / StyleConstants.DEFAULT_2 - padding - margin;
    let mFolderIconRadius = CommonConstants.DEFAULT_ICON_RADIUS;
    let result: CalculateOpenFolderRst = {
      mOpenFolderGridRow: row,
      mOpenFolderGridColumn: column,
      mOpenFolderGridWidth: layoutWidth,
      mOpenFolderGridHeight: layoutHeight,
      mOpenFolderSwiperHeight: layoutSwiperHeight,
      mOpenFolderAddIconSize: this.mBaseConfig.getDesktopIconSize(),
      mOpenFolderIconSize: this.mBaseConfig.getDesktopIconSize(),
      mOpenFolderAppSize: this.mBaseConfig.getDesktopItemSize(),
      mOpenFolderAppNameSize: this.mBaseConfig.getDesktopNameSize(),
      mOpenFolderAppNameHeight: this.mBaseConfig.getNameHeight(),
      mOpenFolderGridGap: gutter,
      mOpenFolderGridPadding: padding,
      mFolderOpenMargin: margin,
      mFolderOpenTitle: title,
      mOpenFolderGridIconTopPadding: this.mBaseConfig.getDesktopIconMarginTop(),
      mFolderOpenItemSpace: 0,
      mFolderOpenRowGap: 0,
      mFolderOpenTittleMargin: 0,
      mFolderIconRadius: mFolderIconRadius
    };
    return result;
  }

  /**
   * calculate add app
   *
   * @param addFolderConfig
   */
  calculateFolderAddList(addFolderConfig: FolderLayoutStruct): CalculateFolderAddListRst {
    log.showInfo('calculateFolderAddList start');
    let column: number = addFolderConfig.column;
    let margin: number = this.mLauncherLayoutStyleConfig.mFolderAddGridMargin;
    let saveMargin: number = PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN;
    let screenGap: number = PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN;
    let gap: number = this.mLauncherLayoutStyleConfig.mFolderAddGridGap;
    let maxHeight: number = this.mLauncherLayoutStyleConfig.mFolderAddMaxHeight *
      (this.mBaseConfig.getScreenHeight() - this.mBaseConfig.getSysUITopHeight());
    let toggleSize: number = this.mLauncherLayoutStyleConfig.mFolderToggleSize;
    let screenColumns: number = PresetStyleConstants.DEFAULT_PHONE_GRID_APP_COLUMNS;
    let textSize: number = this.mLauncherLayoutStyleConfig.mFolderAddTextSize;
    let textLines: number = this.mLauncherLayoutStyleConfig.mFolderAddTextLines;
    let titleSize: number = this.mLauncherLayoutStyleConfig.mFolderAddTitleSize;
    let linesHeight = textSize * textLines;
    let buttonSize: number = this.mLauncherLayoutStyleConfig.mFolderAddButtonSize;
    let ratio: number = this.mLauncherLayoutStyleConfig.mFolderAddIconRatio;
    if (this.mBaseConfig.getIsPad()) {
      screenColumns = PresetStyleConstants.DEFAULT_PAD_GRID_APP_COLUMNS;
    }
    let columnsWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * saveMargin - (screenColumns - 1) * screenGap;
    let columnWidth = columnsWidth / screenColumns;
    let layoutWidth = columnWidth * column + (column - 1) * screenGap;
    let gridSize = layoutWidth - StyleConstants.DEFAULT_2 * margin;
    let itemSize = (gridSize - (column - 1) * gap) / column;
    let layoutHeight = layoutWidth + StyleConstants.DEFAULT_APP_ADD_TITLE_SIZE +
    StyleConstants.DEFAULT_BUTTON_HEIGHT_NUMBER +
    StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN_NUMBER;
    let iconSize = (1 - StyleConstants.DEFAULT_2 * ratio) * itemSize - linesHeight - this.mBaseConfig.getIconNameMarginTop();
    log.showInfo(`calculateFolderAddList layoutWidth: ${layoutWidth}, itemSize: ${itemSize},
      layoutHeight: ${layoutHeight}, iconSize: ${iconSize}, maxHeight: ${maxHeight}`);

    let result: CalculateFolderAddListRst = {
      mAddFolderGridWidth: gridSize,
      mAddFolderDialogWidth: layoutWidth,
      mAddFolderDialogHeight: layoutHeight,
      mAddFolderGridGap: gap,
      mAddFolderGridMargin: margin,
      mAddFolderMaxHeight: maxHeight,
      mFolderToggleSize: toggleSize,
      mAddFolderTextSize: textSize,
      mAddFolderTextLines: textLines,
      mAddFolderLinesHeight: linesHeight,
      mAddFolderItemSize: itemSize,
      mAddFolderIconPaddingTop: itemSize * ratio,
      mAddFolderIconMarginHorizontal: (itemSize - iconSize) / StyleConstants.DEFAULT_2,
      mAddFolderIconSize: iconSize,
      mAddFolderTitleSize: titleSize,
      mAddFolderButtonSize: buttonSize
    };
    return result;
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    log.showInfo('calculateForm start');
    let iconSize = this.mBaseConfig.getDesktopIconSize();
    let gridRow = SettingsModel.getInstance().getGridConfig().row;
    let gridColumn = SettingsModel.getInstance().getGridConfig().column;
    let gap = this.mBaseConfig.getDesktopGap();
    let folderSize = (this.mBaseConfig.getGridRealHeight() + gap) / gridRow + this.mBaseConfig.getDesktopIconSize();
    let widthDimension1: number = folderSize;
    let heightDimension1: number = iconSize;
    let widthDimension2 = folderSize;
    let heightDimension2 = folderSize;
    let widthDimension3 = (this.mBaseConfig.getGridRealWidth() + gap) / gridColumn * StyleConstants.DEFAULT_3 + this.mBaseConfig.getDesktopIconSize();
    let heightDimension3 = folderSize;
    let widthDimension4 = widthDimension3;
    let heightDimension4 = (this.mBaseConfig.getGridRealHeight() + gap) / gridRow * StyleConstants.DEFAULT_3 + this.mBaseConfig.getDesktopIconSize();
    let result: CalculateFormRst = {
      widthDimension2: widthDimension2,
      heightDimension2: heightDimension2,
      widthDimension1: widthDimension1,
      heightDimension1: heightDimension1,
      widthDimension3: widthDimension3,
      heightDimension3: heightDimension3,
      widthDimension4: widthDimension4,
      heightDimension4: heightDimension4,
      mIconNameMargin: this.mBaseConfig.getDesktopIconNameMargin(),
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
    };
    return result;
  }

  /**
   * calculate app center
   */
  calculateAppCenter(screenId: number = 0, isRefresh: boolean = false, screenWidth?: number,
    screenHeight?: number): CalculateAppCenterRst {
    let appCenterMarginLeft: number = this.mLauncherLayoutStyleConfig.mAppCenterMarginLeft;
    let gutter: number = this.mLauncherLayoutStyleConfig.mAppCenterGutter;
    let appItemSize = this.mLauncherLayoutStyleConfig.mAppCenterSize;
    let appCenterSizeWidth = this.mLauncherLayoutStyleConfig.mAppCenterSizeWidth;
    let appCenterSizeHeight = this.mLauncherLayoutStyleConfig.mAppCenterSizeHeight;
    let appCenterItemWidth = this.mLauncherLayoutStyleConfig.mAppCenterItemWidth;
    let appCenterItemHeight = this.mLauncherLayoutStyleConfig.mAppCenterItemHeight;
    let appCenterIconSize = this.mLauncherLayoutStyleConfig.mAppCenterIconSize;
    let appCenterBubbleMarginTop = this.mLauncherLayoutStyleConfig.mAppCenterBubbleMarginTop;
    let appCenterBubbleMarginBottom = this.mLauncherLayoutStyleConfig.mAppCenterBubbleMarginBottom;
    let width = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * appCenterMarginLeft;
    let appCenterMarginTop = this.mLauncherLayoutStyleConfig.mAppCenterMarginTop;
    let appCenterMarginBottom = this.mLauncherLayoutStyleConfig.mAppCenterMarginBottom;
    let height = this.mBaseConfig.getWorkSpaceHeight() - this.mLauncherLayoutStyleConfig.mDockMarginBottom - appCenterMarginTop - appCenterMarginBottom;
    let column = ~~((width + gutter) / (appCenterItemWidth + gutter));
    let row = ~~((height + gutter) / (appCenterItemHeight + gutter));
    log.showInfo(`calculateAppCenter columns=${column},rows=${row}, width:${width}, gutter: ${gutter} appCenterItemWidth:${appCenterItemWidth}   appCenterItemHeight:${appCenterItemHeight} this.mBaseConfig.getScreenWidth()：${this.mBaseConfig.getScreenWidth()}`);
    log.showInfo(`calculateAppCenter appCenterMarginLeft=${appCenterMarginLeft},getScreenHeight:${this.mBaseConfig.getScreenHeight()}  getWorkSpaceHeight:${this.mBaseConfig.getWorkSpaceHeight()} vp2px: ${vp2px(1)}`);
    let padding = (height - row * (appCenterItemHeight + gutter) + gutter) / StyleConstants.DEFAULT_2;
    let ratio = this.mLauncherLayoutStyleConfig.mAppCenterRatio;
    let lines = this.mLauncherLayoutStyleConfig.mAppCenterNameLines;
    let appTextSize = this.mLauncherLayoutStyleConfig.mAppCenterNameSize;
    let nameHeight = lines * appTextSize;
    let nameWidth = this.mLauncherLayoutStyleConfig.mAppCenterNameWidth;
    let iconMarginVertical = ratio * appItemSize;
    let iconHeight = appItemSize - StyleConstants.DEFAULT_2 * iconMarginVertical - nameHeight - this.mBaseConfig.getIconNameMarginTop();
    let indicatorBot = PresetStyleConstants.DEFAULT_INDICATOR_MARGIN_TOP;
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
      mNameWidth: nameWidth,
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
      mIndicatorBottom: indicatorBot
    };
    return result;
  }

  getSpaceOfRow(): number {
    return 0;
  }

  getSpaceOfColumn(): number {
    return 0;
  }


  toString(): String {
    return TAG;
  }
}

export class CalculateDesktopRst {
  mMargin?: number;
  mItemPadding?: number;
  mColumnsGap?: number;
  mRowsGap?: number;
  mColumns?: number;
  mRows?: number;
  mDesktopMarginTop?: number;
  mGridWidth?: number;
  mGridHeight?: number;
  mAppItemSize?: number;
  mNameSize?: number;
  mNameHeight?: number;
  mNameWidth?: number;
  mIconNameMargin?: number;
  mIconNameMarginTop?: number;
  mIconSize?: number;
  mNameLines?: number;
  mIconMarginHorizontal?: number;
  mIconMarginVertical?: number;
  marginBottomOfIndicator?: number;
  mHeightOfIndicator?: number;
  mWidthOfIndicator?: number;
  mPaddingSideFold?: number;
  mWorkSpaceWidth?: number;
  mWorkSpaceHeight?: number;
  mWorkSpacePaddingTop?: number;
  mWorkSpacePaddingBottom?: number;
  // 左右两边padding
  mWorkSpacePadding?: number;
}

export class CalculateDockRst {
  mDockGap?: number;
  mDockRadius?: number;
  mIconSize?: number;
  mBackgroundColor?: string;
  mBackdropBlur?: number;
  mBackSaturation?: number;
  mListItemWidth?: number;
  mListItemHeight?: number;
  mListItemGap?: number;
  mDockPadding?: number;
  mMaxNum?: number;
  mMaxRecentNum?: number;
  mMaxDockNum?: number;
  mMinResidentNum?: number;
  mDockHeight?: number;
  mMarginBottom?: number;
  mResidentSplitLineWidth?: number;
  mResidentSplitLineHeight?: number;
  mResidentSplitLineColor?: string;
  mResidentSplitLineGap?: number;
  mRecentArrowWidth?: number;
  mRecentArrowHeight?: number;
  mRecentArrowPadding?: number;
  mRecentArrowGap?: number;
}

export class CalculateFolderRst {
  mGridSize?: number;
  mGridItemSize?: number;
  mFolderAppSize?: number;
  mFolderGridGap?: number;
  mGridMargin?: number;
  mNameHeight?: number;
  mNameLines?: number;
  mIconNameMargin?: number;
  mIconNameMarginTop?: number;
  mFolderRadius?: number;
  mSmallFolderRadius?: number;
  mFolderIconRadius?: number;
  mFolderRadius1x2?: number;
  mBindSheetGridPadding?: number;
  mBindSheetTitlePadding?: number;
}

export class CalculateOpenFolderRst {
  mOpenFolderGridRow?: number;
  mOpenFolderGridColumn?: number;
  mOpenFolderGridWidth?: number;
  mOpenFolderGridHeight?: number;
  mOpenFolderSwiperHeight?: number;
  mOpenFolderAddIconSize?: number;
  mOpenFolderIconSize?: number;
  mOpenFolderAppSize?: number;
  mOpenFolderAppNameSize?: number;
  mOpenFolderAppNameHeight?: number;
  mOpenFolderGridGap?: number;
  mOpenFolderGridPadding?: number;
  mFolderOpenMargin?: number;
  mFolderOpenTitle?: number;
  mOpenFolderGridIconTopPadding?: number;
  mFolderOpenItemSpace?: number;
  mFolderOpenRowGap?: number;
  mFolderOpenTittleMargin?: number;
  mFolderIconRadius?: number;
  mOpenFolderStyleParam?: OpenFolderStyleParam;
  mOpenFolderStyle? : OpenFolderStyle;
}

export class CalculateFolderAddListRst {
  mAddFolderGridWidth?: number;
  mAddFolderDialogWidth?: number;
  mAddFolderDialogHeight?: number;
  mAddFolderGridGap?: number;
  mAddFolderGridMargin?: number;
  mAddFolderMaxHeight?: number;
  mFolderToggleSize?: number;
  mAddFolderTextSize?: number;
  mAddFolderTextLines?: number;
  mAddFolderLinesHeight?: number;
  mAddFolderItemSize?: number;
  mAddFolderIconPaddingTop?: number;
  mAddFolderIconMarginHorizontal?: number;
  mAddFolderIconSize?: number;
  mAddFolderTitleSize?: number;
  mAddFolderButtonSize?: number;
}

export class CalculateFormRst {
  widthDimension0?: number;
  heightDimension0?: number;
  widthDimension1?: number;
  heightDimension1?: number;
  widthDimension2?: number;
  heightDimension2?: number;
  widthDimension3?: number;
  heightDimension3?: number;
  widthDimension4?: number;
  heightDimension4?: number;
  widthDimension5?: number;
  heightDimension5?: number;
  widthDimension6?: number;
  heightDimension6?: number;
  mIconNameMargin?: number;
  mIconNameMarginTop?: number;
}

export class CalculateAppCenterRst {
  mColumnsGap?: number;
  mRowsGap?: number;
  mColumns?: number;
  mRows?: number;
  mGridWidth?: number;
  mGridHeight?: number;
  mPadding?: number;
  mNameSize?: number;
  mNameHeight?: number;
  mNameWidth?: number;
  mIconSize?: number;
  mNameLines?: number;
  mIconRadius?: number;
  mIconMarginVertical?: number;
  mAppCenterSizeWidth?: number;
  mAppCenterSizeHeight?: number;
  mAppCenterItemWidth?: number;
  mAppCenterItemHeight?: number;
  mAppCenterMarginLeft?: number;
  mAppCenterMarginTop?: number;
  mAppCenterMarginRight?: number;
  mAppCenterMarginBottom?: number;
  mAppCenterBubbleMarginTop?: number;
  mAppCenterBubbleMarginBottom?: number;
  mAppItemSize?: number;
  mIndicatorBottom?: number;
  mRatio?: number;
}

class RecentArea {
  public maxDockNum: number = 0;
  public maxNum: number = 0;
  public maxRecentNum: number = 0;
}