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

const TAG = 'GestureBackCcmSettings';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * Back手势CCM配置
 */
class GestureBackCcmSettings {
  /**
   * 获取CCM配置中Back手势热区宽度
   *
   * @returns CCM配置中，Back手势的热区值
   */
  public getBackResponseRegionWidth(): number | undefined {
    let backResponseRegionWidth: number | undefined =
      SCBGestureNavSetMgr.getGestureNavigationSet()?.backResponseRegionWidth;
    return backResponseRegionWidth;
  }

  /**
   * 获取CCM配置中Back手势识别最小滑动时间
   *
   * @returns
   */
  public getBackTimeThreshold(): number | undefined {
    let backTimeThreshold = SCBGestureNavSetMgr.getGestureNavigationSet()?.backTimeThreshold;
    return backTimeThreshold;
  }

  /**
   * 获取CCM配置中Back手势识别最小滑动距离
   *
   * @returns Back手势识别最小滑动距离
   */
  public getBackDistanceThreshold(): number | undefined {
    let backDistanceThreshold = SCBGestureNavSetMgr.getGestureNavigationSet()?.backDistanceThreshold;
    return backDistanceThreshold;
  }

  /**
   * 获取CCM配置中 是否需要Back手势挤出融球动效
   *
   * @returns 是否需要Back手势挤出融球动效
   */
  public needBackExtrudeAnim(): string | undefined {
    let needBackExtrudeAnim = SCBGestureNavSetMgr.getGestureNavigationSet()?.needBackExtrudeAnim;
    return needBackExtrudeAnim;
  }

  /**
   * 获取CCM配置中 Back融球水平方向跟手阻尼值
   *
   * @returns Back融球跟手阻尼值
   */
  public getBackMetaBallFollowingDampX(): number | undefined {
    let metaBallFollowingDamp = SCBGestureNavSetMgr.getGestureNavigationSet()?.backMetaBallFollowingDampX;
    return metaBallFollowingDamp;
  }

  /**
   * 获取CCM配置中 Back融球垂直方向跟手阻尼值
   *
   * @returns Back融球跟手阻尼值
   */
  public getBackMetaBallFollowingDampY(): number | undefined {
    let metaBallFollowingDamp = SCBGestureNavSetMgr.getGestureNavigationSet()?.backMetaBallFollowingDampY;
    return metaBallFollowingDamp;
  }

  /**
   * 获取CCM配置中Back手势本塞尔曲线完全滑出时滑动距离阈值
   *
   * @returns
   */
  public getBackBezierThreshold(): number | undefined {
    let backBezierThreshold = SCBGestureNavSetMgr.getGestureNavigationSet()?.backBezierThreshold;
    return backBezierThreshold;
  }
}

// 单例
export let gestureBackCcmSettings: GestureBackCcmSettings = SingletonHelper.getInstance(GestureBackCcmSettings, TAG);