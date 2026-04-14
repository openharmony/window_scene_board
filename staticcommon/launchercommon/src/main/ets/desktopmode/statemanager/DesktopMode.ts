/**
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

export { DeviceModeEnum as DesktopModeEnum } from '@ohos/commonconstants';

/**
 * Boost circuit status switch.
 *   1: enabled (China version),
 *   2: enabled (overseas version, not supported currently),
 *   0: disabled.
 */
export enum BoostState {
  TRIGGER_BOOST = '1',
  TRIGGER_BOOST_OVERSEA = '2',
  RECOVERY_BOOST = '0'
}

/**
 * Thermal security mode trigger flag.
 *   0: indicates exiting the thermal security mode,
 *   1: indicates entering the thermal security mode,
 *   2: indicates over-temperature warning.
 */
export enum ThermalState {
  EXIT_THERMAL_SAFE_MODE = 0,
  ENTER_THERMAL_SAFE_MODE = 1,
  PRE_ALARM_THERMAL_SAFE_MODE = 2
}

/**
 * Emergency battery enter and exit threshold
 *   1: enter emergency battery threshold,
 *   2: exit emergency battery threshold.
 */
export enum EmergencyBatteryThreshold {
  CLOSE_THRESHOLD = 0,
  ENTER_THRESHOLD = 1,
  EXIT_THRESHOLD = 2
}