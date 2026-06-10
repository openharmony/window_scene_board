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

import avSession from '@ohos.multimedia.avsession';
import { Callback } from '@kit.BasicServicesKit';

// 该接口在API20可用，SceneBoard仓升级到API20后删除该文件并使用系统提供的接口
/**
 * Device state used to describe states including discovery, authentication and other scenes.
 * @typedef DeviceState
 * @syscap SystemCapability.Multimedia.AVSession.AVCast
 * @systemapi
 * @since 20
 */
export interface CastDeviceState {
  /**
   * Unique device descriptor.
   * @type { string }
   * @readonly
   * @syscap SystemCapability.Multimedia.AVSession.AVCast
   * @systemapi
   * @since 20
   */
  readonly deviceId: string;

  /**
   * Device connection state.
   * @type { number }
   * @readonly
   * @syscap SystemCapability.Multimedia.AVSession.AVCast
   * @systemapi
   * @since 20
   */
  readonly deviceState: number;

  /**
   * Reason for connection failure, for example, user cancellation and timeout.
   * @type { number }
   * @readonly
   * @syscap SystemCapability.Multimedia.AVSession.AVCast
   * @systemapi
   * @since 20
   */
  readonly reasonCode: number;

  /**
   * System radar error code returned by cast+services.
   * @type { number }
   * @readonly
   * @syscap SystemCapability.Multimedia.AVSession.AVCast
   * @systemapi
   * @since 20
   */
  readonly radarErrorCode: number;
}

// 该接口在API20可用，SceneBoard仓升级到API20后删除该文件并使用系统提供的接口
export function onDeviceStateChanged(type: 'deviceStateChanged', callback: Callback<avSession.DeviceState>): void {
  return avSession.on('deviceStateChanged', callback);
}

export function offDeviceStateChanged(type: 'deviceStateChanged', callback?: Callback<avSession.DeviceState>): void {
  if (callback) {
    return avSession.off('deviceStateChanged', callback);
  } else {
    return avSession.off('deviceStateChanged');
  }
}