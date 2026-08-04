/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import display from '@ohos.display';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, ScreenStateModel, ScreenStateMonitor } from '@ohos/frameworkwrapper';
import { CommonConstants } from './CommonConstants';
import { CommonStyle } from './CommonStyle';
import { FoldExpandStyle } from './FoldExpandStyle';

const TAG = 'EmergencyUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * EmergencyUtils
 */
export class EmergencyUtils {
  /**
   * Get screen width
   * @returns
   */
  public static getScreenWidth(): number {
    if (DeviceHelper.isThreeFoldProduct()) {
       let mScreenStateModel: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
       return px2vp(mScreenStateModel.width);
    }
    let screenWidth = AppStorage.get<number>('screenWidth') ?? 0;
    if (screenWidth) {
      return screenWidth;
    }
    const displayData: display.Display | undefined = EmergencyUtils.getDefaultDisplaySync();
    if (!displayData) {
      log.showError('get screen width error!!');
      return screenWidth;
    }
    return px2vp(displayData.width);
  }

  /**
   * Get screen height
   * @returns
   */
  public static getScreenHeight(): number {
    if (DeviceHelper.isThreeFoldProduct()) {
      let mScreenStateModel: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
      return px2vp(mScreenStateModel.height);
    }
    let screenHeight = AppStorage.get<number>('screenHeight') ?? 0;
    if (screenHeight) {
      return screenHeight;
    }
    const displayData: display.Display | undefined = EmergencyUtils.getDefaultDisplaySync();
    if (!displayData) {
      log.showError('get screen height error!!');
      return screenHeight;
    }
    return px2vp(displayData.height);
  }

  private static getDefaultDisplaySync(): display.Display | undefined {
    try {
      return display.getDefaultDisplaySync();
    } catch (e) {
      log.showError(`getDefaultDisplaySync code: ${e?.code}, msg: ${e?.message}`);
    }
    return undefined;
  }

  /**
   * 获取三折叠栅栏宽度和距离.
   * @param style
   * @returns
   */
  public static getThreeFoldGridWidthAndGutter(style: FoldExpandStyle): number[] {
    if (CheckEmptyUtils.isEmpty(style)) {
      log.showError('get three fold grid style is empty');
      return [0, CommonConstants.GRID_GUTTER];
    }
    const screenWidth: number = EmergencyUtils.getScreenWidth();
    let gridWidth: number = (screenWidth - 2 * style.gridMargin -
      (style.gridNumber - 1) * CommonConstants.GRID_GUTTER) / style.gridNumber;
    log.showInfo(`screenWidth: ${screenWidth}, grid width: ${gridWidth}, gutter: ${CommonConstants.GRID_GUTTER}`);
    return [gridWidth, CommonConstants.GRID_GUTTER];
  }

  /**
   * 初始化三折叠的图标网格信息
   * @param gridWidth
   * @param gridGutter
   * @param style
   */
  public static initGridStyleOfThreeFold(gridWidth: number, gridGutter: number, style: CommonStyle,
    fStyle: FoldExpandStyle): void {
    if (CheckEmptyUtils.isEmpty(style) || CheckEmptyUtils.isEmpty(fStyle)) {
      log.showError('init grid style is empty');
      return;
    }
    let gridNum = fStyle.gridNumberBetweenIcon;
    let gutterNum = fStyle.gridGutterNumberBetweenIcon;
    style.appItemPadding = (style.appNameWidth - style.appItemWidth) >> 1;
    style.appGridGutterX = (( gridNum * gridWidth + gutterNum * gridGutter - style.appItemWidth) >> 1) -
      (style.appItemPadding << 1);
    style.appGridGutterY = fStyle.appSearchGridGutterY;
    style.appGridWidth = gridNum * gridWidth + gutterNum * gridGutter + 2 * style.appItemWidth +
      (style.appItemPadding << 1);
    style.appGridHeight = 2 * style.appItemHeight + style.appGridGutterY;
  }

  /**
   * Get the grid information of the current device, including the grid width and grid gutter.
   * @param device
   * @returns
   */
  public static getGridWidthAndGutter(device: string): number[] {
    const screenWidth: number = EmergencyUtils.getScreenWidth();
    let gridWidth: number = 0;
    if (device === 'phone') {
      gridWidth = (screenWidth - 2 * CommonConstants.GRID_SMALL_MARGIN -
        (CommonConstants.GRID_SMALL_NUMBER - 1) * CommonConstants.GRID_GUTTER) / CommonConstants.GRID_SMALL_NUMBER;
    } else if (device === 'fold') {
      gridWidth = (screenWidth - 2 * CommonConstants.GRID_BIG_MARGIN -
        (CommonConstants.GRID_MIDDLE_NUMBER - 1) * CommonConstants.GRID_GUTTER) / CommonConstants.GRID_MIDDLE_NUMBER;
    } else if (device === 'pad') {
      gridWidth = (screenWidth - 2 * CommonConstants.GRID_BIG_MARGIN -
        (CommonConstants.GRID_LARGE_NUMBER - 1) * CommonConstants.GRID_GUTTER) / CommonConstants.GRID_LARGE_NUMBER;
    }
    log.showInfo(`ScreenWidth: ${screenWidth}, get grid width: ${gridWidth}, gutter: ${CommonConstants.GRID_GUTTER}`);
    return [gridWidth, CommonConstants.GRID_GUTTER];
  }

  /**
   * Init grid style of fold in folded status
   * @param gridWidth
   * @param gridGutter
   * @param style
   */
  public static initGridStyleOfFolded(gridWidth: number, gridGutter: number, style: CommonStyle): void {
    if (style) {
      style.appItemPadding = (style.appNameWidth - style.appItemWidth) >> 1;
      style.appGridGutterX = ((2 * gridWidth + gridGutter - style.appItemWidth) >> 1) - (style.appItemPadding << 1);
      style.appGridGutterY = CommonConstants.APP_GRID_GUTTER_Y_IN_FOLDED;
      style.appGridWidth = 2 * gridWidth + gridGutter + 2 * style.appItemWidth + (style.appItemPadding << 1);
      style.appGridHeight = 2 * style.appItemHeight + style.appGridGutterY;
    }
  }

  /**
   * Init grid style of fold in expanded status
   * @param gridWidth
   * @param gridGutter
   * @param style
   */
  public static initGridStyleOfExpanded(gridWidth: number, gridGutter: number, style: CommonStyle): void {
    if (style) {
      style.appItemPadding = (style.appNameWidth - style.appItemWidth) >> 1;
      style.appGridGutterX = ((4 * gridWidth + 3 * gridGutter - style.appItemWidth) >> 1) - (style.appItemPadding << 1);
      style.appGridGutterY = CommonConstants.APP_GRID_GUTTER_Y_IN_EXPANDED;
      style.appGridWidth = 4 * gridWidth + 3 * gridGutter + 2 * style.appItemWidth + (style.appItemPadding << 1);
      style.appGridHeight = 2 * style.appItemHeight + style.appGridGutterY;
    }
  }
}