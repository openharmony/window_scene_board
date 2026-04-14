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

const TAG = 'AppUpdateUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 用于处理应用锁AppUpdate的utils
 */
export default class AppUpdateUtils {
  private static mAppUpdateUtils: AppUpdateUtils;
  private static updateAppBundleNameList: string[] = [];

  private constructor() {
  }

  /**
   * 获取单例对象
   * @returns AppUpdateUtils
   */
  public static getInstance(): AppUpdateUtils {
    if (!AppUpdateUtils.mAppUpdateUtils) {
      AppUpdateUtils.mAppUpdateUtils = new AppUpdateUtils();
    }
    return AppUpdateUtils.mAppUpdateUtils;
  }

  /**
   * 判断是否在企业应用更新列表中
   * @param bundleName
   * @returns true or false 是否在列表
   */
  public static checkIsEnterPriseTypeAppUpdate(bundleName: string): boolean {
    if (AppUpdateUtils.updateAppBundleNameList.length === 0) {
      log.showWarn('updateAppBundleNameList is empty!');
      return false;
    }
    if (AppUpdateUtils.updateAppBundleNameList.includes(bundleName)) {
      log.showInfo(`updateAppBundleNameList has ${bundleName}`);
      return true;
    }
    return false;
  }

  /**
   * 在企业应用更新列表中添加
   * @param bundleName
   */
  public static addEnterPriseTypeAppUpdateList(bundleName: string): void {
    if (AppUpdateUtils.checkIsEnterPriseTypeAppUpdate(bundleName)) {
      return;
    }
    AppUpdateUtils.updateAppBundleNameList.push(bundleName);
  }

  /**
   * 在企业应用更新列表中删除
   * @param bundleName
   */
  public static deleteEnterPriseTypeAppUpdateList(bundleName: string): void {
    if (!AppUpdateUtils.checkIsEnterPriseTypeAppUpdate(bundleName)) {
      return;
    }
    AppUpdateUtils.updateAppBundleNameList = AppUpdateUtils.updateAppBundleNameList.filter(updateBundleName => {
      return updateBundleName !== bundleName;
    });
  }
}