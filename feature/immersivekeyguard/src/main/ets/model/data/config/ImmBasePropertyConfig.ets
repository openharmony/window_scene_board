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

import { WProperty } from '@ohos/screenlockcommon';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { PropertyState, WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { IImmConfigKey } from './IImmConfigKey';

/**
 * 沉浸模块属性配置基类
 */
export abstract class ImmBasePropertyConfig<T extends ImmBasePropertyConfig<T>> {
  // 配置集
  private readonly configMap: LimitMap<string, WidgetPropertyConfig> = new LimitMap();

  // 属性状态管理集
  private readonly ptStMap: LimitMap<string, PropertyState> = new LimitMap();

  // 配置实例名称
  private readonly cfgName: string;

  // 隐藏构造
  protected constructor(cfgName: string) {
    this.cfgName = cfgName;
  }

  /**
   * 取得当前实例
   *
   * @returns 当前实例
   */
  protected abstract getThis(): T;

  /**
   * 配置名称
   *
   * @returns 名称
   */
  public getCfgName(): string {
    return this.cfgName;
  }

  /**
   * 绑定配置
   *
   * @param key 标识
   * @param cfg 配置
   * @returns 链式
   */
  public bindConfig(key: IImmConfigKey, cfg: WidgetPropertyConfig): T {
    if (cfg) {
      this.configMap.set(this.getKey(key), cfg);
    }
    return this.getThis();
  }

  /**
   * 取值配置
   *
   * @param key 标识
   * @returns 配置
   */
  public getConfig(key: IImmConfigKey): WidgetPropertyConfig | undefined {
    return this.configMap.get(this.getKey(key));
  }

  /**
   * 绑定属性状态
   *
   * @param key 标识
   * @param ptSt 属性状态
   * @returns 链式
   */
  public bindPropertySt(key: IImmConfigKey, ptSt?: PropertyState): T {
    if (ptSt) {
      this.ptStMap.set(this.getKey(key), ptSt);
    }
    return this.getThis();
  }

  /**
   * 配置应用
   *
   * @param key 标识，无标识则全部应用，有标识则单个应用
   * @param ptArr 目标应用属性集，默认全应用
   */
  public applyConfig(key?: IImmConfigKey, ptArr?: WProperty[]): void {
    // 应用单一标识下的配置
    if (key) {
      let strKey = this.getKey(key);
      let cfg = this.configMap.get(strKey);
      // 有绑定对应的状态实例，则优先使用，没有则使用配置自带State集
      let ptSt = this.ptStMap.get(strKey);
      cfg?.applyConfig(ptSt, ptArr);
      return;
    }
    // 全部应用
    this.configMap.forEach((cfg, key) => {
      // 有绑定对应的状态实例，则优先使用，没有则使用配置自带State集
      let ptSt = this.ptStMap.get(key);
      cfg?.applyConfig(ptSt);
    });
  }

  /**
   * 清空已应用的配置
   */
  public clearConfig(): void {
    this.configMap.forEach((cfg, key) => {
      // 有绑定对应的状态实例，则优先使用，没有则使用配置自带State集
      let ptSt = this.ptStMap.get(key);
      cfg?.clearConfig(ptSt);
    });
  }

  /**
   * 清空配置集
   */
  public clearCfgMap(): void {
    this.configMap.clear();
    this.ptStMap.clear();
  }

  /**
   * 标识转换
   *
   * @param key 标识
   * @returns 标识
   */
  protected getKey(key: IImmConfigKey): string {
    return key.getKey();
  }
}