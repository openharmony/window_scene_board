/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
 * @file
 * @kit ArkUI
 */

/**
 * Provides an Effect Component, which is invisible, but setting properties on this component defines an effect template
 * that child components can apply by setting useEffect(true).
 *
 * @interface EffectComponentInterface
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
interface EffectComponentInterface {
  /**
   * Return effectComponent.
   *
   * @returns { EffectComponentAttribute }
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @systemapi
   * @since 10
   */
  (): EffectComponentAttribute;
  /**
   * Return effectComponent.
   *
   * @param { EffectComponentOptions } [options] - EffectComponent constructor options.
   * @returns { EffectComponentAttribute }
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @systemapi
   * @since arkts{ '1.1':'20','1.2':'20'}
   * @arkts 1.1&1.2
   */
  (options?: EffectComponentOptions): EffectComponentAttribute;
}

/**
 * Effect layer enum.
 *
 * @enum { number }
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since arkts{ '1.1':'20','1.2':'20'}
 * @arkts 1.1&1.2
 */
declare enum EffectLayer {
  /**
   * No layer.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @systemapi
   * @since arkts{ '1.1':'20','1.2':'20'}
   * @arkts 1.1&1.2
   */
  NONE = 0,

  /**
   * Charge motion layer.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @systemapi
   * @since arkts{ '1.1':'20','1.2':'20'}
   * @arkts 1.1&1.2
   */
  CHARGE_MOTION = 1,

  /**
   * Charge text layer.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @systemapi
   * @since arkts{ '1.1':'20','1.2':'20'}
   * @arkts 1.1&1.2
   */
  CHARGE_TEXT = 2
}

/**
 * Defines the Effect Component constructor options.
 *
 * @interface EffectComponentOptions
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since arkts{ '1.1':'20','1.2':'20'}
 * @arkts 1.1&1.2
 */
declare interface EffectComponentOptions {
  /**
   * Use this to determine the component layer level. Set true to put the component to the independent layer. Set false
   * to put the component to the unified render layer. Default value is false.
   *
   * @type { ?boolean }
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @systemapi
   * @since arkts{ '1.1':'20','1.2':'20'}
   * @arkts 1.1&1.2
   */
  effectLayer?: EffectLayer;
}

/**
 * Defines the Effect Component attribute functions.
 *
 * @extends CommonMethod<EffectComponentAttribute>
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
declare class EffectComponentAttribute extends CommonMethod<EffectComponentAttribute> {
  alwaysSnapshot(snapshot: boolean = false): EffectComponentAttribute;
}

/**
 * Defines Effect Component.
 *
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
declare const EffectComponent: EffectComponentInterface;

/**
 * Defines Effect Component instance.
 *
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @systemapi
 * @since 10
 */
declare const EffectComponentInstance: EffectComponentAttribute;
