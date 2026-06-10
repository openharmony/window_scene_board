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
import { gestureBackCcmSettings } from '@ohos/componenthelper';
import { GestureBackConstants } from './GestureBackConstants';

const TAG = 'GestureBackSettings';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * Back手势相关阈值
 */
export class GestureBackSettings {
  /**
   * 获取Back手势热区宽度
   *
   * @returns Back手势的热区值
   */
  public getBackResponseRegionWidth(): number {
    let backResponseRegionWidth = gestureBackCcmSettings?.getBackResponseRegionWidth();
    if (!backResponseRegionWidth) {
      return GestureBackConstants.BACK_WIDTH;
    }
    return Number(backResponseRegionWidth);
  }

  /**
   * 获取Back手势识别最小滑动时间
   *
   * @returns Back手势识别最小滑动时间
   */
  public getBackTimeThreshold(): number {
    let backTimeThreshold = gestureBackCcmSettings?.getBackTimeThreshold();
    if (!backTimeThreshold) {
      return GestureBackConstants.BACK_TIME_THRESHOLD;
    }
    return Number(backTimeThreshold);
  }

  /**
   * 获取Back手势识别最小滑动距离
   *
   * @returns Back手势识别最小滑动距离
   */
  public getBackDistanceThreshold(): number {
    let backDistanceThreshold = gestureBackCcmSettings?.getBackDistanceThreshold();
    if (!backDistanceThreshold) {
      return GestureBackConstants.BACK_DISTANCE_THRESHOLD;
    }
    return Number(backDistanceThreshold);
  }

  /**
   * 是否需要Back手势挤出融球动效
   *
   * @returns 是否需要Back手势挤出融球动效
   */
  public needBackExtrudeAnim(): boolean {
    let needBackExtrude = gestureBackCcmSettings?.needBackExtrudeAnim();
    let needBackExtrudeAnim = !needBackExtrude || needBackExtrude === 'true';
    return needBackExtrudeAnim;
  }

  /**
   * 获取Back融球水平方向跟手阻尼值
   *
   * @returns Back融球垂直方向跟手阻尼值
   */
  public getBackMetaBallFollowingDampX(): number {
    let metaBallFollowingDampX = gestureBackCcmSettings?.getBackMetaBallFollowingDampX();
    if (!metaBallFollowingDampX) {
      return GestureBackConstants.BACK_METABALL_FOLLOWING_DAMP_X;
    }
    return Number(metaBallFollowingDampX);
  }

  /**
   * 获取Back融球垂直方向跟手阻尼值
   * 
   * @returns Back融球垂直方向跟手阻尼值
   */
  public getBackMetaBallFollowingDampY(): number {
    let metaBallFollowingDampY = gestureBackCcmSettings?.getBackMetaBallFollowingDampY();
    if (!metaBallFollowingDampY) {
      return GestureBackConstants.BACK_METABALL_FOLLOWING_DAMP_Y;
    }
    return Number(metaBallFollowingDampY);
  }

  /**
   * 获取Back手势本塞尔曲线完全滑出时滑动距离阈值
   *
   * @returns
   */
  public getBackBezierThreshold(): number {
    let backBezierThreshold = gestureBackCcmSettings?.getBackBezierThreshold();
    if (backBezierThreshold === undefined) {
      return GestureBackConstants.BACK_METABALL_BEZIER_THRESHOLD;
    }
    return Number(backBezierThreshold);
  }
}

// 单例
export let gestureBackSettings: GestureBackSettings = SingletonHelper.getInstance(GestureBackSettings, TAG);