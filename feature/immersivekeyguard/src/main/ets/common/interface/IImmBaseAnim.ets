/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

/**
 * 沉浸锁屏模块动效基类抽象层
 */
export interface IImmBaseAnim {
  /**
   * 动效场景标识
   *
   * @returns 动效标识
   */
  getAnimScene(): string;
}