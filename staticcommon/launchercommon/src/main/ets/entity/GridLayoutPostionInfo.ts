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

import type { ValuesBucket } from '@ohos.data.ValuesBucket';
import { GridLayoutInfoEnums } from '../db/column/GridLayoutInfoColumns';

/**
 * Item info of GridLayoutPositionInfo item.
 */
export default class GridLayoutPositionInfo {
  /**
   * GridLayoutInfo: info id 元素标识id
   */
  public infoId: string | undefined;

  /**
   * GridLayoutInfo: bigfolder id 元素所在位置（工作区，Dock区，文件夹）
   * Not in bigfolder: - 100
   * In a bigfolder: ID of the bigfolder.
   */
  public container: number | undefined;

  /**
   * GridLayoutInfo: width 网格内所占列数
   */
  public width: number | undefined;

  /**
   * GridLayoutInfo: height 网格内所占行数
   */
  public height: number | undefined;

  /**
   * GridLayoutInfo: page index 桌面页数索引（0 ~ n-1）
   */
  public pageIndex: number | undefined;

  /**
   * GridLayoutInfo: column of positions 网格上起始列
   */
  public column: number | undefined;

  /**
   * GridLayoutInfo: row of positions 网格上起始行
   */
  public row: number | undefined;

  toValuesBucket(): ValuesBucket {
    return {
      [GridLayoutInfoEnums.PAGE_INDEX]: this.pageIndex,
      [GridLayoutInfoEnums.COLUMN]: this.column,
      [GridLayoutInfoEnums.ROW]: this.row
    };
  }
}
