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
  ClockOneShortConsts,
  ScreenLockVerifyService,
  SimCardStateManager,
  slClockOneShotToDesktopService,
  VerifyDataManager,
  VerifyResult,
  VerifyStateListener
} from '@ohos/screenlockcommon';
import { FsmCallback } from '@ohos/screenlockcommon/Index';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { CoreEvent, CoreEventType, CoreStateType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';

const TAG = 'AodSlideAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * AOD滑动处理
 */
export class AodSlideAdapter {
  private readonly fsmProxy: ScreenLockFsmProxy;

  private readonly _coreStateListener: FsmCallback<CoreStateType, CoreEvent> = {
    onFsmStateChange: (oldState: CoreStateType, newState: CoreStateType): void => {
      log.showInfo(`onFsmStateChange: ${CoreStateType[oldState]} --> ${CoreStateType[newState]}`);
      if (CoreStateTypeUtils.isInMainPage(oldState) && !CoreStateTypeUtils.isInMainPage(newState)) {
        // 离开主页
        log.showInfo('leave main page.');
        VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isDirectUnlockOnce = false;
        this.unRegisterListeners();
      }
      log.showInfo('onFsmStateChange end');
    }
  };

  private readonly _verifyResultListener: VerifyStateListener = {
    onVerifyResult: (authType: AuthType, verifyResult: VerifyResult): void => {
      if (authType !== AuthType.FACE) {
        return;
      }
      log.showInfo(`face verify ${verifyResult}.`);
      if (verifyResult !== VerifyResult.SUCCESS) {
        VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isDirectUnlockOnce = false;
        this.unRegisterListeners();
      }
    }
  };

  constructor(fsmProxy: ScreenLockFsmProxy) {
    this.fsmProxy = fsmProxy;
  }

  public handleAodSlide(): void {
    if (SimCardStateManager.getInstance().isSimLocked()) {
      log.showInfo('AOD_SLIDING encounter sim locked.');
      this.fsmProxy.submitCoreEvent(CoreEventType.ADD_SIM_CARD);
    } else if (VerifyDataManager.getInstance().hasNoPwd) {
      // 无密码场景，直接解锁
      log.showInfo('AOD_SLIDING encounter hasNoPwd.');
      if (slClockOneShotToDesktopService.isClockAodToDesktopAnimAvailable()) {
        log.showInfo('doAodToDesktopClockAnim');
        slClockOneShotToDesktopService.requestDirectUnlock(
          ClockOneShortConsts.AOD_TO_DESKTOP_CLOCK_ANIMATION);
      } else {
        this.fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
      }
    } else {
      // 假AOD或灭屏下不能直接人脸解锁，导致无法判断人脸可用性，需要先下发亮屏事件
      this.fsmProxy.submitCoreEvent(CoreEventType.SCREEN_ON);
      if (ScreenLockVerifyService.getInstance().isCanVerify(AuthType.FACE)) {
        // 人脸可用状态，则人脸直接解锁
        log.showInfo('AOD_SLIDING encounter face state ok.');
        VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isDirectUnlockOnce = true;
        this.registerListeners();
      } else {
        // 有密码且人脸禁用或冻结时，则跳转密码页
        log.showInfo('AOD_SLIDING encounter face not support or locked.');
        this.fsmProxy.submitCoreEvent(CoreEventType.SLIDE_FROM_BOTTOM);
      }
    }
  }

  private registerListeners(): void {
    this.fsmProxy.coreFsm.registerObserver(this._coreStateListener, false);
    ScreenLockVerifyService.getInstance().registerObserver(this._verifyResultListener, false);
  }

  private unRegisterListeners(): void {
    this.fsmProxy.coreFsm.unRegisterObserver(this._coreStateListener);
    ScreenLockVerifyService.getInstance().unRegisterObserver(this._verifyResultListener);
  }
}