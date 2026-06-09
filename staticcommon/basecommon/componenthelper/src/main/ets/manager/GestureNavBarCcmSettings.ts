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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SCBGestureNavSetMgr } from './SCBGestureNavSetManager';

const TAG = 'GestureNavBarCcmSettings';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 底部导航CCM配置
 */
class GestureNavBarCcmSettings {
  /**
   * 获取 底部导航横屏状态下，默认窗口宽度百分比
   *
   * @returns 导航条距离屏幕底部距离
   */
  public getNavBarLandscapeWindowWidthPercent(): number | undefined {
    let navBarLandscapeWindowWidthPercent: number | undefined =
      SCBGestureNavSetMgr.getGestureNavigationSet()?.navBarLandscapeWindowWidthPercent;
    return navBarLandscapeWindowWidthPercent;
  }

  /**
   * 获取 导航条距离屏幕底部距离
   *
   * @returns 导航条距离屏幕底部距离
   */
  public getAiBarMarginBottom(): number | undefined {
    let aiBarMarginBottom = SCBGestureNavSetMgr.getGestureNavigationSet()?.aiBarMarginBottom;
    return aiBarMarginBottom;
  }
}

// 单例
export let gestureNavBarCcmSettings: GestureNavBarCcmSettings = SingletonHelper.getInstance(GestureNavBarCcmSettings,
  TAG);