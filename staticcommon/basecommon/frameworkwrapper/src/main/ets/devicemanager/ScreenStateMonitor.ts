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
import {
  BreakpointManager, BreakpointData, BreakpointOrientation, BreakpointState
} from './BreakpointManager';

const TAG = 'ScreenStateMonitor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum ScreenState {
  F = 'F',
  M = 'M',
  G = 'G',
}

export enum ScreenOrientation {
  LANDSCAPE = 'landscape',
  PORTRAIT = 'portrait',
}
export interface ScreenStateModel {
  screenState: ScreenState;
  orientation: ScreenOrientation;
  width: number,
  height: number,
}

export type ScreenStateChangeListener = (oldScreenState: ScreenStateModel, screenState: ScreenStateModel) => void;

export class ScreenStateMonitor {
  private static instance: ScreenStateMonitor;
  private screenStateListenerMap: Map<string, ScreenStateChangeListener> = new Map();

  private constructor() {
    BreakpointManager.getInstance().registerBreakpointDataChange(TAG,
      (oldData: BreakpointData, newData: BreakpointData) => {
        this.updateBreakpointData(oldData, newData);
      }, 1);
  }

  public static getInstance(): ScreenStateMonitor {
    if (!ScreenStateMonitor.instance) {
      ScreenStateMonitor.instance = new ScreenStateMonitor();
    }
    return ScreenStateMonitor.instance;
  }

  public getCurrentScreenStateModel(): ScreenStateModel {
    return this.getScreenStateModel(BreakpointManager.getInstance().getBreakpointData());
  }

  public registerScreenStateChangeListener(key: string, listener: ScreenStateChangeListener): void {
    this.screenStateListenerMap.set(key, listener);
  }

  public unRegisterScreeStateChangeListener(key: string): void {
    this.screenStateListenerMap.delete(key);
  }

  public updateBreakpointData(previousBreakpointData: BreakpointData, currentBreakpointData: BreakpointData): void {
    let previousScreenModel = this.getScreenStateModel(previousBreakpointData);
    let currentScreenModel = this.getScreenStateModel(currentBreakpointData);
    log.showInfo(`prev:${this.getScreenProp(previousScreenModel)}, current:${this.getScreenProp(currentScreenModel)}`);
    Array.from(this.screenStateListenerMap.values()).forEach(callbackFun =>
    callbackFun?.(previousScreenModel, currentScreenModel));
  }

  /**
   * 获取ScreenStateModel字符串
   * @param screenModel
   * @returns
   */
  public getScreenProp(screenModel: ScreenStateModel): string {
    return `${screenModel.screenState} ${screenModel.orientation} w:${screenModel.width} h:${screenModel.height}`
  }

  /**
   * 根据传入的断点数据解析屏幕状态
   * @param data 断点数据
   * @returns 屏幕状态 F, M, G
   */
  public getScreenStateModel(data: BreakpointData): ScreenStateModel {
    //设置默认状态
    let screenOrientation = ScreenOrientation.PORTRAIT;
    let state = ScreenState.F;
    let width = data.width;
    let height = data.height;
    //竖屏
    if (data.orientation === BreakpointOrientation.PORTRAIT) {
      if (data.landscape === BreakpointState.SM && data.portrait === BreakpointState.LG) {
        state = ScreenState.F;
      } else if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.MD) {
        state = ScreenState.M;
      } else if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.LG) {
        state = ScreenState.G;
      } else {
        log.showError(`invalid breakpoint data, landscape: ${data.landscape}, portrait: ${data.portrait}, orientation:${
          data.orientation}, w: ${data.width}, h:${data.height}`);
      }
    } else {
      screenOrientation = ScreenOrientation.LANDSCAPE;
      if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.SM) {
        screenOrientation = ScreenOrientation.PORTRAIT;
        let tempWidth: number = width;
        let tempHeight: number = height;
        width = tempHeight;
        height = tempWidth;
        state = ScreenState.F;
      } else if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.MD) {
        state = ScreenState.M;
      } else if (data.landscape === BreakpointState.LG && data.portrait === BreakpointState.SM) {
        state = ScreenState.G;
      } else {
        log.showError(`invalid breakpoint data, landscape: ${data.landscape}, portrait: ${data.portrait}, orientation:${
          data.orientation}, w: ${data.width}, h:${data.height}`);
      }
    }
    return {
      screenState: state,
      orientation: screenOrientation,
      width: width,
      height: height,
    };
  }
}