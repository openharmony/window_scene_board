/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License"),
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
 * @file
 * @kit MechanicKit
 * @arkts 1.1&1.2
 */

import type { Callback } from './@ohos.base';

/**
 * Provides capabilities for controlling and interacting with mechanical devices connected to this device.
 * The capabilities cover connection management, control, and monitoring.
 *
 * @namespace mechanicManager
 * @syscap SystemCapability.Mechanic.Core
 * @since 20
 */

declare namespace mechanicManager {
  /**
   * Subscribes to device attachment state change events.
   * @param { 'attachStateChange' } type Event type.
   * @param { Callback<AttachStateChangeInfo> } callback Callback used to return the state change.
   * @throws { BusinessError } 33300001 - Service exception.
   * @syscap SystemCapability.Mechanic.Core
   * @since 20
   */
  function on(type: 'attachStateChange', callback: Callback<AttachStateChangeInfo>): void;

  /**
   * Unsubscribes from device attachment state change events.
   * @param { 'attachStateChange' } type Event type.
   * @param { Callback<AttachStateChangeInfo> } [callback] Callback used to return the state change.
   * @throws { BusinessError } 33300001 - Service exception.
   * @syscap SystemCapability.Mechanic.Core
   * @since 20
   */
  function off(type: 'attachStateChange', callback?: Callback<AttachStateChangeInfo>): void;

  /**
   * Obtain the list of connected mechanical devices.
   * @returns { MechInfo[] } List of connected mechanical devices.
   * @throws { BusinessError } 33300001 - Service exception.
   * @syscap SystemCapability.Mechanic.Core
   * @since 20
   */
  function getAttachedMechDevices(): MechInfo[];

  /**
   * Callback information about the device attachment state change.
   * @typedef AttachStateChangeInfo
   * @syscap SystemCapability.Mechanic.Core
   * @since 20
   */
  export interface AttachStateChangeInfo {

    /**
     * Device attachment state.
     * @type { AttachState }
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */
    state: AttachState;

    /**
     * Mechanical device information.
     * @type { MechInfo }
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */
    mechInfo: MechInfo,
  }

  /**
   * Device attach states.
   *
   * @enum { number }
   * @syscap SystemCapability.Mechanic.Core
   * @since 20
   */
  export enum AttachState {

    /**
     * Device attached.
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */
    ATTACHED = 0,

    /**
     * Device detached.
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */
    DETACHED = 1
  }

  /**
   * Mechanical device information.
   * @typedef MechInfo
   * @syscap SystemCapability.Mechanic.Core
   * @since 20
   */
  export interface MechInfo {
    /**
     * ID of the mechanical device.
     * @type { number }
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */
    mechId: number;


    /**
     * Type of the mechanical device.
     * @type { MechDeviceType }
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */
    mechDeviceType: MechDeviceType;

    /**
     * Name of the mechanical device.
     * @type { string }
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */
    mechName: string;
  }

  /**
   * Enumerates the mechanical device types.
   * @enum { number }
   * @syscap SystemCapability.Mechanic.Core
   * @since 20
   */

  export enum MechDeviceType {
    /**
     * Gimbal device.
     * @syscap SystemCapability.Mechanic.Core
     * @since 20
     */

    GIMBAL_DEVICE = 0
  }
}

export default mechanicManager;