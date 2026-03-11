/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
import type bundleManager from '@ohos.bundle.bundleManager';
import { StartMode } from '../scene/common/SCBSceneEnums';

/**
 * AbilityInfo from BMS
 */
export class AbilityItemInfo {
  /**
   * Indicates appIconId.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 10
   */
  appIconId: number;

  /**
   * Indicates appLabelId.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 10
   */
  appLabelId: number;

  /**
   * Indicates the name of the bundle containing the ability
   * @type {string}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  bundleName: string;

  /**
   * Indicates the name of the .hap package to which the capability belongs
   * @type {string}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  moduleName: string;

  /**
   * Indicates whether the ability is hooked or not
   * @type {boolean}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 17
   */
  isAbilityHook: boolean;

  /**
   * Ability simplified class name
   * @type {string}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  name: string;

  /**
   * Enumerates ability launch type
   * @type {bundleManager.LaunchType}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  launchType: bundleManager.LaunchType;

  /**
   * Indicates which window mode is supported
   * @type {Array<bundleManager.SupportWindowMode>}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  supportWindowModes: Array<bundleManager.SupportWindowMode>;

  /**
   * Indicates which window mode is supported in free multi window
   * @type {Array<bundleManager.SupportWindowMode>}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 20
   */
  supportWindowModesInFreeMultiWindow: Array<bundleManager.SupportWindowMode>;

  /**
   * Indicates window size
   * @type {WindowSize}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  windowSize: WindowSize;

  /**
   * Enumerates ability display orientations
   *
   * @type { bundleManager.DisplayOrientation }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  orientation: bundleManager.DisplayOrientation;

  /**
   * Indicates whether remove the session after terminate
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @type {boolean}
   * @since 10
   */
  removeSessionAfterTerminate: boolean;

  /**
   * Whether to display in the session list
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @type {boolean}
   * @since 10
   */
  excludeFromSession: boolean;

  /**
   * Indicates whether the session can be cleared
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @type {boolean}
   * @since 10
   */
  unclearableSession: boolean;

  /**
   * Indicates whether the session can be continue in distributed scenario
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @type {boolean}
   * @since 10
   */
  continuable: boolean;

  /**
   * Indicates multi window orientation
   * @type {string}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 12
   */
  preferMultiWindowOrientation: string;

  /**
   * support force rotation
   * @type {boolean}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 20
   */
  isForceRotate: boolean;
}

/**
 * SCBAbilityItemInfo include abilityItemInfo and sdkVersion
 */
export class SCBAbilityItemInfo {
  /**
   * AbilityItemInfo from BMS.
   * @type {AbilityItemInfo}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 12
   */
  abilityItemInfo: AbilityItemInfo;

  /**
   * target version of SDK.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 12
   */
  sdkVersion: number;

  /**
   * Code path from BMS
   * @type {string}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 12
   */
  codePath: string;

  /**
   * Indicates whether the ability is hooked or not
   * @type {boolean}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 17
   */
  isAbilityHook: boolean;
}

/**
 * Indicates the window size.
 * @typedef WindowSize
 * @syscap SystemCapability.BundleManager.BundleFramework.Core
 * @since 9
 */
export class WindowSize {
  /**
   * Indicates maximum ratio of width over height of window under free window status.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  maxWindowRatio: number;

  /**
   * Indicates minimum ratio of width over height of window under free window status.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  minWindowRatio: number;

  /**
   * Indicates maximum width of window under free window status.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  maxWindowWidth: number;

  /**
   * Indicates minimum width of window under free window status.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  minWindowWidth: number;

  /**
   * Indicates maximum height of window under free window status.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  maxWindowHeight: number;

  /**
   * Indicates minimum height of window under free window status.
   * @type {number}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  minWindowHeight: number;
}

export class SCBApplicationInfo {
  startMode: StartMode;
}