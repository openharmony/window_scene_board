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

/**
 * 栅格布局管理类
 */
export default class GridRowManager {
  private columns: number = 0;
  private gutterX: number = 0;
  private margin: number = 0;
  private bindSheetColumns: number = 0;

  constructor(columns: number, gutterX: number, margin: number, bindSheetColumns: number) {
    this.columns = columns;
    this.gutterX = gutterX;
    this.margin = margin;
    this.bindSheetColumns = bindSheetColumns;
  }

  /**
   * 获取宽度
   */
  public getSpanWidth(screenWidth: number) : number {
    if (this.bindSheetColumns < 1) {
      return 0;
    }
    let gridWidth: number = screenWidth - 2 * this.margin;
    if (this.bindSheetColumns === 1) {
      return this.getSingleColumnWidth(gridWidth);
    }
    if (this.bindSheetColumns >= this.columns) {
      return gridWidth - 2 * this.margin;
    }
    return this.bindSheetColumns * this.getSingleColumnWidth(gridWidth) + (this.bindSheetColumns - 1) * this.gutterX;
  }

  private getSingleColumnWidth(gridWidth: number) : number {
    return (gridWidth - (this.columns - 1) * this.gutterX) / this.columns;
  }

  /**
   * 获取当前类信息
   *
   * @returns 类信息
   */
  public toString(): string {
    return `columns:${this.columns},bindColumns:${this.bindSheetColumns},margin:${this.margin},gutter:${this.gutterX}`;
  }
}