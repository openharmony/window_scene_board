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
import { CcmOption, SlAreaType, SlPositionType } from '../constants/CommonConstants';
import { SlVisualArgs } from './SlVisualData';
import { SolidColorListener } from './SlSolidColorManager';

/**
 * 锁屏视效管理接入客户端接口，用于定义接入客户端的行为
 */
export interface ISlVisualManager {
  /**
   * 组件当前所在锁屏区域
   *
   */
  getAreaType(): SlAreaType;

  /**
   * 查词对应区域CCM配置
   *
   * @param option 需要查询的属性
   * @returns 查询结果
   */
  getEnable(option: CcmOption): boolean;

  /**
   * 查询当前模块所有视效参数
   *
   * @param positionType 参数使用位置
   * @returns 视效参数数组
   */
  getAllVisualArgs(): SlVisualArgs[];

  /**
   * 查询纯色监听器
   *
   * @returns 监听器
   */
  getSolidListener(): SolidColorListener | undefined;

  /**
   * 更新锁屏元素根组件区域
   *
   * @param slArea 组件所在锁屏区域类型
   * @param area 组件区域坐标
   */
  updateComponentArea(slAreaType: SlAreaType, area: Area): void;

  /**
   * 查询视效参数
   *
   * @param positionType 参数使用位置
   * @returns 视效参数
   */
  getVisualArgs(positionType: SlPositionType): SlVisualArgs | undefined;

  /**
   * 初始化
   */
  init(): void;

  /**
   * 销毁
   */
  destroy(): void;
}