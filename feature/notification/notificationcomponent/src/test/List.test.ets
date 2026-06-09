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

import { NotificationEntryTest } from './NotificationEntry.test';
import { NtfHeadsUpVMTest } from './NtfHeadsUpVM.test';
import { NtfHeaderVMTest } from './NtfHeaderVM.test';
import { NotificationListAdapterTest } from './NotificationListForEachAdapter.test';
import { NotificationTypeTest } from './NotificationType.test';
import { NotificationAnimationParasTest } from './NotificationAnimationParas.test';
import { NotificationConfigTest } from './NotificationConfig.test';
import { NotificationExtraHeaderTest } from './NotificationExtraHeader.test';
import { NotificationHeadsUpItemTest } from './NotificationHeadsUPItem.test';

export default function testsuite() {
  NtfHeaderVMTest();
  NtfHeadsUpVMTest();
  NotificationTypeTest();
  NotificationEntryTest();
  NotificationHeadsUpItemTest();
  NotificationListAdapterTest();
  NotificationAnimationParasTest();
  NotificationConfigTest();
  NotificationExtraHeaderTest();
}
