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
import measure from '@ohos.measure';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import { AccessibilityVm } from '../../../../../../main/ets/vm/AccessibilityVm';
import { ResourceVm } from '../../../../../../main/ets/vm/ResourceVm';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { ILiveCapsuleMarqueeVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleMarqueeVm';
import { ILiveCapsuleVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleVm';
import { LiveProgressModel, LiveType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveItemBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCapsuleMarqueeVm } from '../../../../../../main/ets/live/vm/LiveCapsuleMarqueeVm';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';

export default function LiveCapsuleMarqueeVmTest() {
  describe('getProgressText_testSuite', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_percentage_when_isPercentage_is_true', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      progress.isPercentage = true;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50%');
    });

    it('should_return_currentValue_slash_maxValue_when_isPercentage_is_false', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      progress.isPercentage = false;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50/100');
    });

    it('should_return_percentage_when_progress_is_Percentage_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50%');
    });

    it('should_return_currentValue_slash_maxValue_when_isPercentage_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50/100');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_NaN', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = NaN;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_null', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_0', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 0;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('0/100');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_100',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_undefined',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_0',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 0;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_100',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_undefined',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_0',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        progress.maxValue = 0;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_negative_and_maxValue_is_positive',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = -50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('-50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_positive_and_maxValue_is_negative',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = -100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/-100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_negative_and_maxValue_is_negative',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = -50;
        progress.maxValue = -100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('-50/-100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_positive_and_maxValue_is_positive',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_mainText_when_isSplicing_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      const result = liveCapsuleMarqueeVm.getText();
      expect(result).assertEqual("");
    });

    it('should_return_mainText_with_extendText_when_isSplicing_is_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.isSplicing = true;
      let mocker: MockKit = new MockKit();
      const result = liveCapsuleMarqueeVm.getText();
      expect(result).assertEqual("");
    });

    it('should_return_error_when_textWidth_is_less_than_or_equal_to_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(0);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(0);
    });

    it('should_set_textWidth_when_textWidth_is_greater_than_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(100);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
    });

    it('should_return_error_when_textWidth_is_less_than_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(0);
      liveCapsuleMarqueeVm.setTextWidth(-100);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(0);
    });

    it('should_update_ui_property_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 100;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 200;
      liveCapsuleMarqueeVm.fixedTextSize = 30;
      liveCapsuleMarqueeVm.fixedIsSplicing = true;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(200);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(30);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(true);
    });

    it('should_update_ui_property_correctly1', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 10;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 20;
      liveCapsuleMarqueeVm.fixedTextSize = 3;
      liveCapsuleMarqueeVm.fixedIsSplicing = true;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(10);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(20);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(3);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(true);
    });

    it('should_update_ui_property_correctly2', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 100;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 200;
      liveCapsuleMarqueeVm.fixedTextSize = 30;
      liveCapsuleMarqueeVm.fixedIsSplicing = false;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(200);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(30);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(false);
    });

    it('should_update_ui_property_correctly3', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 10;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 20;
      liveCapsuleMarqueeVm.fixedTextSize = 3;
      liveCapsuleMarqueeVm.fixedIsSplicing = false;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(10);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(20);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(3);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(false);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_font_size', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_FONT_SIZE);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width_and_isExtendRunning_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      liveCapsuleMarqueeVm.isSplicing = true;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width_and_isSplicing_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = true;
      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width_and_isExtendRunning_and_isSplicing_are_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width_and_isExtendRunning_and_isSplicing_are_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = true;
      liveCapsuleMarqueeVm.isSplicing = true;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_true_when_isExtend_is_true_and_getExtendText_returns_rtl_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetExtendText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      when(mockGetExtendText)().afterReturn("شمسی");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(true);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(true);
      expect(result).assertEqual(true);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_false_when_isExtend_is_true_and_getExtendText_returns_ltr_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetExtendText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      when(mockGetExtendText)().afterReturn("left");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(false);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(true);
      expect(result).assertEqual(false);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_true_when_isExtend_is_false_and_getText_returns_rtl_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      when(mockGetText)().afterReturn("right");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(true);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(false);
      expect(result).assertEqual(true);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_false_when_isExtend_is_false_and_getText_returns_ltr_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      when(mockGetText)().afterReturn("left");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(false);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(false);
      expect(result).assertEqual(false);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });
  });
  describe('getProgressText_testSuite2', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_percentage_when_isPercentage_is_true', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      progress.isPercentage = true;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50%');
    });

    it('should_return_currentValue_slash_maxValue_when_isPercentage_is_false', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      progress.isPercentage = false;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50/100');
    });

    it('should_return_percentage_when_progress_is_Percentage_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50%');
    });

    it('should_return_currentValue_slash_maxValue_when_isPercentage_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50/100');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_NaN', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = NaN;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_null', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_0', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 0;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('0/100');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_100',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_undefined',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_0',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 0;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_100',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_undefined',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_0',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        progress.maxValue = 0;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_negative_and_maxValue_is_positive',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = -50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('-50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_positive_and_maxValue_is_negative',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = -100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/-100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_negative_and_maxValue_is_negative',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = -50;
        progress.maxValue = -100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('-50/-100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_positive_and_maxValue_is_positive',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_mainText_when_isSplicing_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      const result = liveCapsuleMarqueeVm.getText();
      expect(result).assertEqual("");
    });

    it('should_return_mainText_with_extendText_when_isSplicing_is_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.isSplicing = true;
      let mocker: MockKit = new MockKit();
      const result = liveCapsuleMarqueeVm.getText();
      expect(result).assertEqual("");
    });

    it('should_return_error_when_textWidth_is_less_than_or_equal_to_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(0);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(0);
    });

    it('should_set_textWidth_when_textWidth_is_greater_than_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(100);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
    });

    it('should_return_error_when_textWidth_is_less_than_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(0);
      liveCapsuleMarqueeVm.setTextWidth(-100);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(0);
    });

    it('should_update_ui_property_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 100;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 200;
      liveCapsuleMarqueeVm.fixedTextSize = 30;
      liveCapsuleMarqueeVm.fixedIsSplicing = true;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(200);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(30);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(true);
    });

    it('should_update_ui_property_correctly1', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 10;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 20;
      liveCapsuleMarqueeVm.fixedTextSize = 3;
      liveCapsuleMarqueeVm.fixedIsSplicing = true;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(10);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(20);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(3);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(true);
    });

    it('should_update_ui_property_correctly2', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 100;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 200;
      liveCapsuleMarqueeVm.fixedTextSize = 30;
      liveCapsuleMarqueeVm.fixedIsSplicing = false;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(200);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(30);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(false);
    });

    it('should_update_ui_property_correctly3', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 10;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 20;
      liveCapsuleMarqueeVm.fixedTextSize = 3;
      liveCapsuleMarqueeVm.fixedIsSplicing = false;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(10);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(20);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(3);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(false);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_font_size', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_FONT_SIZE);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width_and_isExtendRunning_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      liveCapsuleMarqueeVm.isSplicing = true;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width_and_isSplicing_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = true;
      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width_and_isExtendRunning_and_isSplicing_are_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width_and_isExtendRunning_and_isSplicing_are_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = true;
      liveCapsuleMarqueeVm.isSplicing = true;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_true_when_isExtend_is_true_and_getExtendText_returns_rtl_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetExtendText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      when(mockGetExtendText)().afterReturn("شمسی");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(true);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(true);
      expect(result).assertEqual(true);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_false_when_isExtend_is_true_and_getExtendText_returns_ltr_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetExtendText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      when(mockGetExtendText)().afterReturn("left");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(false);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(true);
      expect(result).assertEqual(false);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_true_when_isExtend_is_false_and_getText_returns_rtl_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      when(mockGetText)().afterReturn("right");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(true);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(false);
      expect(result).assertEqual(true);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_false_when_isExtend_is_false_and_getText_returns_ltr_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      when(mockGetText)().afterReturn("left");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(false);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(false);
      expect(result).assertEqual(false);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });
  });

  describe('getProgressText_testSuite3', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_currentValue_slash_maxValue_when_isPercentage_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 50;
      progress.maxValue = 100;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('50/100');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_NaN', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = NaN;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_null', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_undefined', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_0', 0, () => {
      let progress: LiveProgressModel = new LiveProgressModel();
      progress.currentValue = 0;
      const result = LiveCapsuleMarqueeVm.getProgressText(progress);
      expect(result).assertEqual('0/100');
    });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_100',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_undefined',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_50_and_maxValue_is_0',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 0;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_100',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_undefined',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_100_and_maxValue_is_0',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 100;
        progress.maxValue = 0;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('100/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_negative_and_maxValue_is_positive',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = -50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('-50/100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_positive_and_maxValue_is_negative',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = -100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/-100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_negative_and_maxValue_is_negative',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = -50;
        progress.maxValue = -100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('-50/-100');
      });

    it('should_return_empty_string_when_progress_is_Percentage_is_undefined_and_currentValue_is_positive_and_maxValue_is_positive',
      0, () => {
        let progress: LiveProgressModel = new LiveProgressModel();
        progress.currentValue = 50;
        progress.maxValue = 100;
        const result = LiveCapsuleMarqueeVm.getProgressText(progress);
        expect(result).assertEqual('50/100');
      });
  });

  describe('getText_testSuite', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_mainText_when_isSplicing_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      const result = liveCapsuleMarqueeVm.getText();
      expect(result).assertEqual("");
    });

    it('should_return_mainText_with_extendText_when_isSplicing_is_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.isSplicing = true;
      let mocker: MockKit = new MockKit();
      const result = liveCapsuleMarqueeVm.getText();
      expect(result).assertEqual("");
    });
  });

  describe('setTextWidth_testSuite', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_error_when_textWidth_is_less_than_or_equal_to_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(0);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(0);
    });

    it('should_set_textWidth_when_textWidth_is_greater_than_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(100);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
    });

    it('should_return_error_when_textWidth_is_less_than_zero', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.setTextWidth(0);
      liveCapsuleMarqueeVm.setTextWidth(-100);
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(0);
    });

  });

  describe('updateUIProperty_testSuite', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_update_ui_property_correctly', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 100;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 200;
      liveCapsuleMarqueeVm.fixedTextSize = 30;
      liveCapsuleMarqueeVm.fixedIsSplicing = true;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(200);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(30);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(true);
    });

    it('should_update_ui_property_correctly1', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 10;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 20;
      liveCapsuleMarqueeVm.fixedTextSize = 3;
      liveCapsuleMarqueeVm.fixedIsSplicing = true;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(10);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(20);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(3);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(true);
    });

    it('should_update_ui_property_correctly2', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 100;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 200;
      liveCapsuleMarqueeVm.fixedTextSize = 30;
      liveCapsuleMarqueeVm.fixedIsSplicing = false;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(100);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(200);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(30);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(false);
    });

    it('should_update_ui_property_correctly3', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      liveCapsuleMarqueeVm.fixedTextWidth = 10;
      liveCapsuleMarqueeVm.fixedExtendTextWidth = 20;
      liveCapsuleMarqueeVm.fixedTextSize = 3;
      liveCapsuleMarqueeVm.fixedIsSplicing = false;

      liveCapsuleMarqueeVm.updateUIProperty();
      expect(liveCapsuleMarqueeVm.textWidth).assertEqual(10);
      expect(liveCapsuleMarqueeVm.extendTextWidth).assertEqual(20);
      expect(liveCapsuleMarqueeVm.textSize).assertEqual(3);
      expect(liveCapsuleMarqueeVm.isSplicing).assertEqual(false);
    });
  });

  describe('getTextWidthBySize_testSuite', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_font_size', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_FONT_SIZE);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width_and_isExtendRunning_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = false;
      liveCapsuleMarqueeVm.isSplicing = true;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width_and_isSplicing_is_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;

      liveCapsuleMarqueeVm.isExtendRunning = true;
      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_extend_text_width_and_isExtendRunning_and_isSplicing_are_false', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;
      liveCapsuleMarqueeVm.isExtendRunning = false;
      liveCapsuleMarqueeVm.isSplicing = false;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_width_when_textSize_is_liveStyle_capsule_title_width_and_isExtendRunning_and_isSplicing_are_true', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      let cutoutVmMock: CutoutVm = new CutoutVm();
      liveCapsuleMarqueeVm.cutoutVm = cutoutVmMock;
      liveCapsuleMarqueeVm.isExtendRunning = true;
      liveCapsuleMarqueeVm.isSplicing = true;
      let result = liveCapsuleMarqueeVm.getTextWidthBySize(LiveStyle.CAPSULE_TITLE_WIDTH);
      expect(result).assertEqual(0);
    });
  });

  describe('isCapsuleMarqueeRTL_testSuite', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_true_when_isExtend_is_true_and_getExtendText_returns_rtl_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      let mockGetExtendText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      when(mockGetExtendText)().afterReturn("شمسی");
      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(true);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(true);
      expect(result).assertEqual(true);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_false_when_isExtend_is_true_and_getExtendText_returns_ltr_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetExtendText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      when(mockGetExtendText)().afterReturn("left");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(false);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(true);
      expect(result).assertEqual(false);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getExtendText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_true_when_isExtend_is_false_and_getText_returns_rtl_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      when(mockGetText)().afterReturn("right");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(true);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(false);
      expect(result).assertEqual(true);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });

    it('should_return_false_when_isExtend_is_false_and_getText_returns_ltr_text', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();

      let mockGetText: Function = mocker.mockFunc(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      when(mockGetText)().afterReturn("left");

      let mockIsTextRTL: Function = mocker.mockFunc(ResourceVm.instance, ResourceVm.instance.isTextRTL);
      when(mockIsTextRTL)(ArgumentMatchers.anyString).afterReturn(false);

      const result = liveCapsuleMarqueeVm.isCapsuleMarqueeRTL(false);
      expect(result).assertEqual(false);

      mocker.ignoreMock(liveCapsuleMarqueeVm, liveCapsuleMarqueeVm.getText);
      mocker.ignoreMock(ResourceVm.instance, ResourceVm.instance.isTextRTL);
    });
  });
}
