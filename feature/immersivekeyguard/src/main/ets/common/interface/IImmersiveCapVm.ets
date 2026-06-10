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
import { ComponentPosition } from '@ohos/screenlockcommon/Index';
import { ImmersiveTypeScene } from '@ohos/systemuicommon';
import { ImmCapCheckData } from '../../model/data/v2/ImmCapCheckData';
import { ImmCapData } from '../../model/data/v2/ImmCapData';
import { ImmCapDataArray } from '../../model/data/v2/ImmCapDataArray';
import { SlCapBindStateV2 } from '../../model/data/v2/SlCapBindStateV2';
import { SlCapStaticStateV2 } from '../../model/data/v2/SlCapStaticStateV2';
import { CapShowType } from '../constants/ImmCapConst';
import { IImmDataShareVm } from './IImmDataShareVm';
import { IImmersiveExtendVm } from './IImmersiveExtendVm';
import { IImmGestureEventVm } from './IImmGestureEventVm';
import { IImmLifeCycleVm } from './IImmLifeCycleVm';

/**
 * 沉浸胶囊业务管理抽象层
 */
export interface IImmersiveCapVm extends IImmersiveExtendVm, IImmDataShareVm, IImmLifeCycleVm, IImmGestureEventVm {
  /**
   * 沉浸胶囊列表数据
   *
   * @returns 列表数据
   */
  getSlCapData(): ImmCapDataArray;

  /**
   * 静态状态管理器
   *
   * @returns 静态状态管理器
   */
  getSlStaticState(): SlCapStaticStateV2;

  /**
   * UI绑定状态管理器
   *
   * @returns UI绑定状态管理器
   */
  getSlBindState(): SlCapBindStateV2;

  /**
   * 动效检测胶囊数据列表
   *
   * @returns 列表数据
   */
  getCheckCapData(): ImmCapCheckData;

  /**
   * 目标数据是否为当前显示沉浸态数据
   *
   * @param groupKey 目标数据标识
   * @returns true沉浸态数据
   */
  isCurImmCard(groupKey?: string): boolean;

  /**
   * 胶囊根组件位置切换
   *
   * @param oldValue 旧区域
   * @param newValue 新区域
   */
  onRootAreaChange(oldValue: Area, newValue: Area): void;

  /**
   * 胶囊条目组件位置
   *
   * @param capType 胶囊类型
   * @returns 组件位置
   */
  getItemPosition(capType: CapShowType): ComponentPosition | undefined;

  /**
   * 条目点击回调
   *
   * @param itemData 条目数据
   */
  onItemClick(itemData: ImmCapData): void;

  /**
   * 胶囊过渡列表态
   *
   * @param vel 过渡动效速度
   * @param scene 过渡场景标识
   */
  onCapToList(vel?: number, scene?: ImmersiveTypeScene): void;

  /**
   * 刷新胶囊内容
   * 影响参数：沉浸状态，通知数据
   */
  updateCapsuleData(): void;

  /**
   * 根据分组标识取胶囊数据
   *
   * @param groupKey 分组标识
   * @returns 胶囊数据
   */
  getCapData(groupKey?: string): ImmCapData | undefined;
}