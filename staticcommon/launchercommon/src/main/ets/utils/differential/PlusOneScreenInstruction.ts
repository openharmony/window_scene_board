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
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { Instruction } from './Instruction';
import { CommonConstants } from '../../constants/CommonConstants';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';


/**
 * PlusOneScreenInstruction
 *
 * @since 2023-11-07
 */

const TAG = 'PlusOneScreenInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class PlusOneScreenInstruction extends Instruction {
  /**
   * 构造器
   *
   * @param rows 屏幕的最大行数
   * @param columns 屏幕的最大列数
   */
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    if (!CheckEmptyUtils.isEmptyArr(gridInfo)) {
      gridInfo.forEach((one) => {
        if (one.container === CommonConstants.CONTAINER_DESKTOP) {
          one.page = (one.page ?? 0) + 1;
        }
      });
    }
    log.showInfo('Adding a screen succeeded.');
    return gridInfo;
  }
}

