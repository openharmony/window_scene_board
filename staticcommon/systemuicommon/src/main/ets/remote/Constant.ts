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

export enum RequestType {
  SETTING_MAINTENANCE = 0,
}

export class NotificationIpc {
  /**
   * 通知中心打点通信标识
   */
  static readonly KEY: string = 'type';
  /**
   * 通知中心打点通信标识
   */
  static readonly VALUE: string = 'notification_ipc';
  /**
   * 连接包名
   */
  static readonly BUNDLE_NAME: string = 'com.ohos.sceneboard';
  /**
   * 连接ability名
   */
  static readonly ABILITY_NAME: string = 'com.ohos.sceneboard.MainAbility';
  /**
   * 接口鉴权令牌
   */
  static readonly INTERFACE_TOKEN: string = 'notification';
  /**
   * ipc请求调用的消息码
   */
  static readonly SEND_MESSAGE_REQUEST_CODE: number = 1;
}

export class SettingMaintenance {
  errorCode?: number;
  desc?: string;
  stack?: string;
  tag?: string;
}