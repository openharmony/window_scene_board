/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { RecentsStyleConfig } from '@ohos/recents/src/main/ets/default/common/RecentsStyleConfig';

/**
 * Recents layout style on pc
 */
export default class PcRecentsStyleConfig extends RecentsStyleConfig {

  /**
   * width of appImage snapshot, < 1 means percentage of screen
   */
  public mAppImageWidth: number | string = 282;

  /**
   * height of appImage snapshot, < 1 means percentage of screen
   */
  public mAppImageHeight: number = 0.165;

  /**
   * height of MissionCard, < 1 means percentage of screen
   */
  public mMissionCardHeight: number | string = 214;

  /**
   * layout weight of appInfo
   */
  public mAppInfoLayoutWeight: number = 2;

  /**
   * recentMission list bottom margin percentage
   */
  public mBottomMarginPercentage: number = 0.2;

  /**
   * appInfo bottom margin
   */
  public mAppInfoTopMargin: number = 4;

  /**
   * appInfo bottom margin
   */
  public mAppInfoBottomMargin: number = 8;

  /**
   * appInfo left margin
   */
  public mVerticalAppInfoLeftMargin: number = 8;

  /**
   * appInfo right margin
   */
  public mAppInfoRightMargin: number = 12;

  /**
   * app name size
   */
  public mAppNameSize: number = 16;

  /**
   * app icon size
   */
  public mAppIconSize: number = 32;

  /**
   * card margin
   */
  public mCardMargin: number = 48;

  /**
   * app name margin
   */
  public mAppNameMargin: number = 8;

  /**
   * whether to show lock icon image
   */
  public mIsShowLockImage: boolean = false;

  /**
   * whether to show delete icon image
   */
  public mIsShowDeleteImage: boolean = true;

  /**
   * whether to rotate appImage snapshot when orientation changes
   */
  public mIsRotateSnapshot: boolean = false;

  /**
   * Maximum height of the mission card
   */
  public mCardMaxHeight: number = 0.52;

  /**
   * Minimum height of the task card
   */
  public mCardMinHeight: number = 0.34;

  /**
   * Width of the available area of the PC, 0.09 * 2
   */
  public mPcUsableWidth: number = 0.82;

  /**
   * Size of the application information button
   */
  public mAppInfoButtonSize: number = 24;

  /**
   * appInfo total height
   */
  public mAppInfoHeight: number = this.mAppIconSize + this.mAppInfoTopMargin + this.mAppInfoBottomMargin;

  /**
   * Right side margin of scroll bar
   */
  public scrollBarMarginRight: number = 48;

  /**
   * Right side margin of scroll bar
   */
  public topGraduallyHideAreaHeight: number = 60;


  /**
   * Right side margin of scroll bar
   */
  public bottomGraduallyHideAreaHeight: number = 0.1;

  static getInstance(): PcRecentsStyleConfig {
    if (globalThis.PcRecentsStyleConfig == null) {
      globalThis.PcRecentsStyleConfig = new PcRecentsStyleConfig();
    }
    return globalThis.PcRecentsStyleConfig;
  }
}