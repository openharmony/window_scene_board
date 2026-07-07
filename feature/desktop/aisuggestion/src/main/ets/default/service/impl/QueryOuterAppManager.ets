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
import { IExecutor } from '@ohos/launchercommon';
import lazy { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG: string = 'QueryOuterAppManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 判断多个应用或ability是否是未适配应用
 *
 * @since 2025-02-21
 */
export class QueryIsBlockApps implements IExecutor {
  async execute(extra?: object): Promise<string> {
    let bundleNames = '';
    if (typeof extra === 'string') {
      bundleNames = extra as string;
    }
    if (!bundleNames) {
      log.showWarn('QueryIsBlockApps bundleNames is invalid');
      return Response.FAIL;
    }
    return OuterAppManager.getInstance().isBlockApps(bundleNames);
  }
}

/**
 * 根据传入包名获取应用分类
 *
 * @since 2025-02-25
 */
export class GetAppCategory implements IExecutor {
  async execute(extra?: object): Promise<string> {
    let bundleNames = '';
    if (typeof extra === 'string') {
      bundleNames = extra as string;
    }
    if (!bundleNames) {
      log.showWarn('GetAppCategory bundleNames is invalid');
      return Response.FAIL;
    }
    return OuterAppManager.getInstance().getAppCategory(bundleNames);
  }
}

/**
 * 根据传入包名获取卡片是否可添加至外屏
 *
 * @since 2025-02-25
 */
export class GetCardIsAddToOuter implements IExecutor {
  async execute(extra?: object): Promise<string> {
    let bundleNames = '';
    if (typeof extra === 'string') {
      bundleNames = extra as string;
    }
    if (!bundleNames) {
      log.showWarn('getCardIsAddToOuter bundleNames is invalid');
      return Response.FAIL;
    }
    return OuterAppManager.getInstance().isFilterCardByJson(bundleNames);
  }
}