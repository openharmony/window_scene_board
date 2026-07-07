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
 * 备份恢复应用开关
 */
@Table({
  name: 'NotificationBackup'
})
export class NotificationBackupEntity extends TableEntity {
  /**
   * 应用包名
   */
  @Column({ name: 'appName', type: 'string' })
  public appName: string;

  /**
   * 通知开关
   */
  @Column({ name: 'notificationEnable', type: 'boolean' })
  public notificationEnable?: boolean;

  /**
   * 角标开关
   */
  @Column({ name: 'showBadge', type: 'boolean' })
  public showBadge?: boolean;

  /**
   * 置顶开关
   */
  @Column({ name: 'isPinTop', type: 'boolean' })
  public isPinTop?: boolean;

  /**
   * 横幅开关
   */
  @Column({ name: 'bannerNotifyEnable', type: 'string' })
  public bannerNotifyEnable?: string;

  /**
   * 锁屏通知开关
   */
  @Column({ name: 'lockNotifyEnable', type: 'string' })
  public lockNotifyEnable?: string;

  /**
   * 铃声开关
   */
  @Column({ name: 'soundEnable', type: 'string' })
  public soundEnable?: string;

  /**
   * 震动开关
   */
  @Column({ name: 'vibrationEnable', type: 'string' })
  public vibrationEnable?: string;

  /**
   * 是否是设备包名
   */
  @Column({ name: 'isPkgName', type: 'boolean' })
  public isPkgName?: boolean;
}