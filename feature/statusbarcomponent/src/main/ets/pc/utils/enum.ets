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

/**
 * 状态栏类型
 */
export enum SCBStatusBarType {
  MAC_STATUS_BAR = 1,
  WINDOW_STATUS_BAR = 2,
}

/**
 * 产品类型
 */
export enum ProductType {
  KLV = 1,
  HAD = 2,
}

/**
 * 状态栏分区内分组
 */
export enum GroupInAreaType {
  DYNAMIC_LEFT = 1,
  FIRST_GROUP = 2,
  SECOND_GROUP = 3,
  THIRD_GROUP = 4,
  FOURTH_GROUP = 5,
  FIFTH_GROUP = 6,
  TEMPORARY = 7,
  TRAY = 8,
}

export enum StyleType {
  PLUGIN = 1,
  LOCAL_GROUP = 2,
  GROUP = 3,
  STATUS_BAR = 4,
}

export enum AudioDeviceType {
  INVALID = 0,
  EARPIECE = 1,
  SPEAKER = 2,
  WIRED_HEADSET = 3,
  WIRED_HEADPHONES = 4,
  BLUETOOTH_SCO = 7,
  BLUETOOTH_A2DP = 8,
  MIC = 15,
  USB_HEADSET = 22,
  DISPLAY_PORT = 23,
  REMOTE_CAST = 24,
  USB_DEVICE = 25,
  HDMI = 27,
  DEFAULT = 1000,
}

export enum TurboChargingStatus {
  TURBO_CHANGING_DEFAULT = '0',
  TURBO_CHANGING_PRE = '1',
  TURBO_CHANGING_START = '2'
}

export enum SCBFoldState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
};
