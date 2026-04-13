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

import { DesktopModeEnum } from '../DesktopMode';

/**
 * The state interface contains the basic process processing of the state machine.
 */
export default interface DesktopModeState {

  /**
   * Processing flow when low battery(EMC) is notified
   */
  notifyLowBattery(): void;

  /**
   * Processing flow when exit low battery(EMC) is notified
   */
  notifyExitLowBattery(): void;

  /**
   * Processing flow when thermal safe is notified
   */
  notifyThermal(): void;

  /**
   * Processing flow when exit thermal safe is notified
   */
  notifyExitThermal(): void;

  /**
   * Get the DesktopMode enumeration of current state class
   * @returns current DesktopMode
   */
  getStateMode(): DesktopModeEnum;
}