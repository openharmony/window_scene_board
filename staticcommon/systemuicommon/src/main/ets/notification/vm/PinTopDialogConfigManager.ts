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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { NtfPinTopLimitDialogConfig } from './NtfPinTopLimitDialogConfig';
import lazy { NtfPinTopLimitDialogConfigPc } from './NtfPinTopLimitDialogConfigPc';
import lazy { NtfPinTopLimitDialogConfigTv } from './NtfPinTopLimitDialogConfigTv';

const TAG = 'PinTopDialogConfigManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

class PinTopDialogConfigManager {
  private static instance: PinTopDialogConfigManager;
  // 置顶应用超5个时弹框参数
  private config : NtfPinTopLimitDialogConfig = this.getInitConfig();

  private constructor() {
  }

  public static getInstance(): PinTopDialogConfigManager {
    if (PinTopDialogConfigManager.instance === undefined) {
      PinTopDialogConfigManager.instance = new PinTopDialogConfigManager();
    }
    return PinTopDialogConfigManager.instance;
  }

  public setConfig(config: NtfPinTopLimitDialogConfig): void {
    log.showInfo('set NotificationPinTopLimitDialogConfig');
    this.config = config;
  }

  public getConfig(): NtfPinTopLimitDialogConfig {
    return this.config;
  }

  private getInitConfig(): NtfPinTopLimitDialogConfig {
    if (DeviceHelper.isPC()) {
      return new NtfPinTopLimitDialogConfigPc();
    } else {
      return new NtfPinTopLimitDialogConfig();
    }
  }
}

export const pinTopDialogConfigManager = PinTopDialogConfigManager.getInstance();