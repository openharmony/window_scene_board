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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from './LogHelper';

const TAG = 'OutdoorConfig';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 户外模式模式状态读取工具类
 */
export class OutdoorConfig {
  private isOutdoorOpen: boolean = false;
  private static instance: OutdoorConfig;
  private isDevSupportOutdoorMode: boolean = false;

  private constructor() {
    this.readSystemParam();
  }

  public static getInstance(): OutdoorConfig {
    if (!OutdoorConfig.instance) {
      OutdoorConfig.instance = new OutdoorConfig();
    }
    return OutdoorConfig.instance;
  }

  /**
   * 设备是否支持云端模式
   * @returns
   */
  public isSupportOutdoorMode(): boolean {
    return this.isDevSupportOutdoorMode;
  }

  /**
   * 是否是户外模式模式
   * @returns
   */
  public isInOutdoorMode(): boolean {
    return this.isOutdoorOpen;
  }

  /**
   * 读取系统配置
   */
  private readSystemParam(): void {
    try {
      let productValue: string = systemParameterEnhance.getSync('ohos.boot.minisys.mode', '');
      log.showInfo(`productValue: ${productValue}`);
      this.isOutdoorOpen = productValue === 'cloud';
      let supportValue: string = systemParameterEnhance.getSync('const.cloud.feature_enable', 'false');
      log.showInfo(`isDeviceSupportCloud: ${supportValue}`);
      this.isDevSupportOutdoorMode = supportValue === 'true';
    } catch (e) {
      log.showError(`query product type error, code: ${e.code}, message: ${e.message}`);
    }
  }
}