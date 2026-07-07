/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

/**
 * 沉浸模块生命周期业务抽象层
 */
export interface IImmLifeCycleVm {
  /**
   * 初始化
   */
  init(): void;

  /**
   * 资源回收
   */
  destroy(): void;
}

// 生命周期业务集
export class IImmLifeCycleVmArray extends Array<IImmLifeCycleVm> {
}