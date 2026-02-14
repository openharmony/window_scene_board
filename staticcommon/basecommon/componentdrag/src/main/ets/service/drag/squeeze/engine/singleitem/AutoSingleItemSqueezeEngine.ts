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
import { DragGridPosition, DragPosition } from '../../../common/type/CommonTypes';
import { SingleItemSqueezeEngine } from './SingleItemSqueezeEngine';

const TAG = 'AutoSingleItemSqueezeEngine';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 单元素自动识别前向或后向挤位引擎
 */
export class AutoSingleItemSqueezeEngine extends SingleItemSqueezeEngine {
  protected isSqueezeBackwards(x: number, y: number, isZSqueeze: boolean, position: DragGridPosition): boolean {
    let isSqueezeBackwards: boolean = true;
    let centerPosition: DragPosition =
      this.positionUtil.getCenterPosition({ row: position.row, column: position.column });
    if (isZSqueeze) {
      isSqueezeBackwards = centerPosition.x > x ? true : false;
    } else {
      isSqueezeBackwards = centerPosition.y > y ? true : false;
    }
    log.showInfo('isSqueezeBackwards x:%{public}d y:%{public}d row:%{public}d column:%{public}d ' +
      'centerPosition:[%{public}d, %{public}d] isSqueezeBackwards:%{public}s isZSqueeze:%{public}s ',
      x, y, position.row, position.column, centerPosition.x, centerPosition.y, isSqueezeBackwards, isZSqueeze);
    return isSqueezeBackwards;
  }
}