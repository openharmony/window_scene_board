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

import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { IconChangeListener } from '../AppModel';
import { RefreshStrategy } from './RefreshStrategy';
import { LogDomain, Logger } from '@ohos/basicutils';
import { dbCache, IconPicType, memoryCache } from '@ohos/frameworkwrapper';
import { LayoutRefreshManager, RefreshViewDataCollection } from './LayoutRefreshManager';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { DataTaskPool } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/fwk/DataTaskPool';
import { DataAndRefreshUtils } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/fwk/DataAndRefreshUtils';

const TAG = 'AllRefreshStrategy';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

// 非同步立即完成的任务数量,全量刷新策略中分批刷新和数据写入不是立即完成所以该值为2
const delay_task_count: number = 2;

/**
 * 用于针对图标控件较少的布局场景刷新策略，会全量获取资源后分批刷新控件
 */
export class AllRefreshStrategy extends RefreshStrategy {
  public async refreshDataAndView(iconChangeListener: IconChangeListener[],
    deliverAppIconInfosMap: Map<string, IconInfo>, allFinished: () => void): Promise<void> {
    iconChangeListener.forEach((listener: IconChangeListener) => {
      if (!listener.bundleName) {
        listener.onIconResourceChange();
      }
    });
    let refreshMgr: LayoutRefreshManager = LayoutRefreshManager.getInstance();
    let collection: RefreshViewDataCollection = refreshMgr.sortLayout(deliverAppIconInfosMap);
    collection.fillingExtraView(iconChangeListener);
    let iconInfos: IconInfo[] = await DataTaskPool.getInstance().startAllRes(deliverAppIconInfosMap, this.getBatchId());
    log.showWarn(TAG, 'refreshDataAndView getData end, size: %{public}d, isCancel: %{public}s', iconInfos.length, this.isCanceled());

    if (this.isCanceled()) {
      // 当此次刷新被取消时,需将之前从bms和hds处获取的图标融合图和双层图标的前后景资源全部删除
      log.showWarn(TAG, 'refreshDataAndView cancel, size: %{public}d', iconInfos.length);
      iconInfos.filter((info: IconInfo) => {
        return info.iconType === IconPicType.NORMAL;
      }).forEach((info: IconInfo) => {
        info.combinePicSrc.release();
      });
      iconInfos.filter((info: IconInfo) => {
        return info.iconType === IconPicType.ADAPTIVE;
      }).forEach((info: IconInfo) => {
        info.combinePicSrc.release();
        info.adaptivePicSrc[0].release();
        info.adaptivePicSrc[1].release();
      });
      GlobalContext.getContext().eventHub.emit(DataAndRefreshUtils.EVENT_STRATEGY_CANCEL_FINISH);
      return;
    }

    if (iconInfos.length === 0) {
      log.showWarn(TAG, 'refreshDataAndView end, size: %{public}d', iconInfos.length);
      allFinished();
      return;
    }

    let finishCount: number = 0;
    let finished: () => void = () => {
      finishCount++;
      log.showWarn(TAG, 'Strategy running, batchId: %{public}d, finishCount: %{public}d', this.getBatchId(), finishCount);
      if (finishCount === delay_task_count) {
        allFinished();
      }
    };
    await memoryCache.setIconResourceArray(iconInfos);
    dbCache.setIconResourceArray(iconInfos, this.getBatchId(), finished);
    log.showWarn(TAG, 'refreshDataAndView iconChangeListener size: %{public}d', iconChangeListener.length);
    refreshMgr.refreshView(iconChangeListener, collection, finished);
  }

  public cancelStrategy(): void {
    log.showWarn(TAG, 'cancel Strategy, batchId: %{public}d', this.getBatchId());
    super.cancelStrategy();
    LayoutRefreshManager.getInstance().cancelRefresh();
    DataTaskPool.getInstance().cancelTask(this.getBatchId());
  }
}


