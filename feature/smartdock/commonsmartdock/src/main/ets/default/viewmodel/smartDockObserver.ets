/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { DockRegionLayoutPropertyVm } from './DockRegionLayoutPropertyVm';

/**
 * dock区observer管理类，获取dock区observer
 */
export class SmartDockObserver {
  private static instance: SmartDockObserver;
  private dockRegionLayoutPropertyVm: DockRegionLayoutPropertyVm = new DockRegionLayoutPropertyVm();

  public static getInstance(): SmartDockObserver {
    if (!SmartDockObserver.instance) {
      SmartDockObserver.instance = new SmartDockObserver();
    }
    return SmartDockObserver.instance;
  }

  /**
   * 获取dock各分区属性的observer
   */
  public getLayoutPropertyVm(): DockRegionLayoutPropertyVm {
    return this.dockRegionLayoutPropertyVm;
  }
}