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

import power from '@ohos.power';
import { LogDomain, Logger, TaskpoolUtil } from '@ohos/basicutils';
import { VibratorUtil } from '@ohos/systemuiutils';
import { PowerOffSysEventUtil, ShutdownPanelState } from '../common/PowerOffSysEventUtil';

export class PowerOffTaskPoolUtil {
  static reboot(): void {
    TaskpoolUtil.doTask(handleReboot);
  }

  static powerOff(): void {
    TaskpoolUtil.doTask(handlePowerOff);
  }
}

@Concurrent
function handleReboot(): void {
  const TAG = 'PowerOffTaskPoolUtil';
  const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
  log.showWarn(TAG, 'poweroff reboot');
  PowerOffSysEventUtil.reportPowerOffEvent(PowerOffSysEventUtil.SHUTDOWN_PANEL,
    ShutdownPanelState.SHUTDOWN_REBOOT_CONFIRM);
  power.reboot('SystemUI Reboot');
}

@Concurrent
function handlePowerOff() {
  const TAG = 'PowerOffTaskPoolUtil';
  const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
  log.showWarn(TAG, 'poweroff shutdown');
  PowerOffSysEventUtil.reportPowerOffEvent(PowerOffSysEventUtil.SHUTDOWN_PANEL,
    ShutdownPanelState.SHUTDOWN_CONFIRM);
  power.shutdown('SystemUI Shutdown');
  // 关机振动
  VibratorUtil.startVibration('haptic.notice.off', 'physicalFeedback', 100);
}