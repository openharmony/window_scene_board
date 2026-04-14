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