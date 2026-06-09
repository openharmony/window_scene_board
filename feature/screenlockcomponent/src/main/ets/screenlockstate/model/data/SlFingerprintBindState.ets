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

import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  FingerprintBindStateType,
  SlMainStateType,
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';

// 锁屏指纹UI绑定状态
@Observed
export class SlFingerprintBindState extends WidgetBindState<FingerprintBindStateType> {
  public slStateChangeListener?: ISlStateChangeListener | undefined; // 复写ISlState

  /**
   * 指纹使能情况
   */
  @Track private fingerprintEnable: boolean = false;
  /**
   * 锁屏指纹在屏幕里的X坐标
   */
  @Track private fingerprintPositionX: number = 0;
  /**
   * 锁屏指纹在屏幕里的Y坐标
   */
  @Track private fingerprintPositionY: number = 0;
  /**
   * 锁屏指纹图标半径
   */
  @Track private fingerprintRadius: number = 0;
  /**
   * 锁屏指纹动画状态
   */
  @Track private fingerAnimateState: AnimationStatus = AnimationStatus.Initial;
  /**
   * 通知禁用指纹状态
   */
  @Track private isNtfDisableFingerPrint: boolean = false;
  /**
   * 指纹Icon消失动效状态
   */
  @Track private isHiddenLottiePlaying: boolean = false;

  constructor(mainType: SlMainStateType) {
    super(mainType);
  }

  protected initSetMethods(): void {
    this.setMethods.set(FingerprintBindStateType.FINGER_ENABLE_STATE,
      (st: SlFingerprintBindState, value: boolean) => st.setEnable(value));
    this.setMethods.set(FingerprintBindStateType.FINGER_POSITION_X,
      (st: SlFingerprintBindState, value: number) => st.setFingerPositionX(value));
    this.setMethods.set(FingerprintBindStateType.FINGER_POSITION_Y,
      (st: SlFingerprintBindState, value: number) => st.setFingerPositionY(value));
    this.setMethods.set(FingerprintBindStateType.FINGER_RADIUS,
      (st: SlFingerprintBindState, value: number) => st.setFingerprintRadius(value));
    this.setMethods.set(FingerprintBindStateType.FINGER_ANIMATE_STATE,
      (st: SlFingerprintBindState, value: AnimationStatus) => st.setFingerAnimateState(value));
    this.setMethods.set(FingerprintBindStateType.FINGER_NTF_DISABLE_STATE,
      (st: SlFingerprintBindState, value: boolean) => st.setNtfDisableFingerPrint(value));
    this.setMethods.set(FingerprintBindStateType.FINGER_ICON_HIDDEN_STATE,
      (st: SlFingerprintBindState, value: boolean) => st.setIconHiddenAnimationState(value));
  }

  protected notifyStateChange(subType: FingerprintBindStateType): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(this.mainType, subType);
  }

  public setEnable(enable: boolean): void {
    if (this.fingerprintEnable !== enable) {
      this.fingerprintEnable = enable;
      this.notifyStateChange(FingerprintBindStateType.FINGER_ENABLE_STATE);
    }
  }

  public getEnable(): boolean {
    return this.fingerprintEnable;
  }

  public setFingerPositionX(positionX: number): void {
    if (this.fingerprintPositionX !== positionX) {
      this.fingerprintPositionX = positionX;
      this.notifyStateChange(FingerprintBindStateType.FINGER_POSITION_X);
    }
  }

  public getFingerPositionX(): number {
    return this.fingerprintPositionX;
  }

  public setFingerPositionY(positionY: number): void {
    if (this.fingerprintPositionY !== positionY) {
      this.fingerprintPositionY = positionY;
      this.notifyStateChange(FingerprintBindStateType.FINGER_POSITION_Y);
    }
  }

  public getFingerPositionY(): number {
    return this.fingerprintPositionY;
  }

  public setFingerprintRadius(radius: number): void {
    if (this.fingerprintRadius !== radius) {
      this.fingerprintRadius = radius;
      this.notifyStateChange(FingerprintBindStateType.FINGER_RADIUS);
    }
  }

  public getFingerprintRadius(): number {
    return this.fingerprintRadius;
  }

  public setFingerAnimateState(fingerAnimateState: AnimationStatus): void {
    if (this.fingerAnimateState !== fingerAnimateState) {
      this.fingerAnimateState = fingerAnimateState;
      this.notifyStateChange(FingerprintBindStateType.FINGER_ANIMATE_STATE);
    }
  }

  public getFingerAnimateState(): AnimationStatus {
    return this.fingerAnimateState;
  }

  public setNtfDisableFingerPrint(isDisabled: boolean): void {
    if (this.isNtfDisableFingerPrint !== isDisabled) {
      this.isNtfDisableFingerPrint = isDisabled;
      this.notifyStateChange(FingerprintBindStateType.FINGER_NTF_DISABLE_STATE);
    }
  }

  public getNtfDisableFingerPrint(): boolean {
    return this.isNtfDisableFingerPrint;
  }

  public setIconHiddenAnimationState(isDisabled: boolean): void {
    if (this.isHiddenLottiePlaying !== isDisabled) {
      this.isHiddenLottiePlaying = isDisabled;
      this.notifyStateChange(FingerprintBindStateType.FINGER_ICON_HIDDEN_STATE);
    }
  }

  public getIconHiddenAnimationState(): boolean {
    return this.isHiddenLottiePlaying;
  }
}