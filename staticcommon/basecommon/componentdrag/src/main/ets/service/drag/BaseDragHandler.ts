/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import type { DragArea } from './DragArea';
import { LogDomain, LogHelper, SingleBase, SingleContext } from '@ohos/basicutils';

const TAG = 'BaseDragHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Drag processing base class, drag processing is mainly responsible for the processing of the following tasks:
 * 1.Efficient event distribution based on drag area.
 * 2.Initialize drag function related parameters.
 * 3.Adjust and refresh the desktop layout according to the drag results.
 */
export abstract class BaseDragHandler extends SingleBase {
  protected mIsInEffectArea = false;

  public static singleName: string = 'BaseDragHandler';

  protected mDragEffectArea: DragArea | undefined;

  constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * Get the position of the drag target.
   */
  protected abstract getItemIndex(x: number, y: number): number;

  /**
   * start drag event
   */
  public abstract onDragStart(x?: number, y?: number): void;

  /**
   * Set the drag effective area.
   */
  setDragEffectArea(effectArea: DragArea): void {
    this.mDragEffectArea = effectArea;
  }

  /**
   * Get valid area.
   */
  protected getDragEffectArea(): DragArea | undefined {
    return this.mDragEffectArea;
  }

  protected isDragEffectArea(x: number, y: number): boolean {
    if (this.mDragEffectArea) {
      if (x >= this.mDragEffectArea.left && x <= this.mDragEffectArea.right &&
        y >= this.mDragEffectArea.top && y <= this.mDragEffectArea.bottom) {
        return true;
      }
    }
    return false;
  }
}
