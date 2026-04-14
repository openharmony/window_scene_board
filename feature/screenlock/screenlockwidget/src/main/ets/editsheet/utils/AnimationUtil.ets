/*
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

import { curves } from '@kit.ArkUI';

/**
 * 动画开始停止回调
 */
export interface AnimationStateListener {
  onAnimationStart: () => void
  onAnimationEnd: () => void;
}

/**
 * 动画工具类
 */
export default class AnimationUtil {
  public static springInterpolator: curves.ICurve = curves.interpolatingSpring(0, 1, 228, 26);
  public static alphaInterpolator: curves.ICurve = curves.cubicBezierCurve(0.4, 0, 0.4, 1);

  public static getInAndOutOpacityEffect(delay?: number): TransitionEffect {
    return TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      delay: delay, duration: 150, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
    }), TransitionEffect.OPACITY.animation({
      duration: 150, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
    }))
  }

  public static getEditToolbarOpacityEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      duration: 200, curve: Curve.Sharp
    }).combine(TransitionEffect.scale({
      x: 0.8, y: 0.8
    }).animation({
      duration: 500, curve: Curve.Friction
    })), TransitionEffect.OPACITY.animation({
      duration: 200, curve: Curve.Sharp
    }))
  }

  public static getBtnInAndOutOpacityEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      duration: 200, curve: Curve.Sharp, delay: 200
    })
      .combine(TransitionEffect.scale({
        x: 0.7, y: 0.7
      })
        .animation({
          duration: 500, curve: Curve.Friction, delay: 200
        })), TransitionEffect.OPACITY.animation({
      duration: 150, curve: Curve.Sharp, delay: 100
    })
      .combine(TransitionEffect.scale({
        x: 0.7, y: 0.7
      }).animation({
        duration: 300, curve: Curve.Friction
      })))
  }

  public static getPickerListItemTransition(index: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({
        y: 50,
      }).animation({
        curve: AnimationUtil.springInterpolator,
        delay: index * 50,
      }),
      TransitionEffect.IDENTITY
    );
  }

  public static getPickerCardTransition(index: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.scale({
        x: 0.8,
        y: 0.8,
      }).animation({
        curve: AnimationUtil.springInterpolator,
        delay: index * 50,
      }),
      TransitionEffect.IDENTITY
    );
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
  public static createAnimateTo(curve: Curve | ICurve, delay: number, duration: number, finish: Function,
                                callback?: AnimationStateListener): void {
    const aniParam: AnimateParam = {
      duration: duration,
      delay: delay,
      onFinish: () => {
        callback?.onAnimationEnd();
      },
      curve: curve
    };
    callback?.onAnimationStart();
    animateTo(aniParam, () => {
      finish();
    })
  }
}