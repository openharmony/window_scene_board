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
import { RemoveButtonData, SettingButtonData } from '../model/NotificationMenuModel';

export interface INotificationMenuVm {
  /**
   * 按钮宽度
   */
  readonly menuWidth: number;

  /**
   * 是否在组通知中
   */
  isInGroup: boolean;
  /**
   * 删除按钮参数
   */
  removeButtonData: RemoveButtonData;
  /**
   * 设置按钮参数
   */
  settingButtonData: SettingButtonData;

  /**
   * 是否显示设置按钮
   * @returns
   */
  isShowSettingButton(): boolean;

  /**
   * 是否显示删除按钮
   * @returns
   */
  isShowRemoveButton(): boolean;

  /**
   * 菜单是否展开
   * @returns
   */
  isMenuExpanded(): boolean;

  /**
   * 删除通知
   * @param offsetX offsetX
   * @returns
   */
  removeNtf(offsetX?: number): void

  /**
   * 更新滑动距离
   * @param offsetX 滑动距离
   * @param isSwipeRemoving 是否正在删除
   */
  updateSwipeOffsetX(offsetX: number, isSwipeRemoving: boolean): void

  /**
   * 设置按钮点击事件
   */
  onSettingButtonClick(): void;
}