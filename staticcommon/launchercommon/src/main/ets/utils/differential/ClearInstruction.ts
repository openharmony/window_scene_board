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
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { Instruction } from './Instruction';

/**
 * 差分指令：清除之前所有的布局，采用新的布局，新布局文件中除了第一条指令外，其他元素不需要配置差分指令，默认是新增
 */
const TAG = 'ClearInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class ClearInstruction extends Instruction {
  /**
   * 构造器
   *
   * @param rows 屏幕的最大行数
   * @param columns 屏幕的最大列数
   */
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridLayoutInfo: GridLayoutItemInfo[], gridLayout: GridLayoutItemInfo): GridLayoutItemInfo[] {
    log.showInfo('Clearing the layout succeeded.');
    return [];
  }
}

