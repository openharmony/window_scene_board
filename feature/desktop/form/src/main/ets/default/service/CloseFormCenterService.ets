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

import { rpc } from '@kit.IPCKit';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { FormCenterViewManager, IExecutor } from '@ohos/launchercommon';
import { ServiceReturnMsg } from './ServiceInterface';

const TAG: string = 'CloseFormCenterService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class CloseFormCenterService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    log.showInfo('close form center view');
    FormCenterViewManager.getInstance().closeFormCenterView();
    return ServiceReturnMsg.RET_SUCCESS;
  }
}