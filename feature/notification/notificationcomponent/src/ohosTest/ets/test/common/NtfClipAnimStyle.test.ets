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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfClipAnimStyle } from '../../../main/ets/common/NtfClipAnimStyle';
export default function NtfClipAnimStyleTest() {
  describe('isRectClipEnable_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isClipAnimEnable_is_true', 0, () => {
      let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
      ntfclipanimstyle.isClipAnimEnable = true;
      const result = ntfclipanimstyle.isRectClipEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isClipAnimEnable_is_false', 0, () => {
      let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
      ntfclipanimstyle.isClipAnimEnable = false;
      const result = ntfclipanimstyle.isRectClipEnable();
      expect(result).assertEqual(false);
    });
  });
  it('should_return_false_when_simpleClipEnable_is_false', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.simpleClipEnable = false;
    const result = ntfclipanimstyle.isSimpleClipEnable();
    expect(result).assertEqual(false);
  });

  it('should_return_true_when_simpleClipEnable_is_true', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.simpleClipEnable = true;
    const result = ntfclipanimstyle.isSimpleClipEnable();
    expect(result).assertEqual(true);
  });
  it('should_return_clip_anim_style_when_isClipEnable_is_true', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildClipEnable(true);
    expect(result.isClipAnimEnable).assertEqual(true);
  });

  it('should_return_clip_anim_style_when_isClipEnable_is_false', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildClipEnable(false);
    expect(result.isClipAnimEnable).assertEqual(false);
  });
  it('should_return_clipWidth_when_clipWidth_is_set_correctly', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildWidth(100);
    expect(result.clipWidth).assertEqual(100);
  });

  it('should_return_clipWidth_when_clipWidth_is_zero', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildWidth(0);
    expect(result.clipWidth).assertEqual(0);
  });

  it('should_return_clipWidth_when_clipWidth_is_negative', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildWidth(-100);
    expect(result.clipWidth).assertEqual(-100);
  });
  it('should_return_this_when_clipHeight_is_set_correctly', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildHeight(100);
    expect(result).assertInstanceOf(NtfClipAnimStyle);
    expect(result.clipHeight).assertEqual(100);
  });

  it('should_return_this_when_clipHeight_is_zero', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildHeight(0);
    expect(result).assertInstanceOf(NtfClipAnimStyle);
    expect(result.clipHeight).assertEqual(0);
  });

  it('should_return_this_when_clipHeight_is_negative', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildHeight(-50);
    expect(result).assertInstanceOf(NtfClipAnimStyle);
    expect(result.clipHeight).assertEqual(-50);
  });
  it('should_return_clipOffsetX_when_offsetX_is_zero', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildOffsetX(0);
    expect(result.clipOffsetX).assertEqual(0);
  });

  it('should_return_clipOffsetX_when_offsetX_is_positive', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildOffsetX(5);
    expect(result.clipOffsetX).assertEqual(5);
  });

  it('should_return_clipOffsetX_when_offsetX_is_negative', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildOffsetX(-10);
    expect(result.clipOffsetX).assertEqual(-10);
  });

  it('should_return_clipOffsetY_when_offsetY_is_zero', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildOffsetY(0);
    expect(result.clipOffsetY).assertEqual(0);
  });

  it('should_return_clipOffsetY_when_offsetY_is_positive', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildOffsetY(10);
    expect(result.clipOffsetY).assertEqual(10);
  });

  it('should_return_clipOffsetY_when_offsetY_is_negative', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildOffsetY(-10);
    expect(result.clipOffsetY).assertEqual(-10);
  });
  it('should_return_this_when_radius_is_zero', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildRadius(0);
    expect(result).assertInstanceOf(NtfClipAnimStyle);
    expect(result.clipRadius).assertEqual(0);
  });

  it('should_return_this_when_radius_is_greater_than_zero', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildRadius(10);
    expect(result).assertInstanceOf(NtfClipAnimStyle);
    expect(result.clipRadius).assertEqual(10);
  });

  it('should_return_this_when_radius_is_negative', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result = ntfclipanimstyle.buildRadius(-5);
    expect(result).assertInstanceOf(NtfClipAnimStyle);
    expect(result.clipRadius).assertEqual(-5);
  });
  it('should_set_isClipAnimEnable_to_false', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildSimpleClipEnable(true);
    expect(ntfclipanimstyle.isClipAnimEnable).assertEqual(false);
    expect(result).assertEqual(ntfclipanimstyle);
  });

  it('should_set_simpleClipEnable_to_true', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildSimpleClipEnable(true);
    expect(ntfclipanimstyle.simpleClipEnable).assertEqual(true);
    expect(result).assertEqual(ntfclipanimstyle);
  });

  it('should_set_isClipAnimEnable_to_false_and_simpleClipEnable_to_false', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let result: NtfClipAnimStyle = ntfclipanimstyle.buildSimpleClipEnable(false);
    expect(ntfclipanimstyle.isClipAnimEnable).assertEqual(false);
    expect(ntfclipanimstyle.simpleClipEnable).assertEqual(false);
    expect(result).assertEqual(ntfclipanimstyle);
  });
  it('should_return_correct_values_when_simpleClipEnable_and_isClipAnimEnable_are_equal', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let rhs: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.clipWidth = 10;
    ntfclipanimstyle.clipHeight = 20;
    ntfclipanimstyle.clipOffsetX = 30;
    ntfclipanimstyle.clipOffsetY = 40;
    ntfclipanimstyle.clipRadius = 50;
    ntfclipanimstyle.simpleClipEnable = true;
    ntfclipanimstyle.isClipAnimEnable = true;
    const result = ntfclipanimstyle.plus(rhs);
    expect(result.clipWidth).assertEqual(10);
    expect(result.clipHeight).assertEqual(20);
    expect(result.clipOffsetX).assertEqual(30);
    expect(result.clipOffsetY).assertEqual(40);
    expect(result.clipRadius).assertEqual(50);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(true);
  });
  it('should_return_correct_values_when_simpleClipEnable_and_isClipAnimEnable_are_not_equal', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let rhs: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.clipWidth = 10;
    ntfclipanimstyle.clipHeight = 20;
    ntfclipanimstyle.clipOffsetX = 30;
    ntfclipanimstyle.clipOffsetY = 40;
    ntfclipanimstyle.clipRadius = 50;
    ntfclipanimstyle.simpleClipEnable = false;
    ntfclipanimstyle.isClipAnimEnable = true;
    const result = ntfclipanimstyle.plus(rhs);
    expect(result.clipWidth).assertEqual(10);
    expect(result.clipHeight).assertEqual(20);
    expect(result.clipOffsetX).assertEqual(30);
    expect(result.clipOffsetY).assertEqual(40);
    expect(result.clipRadius).assertEqual(50);
    expect(result.simpleClipEnable).assertEqual(false);
    expect(result.isClipAnimEnable).assertEqual(true);
  });
  it('should_return_correct_values_when_rhs_is_null', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let rhs: NtfClipAnimStyle = null;
    ntfclipanimstyle.clipWidth = 10;
    ntfclipanimstyle.clipHeight = 20;
    ntfclipanimstyle.clipOffsetX = 30;
    ntfclipanimstyle.clipOffsetY = 40;
    ntfclipanimstyle.clipRadius = 50;
    ntfclipanimstyle.simpleClipEnable = true;
    ntfclipanimstyle.isClipAnimEnable = true;
    const result = ntfclipanimstyle.plus(rhs);
    expect(result.clipWidth).assertEqual(10);
    expect(result.clipHeight).assertEqual(20);
    expect(result.clipOffsetX).assertEqual(30);
    expect(result.clipOffsetY).assertEqual(40);
    expect(result.clipRadius).assertEqual(50);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(true);
  });
  it('should_return_correct_values_when_lhs_is_null', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = null;
    let rhs: NtfClipAnimStyle = new NtfClipAnimStyle();
    rhs.clipWidth = 10;
    rhs.clipHeight = 20;
    rhs.clipOffsetX = 30;
    rhs.clipOffsetY = 40;
    rhs.clipRadius = 50;
    rhs.simpleClipEnable = true;
    rhs.isClipAnimEnable = true;
    const result = ntfclipanimstyle.plus(rhs);
    expect(result.clipWidth).assertEqual(10);
    expect(result.clipHeight).assertEqual(20);
    expect(result.clipOffsetX).assertEqual(30);
    expect(result.clipOffsetY).assertEqual(40);
    expect(result.clipRadius).assertEqual(50);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(true);
  });
  it('should_return_correct_values_when_all_properties_are_different', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let rhs: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.clipWidth = 10;
    ntfclipanimstyle.clipHeight = 20;
    ntfclipanimstyle.clipOffsetX = 30;
    ntfclipanimstyle.clipOffsetY = 40;
    ntfclipanimstyle.clipRadius = 50;
    ntfclipanimstyle.simpleClipEnable = false;
    ntfclipanimstyle.isClipAnimEnable = false;
    const result = ntfclipanimstyle.plus(rhs);
    expect(result.clipWidth).assertEqual(10);
    expect(result.clipHeight).assertEqual(20);
    expect(result.clipOffsetX).assertEqual(30);
    expect(result.clipOffsetY).assertEqual(40);
    expect(result.clipRadius).assertEqual(50);
    expect(result.simpleClipEnable).assertEqual(false);
    expect(result.isClipAnimEnable).assertEqual(false);
  });
  it('should_return_correct_values_when_all_properties_are_same', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    let rhs: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.clipWidth = 10;
    ntfclipanimstyle.clipHeight = 20;
    ntfclipanimstyle.clipOffsetX = 30;
    ntfclipanimstyle.clipOffsetY = 40;
    ntfclipanimstyle.clipRadius = 50;
    ntfclipanimstyle.simpleClipEnable = true;
    ntfclipanimstyle.isClipAnimEnable = true;
    const result = ntfclipanimstyle.plus(rhs);
    expect(result.clipWidth).assertEqual(20);
    expect(result.clipHeight).assertEqual(40);
    expect(result.clipOffsetX).assertEqual(60);
    expect(result.clipOffsetY).assertEqual(80);
    expect(result.clipRadius).assertEqual(100);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(true);
  });
  it('should_return_correct_result_when_simpleClipEnable_and_isClipAnimEnable_are_equal', 0, () => {
    let ntfclipanimstyle1: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle1.clipWidth = 100;
    ntfclipanimstyle1.clipHeight = 100;
    ntfclipanimstyle1.clipOffsetX = 10;
    ntfclipanimstyle1.clipOffsetY = 10;
    ntfclipanimstyle1.clipRadius = 5;
    ntfclipanimstyle1.simpleClipEnable = true;
    ntfclipanimstyle1.isClipAnimEnable = true;

    let ntfclipanimstyle2: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle2.clipWidth = 50;
    ntfclipanimstyle2.clipHeight = 50;
    ntfclipanimstyle2.clipOffsetX = 5;
    ntfclipanimstyle2.clipOffsetY = 5;
    ntfclipanimstyle2.clipRadius = 3;
    ntfclipanimstyle2.simpleClipEnable = true;
    ntfclipanimstyle2.isClipAnimEnable = true;

    let mocker: MockKit = new MockKit();
    let mockBuildWidth: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildWidth);
    when(mockBuildWidth)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildHeight: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildHeight);
    when(mockBuildHeight)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildOffsetX: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetX);
    when(mockBuildOffsetX)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildOffsetY: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetY);
    when(mockBuildOffsetY)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildRadius: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildRadius);
    when(mockBuildRadius)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    const result = ntfclipanimstyle1.subtract(ntfclipanimstyle2);

    expect(result.clipWidth).assertEqual(50);
    expect(result.clipHeight).assertEqual(50);
    expect(result.clipOffsetX).assertEqual(10);
    expect(result.clipOffsetY).assertEqual(10);
    expect(result.clipRadius).assertEqual(2);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(true);

    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildWidth);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildHeight);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetX);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetY);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildRadius);
  });
  it('should_return_correct_result_when_simpleClipEnable_are_equal_but_isClipAnimEnable_are_not_equal', 0, () => {
    let ntfclipanimstyle1: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle1.clipWidth = 100;
    ntfclipanimstyle1.clipHeight = 100;
    ntfclipanimstyle1.clipOffsetX = 10;
    ntfclipanimstyle1.clipOffsetY = 10;
    ntfclipanimstyle1.clipRadius = 5;
    ntfclipanimstyle1.simpleClipEnable = true;
    ntfclipanimstyle1.isClipAnimEnable = true;

    let ntfclipanimstyle2: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle2.clipWidth = 50;
    ntfclipanimstyle2.clipHeight = 50;
    ntfclipanimstyle2.clipOffsetX = 5;
    ntfclipanimstyle2.clipOffsetY = 5;
    ntfclipanimstyle2.clipRadius = 3;
    ntfclipanimstyle2.simpleClipEnable = true;
    ntfclipanimstyle2.isClipAnimEnable = false;
    let mocker: MockKit = new MockKit();

    let mockBuildWidth: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildWidth);
    when(mockBuildWidth)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildHeight: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildHeight);
    when(mockBuildHeight)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildOffsetX: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetX);
    when(mockBuildOffsetX)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildOffsetY: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetY);
    when(mockBuildOffsetY)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildRadius: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildRadius);
    when(mockBuildRadius)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    const result = ntfclipanimstyle1.subtract(ntfclipanimstyle2);

    expect(result.clipWidth).assertEqual(50);
    expect(result.clipHeight).assertEqual(50);
    expect(result.clipOffsetX).assertEqual(10);
    expect(result.clipOffsetY).assertEqual(10);
    expect(result.clipRadius).assertEqual(2);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(true);

    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildWidth);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildHeight);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetX);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetY);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildRadius);
  });
  it('should_return_correct_result_when_simpleClipEnable_are_equal_but_isClipAnimEnable_are_not_equal_1', 0, () => {
    let ntfclipanimstyle1: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle1.clipWidth = 100;
    ntfclipanimstyle1.clipHeight = 100;
    ntfclipanimstyle1.clipOffsetX = 10;
    ntfclipanimstyle1.clipOffsetY = 10;
    ntfclipanimstyle1.clipRadius = 5;
    ntfclipanimstyle1.simpleClipEnable = true;
    ntfclipanimstyle1.isClipAnimEnable = true;

    let ntfclipanimstyle2: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle2.clipWidth = 50;
    ntfclipanimstyle2.clipHeight = 50;
    ntfclipanimstyle2.clipOffsetX = 5;
    ntfclipanimstyle2.clipOffsetY = 5;
    ntfclipanimstyle2.clipRadius = 3;
    ntfclipanimstyle2.simpleClipEnable = true;
    ntfclipanimstyle2.isClipAnimEnable = false;
    let mocker: MockKit = new MockKit();

    let mockBuildWidth: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildWidth);
    when(mockBuildWidth)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildHeight: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildHeight);
    when(mockBuildHeight)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildOffsetX: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetX);
    when(mockBuildOffsetX)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildOffsetY: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetY);
    when(mockBuildOffsetY)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    let mockBuildRadius: Function = mocker.mockFunc(ntfclipanimstyle1, ntfclipanimstyle1.buildRadius);
    when(mockBuildRadius)(ArgumentMatchers.anyNumber).afterReturn(ntfclipanimstyle1);

    const result = ntfclipanimstyle1.subtract(ntfclipanimstyle2);

    expect(result.clipWidth).assertEqual(50);
    expect(result.clipHeight).assertEqual(50);
    expect(result.clipOffsetX).assertEqual(10);
    expect(result.clipOffsetY).assertEqual(10);
    expect(result.clipRadius).assertEqual(2);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(true);

    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildWidth);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildHeight);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetX);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildOffsetY);
    mocker.ignoreMock(ntfclipanimstyle1, ntfclipanimstyle1.buildRadius);
  });
  it('should_return_correct_clipWidth_when_scale_is_greater_than_1', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.clipWidth = 100;
    ntfclipanimstyle.clipHeight = 200;
    ntfclipanimstyle.clipOffsetX = 50;
    ntfclipanimstyle.clipOffsetY = 75;
    ntfclipanimstyle.clipRadius = 15;
    ntfclipanimstyle.simpleClipEnable = true;
    ntfclipanimstyle.isClipAnimEnable = false;

    let result = ntfclipanimstyle.multiply(2);
    expect(result.clipWidth).assertEqual(200);
    expect(result.clipHeight).assertEqual(400);
    expect(result.clipOffsetX).assertEqual(100);
    expect(result.clipOffsetY).assertEqual(150);
    expect(result.clipRadius).assertEqual(30);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(false);
  });

  it('should_return_correct_clipWidth_when_scale_is_less_than_1', 0, () => {
    let ntfclipanimstyle: NtfClipAnimStyle = new NtfClipAnimStyle();
    ntfclipanimstyle.clipWidth = 100;
    ntfclipanimstyle.clipHeight = 200;
    ntfclipanimstyle.clipOffsetX = 50;
    ntfclipanimstyle.clipOffsetY = 75;
    ntfclipanimstyle.clipRadius = 15;
    ntfclipanimstyle.simpleClipEnable = true;
    ntfclipanimstyle.isClipAnimEnable = false;

    let result = ntfclipanimstyle.multiply(0.5);
    expect(result.clipWidth).assertEqual(50);
    expect(result.clipHeight).assertEqual(100);
    expect(result.clipOffsetX).assertEqual(25);
    expect(result.clipOffsetY).assertEqual(37.5);
    expect(result.clipRadius).assertEqual(7.5);
    expect(result.simpleClipEnable).assertEqual(true);
    expect(result.isClipAnimEnable).assertEqual(false);
  });

}