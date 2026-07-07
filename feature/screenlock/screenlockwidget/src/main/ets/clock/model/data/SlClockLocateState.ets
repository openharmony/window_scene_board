/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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