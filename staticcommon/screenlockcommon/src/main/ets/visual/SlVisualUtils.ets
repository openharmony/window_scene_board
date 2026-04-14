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
import effectKit from '@ohos.effectKit';
import { WallpaperConstants } from '@ohos/commonconstants';
import CommonConstants from '../constants/CommonConstants';

/**
 * 锁屏纯色计算工具类
 */
export class SlVisualSolidUtils {
  /**
   * 将计算的小数坐标转换为整数
   *
   * @param posT 小数坐标
   * @returns 标准化的整数坐标
   */
  static getStandPos(posT: number): number {
    return Math.floor(posT * CommonConstants.TOTAL_MULTIPLES);
  }

  /**
   * 将两个位置的等比例放大后，当二者的差值小于一定范围，则认定这两个坐标的位置是相似的
   *
   * @param oldCoordinates 范围[0,1]
   * @param newCoordinates 范围[0,1]
   * @returns true 坐标发生变化
   */
  static hasChanged(oldCoordinates: number, newCoordinates: number): boolean {
    let standOld = SlVisualSolidUtils.getStandPos(oldCoordinates);
    let standNew = SlVisualSolidUtils.getStandPos(newCoordinates);
    return Math.abs(standOld - standNew) > CommonConstants.MAX_DIFFERENCE;
  }

  /**
   * 检查对应区域的坐标是否发生变化；
   * 坐标变化大于一定阈值才判定区域坐标发生变化，返回true,供调用方触发背景颜色计算；
   * 进而减少频繁的背景颜色计算和组件颜色刷新，提升性能，降低负载
   *
   * @param oldPosition 组件旧的位置
   * @param newPosition 组件新的位置
   * @returns true 判定坐标已经发生变化
   */
  static checkAreaChange(oldPosition: number[], newPosition: number[]): boolean {
    if (!SlVisualSolidUtils.checkPositionParam(oldPosition, newPosition)) {
      return true;
    }

    for (let i = 0; i < CommonConstants.POSITION_ARR_LENGTH; i++) {
      if (SlVisualSolidUtils.hasChanged(oldPosition[i], newPosition[i])) {
        return true;
      }
    }

    return false;
  }

  static checkPositionParam(oldPosition: number[], newPosition: number[]): boolean {
    return Array.isArray(oldPosition) && Array.isArray(newPosition) &&
      oldPosition.length < CommonConstants.POSITION_ARR_LENGTH &&
      newPosition.length < CommonConstants.POSITION_ARR_LENGTH;
  }

  /**
   * 颜色值转字串
   *
   * @param color 颜色值
   * @returns 字串颜色
   */
  static getColorString(color?: effectKit.Color): string {
    if (!color) {
      return '';
    }
    let red = SlVisualSolidUtils.toNumber16(color.red);
    let green = SlVisualSolidUtils.toNumber16(color.green);
    let blue = SlVisualSolidUtils.toNumber16(color.blue);
    return `${WallpaperConstants.COLOR_PREFIX}${red}${green}${blue}`;
  }

  /**
   * 颜色值转16进制字串
   *
   * @param color 颜色值
   * @returns 16进制字串
   */
  static toNumber16(color: number): string {
    return color?.toString(WallpaperConstants.NUMBER_16)
      .padStart(WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
  }
}