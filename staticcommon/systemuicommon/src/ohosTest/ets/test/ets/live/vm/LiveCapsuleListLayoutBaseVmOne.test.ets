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
import { CapsuleShowType } from '../../../../main/ets/live/model/LiveCommonModel';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import { LiveBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { LiveCapsuleModel } from '../../../../main/ets/live/model/LiveCapsuleModel';
import { LiveCapsuleMarqueeVm } from '../../../../main/ets/live/vm/LiveCapsuleMarqueeVm';
import { ILiveCapsuleVm } from '../../../../main/ets/live/interface/ILiveCapsuleVm';
import { CutoutVm } from '../../../../main/ets/statusbar/vm/CutoutVm';
import { DeviceInfoVm } from '../../../../main/ets/vm/DeviceInfoVm';
import { SystemUICommonUtil } from '../../../../main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCapsuleListLayoutBaseVm } from '../../../../main/ets/live/vm/LiveCapsuleListLayoutBaseVm';
export default function LiveCapsuleListLayoutBaseVmTest() {
  describe('adjustFixedWidth_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });
    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_fixedShowType_is_SHADOW', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.SHADOW;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_fixedShowType_is_RETRACTABLE_ROUND_CAKE', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.RETRACTABLE_ROUND_CAKE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidthWithExtendTextWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_true', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.HANGING_CAPSULE_MAX_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_capsuleVm_fixedShowType_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.HANGING_HOLE;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = false;
      liveCapsuleMarqueeVm.getHangingHoleCapsuleRealWidth = (l: LiveNotification, s: number) => {
        return 40;
      };
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_ CAPSULE_EXTEND_WIDTH_when_capsuleVm_fixedShowType_is_TOP_and_isExtendShow_is_true', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.TOP;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = true;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_CAPSULE_CIRCLE_WIDTH_when_capsuleVm_fixedShowType_is_LEFT_HOLE', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.LEFT_HOLE;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_capsuleVm_fixedShowType_is_SHADOW', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.SHADOW;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_0_when_capsuleVm_fixedShowType_is_unknown', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.UNKNOWN;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(0);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });


    it('should_return_empty_string_when_capsule_is_null', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = null;
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_title_when_capsule_is_text_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Title');
    });

    it('should_return_content_when_capsule_is_text_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('Test Content');
    });

    it('should_return_progress_text_when_capsule_is_progress_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Progress Text');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_empty_string_when_capsule_is_progress_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_timer_text_when_capsule_is_timer_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Timer Text');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_is_timer_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_type_is_unknown', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = 'UNKNOWN';
      live.capsule.title = 'Test Title';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_greater_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 50;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_less_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 150;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_hangingCapsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithExtend);
    });

    it('should_return_hangingCapsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithoutExtend);
    });

    it('should_return_capsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithExtend);
    });

    it('should_return_capsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithoutExtend);
    });

    it('should_return_0_when_text_length_is_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(0);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text_2', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, '测试');
      expect(result).assertEqual(10);
    });


    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });
    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_fixedShowType_is_SHADOW', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.SHADOW;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_fixedShowType_is_RETRACTABLE_ROUND_CAKE', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.RETRACTABLE_ROUND_CAKE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidthWithExtendTextWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_true', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.HANGING_CAPSULE_MAX_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_capsuleVm_fixedShowType_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.HANGING_HOLE;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = false;
      liveCapsuleMarqueeVm.getHangingHoleCapsuleRealWidth = (l: LiveNotification, s: number) => {
        return 40;
      };
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_ CAPSULE_EXTEND_WIDTH_when_capsuleVm_fixedShowType_is_TOP_and_isExtendShow_is_true', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.TOP;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = true;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_CAPSULE_CIRCLE_WIDTH_when_capsuleVm_fixedShowType_is_LEFT_HOLE', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.LEFT_HOLE;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_capsuleVm_fixedShowType_is_SHADOW', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.SHADOW;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_0_when_capsuleVm_fixedShowType_is_unknown', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.UNKNOWN;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(0);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });


    it('should_return_empty_string_when_capsule_is_null', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = null;
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_title_when_capsule_is_text_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Title');
    });

    it('should_return_content_when_capsule_is_text_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('Test Content');
    });

    it('should_return_progress_text_when_capsule_is_progress_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Progress Text');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_empty_string_when_capsule_is_progress_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_timer_text_when_capsule_is_timer_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Timer Text');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_is_timer_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_type_is_unknown', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = 'UNKNOWN';
      live.capsule.title = 'Test Title';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_greater_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 50;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_less_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 150;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_hangingCapsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithExtend);
    });

    it('should_return_hangingCapsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithoutExtend);
    });

    it('should_return_capsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithExtend);
    });

    it('should_return_capsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithoutExtend);
    });

    it('should_return_0_when_text_length_is_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(0);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text_2', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, '测试');
      expect(result).assertEqual(10);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });
    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_fixedShowType_is_SHADOW', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.SHADOW;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_fixedShowType_is_RETRACTABLE_ROUND_CAKE', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.RETRACTABLE_ROUND_CAKE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidthWithExtendTextWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_true', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.HANGING_CAPSULE_MAX_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_capsuleVm_fixedShowType_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.HANGING_HOLE;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = false;
      liveCapsuleMarqueeVm.getHangingHoleCapsuleRealWidth = (l: LiveNotification, s: number) => {
        return 40;
      };
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_ CAPSULE_EXTEND_WIDTH_when_capsuleVm_fixedShowType_is_TOP_and_isExtendShow_is_true', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.TOP;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = true;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_CAPSULE_CIRCLE_WIDTH_when_capsuleVm_fixedShowType_is_LEFT_HOLE', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.LEFT_HOLE;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_capsuleVm_fixedShowType_is_SHADOW', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.SHADOW;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_0_when_capsuleVm_fixedShowType_is_unknown', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.UNKNOWN;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(0);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });


    it('should_return_empty_string_when_capsule_is_null', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = null;
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_title_when_capsule_is_text_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Title');
    });

    it('should_return_content_when_capsule_is_text_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('Test Content');
    });

    it('should_return_progress_text_when_capsule_is_progress_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Progress Text');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_empty_string_when_capsule_is_progress_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_timer_text_when_capsule_is_timer_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Timer Text');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_is_timer_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_type_is_unknown', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = 'UNKNOWN';
      live.capsule.title = 'Test Title';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_greater_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 50;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_less_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 150;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_hangingCapsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithExtend);
    });

    it('should_return_hangingCapsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithoutExtend);
    });

    it('should_return_capsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithExtend);
    });

    it('should_return_capsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithoutExtend);
    });

    it('should_return_0_when_text_length_is_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(0);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text_2', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, '测试');
      expect(result).assertEqual(10);
    });


    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });
    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_fixedShowType_is_SHADOW', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.SHADOW;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_fixedShowType_is_RETRACTABLE_ROUND_CAKE', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.RETRACTABLE_ROUND_CAKE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidthWithExtendTextWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_true', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.HANGING_CAPSULE_MAX_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_capsuleVm_fixedShowType_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.HANGING_HOLE;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = false;
      liveCapsuleMarqueeVm.getHangingHoleCapsuleRealWidth = (l: LiveNotification, s: number) => {
        return 40;
      };
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_ CAPSULE_EXTEND_WIDTH_when_capsuleVm_fixedShowType_is_TOP_and_isExtendShow_is_true', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.TOP;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = true;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_CAPSULE_CIRCLE_WIDTH_when_capsuleVm_fixedShowType_is_LEFT_HOLE', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.LEFT_HOLE;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_capsuleVm_fixedShowType_is_SHADOW', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.SHADOW;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_0_when_capsuleVm_fixedShowType_is_unknown', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.UNKNOWN;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(0);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });


    it('should_return_empty_string_when_capsule_is_null', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = null;
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_title_when_capsule_is_text_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Title');
    });

    it('should_return_content_when_capsule_is_text_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('Test Content');
    });

    it('should_return_progress_text_when_capsule_is_progress_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Progress Text');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_empty_string_when_capsule_is_progress_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_timer_text_when_capsule_is_timer_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Timer Text');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_is_timer_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_type_is_unknown', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = 'UNKNOWN';
      live.capsule.title = 'Test Title';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_greater_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 50;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_less_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 150;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_hangingCapsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithExtend);
    });

    it('should_return_hangingCapsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithoutExtend);
    });

    it('should_return_capsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithExtend);
    });

    it('should_return_capsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithoutExtend);
    });

    it('should_return_0_when_text_length_is_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(0);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text_2', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, '测试');
      expect(result).assertEqual(10);
    });

  it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_is_not_HANGING_HOLE_and_isExistExtendText_is_false', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleModel();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForNoHangingHoleType: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
      when(mockAdjustFixedWidthForNoHangingHoleType)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForNoHangingHoleType);
    });
    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_fixedShowType_is_SHADOW', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.SHADOW;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_fixedShowType_is_RETRACTABLE_ROUND_CAKE', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.RETRACTABLE_ROUND_CAKE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidthWithExtendTextWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_true', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.HANGING_CAPSULE_MAX_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_false_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_isShowForExtend_is_true_and_realCapsuleWidth_is_set', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, true, 40);
      expect(result).assertEqual(40);
    });

    it('should_return_expectWidth_when_fixedShowType_is_HANGING_HOLE_and_isShowForExtend_is_false_and_realCapsuleWidth_is_undefined', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      liveCapsuleModel.vm = liveCapsuleMarqueeVm;
      live.model = liveCapsuleModel;
      const result = livecapsulelistlayoutbasevm.getExpectWidth(live, false);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    it('should_return_CAPSULE_WIDTH_when_capsuleVm_fixedShowType_is_HANGING_HOLE_and_isExistExtendText_is_false', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.HANGING_HOLE;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = false;
      liveCapsuleMarqueeVm.getHangingHoleCapsuleRealWidth = (l: LiveNotification, s: number) => {
        return 40;
      };
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_ CAPSULE_EXTEND_WIDTH_when_capsuleVm_fixedShowType_is_TOP_and_isExtendShow_is_true', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.TOP;
      let liveCapsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      liveCapsuleMarqueeVm.isExtendShow = true;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleMarqueeVm);
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_EXTEND_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_CAPSULE_CIRCLE_WIDTH_when_capsuleVm_fixedShowType_is_LEFT_HOLE', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.LEFT_HOLE;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_SHADOW_CAPSULE_SHOW_WIDTH_when_capsuleVm_fixedShowType_is_SHADOW', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.SHADOW;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });

    it('should_return_0_when_capsuleVm_fixedShowType_is_unknown', 0, () => {
      let liveCapsuleListLayoutBaseVm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.fixedShowType = CapsuleShowType.UNKNOWN;
      let mockfunc: Function = mocker.mockFunc(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new LiveCapsuleMarqueeVm());
      const result = liveCapsuleListLayoutBaseVm.getMinWidth(live);
      expect(result).assertEqual(0);
      mocker.ignoreMock(liveCapsuleListLayoutBaseVm, liveCapsuleListLayoutBaseVm.vmInjector);
    });


    it('should_return_empty_string_when_capsule_is_null', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = null;
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_title_when_capsule_is_text_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Title');
    });

    it('should_return_content_when_capsule_is_text_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TEXT;
      live.capsule.title = 'Test Title';
      live.capsule.isContentDisplayed = true;
      live.capsule.content = 'Test Content';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('Test Content');
    });

    it('should_return_progress_text_when_capsule_is_progress_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Progress Text');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_empty_string_when_capsule_is_progress_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.PROGRESS;
      live.capsule.progress = 50;
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn('Test Progress Text');
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveCapsuleMarqueeVm, LiveCapsuleMarqueeVm.getProgressText);
    });

    it('should_return_timer_text_when_capsule_is_timer_and_isExtend_is_false', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, false);
      expect(result).assertEqual('Test Timer Text');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_is_timer_and_isExtend_is_true', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = CapsuleShowType.TIMER;
      live.capsule.timer = '00:00';
      live.capsule.title = 'Test Title';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.getTimerVm);
      when(mockfunc)().afterReturn({ getTimerText: () => 'Test Timer Text' });
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live, true);
      expect(result).assertEqual('');
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.getTimerVm);
    });

    it('should_return_empty_string_when_capsule_type_is_unknown', 0, () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.type = 'UNKNOWN';
      live.capsule.title = 'Test Title';
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getText(live);
      expect(result).assertEqual('');
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_greater_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 50;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_increasesUsedSpace_when_capsuleVm_fixedWidth_plus_space_is_less_than_capsuleWidth', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      capsuleVm.fixedWidth = 100;
      let space: number = 150;
      let isUpdateImmediately: boolean = true;
      let increasesUsedSpace: number = 0;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn("test");
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      let mockfunc3: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = await livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);
      expect(result).assertEqual(50);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getText);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.setCapsuleMarqueeFixedParam);
    });

    it('should_return_hangingCapsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithExtend);
    });

    it('should_return_hangingCapsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.HANGING_HOLE;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.hangingCapsuleNonTextWidthWithoutExtend);
    });

    it('should_return_capsuleNonTextWidthWithExtend_when_isExtend_is_true_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = true;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithExtend);
    });

    it('should_return_capsuleNonTextWidthWithoutExtend_when_isExtend_is_false_and_live_is_not_hanging_hole', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.NORMAL;
      let isExtend: boolean = false;
      let result = livecapsulelistlayoutbasevm.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      expect(result).assertEqual(livecapsulelistlayoutbasevm.capsuleNonTextWidthWithoutExtend);
    });

    it('should_return_0_when_text_length_is_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(0);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize();
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, 'Test');
      expect(result).assertEqual(10);
    });

    it('should_return_text_width_when_text_length_is_greater_than_0_with_custom_textSize_and_text_2', 0, () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      const result = livecapsulelistlayoutbasevm.getTextWidthBySize(12, '测试');
      expect(result).assertEqual(10);
    });


    it('should_return_increasesUsedSpace_when_capsuleVm_is_HANGING_HOLE_and_isExistExtendText_is_true', 0, async () => {
      let livecapsulelistlayoutbasevm: LiveCapsuleListLayoutBaseVm = new LiveCapsuleListLayoutBaseVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleMarqueeVm();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
      when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(36);

      let result = livecapsulelistlayoutbasevm.adjustFixedWidth(36, live, true);
      expect(result).assertEqual(36);
      mocker.ignoreMock(livecapsulelistlayoutbasevm.vmInjector, livecapsulelistlayoutbasevm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistlayoutbasevm, livecapsulelistlayoutbasevm.adjustFixedWidthForHangingWithExtend);
    });

  });
}