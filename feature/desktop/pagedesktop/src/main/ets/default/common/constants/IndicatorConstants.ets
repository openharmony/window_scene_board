/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

export default class IndicatorConstants {
  public static readonly HAND_OFF_INDICATOR_ANIMATION = 400;
  public static readonly HEIGHT_OF_INDICATOR = 6;
  public static readonly WIDTH_OF_INDICATOR = 6;
  public static readonly RADIUS_OF_INDICATOR = 6;
  public static readonly INDICATOR_SPACE = 8;
  public static readonly EXPAND_INDICATOR_OFFSET_DISTANCE = 1;
  public static readonly FOLD_INDICATOR_OFFSET_DISTANCE = 3;
  public static readonly EXPAND_HEIGHT_OF_SELECTED_INDICATOR = 10;
  public static readonly FOLD_HEIGHT_OF_SELECTED_INDICATOR = 6.1;
  public static readonly EXPAND_WIDTH_OF_SELECTED_INDICATOR = 24;
  public static readonly FOLD_WIDTH_OF_SELECTED_INDICATOR = 12;
  public static readonly EXPAND_INDICATOR_SELECTED_PADDING = 2;
  public static readonly FOLD_INDICATOR_SELECTED_PADDING = 3;
  // 折叠屏展开态导航点背景跟导航点的距离(24 - 12 - 8) / 2= 2
  public static readonly EXPAND_TRANSLATE_DIFF = (IndicatorConstants.EXPAND_WIDTH_OF_SELECTED_INDICATOR -
    IndicatorConstants.WIDTH_OF_INDICATOR * 2 - IndicatorConstants.INDICATOR_SPACE) / 2;
  // 折叠屏折叠态导航点背景跟导航点的距离(12 - / 2) = 3
  public static readonly FOLD_TRANSLATE_DIFF = (IndicatorConstants.FOLD_WIDTH_OF_SELECTED_INDICATOR -
    IndicatorConstants.WIDTH_OF_INDICATOR) / 2;
  // 导航点+间隙 6 + 8 = 14
  public static readonly INDICATOR_DISTANCE = IndicatorConstants.WIDTH_OF_INDICATOR +
    IndicatorConstants.INDICATOR_SPACE;
  public static readonly INDICATOR_MARGIN = 12;
  public static readonly WIDTH_OF_NEGATIVE_SCREEN_INDICATOR = 6;
  public static readonly HEIGHT_OF_NEGATIVE_SCREEN_INDICATOR = 8;
}