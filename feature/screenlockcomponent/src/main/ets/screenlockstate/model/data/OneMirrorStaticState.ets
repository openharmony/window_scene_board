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

import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  OneMirrorStaticStateType,
  SlMainStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

/**
 * 一镜到底静态状态管理
 *
 */
export class OneMirrorStaticState extends WidgetStaticState<OneMirrorStaticStateType> {
  /**
   * 是否一镜到底动效中
   */
  private isOneMirror: boolean = false;
  /**
   * 是否AOD显示状态
   */
  private isAodShowing: boolean = false;

  /**
   * 是否桌面到锁屏场景
   */
  private isDesktopToSL?: boolean = false;

  /**
   * 是否需要默认进沉浸态
   */
  private isNeedShowImmersive?: boolean = false;

  /**
   * 当前通知列表中是否存在播控通知
   */
  private isHasBroadCastingCenter?: boolean = false;

  private sleepReason: number = -1; // 灭屏原因

  // AOD状态，不参与动效，直接切换
  private _isComAod: boolean = false;

  // AOD状态，参与动效，受_isComAod控制
  private _isAnimAod: boolean = false;

  constructor() {
    super(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE);
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initGetMethods(): void {
    this.getMethods.set(OneMirrorStaticStateType.ONE_MIRROR_ANIM_STATE, this.getMethodOneMirrorState);
    this.getMethods.set(OneMirrorStaticStateType.IS_AOD_SHOWING, this.getMethodAodShowingState);
    this.getMethods.set(OneMirrorStaticStateType.IS_DESKTOP_TO_SL, this.getMethodIsDesktopToSL);
    this.getMethods.set(OneMirrorStaticStateType.IS_NEED_SHOW_IMMERSIVE, this.getMethodIsNeedToShowImmersive);
    this.getMethods.set(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, this.getMethodIsHasBoardCastingCenter);
    this.getMethods.set(OneMirrorStaticStateType.SLEEP_REASON, this.getMethodSleepReason);
    this.getMethods.set(OneMirrorStaticStateType.PT_AOD_STATE, this.getMethodAodState);
  }

  private getMethodAodState(st: OneMirrorStaticState): boolean {
    return st.isAodSt();
  }

  private getMethodOneMirrorState(st: OneMirrorStaticState): boolean {
    return st.getOneMirrorState()
  }

  private getMethodAodShowingState(st: OneMirrorStaticState): boolean {
    return st.getAodShowingState()
  }

  private getMethodIsDesktopToSL(st: OneMirrorStaticState): boolean | undefined {
    return st.getIsDesktopToSL()
  }

  private getMethodIsNeedToShowImmersive(st: OneMirrorStaticState): boolean | undefined {
    return st.getIsNeedToShowImmersive()
  }

  private getMethodIsHasBoardCastingCenter(st: OneMirrorStaticState): boolean | undefined {
    return st.getIsHasBoardCastingCenter()
  }

  private getMethodSleepReason(st: OneMirrorStaticState): number {
    return st.getSleepReason();
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initSetMethods(): void {
    this.setMethods.set(OneMirrorStaticStateType.IS_DESKTOP_TO_SL, this.setMethodIsDesktopToSL);
    this.setMethods.set(OneMirrorStaticStateType.IS_NEED_SHOW_IMMERSIVE, this.setMethodIsNeedToShowImmersive);
    this.setMethods.set(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, this.setMethodIsHasBoardCastingCenter);
    this.setMethods.set(OneMirrorStaticStateType.SLEEP_REASON, this.setMethodSleepReason);
  }

  private setMethodIsDesktopToSL(st: OneMirrorStaticState, value: boolean): void {
    st.setIsDesktopToSL(value);
  }

  private setMethodIsNeedToShowImmersive(st: OneMirrorStaticState, value: boolean): void {
    st.setIsNeedToShowImmersive(value);
  }

  private setMethodIsHasBoardCastingCenter(st: OneMirrorStaticState, value: boolean): void {
    st.setIsHasBoardCastingCenter(value);
  }

  private setMethodSleepReason(state: OneMirrorStaticState, reason: number): void {
    state.setSleepReason(reason);
  }

  /**
   * 获取一镜到底状态
   *
   * @returns 是否一镜到底动效播放中
   */
  public getOneMirrorState(): boolean {
    return this.isOneMirror;
  }

  /**
   * 获取AOD显示状态
   *
   * @returns 是否AOD显示中
   */
  public getAodShowingState(): boolean {
    return this.isAodShowing;
  }

  /**
   * 获取是否是桌面到锁屏场景
   *
   * @returns 是否桌面到锁屏场景
   */
  public getIsDesktopToSL(): boolean | undefined {
    return this.isDesktopToSL;
  }

  /**
   * 获取是否需要默认进沉浸态
   *
   * @returns 是否需要默认进沉浸态
   */
  public getIsNeedToShowImmersive(): boolean | undefined {
    return this.isNeedShowImmersive;
  }

  /**
   * 获取当前通知列表中是否存在播控通知
   *
   * @returns 当前通知列表中是否存在播控通知
   */
  public getIsHasBoardCastingCenter(): boolean | undefined {
    return this.isHasBroadCastingCenter;
  }

  /**
   * 设置一镜到底播放状态
   *
   * @param isOneMirror 是否一镜到底动效播放中
   * @returns 链式
   */
  public setOneMirrorState(isOneMirror: boolean): OneMirrorStaticState {
    if (isOneMirror !== this.isOneMirror) {
      this.isOneMirror = isOneMirror;
    }
    this.notifyStateChange(OneMirrorStaticStateType.ONE_MIRROR_ANIM_STATE);
    return this;
  }

  /**
   * 设置AOD显示状态
   *
   * @param isAodShowing 是否AOD显示中
   * @returns 链式
   */
  public setAodShowingState(isAodShowing: boolean): OneMirrorStaticState {
    if (isAodShowing !== this.isAodShowing) {
      this.isAodShowing = isAodShowing;
    }
    this.notifyStateChange(OneMirrorStaticStateType.IS_AOD_SHOWING);
    return this;
  }

  public setIsDesktopToSL(isDesktopToSL?: boolean): OneMirrorStaticState {
    if (this.isDesktopToSL !== isDesktopToSL) {
      this.isDesktopToSL = isDesktopToSL;
      this.notifyStateChange(OneMirrorStaticStateType.IS_DESKTOP_TO_SL);
    }
    return this;
  }

  public setIsNeedToShowImmersive(isShowImmersive?: boolean): OneMirrorStaticState {
    if (this.isNeedShowImmersive !== isShowImmersive) {
      this.isNeedShowImmersive = isShowImmersive;
      this.notifyStateChange(OneMirrorStaticStateType.IS_NEED_SHOW_IMMERSIVE);
    }
    return this;
  }

  public setIsHasBoardCastingCenter(isHasBroadCast?: boolean): OneMirrorStaticState {
    if (this.isHasBroadCastingCenter !== isHasBroadCast) {
      this.isHasBroadCastingCenter = isHasBroadCast;
      this.notifyStateChange(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER);
    }
    return this;
  }

  public setSleepReason(reason: number): void {
    if (this.sleepReason !== reason) {
      this.sleepReason = reason;
      this.notifyStateChange(OneMirrorStaticStateType.SLEEP_REASON);
    }
  }

  public getSleepReason(): number {
    return this.sleepReason;
  }

  public setComAodSt(isAod: boolean = false): void {
    // 不参与动效，直接设置AOD状态
    this._isComAod = isAod;
  }

  public updateAnimAodSt(): void {
    // 允许动效中切换AOD状态
    if (this._isAnimAod !== this._isComAod) {
      this._isAnimAod = this._isComAod;
      this.notifyStateChange(OneMirrorStaticStateType.PT_AOD_STATE);
    }
  }

  public isAodSt(): boolean {
    return this._isAnimAod;
  }
}
