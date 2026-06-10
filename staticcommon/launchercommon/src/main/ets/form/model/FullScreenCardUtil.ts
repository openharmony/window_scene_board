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
import { DeviceHelper, FoldPhoneTypeValue } from '@ohos/frameworkwrapper';

const TAG = 'FullScreenCardUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FullScreenCardUtil {
  // 全屏卡片所占列数
  private col: number = 4;
  // 全屏卡片所占行数
  private row: number = 6;
  private static instance?: FullScreenCardUtil;

  public static getInstance(): FullScreenCardUtil {
    if (!FullScreenCardUtil.instance) {
      FullScreenCardUtil.instance = new FullScreenCardUtil();
    }
    return FullScreenCardUtil.instance;
  }

  private constructor() {
    // 注意 AppStorage 不可在taskpool里面使用，导致 isSingleDisplayPocketFoldDevice 接口某些情况会报错，因此不使用该接口
    let gridRow: number = DeviceHelper.getFoldProductType() === FoldPhoneTypeValue.EXPANDING_NEX_FORMS ? 5 : 6;
    this.row = gridRow;
    log.showWarn(`full card size[${this.row}, ${this.col}], gridRow[${gridRow}]`);
  }

  public getHeightDimension(iconSizeOfGrid: number, spaceOfRow: number, widthDimension1: number): number {
    return (iconSizeOfGrid + spaceOfRow) * (this.row - 2) + widthDimension1;
  }

  public getRow(): number {
    return this.row;
  }

  public getAllRows(): number[] {
    // 全屏卡片在布局中所占行数可能是5或6
    return [5, 6];
  }

  public getCol(): number {
    return this.col;
  }

  public getArea(): number[] {
    return [this.col, this.row];
  }
}