/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import type { GridLayoutItemInfo } from '@ohos/launchercommon';

const TAG = 'GridLayoutOptionRet';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const NUM_TWO: number = 2;

export class GridLayoutOptionRet {
  public static getGridLayoutOptions(appListInfo: GridLayoutItemInfo[]): GridLayoutOptions {
    if (CheckEmptyUtils.isEmpty(appListInfo)) {
      return { regularSize: [1, 1] };
    }
    return {
      //arkui组件联调接口，等待API评审通过后删除@ts-ignore
      onGetRectByIndex: (index: number): [number, number, number, number] => {
        if (index >= appListInfo.length) {
          return [-1, 1, -1, 1];
        }
        let mItemInfo: GridLayoutItemInfo = appListInfo[index];
        let mArea: number[] | undefined = mItemInfo.area;
        if (mArea && mArea.length >= NUM_TWO) {
          return [mItemInfo.row ?? 0, mItemInfo.column ?? 0, mArea[1], mArea[0]];
        }
        return [-1, 1, -1, 1];
      },
      // 大小规则的GridItem在Grid中占的行数和列数，只支持占1行1列即[1, 1]
      regularSize: [1, 1]
    };
  }
}