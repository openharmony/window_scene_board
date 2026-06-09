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
import { SystemUIUseScene } from '../constants/SystemuiConstants';
import { BaseVmInjector } from '../vm/BaseVmInjector';
import { IStatusBarAnimVm } from './interface/IStatusBarAnimVm';
import { IStatusBarIconAnimVm } from './interface/IStatusBarIconAnimVm';
import { IStatusBarIconListVm } from './interface/IStatusBarIconListVm';
import { IStatusBarIconVm } from './interface/IStatusBarIconVm';
import { IStatusBarLayoutVm } from './interface/IStatusBarLayoutVm';
import { IStatusBarPaddingVm } from './interface/IStatusBarPaddingVm';
import { IStatusBarSettingVm } from './interface/IStatusBarSettingVm';
import { IMouseTypeStyleVm } from './interface/IMouseTypeStyleVm';
import { IStatusBarVmInjector } from './interface/IStatusBarVmInjector';

export abstract class StatusBarVmInjector extends BaseVmInjector implements IStatusBarVmInjector {
  /**
   * 空的占位符，用于赋值给装饰@Consumer的变量，解决@Consumer必须指定初始值的问题
   */
  public static readonly HOLDER = 0 as Object as StatusBarVmInjector;

  public readonly scene: SystemUIUseScene = SystemUIUseScene.STATUSBAR;

  /**
   * 获取状态栏每个图标的VM
   * @returns
   */
  abstract getStatusBarIconVm(pluginName: string): IStatusBarIconVm;

  /**
   * 获取状态栏设置管理的VM，主要负责纯净显示开关，实时网速开关和通知图标开光关
   * @returns
   */
  abstract getStatusBarSettingVm(): IStatusBarSettingVm;

  /**
   * 获取状态栏布局的VM
   * @returns
   */
  abstract getStatusBarLayoutVm(): IStatusBarLayoutVm;

  /**
   * 获取状态栏图标列表管理的VM，所有状态栏图标的显隐控制将汇总在这个VM中管理
   * @returns
   */
  abstract getStatusBarIconListVm(): IStatusBarIconListVm;

  /**
   * 获取状态栏动效的VM
   * @returns
   */
  abstract getStatusBarAnimVm(): IStatusBarAnimVm;

  /**
   * 获取状态栏图标的动效VM
   * @returns
   */
  abstract getStatusBarIconAnimVm(): IStatusBarIconAnimVm;

  /**
   * 获取状态栏paddingVM
   */
  abstract getStatusBarPaddingVm(): IStatusBarPaddingVm;

  /**
   * 鼠标属性
   */
  abstract getMouseTypeStyleVm(): IMouseTypeStyleVm;
}