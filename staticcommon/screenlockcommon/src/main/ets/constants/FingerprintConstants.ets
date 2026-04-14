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

/**
 * Fingerprint sensor type
 */
export enum SensorType {
  OUT_OF_SCREEN_SENSOR = 'OUT_OF_SCREEN_SENSOR',
  UNDER_SCREEN_SENSOR = 'UNDER_SCREEN_SENSOR',
  BOTH_SENSOR = 'BOTH_SENSOR',
  NON_SENSOR = 'NON_SENSOR'
}

/**
 * Out-of-screen fingerprint unlock sensor type
 */
export enum OutOfScreenSensorType {
  FRONT = 'FRONT',
  BACK = 'BACK',
  SIDE = 'SIDE'
}

/**
 * 指纹识别state
 */
export class FingerprintVerifyState {
  // 指纹不可用
  public static readonly NOT_READY: number = 0;

  // 指纹进入使能状态
  public static readonly READY: number = 1;

  // 指纹识别过程中
  public static readonly VERIFYING: number = 2;
}

/**
 * Fingerprint view change reason
 */
export enum FpViewChangeReason {
  NONE = 0,
  NTF_LIST_STATUS = 1
}

/**
 * Fingerprint sensor type
 */
export enum FingerprintType {
  NONE,
  UNDER_SCREEN_SENSOR_LOW,
  UNDER_SCREEN_SENSOR_HIGH,
  OUT_OF_SCREEN_SENSOR,
  BOTH_SENSOR
}

/**
 * Fingerprint authentication constant class
 */
export class FingerprintConstants {
  /**
   * Fingerprint sensor type
   */
  public static readonly FINGERPRINT_SENSOR_TYPE_KEY : string = 'fingerprintSensorType';

  /**
   * Proportion of the X component of the center coordinate of the fingerprint sensor to the screen width.
   * The value ranges from 0 to 1000. The value 0 indicates the left and 1000 indicates the right.
   * This parameter is valid only when SensorType is set to Under_SCREEN_SENSOR or BOTH_SENSOR.
   */
  public static readonly FINGERPRINT_UD_SENSOR_CENTER_X_IN_THOUSANDTH_KEY : string = 'udSensorCenterXInThousandth';

  /**
   * Proportion of the Y component of the center coordinate of the fingerprint sensor to the screen width.
   * The value ranges from 0 to 1000. 0 indicates the top edge, and 1000 indicates the bottom edge.
   * This parameter is valid only when SensorType is set to Under_SCREEN_SENSOR or BOTH_SENSOR.
   */
  public static readonly FINGERPRINT_UD_SENSOR_CENTER_Y_IN_THOUSANDTH_KEY : string = 'udSensorCenterYInThousandth';

  /**
   * Radius of the highlighted area of the fingerprint sensor on the screen. The unit is pixel width (px).
   * This parameter is valid only when SensorType is set to Under_SCREEN_SENSOR or BOTH_SENSOR.
   */
  public static readonly FINGERPRINT_UD_SENSOR_RADIUS_IN_PX_KEY : string = 'udSensorRadiusInPx';

  /**
   * Fingerprint unlock authentication result value
   */
  public static readonly RESULT_OF_FINGERPRINT : string = 'resultOfFingerprint';

  /**
   * X-coordinate of the fingerprint sensor on the screen, in px.
   */
  public static readonly COORDINATE_X_OF_FINGERPRINT_UD_SCREEN_IN_PX = 'coordinateXOfFingerprintUdScreenInPx';

  /**
   * Y-coordinate of the fingerprint sensor on the screen, in px.
   */
  public static readonly COORDINATE_Y_OF_FINGERPRINT_UD_SCREEN_IN_PX = 'coordinateYOfFingerprintUdScreenInPx';

  /**
   * Check whether the current user has enabled fingerprint unlock.
   */
  public static readonly IS_CURRENT_USER_HAS_FINGERPRINT : string = 'isCurrentUserHasFingerprint';


  /**
   * Unlock the home key of the device.
   */
  public static readonly KEY_FINGERPRINT_KEYGUARD_ENABLE: string = 'fp_keyguard_enable';

  /**
   * Default value of fingerprint unlock switch
   */
  public static readonly FINGERPRINT_KEYGUARD_ENABLE_DEFAULT: string = '0';

  /**
   * Unlock the device on
   */
  public static readonly SWITCH_ENABLE: string = '1';

  /**
   * Default fingerprint lockout duration
   */
  public static readonly DEFAULT_FINGERPRINT_DISABLE_MILLI_SECOND: number = 30000;

  /**
   * invalid duration
   */
  public static readonly INVALID_DURATION: number = 2147483647;
}