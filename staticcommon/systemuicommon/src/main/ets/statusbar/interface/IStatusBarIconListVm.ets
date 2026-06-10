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
import { PluginInfo, PluginRequestEvent } from '@ohos/frameworkwrapper';

/**
 * 状态栏图标汇总管理VM
 */
export interface IStatusBarIconListVm {

  rightIcons: PluginInfo[];

  leftIcons: PluginInfo[];

  middleIcons: PluginInfo[];

  /**
   * 状态栏图标颜色
   */
  contentColor: string;

  /**
   * 状态栏类型
   */
  statusBarType: number;

  isRenderGroupEnable: boolean;

  /**
   * 统计状态栏图标的开关状态
   */
  iconSwitchOnInfo: Set<string>;

  /**
   * 状态栏图标开关事件
   * @param event
   */
  onPluginRequestEvent(event: PluginRequestEvent): void;

  onIconVisibleSizeChange(oldValue: SizeOptions, newValue: SizeOptions, pluginName: string): void;
  /**
   * 获取排除槽位
   *
   * @param statusbarType 状态栏类型
   * @returns 排除槽位列表
   */
  getExcludeSlotList(statusbarType: number): string[] | undefined;

  /**
   * 获取左右组图标的描点
   */
  getLeftIconAnchorInfo(pluginName: string): string;
  getRightIconAnchorInfo(pluginName: string): string;

  init(): void;
}