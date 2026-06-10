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

import { NotificationBase } from './NotificationBase';
import { NotificationBaseContent, NotificationRole } from './NotificationContent';

/**
 * 普通通知
 */
export class NormalNotification extends NotificationBase {
  /**
   * 普通通知角色
   */
  readonly role: NotificationRole = NotificationRole.NORMAL;

  /**
   * 通知内容
   */
  content: NotificationBaseContent;

  /**
   * 是否可展开
   */
  isExpandable: boolean;

  public releaseImages(newNtf?: NormalNotification): void {
    super.releaseImages(newNtf);
  }
}