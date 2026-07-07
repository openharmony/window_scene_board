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

import { SCBFoldStatePropertyChangeEvent } from '@ohos/windowscene/src/main/ets/events/SCBFoldStatePropertyChangeEvent';

export enum SCBFoldState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
};

export class SuperFoldStatus {
  private static mInstance: SuperFoldStatus;

  private constructor() {
  }

  public static getInstance(): SuperFoldStatus {
    if (!SuperFoldStatus.mInstance) {
      SuperFoldStatus.mInstance = new SuperFoldStatus();
    }
    return SuperFoldStatus.mInstance;
  }

  public isRotateStatus(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    if ((superFoldStateProperty.tarState === SCBFoldState.UNFOLDED_VERTICAL &&
      superFoldStateProperty.curState === SCBFoldState.UNFOLDED_HORIZONTAL) ||
      (superFoldStateProperty.curState === SCBFoldState.UNFOLDED_VERTICAL &&
        superFoldStateProperty.tarState === SCBFoldState.UNFOLDED_HORIZONTAL)) {
      return true;
    }
    return false;
  }

  public isKeyBoardExist(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD;
  }

  public isKeyBoardOut(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return !this.isKeyBoardExist(superFoldStateProperty) &&
      (superFoldStateProperty.curState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
        superFoldStateProperty.curState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD);
  }

  public isKeyBoardConvert(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return (superFoldStateProperty.curState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD &&
      superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD) ||
      (superFoldStateProperty.curState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD &&
        superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD);
  }

  public curStatusIsKeyBoard(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return superFoldStateProperty.curState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      superFoldStateProperty.curState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD;
  }

  public tarStatusIsKeyBoard(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD;
  }

  public isFoldAndUnFoldStatus(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return ((superFoldStateProperty.curState === SCBFoldState.UNFOLDED_VERTICAL &&
      superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED) ||
      (superFoldStateProperty.curState === SCBFoldState.HALF_FOLDED &&
        superFoldStateProperty.tarState === SCBFoldState.UNFOLDED_VERTICAL))
  }

}

