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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSCBOobeManager, SCBScreenSessionManager } from '@ohos/windowscene';
import {
  PowerUtils,
  ScreenOnOffListener,
  ScreenOnOffService,
  VerifyDataManager,
  WakeUpReason
} from '@ohos/screenlockcommon';
import { CoreEventType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { SoEventType, SoStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenOffFsm';
import { AbstractEventAdapter } from './AbstractEventAdapter';
import { AodSlideAdapter } from './AodSlideAdapter';

const TAG = 'PowerEventAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 电源事件适配器
 */
export class PowerEventAdapter extends AbstractEventAdapter {
  private readonly _aodSlideAdapter: AodSlideAdapter;
  private readonly _powerStateChangeListener: ScreenOnOffListener = {
    onPreBright: this.handlePreBright.bind(this),
    onPreBrightFailSleep: this.handlePreBrightFailSleep.bind(this),
    onBeginWakeUp: this.handleBeginWakeUp.bind(this),
    onBeginDisplayOn: this.handleBeginDisplayOn.bind(this),
    onEndDisplayOn: this.handleEndDisplayOn.bind(this),
    onBeginSleep: this.handleBeginSleep.bind(this),
    onEndSleep: this.handleEndSleep.bind(this),
  };

  constructor(fsmProxy: ScreenLockFsmProxy) {
    super(fsmProxy);
    this._aodSlideAdapter = new AodSlideAdapter(fsmProxy);
  }

  protected doInit(): void {
    log.showInfo('doInit');
    ScreenOnOffService.getInstance().registerObserver(this._powerStateChangeListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    ScreenOnOffService.getInstance().unRegisterObserver(this._powerStateChangeListener);
  }

  private handlePreBright(): void {
    log.showInfo('onPreBright.');
    if (CoreStateTypeUtils.isInScreenOff(this.fsmProxy.coreFsm.currentStateType)) {
      this.fsmProxy.submitAodEvent(SoEventType.PRE_BRIGHT);
    }
  }

  private handlePreBrightFailSleep(): void {
    log.showInfo('onPreBrightFailSleep.');
    if (CoreStateTypeUtils.isInScreenOff(this.fsmProxy.coreFsm.currentStateType)) {
      this.fsmProxy.submitAodEvent(SoEventType.PRE_BRIGHT_FAIL_SLEEP);
    }
  }

  private handleBeginWakeUp(reason: WakeUpReason): void {
    if (sSCBOobeManager.isEnable() && VerifyDataManager.getInstance().hasNoPwd) {
      log.showInfo('onBeginWakeUp encounter no pwd, unlock direct.');
      this.fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
      return;
    }

    if (reason !== WakeUpReason.AOD_SLIDING) {
      return;
    }
    this._aodSlideAdapter.handleAodSlide();
  }

  private handleBeginDisplayOn(): void {
  }

  private handleEndDisplayOn(): void {
    log.showInfo('onEndDisplayOn.');
    this.fsmProxy.submitCoreEvent(CoreEventType.SCREEN_ON);
  }

  private handleBeginSleep(): void {
    if (sSCBOobeManager.isEnable() && VerifyDataManager.getInstance().hasNoPwd &&
      CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
      log.showInfo('onBeginSleep encounter no pwd and in oobe, do nothing.');
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.NOTIFY_OFF_SCREEN_CLOSE_LCD);
    } else {
      log.showInfo('onBeginSleep.');
      this.fsmProxy.submitCoreEvent(CoreEventType.PRE_SCREEN_OFF);
    }
  }

  private handleEndSleep(): void {
    if (sSCBOobeManager.isEnable() && VerifyDataManager.getInstance().hasNoPwd &&
      CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
      log.showInfo('onEndSleep encounter no pwd and in oobe, do nothing.');
    } else {
      log.showInfo(`onEndSleep. power State: ${PowerUtils.isActive()}`);
      this.fsmProxy.submitCoreEvent(CoreEventType.SCREEN_OFF);
    }
  }
}