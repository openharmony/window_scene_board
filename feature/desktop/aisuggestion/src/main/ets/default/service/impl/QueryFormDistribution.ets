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
import type { IExecutor } from '@ohos/launchercommon';
import { LaunchLayoutCacheManager, LayoutDescription } from '@ohos/launchercommon';
import type { InputFaInfo } from '../../bean/InputFaInfo';
import { LauncherFormDistribution } from '../../bean/LauncherFormDistribution';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';

const TAG: string = 'QueryFormDistribution';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 查询特定FA卡片在桌面分布情况
 *
 * @since 2023-08-11
 */
export class QueryFormDistribution implements IExecutor {
  async execute(extra?: object): Promise<string> {
    log.showInfo('execute');
    const arr: (number | LauncherFormDistribution[] | number[])[] = await Promise.all([
      this.getFormDistribution(extra as InputFaInfo[]),
      this.getMainScreenIndex(),
      this.getLayout()
    ]);
    const formDistributions = arr[0];
    const mainScreenIndex = arr[1];
    const layoutInfo = arr[2] as number[];
    return JSON.stringify({
      formDistributions,
      mainScreenIndex,
      row: layoutInfo[0],
      column: layoutInfo[1]
    });
  }

  async getLayout(): Promise<number[]> {
    const layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    return [layoutDescription.row, layoutDescription.column];
  }

  async getMainScreenIndex(): Promise<number> {
    // TODO 获取主屏索引
    return 0;
  }

  private async getFormDistribution(inputFaInfoArr: InputFaInfo[]): Promise<LauncherFormDistribution[]> {
    return Promise.all(inputFaInfoArr.map(inputFaInfo => AbilityFormUtil.getFormDistributionFromCache(inputFaInfo)))
      .then(formDistributionsArr => formDistributionsArr.flat())
      .then(formDistributions => {
        log.showInfo('getFormDistribution length: %{public}d', formDistributions.length);
        return formDistributions;
      });
  }
}