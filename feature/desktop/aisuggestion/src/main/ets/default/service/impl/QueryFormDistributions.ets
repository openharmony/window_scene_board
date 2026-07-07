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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LaunchLayoutCacheManager, LayoutDescription } from '@ohos/launchercommon';
import type { IExecutor } from '@ohos/launchercommon';
import type { InputFaInfo } from '../../bean/InputFaInfo';
import { LauncherFormDistribution } from '../../bean/LauncherFormDistribution';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';
import { FormDistributions } from '../entity/FormDistributions';

const TAG: string = 'QueryFormDistributions';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 查询特定FA卡片在桌面分布情况
 *
 */
export class QueryFormDistributions implements IExecutor {
  async execute(extra?: object): Promise<string> {
    log.showInfo('execute');
    let results: FormDistributions[] = [];
    const innerFormDistributions: (number | LauncherFormDistribution[] | number[])[] = await Promise.all([
    // 获取默认的 formDistributions
      this.getFormDistribution(extra as InputFaInfo[], false),
      // 假设这个方法可以返回多个屏幕索引
      this.getMainScreenIndex(),
      this.getLayout(false)
    ]);
    this.setResult(innerFormDistributions, results);
    return JSON.stringify(results);
  }

  private setResult(arr: (number | LauncherFormDistribution[] | number[])[], results: FormDistributions[],
    screenType?: string) {
    const formDistributionResult = new FormDistributions();
    formDistributionResult.formDistributions = arr[0] as LauncherFormDistribution[];
    formDistributionResult.mainScreenIndex = arr[1] as number;
    const layoutInfo = arr[2] as number[];
    formDistributionResult.row = layoutInfo[0];
    formDistributionResult.column = layoutInfo[1];
    if (screenType) {
      formDistributionResult.screenType = screenType;
    }
    results.push(formDistributionResult);
  }

  async getLayout(isOuter: boolean): Promise<number[]> {
    const layoutDescription: LayoutDescription =
      LaunchLayoutCacheManager.getInstance().selectLayoutDescription(isOuter);
    return [layoutDescription.row, layoutDescription.column];
  }

  async getMainScreenIndex(): Promise<number> {
    // TODO 获取主屏索引
    return 0;
  }

  private async getFormDistribution(inputFaInfoArr: InputFaInfo[],
    isOuter: boolean): Promise<LauncherFormDistribution[]> {
    return Promise.all(inputFaInfoArr.map(inputFaInfo => AbilityFormUtil.getFormDistributionFromCache(inputFaInfo,
      isOuter)))
      .then(formDistributionsArr => formDistributionsArr.flat())
      .then(formDistributions => {
        log.showInfo('getFormDistribution length: %{public}d, isOuter: %{public}s', formDistributions.length, isOuter);
        return formDistributions;
      });
  }
}