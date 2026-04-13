/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { Widget, LayoutRotatePacking } from 'libLayoutRotatePacking.so';

export enum LayoutRotatePackingMode {
  Z = 0,
  N = 1
}

export interface LayoutRotatePackingPosition {
  x: number;
  y: number;
}

export interface LayoutRotatePackingRectangle {
  width: number;
  height: number;
}

export enum LayoutRotatePackingType {
  VERTICAL_TO_LANDSCAPE = 0,
  LANDSCAPE_TO_VERTICAL = 1
}

const TAG = 'LayoutRotatePackingProxy';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class LayoutRotatePackingProxy {
  private layoutRotatePackingInstance: LayoutRotatePacking | null = null;

  constructor(mode: LayoutRotatePackingMode, width: number, height: number) {
    try {
      this.layoutRotatePackingInstance = new LayoutRotatePacking(mode, width, height);
    } catch (e) {
      log.showInfo('get instance error ' + e.message);
    }
  }

  public addVerticalRuler(x: number): void {
    try {
      this.layoutRotatePackingInstance?.addVerticalRuler(x);
    } catch (e) {
      log.showInfo('addVerticalRuler error ' + e.message);
    }
  }

  public addHorizontalRuler(y: number): void {
    try {
      this.layoutRotatePackingInstance?.addHorizontalRuler(y);
    } catch (e) {
      log.showInfo('addHorizontalRuler error ' + e.message);
    }
  }

  public addDeadCell(x: number, y: number): void {
    try {
      this.layoutRotatePackingInstance?.addDeadCell(x, y);
    } catch (e) {
      log.showInfo('addDeadCell error ' + e.message);
    }
  }

  public addPreset(id: number, x: number, y: number): void {
    try {
      this.layoutRotatePackingInstance?.addPreset(id, x, y);
    } catch (e) {
      log.showInfo('addDeadCell error ' + e.message);
    }
  }

  public composedRotate(widgets: Widget[]): Array<Widget> {
    let output: Widget[] = [];
    try {
      if (this.layoutRotatePackingInstance) {
        output = this.layoutRotatePackingInstance.composedRotate(widgets);
      }
    } catch (e) {
      log.showInfo('addDeadCell error ' + e.message);
    }
    return output;
  }

  public sortedRotate(widgets: Widget[]): Array<Widget> {
    let output: Widget[] = [];
    try {
      if (this.layoutRotatePackingInstance) {
        output = this.layoutRotatePackingInstance?.sortedRotate(widgets);
      }
    } catch (e) {
      log.showInfo('addDeadCell error ' + e.message);
    }
    return output;
  }

  /*
   * sort widgets by Mode N
   */
  public sortWidgetsByNOrder(widgets: Widget[]): void {
    widgets.sort((a: Widget, b: Widget) => {
      if (a.x !== b.x) {
        return a.x - b.x;
      }
      if (a.x === b.x) {
        return a.y - b.y;
      }
      return 0;
    });
  }

  private getNextReverseNPos(curPos: LayoutRotatePackingPosition,
    outputLayout: LayoutRotatePackingRectangle): LayoutRotatePackingPosition {
    let nextPos: LayoutRotatePackingPosition = {
      x: curPos.x,
      y: curPos.y
    };
    // width: pos[0], height: pos[1]
    if (curPos.y < outputLayout.height) {
      nextPos.x = curPos.x;
      nextPos.y = curPos.y + 1;
      return nextPos;
    }
    nextPos.x = curPos.x - 1;
    nextPos.x = Math.max(0, nextPos.x);
    nextPos.y = 1;
    return nextPos;
  }

  private isAtomicWidget(widget: Widget): boolean {
    return (widget.width === 1) && (widget.height === 1)
  }

  public presetAtomicWidgetsByReverseN(widgets: Widget[], outputLayout: LayoutRotatePackingRectangle): void {
    // start from [width, 1]
    let cusPos: LayoutRotatePackingPosition = { x: outputLayout.width, y: 1 };
    widgets.forEach((item) => {
      if (this.isAtomicWidget(item)) {
        this.addPreset(item.id, cusPos.x, cusPos.y);
        cusPos = this.getNextReverseNPos(cusPos, outputLayout);
      }
    });
  }
}

