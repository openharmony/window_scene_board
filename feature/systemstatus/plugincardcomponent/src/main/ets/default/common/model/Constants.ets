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
export default class Constants {
  public static readonly LOTTIE_DATA_CONNECT: string = 'connecting.json';
  public static readonly LOTTIE_DATA_CONNECT_DARK: string = 'connecting_dark.json';
  public static readonly LOTTIE_DATA_DISCONNECT: string = 'disconnecting.json';
  public static readonly LOTTIE_DATA_DISCONNECT_DARK: string = 'disconnecting_dark.json';
  public static readonly SUPER_DEVICE_BUNDLE_NAME = 'com.ohos.superdevice';
  public static readonly PUBLISH_EVENT_DIALOG_SHOW: string = 'superdevice.event.CAST_DIALOG_SHOW';
  public static readonly PUBLISH_EVENT_CLOSE_SUB_WINDOW: string = 'superdevice.event.CLOSE_SUB_WINDOW';
  public static readonly PUBLISH_EVENT_OPEN_DIALOG: string = 'superdevice.event.CLOSE_SUB_WINDOW_AND_OPEN_DIALOG';
  public static readonly PUBLISH_EVENT_OPEN_SUB_WINDOW: string = 'superdevice.event.OPEN_SUB_WINDOW';
  public static readonly DIALOG_DEFAULT: number = 0;
  public static readonly DIALOG_ACCOUNT: number = -200001;
  public static readonly DIALOG_WIFI_BLUETOOTH: number = -200002;
  public static readonly DIALOG_SWITCH_STATUS: number = -200003;
  public static readonly PHONE_DIALOG_WIFI: number = -200004;
  public static readonly PHONE_DIALOG_WIFI_LIST: number = -200005;
  public static readonly REPORT_DIALOG_SHOW: number = 0;
  public static readonly REPORT_DIALOG_CONFIRM: number = 1;
  public static readonly REPORT_DIALOG_CANCEL: number = 2;
  public static readonly LOGIN = 1;
  public static readonly LOGOUT = 0;
  public static readonly LIST_HEIGHT = 398;
  public static readonly INVALID_ID = -1;
  public static readonly MAX_FONT_SIZE = 14;
  public static readonly MIN_FONT_SIZE = 12;
  public static readonly STATE_KEY = 'super_device_status';
  public static readonly SUPER_DEVICE_ENTRY = 'super_device_entry';
  public static readonly STATE_OFF_FLAG = '0';
  public static readonly STATE_ON_FLAG = '1';
  public static readonly CONTROLLER_INIT_EVENT = 155555;
  public static readonly REPORT_CLICK_SUPER_DEVICE_ITEM = 'clickSuperDeviceItem';
  public static readonly REPORT_LONG_CLICK_DEVICE_EVENT = 'longClickDevice';
  public static readonly REPORT_CLICK_SAME_DEVICE = 'clickSameDevice';
  public static readonly REPORT_CLICK_OTHER_POS = 'clickOtherPos';
  public static readonly REPORT_COLLABORATION_SUCCEED = 0;
  public static readonly REPORT_COLLABORATION_FAIL = -1;
  public static readonly REPORT_TRIGGER_LOCATION = 'pluginCard';
  public static readonly REPORT_HAS_DEVICE = 1;
  public static readonly REPORT_HAS_NOT_DEVICE = 0;
  public static readonly PHONE = 'PHONE';
  public static readonly PC = 'PC';
  public static readonly INI = '2IN1';
  public static readonly PAD = 'PAD';
  public static readonly AUDIO = 'AUDIO';
  public static readonly HEADSET = 'HEADSET';
  public static readonly SPEAKER = 'SPEAKER';
  public static readonly REPORT_CLICK_OPEN_WLANANDBLUETOOTH = 1;
  public static readonly REPORT_CLICK_OPEN_WLAN = 1;
  public static readonly REPORT_CLICK_OPEN_BLUETOOTH = 1;
  public static readonly REPORT_CLICK_OPEN_HWACCOUNT = 1;
  public static readonly REPORT_CLICK_HELP = 1;
  public static readonly ENTER_LIST_PAGE: string = 'ENTER_LIST_PAGE';
  public static readonly PHONE_PC_COLLABORATION: string = 'PHONE_PC_COLLABORATION';
  public static readonly CANCEL_PHONE_PC_COLLABORATION: string = 'CANCEL_PHONE_PC_COLLABORATION';
  public static readonly PHONE_PAD_COLLABORATION: string = 'PHONE_PAD_COLLABORATION';
  public static readonly CANCEL_PHONE_PAD_COLLABORATION: string = 'CANCEL_PHONE_PAD_COLLABORATION';
  public static readonly AUDIO_COLLABORATION: string = 'AUDIO_COLLABORATION';
  public static readonly CANCEL_AUDIO_COLLABORATION: string = 'CANCEL_AUDIO_COLLABORATION';
  public static readonly CLICK_OPEN_WLANANDBLUETOOTH: string = 'CLICK_OPEN_WLANANDBLUETOOTH';
  public static readonly CLICK_OPEN_WLAN: string = 'CLICK_OPEN_WLAN';
  public static readonly CLICK_OPEN_BLUETOOTH: string = 'CLICK_OPEN_BLUETOOTH';
  public static readonly CLICK_OPEN_HWACCOUNT: string = 'CLICK_OPEN_HWACCOUNT';
  public static readonly SUPER_DEVICE_UE_DOMAIN: string = 'SUPERDEVICE_UE';
  public static readonly SCENE_BOARD_BUNDLE_NAME: string = 'com.ohos.sceneboard';
  public static readonly DEVICE_ITEM_ID: string = 'deviceContentItem';
  public static readonly SUPER_DEVICE_PACKAGE_NAME: string = 'com.ohos.superdevice';
  /**
   * 多设备协同-三态开关
   */
  public static readonly COLLABORATION_SERVICE_SWITCH = 'settings.collaboration.multi_device_collaboration_service_switch';

  /**
   * 多设备协同-三态开关 开关开启状态
   */
  public static readonly COLLABORATION_SERVICE_SWITCH_ON: string = '1';

  /**
   * 多设备协同-三态开关 开关关闭状态
   */
  public static readonly COLLABORATION_SERVICE_SWITCH_OFF: string = '0';

  /**
   * 通知超级终端打开WLAN弹窗
   */
  public static readonly OPEN_WLAN_DIALOG: string = 'OPEN_WLAN_DIALOG';

  /**
   * 超级终端侧通知大桌面发起协同
   */
  public static readonly START_CONTINUITY: string = 'START_CONTINUITY';
}

/**
 * 当前所处页面
 */
export enum ControlCenterState {
  MAIN_LAYOUT,
  TOGGLE_EDIT,
  SUB_PANEL,
  IOT_SUB_PAGE,
  PRIVACY_SUB_PAGE,
  MEDIA_CENTER,
  SOUND_SUB_PAGE,
  BRIGHTNESS_SUBPAGE,
  MULTIMEDIA_SUB_PAGE
}

export enum ServerConnectState {
  INIT_PAGE,
  CONNECTED,
  DISCONNECTED
}