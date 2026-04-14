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

import { LimitMap } from '../utils/LimitMap';
import { WProperty } from '../constants/WidgetPropertyConst';
import { BaseObj } from '../constants/BaseType';
import { WidgetAnimStateV2 } from './WidgetAnimStateV2';
import { WidgetAnimState } from './WidgetAnimState';
import { WidgetStyleStateV2 } from './WidgetStyleStateV2';
import { WidgetStyleState } from './WidgetStyleState';

// 当前满足属性状态管理的类
export type PropertyState = WidgetStyleStateV2 | WidgetStyleState | WidgetAnimStateV2 | WidgetAnimState;

/**
 * 属性配置
 */
export class WidgetPropertyConfig {
  // 配置集
  private readonly configMap: LimitMap<WProperty, BaseObj> = new LimitMap();

  // 需要应用配置集的属性状态集
  private readonly ptStArr: PropertyState[] = [];

  private constructor() {
  }

  /**
   * 配置绑定
   *
   * @param pt 属性标识
   * @param value 配置值
   * @returns 链式
   */
  public bindConfig(pt: WProperty, value?: BaseObj): WidgetPropertyConfig {
    this.configMap.set(pt, value);
    return this;
  }

  /**
   * 取值配置
   *
   * @param pt 属性标识
   * @returns 配置值
   */
  public getConfig(pt: WProperty): BaseObj | undefined {
    return this.configMap.get(pt);
  }

  /**
   * 添加属性状态
   *
   * @param ptSt 属性状态
   * @returns 链式
   */
  public addPtState(ptSt?: PropertyState): WidgetPropertyConfig {
    if (ptSt) {
      this.ptStArr.push(ptSt);
    }
    return this;
  }

  /**
   * 应用配置
   *
   * @param st 接收配置目标状态
   * @param ptArr 目标应用属性集，默认全应用
   */
  public applyConfig(st?: PropertyState, ptArr?: WProperty[]): void {
    if (ptArr) {
      ptArr.forEach((pt) => this.setPtStValue(pt, st, this.getConfig(pt)));
      return;
    }
    // 全部应用
    this.configMap.forEach((value, pt) => this.setPtStValue(pt, st, value));
  }

  /**
   * 清空已应用配置
   *
   * @param st 目标状态
   */
  public clearConfig(st?: PropertyState): void {
    this.configMap.forEach((value, pt) => this.clearStPt(pt, st));
  }

  private setPtStValue(pt: WProperty, st?: PropertyState, value?: BaseObj): void {
    // 存在属性状态则优先使用，不存在则使用默认配置集
    if (st) {
      st.setStateValue(pt, value);
      return;
    }
    this.ptStArr.forEach((ptSt) => ptSt?.setStateValue(pt, value));
  }

  private clearStPt(pt: WProperty, st?: PropertyState): void {
    // 存在属性状态则优先使用，不存在则使用默认配置集
    if (st) {
      st.clearProperty(pt);
      return;
    }
    this.ptStArr.forEach((ptSt) => ptSt?.clearProperty(pt));
  }

  /**
   * 统一管理配置实例创建
   *
   * @returns 配置实例
   */
  public static wrap(): WidgetPropertyConfig {
    return new WidgetPropertyConfig();
  }
}