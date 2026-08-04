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

import type { BaseConfig, CalculateDesktopRst, CalculateDockRst, CalculateFolderRst, CalculateFormRst, CalculateOpenFolderRst } from '@ohos/launchercommon';
import { DesktopMode, FolderLayoutStruct, FolderStyleConstants, OpenFolderStyle, OpenFolderStyleParam, RadiusUtil, StyleConstants } from '@ohos/launchercommon';
import { FileUtils, Log, LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { PhoneLayoutRulesController } from './PhoneLayoutRulesController';
import PadPresetConstants from '../../../common/constants/PadPresetConstants';
import preferences from '@ohos.data.preferences';
import type ctx from '@ohos.app.ability.common';
import configPolicy from '@ohos.configPolicy';
import { FolderStyleCalculate } from '@ohos/bigfolder/src/main/ets/default/viewmodel/FolderStyleCalculate';

const TAG = 'PadLayoutRulesController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CONFIG_PATH = 'etc/desktop/grid_layout_config.json';
const NAVIGATION_OFFSET = 2;
const SPACE_OFFSET = 6;
const APP_ICON_AND_TEXT_SCALE_COEFFICIENTS = 4.5;

export class PadLayoutRulesController extends PhoneLayoutRulesController {
  public static singleName: string = 'PadLayoutRulesController';
  public hasConfig: boolean = false;
  public verticalSpace: number = 0;
  // 竖屏下的行间距
  protected portraitSpaceOfRow: number = 0;
  // 竖屏下的列间距
  protected portraitSpaceOfColumn: number = 0;
  // dock图标大小
  protected dockIconSize: number = PadPresetConstants.DOCK_ICON_SIZE;
  // 网格上方留白offset
  protected aboveSpaceOffset: number = SPACE_OFFSET;
  // 网格下方留白offset
  protected belowSpaceOffset: number = SPACE_OFFSET;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): PadLayoutRulesController {
    let instance = singleManager.get<PadLayoutRulesController>(PadLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    log.showInfo(`${PadLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
  }

  protected loadLauncherNewStyleConfig(): void {
    let cfgFiles: string[] = [];
    try {
      cfgFiles = configPolicy.getCfgFilesSync(CONFIG_PATH);
    } catch (error) {
      log.showError('configPolicy.getCfgFiles error', error);
    }
    if (cfgFiles?.length > 0) {
      const filePath = cfgFiles[0];
      const gridLayout: JsonLayout = FileUtils.readJsonFile(filePath);
      if (gridLayout) {
        this.hasConfig = true;
        this.iconSizeOfGrid = gridLayout.iconSize;
        this.columnNumOfGrid = gridLayout.column;
        this.rowNumOfGrid = gridLayout.row;
        // 横屏：新增行列间距的两个字段
        this.spaceOfColumn = gridLayout.spaceOfColumn ?? gridLayout.space;
        this.spaceOfRow = gridLayout.spaceOfRow ?? gridLayout.space;
        this.verticalSpace = gridLayout.verticalSpace ?? gridLayout.space;
        this.dockIconSize = gridLayout.dockIconSize ?? PadPresetConstants.DOCK_ICON_SIZE;
        this.aboveSpaceOffset = gridLayout.aboveSpaceOffset ?? SPACE_OFFSET;
        this.belowSpaceOffset = gridLayout.belowSpaceOffset ?? SPACE_OFFSET;
        // 文件中最外层的节点是针对横屏的配置，现增加 portraitLayout 用来配置竖屏下有差异的数据
        if (gridLayout.portraitLayout) {
          this.portraitSpaceOfRow = gridLayout.portraitLayout.spaceOfRow;
          this.portraitSpaceOfColumn = gridLayout.portraitLayout.spaceOfColumn;
        }
      } else {
        this.initConfig();
      }
    } else {
      log.showInfo('no cfg files');
      this.initConfig();
    }
  }

  protected setDockIconSize(): void{
    if(this.dockIconSize !== PadPresetConstants.DOCK_ICON_SIZE) {
      this.mBaseConfig.getLauncherLayoutStyleConfig().setDockIconSize(this.dockIconSize);
    }
  }

  initConfig(): void {
    log.showInfo('initConfig');
    this.iconSizeOfGrid = PadIconSize.LARGE;
    this.rowNumOfGrid = PadGridProp.LONG_SCREEN_ROW_NUM_OF_GRID;
    this.columnNumOfGrid = PadGridProp.COLUMN_NUM_OF_GRID;
    this.spaceOfColumn = PadGridProp.ROW_COLUMN_SPACE;
    this.spaceOfRow = PadGridProp.ROW_COLUMN_SPACE;
    this.verticalSpace = PadGridProp.DEFAULT_VERTICAL_SPACE;
  }

  calculateProductConfig(): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    this.spaceOfColumnSide = (scrWidth - this.iconSizeOfGrid * this.columnNumOfGrid -
      this.spaceOfColumn * this.columnNumOfGrid) / 2;
    log.showInfo(`scrWidth:${scrWidth}, spaceOfColumn: ${this.spaceOfColumn}, spaceOfRow: ${this.spaceOfRow}, spaceOfColumnSide: ${this.spaceOfColumnSide},
     offsetOfRowAndColumn :${this.offsetOfRowAndColumn}`);
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
      StyleConstants.DEFAULT_BIND_SHEET_GRID_PADDING,
      StyleConstants.DEFAULT_BIND_SHEET_TITLE_PADDING
    );
  }

  calculateDesktop(): CalculateDesktopRst {
    let itemPadding = this.mBaseConfig.getItemPadding();
    log.showInfo(`itemPadding:${itemPadding}`);
    let realGridWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * this.spaceOfColumnSide;
    // 更新网格宽度
    this.mBaseConfig.setGridRealWidth(realGridWidth);
    let lines = this.mLauncherLayoutStyleConfig.mNameLines;
    let nameHeight = this.mBaseConfig.getNameHeight();
    let itemSize = this.mBaseConfig.getItemSize() + (lines - 1) * nameHeight;
    let realGridHeight = (this.iconSizeOfGrid + this.spaceOfRow) * this.rowNumOfGrid;
    // 更新网格高度
    this.mBaseConfig.setGridRealHeight(realGridHeight);
    let realSpace = this.mBaseConfig.getWorkSpaceHeight() - this.mBaseConfig.getSysUITopHeight() - realGridHeight +
      itemPadding * StyleConstants.DEFAULT_2;

    //上下留白的计算公式 aboveSpace + belowSpace = realSpace; (aboveSpace + padding) : belowSpace = 4 : 5;
    let aboveSpace = StyleConstants.DEFAULT_4 * realSpace / StyleConstants.DEFAULT_9;
    let belowSpace = realSpace - aboveSpace + this.belowSpaceOffset;
    // 上方状态栏高度 + 整体空白区域的2/5 - griditem上方的padding值为实际grid的marginTop
    let marginTop = this.mBaseConfig.getSysUITopHeight() + aboveSpace - itemPadding + this.aboveSpaceOffset;

    // grid底部距离dock图标顶部的距离 的一半，再减去dock图标顶部距离dock组件顶部的距离，再减去导航条高度的一半，即为导航条距离swiper组件底部的距离
    let indicatorHeight = this.mBaseConfig.getIndicatorHeight();
    let marginBottomOfIndicator = (belowSpace - NAVIGATION_OFFSET) / StyleConstants.DEFAULT_2 -
      indicatorHeight / StyleConstants.DEFAULT_2;

    // set desktop icon
    let appTextSize = Math.round(this.iconSizeOfGrid / APP_ICON_AND_TEXT_SCALE_COEFFICIENTS);
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
    // save cur layout to preferences
    this.saveColumnAndRow();
    return result;
  }

  private async saveColumnAndRow(): Promise<void> {
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
        Log.showError(TAG, `getPreferences inner error ${error}`);
      });
    } catch (error) {
      Log.showError(TAG, 'getPreferences outer error', error);
    }
  }

  /**
   * calculate dock
   */
  calculateDock(): CalculateDockRst {
    let result = super.calculateDock();
    result.mIconSize = this.dockIconSize;
    result.mListItemWidth = this.dockIconSize;
    result.mListItemHeight = this.dockIconSize;
    result.mDockHeight = this.dockIconSize + StyleConstants.DEFAULT_2 * PadPresetConstants.DOCK_PADDING;
    result.mDockPadding = PadPresetConstants.DOCK_PADDING;
    result.mListItemGap = PadPresetConstants.DOCK_LIST_ITEM_GAP;
    let dockSpaceWidth = Math.min(this.mBaseConfig.getScreenWidth(), this.mBaseConfig.getScreenHeight());
    let maxNum = ~~((dockSpaceWidth - StyleConstants.DEFAULT_2 * result.mDockPadding - result.mListItemGap * 2 -
    StyleConstants.DEFAULT_20) / (result.mIconSize + result.mListItemGap));
    result.mMaxDockNum = maxNum - 1;
    result.mBackgroundColor = StyleConstants.DEFAULT_SMART_DOCK_PC_BG_COLOR;
    result.mDockRadius = this.mLauncherLayoutStyleConfig.mDockRadius;
    result.mBackSaturation = StyleConstants.DEFAULT_SMART_DOCK_PC_SATURATION;
    return result;
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    log.showInfo('calculateForm pad start');
    // 1 x 1  width * height
    let widthDimension0: number = this.iconSizeOfGrid;
    let heightDimension0: number = this.iconSizeOfGrid;
    // 2 x 1  width * height
    let widthDimension1: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfColumn;
    let heightDimension1: number = this.iconSizeOfGrid;
    // 2 x 2
    let widthDimension2: number = widthDimension1;
    let heightDimension2: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfRow;
    // 4 x 2
    let widthDimension3: number = (this.iconSizeOfGrid + this.spaceOfColumn) * StyleConstants.DEFAULT_2 +
      widthDimension1;
    let heightDimension3: number = heightDimension2;
    // 4 x 4
    let widthDimension4: number = widthDimension3;
    let heightDimension4: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_4 +
      this.spaceOfRow * StyleConstants.DEFAULT_3;
    // 4 x 6
    let widthDimension5: number = widthDimension3;
    let heightDimension5: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_6 +
      this.spaceOfRow * StyleConstants.DEFAULT_5;
    let result: CalculateFormRst = {
      mIconNameMargin: this.mBaseConfig.getDesktopIconNameMargin(),
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      widthDimension0: widthDimension0,
      heightDimension0: heightDimension0,
      widthDimension1: widthDimension1,
      heightDimension1: heightDimension1,
      widthDimension3: widthDimension3,
      heightDimension3: heightDimension3,
      widthDimension2: widthDimension2,
      heightDimension2: heightDimension2,
      widthDimension4: widthDimension4,
      heightDimension4: heightDimension4,
      widthDimension5: widthDimension5,
      heightDimension5: heightDimension5
    };
    return result;
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
    if (!isInPreviewMode) {
      iconSizeTemp += this.getDesktopIconSize();
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
    let itemSpace = iconSizeTemp * OpenFolderGridConfig.PAGE_SPACE + colGap -
      OpenFolderGridConfig.COL_GAP * iconSizeTemp;
    let layoutSwiperHeight = row * itemSize + (row - 1) * gutter + StyleConstants.DEFAULT_2 * padding + itemSize;
    let title = (this.mBaseConfig.getScreenHeight() - layoutHeight) / StyleConstants.DEFAULT_2 - padding - margin;
    let mFolderIconRadius = this.calculateOpenFolderIconRadius(iconSizeTemp, isInPreviewMode);
    let openFolderStyleParam: OpenFolderStyleParam = FolderStyleCalculate.getDefaultOpenFolderStyleParam();
    openFolderStyleParam.iconSize = iconSizeTemp;
    openFolderStyleParam.defaultIconSize = this.iconSizeOfGrid;
    openFolderStyleParam.maxRows = openFolderConfig.row;
    openFolderStyleParam.maxColumns = openFolderConfig.column;
    openFolderStyleParam.sysTopHeight = this.mBaseConfig.getSysUITopHeight();
    openFolderStyleParam.iconHorizontalScale = FolderStyleConstants.PAD_OPEN_FOLDER_ICON_HORIZONTAL_SCALE;
    openFolderStyleParam.iconVerticalScale = FolderStyleConstants.PAD_OPEN_FOLDER_ICON_VERTICAL_SCALE;
    openFolderStyleParam.dragBroderIconHorizontalDistance =
      FolderStyleConstants.PAD_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
    openFolderStyleParam.gridHorizontalPadding =
      FolderStyleConstants.PAD_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
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

  toString(): String {
    return TAG;
  }
}

enum PadGridProp {
  COLUMN_NUM_OF_GRID = 8,
  NAVIGATION_OFFSET = 2,
  COLUMN_SPACE_GAP_OF_SIDE = 8,
  BIG_OFFSET_OF_ROA_AND_COLUMN = 8,
  SMALL_OFFSET_OF_ROW_AND_COLUMN = 4,
  LONG_SCREEN_ROW_NUM_OF_GRID = 4,
  ORDINARY_SCREEN_ROW_NUM_OF_GRID = 6,
  SYSUI_MARGIN_TOP = 4,
  SPACE_COLUMN_SIDE = 125,
  GRID_MARGIN_BUTTOM = 149,
  ROW_COLUMN_SPACE = 62,
  DEFAULT_VERTICAL_SPACE = 64
}

enum PadIconSize {
  LARGE = 58,
  MIDDLE = 54,
  SMALL = 52
}

/**
 * 文件夹展开态布局配置(与图标大小的比例)
 */
enum OpenFolderGridConfig {
  COL_GAP = 12 / 17,
  ROW_GAP = 14 / 17,
  GRID_WIDTH = 464 / 68,
  GRID_HEIGHT = 500 / 68,
  PAGE_SPACE = 4 / 3
}

export interface JsonLayout {
  iconSize: number;

  column: number;

  row: number;

  space: number;

  spaceOfColumn?: number;

  spaceOfRow?: number;

  verticalSpace?: number;

  dockIconSize?: number;

  aboveSpaceOffset?: number;

  belowSpaceOffset?: number;

  portraitLayout?:PortraitLayout
}

export interface PortraitLayout {
  spaceOfRow: number;

  spaceOfColumn: number
}