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

import { clockLayoutHelper } from '../../clock/common/ClockLayoutHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'GridUtil';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const DEFAULT = 8;
const PAD_SMALL_PORTRAIT = 6;
// pad竖屏以840作为大小pad区分
const PAD_PORTRAIT_SMALL_SIZE = 840;

export interface DisplayGrid {
  xGridAttribute: GridAttribute;
  yGridAttribute: GridAttribute;
}

export interface GridAttribute {
  // 数量
  count: number;

  // 边距
  margin: number;

  // 间距
  interval: number;
}

export enum DisplayType {
  BAR,
  EXPANDING_BIG_SCREEN,
  EXPANDING_ULTRA_SCREEN,
  PAD
}

export class GridUtil {
  private displayGridMap: Map<DisplayType, DisplayGrid> = new Map();

  private constructor() {
    /**
     * 大屏：边距24，间距12
     * 超大屏：横屏边距32，间距12；竖屏边距24，间距12
     * Pad：横屏边距32，间距16；竖屏边距24，间距12
     */
    this.initExpandingBigScreenGrid();
    this.initExpandingUltraScreenGrid();
    this.initPadGrid();
  }

  private initExpandingBigScreenGrid() {
    this.displayGridMap.set(DisplayType.EXPANDING_BIG_SCREEN, {
      xGridAttribute: {
        count: 8,
        margin: 24,
        interval: 12
      },
      yGridAttribute: {
        count: 8,
        margin: 24,
        interval: 12
      }
    });
  }

  private initExpandingUltraScreenGrid() {
    this.displayGridMap.set(DisplayType.EXPANDING_ULTRA_SCREEN, {
      xGridAttribute: {
        count: 12,
        margin: 32,
        interval: 12
      },
      yGridAttribute: {
        count: 8,
        margin: 24,
        interval: 12
      }
    });
  }

  private initPadGrid() {
    this.displayGridMap.set(DisplayType.PAD, {
      xGridAttribute: {
        count: 12,
        margin: 32,
        interval: 16
      },
      yGridAttribute: {
        count: 8,
        margin: 24,
        interval: 12
      }
    });
  }

  private static instance: GridUtil;

  public static getInstance(): GridUtil {
    if (!GridUtil.instance) {
      GridUtil.instance = new GridUtil();
    }
    return GridUtil.instance;
  }

  /**
   * 获取锁屏签名/艺术签名半模态框宽度
   * 宽度 = 宫格数量 x 宫格长度 + 宫格间距数量 x 宫格间距长度
   * @returns 锁屏签名/艺术签名半模态框宽度
   */
  public getBindSheetWidth(): number {
    // 直板机、折叠屏折叠态返回屏幕宽度
    if (this.getDisplayType() === DisplayType.BAR) {
      log.showInfo(TAG, 'Return display width.')
      return this.getDisplayWidth();
    }
    let gridColumnCount = this.getBindSheetGridCount();
    return gridColumnCount * this.getGridLength() + (gridColumnCount - 1) * this.getGridAttribute()?.interval;
  }

  public getDisplayType(): DisplayType {
    let displayType: DisplayType = DisplayType.BAR;
    log.showInfo(TAG, `getDisplayType ${DeviceHelper.isFoldExpanded()} ${DeviceHelper.isLargeInFoldProduct()}
      ${DeviceHelper.isUltraScreenProduct()} ${DeviceHelper.isMState()}`)
    if ((DeviceHelper.isFoldExpanded() && DeviceHelper.isLargeInFoldProduct()) ||
      (DeviceHelper.isUltraScreenProduct() && DeviceHelper.isMState())) {
      displayType = DisplayType.EXPANDING_BIG_SCREEN;
    } else if (DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState()) {
      displayType = DisplayType.EXPANDING_ULTRA_SCREEN;
    } else if (DeviceHelper.isPad()) {
      displayType = DisplayType.PAD;
    }
    log.showInfo(TAG, `Display type is ${displayType}.`)
    return displayType;
  }

  /**
   * 获取锁屏签名/艺术签名半模态框宫格数量
   * 大屏：8占8
   * 超大屏：横屏12占8，竖屏8占8
   * Pad：横屏12占8，竖屏大pad 8占6，小pad 8占8
   * @returns 锁屏签名/艺术签名半模态框宽度
   */
  private getBindSheetGridCount(): number {
    if (DeviceHelper.isPad() && !DeviceHelper.isLandscape() && this.getDisplayWidth() >= PAD_PORTRAIT_SMALL_SIZE) {
      return PAD_SMALL_PORTRAIT;
    }
    return DEFAULT;
  }

  /**
   * 获取宫格长度
   * 宫格长度 = (屏幕宽度 - 宫格边距 * 2 - 宫格间距 * (宫格数量 - 1)) / 宫格数量
   * @returns
   */
  private getGridLength(): number {
    let gridAttribute = this.getGridAttribute();
    return (this.getDisplayWidth() - gridAttribute?.margin * 2 - gridAttribute?.interval * (gridAttribute?.count - 1)) /
      gridAttribute?.count;
  }

  /**
   * 获取宫格属性
   */
  private getGridAttribute(): GridAttribute {
    let displayType: DisplayType = this.getDisplayType();
    let gridAttribute = DeviceHelper.isLandscape() ? this.displayGridMap.get(displayType)?.xGridAttribute :
      this.displayGridMap.get(displayType)?.yGridAttribute;
    return gridAttribute ?? {
      count: 4,
      margin: 24,
      interval: 12
    };
  }

  /**
   * 获取屏幕宽度
   */
  private getDisplayWidth(): number {
    return clockLayoutHelper.getScreenWidth();
  }
}