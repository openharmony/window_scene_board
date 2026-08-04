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

import { Context } from '@kit.AbilityKit';
import { relationalStore } from '@kit.ArkData';
import { RdbStore } from '@ohos/systemuicommon/src/main/ets/database/RdbStore';
import {
  NotificationBackupPhoneMgrCommonEntity
} from '../model/NotificationBackupPhoneMgrCommonEntity';
import {
  NotificationBackupPhoneMgrNtfEntity
} from '../model/NotificationBackupPhoneMgrNtfEntity';
import {
  NotificationBackupPhoneMgrNtfCfgEntity
} from '../model/NotificationBackupPhoneMgrNtfCfgEntity';
import { SingletonHelper } from '@ohos/basicutils';

export class NotificationBackupPhoneMgrStore extends RdbStore {
  public static get = SingletonHelper.createFactory(() => new NotificationBackupPhoneMgrStore());

  constructor() {
    super({
      name: 'phoneManager_back.db',
      securityLevel: relationalStore.SecurityLevel.S1,
    });
  }

  /**
   * 初始化数据库
   * @param context 上下文
   */
  public async init(context: Context): Promise<void> {
    const dbContext: Context = context.getApplicationContext();
    await this.initStore(dbContext);
    this.initTable();
  }

  /**
   * 初始化表
   */
  private initTable(): void {
    NotificationBackupPhoneMgrCommonEntity.init(this);
    NotificationBackupPhoneMgrNtfEntity.init(this);
    NotificationBackupPhoneMgrNtfCfgEntity.init(this);
  }
}