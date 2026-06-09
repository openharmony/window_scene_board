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

import { NotificationEntry } from '../model/NotificationEntry';
import { CommonUtils } from '@ohos/basicutils';

/**
 * 通知头数据处理
 *
 * @since 2023-01-07
 */
export class NtfHeaderVM {
  /**
   * 组件回调器
   */
  private callback: HeaderCallback | null = null;

  /**
   * 初始化
   *
   * @param callback 回调器
   */
  init(callback: HeaderCallback): void {
    this.callback = callback;
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    this.callback = null;
  }

  /**
   * 设置条目展开状态
   *
   * @param isItemExpanded true展开
   */
  setItemExpandState(isItemExpanded: boolean): void {
    this.callback?.onItemExpandChange(isItemExpanded);
  }

  /**
   * 刷新次要内容
   */
  refreshSubtext(): void {
    let entry = this.callback?.getNtfEntry();
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    // 普通通知的摘要文本
    this.callback?.onUpdateSubtext(entry?.notificationContent?.additionalText!);
  }
}

/**
 * 组件回调器
 */
export interface HeaderCallback {
  /**
   * 获取通知数据
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry;

  /**
   * 条目展开状态回调
   *
   * @param isItemExpanded 条目是否展开
   */
  onItemExpandChange(isItemExpanded: boolean): void;

  /**
   * 通知头次要文本内容
   *
   * @param subtext 次要文本
   */
  onUpdateSubtext(subtext: string): void;
}