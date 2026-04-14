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

import { SCBFoldStatePropertyChangeEvent } from '@ohos/windowscene/src/main/ets/events/SCBFoldStatePropertyChangeEvent';

export enum SCBFoldState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
};

export class BigScreenStatus {
  private static mInstance: BigScreenStatus;

  private constructor() {
  }

  public static getInstance(): BigScreenStatus {
    if (!BigScreenStatus.mInstance) {
      BigScreenStatus.mInstance = new BigScreenStatus();
    }
    return BigScreenStatus.mInstance;
  }

  public isRotateStatus(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    if ((bigScreenStateProperty.tarState === SCBFoldState.UNFOLDED_VERTICAL &&
      bigScreenStateProperty.curState === SCBFoldState.UNFOLDED_HORIZONTAL) ||
      (bigScreenStateProperty.curState === SCBFoldState.UNFOLDED_VERTICAL &&
        bigScreenStateProperty.tarState === SCBFoldState.UNFOLDED_HORIZONTAL)) {
      return true;
    }
    return false;
  }

  public isKeyBoardExist(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD;
  }

  public isKeyBoardOut(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return !this.isKeyBoardExist(bigScreenStateProperty) &&
      (bigScreenStateProperty.curState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
        bigScreenStateProperty.curState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD);
  }

  public isKeyBoardConvert(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return (bigScreenStateProperty.curState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD &&
      bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD) ||
      (bigScreenStateProperty.curState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD &&
        bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD);
  }

  public curStatusIsKeyBoard(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return bigScreenStateProperty.curState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      bigScreenStateProperty.curState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD;
  }

  public tarStatusIsKeyBoard(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD;
  }

  public isFoldAndUnFoldStatus(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return ((bigScreenStateProperty.curState === SCBFoldState.UNFOLDED_VERTICAL &&
      bigScreenStateProperty.tarState === SCBFoldState.HALF_FOLDED) ||
      (bigScreenStateProperty.curState === SCBFoldState.HALF_FOLDED &&
        bigScreenStateProperty.tarState === SCBFoldState.UNFOLDED_VERTICAL))
  }

}

