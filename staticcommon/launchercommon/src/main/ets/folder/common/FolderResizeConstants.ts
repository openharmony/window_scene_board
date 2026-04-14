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
import { FolderStyleManager } from '../next/common/FolderStyleManager';

/**
 * 拖拽热区位置
 */
export enum ResizePosition {
  LEFT = 1,
  TOP = 1 << 1,
  RIGHT = 1 << 2,
  BOTTOM = 1 << 3,
  LEFT_TOP = LEFT | TOP,
  RIGHT_TOP = RIGHT | TOP,
  RIGHT_BOTTOM = RIGHT | BOTTOM,
  LEFT_BOTTOM = LEFT | BOTTOM,
  NONE = 0
}

/**
 * 拖拽热区数据
 */
export interface ResizeHotArea {
  offsetX: string;
  offsetY: string;
  width: string | number;
  height: string | number;
  position: ResizePosition;
  /**
   * PanDirection
   */
  dragDirection: number;
  /**
   * Alignment
   */
  alignContent: number;
}

/**
 * 调整大小的配置
 */
export class ResizeConfig {
  public width: number = 0;
  public height: number = 0;
  public row: number = 0;
  public column: number = 0;
  public page: number = 0;
  public offsetX: number = 0;
  public offsetY: number = 0;
  public gapWidth: number = 0;
  public nameTransX: number = 0;
  public nameTransY: number = 0;
  public itemOffsetX: number = 0;
  public itemOffsetY: number = 0;
  public failType: ResizeFailType = ResizeFailType.FAIL_THRESHOLD;
  private _area: number[] = [2, 2];

  public set area(value: number[]) {
    this._area = value;
    this.setGapWidth();
  }

  public get area(): number[] {
    return this._area;
  }

  private setGapWidth(): void {
    this.gapWidth = FolderStyleManager.getInstance().getWidthGap(this._area);
  }
}

export enum ResizeFailType {
  SUCCESS = 0,
  /**
   * 1.当前位置不够放置调整后的尺寸
   */
  FAIL_SPACE = 1,
  /**
   * 2.用户拖动调整的距离未达到改变的阈值
   */
  FAIL_THRESHOLD = 2,
  /**
   * 3.用户调整的尺寸大文件夹不支持
   */
  FAIL_SIZE = 3,
}