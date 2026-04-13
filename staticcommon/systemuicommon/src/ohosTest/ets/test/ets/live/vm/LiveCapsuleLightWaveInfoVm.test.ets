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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { AnimateParams, LiveVmInjector } from '../../../../../../../newIndex';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveCapsuleLightWaveVm } from '../../../../../../main/ets/live/vm/LiveCapsuleLightWaveVm';
import { curves } from '@kit.ArkUI';
import { CapsuleShowType } from '../../../../main/ets/live/model/LiveCommonModel';
import { LiveBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { SystemUICommonUtil } from '../../../../main/ets/utils/SystemUICommonUtil';
import { BannerVm } from '../../../../main/ets/vm/BannerVm';
import { LiveCapsuleModel } from '../../../../main/ets/live/model/LiveCapsuleModel';
import { LiveCapsuleMarqueeVm } from '../../../../main/ets/live/vm/LiveCapsuleMarqueeVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveCapsuleListAnimVm } from '../../../../main/ets/live/interface/ILiveCapsuleListAnimVm';
import { CapsuleTransferParam } from '../../../../main/ets/live/interface/ILiveCapsuleListVm';
import { LiveCapsuleListAnimBaseVm } from '../../../../main/ets/live/vm/LiveCapsuleListAnimBaseVm';

const CAPSULE_LIGHT_WAVE_CURVE = curves.cubicBezierCurve(0.08, 0.21, 0.30, 1.00);
const LIGHT_FINISH_DELAY = 730;

export default function LiveCapsuleLightWaveInfoVmTest() {
  describe('setAnimStartState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_positionX_to_offset_value', 0, () => {
      let livecapsulelightwavevm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      let offset: number = 10;
      livecapsulelightwavevm.setAnimStartState(offset);
      expect(livecapsulelightwavevm.positionX).assertEqual(offset);
    });
  });

  describe('setAnimFinishState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_lightShow_to_false_and_positionX_to_minus_40', 0, () => {
      let livecapsulelightwavevm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      livecapsulelightwavevm.setAnimFinishState();
      expect(livecapsulelightwavevm.lightShow).assertEqual(false);
      expect(livecapsulelightwavevm.positionX).assertEqual(-40);
    });
  });

  describe('doWaveAnim_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_animate_params_when_doWaveAnim_is_called', 0, async () => {
      let livecapsulelightwavevm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelightwavevm, livecapsulelightwavevm.setAnimFinishState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let result: AnimateParams[] = livecapsulelightwavevm.doWaveAnim(100, 50);
      expect(result.length).assertEqual(2);
      expect(result[0].curve).assertEqual(LiveStyle.CAPSULE_LIGHT_WAVE_CURVE);
      expect(result[0].duration).assertEqual(500);
      expect(result[0].delay).assertEqual(100);
      expect(result[1].curve).assertEqual(curves.Linear);
      expect(result[1].duration).assertEqual(1);
      expect(result[1].delay).assertEqual(LiveStyle.LIGHT_FINISH_DELAY + 100);

      mocker.ignoreMock(livecapsulelightwavevm, livecapsulelightwavevm.setAnimFinishState);
    });
  });

  describe('updateCapsuleAttribute_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isLivePanel_is_true', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(true);
      let liveList: LiveNotification[] = [];
      let updatedLive: LiveNotification = new LiveNotification();
      await livecapsulelistanimbasevm.updateCapsuleAttribute(liveList, updatedLive);
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
    });

    it('should_update_capsule_text_property_and_change_width_offset_when_isNeedUpdateText_is_false', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(false);
      let liveList: LiveNotification[] = [];
      let updatedLive: LiveNotification = new LiveNotification();
      updatedLive.showType = CapsuleShowType.DEFAULT;
      await livecapsulelistanimbasevm.updateCapsuleAttribute(liveList, updatedLive);
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
    });

    it('should_change_width_offset_and_return_immediately_when_updatedLive_is_undefined', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(false);
      let liveList: LiveNotification[] = [];
      await livecapsulelistanimbasevm.updateCapsuleAttribute(liveList);
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
    });

    it('should_call_updateCapsuleTextContent_when_isNeedUpdateText_is_true', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(livecapsulelistanimbasevm, livecapsulelistanimbasevm.updateCapsuleTextContent);
      when(mockfunc2)([ArgumentMatchers.anyObj, ArgumentMatchers.anyObj]).afterReturn(Promise.resolve());
      let liveList: LiveNotification[] = [];
      let updatedLive: LiveNotification = new LiveNotification();
      updatedLive.showType = CapsuleShowType.DEFAULT;
      await livecapsulelistanimbasevm.updateCapsuleAttribute(liveList, updatedLive);
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
      mocker.ignoreMock(livecapsulelistanimbasevm, livecapsulelistanimbasevm.updateCapsuleTextContent);
    });
  });

  describe('showCapsuleText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_execute_animation_when_live_capsule_show_type_is_text_and_marquee_is_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.showType = CapsuleShowType.SHOW_TYPE_TEXT;
      live.capsule.marquee = false;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();

      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.showCapsuleText(live);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_text_and_marquee_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.showType = CapsuleShowType.SHOW_TYPE_TEXT;
      live.capsule.marquee = true;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();

      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.showCapsuleText(live);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_marquee_and_marquee_is_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.showType = CapsuleShowType.SHOW_TYPE_MARQUEE;
      live.capsule.marquee = false;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();

      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.showCapsuleText(live);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_marquee_and_marquee_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.showType = CapsuleShowType.SHOW_TYPE_MARQUEE;
      live.capsule.marquee = true;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();

      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.showCapsuleText(live);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_roll_and_marquee_is_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.showType = CapsuleShowType.SHOW_TYPE_ROLL;
      live.capsule.marquee = false;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();

      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.showCapsuleText(live);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_roll_and_marquee_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.showType = CapsuleShowType.SHOW_TYPE_ROLL;
      live.capsule.marquee = true;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();

      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.showCapsuleText(live);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_marquee_and_roll_and_marquee_is_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveCapsuleModel();
      live.capsule.showType = CapsuleShowType.SHOW_TYPE_MARQUEE_ROLL;
      live.capsule.marquee = false;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();

      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.showCapsuleText(live);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation,
        livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
    });
  });

  describe('hideCapsuleText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_execute_animation_when_live_capsule_type_is_text_and_show_type_is_hide', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsuleType = CapsuleShowType.TEXT;
      live.showType = CapsuleShowType.HIDE;
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveBaseVm = new LiveBaseVm();
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.hideCapsuleText(live);

      expect(capsuleMarqueeVm.scaleX).assertEqual(0.8);
      expect(capsuleMarqueeVm.scaleY).assertEqual(0.8);
      expect(capsuleMarqueeVm.opacity).assertEqual(0);
      expect(capsuleMarqueeVm.radius).assertEqual(30);
      expect(capsuleMarqueeVm.offsetX).assertEqual(capsuleMarqueeVm.fixedOffsetX);

      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
    });

    it('should_execute_animation_when_live_capsule_type_is_picture_and_show_type_is_hide', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsuleType = CapsuleShowType.PICTURE;
      live.showType = CapsuleShowType.HIDE;
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveBaseVm = new LiveBaseVm();
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.hideCapsuleText(live);

      expect(capsuleMarqueeVm.scaleX).assertEqual(0.8);
      expect(capsuleMarqueeVm.scaleY).assertEqual(0.8);
      expect(capsuleMarqueeVm.opacity).assertEqual(0);
      expect(capsuleMarqueeVm.radius).assertEqual(30);
      expect(capsuleMarqueeVm.offsetX).assertEqual(capsuleMarqueeVm.fixedOffsetX);

      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
    });

    it('should_not_execute_animation_when_live_capsule_type_is_text_and_show_type_is_show', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsuleType = CapsuleShowType.TEXT;
      live.showType = CapsuleShowType.SHOW;
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveBaseVm = new LiveBaseVm();
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.hideCapsuleText(live);

      expect(capsuleMarqueeVm.scaleX).assertEqual(1);
      expect(capsuleMarqueeVm.scaleY).assertEqual(1);
      expect(capsuleMarqueeVm.opacity).assertEqual(1);
      expect(capsuleMarqueeVm.radius).assertEqual(0);
      expect(capsuleMarqueeVm.offsetX).assertEqual(0);

      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
    });

    it('should_not_execute_animation_when_live_capsule_type_is_picture_and_show_type_is_show', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.capsuleType = CapsuleShowType.PICTURE;
      live.showType = CapsuleShowType.SHOW;
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveBaseVm = new LiveBaseVm();
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.hideCapsuleText(live);

      expect(capsuleMarqueeVm.scaleX).assertEqual(1);
      expect(capsuleMarqueeVm.scaleY).assertEqual(1);
      expect(capsuleMarqueeVm.opacity).assertEqual(1);
      expect(capsuleMarqueeVm.radius).assertEqual(0);
      expect(capsuleMarqueeVm.offsetX).assertEqual(0);

      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
    });
  });
}