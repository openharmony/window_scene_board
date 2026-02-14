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

import { display } from '@kit.ArkUI';
import { LogDomain, LogHelper, DomainName, UIContextHelper } from '@ohos/basicutils';
import { TraceUtil } from '@ohos/basicutils';

const TAG = 'BreakpointManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export enum BreakpointState {
  XS = 'xs',
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
  XL = 'xl',
}

export enum BreakpointOrientation {
  LANDSCAPE = 'landscape',
  PORTRAIT = 'portrait',
}

export interface BreakpointData {
  landscape: BreakpointState;
  portrait: BreakpointState;
  orientation: BreakpointOrientation;
  width: number,
  height: number,
}

interface BreakpointListenerValue {
  callback: BreakpointEventListener;
  index: number;
  key: string;
}

const BREAKPOINT_SM_MIN_VALUE: number = 320;
const BREAKPOINT_MD_MIN_VALUE: number = 600;
const BREAKPOINT_LG_MIN_VALUE: number = 840;
const BREAKPOINT_XL_MIN_VALUE: number = 1440;

const BREAKPOINT_MD_MIN_RATIO: number = 0.8;
const BREAKPOINT_LG_MIN_RATIO: number = 1.2;

/**
 * 断点事件分发回调函数
 *
 * @param oldData 旧的断点数据
 * @param newData 新的断点数据
 */
export type BreakpointEventListener = (oldData: BreakpointData, newData: BreakpointData) => void;

export class BreakpointManager {

  private static readonly BREAKPOINT_RUN_TRACE = 'breakpointRunTrace';

  private static instance: BreakpointManager;
  private breakpointListenerMap: Map<string, BreakpointListenerValue> = new Map();

  private breakpointData: BreakpointData = this.getCurrentBreakpointData();

  private constructor() {
  }

  private setCurrentBreakpointData(breakpointData: BreakpointData): void {
    this.breakpointData = breakpointData;
  }

  public static getInstance(): BreakpointManager {
    if (!BreakpointManager.instance) {
      BreakpointManager.instance = new BreakpointManager();
    }
    return BreakpointManager.instance;
  }

  private getWindowWidthBreakpoint(width: number): BreakpointState {
    let breakpoint: BreakpointState = BreakpointState.XS;
    if (width >= BREAKPOINT_SM_MIN_VALUE && width < BREAKPOINT_MD_MIN_VALUE) {
      breakpoint = BreakpointState.SM;
    } else if (width >= BREAKPOINT_MD_MIN_VALUE && width < BREAKPOINT_LG_MIN_VALUE) {
      breakpoint = BreakpointState.MD;
    } else if (width >= BREAKPOINT_LG_MIN_VALUE && width < BREAKPOINT_XL_MIN_VALUE) {
      breakpoint = BreakpointState.LG;
    } else if (width >= BREAKPOINT_XL_MIN_VALUE) {
      breakpoint = BreakpointState.XL;
    }
    return breakpoint;
  }

  private getWindowHeightBreakpoint(ratio: number): BreakpointState {
    let breakpoint: BreakpointState = BreakpointState.SM;
    if (ratio >= BREAKPOINT_MD_MIN_RATIO && ratio < BREAKPOINT_LG_MIN_RATIO) {
      breakpoint = BreakpointState.MD;
    } else if (ratio >= BREAKPOINT_LG_MIN_RATIO) {
      breakpoint = BreakpointState.LG;
    }
    return breakpoint;
  }

  /**
   * 通过Display属性获取实时断点数据
   * @returns 断点数据
   */
  public getCurrentBreakpointData(): BreakpointData {
    try {
      const defaultDisplay: display.Display = display.getDefaultDisplaySync();
      const rotation: number = defaultDisplay.orientation;
      let displayWidth = defaultDisplay.width;
      let displayHeight = defaultDisplay.height;
      switch (rotation) {
        case display.Orientation.LANDSCAPE:
        case display.Orientation.LANDSCAPE_INVERTED:
          if (defaultDisplay.width < defaultDisplay.height) {
            displayWidth = defaultDisplay.height;
            displayHeight = defaultDisplay.width;
          }
          break;
        case display.Orientation.PORTRAIT:
        case display.Orientation.PORTRAIT_INVERTED:
          if (defaultDisplay.width > defaultDisplay.height) {
            displayWidth = defaultDisplay.height;
            displayHeight = defaultDisplay.width;
          }
          break;
        default :
          break;
      }
      const width = UIContextHelper.px2vp(defaultDisplay?.id, displayWidth);
      const height = UIContextHelper.px2vp(defaultDisplay?.id, displayHeight);
      let ratio: number = height / width;
      log.showInfo(`getDataFromDisplay width: ${width}, height: ${height}, ratio: ${ratio}, rotation: ${rotation}`);
      const landscapeBreakpoint = this.getWindowWidthBreakpoint(width);
      const portraitBreakpoint = this.getWindowHeightBreakpoint(ratio);
      let orientation: BreakpointOrientation = BreakpointOrientation.PORTRAIT;
      if (rotation === display.Orientation.LANDSCAPE || rotation === display.Orientation.LANDSCAPE_INVERTED) {
        orientation = BreakpointOrientation.LANDSCAPE;
      }
      return {
        landscape: landscapeBreakpoint,
        portrait: portraitBreakpoint,
        orientation: orientation,
        width: displayWidth,
        height: displayHeight
      };
    } catch (e) {
      log.error(`getCurrentBreakpointData failed: ${e}`);
    }
    return this.breakpointData;
  }

  private getBreakpointListenerArray(): BreakpointListenerValue[] {
    return Array.from(this.breakpointListenerMap.values()).sort(
      (one: BreakpointListenerValue, two: BreakpointListenerValue) => {
        return two.index - one.index;
      });
  }

  private breakpointDataEqual(breakpointData: BreakpointData): boolean {
    return breakpointData.landscape === this.breakpointData.landscape &&
      breakpointData.portrait === this.breakpointData.portrait &&
      breakpointData.orientation === this.breakpointData.orientation;
  }

  /**
   * 更新断点数据
   * @param width
   * @param height
   * @param isPortrait 是否竖屏
   * @param screenId
   */
  public updateBreakpointData(width: number, height: number, isPortrait: boolean, screenId: number): void {
    const newBreakpointData: BreakpointData = this.transToBreakpointData(width, height, isPortrait, screenId);
    if (!this.breakpointDataEqual(newBreakpointData)) {
      log.showInfo(`old landscapeState: ${this.breakpointData.landscape}, portraitState ${
      this.breakpointData.portrait}, orientation: ${this.breakpointData.orientation}, width: ${
      this.breakpointData.width}, height: ${this.breakpointData.height}`);
      log.showInfo(`new landscapeState: ${newBreakpointData.landscape}, portraitState ${
      newBreakpointData.portrait}, orientation: ${newBreakpointData.orientation}, width: ${
      newBreakpointData.width}, height: ${newBreakpointData.height}`);
      TraceUtil.startTrace(DomainName.SCB, BreakpointManager.BREAKPOINT_RUN_TRACE);
      const oldBreakpointData: BreakpointData = this.breakpointData;
      this.setCurrentBreakpointData(newBreakpointData);
      const breakpointListenerArray: BreakpointListenerValue[] = this.getBreakpointListenerArray();
      breakpointListenerArray.forEach((item: BreakpointListenerValue) => {
        log.showInfo(`callback key: ${item.key}, index: ${item.index}`);
        item?.callback?.(oldBreakpointData, newBreakpointData);
      });
      TraceUtil.endTrace(DomainName.SCB, BreakpointManager.BREAKPOINT_RUN_TRACE);
    };
  }

  /**
   * 将由screenProperty中传入的width, height, 方向, screenId数据转为断点信息。
   * @param propertyWidth
   * @param propertyHeight
   * @param isPortrait  是否竖屏
   * @param screenId
   * @returns
   */
  private transToBreakpointData(propertyWidth: number, propertyHeight: number, isPortrait: boolean, screenId: number): BreakpointData {
    try {
      const width = UIContextHelper.px2vp(screenId, propertyWidth);
      const height = UIContextHelper.px2vp(screenId, propertyHeight);
      let ratio: number = height / width;
      log.showInfo(`transToBreakpointData, width: ${width}, height: ${height}, isPortrait: ${isPortrait}`);
      const landscapeBreakpoint = this.getWindowWidthBreakpoint(width);
      const portraitBreakpoint = this.getWindowHeightBreakpoint(ratio);
      let orientation: BreakpointOrientation = BreakpointOrientation.PORTRAIT;
      if (!isPortrait) {
        orientation = BreakpointOrientation.LANDSCAPE;
      }
      return {
        landscape: landscapeBreakpoint,
        portrait: portraitBreakpoint,
        orientation: orientation,
        width: propertyWidth,
        height: propertyHeight
      };
    } catch (e) {
      log.error(`transToBreakpointData failed: ${e}`);
    }
    return this.breakpointData;
  }

  public getBreakpointData(): BreakpointData {
    return this.breakpointData;
  }

  /**
   * 注册断点数据改变监听
   *
   * @param key 注册的key主要用于注销
   * @param callback 回调函数
   * @param index 监听断点状态改变时分发数据的优先级，越大优先级越高，越早被通知
   */
  public registerBreakpointDataChange(key: string, callback: BreakpointEventListener, index: number = 0): void {
    log.showInfo(`register key: ${key}, exist: ${this.breakpointListenerMap.has(key)}`);
    this.breakpointListenerMap.set(key, {
      callback: callback,
      index: index,
      key: key
    });
  }

  public unregisterBreakpointDataChange(key: string): void {
    log.showInfo(`unregister key: ${key}`);
    if (this.breakpointListenerMap.has(key)) {
      log.showInfo(`unregister success key: ${key}`);
      this.breakpointListenerMap.delete(key);
    }
  }
}
