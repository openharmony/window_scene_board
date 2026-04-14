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
import { SingletonHelper, CommonUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { ConfigurationEvent, EvtBus } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBPropertyChangeReason, SCBScreenSessionManager } from '@ohos/windowscene';
import type { EventManager } from '@ohos/frameworkwrapper';
import type { SCBSystemBarProperty } from '@ohos/windowscene';
import type { SCBScreenProperty } from '@ohos/windowscene';

import { DarkModeEvent } from './CommonEvent';
import {
  DarkModeState,
  DisplayRotationState,
  DisplaySizeState,
  ImmersiveBaseState,
  StateType
} from './BaseState';
import type { IState } from './BaseState';
import type { OnStateChangeListener } from './StateListenerRegister';
import { StateListenerRegister } from './StateListenerRegister';
import { ConfigurationConstant } from '@kit.AbilityKit';

const TAG = 'BaseStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 基础状态管理
 */
class BaseStateManager {
  /**
   * 基础状态
   */
  private baseStates: Map<StateType, IState> = new Map([
    // 深色模式
    [StateType.TYPE_DARK_MODE, new DarkModeState() as IState],
    // 沉浸式
    [StateType.TYPE_IMMERSIVE, new ImmersiveBaseState()],
    // 屏幕旋转角度
    [StateType.TYPE_DISPLAY_ROTATION, new DisplayRotationState()],
    // 屏幕宽高大小
    [StateType.TYPE_DISPLAY_SIZE, new DisplaySizeState()]
  ]);

  /**
   * 状态监听集
   */
  private stateListeners: StateListenerRegister = new StateListenerRegister();

  /**
   * 事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 是否已初始化成功
   */
  private isInitSuccess: boolean = false;

  /**
   * 屏幕状态切换监听
   */
  private onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
    if (CommonUtils.isInvalid(screenProperty)) {
      return;
    }

    // 检测屏幕旋转角度切换
    this.onDisplayRotationChange(screenProperty?.rotation);

    // 检测屏幕宽高大小切换
    this.onDisplaySizeChange(screenProperty?.width, screenProperty.height);
  };

  /**
   * 状态栏沉浸式状态监听
   */
  private onSystemBarProperty = (property: SCBSystemBarProperty): void => {
    this.updateImmersiveState(!property.enable);
    let immersiveState = this.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;
    immersiveState.isInImmersive = immersiveState.isImmersive;
  };

  /**
   * 多任务状态监听
   */
  private systemBarPropertyRecentCallback = (property: boolean): void => {
    this.updateImmersiveState(property);
  };

  private updateImmersiveState(state: boolean): void {
    let immersiveState = this.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;
    let isCurrentImmersive = state;
    if (immersiveState.isImmersive === isCurrentImmersive) {
      return;
    }
    immersiveState.isImmersive = isCurrentImmersive;
    log.showInfo(`onImmersiveChange, isImmersive = ${immersiveState.isImmersive},` +
      ` isInImmersive = ${immersiveState.isInImmersive}`);
    // 回调监听
    this.notifyStateChange(StateType.TYPE_IMMERSIVE);
  }

  /**
   * 沉浸式状态下拉状态短暂打破沉浸式状态
   *
   * @param state 是否下拉状态栏
   */
  updateImmersiveStateBreak(state: boolean): void {
    let immersiveState = this.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;
    if (immersiveState.isBreak !== state) {
      immersiveState.isBreak = state;
    }
    // 在沉浸态下下拉TopBar，短暂打破沉浸态也要通知refreshStyle
    this.notifyStateChange(immersiveState.getStateType());
  }

  /**
   * 初始化
   */
  init(): void {
    // 初始化已完成
    if (this.isInitSuccess) {
      return;
    }

    // 深色模式切换事件
    this.eventMgr.on(ConfigurationEvent, this.onDarkModeEvent.bind(this));

    // 注册状态栏沉浸式状态切换监听
    SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks(this.onSystemBarProperty);
    // 监听进入多任务事件
    SCBSceneSessionManager.getInstance().registerSystemBarPropertyRecentCallbacks(this.systemBarPropertyRecentCallback);

    // 注册屏幕状态切换监听
    let mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (!CommonUtils.isInvalid(mainScreenSession)) {
      this.onScreenPropertyChange(mainScreenSession?.scbScreenProperty, SCBPropertyChangeReason.ROTATION);
      SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange);
      SCBScreenSessionManager.getInstance().registerRotationAnimationCallbacks(this.onScreenPropertyChange);
      this.isInitSuccess = true;
    }
  }

  /**
   * 获取对应基础状态
   *
   * @param type 状态类型
   * @returns 基础状态
   */
  getBaseState(type: StateType): IState | undefined {
    return this.baseStates.get(type);
  }

  /**
   * 当前是否深色模式
   *
   * @returns true深色模式
   */
  isDarkMode(): boolean {
    let darkState = this.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
    return darkState.isDarkMode;
  }

  /**
   * 当前是否沉浸式模式
   *
   * @returns true沉浸式
   */
  isImmersive(): boolean {
    let immersiveState = this.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;
    return immersiveState.isImmersive;
  }

  /**
   * 当前是否横屏
   *
   * @returns true横屏
   */
  isLandscape(): boolean {
    let rotationState = this.getBaseState(StateType.TYPE_DISPLAY_ROTATION) as DisplayRotationState;
    return rotationState.isLandscape();
  }

  /**
   * 当前是否正向竖屏
   *
   * @returns true横屏
   */
  isPortraitPositive(): boolean {
    let rotationState = this.getBaseState(StateType.TYPE_DISPLAY_ROTATION) as DisplayRotationState;
    return rotationState.isPortraitPositive();
  }

  /**
   * 当前是否反向竖屏
   *
   * @returns true横屏
   */
  isPortraitNegative(): boolean {
    let rotationState = this.getBaseState(StateType.TYPE_DISPLAY_ROTATION) as DisplayRotationState;
    return rotationState.isPortraitNegative();
  }

  /**
   * 当前是否宽屏场景
   *
   * @returns true宽屏
   */
  isWidestScreen(): boolean {
    let sizeState = this.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
    return sizeState.isWidestScreen();
  }

  /**
   * 注册状态监听
   *
   * @param type 状态类型
   * @param listener 监听器
   * @returns 快速注销监听
   */
  registerStateChangeListener(type: StateType, listener: OnStateChangeListener): () => void {
    return this.stateListeners.registerStateChangeListener(type, listener);
  }

  /**
   * 注销状态监听
   *
   * @param type 状态类型
   * @param listener 监听器
   */
  unregisterStateChangeListener(type: StateType, listener: OnStateChangeListener): void {
    this.stateListeners.unregisterStateChangeListener(type, listener);
  }

  /**
   * 通知状态变化
   *
   * @param type 状态类型
   */
  private notifyStateChange(type: StateType): void {
    this.stateListeners.notifyStateChange(this.getBaseState(type));
  }

  /**
   * 深色模式切换事件回调
   *
   * @param event 事件
   */
  private onDarkModeEvent(event?: ConfigurationEvent): void {
    if (!event) {
      log.showInfo('ConfigurationEvent undefined or null');
      return;
    }

    const darkMode: ConfigurationConstant.ColorMode = event.config?.colorMode ??
    ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
    if (darkMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
      log.showInfo('ConfigurationEvent colorMode not set.');
      return;
    }
    const isDarkMode = darkMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;

    let darkModeState = this.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
    if (darkModeState?.isDarkMode === isDarkMode) {
      return;
    }
    log.showInfo('onDarkModeChange: ' + isDarkMode);
    darkModeState.isDarkMode = isDarkMode;

    // 回调监听
    this.notifyStateChange(StateType.TYPE_DARK_MODE);
  }

  /**
   * 屏幕旋转角度切换回调
   *
   * @param rotation 当前角度
   */
  private onDisplayRotationChange(rotation: number): void {
    let rotationState = this.getBaseState(StateType.TYPE_DISPLAY_ROTATION) as DisplayRotationState;
    if (rotationState.rotateAngle === rotation) {
      return;
    }
    log.showInfo('onDisplayRotationChange: ' + rotation);
    rotationState.rotateAngle = rotation;

    // 回调监听
    this.notifyStateChange(StateType.TYPE_DISPLAY_ROTATION);
  }

  /**
   * 屏幕宽高大小切换回调
   *
   * @param width 当前宽度
   * @param height 当前高度
   */
  private onDisplaySizeChange(width: number, height: number): void {
    let sizeState = this.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
    if (sizeState.displayWidth === width && sizeState.displayHeight === height) {
      return;
    }
    log.showInfo('onDisplaySizeChange: ' + width + ', ' + height);
    sizeState.displayWidth = width;
    sizeState.displayHeight = height;

    // 回调监听
    this.notifyStateChange(StateType.TYPE_DISPLAY_SIZE);
  }
}

// 单例
export let baseStateMgr: BaseStateManager = SingletonHelper.getInstance(BaseStateManager, TAG);