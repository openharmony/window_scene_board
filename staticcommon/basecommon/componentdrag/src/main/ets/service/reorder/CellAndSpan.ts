/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

/**
 * 控件坐标和尺寸工具类
 *
 * @date 2023-2-18
 */
export default class CellAndSpan {
  private mCellX: number = -1; // 网格化布局，X轴坐标
  private mCellY: number = -1; // 网格化布局，X轴坐标
  private mSpanX: number = 1; // X轴占用网格数
  private mSpanY: number = 1; // Y轴占用网格数

  /**
   * 构造函数
   *
   * @param cellX X轴坐标
   * @param cellY Y轴坐标
   * @param spanX X轴占用网格
   * @param spanY Y轴占用网格
   */
  constructor(cellX: number, cellY: number, spanX: number, spanY: number) {
    this.mCellX = cellX;
    this.mCellY = cellY;
    this.mSpanX = spanX;
    this.mSpanY = spanY;
  }

  public toString(): String {
    return '(' + this.mCellX + ', ' + this.mCellY + ': ' + this.mSpanX + ', ' + this.mSpanY + ')';
  }

  /**
   * 复制其他对象的信息
   *
   * @param cellAndSpan 待复制对象
   */
  public copyFrom(cellAndSpan: CellAndSpan): void {
    if (cellAndSpan == null) {
      return;
    }
    this.mCellX = cellAndSpan.getCellX();
    this.mCellY = cellAndSpan.getCellY();
    this.mSpanX = cellAndSpan.getSpanX();
    this.mSpanY = cellAndSpan.getSpanY();
  }

  /**
   * 设置横向网格坐标
   *
   * @param cellX 横向网格坐标
   */
  public setCellX(cellX: number): void {
    this.mCellX = cellX;
  }

  /**
   * 获取横向网格坐标
   *
   * @return 横向网格坐标
   */
  public getCellX(): number {
    return this.mCellX;
  }

  /**
   * 设置纵向网格坐标
   *
   * @param cellY 纵向网格坐标
   */
  public setCellY(cellY: number): void {
    this.mCellY = cellY;
  }

  /**
   * 获取纵向网格坐标
   *
   * @return 纵向网格坐标
   */
  public getCellY(): number {
    return this.mCellY;
  }

  /**
   * 设置横向占用网格
   *
   * @param spanX 横向占用网格
   */
  public setSpanX(spanX: number): void {
    this.mSpanX = spanX;
  }

  /**
   * 获取横向占用网格
   *
   * @return 横向占用网格
   */
  public getSpanX(): number {
    return this.mSpanX;
  }

  /**
   * 设置纵向占用网格
   *
   * @param spanY 纵向占用网格
   */
  public setSpanY(spanY: number): void {
    this.mSpanY = spanY;
  }

  /**
   * 获取纵向占用网格
   *
   * @return 纵向占用网格
   */
  public getSpanY(): number {
    return this.mSpanY;
  }

  /**
   * 当前尺寸信息是否有效
   *
   * @return 尺寸信息是否有效
   */
  public isSpanValid(): boolean {
    if (this.mSpanY <= 0 || this.mSpanX <= 0) {
      return false;
    }

    return true;
  }
}