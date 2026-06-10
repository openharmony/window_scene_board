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

import { FolderLayoutStruct, OpenFolderStyle, OpenFolderStyleParam, StyleConstants } from '@ohos/launchercommon';
import { FileUtils, LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type {
  CalculateOpenFolderRst,
  BaseConfig,
  CalculateDesktopRst,
  CalculateDockRst,
  CalculateFormRst
} from '@ohos/launchercommon';
import { PhoneLayoutRulesController } from './PhoneLayoutRulesController';
import PadPresetConstants from '../../../common/constants/PadPresetConstants';
import { RadiusUtil } from '@ohos/launchercommon';
import { DesktopMode } from '@ohos/launchercommon';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import preferences from '@ohos.data.preferences';
import type ctx from '@ohos.app.ability.common';
import { UpdateRdbManager } from '@ohos/launchercommon';
import { GetLayoutInfoFromConfig } from '@ohos/launchercommon';
import configPolicy from '@ohos.configPolicy';
import { FolderStyleCalculate } from '@ohos/bigfolder/src/main/ets/default/viewmodel/FolderStyleCalculate';

const TAG = 'OuterPhoneLayoutRulesController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CONFIG_PATH = 'etc/desktop/grid_layout_config.json';
const SPACE_OF_COLUMN_SIDE = 23;
const ABOVE_SPACE = 4;
const MARGIN_BOTTOM_OF_INDICATOR = 9;

export class OuterPhoneLayoutRulesController extends PhoneLayoutRulesController {
  public static singleName: string = 'OuterPhoneLayoutRulesController';
  public hasConfig: boolean = false;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): OuterPhoneLayoutRulesController {
    let instance = singleManager.get<OuterPhoneLayoutRulesController>(OuterPhoneLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    log.showInfo(`${OuterPhoneLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
  }

  protected loadLauncherNewStyleConfig(): void {
    let cfgFiles: string[] = [];
    try {
      cfgFiles = configPolicy.getCfgFilesSync(CONFIG_PATH);
    } catch (error) {
      log.error(TAG, 'configPolicy.getCfgFiles error', error);
    }
    if (cfgFiles?.length > 0) {
      const filePath = cfgFiles[0];
      const gridLayout: JsonLayout = FileUtils.readJsonFile(filePath);
      if (gridLayout) {
        this.hasConfig = true;
        this.iconSizeOfGrid = gridLayout.iconSize;
        this.columnNumOfGrid = gridLayout.column;
        this.rowNumOfGrid = gridLayout.row;
        this.spaceOfColumn = gridLayout.space;
        this.spaceOfRow = gridLayout.space;
      } else {
        this.initConfig();
      }
    } else {
      log.showInfo(TAG, 'no cfg files');
      this.initConfig();
    }
  }

  initConfig(): void {
    log.showInfo(TAG, 'initConfig');
    this.iconSizeOfGrid = OuterPhoneIconSize.SMALL;
    this.rowNumOfGrid = OuterPhoneGridProp.ROW_NUM_OF_GRID;
    this.columnNumOfGrid = OuterPhoneGridProp.COLUMN_NUM_OF_GRID;
    this.spaceOfColumn = OuterPhoneGridProp.ROW_COLUMN_SPACE;
    this.spaceOfRow = OuterPhoneGridProp.ROW_COLUMN_SPACE;
  }

  calculateProductConfig(): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    this.spaceOfColumnSide = SPACE_OF_COLUMN_SIDE;
    this.offsetOfRowAndColumn = 0;
    log.showInfo(TAG, `scrWidth:${scrWidth}, spaceOfColumn: ${this.spaceOfColumn}, spaceOfRow: ${this.spaceOfRow}, spaceOfColumnSide: ${this.spaceOfColumnSide},
     offsetOfRowAndColumn :${this.offsetOfRowAndColumn}`);
  }

  calculateDesktop(): CalculateDesktopRst {
    let itemPadding = this.mBaseConfig.getItemPadding();

    log.showInfo(TAG, `itemPadding:${itemPadding}`);
    let realGridWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * this.spaceOfColumnSide;
    // 更新网格宽度
    this.mBaseConfig.setGridRealWidth(realGridWidth);
    let lines = this.mLauncherLayoutStyleConfig.mNameLines;
    let nameHeight = this.mBaseConfig.getNameHeight();
    let itemSize = this.mBaseConfig.getItemSize();
    let realGridHeight = (this.iconSizeOfGrid + this.spaceOfRow) * this.rowNumOfGrid;
    // 更新网格高度
    this.mBaseConfig.setGridRealHeight(realGridHeight);
    let aboveSpace = ABOVE_SPACE;

    let belowSpace = 0;
    // 上方状态栏高度 + 整体空白区域的2/5 - griditem上方的padding值为实际grid的marginTop
    let marginTop = this.mBaseConfig.getSysUITopHeight() + aboveSpace * StyleConstants.DEFAULT_2;

    // grid底部距离dock图标顶部的距离 的一半，再减去dock图标顶部距离dock组件顶部的距离，再减去导航条高度的一半，即为导航条距离swiper组件底部的距离
    let indicatorHeight = this.mBaseConfig.getIndicatorHeight();
    let marginBottomOfIndicator = MARGIN_BOTTOM_OF_INDICATOR;

    // set desktop icon
    let appTextSize = this.mLauncherLayoutStyleConfig.mNameSize;
    let nameWidth = this.mLauncherLayoutStyleConfig.mNameWidth;
    let iconNameMargin = this.mBaseConfig.getDesktopIconNameMargin();
    let iconNameMarginTop = this.mBaseConfig.getIconNameMarginTop();
    let iconHeight = itemSize - nameHeight * lines - iconNameMarginTop;
    let iconMarginHorizontal = 0;
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
    log.showInfo(TAG, `desktop result: columns is ${result.mColumns}, rows is ${result.mRows},
      iconSize is ${result.mIconSize}, gridWidth is ${result.mGridWidth}, gridHeight is ${result.mGridHeight}`);
    // save cur layout to preferences
    this.saveColumnAndRow();
    return result;
  }

  private async saveColumnAndRow(): Promise<void> {
    if (this.mBaseConfig.getScreenWidth() === 0 || this.mBaseConfig.getScreenHeight() === 0) {
      return;
    }
    try {
      preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'OUTER_DESKTOP_LAYOUT_INFO').then((preference) => {
        preference.putSync('column', this.columnNumOfGrid);
        preference.putSync('row', this.rowNumOfGrid);
        log.showInfo(TAG, `calculateDesktop column: ${this.columnNumOfGrid}, row: ${this.rowNumOfGrid}`);
        preference.flush().then((res) => {
          log.showInfo(TAG, ` save layout to sp successs: ${res}`);
        }).catch((reject: Error) => {
          log.showInfo(TAG, ` save layout to sp fail: ${reject}`);
        });
      }).catch((error: Error) => {
        log.showError('getPreferences inner error', error);
      });
    } catch (error) {
      log.showError(TAG, 'getPreferences outer error', error);
    }
  }

  /**
   * calculate dock
   */
  calculateDock(): CalculateDockRst {
    let result = super.calculateDock();
    result.mIconSize = PadPresetConstants.DOCK_ICON_SIZE;
    result.mListItemWidth = PadPresetConstants.DOCK_ICON_SIZE;
    result.mListItemHeight = PadPresetConstants.DOCK_ICON_SIZE;
    result.mDockHeight = PadPresetConstants.DOCK_ICON_SIZE + StyleConstants.DEFAULT_2 * PadPresetConstants.DOCK_PADDING;
    result.mDockPadding = PadPresetConstants.DOCK_PADDING;
    result.mListItemGap = PadPresetConstants.DOCK_LIST_ITEM_GAP;
    let dockSpaceWidth = Math.min(this.mBaseConfig.getScreenWidth(), this.mBaseConfig.getScreenHeight());
    let maxNum = ~~((dockSpaceWidth - StyleConstants.DEFAULT_2 * result.mDockPadding - result.mListItemGap * 2 -
    StyleConstants.DEFAULT_20) / (result.mIconSize + result.mListItemGap));
    result.mMaxDockNum = maxNum - 1;
    result.mBackgroundColor = StyleConstants.DEFAULT_SMART_DOCK_PC_BG_COLOR;
    result.mDockRadius = this.mLauncherLayoutStyleConfig.mDockRadius;
    result.mBackSaturation = StyleConstants.DEFAULT_SMART_DOCK_PC_SATURATION;
    log.showInfo(TAG, `calculateDock DockHeight: ${this.mBaseConfig.getDockHeight()},
      mSysUIBottomHeight: ${this.mBaseConfig.getSysUIBottomHeight()}`);
    return result;
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    log.showInfo(TAG, 'calculateForm pad start');
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
    let result: CalculateFormRst = {
      mIconNameMargin: this.mBaseConfig.getDesktopIconNameMargin(),
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      widthDimension1: widthDimension1,
      heightDimension1: heightDimension1,
      widthDimension3: widthDimension3,
      heightDimension3: heightDimension3,
      widthDimension2: widthDimension2,
      heightDimension2: heightDimension2,
      widthDimension4: widthDimension4,
      heightDimension4: heightDimension4,
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
    log.showInfo(TAG, 'calculateOpenFolder start');
    let iconSizeTemp: number = this.iconSizeOfGrid;
    let themeStyle = this.getThemeStyleInfo(isInPreviewMode);
    if (themeStyle && themeStyle.iconSizeScale) {
      iconSizeTemp += themeStyle.iconSizeScale;
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

enum OuterPhoneGridProp {
  COLUMN_NUM_OF_GRID = 4,
  ROW_NUM_OF_GRID = 4,
  ROW_COLUMN_SPACE = 18,
  NAVIGATION_OFFSET = 2,
  COLUMN_SPACE_GAP_OF_SIDE = 8,
  BIG_OFFSET_OF_ROA_AND_COLUMN = 8,
  SMALL_OFFSET_OF_ROW_AND_COLUMN = 4,
  //  LONG_SCREEN_ROW_NUM_OF_GRID = 4,
  ORDINARY_SCREEN_ROW_NUM_OF_GRID = 6,
  SYSUI_MARGIN_TOP = 4,
  SPACE_COLUMN_SIDE = 125,
  GRID_MARGIN_BUTTOM = 149,

}

enum OuterPhoneIconSize {
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
}