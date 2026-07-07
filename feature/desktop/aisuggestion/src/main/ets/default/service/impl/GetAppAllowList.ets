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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AppItemInfo, AppModel, IExecutor } from '@ohos/launchercommon';
import lazy { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';

const TAG = 'GetAppAllowList';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议查询外屏信任名单参数
 *
 * @since 2025-03-11
 */
export class MessageOption {
  screenType: string = '';

  /**
   * 服务侧推荐服务包名列表
   * 为空时，桌面返回所有白名单
   * 不为空时，桌面取交集返回
   */
  checkBundleNames?: string[];
}

/**
 * 语音助手建议查询外屏应用信息
 *
 * @since 2025-03-11
 */
export class AppInfo {
  bundleName: string;

  constructor(bundleName: string) {
    this.bundleName = bundleName;
  }
}

/**
 * 语音助手建议查询外屏信任名单
 *
 * @since 2025-03-11
 */
export class GetAppAllowList implements IExecutor {
  async execute(extra?: object): Promise<string> {
    log.showInfo('execute');

    const messageOption = extra as MessageOption;
    if (messageOption?.screenType === AiSuggestionConstants.EXTERNAL_SCREEN) {
      const appList = await this.getWhitelist(messageOption.checkBundleNames);
      return JSON.stringify(appList);
    }
    return JSON.stringify([{}]);
  }

  private async getWhitelist(checkBundleNames?: string[]): Promise<AppInfo[]> {
    const layoutInfoList: AppItemInfo[] = AppModel.getInstance().getAppList() ?? [];
    const uniqueBundle = new Set<string>();
    let outerAllowList = layoutInfoList.filter(Boolean).filter((layoutInfo) => {
      uniqueBundle.add(layoutInfo.bundleName);
      return true;
    }).map((layoutInfo: AppItemInfo) => new AppInfo(layoutInfo.bundleName));

    log.showInfo(`GetAppAllowList before = ${outerAllowList.length}_${checkBundleNames?.length}`);
    if (!CheckEmptyUtils.isEmptyArr(checkBundleNames)) {
      const checkSet = new Set(checkBundleNames);
      outerAllowList = outerAllowList.filter(appInfo => checkSet.has(appInfo.bundleName));
    }
    log.showInfo(`GetAppAllowList after = ${outerAllowList.length}`);
    return outerAllowList;
  }
}
