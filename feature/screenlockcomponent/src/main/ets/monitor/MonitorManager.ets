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

import { PowerStatusMonitor } from '@ohos/screenlockcommon/Index';

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemSwitchUtils } from '@ohos/screenlockcommon';
import { CommonUtil } from '@ohos/screenlockcommon/src/main/ets/utils/CommonUtil';
import { SettingsDBMonitor } from './SettingsDBMonitor';

const TAG: string = 'MonitorManager';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class MonitorManager {
  private static instance: MonitorManager;

  private constructor() {
  }

  public static getInstance(): MonitorManager {
    if (!MonitorManager.instance) {
      MonitorManager.instance = new MonitorManager();
    }
    return MonitorManager.instance;
  }

  public init(): void {
    CommonUtil.runWithoutException(TAG, 'init', () => {
      this.initPowerMonitor();
      SettingsDBMonitor.getInstance().init();
    });
  }

  public initPowerMonitor() {
    CommonUtil.runWithoutException(TAG, 'init', () => {
      log.showInfo('init');
      PowerStatusMonitor.getInstance().init();
    });
  }

  public destroy(needSimMonitor: boolean = true): void {
    CommonUtil.runWithoutException(TAG, 'destroy', () => {
      PowerStatusMonitor.getInstance().unregisterListener();
      SettingsDBMonitor.getInstance().unregisterListener();
    });
  }
}
