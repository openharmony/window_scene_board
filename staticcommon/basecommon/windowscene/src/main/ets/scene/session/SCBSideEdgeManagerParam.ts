/*
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

import { ScbNumber, SCBSessionRect } from './SCBSessionRect';
import { SCBSideManagerConstant } from './SCBSideEdgeBarOptions';

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SCBSideEdgeManagerParam';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Observed
export class SCBSideEdgeManagerParam {
  @Track sideEdgePosition: number = 0;
  @Track sideEdgeWidth: number =
    SCBSideManagerConstant.SIDE_MANAGER_WIDTH + SCBSideManagerConstant.SIDE_MANAGER_MARGIN_LEFT +
    SCBSideManagerConstant.SIDE_MANAGER_MARGIN_RIGHT;
  @Track scale: number = 1;
  @Track scrollOffsetY: number = 0;
  @Track sideManagerPosY: number = 0;
  @Track sideManagerPosX: number = 0;
  @Track translateX: number = 0;
  @Track translateY: number = 0;
  @Track sideManagerScale: number = 1;
  @Track sideManagerOpacity: number = 1;
  @Track sideManagerShadowOptions?: ShadowOptions;
  @Track sideWindowRadius: number = 14;
  @Track sideManagerFlag: boolean = false;
  @Track sideIsAmin: boolean = false;
  @Track sideZIndex: number = 0;
  @Track sideWindowWidth: ScbNumber = new ScbNumber();
  @Track sideWindowHeight: ScbNumber = new ScbNumber();
  @Track sideWindowScale: number = 1;
  @Track sideCardRadius: number = 0;
  @Track sideBarAlpha: number = 0;
  @Track sideCardHeight: number = 0;
  @Track sideCardWidth: number = 0;
  @Track sideCardOpacity: number = 1;
  @Track sideCardCenterX: number | string = '50%';
  @Track sideCardCenterY: number | string = 0;
  @Track showSideBarCover: boolean = false;
  @Track isClip: boolean = false;
  @Track blurRadius: number = 0;
  @Track isDestroyed: boolean = false;
  @Track opacity: number = 1;
  @Track isInExitSideAnim: boolean = false;
}

// floating animate params to/from SideFloating
export class SideFloatingAnimParams {
  public persistentId: number = 0;
  public positionX: number = 0;
  public positionY: number = 0;
  public scale: number = 1;
  public width: number = 0;
  public height: number = 0;
  public scrollOffsetY: number = 0;
  public radius: number = 0;

  constructor(persistentId: number, positionX: number, positionY: number, width: number, height: number,
    scrollOffsetY: number) {
    this.persistentId = persistentId;
    this.positionX = positionX;
    this.positionY = positionY;
    this.width = width;
    this.height = height;
    this.scrollOffsetY = scrollOffsetY;
  }

  /**
   * Get the X coordinate of an object
   *
   * @returns { number } Returns the X coordinate of the object
   */
  public getPositionX(): number {
    return this.positionX;
  }

  /**
   * Gets the Y coordinate of the current object.
   *
   * @returns { Number } Returns the Y coordinate of the current object
   */
  public getPositionY(): number {
    return this.positionY;
  }

  /**
   * How to get the width
   *
   * @returns { Number } Returns the width value
   */
  public getWidth(): number {
    return this.width;
  }

  /**
   * Obtains the persistence ID.
   *
   * @returns { Number } Persistence ID
   */
  public getPersistentId(): number {
    return this.persistentId;
  }
}