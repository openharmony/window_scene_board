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
import { LightWeightMap } from '@kit.ArkTS';
import { StoreCache, StoreManager } from './StoreCache';

/**
 * 内存存储管理器
 */
class MemoryStoreManger<T> implements StoreManager<T, T> {
  private readonly _cache: LightWeightMap<string, number | T> = new LightWeightMap<string, number | T>();
  private readonly _name: string;

  constructor(name: string) {
    this._name = name;
  }

  /**
   * 获取名字
   * @return {string} 返回名字
   */
  getName(): string {
    return this._name;
  }

  /**
   * 清空缓存
   * @return {Promise<void>} 返回一个Promise，当缓存清空后resolve
   */
  clear(): Promise<void> {
    this._cache.clear();
    return Promise.resolve();
  }

  /**
   * 将键值对存入缓存
   * @param {string} key 键
   * @param {number | T} value 值，可以是数字或者T类型
   * @return {Promise<void>} 返回一个Promise，当值存入缓存后resolve
   */
  put(key: string, value: number | T): Promise<void> {
    this._cache.set(key, value);
    return Promise.resolve();
  }

  /**
   * 从缓存中获取值
   * @param {string} key 键
   * @param {number | T | undefined} def 默认值，如果键不存在，返回默认值
   * @return {Promise<number | T | undefined>} 返回一个Promise，其解析值为键对应的值或者默认值
   */
  get(key: string, def?: number | T | undefined): Promise<number | T | undefined> {
    return Promise.resolve(this._cache.get(key) ?? def);
  }

  /**
   * 解码方法，对于T类型的值，直接返回
   * @param {T} value 需要解码的值
   * @return {T} 返回解码后的值
   */
  decode(value: T): T {
    return value;
  }

  /**
   * 编码方法，对于T类型的值，直接返回
   * @param {T} data 需要编码的数据
   * @return {T} 返回编码后的数据
   */
  encode(data: T): T {
    return data;
  }
}

export class MemoryCache<T> extends StoreCache<T, T> {
  /**
   * 构造函数，用于创建一个新的Store实例
   * @param name 存储的名称
   * @param loader 一个返回Promise或者T的函数，用于加载数据
   */
  constructor(name: string, loader: () => Promise<T> | T) {
    // 调用父类的构造函数，传入一个新的MemoryStoreManger实例和一个回调函数
    super(new MemoryStoreManger(name), (_oldVersion, _newVersion, _oldData) => {
      return loader();
    });
  }
}