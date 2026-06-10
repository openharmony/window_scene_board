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
import curves from '@ohos.curves';
import { AnimateParams, AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
import { CapsuleShowType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { SystemUICommonUtil } from '../../../../../../main/ets/utils/SystemUICommonUtil';
import { BannerVm } from '../../../../../../main/ets/vm/BannerVm';
import { LiveCapsuleModel } from '../../../../../../main/ets/live/model/LiveCapsuleModel';
import { LiveCapsuleMarqueeVm } from '../../../../../../main/ets/live/vm/LiveCapsuleMarqueeVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCapsuleListAnimBaseVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListAnimBaseVm';

export default function LiveCapsuleListAnimBaseVmTest() {
  describe('showCapsuleText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });
    it('showCapsuleText', 0, async () => {
      let liveVmInjector = new LiveVmInjector();
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm(liveVmInjector);
      expect(livecapsulelistanimbasevm instanceof LiveCapsuleListAnimBaseVm).assertTrue();
    })
    it('should_execute_animation_with_correct_params', 0, async () => {
      let liveVmInjector = new LiveVmInjector();
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm(liveVmInjector);
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm(liveVmInjector, live);
      let mockGetCapsuleMarqueeVm: Function =
        mocker.mockFunc(livecapsulelistanimbasevm, liveVmInjector.getCapsuleMarqueeVm);
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(mockMarqueeVm);

      let animateParams: AnimateParams = {
        duration: 300,
        curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
        delay: 0,
        iterations: 1,
        event: (): void => {
          throw new Error('Function not implemented.');
        }
      };

      await livecapsulelistanimbasevm.showCapsuleText(live);


      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleMarqueeVm);
      expect(animateParams).not().assertFail();
    });

    it('should_log_error_when_live_is_null', 0, async () => {
      let liveVmInjector = new LiveVmInjector();
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm(liveVmInjector);
      let mocker: MockKit = new MockKit();

      expect(livecapsulelistanimbasevm.showCapsuleText).not().assertFail();
    });

    it('should_log_error_when_live_showType_is_null', 0, async () => {
      let liveVmInjector = new LiveVmInjector();
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm(liveVmInjector);
      let live: LiveNotification = new LiveNotification();

      await livecapsulelistanimbasevm.showCapsuleText(live);

      expect(livecapsulelistanimbasevm.showCapsuleText).not().assertFail();
    });

    it('should_log_error_when_live_title_is_null', 0, async () => {
      let liveVmInjector = new LiveVmInjector();
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm(liveVmInjector);
      let live: LiveNotification = new LiveNotification();

      await livecapsulelistanimbasevm.showCapsuleText(live);

      expect(livecapsulelistanimbasevm.showCapsuleText).not().assertFail();
    });

    it('should_log_error_when_live_subTitle_is_null', 0, async () => {
      let liveVmInjector = new LiveVmInjector();
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm(liveVmInjector);
      let live: LiveNotification = new LiveNotification();

      await livecapsulelistanimbasevm.showCapsuleText(live);

      expect(livecapsulelistanimbasevm.showCapsuleText).not().assertFail();
    });
  });
  describe('hideCapsuleText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_execute_animation_when_live_notification_is_valid', 0, async () => {
      let livecapsulelistanimbasevm: LiveCapsuleListAnimBaseVm = new LiveCapsuleListAnimBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleMarqueeVm: Function =
        mocker.mockFunc(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);
      let mockExecuteAnimation: Function =
        mocker.mockFunc(livecapsulelistanimbasevm.capsuleTextHideAnimation,
          livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);

      let live: LiveNotification = new LiveNotification();
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = new LiveCapsuleMarqueeVm();

      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(undefined);

      await livecapsulelistanimbasevm.hideCapsuleText(live);

      expect(capsuleMarqueeVm.scaleX).assertClose(0.8, 0.01);
      expect(capsuleMarqueeVm.scaleY).assertClose(0.8, 0.01);
      expect(capsuleMarqueeVm.opacity).assertClose(0, 0.01);
      expect(capsuleMarqueeVm.radius).assertEqual(30);
      expect(capsuleMarqueeVm.offsetX).assertEqual(capsuleMarqueeVm.fixedOffsetX);

      mocker.ignoreMock(livecapsulelistanimbasevm.vmInjector, livecapsulelistanimbasevm.vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistanimbasevm.capsuleTextHideAnimation,
        livecapsulelistanimbasevm.capsuleTextHideAnimation.executeAnimation);
    });
  });
}