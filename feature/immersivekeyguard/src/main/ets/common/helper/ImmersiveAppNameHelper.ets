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

import {
  CommonUtils,
  SingletonHelper,
  LogHelper,
  LogDomain
} from '@ohos/basicutils';
import {
  ImmersiveConstants
} from '@ohos/systemuicommon';

const TAG = 'ImmersiveAppNameHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ImmersiveAppNameHelper {
  /**
   * 通知hashCode映射图标
   */
  private appNames: Map<string, string> = new Map();

  /**
   * 通知hashCode映射通知图标数据改变回调
   */
  public listeners: Map<string, AppNameCallback> = new Map();

  /**
   * 每个hashCode映射一个数据监听回调
   *
   * @param hashCode 唯一标识
   * @param callback 回调
   */
  registerListener(hashCode?: string, callback?: AppNameCallback): void {
    if (hashCode === undefined || callback === undefined) {
      log.showError(`registerListener fail, hashCode: ${hashCode}`);
      return;
    }
    this.listeners.set(hashCode, callback);
    callback?.onUpdateAppName(this.getAppName(hashCode));
  }

  /**
   * 注销数据监听
   *
   * @param hashCode 唯一标识
   */
  unRegisterListener(hashCode?: string): void {
    if (hashCode === undefined) {
      log.showError('unregisterListener fail');
      return;
    }
    this.listeners.delete(hashCode);
  }

  /**
   * 根据hashCode查询通知应用名
   *
   * @param hashCode
   * @returns  appname
   */
  getAppName(hashCode?: string): string | undefined {
    if (hashCode === undefined) {
      return undefined;
    }
    return this.appNames.get(hashCode);
  }
}

/**
 * 组件回调器
 */
export interface AppNameCallback {
  /**
   * 更新应用名称
   *
   * @param appName 应用名
   */
  onUpdateAppName: (appName?: string) => void;
}

// 单例
export let appNameHelper = SingletonHelper.getInstance(ImmersiveAppNameHelper, TAG);