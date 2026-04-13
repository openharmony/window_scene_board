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

export class ScreenLockSpaceBlurData {
  @Track private _blurRatio: number = 0.0;

  public getBlurRatio(): number {
    return this._blurRatio;
  }

  public setBlurRatio(value: number) {
    this._blurRatio = value;
  }
}

export class ScreenLockSpaceAniData {
  @Track private _spaceOpacity: number = 1;
  @Track private _spaceScale: number = 1;

  public getSpaceOpacity(): number {
    return this._spaceOpacity;
  }

  public setSpaceOpacity(value: number) {
    this._spaceOpacity = value;
  }

  public getSpaceScale(): number {
    return this._spaceScale;
  }

  public setSpaceScale(value: number) {
    this._spaceScale = value;
  }
}

