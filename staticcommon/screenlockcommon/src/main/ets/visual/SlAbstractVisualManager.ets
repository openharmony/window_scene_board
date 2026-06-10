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
import { CcmOption, SlAreaType, SlPositionType } from '../constants/CommonConstants';
import { SlVisualArgs } from './SlVisualData';
import { ISlVisualManager } from './ISlVisualManager';
import { SolidColorListener } from './SlSolidColorManager';
import { SlVisualConfigManager } from './SlVisualConfigManager';
import { SlVisualControl } from './SlVisualControl';

/**
 * 锁屏视效管理接入客户端抽象类
 */
export abstract class SlAbstractVisualManager implements ISlVisualManager {
  /**
   * 组件当前所在锁屏区域
   */
  abstract getAreaType(): SlAreaType;

  /**
   * 查询当前模块所有视效参数
   *
   * @param positionType 参数使用位置
   * @returns 视效参数数组
   */
  abstract getAllVisualArgs(): SlVisualArgs[];

  /**
   * 初始化
   */
  init(): void {
    SlVisualControl.getInstance().registerSlVisualArr(this.getAllVisualArgs());
    SlVisualControl.getInstance().registerSolidListener(this.getAreaType(), this.getSolidListener());
  }

  /**
   * 销毁
   */
  destroy(): void {
    SlVisualControl.getInstance().unregisterSlVisualArr(this.getAllVisualArgs());
    SlVisualControl.getInstance().unregisterSolidListener(this.getAreaType(), this.getSolidListener());
  }

  /**
   * 查询对应区域CCM配置
   *
   * @param option 需要查询的属性
   * @returns 查询结果
   */
  getEnable(option: CcmOption): boolean {
    return SlVisualConfigManager.getInstance().getEnable(option, this.getAreaType());
  }

  /**
   * 更新锁屏元素根组件区域
   *
   * @param slArea 组件类型
   * @param area 组件区域坐标
   */
  updateComponentArea(slAreaType: SlAreaType, area: Area): void {
    SlVisualControl.getInstance().updateComponentArea(slAreaType, area);
  }

  /**
   * 查询提亮参数
   *
   * @param positionType 参数使用位置
   * @returns 提亮参数
   */
  getVisualArgs(positionType: SlPositionType): SlVisualArgs | undefined {
    return SlVisualControl.getInstance().getVisualArgs(positionType);
  }

  /**
   * 查询纯色监听器, 子类根据场景当纯色刷新后按需触发监听器逻辑
   *
   * @returns 监听器
   */
  getSolidListener(): SolidColorListener | undefined {
    return undefined;
  }
}