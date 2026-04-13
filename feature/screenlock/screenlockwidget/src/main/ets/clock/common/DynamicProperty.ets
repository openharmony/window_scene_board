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
import { LogHelper, LogDomain } from '@ohos/basicutils';

const TAG = 'DynamicProperty';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_SIZE = 1000;

/**
 * 动态属性
 */
export class DynamicProperty<T> {
  protected positionMap: Map<string, T> = new Map(); // 不同场景属性记录

  protected constructor() { // 构造
  }

  /**
   * 场景属性绑定
   *
   * @param scene 场景
   * @param offset 属性
   * @returns 链式
   */
  public buildProperty(scene: string, property: T): DynamicProperty<T> {
    if (this.positionMap.size >= MAX_SIZE) {
      log.showWarn('buildProperty positionMap size is too large');
      return this;
    }
    this.positionMap.set(scene, property);
    return this;
  }

  /**
   * 获取目标属性
   *
   * @param scene 目标场景
   * @returns 位置
   */
  public getProperty(scene: string): T | undefined {
    return this.positionMap.get(scene);
  }

  /**
   * 遍历场景属性
   *
   * @param callback 遍历回调
   */
  public forEach(callback: (value: T, key: string, map: Map<string, T>) => void): void {
    this.positionMap.forEach(callback);
  }
}