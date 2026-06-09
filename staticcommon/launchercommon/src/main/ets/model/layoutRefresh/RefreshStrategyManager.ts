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

import { DomainName, LogDomain, Logger, TraceUtil } from '@ohos/basicutils';
import { GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { IconChangeListener } from '../AppModel';
import { RefreshStrategy } from './RefreshStrategy';
import { RefreshStrategyFactory } from './RefreshStrategyFactory';
import { UpdateType } from '@ohos/commonconstants';
import EventConstants from '../../constants/EventConstants';
import emitter from '@ohos.events.emitter';
import { DataAndRefreshUtils } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/fwk/DataAndRefreshUtils';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon';

const TAG = 'RefreshStrategyManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 刷新策略管理类,负责刷新策略的执行,避免同一时间内多个策略同时执行导致的数据异常
 * 如当前已有刷新正在执行会进行打断，待上一个刷新被取消后继续执行新的刷新
 */
export class RefreshStrategyManager {
  private static instance: RefreshStrategyManager | null = null;
  private strategyFac: RefreshStrategyFactory = new RefreshStrategyFactory();
  private currentRunningStrategy?: RefreshStrategy;
  private batchId: number = 0;

  public static getInstance(): RefreshStrategyManager {
    if (!RefreshStrategyManager.instance) {
      RefreshStrategyManager.instance = new RefreshStrategyManager();
    }
    return RefreshStrategyManager.instance;
  }

  /**
   * 资源变化时刷新布局
   *
   * @param iconChangeListener 需要通知刷新的监听
   * @param deliverAppIconInfosMap DH应用列表
   */
  public async refreshLayout(iconChangeListener: IconChangeListener[],
    deliverAppIconInfosMap: Map<string, IconInfo>): Promise<void> {
    if (this.currentRunningStrategy) {
      this.cancelRunningStrategy(iconChangeListener, deliverAppIconInfosMap);
      return;
    }
    this.batchId++;
    log.showWarn(TAG, 'refreshLayout start, batchId: %{public}d', this.batchId);
    let allFinished: () => void = () => {
      log.showWarn(TAG, 'refreshLayout end, batchId: %{public}d', this.batchId);
      this.currentRunningStrategy = undefined;
    };
    PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_THEME_CHANGE);
    TraceUtil.startTrace(DomainName.HOME, 'theme_refresh_layout');
    this.currentRunningStrategy = this.strategyFac.getStrategy(this.batchId);
    await this.currentRunningStrategy.refreshDataAndView(iconChangeListener, deliverAppIconInfosMap, allFinished);
    TraceUtil.endTrace(DomainName.HOME, 'theme_refresh_layout');
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_THEME_CHANGE);

    if (this.currentRunningStrategy?.isCanceled()) {
      log.showWarn(TAG, 'refreshLayout canceled, cancel batchId: %{public}d', this.batchId);
      return;
    }
    localEventManager.sendLocalEvent(EventConstants.EVENT_REFRESH_ALL_SMALL_FOLDER_IMAGE, null);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_ICON_RESOURCE_REFRESH, {
      type: UpdateType.FULL,
      bundleNames: null
    });
    log.showWarn(TAG, `emit ${EventConstants.EVENT_FINISH_SWITCH_APP_ICON}`);
    // 向主题发送桌面图标刷新完成事件
    emitter.emit(EventConstants.EVENT_FINISH_SWITCH_APP_ICON, { priority: emitter.EventPriority.IMMEDIATE });
  }

  private cancelRunningStrategy(iconChangeListener: IconChangeListener[],
    deliverAppIconInfosMap: Map<string, IconInfo>): void {
    if (!this.currentRunningStrategy?.isCanceled()) {
      log.showWarn(TAG, 'refreshLayout is running, cancel batchId: %{public}d',
        this.currentRunningStrategy?.getBatchId());
      GlobalContext.getContext().eventHub.on(DataAndRefreshUtils.EVENT_STRATEGY_CANCEL_FINISH, () => {
        this.currentRunningStrategy = undefined;
        GlobalContext.getContext().eventHub.off(DataAndRefreshUtils.EVENT_STRATEGY_CANCEL_FINISH);
        this.refreshLayout(iconChangeListener, deliverAppIconInfosMap);
      });
      this.currentRunningStrategy?.cancelStrategy();
    } else {
      log.showWarn(TAG, 'refreshLayout being canceled, cancel batchId: %{public}d',
        this.currentRunningStrategy.getBatchId());
    }
  }
}