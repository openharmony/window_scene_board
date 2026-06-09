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

import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SlMainStateType, WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BpCalculator } from '@ohos/screenlockcommon';
import { slCtxHelper, DisplayStateManager } from '@ohos/screenlockcommon/Index';
import { WidgetSize, GridAmount, ISlState, WidgetArea,
  WidgetPivot } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  BaseConstants,
  baseStateMgr,
  DisplaySizeState,
  IState,
  OnStateChangeListener,
  StateType
} from '@ohos/systemuicommon';
import { SlStaticState} from '../data/SlStaticState'
import { slStateHelper } from '../helper/SlStateHelper';

const TAG = 'SlCommonStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MIN = BaseConstants.MIN_VALUE;
const DIV = BaseConstants.DIVIDE;

enum SlDeviceType { // 锁屏管理设备类型
  BAR_PHONE = 0, // 直板机
  FOLD_LARGE, // 大折叠
  PAD // 平板
}

enum SlDeviceState { // 设备状态
  NONE = -1, // 无状态
  BAR_PHONE = 0, // 直板机状态
  FOLD_PHONE_EXPAND, // 大折叠展开状态
  PAD_PORTRAIT, // 平板竖屏
  PAD_LANDSCAPE // 平板横屏
}

const GRID_AMOUNT: GridAmount[] = [ // 不同设备状态栅格数
  { x: 4, y: 7 }, // 直板机状态
  { x: 8, y: 7 }, // 大折叠展开状态
  { x: 6, y: 10 }, // 平板竖屏状态
  { x: 10, y: 6 }, // 平板横屏状态
];

const GRID_MARGIN: WidgetSize[] = [ // 不同设备状态栅格计算时横竖方向间距
  { width: 24, height: 104 }, // 直板机状态
  { width: 24, height: 104 }, // 大折叠展开状态
  { width: 99, height: 99 }, // 平板竖屏状态
  { width: 99, height: 99 }, // 平板横屏状态
];

// 锁屏面板公共状态管理
class SlCommonStateManager {
  private deviceType: SlDeviceType = SlDeviceType.BAR_PHONE; // 设备类型
  private deviceState: SlDeviceState = SlDeviceState.NONE; // 设备状态
  private baseStateListener: OnStateChangeListener = { // 基础状态监听回调
    onStateChange: (state: IState): void => {
      if (state.getStateType() === StateType.TYPE_DISPLAY_SIZE) {
        this.updateDisplaySize(state);
      }
    }
  };

  constructor() {
    this.initDeviceType();
  }

  init(ctx?: Context): void { // 初始化
    BpCalculator.updateDefaultDpi(ctx);
    baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.baseStateListener);
    this.updateDisplaySize(baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE)); // 屏幕大小初始化
  }

  destroy(): void { // 回收
    baseStateMgr.unregisterStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.baseStateListener);
  }

  public setWidgetArea(slType: SlMainStateType, area?: Area): void { // 记录组件显示区域
    let globalX = area?.globalPosition?.x as number ?? 0;
    let globalY = area?.globalPosition?.y as number ?? 0;
    let width = area?.width as number ?? 0;
    let height = area?.height as number ?? 0;
    let wgArea: WidgetArea = { globalX: globalX, globalY: globalY, width: width, height: height };
    let st = this.getStateByType(slType);
    st?.setSlState(WidgetStaticStateType.WIDGET_AREA, wgArea);
    // 同步刷新缩放中心
    let screenSize = this.getStaticState().getScreenSize();
    let screenCenterX = screenSize.width / DIV;
    let screenCenterY = screenSize.height / DIV;
    let wgPivot: WidgetPivot = { centerX: screenCenterX - globalX, centerY: screenCenterY - globalY };
    st?.setSlState(WidgetStaticStateType.WIDGET_SCREEN_PIVOT, wgPivot);
  }

  /**
   * 更新屏幕断点状态
   *
   * @param screenW 屏幕宽度，px
   * @param screenH 屏幕高度，px
   */
  public updateScreenBp(screenW: number, screenH: number): void {
    let calcWidth = screenW;
    let calcHeight = screenH;
    if (!DisplayStateManager.getInstance().getScreenSessionRotatable()) { // 当锁屏页面不可旋转时，保持竖屏宽高
      calcWidth = Math.min(screenW, screenH);
      calcHeight = Math.max(screenW, screenH);
    }
    let screenBp = BpCalculator.calcScreenBp(calcWidth, calcHeight, slCtxHelper.getUiContext());
    this.getStaticState().setScreenBp(screenBp);
  }

  private updateDisplaySize(state?: IState): void { // 刷新屏幕宽高
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    let sizeState = state as DisplaySizeState;
    this.updateScreenBp(sizeState.displayWidth, sizeState.displayHeight);
    this.updatePadPortrait(sizeState);
    if (this.updateDeviceState()) { // 状态刷新则刷新对应状态下各栅格参数
      let slSize = this.getSlSize(sizeState);
      let maxGrid = this.getMaxGridAmount();
      this.getStaticState()?.setMaxGridAmount(maxGrid);
      this.updateGridUnitSize(slSize, maxGrid);
      this.getStaticState()?.setScreenSize(slSize);
    }
  }

  private updatePadPortrait(state: DisplaySizeState): void { // 更新PAD设备横竖屏状态
    if (this.isPad() || this.isLargeFold()) {
      this.getStaticState()?.setPortraitState(state.displayWidth < state.displayHeight);
    }
  }

  private updateDeviceState(): boolean { // 刷新设备状态
    let state = SlDeviceState.BAR_PHONE;
    if (this.isLargeFold() && this.getStaticState()?.isDeviceExpanded()) {
      state = SlDeviceState.FOLD_PHONE_EXPAND;
    } else if (this.isPad()) {
      state = this.getStaticState()?.getPortraitState() ? SlDeviceState.PAD_PORTRAIT : SlDeviceState.PAD_LANDSCAPE;
    }
    if (this.deviceState !== state) {
      this.deviceState = state;
      log.showInfo(`updateDeviceState change: ${state}`);
      return true;
    }
    return false;
  }

  private updateGridUnitSize(slSize: WidgetSize, maxGrid: GridAmount): void { // 刷新栅格单位大小
    if (maxGrid.x <= MIN || maxGrid.y <= MIN) {
      log.showWarn('updateGridUnitSize max grid error.');
      return;
    }
    let gridMargin = this.getGridMargin();
    let db = BaseConstants.DOUBLE;
    let singleGridWidth = (slSize.width - gridMargin.width * db) / maxGrid.x;
    let singleGridHeight = (slSize.height - gridMargin.height * db) / maxGrid.y;
    this.getStaticState()?.setGridUnitSize(Math.min(singleGridWidth, singleGridHeight));
  }

  private getSlSize(state: DisplaySizeState): WidgetSize { // 锁屏面板大小
    let isBarPhoneState = this.deviceState === SlDeviceState.BAR_PHONE;
    let minSize = Math.min(state.displayWidth, state.displayHeight);
    let maxSize = Math.max(state.displayWidth, state.displayHeight);
    let width = isBarPhoneState ? minSize : state.displayWidth; // 直板机状态，保持固定宽高
    let height = isBarPhoneState ? maxSize : state.displayHeight;
    return { width: px2vp(width), height: px2vp(height) };
  }

  private getMaxGridAmount(): GridAmount { // 当前设备状态下的最大栅格数
    return GRID_AMOUNT[this.deviceState];
  }

  private getGridMargin(): WidgetSize { // 当前设备状态下的栅格横竖方向间距
    return GRID_MARGIN[this.deviceState];
  }

  private getStaticState(): SlStaticState { // 静态状态
    return slStateHelper.getSlStaticState();
  }

  private getStateByType(type: SlMainStateType): ISlState | undefined { // 目标状态
    return slUiStateMgr.getSlState(type);
  }

  private isLargeFold(): boolean { // 大大屏幕机
    return this.deviceType === SlDeviceType.FOLD_LARGE;
  }

  private isPad(): boolean { // PAD
    return this.deviceType === SlDeviceType.PAD;
  }

  private initDeviceType(): void { // 确定设备类型
    if (DeviceHelper.isPadOr2in1PcType()) {
      this.deviceType = SlDeviceType.PAD;
      return;
    }
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      this.deviceType = SlDeviceType.FOLD_LARGE;
    }
  }
}

// 单例
export let slComStateMgr: SlCommonStateManager = SingletonHelper.getInstance(SlCommonStateManager, TAG);