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

import WifiIcon from '@ohos/wificomponent/src/main/ets/default/pages/wifiIcon';
import { GlassStatusBarStyle } from './GlassStatusBarStyle';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import wifiManager from '@ohos.wifiManager';
import { WifiDetailState } from '@ohos/wificomponent/src/main/ets/default/common/Constants';
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'WlanIcon');

/**
 * WLAN: Wifi、HotPot
 */
@Component
export default struct WlanIcon {
  @State isWifiVisible: boolean = false;
  @Provide iconsOpacityInfo: Array<PluginSlot> = [];

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`)
    this.initPolicy();
    this.updateVisibleStatus();
  }

  private onWifiConnectionChange = (data: number): void => {
    this.isWifiVisible = data === 1 ? true : false;
  }
  private onWifiStateChange = (data: number) => {
    log.showInfo(`wifiStateChange data: ${data}`);
    let wifiCurState: WifiDetailState = this.getWifiDetailState();
    if (wifiCurState === WifiDetailState.STATE_UNKNOWN) {
      return;
    }
    if (wifiCurState === WifiDetailState.STATE_DEACTIVATING ||
      wifiCurState === WifiDetailState.STATE_SEMI_ACTIVATING) {
      this.isWifiVisible = false;
    }
    let currentIsConnected = wifiManager.isConnected();
    log.showInfo(`currentIsConnected: ${currentIsConnected},isConnected: ${this.isWifiVisible}`);
    if (this.isWifiVisible !== currentIsConnected) {
      this.isWifiVisible = currentIsConnected;
    }
  }

  private initPolicy(): void {
    log.showInfo(`initPolicy`);
    try {
      wifiManager.on('wifiConnectionChange', this.onWifiConnectionChange);
      wifiManager.on('wifiStateChange', this.onWifiStateChange);
    } catch (err) {
      log.showError(`initPolicy fail,error is ${err.message}`);
    }
  }

  private unInitPolicy(): void {
    log.showInfo(`unInitPolicy`);
    try {
      wifiManager.off('wifiConnectionChange');
      wifiManager.off('wifiStateChange');
    } catch (err) {
      log.showError(`unInitPolicy fail ,error is ${err.message}`);
    }
  }

  private getWifiDetailState(): WifiDetailState {
    log.showInfo(`getWifiDetailState`)
    let curState: WifiDetailState = WifiDetailState.STATE_UNKNOWN;
    let wifiCurState: number = WifiDetailState.STATE_UNKNOWN;
    try {
      wifiCurState = wifiManager.getWifiDetailState();
    } catch (error) {
      log.showError(`getWifiDetailState error:${error}`);
    }
    switch (wifiCurState) {
      case WifiDetailState.STATE_INACTIVE:
      case WifiDetailState.STATE_DEACTIVATING:
        curState = WifiDetailState.STATE_INACTIVE;
        break;
      case WifiDetailState.STATE_ACTIVE:
      case WifiDetailState.STATE_ACTIVATING:
        curState = WifiDetailState.STATE_ACTIVE;
        break;
      case WifiDetailState.STATE_SEMI_ACTIVE:
      case WifiDetailState.STATE_SEMI_ACTIVATING:
        curState = WifiDetailState.STATE_SEMI_ACTIVE;
        break;
      default:
        break;
    }
    return curState;
  }

  private updateVisibleStatus(): void {
    log.showInfo(`updateVisibleStatus`)
    this.isWifiVisible = wifiManager.isConnected();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.unInitPolicy();
  }

  build() {
    if (this.isWifiVisible) {
      WifiIcon({
        style: {
          statusBarWifiWidth: GlassStatusBarStyle.ICON_SIZE,
          statusBarWifiHeight: GlassStatusBarStyle.ICON_SIZE,
        }
      })
    }
  }
}