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
 * fold expand style config 折展变化相关的样式属性
 */
export class FoldExpandStyle {
  public constructor() {}

  /**
   * 图标之间栅栏数量
   */
  public gridNumberBetweenIcon: number = 2;

  /**
   * 图标之间栅栏间距的数量
   */
  public gridGutterNumberBetweenIcon: number = 1;

  /**
   * 栅栏数量
   */
  public gridNumber: number = 4;

  /**
   * 栅栏的间隔
   */
  public gridMargin: number = 16;

  /**
   * 搜索页列数
   */
  public appSearchColumn: number = 4;

  /**
   * 搜索页行间距
   */
  public appSearchRowGap: number = 16;

  /**
   * 通用padding
   */
  public commonPadding: number = 16;

  /**
   * 搜索页网格距离边框的距离
   */
  public appSearchGridPadding: number = 26;

  /**
   * 搜索页网格上下距离
   */
  public appSearchGridGutterY: number = 32;

  /**
   * 设置grid相关参数
   * @param gridNumberBetweenIcon
   * @param gridGutterNumberBetweenIcon
   * @param gridNumber
   * @param gridMargin
   */
  public setGridParam(gridNumberIcon: number, gridGutterNumberIcon: number, gridNumber: number, gridMargin: number,
    commonPadding: number): void {
    this.gridNumberBetweenIcon = gridNumberIcon;
    this.gridGutterNumberBetweenIcon = gridGutterNumberIcon;
    this.gridNumber = gridNumber;
    this.gridMargin = gridMargin;
    this.commonPadding = commonPadding;
  }

  /**
   * 设置appsearch相关参数
   * @param column
   * @param rowGap
   * @param commonPadding
   * @param gridPadding
   * @param gridGutterY
   */
  public setAppSearchParam(column: number, rowGap: number, gridPadding: number, gridGutterY: number): void {
    this.appSearchColumn = column;
    this.appSearchRowGap = rowGap;
    this.appSearchGridPadding = gridPadding;
    this.appSearchGridGutterY = gridGutterY;
  }
}