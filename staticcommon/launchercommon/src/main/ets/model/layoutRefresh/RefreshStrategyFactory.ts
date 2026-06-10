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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper, SystemParamUtils } from '@ohos/frameworkwrapper';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { LaunchLayoutCacheManager } from '../../cache/layout/LaunchLayoutCacheManager';
import { AllRefreshStrategy } from './AllRefreshStrategy';
import { MiniBatchRefreshStrategy } from './MiniBatchRefreshStrategy';
import { RefreshStrategy } from './RefreshStrategy';

const TAG = 'RefreshStrategyFactory';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

// 布局刷新方案的阈值，少于该值时使用全量资源获取方式
const ALL_REFRESH_ITEM_COUNT: number = 120;

/**
 * 策略工厂，用于获取对应策略实例
 */
export class RefreshStrategyFactory {
  /**
   * 获取对应策略实例
   *
   * @returns 对应刷新策略实例
   */
  public getStrategy(batchId: number): RefreshStrategy {
    let type: StrategyType = this.getRefreshStrategyType();
    log.showWarn(TAG, 'refreshLayout type: %{public}d, batchId: %{public}d', type, batchId);
    switch (type) {
      case StrategyType.DEF_STRATEGY:
        return new MiniBatchRefreshStrategy(batchId);
      case StrategyType.ALL_STRATEGY:
        return new AllRefreshStrategy(batchId);
      default:
        return new MiniBatchRefreshStrategy(batchId);
    }
  }

  private getRefreshStrategyType(): StrategyType {
    // 方便测试验证两个策略的收益，主干上删除
    let batch_mode = SystemParamUtils.getSystemParam('persist.theme_test.getIconResourceBatch', '1');
    if (batch_mode === '0') {
      return StrategyType.DEF_STRATEGY;
    }
    let gridItems: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllApps();
    if (gridItems.length <= ALL_REFRESH_ITEM_COUNT && !DeviceHelper.isPC() && !DeviceHelper.is2In1DevicePcType()) {
      return StrategyType.ALL_STRATEGY;
    }
    return StrategyType.DEF_STRATEGY;
  }
}

/**
 * 布局刷新策略类型，根据当前桌面布局上控件摆放决定
 */
export enum StrategyType {
  DEF_STRATEGY, // 当图标控件较多时防止从bms和hds获取资源耗时较长,将图标分批逐个刷新
  ALL_STRATEGY, // 当图标控件数量小于120个时,从bms和hds全量获取资源后批量刷新
  BATCH_STRATEGY, // 当图标控件数量小于120个时,从bms和hds全量获取资源后批量刷新,待arkui1.2后实现
}