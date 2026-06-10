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
import lazy { SCBTransitionManager, SCBUnlockTransitionController } from '@ohos/windowscene';
import type { Callback } from '@ohos.base';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';

const TAG = 'ScreenLockAdapter'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 上锁解锁事件回调
 */
export interface LockUnlockCallback {
  /**
   * 成功时回调
   */
  success?: Function;

  /**
   * 认证成功并收到result时回调（代表此时文件解密成功）
   */
  authResultSuccess?: Function;

  /**
   * 取消时回调
   */
  cancel?: Function;

  /**
   * 失败时回调
   */
  fail?: Function;
}

export interface LockUnlockCallbackAdapter extends LockUnlockCallback {
  withDelay?: boolean;
  cancelCallback?: Callback<void>;
}

interface LockState {
  lockState: number;
}

interface IScreenLockStateManager {
  isPageShow: boolean;
  isInEdite: boolean;
  isLocked: boolean;
  lockStateInfo: LockState;
}

interface IScreenLockApi {
  getLock(): boolean;
  unlockWhenNoPsw(): void;
  notifyUnlockTransitionForPc(): void;
  requestUnlock(callback?: LockUnlockCallback, withDelay?: boolean, cancelCallback?: Callback<void>): void;
}

interface ISystemSwitchUtils {
  isUseNewScreenLock(): boolean;
}

interface IScreenLockUnlockService {
  requestUnlock(callback: LockUnlockCallback): void;
}

enum ScreenLockState {
  HOST,
  THEME_EDITOR,
  THEME_EDITOR_FULL,
  THEME_EDITOR_FULL_CLOCK,
  THEME_EDITOR_FULL_FORM,
  THEME_EDITOR_FORM_DETAIL,
  THEME_EDITOR_CLOCK_DRAG,
  THEME_EDITOR_FORM_DRAG,
  BOUNCER,
  EXIT_KEYGUARD,
  ENTER_OTHER_APP
}

interface ScreenLockStateListener {
  /**
   * 触发进入锁屏首页
   *
   * @param isNeedAnimation 是否需要播放动效
   */
  onEnterHost?: (preState: ScreenLockState, isSaveConfig: boolean) => void;
  /**
   * 触发进入个性化编辑页面
   */
  onEnterThemeEditor?: (preState: ScreenLockState) => void;
  /**
   * 触发进入全屏编辑页面
   */
  onEnterFullEditor?: (preState: ScreenLockState, fullState: ScreenLockState) => void;
  /**
   * 触发进入密码输入界面
   */
  onEnterBouncer?: (preState: ScreenLockState, keyboardPosition: number) => void;
  /**
   * 触发退出锁屏
   */
  onExitKeyguard?: () => void;
  /**
   * 进入主题/壁纸/AOD界面
   */
  onEnterOtherApp?: () => void;
  /**
   * 进入壁纸/AOD界面
   */
  onEnterOtherAppBorderShow?: () => void;
  /**
   * 进入主题界面
   */
  onEnterOtherAppBorderHide?: () => void;

  /**
   * 指纹认证成功
   */
  onAuthFPSuccess?: () => void;
}

interface IScreenLockInnerStateManager {
  currentState: number;
  registerScreenLockState(listener: ScreenLockStateListener): void;
  unregisterScreenLockState(listener: ScreenLockStateListener | undefined): void;
}

export class ScreenLockAdapter {
  private static stateManager?: IScreenLockStateManager;
  private static innerStateManager?: IScreenLockInnerStateManager;
  private static api?: IScreenLockApi;
  private static switchUtils?: ISystemSwitchUtils;
  private static unlockService?: IScreenLockUnlockService;
  public static isScreenLock: boolean = false;

  public static setStateManager(manager: IScreenLockStateManager): void {
    log.showInfo('Set state manager');
    ScreenLockAdapter.stateManager = manager;
  }

  public static setInnerStateManager(innerStateManager: IScreenLockInnerStateManager): void {
    log.showInfo('Set inner state manager');
    ScreenLockAdapter.innerStateManager = innerStateManager;
  }

  public static setScreenLockApi(api: IScreenLockApi): void {
    log.showInfo('Set api');
    ScreenLockAdapter.api = api;
  }

  public static setSwitchUtils(switchUtils: ISystemSwitchUtils): void {
    log.showInfo('Set switchUtils');
    ScreenLockAdapter.switchUtils = switchUtils;
  }

  public static setUnlockService(unlockService: IScreenLockUnlockService): void {
    log.showInfo('Set unlockService');
    ScreenLockAdapter.unlockService = unlockService;
  }

  @threadCall(ThreadCallType.Sync)
  public static getLock(): boolean | undefined {
    return ScreenLockAdapter.api?.getLock();
  }

  @threadCall()
  public static isExitKeyGuard(): boolean | Promise<boolean> {    
    return ScreenLockAdapter.innerStateManager?.currentState === ScreenLockState.EXIT_KEYGUARD;
  }

  @threadCall(ThreadCallType.Sync)
  public static isPageShow(): boolean {
    return ScreenLockAdapter.stateManager?.isPageShow ?? false;
  }

  @threadCall(ThreadCallType.Sync)
  public static isInEdite(): boolean {
    return ScreenLockAdapter.stateManager?.isInEdite ?? false;
  }

  @threadCall(ThreadCallType.Sync)
  public static isLocked(): boolean {
    return ScreenLockAdapter.stateManager?.isLocked ?? false;
  }

  @threadCall(ThreadCallType.Sync)
  public static getLockState(): number {
    return ScreenLockAdapter.stateManager?.lockStateInfo.lockState ?? 0;
  }

  @threadCall(ThreadCallType.Sync)
  public static isUseNewScreenLock(): boolean | undefined {
    return ScreenLockAdapter.switchUtils?.isUseNewScreenLock();
  }

  @threadCall()
  public static unlockWhenNoPsw(): void {
    log.showInfo('unlockWhenNoPsw');
    ScreenLockAdapter.api?.unlockWhenNoPsw();
  }

  @threadCall()
  public static notifyUnlockTransitionForPc(): void {
    log.showInfo('notifyUnlockTransitionForPc');
    ScreenLockAdapter.api?.notifyUnlockTransitionForPc();
  }

  @threadCall(ThreadCallType.RegisterOnce)
  public static requestUnlockScreenLockUnlockService(callback: LockUnlockCallback, tag: string): void {
    log.showInfo(`requestUnlockScreenLockUnlockService tag ${tag}`);
    ScreenLockAdapter.unlockService?.requestUnlock(callback);
  }

  @threadCall(ThreadCallType.RegisterOnce)
  public static requestUnlock(callback: LockUnlockCallbackAdapter, tag: string): void {
    log.showInfo(`requestUnlock tag ${tag}`);
    ScreenLockAdapter.api?.requestUnlock(callback, callback.withDelay, callback.cancelCallback);
  }

  @threadCall(ThreadCallType.Register)
  public static registerScreenLockState(listener: ScreenLockStateListener, tag: string): void {
    log.showInfo(`registerScreenLockState tag ${tag}`);
    ScreenLockAdapter.innerStateManager?.registerScreenLockState(listener);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unregisterScreenLockState(listener: ScreenLockStateListener, tag: string): void {
    log.showInfo(`unregisterScreenLockState tag ${tag}`);
    ScreenLockAdapter.innerStateManager?.unregisterScreenLockState(listener);
  }

  @threadCall(ThreadCallType.Register)
  public static registerUnlockTransitionController(controller: SCBUnlockTransitionController, tag: string): void {
    SCBTransitionManager.getInstance().registerUnlockTransitionController(controller, false);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterUnlockTransitionController(controller: SCBUnlockTransitionController, tag: string): void {
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(controller, false);
  }

  @threadCall(ThreadCallType.Register)
  public static registerTransitionCallback(obj: Object, tag: string): void {
    SCBTransitionManager.getInstance().registerUnlockTransitionController(Reflect.get(obj, 'eventId'),
      Reflect.get(obj, 'callback'));
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterTransitionCallback(obj: Object, tag: string): void {
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(Reflect.get(obj, 'eventId'),
      Reflect.get(obj, 'callback'));
  }

  @threadCall()
  public static setScreenLockMoveEvent(event: Object): void {
    const parsedData = new Object();
    SystemUICommonUtil.assign(parsedData as Object as Record<string, Object>, event as Object as Record<string, Object>)
    AppStorage.setOrCreate('screenLockMoveEvent', parsedData);
  }

  @threadCall(ThreadCallType.Async)
  public static unLock(): Promise<boolean> {
    return new Promise<boolean>((resolve) => {
      ScreenLockAdapter.api?.requestUnlock({
        success: () => resolve(true),
        cancel: () => resolve(false),
        fail: () => resolve(false),
      }, true);
    });
  }
}
