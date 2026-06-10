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

/**
 * 拖拽和挤位模块共享数据管理模块
 * 只能保存类，不能保存接口
 */
export class ShareDataManager {
  private static data = new Map();

  /**
   * 获取共享数据类单例
   *
   * @param className 类名
   * @param keyName 键值
   * @return 数据类单例
   */
  public static getInstance<T>(className: { new(): T }, keyName: string): T {
    const value = this.data.get(keyName);
    if (!value) {
      const item = new className();
      this.data.set(keyName, item);
      return item;
    }
    return value;
  }
}