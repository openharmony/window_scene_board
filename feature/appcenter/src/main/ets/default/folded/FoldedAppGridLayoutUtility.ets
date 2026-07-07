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
import { DragGridParam, RealPaddingParam } from '@ohos/componentdrag';
import { CommonAppGridLayoutUtility } from '../common/util/CommonAppGridLayoutUtility';

const TAG: string = 'FoldedAppGridLayoutUtility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 折叠机-宫格位置计算工具类
 */
export class FoldedAppGridLayoutUtility extends CommonAppGridLayoutUtility {
  protected extraSpacing: number = 0;
  public initGridParameter(gridParam: DragGridParam, realPadding: RealPaddingParam, gridSpace?: number): void {
    super.initGridParameter(gridParam, realPadding, gridSpace);
    this.gridSpace = gridSpace ?? 0;
    this.nextPaddingTop = this.paddingTop + gridParam.gridHeight;
    log.showInfo(`initGridParameter-${this.nextPaddingTop}-${this.gridSpace}`);
  }

  public setExtraPaddingTopOffset(space: number): void {
    log.showInfo(`setExtraPaddingTopOffset-${space}-${this.gridSpace}-${this.extraSpacing}`);
    this.extraSpacing = space;
  }

  protected getRealPaddingTop(page?: number): number {
    if (this.singlePage) {
      return this.paddingTop;
    }

    if (((page ?? 0) % 2) > 0) {
      return this.nextPaddingTop + this.extraSpacing;
    } else {
      return this.paddingTop;
    }
  }
}