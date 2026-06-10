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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '../../constants/CommonConstants';
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { Instruction } from './Instruction';

const TAG = 'DeleteInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * DeleteInstruction.ts
 * 该命令是删除布局中的图标的位置，支持应用或者文件夹。有两个功能：一是删除数据库中存在但实际PKG不存在的冗余信息；二是PKG存在，且暂时不知道这个图标应该放在哪里，
 * 可以使用delete命令，待明确如何处理时再用insert或者insertinto指令插入回来。
 * @since 2023-11-20
 */
export class DeleteInstruction extends Instruction {
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    const index = gridInfo.findIndex(dataItem => this.isItemExist(dataItem, item));
    if (index === CommonConstants.INVALID_VALUE) {
      log.showError('Layout element does not exist.');
      return gridInfo;
    }
    // 删除对应的应用或者文件夹
    gridInfo.splice(index, 1);
    log.showInfo('The layout element is deleted successfully.');
    return gridInfo;
  }
}