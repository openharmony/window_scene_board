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
import { CommonUtils } from '@ohos/basicutils';

const MAX_VALUE = 1;

/**
 * 跟手常数默认值
 */
const DEFAULT_K = 1.848;

/**
 * 默认最大限度比率
 */
const DEFAULT_MAXIMUM_X = 0.75;

/**
 * 动态跟手率
 */
export class DynamicCurveRate {
  /**
   * 跟手常数
   */
  private coefficient: number;

  /**
   * 最大位移值
   */
  private maxDeltaX: number;

  /**
   * 最大比率
   */
  private maximumX: number;

  /**
   * 构造
   *
   * @param maxDeltaX 最大位移值
   * @param coefficient 跟手常数
   */
  constructor(maxDeltaX: number, coefficient: number = DEFAULT_K) {
    this.maximumX = DEFAULT_MAXIMUM_X;
    this.maxDeltaX = maxDeltaX;
    this.coefficient = coefficient;
  }

  /**
   * 获取动态比率
   *
   * @param start 起始点
   * @param cur 当前点
   * @returns 当前比率
   */
  public getRate(start: number, cur: number): number {
    if (CommonUtils.equals(this.maxDeltaX, 0)) {
      return 0;
    }
    let relativeDelta = Math.abs(cur - start);
    let coeff = relativeDelta / this.maxDeltaX;
    if (coeff > MAX_VALUE) {
      coeff = MAX_VALUE;
    }
    let value = coeff * this.maximumX;
    let rate = Math.exp(-((this.coefficient * value)));
    return rate;
  }

  /**
   * 设置最大位移值
   *
   * @param maxDeltaX 最大值
   * @returns 链式
   */
  public setMaxDeltaX(maxDeltaX: number): DynamicCurveRate {
    this.maxDeltaX = maxDeltaX;
    return this;
  }

  /**
   * 设置跟手常数
   *
   * @param coefficient 常数
   * @returns 链式
   */
  public setK(coefficient: number): DynamicCurveRate {
    this.coefficient = coefficient;
    return this;
  }
}