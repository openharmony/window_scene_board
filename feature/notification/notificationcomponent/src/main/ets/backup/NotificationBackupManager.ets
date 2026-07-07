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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { ITableProps } from '@ohos/systemuicommon/src/main/ets/database/TableModel';
import {
  NotificationBackupEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationBackupEntity';
import { SystemUICommonUtil } from '@ohos/systemuicommon';


const TAG: string = 'NotificationBackupManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationBackupManager {
  public static get = SingletonHelper.createFactory(() => new NotificationBackupManager());
  private ntfBackupMap: Map<string, NotificationBackupEntity> = new Map();

  public getBackupEntity(appName: string): NotificationBackupEntity | undefined {
    return this.ntfBackupMap.get(appName);
  }

  public reset(): void {
    this.ntfBackupMap.clear();
  }

  public isEmpty(): boolean {
    return this.ntfBackupMap.size === 0;
  }

  public setBackup<T extends NotificationBackupEntity>(appName: string, props: ITableProps<T>): void {
    let backupEntity = this.getBackupEntity(appName) ?? NotificationBackupEntity.build({
      appName: appName
    });
    SystemUICommonUtil.assign(backupEntity as Object as Record<string, Object>, props);
    this.ntfBackupMap.set(appName, backupEntity);
  }

  public async save(): Promise<void> {
    await NotificationBackupEntity.initTable();
    for (const ntfBackup of this.ntfBackupMap.values()) {
      await NotificationBackupEntity.insert(ntfBackup);
    }
  }
}