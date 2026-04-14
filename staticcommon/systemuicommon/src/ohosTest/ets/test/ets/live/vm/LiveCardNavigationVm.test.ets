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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { LiveVmInjector, ResourceVm } from "../../../../../../../newIndex";
import { LiveStyle } from "../../../../../../main/ets/live/constants/LiveStyle";
import { LiveRichTextModel, LiveTimerModel } from "../../../../../../main/ets/live/model/LiveCommonModel";
import { LiveNotification } from "../../../../../../main/ets/live/model/LiveNotification";
import { LiveCardNavigationVm } from "../../../../../../main/ets/live/vm/LiveCardNavigationVm";
import { LengthMetrics } from "@kit.ArkUI";

export default function LiveCardNavigationVmTest() {
  describe('setNavDirectIcons_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_hasNavDirectionIcons_correctly_when_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(true);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertEqual(true);
    });

    it('should_set_hasNavDirectionIcons_correctly_when_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(false);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertEqual(true);
    });


    it('set_hasNavDirectionIcons_correctly_when_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(true);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertUndefined();
    });

    it('set_hasNavDirectionIcons_correctly_when_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(false);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertUndefined();
    });


    it('should_set_hasNavDirectionIcons_when_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(true);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertEqual(true);
    });

    it('should_set_hasNavDirectionIcons_when_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(false);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertEqual(true);
    });


    it('should_set_hasNavDirectionIcons_correctly_when_not_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(true);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertUndefined();
    });

    it('should_set_hasNavDirectionIcons_correctly_when_not_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(false);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertUndefined();
    });


    it('should_set_hasNavDirectionIcons_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(true);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertEqual(true);
    });

    it('should_set_hasNavDirectionIcons_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setNavDirectIcons(false);
      expect(liveCardNavigationVm.hasNavDirectionIcons).assertEqual(true);
    });
  });

  describe('getCardScale_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_1_5_px_when_cardScale_is_less_than_1', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 0.5;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1.5px');
    });

    it('should_return_1_px_when_cardScale_is_not_less_than_1', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 1;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1px');
    });

    it('should_return_1_px_when_cardScale_is_undefined', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = undefined;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1px');
    });


    it('should_return_1_5_px_when_cardScale_is_0.3', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 0.3;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1.5px');
    });

    it('should_return_1_px_when_cardScale_is_1.3', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 1.3;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1px');
    });


    it('should_return_1_5_px_when_cardScale_is_0.6', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 0.6;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1.5px');
    });

    it('should_return_1_px_when_cardScale_is_1.6', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 1;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1px');
    });


    it('should_return_1_5_px_when_cardScale_is_0.9', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 0.9;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1.5px');
    });

    it('should_return_1_px_when_cardScale_is_1.9', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 1;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1px');
    });


    it('should_return_1_5_px_when_cardScale_is_0.4', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 0.4;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1.5px');
    });

    it('should_return_1_px_when_cardScale_is_1.4', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 1.4;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1px');
    });


    it('should_return_1_5_px_when_cardScale_is_0.7', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 0.5;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1.5px');
    });

    it('should_return_1_px_when_cardScale_is_1.7', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.cardScale = 1;
      const result = liveCardNavigationVm.getCardScale();
      expect(result).assertEqual('1px');
    });
  });

  describe('getTimerText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_text_when_timer_uid_is_undefined', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text";
      let timer: LiveTimerModel = new LiveTimerModel("123");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });

    it('should_return_text_with_timer_text_when_timer_uid_is_defined', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text ${placeholder.timer}";
      let timer: LiveTimerModel = new LiveTimerModel("123");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });


    it('return_text_when_timer_uid_is_undefined', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test";
      let timer: LiveTimerModel = new LiveTimerModel("456");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });

    it('return_text_with_timer_text_when_timer_uid_is_defined', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test${placeholder.timer}";
      let timer: LiveTimerModel = new LiveTimerModel("456");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });


    it('should_return_text_when_timer_uid_is_undefined_789', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text";
      let timer: LiveTimerModel = new LiveTimerModel("789");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });

    it('should_return_text_with_timer_text_when_timer_uid_is_defined_789', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text ${placeholder.timer}";
      let timer: LiveTimerModel = new LiveTimerModel("789");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });


    it('should_return_text_when_timer_uid_is_undefined_101112', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text";
      let timer: LiveTimerModel = new LiveTimerModel("101112");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });

    it('should_return_text_with_timer_text_when_timer_uid_is_defined_101112', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text ${placeholder.timer}";
      let timer: LiveTimerModel = new LiveTimerModel("101112");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });


    it('should_return_text_when_timer_uid_is_undefined_131415', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text";
      let timer: LiveTimerModel = new LiveTimerModel("131415");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });

    it('should_return_text_with_timer_text_when_timer_uid_is_defined_131415', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let text: string = "Test Text ${placeholder.timer}";
      let timer: LiveTimerModel = new LiveTimerModel("131415");
      const result = liveCardNavigationVm.getTimerText(text, timer);
      expect(result).assertEqual(text);
    });
  });

  describe('getFixedAreaHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_height_48_when_hasNavDirectionIcons_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = false;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(48);
    });

    it('should_return_height_72_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = true;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(72);
    });

    it('should_return_height_120_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(120);
    });

    it('should_return_height_148_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(148);
    });

    it('should_return_height_178_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(178);
    });

    it('should_return_height_200_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(200);
    });

    it('should_return_height_248_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(248);
    });

    it('should_return_height_278_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(278);
    });

    it('should_return_height_300_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(300);
    });

    it('should_return_height_328_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(328);
    });

    it('should_return_height_with_fontScale_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(5);
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(77);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });

    it('should_return_height_with_fontScale_when_hasNavDirectionIcons_is_true_and_layoutIsNavigationIconsDisplayed_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
      when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(5);
      const result = liveCardNavigationVm.getFixedAreaHeight();
      expect(result).assertEqual(125);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.getFontScaleHeightDiff);
    });

    it('should have correct navDirsSize', () => {
      liveCardNavigationVm.card.layoutNavigationIcons = [{}, {}];
      liveCardNavigationVm.navDirsWidth = 60;
      expect(liveCardNavigationVm.navDirsSize).toBe('24vp');
    });

    it('should have correct imgColorFilter', () => {
      liveCardNavigationVm.card.layoutNavigationIconMimeType = 'svg';
      expect(liveCardNavigationVm.imgColorFilter).toBe(LiveStyle.WHITE_COLOR_FILTER);
    });

    // Tests for methods

    it('should set parameters without navigation icons', () => {
      liveCardNavigationVm.setParamWithoutNavigationIcons();
      expect(liveCardNavigationVm.cardMarginUpperHalf).toEqual({
        top: '12vp',
        left: '12vp',
        right: '12vp',
        bottom: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).toBe('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).toBe(FontWeight.Bold);
    });

    it('should set parameters with bottom', () => {
      liveCardNavigationVm.setParamWithBottom();
      expect(liveCardNavigationVm.cardMarginUpperHalf).toEqual({
        top: '12vp',
        left: '12vp',
        right: '12vp',
        bottom: '4vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).toEqual({
        top: '0vp',
        left: '12vp',
        right: '12vp',
        bottom: '12vp'
      });
      expect(liveCardNavigationVm.mainNavInfoWeight).toBe(FontWeight.Bold);
    });

    it('should set navigation direction icons', () => {
      liveCardNavigationVm.setNavDirectIcons(true);
      expect(liveCardNavigationVm.hasNavDirectionIcons).toBe(true);
    });

    it('should get card scale', () => {
      liveCardNavigationVm.cardScale = 0.5;
      expect(liveCardNavigationVm.getCardScale()).toBe('0.5px');
    });

    it('should get timer text', () => {
      const text = 'Hello ${placeholder.timer}';
      const timer = { uid: '123' };
      liveCardNavigationVm.getTimerText(text, timer);
      expect(text.replace(/\$\{placeholder.timer\}/g, 'Timer Text')).toBe('Hello Timer Text');
    });

    it('should get fixed area height', () => {
      liveCardNavigationVm.hasNavDirectionIcons = true;
      liveCardNavigationVm.card.layoutIsNavigationIconsDisplayed = false;
      expect(liveCardNavigationVm.getFixedAreaHeight()).toBe(120);
    });

    it('should get card height', () => {
      liveCardNavigationVm.hasNavDirectionIcons = true;
      expect(liveCardNavigationVm.getCardHeight()).toBe(LiveStyle.LIVE_OTHER_CARD_HEIGHT + ResourceVm.DEFAULT_MAX_SCALE);
    });

    it('should get content font color', () => {
      const richText = { textColor: 'red' };
      expect(liveCardNavigationVm.getContentFontColor(richText)).toBe('red');
    });

    const getNavDirsSizeDT = [
      { iconSize: 32, iconNum: 0, expected: '32vp' },
      { iconSize: 32, iconNum: 1, expected: '32vp' },
      { iconSize: 32, iconNum: 2, expected: '24vp' },
      { iconSize: 28, iconNum: 1, expected: '28vp' },
      { iconSize: 28, iconNum: 2, expected: '24vp' },
      { iconSize: 24, iconNum: 1, expected: '24vp' },
      { iconSize: 24, iconNum: 2, expected: '24vp' },
    ];

    getNavDirsSizeDT.forEach((testCase) => {
      it(`should return ${testCase.expected} for getNavDirsSize with iconSize: ${testCase.iconSize}, iconNum: ${testCase.iconNum}`, () => {
        liveCardNavigationVm.card.layoutNavigationIcons = Array(testCase.iconNum).fill({ mimeType: 'png' });
        liveCardNavigationVm.navDirsWidth = testCase.iconSize * testCase.iconNum;
        expect(liveCardNavigationVm.navDirsSize).toBe(testCase.expected);
      });
    });

    it('getNavDirsSizeDT1', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
    });

    it('getNavDirsSizeDT2', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('getCardHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_live_other_card_height_when_hasNavDirectionIcons_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = false;
      const result = liveCardNavigationVm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT);
    });

    it('should_return_live_system_card_height_when_hasNavDirectionIcons_is_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      const result = liveCardNavigationVm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
    });

    it('should_return_correct_height_when_hasNavDirectionIcons_is_false_and_fontScaleHeightDiff_is_not_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = false;
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockFunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(10);
      const result = liveCardNavigationVm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT + 10);
      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });

    it('should_return_correct_height_when_hasNavDirectionIcons_is_true_and_fontScaleHeightDiff_is_not_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockFunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(10);
      const result = liveCardNavigationVm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);
      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });


    it('return_correct_height_when_hasNavDirectionIcons_is_false_and_fontScaleHeightDiff_is_not_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = false;
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockFunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(10);
      const result = liveCardNavigationVm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_OTHER_CARD_HEIGHT + 10);
      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });

    it('return_correct_height_when_hasNavDirectionIcons_is_true_and_fontScaleHeightDiff_is_not_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.hasNavDirectionIcons = true;
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.instance;
      let mockFunc: Function = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(10);
      const result = liveCardNavigationVm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);
      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });
  });

  describe('getContentFontColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_default_font_color_when_richText_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let richText: LiveRichTextModel | undefined = new LiveRichTextModel();
      const result = liveCardNavigationVm.getContentFontColor(richText);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR);
    });

    it('should_return_richText_font_color_when_richText_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let richText: LiveRichTextModel = new LiveRichTextModel();
      const result = liveCardNavigationVm.getContentFontColor(richText);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR);
    });


    it('return_default_font_color_when_richText_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let richText: LiveRichTextModel | undefined = new LiveRichTextModel();
      const result = liveCardNavigationVm.getContentFontColor(richText);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR);
    });

    it('return_richText_font_color_when_richText_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      let richText: LiveRichTextModel = new LiveRichTextModel();
      const result = liveCardNavigationVm.getContentFontColor(richText);
      expect(result).assertEqual(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR);
    });
  });

  describe('setParamWithBottom_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('should_set_all_params_incorrectly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithBottom_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('should_set_all_params_incorrectly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite2', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithBottom_testSuite2', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('should_set_all_params_incorrectly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite2', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite3', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithBottom_testSuite3', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('should_set_all_params_incorrectly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite3', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });
}        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite5', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });
  });

  describe('setParamWithBottom_testSuite5', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_all_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('set_params_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });


    it('should_set_all_params_incorrectly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithBottom();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '4vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.cardMarginBottomHalf).assertDeepEquals({
        top: '0vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('64vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('64vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertEqual($r('sys.float.ohos_id_text_size_headline8'));
      expect(liveCardNavigationVm.mainViceSpace).assertEqual($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertEqual($r('sys.float.ohos_id_text_size_body2'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(24)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: {
          anchor: '__container__', align: VerticalAlign.Center
        },
        left: {
          anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End
        },
        right: {
          anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.Start
        },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: {
          anchor: `__container__`, align: VerticalAlign.Top
        },
        right: {
          anchor: '__container__', align: HorizontalAlign.End
        },
      });
    });
  });

  describe('setParamWithoutNavigationIcons_testSuite5', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
        bottom: '12vp',
        left: '12vp',
        right: '12vp'
      });
      expect(liveCardNavigationVm.currNavDirectionHeight).assertEqual('80vp');
      expect(liveCardNavigationVm.currNavDirectionWidth).assertEqual('80vp');
      expect(liveCardNavigationVm.mainNavInfoWeight).assertEqual(FontWeight.Bold);
      expect(liveCardNavigationVm.mainNavInfoSizeRes).assertDeepEquals($r('sys.float.ohos_id_text_size_headline7'));
      expect(liveCardNavigationVm.mainViceSpace).assertDeepEquals($r('sys.float.ohos_id_text_paragraph_margin_xs'));
      expect(liveCardNavigationVm.viceNavInfoSize).assertDeepEquals($r('sys.float.ohos_id_text_size_sub_title1'));
      expect(liveCardNavigationVm.navInfoMargin).assertDeepEquals({
        start: LengthMetrics.vp(12),
        end: LengthMetrics.vp(0)
      });
      expect(liveCardNavigationVm.navInfoAlignRule).assertDeepEquals({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: `nav-direction-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
        right: { anchor: `nav-app-icon_${liveCardNavigationVm.live.hashCode}`, align: HorizontalAlign.End },
      });
      expect(liveCardNavigationVm.appIconAlignRule).assertDeepEquals({
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      });
    });


    it('set_all_parameters_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCardNavigationVm: LiveCardNavigationVm = new LiveCardNavigationVm(liveVmInjector, live);
      liveCardNavigationVm.setParamWithoutNavigationIcons();

      expect(liveCardNavigationVm.cardMarginUpperHalf).assertDeepEquals({
        top: '12vp',
