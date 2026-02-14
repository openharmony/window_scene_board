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

import { LogDomain } from './LogHelper';
import { Logger } from './Logger';

const TAG = 'SingleInstanceHelper';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 单例工具
 * @deprecated since 2025.08.06
 */
export class SingletonHelper {
  /**
   * 创建单例工厂函数
   * @param clazz 类
   * @returns 单实例
   */
  public static createFactory<T>(getInstance: () => T): () => T {
    let instance: T | undefined;
    return (): T => {
      if (!instance) {
        instance = getInstance();
      }
      return instance;
    };
  }

  /**
   * 获取单实例
   *
   * @param clazz 构造
   * @param key 键值
   * @return 单实例
   */
  static getInstance<T>(clazz: { new(): T}, key: string): T {
    if (!globalThis[key]) {
      globalThis[key] = new clazz();
      log.showDebug(TAG, `Create key of ${key}`);
    }
    return globalThis[key];
  }
}
