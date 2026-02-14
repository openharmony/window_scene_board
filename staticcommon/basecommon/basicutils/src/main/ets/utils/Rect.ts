/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

const TAG: string = 'RectItem';

export class RectItem {
  public left: number;
  public top: number;
  public right: number;
  public bottom: number;

  constructor(left: number, top: number, right: number, bottom: number) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }

  public width(): number {
    return this.right - this.left;
  }

  public height(): number {
    return this.bottom - this.top;
  }

  public set(left: number, top: number, right: number, bottom: number): void {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }

  public setRect(src: RectItem): void {
    this.left = src.left;
    this.top = src.top;
    this.right = src.right;
    this.bottom = src.bottom;
  }

  public contains(x: number, y: number): boolean {
    return this.left < this.right && this.top < this.bottom && // check for empty first
      x >= this.left && x < this.right && y >= this.top && y < this.bottom;
  }

  public containsRect(r: RectItem): boolean {
    // check for empty first
    return this.left < this.right && this.top < this.bottom &&
      this.left <= r.left && this.top <= r.top && this.right >= r.right && this.bottom >= r.bottom;
  }

  /**
   * @return the horizontal center of the rectangle. If the computed value
   *         is fractional, this method returns the largest integer that is
   *         less than the computed value.
   */
  public centerX(): number {
    return (this.left + this.right) >> 1;
  }

  /**
   * @return the vertical center of the rectangle. If the computed value
   *         is fractional, this method returns the largest integer that is
   *         less than the computed value.
   */
  public centerY(): number {
    return (this.top + this.bottom) >> 1;
  }

  public offset(dx: number, dy: number): void {
    this.left += dx;
    this.top += dy;
    this.right += dx;
    this.bottom += dy;
  }

  public static intersects(a: RectItem, b: RectItem): boolean {
    return a.left < b.right && b.left < a.right && a.top < b.bottom && b.top < a.bottom;
  }

  public union(r: RectItem): void {
    this.union4(r.left, r.top, r.right, r.bottom);
  }

  public union4(left: number, top: number, right: number, bottom: number): void {
    if ((left < right) && (top < bottom)) {
      if ((this.left < this.right) && (this.top < this.bottom)) {
        if (this.left > left) {
          this.left = left;
        }
        if (this.top > top) {
          this.top = top;
        }
        if (this.right < right) {
          this.right = right;
        }
        if (this.bottom < bottom) {
          this.bottom = bottom;
        }
      } else {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
      }
    }
  }

  public toString(): String {
    let sb: String = new String();
    return sb.concat('Rect(').concat(this.left.toString()).concat(', ')
      .concat(this.top.toString()).concat(' - ').concat(this.right.toString())
      .concat(', ').concat(this.bottom.toString()).concat(')');
  }
}