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

import {
  AnimEvent,
  ComponentPosition,
  WidgetAnimState,
  WidgetAnimStateV2,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { CardAnimScene, CardShowType } from '../constants/ImmCardConst';
import { IImmersiveAnimBaseVm } from './IImmersiveAnimBaseVm';

/**
 * 沉浸大卡模块动效业务抽象层
 */
export interface IImmersiveCardAnimVm extends IImmersiveAnimBaseVm {
  /**
   * 沉浸大卡是否有效（是否有对应类型数据）
   *
   * @param type 大卡类型
   * @returns true大卡有效
   */
  isCardValid(type: CardShowType): boolean;

  /**
   * 内容大卡判断
   *
   * @param type 大卡类型
   * @returns true内容大卡
   */
  isCardContent(type: CardShowType): boolean;

  /**
   * 更新动效大卡判断
   *
   * @param type 大卡类型
   * @returns true更新动效大卡
   */
  isCardUpdate(type: CardShowType): boolean;

  /**
   * 删除类型动效大卡判断
   *
   * @param type 大卡类型
   * @returns true删除类型动效大卡
   */
  isCardDelete(type: CardShowType): boolean;

  /**
   * 无效大卡
   *
   * @param type 大卡类型
   * @returns true无效大卡
   */
  isCardNone(type: CardShowType): boolean;

  /**
   * 获取根布局动效状态
   *
   * @returns 根布局动效状态
   */
  getRootAnimSt(): WidgetAnimStateV2;

  /**
   * 获取条目通用动效状态
   *
   * @param type 大卡类型
   * @returns 条目动效状态
   */
  getItemComAnimSt(type: CardShowType): WidgetAnimStateV2 | undefined;

  /**
   * 实况卡片V1动效状态
   *
   * @returns V1动效
   */
  getLiveCardAnimV1St(): WidgetAnimState;

  /**
   * 获取实况卡片动效状态
   *
   * @param type 大卡类型
   * @returns 实况卡片动效状态
   */
  getLiveCardAnimSt(type: CardShowType): WidgetAnimStateV2 | undefined;

  /**
   * 获取根布局样式状态
   *
   * @returns 根布局样式状态
   */
  getRootStyle(): WidgetStyleStateV2;

  /**
   * 获取条目通用样式状态
   *
   * @param type 大卡类型
   * @returns 条目样式状态
   */
  getItemComStyle(type: CardShowType): WidgetStyleStateV2 | undefined;

  /**
   * 获取根布局位置
   *
   * @returns 根布局位置
   */
  getRootPos(): ComponentPosition;

  /**
   * 获取条目布局通用位置
   *
   * @param type 大卡类型
   * @returns 条目位置
   */
  getItemComPos(type: CardShowType): ComponentPosition | undefined;

  /**
   * 获取条目布局实况位置
   *
   * @param groupKey 标识
   * @returns 条目位置
   */
  getItemLivePos(groupKey?: string): ComponentPosition | undefined;

  /**
   * 获取实况列表点击卡片位置
   *
   * @returns 点击卡片位置
   */
  getClickLivePos(): ComponentPosition | undefined;

  /**
   * 获取实况胶囊位置
   *
   * @returns 实况胶囊位置
   */
  getLiveCapPos(): ComponentPosition | undefined;

  /**
   * 开启沉浸大卡生命周期动效
   *
   * @param scene 动效场景
   */
  startLifeCycleAnim(scene?: CardAnimScene): void;

  /**
   * 开启实况卡片收拢/展开动效
   *
   * @param endValue 动效终值
   */
  startLiveCardFoldAnim(endValue: AnimEvent): void;
}