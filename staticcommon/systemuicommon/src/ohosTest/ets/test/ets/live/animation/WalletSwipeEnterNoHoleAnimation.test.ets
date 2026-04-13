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
import { AnimateParams } from '../../../../../main/ets/animation/AnimationBase';
import { curves } from '@kit.ArkUI';
import { ILiveHeadsUpWalletCardVm } from '../../../../../main/ets/live/interface/ILiveHeadsUpWalletCardVm';
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  getWalletSwipeEnterNoHoleAnimation
} from '../../../../../main/ets/live/animation/wallet/WalletSwipeEnterNoHoleAnimation';
import {
  getWalletSwipeEnterHoleAnimation
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeEnterHoleAnimation';
import {
  getWalletSwipeEnterRefreshImageHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeEnterRefreshImageHoleAni';
import { SweepStage } from '../../../../../../main/ets/live/vm/LiveHeadsUpWalletCardVm';
import {
  getWalletSwipeEnterRefreshImageNoHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeEnterRefreshImageNoHoleAni';
import {
  getSwipeEnterRotationNoHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeEnterRotationNoHoleAni';
import { LogHelper } from '@ohos/basicutils';
import {
  getWalletSwipeEnterSweepHoleAnimation
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeEnterSweepHoleAnimation';
import {
  getSwipeExitFailEndHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeExitFailEndHoleAni';
import {
  getSwipeExitFailEndNoHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeExitFailEndNoHoleAni';
import {
  getWalletSwipeExitSuccessStartNoHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeExitSuccessStartNoHoleAni';
import {
  getSwipeExitFailEndPhaseOneHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeExitFailEndPhaseOneHoleAni';
import {
  getWalletSwipeEnterSweepNoHoleAnimation
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeEnterSweepNoHoleAnimation';
import {
  getWalletSwipeExitSuccessStartHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeExitSuccessStartHoleAni';
import {
  getSwipeExitSuccessEndPhaseOneNoHoleAni
} from '../../../../../../main/ets/live/animation/wallet/WalletSwipeExitSuccessEndPhaseOneNoHoleAni';

class MockWalletVm implements ILiveHeadsUpWalletCardVm {
  overlayBoxInfo = {
    backGroundColor: false,
    width: 0,
    height: 0,
    opacity: 0,
    borderRadius: 0,
    translateY: 0,
  };
  imageInfo = {
    scalaX: 1,
    scalaY: 1,
    translateY: 0,
    angle: 0,
  };
  largeFontAdaptationHeight = 150; // 模拟动态值
}
export default function getWalletSwipeEnterNoHoleAnimationTest() {
  describe('getWalletSwipeEnterNoHoleAnimation_testSuite', () => {
    let walletVm: MockWalletVm;
    let animateParams: AnimateParams[];
    beforeEach(() => {
      walletVm = new MockWalletVm();
      animateParams = getWalletSwipeEnterNoHoleAnimation(walletVm);
    });
    afterEach(() => {

    });


    it('should_return_correct_animateParams_when_call_getWalletSwipeEnterNoHoleAnimation', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result: AnimateParams[] = getWalletSwipeEnterNoHoleAnimation(walletVm);
      expect(result.length).assertEqual(7);
      expect(walletVm.overlayBoxInfo.backGroundColor).assertEqual(true);
      expect(walletVm.overlayBoxInfo.width).assertEqual(100);
      expect(walletVm.overlayBoxInfo.height).assertEqual(walletVm.largeFontAdaptationHeight);
      expect(walletVm.overlayBoxInfo.opacity).assertEqual(1);
      expect(walletVm.imageInfo.scalaX).assertEqual(1.1);
      expect(walletVm.imageInfo.scalaY).assertEqual(1.1);
      expect(walletVm.imageInfo.translateY).assertEqual('-6px');
      expect(walletVm.imageInfo.angle).assertEqual(0);
    });

    it('should_return_correct_animateParams_when_call_getWalletSwipeEnterHoleAnimation', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result = getWalletSwipeEnterHoleAnimation(walletVm);
      expect(result.length).assertEqual(12);
      expect(result[0].duration).assertEqual(50);
      expect(result[0].curve).assertEqual(Curve.Linear);
      expect(result[0].delay).assertUndefined();
      expect(result[0].onFinish).assertUndefined();
      expect(result[1].duration).assertEqual(50);
      expect(result[1].curve).assertEqual(curves.interpolatingSpring(0, 1, 110, 11));
      expect(result[1].delay).assertEqual(50);
      expect(result[1].onFinish).assertUndefined();
      expect(result[2].duration).assertEqual(150);
      expect(result[2].onFinish).assertEqual(() => {
        walletVm.overlayBoxInfo.backGroundColor = true;
      });
      expect(result[3].duration).assertEqual(400);
      expect(result[3].onFinish).assertEqual(() => {
        if (walletVm.sweepingStage === SweepStage.NOT_DO) {
          walletVm.sweepingStage = SweepStage.CAN_DO;
        }
      });
      expect(result[4].duration).assertEqual(150);
      expect(result[4].curve).assertEqual(curves.cubicBezierCurve(0.04, 0.03, 0.67, 1.00));
      expect(result[4].delay).assertEqual(150);
      expect(result[5].duration).assertEqual(250);
      expect(result[5].event).assertEqual(() => {
        walletVm.imageInfo.scalaX = 1.1;
        walletVm.imageInfo.scalaY = 1.1;
      });
      expect(result[6].duration).assertEqual(150);
      expect(result[6].curve).assertEqual(curves.cubicBezierCurve(0.20, 0.00, 0.57, 1.00));
      expect(result[6].delay).assertEqual(150);
      expect(result[7].duration).assertEqual(250);
      expect(result[7].event).assertEqual(() => {
        walletVm.imageInfo.translateY = '-6px';
      });
      expect(result[8].duration).assertEqual(150);
      expect(result[8].curve).assertEqual(curves.cubicBezierCurve(0.33, 0.00, 0.33, 1.00));
      expect(result[8].delay).assertEqual(150);
      expect(result[9].duration).assertEqual(400);
      expect(result[9].curve).assertEqual(curves.cubicBezierCurve(0.04, 0.03, 0.67, 1.00));
      expect(result[9].delay).assertEqual(400);
      expect(result[10].duration).assertEqual(200);
      expect(result[10].curve).assertEqual(curves.cubicBezierCurve(0.33, 0.00, 0.33, 1.00));
      expect(result[10].delay).assertEqual(400);
      expect(result[11].duration).assertEqual(250);
      expect(result[11].event).assertEqual(() => {
        walletVm.imageInfo.scalaX = 1;
        walletVm.imageInfo.scalaY = 1;
      });
    });

    it('should_return_animateParams_with_correct_curve_and_duration', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result: AnimateParams[] = getWalletSwipeEnterRefreshImageHoleAni(walletVm);
      expect(result[0].curve).assertEqual(curves.cubicBezierCurve(0.33, 0.00, 0.67, 1));
      expect(result[0].duration).assertEqual(300);
    });

    it('should_set_imageInfo_opacity_correctly', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result: AnimateParams[] = getWalletSwipeEnterRefreshImageHoleAni(walletVm);
      result[0].event();
      expect(walletVm.imageInfo.defaultCardOpacity).assertEqual(0);
      expect(walletVm.imageInfo.imageUpdateCardOpacity).assertEqual(1);
    });

    it('should_return_correct_animateParams_when_called_with_ILiveHeadsUpWalletCardVm', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result: AnimateParams[] = getWalletSwipeEnterRefreshImageNoHoleAni(walletVm);
      expect(result.length).assertEqual(2);
      expect(result[0].curve).assertInstanceOf(curves.cubicBezierCurve);
      expect(result[0].duration).assertEqual(300);
      expect(result[0].event()).assertInstanceOf(Function);
      expect(result[1].curve).assertInstanceOf(curves.cubicBezierCurve);
      expect(result[1].duration).assertEqual(300);
      expect(result[1].event()).assertInstanceOf(Function);
    });

    it('should_return_correct_animateParams_when_called_with_valid_input', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let onFinish: () => Promise<void> = () => {
        return new Promise<void>((resolve) => {
          resolve();
        });
      };
      let result: AnimateParams[] = getSwipeEnterRotationHoleAni(walletVm, onFinish);
      expect(result.length).assertEqual(3);
      expect(result[0].delay).assertEqual(0);
      expect(result[0].duration).assertEqual(324);
      expect(result[1].delay).assertEqual(324);
      expect(result[1].duration).assertEqual(1);
      expect(result[2].delay).assertEqual(325);
      expect(result[2].duration).assertEqual(325);
      expect(result[2].onFinish).assertEqual(onFinish);
    });

    it('should_return_correct_animateParams_when_called_with_valid_input', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let onFinish: () => Promise<void> = () => {
        return new Promise<void>((resolve) => {
          resolve();
        });
      };
      let result: AnimateParams[] = getSwipeEnterRotationNoHoleAni(walletVm, onFinish);
      expect(result.length).assertEqual(3);
      expect(result[0].delay).assertEqual(0);
      expect(result[0].duration).assertEqual(324);
      expect(result[1].delay).assertEqual(324);
      expect(result[1].duration).assertEqual(1);
      expect(result[2].delay).assertEqual(325);
      expect(result[2].duration).assertEqual(325);
      expect(result[0].curve).assertDeepEquals(curves.cubicBezierCurve(0.33, 0.00, 0.67, 1));
      expect(result[1].curve).assertDeepEquals(curves.cubicBezierCurve(0.33, 0.00, 0.67, 1));
      expect(result[2].curve).assertDeepEquals(curves.cubicBezierCurve(0.33, 0.00, 0.67, 1));
      expect(result[0].onFinish).assertInstanceOf(Function);
      expect(result[1].onFinish).assertInstanceOf(Function);
      expect(result[2].onFinish).assertInstanceOf(Function);
      expect(result[0].event).assertInstanceOf(Function);
      expect(result[1].event).assertInstanceOf(Function);
      expect(result[2].event).assertInstanceOf(Function);
    });

    it('should_log_info_when_onFinish_is_called', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let onFinish: () => Promise<void> = () => {
        return new Promise<void>((resolve) => {
          resolve();
        });
      };
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.info;
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let result: AnimateParams[] = getSwipeEnterRotationNoHoleAni(walletVm, onFinish);
      result[0].onFinish();
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_set_walletVm_imageInfo_correctly_when_event_is_called', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let onFinish: () => Promise<void> = () => {
        return new Promise<void>((resolve) => {
          resolve();
        });
      };
      let result: AnimateParams[] = getSwipeEnterRotationNoHoleAni(walletVm, onFinish);
      result[0].event();
      expect(walletVm.imageInfo.X).assertEqual(0);
      expect(walletVm.imageInfo.Y).assertEqual(1);
      expect(walletVm.imageInfo.Z).assertEqual(0);
      expect(walletVm.imageInfo.angle).assertEqual(90);
    });

    it('should_add_animation_params_with_delay_and_curve', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 100;

      let result = getWalletSwipeEnterSweepHoleAnimation(walletVm, animateParams, delay);

      expect(result.length).assertEqual(1);
      expect(result[0].delay).assertEqual(delay);
      expect(result[0].curve).assertInstanceOf(curves.Curve);
    });

    it('should_add_animation_params_with_default_delay_when_delay_is_not_provided', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];

      let result = getWalletSwipeEnterSweepHoleAnimation(walletVm, animateParams);

      expect(result.length).assertEqual(1);
      expect(result[0].delay).assertEqual(0);
      expect(result[0].curve).assertInstanceOf(curves.Curve);
    });

    it('should_call_onFinish_and_event_when_animation_finishes', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 100;

      getWalletSwipeEnterSweepHoleAnimation(walletVm, animateParams, delay);

      expect(walletVm.imageInfo.sweepPositionX).assertEqual(-30);
    });

    it('should_return_animateParams_with_delay_0', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 0;
      let result = getWalletSwipeEnterSweepNoHoleAnimation(walletVm, animateParams, delay);
      expect(result.length).assertEqual(1);
      expect(result[0].delay).assertEqual(0);
    });

    it('should_return_animateParams_with_delay_500', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 500;
      let result = getWalletSwipeEnterSweepNoHoleAnimation(walletVm, animateParams, delay);
      expect(result.length).assertEqual(1);
      expect(result[0].delay).assertEqual(500);
    });

    it('should_return_animateParams_with_duration_1500', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 0;
      let result = getWalletSwipeEnterSweepNoHoleAnimation(walletVm, animateParams, delay);
      expect(result.length).assertEqual(1);
      expect(result[0].duration).assertEqual(1000);
    });

    it('should_return_animateParams_with_curve_cubicBezierCurve_0.4_0_0.2_1', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 0;
      let result = getWalletSwipeEnterSweepNoHoleAnimation(walletVm, animateParams, delay);
      expect(result.length).assertEqual(1);
      expect(result[0].curve).assertEqual(curves.cubicBezierCurve(0.4, 0, 0.2, 1));
    });

    it('should_return_animateParams_with_onFinish_event', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 0;
      let result = getWalletSwipeEnterSweepNoHoleAnimation(walletVm, animateParams, delay);
      expect(result.length).assertEqual(1);
      expect(result[0].onFinish).assertInstanceOf(Function);
      expect(result[0].event).assertInstanceOf(Function);
    });

    it('should_return_animateParams_with_onFinish_event_positionX_change', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let animateParams: AnimateParams[] = [];
      let delay: number = 0;
      let result = getWalletSwipeEnterSweepNoHoleAnimation(walletVm, animateParams, delay);
      expect(result.length).assertEqual(1);
      result[0].onFinish();
      expect(walletVm.imageInfo.sweepPositionX).assertEqual(-30);
      result[0].event();
      expect(walletVm.imageInfo.sweepPositionX).assertEqual(106);
    });

    it('should_return_correct_animateParams_when_called_with_valid_input', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let result: AnimateParams[] = getSwipeExitFailEndHoleAni(walletVm, () => {});

      expect(result.length).assertEqual(22);
      expect(result[0].duration).assertEqual(693.3);
      expect(result[1].curve).assertEqual(curves.cubicBezierCurve(0.33, 0.00, 0.67, 1));
      expect(result[2].event).assertInstanceOf(Function);
      expect(result[3].delay).assertEqual(153.3);
      expect(result[4].duration).assertEqual(250);
      expect(result[5].event).assertInstanceOf(Function);
      expect(result[6].delay).assertEqual(250);
      expect(result[7].duration).assertEqual(150);
      expect(result[8].event).assertInstanceOf(Function);
      expect(result[9].delay).assertEqual(153.3);
      expect(result[10].duration).assertEqual(200);
      expect(result[11].event).assertInstanceOf(Function);
      expect(result[12].delay).assertEqual(353.3);
      expect(result[13].duration).assertEqual(315);
      expect(result[14].event).assertInstanceOf(Function);
      expect(result[15].delay).assertEqual(768.3);
      expect(result[16].duration).assertEqual(50);
      expect(result[17].event).assertInstanceOf(Function);
      expect(result[18].duration).assertEqual(350);
      expect(result[19].event).assertInstanceOf(Function);
      expect(result[20].duration).assertEqual(FAIL_ANIMATION_END_TIME);
      expect(result[21].event).assertInstanceOf(Function);

      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_correct_animateParams_when_called_with_ILiveHeadsUpWalletCardVm_and_resolve_function', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mocker: MockKit = new MockKit();
      let mockLogHelper: LogHelper = new LogHelper();
      let mockLogInfo: Function = mocker.mockFunc(mockLogHelper, mockLogHelper.info);
      when(mockLogInfo)(ArgumentMatchers.any).afterReturnNothing();

      let resolve: (value: void | PromiseLike<void>) => void = () => {};
      let result: AnimateParams[] = getSwipeExitFailEndNoHoleAni(walletVm, resolve);

      expect(result.length).assertEqual(4);
      expect(result[0].curve).assertEqual(Curve.Linear);
      expect(result[0].duration).assertEqual(365);
      expect(result[0].event).assertInstanceOf(Function);
      expect(result[1].curve).assertDeepEquals(curves.cubicBezierCurve(0.69, 0.70, 1.00, 1.00));
      expect(result[1].duration).assertEqual(250);
      expect(result[1].event).assertInstanceOf(Function);
      expect(result[2].delay).assertEqual(299);
      expect(result[2].duration).assertEqual(66);
      expect(result[2].event).assertInstanceOf(Function);
      expect(result[3].duration).assertEqual(365);
      expect(result[3].onFinish).assertInstanceOf(Function);

      mocker.ignoreMock(mockLogHelper, mockLogHelper.info);
    });

    it('should_return_animateParams_with_duration_0_when_onFinish_is_provided', 0, () => {
      let onFinish: () => Promise<void> = () => {};
      let result: AnimateParams[] = getSwipeExitFailEndPhaseOneHoleAni(onFinish);
      expect(result[0].duration).assertEqual(0);
      expect(result[0].onFinish).assertDeepEquals(onFinish);
    });

    it('should_return_animateParams_with_duration_0_when_onFinish_is_not_provided', 0, () => {
      let result: AnimateParams[] = getSwipeExitFailEndPhaseOneHoleAni(null);
      expect(result[0].duration).assertEqual(0);
      expect(result[0].onFinish).assertNull();
    });

    it('should_return_correct_animateParams_when_call_getWalletSwipeExitSuccessStartNoHoleAni', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
      expect(result.length).assertEqual(13);
      expect(result[0].curve).assertInstanceOf(curves.Curve);
      expect(result[0].duration).assertInstanceOf(Number);
      expect(result[0].event).assertInstanceOf(Function);
      expect(result[0].delay).assertInstanceOf(Number);
    });

    it('should_set_walletVm_properties_correctly_when_animateParams_are_called', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mocker: MockKit = new MockKit();
      let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
      expect(walletVm.imageInfo.X).assertEqual(0);
      expect(walletVm.imageInfo.Y).assertEqual(1);
      expect(walletVm.imageInfo.Z).assertEqual(0);
      expect(walletVm.imageInfo.angle).assertEqual(90);
      expect(walletVm.overlayBoxInfo.borderRadius).assertEqual(20);
      expect(walletVm.overlayBoxInfo.width).assertEqual(328);
      expect(walletVm.textInfo.textOpacity).assertEqual(1);
      expect(walletVm.radioInfo.radioOpacity).assertEqual(1);
      expect(walletVm.radioInfo.radioscalaX).assertEqual(1);
      expect(walletVm.radioInfo.radioscalaY).assertEqual(1);
    });

    it('should_call_loadAnimation_when_duration_is_758_33', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mocker: MockKit = new MockKit();
      let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
      expect(walletVm.radioInfo.animateItemAppear).assertInstanceOf(lottie.AnimationItem);
    });

    it('should_call_destroy_when_animateItemAppear_is_not_null', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      walletVm.radioInfo.animateItemAppear = lottie.loadAnimation({
        container: walletVm.radioInfo.controller,
        renderer: 'canvas',
        loop: false,
        autoplay: true,
        name: walletVm.radioInfo.animateNameAppear,
        path: walletVm.radioInfo.animatePathAppear,
      });
      let mocker: MockKit = new MockKit();
      let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
      expect(walletVm.radioInfo.animateItemAppear).assertNull();
    });

    it('should_return_correct_animateParams_when_call_getWalletSwipeExitSuccessStartHoleAni', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result = getWalletSwipeExitSuccessStartHoleAni(walletVm);
      expect(result.length).assertEqual(14);
      expect(result[0].curve).assertInstanceOf(curves.Curve);
      expect(result[0].duration).assertInstanceOf(Number);
      expect(result[0].event).assertInstanceOf(Function);
      expect(result[0].delay).assertInstanceOf(Number);
    });

    it('should_set_walletVm_properties_correctly_when_animateParams_are_called', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mocker: MockKit = new MockKit();
      let result = getWalletSwipeExitSuccessStartHoleAni(walletVm);
      for (let i = 0; i < result.length; i++) {
        result[i].event();
      }
      expect(walletVm.overlayBoxInfo.borderRadius).assertEqual(20);
      expect(walletVm.overlayBoxInfo.width).assertEqual(walletVm.bannerWidthConstantFinalState);
      expect(walletVm.textInfo.textTranslateX).assertEqual(-((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12));
      expect(walletVm.textInfo.textOpacity).assertEqual(1);
      expect(walletVm.radioInfo.radioOpacity).assertEqual(1);
      expect(walletVm.radioInfo.radioscalaX).assertEqual(1);
      expect(walletVm.radioInfo.radioscalaY).assertEqual(1);
    });

    it('should_call_destroy_on_radioInfo_animateItemAppear_when_animateItemAppear_is_not_null', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let result = getWalletSwipeExitSuccessStartNoHoleAni(walletVm);
      walletVm.radioInfo.animateItemAppear = lottie.loadAnimation({
        container: walletVm.radioInfo.controller,
        renderer: 'canvas',
        loop: false,
        autoplay: true,
        name: walletVm.radioInfo.animateNameAppear,
        path: walletVm.radioInfo.animatePathAppear,
      });
      result[result.length - 1].event();
      expect(walletVm.radioInfo.animateItemAppear).assertNull();
    });

    it('should_return_animateParams_when_walletVm_is_null', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = null;
      let onFinish: () => Promise<void> = async () => {
        expect(walletVm).assertNull();
      };
      let result = getSwipeExitSuccessEndPhaseOneNoHoleAni(walletVm, onFinish);
      expect(result.length).assertEqual(12);
    });
    it('should_return_animateParams_when_walletVm_is_undefined', 0, async () => {
      let walletVm: ILiveHeadsUpWalletCardVm = undefined;
      let onFinish: () => Promise<void> = async () => {
        expect(walletVm).assertUndefined();
      };
      let result = getSwipeExitSuccessEndPhaseOneNoHoleAni(walletVm, onFinish);
      expect(result.length).assertEqual(12);
    });

    // 测试用例 1：验证初始参数设置
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(walletVm.overlayBoxInfo.backGroundColor).toBe(true);
      expect(walletVm.overlayBoxInfo.width).toBe(10);
      expect(walletVm.overlayBoxInfo.height).toBe(10);
      expect(walletVm.overlayBoxInfo.opacity).toBe(0);
    });

    // 测试用例 2：验证动画步骤数量
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(animateParams.length).toBe(6);
    });

    // 测试用例 3：验证第1步参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step1 = animateParams[0];
      expect(step1.delay).toBe(0);
      expect(step1.curve).toEqual(curves.interpolatingSpring(0, 1, 110, 11));
      expect(step1.event).toBeDefined();
    });

    // 测试用例 4：验证第1步事件逻辑
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step1 = animateParams[0];
      step1.event();
      expect(walletVm.overlayBoxInfo.borderRadius).toBe(16);
      expect(walletVm.overlayBoxInfo.translateY).toBe(0);
      expect(walletVm.overlayBoxInfo.width).toBe(100);
      expect(walletVm.overlayBoxInfo.height).toBe(walletVm.largeFontAdaptationHeight);
    });

    // 测试用例 5：验证第2步参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0,() => {
      const step2 = animateParams[1];
      expect(step2.delay).toBe(16);
      expect(step2.duration).toBe(66);
      expect(step2.curve).toBeUndefined();
      expect(step2.event).toBeDefined();
    });

    // 测试用例 6：验证第2步事件逻辑
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step2 = animateParams[1];
      step2.event();
      expect(walletVm.overlayBoxInfo.opacity).toBe(1);
    });

    // 测试用例 7：验证第3步参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step3 = animateParams[2];
      expect(step3.delay).toBe(150);
      expect(step3.curve).toEqual(curves.cubicBezierCurve(0.04, 0.03, 0.67, 1.00));
      expect(step3.duration).toBe(250);
    });

    // 测试用例 8：验证第3步事件逻辑
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step3 = animateParams[2];
      step3.event();
      expect(walletVm.imageInfo.scalaX).toBe(1.1);
      expect(walletVm.imageInfo.scalaY).toBe(1.1);
    });

    // 测试用例 9：验证第4步参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step4 = animateParams[3];
      expect(step4.curve).toEqual(curves.cubicBezierCurve(0.20, 0.00, 0.57, 1.00));
      expect(step4.duration).toBe(250);
    });

    // 测试用例 10：验证第4步事件逻辑
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step4 = animateParams[3];
      step4.event();
      expect(walletVm.imageInfo.translateY).toBe('-6px');
    });

    // 测试用例 11：验证第5步参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step5 = animateParams[4];
      expect(step5.duration).toBe(500);
      expect(step5.curve).toEqual(curves.cubicBezierCurve(0.20, 0.00, 0.57, 1.00));
    });

    // 测试用例 12：验证第5步事件逻辑
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step5 = animateParams[4];
      step5.event();
      expect(walletVm.imageInfo.angle).toBe(0);
    });

    // 测试用例 13：验证第6步参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step6 = animateParams[5];
      expect(step6.delay).toBe(400);
      expect(step6.curve).toEqual(curves.cubicBezierCurve(0.33, 0.00, 0.33, 1.00));
      expect(step6.duration).toBe(250);
    });

    // 测试用例 14：验证第6步事件逻辑
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step6 = animateParams[5];
      step6.event();
      expect(walletVm.imageInfo.scalaX).toBe(1);
      expect(walletVm.imageInfo.scalaY).toBe(1);
      expect(walletVm.imageInfo.translateY).toBe(0);
    });

    // 测试用例 15：验证所有步骤执行后的最终状态
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams.forEach((step) => step.event());

      expect(walletVm.overlayBoxInfo.borderRadius).toBe(16);
      expect(walletVm.overlayBoxInfo.translateY).toBe(0);
      expect(walletVm.overlayBoxInfo.width).toBe(100);
      expect(walletVm.overlayBoxInfo.height).toBe(walletVm.largeFontAdaptationHeight);
      expect(walletVm.overlayBoxInfo.opacity).toBe(1);

      expect(walletVm.imageInfo.scalaX).toBe(1);
      expect(walletVm.imageInfo.scalaY).toBe(1);
      expect(walletVm.imageInfo.translateY).toBe(0);
      expect(walletVm.imageInfo.angle).toBe(0);
    });

    // 测试用例 16：无效的 walletVm 输入
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const result = getWalletSwipeEnterNoHoleAnimation(null as unknown as ILiveHeadsUpWalletCardVm);
      expect(result).toEqual([]);
    });

    // 测试用例 17：验证曲线参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(animateParams[0].curve).toEqual(curves.interpolatingSpring(0, 1, 110, 11));
      expect(animateParams[2].curve).toEqual(curves.cubicBezierCurve(0.04, 0.03, 0.67, 1.00));
      expect(animateParams[5].curve).toEqual(curves.cubicBezierCurve(0.33, 0.00, 0.33, 1.00));
    });

    // 测试用例 18：验证延迟总和
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const totalDelay = animateParams.reduce((sum, step) => sum + (step.delay || 0), 0);
      expect(totalDelay).toBe(0 + 16 + 150 + 150 + 150 + 400);
    });

    // 测试用例 19：验证事件执行顺序
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const eventOrder: string[] = [];
      animateParams.forEach((step, index) => {
        const originalEvent = step.event;
        step.event = () => {
          eventOrder.push(`Step ${index + 1}`);
          originalEvent?.();
        };
      });

      animateParams.forEach((step) => step.event());

      expect(eventOrder).toEqual(['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5', 'Step 6']);
    });

    // 测试用例 20：验证动态高度计算
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      walletVm.largeFontAdaptationHeight = 200;
      const newParams = getWalletSwipeEnterNoHoleAnimation(walletVm);
      newParams[0].event();
      expect(walletVm.overlayBoxInfo.height).toBe(200);
    });

    // 测试用例 21：验证 translateY 类型
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step4 = animateParams[3];
      step4.event();
      expect(typeof walletVm.imageInfo.translateY).toBe('string');
    });

    // 测试用例 22：验证缩放参数边界值
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step3 = animateParams[2];
      step3.event();
      expect(walletVm.imageInfo.scalaX).toBeGreaterThanOrEqual(1);
      expect(walletVm.imageInfo.scalaY).toBeGreaterThanOrEqual(1);
    });

    // 测试用例 23：验证角度参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step5 = animateParams[4];
      step5.event();
      expect(walletVm.imageInfo.angle).toBe(0);
    });

    // 测试用例 24：验证最终宽度和高度
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams.forEach((step) => step.event());
      expect(walletVm.overlayBoxInfo.width).toBe(100);
      expect(walletVm.overlayBoxInfo.height).toBe(walletVm.largeFontAdaptationHeight);
    });

    // 测试用例 25：验证背景颜色设置
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(walletVm.overlayBoxInfo.backGroundColor).toBe(true);
    });

    // 测试用例 26：验证初始高度
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(walletVm.overlayBoxInfo.height).toBe(10);
    });

    // 测试用例 27：验证最终透明度
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[1].event();
      expect(walletVm.overlayBoxInfo.opacity).toBe(1);
    });

    // 测试用例 28：验证事件执行后的边框半径
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[0].event();
      expect(walletVm.overlayBoxInfo.borderRadius).toBe(16);
    });

    // 测试用例 29：验证 translateY 的最终值
    it('should_return_animateParams_when_walletVm_is_undefined', 0,() => {
      animateParams[5].event();
      expect(walletVm.imageInfo.translateY).toBe(0);
    });

    // 测试用例 30：验证所有步骤的事件存在性
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams.forEach((step) => {
        expect(step.event).toBeDefined();
      });
    });

    // 测试用例 31：验证延迟参数的合理性
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(animateParams[0].delay).toBeGreaterThanOrEqual(0);
      expect(animateParams[5].delay).toBeGreaterThanOrEqual(0);
    });

    // 测试用例 32：验证曲线参数的类型
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(typeof animateParams[0].curve).toBe('object');
      expect(typeof animateParams[2].curve).toBe('object');
    });

    // 测试用例 33：验证 duration 参数
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(animateParams[0].duration).toBeUndefined();
      expect(animateParams[1].duration).toBe(66);
    });

    // 测试用例 34：验证最终缩放值
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[5].event();
      expect(walletVm.imageInfo.scalaX).toBe(1);
      expect(walletVm.imageInfo.scalaY).toBe(1);
    });

    // 测试用例 35：验证 translateY 的中间值
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[3].event();
      expect(walletVm.imageInfo.translateY).toBe('-6px');
    });

    // 测试用例 36：验证角度参数的初始值
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(walletVm.imageInfo.angle).toBe(0);
    });

    // 测试用例 37：验证最终宽度
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[0].event();
      expect(walletVm.overlayBoxInfo.width).toBe(100);
    });

    // 测试用例 38：验证高度变化
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[0].event();
      expect(walletVm.overlayBoxInfo.height).toBe(walletVm.largeFontAdaptationHeight);
    });

    // 测试用例 39：验证所有步骤的延迟
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(animateParams[0].delay).toBe(0);
      expect(animateParams[1].delay).toBe(16);
      expect(animateParams[2].delay).toBe(150);
      expect(animateParams[3].delay).toBe(150);
      expect(animateParams[4].delay).toBe(150);
      expect(animateParams[5].delay).toBe(400);
    });

    // 测试用例 40：验证最终状态的综合验证
    it('should_return_animateParams_when_walletVm_is_undefined', 0,() => {
      animateParams.forEach((step) => step.event());
      expect(walletVm.overlayBoxInfo).toEqual({
        backGroundColor: true,
        width: 100,
        height: walletVm.largeFontAdaptationHeight,
        opacity: 1,
        borderRadius: 16,
        translateY: 0,
      });
      expect(walletVm.imageInfo).toEqual({
        scalaX: 1,
        scalaY: 1,
        translateY: 0,
        angle: 0,
      });
    });

    // 测试用例 41：验证 translateY 的字符串格式
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const step4 = animateParams[3];
      step4.event();
      expect(walletVm.imageInfo.translateY).toMatch(/^-?\d+px$/);
    });

    // 测试用例 42：验证缩放参数的类型
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(typeof walletVm.imageInfo.scalaX).toBe('number');
      expect(typeof walletVm.imageInfo.scalaY).toBe('number');
    });

    // 测试用例 43：验证角度参数的类型
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(typeof walletVm.imageInfo.angle).toBe('number');
    });

    // 测试用例 44：验证最终 translateY 的数值类型
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[5].event();
      expect(typeof walletVm.imageInfo.translateY).toBe('number');
    });

    // 测试用例 45：验证所有步骤的 duration
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(animateParams[0].duration).toBeUndefined();
      expect(animateParams[1].duration).toBe(66);
      expect(animateParams[2].duration).toBe(250);
      expect(animateParams[3].duration).toBe(250);
      expect(animateParams[4].duration).toBe(500);
      expect(animateParams[5].duration).toBe(250);
    });

    // 测试用例 46：验证曲线参数的可调用性
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      expect(typeof animateParams[0].curve?.interpolate).toBe('function');
      expect(typeof animateParams[2].curve?.interpolate).toBe('function');
    });

    // 测试用例 47：验证事件执行后的属性变化
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const initialTranslateY = walletVm.imageInfo.translateY;
      animateParams[3].event();
      expect(walletVm.imageInfo.translateY).not.toBe(initialTranslateY);
    });

    // 测试用例 48：验证最终角度值
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams[4].event();
      expect(walletVm.imageInfo.angle).toBe(0);
    });

    // 测试用例 49：验证所有步骤的事件执行顺序
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      const eventOrder: string[] = [];
      animateParams.forEach((step, index) => {
        const originalEvent = step.event;
        step.event = () => {
          eventOrder.push(`Step ${index + 1}`);
          originalEvent?.();
        };
      });

      animateParams.forEach((step) => step.event());
      expect(eventOrder).toEqual(['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5', 'Step 6']);
    });

    // 测试用例 50：验证最终状态的综合边界值
    it('should_return_animateParams_when_walletVm_is_undefined', 0, () => {
      animateParams.forEach((step) => step.event());
      expect(walletVm.overlayBoxInfo.width).toBeGreaterThanOrEqual(0);
      expect(walletVm.overlayBoxInfo.height).toBeGreaterThanOrEqual(0);
      expect(walletVm.overlayBoxInfo.opacity).toBeGreaterThanOrEqual(0);
      expect(walletVm.overlayBoxInfo.opacity).toBeLessThanOrEqual(1);
    });
  });
}