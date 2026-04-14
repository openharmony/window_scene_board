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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import locationManager from '@ohos.enterprise.locationManager';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG: string = 'SuperPrivacyUtils';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const SUPER_PRIVACY_FEATURE: string = 'const.appsecurityprivacy.superprivacy.feature_enabled';
const PROP_DEVICE_PADDLE: string = 'const.appsecurityprivacy.superprivacy.paddle_existed';
const EDM_LOCATION_KEY: string = 'persist.edm.location_policy';
const EDM_CAMERA_KEY: string = 'persist.edm.camera_disable';
const EDM_MICROPHONE_KEY: string = 'persist.edm.mic_disable';
const PERSIST_EDM_CONFIG: string = 'persist.edm.edm_enable';
const SUPER_PRIVACY_FEATURE_SUPPORT_FOLD: string = '3';
const SUPER_PRIVACY_FEATURE_ENABLE: string = '1';
const DEVICE_PADDLE_EXISTED: string = '1';

let isSupportFoldProtection: boolean = false;
let isSupportSoftProtection: boolean = false;
let isPaddleDevice: boolean = false;
let isEnableEdm: boolean = false;
let isMicrophoneUnderEdmControl: boolean = false;
let isCameraUnderEdmControl: boolean = false;
let isLocationUnderEdmControl: locationManager.LocationPolicy = locationManager.LocationPolicy.DEFAULT_LOCATION_SERVICE;

export default class SuperPrivacyUtils {
  private constructor() {
  }

  private static bSuperPrivacyInit: boolean = false;

  private static superPrivacyInit(): void {
    try {
      SuperPrivacyUtils.bSuperPrivacyInit = true;
      let superPrivacyFeatureValue = systemParameterEnhance.getSync(SUPER_PRIVACY_FEATURE, '0');
      isSupportFoldProtection = superPrivacyFeatureValue === SUPER_PRIVACY_FEATURE_SUPPORT_FOLD;
      isSupportSoftProtection = superPrivacyFeatureValue === SUPER_PRIVACY_FEATURE_ENABLE;
      isPaddleDevice = systemParameterEnhance.getSync(PROP_DEVICE_PADDLE, '0') === DEVICE_PADDLE_EXISTED;
    } catch (err) {
      log.error(TAG, `Get prop failed. Cause: ${err?.code}, ${err?.message}`);
    }
  }

  private static bEdmInit: boolean = false;

  /**
   * 允许调用者刷新edm状态
   */
  public static edmInit(): void {
    try {
      SuperPrivacyUtils.bEdmInit = true;
      isEnableEdm = systemParameterEnhance.getSync(PERSIST_EDM_CONFIG, 'false') === 'true';
      isMicrophoneUnderEdmControl =
        isEnableEdm && systemParameterEnhance.getSync(EDM_MICROPHONE_KEY, 'false') !== 'false';
      isCameraUnderEdmControl = isEnableEdm && systemParameterEnhance.getSync(EDM_CAMERA_KEY, 'false') !== 'false';
      if (isEnableEdm) {
        let policy = systemParameterEnhance.getSync(EDM_LOCATION_KEY, 'none');
        if (policy === 'force_open') {
          isLocationUnderEdmControl = locationManager.LocationPolicy.FORCE_OPEN_LOCATION_SERVICE;
        } else if (policy === 'disallow') {
          isLocationUnderEdmControl = locationManager.LocationPolicy.DISALLOW_LOCATION_SERVICE;
        } else {
          isLocationUnderEdmControl = locationManager.LocationPolicy.DEFAULT_LOCATION_SERVICE;
        }
      }
    } catch (err) {
      log.error(TAG, `Get prop failed. Cause: ${err?.code}, ${err?.message}`);
    }
  }

  /**
   * 判断当前设备是否支持折叠保护
   *
   * @returns True：支持折叠保护
   */
  public static isSupportFoldProtection(): boolean {
    if (!SuperPrivacyUtils.bSuperPrivacyInit) {
      SuperPrivacyUtils.superPrivacyInit();
    }
    return isSupportFoldProtection;
  }

  /**
   * 判断当前设备是否支持软方案超级隐私模式
   *
   * @returns True：支持软方案超级隐私模式
   */
  public static isSupportSoftProtection(): boolean {
    if (!SuperPrivacyUtils.bSuperPrivacyInit) {
      SuperPrivacyUtils.superPrivacyInit();
    }
    return isSupportSoftProtection;
  }

  /**
   * 判断当前设备是否支持超级隐私模式
   *
   * @returns True：支持超级隐私模式
   */
  public static isSupportSuperPrivacy(): boolean {
    if (!SuperPrivacyUtils.bSuperPrivacyInit) {
      SuperPrivacyUtils.superPrivacyInit();
    }
    return isSupportFoldProtection || isSupportSoftProtection;
  }

  /**
   * 判断当前设备是否拨片设备
   *
   * @returns True：当前设备为拨片设备
   */
  public static isPaddleDevice(): boolean {
    if (!SuperPrivacyUtils.bSuperPrivacyInit) {
      SuperPrivacyUtils.superPrivacyInit();
    }
    return isPaddleDevice;
  }

  /**
   * edm是否管控麦克风
   * @returns
   */
  public static isMicrophoneUnderEdmControl(): boolean {
    if (!SuperPrivacyUtils.bEdmInit) {
      SuperPrivacyUtils.edmInit();
    }
    return isMicrophoneUnderEdmControl;
  }

  /**
   * edm是否管控相机
   * @returns
   */
  public static isCameraUnderEdmControl(): boolean {
    if (!SuperPrivacyUtils.bEdmInit) {
      SuperPrivacyUtils.edmInit();
    }
    return isCameraUnderEdmControl;
  }

  /**
   * edm是否管控位置,none表示不管控，force_open or disallow表示管控
   * @returns
   */
  public static isLocationUnderEdmControl(): locationManager.LocationPolicy {
    if (!SuperPrivacyUtils.bEdmInit) {
      SuperPrivacyUtils.edmInit();
    }
    return isLocationUnderEdmControl;
  }

  public static isEdmEnable(): boolean {
    if (!SuperPrivacyUtils.bEdmInit) {
      SuperPrivacyUtils.edmInit();
    }
    return isEnableEdm;
  }
}