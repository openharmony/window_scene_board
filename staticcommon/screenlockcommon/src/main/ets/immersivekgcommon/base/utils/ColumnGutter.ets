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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ColumnGutter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 默认栅格间距
const DEFAULT_GUTTER = 12;

// 默认侧边间距
const DEFAULT_MARGIN = 12;

/**
 * 栅格类型
 */
export enum ColumnType {
  SM = 4, // 窄宽度，4栅格数
  MD = 8, // 中宽度，8栅格数
  LG = 12 // 大宽度，12栅格数
}

/**
 * 栅格参数
 */
export interface ColumnParam {
  // 最大栅格数
  maxColumn: number;

  // 栅格间距，vp
  gutter: number;

  // 栅格两侧间距，vp
  margin: number;
}

/**
 * 栅格化
 */
export class ColumnGutter {
  /**
   * 不同宽度下的默认栅格化参数
   */
  private static readonly DEFAULT_COLUMN: Map<ColumnType, ColumnGutter> = new Map([
    [ColumnType.SM, ColumnGutter.wrap({ maxColumn: ColumnType.SM, gutter: DEFAULT_GUTTER, margin: DEFAULT_MARGIN })],
    [ColumnType.MD, ColumnGutter.wrap({ maxColumn: ColumnType.MD, gutter: DEFAULT_GUTTER, margin: DEFAULT_MARGIN })],
    [ColumnType.LG, ColumnGutter.wrap({ maxColumn: ColumnType.LG, gutter: DEFAULT_GUTTER, margin: DEFAULT_MARGIN })],
  ]);

  /**
   * 最大栅格数，默认SM
   */
  private maxColumn: number = ColumnType.SM;

  /**
   * 栅格间距，vp
   */
  private gutter: number = DEFAULT_GUTTER;

  /**
   * 栅格两侧间距，vp
   */
  private margin: number = DEFAULT_MARGIN;

  /**
   * 取用栅格数
   */
  private columnNum: number = 0;

  private constructor(param: ColumnParam) {
    let maxColumn = param?.maxColumn ?? -1;
    if (maxColumn > 0) {
      this.maxColumn = maxColumn;
    } else {
      log.showWarn(`instance invalid maxColume: ${maxColumn}`);
    }
    let gutter = param?.gutter ?? -1;
    if (gutter >= 0) {
      this.gutter = gutter;
    } else {
      log.showWarn(`instance invalid gutter: ${gutter}`);
    }
    let margin = param?.margin ?? -1;
    if (margin >= 0) {
      this.margin = margin;
    } else {
      log.showWarn(`instance invalid margin: ${margin}`);
    }
  }

  /**
   * 更新取用栅格数
   *
   * @param columnNum 栅格数
   * @returns 链式
   */
  public updateColumn(columnNum: number): ColumnGutter {
    if (columnNum < 0 || columnNum > this.maxColumn) {
      log.showWarn(`updateColumn invalid column num: ${columnNum}`);
      return this;
    }
    this.columnNum = columnNum;
    return this;
  }

  /**
   * 获取目标使用栅格宽度
   *
   * @param screenW 总宽度
   * @param columnNum 目标栅格数
   * @returns 使用栅格占用宽度
   */
  public getColumnWidth(screenW: number, columnNum?: number): number {
    // 优先使用传入栅格数
    let tarColumnNum = columnNum ?? this.columnNum;
    // 栅格间距个数
    let gutterNum = this.maxColumn - 1;
    // 单个栅格宽度，排除两侧间距、栅格间距
    let singleWidth = (screenW - this.margin * 2 - gutterNum * this.gutter) / this.maxColumn;
    // 最终栅格占用宽度，包含栅格间距
    return singleWidth * tarColumnNum + (Math.max(tarColumnNum - 1, 0) * this.gutter);
  }

  /**
   * 栅格创建
   *
   * @param param 栅格参数
   * @returns 栅格化
   */
  public static wrap(param: ColumnParam): ColumnGutter {
    return new ColumnGutter(param);
  }

  /**
   * 默认栅格化
   *
   * @param type 默认栅格化类型
   * @returns 栅格化
   */
  public static getDefault(type: ColumnType): ColumnGutter {
    return ColumnGutter.DEFAULT_COLUMN.get(type) ??
      ColumnGutter.wrap({ maxColumn: ColumnType.SM, gutter: DEFAULT_GUTTER, margin: DEFAULT_MARGIN });
  }
}