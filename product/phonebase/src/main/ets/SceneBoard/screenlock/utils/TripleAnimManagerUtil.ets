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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { UltraScreenStatus } from '@ohos/screenlockcommon';
import { TripleAnimConstants } from '../constant/TripleAnimConstants';

const TAG: string = 'TripleAnimManagerUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const BOTTOM_TOOLS_MARGIN_F = 16;
const BOTTOM_TOOLS_MARGIN_M = 32;
const BOTTOM_TOOLS_MARGIN_G = 48;
const IS_ULTRA_SCREEN = DeviceHelper.isUltraScreenProduct();

// 超大屏状态切换
export enum TripleStateChange {
  INVALID,
  F_TO_M,
  F_TO_G,
  M_TO_F,
  M_TO_G,
  G_TO_F,
  G_TO_M,
}

// 密码面板在屏幕的位置
export enum FoldablePsdPos {
  Left,
  Center,
  Right,
}

type TripleStateChangeFunction = (screenWidth: number) => number;

const quickToolsTransXCalculateMap: Map<TripleStateChange, TripleStateChangeFunction> = new Map([
  [TripleStateChange.F_TO_M, (screenWidth: number) => {
    return -screenWidth;
  }],
  [TripleStateChange.M_TO_F, (screenWidth: number) => {
    return TripleAnimConstants.CONSTANT_THREE * screenWidth / TripleAnimConstants.CONSTANT_EIGHT;
  }],
  [TripleStateChange.M_TO_G, (screenWidth: number) => {
    return screenWidth / TripleAnimConstants.CONSTANT_TWO - px2vp(BOTTOM_TOOLS_MARGIN_G - BOTTOM_TOOLS_MARGIN_M);
  }],
  [TripleStateChange.G_TO_M, (screenWidth: number) => {
    return -screenWidth / TripleAnimConstants.CONSTANT_THREE;
  }],
  [TripleStateChange.F_TO_G, () => {
    return -px2vp(BOTTOM_TOOLS_MARGIN_G - BOTTOM_TOOLS_MARGIN_F);
  }],
  [TripleStateChange.G_TO_F, () => {
    return px2vp(BOTTOM_TOOLS_MARGIN_G - BOTTOM_TOOLS_MARGIN_F);
  }],
  [TripleStateChange.INVALID, () => {
    return TripleAnimConstants.CONSTANT_ZERO;
  }],
]);

const bottomCameraTransXCalculateMap: Map<TripleStateChange, TripleStateChangeFunction> = new Map([
  [TripleStateChange.F_TO_M, (screenWidth: number) => {
    return -screenWidth;
  }],
  [TripleStateChange.M_TO_F, (screenWidth: number) => {
    return TripleAnimConstants.CONSTANT_THREE * screenWidth / TripleAnimConstants.CONSTANT_EIGHT;
  }],
  [TripleStateChange.M_TO_G, () => {
    return px2vp(BOTTOM_TOOLS_MARGIN_G - BOTTOM_TOOLS_MARGIN_M);
  }],
  [TripleStateChange.G_TO_M, () => {
    return -px2vp(BOTTOM_TOOLS_MARGIN_G - BOTTOM_TOOLS_MARGIN_M);
  }],
  [TripleStateChange.F_TO_G, (screenWidth: number) => {
    return -screenWidth * TripleAnimConstants.CONSTANT_TWO + px2vp(BOTTOM_TOOLS_MARGIN_G - BOTTOM_TOOLS_MARGIN_F);
  }],
  [TripleStateChange.G_TO_F, (screenWidth: number) => {
    return screenWidth / TripleAnimConstants.CONSTANT_TWO;
  }],
  [TripleStateChange.INVALID, () => {
    return TripleAnimConstants.CONSTANT_ZERO;
  }],
]);

const immersiveKeyguardTransXCalculateMap: Map<TripleStateChange, TripleStateChangeFunction> = new Map([
  [TripleStateChange.F_TO_M, (screenWidth: number) => {
    return -screenWidth;
  }],
  [TripleStateChange.M_TO_F, (screenWidth: number) => {
    return TripleAnimConstants.CONSTANT_THREE * screenWidth / TripleAnimConstants.CONSTANT_EIGHT;
  }],
  [TripleStateChange.M_TO_G, (screenWidth: number) => {
    return screenWidth / TripleAnimConstants.CONSTANT_FOUR;
  }],
  [TripleStateChange.G_TO_M, (screenWidth: number) => {
    return -screenWidth / TripleAnimConstants.CONSTANT_SIX;
  }],
  [TripleStateChange.F_TO_G, (screenWidth: number) => {
    return -screenWidth;
  }],
  [TripleStateChange.G_TO_F, (screenWidth: number) => {
    return screenWidth / TripleAnimConstants.CONSTANT_THREE;
  }],
  [TripleStateChange.INVALID, () => {
    return TripleAnimConstants.CONSTANT_ZERO;
  }],
]);

const foldablePSDCalculateMap: Map<TripleStateChange, TripleStateChangeFunction> = new Map([
  [TripleStateChange.F_TO_M, (screenWidth: number) => {
    return -screenWidth;
  }],
  [TripleStateChange.M_TO_F, (screenWidth: number) => {
    return TripleAnimConstants.CONSTANT_THREE * screenWidth / TripleAnimConstants.CONSTANT_EIGHT;
  }],
  [TripleStateChange.M_TO_G, (screenWidth: number) => {
    let pos: FoldablePsdPos = TripleAnimManagerUtil.getFoldablePSDPos();
    let trans: number = 0;
    if (pos === FoldablePsdPos.Left) {
      trans = screenWidth / TripleAnimConstants.CONSTANT_TWO;
    }
    if (pos === FoldablePsdPos.Right) {
      trans = TripleAnimConstants.CONSTANT_ZERO;
    }
    if (pos === FoldablePsdPos.Center) {
      trans = screenWidth / TripleAnimConstants.CONSTANT_FOUR;
    }
    return trans;
  }],
  [TripleStateChange.G_TO_M, (screenWidth: number) => {
    let pos: FoldablePsdPos = TripleAnimManagerUtil.getFoldablePSDPos();
    let trans: number = 0;
    if (pos === FoldablePsdPos.Left) {
      trans = -screenWidth / TripleAnimConstants.CONSTANT_TWO;
    }
    if (pos === FoldablePsdPos.Right) {
      trans = TripleAnimConstants.CONSTANT_ZERO;
    }
    if (pos === FoldablePsdPos.Center) {
      trans = -screenWidth / TripleAnimConstants.CONSTANT_SIX;
    }
    return trans;
  }],
  [TripleStateChange.F_TO_G, (screenWidth: number) => {
    return -screenWidth / TripleAnimConstants.CONSTANT_THREE;
  }],
  [TripleStateChange.G_TO_F, (screenWidth: number) => {
    let pos: FoldablePsdPos = TripleAnimManagerUtil.getFoldablePSDPos();
    let trans: number = 0;
    if (pos === FoldablePsdPos.Left) {
      trans = TripleAnimConstants.CONSTANT_ZERO;
    }
    if (pos === FoldablePsdPos.Right || pos === FoldablePsdPos.Center) {
      trans = screenWidth;
    }
    return trans;
  }],
  [TripleStateChange.INVALID, () => {
    return TripleAnimConstants.CONSTANT_ZERO;
  }],
]);

const clockTransXCalculateMap: Map<TripleStateChange, TripleStateChangeFunction> = new Map([
  [TripleStateChange.F_TO_M, (screenWidth: number) => {
    return -screenWidth;
  }],
  [TripleStateChange.M_TO_F, (screenWidth: number) => {
    return TripleAnimConstants.CONSTANT_THREE * screenWidth / TripleAnimConstants.CONSTANT_EIGHT;
  }],
  [TripleStateChange.M_TO_G, (screenWidth: number) => {
    return TripleAnimManagerUtil.preClockPosition[0] + screenWidth / TripleAnimConstants.CONSTANT_TWO -
    TripleAnimManagerUtil.curClockPosition[0];
  }],
  [TripleStateChange.G_TO_M, (screenWidth: number) => {
    return TripleAnimManagerUtil.preClockPosition[0] - screenWidth / TripleAnimConstants.CONSTANT_THREE -
    TripleAnimManagerUtil.curClockPosition[0];
  }],
  [TripleStateChange.F_TO_G, () => {
    return TripleAnimManagerUtil.preClockPosition[0] - TripleAnimManagerUtil.curClockPosition[0];
  }],
  [TripleStateChange.G_TO_F, () => {
    return TripleAnimManagerUtil.preClockPosition[0] - TripleAnimManagerUtil.curClockPosition[0];
  }],
  [TripleStateChange.INVALID, () => {
    return TripleAnimConstants.CONSTANT_ZERO;
  }],
]);

// 超大屏锁屏开合动效参数管理类
export class TripleAnimManagerUtil {
  private static mInstance: TripleAnimManagerUtil = new TripleAnimManagerUtil();
  // pre表示折叠前时钟组件位置
  public static preClockPosition: number[] = [0, 0];
  // cur表示折叠后时钟组件位置
  public static curClockPosition: number[] = [0, 0];
  // 判断是否跳过时钟组件的updateClockMargin()时执行的动效
  private static isSkipClockMarginAnimation: boolean = false;
  // 组件与动效初始值计算函数映射关系
  private animationMap: Map<string, Map<TripleStateChange, TripleStateChangeFunction>> = new Map();
  // 超大屏产品开合状态映射关系
  private stateChangeMap: Map<string, TripleStateChange> = new Map();

  constructor() {
    this.animationMap.set(TripleAnimConstants.LOCK_ICON, immersiveKeyguardTransXCalculateMap);
    this.animationMap.set(TripleAnimConstants.CLOCK, clockTransXCalculateMap);
    this.animationMap.set(TripleAnimConstants.IMMERSIVE_CAP, immersiveKeyguardTransXCalculateMap);
    this.animationMap.set(TripleAnimConstants.IMMERSIVE_LIST, immersiveKeyguardTransXCalculateMap);
    this.animationMap.set(TripleAnimConstants.IMMERSIVE_CARD, immersiveKeyguardTransXCalculateMap);
    this.animationMap.set(TripleAnimConstants.QUICK_TOOLS, quickToolsTransXCalculateMap);
    this.animationMap.set(TripleAnimConstants.BOTTOM_CAMERA, bottomCameraTransXCalculateMap);
    this.animationMap.set(TripleAnimConstants.FOLDABLE_PSD, foldablePSDCalculateMap);

    this.stateChangeMap.set(`${UltraScreenStatus.F_STATUS},${UltraScreenStatus.M_STATUS}`, TripleStateChange.F_TO_M);
    this.stateChangeMap.set(`${UltraScreenStatus.F_STATUS},${UltraScreenStatus.G_STATUS}`, TripleStateChange.F_TO_G);
    this.stateChangeMap.set(`${UltraScreenStatus.M_STATUS},${UltraScreenStatus.F_STATUS}`, TripleStateChange.M_TO_F);
    this.stateChangeMap.set(`${UltraScreenStatus.M_STATUS},${UltraScreenStatus.G_STATUS}`, TripleStateChange.M_TO_G);
    this.stateChangeMap.set(`${UltraScreenStatus.G_STATUS},${UltraScreenStatus.F_STATUS}`, TripleStateChange.G_TO_F);
    this.stateChangeMap.set(`${UltraScreenStatus.G_STATUS},${UltraScreenStatus.M_STATUS}`, TripleStateChange.G_TO_M);
  }

  public static getInstance(): TripleAnimManagerUtil {
    if (!TripleAnimManagerUtil.mInstance) {
      TripleAnimManagerUtil.mInstance = new TripleAnimManagerUtil();
    }
    return TripleAnimManagerUtil.mInstance;
  }

  // 更新时钟前一状态位置信息
  public setPreClockPosition(x: number | undefined, y: number | undefined): void {
    log.showInfo(`setPreClockPosition: posX is ${x}, posY is ${y}`);
    if (!IS_ULTRA_SCREEN) {
      return;
    }
    if (x === undefined || y === undefined) {
      return;
    }
    TripleAnimManagerUtil.preClockPosition[0] = x;
    TripleAnimManagerUtil.preClockPosition[1] = y;
  }

  // 更新时钟下一状态位置信息
  public setCurClockPosition(x: number, y: number): void {
    log.showInfo(`setCurClockPosition: posX is ${x}, posY is ${y}`);
    if (!IS_ULTRA_SCREEN) {
      return;
    }
    TripleAnimManagerUtil.curClockPosition[0] = x;
    TripleAnimManagerUtil.curClockPosition[1] = y;
  }

  // 设置是否需要跳过时钟组件的updateClockMargin()动画
  public setSkipClockMarginAnimation(isSkip: boolean): void {
    if (!IS_ULTRA_SCREEN) {
      log.showInfo('not triple fold product, dont skip animation');
      return;
    }
    TripleAnimManagerUtil.isSkipClockMarginAnimation = isSkip;
    return;
  }

  // 判断当前是否需要跳过时钟组件updateClockMargin()动画
  public getSkipClockMarginAnimation(): boolean {
    log.showInfo(`getSkipClockMarginAnimation: ${TripleAnimManagerUtil.isSkipClockMarginAnimation}`);
    if (!IS_ULTRA_SCREEN) {
      log.showInfo('not triple fold product, return false');
      return false;
    }
    return TripleAnimManagerUtil.isSkipClockMarginAnimation;
  }

  // 获取超大屏锁屏开合状态
  public getTripleScreenLockStateChange(oldUltraScreenState: UltraScreenStatus,
    newUltraScreenState: UltraScreenStatus): TripleStateChange {
    log.showInfo(`getTripleScreenLockStateChange, old: ${oldUltraScreenState}, new: ${newUltraScreenState}`);
    if (!IS_ULTRA_SCREEN) {
      return TripleStateChange.INVALID;
    }
    let key: string = `${oldUltraScreenState},${newUltraScreenState}`;
    if (this.stateChangeMap.get(key) !== undefined) {
      return this.stateChangeMap.get(key) as TripleStateChange;
    } else {
      return TripleStateChange.INVALID;
    }
  }

  // 获取锁屏密码面板位置
  public static getFoldablePSDPos(): FoldablePsdPos {
    let isLeft: boolean = AppStorage.get<boolean>('isLeft') as boolean;
    let isRight: boolean = AppStorage.get<boolean>('isRight') as boolean;
    if (!isLeft && isRight) {
      return FoldablePsdPos.Left;
    } else if (isLeft && !isRight) {
      return FoldablePsdPos.Right;
    } else {
      return FoldablePsdPos.Center;
    }
  }

  // 计算各个组件位移动画初始值
  public initTripleAnimTransX(stateChange: TripleStateChange, screenWidth: number, animScene: string): number {
    let transX: number = 0;
    let calculate = this.animationMap.get(animScene);
    if (calculate && calculate.get(stateChange)) {
      let fun = calculate.get(stateChange) as TripleStateChangeFunction;
      transX = fun(screenWidth);
    }
    if (animScene === TripleAnimConstants.CLOCK) {
      // 更新时钟位置信息
      TripleAnimManagerUtil.preClockPosition[0] = TripleAnimManagerUtil.curClockPosition[0];
    }
    log.showInfo(`calculateInitialValue, stateChange is ${stateChange}, transX is ${transX}`);
    return transX;
  }

  // 计算时钟组件Y方向位移动画初始值
  public initTripleClockTransY(stateChange: TripleStateChange): number {
    let transY: number = 0;
    switch (stateChange) {
      case TripleStateChange.F_TO_M:
      case TripleStateChange.M_TO_F:
        transY = TripleAnimConstants.CONSTANT_ZERO;
        break;
      case TripleStateChange.M_TO_G:
      case TripleStateChange.G_TO_M:
      case TripleStateChange.F_TO_G:
      case TripleStateChange.G_TO_F:
        transY = TripleAnimManagerUtil.preClockPosition[1] - TripleAnimManagerUtil.curClockPosition[1];
        break;
      default:
        transY = TripleAnimConstants.CONSTANT_ZERO;
        break;
    }
    log.showInfo(`initTripleClockTransY, stateChange is ${stateChange}, transY is ${transY}`);
    TripleAnimManagerUtil.preClockPosition[1] = TripleAnimManagerUtil.curClockPosition[1];
    return transY;
  }

  // 返回开合动画曲线
  public getTripleAnimCurves(stateChange: TripleStateChange): ICurve {
    log.showInfo(`getTripleAnimCurves, stateChange is ${stateChange}`);
    let tripleAnimtionCurve: ICurve;
    switch (stateChange) {
      case TripleStateChange.F_TO_M:
      case TripleStateChange.M_TO_F:
      case TripleStateChange.M_TO_G:
      case TripleStateChange.G_TO_M:
        tripleAnimtionCurve = TripleAnimConstants.TRANSLATE_CURVES_DEFAULT;
        break;
      case TripleStateChange.F_TO_G:
      case TripleStateChange.G_TO_F:
        tripleAnimtionCurve = TripleAnimConstants.TRANSLATE_CURVES;
        break;
      default:
        tripleAnimtionCurve = TripleAnimConstants.TRANSLATE_CURVES_DEFAULT;
        break;
    }
    return tripleAnimtionCurve;
  }
}