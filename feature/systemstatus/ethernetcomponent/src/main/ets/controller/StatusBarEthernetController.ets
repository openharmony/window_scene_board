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
import { LogDomain, LogHelper, SingletonHelper, AppStorageUtil } from '@ohos/basicutils';
import { EvtBus, PluginSlot, PluginRequestEvent } from '@ohos/frameworkwrapper';
import { EthernetData } from './../common/Constants';
import connection from '@ohos.net.connection';
import { WifiUtils } from '@ohos/wificomponent/src/main/ets/default/utils/WifiUtils';
import { BaseController } from '@ohos/controlcentercommon/Index';

const TAG = 'Model.EthernetController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class StatusBarEthernetController extends BaseController<EthernetData> {
  public static get = SingletonHelper.createFactory(() => new StatusBarEthernetController);
  private mEthernetData: EthernetData = new EthernetData();
  private ethernetCon: connection.NetConnection = connection.createNetConnection({
    netCapabilities: {
      bearerTypes: [connection.NetBearType.BEARER_ETHERNET]
    }
  });

  constructor() {
    super();
    this.onStart();
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    // 订阅有线网络以太网事件。
    this.ethernetCon.register(() => {
      log.showInfo('register ethernetCon.');
    });
    this.ethernetCon.on('netCapabilitiesChange', this.onEthernetCapabilitiesChange);
    this.ethernetCon.on('netLost', this.onEthernetNetLost);
  }

  onStop(): void {
    this.ethernetCon.unregister(() => {
      log.showInfo('unregister ethernetCon.');
    });
    super.onStop();
  }

  getData(): EthernetData {
    return this.mEthernetData;
  }

  isAvailable(): boolean {
    return true;
  }

  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_ETHERNET;
  }

  public onEthernetCapabilitiesChange = (data: connection.NetCapabilityInfo): void => {
    let caps = data?.netCap?.networkCap;
    let types = data?.netCap?.bearerTypes;
    log.showWarn('onEthernetCapabilitiesChange');
    if (WifiUtils.isBearerEthernet(types)) {
      // 判断当前以太网是否连通，以太网连通则状态栏WIFI图标优先显示以太网有线连接图标
      const isEthernetAvailable = WifiUtils.isEthernetNetworkValidated(caps);
      log.showWarn(`isEthernetAvailable: ${isEthernetAvailable}`);
      AppStorageUtil.setOrCreate('isEthernetNetworkValidated', isEthernetAvailable);
      this.handleStatusBarState(true);
      return;
    }
    this.handleStatusBarState(false);
  };

  public onEthernetNetLost = (data: connection.NetHandle): void => {
    // 断网后将网络标记为不可用，刷新图标
    log.showWarn('onEthernetNetLost');
    AppStorageUtil.setOrCreate('isEthernetNetworkValidated', false);
    this.handleStatusBarState(false);
  };

  private handleStatusBarState(newState: boolean): void {
    this.mEthernetData.isConnected = newState;
    let oldState = this.sbPluginRequest.isVisible();
    log.showInfo(`StatusBarEthernet status change, newState: ${newState}, oldState: ${oldState}`);
    if (oldState !== newState) {
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

}

