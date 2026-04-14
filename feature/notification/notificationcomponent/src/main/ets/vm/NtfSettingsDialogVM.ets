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
import type { NotificationEntry } from '../model/NotificationEntry';

/**
 * 通知设置弹框数据处理
 *
 * @since 2023-01-13
 */
export class NtfSettingsDialogVM {
  /**
   * 通知数据
   */
  private ntfEntry: NotificationEntry | null = null;

  /**
   * 回调器
   */
  private callback: SettingsDialogCallback | null = null;

  /**
   * 弹窗偏移位置X轴
   */
  private dialogLeft: number = 0;

  /**
   * 弹窗偏移位置Y轴
   */
  private dialogTop: number = 0;

  /**
   * 初始化
   *
   * @param callback 回调器
   */
  init(callback: SettingsDialogCallback): void {
    this.callback = callback;
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    this.callback = null;
  }

  /**
   * 设置弹框通知数据
   *
   * @param ntfEntry 通知数据
   */
  setDialogNtfEntry(ntfEntry: NotificationEntry | null): void {
    this.ntfEntry = ntfEntry;
    if (ntfEntry != null) {
      this.callback?.onNtfEntryChange(ntfEntry);
    }
  }

  /**
   * 获取当前弹框的通知数据
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry {
    return this.ntfEntry as NotificationEntry;
  }
}

/**
 * 通知设置弹框回调器
 */
export interface SettingsDialogCallback {
  /**
   * 弹框通知数据切换回调
   *
   * @param ntfEntry 通知数据
   */
  onNtfEntryChange(ntfEntry: NotificationEntry): void;
}