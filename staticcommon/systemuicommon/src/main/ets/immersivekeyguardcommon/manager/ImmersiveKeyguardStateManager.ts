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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { DeviceHelper, sSettingsUtil, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import type { OnStateChangeListener } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import { StateListenerRegister } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import type { FingerprintState, ImmersiveState, ImmersiveTypeScene } from '../common/ImmersiveKeyguardState';
import { ImmersiveKeyguardState, ImmersiveType } from '../common/ImmersiveKeyguardState';
import { OneMirrorState } from '../base/anim/OneMirrorState';
import { SlNtfStyleChangeEvent } from '../../datasharemanager/SysUIDataShareEvent';
import { DefaultImmersiveUtils } from '../utils/DefaultImmersiveUtils';
import { slGreetUtils } from '../../utils/SlGreetUtils';

const TAG = 'ImmersiveKeyguardStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ImmersiveKeyguardStateManager {
  /**
   * 沉浸式锁屏状态
   */
  private immersiveKeyguardState: ImmersiveKeyguardState = new ImmersiveKeyguardState();

  /**
   * 状态监听器
   */
  private stateListeners: StateListenerRegister = new StateListenerRegister();

  /**
   * 通知一镜到底状态
   */
  private oneMirrorState: OneMirrorState = new OneMirrorState();

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 小外屏是否默认进沉浸态，默认开启
   */
  private isOuterDefaultImm: boolean = true;

  /**
   * 用户通过设置选择锁屏通知默认显示为列表态
   */
  private isDefaultShowList: boolean = this.isUserSetDefaultList();

  /**
   * 用户设置默认显示列表时为true，默认显示为胶囊时为false
   */
  private onSlNtfStyleChangeEvent = (event: SlNtfStyleChangeEvent): void => {
    if (event && event.shareValue !== this.isDefaultShowList) {
      this.isDefaultShowList = event.shareValue;
      log.showInfo(`set default show list: ${this.isDefaultShowList}`);
      this.setDefaultImmersiveType();
    }
  };

  constructor() {
    this.eventMgr.on(SlNtfStyleChangeEvent, this.onSlNtfStyleChangeEvent);
  }

  /**
   * 一镜到底动效状态管理
   *
   * @returns 动效状态
   */
  public getOneMirrorState(): OneMirrorState {
    return this.oneMirrorState;
  }

  /**
   * 是否开启默认进沉浸态
   */
  public getDefaultImmersiveSwitch(isForceOuterHomeFold: boolean = false): boolean {
    // 通知开关和屏幕开关有一个未打开直接就说开关关闭
    if (!DefaultImmersiveUtils.isEnableDefaultImmersive()) {
      return false;
    }
    // 检测默认屏幕开关是否打开
    return DefaultImmersiveUtils.isEnableDefaultScreen();
  }

  /**
   * 赋值小外屏默认进沉浸态状态
   *
   * @param isDefaultImm true默认进沉浸态
   */
  public setOuterDefaultImmState(isDefaultImm: boolean): void {
    if (this.isOuterDefaultImm !== isDefaultImm) {
      this.isOuterDefaultImm = isDefaultImm;
      log.showInfo(`setOuterDefaultImmState ${isDefaultImm}`);
    }
  }

  /**
   * 注册状态监听
   *
   * @param type 状态类型, 当前可注册TYPE_FINGERPRINT, TYPE_IMMERSIVE_KEYGUARD_TYPE
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
   * 获取沉浸锁屏状态
   *
   * @returns 沉浸锁屏状态
   */
  public getImmersiveKeyguardState(): ImmersiveKeyguardState {
    return this.immersiveKeyguardState;
  }

  /**
   * 获取沉浸显示状态
   *
   * @returns 沉浸显示状态
   */
  public getImmersiveDisplayState(): ImmersiveState {
    return this.immersiveKeyguardState.immersiveState;
  }

  /**
   * 获取沉浸前状态
   *
   * @returns 沉浸前显示状态
   */
  public getBeforeImmersiveState(): ImmersiveState {
    return this.immersiveKeyguardState.beforeImmersiveState;
  }

  /**
   * 是否进出沉浸态场景
   */
  public isEnterOrExitImmersive(): boolean {
    return this.immersiveKeyguardState.beforeImmersiveState.isImmersive() ||
      this.immersiveKeyguardState.immersiveState.isImmersive();
  }

  /**
   * 设置沉浸前状态
   *
   * @returns 沉浸前显示状态
   */
  public setBeforeImmersiveState(type: ImmersiveType): void {
    this.immersiveKeyguardState.beforeImmersiveState.immersiveType = type;
  }

  /**
   * 退出沉浸态
   */
  public exitImmersiveState(isAnim: boolean = false, isBackToCapsule: boolean = false): void {
    if (this.getImmersiveDisplayState().isImmersive()) {
      if (isAnim) {
        log.showInfo(`setImmersiveType type:${ImmersiveType.TYPE_CAPSULE} isAnim`);
        this.immersiveKeyguardState.immersiveState.immersiveType = ImmersiveType.TYPE_CAPSULE;
        this.setBeforeImmersiveState(ImmersiveType.TYPE_IMMERSIVE);
      } else {
        let type = isBackToCapsule ? ImmersiveType.TYPE_CAPSULE : this.getBeforeImmersiveState()?.immersiveType;
        this.setImmersiveType(type);
      }
    }
  }

  /**
   * 通知状态改变
   */
  public notifyStateChange(): void {
    log.showInfo(`immersiveState change ${this.immersiveKeyguardState.immersiveState.getStateType()}`);
    this.stateListeners.notifyStateChange(this.immersiveKeyguardState.immersiveState);
  }

  /**
   * 获取指纹状态
   *
   * @returns 指纹状态
   */
  public getFingerprintState(): FingerprintState {
    return this.immersiveKeyguardState.fingerprintState;
  }

  /**
   * 设置沉浸类型
   *
   * @param type 沉浸类型
   * @param isForceSendEvent 是否强制发送事件
   * @param scene 切换场景
   * @returns 设置是否成功切换
   */
  public setImmersiveType(type: ImmersiveType, isForceSendEvent: boolean = false, scene?: ImmersiveTypeScene): boolean {
    log.showInfo(`setImmersiveType type:${type}`);
    let isTypeChange = type !== this.immersiveKeyguardState.immersiveState.immersiveType;
    if (isTypeChange) {
      // 进入沉浸态，缓存进入沉浸态前的状态
      this.setBeforeImmersiveState(this.immersiveKeyguardState.immersiveState.immersiveType);
      this.immersiveKeyguardState.immersiveState.immersiveType = type;
      this.immersiveKeyguardState.immersiveState.changeScene = scene;
      // 进入沉浸态时，标识默认沉浸态
      if (type === ImmersiveType.TYPE_IMMERSIVE) {
        this.setOuterDefaultImmState(true);
      }
    }

    // 初始化时始终会通知当前的状态
    if (isTypeChange || isForceSendEvent) {
      this.notifyStateChange();
    }
    return true;
  }

  /**
   * 更新低位指纹标记
   *
   * @param isLowPosition 是否是低位指纹
   * @param fingerHeight 指纹高度
   */
  public updateFpIsLowPos(isLowPosition: boolean, fingerHeight: number, fingerType: number): void {
    if (this.immersiveKeyguardState.fingerprintState.isUnderScreenLowPosition !== isLowPosition ||
      this.immersiveKeyguardState.fingerprintState.fingerHeight !== fingerHeight ||
      this.immersiveKeyguardState.fingerprintState.fingerType !== fingerType) {
      this.immersiveKeyguardState.fingerprintState.isUnderScreenLowPosition = isLowPosition;
      this.immersiveKeyguardState.fingerprintState.fingerHeight = fingerHeight;
      this.immersiveKeyguardState.fingerprintState.fingerType = fingerType;
      this.notifyStateChangeByFingerprint();
      this.setImmersiveType(this.getDefaultImmersiveType());
    }
  }

  /**
   * 更新指纹功能是否开启状态
   *
   * @param isEnable 指纹功能是否开启状态
   */
  public updateFingerprintEnable(isEnable: boolean): void {
    if (this.immersiveKeyguardState.fingerprintState.isEnable !== isEnable) {
      this.immersiveKeyguardState.fingerprintState.isEnable = isEnable;
      this.notifyStateChangeByFingerprint();
      this.setImmersiveType(this.getDefaultImmersiveType());
    }
  }

  /**
   * 设置默认的沉浸类型
   */
  public setDefaultImmersiveType(isForceEvent: boolean = true): void {
    this.setImmersiveType(this.getDefaultImmersiveType(), isForceEvent);
  }

  /**
   * 指纹状态改变
   */
  private notifyStateChangeByFingerprint(): void {
    log.showInfo(`fingerprintState change ${this.immersiveKeyguardState.fingerprintState.getStateType()}`);
    this.stateListeners.notifyStateChange(this.immersiveKeyguardState.fingerprintState);
  }

  /**
   * 获取用户设置的默认通知显示类型
   *
   * @returns 用户设置默认显示列表时为true，默认显示为胶囊时为false
   */
  private isUserSetDefaultList(): boolean {
    let userConfig = sSettingsUtil.getSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE);
    return userConfig === 'true';
  }

  /**
   * 获取默认的沉浸类型
   *
   * @returns 返回默认的沉浸类型
   */
  public getDefaultImmersiveType(): ImmersiveType {
    if ((this.immersiveKeyguardState.fingerprintState.isLowPosRecognition() || this.isDefaultShowList) &&
      !slGreetUtils.slGreetViewIsShow) {
      return ImmersiveType.TYPE_LIST;
    }
    return ImmersiveType.TYPE_CAPSULE;
  }
}

export let immersiveKgMgr: ImmersiveKeyguardStateManager =
  SingletonHelper.getInstance(ImmersiveKeyguardStateManager, TAG);