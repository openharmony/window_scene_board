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
import { PluginInfo, PluginRequestEvent } from '@ohos/frameworkwrapper';
import { StatusBarType } from '../../plugin/info/StatusBarType';
import { StatusBarCapsulePosition } from '../model/StatusBarCapsulePosition';
import { IStatusBarIconVm } from './IStatusBarIconVm';

/**
 * 状态栏
 */
export interface IStatusBarVm {

  rightIcons: PluginInfo[];

  leftIcons: PluginInfo[];

  middleIcons: PluginInfo[];

  /**
   * 实况胶囊的位置
   */
  capsulePosition: StatusBarCapsulePosition;

  /**
   * 胶囊左侧X坐标,用于计算左侧剩余可放置图标区域宽度
   */
  capsuleLeftX: number;

  /**
   * 胶囊右侧X坐标,用于计算右侧剩余可放置图标区域宽度
   */
  capsuleRightX: number;

  /**
   * 状态栏左侧group最大可显示宽度
   */
  getLeftGroupMaxSpace(): number;

  /**
   * 状态栏右侧group最大可显示宽度
   */
  getRightGroupMaxSpace(): number;

  /**
   * 状态栏图标颜色
   */
  contentColor: string;

  /**
   * 状态栏左侧图标padding
   */
  statusBarPaddingLeft: number;

  /**
   * 状态栏顶部图标margin
   */
  get statusBarMarginTop(): number;

  /**
   * 系统图标之间的间隔
   */
  iconGap: number;

  /**
   * 状态栏类型
   */
  statusBarType: number;

  isRenderGroupEnable: boolean;

  init(): void;

  /**
   * 中间区域宽度、位置变化事件
   * @param oldArea
   * @param newArea
   */
  onMiddleAreaChange(oldArea: Area, newArea: Area): void;

  /**
   * 胶囊位置变化回调，需要刷新状态栏布局
   * @param width
   */
  onCapsulePositionChange(left: number, right: number): void;
  /**
   * 胶囊左侧宽度变化回调，需要刷新状态栏布局
   * @param width
   */
  onCapsuleLeftChange(deltaWidth: number): void;

  /**
   * 胶囊右侧宽度变化回调，需要刷新状态栏布局
   * @param width
   */
  onCapsuleRightChange(deltaWidth: number): void;


  setStatusBarType(statusBar: StatusBarType): void;

  /**
   * 状态栏图标开关事件
   * @param event
   */
  onPluginRequestEvent(event: PluginRequestEvent): void;


  onIconVisibleSizeChange(oldValue: SizeOptions, newValue: SizeOptions, pluginName: string): void;


  getIconVmByName(pluginName: string): IStatusBarIconVm;

}