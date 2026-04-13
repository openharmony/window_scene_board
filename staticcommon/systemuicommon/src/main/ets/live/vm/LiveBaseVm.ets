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

import { BaseVm } from '../../vm/BaseVm';
import { LiveNotification } from '../model/LiveNotification';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { Log, LogUtil } from '../../utils/LogUtil';

export abstract class LiveBaseVm extends BaseVm<ILiveVmInjector> {
  protected readonly TAG: string = 'LiveBaseVm';

  private _log?: Log;
  protected get log(): Log {
    if (!this._log) {
      this._log = LogUtil.getLiveLogger(`${this.TAG}_${this.vmInjector.scene}`);
    }
    return this._log;
  }

  /**
   * 判断点击的坐标是否在某一个组件的区域内
   *
   * @param x 点击横坐标
   * @param y 点击纵坐标
   * @param area 组件区域
   */
  protected checkPointInArea(x: number, y: number, area: Area): boolean {
    let top = vp2px(area.globalPosition.y as number);
    let bottom = top + vp2px(area.height as number);
    let left = vp2px(area.globalPosition.x as number);
    let right = left + vp2px(area.width as number);
    this.log.showInfo(`checkPointInArea x:${x}, y:${y}, l:${left}, t:${top}, r:${right}, b:${bottom}`);
    if (y < top || y > bottom || x < left || x > right) {
      return false;
    }
    return true;
  }

  /**
   * 将字符串的颜色值和透明度转成RGBA
   * @param color
   * @param alpha
   * @returns
   */
  protected convertColorToRgba(color: string, alpha: number): string {
    let red: number;
    let green: number;
    let blue: number;
    const colorStr = color.substring(1);
    if (colorStr.length === 6) {
      red = parseInt(colorStr.substring(0, 2), 16);
      green = parseInt(colorStr.substring(2, 4), 16);
      blue = parseInt(colorStr.substring(4, 6), 16);
    } else {
      red = parseInt(colorStr.substring(2, 4), 16);
      green = parseInt(colorStr.substring(4, 6), 16);
      blue = parseInt(colorStr.substring(6, 8), 16);
    }
    // 取渐变的1/2作为背板
    red = Math.floor(red / 2);
    green = Math.floor(green / 2);
    blue = Math.floor(blue / 2);
    return 'rgba(' + red + ',' + green + ',' + blue + ',' + alpha + ')';
  }
}

/**
 * 与每一条实况相关的VM
 */
@ObservedV2
export abstract class LiveItemBaseVm extends LiveBaseVm {
  @Trace public live: LiveNotification;

  constructor(vmInjector: ILiveVmInjector, live: LiveNotification) {
    super(vmInjector);
    this.live = live;
  }

  init(): void {}

  destroy(): void {}

  public onUpdate(live: LiveNotification): void {
    this.live = live;
  }
}

/**
 * 三方卡片扩展区VM
 */
@ObservedV2
export abstract class LiveCardOtherLayoutVm<T> extends LiveItemBaseVm {
  @Trace public card: T;

  constructor(vmInjector: ILiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.card = live.card as T;
  }

  public onUpdate(live: LiveNotification): void {
    super.onUpdate(live);
    this.card = live.card as T;
  }
}