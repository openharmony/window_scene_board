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

import { LengthMetrics } from '@kit.ArkUI';

const numberRegex = /^-?\d+(\.\d+)?$/;

export class LengthMetricsUtil {
  public static Length2LengthMetrics(length: Length | undefined): LengthMetrics | undefined {
    if (!length) {
      return undefined;
    }
    if (typeof length === 'string') {
      if (length.includes('vp')) {
        const value = Number(length.slice(0, -2));
        if (isNaN(value) || !isFinite(value)) {
          return undefined;
        }
        return LengthMetrics.vp(value);
      } else if (length.includes('px')) {
        const value = Number(length.slice(0, -2));
        if (isNaN(value) || !isFinite(value)) {
          return undefined;
        }
        return LengthMetrics.px(value);
      } else if (numberRegex.test(length)) {
        const value = Number(length);
        if (isNaN(value) || !isFinite(value)) {
          return undefined;
        }
        return LengthMetrics.vp(value);
      } else {
        return undefined;
      }
    } else if (typeof length === 'number') {
      return LengthMetrics.vp(length);
    } else {
      return LengthMetrics.resource(length as Resource);
    }
  }
}