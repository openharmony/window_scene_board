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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { windowManager } from '@ohos/componentdrag';
import { AccountMgr } from '@ohos/frameworkwrapper';
import { ResUtils, scbGestureManager } from '@ohos/windowscene';
import { NotificationConfigEntity, SystemUICommonUtil } from '@ohos/systemuicommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import promptAction from '@ohos.promptAction';
import type { NotificationEntry } from './NotificationEntry';
import type { NotificationBase } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';

const log = LogHelper.getLogHelper(LogDomain.NC, 'ExclusiveChecker');
// 互斥业务资源类型
const EXCLUSIVE_RES_TYPE = 501;
// toast提示时长，按照规范超过1行文本提示使用3500ms
const EXCLUSIVE_TOAST_DURATION = 3500;
// toast离底部的间距，单位vp
const EXCLUSIVE_TOAST_BOTTOM = 80;
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

interface RssInfo {
  domain: string;
  bundleName: string;
}

interface RssDataDetail {
  appInfo: RssInfo;
  reason: Array<RssInfo>;
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
  private excludeBundleName?: string;
  /**
   * 互斥的应用名称
   */
  private excludeAppName?: string;
  /**
   * 是否为大模型互斥
   */
  private isLLMExclude?: boolean;


  /**
   * 检查拉起应用时互斥关系
   * @param bundleName 包名
   * @param mode 拉起应用的模式
   * @returns
   */
  public static check(bundleName: string, mode: 'FLOATING' | 'FULL_SCREEN', showToast: boolean): ExclusiveChecker {
    const exclusive = new ExclusiveChecker();
    const payload: Record<string, string> = { 'bundleName' : bundleName, 'mode': mode };

    try {
      log.showInfo(`Check exclusive for bundleName: ${bundleName}, mode: ${mode}`);
      const result = sceneSessionManager.getRssData(EXCLUSIVE_RES_TYPE, payload) as object as RssData | undefined;
      log.showInfo(`Rss exclusive result.details: ${result?.details}`);
      exclusive.result = result?.result ?? false;
      if (exclusive.result && result?.details) {
        const details = SystemUICommonUtil.safeParseJson<RssDataDetail>(result.details);
        exclusive.excludeBundleName = details?.reason?.find((r) => r.bundleName)?.bundleName;
        if (!exclusive.excludeBundleName) {
          exclusive.isLLMExclude = Boolean(details?.reason?.some((r) => r.domain === LLM_DOMAIN));
        }
      }
      log.showInfo(`Check exclusive result: ${exclusive.result}, bundle: ${exclusive.excludeBundleName}` +
        `, isLLMExclude: ${exclusive.isLLMExclude}`);
    } catch (e) {
      log.error(`Check exclusive for bundleName: ${bundleName}, mode: ${mode} error:`, e);
    }
    if (exclusive.result && showToast) {
      exclusive.showExclusiveToast();
    }

    return exclusive;
  }

  /**
   * 显示互斥关系的toast
   * @returns
   */
  private async showExclusiveToast(): Promise<void> {
    try {
      const appName = await this.getExcludeAppName();
      if (!appName) {
        return;
      }
      const bottom = this.getToastBottom();
      log.showInfo(`Exclusive toast appName: ${appName}, bottom: ${bottom}`);
      promptAction.showToast({
        message: $r('app.string.app_running_mutex_toast', '', appName),
        duration: EXCLUSIVE_TOAST_DURATION,
        bottom,
      });
    } catch (e) {
      log.error('Show exclude toast error:', e);
    }
  }

  /**
   * 获取初始应用名称，当前只需要取第一个互斥应用的名称
   * @returns
   */
  private async getExcludeAppName(): Promise<string> {
    if (this.excludeAppName) {
      return this.excludeAppName;
    }
    if (this.isLLMExclude) {
      this.excludeAppName = ResUtils.getInnerString($r('app.string.app_smart_service'));
      return this.excludeAppName;
    }
    const userId = await AccountMgr.getCurrentAccountId();
    const config = await NotificationConfigEntity.queryByProps({ bundle: this.excludeBundleName, userId }, {
      columns: ['label']
    });
    log.showInfo(`Get exclude app name result: ${config?.label}`);
    this.excludeAppName = config?.label;
    return this.excludeAppName ?? '';
  }

  /**
   * 获取互斥toast距离底部的距离
   * @returns
   */
  private getToastBottom(): number {
    try {
      return windowManager.getWindowHeight() + EXCLUSIVE_TOAST_BOTTOM;
    } catch (e) {
      return EXCLUSIVE_TOAST_BOTTOM;
    }
  }
}