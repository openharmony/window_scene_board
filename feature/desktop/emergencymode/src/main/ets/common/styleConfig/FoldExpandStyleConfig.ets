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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenState } from '@ohos/frameworkwrapper';
import { AppSearchThreeFoldConstants, ThreeFoldConstants } from '../CommonConstants';
import { FoldExpandStyle } from '../FoldExpandStyle';

const TAG = 'FoldExpandStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * StyleFactory
 */
export class FoldExpandStyleConfig {
  private static _emergencyMap: Map<string, FoldExpandStyle> = new Map();

  private static _thermalMap: Map<string, FoldExpandStyle> = new Map();

  /**
   * 初始化 emergency map
   * @returns
   */
  public static initEmergencyMap(): void {
    // 创建F态
    let foldExpandStyleF: FoldExpandStyle = new FoldExpandStyle();
    foldExpandStyleF.setGridParam(ThreeFoldConstants.GRID_NUMBER_BETWEEN_ICON_F,
      ThreeFoldConstants.GUTTER_NUMBER_BETWEEN_ICON_F, ThreeFoldConstants.GRID_NUMBER_F,
      ThreeFoldConstants.GRID_MARGIN_F, ThreeFoldConstants.COMMON_PADDING_F);
    foldExpandStyleF.setAppSearchParam(AppSearchThreeFoldConstants.COLNUM_F, AppSearchThreeFoldConstants.ROWGAP_F,
      AppSearchThreeFoldConstants.GRID_PADDING_F, ThreeFoldConstants.APP_GRID_GUTTER_Y);
    FoldExpandStyleConfig._emergencyMap.set(ScreenState.F, foldExpandStyleF);
    // 创建M态
    let foldExpandStyleM: FoldExpandStyle = new FoldExpandStyle();
    foldExpandStyleM.setGridParam(ThreeFoldConstants.GRID_NUMBER_BETWEEN_ICON_M,
      ThreeFoldConstants.GUTTER_NUMBER_BETWEEN_ICON_M, ThreeFoldConstants.GRID_NUMBER_M,
      ThreeFoldConstants.GRID_MARGIN_M, ThreeFoldConstants.COMMON_PADDING_M);
    foldExpandStyleM.setAppSearchParam(AppSearchThreeFoldConstants.COLNUM_M, AppSearchThreeFoldConstants.ROWGAP_M,
      AppSearchThreeFoldConstants.GRID_PADDING_M, ThreeFoldConstants.APP_GRID_GUTTER_Y);
    FoldExpandStyleConfig._emergencyMap.set(ScreenState.M, foldExpandStyleM);
    // 创建G态
    let foldExpandStyleG: FoldExpandStyle = new FoldExpandStyle();
    foldExpandStyleG.setGridParam(ThreeFoldConstants.GRID_NUMBER_BETWEEN_ICON_G,
      ThreeFoldConstants.GUTTER_NUMBER_BETWEEN_ICON_G, ThreeFoldConstants.GRID_NUMBER_G,
      ThreeFoldConstants.GRID_MARGIN_G, ThreeFoldConstants.COMMON_PADDING_G);
    foldExpandStyleG.setAppSearchParam(AppSearchThreeFoldConstants.COLNUM_G, AppSearchThreeFoldConstants.ROWGAP_G,
      AppSearchThreeFoldConstants.GRID_PADDING_G, ThreeFoldConstants.APP_GRID_GUTTER_Y);
    FoldExpandStyleConfig._emergencyMap.set(ScreenState.G, foldExpandStyleG);
  }

  /**
   * 初始化Thermal map
   * @returns
   */
  public static initThermalMap(): void {
    // 创建F态
    let foldExpandStyleF: FoldExpandStyle = new FoldExpandStyle();
    foldExpandStyleF.setGridParam(ThreeFoldConstants.GRID_NUMBER_BETWEEN_ICON_F,
      ThreeFoldConstants.GUTTER_NUMBER_BETWEEN_ICON_F, ThreeFoldConstants.GRID_NUMBER_F,
      ThreeFoldConstants.GRID_MARGIN_F, ThreeFoldConstants.COMMON_PADDING_F);
    FoldExpandStyleConfig._thermalMap.set(ScreenState.F, foldExpandStyleF);
    // 创建M态
    let foldExpandStyleM: FoldExpandStyle = new FoldExpandStyle();
    foldExpandStyleM.setGridParam(ThreeFoldConstants.GRID_NUMBER_BETWEEN_ICON_M,
      ThreeFoldConstants.GUTTER_NUMBER_BETWEEN_ICON_M, ThreeFoldConstants.GRID_NUMBER_M,
      ThreeFoldConstants.GRID_MARGIN_M, ThreeFoldConstants.COMMON_PADDING_M);
    FoldExpandStyleConfig._thermalMap.set(ScreenState.M, foldExpandStyleM);
    // 创建G态
    let foldExpandStyleG: FoldExpandStyle = new FoldExpandStyle();
    foldExpandStyleG.setGridParam(ThreeFoldConstants.GRID_NUMBER_BETWEEN_ICON_G,
      ThreeFoldConstants.GUTTER_NUMBER_BETWEEN_ICON_G, ThreeFoldConstants.GRID_NUMBER_G,
      ThreeFoldConstants.GRID_MARGIN_G, ThreeFoldConstants.COMMON_PADDING_G);
    FoldExpandStyleConfig._thermalMap.set(ScreenState.G, foldExpandStyleG);
  }

  public static getEmergencyMap(): Map<string, FoldExpandStyle> {
    return FoldExpandStyleConfig._emergencyMap;
  }

  public static getThermalMap(): Map<string, FoldExpandStyle> {
    return FoldExpandStyleConfig._thermalMap;
  }

  /**
   * 清空map
   */
  public static clearMap(): void {
    FoldExpandStyleConfig._emergencyMap.clear();
    FoldExpandStyleConfig._thermalMap.clear();
  }
}