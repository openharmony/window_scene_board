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
import { IBaseVmInjector } from '../../vm/IBaseVmInjector'
import { IStatusBarAnimVm } from './IStatusBarAnimVm';
import { IStatusBarIconAnimVm } from './IStatusBarIconAnimVm';
import { IStatusBarIconListVm } from './IStatusBarIconListVm';
import { IStatusBarIconVm } from './IStatusBarIconVm';
import { IStatusBarLayoutVm } from './IStatusBarLayoutVm';
import { IStatusBarPaddingVm } from './IStatusBarPaddingVm';
import { IStatusBarSettingVm } from './IStatusBarSettingVm';
import { IMouseTypeStyleVm } from './IMouseTypeStyleVm';

export interface IStatusBarVmInjector extends IBaseVmInjector {

  /**
   * 获取状态栏每个图标的VM
   * @returns
   */
  getStatusBarIconVm(pluginName: string): IStatusBarIconVm;

  /**
   * 获取状态栏设置管理的VM，主要负责纯净显示开关，实时网速开关和通知图标开光关
   * @returns
   */
  getStatusBarSettingVm(): IStatusBarSettingVm;

  /**
   * 获取状态栏布局的VM
   * @returns
   */
  getStatusBarLayoutVm(): IStatusBarLayoutVm;

  /**
   * 获取状态栏图标列表管理的VM，所有状态栏图标的显隐控制将汇总在这个VM中管理
   * @returns
   */
  getStatusBarIconListVm(): IStatusBarIconListVm;

  /**
   * 获取状态栏动效的VM
   * @returns
   */
  getStatusBarAnimVm(): IStatusBarAnimVm;

  /**
   * 获取状态栏图标的动效VM
   * @returns
   */
  getStatusBarIconAnimVm(): IStatusBarIconAnimVm;

  /**
   * 获取状态栏paddingVM
   */
  getStatusBarPaddingVm(): IStatusBarPaddingVm;

  /**
   * 鼠标属性
   */
  getMouseTypeStyleVm(): IMouseTypeStyleVm;
}

