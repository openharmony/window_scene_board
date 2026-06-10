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

import power from '@ohos.power';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { pcShutdownDialogVMP } from '../pages/PcShutdownDialogVMP';

const TAG = 'SystemTools-ShutdownView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SystemTools {
  /**
   * 关机
   */
  shutdown(): void {
    log.showInfo('shutdown by user');
    try {
      power.shutdown('shutdown_by_user');
    } catch (error) {
      log.showError(`shutdown fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * 重启
   */
  reboot(): void {
    log.showInfo('rebootDevice by user');
    try {
      power.reboot('reboot_by_user');
    } catch (error) {
      log.showError(`reboot fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * 休眠
   */
  hibernate(): void {
    log.showInfo('hibernate by user');
    try {
      power.hibernate(true);
    } catch (error) {
      log.showError(`hibernate fail, error -> ${error?.code} ${error?.message}`);
    }
  }
}

let mSystemTools = new SystemTools();

export default mSystemTools as SystemTools;