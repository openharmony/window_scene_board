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
import { RectangularCoordinates } from '@ohos/componenthelper';
import { GravityAnimationConfig } from '../config/GravityAnimationConfig';

const TAG = 'GravityAnimationAlgorithm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 引力方向
 */
export enum ForceType {
  /* 斥力，即力的初始化方向反向于中心点 */
  REPULSION = 0,
  /* 引力，即力的初始化方向朝向于中心点 */
  GRAVITATION = 1,
}

/**
 * 引力动效参数
 *
 * @since 2024/04/20
 */
export interface GravityAnimationParameter {
  /* 当前元素中心点 */
  now: RectangularCoordinates.Point;
  /* 是否受到引力影响，为false时后续参数没有意义 */
  effected: boolean;
  /* 当前元素（中心点）距离引力中心点的距离 */
  distance: number;
  /* 当前元素开始动效的延迟时间 */
  delay: number;
  /* 当前元素引力波动时的波峰点坐标 */
  waveCrest: RectangularCoordinates.Point;
  /* 当前元素引力波动时的波谷点坐标 */
  waveTrough : RectangularCoordinates.Point;
  /* 当前元素引力波动的单次用时 */
  waveDuration: number;
  /* 引力曲线 */
  waveCurve: Curve | ICurve;
  /* 是否距离中心点最远的元素 */
  isFarthest: boolean;
}

/**
 * 引力动效算法类，算法来源于Oscar开放平台的引力模型
 *
 * @since 2024/04/20
 */
export class GravityAnimationAlgorithm {
  private center: RectangularCoordinates.Point = { x: 0, y: 0 };
  private force: ForceType;
  private maxRadiusFactor: number;

  /*
   * 根据中心点落位元素的大小，MaxRadius需要做放大，解决如果仅考虑中心点和其他元素的中心点做引力计算，大尺寸元素和小尺寸元素落位效果一致的。
   * 特别是超大尺寸元素落位，可能周围紧挨着的元素都不能受到引力动效影响了。这个和实际的物理情况是不匹配的，因此添加了这个放大系数。
   * 跟UX联调后，定稿如下。key值是元素‘面积’，value是放大系数。对于1*2和2*1的同'面积'元素来说，放大系数一致。
   *
   * 注意保持有序的形式！
   */
  private static readonly NAX_RADIUS_FACTOR_MAP: Map<number, number> = new Map([
    [1, 1],
    [2, 1.13],
    [4, 1.39],
    [8, 1.93],
    [16, 3.0]]);

  /**
   * 创建引力算法类
   *
   * @param x 引力中心点x
   * @param y 引力中心点y
   * @param force 引力类型
   * @param size 引力元素大小，做放大系数用
   */
  constructor(x: number, y: number, force: ForceType, size: number[]) {
    this.center.x = x;
    this.center.y = y;
    this.force = force;
    this.maxRadiusFactor = this.getMaxRadiusFactor(size);
  }

  private getMaxRadiusFactor(size: number[]): number {
    let factor = GravityAnimationConfig.getMaxRadiusFactor();
    if (factor > 0) {
      log.showDebug('user set MAX-RADIUS-FACTOR parameter, using %{public}d replace', factor);
      return factor;
    }
    let area = size[0] * size[1];
    factor = 1;
    GravityAnimationAlgorithm.NAX_RADIUS_FACTOR_MAP.forEach((value, key) => {
      if (area >= key) {
        factor = value;
      }
    })
    log.showDebug('select factor %{public}d for area %{public}d', factor, area);
    return factor;
  }

  private getMaxRadius(): number {
    return GravityAnimationConfig.getMaxRadius() * this.maxRadiusFactor;
  }

  private isEffected(now: RectangularCoordinates.Point, res: GravityAnimationParameter): void {
    res.distance = RectangularCoordinates.Linear.getDistance(now, this.center);
    res.effected = (res.distance > GravityAnimationConfig.getMinRadius()) &&
      (res.distance < this.getMaxRadius());
  }

  private calcDelayTime(now: RectangularCoordinates.Point, res: GravityAnimationParameter): void {
    res.delay = (res.distance / GravityAnimationConfig.getWaveSpeed());
  }

  private calcWave(now: RectangularCoordinates.Point, res: GravityAnimationParameter): void {
    /* 获取波动距离 */
    let extensionDistance = GravityAnimationConfig.getWaveRangeConstant() * this.getMaxRadius() / res.distance;
    /* 中心点指向坐标点的是波峰最高点。默认小数点4位精度 */
    if (this.force === ForceType.REPULSION) {
      res.waveCrest = RectangularCoordinates.Linear.getPointOnExtensionLine(this.center, now, extensionDistance, 4);
    } else {
      res.waveCrest = RectangularCoordinates.Linear.getPointOnExtensionLine(this.center, now, -extensionDistance, 4);
    }
    /* 波谷目前是回原位 */
    res.waveTrough = now;
    /* 波动时间来自于配置 */
    res.waveDuration = GravityAnimationConfig.getWaveDuration();
  }

  private findNearestDistance(params: Array<GravityAnimationParameter>): GravityAnimationParameter | null {
    let nearest: GravityAnimationParameter | null = null;
    params.forEach((item) => {
      if (!item.effected) {
        return;
      }
      log.showDebug('compare distance %{public}d vs %{public}d', item.distance, nearest?.distance);
      if (!nearest) {
        nearest = item;
        return;
      }

      nearest = (nearest.distance > item.distance) ? item : nearest;
    })

    return nearest;
  }

  private findFarthestItem(params: Array<GravityAnimationParameter>): GravityAnimationParameter | null {
    let farthest: GravityAnimationParameter | null = null;
    params.forEach((item) => {
      if (!item.effected) {
        return;
      }
      log.showDebug('compare distance %{public}d vs %{public}d', item.distance, farthest?.distance);
      if (!farthest) {
        farthest = item;
        return;
      }

      farthest = (farthest.distance < item.distance) ? item : farthest;
    })

    return farthest;
  }

  /**
   * 生成引力结果参数字符串，维测用
   *
   * @param para 生成的引力结果参数
   * @returns 描述字符串
   */
  public parameterToString(para: GravityAnimationParameter): string {
    let effected = para.effected ? 'EFFECTED' : 'UNAFFECTED';
    return 'PARAM [' + effected + ',X:' + para.now.x + ',Y:' + para.now.y + ',DELAY:' +
      para.delay + ',DISTANCE:' + para.distance + ',CX:' + para.waveCrest.x + ',CY:' + para.waveCrest.y + ']';
  }

  /**
   * 生成指定点受引力动效的影响参数
   *
   * @param x 指定点所在屏幕的横坐标vp
   * @param y 指定点所在屏幕的纵坐标vp
   * @param maxRadiusFactor 引力放大系数
   * @returns 引力动效参数
   */
  public generateParameter(x: number, y: number): GravityAnimationParameter {
    let now: RectangularCoordinates.Point = {
      x: x,
      y: y,
    };
    let res: GravityAnimationParameter = {
      now: { x: x, y: y },
      effected: false,
      distance: 0,
      delay: 0,
      waveCrest: { x: 0, y: 0 },
      waveTrough: { x: 0, y: 0 },
      waveDuration: 0,
      waveCurve: GravityAnimationConfig.getCurveConfig(),
      isFarthest: false,
    };

    this.isEffected(now, res);
    if (res.effected) {
      this.calcDelayTime(now, res);
      this.calcWave(now, res);
    }
    return res;
  }

  /**
   * 修正动效参数
   * 引力动效要求最近的元素立刻动效，所以其他元素的动效延迟需要减去这个时间
   * 并且因为要支持动效结束时的动效通知，所以也要知道最远元素
   *
   * @param params 所有引力动效参数集合
   */
  public adjustParameter(params: Array<GravityAnimationParameter>): boolean {
    let farthest = this.findFarthestItem(params);
    if (!farthest) {
      log.showError('cannot find farthest component ?');
      return false;
    }
    farthest.isFarthest = true;

    let nearest: GravityAnimationParameter | null = this.findNearestDistance(params);
    if (!nearest) {
      log.showError('cannot find nearest component ?');
      return false;
    }
    /* 新增临时变量保存最小延迟时间，避免下面的foreach循环直接修改item的delay时间，导致其他item计算错误 */
    let minDelay = nearest.delay;
    log.showInfo('nearest component would run right now, others component delay time should minute %{public}d',
      minDelay);
    params.forEach((item) => {
      if (!item.effected) {
        return;
      }
      log.showDebug('component self-delay is %{public}d', item.delay);
      let diff = item.delay - minDelay;
      if (diff < 0) {
        log.showWarn('strange component, self-delay is %{public}d, less than nearest component', item.delay);
        diff = 0;
      }
      item.delay = diff;
    })

    return true;
  }
}