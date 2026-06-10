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

import { TsLog } from '../log/TsLog';
import { JsonUtils } from '../utils/JsonUtils';

/**
 * 存储割接器
 */
export type StoreMigrator<T> = (oldVersion: number, newVersion: number, oldData: Nullable<T>) => Promise<Nullable<T>>
  | Nullable<T>;

/**
 * 缓存首次启动，空版本号
 */
export const VERSION_EMPTY: number = -1;

const TAG: string = 'StoreCache';

/**
 * 存储管理器
 */
export interface StoreManager<T_DECODE, T_ENCODE> {
  /**
   * 获取当前存储的名称
   * @return {string} 返回当前存储的名称
   */
  getName(): string;

  /**
   * 清空当前存储
   * @return {Promise<void>} 返回一个Promise，当清空操作完成时resolve
   */
  clear(): Promise<void>;

  /**
   * 将键值对存储到当前存储中
   * @param {string} key 要存储的键
   * @param {T_ENCODE | number} value 要存储的值
   * @return {Promise<void>} 返回一个Promise，当存储操作完成时resolve
   */
  put(key: string, value: T_ENCODE | number): Promise<void>;

  /**
   * 从当前存储中获取指定键的值
   * @param {string} key 要获取的键
   * @param {T_ENCODE | number} def 默认值，如果指定键的值不存在，则返回此默认值
   * @return {Promise<T_ENCODE | number | undefined>} 返回一个Promise，其resolve值为指定键的值，如果键不存在，则resolve为默认值或undefined
   */
  get(key: string, def?: T_ENCODE | number): Promise<T_ENCODE | number | undefined>;

  /**
   * 对存储中的值进行解码
   * @param {T_ENCODE} value 要解码的值
   * @return {T_DECODE} 返回解码后的值
   */
  decode(value: T_ENCODE): T_DECODE | undefined;

  /**
   * 对数据进行编码，以便存储
   * @param {T_DECODE} data 要编码的数据
   * @return {T_ENCODE} 返回编码后的值
   */
  encode(data: T_DECODE): T_ENCODE | undefined;
}

export class StoreCache<T_DECODE, T_ENCODE> {
  private static readonly VERSION_DEFAULT = 0;

  private static readonly KEY_VERSION: string = 'version';

  private static readonly KEY_DATA: string = 'data';

  private readonly storeManager: StoreManager<T_DECODE, T_ENCODE>;

  private storeData: Nullable<StoreData<T_DECODE>>;

  private readonly storeVersion: number;

  private migrator: Nullable<StoreMigrator<T_DECODE>>;

  constructor(storeManager: StoreManager<T_DECODE, T_ENCODE>, migrator?: StoreMigrator<T_DECODE>,
    version: number = StoreCache.VERSION_DEFAULT) {
    this.storeManager = storeManager;
    this.storeVersion = version;
    this.migrator = migrator;
  }

  private async load(): Promise<void> {
    try {
      const encodeData: T_ENCODE = await this.storeManager.get(StoreCache.KEY_DATA) as T_ENCODE;
      let decodeData: Nullable<T_DECODE> = encodeData ? this.storeManager.decode(encodeData) : undefined;
      TsLog.debug(TAG, `load(${this.storeManager.getName()}) encodeData:  ${encodeData}`);
      if (await this.migrate(decodeData)) {
        TsLog.debug(TAG, `load(${this.storeManager.getName()}) migrate`);
        return;
      }
      this.storeData = new StoreData<T_DECODE>(this.storeVersion, decodeData);
    } catch (err) {
      TsLog.error(TAG, `load(${this.storeManager.getName()}) catch exception.`, err);
    }
  }

  private async migrate(decodeData: Nullable<T_DECODE>): Promise<boolean> {
    if (!this.migrator) {
      return false;
    }
    // 根据版本号变化，缓存迁移，版本号相同是否需要处理由具体实现者进行决策处理
    const version: number = await this.storeManager.get(StoreCache.KEY_VERSION, VERSION_EMPTY) as number;
    TsLog.info(TAG, `Cache(${this.storeManager.getName()}) migrate from ${version} to ${this.storeVersion}`);
    let migrateData: Nullable<T_DECODE> = await this.migrator(version, this.storeVersion, decodeData);
    if (migrateData) {
      return this.update(migrateData);
    }
    return false;
  }

  /**
   * 获取缓存数据
   * @return 返回缓存数据，如果没有数据，则返回null
   */
  public async get(): Promise<Nullable<T_DECODE>> {
    // 缓存首次启动，从缓存管理器加载到内存
    if (!this.storeData) {
      await this.load();
    }
    // 返回缓存数据，如果没有数据，则返回null
    return this.storeData?.data;
  }


  /**
   * 更新存储数据的方法
   * @param data 需要更新的数据
   * @return 返回一个Promise，如果更新成功，Promise的结果为true，否则为false
   * @throws 如果在更新过程中发生错误，会抛出异常
   */
  public async update(data: T_DECODE): Promise<boolean> {
    if (TsLog.isDebug(TAG)) {
      TsLog.debug(TAG, `update (${this.storeManager.getName()}), data:${JsonUtils.stringify(data)}`);
    }
    try {
      // 创建一个新的StoreData对象，包含当前的store版本和需要更新的数据
      this.storeData = new StoreData<T_DECODE>(this.storeVersion, data);
      // 将新的store版本存储到storeManager中
      await this.storeManager.put(StoreCache.KEY_VERSION, this.storeData.version);
      // 将新的数据编码后存储到storeManager中
      await this.storeManager.put(StoreCache.KEY_DATA, this.storeManager.encode(data) as T_ENCODE | number);
      return true;
    } catch (err) {
      TsLog.error(TAG,
        `update (${this.storeManager.getName()}), catch exception. code:${err.code}, message:${err.message}`);
    }
    return false;
  }

  /**
   * 清除存储数据的方法
   * @return {Promise<void>} 返回一个Promise对象，当存储数据清除成功时，Promise对象的状态变为resolved
   */
  public clear(): Promise<void> {
    // 创建一个新的StoreData对象，并将其赋值给this.storeData，StoreData对象的version参数为this.storeVersion，data参数为undefined
    this.storeData = new StoreData<T_DECODE>(this.storeVersion, undefined);
    // 调用storeManager的clear方法，清除存储数据，并返回一个Promise对象
    return this.storeManager.clear();
  }
}

class StoreData <T> {
  private readonly _version: number = 0;

  private readonly _data: Nullable<T>;

  constructor(version: number, data: Nullable<T>) {
    this._version = version;
    this._data = data;
  }

  public get version(): number {
    return this._version;
  }

  public get data(): Nullable<T> {
    return this._data;
  }
}