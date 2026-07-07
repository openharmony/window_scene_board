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

import type { GridLayoutItemInfo } from '@ohos/launchercommon';
import { FormLayoutCacheManager, GetHideAppsFromConfig, IExecutor } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import type { InputScreenInfo } from '../../bean/InputScreenInfo';
import { LauncherScreenPageInfo } from '../../bean/LauncherScreenPageInfo';
import { LauncherScreenInfo } from '../../bean/LauncherScreenInfo';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { AiSuggestionDataHelper } from '../../helper/AiSuggestionDataHelper';

const TAG: string = 'QuerySpecifiedScreenInfos';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const DOUBLE_NUM: number = 2;

/**
 * 查询所在屏幕对应的展示信息
 *
 * @since 2023-08-11
 */
export class QuerySpecifiedScreenInfos implements IExecutor {
  async execute(extra?: object): Promise<string> {
    log.showInfo('execute');
    let queryScreenInfo = extra as InputScreenInfo;
    if (!queryScreenInfo || CheckEmptyUtils.isEmptyArr(queryScreenInfo.screenIndexs)) {
      log.showWarn('invalid queryScreenInfo');
      return '';
    }
    log.showInfo(`getSpecifiedScreenInfos screenIndex = ${queryScreenInfo.screenIndexs.toString()}`);
    let screenInfoList = await this.getScreenInfo(queryScreenInfo);
    return JSON.stringify(screenInfoList);
  }

  private async getScreenInfo(queryScreenInfo: InputScreenInfo): Promise<LauncherScreenInfo[]> {
    let screenInfoArr: LauncherScreenInfo[] = [];
    for (let i = 0; i < queryScreenInfo.screenIndexs.length; i++) {
      let screenIndex = queryScreenInfo.screenIndexs[i];
      const curIndexScreenData = await this.getSpecifiedScreenInfos(screenIndex, queryScreenInfo.screenType);
      let launcherScreenInfo = new LauncherScreenInfo();
      launcherScreenInfo.screenIndex = screenIndex;
      launcherScreenInfo.currentScreenInfo = curIndexScreenData;
      if (i === 0) {
        // 在第一个元素中存入隐藏应用数据,语音助手建议会取出隐藏应用的数据去做推荐过滤
        launcherScreenInfo.hideAppList = Array.from(GetHideAppsFromConfig.getInstance().getHideConfig());
      }
      screenInfoArr.push(launcherScreenInfo);
    }
    return screenInfoArr;
  }

  private async getSpecifiedScreenInfos(screenIndex: number, screenType?: String): Promise<LauncherScreenPageInfo> {
    let layoutInfo: GridLayoutItemInfo[] =
      FormLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_CARD,
        screenType === AiSuggestionConstants.EXTERNAL_SCREEN);
    if (!layoutInfo || layoutInfo.length === 0) {
      log.showWarn('getSpecifiedScreenInfos gridLayoutInfo is invalid');
      return new LauncherScreenPageInfo();
    }
    let screenInfo = new LauncherScreenPageInfo();
    const arr =
      await Promise.all([
        AiSuggestionDataHelper.getApps(layoutInfo, screenIndex),
        AiSuggestionDataHelper.getForms(layoutInfo, screenIndex),
        AiSuggestionDataHelper.getDocker(screenType === AiSuggestionConstants.EXTERNAL_SCREEN),
        AiSuggestionDataHelper.getFolders(layoutInfo, screenIndex),
        AiSuggestionDataHelper.getStacks(layoutInfo, screenIndex)
      ]);
    screenInfo.apps = arr[0];
    screenInfo.forms = arr[1];
    screenInfo.docker = arr[2];
    screenInfo.bigFolderList = arr[3];
    screenInfo.stacks = arr[4];
    return Promise.resolve(screenInfo);
  }
}