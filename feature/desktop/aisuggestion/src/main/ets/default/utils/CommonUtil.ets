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
import { bundleManager } from '@kit.AbilityKit';

const INVALID_TIMER = -1;
const TAG = 'CommonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 通用工具
 *
 * @since 2023-12-18
 */
export class CommonUtil {
  /**
   * 函数防抖
   *
   * @param func 要执行的函数
   * @param delay 时延
   * @returns 防抖函数
   */
  static debounce<T>(func: Function, delay: number): Function {
    let timer: number = INVALID_TIMER;
    return (param?: T): void => {
      if (timer !== INVALID_TIMER) {
        clearTimeout(timer);
      }
      timer = setTimeout(() => {
        func(param);
      }, delay);
    };
  }

  /**
   * 判断应用是否安装
   * @param bundleName
   * @returns 是否安装
   */
  static isInstalled(bundleName: string): boolean {
    log.showInfo(`isAppInstalled, start`);
    try {
      let applicationInfo = bundleManager.getApplicationInfoSync(bundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (applicationInfo) {
        log.showInfo(`isInstalled, bundleName:${bundleName} is install?true`);
        return true;
      }
    } catch (error) {
      log.error('isInstalled error', error);
    }
    log.showInfo(`isInstalled, bundleName:${bundleName} is install?false`);
    return false;
  }
}