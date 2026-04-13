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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { DeviceModeEnum } from '@ohos/commonconstants/src/main/ets/constants/DeviceModeConstants';
import { Singleton } from '../utils/Singleton';

const TAG = 'EmergencyThermalSafeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class EmergencyThermalSafeManager {

  @Singleton.decorate()
  public static get instance(): EmergencyThermalSafeManager {
    return new EmergencyThermalSafeManager();
  }

  // 当前模式
  private deviceModeState: DeviceModeEnum = DeviceModeEnum.BASE_MODE;

  // 应用白名单
  private bundleWhiteList: string[] = [];

  /**
   * 设置当前模式
   *
   * @param deviceModeState 当前模式
   */
  public setDeviceModeState(deviceModeState: DeviceModeEnum): void {
    log.showInfo('Set device mode state: %{public}s', deviceModeState);
    this.deviceModeState = deviceModeState;
  }

  /**
   * 设置应用白名单
   *
   * @param bundleWhiteList
   */
  public setBundleWhiteList(bundleWhiteList: string[]): void {
    this.bundleWhiteList = bundleWhiteList;
  }

  /**
   * 是否在应急模式、热安全模式白名单
   *
   * @param bundleName 应用包名
   * @returns 是否在白名单
   */
  public isInWhiteList(bundleName: string): boolean {
    return this.bundleWhiteList.includes(bundleName);
  }

  /**
   * 是否显示通知
   *
   * @param bundleName 应用包名
   * @returns 是否在应急模式 或 热安全模式白名单
   */
  public isShowNotification(bundleName: string): boolean {
    // 未在应急模式、热安全模式不限制
    if (!this.isEmergencyOrThermalSafeMode()) {
      return true;
    }
    return this.bundleWhiteList.includes(bundleName);
  }

  /**
   * 是否在应急模式、热安全模式
   *
   * @returns 是否在应急模式、热安全模式
   */
  public isEmergencyOrThermalSafeMode(): boolean {
    return this.deviceModeState === DeviceModeEnum.EMERGENCY_MODE ||
      this.deviceModeState === DeviceModeEnum.THERMAL_SAFE_MODE;
  }

  /**
   * 是否在应急模式
   *
   * @returns 是否在应急模式
   */
  public isInEmergencyMode(): boolean {
    return this.deviceModeState === DeviceModeEnum.EMERGENCY_MODE;
  }
}