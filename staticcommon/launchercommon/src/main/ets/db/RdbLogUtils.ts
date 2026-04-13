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

import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { HashSet } from '@kit.ArkTS';
import GridLayoutInfoColumns from './column/GridLayoutInfoColumns';

/**
 * Rdb日志工具类
 */
export class RdbLogUtils {
  /**
   * GridLayoutInfo操作关键打印数据
   *
   * @param tableName
   * @param info
   * @returns 需要打印的数据
   */
  public static genGridLayoutInfoLog(info: GridLayoutItemInfo): string {
    return `${info.bundleName}_${info.appIndex ?? 0}_${info.typeId}_${info.shortcutId ??
      ''}_${info.infoName ??
      ''} AND LOCATION ${info.page}_${info.container}_${info.row}_${info.column}`;
  }

  public static getPrintSets(): HashSet<string> {
    let printSets: HashSet<string> = new HashSet<string>();
    printSets.add(GridLayoutInfoColumns.BUNDLE_NAME);
    printSets.add(GridLayoutInfoColumns.TYPE_ID);
    printSets.add(GridLayoutInfoColumns.APP_INDEX);
    printSets.add(GridLayoutInfoColumns.SHORTCUT_ID);
    printSets.add(GridLayoutInfoColumns.INFO_ID);
    printSets.add(GridLayoutInfoColumns.PAGE_INDEX);
    printSets.add(GridLayoutInfoColumns.CONTAINER);
    printSets.add(GridLayoutInfoColumns.ROW);
    printSets.add(GridLayoutInfoColumns.COLUMN);
    printSets.add(GridLayoutInfoColumns.WIDTH);
    printSets.add(GridLayoutInfoColumns.HEIGHT);
    return printSets;
  }
}