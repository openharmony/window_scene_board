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
import type abilityCommon from '@ohos.app.ability.common';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'GlobalContext';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
/**
 * 提供一个全局的对象读写能力，用于替代globalThis。
 */
export class GlobalContext {
  private constructor() {
  }

  private _objects = new Map<string, Object>();
  private isDebug: boolean = false;

  /**
   * 获取 GlobalContext 单例的静态方法。
   *
   * @returns GlobalContext 单例。
   */
  public static getInstance(): GlobalContext {
    if (globalThis.GlobalContext == null) {
      globalThis.GlobalContext = new GlobalContext();
    }
    return globalThis.GlobalContext;
  }

  /**
   * 设置context
   *
   * @param context abilityCommon.ServiceExtensionContext
   */
  public static setContext(context: abilityCommon.ServiceExtensionContext): void {
    let isContextNull = CheckEmptyUtils.isEmpty(context);
    log.showInfo('setContext, context is null: ' + isContextNull);
    globalThis.mContext = context;
  }

  /**
   * 获取context
   *
   * @returns abilityCommon.ServiceExtensionContext
   */
  public static getContext(): abilityCommon.ServiceExtensionContext {
    return globalThis.mContext;
  }

  /**
   * 从Map中返回指定的元素。
   *
   * @param key map中映射的唯一标记。
   * @returns 返回指定key管理的元素，如果获取不到则返回undefined.
   */
  public getObject(key: string): Object | undefined {
    let result = this._objects.get(key);
    this.printLog('getObject: ' + key + ' -> ' + (result != null));
    return result;
  }

  /**
   * 判断指定的元素是否存在与map中。
   *
   * @param key map中映射的唯一标记。
   * @returns 如果存在，则返回true。
   */
  public hasObject(key: string): boolean {
    return this._objects.has(key);
  }

  /**
   * 将指定键和值的新元素添加到Map中。如果已存在具有相同键的元素，则将更新该元素。
   *
   * @param key map中映射的唯一标记。
   * @param objectClass 需要存储的元素。
   */
  public setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
    this.printLog('setObject: ' + key);
  }

  /**
   * 从map中移除指定的元素。
   *
   * @param key map中映射的唯一标记。
   */
  public removeObject(key: string): boolean {
    return this._objects.delete(key);
    this.printLog('delete: ' + key);
  }

  private printLog(message: string): void {
    if (!this.isDebug) {
      return;
    }
    console.info(TAG, message);
  }
}