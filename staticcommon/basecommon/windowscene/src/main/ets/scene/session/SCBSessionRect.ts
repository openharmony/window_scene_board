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

import sceneSessionManager from '@ohos.sceneSessionManager';

const MINI_VALUE = 0.000001;

@Observed
export class ScbNumber {
  private value: number = 0;

  constructor(value?: number) {
    this.value = (value === undefined) ? 0 : value;
  }

  /**
   * set number
   *
   * @param { Number } num
   */
   public setNumber(num: number): void {
    if (this.value === num) {
      return;
    }
    this.value = num;
  }

  /**
   * get Px
   *
   * @returns { number }
   */
  public getPx(): number {
    return this.value;
  }

  /**
   * get Vp
   *
   * @returns { Number }
   */
  public getVp(): number {
    return px2vp(this.value);
  }

  /**
   * get px string
   *
   * @returns { string }
   */
  public getPxStr(): string {
    return String(this.getPx()) + 'px';
  }

  /**
   * get px Size String
   *
   * @returns { string }
   */
  public getPxSizeStr(): string {
    return this.getPx() === 0 ? '100%' : this.getPxStr();
  }

  /**
   * copy
   *
   * @returns { ScbNumber }
   */
  public copy(): ScbNumber {
    return new ScbNumber(this.getPx());
  }
}

@Observed
export class SCBSessionRect {
  left: ScbNumber;
  top: ScbNumber;
  width: ScbNumber;
  height: ScbNumber;

  constructor(left?: number, top?: number, width?: number, height?: number) {
    this.left = new ScbNumber(left);
    this.top = new ScbNumber(top);
    this.width = new ScbNumber(width);
    this.height = new ScbNumber(height);
  }

  /**
   * set rect
   *
   * @param { ScbNumber } left
   * @param { ScbNumber } top
   * @param { ScbNumber } width
   * @param { ScbNumber } height
   */
  public setRect(left: ScbNumber, top: ScbNumber, width: ScbNumber, height: ScbNumber): void {
    this.setRectNum(left.getPx(), top.getPx(), width.getPx(), height.getPx());
  }

  /**
   * set rect number
   *
   * @param { Number } left
   * @param { Number } top
   * @param { Number } width
   * @param { Number } height
   */
  public setRectNum(left: number, top: number, width: number, height: number): void {
    this.setPosNum(left, top);
    this.setSizeNum(width, height);
  }

  /**
   * set position Number
   *
   * @param { Number } left
   * @param { Number } top
   */
  public setPosNum(left: number, top: number): void {
    this.left = new ScbNumber(left);
    this.top = new ScbNumber(top);
  }

  /**
   * set size number
   *
   * @param { Number } width
   * @param { Number } height
   */
  public setSizeNum(width: number, height: number): void {
    this.width = new ScbNumber(width);
    this.height = new ScbNumber(height);
  }

  /**
   * set size
   *
   * @param { ScbNumber } width
   * @param { ScbNumber } height
   */
  public setSize(width: ScbNumber, height: ScbNumber): void {
    this.setSizeNum(width.getPx(), height.getPx());
  }

  /**
   * set position
   *
   * @param { ScbNumber } left
   * @param { ScbNumber } top
   */
  public setPos(left: ScbNumber, top: ScbNumber): void {
    this.setPosNum(left.getPx(), top.getPx());
  }

  /**
   * copy
   *
   * @returns { SCBSessionRect }
   */
  public copy(): SCBSessionRect {
    return new SCBSessionRect(this.left.getPx(), this.top.getPx(), this.width.getPx(), this.height.getPx());
  }

  /**
   * copy from
   *
   * @param { SCBSessionRect } rect
   */
  public copyFrom(rect: SCBSessionRect): void {
    this.setRectNum(rect.left.getPx(), rect.top.getPx(), rect.width.getPx(), rect.height.getPx());
  }

  /**
   * whether is empty
   *
   * @returns { boolean }
   */
  public isEmpty(): boolean {
    if (this.nearEqual(this.width.getPx(), 0) || this.nearEqual(this.height.getPx(), 0)) {
      return true;
    }
    return false;
  }

  /**
   * transfer SCBSessionRect to SessionRect
   * @returns
   */
  public transfer2SessionRect(): sceneSessionManager.SessionRect {
    let res: sceneSessionManager.SessionRect = {
      posX_: this.left.getPx(),
      posY_: this.top.getPx(),
      width_: this.width.getPx(),
      height_: this.height.getPx(),
    };
    return res;
  }

  /**
   * equals
   *
   * @param { SCBSessionRect } rect
   * @return { Boolean }
   */
  public equals(rect: SCBSessionRect): boolean {
    if (this.nearEqual(rect.left.getPx(), this.left.getPx()) && this.nearEqual(rect.top.getPx(), this.top.getPx()) &&
    this.nearEqual(rect.width.getPx(), this.width.getPx()) &&
    this.nearEqual(rect.height.getPx(), this.height.getPx())) {
      return true;
    }
    return false;
  }

  /**
   * equals
   *
   * @param { SCBSessionRect } rect
   * @return { Boolean }
   */
  public equalsOfSize(rect: SCBSessionRect): boolean {
    if (this.nearEqual(rect.width.getPx(), this.width.getPx()) &&
    this.nearEqual(rect.height.getPx(), this.height.getPx())) {
      return true;
    }
    return false;
  }

  private nearEqual(a: number, b: number): boolean {
    // 0.000001: min error
    return Math.abs(a - b) < MINI_VALUE;
  }

  /**
   * contains
   *
   * @param { Number } x
   * @param { Number } y
   * @return { Boolean }
   */
  public contains(x : number, y : number): boolean {
    return x >= this.left.getPx() && x <= (this.left.getPx() + this.width.getPx()) &&
      y >= this.top.getPx() && y <= (this.top.getPx() + this.height.getPx());
  }

  public printPx(): string {
    return `[${this.left.getPx()}, ${this.top.getPx()}, ${this.width.getPx()}, ${this.height.getPx()}]`;
  }
}