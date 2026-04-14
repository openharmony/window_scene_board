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
import {
  AbstractObserverManager,
  LockStateInfo,
  LockUnlockListener,
  ObserverAble,
  ObserverProxy,
  ScreenLockStateChangeListener,
  ScreenLockStateManager,
  ScreenLockUnlockService,
  ScreenLockVerifyService,
  ScreenOnOffListener,
  ScreenOnOffService,
  StrongAuthStateManager,
  StrongAuthStateListener,
  StrongAuthReasonFlags,
  VerifyDataChangeListener,
  VerifyDataManager,
  VerifyInfo,
  VerifyStateListener,
  SimCardStateManager,
  SimCardStateChangeListener
} from '@ohos/screenlockcommon';
import {
  DisplayStateListener,
  DisplayStateManager,
  FsmCallback,
  RemoteLockStateChangeListener,
  RemoteLockStateManager
} from '@ohos/screenlockcommon/Index';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { BouncerEvent, BouncerStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/BouncerFsm';
import { MpEvent, MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { CoreEvent, CoreStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { OneMirrorListener, OneMirrorService } from '../onemirror/service/OneMirrorService';
import { VerifyTipsListener, VerifyTipsService } from '../tips/service/VerifyTipsService';

const TAG = 'SlObserverProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏页面使用的数据观察者，注：仅供页面使用，内部请使用原始接口
 */
export class SlObserverProxy extends AbstractObserverManager<ObserverProxy<ObserverAble>> {
  /**
   * 获取验证信息（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param inAuthType 验证类型
   * @param callback 更新回调
   * @returns 验证信息
   */
  public getVerifyInfo(inAuthType: AuthType, callback?: (verifyInfo: VerifyInfo) => void): VerifyInfo | undefined {
    let verifyInfo: VerifyInfo | undefined = VerifyDataManager.getInstance().getVerifyInfo(inAuthType);
    if (callback) {
      let observerProxy: ObserverProxy<VerifyDataChangeListener> = new ObserverProxy({
        onVerifyInfoChange: (authType: AuthType, verifyInfo: VerifyInfo): void => {
          if (inAuthType === authType) {
            callback(verifyInfo);
          }
        }
      }, VerifyDataManager.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      if (verifyInfo) {
        callback(verifyInfo);
      }
    }
    return verifyInfo;
  }

  /**
   * 获取验证是否锁定（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param inAuthType 验证类型
   * @param callback 更新回调
   * @returns 验证信息
   */
  public getVerifyStateLocked(inAuthType: AuthType, callback?: (verifyInfo: VerifyInfo) => void): boolean {
    let verifyInfo: VerifyInfo | undefined = VerifyDataManager.getInstance().getVerifyInfo(inAuthType);
    if (callback) {
      let observerProxy: ObserverProxy<VerifyDataChangeListener> = new ObserverProxy({
        onVerifyStateChange: (authType: AuthType, verifyInfo: VerifyInfo): void => {
          if (inAuthType === authType) {
            callback(verifyInfo);
          }
        }
      }, VerifyDataManager.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
    }
    return verifyInfo?.isStateLocked;
  }

  /**
   * 查询是否处在验证中（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param inAuthType 验证类型
   * @param callback 更新回调
   * @returns 验证状态
   */
  public isVerifying(inAuthType: AuthType, callback?: (isVerifying: boolean) => void): boolean {
    let isVerifying: boolean = ScreenLockVerifyService.getInstance().isVerifying(inAuthType);
    if (callback) {
      let observerProxy: ObserverProxy<VerifyStateListener> = new ObserverProxy({
        onVerifyStateChange: (authType: AuthType, isVerifying: boolean): void => {
          if (inAuthType === authType) {
            callback(isVerifying);
          }
        }
      }, ScreenLockVerifyService.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(isVerifying);
    }
    return isVerifying;
  }

  /**
   * 查询是否处理请求解锁中（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param callback 更新回调
   * @returns 验证状态
   */
  public isInRequestUnlock(callback?: (isInRequestUnlock: boolean) => void): boolean {
    let isInRequestUnlock: boolean = ScreenLockUnlockService.getInstance().isInRequestUnlock;
    if (callback) {
      let observerProxy: ObserverProxy<LockUnlockListener> = new ObserverProxy({
        onRequestUnlockStateChange: (isInRequestUnlock: boolean): void => {
          callback(isInRequestUnlock);
        }
      }, ScreenLockUnlockService.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(isInRequestUnlock);
    }
    return isInRequestUnlock;
  }

  /**
   * 查询是否处理请求解锁中（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param callback 更新回调
   * @returns 验证状态
   */
  public isScreenOn(callback?: (isScreenOn: boolean) => void): boolean {
    let isScreenOn: boolean = ScreenOnOffService.getInstance().isScreenOn;
    if (callback) {
      let observerProxy: ObserverProxy<ScreenOnOffListener> = new ObserverProxy({
        onScreenOnChange: (isScreenOn: boolean): void => {
          callback(isScreenOn);
        }
      }, ScreenOnOffService.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(isScreenOn);
    }
    return isScreenOn;
  }

  /**
   * 查询是否SIM卡上锁（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param callback 更新回调
   * @returns 验证状态
   */
  public isSimLocked(callback?: (isSimLocked: boolean) => void): boolean {
    let isSimLocked: boolean = SimCardStateManager.getInstance().isSimLocked();
    if (callback) {
      let observerProxy: ObserverProxy<SimCardStateChangeListener> = new ObserverProxy({
        onSimCardLockChanged: (isSimLocked: boolean): void => {
          callback(isSimLocked);
        }
      }, SimCardStateManager.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(isSimLocked);
    }
    return isSimLocked;
  }

  /**
   * 查询是否处于熄屏过程中（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param callback 更新回调
   * @returns 验证状态
   */
  public isIntoSleep(callback?: (isIntoSleep: boolean) => void): boolean {
    let isIntoSleep: boolean = ScreenOnOffService.getInstance().isIntoSleep;
    if (callback) {
      let observerProxy: ObserverProxy<ScreenOnOffListener> = new ObserverProxy<ScreenOnOffListener>({
        onIntoSleepChange: (isIntoSleep: boolean): void => {
          callback(isIntoSleep);
        }
      }, ScreenOnOffService.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(isIntoSleep);
    }
    return isIntoSleep;
  }

  /**
   * 查询锁定状态（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param callback 更新回调
   * @returns 锁定状态
   */
  public getLockState(callback?: (lockState: LockStateInfo) => void): LockStateInfo {
    let lockState: LockStateInfo = ScreenLockStateManager.getInstance().lockStateInfo;
    if (callback) {
      let observerProxy: ObserverProxy<ScreenLockStateChangeListener> =
        new ObserverProxy<ScreenLockStateChangeListener>({
          onLockStateChange: (lockState: LockStateInfo): void => {
            callback(lockState);
          }
        }, ScreenLockStateManager.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(lockState);
    }
    return lockState;
  }

  /**
   * 查询核心状态机状态（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param persistentId 状态机实例ID
   * @param callback 更新回调
   * @returns 核心状态机状态
   */
  public getCoreFsmState(persistentId: number, callback?: (oldState: CoreStateType, newState: CoreStateType) => void):
    CoreStateType {
    let currentStateType: CoreStateType = ScreenLockFsmProxy.getInstance(persistentId).coreFsm.currentStateType;
    if (callback) {
      let observerProxy: ObserverProxy<FsmCallback<CoreStateType, CoreEvent>> =
        new ObserverProxy<FsmCallback<CoreStateType, CoreEvent>>({
          onFsmStateChange: (oldState: CoreStateType, newState: CoreStateType): void => {
            log.showInfo(`CoreFsmState: ${CoreStateType[oldState]} --> ${CoreStateType[newState]}`);
            callback(oldState, newState);
          }
        }, ScreenLockFsmProxy.getInstance(persistentId).coreFsm, callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
    }
    return currentStateType;
  }

  /**
   * 查询主页状态机状态（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param persistentId 状态机实例ID
   * @param callback 更新回调
   * @returns 核心状态机状态
   */
  public getMpFsmState(persistentId: number, callback?: (oldState: MpStateType, newState: MpStateType) => void):
    MpStateType {
    let currentStateType: MpStateType = ScreenLockFsmProxy.getInstance(persistentId).mainPageFsm.currentStateType;
    if (callback) {
      let observerProxy: ObserverProxy<FsmCallback<MpStateType, MpEvent>> =
        new ObserverProxy<FsmCallback<MpStateType, MpEvent>>({
          onFsmStateChange: (oldState: MpStateType, newState: MpStateType): void => {
            log.showInfo(`MpFsmState: ${MpStateType[oldState]} --> ${MpStateType[newState]}`);
            callback(oldState, newState);
          }
        }, ScreenLockFsmProxy.getInstance(persistentId).mainPageFsm, callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
    }
    return currentStateType;
  }

  /**
   * 查询密码页状态机状态（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param persistentId 状态机实例ID
   * @param callback 更新回调
   * @returns 核心状态机状态
   */
  public getBouncerFsmState(persistentId: number,
    callback?: (oldState: BouncerStateType, newState: BouncerStateType) => void): BouncerStateType {
    let currentStateType: BouncerStateType = ScreenLockFsmProxy.getInstance(persistentId).bouncerFsm.currentStateType;
    if (callback) {
      let observerProxy: ObserverProxy<FsmCallback<BouncerStateType, BouncerEvent>> =
        new ObserverProxy<FsmCallback<BouncerStateType, BouncerEvent>>({
          onFsmStateChange: (oldState: BouncerStateType, newState: BouncerStateType): void => {
            log.showInfo(`BouncerFsmState: ${BouncerStateType[oldState]} --> ${BouncerStateType[newState]}`);
            callback(oldState, newState);
          }
        }, ScreenLockFsmProxy.getInstance(persistentId).bouncerFsm, callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
    }
    return currentStateType;
  }

  /**
   * 观察一镜到底变化（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param oneMirrorListener 一镜到底监听器
   */
  public observerOneMirror(oneMirrorListener: OneMirrorListener): void {
    let observerProxy: ObserverProxy<OneMirrorListener> = new ObserverProxy(
      oneMirrorListener, OneMirrorService.getInstance(), oneMirrorListener);
    observerProxy.init();
    this.registerObserver(observerProxy);
  }

  /**
   * 观察验证提示变化（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param verifyTipsListener 验证提示监听器
   */
  public observerVerifyTips(verifyTipsListener: VerifyTipsListener): void {
    let observerProxy: ObserverProxy<VerifyTipsListener> = new ObserverProxy(
      verifyTipsListener, VerifyTipsService.getInstance(), verifyTipsListener);
    observerProxy.init();
    this.registerObserver(observerProxy);
  }

  /**
   * 观察屏幕状态变化（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param displayStateListener 屏幕状态监听器
   */
  public observerDisplayState(displayStateListener: DisplayStateListener): void {
    let observerProxy: ObserverProxy<DisplayStateListener> = new ObserverProxy(
      displayStateListener, DisplayStateManager.getInstance(), displayStateListener);
    observerProxy.init();
    this.registerObserver(observerProxy);
  }

  /**
   * 监听认证状态变化
   *
   * @param verifyStateListener 认证状态监听器
   */
  public observerVerifyState(verifyStateListener: VerifyStateListener): void {
    let observerProxy: ObserverProxy<VerifyStateListener> = new ObserverProxy(
      verifyStateListener, ScreenLockVerifyService.getInstance(), verifyStateListener);
    observerProxy.init();
    this.registerObserver(observerProxy);
  }

  /**
   * 观察亮灭屏事件（注意：带回调时需要放置在aboutToAppear中调用）
   *
   * @param screenOnOffListener 亮灭屏监听器
   */
  public observerScreenOnOff(screenOnOffListener: ScreenOnOffListener): void {
    let observerProxy: ObserverProxy<ScreenOnOffListener> = new ObserverProxy(
      screenOnOffListener, ScreenOnOffService.getInstance(), screenOnOffListener);
    observerProxy.init();
    this.registerObserver(observerProxy);
  }

  /**
   * 观察PreUnlock事件
   *
   * @param LockUnlockListener 解锁上锁监听
   */
  public observerPreUnlock(lockUnlockListener: LockUnlockListener): void {
    let observerProxy: ObserverProxy<LockUnlockListener> = new ObserverProxy(
      lockUnlockListener, ScreenLockUnlockService.getInstance(), lockUnlockListener);
    observerProxy.init();
    this.registerObserver(observerProxy);
  }

  /**
   * 监听强认证变化
   *
   * @param callback 更新回调
   * @returns 强认证状态
   */
  public observerStrongAuthState(callback?: (strongAuthStatus: StrongAuthReasonFlags) => void): StrongAuthReasonFlags {
    let strongAuthState: number = StrongAuthStateManager.getInstance().getStrongAuthStatus();
    if (callback) {
      let observerProxy: ObserverProxy<StrongAuthStateListener> = new ObserverProxy({
        onStrongAuthStateChange: (strongAuthStatus: StrongAuthReasonFlags): void => {
          callback(strongAuthStatus);
        }
      }, StrongAuthStateManager.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(strongAuthState);
    }
    return strongAuthState;
  }

  public observerEdmRemoteLock(callback?: (isEDMRemoteLock: boolean) => void): boolean {
    let isEdmRemoteLock: boolean = RemoteLockStateManager.getInstance().isRemoteLocked;
    if (callback) {
      let observerProxy: ObserverProxy<RemoteLockStateChangeListener> = new ObserverProxy({
        onRemoteLockStateChange: (isLocked: boolean, lockedTips: string): void => {
          callback(isLocked);
        }
      }, RemoteLockStateManager.getInstance(), callback);
      observerProxy.init();
      this.registerObserver(observerProxy);
      callback(isEdmRemoteLock);
    }
    return isEdmRemoteLock;
  }

  /**
   * 释放回调
   *
   * @param callback 回调函数
   */
  public releaseCallback(callback: Function | VerifyStateListener | LockUnlockListener): void {
    this.broadcastDataChange(observerProxy => {
      if (observerProxy.callback === callback) {
        observerProxy.release();
        this.unRegisterObserver(observerProxy);
      }
    });
  }

  /**
   * 销毁监听
   */
  public release(): void {
    log.showDebug('release');
    this.broadcastDataChange(observerProxy => {
      observerProxy.release();
      this.unRegisterObserver(observerProxy);
    });
    super.release();
  }
}