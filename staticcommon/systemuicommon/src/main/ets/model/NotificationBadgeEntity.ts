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

import { Column, Table } from '../database/TableDecorator';
import { TableEntity } from '../database/TableEntity';

/**
 * 系统迁移应用角标开关
 */
@Table({
  name: 'BadgeRestore'
})
export class NotificationBadgeEntity extends TableEntity {
  /**
   * 应用设备包名
   */
  @Column({ name: 'packageName', type: 'string' })
  public packageName: string;

  /**
   * 角标开关
   */
  @Column({ name: 'showBadge', type: 'boolean' })
  public showBadge: boolean;
}