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
import { RdbStore, NotificationStoreConfig, NotificationConfigEntity } from '../common/BasicCommon';

class NotificationSettingStore extends RdbStore {
  constructor() {
    super({
      name: NotificationStoreConfig.DB_NAME,
      securityLevel: NotificationStoreConfig.DB_SECURITY_LEVEL,
    });
  }

  /**
   * 初始化数据库
   * @param context 上下文
   * @param createNewContext 是否创建新的上下文，避免影响原始上下文
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
    NotificationConfigEntity.init(this);
  }
}

export const notificationSettingStore = new NotificationSettingStore();