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

/**
 * 笛卡尔坐标系（平面直角坐标系）命名空间
 *
 * @since 2024/04/13
 */
namespace CartesianCoordinates {
  /**
   * 二维坐标点
   *
   * @since 2024/04/13
   */
  export interface Point {
    x: number;
    y: number;
  }

  /**
   * 直线计算工具
   *
   * @since 2024/4/13
   */
  export class Linear {
    private static round(value: number, accuracy: number): number {
      return Math.round(value * Math.pow(10, accuracy)) / Math.pow(10, accuracy);
    }

    /**
     * 获取两点延长线上的指定长度所在点坐标
     *
     * @param starter 直线开始点坐标
     * @param ender 直线结束点坐标
     * @param extensionLength 开始点向结束点延长的距离
     * @returns 延长线上距离点的坐标
     */
    public static getPointOnExtensionLine(starter: Point, ender: Point, extensionLength: number,
                                          accuracy: number = 6): Point {
      let res: Point = { x: 0, y: 0};
      let roundStart = { x: this.round(starter.x, accuracy), y: this.round(starter.y, accuracy) };
      let roundEnder = { x: this.round(ender.x, accuracy), y: this.round(ender.y, accuracy) };
      /*
       * 假设starter是x1y1, ender是x2y2，两点距离则为r1，求指定长度r2延长线上的一点xy，基于如下两个公式求解
       * 1. (x2 - x1)   (x  - x2)
       *    ————————— = ————————— = k
       *    (y2 - y1)   (y  - y2)
       *
       * 2. (x2 - x1)   r2
       *    ————————— = ——
       *    (x  - x2)   r1
       */
      let r1 = this.getDistance(roundEnder, roundStart);
      let r2 = extensionLength;
      if (roundEnder.x === roundStart.x) {
        res.x = roundEnder.x;
        res.y = (r2 * (roundEnder.y - roundStart.y) / r1) + roundEnder.y;
      } else {
        res.x = (r2 * (roundEnder.x - roundStart.x) / r1) + roundEnder.x;
        res.y = ((res.x - roundEnder.x) * (roundEnder.y - roundStart.y) / (roundEnder.x - roundStart.x)) + roundEnder.y;
      }
      res.x = this.round(res.x, accuracy);
      res.y = this.round(res.y, accuracy);

      return res;
    }

    /**
     * 计算两点间的距离
     *
     * @param a 两点之一的坐标点
     * @param b 两点之一的坐标点
     * @returns 两点间的距离
     */
    public static getDistance(a: Point, b: Point): number {
      return Math.sqrt(Math.pow((a.x - b.x), 2) + Math.pow((a.y - b.y), 2));
    }
  }
}

export default CartesianCoordinates;