/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * @file
 * @kit ArkGraphics2D
 */

import { AsyncCallback } from './@ohos.base';
import type common2D from './@ohos.graphics.common2D';


/**
 * @namespace uiEffect
 * @syscap SystemCapability.Graphics.Drawing
 * @since 12
 */

declare namespace uiEffect {

  /**
   * The Filter for Component.
   * @typedef Filter
   * @syscap SystemCapability.Graphics.Drawing
   * @since 12
   */
  interface Filter {
    /**
     * Set the edge pixel stretch effect of the Component.
     *
     * @param { Array<number> } stretchSizes
     * @param { TileMode } tileMode
     * @returns { Filter }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    pixelStretch(stretchSizes: Array<number>, tileMode: TileMode): Filter;

    /**
     * Adds the content radius gradient blurring effect for the current component. The input parameter is the blurring radius.
     *
     * @param { number } value - the blurring radius.
     * The larger the blurring radius, the more blurring the content, and if the value is 0, the content blurring effect is not blurring.
     * @param { LinearGradientBlurOptions } options - the radius gradient blur options.
     * @returns { Filter } - Returns radius gradient blur Filter.
     * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 19
     */
    radiusGradientBlur(value: number, options: LinearGradientBlurOptions): Filter;

    blur(blurRadius: number): Filter;

    directionLight(direction: common2D.Point3d, color: common2D.Color, intensity: number, bumpMask?: Mask): Filter;

    maskTransition(alphaMask: Mask, factor?: number, inverse?: boolean): Filter;

    edgeLight(alpha: number, color?: Color, mask?: Mask, bloom?: boolean): Filter;

    displacementDistort(displacementMap: Mask, factor?: [number, number]): Filter;
  }

  /**
   * TileMode enumeration description
   *
   * @enum { number }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  enum TileMode {
    /**
     * Clamp mode.
     *
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    CLAMP = 0,

    /**
     * Repeat mode.
     *
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    REPEAT = 1,

    /**
     * Mirror mode.
     *
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    MIRROR = 2,

    /**
     * Decal mode.
     *
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    DECAL = 3,
  }
  
  /**
   * The VisualEffect of Component.
   * @typedef VisualEffect
   * @syscap SystemCapability.Graphics.Drawing
   * @since 12
   */
  interface VisualEffect {
    /**
    * A backgroundColorEffect effect is added to the Component.
    * @param { BrightnessBlender } blender - The blender to blend backgroundColor.
    * @returns { VisualEffect } VisualEffects for the current effect have been added.
    * @syscap SystemCapability.Graphics.Drawing
    * @systemapi
    * @since 12
    */
    backgroundColorBlender(blender: BrightnessBlender): VisualEffect;
  }

  /* hht */
  type Blender = BrightnessBlender | ShadowBlender;

  /* hht */
  interface ShadowBlender {
    cubicCoeff: number;
    quadraticCoeff: number;
    linearCoeff: number;
    constantTerm: number;
  }

  /**
   * The Blender of backgroundColorEffect.
   * @typedef BrightnessBlender
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  interface BrightnessBlender {
    /**
     * Defines the brightness cubicRate.
     *
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    cubicRate: number;
    /**
     * Defines the brightness quadRate.
     *
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    quadRate: number;
    /**
     * Defines the brightness LinearRate.
     *
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    linearRate: number;
    /**
     * Defines the brightness degree.
     *
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    degree: number;
    /**
     * Defines the brightness saturation.
     *
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    saturation: number;
    /**
     * Defines the brightness positiveCoeff.
     *
     * @type { [number, number, number] }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    positiveCoeff: [number, number, number];
    /**
     * Defines the brightness negativeCoeff.
     *
     * @type { [number, number, number] }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    negativeCoeff: [number, number, number];
    /**
     * Defines the brightness fraction.
     *
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 12
     */
    fraction: number;
  }

  /**
   * The Color of Light.
   * @typedef Color
   * @syscap SystemCapability.Graphics.Drawing
   * @since 20
   */
  interface Color {
    /**
     * Red component of color.
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @since 20
     */
    red: number;
    /**
     * Green component of color.
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @since 20
     */
    green: number;
    /**
     * Blue component of color
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @since 20
     */
    blue: number;
    /**
     * Alpha component of color.
     * @type { number }
     * @syscap SystemCapability.Graphics.Drawing
     * @since 20
     */
    alpha: number;
  }

  /**
   * Defines the mask for Filter or VisualEffect.
   * @typedef { Mask }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 20
   */
  class Mask {
    /**
     * Create a Mask of ripple.
     * @param { common2D.Point } center
     * @param { number } radius
     * @param { number } width
     * @param { number } [offset]
     * @returns { Mask }
     * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
     * @static
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 20
     */
    static createRippleMask(center: common2D.Point, radius: number, width: number, offset?: number): Mask;

    /**
     * Create a Mask of pixelmap.
     * @param { image.PixelMap } pixelMap
     * @param { common2D.Rect } srcRect
     * @param { common2D.Rect } dstRect
     * @param { Color } [fillColor]
     * @returns { Mask }
     * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
     * @static
     * @syscap SystemCapability.Graphics.Drawing
     * @systemapi
     * @since 20
     */
    static createPixelMapMask(pixelMap: image.PixelMap, srcRect: common2D.Rect, dstRect: common2D.Rect,
      fillColor?: common2D.Color): Mask;

    static createRadialGradientMask(center: common2D.Point, radiusX: number, radiusY: number,
      values: Array<[number, number]>): Mask;
  }

  /**
   * Create a Filter to add multiple effects to the component.
   * @returns { Filter } Returns the head node of Filter.
   * @syscap SystemCapability.Graphics.Drawing
   * @since 12
   */
  function createFilter(): Filter;

  /**
     * Create a VisualEffect to add multiple effects to the component.
     * @returns { VisualEffect } Returns the head node of visualEffect.
     * @syscap SystemCapability.Graphics.Drawing
     * @since 12
     */
  function createEffect(): VisualEffect;

  /**
   * Create a BrightnessBlender to add BrightnessBlender to the component.
   * @param { number } cubicRate - The cubicRate to brightness blender.
   * @param { number } quadRate - The quadRate to brightness blender.
   * @param { number } linearRate - The linearRate to brightness blender.
   * @param { number } degree - The degree to brightness blender.
   * @param { number } saturation - The saturation to brightness blender.
   * @param { Array<number> } positiveCoeff - The positiveCoeff to brightness blender.
   * @param { Array<number> } negativeCoeff - The negativeCoeff to brightness blender.
   * @param { number } fraction - The fraction to brightness blender.
   * @returns { BrightnessBlender } Returns the blender.
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  function createBrightnessBlender(cubicRate: number, quadRate: number, linearRate: number, degree: number, saturation:number,
    positiveCoeff: Array<number>, negativeCoeff: Array<number>, fraction: number): BrightnessBlender;

  function createBrightnessBlender(param: BrightnessBlenderParam): BrightnessBlender;

  /* hht */
  function createShadowBlender(param: ShadowBlenderParam): ShadowBlender;
}

/* hht */
declare interface ShadowBlenderParam {
  cubicCoeff: number;
  quadraticCoeff: number;
  linearCoeff: number;
  constantTerm: number;
}

/**
 * The parameters of brightness blender.
 * @typedef BrightnessBlenderParam
 * @syscap SystemCapability.Graphics.Drawing
 * @systemapi
 * @since 12
 */
declare interface BrightnessBlenderParam {
  /**
   * Defines third-order rate for grayscale adjustment.
   *
   * @type { number }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  cubicRate: number;

  /**
   * Defines second-order rate for grayscale adjustment.
   *
   * @type { number }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  quadraticRate: number;

  /**
   * Defines linear rate for grayscale adjustment.
   *
   * @type { number }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  linearRate: number;

  /**
   * Defines grayscale adjustment degree.
   *
   * @type { number }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  degree: number;

  /**
   * Defines the reference saturation for brightness.
   *
   * @type { number }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  saturation: number;

  /**
   * Defines the positive adjustment coefficients in RGB channels based on the reference saturation.
   *
   * @type { [number, number, number] }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  positiveCoefficient: [number, number, number];

  /**
   * Defines the negative adjustment coefficients in RGB channels based on the reference saturation.
   *
   * @type { [number, number, number] }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  negativeCoefficient: [number, number, number];

  /**
   * Defines the blending fraction for brightness effect.
   *
   * @type { number }
   * @syscap SystemCapability.Graphics.Drawing
   * @systemapi
   * @since 12
   */
  fraction: number;
}

export default uiEffect;
