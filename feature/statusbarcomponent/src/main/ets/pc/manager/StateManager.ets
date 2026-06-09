/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'StateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class StateManager {
  private states: Map<string, StateProperty> = new Map();
  private static mInstance: StateManager;

  public static getInstance(): StateManager {
    if (!StateManager.mInstance) {
      StateManager.mInstance = new StateManager();
    }
    return StateManager.mInstance;
  }

  getState(key: string): StateProperty {
    if (!this.states.has(key)) {
      let state = new StateProperty(key);
      this.states.set(key, state);
      return state;
    }
    return this.states.get(key) as StateProperty;
  }

  clear(): void {
    this.states.clear();
  }

  updateSelectedState(key: string, isSelected: boolean): void {
    if (!this.states.has(key)) {
      log.showDebug('updateSelectedState failed, not found key: ' + key);
      return;
    }
    (this.states.get(key) as StateProperty).isSelected = isSelected;
  }

  updateClickedState(key: string, isClicked: boolean): void {
    if (!this.states.has(key)) {
      log.showDebug('updateClickedState failed, not found key: ' + key);
      return;
    }
    (this.states.get(key) as StateProperty).isClicked = isClicked;
  }

  updateHoveredState(key: string, isHovered: boolean): void {
    if (!this.states.has(key)) {
      log.showDebug('updateHoveredState failed, not found key: ' + key);
      return;
    }
    (this.states.get(key) as StateProperty).isHovered = isHovered;
  }

  resetStates(): void {
    this.states.forEach((state) => {
      state.isClicked = false;
      state.isHovered = false;
      state.isSelected = false;
    });
  }
}

@Observed
export class StateProperty {
  public slot: string = '';
  public isClicked: boolean = false;
  public isHovered: boolean = false;
  public isSelected: boolean = false;

  constructor(slot: string) {
    this.slot = slot;
  }
}