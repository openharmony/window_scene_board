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


import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveCapsuleVm } from '../../../../../../main/ets/live/vm/LiveCapsuleVm';
import { CapsuleShowType } from '../../../../../../main/ets/liveview/common/LiveConstants';

export default function LiveCapsuleVmTest() {
  describe('getRect_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_rect_when_position_is_available', 0, () => {
      const live: LiveNotification = new LiveNotification()
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      when(mockfunc)().afterReturn({
        position: {
          left: 10, top: 20
        }
      });
      const result = livecapsulevm.getRect();
      expect(result.x).assertEqual(10);
      expect(result.y).assertEqual(20);
      expect(result.width).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      expect(result.height).assertEqual(LiveStyle.CAPSULE_HEIGHT);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    });


    it('should_return_default_rect_when_position_is_not_available', 0, () => {
      const live: LiveNotification = new LiveNotification()
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      when(mockfunc)().afterReturn({
        position: undefined
      });
      livecapsulevm.vmInjector = liveVmInjector;
      const result = livecapsulevm.getRect();
      expect(result.x).assertEqual(0);
      expect(result.y).assertEqual(0);
      expect(result.width).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      expect(result.height).assertEqual(LiveStyle.CAPSULE_HEIGHT);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    });


    it('should_set_isCakeShow_to_false_when_isPersistent_is_true', 0, () => {
        const live: LiveNotification = new LiveNotification()
        let liveVmInjector: LiveVmInjector = new LiveVmInjector();
        let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
        livecapsulevm.isPersistent = true;
        livecapsulevm.setCakeShowVal();
        expect(livecapsulevm.isCakeShow).assertEqual(false);
    });


    it('should_set_isCakeShow_to_true_when_showType_is_ROUND_CAKE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(true);
    });


    it('should_set_isCakeShow_to_true_when_showType_is_RIGHT_HOLE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.RIGHT_HOLE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(true);
    });


    it('should_set_isCakeShow_to_true_when_showType_is_LEFT_HOLE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.LEFT_HOLE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(true);
    });


    it('should_set_isCakeShow_to_false_when_showType_is_NONE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.NONE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(false);
    });


      it('should_return_true_when_live_is_persistent', 0, () => {
          let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
          let mocker: MockKit = new MockKit();
          let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isPersistent);
          when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
          const result = livecapsulevm.isNeedClip;
          expect(result).assertEqual(true);
          mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isPersistent);
      });


      it('should_return_false_when_showType_is_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_greater_than_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
          let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
          livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
          livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH + 1;
          const result = livecapsulevm.isNeedClip;
          expect(result).assertEqual(false);
      });


      it('should_return_true_when_showType_is_not_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_greater_than_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
          let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
          livecapsulevm.showType = CapsuleShowType.NONE;
          livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH + 1;
          const result = livecapsulevm.isNeedClip;
          expect(result).assertEqual(true);
      });


      it('should_return_false_when_showType_is_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_less_than_or_equal_to_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
          let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
          livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
          livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
          const result = livecapsulevm.isNeedClip;
          expect(result).assertEqual(false);
      });


      it('should_return_true_when_showType_is_not_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_less_than_or_equal_to_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
          let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
          livecapsulevm.showType = CapsuleShowType.NONE;
          livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
          const result = livecapsulevm.isNeedClip;
          expect(result).assertEqual(true);
      });


    it('should_return_true_when_isMediaPlayer_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsMediaPlayer: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
      when(mockfuncIsMediaPlayer)().afterReturn(true);
      const result = livecapsulevm.checkNeedExpandCard();
      expect(result).assertEqual(true);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
    });


    it('should_return_true_when_isFlashLight_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsFlashLight: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isFlashLight);
      when(mockfuncIsFlashLight)().afterReturn(true);
      const result = livecapsulevm.checkNeedExpandCard();
      expect(result).assertEqual(true);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isFlashLight);
    });


    it('should_return_false_when_neither_isMediaPlayer_nor_isFlashLight_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsMediaPlayer: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
      let mockfuncIsFlashLight: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isFlashLight);
      when(mockfuncIsMediaPlayer)().afterReturn(false);
      when(mockfuncIsFlashLight)().afterReturn(false);
      const result = livecapsulevm.checkNeedExpandCard();
      expect(result).assertEqual(false);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isFlashLight);
    });


    it('should_logInfo_when_isShow_is_false', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_startCapsuleWantAgent_when_isInstant_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => true } as LiveItemBaseVm;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('startCapsuleWantAgent', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
    });


    it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_need_expand', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.isPersistent = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
      livecapsulevm.checkNeedExpandCard = () => false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
      when(mockfunc)().afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('expandCapsuleToCard', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
    });


    it('should_startCapsuleWantAgent_when_isPersistent_is_true_and_need_expand_and_wantAgent_exists', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.isPersistent = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
      livecapsulevm.checkNeedExpandCard = () => true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('startCapsuleWantAgent', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
    });


    it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_wantAgent_and_need_expand', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.isPersistent = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: false } as LiveItemBaseVm;
      livecapsulevm.checkNeedExpandCard = () => true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
      when(mockfunc)().afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('expandCapsuleToCard', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
    });

    it('should_log_error_when_button_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      livecapsulevm.button = null;
      livecapsulevm.onClickButton();
      mocker.verify('showError', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_save_info_and_trigger_button_when_button_is_not_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockButton = { name: 'testButton' };
      livecapsulevm.button = mockButton as any;

      let mockStartVm = { triggerButton: () => {} };
      let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      when(mockGetStartVm)().afterReturn(mockStartVm);

      livecapsulevm.onClickButton();
      mocker.verify('showError', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
    });

    it('should_report_record_click_event_when_live_is_screen_recorder', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockButton = { name: 'testButton' };
      livecapsulevm.button = mockButton as any;

      let mockStartVm = { triggerButton: () => {} };
      let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      when(mockGetStartVm)().afterReturn(mockStartVm);

      let mockIsScreenRecorder = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
      when(mockIsScreenRecorder)().afterReturn(true);

      livecapsulevm.onClickButton();
      mocker.verify('showError', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
    });

    it('should_not_report_record_click_event_when_live_is_not_screen_recorder', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockButton = { name: 'testButton' };
      livecapsulevm.button = mockButton as any;

      let mockStartVm = { triggerButton: () => {} };
      let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      when(mockGetStartVm)().afterReturn(mockStartVm);

      let mockIsScreenRecorder = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
      when(mockIsScreenRecorder)().afterReturn(false);

      livecapsulevm.onClickButton();
      mocker.verify('showError', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
    });

    it('should_return_correct_gradient_colors_when_isMiddleCutout_is_true_and_showType_is_HANGING_HOLE', 0, async () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(true);
      livecapsulevm.showType = CapsuleShowType.HANGING_HOLE;
      livecapsulevm.linearGradientWidth = 200;
      const result = livecapsulevm.linearGradientColors;
      expect(result.length).assertEqual(3);
      expect(result[0][0]).assertEqual('rgba(0, 0, 0, 0.5)');
      expect(result[1][0]).assertEqual('rgba(0, 0, 0, 1)');
      expect(result[2][0]).assertEqual('rgba(0, 0, 0, 1)');
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_correct_gradient_colors_when_isMiddleCutout_is_false_or_showType_is_not_HANGING_HOLE', 0, async () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(false);
      livecapsulevm.showType = CapsuleShowType.NONE;
      livecapsulevm.linearGradientWidth = 200;
      const result = livecapsulevm.linearGradientColors;
      expect(result.length).assertEqual(2);
      expect(result[0][0]).assertEqual('rgba(0, 0, 0, 0)');
      expect(result[1][0]).assertEqual('rgba(0, 0, 0, 0)');
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_false_when_live_is_not_charge_and_capsule_is_not_progress', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isCharge);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      livecapsulevm.live.capsule = { isProgress: () => false };
      const result = livecapsulevm.isShowProgress;
      expect(result).assertEqual(false);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isCharge);
    });

    it('should_return_true_when_live_is_charge_and_capsule_is_progress', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isCharge);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      livecapsulevm.live.capsule = { isProgress: () => true };
      const result = livecapsulevm.isShowProgress;
      expect(result).assertEqual(true);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isCharge);
    });

    it('should_return_false_when_live_is_charge_and_capsule_is_not_progress', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isCharge);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      livecapsulevm.live.capsule = { isProgress: () => false };
      const result = livecapsulevm.isShowProgress;
      expect(result).assertEqual(false);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isCharge);
    });

    it('should_return_false_when_width_is_small_and_isLayoutSupportExtendShow_is_false', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
      let mockIsLayoutSupportExtendShow: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
      when(mockIsLayoutSupportExtendShow)([]).afterReturn(false);
      when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
      livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      livecapsulevm.isLayoutSupportExtendShow = false;
      livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
      livecapsulevm.deviceInfoVm = { width: 100 };
      expect(livecapsulevm.isExtendShow).assertEqual(false);
      mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
      mocker.ignoreMock(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
    });

    it('should_return_true_when_width_is_small_and_isLayoutSupportExtendShow_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
      let mockIsLayoutSupportExtendShow: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
      when(mockIsLayoutSupportExtendShow)([]).afterReturn(true);
      when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
      livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      livecapsulevm.isLayoutSupportExtendShow = false;
      livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
      livecapsulevm.deviceInfoVm = { width: 100 };
      expect(livecapsulevm.isExtendShow).assertEqual(true);
      mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
      mocker.ignoreMock(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
    });

    it('should_return_false_when_width_is_big_and_text_length_is_zero', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
      when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "" });
      livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      livecapsulevm.isLayoutSupportExtendShow = true;
      livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
      livecapsulevm.deviceInfoVm = { width: 1000 };
      expect(livecapsulevm.isExtendShow).assertEqual(false);
      mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
    });

    it('should_return_true_when_width_is_big_and_text_length_is_not_zero', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
      when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
      livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      livecapsulevm.isLayoutSupportExtendShow = true;
      livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
      livecapsulevm.deviceInfoVm = { width: 1000 };
      expect(livecapsulevm.isExtendShow).assertEqual(true);
      mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
    });

    it('should_return_false_when_live_is_instant_and_persistent', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
      when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
      livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      livecapsulevm.isLayoutSupportExtendShow = true;
      livecapsulevm.live = { isInstant: () => true, isPersistent: () => true };
      livecapsulevm.deviceInfoVm = { width: 1000 };
      expect(livecapsulevm.isExtendShow).assertEqual(false);
      mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
    });

    it('should_return_undefined_when_isTempDisplay_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isTempDisplay = true;
      const result = livecapsulevm.contentColor;
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_isPersistent_is_true_and_showTempColor_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = true;
      livecapsulevm.showTempColor = true;
      const result = livecapsulevm.contentColor;
      expect(result).assertUndefined();
    });

    it('should_return_Color_Transparent_when_isPersistent_is_true_and_showTempColor_is_false', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = true;
      livecapsulevm.showTempColor = false;
      const result = livecapsulevm.contentColor;
      expect(result).assertEqual(Color.Transparent);
    });

    it('should_return_backgroundColor_when_isPersistent_is_false_and_live_capsule_backgroundColor_is_not_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.live = {
        capsule: {
          backgroundColor: Color.Red
        }
      } as ILiveCapsuleVm;
      const result = livecapsulevm.contentColor;
      expect(result).assertEqual(Color.Red);
    });

    it('should_return_LiveStyle_CAPSULE_CONTENT_COLOR_when_isPersistent_is_false_and_live_capsule_backgroundColor_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.live = {
        capsule: {
          backgroundColor: null
        }
      } as ILiveCapsuleVm;
      const result = livecapsulevm.contentColor;
      expect(result).assertEqual(LiveStyle.CAPSULE_CONTENT_COLOR);
    });
    it('should_return_correct_rect_when_position_is_available', 0, () => {
      const live: LiveNotification = new LiveNotification()
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      when(mockfunc)().afterReturn({
        position: {
          left: 10, top: 20
        }
      });
      const result = livecapsulevm.getRect();
      expect(result.x).assertEqual(10);
      expect(result.y).assertEqual(20);
      expect(result.width).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      expect(result.height).assertEqual(LiveStyle.CAPSULE_HEIGHT);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    });


    it('should_return_default_rect_when_position_is_not_available', 0, () => {
      const live: LiveNotification = new LiveNotification()
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm(liveVmInjector, live);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      when(mockfunc)().afterReturn({
        position: undefined
      });
      livecapsulevm.vmInjector = liveVmInjector;
      const result = livecapsulevm.getRect();
      expect(result.x).assertEqual(0);
      expect(result.y).assertEqual(0);
      expect(result.width).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
      expect(result.height).assertEqual(LiveStyle.CAPSULE_HEIGHT);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    });


    it('should_set_isCakeShow_to_false_when_isPersistent_is_true', 0, () => {
      const live: LiveNotification = new LiveNotification()
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = true;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(false);
    });


    it('should_set_isCakeShow_to_true_when_showType_is_ROUND_CAKE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(true);
    });


    it('should_set_isCakeShow_to_true_when_showType_is_RIGHT_HOLE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.RIGHT_HOLE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(true);
    });


    it('should_set_isCakeShow_to_true_when_showType_is_LEFT_HOLE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.LEFT_HOLE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(true);
    });


    it('should_set_isCakeShow_to_false_when_showType_is_NONE', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isPersistent = false;
      livecapsulevm.showType = CapsuleShowType.NONE;
      livecapsulevm.setCakeShowVal();
      expect(livecapsulevm.isCakeShow).assertEqual(false);
    });


    it('should_return_true_when_live_is_persistent', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isPersistent);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      const result = livecapsulevm.isNeedClip;
      expect(result).assertEqual(true);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isPersistent);
    });


    it('should_return_false_when_showType_is_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_greater_than_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
      livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH + 1;
      const result = livecapsulevm.isNeedClip;
      expect(result).assertEqual(false);
    });


    it('should_return_true_when_showType_is_not_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_greater_than_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.showType = CapsuleShowType.NONE;
      livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH + 1;
      const result = livecapsulevm.isNeedClip;
      expect(result).assertEqual(true);
    });


    it('should_return_false_when_showType_is_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_less_than_or_equal_to_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
      livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      const result = livecapsulevm.isNeedClip;
      expect(result).assertEqual(false);
    });


    it('should_return_true_when_showType_is_not_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_less_than_or_equal_to_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.showType = CapsuleShowType.NONE;
      livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      const result = livecapsulevm.isNeedClip;
      expect(result).assertEqual(true);
    });


    it('should_return_true_when_isMediaPlayer_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsMediaPlayer: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
      when(mockfuncIsMediaPlayer)().afterReturn(true);
      const result = livecapsulevm.checkNeedExpandCard();
      expect(result).assertEqual(true);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
    });


    it('should_return_true_when_isFlashLight_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsFlashLight: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isFlashLight);
      when(mockfuncIsFlashLight)().afterReturn(true);
      const result = livecapsulevm.checkNeedExpandCard();
      expect(result).assertEqual(true);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isFlashLight);
    });


    it('should_return_false_when_neither_isMediaPlayer_nor_isFlashLight_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsMediaPlayer: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
      let mockfuncIsFlashLight: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isFlashLight);
      when(mockfuncIsMediaPlayer)().afterReturn(false);
      when(mockfuncIsFlashLight)().afterReturn(false);
      const result = livecapsulevm.checkNeedExpandCard();
      expect(result).assertEqual(false);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isFlashLight);
    });


    it('should_logInfo_when_isShow_is_false', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_startCapsuleWantAgent_when_isInstant_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => true } as LiveItemBaseVm;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('startCapsuleWantAgent', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
    });


    it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_need_expand', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.isPersistent = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
      livecapsulevm.checkNeedExpandCard = () => false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
      when(mockfunc)().afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('expandCapsuleToCard', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
    });


    it('should_startCapsuleWantAgent_when_isPersistent_is_true_and_need_expand_and_wantAgent_exists', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.isPersistent = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
      livecapsulevm.checkNeedExpandCard = () => true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('startCapsuleWantAgent', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
    });


    it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_wantAgent_and_need_expand', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isShow = true;
      livecapsulevm.isPersistent = true;
      livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: false } as LiveItemBaseVm;
      livecapsulevm.checkNeedExpandCard = () => true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
      when(mockfunc)().afterReturnNothing();
      livecapsulevm.onClick();
      mocker.verify('expandCapsuleToCard', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
    });

    it('should_log_error_when_button_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      livecapsulevm.button = null;
      livecapsulevm.onClickButton();
      mocker.verify('showError', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_save_info_and_trigger_button_when_button_is_not_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockButton = { name: 'testButton' };
      livecapsulevm.button = mockButton as any;

      let mockStartVm = { triggerButton: () => {} };
      let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      when(mockGetStartVm)().afterReturn(mockStartVm);

      livecapsulevm.onClickButton();
      mocker.verify('showError', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
    });

    it('should_report_record_click_event_when_live_is_screen_recorder', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockButton = { name: 'testButton' };
      livecapsulevm.button = mockButton as any;

      let mockStartVm = { triggerButton: () => {} };
      let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      when(mockGetStartVm)().afterReturn(mockStartVm);

      let mockIsScreenRecorder = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
      when(mockIsScreenRecorder)().afterReturn(true);

      livecapsulevm.onClickButton();

      mocker.verify('showError', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
      mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
    });

  });

  it('should_return_correct_rect_when_position_is_available', 0, () => {
    const live: LiveNotification = new LiveNotification()
    let liveVmInjector: LiveVmInjector = new LiveVmInjector();
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockfunc)().afterReturn({
      position: {
        left: 10, top: 20
      }
    });
    const result = livecapsulevm.getRect();
    expect(result.x).assertEqual(10);
    expect(result.y).assertEqual(20);
    expect(result.width).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
    expect(result.height).assertEqual(LiveStyle.CAPSULE_HEIGHT);
    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
  });


  it('should_return_default_rect_when_position_is_not_available', 0, () => {
    const live: LiveNotification = new LiveNotification()
    let liveVmInjector: LiveVmInjector = new LiveVmInjector();
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockfunc)().afterReturn({
      position: undefined
    });
    livecapsulevm.vmInjector = liveVmInjector;
    const result = livecapsulevm.getRect();
    expect(result.x).assertEqual(0);
    expect(result.y).assertEqual(0);
    expect(result.width).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
    expect(result.height).assertEqual(LiveStyle.CAPSULE_HEIGHT);
    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
  });


  it('should_set_isCakeShow_to_false_when_isPersistent_is_true', 0, () => {
    const live: LiveNotification = new LiveNotification()
    let liveVmInjector: LiveVmInjector = new LiveVmInjector();
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isPersistent = true;
    livecapsulevm.setCakeShowVal();
    expect(livecapsulevm.isCakeShow).assertEqual(false);
  });


  it('should_set_isCakeShow_to_true_when_showType_is_ROUND_CAKE', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isPersistent = false;
    livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
    livecapsulevm.setCakeShowVal();
    expect(livecapsulevm.isCakeShow).assertEqual(true);
  });


  it('should_set_isCakeShow_to_true_when_showType_is_RIGHT_HOLE', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isPersistent = false;
    livecapsulevm.showType = CapsuleShowType.RIGHT_HOLE;
    livecapsulevm.setCakeShowVal();
    expect(livecapsulevm.isCakeShow).assertEqual(true);
  });


  it('should_set_isCakeShow_to_true_when_showType_is_LEFT_HOLE', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isPersistent = false;
    livecapsulevm.showType = CapsuleShowType.LEFT_HOLE;
    livecapsulevm.setCakeShowVal();
    expect(livecapsulevm.isCakeShow).assertEqual(true);
  });


  it('should_set_isCakeShow_to_false_when_showType_is_NONE', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isPersistent = false;
    livecapsulevm.showType = CapsuleShowType.NONE;
    livecapsulevm.setCakeShowVal();
    expect(livecapsulevm.isCakeShow).assertEqual(false);
  });


  it('should_return_true_when_live_is_persistent', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isPersistent);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    const result = livecapsulevm.isNeedClip;
    expect(result).assertEqual(true);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isPersistent);
  });


  it('should_return_false_when_showType_is_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_greater_than_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
    livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH + 1;
    const result = livecapsulevm.isNeedClip;
    expect(result).assertEqual(false);
  });


  it('should_return_true_when_showType_is_not_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_greater_than_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.showType = CapsuleShowType.NONE;
    livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH + 1;
    const result = livecapsulevm.isNeedClip;
    expect(result).assertEqual(true);
  });


  it('should_return_false_when_showType_is_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_less_than_or_equal_to_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.showType = CapsuleShowType.ROUND_CAKE;
    livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
    const result = livecapsulevm.isNeedClip;
    expect(result).assertEqual(false);
  });


  it('should_return_true_when_showType_is_not_ROUND_CAKE_or_RIGHT_HOLE_or_LEFT_HOLE_and_fixedWidth_less_than_or_equal_to_LiveStyle.CAPSULE_CIRCLE_WIDTH', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.showType = CapsuleShowType.NONE;
    livecapsulevm.fixedWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
    const result = livecapsulevm.isNeedClip;
    expect(result).assertEqual(true);
  });


  it('should_return_true_when_isMediaPlayer_is_true', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfuncIsMediaPlayer: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
    when(mockfuncIsMediaPlayer)().afterReturn(true);
    const result = livecapsulevm.checkNeedExpandCard();
    expect(result).assertEqual(true);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
  });


  it('should_return_true_when_isFlashLight_is_true', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfuncIsFlashLight: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isFlashLight);
    when(mockfuncIsFlashLight)().afterReturn(true);
    const result = livecapsulevm.checkNeedExpandCard();
    expect(result).assertEqual(true);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isFlashLight);
  });


  it('should_return_false_when_neither_isMediaPlayer_nor_isFlashLight_is_true', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfuncIsMediaPlayer: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
    let mockfuncIsFlashLight: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isFlashLight);
    when(mockfuncIsMediaPlayer)().afterReturn(false);
    when(mockfuncIsFlashLight)().afterReturn(false);
    const result = livecapsulevm.checkNeedExpandCard();
    expect(result).assertEqual(false);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isMediaPlayer);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isFlashLight);
  });


  it('should_logInfo_when_isShow_is_false', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isShow = false;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
    livecapsulevm.onClick();
    mocker.verify('showInfo', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(LogHelper, LogHelper.showInfo);
  });


  it('should_startCapsuleWantAgent_when_isInstant_is_true', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isShow = true;
    livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => true } as LiveItemBaseVm;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
    when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturnNothing();
    livecapsulevm.onClick();
    mocker.verify('startCapsuleWantAgent', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
  });


  it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_need_expand', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isShow = true;
    livecapsulevm.isPersistent = true;
    livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
    livecapsulevm.checkNeedExpandCard = () => false;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
    when(mockfunc)().afterReturnNothing();
    livecapsulevm.onClick();
    mocker.verify('expandCapsuleToCard', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
  });


  it('should_startCapsuleWantAgent_when_isPersistent_is_true_and_need_expand_and_wantAgent_exists', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isShow = true;
    livecapsulevm.isPersistent = true;
    livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
    livecapsulevm.checkNeedExpandCard = () => true;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
    when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();
    livecapsulevm.onClick();
    mocker.verify('startCapsuleWantAgent', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
  });


  it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_wantAgent_and_need_expand', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isShow = true;
    livecapsulevm.isPersistent = true;
    livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: false } as LiveItemBaseVm;
    livecapsulevm.checkNeedExpandCard = () => true;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
    when(mockfunc)().afterReturnNothing();
    livecapsulevm.onClick();
    mocker.verify('expandCapsuleToCard', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
  });

  it('should_log_error_when_button_is_null', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
    when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

    livecapsulevm.button = null;
    livecapsulevm.onClickButton();
    mocker.verify('showError', [ArgumentMatchers.any]).once();

    mocker.ignoreMock(LogHelper, LogHelper.showError);
  });

  it('should_save_info_and_trigger_button_when_button_is_not_null', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
    when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

    let mockButton = { name: 'testButton' };
    livecapsulevm.button = mockButton as any;

    let mockStartVm = { triggerButton: () => {} };
    let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
    when(mockGetStartVm)().afterReturn(mockStartVm);

    livecapsulevm.onClickButton();
    mocker.verify('showError', [ArgumentMatchers.any]).once();

    mocker.ignoreMock(LogHelper, LogHelper.showError);
    mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
  });

  it('should_report_record_click_event_when_live_is_screen_recorder', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
    when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

    let mockButton = { name: 'testButton' };
    livecapsulevm.button = mockButton as any;

    let mockStartVm = { triggerButton: () => {} };
    let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
    when(mockGetStartVm)().afterReturn(mockStartVm);

    let mockIsScreenRecorder = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
    when(mockIsScreenRecorder)().afterReturn(true);

    livecapsulevm.onClickButton();
    mocker.verify('showError', [ArgumentMatchers.any]).once();

    mocker.ignoreMock(LogHelper, LogHelper.showError);
    mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
  });

  it('should_not_report_record_click_event_when_live_is_not_screen_recorder', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
    when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

    let mockButton = { name: 'testButton' };
    livecapsulevm.button = mockButton as any;

    let mockStartVm = { triggerButton: () => {} };
    let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
    when(mockGetStartVm)().afterReturn(mockStartVm);

    let mockIsScreenRecorder = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
    when(mockIsScreenRecorder)().afterReturn(false);

    livecapsulevm.onClickButton();
    mocker.verify('showError', [ArgumentMatchers.any]).once();

    mocker.ignoreMock(LogHelper, LogHelper.showError);
    mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
  });

  it('should_return_correct_gradient_colors_when_isMiddleCutout_is_true_and_showType_is_HANGING_HOLE', 0, async () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
    when(mockfunc)().afterReturn(true);
    livecapsulevm.showType = CapsuleShowType.HANGING_HOLE;
    livecapsulevm.linearGradientWidth = 200;
    const result = livecapsulevm.linearGradientColors;
    expect(result.length).assertEqual(3);
    expect(result[0][0]).assertEqual('rgba(0, 0, 0, 0.5)');
    expect(result[1][0]).assertEqual('rgba(0, 0, 0, 1)');
    expect(result[2][0]).assertEqual('rgba(0, 0, 0, 1)');
    mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
  });

  it('should_return_correct_gradient_colors_when_isMiddleCutout_is_false_or_showType_is_not_HANGING_HOLE', 0, async () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
    when(mockfunc)().afterReturn(false);
    livecapsulevm.showType = CapsuleShowType.NONE;
    livecapsulevm.linearGradientWidth = 200;
    const result = livecapsulevm.linearGradientColors;
    expect(result.length).assertEqual(2);
    expect(result[0][0]).assertEqual('rgba(0, 0, 0, 0)');
    expect(result[1][0]).assertEqual('rgba(0, 0, 0, 0)');
    mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
  });

  it('should_return_false_when_live_is_not_charge_and_capsule_is_not_progress', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isCharge);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    livecapsulevm.live.capsule = { isProgress: () => false };
    const result = livecapsulevm.isShowProgress;
    expect(result).assertEqual(false);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isCharge);
  });

  it('should_return_true_when_live_is_charge_and_capsule_is_progress', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isCharge);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    livecapsulevm.live.capsule = { isProgress: () => true };
    const result = livecapsulevm.isShowProgress;
    expect(result).assertEqual(true);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isCharge);
  });

  it('should_return_false_when_live_is_charge_and_capsule_is_not_progress', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isCharge);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    livecapsulevm.live.capsule = { isProgress: () => false };
    const result = livecapsulevm.isShowProgress;
    expect(result).assertEqual(false);
    mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isCharge);
  });

  it('should_return_false_when_width_is_small_and_isLayoutSupportExtendShow_is_false', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
    let mockIsLayoutSupportExtendShow: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
    when(mockIsLayoutSupportExtendShow)([]).afterReturn(false);
    when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
    livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
    livecapsulevm.isLayoutSupportExtendShow = false;
    livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
    livecapsulevm.deviceInfoVm = { width: 100 };
    expect(livecapsulevm.isExtendShow).assertEqual(false);
    mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
    mocker.ignoreMock(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
  });

  it('should_return_true_when_width_is_small_and_isLayoutSupportExtendShow_is_true', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
    let mockIsLayoutSupportExtendShow: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
    when(mockIsLayoutSupportExtendShow)([]).afterReturn(true);
    when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
    livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
    livecapsulevm.isLayoutSupportExtendShow = false;
    livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
    livecapsulevm.deviceInfoVm = { width: 100 };
    expect(livecapsulevm.isExtendShow).assertEqual(true);
    mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
    mocker.ignoreMock(livecapsulevm, livecapsulevm.isLayoutSupportExtendShow);
  });

  it('should_return_false_when_width_is_big_and_text_length_is_zero', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
    when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "" });
    livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
    livecapsulevm.isLayoutSupportExtendShow = true;
    livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
    livecapsulevm.deviceInfoVm = { width: 1000 };
    expect(livecapsulevm.isExtendShow).assertEqual(false);
    mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
  });

  it('should_return_true_when_width_is_big_and_text_length_is_not_zero', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
    when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
    livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
    livecapsulevm.isLayoutSupportExtendShow = true;
    livecapsulevm.live = { isInstant: () => false, isPersistent: () => false };
    livecapsulevm.deviceInfoVm = { width: 1000 };
    expect(livecapsulevm.isExtendShow).assertEqual(true);
    mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
  });

  it('should_return_false_when_live_is_instant_and_persistent', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    let mocker: MockKit = new MockKit();
    let mockMarqueeVm: Function = mocker.mockFunc(livecapsulevm, livecapsulevm.marqueeVm);
    when(mockMarqueeVm)([]).afterReturn({ getExtendText: () => "test" });
    livecapsulevm.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
    livecapsulevm.isLayoutSupportExtendShow = true;
    livecapsulevm.live = { isInstant: () => true, isPersistent: () => true };
    livecapsulevm.deviceInfoVm = { width: 1000 };
    expect(livecapsulevm.isExtendShow).assertEqual(false);
    mocker.ignoreMock(livecapsulevm, livecapsulevm.marqueeVm);
  });

  it('should_return_undefined_when_isTempDisplay_is_true', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isTempDisplay = true;
    const result = livecapsulevm.contentColor;
    expect(result).assertUndefined();
  });

  it('should_return_undefined_when_isPersistent_is_true_and_showTempColor_is_true', 0, () => {
    let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
    livecapsulevm.isPersistent = true;
    livecapsulevm.showTempColor = true;
    const result = livecapsulevm.contentColor;
    expect(result).assertUndefined();
  });

}