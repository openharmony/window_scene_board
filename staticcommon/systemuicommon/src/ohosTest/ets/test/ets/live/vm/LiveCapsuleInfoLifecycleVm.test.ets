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


import { AnimateParams, AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import { CapsuleShowType } from '../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { LiveBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { SystemUICommonUtil } from '../../../../main/ets/utils/SystemUICommonUtil';
import { BannerVm } from '../../../../main/ets/vm/BannerVm';
import { LiveCapsuleModel } from '../../../../main/ets/live/model/LiveCapsuleModel';
import { LiveCapsuleMarqueeVm } from '../../../../main/ets/live/vm/LiveCapsuleMarqueeVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveCapsuleListAnimVm } from '../../../../main/ets/live/interface/ILiveCapsuleListAnimVm';
import { CapsuleTransferParam } from '../../../../main/ets/live/interface/ILiveCapsuleListVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCapsuleListAnimBaseVm } from '../../../../main/ets/live/vm/LiveCapsuleListAnimBaseVm';
import { LiveCapsuleLightWaveVm } from '../../../../main/ets/live/vm/LiveCapsuleLightWaveVm';
import { curves } from '@kit.ArkUI';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import { ILiveCapsuleLightWaveVm } from '../../../../main/ets/live/interface/ILiveCapsuleLightWaveVm';
import { LiveItemBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { LiveCapsuleLifecycleVm } from '../../../../main/ets/live/vm/LiveCapsuleLifecycleVm';
import { ILiveCapsuleLifecycleVm } from '../../../../main/ets/live/interface/ILiveCapsuleLifecycleVm';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';

export default function LiveCapsuleInfoLifecycleVm() {
  describe('getCapsuleShowTime_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('should_return_0_when_totalKeepTime_is_null', 0, () => {
      let livecapsulelifecyclevm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelifecyclevm, livecapsulelifecyclevm.getCapsuleShowTime);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(null);
      const result = livecapsulelifecyclevm.getCapsuleShowTime(1);
      expect(result).assertEqual(0);
      mocker.ignoreMock(livecapsulelifecyclevm, livecapsulelifecyclevm.getCapsuleShowTime);
    });

    it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_not_null', 0, () => {
      let livecapsulelifecyclevm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelifecyclevm, livecapsulelifecyclevm.getCapsuleShowTime);
      let capsuleLifecycleInfo: CapsuleLifecycleInfo = { totalKeepTime: 2000 };
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
      const result = livecapsulelifecyclevm.getCapsuleShowTime(1);
      expect(result).assertEqual(2);
      mocker.ignoreMock(livecapsulelifecyclevm, livecapsulelifecyclevm.getCapsuleShowTime);
    });

    it('should_delete_lifecycle_info_and_log_info', 0, async () => {
      let livecapsulelifecyclevm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      let id: number = 1;
      livecapsulelifecyclevm.deleteLifecycleInfo(id);

      expect(livecapsulelifecyclevm.lifeMap.has(id)).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_deleting_lifecycle_info', 0, async () => {
      let livecapsulelifecyclevm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      let id: number = 1;
      livecapsulelifecyclevm.deleteLifecycleInfo(id);

      expect(livecapsulelifecyclevm.lifeMap.has(id)).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_start_count_time_when_capsule_is_show', 0, async () => {
      let livecapsulelifecyclevm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleLifecycleVm = new BaseVm();
      capsuleVm.isShow = true;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(capsuleVm);
      livecapsulelifecyclevm.vmInjector = liveVmInjector;
      let liveList: LiveNotification[] = [new LiveNotification()];
      await livecapsulelifecyclevm.updateCapsuleShow(liveList);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
    });

    it('should_end_count_time_when_capsule_is_not_show', 0, async () => {
      let livecapsulelifecyclevm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleLifecycleVm = new BaseVm();
      capsuleVm.isShow = false;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(capsuleVm);
      livecapsulelifecyclevm.vmInjector = liveVmInjector;
      let liveList: LiveNotification[] = [new LiveNotification()];
      await livecapsulelifecyclevm.updateCapsuleShow(liveList);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
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

    it('should_return_immediately_when_isLivePanel_is_true', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(true);
      await livecapsulelistanimbasevm.updateCapsuleAttribute([], {});
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
    });

    it('should_update_capsule_text_property_and_change_width_offset_when_updatedLive_is_not_provided', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(false);
      let mockUpdateCapsuleTextProperty: Function = mocker.mockFunc(livecapsulelistanimbasevm, livecapsulelistanimbasevm.updateCapsuleTextProperty);
      let mockChangeCapsuleWidthAndOffset: Function = mocker.mockFunc(livecapsulelistanimbasevm, livecapsulelistanimbasevm.changeCapsuleWidthAndOffset);
      when(mockUpdateCapsuleTextProperty)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();
      when(mockChangeCapsuleWidthAndOffset)([ArgumentMatchers.any]).afterReturnNothing();
      await livecapsulelistanimbasevm.updateCapsuleAttribute([], {});
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
      mocker.ignoreMock(livecapsulelistanimbasevm, livecapsulelistanimbasevm.updateCapsuleTextProperty);
      mocker.ignoreMock(livecapsulelistanimbasevm, livecapsulelistanimbasevm.changeCapsuleWidthAndOffset);
    });

    it('should_change_width_offset_and_return_immediately_when_isNeedUpdateText_is_false', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(false);
      let mockCheckIsNeedUpdateCapsuleText: Function = mocker.mockFunc(livecapsulelistanimbasevm, livecapsulelistanimbasevm.checkIsNeedUpdateCapsuleText);
      when(mockCheckIsNeedUpdateCapsuleText)([ArgumentMatchers.any]).afterReturn(false);
      let mockChangeCapsuleWidthAndOffset: Function = mocker.mockFunc(livecapsulelistanimbasevm, livecapsulelistanimbasevm.changeCapsuleWidthAndOffset);
      when(mockChangeCapsuleWidthAndOffset)([ArgumentMatchers.any]).afterReturnNothing();
      await livecapsulelistanimbasevm.updateCapsuleAttribute([], { capsuleShowType: CapsuleShowType.DEFAULT });
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
      mocker.ignoreMock(livecapsulelistanimbasevm, livecapsulelistanimbasevm.checkIsNeedUpdateCapsuleText);
      mocker.ignoreMock(livecapsulelistanimbasevm, livecapsulelistanimbasevm.changeCapsuleWidthAndOffset);
    });

    it('should_update_capsule_text_content_and_return_immediately_when_isNeedUpdateText_is_true', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(mockfunc)([]).afterReturn(false);
      let mockCheckIsNeedUpdateCapsuleText: Function = mocker.mockFunc(livecapsulelistanimbasevm, livecapsulelistanimbasevm.checkIsNeedUpdateCapsuleText);
      when(mockCheckIsNeedUpdateCapsuleText)([ArgumentMatchers.any]).afterReturn(true);
      let mockUpdateCapsuleTextContent: Function = mocker.mockFunc(livecapsulelistanimbasevm, livecapsulelistanimbasevm.updateCapsuleTextContent);
      when(mockUpdateCapsuleTextContent)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();
      await livecapsulelistanimbasevm.updateCapsuleAttribute([], { capsuleShowType: CapsuleShowType.DEFAULT });
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
      mocker.ignoreMock(livecapsulelistanimbasevm, livecapsulelistanimbasevm.checkIsNeedUpdateCapsuleText);
      mocker.ignoreMock(livecapsulelistanimbasevm, livecapsulelistanimbasevm.updateCapsuleTextContent);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_text_and_marquee_is_false', 0, async () => {
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.showType = CapsuleShowType.TEXT;
      liveCapsuleModel.marquee = false;
      let liveNotification: LiveNotification = new LiveNotification();
      liveNotification.liveCapsuleModel = liveCapsuleModel;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation, livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);

      let animateParams: AnimateParams = {
        curve: curves.interpolatingSpring(0, 1, 2, 3),
        duration: 1000,
        event: () => {
          const capsuleMarqueeVm = livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm(liveNotification);
          capsuleMarqueeVm.scaleX = 1;
          capsuleMarqueeVm.scaleY = 1;
          capsuleMarqueeVm.opacity = 1;
          capsuleMarqueeVm.radius = 0;
          capsuleMarqueeVm.offsetX = 0;
        }
      };

      when(mockExecuteAnimation)([ArgumentMatchers.anyObj], 'showCapsuleText').afterReturn(undefined);
      when(mockGetCapsuleMarqueeVm)([ArgumentMatchers.anyObj]).afterReturn(new LiveCapsuleMarqueeVm());

      await livecapsulelistanimbasevm.showCapsuleText(liveNotification);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation, livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      mocker.ignoreMock(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_text_and_marquee_is_true', 0, async () => {
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.showType = CapsuleShowType.TEXT;
      liveCapsuleModel.marquee = true;
      let liveNotification: LiveNotification = new LiveNotification();
      liveNotification.liveCapsuleModel = liveCapsuleModel;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation, livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);

      let animateParams: AnimateParams = {
        curve: curves.interpolatingSpring(0, 1, 2, 3),
        duration: 1000,
        event: () => {
          const capsuleMarqueeVm = livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm(liveNotification);
          capsuleMarqueeVm.scaleX = 1;
          capsuleMarqueeVm.scaleY = 1;
          capsuleMarqueeVm.opacity = 1;
          capsuleMarqueeVm.radius = 0;
          capsuleMarqueeVm.offsetX = 0;
        }
      };

      when(mockExecuteAnimation)([ArgumentMatchers.anyObj], 'showCapsuleText').afterReturn(undefined);
      when(mockGetCapsuleMarqueeVm)([ArgumentMatchers.anyObj]).afterReturn(new LiveCapsuleMarqueeVm());

      await livecapsulelistanimbasevm.showCapsuleText(liveNotification);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation, livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      mocker.ignoreMock(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);
    });

    it('should_execute_animation_when_live_capsule_show_type_is_marquee_and_marquee_is_false', 0, async () => {
      let liveCapsuleModel: LiveCapsuleModel = new LiveCapsuleModel();
      liveCapsuleModel.showType = CapsuleShowType.MARQUEE;
      liveCapsuleModel.marquee = false;
      let liveNotification: LiveNotification = new LiveNotification();
      liveNotification.liveCapsuleModel = liveCapsuleModel;

      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextShowAnimation, livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);

      let animateParams: AnimateParams = {
        curve: curves.interpolatingSpring(0, 1, 2, 3),
        duration: 1000,
        event: () => {
          const capsuleMarqueeVm = livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm(liveNotification);
          capsuleMarqueeVm.scaleX = 1;
          capsuleMarqueeVm.scaleY = 1;
          capsuleMarqueeVm.opacity = 1;
          capsuleMarqueeVm.radius = 0;
          capsuleMarqueeVm.offsetX = 0;
        }
      };

      when(mockExecuteAnimation)([ArgumentMatchers.anyObj], 'showCapsuleText').afterReturn(undefined);
      when(mockGetCapsuleMarqueeVm)([ArgumentMatchers.anyObj]).afterReturn(new LiveCapsuleMarqueeVm());

      await livecapsulelistanimbasevm.showCapsuleText(liveNotification);

      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextShowAnimation, livecapsulelistanimbasevm.capsuleTextShowAnimation.executeAnimation);
      mocker.ignoreMock(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);
    });

    it('should_execute_animation_when_live_notification_is_valid', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextHideAnimation, livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);

      let live: LiveNotification = new LiveNotification();
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();

      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(Promise.resolve());

      await livecapsulelistanimbasevm.hideCapsuleText(live);

      expect(capsuleMarqueeVm.scaleX).assertEqual(0.8);
      expect(capsuleMarqueeVm.scaleY).assertEqual(0.8);
      expect(capsuleMarqueeVm.opacity).assertEqual(0);
      expect(capsuleMarqueeVm.radius).assertEqual(30);
      expect(capsuleMarqueeVm.offsetX).assertEqual(capsuleMarqueeVm.fixedOffsetX);

      mocker.ignoreMock(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextHideAnimation, livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
    });
  });
}