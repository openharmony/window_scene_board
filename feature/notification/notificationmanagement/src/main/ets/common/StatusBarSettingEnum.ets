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
import { SettingsKeyConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';

// Image图标资源
export const ICON_INFO: Map<SettingsKeyConstants, Resource> = new Map([
  [SettingsKeyConstants.SHOW_NEARLINK_ICON, $r('app.media.nearlink')],
]);

// SymbolGlyph图标资源
export const SYMBOL_ICON_INFO: Map<SettingsKeyConstants, Resource> = new Map([
  [SettingsKeyConstants.SHOW_VPN_ICON, $r('sys.symbol.vpn_key')],
  [SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON, $r('sys.symbol.alarm_fill')],
  [SettingsKeyConstants.SHOW_NFC_ICON, $r('sys.symbol.nfc_fill')],
  [SettingsKeyConstants.SHOW_HEAD_PHONES_ICON, $r('sys.symbol.headphones_fill')],
  [SettingsKeyConstants.SHOW_RING_MODE_ICON, $r('sys.symbol.bell_slash_fill')],
]);

// 描述资源
export const DESCRIPTION_INFO: Map<SettingsKeyConstants, Resource> = new Map([
  [SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON, $r('app.string.enable_switch_notification_icon')],
  [SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED, $r('app.string.enable_switch_net_speed')],
  [SettingsKeyConstants.SHOW_VPN_ICON, $r('app.string.enable_switch_vpn')],
  [SettingsKeyConstants.SHOW_RING_MODE_ICON, $r('app.string.enable_switch_ring_mode')],
  [SettingsKeyConstants.SHOW_NEARLINK_ICON, $r('app.string.enable_switch_nearlink')],
  [SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON, $r('app.string.enable_switch_alarm_clock')],
  [SettingsKeyConstants.SHOW_NFC_ICON, $r('app.string.enable_switch_nfc')],
  [SettingsKeyConstants.SHOW_HEAD_PHONES_ICON, $r('app.string.enable_switch_head_phones')],
]);

// 相关开关的默认值
export const SWITCH_DEFAULT: Map<SettingsKeyConstants, boolean> = new Map([
  [SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON, true],
  [SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED, false],
  [SettingsKeyConstants.SHOW_VPN_ICON, true],
  [SettingsKeyConstants.SHOW_RING_MODE_ICON, true],
  [SettingsKeyConstants.SHOW_NEARLINK_ICON, true],
  [SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON, true],
  [SettingsKeyConstants.SHOW_NFC_ICON, false],
  [SettingsKeyConstants.SHOW_HEAD_PHONES_ICON, false],
]);

// 开关打点事件名称映射
export const USER_BEHAVIOR_KEY: Map<SettingsKeyConstants, string> = new Map([
  [SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON, 'NTF'],
  [SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED, 'NET_SPEED_ENABLE'],
  [SettingsKeyConstants.SHOW_VPN_ICON, 'VPN_ENABLE'],
  [SettingsKeyConstants.SHOW_RING_MODE_ICON, 'RING_MODE_ENABLE'],
  [SettingsKeyConstants.SHOW_NEARLINK_ICON, 'NEARLINK_BLE_ENABLE'],
  [SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON, 'ALARM_CLOCK_ENABLE'],
  [SettingsKeyConstants.SHOW_NFC_ICON, 'NFC_ENABLE'],
  [SettingsKeyConstants.SHOW_HEAD_PHONES_ICON, 'HEAD_PHONES_ENABLE'],
])

export const INTENT_SWITCH: SettingsKeyConstants[] = [
  SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED,
  SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON,
]