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
import { call, observer } from '@kit.TelephonyKit';
import { GestureDockViewParam } from '../viewdata/GestureDockParam';
import GestureDockViewDataMgr from '../viewdata/GestureDockViewDataMgr';
import { GestureDockBarViewModel } from '../../../dockbar/viewmodel/GestureDockBarViewModel';

const TAG = 'CallStateHandler';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 来电监听处理器
 */
export class CallStateHandler {
  private dockBarViewModel: GestureDockBarViewModel = GestureDockBarViewModel.getInstance();
  private viewDataMgr: GestureDockViewDataMgr;
  private gestureDockParam: GestureDockViewParam;

  /**
   * 构造器
   *
   * @param viewDataMgr 数据管理
   */
  constructor(viewDataMgr: GestureDockViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.gestureDockParam = this.viewDataMgr.gestureDockParam;
  }

  private callStateChangeCallback: (data: observer.CallStateInfo) => void = (data: observer.CallStateInfo) => {
    log.showInfo(`[${TAG}] on callStateChange, data: ${data.state};isShowAllApps: ${this.gestureDockParam.isShowAllApps}`);
    if (data.state === call.CallState.CALL_STATE_RINGING && this.gestureDockParam.isShowAllApps) {
      // 新来电,并且allApps处于打开状态,则直接关闭allApps
      this.gestureDockParam.isShowAllApps = false;
      this.dockBarViewModel.getViewEvent()?.doRestPositionAnimate(this.gestureDockParam.gestureDockDirection, false);
      log.showInfo(`[${TAG}] close allApps isShowAllApps: ${this.gestureDockParam.isShowAllApps}`);
    }
  }

  /**
   * 订阅通话状态变化事件
   */
  public subscribeCallStateChange(): void {
    log.showInfo(`[${TAG}] subscribe call state change event`);
    try {
      observer.on('callStateChange', this.callStateChangeCallback);
    } catch (err) {
      log.showError(`subscribe call state observer, err: ${err.code}, err: ${err.message}`);
    }
  }

  /**
   * 取消订阅通话状态变化事件
   */
  public unSubscribeCallStateChange(): void {
    log.showInfo(`[${TAG}] unsubscribe call state change event`);
    try {
      observer.off('callStateChange', this.callStateChangeCallback);
    } catch (err) {
      log.showError(`unsubscribe call state observer, err: ${err.code}, err: ${err.message}`);
    }
  }
}