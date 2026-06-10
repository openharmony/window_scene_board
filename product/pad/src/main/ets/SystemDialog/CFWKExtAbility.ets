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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import lazy { ResourceUtil, SystemDialogController, CFWKSysDialogStub } from '@ohos/collaborationfwkdialog'
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'CFWKDialogServiceExtAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class CFWKDialogServiceExtAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    log.showInfo('onCreate');
    ResourceUtil.setContext(this.context);
    SystemDialogController.getInstance().setContext(this.context);
  }

  onConnect(): CFWKSysDialogStub {
    log.showInfo('onConnect');
    return new CFWKSysDialogStub('SystemDialog');
  }

  onDisconnect(): void {
    log.showInfo('onDisconnect');
  }

  onDestroy(): void {
    log.showInfo('onDestroy');
    ResourceUtil.clearContext();
    SystemDialogController.getInstance().closeAll();
  }
}