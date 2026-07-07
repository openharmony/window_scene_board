/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 */

export interface ILiveHeadsUpSwipeVm {
  /**
   * 是否触摸中
   */
  isTouching: boolean;
  /**
   * 开始横滑
   */
  onHorizontalPanStart(event: GestureEvent): void;
  /**
   * 更新横滑
   */
  onHorizontalPanUpdate(event: GestureEvent): void;
  /**
   * 结束横滑
   */
  onHorizontalPanEnd(event: GestureEvent): Promise<void>;
  /**
   * 取消横滑
   */
  onHorizontalPanCancel(): void;
  /**
   * 开始竖滑
   */
  onVerticalPanStart(event: GestureEvent): void;
  /**
   * 更新竖滑
   */
  onVerticalPanUpdate(event: GestureEvent): void;
  /**
   * 结束竖滑
   */
  onVerticalPanEnd(event: GestureEvent): Promise<void>;
  /**
   * 取消竖滑
   */
  onVerticalPanCancel(): void;
}