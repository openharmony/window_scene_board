/**
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

export default class MultiFingerPinchUtil {
  public scale: number;
  public crossBoundary: boolean;
  public startScale: number;
  public validMinScale: number;
  public validMaxScale: number;
  public scaleThreshold1: number;
  public scaleThreshold2: number;

  constructor(scale: number = 1, crossBoundary: boolean = false, startScale: number = 1,
              validMinScale: number = 0.5, validMaxScale: number = 2,
              scaleThreshold1: number = 0.95, scaleThreshold2: number = 1.02) {
    this.scale = scale;
    this.crossBoundary = crossBoundary;
    this.startScale = startScale;
    this.validMinScale = validMinScale;
    this.validMaxScale = validMaxScale;
    this.scaleThreshold1 = scaleThreshold1;
    this.scaleThreshold2 = scaleThreshold2;
  }
}