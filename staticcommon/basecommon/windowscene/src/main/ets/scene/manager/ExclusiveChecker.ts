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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';

import { ResourceManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '../../utils/ResourceUtils';
import Prompt from '@ohos.promptAction';

const log = LogHelper.getLogHelper(LogDomain.SCB, 'ExclusiveChecker');
// 互斥业务资源类型
const EXCLUSIVE_RES_TYPE = 501;
// 大模型领域值
const LLM_DOMAIN = '2';

interface RssData {
  /**
   * 是否互斥
   */
  result: boolean;
  /**
   * 互斥详情
   */
  details?: string;
}

interface RssDataDetail {
  appInfo: {
    domain: string;
    bundleName: string;
  };
  reason: Array<{
    domain: string;
    bundleName: string;
  }>;
}

/**
 * 互斥业务检查
 */
export class ExclusiveChecker {
  /**
   * 是否互斥
   */
  public result: boolean = false;
  /**
   * 互斥的包名
   */
  public excludeBundleName?: string;
  /**
   * 是否为大模型互斥
   */
  private isLLMExclude: boolean;

  /**
   * 检查拉起应用时互斥关系
   * @param bundleName 包名
   * @param mode 拉起应用的模式
   * @returns
   */
  public static check(bundleName: string, mode: string, isToast: boolean): ExclusiveChecker {
    const exclusive = new ExclusiveChecker();
    const payload: Record<string, string> = { bundleName, mode };

    try {
      log.showWarn(`Check exclusive for bundleName: ${bundleName}, mode: ${mode}`);
      TraceUtil.startTrace(DomainName.SCB, 'getRssData');
      const result = sceneSessionManager.getRssData(EXCLUSIVE_RES_TYPE, payload) as unknown as RssData;
      TraceUtil.endTrace(DomainName.SCB, 'getRssData');
      if (!result) {
        log.showError('getRssData result is empty');
        return exclusive;
      }
      exclusive.result = result.result;
      if (exclusive.result && result.details) {
        const details = this.safeParseJson<RssDataDetail>(result.details);
        exclusive.excludeBundleName = details?.reason?.find((r) => r.bundleName)?.bundleName;
        if (!exclusive.excludeBundleName) {
          exclusive.isLLMExclude = Boolean(details?.reason?.some((r) => r.domain === LLM_DOMAIN));
        }
      }
      log.showWarn(`Check exclusive result: ${exclusive.result}, bundle: ${exclusive.excludeBundleName}` +
        `, isLLMExclude: ${exclusive.isLLMExclude}`);
    } catch (err) {
      log.showError(`Check exclusive error, code: ${err?.code}, message: ${err?.message}`);
    }
    if (exclusive.result && isToast) {
      exclusive.showExclusiveToast();
    }

    return exclusive;
  }

  /**
   * 显示互斥关系的toast
   * @returns
   */
  private showExclusiveToast(): void {
    try {
      const appName = this.getExcludeAppName();
      if (!appName) {
        log.showWarn('appName is empty');
        return;
      }
      const deliverTongAppName = ResUtils.getInnerString($r('app.string.app_others'));
      Prompt.showToast({
        message: $r('app.string.app_running_mutex_toast', deliverTongAppName, appName),
      });
    } catch (err) {
      log.showError(`Show exclude toast error, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /**
   * 获取初始应用名称，当前只需要取第一个互斥应用的名称
   * @returns
   */
  private getExcludeAppName(): string {
    let appName: string = '';
    if (this.isLLMExclude) {
      appName = ResUtils.getInnerString($r('app.string.app_smart_service'));
      return appName;
    }
    try {
      log.showWarn(`Get exclude app name of [${this.excludeBundleName}]`);
      if (this.excludeBundleName) {
        appName = ResourceManager.getInstance().getBundleAppName(this.excludeBundleName);
      }
      log.showWarn(`Get exclude app name of [${appName}]`);
    } catch (err) {
      log.showError(`Get exclude app name error, code: ${err?.code}, message: ${err?.message}`);
    }
    return appName;
  }

  public static safeParseJson<T>(jsonString: string): T | null {
    try {
      return JSON.parse(jsonString) as T;
    } catch (e) {
      log.error('Invalid JSON string code:' + e?.code + ', message:' + e?.message);
      return null;
    }
  }
}