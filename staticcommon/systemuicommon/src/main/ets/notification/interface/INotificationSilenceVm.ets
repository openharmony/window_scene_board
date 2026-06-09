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
import { NotificationConfigBaseManager } from '../../manager/NotificationConfigBaseManager';
import { NotificationBase } from '../../model/NotificationBase';

export interface INotificationSilenceVm {
  /**
   * 初始化
   * @param manager
   */
  init(manager: NotificationConfigBaseManager, controller: CustomDialogController): void;

  /**
   * 设置应用静默状态
   * @param uid 应用uid
   * @Param bundleName 应用包名
   * @param enabled 是否置顶
   * @returns 应用静默状态
   */
  setSilence(ntf: NotificationBase, enabled: boolean): Promise<boolean>;

  /**
   * 应用名
   */
  silentAppLabel: string;

  /**
   * 打开静默通知弹窗
   */
  openSilenceDialog(): void;

  /**
   * 打开静默通知弹窗
   */
  closeSilenceDialog(): void;

  /**
   * 点击取消
   */
  onCancel(): void;

  /**
   * 点击确定
   * @returns
   */
  onConfirm(): Promise<void>;

  /**
   * 静默通知弹窗是否展示
   */
  isSilenceDialogShow: boolean;

  /**
   * 弹框标题
   * @returns
   */
  getDialogTitle(): string

  ntf?: NotificationBase;

  /**
   * 隐藏弹框
   */
  hide(): void;

  /**
   * 弹框标题
   */
  dialogTitle: string;

  /**
   * 是否展示弹窗
   */
  isShowFlag: boolean;
}