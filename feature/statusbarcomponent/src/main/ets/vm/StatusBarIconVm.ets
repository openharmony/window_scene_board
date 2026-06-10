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
import { PluginInfo, PluginSlot } from '@ohos/frameworkwrapper';
import BatteryIcon from '@ohos/batterycomponent/src/main/ets/default/pages/batteryIcon';
import StatusBarIconItemBluetoothComponent
  from '@ohos/bluetoothcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemBluetoothComponent';
import StatusBarIconItemEarPhoneComponent
  from '@ohos/earphonecomponent/src/main/ets/default/pages/StatusBarIconItemEarPhoneComponent';
import StatusBarIconItemHotSpotComponent
  from '@ohos/hotspotcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemHotSpotComponent';
import StatusBarNetspeed from '@ohos/linkspeedcomponent/src/main/ets/default/pages/StatusBarNetspeed';
import StatusBarIconItemLocationComponent
  from '@ohos/locationcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemLocationComponent';
import StatusBarIconItemNFCModeComponent
  from '@ohos/nfccomponent/src/main/ets/com/ohos/pages/StatusBarIconItemNFComponent';
import StatusBarIconItemRingModeComponent
  from '@ohos/ringmodecomponent/src/main/ets/com/ohos/pages/StatusBarIconItemRingModeComponent';
import SignalIcon from '@ohos/signalcomponent/src/main/ets/default/pages/signalIcon';
import StatusBarStarFlashComponent from '@ohos/starflashcomponent/src/main/ets/pages/StatusBarStarFlashComponent';
import StatusBarFocusModeComponent
  from '@ohos/statusbarfocusmodecomponent/src/main/ets/pages/StatusBarFocusModeComponent';
import StatusBarSuperPrivacyComponent
  from '@ohos/statusbarsuperprivacycomponent/src/main/ets/pages/Statusbarsuperprivacycomponent';
import lazy StatusBarEthernetComponent from '@ohos/ethernetcomponent/src/main/ets/pages/StatusBarEthernetComponent';
import { StatusBarVmInjector } from '@ohos/systemuicommon/newIndex';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { RealTimeNetworkSpeedEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import StatusBarVpnComponent from '@ohos/vpncomponent/src/main/ets/pages/StatusBarVpnComponent';
import StatusBarAlarmClockComponent from '@ohos/customcomponent/src/main/ets/pages/StatusBarAlarmClockComponent';
import WifiIcon from '@ohos/wificomponent/src/main/ets/default/pages/wifiIcon';
import { StatusBarIconView } from '../view/StatusBarIconView';
import { StatusBarIconBaseVm } from './StatusBarIconBaseVm';
import signalOperatorInfo from '@ohos/signalcomponent/src/main/ets/default/pages/signalOperatorInfo';
// instrument ignore file

const TAG = 'StatusBarIconVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarIconVm extends StatusBarIconBaseVm {
  // 常驻显示的图标，直接置为true
  public static readonly defaultSwitchOnIcons: string[] = [PluginSlot.SLOT_STATUS_BATTERY,
    PluginSlot.SLOT_STATUS_SIGNAL, PluginSlot.SLOT_STATUS_OPERATOR];
  // 在默认状态栏类型下不显示的图标类似
  public static readonly defaultStatusBarTypeVisible: string[] = [PluginSlot.SLOT_STATUS_OPERATOR];

  initIcon(): void {

  }

  getBuilder(): WrappedBuilder<[PluginInfo]> {
    return wrapBuilder(operatorIconBuilder);
  }

  getIsOnTheTree(): boolean {
    return true;
  }
}

@Builder
function operatorIconBuilder(pluginInfo: PluginInfo) {
  StatusBarIconView({ pluginInfo: pluginInfo }) {
    if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_VPN) {
      StatusBarVpnComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_STAR_FLASH) {
      StatusBarStarFlashComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_EARPHONE) {
      StatusBarIconItemEarPhoneComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_NFC) {
      StatusBarIconItemNFCModeComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_BLE) {
      StatusBarIconItemBluetoothComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_SUPER_PRIVACY) {
      StatusBarSuperPrivacyComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_LOCATION) {
      StatusBarIconItemLocationComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_DO_NOT_DISTURB) {
      StatusBarFocusModeComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_RING) {
      StatusBarIconItemRingModeComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_NET_SPEED) {
      StatusBarNetspeed();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_HOT_SPOT) {
      StatusBarIconItemHotSpotComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_WIFI) {
      WifiIcon();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_SIGNAL) {
      SignalIcon();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_BATTERY) {
      BatteryIcon();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_OPERATOR) {
      signalOperatorInfo();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_ALARM_CLOCK) {
      StatusBarAlarmClockComponent();
    } else if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_ETHERNET) {
      StatusBarEthernetComponent();
    }
  }
}