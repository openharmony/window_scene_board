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

import fs from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils';

/**
 * 动画开始停止回调
 */
export interface AnimationStateListener {
  onAnimationStart?: () => void
  onAnimationEnd?: () => void;
}

export const SANDBOX_THEME_PATH_FLAG_A: string = '/data/themes/a/app/flag';
export const SANDBOX_THEME_PATH_APP_A: string = '/data/themes/a/app';
export const SANDBOX_THEME_PATH_FLAG_B: string = '/data/themes/b/app/flag';
export const SANDBOX_THEME_PATH_APP_B: string = '/data/themes/b/app';
export const THEME_SKIN_BASE: string = '/skin/com.ohos.sceneboard/screenlockcomponent/base/media/';
export const FACE_COMPLETE_BASE_DEFAULT_NAME: string = 'complete_faceID_00.svg';
const EXPECTED_FRAME_RATE_RANGE: ExpectedFrameRateRange = {
  expected: 120,
  min: 120,
  max: 120
};

const TAG: string = 'CommonAnimationUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 动画执行工具类
 */
export class CommonAnimationUtil {
  /**
   * 创建执行动画
   *
   * @param curve 动画曲线
   * @param delay 动画延迟
   * @param duration 动画时长
   * @param finish 刷新动画参数的动画
   * @param callback 动画执行回调
   */
  public static createAnimateTo(curve: Curve | ICurve, delay: number, duration: number | undefined, finish: Function,
    callback?: AnimationStateListener): void {
    const aniParam: AnimateParam = CommonAnimationUtil.prepareAniParam(duration, delay, callback, curve);
    animateTo(aniParam, () => {
      finish();
    })
  }

  private static prepareAniParam(duration: number | undefined, delay: number,
    callback: AnimationStateListener | undefined, curve: Curve | ICurve, shouldKeepFrameRate: boolean = false) {
    let expectedFrameRateRange = shouldKeepFrameRate ? undefined : EXPECTED_FRAME_RATE_RANGE;
    const aniParam: AnimateParam = {
      duration: duration,
      delay: delay,
      expectedFrameRateRange: expectedFrameRateRange,
      onFinish: () => {
        callback?.onAnimationEnd?.();
      },
      curve: curve
    };
    callback?.onAnimationStart?.();
    return aniParam;
  }

  /**
   * 创建执行动画
   *
   * @param curve 动画曲线
   * @param delay 动画延迟
   * @param duration 动画时长
   * @param finish 刷新动画参数的动画
   * @param callback 动画执行回调
   */
  public static createAnimateToImmediately(curve: Curve | ICurve, delay: number, duration: number | undefined,
    finish: Function, callback?: AnimationStateListener): void {
    const aniParam: AnimateParam = CommonAnimationUtil.prepareAniParam(duration, delay, callback, curve);
    animateToImmediately(aniParam, () => {
      finish();
    })
  }

  public static isFileAccessed(themePath: string, fileListPath: string[]): boolean {
    if (fileListPath.length <= 0) {
      return false;
    }
    let isAccessed: boolean = true;
    try {
      fileListPath.forEach((item) => {
        if (!fs.accessSync(themePath + THEME_SKIN_BASE + item)) {
          isAccessed = false;
          return;
        }
      });
    } catch (e) {
      log.showError('Check skin file access failed');
      return false;
    }
    return isAccessed;
  }

  public static getCurrentThemePath(): string | null {
    try {
      if (fs.accessSync(SANDBOX_THEME_PATH_FLAG_A)) {
        return SANDBOX_THEME_PATH_APP_A;
      } else if (fs.accessSync(SANDBOX_THEME_PATH_FLAG_B)) {
        return SANDBOX_THEME_PATH_APP_B;
      }
    } catch (e) {
      log.showError('Check sandbox file access failed');
    }
    return null;
  }

  /**
   * 创建执行动画, 通过此方法使用智能帧率, 避免强制切换为120帧
   *
   * @param curve 动画曲线
   * @param delay 动画延迟
   * @param duration 动画时长
   * @param finish 刷新动画参数的动画
   * @param callback 动画执行回调
   */
  public static createAnimateToWithIntelligentFrame(curve: Curve | ICurve, delay: number,
    duration: number | undefined, finish: Function, callback?: AnimationStateListener): void {
    const aniParam: AnimateParam =
      CommonAnimationUtil.prepareAniParam(duration, delay, callback, curve, true);
    animateTo(aniParam, () => {
      finish();
    })
  }
}