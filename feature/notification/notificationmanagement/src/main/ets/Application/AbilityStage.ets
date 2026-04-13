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

import AbilityStage from '@ohos.app.ability.AbilityStage';
import {
  CommonExceptionMaintenance,
  pinTopDialogConfigManager,
  NtfPinTopLimitDialogConfigPc,
  LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { Trace } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/Trace';
import { NtfManagementTrace } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import {
  notificationSettingStore
} from '@ohos/managementcomponent/src/main/ets/com/ohos/database/NotificationSettingStore';
import { SettingExceptionReporter } from '../maintenance/SettingExceptionReporter';
import { DeviceHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/DeviceHelper';

const TAG = 'NotificationManagement_AbilityStage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export default class MainAbilityStage extends AbilityStage {
  onCreate(): void {
    log.showInfo('onCreate');
    Trace.start(NtfManagementTrace.TRACE_PROCESS_INIT);
    ContextManager.context = this.context;
    if (DeviceHelper.isPhoneOrPad()) {
      CommonExceptionMaintenance.get().init(new SettingExceptionReporter());
    }
    if (DeviceHelper.isPC()) {
      pinTopDialogConfigManager.setConfig(new NtfPinTopLimitDialogConfigPc());
    }
    notificationSettingStore.init(this.context);
    notificationSettingManager.init();
    notificationSettingManager.preloadAppList();
  }
}