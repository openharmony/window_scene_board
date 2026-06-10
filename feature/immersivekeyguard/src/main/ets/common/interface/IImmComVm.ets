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

import { ImmersiveState } from '@ohos/systemuicommon';
import { IImmCurDataCtrlVm } from './IImmCurDataCtrlVm';
import { IImmersiveExtendVm } from './IImmersiveExtendVm';
import { IImmLifeCycleVm } from './IImmLifeCycleVm';

/**
 * 沉浸模块通用业务抽象层
 */
export interface IImmComVm extends IImmersiveExtendVm, IImmLifeCycleVm {
  /**
   * 设置沉浸状态默认值
   */
  setDefaultImmState(): void;

  /**
   * 沉浸状态中胶囊是否显示
   *
   * @returns true胶囊显示
   */
  isShowCapsule(): boolean;

  /**
   * 沉浸状态中列表是否显示
   *
   * @returns true列表显示
   */
  isShowList(): boolean;

  /**
   * 沉浸状态中大卡是否显示
   *
   * @returns true大卡显示
   */
  isShowCard(): boolean;

  /**
   * 沉浸状态
   *
   * @returns 沉浸状态
   */
  getImmState(): ImmersiveState;

  /**
   * 进入沉浸态前状态
   *
   * @returns 前状态
   */
  getBeforeImmState(): ImmersiveState;

  /**
   * 当前是否为AOD状态
   *
   * @returns true AOD
   */
  isAod(): boolean;

  /**
   * 及时刷新锁定状态，默认锁屏时调用
   */
  refreshLockVerify(): void;

  /**
   * 赋值当前沉浸态数据标识
   *
   * @param groupKey 分组标识
   */
  setCurImmData(groupKey?: string): void;

  /**
   * 注册当前沉浸态数据控制器
   *
   * @param ctrl 控制器
   */
  registerImmCurDataCtrl(ctrl: IImmCurDataCtrlVm): void;

  /**
   * 注销当前沉浸态数据控制器
   *
   * @param ctrl 控制器
   */
  unregisterImmCurDataCtrl(ctrl: IImmCurDataCtrlVm): void;

  /**
   * 主动请求当前沉浸态数据
   *
   * @param ctrl 控制器
   */
  requestImmCurData(ctrl: IImmCurDataCtrlVm): void;
}