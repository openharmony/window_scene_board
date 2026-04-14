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

import { ILiveCardSystemVm } from '../../../../../../main/ets/live/interface/ILiveCardSystemVm';
import { LiveItemBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCardSystemModel } from '../../../../../../main/ets/live/model/LiveCardSystemModel';
import { PhoneSimStatus, SysTypeCode } from '../../../../../../main/ets/liveview/common/LiveConstants';
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
import { LiveCardSystemVm } from '../../../../../../main/ets/live/vm/LiveCardSystemVm';

export default function LiveCardSystemVmTest() {
  describe('card_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_live_card_system_model_when_live_card_system_model_is_set', 0, () => {
      let livecardsystemvm: LiveCardSystemVm = new LiveCardSystemVm();
      let live: ILiveCardSystemVm = {
        card: new LiveCardSystemModel()
      } as ILiveCardSystemVm;
      livecardsystemvm.live = live;
      const result = livecardsystemvm.card;
      expect(result).assertInstanceOf(LiveCardSystemModel);
    });

    it('should_return_live_card_system_model_when_live_is_null', 0, () => {
      let livecardsystemvm: LiveCardSystemVm = new LiveCardSystemVm();
      livecardsystemvm.live = null as any;
      const result = livecardsystemvm.card;
      expect(result).assertInstanceOf(LiveCardSystemModel);
    });

    it('should_return_live_card_system_model_when_live_is_undefined', 0, () => {
      let livecardsystemvm: LiveCardSystemVm = new LiveCardSystemVm();
      livecardsystemvm.live = undefined as any;
      const result = livecardsystemvm.card;
      expect(result).assertInstanceOf(LiveCardSystemModel);
    });
  });

  describe('title_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_timer_text_when_timer_and_isTimerInTitle_are_true', 0, async () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = "123456";
      card.isTimerInTitle = true;
      livecardsystemvm.card = card;

      let vmInjector: any = {
        getTimerVm: function () {
          return {
            getTimerText: function () {
              return "Mocked Timer Text";
            }
          };
        }
      };
      livecardsystemvm.vmInjector = vmInjector;

      const result = livecardsystemvm.title;
      expect(result).assertEqual("Mocked Timer Text");
    });

    it('should_return_card_title_when_timer_or_isTimerInTitle_are_false', 0, async () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = "123456";
      card.isTimerInTitle = false;
      livecardsystemvm.card = card;

      let vmInjector: any = {
        getTimerVm: function () {
          return {
            getTimerText: function () {
              return "Mocked Timer Text";
            }
          };
        }
      };
      livecardsystemvm.vmInjector = vmInjector;

      const result = livecardsystemvm.title;
      expect(result).assertEqual("123456");
    });
  });

  describe('isBigTitle_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_card_timer_is_false', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.typeCode = SysTypeCode.BIG_TEXT_TIMER;
      livecardsystemvm.card = card;
      livecardsystemvm.live = live;
      livecardsystemvm.simIconColor = [LiveStyle.LIVE_CARD_TEXT_FONT_COLOR];
      livecardsystemvm.textFontSize = LiveStyle.SYSTEM_CARD_TEXT_FONT_SIZE;
      livecardsystemvm.titleFontColor = LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
      livecardsystemvm.textFontColor = LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
      livecardsystemvm.simIconSize = undefined;
      livecardsystemvm.maxFontScale = ResourceVm.DEFAULT_MAX_SCALE;
      livecardsystemvm.fontFixedAreaHeight = 32;
      const result = livecardsystemvm.isBigTitle;
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_live_typeCode_is_not_BIG_TEXT_TIMER', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = true;
      card.isTimerInTitle = true;
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.typeCode = SysTypeCode.NOT_BIG_TEXT_TIMER;
      livecardsystemvm.card = card;
      livecardsystemvm.live = live;
      livecardsystemvm.simIconColor = [LiveStyle.LIVE_CARD_TEXT_FONT_COLOR];
      livecardsystemvm.textFontSize = LiveStyle.SYSTEM_CARD_TEXT_FONT_SIZE;
      livecardsystemvm.titleFontColor = LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
      livecardsystemvm.textFontColor = LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
      livecardsystemvm.simIconSize = undefined;
      livecardsystemvm.maxFontScale = ResourceVm.DEFAULT_MAX_SCALE;
      livecardsystemvm.fontFixedAreaHeight = 32;
      const result = livecardsystemvm.isBigTitle;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = true;
      card.isTimerInTitle = true;
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.typeCode = SysTypeCode.BIG_TEXT_TIMER;
      livecardsystemvm.card = card;
      livecardsystemvm.live = live;
      livecardsystemvm.simIconColor = [LiveStyle.LIVE_CARD_TEXT_FONT_COLOR];
      livecardsystemvm.textFontSize = LiveStyle.SYSTEM_CARD_TEXT_FONT_SIZE;
      livecardsystemvm.titleFontColor = LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
      livecardsystemvm.textFontColor = LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
      livecardsystemvm.simIconSize = undefined;
      livecardsystemvm.maxFontScale = ResourceVm.DEFAULT_MAX_SCALE;
      livecardsystemvm.fontFixedAreaHeight = 32;
      const result = livecardsystemvm.isBigTitle;
      expect(result).assertEqual(true);
    });
  });

  describe('titleFontSize_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_headline6_font_size_when_isBigTitle_is_true', 0, () => {
      let livecardsystemvm: LiveCardSystemVm = new LiveCardSystemVm();
      livecardsystemvm.isBigTitle = true;
      const result = livecardsystemvm.titleFontSize;
      expect(result).assertEqual($r('sys.float.ohos_id_text_size_headline6'));
    });

    it('should_return_sub_title3_font_size_when_isBigTitle_is_false', 0, () => {
      let livecardsystemvm: LiveCardSystemVm = new LiveCardSystemVm();
      livecardsystemvm.isBigTitle = false;
      const result = livecardsystemvm.titleFontSize;
      expect(result).assertEqual($r('sys.float.ohos_id_text_size_sub_title3'));
    });
  });

  describe('titleLineHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_auto_when_isBigTitle_is_true', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      livecardsystemvm.isBigTitle = true;
      const result = livecardsystemvm.titleLineHeight;
      expect(result).assertEqual('auto');
    });

    it('should_return_font_size_when_isBigTitle_is_false', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      livecardsystemvm.isBigTitle = false;
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockfunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('12px');
      const result = livecardsystemvm.titleLineHeight;
      expect(result).assertEqual('12px');
      mocker.ignoreMock(resourceVm, resourceVm.getFontSize);
    });
  });

  describe('text_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_content_when_isTimerInTitle_is_true', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = true;
      card.content = "test content";
      livecardsystemvm.card = card;
      expect(livecardsystemvm.text).assertEqual("test content");
    });

    it('should_return_timer_text_when_isTimerInTitle_is_false_and_card_timer_is_not_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = false;
      card.timer = "test timer";
      let vmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getTimerVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({
        getTimerText: (timer: string) => {
          return "test timer text";
        }
      });
      livecardsystemvm.vmInjector = vmInjector;
      livecardsystemvm.card = card;
      expect(livecardsystemvm.text).assertEqual("test timer text");
      mocker.ignoreMock(vmInjector, vmInjector.getTimerVm);
    });

    it('should_return_content_when_isTimerInTitle_is_false_and_card_timer_is_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = false;
      card.content = "test content";
      livecardsystemvm.card = card;
      expect(livecardsystemvm.text).assertEqual("test content");
    });
  });

  describe('textLineHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_textLineHeight_when_fontSize_is_CARD_TEXT_LINE_HEIGHT', 0, async () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockfunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new Length(16));

      const result = livecardsystemvm.textLineHeight;
      expect(result.value).assertEqual(16);

      mocker.ignoreMock(resourceVm, resourceVm.getFontSize);
    });
  });

  describe('simIcon_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_sim1_and_sim2_are_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemvm.card = liveItemBaseVm;
      livecardsystemvm.card.simIconStatus = PhoneSimStatus.STATUS_SIM_1;
      let result = livecardsystemvm.simIcon;
      expect(result).assertEqual(undefined);
    });

    it('should_return_sim1_when_simIconStatus_is_STATUS_SIM_1', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemvm.card = liveItemBaseVm;
      livecardsystemvm.card.simIconStatus = PhoneSimStatus.STATUS_SIM_1;
      let sim1 = LiveStyle.SIM1_SYMBOL_RESOURCE;
      let sim2 = LiveStyle.SIM2_SYMBOL_RESOURCE;
      livecardsystemvm.simIconColor = [sim1];
      let result = livecardsystemvm.simIcon;
      expect(result).assertEqual(sim1);
    });

    it('should_return_sim2_when_simIconStatus_is_STATUS_SIM_2', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemvm.card = liveItemBaseVm;
      livecardsystemvm.card.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
      let sim1 = LiveStyle.SIM1_SYMBOL_RESOURCE;
      let sim2 = LiveStyle.SIM2_SYMBOL_RESOURCE;
      livecardsystemvm.simIconColor = [sim2];
      let result = livecardsystemvm.simIcon;
      expect(result).assertEqual(sim2);
    });

    it('should_return_undefined_when_simIconStatus_is_neither_STATUS_SIM_1_nor_STATUS_SIM_2', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemvm.card = liveItemBaseVm;
      livecardsystemvm.card.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
      let sim1 = LiveStyle.SIM1_SYMBOL_RESOURCE;
      let sim2 = LiveStyle.SIM2_SYMBOL_RESOURCE;
      livecardsystemvm.simIconColor = [sim1, sim2];
      let result = livecardsystemvm.simIcon;
      expect(result).assertEqual(undefined);
    });
  });

  describe('getTitleAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      AccessibilityVm.instance.isEnabled = false;
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('');
    });

    it('should_return_timer_accessibility_text_when_timer_is_enabled_and_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockCard: LiveCardSystemModel = new LiveCardSystemModel();
      mockCard.timer = 'timer1';
      mockCard.isTimerInTitle = true;
      livecardsystemvm.card = mockCard;

      let mockTimerVm: ILiveTimerVm = new ILiveTimerVm();
      let mockGetTimerVm: Function =
        mocker.mockFunc(livecardsystemvm.vmInjector, livecardsystemvm.vmInjector.getTimerVm);
      when(mockGetTimerVm)([]).afterReturn(mockTimerVm);

      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('mockedTimerAccessibilityText');

      mocker.ignoreMock(livecardsystemvm.vmInjector, livecardsystemvm.vmInjector.getTimerVm);
    });

    it('should_return_title_when_timer_is_not_enabled_or_not_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockCard: LiveCardSystemModel = new LiveCardSystemModel();
      mockCard.timer = 'timer1';
      mockCard.isTimerInTitle = false;
      livecardsystemvm.card = mockCard;

      let mockTimerVm: ILiveTimerVm = new ILiveTimerVm();
      let mockGetTimerVm: Function =
        mocker.mockFunc(livecardsystemvm.vmInjector, livecardsystemvm.vmInjector.getTimerVm);
      when(mockGetTimerVm)([]).afterReturn(mockTimerVm);

      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('mockedTimerAccessibilityText');

      mocker.ignoreMock(livecardsystemvm.vmInjector, livecardsystemvm.vmInjector.getTimerVm);
    });
  });

  describe('getContentAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled); //还原mock函数，否则会影响其他用例
    });

    it('should_return_content_when_timer_is_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = true;
      card.content = "Test Content";
      let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual('Test Content');
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card); //还原mock函数，否则会影响其他用例
    });

    it('should_return_timer_accessibility_text_when_timer_is_not_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = false;
      card.timer = {
        phoneSimStatus: PhoneSimStatus.SIM_INSERTED, simType: SysTypeCode.MOBILE, simColor: 0
      };
      card.content = "Test Content";
      let vmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfunc1: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(card);
      let mockfunc2: Function = mocker.mockFunc(vmInjector, vmInjector.getTimerVm);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        getTimerAccessibilityText: () => "Timer Accessibility Text"
      });
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual('Timer Accessibility Text');
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card); //还原mock函数，否则会影响其他用例
      mocker.ignoreMock(vmInjector, vmInjector.getTimerVm); //还原mock函数，否则会影响其他用例
    });
  });
}