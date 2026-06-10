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

import screenLock from '@ohos.screenLock';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventConstants, obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper';
import { sSCBOobeManager } from '@ohos/windowscene';
import {
  GlobalStatusCache,
  HandleResult,
  KeyGuardCacheKey,
  LockEventType,
  LockUnlockRequestHandler,
  ScreenLockUnlockService,
  SlEventListener,
  SlServerHelper,
  VerifyDataManager,
  VerifyStateListener,
  StrongAuthStateManager,
  ScreenLockStateManager,
  LockOperateResult,
} from '@ohos/screenlockcommon';
import { FsmCallback, RemoteLockStateManager } from '@ohos/screenlockcommon/Index';
import { CoreEvent, CoreEventType, CoreStateType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { AbstractEventAdapter } from './AbstractEventAdapter';
import { SlObserverProxy } from '../observer/SlObserverProxy';

const TAG = 'SlServiceEventAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const EVENT_SYSTEM_READY: string = 'systemReady';
const EVENT_UNLOCK_SCREEN: string = 'unlockScreen';
const EVENT_LOCK_SCREEN: string = 'lockScreen';
const EVENT_BEGIN_EXIT_ANIMATION: string = 'beginExitAnimation';
const EVENT_USERIAM_READY_STATE: string = 'useriamReady';
const EVENT_STRONG_AUTH_CHANGED: string = 'strongAuthChanged';

const USERIAM_READY: string = 'true';

/**
 * 锁屏服务事件适配器
 */
export class SlServiceEventAdapter extends AbstractEventAdapter {
  private readonly _lockUnlockRequestListener: LockUnlockRequestHandler = {
    onRequestUnlock: this.handleUnlockRequestEvent.bind(this),
    onRequestLock: this.handleLockRequestEvent.bind(this),
  };

  private readonly _slEventListener: SlEventListener = {
    onSystemEvent: (event : screenLock.SystemEvent): void => {
      log.showInfo(`onSystemEvent event: ${event?.eventType}`);
      switch (event?.eventType) {
        case EVENT_SYSTEM_READY:
          this.handleSystemReadyEvent();
          break;
        case EVENT_UNLOCK_SCREEN:
          ScreenLockUnlockService.getInstance().requestUnlock();
          break;
        case EVENT_LOCK_SCREEN:
          this.handleLockRequestEvent();
          break;
        case EVENT_BEGIN_EXIT_ANIMATION:
          sEventManager.publish(obtainLocalEvent(EventConstants.SCREEN_LOCK_EXIT, 0));
          break;
        case EVENT_USERIAM_READY_STATE:
          this.handleUserIamReady(event);
          break;
        case EVENT_STRONG_AUTH_CHANGED:
          this.handleStrongAuthChange(event);
          break;
        default:
          log.showDebug(`unhandle screenlock service event: ${event?.eventType}`);
          break;
      }
      log.showDebug(`receive screenlock service end. event: ${event?.eventType}`);
    },
    onEndServiceRestart: (): void => {
      log.showInfo(`receive onEndServiceRestart`);
      this.handleLockRequestEvent();
    }
  };

  protected doInit(): void {
    log.showInfo('doInit');
    SlServerHelper.getInstance().registerObserver(this._slEventListener);

    ScreenLockUnlockService.getInstance().lockUnlockRequestHandler = this._lockUnlockRequestListener;
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    SlServerHelper.getInstance().unRegisterObserver(this._slEventListener);
    ScreenLockUnlockService.getInstance().lockUnlockRequestHandler = undefined;
  }

  private handleSystemReadyEvent(): void {
    log.showDebug(TAG, 'handleSystemReadyEvent.');
    // 连接锁屏管理服务后获取刷新当前强认证状态
    StrongAuthStateManager.getInstance().updateStrongAuth();
    if (sSCBOobeManager.isEnable() && VerifyDataManager.getInstance().hasNoPwd) {
      // OOBE阶段未设置密码则运转至未锁屏态
      this.fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
    }
  }

  private handleUnlockRequestEvent(callback?: (result: HandleResult) => void): void {
    log.showDebug('handleUnlockRequestEvent.');
    if (RemoteLockStateManager.getInstance().isRemoteLocked) {
      log.showWarn('remote locked, cannot unlock.');
      callback?.(HandleResult.FAIL);
      return;
    }
    if (CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType) &&
      !ScreenLockStateManager.getInstance().isDeviceLocked) {
      log.showWarn('request unlock when unlocked.');
      SlServerHelper.getInstance()
        .sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT, LockOperateResult.AlreadyUnlocked);
    }
    let isInterWallpaperAble: boolean = GlobalStatusCache.getInstance().getStatus(
      KeyGuardCacheKey.INTERWALLPAPER_UNLOCKABLE, false) as boolean;
    let skipRequestUnlock: boolean = false;
    if (isInterWallpaperAble) {
      if (!skipRequestUnlock && CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
        log.showWarn('handleUnlockRequestEvent isInUnlockPage');
        skipRequestUnlock = true;
      }
      if (!skipRequestUnlock && CoreStateTypeUtils.isScreenOffPwdCheckState(this.fsmProxy.coreFsm.currentStateType)) {
        log.showWarn('handleUnlockRequestEvent isScreenOffPwdCheckState');
        skipRequestUnlock = true;
      }
      if (!skipRequestUnlock && CoreStateTypeUtils.isBouncerToUnlockState(this.fsmProxy.coreFsm.currentStateType)) {
        log.showWarn('handleUnlockRequestEvent isBouncerToUnlockState');
        skipRequestUnlock = true;
      }
    }
    if (!skipRequestUnlock) {
      log.showWarn('handleUnlockRequestEvent submitCoreEvent REQUEST_UNLOCK');
      this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
    }
    if (callback) {
      this.handleUnlockRequestCallback(callback);
    }
  }

  private handleLockRequestEvent(): void {
    log.showDebug('handleLockRequestEvent.');
    if (SlServerHelper.getInstance().isScreenLockDisabled()) {
      log.showWarn('Lock disabled.');
      return;
    }
    if (!CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
      log.showWarn('request lock when locked.');
      SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.LOCK_SCREEN_RESULT);
    }
    this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_LOCK);
  }

  private handleUnlockRequestCallback(callback: (result: HandleResult) => void): void {
    switch (this.fsmProxy.coreFsm.currentStateType) {
      case CoreStateType.UNLOCK_STATE:
        log.showInfo('handleUnlockRequestEvent request lock success.');
        callback(HandleResult.SUCCESS);
        break;
      case CoreStateType.BOUNCER_TO_UNLOCK_STATE:
      case CoreStateType.BOUNCER_UNLOCK_STATE:
        log.showInfo('handleUnlockRequestEvent request lock doing.');
        callback(HandleResult.WAITING);
        this.waitRequestUnlock(callback);
        break;
      default:
        log.showInfo('handleUnlockRequestEvent request lock failed.');
        callback(HandleResult.FAIL);
        break;
    }
  }

  private waitRequestUnlock(callback: (result: HandleResult) => void): void {
    let observerProxy: SlObserverProxy = new SlObserverProxy();
    let fsmCallback: FsmCallback<CoreStateType, CoreEvent> = {
      onFsmStateChange: (oldState: CoreStateType, newState: CoreStateType): void => {
        log.showInfo(`onFsmStateChange: ${CoreStateType[oldState]} --> ${CoreStateType[newState]}`);
        if (oldState !== CoreStateType.BOUNCER_TO_UNLOCK_STATE && oldState !== CoreStateType.BOUNCER_UNLOCK_STATE) {
          log.showWarn(`handleUnlockRequestEvent request lock failed. oldState: ${CoreStateType[oldState]}`);
          callback(HandleResult.FAIL);
          this.fsmProxy.coreFsm.unRegisterObserver(fsmCallback);
          observerProxy.release();
          return;
        }
        if (oldState === newState || newState === CoreStateType.BOUNCER_UNLOCK_STATE) {
          return;
        }
        if (newState === CoreStateType.UNLOCK_STATE) {
          log.showInfo('handleUnlockRequestEvent request lock success.');
          // 通知解锁成功前，先通知wms解锁，避免应用拉起被wms拦截
          ScreenLockUnlockService.getInstance().notifyEarlyUnlockTransition();
          callback(HandleResult.SUCCESS);
          if (isAuthSuccess) {
            // 认证成功比锁屏退出快
            callback(HandleResult.AUTH_RESULT_SUCCESS);
          }
        } else {
          log.showWarn(`handleUnlockRequestEvent request lock cancel. newState: ${CoreStateType[newState]}`);
          callback(HandleResult.CANCEL);
          SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT, LockOperateResult.Cancel);
          observerProxy.release();
        }
        log.showInfo('handleUnlockRequestEvent end');
        this.fsmProxy.coreFsm.unRegisterObserver(fsmCallback);
      }
    };
    this.fsmProxy.coreFsm.registerObserver(fsmCallback, false);

    // 已经处于解锁态，则不需要注册认证成功的回调
    let isAuthSuccess = CoreStateTypeUtils.isUnlockStateScreenOn(this.fsmProxy.coreFsm.currentStateType);
    log.showInfo(`handleUnlockRequestEvent isAuthSuccess: ${isAuthSuccess}`);
    let authResultCallback: VerifyStateListener = {
      onAuthSuccessResult: (): void => {
        if (CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
          // 锁屏退出比认证成功快
          callback(HandleResult.AUTH_RESULT_SUCCESS);
        } else {
          isAuthSuccess = true;
        }
        observerProxy.release();
      }
    };
    if (!isAuthSuccess) {
      observerProxy.observerVerifyState(authResultCallback);
    }
  }

  private handleUserIamReady(event?: screenLock.SystemEvent): void {
    let userIamState: string | undefined = event?.params;
    log.showInfo(TAG, `USERIAM_READY event, userIamState: ${userIamState}`);
    if (userIamState === USERIAM_READY) {
      VerifyDataManager.getInstance().userIamReadyUpdateVerifyInfo();
    }
  }

  private handleStrongAuthChange(event?: screenLock.SystemEvent): void {
    let strongAuthState: number = Number(event?.params);
    log.showInfo(TAG, `strongAuthChanged event, strongAuthState: ${strongAuthState}`);
    StrongAuthStateManager.getInstance().updateStrongAuth();
  }
}