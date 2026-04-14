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

/**
 * 数值处理工具
 */
export class NumberUtils {
  static readonly DEFAULT_ACCURACY: number = 0;
  static readonly DEFAULT_ERROR_INFO: string = '';
  static readonly PERCENT_SIGN: string = '%';
  static readonly SLASHES: string = '/';
  static readonly DEFAULT_PERCENTAGE: number = 100;

  static getPercentage(progress?: number, max?: number, isPercent?: boolean): string {
    if (CommonUtils.isInvalid(progress) || CommonUtils.isInvalid(max) || CommonUtils.isInvalid(isPercent) || max === 0) {
      return NumberUtils.DEFAULT_ERROR_INFO;
    }
    if (isPercent) {
      return NumberUtils.getPercentageContent(progress / max, NumberUtils.DEFAULT_ACCURACY);
    } else {
      return NumberUtils.getFractionsContent(progress, max);
    }
  }

  static getPercentageContent(current: number, accuracy?: number): string {
    let percentage = current * NumberUtils.DEFAULT_PERCENTAGE;
    return percentage.toFixed(accuracy ?? NumberUtils.DEFAULT_ACCURACY) + NumberUtils.PERCENT_SIGN;
  }

  static getFractionsContent(progress: number, max: number): string {
    return progress + NumberUtils.SLASHES + max;
  }
}