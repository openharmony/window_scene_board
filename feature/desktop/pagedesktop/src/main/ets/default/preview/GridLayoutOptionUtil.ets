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

import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { PreviewUtils } from './PreviewUtils';

export class GridLayoutOptionUtil {
  public static getGridLayoutOptions(appListInfo: GridLayoutItemInfo[]): GridLayoutOptions {
    if (PreviewUtils.isEmpty(appListInfo)) {
      return { regularSize: [1, 1] };
    }
    return {
      //arkui组件联调接口，等待API评审通过后删除@ts-ignore
      onGetRectByIndex: (index: number): [number, number, number, number] => {
        if (index >= appListInfo.length) {
          return [-1, 1, -1, 1];
        }
        let mArea: number[] | undefined = appListInfo[index].area;
        if (mArea) {
          return [appListInfo[index].row as number, appListInfo[index].column as number,
            mArea[1] as number, mArea[0] as number];
        }
        return [-1, 1, -1, 1];
      },
      // 大小规则的GridItem在Grid中占的行数和列数，只支持占1行1列即[1, 1]
      regularSize: [1, 1]
    };
  }
}