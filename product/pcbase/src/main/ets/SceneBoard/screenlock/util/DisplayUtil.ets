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

import display from '@ohos.display';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'DisplayUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * display工具类
 *
 * @since 2025-03-27
 */
export class DisplayUtil {
  private constructor() {
  }

  /**
   * 注册角度变化监听回调
   *
   * @params callback 回调函数
   */
  public static registerFoldAngleChangeCallback(callback: Callback<number[]>): void {
    try {
      display.on('foldAngleChange', callback);
    } catch (err) {
      log.showError(`failed to register FoldAngleChangeCallback. code: ${err?.code}, msg: ${err?.message}`);
    }
  }

  /**
   * 反注册角度变化监听回调
   *
   * @params callback 回调函数
   */
  public static unregisterFoldAngleChangeCallback(callback: Callback<number[]>): void {
    try {
      display.off('foldAngleChange', callback);
    } catch (err) {
      log.showError(`failed to unregister FoldAngleChangeCallback. code: ${err?.code}, msg: ${err?.message}`);
    }
  }
}