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

import {
  CommonUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { SlMainStateType, SlStaticStateType,
  SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  DisplayUtils,
  KeyguardStatusService,
  ScreenBp,
  SizeBpSplice
} from '@ohos/screenlockcommon';
import { baseStateMgr, DisplaySizeState,
  IImmersiveData,
  ImmersiveConstants,
  immersiveKgMgr,
  ImmersiveTypeScene,
  OnStateChangeListener
} from '@ohos/systemuicommon';
import {
  ImmersiveType
} from '@ohos/systemuicommon';
import { IState, StateType } from '@ohos/systemuicommon';
import { immersiveMultiDeviceHelper } from '../helper/ImmersiveMultiDeviceHelper';

const TAG = 'ImmersiveStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸状态接口
 */
export interface IImmersiveState {
  /**
   * 标记当前状态类型
   *
   * @returns 状态类型
   */
  getImmersiveStateType(): ImmersiveType;
}

/**
 * 沉浸卡片状态
 */
export class ImmersiveCardState implements IImmersiveState {
  /**
   * 当前沉浸卡片
   */
  curImmersiveCard?: IImmersiveData;

  /**
   * 是否设置动效卡片，默认为旧卡片数据
   */
  isSetAnimCard?: boolean;

  /**
   * 复写IImmersiveState
   *
   * @returns 沉浸卡片状态
   */
  getImmersiveStateType(): ImmersiveType {
    return ImmersiveType.TYPE_IMMERSIVE;
  }
}

/**
 * 锁屏胶囊态
 */
export class KeyGuardCapsuleState implements IImmersiveState {
  /**
   * 复写IImmersiveState
   *
   * @returns 锁屏胶囊态
   */
  getImmersiveStateType(): ImmersiveType {
    return ImmersiveType.TYPE_CAPSULE;
  }
}

/**
 * 锁屏通知列表态
 */
export class KeyGuardListState implements IImmersiveState {
  /**
   * 复写IImmersiveState
   *
   * @returns 锁屏通知列表态
   */
  getImmersiveStateType(): ImmersiveType {
    return ImmersiveType.TYPE_LIST;
  }
}

/**
 * 沉浸锁屏胶囊宽度状态
 */
export class ImmersiveWidthState implements IImmersiveState {
  /**
   * 胶囊显示的宽度，px
   */
  capsuleWidth: number = 0;

  /**
   * 胶囊辅助区组件数量
   */
  capsuleBtnCount: number = 1;

  /**
   * 卡片显示的宽度，vp
   */
  cardWidth: number = 0;

  /**
   * 卡片显示的高度，vp
   */
  cardHeight: number = 0;

  /**
   * 复写IImmersiveState
   *
   * @returns 胶囊宽度状态
   */
  getImmersiveStateType(): ImmersiveType {
    return ImmersiveType.TYPE_WIDTH_DISPLAY_STATE;
  }
}


/**
 * 沉浸状态变化监听器
 */
export type OnImmersiveStateChangeListener = (state?: IImmersiveState) => void;

/**
 * 沉浸状态统一管理
 */
class ImmersiveStateManager {
  /**
   * 记录开机后是否进行了首次解锁
   */
  private isUnlocked: boolean = false;

  /**
   * 沉浸状态集
   */
  private immersiveStates: Map<ImmersiveType, IImmersiveState> = new Map([
    [ImmersiveType.TYPE_IMMERSIVE, new ImmersiveCardState()],
    [ImmersiveType.TYPE_CAPSULE, new KeyGuardCapsuleState()],
    [ImmersiveType.TYPE_LIST, new KeyGuardListState()],
    [ImmersiveType.TYPE_WIDTH_DISPLAY_STATE, new ImmersiveWidthState()],
  ]);

  /**
   * 锁屏静态状态监听
   */
  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SCREEN_BP) {
        this.updateCapsuleWidthState();
        this.updateCardWidthState();
        this.notifyImmersiveStateChange(ImmersiveType.TYPE_WIDTH_DISPLAY_STATE);
      }
    }
  };

  /**
   * 状态监听器集
   */
  private immersiveStateListeners: Set<OnImmersiveStateChangeListener> = new Set();

  constructor() {
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onImmersiveChange);
    baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onImmersiveChange);
    // 根据屏幕宽高初始化胶囊宽度
    this.updateCapsuleWidthState();
    this.updateCardWidthState();
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
  }

  /**
   * 外部状态切换回调
   *
   * @param state 状态
   */
  private onImmersiveChange: OnStateChangeListener = {
    /**
     * 沉浸锁屏状态变化回调
     */
    onStateChange: (state: IState): void => {
      let stateType = state.getStateType();
      switch (stateType) {
        case StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE:
          this.onImmersiveStateChange();
          break;
        case StateType.TYPE_DISPLAY_SIZE:
          this.onDisplaySizeChange();
          break;
        default:
          break;
      }
    }
  };

  /**
   * 注册状态监听器
   *
   * @param listener 监听器
   * @returns 快速注销
   */
  registerOnImmersiveStateChangeListener(listener: OnImmersiveStateChangeListener): () => void {
    if (CommonUtils.isInvalid(listener)) {
      return () => {};
    }
    this.immersiveStateListeners.add(listener);
    return () => this.unregisterOnImmersiveStateChangeListener(listener);
  }

  /**
   * 注销状态监听器
   *
   * @param listener 监听器
   */
  unregisterOnImmersiveStateChangeListener(listener: OnImmersiveStateChangeListener): void {
    this.immersiveStateListeners.delete(listener);
  }

  /**
   * 获取当前状态
   *
   * @param stateType 状态类型
   * @returns 当前状态
   */
  getCurrentState(stateType: ImmersiveType): IImmersiveState | undefined {
    return this.immersiveStates.get(stateType);
  }

  /**
   * immersive模块统一通过该方改变沉浸式状态,便于对状态改变作统一业务处理
   *
   * @param type 沉浸类型
   * @param isForceSendEvent 是否强制发送事件
   * @param scene 切换场景
   */
  switchImmersiveState(nextType: ImmersiveType, isForceSendEvent: boolean = false, scene?: ImmersiveTypeScene): void {
    // 低位指纹不能切换到胶囊态
    if (nextType === ImmersiveType.TYPE_CAPSULE &&
    immersiveKgMgr.getImmersiveKeyguardState().fingerprintState.isLowPosRecognition() &&
      !KeyguardStatusService.isSlGreetMode()) {
      log.showWarn(`cannot switched to the capsule state in low fingerprint scene`);
      return;
    }
    let currentType = immersiveKgMgr.getImmersiveDisplayState().immersiveType;
    this.handleImmersiveStateChange(currentType, nextType);
    immersiveKgMgr.setImmersiveType(nextType, isForceSendEvent, scene);
  }

  exitImmersiveState(isAnim: boolean = false, isBackToCapsule: boolean = false): void {
    let immeCardState = (this.getCurrentState(ImmersiveType.TYPE_IMMERSIVE) as ImmersiveCardState);
    immeCardState?.curImmersiveCard?.setShowInCard(false);
    immersiveKgMgr.exitImmersiveState(isAnim, isBackToCapsule);
  }

  private handleImmersiveStateChange(current: ImmersiveType, next: ImmersiveType): void {
    let immeCardState = (this.getCurrentState(ImmersiveType.TYPE_IMMERSIVE) as ImmersiveCardState);
    if (current !== ImmersiveType.TYPE_IMMERSIVE && next === ImmersiveType.TYPE_IMMERSIVE) {
      immeCardState?.curImmersiveCard?.setShowInCard(true);
    }
    if (current === ImmersiveType.TYPE_IMMERSIVE && next !== ImmersiveType.TYPE_IMMERSIVE) {
      immeCardState?.curImmersiveCard?.setShowInCard(false);
    }
  }

  /**
   * 请求切换沉浸卡片
   *
   * @param card 新卡片数据
   */
  requestImmersiveCard(card?: IImmersiveData, isSetAnimCard?: boolean): void {
    let cardState = this.getCurrentState(ImmersiveType.TYPE_IMMERSIVE) as ImmersiveCardState;
    cardState.curImmersiveCard?.setShowInCard(false);
    card?.setShowInCard(true);
    cardState.curImmersiveCard = card;
    cardState.isSetAnimCard = isSetAnimCard;
    if (immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      this.notifyImmersiveStateChange(ImmersiveType.TYPE_IMMERSIVE);
    }
  }

  /**
   * 通知状态切换回调
   *
   * @param type 状态类型
   */
  private notifyImmersiveStateChange(type: ImmersiveType): void {
    this.immersiveStateListeners?.forEach((listener) => {
      listener?.(this.getCurrentState(type));
    });
  }

  /**
   * 沉浸态状态切换回调
   */
  private onImmersiveStateChange(): void {
    let currentState = immersiveKgMgr.getImmersiveDisplayState().immersiveType;
    if (CommonUtils.isInvalid(currentState)) {
      return;
    }
    this.notifyImmersiveStateChange(currentState);
  }

  /**
   * 屏幕宽高发生变化的回调
   */
  private onDisplaySizeChange(): void {
    this.updateCapsuleWidthState();
    this.updateCardWidthState();
    this.notifyImmersiveStateChange(ImmersiveType.TYPE_WIDTH_DISPLAY_STATE);
  }

  /**
   * 更新屏幕宽度信息
   */
  private updateCapsuleWidthState(): void {
    let immersiveDisplaySizeState = this.getCurrentState(ImmersiveType.TYPE_WIDTH_DISPLAY_STATE) as ImmersiveWidthState;
    if (!immersiveDisplaySizeState) {
      log.showWarn('immersiveDisplaySizeState is undefined, return');
      return;
    }
    let curDisplaySizeState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
    let displayWidth = curDisplaySizeState?.displayWidth ?? 0;
    let slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    let screenBreakPoint = slStaticState?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    if (screenBreakPoint?.bpSplice === SizeBpSplice.MS || screenBreakPoint?.bpSplice === SizeBpSplice.SL) {
      displayWidth = Math.min(curDisplaySizeState?.displayWidth ?? 0, curDisplaySizeState?.displayHeight ?? 0);
    }
    const capsuleBtnCount: number = immersiveMultiDeviceHelper.getCapsuleBtnCount();
    let capsuleWidthDisplay = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(displayWidth);
    if (immersiveDisplaySizeState.capsuleWidth !== capsuleWidthDisplay ||
      immersiveDisplaySizeState.capsuleBtnCount !== capsuleBtnCount) {
      log.showWarn(`CapsuleWidthDisplay is ${capsuleWidthDisplay} and displayWidth is ${displayWidth}, ` +
        `bpSplice is ${screenBreakPoint?.bpSplice}, capsuleBtnCount is ${capsuleBtnCount}`);
    }
    immersiveDisplaySizeState.capsuleBtnCount = capsuleBtnCount;
    immersiveDisplaySizeState.capsuleWidth = capsuleWidthDisplay;
  }

  /**
   * 更新卡片宽度信息
   */
  public updateCardWidthState(): void {
    let curDisplaySizeState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
    let immersiveDisplaySizeState = this.getCurrentState(ImmersiveType.TYPE_WIDTH_DISPLAY_STATE) as ImmersiveWidthState;
    if (!immersiveDisplaySizeState) {
      log.showWarn('immersiveDisplaySizeState is undefined, return');
      return;
    }
    let displayWidth = curDisplaySizeState.displayWidth;
    if (!immersiveMultiDeviceHelper.isLandscape() && DisplayUtils.isLargeScreen()) {
      displayWidth = curDisplaySizeState.displayHeight;
    }
    let cardWidthDisplay = immersiveMultiDeviceHelper.getCardWidthDisplay(displayWidth);
    if (immersiveDisplaySizeState.cardWidth !== cardWidthDisplay) {
      log.showWarn(`cardWidthDisplay is ${cardWidthDisplay} and displayWidth is ${displayWidth}`);
    }
    immersiveDisplaySizeState.cardWidth = cardWidthDisplay;
    immersiveDisplaySizeState.cardHeight = immersiveMultiDeviceHelper.getCardHeightDisplay(
      curDisplaySizeState.displayWidth, curDisplaySizeState.displayHeight);
  }

  /**
   * 设置锁屏解锁状态为已进行过开机后首次解锁
   */
  setUnlockedState(): void {
    this.isUnlocked = true;
  }

  /**
   * 获取锁屏解锁配置状态
   */
  getUnlockedState(): boolean {
    return this.isUnlocked;
  }
}

// 单例
export let immersiveStateMgr: ImmersiveStateManager = SingletonHelper.getInstance(ImmersiveStateManager, TAG);