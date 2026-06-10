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

import { EditModeStyleParam } from '../style/EditModeStyle';

@Observed
export class EditModeGridData {
  @Track public rowsGap: number | undefined = undefined;
  @Track public colsGap: number | undefined = undefined;
  @Track public margin: Margin | Length | LocalizedMargin | undefined = undefined;
  @Track public padding: Margin | Length | LocalizedMargin | undefined = undefined;
  @Track public height: Length | undefined = undefined;
  @Track public width: Length | undefined = undefined;
  @Track public border: BorderOptions | undefined = undefined;
  @Track public isShowing: boolean = false;

  public updateGridLayout(param: EditModeStyleParam): void {
    if (param.rowsGap !== undefined) {
      this.rowsGap = param.rowsGap;
    }
    if (param.colsGap !== undefined) {
      this.colsGap = param.colsGap;
    }
    if (param.margin !== undefined) {
      this.margin = param.margin;
    }
    if (param.padding !== undefined) {
      this.padding = param.padding;
    }
    if (param.height !== undefined) {
      this.height = param.height;
    }
    if (param.width !== undefined) {
      this.width = param.width;
    }
    if (param.border !== undefined) {
      this.border = param.border;
    }
  }
}