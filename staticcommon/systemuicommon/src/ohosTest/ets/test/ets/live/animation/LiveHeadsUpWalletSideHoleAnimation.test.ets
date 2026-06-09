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
import { AnimateParams } from '../../../../main/ets/animation/AnimationBase';
import { LiveHeadsUpWalletAnimation } from '../../../../main/ets/live/animation/LiveHeadsUpWalletAnimation';
import { getWalletSwipeEnterNoHoleAnimation } from '../../../../main/ets/live/animation/wallet/WalletSwipeEnterNoHoleAnimation';
import { getWalletSwipeEnterRefreshImageNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeEnterRefreshImageNoHoleAni';
import { getSwipeEnterRotationNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeEnterRotationNoHoleAni';
import { getWalletSwipeEnterSweepNoHoleAnimation } from '../../../../main/ets/live/animation/wallet/WalletSwipeEnterSweepNoHoleAnimation';
import { getSwipeExitFailEndNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeExitFailEndNoHoleAni';
import { getSwipeExitFailEndPhaseOneNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeExitFailEndPhaseOneNoHoleAni';
import { getWalletSwipeExitFailStartNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeExitFailStartNoHoleAni';
import { getSwipeExitNoFeedbackEndNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeExitNoFeedbackEndNoHoleAni';
import { getSwipeExitSuccessEndNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeExitSuccessEndNoHoleAni';
import { getSwipeExitSuccessEndPhaseOneNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeExitSuccessEndPhaseOneNoHoleAni';
import { getWalletSwipeExitSuccessStartNoHoleAni } from '../../../../main/ets/live/animation/wallet/WalletSwipeExitSuccessStartNoHoleAni';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveHeadsUpWalletNoHoleAnimation } from '../../../../main/ets/live/animation/LiveHeadsUpWalletNoHoleAnimation';
export default function LiveHeadsUpWalletNoHoleAnimationTest() {
  describe('swipeExitSuccessStartAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('swipeExitSuccessStartAnimation_should_set_pageLayOutAlignment_to_true', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();
      await liveheadsupwalletnoholeanimation.swipeExitSuccessStartAnimation();
      expect(liveheadsupwalletnoholeanimation.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutAlignment).assertEqual(true);
    });

    it('swipeExitSuccessStartAnimation_should_call_super_swipeExitSuccessStartAnimation', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();
      await liveheadsupwalletnoholeanimation.swipeExitSuccessStartAnimation();
    });
    it('swipeExitFailStartAnimation_should_run_successfully', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();

      await liveheadsupwalletnoholeanimation.swipeExitFailStartAnimation();

    });

    it('swipeExitFailStartAnimation_should_set_pageLayOutAlignment_to_true', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();

      await liveheadsupwalletnoholeanimation.swipeExitFailStartAnimation();

      expect(liveheadsupwalletnoholeanimation.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutAlignment).assertEqual(true);

    });

    it('should_return_correct_animation_params_when_called', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();

      let resolve: (value: void | PromiseLike<void>) => void = () => {};
      const result = await liveheadsupwalletnoholeanimation.getSwipeExitFailEndData(resolve);

      expect(result.length).assertEqual(2);
      expect(result[0].constructor).assertEqual(AnimateParams);
      expect(result[1].constructor).assertEqual(AnimateParams);
    });

    it('should_return_correct_animation_params_when_called', 0, () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();


      const result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitFailStartData();
      expect(result).assertDeepEquals([
        new AnimateParams(),
        new AnimateParams()
      ]);

    });

    it('should_return_empty_array_when_walletVm_is_null', 0, () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();


      const result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitFailStartData();
      expect(result).assertDeepEquals([]);

    });

    it('should_return_correct_animation_params_when_called_with_onFinish_callback', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();

      let onFinish: () => Promise<void> = () => Promise.resolve();
      const result: AnimateParams[] = await liveheadsupwalletnoholeanimation.getSwipeExitSuccessEndPhaseOneData(onFinish);

      expect(result).assertInstanceOf(AnimateParams);
    });

    it('should_return_correct_animation_params_when_resolve_is_called', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let resolve: (value: void | PromiseLike<void>) => void = (resolve) => {
        resolve();
      };
      let result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitSuccessEndData(resolve);
      expect(result).assertInstanceOf(AnimateParams);
    });

    it('should_return_correct_animation_params_when_resolve_is_not_called', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let resolve: (value: void | PromiseLike<void>) => void = (resolve) => {
      };
      let result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitSuccessEndData(resolve);
      expect(result).assertInstanceOf(AnimateParams);
    });

    it('should_return_correct_animation_params_when_called', 0, () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();


      const result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitSuccessStartData();
      expect(result).assertDeepEquals([new AnimateParams()]);

    });

    it('should_return_correct_animation_params_when_resolve_is_called', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let resolve: (value: void | PromiseLike<void>) => void = (resolve) => {
        resolve();
      };
      let result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitSuccessEndData(resolve);
      expect(result).assertInstanceOf(AnimateParams);
    });

    it('should_return_correct_animation_params_when_resolve_is_not_called', 0, async () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let resolve: (value: void | PromiseLike<void>) => void = (resolve) => {
      };
      let result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitSuccessEndData(resolve);
      expect(result).assertInstanceOf(AnimateParams);
    });

    it('should_return_correct_animation_params_when_called', 0, () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();


      const result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeExitSuccessStartData();
      expect(result).assertDeepEquals([new AnimateParams()]);

    });

    it('should_return_correct_animation_params_when_getSwipeEnterRefreshImageData_is_called', 0, () => {
      let liveheadsupwalletnoholeanimation: LiveHeadsUpWalletNoHoleAnimation = new LiveHeadsUpWalletNoHoleAnimation();
      let mocker: MockKit = new MockKit();


      const result: AnimateParams[] = liveheadsupwalletnoholeanimation.getSwipeEnterRefreshImageData();
      expect(result).assertInstanceOf(AnimateParams);

    });

    it('should_call_executeAnimation_when_removeCard_is_called4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called1', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

  });
};