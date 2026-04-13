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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { AppIconDynamicShadowData } from './AppIconDynamicShadowData';

const DOCK_ITEM_SHADOW_OFFSET_ONE: number = 1;
const ITEM_SHADOW_RADIUS: number = 5;
const ITEM_SHADOW_COLOR: string = '#26000000';

export class AppIconDynamicShadowViewModel {
  private appIconDynamicShadowData: AppIconDynamicShadowData;

  constructor(viewData: AppIconDynamicShadowData) {
    this.appIconDynamicShadowData = viewData;
  }

  public init(): void {
    this.appIconDynamicShadowData.radius = ITEM_SHADOW_RADIUS;
    this.appIconDynamicShadowData.offsetX = 0;
    this.appIconDynamicShadowData.offsetY = DOCK_ITEM_SHADOW_OFFSET_ONE;
    this.appIconDynamicShadowData.color = ITEM_SHADOW_COLOR;
  }

  public update(radius: number, offsetX: number, offsetY: number, color: string = ''): void {
    this.appIconDynamicShadowData.radius = radius;
    this.appIconDynamicShadowData.offsetX = offsetX;
    this.appIconDynamicShadowData.offsetY = offsetY;
    if (!CheckEmptyUtils.checkStrIsEmpty(color)) {
      this.appIconDynamicShadowData.color = color;
    }
  }
}