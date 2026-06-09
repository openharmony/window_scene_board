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
 * Provide parameter Object for DynamicComponent
 */
interface DynamicComponentOptions {
  hapPath?: string;
  abcPath?: string;
  entryPoint: string;
  backgroundTransparent?: boolean,
  worker: import('../api/@ohos.worker').default.ThreadWorker;
  // want: import('../api/@ohos.app.ability.Want').default;
}

/**
 * Provide an interface for the DynamicComponent
 *
 * @interface DynamicComponentInterface
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
interface DynamicComponentInterface {
  /**
   * Construct the DynamicComponent.<br/>
   * Called when the DynamicComponent is used.
   *
   * @param { DynamicComponentOptions } options - indicates the parameters of DynamicComponent
   * @returns { DynamicComponentAttribute }
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @systemapi
   * @since 10
   */
  (options: DynamicComponentOptions): DynamicComponentAttribute;
}

/**
 * Define the attribute functions of DynamicComponent.
 *
 * @extends CommonMethod
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
declare class DynamicComponentAttribute extends CommonMethod<DynamicComponentAttribute> {
  /**
   * @param { ErrorCallback } callback - called when some error occurred except disconnected from DynamicAbility.
   * @returns { DynamicComponentAttribute }
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @since 12
   */
  onError(callback: ErrorCallback): DynamicComponentAttribute;
  /**
   * @param { boolean } value - called when some error occurred except disconnected from DynamicAbility.
   * @returns { DynamicComponentAttribute }
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @since 12
   */
  isReportFrameEvent(value: boolean): DynamicComponentAttribute;
}

/**
 * Defines DynamicComponent.
 *
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
declare const DynamicComponent: DynamicComponentInterface;

/**
 * Defines DynamicComponent instance.
 *
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
declare const DynamicComponentInstance: DynamicComponentAttribute;
