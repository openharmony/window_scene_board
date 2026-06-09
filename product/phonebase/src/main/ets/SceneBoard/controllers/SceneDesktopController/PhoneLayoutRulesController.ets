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
  BaseConfig,
  CalculateDesktopRst,
  CalculateDockRst,
  CalculateFolderRst,
  CalculateFormRst,
  CalculateOpenFolderRst,
  CommonConstants,
  FolderLayoutStruct,
  FullScreenCardUtil,
  OpenFolderStyle,
  OpenFolderStyleParam,
  ThemeStyleInfo
} from '@ohos/launchercommon';
import {
  ConfigParseUtil,
  DesktopMode,
  IconCommonUtil,
  LayoutRulesController,
  RadiusUtil,
  SettingsModel,
  StyleConstants,
  ThemeStyleManager,
  ThemeStylePreviewManager
} from '@ohos/launchercommon';
import { CheckEmptyUtils, FileUtils, LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { SCBScreenSession } from '@ohos/windowscene';
import preferences from '@ohos.data.preferences';
import type ctx from '@ohos.app.ability.common';
import display from '@ohos.display';
import { FolderStyleCalculate } from '@ohos/bigfolder/src/main/ets/default/viewmodel/FolderStyleCalculate';

const TAG = 'PhoneLayoutRulesControllers';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const GRID_CONFIG_PATH = 'etc/SceneBoard/launcher_layout_rules.json';
const WIDTH_SCALE_FACTOR = 9;
/** 纵向间隙比*/
const PORTRAIT_GAP_RATIO: number = 0.04;

/**
 * Layout rules controller of phone
 * 手机端布局规则控制器，适用于桌面新布局
 *
 */
export class PhoneLayoutRulesController extends LayoutRulesController {
  public static singleName: string = 'PhoneLayoutRulesController';

  /** 图标大小，从本地配置文件中读取 */
  protected iconSizeOfGrid: number = 0;

  /** 两侧列间距的差值，从本地配置文件中读取 */
  protected columnSpaceGapOfSide: number = 0;

  /** 行间距与列间距的差值，从本地配置文件中读取 */
  protected offsetOfRowAndColumn: number = 0;

  /** 网格列数，从本地配置文件中读取 */
  protected columnNumOfGrid: number = 0;

  /** 网格行数，从本地配置文件中读取 */
  protected rowNumOfGrid: number = 0;

  /** 导航点偏移量，从本地配置文件中读取 */
  protected navigationOffset: number = 0;

  /** 列间距，配置文件有就使用配置文件得到，否则通过计算得到*/
  protected spaceOfColumn: number = 0;

  /** 行间距，通过计算得到*/
  protected spaceOfRow: number = 0;

  /** 列两侧间距，通过计算得到，列间距从配置文件得到时，该值可以调整列两侧间距保证列间距设置成功*/
  protected spaceOfColumnSide: number = 0;

  protected mScreenWidth: number = 0;

  /** 针对VDE, 标识列间距是否从配置文件中获取*/
  protected isSpaceOfColumnFromConfig: boolean = false;

  /**
   * Default bindSheet grid padding size in landscape mode
   */
  protected bindSheetGridPadding: number = 13;

  /**
   * Default bindSheet title padding size in landscape mode
   */
  protected bindSheetTitlePadding: number = 3;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): PhoneLayoutRulesController {
    let instance = singleManager.get<PhoneLayoutRulesController>(PhoneLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    log.showInfo(`${PhoneLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
    // 优先计算系统配置
    this.initProductConfig();
    // 产品配置如果存在，则覆盖系统配置
    this.loadLauncherNewStyleConfig();
    this.setDockIconSize();
    this.calculateProductConfig();
  }

  protected setDockIconSize(): void {}

  private initProductConfig(): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    let scrHeight = this.mBaseConfig.getScreenHeight();
    // 初始化iconSizeOfGrid
    if (scrWidth >= ScreenWidth.LARGE) {
      this.iconSizeOfGrid = IconSize.LARGE;
    } else if (scrWidth < ScreenWidth.MIDDLE) {
      this.iconSizeOfGrid = IconSize.SMALL;
    } else {
      this.iconSizeOfGrid = IconSize.MIDDLE;
    }
    if (scrHeight !== 0) {
      let radio = scrHeight / scrWidth;
      if (radio >= ScreenRatioRange.LEFT_DIVIDE && radio <= ScreenRatioRange.RIGHT_DIVIDE) {
        // 初始化两侧列间距差值
        this.offsetOfRowAndColumn = DefaultGridProp.BIG_OFFSET_OF_ROA_AND_COLUMN;
      } else {
        this.offsetOfRowAndColumn = DefaultGridProp.SMALL_OFFSET_OF_ROW_AND_COLUMN;
      }
      if (radio > ScreenRatioRange.LONG_SCREEN_DIVIDE || this.getIsFoldable()) {
        this.rowNumOfGrid = DefaultGridProp.LONG_SCREEN_ROW_NUM_OF_GRID;
      } else {
        this.rowNumOfGrid = DefaultGridProp.ORDINARY_SCREEN_ROW_NUM_OF_GRID;
      }
    } else {
      this.offsetOfRowAndColumn = DefaultGridProp.SMALL_OFFSET_OF_ROW_AND_COLUMN;
      this.rowNumOfGrid = DefaultGridProp.ORDINARY_SCREEN_ROW_NUM_OF_GRID;
    }
    if (DeviceHelper.isUltraScreenProduct()) {
      this.rowNumOfGrid = DefaultGridProp.ORDINARY_SCREEN_ROW_NUM_OF_GRID;
    }
    this.columnNumOfGrid = DefaultGridProp.COLUMN_NUM_OF_GRID;
    // 初始化导航点偏移量
    this.navigationOffset = DefaultGridProp.NAVIGATION_OFFSET;
    //初始化两侧列间距补偿值
    this.columnSpaceGapOfSide = DefaultGridProp.COLUMN_SPACE_GAP_OF_SIDE;
    log.showInfo(`iconSize: ${this.iconSizeOfGrid}, rowNumOfGrid ${this.rowNumOfGrid}, scrHeight: ${scrHeight}, scrWidth :${scrWidth}`);
  }

  private getIsFoldable(): boolean {
    let isFoldable: boolean = false;
    try {
      isFoldable = display.isFoldable();
    } catch (error) {
      log.showError('getIsFoldable failed', error);
    }
    log.showInfo(`isFoldable is ${isFoldable}`);
    return isFoldable;
  }

  /**
   * 列间距计算规则：X = (ScreenWidth + 8vp * 2 - iconSize * cellXNum) / (cellXNum + 1)
   * 行间距计算规则：X + offset
   * 比例为：18.7:9 和 20.9:9  offset = 4
   * 比例为：19.5:9 和 19.9:9  offset = 8
   */
  calculateProductConfig(): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    //如果配置文件没配置，就计算得到列间距
    if (!this.isSpaceOfColumnFromConfig) {
      this.spaceOfColumn =
        (scrWidth + this.columnSpaceGapOfSide * StyleConstants.DEFAULT_2 - this.iconSizeOfGrid * this.columnNumOfGrid) /
        (this.columnNumOfGrid + 1);
      this.spaceOfColumnSide = this.spaceOfColumn / StyleConstants.DEFAULT_2 - this.columnSpaceGapOfSide;
    } else {
      this.spaceOfColumnSide =
        (this.mBaseConfig.getScreenWidth() - this.columnNumOfGrid * (this.iconSizeOfGrid + this.spaceOfColumn)) /
        StyleConstants.DEFAULT_2;
    }
    this.offsetOfRowAndColumn = this.calculateOffsetOfRowAndColumn();
    this.spaceOfRow = this.adjustSpaceOfRowByScreenHeight(this.spaceOfColumn, this.offsetOfRowAndColumn);
    log.showInfo(`spaceOfColumn: ${this.spaceOfColumn}, spaceOfRow: ${this.spaceOfRow}, spaceOfColumnSide: ${this.spaceOfColumnSide},
     offsetOfRowAndColumn :${this.offsetOfRowAndColumn}`);
  }

  /**
   * 人因间隙比差值
   *
   * @returns 行间距调整偏差值
   */
  public calculateOffsetOfRowAndColumn(): number {
    let result: number = (this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfColumn) *
      PORTRAIT_GAP_RATIO * StyleConstants.DEFAULT_2;
    return result;
  }

  /**
   * 行间距调整
   *
   * @param columSpace 列间距
   * @package offset 为保证2*2方形补充的偏移量
   * @returns 调整后的行间距
   */
  public adjustSpaceOfRowByScreenHeight(columSpace: number, offset: number): number {
    if (desktopUtil.isFold() && this.rowNumOfGrid === DefaultGridProp.LONG_SCREEN_ROW_NUM_OF_GRID) {
      return SpaceOfRowSize.SMALL_SIZE;
    }
    if (columSpace >= SpaceOfRowSize.MAX_SIZE) {
      return columSpace;
    }
    let extendColumSpace = columSpace + offset;
    let adjustSpaceOfRow: number = extendColumSpace;
    if (extendColumSpace < SpaceOfRowSize.SMALL_SIZE) {
      log.showInfo('the spaceOfRow is abnormal');
      adjustSpaceOfRow = extendColumSpace;
    } else if (extendColumSpace >= SpaceOfRowSize.SMALL_SIZE && extendColumSpace < SpaceOfRowSize.MEDIUM_SIZE) {
      adjustSpaceOfRow = SpaceOfRowSize.SMALL_SIZE;
    } else if (extendColumSpace >= SpaceOfRowSize.MEDIUM_SIZE && extendColumSpace < SpaceOfRowSize.LARGE_SIZE) {
      adjustSpaceOfRow = SpaceOfRowSize.MEDIUM_SIZE;
    } else if (extendColumSpace >= SpaceOfRowSize.LARGE_SIZE && extendColumSpace < SpaceOfRowSize.MAX_SIZE) {
      adjustSpaceOfRow = SpaceOfRowSize.LARGE_SIZE;
    } else {
      adjustSpaceOfRow = SpaceOfRowSize.MAX_SIZE;
    }
    return adjustSpaceOfRow;
  }

  protected loadLauncherNewStyleConfig(): void {
    try {
      let cfgFile: string = ConfigParseUtil.getConfigSync(GRID_CONFIG_PATH);
      if (CheckEmptyUtils.checkStrIsEmpty(cfgFile)) {
        throw new Error('config json is empty!');
      }
      let cfgJson: CfgJson = FileUtils.readJsonFile(cfgFile);
      let defaultLayout = cfgJson.defaultLayout;
      let newLayout = cfgJson.newLayout;
      if (this.isUseNewLayoutConfig(newLayout)) {
        this.loadLayoutFromConfig(newLayout);
      } else if (defaultLayout) {
        this.loadLayoutFromConfig(defaultLayout);
      }
      log.showInfo('read GridStyle config JSON success.config = ' + cfgFile);
    } catch (e) {
      log.showError('read GridStyle config JSON fail ' + e);
    }
  }

  protected isUseNewLayoutConfig(newLayout: DefaultLayout): boolean {
    if (newLayout === null || newLayout === undefined) {
      return false;
    }
    if (newLayout.rowNumOfGrid === null || newLayout.rowNumOfGrid === undefined) {
      log.showInfo('newLayout.rowNumOfGrid not config');
      return false;
    }
    let context: ctx.ServiceExtensionContext =
      GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
    let desktopLayoutPreferences = preferences.getPreferencesSync(context, { name: 'DESKTOP_LAYOUT_INFO' });
    let row: number = desktopLayoutPreferences.getSync('row', 0) as number;
    let column: number = desktopLayoutPreferences.getSync('column', 0) as number;
    log.showInfo(`get grid config from preferences, row: ${row}, column: ${column}`);
    // 新机场景和旧机宫格行列与配置相同时，使用新配置
    return row === 0 || (row === newLayout.rowNumOfGrid && column === newLayout.columnNumOfGrid);
  }

  protected loadLayoutFromConfig(layout: DefaultLayout): void {
    this.iconSizeOfGrid = layout?.iconSizeOfGrid ?? this.iconSizeOfGrid;
    this.columnNumOfGrid = layout?.columnNumOfGrid ?? this.columnNumOfGrid;
    this.rowNumOfGrid = layout?.rowNumOfGrid ?? this.rowNumOfGrid;
    //列间距优先从配置文件得到
    this.spaceOfColumn = layout?.spaceOfColumn ? layout?.spaceOfColumn : -1;
    if (this.spaceOfColumn !== -1) {
      this.isSpaceOfColumnFromConfig = true;
    } else {
      log.showWarn('space of column is empty');
      this.spaceOfColumn = 0;
    }
  }

  /**
   * calculate desktop
   */
  calculateDesktop(): CalculateDesktopRst {
    let itemPadding = this.mBaseConfig.getItemPadding();
    let realGridWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * this.spaceOfColumnSide;
    // 更新网格宽度
    this.mBaseConfig.setGridRealWidth(realGridWidth);
    let lines = this.mLauncherLayoutStyleConfig.mNameLines;
    let nameHeight = this.mBaseConfig.getNameHeight();
    let itemSize = this.mBaseConfig.getItemSize() + (lines - 1) * nameHeight;
    let realGridHeight = (this.iconSizeOfGrid + this.spaceOfRow) * this.rowNumOfGrid;
    // 更新网格高度
    let fixedPaddinOfStatus = this.mLauncherLayoutStyleConfig.mSystemUIBottomPadding;
    this.mBaseConfig.setGridRealHeight(realGridHeight);
    let realSpace = this.mBaseConfig.getWorkSpaceHeight() - this.mBaseConfig.getSysUITopHeight() - realGridHeight +
      itemPadding * StyleConstants.DEFAULT_2 + this.mLauncherLayoutStyleConfig.mDockPadding;

    //上下留白的计算公式 aboveSpace + belowSpace = realSpace; (aboveSpace + padding) : belowSpace = 2 : 3;
    let aboveSpace = (StyleConstants.DEFAULT_2 * realSpace - StyleConstants.DEFAULT_3 * fixedPaddinOfStatus) /
      StyleConstants.DEFAULT_5;
    let belowSpace = realSpace - aboveSpace;
    // 上方状态栏高度 + 整体空白区域的2/5 - griditem上方的padding值为实际grid的marginTop
    let marginTop = this.mBaseConfig.getSysUITopHeight() + aboveSpace - itemPadding;

    // grid底部距离dock图标顶部的距离 的一半，再减去dock图标顶部距离dock组件顶部的距离，再减去导航条高度的一半，再整体上移1vp，即为导航条距离swiper组件底部的距离
    let indicatorHeight = this.mBaseConfig.getIndicatorHeight();
    let marginBottomOfIndicator = belowSpace / StyleConstants.DEFAULT_2 - this.mLauncherLayoutStyleConfig.mDockPadding -
      indicatorHeight / StyleConstants.DEFAULT_2 + this.navigationOffset / StyleConstants.DEFAULT_2;

    // set desktop icon
    let appTextSize = this.mLauncherLayoutStyleConfig.mNameSize;
    let nameWidth = this.mLauncherLayoutStyleConfig.mNameWidth;
    let iconNameMargin = this.mLauncherLayoutStyleConfig.mIconNameGap;
    let iconNameMarginTop = this.mBaseConfig.getIconNameMarginTop();
    let iconHeight = itemSize - nameHeight * lines - iconNameMarginTop;
    let iconMarginHorizontal = (itemSize - iconHeight) / StyleConstants.DEFAULT_2;
    this.updateGrid(this.rowNumOfGrid, this.columnNumOfGrid);

    let result: CalculateDesktopRst = {
      mMargin: this.spaceOfColumnSide,
      mItemPadding: itemPadding,
      mColumnsGap: 0,
      mRowsGap: 0,
      mColumns: this.columnNumOfGrid,
      mRows: this.rowNumOfGrid,
      mDesktopMarginTop: marginTop,
      mGridWidth: realGridWidth,
      mGridHeight: realGridHeight,
      mAppItemSize: itemSize,
      mNameSize: appTextSize,
      mNameHeight: nameHeight,
      mNameWidth: nameWidth,
      mIconNameMargin: iconNameMargin,
      mIconNameMarginTop: iconNameMarginTop,
      mIconSize: this.iconSizeOfGrid,
      mNameLines: lines,
      mIconMarginHorizontal: iconMarginHorizontal,
      mIconMarginVertical: 0,
      marginBottomOfIndicator: marginBottomOfIndicator,
      mHeightOfIndicator: indicatorHeight
    };
    log.showInfo(`desktop result: columns is ${result.mColumns}, rows is ${result.mRows}, iconSize is ${result.mIconSize}, gridWidth is ${result.mGridWidth}, gridHeight is ${result.mGridHeight}`);
    this.saveLayoutToPreferences();
    return result;
  }

  protected saveLayoutToPreferences(): void {
    // save cur layout to preferences
    if (this.mBaseConfig.getScreenWidth() === 0 || this.mBaseConfig.getScreenHeight() === 0) {
      return;
    }
    try {
      preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'DESKTOP_LAYOUT_INFO').then((preference) => {
        preference.putSync('column', this.columnNumOfGrid);
        preference.putSync('row', this.rowNumOfGrid);
        log.showInfo(`calculateDesktop column: ${this.columnNumOfGrid}, row: ${this.rowNumOfGrid}`);
        preference.flush().then((res) => {
          log.showInfo(` save layout to sp successs: ${res}`);
        }).catch((reject: Error) => {
          log.showInfo(` save layout to sp fail: ${reject}`);
        });
      }).catch((error: Error) => {
        log.showError(`getPreferences inner error:${error}`);
      });
    } catch (error) {
      log.showError('getPreferences outer error', error);
    }
  }

  /**
   * calculate dock
   */
  calculateDock(): CalculateDockRst {
    log.showInfo('calculateDock start');
    let margin = this.mLauncherLayoutStyleConfig.mDockSaveMargin;
    let dockGap = this.mLauncherLayoutStyleConfig.mDockGutter;
    let iconSize = this.iconSizeOfGrid;
    let listItemGap = this.spaceOfColumn;
    let marginBottom = this.mLauncherLayoutStyleConfig.mDockMarginBottomHideBar;
    if (!this.mBaseConfig.getNavigationBarStatus()) {
      marginBottom = this.mLauncherLayoutStyleConfig.mDockMarginBottom;
    }
    let maxDockNum = 4;
    let maxNum = maxDockNum;
    let dockPadding = this.mLauncherLayoutStyleConfig.mDockPadding;

    log.showInfo(`calculateDock DockHeight: ${this.mBaseConfig.getDockHeight()}, mSysUIBottomHeight: ${this.mBaseConfig.getSysUIBottomHeight()}`);
    let result: CalculateDockRst = {
      mDockGap: dockGap,
      mIconSize: iconSize,
      mBackgroundColor: this.mLauncherLayoutStyleConfig.mBackgroundColor,
      mBackdropBlur: this.mLauncherLayoutStyleConfig.mBackdropBlur,
      mBackSaturation: this.mLauncherLayoutStyleConfig.mBackSaturation,
      mListItemWidth: iconSize,
      mListItemHeight: iconSize,
      mListItemGap: listItemGap,
      mDockPadding: dockPadding,
      mMaxNum: maxNum,
      mMaxRecentNum: 0,
      mMaxDockNum: maxDockNum,
      mMinResidentNum: this.mLauncherLayoutStyleConfig.mMinResidentNumber,
      mDockHeight: iconSize + StyleConstants.DEFAULT_2 * dockPadding,
      mMarginBottom: marginBottom,
      mRecentArrowWidth: this.mLauncherLayoutStyleConfig.mDockRecentArrowWidth,
      mRecentArrowHeight: this.mLauncherLayoutStyleConfig.mDockRecentArrowHeight,
      mRecentArrowPadding: this.mLauncherLayoutStyleConfig.mDockRecentArrowPadding,
      mRecentArrowGap: this.mLauncherLayoutStyleConfig.mDockRecentArrowGap
    };
    log.showInfo(`phone dock layout: ${JSON.stringify(result)} this.mBaseConfig.getDockHeight() ${this.mBaseConfig.getDockHeight()}`);
    return result;
  }

  /**
   * calculate desktop folder
   *
   * @param layoutInfo folder layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateFolder(layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateFolderRst {
    let numberOfIconsLine = StyleConstants.DEFAULT_2;
    let bigFolderSize = this.iconSizeOfGrid * numberOfIconsLine + this.spaceOfRow;
    const calculateFolder = (layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean) =>
    this.calculateFolderByFolderSize(layoutInfo, bigFolderSize, isInPreviewMode);

    return FolderStyleCalculate.calculateFolderCommon(
      layoutInfo,
      isInPreviewMode,
      calculateFolder,
      this.bindSheetGridPadding,
      this.bindSheetTitlePadding
    );
  }

  private isSmallFolder(layoutInfo: FolderLayoutStruct): boolean {
    if (layoutInfo.area) {
      return layoutInfo.area[0] === 1 && layoutInfo.area[1] === 1;
    }
    return false;
  }

  getThemeStyleInfo(isInPreviewMode?: boolean): ThemeStyleInfo {
    let themeStyle = isInPreviewMode ? ThemeStylePreviewManager.getInstance().getThemeStyle() :
      ThemeStyleManager.getInstance().getThemeStyle();
    if (!isInPreviewMode && (!themeStyle ||
      (themeStyle.iconSizeScale === undefined && themeStyle.radiusSizeScale === undefined))) {
      ThemeStyleManager.getInstance().loadThemeStyle();
      themeStyle = ThemeStyleManager.getInstance().getThemeStyle();
    }
    return themeStyle;
  }

  getDesktopIconSize(): number {
    let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 0;
    if (IconCommonUtil.isValidIconSizeChange(desktopIconChangeSize)) {
      return desktopIconChangeSize;
    } else {
      return 0;
    }
  }

  /**
   * calculate open folder
   *
   * @param openFolderConfig layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateOpenFolder(openFolderConfig: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateOpenFolderRst {
    log.showInfo('calculateOpenFolder start');
    let iconSizeTemp: number = this.iconSizeOfGrid;
    let themeStyle = this.getThemeStyleInfo(isInPreviewMode);
    if (themeStyle && themeStyle.iconSizeScale) {
      iconSizeTemp += themeStyle.iconSizeScale;
    }
    let secureSettingIconSize = this.getDesktopIconSize();
    if (!isInPreviewMode) {
      iconSizeTemp += secureSettingIconSize;
    }
    let row = openFolderConfig.row;
    let column = openFolderConfig.column;
    let gutter = this.mLauncherLayoutStyleConfig.mFolderOpenGutter;
    let padding = this.mLauncherLayoutStyleConfig.mFolderOpenPADDING;
    let margin = this.mLauncherLayoutStyleConfig.mFolderOpenMargin;
    let itemSize = iconSizeTemp + this.mBaseConfig.getNameHeight() + this.mBaseConfig.getIconNameMarginTop();
    let layoutWidth = iconSizeTemp * OpenFolderGridConfig.GRID_WIDTH;
    let layoutHeight = iconSizeTemp * OpenFolderGridConfig.GRID_HEIGHT;
    let colGap = column * iconSizeTemp + iconSizeTemp * OpenFolderGridConfig.COL_GAP * column - layoutWidth;
    let rowGap = row * iconSizeTemp + iconSizeTemp * OpenFolderGridConfig.ROW_GAP * row - layoutHeight;
    let tittleMargin = this.mLauncherLayoutStyleConfig.mFolderOpenTittleMargin ?? 0;
    let layoutItemSize = row === 0 ? 0 : (layoutHeight - rowGap * (row - 1)) / row;
    tittleMargin = this.mBaseConfig.getScreenHeight() / 2 - layoutHeight / 2 + (layoutItemSize - iconSizeTemp) -
      tittleMargin;
    let itemSpace = iconSizeTemp * OpenFolderGridConfig.PAGE_SPACE + colGap - OpenFolderGridConfig.COL_GAP *
      iconSizeTemp;
    let layoutSwiperHeight = row * itemSize + (row - 1) * gutter + StyleConstants.DEFAULT_2 * padding + itemSize;
    let title = (this.mBaseConfig.getScreenHeight() - layoutHeight) / StyleConstants.DEFAULT_2 - padding - margin;
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
    let openFolderStyleParam: OpenFolderStyleParam = FolderStyleCalculate.getDefaultOpenFolderStyleParam();
    openFolderStyleParam.iconSize = iconSizeTemp;
    openFolderStyleParam.defaultIconSize = this.iconSizeOfGrid;
    openFolderStyleParam.maxRows = openFolderConfig.row;
    openFolderStyleParam.maxColumns = openFolderConfig.column;
    openFolderStyleParam.sysTopHeight = this.mBaseConfig.getSysUITopHeight();
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
      mOpenFolderStyle: openFolderStyle,
    };
    return result;
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    log.showInfo('calculateForm phone start');
    // 1 x 1  width * height
    let widthDimension0: number = this.iconSizeOfGrid;
    let heightDimension0: number = this.iconSizeOfGrid;
    // 2 x 1  width * height
    let widthDimension1: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfRow;
    let heightDimension1: number = this.iconSizeOfGrid;
    // 2 x 2
    let widthDimension2: number = widthDimension1;
    let heightDimension2: number = widthDimension1;
    // 4 x 2
    let widthDimension3: number = (this.iconSizeOfGrid + this.spaceOfColumn) * StyleConstants.DEFAULT_2 +
      widthDimension1;
    let heightDimension3: number = heightDimension2;
    // 4 x 4
    let widthDimension4: number = widthDimension3;
    let heightDimension4: number = (this.iconSizeOfGrid + this.spaceOfRow) * StyleConstants.DEFAULT_2 + widthDimension1;
    // 6 x 4
    let widthDimension5: number = widthDimension3;
    let heightDimension5: number = FullScreenCardUtil.getInstance().getHeightDimension(this.iconSizeOfGrid,
      this.spaceOfRow, widthDimension1);
    let result: CalculateFormRst = {
      mIconNameMargin: this.mBaseConfig.getDesktopIconNameMargin(),
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      widthDimension0: widthDimension0,
      heightDimension0: heightDimension0,
      widthDimension1: widthDimension1,
      heightDimension1: heightDimension1,
      widthDimension2: widthDimension2,
      heightDimension2: heightDimension2,
      widthDimension4: widthDimension4,
      heightDimension4: heightDimension4,
      widthDimension3: widthDimension3,
      heightDimension3: heightDimension3,
      widthDimension5: widthDimension5,
      heightDimension5: heightDimension5
    };
    return result;
  }

  getSpaceOfRow(): number {
    return this.spaceOfRow;
  }

  getSpaceOfColumn(): number {
    return this.spaceOfColumn;
  }

  toString(): String {
    return TAG;
  }

  /**
   * 根据folderSize大小计算文件夹折叠态布局,
   * 不同形态下FolderSize的对齐规格不一致
   *
   * @param layoutInfo folder layoutInfo
   * @param bigFolderSize 大文件夹基准对齐长度
   * @param isInPreviewMode boolean
   */
  protected calculateFolderByFolderSize(layoutInfo: FolderLayoutStruct, bigFolderSize: number,
    isInPreviewMode?: boolean): CalculateFolderRst {
    let folderSize: number = StyleConstants.DEFAULT_0;
    let folderGutter: number = StyleConstants.DEFAULT_0;
    let folderMargin: number = StyleConstants.DEFAULT_0;
    let iconSizeTemp: number = this.iconSizeOfGrid;
    let themeStyle = this.getThemeStyleInfo(isInPreviewMode);
    if (themeStyle && themeStyle.iconSizeScale) {
      iconSizeTemp += themeStyle.iconSizeScale;
    }
    let secureSettingIconSize = this.getDesktopIconSize();
    if (!isInPreviewMode) {
      iconSizeTemp += secureSettingIconSize;
    }
    if (this.isSmallFolder(layoutInfo)) {
      folderSize = iconSizeTemp;
      folderGutter = this.mLauncherLayoutStyleConfig.mSmallFolderGutterRatio * folderSize;
      folderMargin = this.mLauncherLayoutStyleConfig.mSmallFolderMarginRatio * folderSize;
    } else {
      let itemSize = this.mLauncherLayoutStyleConfig.mAppItemSize;
      let gridRow = SettingsModel.getInstance().getGridConfig().row;
      log.showInfo(`calculateFolder itemSize ${itemSize} gridRow ${gridRow}`);
      folderSize = bigFolderSize;
      if (themeStyle && themeStyle.iconSizeScale) {
        folderSize += themeStyle.iconSizeScale;
      }
      if (!isInPreviewMode) {
        folderSize += secureSettingIconSize;
      }
      folderGutter = this.mLauncherLayoutStyleConfig.mFolderGutterRatio * folderSize;
      folderMargin = this.mLauncherLayoutStyleConfig.mFolderMarginRatio * folderSize;
    }
    let column = layoutInfo.column;
    let iconSize = (folderSize - folderGutter * StyleConstants.DEFAULT_2 - folderMargin * StyleConstants.DEFAULT_2) /
      column;
    log.showInfo(`calculateFolder folderSize: ${folderSize}, folderGutter: ${folderGutter},
      folderMargin: ${folderMargin}, iconSize: ${iconSize}`);
    let nameHeight = this.mBaseConfig.getNameHeight();
    let nameLines = this.mBaseConfig.getDesktopNameLines();
    let iconNameMargin = this.mBaseConfig.getDesktopIconNameMargin();
    let iconNameMarginTop = this.mBaseConfig.getIconNameMarginTop();
    let folderItemSize = folderSize + nameHeight * nameLines + iconNameMarginTop;
    let desktopIconRadius = 0;
    if (isInPreviewMode) {
      desktopIconRadius = RadiusUtil.calculateRadius(iconSizeTemp, DesktopMode.PREVIEW_MODE);
    } else {
      desktopIconRadius = RadiusUtil.calculateRadius(iconSizeTemp);
    }
    //小文件夹圆角 = 桌面显示圆角
    let mSmallFolderRadius = desktopIconRadius;
    //文件夹图标圆角 桌面显示圆角*文件夹内图标缩小比例
    let mFolderIconRadius = desktopIconRadius * (iconSize / iconSizeTemp);
    //2*2大文件夹圆角 大文件夹图标圆角+ 大文件夹内边距
    let mFolderRadius = mFolderIconRadius === 0 ? 0 : (mFolderIconRadius + folderMargin);
    //1*2 2*1 大文件夹圆角 桌面显示圆角与2*2大文件夹圆角的平均值
    let mFolderRadius1x2 = (desktopIconRadius + mFolderRadius) / 2;
    let result: CalculateFolderRst = {
      mGridSize: folderSize,
      mGridItemSize: folderItemSize,
      mGridMargin: folderMargin,
      mNameLines: nameLines,
      mNameHeight: nameHeight,
      mIconNameMargin: iconNameMargin,
      mIconNameMarginTop: iconNameMarginTop,
      mFolderAppSize: iconSize,
      mFolderGridGap: folderGutter,
      mFolderRadius: mFolderRadius,
      mSmallFolderRadius: mSmallFolderRadius,
      mFolderIconRadius: mFolderIconRadius,
      mFolderRadius1x2: mFolderRadius1x2
    };
    return result;
  }
}

/**
 * 屏幕宽度分级
 */
export enum ScreenWidth {
  LARGE = 375,
  MIDDLE = 360
}

/**
 * 不同屏幕宽度下的图标大小
 */
export enum IconSize {
  LARGE = 58,
  MIDDLE = 54,
  SMALL = 52
}

/**
 * 屏幕高度分级
 */
enum ScreenHeight {
  HEIGHT_SCALE_RATIO_SHORT = 19.5,
  HEIGHT_SCALE_RATIO_MIDDLE = 19.9,
  HEIGHT_SCALE_RATIO_LONG = 20
}

/**
 * 屏幕比例分级
 */
enum ScreenRatioRange {
  LEFT_DIVIDE = ScreenHeight.HEIGHT_SCALE_RATIO_SHORT / WIDTH_SCALE_FACTOR,
  RIGHT_DIVIDE = ScreenHeight.HEIGHT_SCALE_RATIO_MIDDLE / WIDTH_SCALE_FACTOR,
  LONG_SCREEN_DIVIDE = ScreenHeight.HEIGHT_SCALE_RATIO_LONG / WIDTH_SCALE_FACTOR
}

/**
 * 布局配置值
 */
export enum DefaultGridProp {
  COLUMN_NUM_OF_GRID = 4,
  NAVIGATION_OFFSET = 2,
  COLUMN_SPACE_GAP_OF_SIDE = 8,
  BIG_OFFSET_OF_ROA_AND_COLUMN = 8,
  SMALL_OFFSET_OF_ROW_AND_COLUMN = 4,
  LONG_SCREEN_ROW_NUM_OF_GRID = 7,
  ORDINARY_SCREEN_ROW_NUM_OF_GRID = 6
}


/**
 * 文件夹展开态布局配置(与图标大小的比例)
 */
enum OpenFolderGridConfig {
  COL_GAP = 8 / 15,
  ROW_GAP = 11 / 15,
  GRID_WIDTH = 276 / 60,
  GRID_HEIGHT = 408 / 60,
  PAGE_SPACE = 3 / 5
}

/**
 * 根据屏幕高度，纵向间隙比计算的行间距大小
 */
export enum SpaceOfRowSize {
  SMALL_SIZE = 36,
  MEDIUM_SIZE = 38,
  LARGE_SIZE = 40,
  MAX_SIZE = 42
}

/**
 * 对应配置文件类型
 */
export interface CfgJson {
  defaultLayout: DefaultLayout;
  newLayout: DefaultLayout;
};

export interface DefaultLayout {
  iconSizeOfGrid: number;

  columnNumOfGrid: number;

  rowNumOfGrid: number;

  spaceOfColumn: number;

  maxDisplayCountEnable?: boolean;

  maxDisplayCount?: number;
}
