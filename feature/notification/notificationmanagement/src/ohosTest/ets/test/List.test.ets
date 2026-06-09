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

import { NotificationMgmtCommonTest } from './ets/common/NotificationMgmtCommon.test';
import { NtfSearchControllerTest } from './ets/common/NtfSearchController.test';
import { NotificationContextManagerTest } from './ets/MainAbility/ContextManager.test';
import { NotificationMgmtModelTest01, NotificationMgmtModelTest02 } from './ets/model/NotificationMgmtModel.test';
import {
  NotificationMgmtViewDataTest01,
  NotificationMgmtViewDataTest02,
  NotificationMgmtViewDataTest03,
  VisualReminderViewDataTest,
  SoltCfgTest,
  SlotViewDataTest,
  NotificationStateTest,
} from './ets/vm/NotificationMgmtViewData.test';
import { NotificationMgmtViewEventTest } from './ets/vm/NotificationMgmtViewEvent.test';
import { NotificationManagenmentViewModelTest } from './ets/vm/notificationManagenmentViewModel.test';


export default function NotificationManagementTestSuite() {
  NotificationMgmtCommonTest();
  NtfSearchControllerTest();
  NotificationContextManagerTest();
  NotificationMgmtModelTest01();
  NotificationMgmtModelTest02();
  NotificationMgmtViewDataTest01();
  NotificationMgmtViewDataTest02();
  NotificationMgmtViewDataTest03();
  VisualReminderViewDataTest();
  SoltCfgTest();
  SlotViewDataTest();
  NotificationStateTest();
  NotificationMgmtViewEventTest();
  NotificationManagenmentViewModelTest();
}
