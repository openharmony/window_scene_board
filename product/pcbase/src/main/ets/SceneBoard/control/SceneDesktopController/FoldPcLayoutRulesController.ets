/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  LogDomain,
  LogHelper,
  UIContextHelper,
  SingleContext,
  singleManager
} from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  BaseConfig,
  CalculateDesktopRst,
  CalculateAppCenterRst,
  LayoutViewModel,
  StyleConstants,
  GridLayoutUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import PcPresetStyleConstants from '../../../common/constants/PcPresentConstants';
import { PcLayoutRulesController } from './PcLayoutRulesController';
import {
  FoldedDeviceAcViewModel,
  SCBFoldedState
} from '@ohos/appcenter/src/main/ets/default/folded/FoldedDeviceAcViewModel';
import { PCUtils } from '../../../common/utils/PCUtils';

const TAG = 'FoldPcLayoutRulesController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 折叠PC布局控制器
 */
export class FoldPcLayoutRulesController extends PcLayoutRulesController {
  public static singleName: string = 'FoldPcLayoutRulesController';

  private isPortrait: boolean = true;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): FoldPcLayoutRulesController {
    let instance = singleManager.get<FoldPcLayoutRulesController>(FoldPcLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    log.showInfo(`${FoldPcLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
  }

  setIsPortrait(isPortrait: boolean): void {
    log.showInfo(`setIsPortrait: ${isPortrait}`);
    this.isPortrait = isPortrait;
  }

  getPortrait(): boolean {
    return this.isPortrait;
  }

  toString(): String {
    return TAG;
  }

  /**
   * calculate desktop
   */
  calculateDesktop(): CalculateDesktopRst {
    log.showInfo(`calculateDesktop mBaseConfig ${JSON.stringify(this.mBaseConfig)}`);
    log.showInfo(`calculateDesktop mLauncherLayoutStyleConfig ${JSON.stringify(this.mLauncherLayoutStyleConfig)}`);
    const isPortrait: boolean = this.getPortrait();
    log.showInfo(`calculateDesktop isPortrait ${isPortrait}`);

    const columns: number = isPortrait ? PcPresetStyleConstants.DEFAULT_HPR_MDPI_PORTRAIT_COLUMN :
    PcPresetStyleConstants.DEFAULT_HPR_MDPI_NON_PORTRAIT_COLUMN;
    const rows: number = isPortrait ? PcPresetStyleConstants.DEFAULT_HPR_MDPI_PORTRAIT_ROW :
    PcPresetStyleConstants.DEFAULT_HPR_MDPI_NON_PORTRAIT_ROW;
    const marginHorizontal: number = 0;
    const itemSize: number = PcPresetStyleConstants.DEFAULT_HPR_MDPI_ITEM_SIZE;
    const gutter: number = PcPresetStyleConstants.DEFAULT_HPR_MDPI_ITEM_GUTTER;
    const itemPadding: number = this.mBaseConfig.getItemPadding();
    const gridWidth: number = (itemSize + gutter) * columns;
    const gridHeight: number = (itemSize + gutter) * rows;
    const realWidth: number = isPortrait ? this.mBaseConfig.getScreenWidth() : this.mBaseConfig.getScreenWidth() / 2;
    const realHeight: number = isPortrait ? gridHeight : this.mBaseConfig.getScreenHeight() -
    this.mLauncherLayoutStyleConfig.mMarginTop - this.mBaseConfig.getDockHeight();

    this.mBaseConfig.setGridRealHeight(gridHeight);
    let iconMarginVertical = GridLayoutUtil.getCeilVp(this.mLauncherLayoutStyleConfig.mIconMarginTOP);
    let iconMarginHorizontal =
      (itemSize - this.mLauncherLayoutStyleConfig.mAppBubbleIconSize) / StyleConstants.DEFAULT_2;
    log.showInfo(`calculateDesktop realHeight:${realHeight}, gutter:${gutter}, itemSize:${itemSize},
      workspaceHeight:${this.mBaseConfig.getWorkSpaceHeight()},
      indicatorHeight:${this.mBaseConfig.getIndicatorHeight()},
      sysUIHeight:${this.mBaseConfig.getSysUITopHeight()}`);
    this.updateGrid(rows, columns);
    iconMarginHorizontal = (itemSize - this.mLauncherLayoutStyleConfig.mIconBackgroundSize) / StyleConstants.DEFAULT_2;
    let desktopMarginTop: number = this.mLauncherLayoutStyleConfig.mMarginTop;
    desktopMarginTop = PcPresetStyleConstants.WIN_STYLE_SYS_TOP_HEIGHT;
    // 融合dock
    this.mLauncherLayoutStyleConfig.mWorkSpacePaddingTop =
      isPortrait ? PcPresetStyleConstants.DEFAULT_HPR_MDPI_WORK_SPACE_PADDING_TOP :
      PcPresetStyleConstants.DEFAULT_HPR_MDPI_HORIZONTAL_WORK_SPACE_PADDING_TOP;
    const workSpacePaddingTop: number = this.mLauncherLayoutStyleConfig.mWorkSpacePaddingTop;
    const workSpacePadding: number = isPortrait ? PcPresetStyleConstants.DEFAULT_HPR_MDPI_PORTRAIT_MARGIN_HORIZONTAL :
    PcPresetStyleConstants.DEFAULT_HPR_MDPI_NON_PORTRAIT_MARGIN_HORIZONTAL;
    let result: CalculateDesktopRst = {
      mMargin: marginHorizontal,
      mItemPadding: itemPadding,
      mColumnsGap: gutter,
      mRowsGap: gutter,
      mColumns: columns,
      mRows: rows,
      mDesktopMarginTop: desktopMarginTop,
      mWorkSpacePaddingTop: GridLayoutUtil.getFloorVp(workSpacePaddingTop),
      mWorkSpacePaddingBottom: 0,
      mGridWidth: gridWidth,
      mGridHeight: gridHeight,
      mWorkSpaceWidth: realWidth,
      mWorkSpaceHeight: realHeight,
      mAppItemSize: itemSize,
      mNameSize: this.mLauncherLayoutStyleConfig.mNameSize,
      mNameHeight: this.mBaseConfig.getNameHeight(),
      mNameWidth: this.mLauncherLayoutStyleConfig.mNameWidth,
      mIconNameMargin: this.mLauncherLayoutStyleConfig.mIconNameGap,
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      mIconSize: GridLayoutUtil.getFloorVp(this.mLauncherLayoutStyleConfig.mAppBubbleIconSize),
      mNameLines: this.mLauncherLayoutStyleConfig.mNameLines,
      mIconMarginHorizontal: iconMarginHorizontal,
      mIconMarginVertical: iconMarginVertical,
      mWorkSpacePadding: GridLayoutUtil.getFloorVp(workSpacePadding)
    };
    log.showInfo(`calculateDesktop result ${JSON.stringify(result)}`);
    this.saveLayoutToPreferences();
    return result;
  }

  public calculateAppCenter(screenId: number = 0, isRefresh: boolean = false, width?: number,
    height?: number): CalculateAppCenterRst {
    let fs = FoldedDeviceAcViewModel.getInstance().getCurrentFoldState();
    // 屏幕宽度高度初始设置-默认竖屏
    let screenWidth = this.mBaseConfig.getScreenWidth();
    let screenHeight = this.mBaseConfig.getScreenHeight();
    let isMainScreen = screenId === 0;
    if (!isMainScreen) {
      screenWidth = UIContextHelper.px2vp(screenId, width);
      screenHeight = UIContextHelper.px2vp(screenId, height);
    }

    // 应用中心尺寸参数初始化
    let result = new CalculateAppCenterRst();
    result.mAppItemSize = this.mLauncherLayoutStyleConfig.mAppCenterSize;
    result.mAppCenterSizeWidth = this.mLauncherLayoutStyleConfig.mAppCenterSizeWidth;
    result.mAppCenterSizeHeight = this.mLauncherLayoutStyleConfig.mAppCenterSizeHeight;
    result.mAppCenterItemWidth = this.mLauncherLayoutStyleConfig.mAppCenterItemWidth;
    result.mAppCenterItemHeight = this.mLauncherLayoutStyleConfig.mAppCenterItemHeight;
    result.mIconSize = this.mLauncherLayoutStyleConfig.mAppCenterIconSize;
    result.mAppCenterBubbleMarginTop = PcPresetStyleConstants.DEFAULT_HPR_APP_CENTER_BUBBLE_MARGIN_TOP;
    result.mAppCenterBubbleMarginBottom = this.mLauncherLayoutStyleConfig.mAppCenterBubbleMarginBottom;
    result.mIconRadius = this.mLauncherLayoutStyleConfig.mAppCenterIconRadius;
    // 计算应用中心宫格的高度和宽度：特定UX比例计算
    let ratio = StyleConstants.APP_CENTER_GRID_WIDTH_RATIO;
    if (fs === SCBFoldedState.UNFOLDED_HORIZONTAL) {
      ratio = PcPresetStyleConstants.HPR_LS_APP_CENTER_GRID_WIDTH_RATIO;
      if (screenWidth < screenHeight) {
        let m = screenWidth;
        screenWidth = screenHeight;
        screenHeight = m;
        log.showInfo('exchange the sw and sh when landscape mode');
      }
    }
    result.mGridWidth = screenWidth * ratio;
    result.mGridHeight = result.mGridWidth * StyleConstants.APP_CENTER_GRID_HEIGHT_RATIO;
    result.mColumns = this.mLauncherLayoutStyleConfig.mAppCenterColNum;
    result.mRows = this.mLauncherLayoutStyleConfig.mAppCenterRowNum;
    result.mNameSize = this.mLauncherLayoutStyleConfig.mAppCenterNameSize;
    // 如果是展开态横屏则表格高度减半
    if (fs === SCBFoldedState.UNFOLDED_HORIZONTAL || !isMainScreen) {
      result.mGridHeight = (result.mGridWidth * PcPresetStyleConstants.HPR_LS_APP_CENTER_GRID_HEIGHT_RATIO) / 2;
      if (!isMainScreen) {
        if (result.mGridHeight > (screenHeight - this.mLauncherLayoutStyleConfig.mAppCenterMarginTop -
        this.mLauncherLayoutStyleConfig.mAppCenterMarginTop - this.mBaseConfig.getDockHeight()) / 2) {
          result.mGridHeight = (screenHeight - this.mLauncherLayoutStyleConfig.mAppCenterMarginTop -
          this.mLauncherLayoutStyleConfig.mAppCenterMarginTop - this.mBaseConfig.getDockHeight()) / 2;
        }
      }
      FoldedDeviceAcViewModel.getInstance(screenId).setLastColumns(result.mColumns);
      result.mColumns = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_LANDSCAPE_COLS;
      result.mRows = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_LANDSCAPE_ROWS;
      result.mNameSize = PcPresetStyleConstants.UNFOLDED_HORIZONTAL_HPR_APP_CENTER_APPNAME_SIZE;
    }
    if (!isMainScreen) {
      this.proportionalScaling(result);
    }
    // 计算行间距
    result.mColumnsGap =
      Math.round((result.mGridWidth - result.mAppCenterItemWidth * result.mColumns) / result.mColumns);
    result.mRowsGap = Math.round((result.mGridHeight - result.mAppCenterItemHeight * result.mRows) / result.mRows);
    FoldedDeviceAcViewModel.getInstance(screenId).setAcGridPaddingTop(result.mRowsGap / 2);
    // 左右间距计算
    result.mAppCenterMarginLeft =
      Math.round(screenWidth - result.mGridWidth + result.mColumnsGap) / StyleConstants.DEFAULT_2;
    result.mAppCenterMarginRight = result.mAppCenterMarginLeft;
    // 计算上下间距
    result.mAppCenterMarginTop = this.mLauncherLayoutStyleConfig.mAppCenterMarginTop;
    result.mAppCenterMarginBottom =
      screenHeight - result.mAppCenterMarginTop - result.mGridHeight * StyleConstants.DEFAULT_2 -
      this.mBaseConfig.getDockHeight();
    if (fs === SCBFoldedState.HALF_FOLDED) {
      result.mAppCenterMarginBottom =
        result.mAppCenterMarginBottom - PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_SWIPER_ITEM_SPACE_F;
    } else if (fs === SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD ||
      fs === SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD) {
      result.mAppCenterMarginBottom = result.mAppCenterMarginBottom + result.mGridHeight;
    }
    // 计算详细的表格Padding
    result.mPadding =
      (result.mGridHeight - result.mRows * (result.mAppCenterItemHeight + result.mRowsGap) + result.mRowsGap) /
      StyleConstants.DEFAULT_2;
    // 计算图标相关参数
    this.calculateAppCenterItem(result);
    // 计算item space
    let itemSpace = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_SWIPER_ITEM_SPACE_P_UF;
    if (fs === SCBFoldedState.HALF_FOLDED) {
      itemSpace = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_SWIPER_ITEM_SPACE_F;
    } else if (fs === SCBFoldedState.UNFOLDED_VERTICAL) {
      itemSpace = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_SWIPER_ITEM_SPACE_LS_UF;
    } else if (fs === SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD || fs === SCBFoldedState.UNFOLDED_HORIZONTAL) {
      itemSpace = PcPresetStyleConstants.DEFAULT_HPR_MDPI_APP_CENTER_SWIPER_ITEM_SPACE_LS_UF;
    }
    FoldedDeviceAcViewModel.getInstance(screenId).setSwiperItemSpace(itemSpace);
    FoldedDeviceAcViewModel.getInstance(screenId)
      .updateDraggableAreaBottom(result.mAppCenterMarginTop, result.mGridHeight);

    log.showInfo(`calculateAppCenter screenId=${screenId}, columns=${result.mColumns},rows=${result.mRows},` +
      `g-width:${result.mGridWidth}, g-height:${result.mGridHeight},` +
      `mColumnsGap: ${result.mColumnsGap},mRowsGap: ${result.mRowsGap},fs=${fs},` +
      `appCenterItemWidth:${result.mAppCenterItemWidth},appCenterItemHeight:${result.mAppCenterItemHeight},` +
      `bc-sw：${this.mBaseConfig.getScreenWidth()},bc-sh:${this.mBaseConfig.getScreenHeight()},sh:${screenHeight},` +
      `bc-wsh:${this.mBaseConfig.getWorkSpaceHeight()},appCenterMarginLeft=${result.mAppCenterMarginLeft},` +
      `appCenterMarginTop=${result.mAppCenterMarginTop},appCenterMarginBottom=${result.mAppCenterMarginBottom},` +
      `itemspace=${itemSpace}, sw=${screenWidth}, mPadding=${result.mPadding}`);
    return result;
  }
}