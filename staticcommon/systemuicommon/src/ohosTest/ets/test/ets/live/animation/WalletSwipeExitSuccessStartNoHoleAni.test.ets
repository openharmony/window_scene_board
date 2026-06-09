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
import { getWalletSwipeExitSuccessStartNoHoleAni } from './walletAnimation';
import { curves } from '@ohos/agp';
import { AnimateParams } from '../../../../../main/ets/animation/AnimationBase';
import { ILiveHeadsUpWalletCardVm } from '../../../../../main/ets/live/interface/ILiveHeadsUpWalletCardVm';
import { curves } from '@kit.ArkUI';
import lottie from '@ohos/lottie';
import { SUCCESS_START_DELAY_TIME } from '../../../../../main/ets/live/animation/LiveHeadsUpWalletAnimation';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers, vi } from '@ohos/hypium';
import { getWalletSwipeExitSuccessStartNoHoleAni } from '../../../../../main/ets/live/animation/wallet/WalletSwipeExitSuccessStartNoHoleAni';
const SUCCESS_START_DELAY_TIME = 325;

export default function getWalletSwipeExitSuccessStartNoHoleAniTest() {
describe('getWalletSwipeExitSuccessStartNoHoleAni', () => {
  let walletVm: any;
  let mockLottie: any;

  beforeEach(() => {
    walletVm = {
      imageInfo: {
        X: 0,
        Y: 0,
        Z: 0,
        angle: 0
      },
      overlayBoxInfo: {
        borderRadius: 0,
        width: 0
      },
      textInfo: {
        textOpacity: 0
      },
      radioInfo: {
        radioOpacity: 0,
        radioscalaX: 0,
        radioscalaY: 0,
        animateItemAppear: null,
        controller: {},
        animateNameAppear: 'appear',
        animatePathAppear: 'path/to/animation.json'
      }
    };

    mockLottie = {
      loadAnimation: vi.fn().mockReturnValue({
        destroy: vi.fn()
      })
    };

    vi.doMock('@ohos/lottie', () => mockLottie);
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it('should return an array of animate params', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    expect(Array.isArray(result)).toBeTruthy();
    expect(result.length).toBeGreaterThan(0);
  });

  it('should set initial image position and angle', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const firstAnimation = result[0];

    firstAnimation.event();
    expect(walletVm.imageInfo.X).toBe(0);
    expect(walletVm.imageInfo.Y).toBe(1);
    expect(walletVm.imageInfo.Z).toBe(0);
    expect(walletVm.imageInfo.angle).toBe(90);
  });

  it('should reverse image angle after delay', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const secondAnimation = result[1];

    secondAnimation.event();
    expect(walletVm.imageInfo.X).toBe(0);
    expect(walletVm.imageInfo.Y).toBe(1);
    expect(walletVm.imageInfo.Z).toBe(0);
    expect(walletVm.imageInfo.angle).toBe(-90);

    // Verify delay time
    expect(secondAnimation.delay).toBe(SUCCESS_START_DELAY_TIME - 1);
    expect(secondAnimation.duration).toBe(1);
  });

  it('should reset image angle at success start delay', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const thirdAnimation = result[2];

    thirdAnimation.event();
    expect(walletVm.imageInfo.X).toBe(0);
    expect(walletVm.imageInfo.Y).toBe(1);
    expect(walletVm.imageInfo.Z).toBe(0);
    expect(walletVm.imageInfo.angle).toBe(0);

    // Verify delay and duration
    expect(thirdAnimation.delay).toBe(SUCCESS_START_DELAY_TIME);
    expect(thirdAnimation.duration).toBe(785);
  });

  it('should update box dimensions with spring animation', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const boxAnimation = result[3];

    boxAnimation.event();
    expect(walletVm.overlayBoxInfo.borderRadius).toBe(20);
    expect(walletVm.overlayBoxInfo.width).toBe(328);

    // Verify delay time
    expect(boxAnimation.delay).toBe(325);
  });

  it('should fade in text with proper timing', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const textAnimation = result[4];

    textAnimation.event();
    expect(walletVm.textInfo.textOpacity).toBe(1);

    // Verify timing
    expect(textAnimation.delay).toBe(415);
    expect(textAnimation.duration).toBe(300);
  });

  it('should fade in and scale radio with proper timing', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const radioFadeIn = result[5];
    const radioScale = result[6];

    radioFadeIn.event();
    radioScale.event();

    expect(walletVm.radioInfo.radioOpacity).toBe(1);
    expect(walletVm.radioInfo.radioscalaX).toBe(1);
    expect(walletVm.radioInfo.radioscalaY).toBe(1);

    // Verify timing
    expect(radioFadeIn.delay).toBe(558.33);
    expect(radioFadeIn.duration).toBe(200);
    expect(radioScale.delay).toBe(558.33);
    expect(radioScale.duration).toBe(200);
  });

  it('should load and play lottie animation on finish', () => {
    walletVm.radioInfo.animateItemAppear = {
      destroy: vi.fn()
    };

    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const lottieAnimation = result[7];

    lottieAnimation.onFinish();

    expect(walletVm.radioInfo.animateItemAppear).not.toBeNull();
    expect(walletVm.radioInfo.animateItemAppear.destroy).toHaveBeenCalled();

    // Verify lottie parameters
    expect(mockLottie.loadAnimation).toHaveBeenCalledWith({
      container: walletVm.radioInfo.controller,
      renderer: 'canvas',
      loop: false,
      autoplay: true,
      name: walletVm.radioInfo.animateNameAppear,
      path: walletVm.radioInfo.animatePathAppear,
    });

    // Verify duration (assuming 758.33 is total duration minus delay)
    expect(lottieAnimation.duration).toBe(758.33);
  });

  it('should handle empty walletVm object', () => {
    const emptyWalletVm = {};
    const result = getWalletSwipeExitSuccessStartNoHoleAni(emptyWalletVm);

    expect(result).toBeDefined();
    expect(result.length).toBe(8);

    // Verify no errors when executing animations
    result.forEach(anim => {
      if (anim.event) {
        anim.event();
      }
      if (anim.onFinish) {
        anim.onFinish();
      }
    });
  });

  it('should handle missing optional properties in walletVm', () => {
    const minimalWalletVm = {
      imageInfo: {},
      overlayBoxInfo: {},
      textInfo: {},
      radioInfo: {}
    };

    const result = getWalletSwipeExitSuccessStartNoHoleAni(minimalWalletVm);
    expect(result).toBeDefined();

    // Verify no errors when executing animations
    expect(() => {
      result.forEach(anim => {
        if (anim.event) {
          anim.event();
        }
        if (anim.onFinish) {
          anim.onFinish();
        }
      });
    }).not.toThrow();
  });

  it('should use correct curve types for each animation', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);

    // First two animations should use the same cubic bezier curve
    expect(result[0].curve).toEqual(result[1].curve);
    expect(result[0].curve).toEqual(curves.cubicBezierCurve(0.33, 0.00, 0.67, 1));

    // Third animation has a different curve
    expect(result[2].curve).toEqual(curves.cubicBezierCurve(0.43, 0.00, 0.00, 1.00));

    // Box animation uses spring curve
    expect(result[3].curve).toEqual(curves.interpolatingSpring(0, 1, 81, 11));
  });

  it('should maintain proper timing sequence between animations', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);

    const startTimes = result.map(anim => anim.delay || 0);
    const durations = result.map(anim => anim.duration || 0);

    // Verify timings are in expected order
    expect(startTimes[0] + durations[0]).toBeLessThanOrEqual(startTimes[1]);
    expect(startTimes[1] + durations[1]).toBeLessThanOrEqual(startTimes[2]);
  });

  // Edge cases and error scenarios
  it('should handle undefined walletVm', () => {
    expect(() => getWalletSwipeExitSuccessStartNoHoleAni(undefined)).toThrow();
  });

  it('should handle null walletVm', () => {
    expect(() => getWalletSwipeExitSuccessStartNoHoleAni(null)).toThrow();
  });

  it('should not modify original walletVm when creating animation params', () => {
    const originalVm = JSON.parse(JSON.stringify(walletVm));
    getWalletSwipeExitSuccessStartNoHoleAni(walletVm);

    // Check imageInfo wasn't modified
    expect(walletVm.imageInfo.X).toBe(originalVm.imageInfo.X);
    expect(walletVm.imageInfo.Y).toBe(originalVm.imageInfo.Y);
    expect(walletVm.imageInfo.Z).toBe(originalVm.imageInfo.Z);
    expect(walletVm.imageInfo.angle).toBe(originalVm.imageInfo.angle);

    // Check other properties weren't modified
    expect(walletVm.overlayBoxInfo.borderRadius).toBe(originalVm.overlayBoxInfo.borderRadius);
    expect(walletVm.overlayBoxInfo.width).toBe(originalVm.overlayBoxInfo.width);
  });

  // Performance tests
  it('should execute quickly for multiple calls', () => {
    const startTime = performance.now();
    const iterations = 100;

    for (let i = 0; i < iterations; i++) {
      getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    }

    const duration = performance.now() - startTime;
    expect(duration).toBeLessThan(100); // ms
  });

  // Behavior tests
  it('should not load lottie animation if radioInfo missing', () => {
    delete walletVm.radioInfo;
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const lottieAnimation = result[7];

    expect(() => lottieAnimation.onFinish()).not.toThrow();
    expect(mockLottie.loadAnimation).not.toHaveBeenCalled();
  });

  it('should handle missing animateItemAppear property', () => {
    delete walletVm.radioInfo.animateItemAppear;
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const lottieAnimation = result[7];

    expect(() => lottieAnimation.onFinish()).not.toThrow();
    expect(mockLottie.loadAnimation).toHaveBeenCalled();
  });

  // Animation flow tests
  it('should maintain animation sequence consistency', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);

    const expectedSequence = [
      { type: 'image', prop: 'angle', value: 90 },
      { type: 'image', prop: 'angle', value: -90 },
      { type: 'image', prop: 'angle', value: 0 },
      { type: 'box', prop: 'borderRadius', value: 20 },
      { type: 'box', prop: 'width', value: 328 },
      { type: 'text', prop: 'textOpacity', value: 1 },
      { type: 'radio', prop: 'radioOpacity', value: 1 },
      { type: 'radio', prop: 'radioscalaX', value: 1 },
      { type: 'radio', prop: 'radioscalaY', value: 1 },
      { type: 'lottie', prop: 'load', value: true }
    ];

    let sequenceIndex = 0;

    // Execute all animations in order
    result.forEach(anim => {
      if (anim.event) {
        anim.event();
      }
      if (anim.onFinish) {
        anim.onFinish();
      }
    });

    // Check angle changes
    expect(walletVm.imageInfo.angle).toBe(0);

    // Check box properties
    expect(walletVm.overlayBoxInfo.borderRadius).toBe(20);
    expect(walletVm.overlayBoxInfo.width).toBe(328);

    // Check text opacity
    expect(walletVm.textInfo.textOpacity).toBe(1);

    // Check radio properties
    expect(walletVm.radioInfo.radioOpacity).toBe(1);
    expect(walletVm.radioInfo.radioscalaX).toBe(1);
    expect(walletVm.radioInfo.radioscalaY).toBe(1);

    // Check lottie was loaded
    expect(mockLottie.loadAnimation).toHaveBeenCalled();
  });

  // Mock curve tests
  it('should use mocked curve functions without errors', () => {
    const mockCurve = { getInterpolation: vi.fn() };
    vi.spyOn(curves, 'cubicBezierCurve').mockReturnValue(mockCurve);
    vi.spyOn(curves, 'interpolatingSpring').mockReturnValue(mockCurve);

    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);

    expect(curves.cubicBezierCurve).toHaveBeenCalled();
    expect(curves.interpolatingSpring).toHaveBeenCalled();

    // Execute animations with mocked curves
    result.forEach(anim => {
      if (anim.event) {
        anim.event();
      }
      if (anim.onFinish) {
        anim.onFinish();
      }
    });

    expect(mockCurve.getInterpolation).not.toHaveBeenCalled(); // Not called during param setup
  });

  // More edge cases
  it('should handle negative delay values gracefully', () => {
    // Force negative delay (unlikely in production)
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const animWithNegativeDelay = { ...result[0], delay: -100 };

    expect(() => animWithNegativeDelay.event()).not.toThrow();
  });

  it('should handle very large duration values', () => {
    // Force large duration (unlikely in production)
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const animWithLargeDuration = { ...result[0], duration: 1e6 };

    expect(() => animWithLargeDuration.event()).not.toThrow();
  });

  // Type tests
  it('should return correctly typed animation parameters', () => {
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);

    result.forEach(anim => {
      expect(anim).toHaveProperty('curve');
      if (anim.delay !== undefined) {
        expect(typeof anim.delay).toBe('number');
      }
      if (anim.duration !== undefined) {
        expect(typeof anim.duration).toBe('number');
      }
      expect(anim.event || anim.onFinish).toBeDefined();
    });
  });

  // More mock tests
  it('should not call lottie.loadAnimation if radioInfo is missing properties', () => {
    delete walletVm.radioInfo.controller;
    delete walletVm.radioInfo.animatePathAppear;

    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    const lottieAnimation = result[7];

    lottieAnimation.onFinish();

    expect(mockLottie.loadAnimation).not.toHaveBeenCalled();
  });

  // Property modification tests
  it('should modify only expected properties during animation', () => {
    const originalVm = JSON.parse(JSON.stringify(walletVm));
    const result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);

    // Execute all animations
    result.forEach(anim => {
      if (anim.event) {
        anim.event();
      }
      if (anim.onFinish) {
        anim.onFinish();
      }
    });

    // Check only expected properties changed
    expect(walletVm.imageInfo).not.toEqual(originalVm.imageInfo);
    expect(walletVm.overlayBoxInfo).not.toEqual(originalVm.overlayBoxInfo);
    expect(walletVm.textInfo).not.toEqual(originalVm.textInfo);
    expect(walletVm.radioInfo).not.toEqual(originalVm.radioInfo);

    // Check other properties didn't change
    const allOriginalKeys = Object.keys(originalVm);
    const allNewKeys = Object.keys(walletVm);
    expect(allNewKeys).toEqual(allOriginalKeys);
  });

  it('should_return_correct_animateParams_when_call_getWalletSwipeExitSuccessStartNoHoleAni', 0, () => {
    let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
    let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    expect(result.length).assertEqual(13);
    expect(result[0].curve).assertInstanceOf(curves.Curve);
    expect(result[0].duration).assertInstanceOf(Number);
    expect(result[0].event).assertInstanceOf(Function);
    expect(result[0].delay).assertInstanceOf(Number);
  });

  it('should_set_walletVm_properties_correctly_when_animateParams_are_called', 0, () => {
    let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
    let mocker: MockKit = new MockKit();
    let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    expect(walletVm.imageInfo.X).assertEqual(0);
    expect(walletVm.imageInfo.Y).assertEqual(1);
    expect(walletVm.imageInfo.Z).assertEqual(0);
    expect(walletVm.imageInfo.angle).assertEqual(90);
    expect(walletVm.overlayBoxInfo.borderRadius).assertEqual(20);
    expect(walletVm.overlayBoxInfo.width).assertEqual(328);
    expect(walletVm.textInfo.textOpacity).assertEqual(1);
    expect(walletVm.radioInfo.radioOpacity).assertEqual(1);
    expect(walletVm.radioInfo.radioscalaX).assertEqual(1);
    expect(walletVm.radioInfo.radioscalaY).assertEqual(1);
  });

  it('should_call_loadAnimation_when_duration_is_758_33', 0, () => {
    let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
    let mocker: MockKit = new MockKit();
    let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    expect(walletVm.radioInfo.animateItemAppear).assertInstanceOf(lottie.AnimationItem);
  });

  it('should_call_destroy_when_animateItemAppear_is_not_null', 0, () => {
    let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
    walletVm.radioInfo.animateItemAppear = lottie.loadAnimation({
      container: walletVm.radioInfo.controller,
      renderer: 'canvas',
      loop: false,
      autoplay: true,
      name: walletVm.radioInfo.animateNameAppear,
      path: walletVm.radioInfo.animatePathAppear,
    });
    let mocker: MockKit = new MockKit();
    let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
    expect(walletVm.radioInfo.animateItemAppear).assertNull();
  });
});
}