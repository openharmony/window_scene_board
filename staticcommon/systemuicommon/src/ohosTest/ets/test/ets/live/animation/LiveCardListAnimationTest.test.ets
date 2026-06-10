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
import { AnimateParams, AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { LiveVmInjector } from '../../../../../../main/ets/live/LiveVmInjector';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemUICommonUtil } from '../../../../../../main/ets/utils/SystemUICommonUtil';
import { ILiveCardListItemVm } from '../../../../../../main/ets/live/interface/ILiveCardListItemVm';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import { ResourceVm } from '../../../../../../main/ets/vm/ResourceVm';
import { DeviceInfoVm } from '../../../../../../main/ets/vm/DeviceInfoVm';
import { display } from '@kit.ArkUI';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCardListAnimation } from '../../../../../../main/ets/live/animation/LiveCardListAnimation';
export default function LiveCardListAnimationTest() {
  describe('expandCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_getCardListVm_clearAnimations_startAnimation_when_expandCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      let mockClearAnimations: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockStartAnimation: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.startAnimation);

      when(mockGetCardListVm)([]).afterReturn({
        isListRebound: false
      });
      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecardlistanimation.expandCard();

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.startAnimation);
    });

    it('should_call_getCardListVm_clearAnimations_startAnimation_with_correct_params_when_expandCard_is_called', 0,
      async () => {
        let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
        let mocker: MockKit = new MockKit();

        let mockGetCardListVm: Function =
          mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
        let mockClearAnimations: Function =
          mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
        let mockStartAnimation: Function =
          mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.startAnimation);

        when(mockGetCardListVm)([]).afterReturn({
          isListRebound: false
        });
        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber])
          .afterReturn(Promise.resolve());

        await livecardlistanimation.expandCard();

        expect(mockStartAnimation).assertCalledWith("ExpandCard, count:1", 2000);

        mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
        mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
        mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.startAnimation);
      });

    it('should_call_getCardListVm_with_correct_params_when_expandCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      let mockClearAnimations: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockStartAnimation: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.startAnimation);

      when(mockGetCardListVm)([]).afterReturn({
        isListRebound: false
      });
      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecardlistanimation.expandCard();

      expect(mockGetCardListVm).assertCalledWith([]);

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.startAnimation);
    });

    it('should_call_clearAnimations_with_correct_params_when_expandCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      let mockClearAnimations: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockStartAnimation: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.startAnimation);

      when(mockGetCardListVm)([]).afterReturn({
        isListRebound: false
      });
      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecardlistanimation.expandCard();

      expect(mockClearAnimations).assertCalledWith();

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.startAnimation);
    });

    it('should_call_startAnimation_with_correct_params_when_expandCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      let mockClearAnimations: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockStartAnimation: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.startAnimation);

      when(mockGetCardListVm)([]).afterReturn({
        isListRebound: false
      });
      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecardlistanimation.expandCard();

      expect(mockStartAnimation).assertCalledWith("ExpandCard, count:1", 2000);

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.startAnimation);
    });

    it('should_call_getCardListVm_isListRebound_with_false_when_expandCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      let mockClearAnimations: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockStartAnimation: Function =
        mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.startAnimation);

      when(mockGetCardListVm)([]).afterReturn({
        isListRebound: false
      });
      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecardlistanimation.expandCard();

      expect(mockGetCardListVm).assertCalledWith([]);
      expect(mockGetCardListVm).assertCalledWith({
        isListRebound: false
      });

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.startAnimation);
    });

  });

  describe('getCollapseCardDuration_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_duration_when_cardRectList_is_not_empty', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cutoutVm: CutoutVm = new CutoutVm();
      cutoutVm.style = LiveStyle.CUTOUT_NONE;
      let resourceVm: ResourceVm = new ResourceVm();
      resourceVm.deviceInfo = new DeviceInfoVm();
      resourceVm.deviceInfo.deviceType = "phone";
      let animateParams: AnimateParams = new AnimateParams(true, 1000, 1000, curves.cubicBezierCurve(0.26, 0, 0.39, 0.95), 250, 17, 0, 0, 0, 25, 183, 250, 25, 250, 25, 17, 33);
      animateParams.duration = 250;
      animateParams.delay = 17;
      animateParams.curve = curves.cubicBezierCurve(0.26, 0, 0.39, 0.95);
      animateParams.onFinish = () => {
        console.log("animateParams onFinish");
      };
      cutoutVm.animateToParams = animateParams;
      livecardlistanimation.vmInjector.statusBarVm.liveCutoutVm = cutoutVm;
      livecardlistanimation.vmInjector.resourceVm = resourceVm;

      let cardRectList: RectResult[] = [{ width: 100, height: 100, position: { x: 0, y: 0 } }];
      livecardlistanimation.getCardRectList = () => {
        return cardRectList;
      };

      const result = livecardlistanimation.getCollapseCardDuration();
      expect(result).assertEqual(250 + 17 * cardRectList.length);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_correct_duration_when_cardRectList_is_not_empty1', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cutoutVm: CutoutVm = new CutoutVm();
      cutoutVm.style = LiveStyle.CUTOUT_NONE;
      let resourceVm: ResourceVm = new ResourceVm();
      resourceVm.deviceInfo = new DeviceInfoVm();
      resourceVm.deviceInfo.deviceType = "phone";
      let animateParams: AnimateParams = new AnimateParams(true, 1000, 1000, curves.cubicBezierCurve(0.26, 0, 0.39, 0.95), 250, 17, 0, 0, 0, 25, 183, 250, 25, 250, 25, 17, 33);
      animateParams.duration = 250;
      animateParams.delay = 17;
      animateParams.curve = curves.cubicBezierCurve(0.26, 0, 0.39, 0.95);
      animateParams.onFinish = () => {
        console.log("animateParams onFinish");
      };
      cutoutVm.animateToParams = animateParams;
      livecardlistanimation.vmInjector.statusBarVm.liveCutoutVm = cutoutVm;
      livecardlistanimation.vmInjector.resourceVm = resourceVm;

      let cardRectList: RectResult[] = [{ width: 100, height: 100, position: { x: 0, y: 0 } }];
      livecardlistanimation.getCardRectList = () => {
        return cardRectList;
      };

      const result = livecardlistanimation.getCollapseCardDuration();
      expect(result).assertEqual(250 + 17 * cardRectList.length);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_default_duration_when_cardRectList_is_empty', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cutoutVm: CutoutVm = new CutoutVm();
      cutoutVm.style = LiveStyle.CUTOUT_NONE;
      let resourceVm: ResourceVm = new ResourceVm();
      resourceVm.deviceInfo = new DeviceInfoVm();
      resourceVm.deviceInfo.deviceType = "phone";
      let animateParams: AnimateParams = new AnimateParams(true, 1000, 1000, curves.cubicBezierCurve(0.26, 0, 0.39, 0.95), 250, 17, 0, 0, 0, 25, 183, 250, 25, 250, 25, 17, 33);
      animateParams.duration = 250;
      animateParams.delay = 17;
      animateParams.curve = curves.cubicBezierCurve(0.26, 0, 0.39, 0.95);
      animateParams.onFinish = () => {
        console.log("animateParams onFinish");
      };
      cutoutVm.animateToParams = animateParams;
      livecardlistanimation.vmInjector.statusBarVm.liveCutoutVm = cutoutVm;
      livecardlistanimation.vmInjector.resourceVm = resourceVm;

      let cardRectList: RectResult[] = [];
      livecardlistanimation.getCardRectList = () => {
        return cardRectList;
      };

      const result = livecardlistanimation.getCollapseCardDuration();
      expect(result).assertEqual(250 + 17 * cardRectList.length);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_default_duration_when_cardRectList_is_empty1', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cutoutVm: CutoutVm = new CutoutVm();
      cutoutVm.style = LiveStyle.CUTOUT_NONE;
      let resourceVm: ResourceVm = new ResourceVm();
      resourceVm.deviceInfo = new DeviceInfoVm();
      resourceVm.deviceInfo.deviceType = "phone";
      let animateParams: AnimateParams = new AnimateParams(true, 1000, 1000, curves.cubicBezierCurve(0.26, 0, 0.39, 0.95), 250, 17, 0, 0, 0, 25, 183, 250, 25, 250, 25, 17, 33);
      animateParams.duration = 250;
      animateParams.delay = 17;
      animateParams.curve = curves.cubicBezierCurve(0.26, 0, 0.39, 0.95);
      animateParams.onFinish = () => {
        console.log("animateParams onFinish");
      };
      cutoutVm.animateToParams = animateParams;
      livecardlistanimation.vmInjector.statusBarVm.liveCutoutVm = cutoutVm;
      livecardlistanimation.vmInjector.resourceVm = resourceVm;

      let cardRectList: RectResult[] = [];
      livecardlistanimation.getCardRectList = () => {
        return cardRectList;
      };

      const result = livecardlistanimation.getCollapseCardDuration();
      expect(result).assertEqual(250 + 17 * cardRectList.length);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_default_duration_when_cardRectList_is_empty2', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cutoutVm: CutoutVm = new CutoutVm();
      cutoutVm.style = LiveStyle.CUTOUT_NONE;
      let resourceVm: ResourceVm = new ResourceVm();
      resourceVm.deviceInfo = new DeviceInfoVm();
      resourceVm.deviceInfo.deviceType = "phone";
      let animateParams: AnimateParams = new AnimateParams(true, 1000, 1000, curves.cubicBezierCurve(0.26, 0, 0.39, 0.95), 250, 17, 0, 0, 0, 25, 183, 250, 25, 250, 25, 17, 33);
      animateParams.duration = 250;
      animateParams.delay = 17;
      animateParams.curve = curves.cubicBezierCurve(0.26, 0, 0.39, 0.95);
      animateParams.onFinish = () => {
        console.log("animateParams onFinish");
      };
      cutoutVm.animateToParams = animateParams;
      livecardlistanimation.vmInjector.statusBarVm.liveCutoutVm = cutoutVm;
      livecardlistanimation.vmInjector.resourceVm = resourceVm;

      let cardRectList: RectResult[] = [];
      livecardlistanimation.getCardRectList = () => {
        return cardRectList;
      };

      const result = livecardlistanimation.getCollapseCardDuration();
      expect(result).assertEqual(250 + 17 * cardRectList.length);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_default_duration_when_cardRectList_is_empty3', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cutoutVm: CutoutVm = new CutoutVm();
      cutoutVm.style = LiveStyle.CUTOUT_NONE;
      let resourceVm: ResourceVm = new ResourceVm();
      resourceVm.deviceInfo = new DeviceInfoVm();
      resourceVm.deviceInfo.deviceType = "phone";
      let animateParams: AnimateParams = new AnimateParams(true, 1000, 1000, curves.cubicBezierCurve(0.26, 0, 0.39, 0.95), 250, 17, 0, 0, 0, 25, 183, 250, 25, 250, 25, 17, 33);
      animateParams.duration = 250;
      animateParams.delay = 17;
      animateParams.curve = curves.cubicBezierCurve(0.26, 0, 0.39, 0.95);
      animateParams.onFinish = () => {
        console.log("animateParams onFinish");
      };
      cutoutVm.animateToParams = animateParams;
      livecardlistanimation.vmInjector.statusBarVm.liveCutoutVm = cutoutVm;
      livecardlistanimation.vmInjector.resourceVm = resourceVm;

      let cardRectList: RectResult[] = [];
      livecardlistanimation.getCardRectList = () => {
        return cardRectList;
      };

      const result = livecardlistanimation.getCollapseCardDuration();
      expect(result).assertEqual(250 + 17 * cardRectList.length);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });

  describe('collapseCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_clearAnimations_and_startAnimation_when_collapseCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockClearAnimations: Function = mocker.mockFunc(livecardlistanimation, livecardlistanimation.clearAnimations);
      when(mockClearAnimations)(ArgumentMatchers.any).afterReturnNothing();

      let mockStartAnimation: Function = mocker.mockFunc(livecardlistanimation, livecardlistanimation.startAnimation);
      when(mockStartAnimation)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      when(mockGetCardListVm)(ArgumentMatchers.any).afterReturn({
        enableScroll: false
      });

      await livecardlistanimation.collapseCard();

      mocker.ignoreMock(livecardlistanimation, livecardlistanimation.clearAnimations);
      mocker.ignoreMock(livecardlistanimation, livecardlistanimation.startAnimation);
      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
    });

    it('should_call_getCardListVm_and_enableScroll_when_collapseCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      when(mockGetCardListVm)(ArgumentMatchers.any).afterReturn({
        enableScroll: false
      });

      await livecardlistanimation.collapseCard();

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
    });

    it('should_call_getCardListVm_and_enableScroll_when_collapseCard_is_called1', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      when(mockGetCardListVm)(ArgumentMatchers.any).afterReturn({
        enableScroll: false
      });

      await livecardlistanimation.collapseCard();

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
    });

    it('should_call_getCardListVm_and_enableScroll_when_collapseCard_is_called2', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function =
        mocker.mockFunc(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
      when(mockGetCardListVm)(ArgumentMatchers.any).afterReturn({
        enableScroll: false
      });

      await livecardlistanimation.collapseCard();

      mocker.ignoreMock(livecardlistanimation.vmInjector, livecardlistanimation.vmInjector.getCardListVm);
    });

    it('should_call_resetCard_when_collapseCard_is_called', 0, async () => {
      let livecardlistanimation: LiveCardListAnimation = new LiveCardListAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockResetCard: Function = mocker.mockFunc(livecardlistanimation, livecardlistanimation.resetCard);
      when(mockResetCard)([ArgumentMatchers.anyBoolean]).afterReturn(Promise.resolve());

      await livecardlistanimation.collapseCard();

      mocker.ignoreMock(livecardlistanimation, livecardlistanimation.resetCard);
    });
  });
}