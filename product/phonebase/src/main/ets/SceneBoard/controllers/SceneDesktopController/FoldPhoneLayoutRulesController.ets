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

import {
  CalculateFolderRst,
  ConfigParseUtil,
  FolderLayoutStruct,
  FolderStyleConstants,
  OpenFolderStyle,
  OpenFolderStyleParam,
  StyleConstants
} from '@ohos/launchercommon';
import { CheckEmptyUtils, FileUtils, Log, SingleContext, singleManager } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import type {
  CalculateOpenFolderRst,
  BaseConfig,
  CalculateDesktopRst,
  CalculateDockRst,
  CalculateFormRst
} from '@ohos/launchercommon';
import preferences from '@ohos.data.preferences';
import { IconSize, PhoneLayoutRulesController, ScreenWidth } from './PhoneLayoutRulesController';
import type ctx from '@ohos.app.ability.common';
import { RadiusUtil } from '@ohos/launchercommon';
import { DesktopMode } from '@ohos/launchercommon';
import { FolderStyleCalculate } from '@ohos/bigfolder/src/main/ets/default/viewmodel/FolderStyleCalculate';

const TAG = 'FoldPhoneLayoutRulesControllers';
const GRID_CONFIG_PATH = 'etc/SceneBoard/launcher_layout_rules.json';
interface DesktopStatus {
  itemPadding: number,
  realGridWidth: number,
  marginGrid: number,
  paddingSideFold: number,
  lines: number,
  nameHeight: number,
  itemSize: number,
  realGridHeight: number,
  marginTop: number,
  marginBottomOfIndicator: number,
  appTextSize: number,
  nameWidth: number,
  iconNameMargin: number,
  iconNameMarginTop: number,
  iconMarginHorizontal: number
};
/**
 * 二折的展开态，三折的M态竖屏布局器
 */
export class FoldPhoneLayoutRulesController extends PhoneLayoutRulesController {
  public static singleName: string = 'FoldPhoneLayoutRulesController';

  /** 双屏之间间距，通过计算得到*/
  protected spaceOfScreenSide: number = 0;

  /**
   * 横屏状态图标行间距配置
   */
  protected configSpaceOfRow: number = 0;

  /**
   * 横屏状态默认图标大小配置
   */
  protected landIconSizeOfGrid: number = 0;

  /**
   * Default bindSheet grid padding size in landscape mode
   */
  protected bindSheetGridPadding: number = 14;

  /**
   * Default bindSheet title padding size in landscape mode
   */
  protected bindSheetTitlePadding: number = 2;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): FoldPhoneLayoutRulesController {
    let instance = singleManager.get<FoldPhoneLayoutRulesController>(FoldPhoneLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    Log.showInfo(TAG, `${FoldPhoneLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
  }

  /**
   * 列间距计算规则：X = (ScreenWidth + 8vp * 2 - iconSize * cellXNum) / (cellXNum + 1)
   * 行间距计算规则：X + offset
   * 比例为：[19.5:9 , 19.9:9 ] offset = 8  其他  offset = 4
   * 行间距 offset修正 offset +2
   */
  calculateProductConfig(): void {
    this.initGridIconSize();
    if (this.mScreenWidth === 0) {
      Log.showInfo(TAG, `calculate mScreenWidth ${this.mScreenWidth}`);
      this.mScreenWidth = this.mBaseConfig.getScreenWidth();
    }

    Log.showInfo(TAG, `calculateProductConfig ${this.mScreenWidth} gap ${this.columnSpaceGapOfSide}` +
      `size: ${this.iconSizeOfGrid} columnNumOfGrid  ${this.columnNumOfGrid}`);
    this.initRowAndColumnGap();
    this.initSpaceSideOfColumnAndScreen(StyleConstants.DEFAULT_2);
    Log.showInfo(TAG, `spaceOfColumn: ${this.spaceOfColumn}, spaceOfRow: ${this.spaceOfRow},` +
      ` spaceOfColumnSide: ${this.spaceOfColumnSide} offsetOfRowAndColumn:${this.offsetOfRowAndColumn}`);
  }

  protected initGridIconSize(): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    // 初始化iconSizeOfGrid
    if (scrWidth >= ScreenWidth.LARGE) {
      this.iconSizeOfGrid = IconSize.LARGE;
    } else if (scrWidth < ScreenWidth.MIDDLE) {
      this.iconSizeOfGrid = IconSize.SMALL;
    } else {
      this.iconSizeOfGrid = IconSize.MIDDLE;
    }
  }

  protected loadLauncherNewStyleConfig(): void {
    try {
      let cfgFile: string = ConfigParseUtil.getConfigSync(GRID_CONFIG_PATH);
      if (CheckEmptyUtils.checkStrIsEmpty(cfgFile)) {
        throw new Error('config json is empty!');
      }
      let cfgJson: ClassCfgJson = FileUtils.readJsonFile(cfgFile);
      let portraitLayout = cfgJson.portraitLayout;
      this.iconSizeOfGrid = portraitLayout?.iconSizeOfGrid ?? this.iconSizeOfGrid;
      this.columnNumOfGrid = portraitLayout?.columnNumOfGrid ?? this.columnNumOfGrid;
      this.rowNumOfGrid = portraitLayout?.rowNumOfGrid ?? this.rowNumOfGrid;
      this.mScreenWidth = portraitLayout?.screenWidth ? px2vp(portraitLayout?.screenWidth) : this.mScreenWidth;
      // 优先从配置文件读取行间距与图标大小，解决X5 7行布局横屏状态下滑动桌面时顶部截断问题
      this.configSpaceOfRow = cfgJson.defaultLayout?.spaceOfRow ?? 0;
      this.landIconSizeOfGrid = cfgJson.defaultLayout?.landIconSizeOfGrid ?? 0;
      Log.showInfo(TAG, 'read GridStyle config JSON success.config = ' + cfgFile);
    } catch (e) {
      Log.showError(TAG, 'read GridStyle config JSON fail ' + e);
    }
  }

  protected initRowAndColumnGap(): void {
    // 列间距X
    this.spaceOfColumn = (this.mScreenWidth + this.columnSpaceGapOfSide * StyleConstants.DEFAULT_2 -
      this.iconSizeOfGrid * this.columnNumOfGrid) / (this.columnNumOfGrid + 1);
    this.offsetOfRowAndColumn = super.calculateOffsetOfRowAndColumn();
    // 行间距Y
    this.spaceOfRow = super.adjustSpaceOfRowByScreenHeight(this.spaceOfColumn, this.offsetOfRowAndColumn);
  }
  protected initSpaceSideOfColumnAndScreen(offset: number): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    let allIconWidth = this.iconSizeOfGrid * this.columnNumOfGrid * StyleConstants.DEFAULT_2;
    let allColumnSpaceWidth = this.spaceOfColumn * (this.columnNumOfGrid * StyleConstants.DEFAULT_2 -
      StyleConstants.DEFAULT_2);
    // spaceX: 图标到屏幕侧边的空白距离
    let spaceX = (scrWidth * StyleConstants.DEFAULT_2 - allIconWidth - allColumnSpaceWidth - offset) /
      StyleConstants.DEFAULT_3;
    this.spaceOfScreenSide = (spaceX + offset) - this.spaceOfColumn;
    this.spaceOfColumnSide = spaceX - this.spaceOfColumn / StyleConstants.DEFAULT_2;
  }
  /**
   * calculate desktop
   */
  calculateDesktop(): CalculateDesktopRst {
    const mDesktopStatus: DesktopStatus = this.getDesktopStatus();
    let result: CalculateDesktopRst = {
      mMargin: mDesktopStatus.marginGrid,
      mItemPadding: mDesktopStatus.itemPadding,
      mColumnsGap: 0,
      mRowsGap: 0,
      mColumns: this.columnNumOfGrid,
      mRows: this.rowNumOfGrid,
      mDesktopMarginTop: mDesktopStatus.marginTop,
      mGridWidth: mDesktopStatus.realGridWidth,
      mGridHeight: mDesktopStatus.realGridHeight,
      mAppItemSize: mDesktopStatus.itemSize,
      mNameSize: mDesktopStatus.appTextSize,
      mNameHeight: mDesktopStatus.nameHeight,
      mNameWidth: mDesktopStatus.nameWidth,
      mIconNameMargin: mDesktopStatus.iconNameMargin,
      mIconNameMarginTop: mDesktopStatus.iconNameMarginTop,
      mIconSize: this.iconSizeOfGrid,
      mNameLines: mDesktopStatus.lines,
      mIconMarginHorizontal: mDesktopStatus.iconMarginHorizontal,
      mIconMarginVertical: 0,
      marginBottomOfIndicator: mDesktopStatus.marginBottomOfIndicator,
      mHeightOfIndicator: this.mBaseConfig.getIndicatorHeight(),
      mPaddingSideFold: mDesktopStatus.paddingSideFold
    };
    Log.showInfo(TAG, `desktop result: columns is ${result.mColumns}, rows is ${result.mRows}, iconSize is ${result.mIconSize}, gridWidth is ${result.mGridWidth}, gridHeight is ${result.mGridHeight}`);
    this.saveLayoutToPreferences();
    return result;
  }

  protected saveLayoutToPreferences(): void {
    // save cur layout to preferences
    if (this.mBaseConfig.getScreenWidth() !== 0 && this.mBaseConfig.getScreenHeight() !== 0) {
      try {
        preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'DESKTOP_LAYOUT_INFO').then((preference) => {
          preference.putSync('column', this.columnNumOfGrid);
          preference.putSync('row', this.rowNumOfGrid);
          Log.showInfo(TAG, `calculateDesktop column: ${this.columnNumOfGrid}, row: ${this.rowNumOfGrid}`);
          preference.flush().then((res) => {
            Log.showInfo(TAG, ` save layout to sp successs: ${res}`);
          }).catch((reject: Error) => {
            Log.showError(TAG, ` save layout to sp fail: ${reject}`);
          });
        }).catch((reject: Error) => {
          Log.showError(TAG, ` getPreferences fail: ${reject}`);
        });
      } catch (err) {
        Log.showError('saveLayoutToPreferences error! ', err);
      }
    }
  }

  protected getAboveSpace(realSpace: number, fixedPaddinOfStatus: number): number {
    return (StyleConstants.DEFAULT_2 * realSpace - StyleConstants.DEFAULT_3 * fixedPaddinOfStatus) /
      StyleConstants.DEFAULT_5;
  }

  protected getMarginBottomOfIndicator(belowSpace: number): number {
    let indicatorHeight = this.mBaseConfig.getIndicatorHeight();
    let margin = belowSpace / StyleConstants.DEFAULT_2 - indicatorHeight / StyleConstants.DEFAULT_2 +
      this.navigationOffset / StyleConstants.DEFAULT_2;
    if (DeviceHelper.isThreeFoldProduct()) {
      return margin - this.mLauncherLayoutStyleConfig.mDockPadding;
    }
    return margin;
  }

  protected getRealSpace(realGridHeight: number): number {
    let space = this.mBaseConfig.getWorkSpaceHeight() - this.mBaseConfig.getSysUITopHeight() -
      realGridHeight + this.mBaseConfig.getItemPadding() * StyleConstants.DEFAULT_2;
    if (DeviceHelper.isThreeFoldProduct()) {
      return space + this.mLauncherLayoutStyleConfig.mDockPadding;
    }
    return space;
  }

  /**
   * calculate desktop folder
   *
   * @param layoutInfo folder layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateFolder(layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateFolderRst {
    return FolderStyleCalculate.calculateFolderCommon(
      layoutInfo,
      isInPreviewMode,
      super.calculateFolder.bind(this),
      this.bindSheetGridPadding,
      this.bindSheetTitlePadding
    );
  }

  /**
   * calculate open folder
   *
   * @param openFolderConfig layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateOpenFolder(openFolderConfig: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateOpenFolderRst {
    Log.showInfo(TAG, 'calculateOpenFolder start');
    let iconSizeTemp: number = this.iconSizeOfGrid;
    let themeStyle = this.getThemeStyleInfo(isInPreviewMode);
    if (themeStyle && themeStyle.iconSizeScale) {
      iconSizeTemp += themeStyle.iconSizeScale;
    }
    if (!isInPreviewMode) {
      iconSizeTemp += this.getDesktopIconSize();
    }
    let row = openFolderConfig.row;
    let column = openFolderConfig.column;
    let gutter = this.mLauncherLayoutStyleConfig.mFolderOpenGutter;
    let padding = this.mLauncherLayoutStyleConfig.mFolderOpenPADDING;
    let margin = this.mLauncherLayoutStyleConfig.mFolderOpenMargin;
    let itemSize = iconSizeTemp + this.mBaseConfig.getNameHeight() + this.mBaseConfig.getIconNameMarginTop();
    let openFolderGridConfig = this.mBaseConfig.getFoldStatus() === 1 ? OpenFolderGridConfigExpand :
      OpenFolderGridConfig;
    let layoutWidth = iconSizeTemp * openFolderGridConfig.GRID_WIDTH;
    let layoutHeight = iconSizeTemp * openFolderGridConfig.GRID_HEIGHT;
    let colGap = column * iconSizeTemp + iconSizeTemp * openFolderGridConfig.COL_GAP * column - layoutWidth;
    let rowGap = row * iconSizeTemp + iconSizeTemp * openFolderGridConfig.ROW_GAP * row - layoutHeight;
    let tittleMargin = this.mLauncherLayoutStyleConfig.mFolderOpenTittleMargin ?? 0;
    let layoutItemSize = row === 0 ? 0 : (layoutHeight - rowGap * (row - 1)) / row;
    tittleMargin = this.mBaseConfig.getScreenHeight() / 2 - layoutHeight / 2 + (layoutItemSize - iconSizeTemp) -
      tittleMargin;
    let itemSpace = iconSizeTemp * openFolderGridConfig.PAGE_SPACE + colGap -
      openFolderGridConfig.COL_GAP * iconSizeTemp;
    let layoutSwiperHeight = row * itemSize + (row - 1) * gutter + StyleConstants.DEFAULT_2 * padding + itemSize;
    let title = (this.mBaseConfig.getScreenHeight() - layoutHeight) / StyleConstants.DEFAULT_2 - padding - margin;
    let mFolderIconRadius = this.calculateOpenFolderIconRadius(iconSizeTemp, isInPreviewMode);

    let openFolderStyleParam: OpenFolderStyleParam = FolderStyleCalculate.getDefaultOpenFolderStyleParam();
    openFolderStyleParam.iconSize = iconSizeTemp;
    openFolderStyleParam.defaultIconSize = this.iconSizeOfGrid;
    openFolderStyleParam.maxRows = openFolderConfig.row;
    openFolderStyleParam.maxColumns = openFolderConfig.column;
    openFolderStyleParam.sysTopHeight = this.mBaseConfig.getSysUITopHeight();
    openFolderStyleParam.iconHorizontalScale = FolderStyleConstants.FOLD_DEVICE_FOLDER_ICON_HORIZONTAL_SCALE;
    openFolderStyleParam.dragBroderIconHorizontalDistance =
      FolderStyleConstants.FOLD_DEVICE_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
    let openFolderStyle: OpenFolderStyle = FolderStyleCalculate.calculateOpenFolderStyle(openFolderStyleParam);
    let result: CalculateOpenFolderRst = {
      mOpenFolderGridRow: row,
      mOpenFolderGridColumn: column,
      mOpenFolderGridWidth: layoutWidth,
      mOpenFolderGridHeight: layoutHeight,
      mOpenFolderSwiperHeight: layoutSwiperHeight,
      mOpenFolderAddIconSize: iconSizeTemp,
      mOpenFolderIconSize: iconSizeTemp,
      mOpenFolderAppSize: iconSizeTemp,
      mOpenFolderAppNameSize: this.mBaseConfig.getDesktopNameSize(),
      mOpenFolderAppNameHeight: this.mBaseConfig.getNameHeight(),
      mOpenFolderGridGap: colGap,
      mOpenFolderGridPadding: padding,
      mFolderOpenMargin: margin,
      mFolderOpenTitle: title,
      mOpenFolderGridIconTopPadding: this.mBaseConfig.getDesktopIconMarginTop(),
      mFolderOpenItemSpace: itemSpace,
      mFolderOpenRowGap: rowGap,
      mFolderOpenTittleMargin: tittleMargin,
      mFolderIconRadius: mFolderIconRadius,
      mOpenFolderStyleParam: openFolderStyleParam,
      mOpenFolderStyle: openFolderStyle
    };
    return result;
  }

  private calculateOpenFolderIconRadius(iconSizeTemp: number, isInPreviewMode?: boolean): number {
    let desktopIconRadius = 0;
    if (isInPreviewMode) {
      desktopIconRadius = RadiusUtil.calculateRadius(iconSizeTemp, DesktopMode.PREVIEW_MODE);
    } else {
      desktopIconRadius = RadiusUtil.calculateRadius(iconSizeTemp);
    }
    let mFolderIconRadius = desktopIconRadius;
    if (mFolderIconRadius > iconSizeTemp / StyleConstants.DEFAULT_2) {
      mFolderIconRadius = iconSizeTemp / StyleConstants.DEFAULT_2;
    }
    return mFolderIconRadius;
  }

  /**
   * calculate dock
   */
  calculateDock(): CalculateDockRst {
    let result = super.calculateDock();
    result.mBackgroundColor = this.mLauncherLayoutStyleConfig.mFolderDockBackgroundColor;
    result.mBackdropBlur = this.mLauncherLayoutStyleConfig.mFolderDockBackdropBlur;
    result.mDockRadius = this.mLauncherLayoutStyleConfig.mFolderRadius;
    result.mResidentSplitLineWidth = StyleConstants.DEFAULT_2;
    result.mResidentSplitLineGap = (this.spaceOfColumn + this.spaceOfScreenSide - result.mResidentSplitLineWidth) /
    StyleConstants.DEFAULT_2 - (result.mDockPadding ?? 0);
    Log.showInfo(TAG, `phone dock layout: ${JSON.stringify(result)} this.mBaseConfig.getDockHeight() ${this.mBaseConfig.getDockHeight()}`);
    return result;
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    return super.calculateForm();
  }

  toString(): String {
    return TAG;
  }

  /**
   * 2*2不是正方形的卡片场景,计算卡片大小
   * @param addValue 竖直方向对齐超出补偿值
   * @returns CalculateFormRst 卡片布局结果计算对象
   */
  public calculateFormInNotSquare(addValue: number): CalculateFormRst {
    // 1 x 1  width * height
    let widthDimension0: number = this.iconSizeOfGrid + addValue;
    let heightDimension0: number = this.iconSizeOfGrid;
    // 2 x 1  width * height
    let widthDimension1: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfColumn + addValue;
    let heightDimension1: number = this.iconSizeOfGrid;
    // 2 x 2
    let widthDimension2: number = widthDimension1;
    let heightDimension2: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfRow;
    // 4 x 2
    let widthDimension3: number =
      (this.iconSizeOfGrid + this.spaceOfColumn) * StyleConstants.DEFAULT_2 + widthDimension1;
    let heightDimension3: number = heightDimension2;
    // 4 x 4
    let widthDimension4: number = widthDimension3;
    let heightDimension4: number =
      (this.iconSizeOfGrid + this.spaceOfRow) * StyleConstants.DEFAULT_2 + heightDimension2;
    // 6 x 4
    let widthDimension5: number = widthDimension3;
    let heightDimension5: number =
      (this.iconSizeOfGrid + this.spaceOfRow) * StyleConstants.DEFAULT_4 + heightDimension2;
    let result: CalculateFormRst = {
      mIconNameMargin: this.mBaseConfig.getDesktopIconNameMargin(),
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      widthDimension0: widthDimension0,
      heightDimension0: heightDimension0,
      widthDimension1: widthDimension1,
      heightDimension1: heightDimension1,
      widthDimension2: widthDimension2,
      heightDimension2: heightDimension2,
      widthDimension3: widthDimension3,
      heightDimension3: heightDimension3,
      widthDimension4: widthDimension4,
      heightDimension4: heightDimension4,
      widthDimension5: widthDimension5,
      heightDimension5: heightDimension5
    };
    return result;
  }

  protected getRealGridWidth(): number {
    return this.mBaseConfig.getScreenWidth() - this.spaceOfColumnSide -
      this.spaceOfScreenSide / StyleConstants.DEFAULT_2;
  }

  protected getPaddingSideFold(): number {
    return this.spaceOfColumnSide - this.spaceOfScreenSide / StyleConstants.DEFAULT_2;
  }

  /**
   * 获取grid跟单屏之间的margin
   * @returns
   */
  protected getMarginGrid(): number {
    return this.spaceOfScreenSide / StyleConstants.DEFAULT_2;
  }

  private getDesktopStatus(): DesktopStatus {
    let itemPadding = this.mBaseConfig.getItemPadding();
    // 更新折叠屏展开态竖屏，图标到屏幕两侧间距和左右屏间距margin与padding
    let realGridWidth = this.getRealGridWidth();
    let marginGrid = this.getMarginGrid();
    let paddingSideFold = this.getPaddingSideFold();
    // 更新网格宽度
    this.mBaseConfig.setGridRealWidth(realGridWidth);
    let lines = this.mLauncherLayoutStyleConfig.mNameLines;
    let nameHeight = this.mBaseConfig.getNameHeight();
    let itemSize = this.mBaseConfig.getItemSize() + (lines - 1) * nameHeight;
    // 更新网格高度
    // 状态栏中，文字距离状态栏底部的padding，预估值12vp
    let fixedPaddinOfStatus = this.mLauncherLayoutStyleConfig.mSystemUIBottomPadding;
    // 网格布局的全高度，单个网格高度为：行间距+图标高度
    let realGridHeight = (this.iconSizeOfGrid + this.spaceOfRow) * this.rowNumOfGrid;
    this.mBaseConfig.setGridRealHeight(realGridHeight);
    // WorkSpace的高度为：全屏高度-底部SmartDock高度
    // realSpace 为上下空白区域区域之和，上空白区域从状态栏底部到第一行网格上边缘，下空白区域为网格底部到SmartDock背板上边缘
    let realSpace = this.getRealSpace(realGridHeight);
    /*
      上下留白的计算公式
      aboveSpace + belowSpace = realSpace;
      (aboveSpace + padding) : belowSpace = 2 : 3;
     */
    let aboveSpace = this.getAboveSpace(realSpace, fixedPaddinOfStatus);
    let belowSpace = realSpace - aboveSpace;
    Log.showInfo(TAG, `build realSpace: ${realSpace} aboveSpace:${aboveSpace} fixedPaddinOfStatus :${fixedPaddinOfStatus} belowSpace: ${belowSpace} dockHeight:${this.mBaseConfig.getDockHeight()} realGridHeight :${realGridHeight}` +
      ` this.mBaseConfig.getWorkSpaceHeight(): ${this.mBaseConfig.getWorkSpaceHeight()} screenHeight: ${this.mBaseConfig.getScreenHeight()}`);
    // marginTop为屏幕顶部边缘到grid的顶部距离，即为状态栏高度加aboveSpace
    let marginTop = this.mBaseConfig.getSysUITopHeight() + aboveSpace - itemPadding;
    // grid底部距离dock图标顶部的距离 的一半，再减去dock图标顶部距离dock组件顶部的距离，再减去导航条高度的一半，再整体上移1vp，即为导航条距离swiper组件底部的距离
    let marginBottomOfIndicator = this.getMarginBottomOfIndicator(belowSpace);
    // set desktop icon
    let appTextSize = this.mLauncherLayoutStyleConfig.mNameSize;
    let nameWidth = this.mLauncherLayoutStyleConfig.mNameWidth;
    let iconNameMargin = this.mLauncherLayoutStyleConfig.mIconNameGap;
    let iconNameMarginTop = this.mBaseConfig.getIconNameMarginTop();
    let iconHeight = itemSize - nameHeight * lines - iconNameMarginTop;
    let iconMarginHorizontal = (itemSize - iconHeight) / StyleConstants.DEFAULT_2;
    this.updateGrid(this.rowNumOfGrid, this.columnNumOfGrid);
    return { itemPadding, realGridWidth, marginGrid, paddingSideFold, lines, nameHeight, itemSize, realGridHeight,
      marginTop, marginBottomOfIndicator, appTextSize, nameWidth, iconNameMargin, iconNameMarginTop,
      iconMarginHorizontal };
  }
}

/**
 * 文件夹展开态布局配置-折叠(与图标大小的比例)
 */
enum OpenFolderGridConfig {
  COL_GAP = 8 / 15,
  ROW_GAP = 11 / 15,
  GRID_WIDTH = 276 / 60,
  GRID_HEIGHT = 408 / 60,
  PAGE_SPACE = 3 / 5
}

/**
 * 文件夹展开态布局配置-展开(与图标大小的比例)
 */
enum OpenFolderGridConfigExpand {
  COL_GAP = 13 / 15,
  ROW_GAP = 11 / 15,
  GRID_WIDTH = 428 / 60,
  GRID_HEIGHT = 408 / 60,
  PAGE_SPACE = 4 / 3
}

/**
 * 对应配置文件类型
 */
export interface ClassCfgJson {
  portraitLayout: PortraitLayout;

  defaultLayout: DefaultLayout;
};

export interface PortraitLayout {
  iconSizeOfGrid: number;

  columnNumOfGrid: number;

  rowNumOfGrid: number;

  screenWidth: number;
}

export interface DefaultLayout {
  spaceOfRow: number;

  landIconSizeOfGrid: number;

  spaceOfIconScreen?: number

  maxDisplayCount?: number
}
