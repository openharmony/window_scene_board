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
import { RotationConstants } from '@ohos/commonconstants';

/**
 * 状态类型
 */
export enum StateType {
  /**
   * 深色模式类型
   */
  TYPE_DARK_MODE,

  /**
   * 沉浸式类型
   */
  TYPE_IMMERSIVE,

  /**
   * 屏幕旋转类型
   */
  TYPE_DISPLAY_ROTATION,

  /**
   * 屏幕宽高类型
   */
  TYPE_DISPLAY_SIZE,

  /**
   * banner面板类型
   */
  TYPE_BANNER_PANEL_TYPE,

  /**
   * banner面板样式属性
   */
  TYPE_BANNER_STYLE,

  /**
   * banner面板外部触摸状态
   */
  TYPE_BANNER_OUTSIDE,

  /**
   * 系统弹框面板显示类型
   */
  TYPE_SYS_DIALOG_PANEL_TYPE,

  /**
   * 锁屏指纹类型
   */
  TYPE_FINGERPRINT,

  /**
   * 沉浸锁屏类型
   */
  TYPE_IMMERSIVE_KEYGUARD_TYPE
}

/**
 * 抽象状态
 */
export interface IState {
  /**
   * 获取该状态类型
   *
   * @returns 状态类型
   */
  getStateType(): StateType;

  /**
   * 获取扩展类型
   *
   * @returns 扩展类型
   */
  getExtendType?(): number;
}

/**
 * 深色模式状态
 */
@Observed
export class DarkModeState implements IState {
  /**
   * 当前是否深色模式
   */
  isDarkMode: boolean = false;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_DARK_MODE;
  }
}

/**
 * 沉浸式状态
 */
@Observed
export class ImmersiveBaseState implements IState {
  /**
   * 当前是否沉浸式（横屏退出多任务进入沉浸式，会先变成false再变成true）
   */
  isImmersive: boolean = false;

  /**
   * 当前是否是沉浸式
   */
  isInImmersive: boolean = false;

  /**
   * 沉浸式下拉 短暂打破沉浸式
   */
  isBreak: boolean = false;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_IMMERSIVE;
  }
}

/**
 * 屏幕旋转状态
 */
@Observed
export class DisplayRotationState implements IState {
  /**
   * 当前屏幕旋转角度
   */
  rotateAngle: number = RotationConstants.ROTATION_0;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_DISPLAY_ROTATION;
  }

  /**
   * 当前是否横屏
   *
   * @returns true横屏
   */
  isLandscape(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_90 ||
      this.rotateAngle === RotationConstants.ROTATION_270;
  }

  /**
   * 当前是否正向竖屏
   *
   * @returns true正向竖屏
   */
  isPortraitPositive(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_0 ||
      this.rotateAngle === RotationConstants.ROTATION_360;
  }

  /**
   * 当前是否反向竖屏
   *
   * @returns true反向竖屏
   */
  isPortraitNegative(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_180;
  }
}

/**
 * 屏幕宽高状态
 */
@Observed
export class DisplaySizeState implements IState {
  /**
   * 宽屏判断最小阈值，vp
   * 达到阈值，布局按宽屏布局处理
   */
  private static readonly WIDTH_THRESHOLD_SMALL = 600;

  /**
   * 屏幕宽度，px
   */
  displayWidth: number = 0;

  /**
   * 屏幕高度，px
   */
  displayHeight: number = 0;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_DISPLAY_SIZE;
  }

  /**
   * 当前是否为宽屏
   *
   * @returns true 宽屏
   */
  isWidestScreen(): boolean {
    return px2vp(this.displayWidth) > DisplaySizeState.WIDTH_THRESHOLD_SMALL;
  }

  public isWidestScreenByVp(displayWidthByVp: number): boolean {
    return displayWidthByVp > DisplaySizeState.WIDTH_THRESHOLD_SMALL;
  }
}