/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import NotificationNormalVmTest from './NotificationNormalVm.test'
import BannerFloatingControllerTest from './controller/BannerFloatingController.test'
import NotificationDropdownControllerTest from './controller/NotificationDropdownController.test'
import NtfItemSwipeControllerTest from './controller/NtfItemSwipeController.test'
import NtfListScrollControllerTest from './controller/NtfListScrollController.test'
import PinTopLimitDialogControllerTest from './controller/PinTopLimitDialogController.test'
import HideBannerNtfContentObjTest from './model/HideBannerNtfContentObj.test'
import NotificationConstantsTest from './common/NotificationConstants.test'
import NtfSingleItemVMTest from './vm/NtfSingleItemVM.test'
import KeyguardNtfActionVMTest from './vm/KeyguardNtfActionVM.test'
import NotificationManagerTest from './model/NotificationManager.test'
import NotificationSysEventReporterTest from './controller/NotificationSysEventReporter.test'
import CampaignNotificationFilterTest from './common/CampaignNotificationFilter.test';

export default function NotificationComponentTest() {
  CampaignNotificationFilterTest();
  BannerFloatingControllerTest();
  NotificationDropdownControllerTest();
  NtfItemSwipeControllerTest();
  NtfListScrollControllerTest();
  PinTopLimitDialogControllerTest();
  HideBannerNtfContentObjTest();
  NotificationConstantsTest();
  NtfSingleItemVMTest();
  KeyguardNtfActionVMTest();
  NotificationManagerTest();
  NotificationSysEventReporterTest();
  NotificationNormalVmTest()
}