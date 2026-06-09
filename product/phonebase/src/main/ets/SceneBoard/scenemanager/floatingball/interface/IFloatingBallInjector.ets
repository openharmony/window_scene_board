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

import { IFloatingBallListVm } from './IFloatingBallListVm';
import { IFloatingBallMenuVm } from './IFloatingBallMenuVm';
import { IFloatingBallPanelVm } from './IFloatingBallPanelVm';
import { IFloatingBallRectVm } from './IFloatingBallRectVm';

export interface IFloatingBallInjector {
  /**
   * 获取悬浮球面板的VM，负责管理悬浮球生命周期
   * @returns 返回悬浮球面板VM
   */
  getPanelVm(): IFloatingBallPanelVm;

  /**
   * 获取悬浮球尺寸的VM，负责管理悬浮球面板位置、大小
   * @returns 返回悬浮球尺寸VM
   */
  getRectVm(): IFloatingBallRectVm;

  /**
   * 获取悬浮球List的VM，负责管理悬浮球个数
   * @returns 返回悬浮球列表VM
   */
  getListVm(): IFloatingBallListVm;

  /**
   * 获取悬浮球菜单的VM，负责管理悬浮球菜单
   * @returns 返回悬浮球菜单VM
   */
  getMenuVm(): IFloatingBallMenuVm;

  /**
   * 销毁vm
   */
  destroy(): void;
}