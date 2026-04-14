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
import { ComponentPosition, WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { CapTypeChainV2 } from '../anim/v2/CapTypeChainV2';
import { CapAnimScene, CapShowType } from '../constants/ImmCapConst';
import { IImmersiveAnimBaseVm } from './IImmersiveAnimBaseVm';

/**
 * 沉浸胶囊模块动效业务抽象层
 */
export interface IImmersiveCapAnimVm extends IImmersiveAnimBaseVm {
  /**
   * 默认胶囊类型链条
   *
   * @returns 默认链条
   */
  getDefaultCapChain(): CapTypeChainV2;

  /**
   * 取值有效链条
   *
   * @param rootChain 起始链条
   * @returns 有效链条
   */
  getValidCapChain(rootChain?: CapTypeChainV2): CapTypeChainV2 | undefined;

  /**
   * 胶囊是否有效（是否有对应胶囊数据）
   *
   * @param type 胶囊类型
   * @returns true胶囊有效
   */
  isCapValid(type: CapShowType): boolean;

  /**
   * 强提醒胶囊判断
   *
   * @param type 胶囊类型
   * @returns true内容胶囊
   */
  isCapRemind(type: CapShowType): boolean;

  /**
   * 内容胶囊判断
   *
   * @param type 胶囊类型
   * @returns true内容胶囊
   */
  isCapContent(type: CapShowType): boolean;

  /**
   * 阴影胶囊判断
   *
   * @param type 胶囊类型
   * @returns true阴影胶囊
   */
  isCapShadow(type: CapShowType): boolean;

  /**
   * 无匹配胶囊判断
   *
   * @param type 胶囊类型
   * @returns true无匹配胶囊
   */
  isCapNone(type: CapShowType): boolean;

  /**
   * 获取根布局动效状态
   *
   * @returns 动效状态
   */
  getRootAnimSt(): WidgetAnimStateV2;

  /**
   * 获取对应类型胶囊通用动效状态
   *
   * @param type 胶囊类型
   * @returns 动效状态
   */
  getItemComAnimSt(type: CapShowType): WidgetAnimStateV2 | undefined;

  /**
   * 获取对应类型胶囊inner动效状态
   *
   * @param type 胶囊类型
   * @returns 动效状态
   */
  getItemInnerAnimSt(type: CapShowType): WidgetAnimStateV2 | undefined;

  /**
   * 获取根组件样式状态管理器
   *
   * @returns 样式
   */
  getRootStyle(): WidgetStyleStateV2;

  /**
   * 获取对应类型胶囊的通用样式状态管理器
   *
   * @param type 胶囊类型
   * @returns 样式
   */
  getItemComStyle(type: CapShowType): WidgetStyleStateV2 | undefined;

  /**
   * 获取胶囊有效通用样式状态管理器
   *
   * @param type 胶囊类型
   * @returns 样式
   */
  getValidItemComStyle(type: CapShowType): WidgetStyleStateV2;

  /**
   * 获取胶囊根组件位置
   *
   * @returns 位置
   */
  getRootPos(): ComponentPosition | undefined;

  /**
   * 获取对应类型胶囊的位置
   *
   * @param type 胶囊类型
   * @returns 位置
   */
  getItemPos(type: CapShowType): ComponentPosition | undefined;

  /**
   * 获取有效胶囊的位置
   *
   * @param capType 胶囊类型
   * @returns 位置
   */
  getValidItemPos(capType: CapShowType): ComponentPosition;

  /**
   * 开启胶囊生命周期动效
   *
   * @param scene 动效场景
   */
  startLifeCycleAnim(scene?: CapAnimScene): void;
}