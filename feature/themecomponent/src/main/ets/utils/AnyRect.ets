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

export interface AnyRectInterface {
  x: number,
  y: number,
  width: number,
  height: number,
  ratio?: number,
}

@Observed
export class AnyRect {
  public x: number;
  public y: number;
  public width: number;
  public height: number;
  public ratio: number;

  constructor(params?: AnyRectInterface) {
    this.x = params?.x ?? -1;
    this.y = params?.y ?? -1;
    this.width = params?.width ?? 0;
    this.height = params?.height ?? 0;
    this.ratio = params?.ratio ?? 1.0;
  }

  public toString(): string {
    return `x=${this.x}, ` +
      `y=${this.y}, ` +
      `width=${this.width}, ` +
      `height=${this.height}, ` +
      `ratio=${this.ratio}, `;
  }
}