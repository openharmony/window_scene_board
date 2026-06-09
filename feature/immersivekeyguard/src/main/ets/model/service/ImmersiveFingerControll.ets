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

import {
  ImmersiveType,
  ImmersiveState,
  FingerprintState,
  ImmersiveKeyguardState,
  slGreetUtils
} from '@ohos/systemuicommon';
import {
  ArrayUtils,
  CommonUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { ImmersiveConstants } from '@ohos/systemuicommon';
import {
  immersiveKgMgr
} from '@ohos/systemuicommon';
import { IState, StateType } from '@ohos/systemuicommon';
import {
  FingerprintType
} from '@ohos/screenlockcommon';
import { ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';

const TAG = 'ImmersiveFingerControll';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 指纹隐藏扩展场景
 */
export enum FingerExtendScene {
  /**
   * 默认场景
   */
  SCENE_DEFAULT = 'scene_hide_default',
  GREET_SCENE = 'greet_scene_hide',
}

/**
 * 指纹隐藏场景，包含动效场景
 */
export type FingerHideScene = FingerExtendScene | ImmersiveAnimScene;

/**
 * 沉浸锁屏指纹状态变化监听
 */
export interface ImmersiveFingerListener {
  /**
   * 沉浸锁屏指纹状态变化回调
   *
   * @param isShowFinger 是否显示指纹
   */
  onNtfDataUpdate: (isShowFinger: boolean) => void;
}

/**
 * 沉浸锁屏指纹管理
 */
class ImmersiveFingerController {
  /**
   * 监听沉浸锁屏指纹状态回调集
   */
  private immersiveFingerListeners: Set<ImmersiveFingerListener> = new Set();

  /**
   * 指纹隐藏场景
   */
  private fingerHideScene: Set<FingerHideScene> = new Set();

  /**
   * 是否显示指纹
   */
  private isFingerShow: boolean = false;

  /**
   * 是否低指纹显示
   */
  private isLowPosFingerShow: boolean = false;

  /**
   * 是否开启指纹识别
   */
  private isRecognition: boolean = false;

  /**
   * 指纹高度
   */
  private fingerHeight: number = 0;

  /**
   * 当前沉浸锁屏状态
   */
  private immersiveType: ImmersiveType = ImmersiveType.TYPE_CAPSULE;

  /**
   * 指纹类型
   */
  private fingerType: FingerprintType = FingerprintType.NONE;

  /**
   * 是否存在隐藏指纹场景
   */
  private isHideFingerScene: boolean = false;

  /**
   * 注册监听
   *
   * @param listener 监听回调
   */
  registerImmersiveFingerListener(listener: ImmersiveFingerListener): void {
    if (CommonUtils.isInvalid(listener)) {
      log.showError('listener is invalid.');
      return;
    }
    this.immersiveFingerListeners.add(listener);
  }

  /**
   * 注销监听
   *
   * @param listener 监听回调
   */
  unregisterImmersiveFingerListener(listener: ImmersiveFingerListener) {
    if (CommonUtils.isInvalid(listener)) {
      log.showError('listener is invalid.');
      return;
    }
    this.immersiveFingerListeners.delete(listener);
  }

  /**
   * 状态变化
   */
  private onFingerStateChange() {
    this.immersiveFingerListeners.forEach((listener) => {
      log.showInfo(`onFingerStateChange ${this.isFingerShow && !this.isHideFingerScene}`);
      listener.onNtfDataUpdate(this.isFingerShow && !this.isHideFingerScene);
    });
  }

  /**
   * 注册监听沉浸状态变化
   */
  init(): void {
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this);
    // 获取高低指纹位置
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_FINGERPRINT, this);
    let state: ImmersiveKeyguardState = immersiveKgMgr.getImmersiveKeyguardState();
    this.isRecognition = state.fingerprintState.isEnable;
  }

  /**
   * 注销监听
   */
  destroy(): void {
    immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this);
    immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_FINGERPRINT, this);
  }

  /**
   * 状态切换回调
   *
   * @param state 新的指纹或沉浸锁屏状态
   */
  onStateChange(state: IState): void {
    if (state.getStateType() === StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE) {
      let immersiveState = state as ImmersiveState;
      this.immersiveType = immersiveState.immersiveType;
    } else if (state.getStateType() === StateType.TYPE_FINGERPRINT) {
      let immersiveState = state as FingerprintState;
      this.isRecognition = immersiveState.isEnable;
      this.isLowPosFingerShow = immersiveState.isUnderScreenLowPosition;
      this.fingerHeight = immersiveState.fingerHeight;
      this.fingerType = immersiveState.fingerType;
    }
    this.updateFingerState();
  }

  /**
   * 更新指纹显示状态
   */
  private updateFingerState(): void {
    if (!this.isRecognition || this.immersiveType === ImmersiveType.TYPE_IMMERSIVE ||
      this.fingerType === FingerprintType.OUT_OF_SCREEN_SENSOR) {
      // 指纹未开启或沉浸卡片态
      this.isFingerShow = false;
      this.onFingerStateChange();
      // 设置通知面板高度为默认值
    } else if (this.immersiveType === ImmersiveType.TYPE_LIST || this.immersiveType === ImmersiveType.TYPE_CAPSULE) {
      // 列表态或者胶囊态允许显示指纹
      this.isFingerShow = true;
      this.onFingerStateChange();
    }
  }

  /**
   * 当前指纹是否显示
   */
  isFingerPrint(): boolean {
    return this.isFingerShow && this.isRecognition;
  }

  /**
   * 当前是否低指纹显示
   */
  isLowPosFingerPrint(): boolean {
    return this.isLowPosFingerShow && this.isRecognition;
  }

  /**
   * 添加指纹隐藏场景
   *
   * @param scene 场景
   */
  addFingerHideScene(scene?: FingerHideScene): void {
    this.fingerHideScene.add(scene ?? FingerExtendScene.SCENE_DEFAULT);
    this.checkHideFingerSceneChange();
  }

  /**
   * 移除指纹隐藏场景
   *
   * @param scene 场景
   */
  removeFingerHideScene(scene?: FingerHideScene): void {
    this.fingerHideScene.delete(scene ?? FingerExtendScene.SCENE_DEFAULT);
    this.checkHideFingerSceneChange();
  }

  /**
   * 检测指纹隐藏状态切换
   */
  private checkHideFingerSceneChange(): void {
    let isForceHide = this.isForceHideFinger();
    if (this.isHideFingerScene !== isForceHide) {
      this.isHideFingerScene = isForceHide;
      this.onFingerStateChange();
    }
  }

  /**
   * 是否强制隐藏指纹
   *
   * @returns true强制隐藏
   */
  private isForceHideFinger(): boolean {
    return !ArrayUtils.isEmpty(this.fingerHideScene);
  }
}

// 单例
export let immersiveFgCtrl: ImmersiveFingerController =
  SingletonHelper.getInstance(ImmersiveFingerController, TAG);