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
 * 堆叠数据
 */
@Observed
export class StackData {
  private _radius: number = 0;

  private _name: string = '';

  private _width: number = 0;

  private _height: number = 0;

  private _size: number = 0;

  private _formRatio: number = 0;

  public set formRatio(value: number) {
    this._formRatio = value;
  }

  public get formRatio(): number {
    return this._formRatio;
  }

  public set size(value: number) {
    this._size = value;
  }

  public get size(): number {
    return this._size;
  }

  public set name(value: string) {
    this._name = value;
  }

  public get name(): string {
    return this._name;
  }

  public set radius(value: number) {
    this._radius = value;
  }

  public get radius(): number {
    return this._radius;
  }

  public set width(value: number) {
    this._width = value;
  }

  public get width(): number {
    return this._width;
  }

  public set height(value: number) {
    this._height = value;
  }

  public get height(): number {
    return this._height;
  }
}