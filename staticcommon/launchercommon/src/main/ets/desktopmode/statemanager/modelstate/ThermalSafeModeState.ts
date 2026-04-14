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

export class ThermalSafeModeState implements DesktopModeState {

  private static instance: ThermalSafeModeState;

  private stateMode: DesktopModeEnum = DesktopModeEnum.THERMAL_SAFE_MODE;

  private constructor() {}

  notifyLowBattery(): void {
    DesktopModeManager.getInstance().changeModeStateTo(TherEmcOverlayModeState.getInstance());
  }

  notifyExitLowBattery(): void {
    // Don't need to do anything.
  }

  notifyThermal(): void {
    // Don't need to do anything.
  }

  notifyExitThermal(): void {
    DesktopModeManager.getInstance().changeModeStateTo(BaseModeState.getInstance());
  }

  getStateMode(): DesktopModeEnum {
    return this.stateMode;
  }

  public static getInstance(): ThermalSafeModeState {
    if (!ThermalSafeModeState.instance) {
      ThermalSafeModeState.instance = new ThermalSafeModeState();
    }
    return ThermalSafeModeState.instance;
  }
}