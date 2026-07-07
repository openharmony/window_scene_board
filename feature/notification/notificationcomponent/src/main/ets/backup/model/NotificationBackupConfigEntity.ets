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
import { CustomPromise } from '@ohos/frameworkwrapper';
import { RdbStore } from '@ohos/systemuicommon/src/main/ets/database/RdbStore';
import { Column, Table } from '@ohos/systemuicommon/src/main/ets/database/TableDecorator';
import { TableEntity } from '@ohos/systemuicommon/src/main/ets/database/TableEntity';

/**
 * 单克隆单通知备份数据库置顶表实体
 */
@Table({
  name: 'NotificationConfig'
})
export class NotificationBackupConfigEntity extends TableEntity {
  protected static storePromise: CustomPromise<RdbStore> = new CustomPromise();
  /**
   * 应用包名
   */
  @Column({ name: 'bundle', type: 'string' })
  public bundle?: string;

  /**
   * 应用用户ID
   */
  @Column({ name: 'userId', type: 'number' })
  public userId?: number;

  /**
   * 应用uid
   */
  @Column({ name: 'uid', type: 'number' })
  public uid?: number;

  /**
   * 是否置顶
   */
  @Column({ name: 'pinTop', type: 'boolean' })
  public pinTop?: boolean;
}