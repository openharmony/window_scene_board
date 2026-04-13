/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import {
  CheckEmptyUtils,
} from '@ohos/basicutils';

/**
 * game card info
 */
export class GameCardInfo {
  /**
   * Indicates game type.
   */
  public gameType: string = '';

  /**
   * Indicates bind game identifier for the quick type game.
   */
  public formBindGame: string = '';

  /**
   * Indicates sub bundle name identifier for the quick type game.
   */
  public subBundleName: string = '';

  /**
   * Indicates extension type.
   */
  public extensionType: string = '';

  /**
   * Indicates bind ability identifier for the native type game.
   */
  public formBindAbility: string = '';

  /**
   * Indicates gesture disabled in funInteraction scene
   */
  public disabledDesktopBehaviors: string = '';

  /**
   * Indicates the pause duration in funInteraction scene
   */
  public pauseDuration: number = 0;

  /**
   * Compares whether the game card info is the same
   * Used to judge whether to handle the card
   *
   * @param info the compare gameCardInfo
   * @returns true or false
   */
  isEquals(info: GameCardInfo): boolean {
    if (CheckEmptyUtils.isEmpty(info)) {
      return false;
    }
    if (this.gameType === info.gameType && this.formBindGame === info.formBindGame) {
      return true;
    }
    if (this.extensionType === info.extensionType) {
      return (this.formBindGame === info.formBindGame && this.subBundleName === info.subBundleName) ||
        this.formBindAbility === info.formBindAbility;
    }
    return false;
  }
}