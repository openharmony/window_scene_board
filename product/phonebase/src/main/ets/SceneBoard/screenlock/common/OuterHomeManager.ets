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

import { Callback } from '@ohos.base';
import display from '@ohos.display';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, DeviceHelper, EvtBus, OuterHomeCallbackEvent } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import {
  AbstractInitialAble,
  LockStateInfo,
  ScreenLockStateChangeListener,
  ScreenLockStateManager
} from '@ohos/screenlockcommon';
import {
  DisplayStateListener,
  DisplayStateManager,
  ScreenLockVerifyService,
  MultimodalInputPowerModule
} from '@ohos/screenlockcommon/Index';
import { CoreEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { FinishCallback } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { MirrorScene } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { MirrorSceneUtils } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { OneMirrorListener } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { OneMirrorService } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import IdlOuterHomeServiceProxy from '../idlService/IdlOuterHomeServiceProxy';
import OuterHomeRemoteService from '../idlService/OuterHomeRemoteService';
import lazy { OuterHomeManagerUtil } from '../utils/OuterHomeManagerUtil';
import { ScreenOnOffMediator } from '@ohos/screenlockcommon';

const TAG: string = 'OuterHomeManagerNew';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const INVALID_TIMER_ID: number = -1;
const NOTIFY_OFF_SCREEN_OPEN_LCD: number = 2;
const NOTIFY_OFF_SCREEN_CLOSE_LCD: number = 3;
const LEM_MAX_SCREEN_OFF_DELAY_TIME: number = 3000;
const MAX_SCREEN_OFF_DELAY_TIME: number = 2000;
const EVENT_CODE_LOCK_STATE: number = 4;

/**
 * 外部锁屏管理
 */
export class OuterHomeManager extends AbstractInitialAble {
  private static sInstance: OuterHomeManager;

  public static getInstance(): OuterHomeManager {
    if (!OuterHomeManager.sInstance) {
      OuterHomeManager.sInstance = new OuterHomeManager();
    }
    return OuterHomeManager.sInstance;
  }

  private readonly _multimodalInputPowerModule: MultimodalInputPowerModule = new MultimodalInputPowerModule(
    (keyOptions: inputConsumer.KeyOptions) => {
      if (keyOptions.finalKey === KeyCode.KEYCODE_POWER && keyOptions.isFinalKeyDown) {
        log.showInfo('power key down callback');
        if (this._timerId !== INVALID_TIMER_ID) {
          // 如果播放外屏灭屏动效过程中再次按power键, 需要取消之前的延迟灭屏, 并马上灭屏, 避免阻碍后续的power亮屏事件
          log.showInfo('power key down in screen off mirror to end');
          this.clearTimer();
          // 打断灭屏动效时采用不下电灭屏
          SCBScreenSessionManager.getInstance().notifyScreenLockEvent(NOTIFY_OFF_SCREEN_OPEN_LCD);
        }
      }
    });
  private readonly _foldStatusChangeListener: Callback<display.FoldStatus> =
    (foldStatus: display.FoldStatus): void => {
      this.updateFoldDisplayMode(foldStatus);
    };
  private readonly _oneMirrorListener: OneMirrorListener = {
    onMirrorScene: (fromScene: MirrorScene, toScene: MirrorScene, hasAnim: boolean,
      finishCallback?: FinishCallback): boolean => {
      if (DeviceHelper.isSubDisplayMode() && !MirrorSceneUtils.isScreenOffScene(fromScene) &&
        toScene === MirrorScene.AOD && hasAnim) {
        // 折叠态，灭屏到AOD场景
        this.doOuterHomeScreenOff(finishCallback);
        return true;
      }
      return false;
    },
    onPostStopAod: () => {
      this.clearTimer();
    }
  }
  private readonly _screenPropertyChangeCallback: DisplayStateListener = {
    onScreenPropertyChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      log.showInfo(`onScreenPropertyChange reason: ${reason}`);
      OuterHomeManagerUtil.getInstance().processSinglePocketExpandAndFold(reason);
    }
  }
  private screenLockStateChangeListener: ScreenLockStateChangeListener = {
    onLockStateChange: (lockStateInfo: LockStateInfo): void => {
      if (DeviceHelper.isSmallFoldProduct()) {
        const eventData: string = JSON.stringify({
          pageState: lockStateInfo.pageState, lockState: lockStateInfo.lockState
        });
        let outerHomeCallbackEvent = new OuterHomeCallbackEvent(EVENT_CODE_LOCK_STATE, eventData);
        EvtBus.post(OuterHomeCallbackEvent, outerHomeCallbackEvent);
      }
    }
  }

  private _isFoldFullDisplay?: boolean;
  private _timerId: number = INVALID_TIMER_ID;
  private _persistentId: number = 0;
  private fsmProxy?: ScreenLockFsmProxy;

  private constructor() {
    super();
  }

  protected isSupport(): boolean {
    return DeviceHelper.isSmallFoldProduct();
  }

  protected doInit(persistentId: number): void {
    log.showInfo('doInit');
    this._persistentId = persistentId;
    this.fsmProxy = ScreenLockFsmProxy.getInstance(persistentId);
    try {
      display.on('foldStatusChange', this._foldStatusChangeListener);
    } catch (error) {
      log.showError(`foldStatusChange on failed. code ${error.code}`);
    }

    // 监听一镜到底
    OneMirrorService.getInstance().registerObserver(this._oneMirrorListener);

    // 监听锁定状态
    ScreenLockStateManager.getInstance().registerObserver(this.screenLockStateChangeListener);

    this.updateFoldDisplayMode();
    if (DeviceHelper.isSubDisplayMode()) {
      // 折叠状态开机时, 设置一次保底灭屏时长
      SCBScreenSessionManager.getInstance().setScreenOffDelayTime(LEM_MAX_SCREEN_OFF_DELAY_TIME);
      this.registerPowerKeyDown();
    } else {
      SCBScreenSessionManager.getInstance().setScreenOffDelayTime(MAX_SCREEN_OFF_DELAY_TIME);
    }
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    try {
      display.off('foldStatusChange', this._foldStatusChangeListener);
    } catch (error) {
      log.showError(`foldStatusChange off failed. code ${error.code}`);
    }

    // 取消监听一镜到底
    OneMirrorService.getInstance().unRegisterObserver(this._oneMirrorListener);

    // 取消监听锁定状态
    ScreenLockStateManager.getInstance().unRegisterObserver(this.screenLockStateChangeListener);
  }

  /**
   * 处理外屏灭屏
   *
   * @param finishCallback 结束回调
   */
  private doOuterHomeScreenOff(finishCallback?: FinishCallback): void {
    let screenOffDelay: number = 0;
    let finishId: number = finishCallback?.getId() ?? 0;
    this.getScreenOffDelayOfOuterHome() // 此处触发副屏熄屏动效
      .then((value) => {
        screenOffDelay = value;
      })
      .catch(() => {
        log.showError('doOuterHomeScreenOff encounter error.');
        screenOffDelay = 0;
      })
      .finally(() => {
        log.showInfo(`doOuterHomeScreenOff, delay ${screenOffDelay} ms`);
        this._timerId = setTimeout(() => {
          this._timerId = INVALID_TIMER_ID;
          if (ScreenOnOffMediator.ableToSendScreenOffNotifyEvent) {
            log.showInfo(`doOuterHomeScreenOff, NOTIFY_OFF_SCREEN_CLOSE_LCD`);
            SCBScreenSessionManager.getInstance().notifyScreenLockEvent(NOTIFY_OFF_SCREEN_CLOSE_LCD);
          }
          finishCallback?.finish(finishId);
        }, screenOffDelay);
      })
  }

  /**
   * 清理外屏定时任务
   */
  private clearTimer(): void {
    if (this._timerId !== INVALID_TIMER_ID) {
      clearTimeout(this._timerId);
      this._timerId = INVALID_TIMER_ID;
    }
  }

  /**
   * 注册Power键按下事件
   */
  private registerPowerKeyDown(): void {
    this._multimodalInputPowerModule?.registerPowerKeyDown();
    log.showInfo('registerPowerKeyDown end');
  }

  /**
   * 注销Power键按下事件
   */
  private unRegisterPowerKeyDown(): void {
    this._multimodalInputPowerModule?.unRegisterPowerKeyDown();
    log.showInfo('unRegisterPowerKeyDown end');
  }

  private getScreenOffDelayOfOuterHome(): Promise<number> {
    return new Promise((resolve, reject) => {
      let serviceAbility = new OuterHomeRemoteService(GlobalContext.getContext());
      serviceAbility.getProxy()
        .then((proxy: IdlOuterHomeServiceProxy) => {
          proxy.getScreenOffDelayOfOuterHome((_code: number, value: number) => {
            resolve(value);
            serviceAbility.disConnect();
          });
        })
        .catch((err: Error) => {
          log.showError('getScreenOffDelayOfOuterHome error.');
          serviceAbility.disConnect();
          return reject(err);
        });
    });
  }

  private updateFoldDisplayMode(foldStatus?: display.FoldStatus): void {
    try {
      const curFoldStatus: display.FoldStatus = foldStatus ?? display.getFoldStatus();
      const newIsFoldFullDisplay: boolean = curFoldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED;
      this.handleSinglePocketExpandAndFold(curFoldStatus);
      if (this._isFoldFullDisplay !== newIsFoldFullDisplay) {
        this._isFoldFullDisplay = newIsFoldFullDisplay;
        this.onFoldFullDisplayChange();
      }
    } catch (error) {
      log.showError(`updateFoldDisplayMode failed. code ${error.code}`);
    }
  }

  private onFoldFullDisplayChange(): void {
    log.showInfo(`onFoldFullDisplayChange isInOuterScreen: ${!this._isFoldFullDisplay}`);
    if (!this._isFoldFullDisplay) {
      // 折叠态下, 延长系统保底灭屏时间, 以完整播放外屏灭屏动效
      SCBScreenSessionManager.getInstance().setScreenOffDelayTime(LEM_MAX_SCREEN_OFF_DELAY_TIME);
      this.registerPowerKeyDown();
    } else {
      SCBScreenSessionManager.getInstance().setScreenOffDelayTime(MAX_SCREEN_OFF_DELAY_TIME);
      this.unRegisterPowerKeyDown();
    }
  }

  private handleSinglePocketExpandAndFold(foldStatus: display.FoldStatus): void {
    if (!DeviceHelper.isSmallFoldProduct()) {
      return;
    }
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.fsmProxy?.submitCoreEvent(CoreEventType.REQUEST_LOCK);
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, false, false, 'outerExpandToFold');
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, true, 'outerFoldToExpand');
    }
  }
}