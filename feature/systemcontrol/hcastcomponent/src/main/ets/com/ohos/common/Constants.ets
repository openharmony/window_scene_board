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

export default class Constants {
  public static readonly CAST_BUNDLE_NAME: string = 'com.ohos.cast';
  public static readonly CONTROL_CENTER_CLICK_CODE: number = 1002;
  public static readonly CONTROL_CENTER_PHONE_CLICK_CODE: number = 1006;
  public static readonly CAST_PRIVACY_VERSION: string = 'wireless_projection_privacy_agree';
  public static readonly CONTROL_CENTER_RESHOW_PRIVACY: string = 'need_reshow_projection_privacy';
  public static readonly PUBLISH_EVENT_CAST_CONNECTED: string = 'cast.event.CAST_CONNECTED';
  public static readonly PUBLISH_EVENT_CAST_DISCONNECTED: string = 'cast.event.CAST_DISCONNECTED';
  public static readonly PUBLISH_EVENT_CAST_DISCONNECT_DEVICE: string = 'cast.event.DISCONNECT_DEVICE';
  public static readonly PUBLISH_EVENT_GET_CONNECT_STATE: string = 'cast.event.CAST_GET_CONNECT_STATE';
  public static readonly PUBLISH_EVENT_CLOSE_CAST_DIALOG: string = 'cast.event.CLOSE_CAST_DIALOG';
  public static readonly PUBLISH_PERMISSION_MIRROR: string = 'ohos.permission.ACCESS_CAST_ENGINE_MIRROR';
  public static readonly PRIVACY_VERSION_DEFAULT: string = '0';
  public static readonly PRIVACY_VERSION_NEWEST: string = '1';
  public static readonly PUBLISH_EVENT_DIALOG_SHOW: string = 'cast.event.CAST_DIALOG_SHOW';
  public static readonly PUBLISH_EVENT_CLOSE_SUB_WINDOW: string = 'cast.event.CLOSE_SUB_WINDOW';
  public static readonly PUBLISH_EVENT_OPEN_SUB_WINDOW: string = 'cast.event.OPEN_SUB_WINDOW';
  public static readonly DIALOG_DEFAULT: number = 0;
  public static readonly DIALOG_PRIVACY: number = -100001;
  public static readonly DIALOG_WIFI_BLUETOOTH: number = -100002;
  public static readonly LAST_CONNECTED_DEV_ID: string = 'last_connected_device_id';
  public static readonly REPORT_DIALOG_SHOW: number = 0;
  public static readonly REPORT_DIALOG_CONFIRM: number = 1;
  public static readonly REPORT_DIALOG_CANCEL: number = 2;
  public static readonly MAX_RETRY_CONNECT_TIMES: number = 3;
  public static readonly TIBETAN_LANGUAGES: string[] = ['bo'];
}