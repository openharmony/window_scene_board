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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  EvtBus,
  PluginSlot,
  PluginRequestEvent,
} from '@ohos/frameworkwrapper';
import { BaseController } from '@ohos/controlcentercommon/Index';
import { VpnData } from '../common/Constants';
import commonEventManager from '@ohos.commonEventManager';
// instrument ignore file
const TAG = 'Model.VpnController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const SLE_CONNECTION_STATE_CONNECTED = 0x01;
const PERMISSION_CONNECT: string = 'ohos.permission.GET_NETWORK_INFO';
const SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.VPN_CONNECTION_STATUS_CHANGED'
  ],
  publisherPermission: PERMISSION_CONNECT
};

export class VpnController extends BaseController<VpnData> {
  private mVpnData: VpnData = new VpnData();
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;

  constructor() {
    super();
    this.onStart();
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    // 监听连接
    try {
      this.subscribeVpnConnectedChangedEvent();
    } catch (error) {
      log.showError('subscribeVpnConnectedChangedEvent error');
    }
  }

  private async subscribeVpnConnectedChangedEvent(): Promise<void> {
    try {
      log.showInfo(`VpnConnectedChangedEvent`);
      this.mSubscriber = await commonEventManager.createSubscriber(SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mSubscriber, (err, data: commonEventManager.CommonEventData) => {
        if (err && err?.code !== 0) {
          log.showError(`Can't handle common event, err: ${err.message}`);
          return;
        }
        this.handleVpnConnectedChangedEvent(data);
      });
    } catch (error) {
      log.showError(`createSubscriber error: ${error.message}`);
    }
  }

  private handleVpnConnectedChangedEvent(data: commonEventManager.CommonEventData): void {
    log.showWarn(`receive vpn connected event data, event: ${data?.event}, state: ${data?.parameters?.state}`);
    if (data && SUBSCRIBE_INFO.events.indexOf(data.event) !== -1) {
      const state: number = data.parameters?.state;
      if (state === SLE_CONNECTION_STATE_CONNECTED) {
        this.onVpnStateChange(true);
      } else {
        this.onVpnStateChange(false);
      }
    }
  }

  onVpnStateChange(status: boolean): void {
    this.mVpnData.isConnected = status;
    this.handleStatusBarState(this.mVpnData.isConnected);
  }

  onStop(): void {
    super.onStop();
    try {
      if (this.mSubscriber) {
        commonEventManager.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      }
    } catch (error) {
      log.showError('unsubscribe vpn connected error');
    }
    log.showInfo('onStop');
  }

  getData(): VpnData {
    return this.mVpnData;
  }

  isAvailable(): boolean {
    return true;
  }

  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_VPN;
  }

  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    log.showInfo(`vpn status bar status change, newState: ${newState}, oldState: ${oldState}`);
    if (oldState !== newState) {
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }
}

let sVpnController = SingletonHelper.getInstance(VpnController, TAG);

export default sVpnController as VpnController;

