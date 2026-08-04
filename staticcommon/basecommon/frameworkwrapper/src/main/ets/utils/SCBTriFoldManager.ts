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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '../base/DeviceHelper';
import screenSessionManager from '@ohos.screenSessionManager';

const TAG = 'SCBTriFoldManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export const FOLD_STATUS_EXPANDED_WITH_SECOND_EXPANDED = 11;
export const FOLD_STATUS_EXPANDED_WITH_SECOND_HALF_FOLDED = 21;
export const FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED = 12;
export const FOLD_STATUS_FOLDED_WITH_SECOND_HALF_FOLDED = 22;
export const FOLD_STATUS_HALF_FOLDED_WITH_SECOND_EXPANDED = 13;
export const FOLD_STATUS_HALF_FOLDED_WITH_SECOND_HALF_FOLDED = 23;

/**
 * F/M/G state for three fold device, only for fold expand animation
 */
export enum SCBTripleFoldState {
  UNKNOWN = 'UNKNOWN',
  F = 'F',
  M = 'M',
  G = 'G',
}

/**
 * Manager for three fold device
 */
export class SCBTriFoldManager {
  public static getInstance(): SCBTriFoldManager {
    return SingletonHelper.getInstance(SCBTriFoldManager, TAG);
  }

  private prevTriFoldState: SCBTripleFoldState = SCBTripleFoldState.UNKNOWN;
  private curTriFoldState: SCBTripleFoldState = SCBTripleFoldState.UNKNOWN;

  /**
   * Get previous fold state of three fold product, only used for fold or expand animation
   *
   * @return SCBTripleFoldState, F/M/G state
   */
  public getPrevTriFoldState(): SCBTripleFoldState {
    if (!DeviceHelper.isThreeFoldProduct()) {
      log.showWarn('getPrevTriFoldState skip for not support this product');
      return SCBTripleFoldState.UNKNOWN;
    }
    return this.prevTriFoldState;
  }


  /**
   * Get current fold state of three fold product, only used for fold or expand animation
   *
   * @return SCBTripleFoldState, F/M/G state
   */
  public getCurTriFoldState(): SCBTripleFoldState {
    if (!DeviceHelper.isThreeFoldProduct()) {
      log.showWarn('getCurTriFoldState skip for not support this product');
      return SCBTripleFoldState.UNKNOWN;
    }
    return this.curTriFoldState;
  }

  /**
   * Recalculate current fold state of three fold product, only used for fold or expand animation
   *
   * @return SCBTripleFoldState, F/M/G state
   */
  public recalculateTriFoldState(): SCBTripleFoldState {
    if (!DeviceHelper.isThreeFoldProduct()) {
      log.showWarn('recalculateTriFoldState skip for not support this product');
      return SCBTripleFoldState.UNKNOWN;
    }
    let curFoldStatus: screenSessionManager.FoldDisplayMode = screenSessionManager.getFoldDisplayMode();
    log.showInfo(`recalculateTriFoldState, curFoldStatus:${curFoldStatus}`);
    let state = SCBTripleFoldState.UNKNOWN;
    if (curFoldStatus === screenSessionManager.FoldDisplayMode.FULL) {
      state = SCBTripleFoldState.M;
    } else if (curFoldStatus === screenSessionManager.FoldDisplayMode.MAIN) {
      state = SCBTripleFoldState.F;
    } else if (curFoldStatus === screenSessionManager.FoldDisplayMode.GLOBAL_FULL) {
      state = SCBTripleFoldState.G;
    }
    return state;
  }

  /**
   * Update sh fold state of three fold product, only used for fold or expand animation
   */
  public updateTriFoldStateIfNeeded(): void {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return;
    }
    let newState = this.recalculateTriFoldState();
    if (newState !== this.curTriFoldState) {
      log.showInfo(`update triFoldState from ${this.curTriFoldState} to ${newState}`);
      this.prevTriFoldState = this.curTriFoldState;
      this.curTriFoldState = newState;
    }
  }

  /**
   * Whether curTriFoldState is G state or not
   *
   * @returns true: is G state, otherwise not
   */
  public isCurGState(): boolean {
    return this.curTriFoldState === SCBTripleFoldState.G;
  }

  /**
   * Whether curTriFoldState is M state or not
   *
   * @returns true: is M state, otherwise not
   */
  public isCurMState(): boolean {
    return this.curTriFoldState === SCBTripleFoldState.M;
  }

  /**
   * Whether curTriFoldState is F state or not
   *
   * @returns true: is F state, otherwise not
   */
  public isCurFState(): boolean {
    return this.curTriFoldState === SCBTripleFoldState.F;
  }

  /**
   * Whether prevTriFoldState is G state or not
   *
   * @returns true: is G state, otherwise not
   */
  public isPrevGState(): boolean {
    return this.prevTriFoldState === SCBTripleFoldState.G;
  }

  /**
   * Whether prevTriFoldState is M state or not
   *
   * @returns true: is M state, otherwise not
   */
  public isPrevMState(): boolean {
    return this.prevTriFoldState === SCBTripleFoldState.M;
  }

  /**
   * Whether prevTriFoldState is F state or not
   *
   * @returns true: is F state, otherwise not
   */
  public isPrevFState(): boolean {
    return this.prevTriFoldState === SCBTripleFoldState.F;
  }

  /**
   * Is M/G state switch
   *
   * @returns
   */
  public isMStateGStateSwitch(): boolean {
    return (this.prevTriFoldState === SCBTripleFoldState.M ||
      this.prevTriFoldState === SCBTripleFoldState.G) && (this.curTriFoldState === SCBTripleFoldState.M ||
      this.curTriFoldState === SCBTripleFoldState.G);
  }
}
