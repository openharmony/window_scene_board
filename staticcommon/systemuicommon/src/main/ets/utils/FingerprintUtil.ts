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
import osAccount from '@ohos.account.osAccount';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';

const TAG: string = 'FingerprintUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 指纹解锁开关的key
 */
const FINGER_PRINT_KEY_GUARD_ENABLE_KEY: string = 'fp_keyguard_enable';
/**
 * 指纹解锁使能时，值为'1'
 */
const FINGER_PRINT_KEY_GUARD_ENABLED: string = '1';
export class FingerprintUtil {
  static readonly FINGERPRINT_TYPE_KEY: string = 'fingerprint_type';
  /*** 判断是否存在指纹
   * @returns 是否存在指纹结果
   */
  public static async hasFingerprint(): Promise<boolean> {
    const FINGER_PRINT_AUTH_TYPE: number = 4;
    const userIdentityManager: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
    const enrolledCredInfoArray = await userIdentityManager?.getAuthInfo(FINGER_PRINT_AUTH_TYPE);
    const enrolledCredInfoObj = enrolledCredInfoArray[0];
    const enrolledFingerprint = !!enrolledCredInfoObj?.credentialId && enrolledCredInfoObj?.authType === FINGER_PRINT_AUTH_TYPE;
    log.showInfo(`enrolledFingerprint: ${enrolledFingerprint}`);
    return enrolledFingerprint;
  }

  /**
   * 判断当前是否开启指纹解锁
   * @returns true: 开启指纹解锁
   */
  public static isFPKeyguardEnable(): boolean {
    const fpKeyguardStatus = sSettingsUtil.getSecureValue(FINGER_PRINT_KEY_GUARD_ENABLE_KEY, '');
    log.showInfo(`fpkeyguard status:${fpKeyguardStatus}`);
    return fpKeyguardStatus === FINGER_PRINT_KEY_GUARD_ENABLED;
  }

  /**
   * 当前设备的指纹位置是否为低位指纹. 该值同步自锁屏
   * @returns 锁屏通知样式是否锁定
   */
  public static isLowFingerPrint(): boolean {
    const fingerprintType = Number(sSettingsUtil.getSecureValue(this.FINGERPRINT_TYPE_KEY, ''));
    log.showInfo(`fingerprint type:${fingerprintType}`);
    return fingerprintType === FingerprintType.UNDER_SCREEN_SENSOR_LOW;
  }
}

/**
 * 指纹传感器类型
 */
enum FingerprintType {
  NONE,
  UNDER_SCREEN_SENSOR_LOW,
  UNDER_SCREEN_SENSOR_HIGH,
  OUT_OF_SCREEN_SENSOR,
  BOTH_SENSOR
}