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
import { i18n } from '@kit.LocalizationKit';
import { RTLUtil } from '@ohos/componenthelper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveViewCapsuleStyle } from '../../../../../main/ets/liveview/common/LiveViewCapsuleStyle';
import measure from '@ohos.measure';
import { capsuleStateMgr } from '../../../../../main/ets/liveview/CapsuleManager';
import { OverlayStartAnimHelper } from '../../../../../main/ets/overlay/OverlayStartAnimHelper';
import { CapsuleListState } from '../../../../../main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../../main/ets/liveview/component/capsule/CapsuleMarquee';
export default function Test() {
  describe('buildMarquee_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_correct_values_for_all_properties', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockStart: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.start);
      let mockFinish: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onFinish);
      let mockDisappear: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onDisAppear);

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      let mockDraggable: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.draggable);
      let mockAlign: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.align);

      let mockFontSize: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      let mockFontColor: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      let mockMarqueeUpdateStrategy: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      let mockFontWeight: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      let mockFontFamily: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      let mockOnFinish: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      let mockOnDisAppear: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);

      when(mockStart)(ArgumentMatchers.any).afterReturn(new Marquee());
      when(mockFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockDisappear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockDraggable)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockAlign)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockMarqueeUpdateStrategy)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontFamily)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnDisAppear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());

      let capsule = new CapsuleMarquee();
      capsule.content = {
        contentText: 'test text',
        textSize: 10
      };
      capsule.isMarqueeRunning = false;
      capsule.isMarqueeBack = false;
      capsule.isMarqueeAppearred = false;
      capsule.buildMarquee();

      expect(capsule.isMarqueeRunning).assertEqual(false);
      expect(capsule.isMarqueeBack).assertEqual(true);
      expect(capsule.isMarqueeAppearred).assertEqual(false);

      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.start);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onFinish);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onDisAppear);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.draggable);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.align);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);
    });

    it('should_set_correct_values_for_all_properties', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockStart: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.start);
      let mockFinish: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onFinish);
      let mockDisappear: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onDisAppear);

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      let mockDraggable: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.draggable);
      let mockAlign: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.align);

      let mockFontSize: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      let mockFontColor: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      let mockMarqueeUpdateStrategy: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      let mockFontWeight: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      let mockFontFamily: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      let mockOnFinish: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      let mockOnDisAppear: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);

      when(mockStart)(ArgumentMatchers.any).afterReturn(new Marquee());
      when(mockFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockDisappear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockDraggable)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockAlign)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockMarqueeUpdateStrategy)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontFamily)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnDisAppear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());

      let capsule = new CapsuleMarquee();
      capsule.content = {
        contentText: 'test text',
        textSize: 10
      };
      capsule.isMarqueeRunning = false;
      capsule.isMarqueeBack = false;
      capsule.isMarqueeAppearred = false;
      capsule.buildMarquee();

      expect(capsule.isMarqueeRunning).assertEqual(false);
      expect(capsule.isMarqueeBack).assertEqual(true);
      expect(capsule.isMarqueeAppearred).assertEqual(false);

      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.start);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onFinish);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onDisAppear);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.draggable);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.align);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);
    });

    it('should_set_correct_values_for_all_properties', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockStart: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.start);
      let mockFinish: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onFinish);
      let mockDisappear: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onDisAppear);

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      let mockDraggable: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.draggable);
      let mockAlign: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.align);

      let mockFontSize: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      let mockFontColor: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      let mockMarqueeUpdateStrategy: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      let mockFontWeight: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      let mockFontFamily: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      let mockOnFinish: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      let mockOnDisAppear: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);

      when(mockStart)(ArgumentMatchers.any).afterReturn(new Marquee());
      when(mockFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockDisappear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockDraggable)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockAlign)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockMarqueeUpdateStrategy)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontFamily)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnDisAppear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());

      let capsule = new CapsuleMarquee();
      capsule.content = {
        contentText: 'test text',
        textSize: 10
      };
      capsule.isMarqueeRunning = false;
      capsule.isMarqueeBack = false;
      capsule.isMarqueeAppearred = false;
      capsule.buildMarquee();

      expect(capsule.isMarqueeRunning).assertEqual(false);
      expect(capsule.isMarqueeBack).assertEqual(true);
      expect(capsule.isMarqueeAppearred).assertEqual(false);

      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.start);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onFinish);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onDisAppear);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.draggable);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.align);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);
    });

    it('should_set_correct_values_for_all_properties', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockStart: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.start);
      let mockFinish: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onFinish);
      let mockDisappear: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onDisAppear);

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      let mockDraggable: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.draggable);
      let mockAlign: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.align);

      let mockFontSize: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      let mockFontColor: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      let mockMarqueeUpdateStrategy: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      let mockFontWeight: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      let mockFontFamily: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      let mockOnFinish: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      let mockOnDisAppear: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);

      when(mockStart)(ArgumentMatchers.any).afterReturn(new Marquee());
      when(mockFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockDisappear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockDraggable)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockAlign)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockMarqueeUpdateStrategy)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontFamily)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnDisAppear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());

      let capsule = new CapsuleMarquee();
      capsule.content = {
        contentText: 'test text',
        textSize: 10
      };
      capsule.isMarqueeRunning = false;
      capsule.isMarqueeBack = false;
      capsule.isMarqueeAppearred = false;
      capsule.buildMarquee();

      expect(capsule.isMarqueeRunning).assertEqual(false);
      expect(capsule.isMarqueeBack).assertEqual(true);
      expect(capsule.isMarqueeAppearred).assertEqual(false);

      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.start);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onFinish);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onDisAppear);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.draggable);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.align);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);
    });

    it('should_set_correct_values_for_all_properties', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockStart: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.start);
      let mockFinish: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onFinish);
      let mockDisappear: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onDisAppear);

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      let mockDraggable: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.draggable);
      let mockAlign: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.align);

      let mockFontSize: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      let mockFontColor: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      let mockMarqueeUpdateStrategy: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      let mockFontWeight: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      let mockFontFamily: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      let mockOnFinish: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      let mockOnDisAppear: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);

      when(mockStart)(ArgumentMatchers.any).afterReturn(new Marquee());
      when(mockFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockDisappear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockDraggable)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockAlign)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockMarqueeUpdateStrategy)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontFamily)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnDisAppear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());

      let capsule = new CapsuleMarquee();
      capsule.content = {
        contentText: 'test text',
        textSize: 10
      };
      capsule.isMarqueeRunning = false;
      capsule.isMarqueeBack = false;
      capsule.isMarqueeAppearred = false;
      capsule.buildMarquee();

      expect(capsule.isMarqueeRunning).assertEqual(false);
      expect(capsule.isMarqueeBack).assertEqual(true);
      expect(capsule.isMarqueeAppearred).assertEqual(false);

      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.start);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onFinish);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onDisAppear);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.draggable);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.align);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);
    });

    it('should_set_correct_values_for_all_properties', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockStart: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.start);
      let mockFinish: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onFinish);
      let mockDisappear: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onDisAppear);

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      let mockDraggable: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.draggable);
      let mockAlign: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.align);

      let mockFontSize: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      let mockFontColor: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      let mockMarqueeUpdateStrategy: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      let mockFontWeight: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      let mockFontFamily: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      let mockOnFinish: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      let mockOnDisAppear: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);

      when(mockStart)(ArgumentMatchers.any).afterReturn(new Marquee());
      when(mockFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockDisappear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockDraggable)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockAlign)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockMarqueeUpdateStrategy)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontFamily)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnDisAppear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());

      let capsule = new CapsuleMarquee();
      capsule.content = {
        contentText: 'test text',
        textSize: 10
      };
      capsule.isMarqueeRunning = false;
      capsule.isMarqueeBack = false;
      capsule.isMarqueeAppearred = false;
      capsule.buildMarquee();

      expect(capsule.isMarqueeRunning).assertEqual(false);
      expect(capsule.isMarqueeBack).assertEqual(true);
      expect(capsule.isMarqueeAppearred).assertEqual(false);

      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.start);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onFinish);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onDisAppear);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.draggable);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.align);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);
    });

    it('should_set_correct_values_for_all_properties', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockStart: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.start);
      let mockFinish: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onFinish);
      let mockDisappear: Function = mocker.mockFunc(Marquee.prototype, Marquee.prototype.onDisAppear);

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      let mockDraggable: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.draggable);
      let mockAlign: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.align);

      let mockFontSize: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      let mockFontColor: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      let mockMarqueeUpdateStrategy: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      let mockFontWeight: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      let mockFontFamily: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      let mockOnFinish: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      let mockOnDisAppear: Function = mocker.mockFunc(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);

      when(mockStart)(ArgumentMatchers.any).afterReturn(new Marquee());
      when(mockFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockDisappear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockDraggable)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockAlign)(ArgumentMatchers.any).afterReturn(new CommonMethod());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockMarqueeUpdateStrategy)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockFontFamily)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnFinish)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());
      when(mockOnDisAppear)(ArgumentMatchers.any).afterReturn(new MarqueeAttribute());

      let capsule = new CapsuleMarquee();
      capsule.content = {
        contentText: 'test text',
        textSize: 10
      };
      capsule.isMarqueeRunning = false;
      capsule.isMarqueeBack = false;
      capsule.isMarqueeAppearred = false;
      capsule.buildMarquee();

      expect(capsule.isMarqueeRunning).assertEqual(false);
      expect(capsule.isMarqueeBack).assertEqual(true);
      expect(capsule.isMarqueeAppearred).assertEqual(false);

      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.start);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onFinish);
      mocker.ignoreMock(Marquee.prototype, Marquee.prototype.onDisAppear);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.draggable);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.align);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontSize);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontColor);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.marqueeUpdateStrategy);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontWeight);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.fontFamily);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onFinish);
      mocker.ignoreMock(MarqueeAttribute.prototype, MarqueeAttribute.prototype.onDisAppear);
    });
  });
}