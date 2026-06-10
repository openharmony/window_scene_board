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

import { ILiveCardOtherVm } from '../../../../../../main/ets/live/interface/ILiveCardOtherVm';
import { LiveItemBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCardType, LiveRichTextModel } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveCardOtherModel } from '../../../../../../main/ets/live/model/LiveCardOtherModel';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { AccessibilityVm } from '../../../../../../main/ets/vm/AccessibilityVm';
import { ResourceVm } from '../../../../../../main/ets/vm/ResourceVm';
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
import { LiveCardOtherVm } from '../../../../../../main/ets/live/vm/LiveCardOtherVm';

export default function LiveCardOtherVmTest() {
  describe('replaceTimeHolder_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_card_timer_is_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = null;
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}");
      expect(result).assertEqual("");
    });

    it('should_return_text_without_time_placeholder_when_card_timer_is_null_and_isAccessibilityText_is_true', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = null;
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}", true);
      expect(result).assertEqual("Hello ");
    });

    it('should_return_text_with_time_text_when_card_timer_is_not_null_and_isAccessibilityText_is_true', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let mocker: MockKit = new MockKit();
      let mockGetTimerVm: Function = mocker.mockFunc(livecardothervm.vmInjector, livecardothervm.vmInjector.getTimerVm);
      when(mockGetTimerVm)().afterReturn({
        getTimerAccessibilityText: (timer: string) => "00:00:00"
      });
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}", true);
      expect(result).assertEqual("Hello 00:00:00");
      mocker.ignoreMock(livecardothervm.vmInjector, livecardothervm.vmInjector.getTimerVm);
    });

    it('should_return_text_with_time_text_when_card_timer_is_not_null_and_isAccessibilityText_is_false', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let mocker: MockKit = new MockKit();
      let mockGetTimerVm: Function = mocker.mockFunc(livecardothervm.vmInjector, livecardothervm.vmInjector.getTimerVm);
      when(mockGetTimerVm)().afterReturn({
        getTimerText: (timer: string) => "00:00:00"
      });
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}", false);
      expect(result).assertEqual("Hello 00:00:00");
      mocker.ignoreMock(livecardothervm.vmInjector, livecardothervm.vmInjector.getTimerVm);
    });

    it('should_return_text_with_time_text_when_card_timer_is_not_null_and_isAccessibilityText_is_false_and_text_contains_time_placeholder',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let card: LiveCardOtherModel = new LiveCardOtherModel();
        card.timer = "00:00:00";
        livecardothervm.card = card;
        let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}", false);
        expect(result).assertEqual("Hello 00:00:00");
      });

    it('should_return_text_with_time_text_when_card_timer_is_not_null_and_isAccessibilityText_is_true_and_text_contains_time_placeholder',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let card: LiveCardOtherModel = new LiveCardOtherModel();
        card.timer = "00:00:00";
        livecardothervm.card = card;
        let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}", true);
        expect(result).assertEqual("Hello 00:00:00");
      });

    it('should_return_empty_string_when_result_is_trimmed_and_length_is_zero', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("     ", true);
      expect(result).assertEqual("");
    });

    it('should_return_empty_string_when_result_is_trimmed_and_length_is_zero_2', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("     ", false);
      expect(result).assertEqual("");
    });

    it('should_return_empty_string_when_result_is_trimmed_and_length_is_zero_3', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}", true);
      expect(result).assertEqual("");
    });

    it('should_return_empty_string_when_result_is_trimmed_and_length_is_zero_4', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer}", false);
      expect(result).assertEqual("");
    });

    it('should_return_empty_string_when_result_is_trimmed_and_length_is_zero_5', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer} World", true);
      expect(result).assertEqual("Hello  World");
    });

    it('should_return_empty_string_when_result_is_trimmed_and_length_is_zero_6', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let card: LiveCardOtherModel = new LiveCardOtherModel();
      card.timer = "00:00:00";
      livecardothervm.card = card;
      let result = livecardothervm.replaceTimeHolder("Hello ${placeholder.timer} World", false);
      expect(result).assertEqual("Hello  World");
    });
  });

  describe('isHideLayout_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_cardType_is_NO_LAYOUT', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let cardModel: LiveCardOtherModel = new LiveCardOtherModel();
      cardModel.cardType = LiveCardType.NO_LAYOUT;
      livecardothervm.card = cardModel;
      const result = livecardothervm.isHideLayout();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_cardType_is_not_NO_LAYOUT', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let cardModel: LiveCardOtherModel = new LiveCardOtherModel();
      cardModel.cardType = LiveCardType.RICH_TEXT;
      livecardothervm.card = cardModel;
      const result = livecardothervm.isHideLayout();
      expect(result).assertEqual(false);
    });
  });

  describe('getContentAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)().afterReturn(false);
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
    });

    it('should_return_concatenated_text_when_accessibility_is_enabled', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(livecardothervm, livecardothervm.card);
      let liveCardOtherModel: LiveCardOtherModel = new LiveCardOtherModel();
      liveCardOtherModel.fixedContent = [
        new LiveRichTextModel('Hello'),
        new LiveRichTextModel('World')
      ];
      when(mockfunc2)().afterReturn(liveCardOtherModel);
      let mockfunc3: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('ReplacedText');
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('ReplacedTextReplacedText');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
      mocker.ignoreMock(livecardothervm, livecardothervm.card);
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_empty_string_when_fixedContent_is_empty', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(livecardothervm, livecardothervm.card);
      let liveCardOtherModel: LiveCardOtherModel = new LiveCardOtherModel();
      liveCardOtherModel.fixedContent = [];
      when(mockfunc2)().afterReturn(liveCardOtherModel);
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
      mocker.ignoreMock(livecardothervm, livecardothervm.card);
    });
  });

  describe('getTitleAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_AccessibilityVm_instance_is_not_enabled', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(false);
      const result = livecardothervm.getTitleAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
    });

    it('should_return_result_of_replaceTimeHolder_when_AccessibilityVm_instance_is_enabled', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc2)('test', true).afterReturn('mockedResult');
      const result = livecardothervm.getTitleAccessibilityText();
      expect(result).assertEqual('mockedResult');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });
  });

  describe('getContentText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_richText_is_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let result = livecardothervm.getContentText(null);
      expect(result).assertEqual('');
    });

    it('should_return_result_from_replaceTimeHolder_when_richText_is_not_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn("mocked result");
      let richText: LiveRichTextModel = new LiveRichTextModel();
      richText.text = "test text";
      let result = livecardothervm.getContentText(richText);
      expect(result).assertEqual("mocked result");
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });
  });

  describe('getContentFontColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_default_font_color_when_richText_is_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let result = livecardothervm.getContentFontColor(null);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR);
    });

    it('should_return_richText_font_color_when_richText_is_not_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let richText: LiveRichTextModel = new LiveRichTextModel();
      richText.textColor = LiveStyle.LIVE_CARD_ADDITIONAL_TEXT_COLOR;
      let result = livecardothervm.getContentFontColor(richText);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_ADDITIONAL_TEXT_COLOR);
    });
  });

  describe('getContentFontWeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_FontWeight_Regular_when_richText_is_not_RichText_type', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let result = livecardothervm.getContentFontWeight(null as any);
      expect(result).assertEqual(FontWeight.Regular);
    });

    it('should_return_FontWeight_Regular_when_richText_is_RichText_type_but_has_no_fontWeight_attribute', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let richText = new LiveRichTextModel();
      let result = livecardothervm.getContentFontWeight(richText);
      expect(result).assertEqual(FontWeight.Regular);
    });

    it('should_return_FontWeight_Medium_when_richText_is_RichText_type_and_has_fontWeight_attribute_Medium', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let richText = new LiveRichTextModel();
      richText.fontWeight = FontWeight.Medium;
      let result = livecardothervm.getContentFontWeight(richText);
      expect(result).assertEqual(FontWeight.Medium);
    });
  });

  describe('getTimerContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_content_when_replaceTimeHolder_returns_content', 0, async () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn("newContent");
      const result = livecardothervm.getTimerContent("oldContent");
      expect(result).assertEqual("newContent");
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });
  });

  describe('getFixedAreaHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_height', 0, async () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockfunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(10);

      const result = livecardothervm.getFixedAreaHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_FIXED_HEIGHT + 10);
      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });
  });

  describe('getCardHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_live_system_card_height_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_other_card_height_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_system_card_height_plus_font_scale_height_diff_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });

    it('should_return_live_other_card_height_plus_font_scale_height_diff_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });
    it('should_return_live_system_card_height_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_other_card_height_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_system_card_height_plus_font_scale_height_diff_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });

    it('should_return_live_other_card_height_plus_font_scale_height_diff_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });
    it('should_return_live_system_card_height_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_other_card_height_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_system_card_height_plus_font_scale_height_diff_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });

    it('should_return_live_other_card_height_plus_font_scale_height_diff_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });
    it('should_return_live_system_card_height_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_other_card_height_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_system_card_height_plus_font_scale_height_diff_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });

    it('should_return_live_other_card_height_plus_font_scale_height_diff_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });
    it('should_return_live_system_card_height_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_other_card_height_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
    });

    it('should_return_live_system_card_height_plus_font_scale_height_diff_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });

    it('should_return_live_other_card_height_plus_font_scale_height_diff_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.isHideLayout);
      when(mockfunc)([]).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockfunc2)([ArgumentMatchers.anyNumber]).afterReturn(10);
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT + 10);
      mocker.ignoreMock(livecardothervm, livecardothervm.isHideLayout);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });
  });

  describe('isHideLayout_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_cardType_is_NO_LAYOUT', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mockKit: MockKit = new MockKit();
      let mockLiveCardOtherModel: LiveCardOtherModel = new LiveCardOtherModel();
      mockLiveCardOtherModel.cardType = LiveCardType.NO_LAYOUT;
      livecardothervm.card = mockLiveCardOtherModel;
      const result = livecardothervm.isHideLayout();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_cardType_is_not_NO_LAYOUT', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mockKit: MockKit = new MockKit();
      let mockLiveCardOtherModel: LiveCardOtherModel = new LiveCardOtherModel();
      mockLiveCardOtherModel.cardType = LiveCardType.RICH_TEXT;
      livecardothervm.card = mockLiveCardOtherModel;
      const result = livecardothervm.isHideLayout();
      expect(result).assertEqual(false);
    });
  });

  describe('getTitleAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_AccessibilityVm_instance_is_not_enabled', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      AccessibilityVm.instance.isEnabled = false;
      const result = livecardothervm.getTitleAccessibilityText();
      expect(result).assertEqual('');
    });

    it('should_return_result_of_replaceTimeHolder_when_AccessibilityVm_instance_is_enabled', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('mocked result');
      AccessibilityVm.instance.isEnabled = true;
      const result = livecardothervm.getTitleAccessibilityText();
      expect(result).assertEqual('mocked result');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });
  });

  describe('getContentAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_AccessibilityVm_instance_is_not_enabled', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      AccessibilityVm.instance.isEnabled = false;
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('');
    });

    it('should_return_concatenated_text_when_AccessibilityVm_instance_is_enabled', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('test');
      AccessibilityVm.instance.isEnabled = true;
      let richText1: LiveRichTextModel = { text: 'richText1' };
      let richText2: LiveRichTextModel = { text: 'richText2' };
      livecardothervm.card.fixedContent = [richText1, richText2];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('testtest');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_concatenated_text_with_time_holders_replaced_when_AccessibilityVm_instance_is_enabled', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('test');
      AccessibilityVm.instance.isEnabled = true;
      let richText1: LiveRichTextModel = { text: 'richText1{timeHolder1}' };
      let richText2: LiveRichTextModel = { text: 'richText2{timeHolder2}' };
      livecardothervm.card.fixedContent = [richText1, richText2];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('testtest');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_concatenated_text_with_time_holders_replaced_when_AccessibilityVm_instance_is_enabled_and_time_holders_are_empty', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('test');
      AccessibilityVm.instance.isEnabled = true;
      let richText1: LiveRichTextModel = { text: 'richText1{}' };
      let richText2: LiveRichTextModel = { text: 'richText2{}' };
      livecardothervm.card.fixedContent = [richText1, richText2];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('testtest');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_concatenated_text_with_time_holders_replaced_when_AccessibilityVm_instance_is_enabled_and_time_holders_are_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('test');
      AccessibilityVm.instance.isEnabled = true;
      let richText1: LiveRichTextModel = { text: 'richText1{timeHolder1}' };
      let richText2: LiveRichTextModel = { text: 'richText2{timeHolder2}' };
      livecardothervm.card.fixedContent = [richText1, richText2];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('testtest');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_concatenated_text_with_time_holders_replaced_when_AccessibilityVm_instance_is_enabled_and_time_holders_are_undefined', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('test');
      AccessibilityVm.instance.isEnabled = true;
      let richText1: LiveRichTextModel = { text: 'richText1{timeHolder1}' };
      let richText2: LiveRichTextModel = { text: 'richText2{timeHolder2}' };
      livecardothervm.card.fixedContent = [richText1, richText2];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('testtest');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_concatenated_text_with_time_holders_replaced_when_AccessibilityVm_instance_is_enabled_and_time_holders_are_same', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('test');
      AccessibilityVm.instance.isEnabled = true;
      let richText1: LiveRichTextModel = { text: 'richText1{timeHolder1}' };
      let richText2: LiveRichTextModel = { text: 'richText2{timeHolder1}' };
      livecardothervm.card.fixedContent = [richText1, richText2];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('testtest');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_concatenated_text_with_time_holders_replaced_when_AccessibilityVm_instance_is_enabled_and_time_holders_are_different', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('test');
      AccessibilityVm.instance.isEnabled = true;
      let richText1: LiveRichTextModel = { text: 'richText1{timeHolder1}' };
      let richText2: LiveRichTextModel = { text: 'richText2{timeHolder2}' };
      livecardothervm.card.fixedContent = [richText1, richText2];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('testtest');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_empty_string_when_fixedContent_is_empty', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      AccessibilityVm.instance.isEnabled = true;
      livecardothervm.card.fixedContent = [];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_richText_text_is_empty', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('');
      AccessibilityVm.instance.isEnabled = true;
      let richText: LiveRichTextModel = { text: '' };
      livecardothervm.card.fixedContent = [richText];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_empty_string_when_richText_text_is_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('');
      AccessibilityVm.instance.isEnabled = true;
      let richText: LiveRichTextModel = { text: null };
      livecardothervm.card.fixedContent = [richText];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_empty_string_when_richText_text_is_undefined', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('');
      AccessibilityVm.instance.isEnabled = true;
      let richText: LiveRichTextModel = { text: undefined };
      livecardothervm.card.fixedContent = [richText];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_replaced_text_with_multiple_time_holders', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('replaced');
      AccessibilityVm.instance.isEnabled = true;
      let richText: LiveRichTextModel = { text: 'text{time1}{time2}' };
      livecardothervm.card.fixedContent = [richText];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('replaced');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_original_text_without_time_holders', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean).afterReturn('original');
      AccessibilityVm.instance.isEnabled = true;
      let richText: LiveRichTextModel = { text: 'original' };
      livecardothervm.card.fixedContent = [richText];
      const result = livecardothervm.getContentAccessibilityText();
      expect(result).assertEqual('original');
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });
  });

  describe('getCardHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_live_system_card_height_when_isHideLayout_is_true', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      livecardothervm.isHideLayout = () => true;
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
    });

    it('should_return_live_other_card_height_when_isHideLayout_is_false', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      livecardothervm.isHideLayout = () => false;
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT);
    });

    it('should_return_live_system_card_height_when_isHideLayout_is_undefined', 0, () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      livecardothervm.isHideLayout = undefined;
      const result = livecardothervm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
    });
  });

  describe('getFixedAreaHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_height_when_getFixedAreaHeight_is_called', 0, async () => {
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockfunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(10);

      const result = livecardothervm.getFixedAreaHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_FIXED_HEIGHT + 10);

      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });
  });

  describe('getTimerContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_content_when_content_is_not_null', 0, async () => {
      // Arrange
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn("mocked_content");

      // Act
      let result = livecardothervm.getTimerContent("test_content");

      // Assert
      expect(result).assertEqual("mocked_content");
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });

    it('should_return_content_when_content_is_null', 0, async () => {
      // Arrange
      let livecardothervm: LiveCardOtherVm = new LiveCardOtherVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardothervm, livecardothervm.replaceTimeHolder);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      // Act
      let result = livecardothervm.getTimerContent(null);

      // Assert
      expect(result).assertNull();
      mocker.ignoreMock(livecardothervm, livecardothervm.replaceTimeHolder);
    });
  });

  describe('getContentFontWeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_FontWeight_Regular_when_richText_is_not_RichText_type', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let result = livecardothervm.getContentFontWeight(LiveCardType.RICH_TEXT);
      expect(result).assertEqual(FontWeight.Regular);
    });

    it('should_return_FontWeight_Regular_when_richText_is_RichText_type_and_contentRenderGroup_is_false', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
      livecardothervm.contentRenderGroup = false;
      let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
      expect(result).assertEqual(FontWeight.Regular);
    });

    it('should_return_FontWeight_Regular_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_false',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = false;
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Regular);
      });

    it('should_return_FontWeight_Regular_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_true_and_richTextFontSize_is_not_richTextFontSize_type',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = true;
        livecardothervm.richTextFontSize = '12fp';
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Regular);
      });

    it('should_return_FontWeight_Regular_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_true_and_richTextFontSize_is_richTextFontSize_type_and_value_is_0',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = true;
        livecardothervm.richTextFontSize = {
          value: 0
        };
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Regular);
      });

    it('should_return_FontWeight_Medium_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_true_and_richTextFontSize_is_richTextFontSize_type_and_value_is_1',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = true;
        livecardothervm.richTextFontSize = {
          value: 1
        };
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Medium);
      });

    it('should_return_FontWeight_Bold_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_true_and_richTextFontSize_is_richTextFontSize_type_and_value_is_2',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = true;
        livecardothervm.richTextFontSize = {
          value: 2
        };
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Bold);
      });

    it('should_return_FontWeight_Bold_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_true_and_richTextFontSize_is_richTextFontSize_type_and_value_is_3',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = true;
        livecardothervm.richTextFontSize = {
          value: 3
        };
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Bold);
      });

    it('should_return_FontWeight_Bold_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_true_and_richTextFontSize_is_richTextFontSize_type_and_value_is_4',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = true;
        livecardothervm.richTextFontSize = {
          value: 4
        };
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Bold);
      });

    it('should_return_FontWeight_Bold_when_richText_is_RichText_type_and_contentRenderGroup_is_true_and_isShowUnderline_is_true_and_richTextFontSize_is_richTextFontSize_type_and_value_is_5',
      0, () => {
        let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
        let mockLiveRichTextModel: LiveRichTextModel = new LiveRichTextModel();
        livecardothervm.contentRenderGroup = true;
        livecardothervm.isShowUnderline = true;
        livecardothervm.richTextFontSize = {
          value: 5
        };
        let result = livecardothervm.getContentFontWeight(mockLiveRichTextModel);
        expect(result).assertEqual(FontWeight.Bold);
      });
  })

  describe('getContentFontColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_default_font_color_when_richText_is_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let richText: LiveRichTextModel | undefined = undefined;
      const result = livecardothervm.getContentFontColor(richText);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR);
    });

    it('should_return_richText_font_color_when_richText_is_not_null', 0, () => {
      let livecardothervm: ILiveCardOtherVm = new LiveCardOtherVm();
      let richText: LiveRichTextModel = new LiveRichTextModel();
      richText.textColor = LiveStyle.LIVE_CARD_HIGHLIGHT_FONT_COLOR;
      const result = livecardothervm.getContentFontColor(richText);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_HIGHLIGHT_FONT_COLOR);
    });
  });
}