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

const LOG_CONNECTOR = '-';

export class LogUtil {
  private static INSTANCE: LogUtil;

  private constructor() {}

  /**
   * 单例对象
   *
   * @returns 单例对象
   */
  public static getInstance(): LogUtil {
    if (!LogUtil.INSTANCE) {
      LogUtil.INSTANCE = new LogUtil();
    }
    return LogUtil.INSTANCE;
  }

  /**
   * 创建log helper
   * @param tag log tag
   * @param screenId screen id
   * @returns log helper
   */
  public createLogHelper(tag: string, screenId: number): LogHelper {
    const logTag = tag + LOG_CONNECTOR + screenId.toString();
    return LogHelper.getLogHelper(LogDomain.WINDOW, logTag);
  }
}