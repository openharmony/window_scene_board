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

import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  FolderStyleConstants,
  LayoutViewModel,
  OpenFolderStyle,
  OpenFolderStyleParam,
  PageDesktopModel,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  FolderLayoutStruct,
  CalculateFolderRst
} from '@ohos/launchercommon';

/**
 * 布局计算静态方法集合基类,子类如果没有单独规格使用基态方法, 否则需要super调用先取到对象, 再对属性进行针对覆盖
 */
export class FolderStyleCalculate {
  /**
   * 计算展开态布局参数对象
   *
   * @param 展开态入参对象
   * @returns 展开态布局对象
   */
  public static calculateOpenFolderStyle(param: OpenFolderStyleParam): OpenFolderStyle {
    let openFolderStyle = FolderStyleCalculate.getBasicOpenStyleConfig(param);
    FolderStyleCalculate.setRestOpenFolderStyleConfig(param, openFolderStyle);
    return openFolderStyle;
  }

  /**
   * 获取展开态布局参数配置
   *
   * @param 展开态布局计算入参对象
   * @returns 展开态布局对象
   */
  private static getBasicOpenStyleConfig(param: OpenFolderStyleParam): OpenFolderStyle {
    let openFolderStyle = new OpenFolderStyle();
    openFolderStyle.iconSize = param.iconSize;
    openFolderStyle.columnGap = param.columnGap;
    openFolderStyle.rowGap = param.rowGap;
    openFolderStyle.appNameMarginTop = param.appNameMarginTop;
    openFolderStyle.iconMarginTop = param.iconMarginTop;
    openFolderStyle.gridVerticalPadding = param.gridVerticalPadding;
    openFolderStyle.gridHorizontalPadding = param.gridHorizontalPadding;
    openFolderStyle.gridItemWidth = param.defaultIconSize * (1 + param.iconHorizontalScale);
    openFolderStyle.gridItemHeight = param.defaultIconSize * (1 + param.iconVerticalScale);
    openFolderStyle.openGridWidth =
      openFolderStyle.gridItemWidth * param.maxColumns + StyleConstants.DEFAULT_2 * param.gridHorizontalPadding;
    openFolderStyle.openGridHeight =
      openFolderStyle.gridItemHeight * param.maxRows + StyleConstants.DEFAULT_2 * param.gridVerticalPadding;
    openFolderStyle.indicatorBottom = FolderStyleCalculate.getIndicatorBottom(openFolderStyle);
    return openFolderStyle;
  }

  /**
   * 计算需要通过基础布局参数进行二次处理的展开态布局参数
   *
   * @param 展开态布局计算入参对象
   * @returns 展开态布局对象
   */
  private static setRestOpenFolderStyleConfig(param: OpenFolderStyleParam, openFolderStyle: OpenFolderStyle): void {
    let iconGridHeight = openFolderStyle.gridItemHeight * (param.maxRows - 1) + param.defaultIconSize;
    let halfDistance = (param.screenHeight - iconGridHeight) / StyleConstants.DEFAULT_2;
    openFolderStyle.openFolderIconTopMargin = halfDistance - param.gridVerticalPadding - param.iconMarginTop;
    openFolderStyle.openFolderIconBottomMargin =
      param.screenHeight - openFolderStyle.openGridHeight - openFolderStyle.openFolderIconTopMargin;
    openFolderStyle.titleMarginTop = halfDistance - param.sysTopHeight - param.titleMargin;
    openFolderStyle.dragBorderMargin = openFolderStyle.openFolderIconTopMargin + openFolderStyle.iconMarginTop -
    param.dragBroderIconVerticalDistance;
    openFolderStyle.dragBorderHeight =
      iconGridHeight + openFolderStyle.appNameMarginTop + StyleConstants.DEFAULT_OPEN_FOLDER_APP_NAME_SIZE +
        param.dragBroderIconVerticalDistance * StyleConstants.DEFAULT_2;
    openFolderStyle.dragBorderWidth = openFolderStyle.gridItemWidth * (param.maxColumns - 1) + param.defaultIconSize +
      param.dragBroderIconHorizontalDistance * StyleConstants.DEFAULT_2;
  }

  /**
   * 获取默认参数对象,后续产品克继承此类覆写此方法
   *
   * @returns 展开态布局参数对象
   */
  public static getDefaultOpenFolderStyleParam(): OpenFolderStyleParam {
    let openFolderStyleParam: OpenFolderStyleParam = new OpenFolderStyleParam();
    openFolderStyleParam.columnGap = FolderStyleConstants.DEFAULT_OPEN_FOLDER_COLUMN_GRID_GAP;
    openFolderStyleParam.rowGap = FolderStyleConstants.DEFAULT_OPEN_FOLDER_ROW_GRID_GAP;
    openFolderStyleParam.iconHorizontalScale = FolderStyleConstants.DEFAULT_OPEN_FOLDER_ICON_HORIZONTAL_SCALE;
    openFolderStyleParam.iconVerticalScale = FolderStyleConstants.DEFAULT_OPEN_FOLDER_ICON_VERTICAL_SCALE;
    openFolderStyleParam.titleMargin = FolderStyleConstants.DEFAULT_OPEN_FOLDER_TITTLE_MARGIN;
    openFolderStyleParam.appNameMarginTop = FolderStyleConstants.DEFAULT_OPEN_FOLDER_APPNAME_MARGIN_TOP;
    openFolderStyleParam.gridHorizontalPadding = FolderStyleConstants.DEFAULT_OPEN_FOLDER_GRID_HORIZONTAL_PADDING;
    openFolderStyleParam.gridVerticalPadding = FolderStyleConstants.DEFAULT_OPEN_FOLDER_GRID_VERTICAL_PADDING;
    openFolderStyleParam.dragBroderIconHorizontalDistance =
      FolderStyleConstants.DEFAULT_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
    openFolderStyleParam.dragBroderIconVerticalDistance =
      FolderStyleConstants.DEFAULT_OPEN_FOLDER_DRAG_BORDER_ICON_VERTICAL_DISTANCE;
    openFolderStyleParam.screenHeight = AppStorage.get('screenHeight') as number;
    openFolderStyleParam.screenWidth = AppStorage.get('screenWidth') as number;
    openFolderStyleParam.iconMarginTop = FolderStyleConstants.DEFAULT_OPEN_FOLDER_GRID_ICON_MARGIN_TOP;
    return openFolderStyleParam;
  }

  /**
   * 获取导航点高度
   *
   * @returns 导航点距离屏幕底部高度
   */
  private static getIndicatorBottom(openFolderStyle: OpenFolderStyle): number {
    if (LayoutViewModel.getInstance().getDesktopModel() === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      return LayoutViewModel.getInstance().getDockHeight() - FolderStyleConstants.DEFAULT_OPEN_FOLDER_INDICATOR;
    }
    let marginBottomOfIndicator =
      PageDesktopModel.getInstance().getPageDesktopStyleConfig().mMarginBottomOfIndicator;
    // 导航点高度和桌面导航点高度一致
    return LayoutViewModel.getInstance().getDockHeight() + marginBottomOfIndicator -
    FolderStyleConstants.DEFAULT_INDICATOR_BOTTOM_MARGIN;
  }

  private static getIndicatorBottomInSingleFoldDevice(openFolderStyle: OpenFolderStyle): number {
    let screenHeight = AppStorage.get('screenHeight') as number;
    let sysUITopHeight = LayoutViewModel.getInstance().getSysUITopHeight();
    let gridHeight = openFolderStyle.openGridHeight;
    let gridBottomPadding = openFolderStyle.gridVerticalPadding;
    let appNameMargin = openFolderStyle.appNameMarginTop;
    return ((screenHeight - sysUITopHeight - gridHeight) / StyleConstants.DEFAULT_2 + gridBottomPadding +
      appNameMargin) / StyleConstants.DEFAULT_2;
  }

  public static calculateFolderCommon(
    layoutInfo: FolderLayoutStruct,
    isInPreviewMode: boolean | undefined,
    calculateFolder: (layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean) => CalculateFolderRst,
    bindSheetGridPadding: number,
    bindSheetTitlePadding: number
  ): CalculateFolderRst {
    const result = calculateFolder(layoutInfo, isInPreviewMode);
    result.mBindSheetGridPadding = bindSheetGridPadding;
    result.mBindSheetTitlePadding = bindSheetTitlePadding;
    return result;
  }
}