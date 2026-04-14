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

import systemDateTime from '@ohos.systemDateTime';
import usageStatistics from '@ohos.resourceschedule.usageStatistics';
import HashMap from '@ohos.util.HashMap';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import lazy { pocketPreferenceUtil } from '@ohos/launchercommon/src/main/ets/utils/PocketPreferenceUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'AppFormWeightManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

const ENTER_RECOMMEND_INTERVAL_DAYS = 1;

/**
 * Card APP Weight Manager Class
 */
export default class AppFormWeightManager {
  private mAppUsageWeight: HashMap<string, number> = new HashMap();
  private mRefreshTime: number = 0;
  private static instance: AppFormWeightManager;

  private constructor() {
  }

  /**
   * getInstance
   *
   * @return Instance 单例
   */
  static getInstance(): AppFormWeightManager {
    if (!AppFormWeightManager.instance) {
      AppFormWeightManager.instance = new AppFormWeightManager();
    }
    return AppFormWeightManager.instance;
  }

  /**
   * 刷新权重
   */
  async refreshUsageWeight(): Promise<void> {
    log.showInfo('refreshUsageWeight');
    if (this.isNeedRefresh()) {
      try {
        log.showInfo('start queryModuleUsageRecords.');
        let moduleInfoArr: Array<usageStatistics.HapModuleInfo> = await usageStatistics.queryModuleUsageRecords();
        this.mAppUsageWeight = new HashMap();
        if (!CheckEmptyUtils.isEmptyArr(moduleInfoArr)) {
          log.showInfo(`moduleInfoArr length=${moduleInfoArr.length}`);
          for (let i: number = 0; i < moduleInfoArr.length; i++) {
            this.mAppUsageWeight.set(moduleInfoArr[i].bundleName, moduleInfoArr[i].launchedCount);
          }
        } else {
          log.showInfo('moduleInfoArr is empty');
        }
      } catch (error) {
        log.showError(`queryModuleUsageRecords throw error, code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  /**
   * 根据传入的权重列表刷新权重 新形态小折叠内屏设置页面调用,非scb主进程.
   *
   * @param moduleInfoMap 权重列表
   * @param refreshTime 刷新时间
   */
  async setUsageWeight(moduleInfoMap: HashMap<string, number>, refreshTime: number): Promise<void> {
    try {
      log.showInfo('start setUsageWeight.');
      if (!moduleInfoMap.isEmpty()) {
        this.mRefreshTime = refreshTime;
        this.mAppUsageWeight = moduleInfoMap;
      } else {
        log.showWarn('setUsageWeight moduleInfoMap empty');
      }
    } catch (error) {
      log.showError(`setUsageWeight throw error, code: ${error.code}, message: ${error.message}`);
    }
  }

  /**
   * 获取app的使用权重.
   *
   * @return app的使用权重.
   */
  getSortedAppUsageWeight(): ((string | number)[]) [] {
    if (this.mAppUsageWeight.length === 0) {
      return new Array();
    }
    let mAppUsageWeightArr = Array.from(this.mAppUsageWeight);
    mAppUsageWeightArr.sort((item1, item2) => {
      return item2[1] - item1[1];
    });
    return mAppUsageWeightArr;
  }

  /**
   * 是否更新数据：时间超过一天，刷新一次
   */
  private isNeedRefresh(): boolean {
    let current: number = systemDateTime.getTime();
    let isNeedRefresh: boolean = false;
    let isIntervalDaysExceedsThreshold: boolean = (current - this.mRefreshTime) >
      NumberConstants.CONSTANT_DAY_TIME_MILLIS * ENTER_RECOMMEND_INTERVAL_DAYS;
    if (isIntervalDaysExceedsThreshold) {
      this.mRefreshTime = current;
      isNeedRefresh = true;
    }
    return isNeedRefresh;
  }
}
