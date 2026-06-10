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
 * 时钟组件动态状态管理
 */
@Observed
export class SlClockLocateState {
  // 时钟位移距离
  @Track private moveDistance: number = 0;
  // 时钟组件拖拽网格坐标x
  @Track private dragGridX: number = 0;
  // 时钟组件拖拽网格坐标y
  @Track private dragGridY: number = 0;

  public setMoveDistance(distance: number): SlClockLocateState {
    if (this.moveDistance !== distance) {
      this.moveDistance = distance;
    }
    return this;
  }

  public getMoveDistance(): number {
    return this.moveDistance;
  }

  public setDragGridX(x: number): SlClockLocateState {
    if (this.dragGridX !== x) {
      this.dragGridX = x;
    }
    return this;
  }

  public getDragGridX(): number {
    return this.dragGridX;
  }

  public setDragGridY(y: number): SlClockLocateState {
    if (this.dragGridY !== y) {
      this.dragGridY = y;
    }
    return this;
  }

  public getDragGridY(): number {
    return this.dragGridY;
  }
}