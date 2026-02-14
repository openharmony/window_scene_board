/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import screenSessionManager from '@ohos.screenSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import {
  SCBSceneOrientationPolicy,
  SCBDefaultOrientationPolicy } from '../scene/session/SCBSceneOrientationPolicy';
import { SCBScreenSessionManager } from '../screen/session/SCBScreenSessionManager';
import { WinLog, WinLogDomain } from '../utils/WinLog';

const TAG = 'SCBDeviceScreenConfig';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class SCBDeviceScreenConfig {
  deviceScreenConfig: screenSessionManager.DeviceScreenConfig;
  rotationPolicyMap: Map<number, boolean> = new Map([
    [RotationConstants.ROTATION_0, true],
    [RotationConstants.ROTATION_90, true],
    [RotationConstants.ROTATION_180, false],
    [RotationConstants.ROTATION_270, true]
  ]);
  expandRotationPolicyMap: Map<number, boolean> = new Map([
    [RotationConstants.ROTATION_0, true],
    [RotationConstants.ROTATION_90, true],
    [RotationConstants.ROTATION_180, true],
    [RotationConstants.ROTATION_270, true]
  ]);
  expandSecondaryRotationPolicyMap: Map<number, boolean> = new Map([
    [RotationConstants.ROTATION_0, true],
    [RotationConstants.ROTATION_90, true],
    [RotationConstants.ROTATION_180, true],
    [RotationConstants.ROTATION_270, true]
  ]);
  private desktopRotable = false;

  /**
   * Get the singleton of the device screen config.
   */
  static getInstance(): SCBDeviceScreenConfig {
    if (!globalThis.SCBDeviceScreenConfigInstance) {
      globalThis.SCBDeviceScreenConfigInstance = new SCBDeviceScreenConfig();
    }

    return globalThis.SCBDeviceScreenConfigInstance;
  }

  public loadDeviceScreenConfig(): void {
    try {
      this.deviceScreenConfig = screenSessionManager.getDeviceScreenConfig();
      log.showInfo('Device screen config, rotationPolicy: ' + this.deviceScreenConfig.rotationPolicy +
        ', defaultRotationPolicy: ' + this.deviceScreenConfig.defaultRotationPolicy +
        ', isRightPowerButton: ' + this.deviceScreenConfig.isRightPowerButton);
      this.parseRotationPolicyConfig(this.deviceScreenConfig.rotationPolicy);
      SCBDefaultOrientationPolicy.getInstance().parseDefaultRotationPolicyConfig(
        this.deviceScreenConfig.defaultRotationPolicy);
    } catch (err) {
      log.showError(`loadDeviceScreenConfig failed: ${err.message}`);
    }
  }

  public getRotationPolicyMap(): Map<number, boolean> {
    let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'getRotationPolicyMap screenSession is null.');
      return this.rotationPolicyMap;
    }
    if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      return this.expandSecondaryRotationPolicyMap;
    }
    if (screenSession.isFoldablePhoneExpandStatus()) {
      return this.expandRotationPolicyMap;
    }
    return this.rotationPolicyMap;
  }

  public getRightPowerButton(): boolean {
    return this.deviceScreenConfig?.isRightPowerButton ?? true;
  }

  private parseRotationPolicyConfig(rotationPolicy: string): void {
    let rotationPolicyArray: string[] = rotationPolicy.split(',');
    if (rotationPolicyArray.length === 1) {
      this.rotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy(
        rotationPolicyArray[0]);
    } else if (rotationPolicyArray.length === 2) {
      this.rotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy(
        rotationPolicyArray[0]);
      this.expandRotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy(
        rotationPolicyArray[1]);
    } else if (rotationPolicyArray.length === 3) {
      // 旋转策略按逗号分割，有三组参数配置项
      this.rotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy(
        rotationPolicyArray[0]);
      this.expandRotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy(
        rotationPolicyArray[1]);
      this.expandSecondaryRotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy(
        rotationPolicyArray[2]);
    }
  }

}