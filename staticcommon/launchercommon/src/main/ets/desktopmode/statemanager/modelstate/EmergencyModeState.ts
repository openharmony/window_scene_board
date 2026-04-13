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
import { DesktopModeManager } from '../DesktopModeManager';
import { BaseModeState } from './BaseModeState';
import type DesktopModeState from './DesktopModeState';
import { TherEmcOverlayModeState } from './TherEmcOverlayModeState';

export class EmergencyModeState implements DesktopModeState {

  private static instance: EmergencyModeState;

  private stateMode: DesktopModeEnum = DesktopModeEnum.EMERGENCY_MODE;

  private constructor() {}

  notifyLowBattery(): void {
    // Don't need to do anything.
  }

  notifyExitLowBattery(): void {
    DesktopModeManager.getInstance().changeModeStateTo(BaseModeState.getInstance());
  }

  notifyThermal(): void {
    DesktopModeManager.getInstance().changeModeStateTo(TherEmcOverlayModeState.getInstance());
  }

  notifyExitThermal(): void {
    // Don't need to do anything.
  }

  getStateMode(): DesktopModeEnum {
    return this.stateMode;
  }

  public static getInstance(): EmergencyModeState {
    if (!EmergencyModeState.instance) {
      EmergencyModeState.instance = new EmergencyModeState();
    }
    return EmergencyModeState.instance;
  }
}