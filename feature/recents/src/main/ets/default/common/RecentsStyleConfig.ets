/**
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

/**
 * Recents layout style
 */
export class RecentsStyleConfig {

  /**
   * width of MissionCard, < 1 means percentage of screen
   */
  public missionCardWidthRatio: number = 0.6;

  /**
   * recentMission list bottom margin percentage
   */
  public mBottomMarginPercentage: number = 0.2;

  /**
   * recentMission list bottom margin percentage
   */
  public mBottomMarginPercentageForMulti: number = 0.17;

  /**
   * appInfo left margin
   */
  public mVerticalAppInfoLeftMargin: number = 12;

  /**
   * appInfo right margin
   */
  public mVerticalAppInfoRightMargin: number = 12;

  /**
   * recent space between title
   */
  public recentSpaceBetweenTitle = 8;

  /**
   * app name size
   */
  public mAppNameSize: number = 16;

  /**
   * app icon size
   */
  public mAppIconSize: number = 24;

  /**
   * lock icon size
   */
  public lockIconSize: number = 24;

  /**
   * lock icon fontsize
   */
  public lockIconFontsize: string = '24vp';

  /**
   * lock icon click hot area size
   */
  public lockIconClickHotAreaSize: number = 40;

  /**
   * lock icon click hot area padding
   */
  public lockIconClickHotAreaPadding: number = 8;

  public static getInstance(): RecentsStyleConfig {
    if (globalThis.RecentsStyleConfig == null) {
      globalThis.RecentsStyleConfig = new RecentsStyleConfig();
    }
    return globalThis.RecentsStyleConfig;
  }
}