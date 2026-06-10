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
import {
  SlVisualArgs,
  CcmOption,
  SlAreaType,
  SlFeatureType,
  SlPositionType,
  SlVisualConfigManager,
} from '@ohos/screenlockcommon';
import { SlAbstractVisualManager } from '@ohos/screenlockcommon/Index';
import { ClockVisualManager } from './ClockVisualManager';
import { LockIconVisualManager } from './LockIconVisualManager';
import { SlFormVisualManager } from './SlFormVisualManager';
import { ImmersiveCapsuleVisualManager } from './ImmersiveCapsuleVisualManager';
import { ImmersiveListVisualManager } from './ImmersiveListVisualManager';
import { ImmersiveCardVisualManager } from './ImmersiveCardVisualManager';

/**
 * 锁屏主页面视效管理控制器
 * 用于锁屏主页面各业务视效参数生命周期管理
 */
export class SlVisualVc {
  /**
   * 各子业务视效参数
   */
  private subVisualManagers: Map<SlFeatureType, SlAbstractVisualManager> = new Map();

  constructor() {
    this.subVisualManagers.set(SlFeatureType.LOCK_ICON, new LockIconVisualManager());
    this.subVisualManagers.set(SlFeatureType.CLOCK_MAIN, new ClockVisualManager());
    this.subVisualManagers.set(SlFeatureType.FORM, new SlFormVisualManager());
    this.subVisualManagers.set(SlFeatureType.CAPSULE, new ImmersiveCapsuleVisualManager());
    this.subVisualManagers.set(SlFeatureType.NTF_LIST, new ImmersiveListVisualManager());
    this.subVisualManagers.set(SlFeatureType.IMMERSIVE_CARD, new ImmersiveCardVisualManager());
  }

  /**
   * 锁屏主页面上树，注册提亮参数
   */
  init(): void {
    this.subVisualManagers.forEach((value: SlAbstractVisualManager) => {
      value.init();
    })
  }

  /**
   * 锁屏主页面下树，各个元素的提亮参数注销，避免冗余刷新
   */
  destroy(): void {
    this.subVisualManagers.forEach((value: SlAbstractVisualManager) => {
      value.destroy();
    })
  }

  /**
   * 查询提亮参数
   *
   * @param SlFeatureType 业务类型
   * @param positionType 参数使用位置
   * @returns 提亮参数
   */
  getBrightArgs(type: SlFeatureType, positionType: SlPositionType): SlVisualArgs | undefined {
    return this.subVisualManagers.get(type)?.getVisualArgs(positionType);
  }

  /**
   * 更新锁屏元素根组件区域
   *
   * @param type 业务类型
   * @param slArea 组件类型
   * @param area 组件区域坐标
   */
  updateComponentArea(type: SlFeatureType, slAreaType: SlAreaType, area: Area): void {
    this.subVisualManagers.get(type)?.updateComponentArea(slAreaType, area);
  }

  /**
   * 查询对应区域CCM配置
   *
   * @param type 业务类型
   * @param option 需要查询的属性
   * @returns 查询结果
   */
  getEnable(type: SlFeatureType, option: CcmOption): boolean {
    return this.subVisualManagers.get(type)?.getEnable(option) ?? false;
  }

  /**
   * 查询锁屏主页面模糊是否关闭
   *
   * @returns true 标识模糊关闭
   */
  getMainViewEffectDisabled(): boolean {
    return !SlVisualConfigManager.getInstance().getEnable(CcmOption.EFFECT);
  }
}