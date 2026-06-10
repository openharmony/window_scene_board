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

import { HashMap } from '@kit.ArkTS';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { SCBVisualEffectMgr } from '@ohos/componenthelper/src/main/ets/TsIndex';

const TIME_INTERVAL: number = 8;
/**
 * 用于计算桌面图标解锁动画。
 */
export class SpaceAnimationUtils {
  private static timeMap: HashMap<number, number> = new HashMap();

  private static supportForegroundBlur: boolean | undefined = undefined;

  public static isForegroundEffectSupport(): boolean | undefined {
    if (SCBVisualEffectMgr.isPowerSaveMode()) {
      return false;
    }
    if (SpaceAnimationUtils.supportForegroundBlur === undefined) {
      SpaceAnimationUtils.supportForegroundBlur = systemParameterEnhance.getSync(
        'const.sceneboard.unlock.desktop_foregroundblur_enable', 'false') === 'true';
    }
    return SpaceAnimationUtils.supportForegroundBlur;
  }

  /**
   * 桌面元素进场时序调整，每帧限制进场元素数量，优化性能
   * @param originalTime
   * @param limitPerFrame
   * @returns
   */
  public static calcRealTime(originalTime: number, limitPerFrame: number): number {
    if (Number.isNaN(originalTime)) {
      return originalTime;
    }
    let realTime: number = originalTime;
    if (SpaceAnimationUtils.timeMap.hasKey(originalTime)) {
      let value = SpaceAnimationUtils.timeMap.get(originalTime);
      if (value <= limitPerFrame) {
        SpaceAnimationUtils.timeMap.set(originalTime, value + 1);
      } else {
        realTime = SpaceAnimationUtils.calcRealTime(realTime + TIME_INTERVAL, limitPerFrame);
      }
    } else {
      SpaceAnimationUtils.timeMap.set(realTime, 1);
    }
    return realTime;
  }

  public static resetTimeMap() {
    SpaceAnimationUtils.timeMap.clear();
  }
}