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
import { RectInfo } from '@ohos/basicutils/src/main/ets/utils/RectInfo';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/utils/RTLUtil';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { CardScaleUtil } from '../../../main/ets/utils/CardScaleUtil';

export default function CardScaleUtilTest() {
  describe('getWidth_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originWidth_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getWidth(true, undefined);
        let result2 = CardScaleUtil.getWidth(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originWidth_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originWidth_is_number', 0,
      () => {
        let originWidth = 100;
        let result = CardScaleUtil.getWidth(true, originWidth);
        expect(result).assertEqual(originWidth * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originWidth_when_needScale_is_true_and_originWidth_is_string', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(true, originWidth);
      expect(result).assertEqual(originWidth);
    });

    it('should_return_originWidth_when_needScale_is_false', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(false, originWidth);
      expect(result).assertEqual(originWidth);
    });


    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originHeight_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getHeight(true, undefined);
        let result2 = CardScaleUtil.getHeight(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originHeight_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originHeight_is_number', 0,
      () => {
        let originHeight = 100;
        let result = CardScaleUtil.getHeight(true, originHeight);
        expect(result).assertEqual(originHeight * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originHeight_when_needScale_is_true_and_originHeight_is_string', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(true, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_originHeight_when_needScale_is_false', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(false, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originHeight_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getHeight(true, undefined);
        let result2 = CardScaleUtil.getHeight(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originHeight_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originHeight_is_number', 0,
      () => {
        let originHeight = 100;
        let result = CardScaleUtil.getHeight(true, originHeight);
        expect(result).assertEqual(originHeight * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originHeight_when_needScale_is_true_and_originHeight_is_string', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(true, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_originHeight_when_needScale_is_false', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(false, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_CARD_SCALE_VERTICAL_CENTER_when_needScale_is_true_and_type_is_SCALE_VERTICAL_CENTER', 0, () => {
      let needScale: boolean = true;
      let type: CardScaleType = CardScaleType.SCALE_VERTICAL_CENTER;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertEqual(CardScaleUtil.CARD_SCALE_VERTICAL_CENTER);
    });

    it('should_return_CARD_SCALE_LEFT_TOP_when_needScale_is_true_and_type_is_SCALE_TOP_LEFT', 0, () => {
      let needScale: boolean = true;
      let type: CardScaleType = CardScaleType.SCALE_TOP_LEFT;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertEqual(CardScaleUtil.CARD_SCALE_LEFT_TOP);
    });

    it('should_return_CARD_SCALE_VERTICAL_CENTER_RTL_when_needScale_is_true_and_type_is_SCALE_VERTICAL_CENTER_SELF_and_RTLUtil_is_RTL',
      0, () => {
        let needScale: boolean = true;
        let type: CardScaleType = CardScaleType.SCALE_VERTICAL_CENTER_SELF;
        let mocker: MockKit = new MockKit();
        when(mocker.mockFunc(RTLUtil, RTLUtil.isRTL))().afterReturn(true);
        const result = CardScaleUtil.getScale(needScale, type);
        expect(result).assertEqual(CardScaleUtil.CARD_SCALE_VERTICAL_CENTER_RTL);
      });

    it('should_return_CARD_SCALE_CENTER_when_needScale_is_true_and_type_is_not_SCALE_VERTICAL_CENTER_SELF', 0, () => {
      let needScale: boolean = true;
      let type: CardScaleType = CardScaleType.SCALE_CENTER;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertEqual(CardScaleUtil.CARD_SCALE_CENTER);
    });

    it('should_return_undefined_when_needScale_is_false', 0, () => {
      let needScale: boolean = false;
      let type: CardScaleType = CardScaleType.SCALE_CENTER;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertUndefined();
    });

    it('should_scale_rect_when_width_is_provided', 0, () => {
      let rectInfo: RectInfo = new RectInfo(0, 0, 100, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE + 0);
      expect(result.left).assertEqual(0);
    });

    it('should_scale_rect_when_width_is_not_provided', 0, () => {
      let rectInfo: RectInfo = new RectInfo(0, 0, 0, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE + 0);
      expect(result.left).assertEqual(0);
    });

    it('should_scale_rect_when_RTLUtil_is_RTL', 0, () => {
      let mocker: MockKit = new MockKit();
      when(RTLUtil.isRTL)([]).afterReturn(true);
      let rectInfo: RectInfo = new RectInfo(0, 0, 100, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(0);
      expect(result.left).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
    });

    it('should_scale_rect_when_RTLUtil_is_not_RTL', 0, () => {
      let mocker: MockKit = new MockKit();
      when(RTLUtil.isRTL)([]).afterReturn(false);
      let rectInfo: RectInfo = new RectInfo(0, 0, 100, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE + 0);
      expect(result.left).assertEqual(0);
    });

    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originWidth_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getWidth(true, undefined);
        let result2 = CardScaleUtil.getWidth(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originWidth_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originWidth_is_number', 0,
      () => {
        let originWidth = 100;
        let result = CardScaleUtil.getWidth(true, originWidth);
        expect(result).assertEqual(originWidth * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originWidth_when_needScale_is_true_and_originWidth_is_string', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(true, originWidth);
      expect(result).assertEqual(originWidth);
    });

    it('should_return_originWidth_when_needScale_is_false', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(false, originWidth);
      expect(result).assertEqual(originWidth);
    });

    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originWidth_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getWidth(true, undefined);
        let result2 = CardScaleUtil.getWidth(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originWidth_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originWidth_is_number', 0,
      () => {
        let originWidth = 100;
        let result = CardScaleUtil.getWidth(true, originWidth);
        expect(result).assertEqual(originWidth * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originWidth_when_needScale_is_true_and_originWidth_is_string', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(true, originWidth);
      expect(result).assertEqual(originWidth);
    });

    it('should_return_originWidth_when_needScale_is_false', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(false, originWidth);
      expect(result).assertEqual(originWidth);
    });


    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originHeight_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getHeight(true, undefined);
        let result2 = CardScaleUtil.getHeight(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originHeight_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originHeight_is_number', 0,
      () => {
        let originHeight = 100;
        let result = CardScaleUtil.getHeight(true, originHeight);
        expect(result).assertEqual(originHeight * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originHeight_when_needScale_is_true_and_originHeight_is_string', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(true, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_originHeight_when_needScale_is_false', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(false, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originHeight_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getHeight(true, undefined);
        let result2 = CardScaleUtil.getHeight(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originHeight_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originHeight_is_number', 0,
      () => {
        let originHeight = 100;
        let result = CardScaleUtil.getHeight(true, originHeight);
        expect(result).assertEqual(originHeight * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originHeight_when_needScale_is_true_and_originHeight_is_string', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(true, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_originHeight_when_needScale_is_false', 0, () => {
      let originHeight = "100";
      let result = CardScaleUtil.getHeight(false, originHeight);
      expect(result).assertEqual(originHeight);
    });

    it('should_return_CARD_SCALE_VERTICAL_CENTER_when_needScale_is_true_and_type_is_SCALE_VERTICAL_CENTER', 0, () => {
      let needScale: boolean = true;
      let type: CardScaleType = CardScaleType.SCALE_VERTICAL_CENTER;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertEqual(CardScaleUtil.CARD_SCALE_VERTICAL_CENTER);
    });

    it('should_return_CARD_SCALE_LEFT_TOP_when_needScale_is_true_and_type_is_SCALE_TOP_LEFT', 0, () => {
      let needScale: boolean = true;
      let type: CardScaleType = CardScaleType.SCALE_TOP_LEFT;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertEqual(CardScaleUtil.CARD_SCALE_LEFT_TOP);
    });

    it('should_return_CARD_SCALE_VERTICAL_CENTER_RTL_when_needScale_is_true_and_type_is_SCALE_VERTICAL_CENTER_SELF_and_RTLUtil_is_RTL',
      0, () => {
        let needScale: boolean = true;
        let type: CardScaleType = CardScaleType.SCALE_VERTICAL_CENTER_SELF;
        let mocker: MockKit = new MockKit();
        when(mocker.mockFunc(RTLUtil, RTLUtil.isRTL))().afterReturn(true);
        const result = CardScaleUtil.getScale(needScale, type);
        expect(result).assertEqual(CardScaleUtil.CARD_SCALE_VERTICAL_CENTER_RTL);
      });

    it('should_return_CARD_SCALE_CENTER_when_needScale_is_true_and_type_is_not_SCALE_VERTICAL_CENTER_SELF', 0, () => {
      let needScale: boolean = true;
      let type: CardScaleType = CardScaleType.SCALE_CENTER;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertEqual(CardScaleUtil.CARD_SCALE_CENTER);
    });

    it('should_return_undefined_when_needScale_is_false', 0, () => {
      let needScale: boolean = false;
      let type: CardScaleType = CardScaleType.SCALE_CENTER;
      const result = CardScaleUtil.getScale(needScale, type);
      expect(result).assertUndefined();
    });

    it('should_scale_rect_when_width_is_provided', 0, () => {
      let rectInfo: RectInfo = new RectInfo(0, 0, 100, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE + 0);
      expect(result.left).assertEqual(0);
    });

    it('should_scale_rect_when_width_is_not_provided', 0, () => {
      let rectInfo: RectInfo = new RectInfo(0, 0, 0, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE + 0);
      expect(result.left).assertEqual(0);
    });

    it('should_scale_rect_when_RTLUtil_is_RTL', 0, () => {
      let mocker: MockKit = new MockKit();
      when(RTLUtil.isRTL)([]).afterReturn(true);
      let rectInfo: RectInfo = new RectInfo(0, 0, 100, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(0);
      expect(result.left).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
    });

    it('should_scale_rect_when_RTLUtil_is_not_RTL', 0, () => {
      let mocker: MockKit = new MockKit();
      when(RTLUtil.isRTL)([]).afterReturn(false);
      let rectInfo: RectInfo = new RectInfo(0, 0, 100, 100);
      let result: RectInfo = CardScaleUtil.scaleRect(rectInfo);
      expect(result.width).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE);
      expect(result.right).assertEqual(100 * CardScaleUtil.CARD_SCALE_RATE + 0);
      expect(result.left).assertEqual(0);
    });

    it('should_return_CARD_ZOOM_IN_RATE_PERCENT_when_needScale_is_true_and_originWidth_is_undefined_or_ONE_HUNDRED_PERCENT',
      0, () => {
        let result1 = CardScaleUtil.getWidth(true, undefined);
        let result2 = CardScaleUtil.getWidth(true, CardScaleUtil.ONE_HUNDRED_PERCENT);
        expect(result1).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
        expect(result2).assertEqual(CardScaleUtil.CARD_ZOOM_IN_RATE_PERCENT);
      });

    it('should_return_originWidth_times_CARD_ZOOM_IN_RATE_NUMBER_when_needScale_is_true_and_originWidth_is_number', 0,
      () => {
        let originWidth = 100;
        let result = CardScaleUtil.getWidth(true, originWidth);
        expect(result).assertEqual(originWidth * CardScaleUtil.CARD_ZOOM_IN_RATE_NUMBER);
      });

    it('should_return_originWidth_when_needScale_is_true_and_originWidth_is_string', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(true, originWidth);
      expect(result).assertEqual(originWidth);
    });

    it('should_return_originWidth_when_needScale_is_false', 0, () => {
      let originWidth = "100px";
      let result = CardScaleUtil.getWidth(false, originWidth);
      expect(result).assertEqual(originWidth);
    });

    it('should_init_language_and_font_size_and_subscribe_to_configuration_event_when_no_error_occurs', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterReturnNothing();

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterReturnNothing();

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterReturnNothing();

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });

    it('should_log_error_when_init_language_throws_error', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterThrow("Error");

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterReturnNothing();

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterReturnNothing();

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });

    it('should_log_error_when_init_font_size_throws_error', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterReturnNothing();

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterThrow("Error");

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterReturnNothing();

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });

    it('should_log_error_when_subscribe_to_configuration_event_throws_error', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterReturnNothing();

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterReturnNothing();

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterThrow("Error");

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });
  });
}