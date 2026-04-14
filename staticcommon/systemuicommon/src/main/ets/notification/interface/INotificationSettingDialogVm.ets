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
import { NotificationBase } from '../../model/NotificationBase';
import { NotificationSettingDialogModel } from '../model/NotificationSettingDialogModel';

export interface INotificationSettingDialogVm {
  readonly settingDiagData: NotificationSettingDialogModel;

  showHideButton: boolean;

  /**
   * 弹窗列表组件ID
   */
  componentId: string;

  init(): void;

  unInit(): void;

  /**
   * 打开设置弹窗
   * @param ntf
   * @param buttonPosition
   */
  openSetting(ntf: NotificationBase, buttonPosition: Position): Promise<void>;

  /**
   * 隐藏
   */
  hide(): void;

  /**
   * 设置弹窗标题
   */
  setDialogTitle(): void;

  ntf?: NotificationBase;

  /**
   * 打开静默通知
   */
  silentNtf: () => Promise<void>;

  /**
   * 重置状态栏层级，使菜单页面背景无状态栏
   */
  getStatusBarReset(): void;
}