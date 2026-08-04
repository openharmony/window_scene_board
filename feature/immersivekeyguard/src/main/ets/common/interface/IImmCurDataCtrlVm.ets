/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

/**
 * 当前沉浸态数据控制
 */
export interface IImmCurDataCtrlVm {
  /**
   * 设置当前显示的沉浸大卡数据
   *
   * @param groupKey 通知数据唯一标识
   */
  setCurImmCardData(groupKey?: string): void;
}