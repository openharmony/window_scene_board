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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';

const TAG = 'SCBRecentAnimation';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentAnimation {
  private exitChainAnimationDuration: number = SCBRecentStyleConstants.RECENT_EXIT_CHAIN_ANIMATION_DURATION;
  private _recentExitBackgroundDuration: number = SCBRecentStyleConstants.RECENT_BACKGROUND_HIDE_TIME;
  private _recentExitBackgroundAnimationCurve: ICurve = SCBRecentStyleConstants.RECENT_BACKGROUND_HIDE_ANIMATION_CURVE;

  /**
   * 获取任务中心退出时后台窗口动效时长
   */
  public getExitChainAnimationDuration(): number {
    log.showDebug(`getExitChainAnimationDuration ${this.exitChainAnimationDuration}`);
    return this.exitChainAnimationDuration;
  }

  /**
   * 获取任务中心退出时背板动效时长
   */
  public get recentExitBackgroundDuration(): number {
    return this._recentExitBackgroundDuration;
  }

  /**
   * 获取任务中心退出时背板动效曲线
   */
  public get recentExitBackgroundAnimationCurve(): ICurve {
    return this._recentExitBackgroundAnimationCurve;
  }
}