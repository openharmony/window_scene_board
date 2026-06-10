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
import {
  SlStateBaseMgr,
  SlStateId,
  SlStateMgr,
  StateType } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { IBaseNestableState } from './IBaseNestableState';

const TAG = 'ImmItemBaseHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸各模块条目状态辅助工具
 */
export abstract class ImmItemBaseHelper<T extends IBaseNestableState<T>> {
  // 辅助工具集
  private static readonly sHelperMap: Map<string, object> = new Map();
  // 状态管理器名
  private readonly mgrName: SlStateMgr;
  // 模块根状态
  private rootSt?: T;

  /**
   * 构造
   *
   * @param mgrName 状态管理器名
   */
  protected constructor(mgrName: SlStateMgr) {
    this.mgrName = mgrName;
  }


  /**
   * 状态类型
   *
   * @returns 状态类型
   */
  protected abstract getStateType(): StateType;

  /**
   * 状态名称标识
   *
   * @returns 名称标识
   */
  protected abstract getStateId(): SlStateId.SL_LIST_STATE | SlStateId.SL_CAP_STATE | SlStateId.SL_CARD_STATE;

  /**
   * 状态后缀
   *
   * @returns 后缀
   */
  protected abstract getStSuffix(): string;

  /**
   * 创建状态实例
   *
   * @param childKey 标识
   * @returns 状态实例
   */
  protected abstract createChildState(childKey: string): T;

  /**
   * 添加条目状态管理器
   *
   * @param itemKey 条目标识
   */
  public addItemSt(itemKey?: string): void {
    if (!itemKey) {
      log.showWarn(`addItemSt invalid key, ${this.splicePrintStr()}`);
      return;
    }
    let key = this.getStKey(itemKey);
    let rootSt = this.getRootSt();
    if (!rootSt?.getChildState(key)) {
      rootSt?.addChildState(this.createChildState(key));
    }
  }

  /**
   * 移除条目状态管理器
   *
   * @param itemKey 条目标识
   */
  public removeItemSt(itemKey?: string): void {
    if (!itemKey) {
      log.showWarn(`removeItemSt invalid key, ${this.splicePrintStr()}`);
      return;
    }
    this.getRootSt()?.removeChildState(this.getStKey(itemKey));
  }

  /**
   * 获取条目状态管理器
   *
   * @param itemKey 条目标识
   * @returns 状态管理器
   */
  public getItemSt(itemKey?: string): T | undefined {
    if (!itemKey) {
      log.showWarn(`getItemSt invalid key, ${this.splicePrintStr()}`);
      return undefined;
    }
    let key = this.getStKey(itemKey);
    let itemSt = this.getRootSt()?.getChildState(key);
    if (!itemSt) {
      log.showWarn(`getItemSt has not add ${key}, ${this.splicePrintStr()}`);
    }
    return itemSt;
  }

  /**
   * 根状态
   *
   * @returns 根状态
   */
  public getRootSt(): T {
    if (!this.rootSt) {
      let mgr = SlStateBaseMgr.getMgr(this.mgrName);
      this.rootSt = mgr?.getState(this.getStateType(), this.getStateId()) as T;
    }
    return this.rootSt;
  }

  /**
   * 状态键值
   *
   * @param itemKey 条目键值
   * @returns 键值
   */
  private getStKey(itemKey: string): string {
    return `${itemKey}${this.getStSuffix()}`;
  }

  /**
   * 字串打印拼接
   *
   * @returns 打印字串
   */
  private splicePrintStr(): string {
    return `${this.mgrName}, ${this.getStateId()}, ${this.getStateType()}, ${this.getStSuffix()}`;
  }

  /**
   * 辅助工具单例获取
   *
   * @param clazz 类构造函数
   * @param mgrName 状态管理器名
   * @returns 实例
   */
  public static getHelper<V extends IBaseNestableState<V>, T extends ImmItemBaseHelper<V>>(clazz: Function,
    mgrName: SlStateMgr, suffix: string): T {
    let key = `${mgrName}_${suffix}_${clazz.name}`;
    let helper = this.sHelperMap.get(key);
    if (helper) {
      return helper as T;
    }
    helper = Reflect.construct(clazz, [mgrName, suffix]);
    if (helper instanceof ImmItemBaseHelper) {
      this.sHelperMap.set(key, helper);
      return helper as T;
    }
    log.showWarn(`getHelper invalid clazz: ${key}`);
    return helper as T;
  }
}