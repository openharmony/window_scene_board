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
 * 双克隆单手管数据置顶、公共数据表
 */
@Table({
  name: 'comhuaweisystemmanagerCommonPrefBackupProviderCommonPreferences_tb'
})
export class NotificationBackupPhoneMgrCommonEntity extends TableEntity {
  protected static storePromise: CustomPromise<RdbStore> = new CustomPromise();

  /**
   * key
   */
  @Column({ name: 'preference_key', type: 'string' })
  public preferenceKey?: string;

  /**
   * value
   */
  @Column({ name: 'preference_value', type: 'string' })
  public preferenceValue?: string;
}