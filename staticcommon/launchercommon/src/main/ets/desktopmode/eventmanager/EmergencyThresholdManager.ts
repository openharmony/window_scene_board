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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { EmergencyBatteryThreshold } from '../statemanager/DesktopMode';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'EmergencyThresholdManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 容错场景
const MAX_EMERGENCY_ENTER_THRESHOLD = 10;

/**
 * 获取进入应急模式的阈值，支持读取ccm配置的进入阈值
 */
export class EmergencyThresholdManager {
  private static instance: EmergencyThresholdManager;

  private emergencyEnterThreshold: number = EmergencyBatteryThreshold.ENTER_THRESHOLD;
  private emergencyExitThreshold: number = EmergencyBatteryThreshold.EXIT_THRESHOLD;

  public static getInstance(): EmergencyThresholdManager {
    if (!EmergencyThresholdManager.instance) {
      EmergencyThresholdManager.instance = new EmergencyThresholdManager();
    }
    return EmergencyThresholdManager.instance;
  }

  private constructor() {
    this.emergencyThresholdInit();
  }
  
  private emergencyThresholdInit(): void {
    this.initEmergencyEnterThreshold();
    this.initEmergencyExitThreshold();
  }

  public getEmergencyEnterThreshold(): number {
    return this.emergencyEnterThreshold;
  }

  public getEmergencyExitThreshold(): number {
    return this.emergencyExitThreshold;
  }

  // power_off_control 配置格式xx_xx_xx：第一个表示进入阈值，第二个表示弹窗出现延时，第三个表示弹窗时长，当前只支持第一个字段生效
  private initEmergencyEnterThreshold(): void {
    try {
      let value = systemParameterEnhance.getSync('const.low_battery.power_off_control');
      if (CheckEmptyUtils.isEmpty(value)) {
        log.showWarn(`has not config, use default value`);
      } else {
        const val: number = Number(value.split('_').shift());
        this.emergencyEnterThreshold =
          (isNaN(val) || val > MAX_EMERGENCY_ENTER_THRESHOLD || val <= 0) ? this.emergencyEnterThreshold : val;
      }
      log.showWarn(`current emergency enter threshold: ${this.emergencyEnterThreshold}`);
    } catch (e) {
      log.showError(`getShutDownSoc error, code: ${e?.code}, message: ${e?.mesage}`);
    }
  }

  private initEmergencyExitThreshold(): void {
    this.emergencyExitThreshold = this.emergencyEnterThreshold + 1;
    log.showWarn(`current emergency exit threshold: ${this.emergencyExitThreshold}`);
  }
}