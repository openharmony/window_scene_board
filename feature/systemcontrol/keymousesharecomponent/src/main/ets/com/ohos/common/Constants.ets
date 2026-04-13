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
  public static readonly KEYMOUSE_SHARE_BUNDLE_NAME: string = 'com.openharmony.associateassistant';
  public static readonly CONTROL_CENTER_CLICK_CODE: number = 16;
  public static readonly CONTROL_CENTER_RESHOW_PRIVACY: string = 'need_reshow_projection_privacy';
  public static readonly PUBLISH_EVENT_CAST_CONNECTED: string = 'key.mouse.event.connected';
  public static readonly PUBLISH_EVENT_CAST_DISCONNECTED: string = 'key.mouse.event.disconnected';
  public static readonly PUBLISH_EVENT_GET_CONNECT_STATE: string = 'key.mouse.event.get.connect.state';
  public static readonly PRIVACY_VERSION_DEFAULT: string = '0';
  public static readonly PRIVACY_VERSION_NEWEST: string = '1';
  public static readonly PUBLISH_EVENT_CLOSE_SUB_WINDOW: string = 'key.mouse.event.CLOSE_SUB_WINDOW';
  public static readonly CAST_EVENT_CLOSE_PENAL: number = 31;
  public static readonly MAX_RETRY_CONNECT_TIMES: number = 3;
  public static readonly KEY_MOUSE_SERVICE_DESCRIPTOR = 'com.openharmony.associateassistant.KeyMouseManager';
}