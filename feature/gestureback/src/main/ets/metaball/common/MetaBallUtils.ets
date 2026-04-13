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

import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureBackConstants } from '../../common/GestureBackConstants';

/**
 * metaball工具类
 */
export class MetaBallUtils {
  /**
   * 计算媒体球曲率
   * @param distance 手指移动距离
   * @returns 媒体球曲率
   */
  public static calculateAnimProcess(distance: number): number {
    const backQuickChangeMaxDistance: number = GestureBackConstants.GESTURE_NAVIGATION_BACK_QUICK_CHANGE_MAX_DISTANCE;
    const backSlowChangeMaxDistance: number = GestureBackConstants.GESTURE_NAVIGATION_BACK_SLOW_CHANGE_MAX_DISTANCE;
    const backAnimMaxRatio: number = StyleConstants.GESTURE_NAVIGATION_BACK_ANIM_MAX_RATIO;
    if (distance < backQuickChangeMaxDistance) {
      const process = (distance / backQuickChangeMaxDistance) * backAnimMaxRatio;
      return Math.max(StyleConstants.GESTURE_NAVIGATION_BACK_ANIM_MIN_RATIO, process);
    } else {
      let rubber: number = distance - backQuickChangeMaxDistance;
      if (backSlowChangeMaxDistance !== backQuickChangeMaxDistance) {
        rubber = rubber / (backSlowChangeMaxDistance - backQuickChangeMaxDistance);
      }
      if (rubber > 1) {
        return 1;
      } else if (rubber < 0) {
        return backAnimMaxRatio;
      } else {
        return rubber * (1 - backAnimMaxRatio) + backAnimMaxRatio;
      }
    }
  }

  /**
   * 给媒体球画线
   * @param isLeftGesture 是否左滑
   * @param process
   * @param startY 媒体球曲线起始点Y值
   * @param context
   * @returns 媒体球移动距离
   */
  public static drawMetaBall(isLeftGesture: boolean, process: number, startY: number,
                             context: CanvasRenderingContext2D): number {
    context.clearRect(0, 0, context.width, context.height);
    context.lineWidth = 1;
    let stepDouble: number = 2;
    let startX: number = 0;
    if (!isLeftGesture) {
      stepDouble = -2;
      startX = context.width;
    }
    let lineX: number = startX;
    context.moveTo(lineX, startY);
    context.scale(1 / 6, 1 / 6);
    context.translate(startX * 5, startY * 6);
    let regionUp = new Path2D();
    let regionDown = new Path2D();
    regionUp.moveTo(lineX, 0);
    regionDown.moveTo(lineX, 0);
    let lineToCount: number = 500;
    let skipCount: number = 0;
    for (let x = -1; x <= 0; x += 1 / 500) {
      let metaBallHeight: number = MetaBallUtils.getMetaBallHeight(x, process);
      if (metaBallHeight < 0) {
        regionUp.lineTo(lineX, 0);
        regionDown.lineTo(lineX, 0);
        lineToCount = Math.round((x + 1) * 500);
        break;
      }
      const lineY: number = Math.sqrt(metaBallHeight) * 1000;

      // 绘制次数减半，减少`lineTo`绘制时间
      if ((skipCount & 1) === 0) {
        regionUp.lineTo(lineX, -lineY);
        regionDown.lineTo(lineX, lineY);
      }

      lineX += stepDouble;
      skipCount++;
    }
    regionUp.moveTo(startX, 0);
    regionUp.closePath();
    regionDown.moveTo(startX, 0);
    regionDown.closePath();
    context.fill(regionUp);
    context.fill(regionDown);
    context.translate(-startX * 5, -startY * 6);
    context.scale(6, 6);
    return lineToCount / 5 + 3;
  }

  /*
  * 计算媒体球x对应位置的y值
  */
  private static getMetaBallHeight(x: number, process: number): number {
    let temporaryParam: number = x * x - 0.05;
    if (process > 0.55) {
      temporaryParam = temporaryParam - 0.1 * (process - 0.55) / 0.45;
    }
    return (0.01 / (1.0 - temporaryParam)) - Math.pow((x + 1.35 - 0.5 * process), 2);
  }

  /**
   * 计算媒体球内箭头暴露的部分
   * @param process
   * @returns 媒体球内箭头暴露多少
   */
  public static calculateAlpha(process: number): number {
    if (process >= 0.55) {
      return 1
    } else if (process < 0.275) {
      return 0
    } else {
      return (process - 0.275) / 0.275
    }
  }

  /**
   * 计算媒体球内箭头的目标位置
   * @param distance 手指移动距离
   * @param isLeftGesture 是否左滑
   * @param screenWidth 屏幕宽度
   * @param imgWidth 箭头宽度
   * @returns 箭头的目标位置
   */
  public static calculateArrowImgTranslateX(distance: number,
                                            isLeftGesture: boolean,
                                            screenWidth: number,
                                            imgWidth: number): number {
    const dis: number = MetaBallUtils.calculateArrowMoveX(distance);
    if (isLeftGesture) {
      return -imgWidth + dis;
    } else {
      return px2vp(screenWidth) - dis;
    }
  }

  private static calculateArrowMoveX(distance: number): number {
    if (distance < GestureBackConstants.ARROW_MOVE_QUICK_MAX_DISTANCE) {
      return (distance + GestureBackConstants.ARROW_MOVE_QUICK_MAX_DISTANCE) / 2;
    } else {
      return distance;
    }
  }
}