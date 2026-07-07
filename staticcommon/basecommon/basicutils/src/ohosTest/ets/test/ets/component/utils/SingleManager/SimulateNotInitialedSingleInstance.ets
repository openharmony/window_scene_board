/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { SingleManager } from '../../../../../../../main/ets/utils/SingleManager';

/**
 * 专门为了测试DT继承的一个未初始化的SingleManager，避免影响SCB主进程
 */
export class SimulateNotInitialedSingleInstance extends SingleManager {
  private static instance: SimulateNotInitialedSingleInstance;

  public static getInstance(): SimulateNotInitialedSingleInstance {
    if (!SimulateNotInitialedSingleInstance.instance) {
      SimulateNotInitialedSingleInstance.instance = new SimulateNotInitialedSingleInstance();
    }

    return SimulateNotInitialedSingleInstance.instance;
  }
}

export let simulateNotInitialedSingleInstance = SimulateNotInitialedSingleInstance.getInstance();