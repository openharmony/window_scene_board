/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import {
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
} from '@ohos/basicutils';

const TAG = 'LauncherAnimUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * 标记ui busy后一直没有正常标记ui free, 超过1.5s定时器自动修复
 */
const EXPIRED_TIME = 500;

export class LauncherAnimUtil {
  private static isUIThreadBusy: boolean = false;
  private static timerId: number = 0;

  /**
   * 应用是否有做动效
   * @param tag 调用方标识
   * @param uiBusy 动效标识
   * @param isSetImmediately 是否立刻生效
   * @param time 执行定时器的时间
   */
  public static setIsUIBusy(tag: string, uiBusy: boolean, isSetImmediately?: boolean, time?: number): void {
    log.showInfo(`tag=${tag} isUiBusy=${uiBusy}`);
    if (!uiBusy && !isSetImmediately) {
      // false不主动恢复标记位，采用1.5s后自动恢复方案，UI busy的1.5s内语音助手建议不刷新，后续优化语音助手建议的刷新时延后可以放开限制
      return;
    }
    LauncherAnimUtil.isUIThreadBusy = uiBusy;

    if (LauncherAnimUtil.timerId > 0) {
      clearTimeout(LauncherAnimUtil.timerId);
      LauncherAnimUtil.timerId = 0;
    }
    if (uiBusy) {
      TraceUtil.startTrace(DomainName.HOME, 'UIBusy');
      LauncherAnimUtil.timerId = setTimeout(() => {
        log.showInfo(`${tag} reset isUiBusy after ${EXPIRED_TIME}ms`);
        LauncherAnimUtil.isUIThreadBusy = false;
        TraceUtil.endTrace(DomainName.HOME, 'UIBusy');
      }, time ?? EXPIRED_TIME);
    } else {
      TraceUtil.endTrace(DomainName.HOME, 'UIBusy');
    }
  }

  /**
   * Check if Ui thread is busy.
   *
   * @return True for yes
   */
  public static isUiThreadBusy(): boolean {
    return LauncherAnimUtil.isUIThreadBusy;
  }
}