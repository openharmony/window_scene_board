/**
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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { gestureNavBarCcmSettings } from '@ohos/componenthelper';
import { GestureNavBarConstants } from './constants/CommonConstants';

const TAG = 'GestureNavBarSettings';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class GestureNavBarSettings {
  /**
   * 获取底部导航横屏状态下窗口宽度占屏幕宽度百分比
   *
   * @returns 窗口宽度占屏幕宽度百分比
   */
  public getLandscapeWindowWidthPercent(defaultPercent: number): number {
    let landscapeWindowWidthPercent = gestureNavBarCcmSettings?.getNavBarLandscapeWindowWidthPercent();
    if (!landscapeWindowWidthPercent) {
      return defaultPercent;
    }
    return Number(landscapeWindowWidthPercent);
  }

  /**
   * 获取 导航条距离屏幕底部距离
   *
   * @returns 导航条距离屏幕底部距离
   */
  public getAiBarMarginBottom(): number {
    let aiBarMarginBottom = gestureNavBarCcmSettings?.getAiBarMarginBottom();
    if (!aiBarMarginBottom) {
      return GestureNavBarConstants.AIBAR_DEFAULT_BOTTOM_MARGIN;
    }
    return Number(aiBarMarginBottom);
  }
}

// 单例
export let gestureNavBarSettings: GestureNavBarSettings = SingletonHelper.getInstance(GestureNavBarSettings, TAG);