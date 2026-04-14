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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'GlassLayoutManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export interface Rect {
  left?: number;
  top?: number;
  width?: number;
  height?: number;
}

@Observed
export class SceneRect {
  public left: number = 0;
  public top: number = 0;
  public width: number = 0;
  public height: number = 0;

  public refreshRect(sceneRect?: SceneRect): void {
    if (sceneRect === undefined) {
      return;
    }
    this.left = sceneRect.left;
    this.top = sceneRect.top;
    this.width = sceneRect.width;
    this.height = sceneRect.height;
  }

  public stringify(): string {
    return `left: ${this.left}, top: ${this.top}, width: ${this.width}, height:${this.height}`;
  }
}

export class GlassLayoutManager {
  private static instance?: GlassLayoutManager;
  private screenWidthPx: number = 0;
  private screenHeightPx: number = 0;

  private constructor() {
  }

  public static getInstance(): GlassLayoutManager {
    if (!GlassLayoutManager.instance) {
      GlassLayoutManager.instance = new GlassLayoutManager();
    }
    return GlassLayoutManager.instance;
  }

  public onScreenAttrChange(screenWidthPx: number, screenHeightPx: number): void {
    this.screenWidthPx = screenWidthPx;
    this.screenHeightPx = screenHeightPx;
  }

  public getScreenWidthPx(): number {
    log.showInfo(`getScreenWidthPx is ${this.screenWidthPx}`);
    return this.screenWidthPx;
  }

  public getScreenHeightPx(): number {
    log.showInfo(`getScreenHeightPx is ${this.screenHeightPx}`);
    return this.screenHeightPx;
  }

  public static destroy(): void {
    GlassLayoutManager.instance = undefined;
  }
}