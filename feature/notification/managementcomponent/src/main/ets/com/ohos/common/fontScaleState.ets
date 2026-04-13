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

@Observed
export class FontScaleState {
  public static systemUIMaxScale: number = 2;
  /**
   * 系统fp字体扩大倍数
   */
  public fontSizeScale: number = 1;

  /**
   * 获取字体、行高使用大小（vp）
   */
  public getScaleSize(font: Resource | number): string {
    if (typeof font === 'number') {
      return font * this.getFontScale() + 'vp';
    }

    return LengthMetrics.resource(font).value * this.getFontScale() + 'vp';
  }

  /**
   * 获取字体放大倍数（systemUI限制在2倍）
   */
  public getFontScale(): number {
    return Math.min(FontScaleState.systemUIMaxScale, this.fontSizeScale);
  }
}