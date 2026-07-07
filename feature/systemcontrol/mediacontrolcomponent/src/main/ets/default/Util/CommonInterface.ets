/**
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import AVSessionManager from '@ohos.multimedia.avsession';

export interface VolumeInfo {
  type : string;
  value: number;
}

export interface SessionController {
  type: string;
  controller?:  AVSessionManager.AVSessionController;
}

export interface MessageInfo {
  code : number;
  msg : string;
}

export interface DeviceSession {
  sessionId : string;
  device : AVSessionManager.OutputDeviceInfo;
  connectState: AVSessionManager.ConnectionState;
}

export interface AVState {
  type: string;
  value : AVSessionManager.AVPlaybackState;
}

export interface SongInfo {
  songName?: string
  songArtist?: string
}

export interface DfxParam {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGE_NAME?: string;
  DEVICE_NAME?: string;
  TIME_COST?: number;
  REASON?: string;
  COLD_START?: boolean;
  VOLUME?: number;
  OPERATE_TYPE?: string;
  PREV_DEVICE_TYPE?: number;
  DEVICE_TYPE?: number;
  LIST?: string;
  APP_TYPE?: string;
  CONTROL_MODE?: number;
  TIP_CODE?: string;
  TIP_TYPE?: string;
  PROTOCOL?: string;
  CONTROL_TIME?: number;
  CONTROLINTERFACE?: number;
  DEVICEMODELTYPE?: string;
  TIME?: number;
  SCREENSTATUS?: number;
  SCREENFOLDEDSTATUS?: number;
  AVQUEUE_ID?: string;
  AVQUEUE_NAME?: string;
  PREV_DEVICE_NAME?: string;
  SUPPORTACTION?: string[],
  PREV_PROTOCOL?: string,
  CONTROL_RESULT?: string,
  PACKAGE_VERSION?: string,
  CONTROL_APP_VERSION_NAME?: string,
  CONTROL_BUNDLE_NAME?: string,
  SUPPORT_DURATION?: boolean,
  PICKER_STYLE?: string
  SHOW_STATE?: number;
  IS_HISTORY_AVQUEUE?: boolean;
  OPERATING_MODE?: number;
}

export interface DfxDevice {
  DEVICE_TYPE: number;
  DEVICE_NAME: string;
}

export interface RadarDevice {
  PEER_UDID: string;
  PEER_DEV_NAME: string;
  PEER_DEV_TYPE: number;
  PEER_BT_MAC?: string;
  PEER_NET_ID?: string;
}

export interface RadarParam {
  ORG_PKG?: string;
  HOST_PKG?: string; // 上游组织模块
  TO_CALL_PKG?: string;
  TRIGGER_MODE?: number;
  FUNC?: string;
  BIZ_SCENE?: number;
  BIZ_STAGE?: number;
  STAGE_RES?: number;
  BIZ_STATE?: number;
  ERROR_CODE?: number;
  DISCOVERY_DEVICE_LIST?: string;
  // 本端设备信息
  LOCAL_UDID?: string;
  LOCAL_NET_ID?: string;
  LOCAL_DEV_TYPE?: string;
  // 对端设备信息
  PEER_UDID?: string;
  PEER_NET_ID?: string;
  PEER_BT_MAC?: string;
  PEER_DEV_TYPE?: string;
  IS_TRUST?: number; // 是否可信
  // 通道信息
  LOCAL_SESS_NAME?: string;
  PEER_SESS_NAME?: string;
  CONTROL_TIME?: number;
  DEVICE_TYPE?: number;
  PROTOCOL?: string;
  APP_CALLER?: string; // 应用包名
  SERVICE_DURATION?: number; // 投播时长
  // 资源信息
  RESOURCE_TYPE?: string;
  RESOURCE_DURATION?: number;
}

export type PartialRadaParam = Partial<RadarParam>;
