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

/**
 * 色彩样式类型枚举值
 */
export enum ColorType {
  MULTI_COLOR = 0,
  DARK = 1,
  LIGHT = 2,
};

interface MainColorInterface {
  radius?: number;
  saturation?: number;
  brightness?: number;
  needColor?: string;
  isShadow?: boolean;
  colorType?: ColorType;
  isChangeColor?: boolean;
}

@Observed
export class MainColor {
  public radius?: number;
  public saturation?: number;
  public brightness?: number;
  public needColor?: string;
  public isShadow?: boolean;
  public colorType?: ColorType;
  public isChangeColor: boolean = false;

  constructor(args: MainColorInterface) {
    this.radius = args.radius;
    this.saturation = args.saturation;
    this.brightness = args.brightness;
    this.needColor = args.needColor;
    this.isShadow = args.isShadow;
    this.colorType = args.colorType;
    this.isChangeColor = args.isChangeColor ?? false;
  }
}