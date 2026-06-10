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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DockItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon';
import { CollaborationLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/dock/cache/CollaborationLayoutCacheMgr';
import RecentDockModel from '../model/RecentDockModel';

/**
 * 提供获取当前数据数量的方法，供缩放使用
 */
export class SmartDockItemsVm {

  /**
   * 获取dock区当前总数量
   * @returns
   */
  public getCurrentAllDockItemSize(): number {
    let residentSize = this.getCurrentResidentSize();
    let collaborationSize = this.getCurrentCollaborationSize();
    let recentSize = this.getCurrentRecentSize();
    return residentSize + collaborationSize + recentSize;
  }

  /**
   * 获取当前展示的resident区数据，（resident区暂不考虑接续，若是后期直板机要使用这个方法，需要加入接续逻辑）
   * @returns
   */
  public getCurrentResidentList(): DockItemInfo[] {
    return ResidentLayoutCacheMgr.getInstance().getAllDockItems();
  }

  /**
   * 获取当前展示的resident区数量，（resident区暂不考虑接续，若是后期直板机要使用这个方法，需要加入接续逻辑）
   * @returns
   */
  public getCurrentResidentSize(): number {
    return this.getCurrentResidentList().length;
  }

  /**
   * 获取当前展示的collaboration区可见数据
   * @returns
   */
  public getCurrentCollaborationList(): DockItemInfo[] {
    if (!DeviceHelper.isPad()) {
      return [];
    }
    return CollaborationLayoutCacheMgr.getInstance().getAllDockItems();
  }

  /**
   * 获取当前展示的collaboration区可见数量
   * @returns
   */
  public getCurrentCollaborationSize(): number {
    return this.getCurrentCollaborationList().length;
  }

  /**
   * 获取当前展示的recent区数量
   * @returns
   */
  public getCurrentRecentSize(): number {
    return RecentDockModel.getInstance().getRecentListRotateNum();
  }
}