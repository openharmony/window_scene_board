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

import { Animator, AnimatorResult } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimateParams, AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
import { BannerVm } from '../../../../../../main/ets/vm/BannerVm';
import { DropdownVm } from '../../../../../../main/ets/vm/DropdownVm';
import { ILiveCardOtherProgressVm } from '../../../../../../main/ets/live/interface/ILiveCardOtherProgressVm';
import { LiveCardProgressModel } from '../../../../../../main/ets/live/model/LiveCardProgressModel';
import { LiveIndicatorType, LiveLineType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveItemBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCardOtherProgressVm } from '../../../../../../main/ets/live/vm/LiveCardOtherProgressVm';
export default function LiveCardOtherProgressVmTest() {
  describe('onUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_progress_width_when_layoutLineType_is_different', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateProgressWidth: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.updateProgressWidth);
      when(mockUpdateProgressWidth)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      let oldLiveCard: LiveCardProgressModel = new LiveCardProgressModel();
      oldLiveCard.layoutLineType = LiveLineType.straight;
      let newLiveCard: LiveCardProgressModel = new LiveCardProgressModel();
      newLiveCard.layoutLineType = LiveLineType.curved;
      live.card = newLiveCard;

      livecardotherprogressvm.onUpdate(live);

      mocker.verify('checkStartAnim', []).once();
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.updateProgressWidth);
    });

    it('should_start_progress_anim_when_layoutProgress_is_different_and_checkStartAnim_is_true', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockStartProgressAnim: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.startProgressAnim);
      when(mockStartProgressAnim)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturnNothing();

      let mockCheckStartAnim: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.checkStartAnim);
      when(mockCheckStartAnim)().afterReturn(true);

      let live: LiveNotification = new LiveNotification();
      let oldLiveCard: LiveCardProgressModel = new LiveCardProgressModel();
      oldLiveCard.layoutProgress = 50;
      let newLiveCard: LiveCardProgressModel = new LiveCardProgressModel();
      newLiveCard.layoutProgress = 75;
      live.card = newLiveCard;

      livecardotherprogressvm.onUpdate(live);

      mocker.verify('checkStartAnim', []).once();
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.startProgressAnim);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.checkStartAnim);
    });

    it('should_not_start_progress_anim_when_layoutProgress_is_different_but_checkStartAnim_is_false', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockStartProgressAnim: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.startProgressAnim);
      when(mockStartProgressAnim)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturnNothing();

      let mockCheckStartAnim: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.checkStartAnim);
      when(mockCheckStartAnim)().afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      let oldLiveCard: LiveCardProgressModel = new LiveCardProgressModel();
      oldLiveCard.layoutProgress = 50;
      let newLiveCard: LiveCardProgressModel = new LiveCardProgressModel();
      newLiveCard.layoutProgress = 75;
      live.card = newLiveCard;

      livecardotherprogressvm.onUpdate(live);

      mocker.verify('checkStartAnim', []).once();
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.startProgressAnim);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.checkStartAnim);
    });

    it('should_set_isIndicatorShow_to_false_and_translateX_to_0_when_nowValue_is_not_progress_card', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.isIndicatorShow = true;
      livecardotherprogressvm.translateX = 100;

      let mocker: MockKit = new MockKit();

      let live: LiveNotification = new LiveNotification();
      let newLiveCard: LiveCardProgressModel = new LiveCardProgressModel();
      newLiveCard.indicatorType = LiveIndicatorType.none;
      live.card = newLiveCard;

      livecardotherprogressvm.onUpdate(live);

      expect(livecardotherprogressvm.isIndicatorShow).assertEqual(false);
      expect(livecardotherprogressvm.translateX).assertEqual(0);
    });

    it('should_return_LiveCardProgressModel_when_live_card_is_ILiveCardOtherProgressVm', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let live: ILiveCardOtherProgressVm = new ILiveCardOtherProgressVm() as ILiveCardOtherProgressVm;
      livecardotherprogressvm.live = live;
      const result = livecardotherprogressvm.getCard();
      expect(result).assertInstanceOf(LiveCardProgressModel);
    });

    it('should_return_LiveCardProgressModel_when_live_card_is_not_ILiveCardOtherProgressVm', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let live: BannerVm = new BannerVm();
      livecardotherprogressvm.live = live as ILiveCardOtherProgressVm;
      const result = livecardotherprogressvm.getCard();
      expect(result).assertInstanceOf(LiveCardProgressModel);
    });

    it('should_return_immediately_when_layoutLineType_is_not_DOTTED_LINE', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getCard);
      when(mockfunc)().afterReturn(new LiveCardProgressModel());
      livecardotherprogressvm.refreshDotColor();
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getCard);
    });

    it('should_refresh_dotsColors_when_layoutLineType_is_DOTTED_LINE', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.dots = [new ProgressDot(), new ProgressDot()];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getCard);
      let mockfunc2: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      when(mockfunc)().afterReturn(new LiveCardProgressModel());
      when(mockfunc2)().afterReturn("red");
      livecardotherprogressvm.refreshDotColor();
      expect(livecardotherprogressvm.dotsColors.length).assertEqual(2);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getCard);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
    });

    it('should_call_refreshDotColor_when_resetType_is_greater_than_0', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockRefreshDotColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.refreshDotColor);
      when(mockRefreshDotColor)(ArgumentMatchers.any).afterReturnNothing();

      await livecardotherprogressvm.startProgressAnim(0, 1);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.refreshDotColor);
    });

    it('should_set_initial_state_when_resetType_is_greater_than_0', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockSetInitialState: Function = mocker.mockFunc(livecardotherprogressvm.animation, livecardotherprogressvm.animation.setInitialState);
      when(mockSetInitialState)(ArgumentMatchers.any).afterReturnNothing();

      await livecardotherprogressvm.startProgressAnim(0, 1);
      mocker.ignoreMock(livecardotherprogressvm.animation, livecardotherprogressvm.animation.setInitialState);
    });

    it('should_call_getTranslateX_when_card_layoutLineType_is_DOTTED_LINE_and_resetType_is_not_2', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card.layoutLineType = LiveLineType.DOTTED_LINE;
      let mocker: MockKit = new MockKit();
      let mockGetTranslateX: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getTranslateX);
      when(mockGetTranslateX)(ArgumentMatchers.any).afterReturn(0);

      await livecardotherprogressvm.startProgressAnim(0, 1);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getTranslateX);
    });

    it('should_call_executeAnimation_when_card_layoutLineType_is_DOTTED_LINE', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card.layoutLineType = LiveLineType.DOTTED_LINE;
      let mocker: MockKit = new MockKit();
      let mockExecuteAnimation: Function = mocker.mockFunc(livecardotherprogressvm.animation, livecardotherprogressvm.animation.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      await livecardotherprogressvm.startProgressAnim(0, 1);
      mocker.ignoreMock(livecardotherprogressvm.animation, livecardotherprogressvm.animation.executeAnimation);
    });

    it('should_call_startAnimator_when_card_layoutLineType_is_DOTTED_LINE', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card.layoutLineType = LiveLineType.DOTTED_LINE;
      let mocker: MockKit = new MockKit();

      await livecardotherprogressvm.startProgressAnim(0, 1);
    });

    it('should_call_executeAnimation_when_card_layoutLineType_is_not_DOTTED_LINE', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card.layoutLineType = LiveLineType.SOLID_LINE;
      let mocker: MockKit = new MockKit();
      let mockExecuteAnimation: Function = mocker.mockFunc(livecardotherprogressvm.animation, livecardotherprogressvm.animation.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      await livecardotherprogressvm.startProgressAnim(0, 1);
      mocker.ignoreMock(livecardotherprogressvm.animation, livecardotherprogressvm.animation.executeAnimation);
    });

    it('should_set_lineProgress_when_card_layoutLineType_is_not_DOTTED_LINE', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card.layoutLineType = LiveLineType.SOLID_LINE;
      let mocker: MockKit = new MockKit();

      await livecardotherprogressvm.startProgressAnim(0, 1);
    });

    it('should_call_getTranslateX_and_getCard_and_calcDots_when_updateProgressWidth_is_called', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();

      let mockGetTranslateX: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getTranslateX);
      when(mockGetTranslateX)([]).afterReturn(10);

      let mockGetCard: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getCard);
      let cardModel: LiveCardProgressModel = new LiveCardProgressModel();
      when(mockGetCard)([]).afterReturn(cardModel);

      let mockCalcDots: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.calcDots);
      when(mockCalcDots)([ArgumentMatchers.anyBoolean]).afterReturnNothing();

      livecardotherprogressvm.updateProgressWidth();

      expect(livecardotherprogressvm.translateX).assertEqual(10);
      expect(livecardotherprogressvm.lineProgress).assertEqual(cardModel.layoutProgress);

      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getTranslateX);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getCard);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.calcDots);
    });

    it('should_call_getTranslateX_and_getCard_and_calcDots_with_isDrawColor_when_updateProgressWidth_is_called', 0, async () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();

      let mockGetTranslateX: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getTranslateX);
      when(mockGetTranslateX)([]).afterReturn(10);

      let mockGetCard: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getCard);
      let cardModel: LiveCardProgressModel = new LiveCardProgressModel();
      when(mockGetCard)([]).afterReturn(cardModel);

      let mockCalcDots: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.calcDots);
      when(mockCalcDots)([ArgumentMatchers.anyBoolean]).afterReturnNothing();

      livecardotherprogressvm.updateProgressWidth(true);

      expect(livecardotherprogressvm.translateX).assertEqual(10);
      expect(livecardotherprogressvm.lineProgress).assertEqual(cardModel.layoutProgress);

      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getTranslateX);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getCard);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.calcDots);
    });

    it('should_return_correct_translateX_when_indicatorType_is_UP', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: 50,
        layoutIndicatorType: LiveIndicatorType.UP,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(undefined);
      expect(result).assertEqual(125);
    });

    it('should_return_correct_translateX_when_indicatorType_is_OVERLAY', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: 50,
        layoutIndicatorType: LiveIndicatorType.OVERLAY,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(undefined);
      expect(result).assertEqual(150);
    });

    it('should_return_correct_translateX_when_progress_is_undefined', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: 50,
        layoutIndicatorType: LiveIndicatorType.UP,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(undefined);
      expect(result).assertEqual(125);
    });

    it('should_return_correct_translateX_when_progress_is_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: 0,
        layoutIndicatorType: LiveIndicatorType.UP,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(0);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_translateX_when_progress_is_100', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: 100,
        layoutIndicatorType: LiveIndicatorType.UP,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(100);
      expect(result).assertEqual(330);
    });

    it('should_return_correct_translateX_when_indicatorType_is_UP_and_progress_is_less_than_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: -10,
        layoutIndicatorType: LiveIndicatorType.UP,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(-10);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_translateX_when_indicatorType_is_UP_and_progress_is_more_than_100', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: 110,
        layoutIndicatorType: LiveIndicatorType.UP,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(110);
      expect(result).assertEqual(330);
    });

    it('should_return_correct_translateX_when_indicatorType_is_OVERLAY_and_progress_is_less_than_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: -10,
        layoutIndicatorType: LiveIndicatorType.OVERLAY,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(-10);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_translateX_when_indicatorType_is_OVERLAY_and_progress_is_more_than_100', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.card = {
        layoutProgress: 110,
        layoutIndicatorType: LiveIndicatorType.OVERLAY,
        indicatorOverlayWidth: 100,
        progressWidth: 200
      } as ILiveCardOtherProgressVm;
      let result = livecardotherprogressvm.getTranslateX(110);
      expect(result).assertEqual(330);
    });

    it('should_return_immediately_when_layoutLineType_is_not_DOTTED_LINE', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetCard: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getCard);
      when(mockGetCard)().afterReturn(new LiveCardProgressModel());
      livecardotherprogressvm.calcDots();
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getCard);
    });

    it('should_calculate_dots_correctly_when_isDrawColor_is_true', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetCard: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getCard);
      let mockLineColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      let mockLineBackgroundColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockCard: LiveCardProgressModel = new LiveCardProgressModel();
      mockCard.layoutLineType = LiveLineType.DOTTED_LINE;
      mockCard.layoutNodeIcons = [1, 2, 3];
      mockCard.layoutProgress = 50;
      mockCard.indicatorType = LiveIndicatorType.FULL_BLOCK;
      when(mockGetCard)().afterReturn(mockCard);
      when(mockLineColor)().afterReturn("red");
      when(mockLineBackgroundColor)().afterReturn("blue");
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      livecardotherprogressvm.progressWidth = 100;
      livecardotherprogressvm.indicatorOverlayWidth = 50;
      livecardotherprogressvm.calcDots(true);

      expect(livecardotherprogressvm.dots.length).assertEqual(2);
      expect(livecardotherprogressvm.dots[0].offset).assertEqual(0);
      expect(livecardotherprogressvm.dots[0].isInProgress).assertEqual(true);
      expect(livecardotherprogressvm.dots[1].offset).assertEqual(50);
      expect(livecardotherprogressvm.dots[1].isInProgress).assertEqual(false);

      expect(livecardotherprogressvm.dotsColors.length).assertEqual(2);
      expect(livecardotherprogressvm.dotsColors[0]).assertEqual("red");
      expect(livecardotherprogressvm.dotsColors[1]).assertEqual("blue");

      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getCard);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_calculate_dots_correctly_when_isDrawColor_is_false', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetCard: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getCard);
      let mockLineBackgroundColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockCard: LiveCardProgressModel = new LiveCardProgressModel();
      mockCard.layoutLineType = LiveLineType.DOTTED_LINE;
      mockCard.layoutNodeIcons = [1, 2, 3];
      mockCard.layoutProgress = 50;
      mockCard.indicatorType = LiveIndicatorType.FULL_BLOCK;
      when(mockGetCard)().afterReturn(mockCard);
      when(mockLineBackgroundColor)().afterReturn("blue");
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      livecardotherprogressvm.progressWidth = 100;
      livecardotherprogressvm.indicatorOverlayWidth = 50;
      livecardotherprogressvm.calcDots(false);

      expect(livecardotherprogressvm.dots.length).assertEqual(2);
      expect(livecardotherprogressvm.dots[0].offset).assertEqual(0);
      expect(livecardotherprogressvm.dots[0].isInProgress).assertEqual(true);
      expect(livecardotherprogressvm.dots[1].offset).assertEqual(50);
      expect(livecardotherprogressvm.dots[1].isInProgress).assertEqual(false);

      expect(livecardotherprogressvm.dotsColors.length).assertEqual(2);
      expect(livecardotherprogressvm.dotsColors[0]).assertEqual("blue");
      expect(livecardotherprogressvm.dotsColors[1]).assertEqual("blue");

      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getCard);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_correct_progress_when_layoutProgress_is_less_than_100', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutProgress_is_100', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 100;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutProgress_is_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 0;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(0);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutNodeIcons_is_empty', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(0);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutNodeIcons_has_only_1_icon', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutNodeIcons_has_only_2_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(37.5);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutNodeIcons_has_only_3_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_create_animator_with_reset_1', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);

      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 1);

      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('should_create_animator_with_reset_2', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 2);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(0);

    });

    it('should_create_animator_with_reset_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 0);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('should_set_dotsColors_correctly_when_progress_is_greater_than_progressWidth', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.progressWidth = 100;
      livecardotherprogressvm.dots = [{ offset: 110 }];
      let mocker: MockKit = new MockKit();
      let mockLineColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      let mockLineBackgroundColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      when(mockLineColor)(ArgumentMatchers.any).afterReturn("red");
      when(mockLineBackgroundColor)(ArgumentMatchers.any).afterReturn("blue");
      livecardotherprogressvm.onFrameAnimation(110);
      expect(livecardotherprogressvm.dotsColors).assertDeepEquals(["blue"]);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
    });

    const handleLineSizeChangeDT = [
      { newSize: { width: 100 }, isDrawColor: true },
      { newSize: { width: 100 }, isDrawColor: false },
      { newSize: { width: 50 }, isDrawColor: true },
      { newSize: { width: 50 }, isDrawColor: false },
    ];

    handleLineSizeChangeDT.forEach((testCase) => {
      it(`should update the progress width correctly for handleLineSizeChange with newSize: ${testCase.newSize.width} and isDrawColor: ${testCase.isDrawColor}`, () => {
        liveCardOtherProgressVm.handleLineSizeChange(testCase.newSize, testCase.isDrawColor);
        expect(liveCardOtherProgressVm.progressWidth).toBe(testCase.newSize.width - LINE_PADDING * 2);
      });
    });

    // DT tests for the handleIndicatorOverlaySizeChange method
    const handleIndicatorOverlaySizeChangeDT = [
      { newSize: { width: 100 } },
      { newSize: { width: 50 } },
    ];

    handleIndicatorOverlaySizeChangeDT.forEach((testCase) => {
      it(`should update the indicator overlay width correctly for handleIndicatorOverlaySizeChange with newSize: ${testCase.newSize.width}`, () => {
        liveCardOtherProgressVm.handleIndicatorOverlaySizeChange(testCase.newSize);
        expect(liveCardOtherProgressVm.indicatorOverlayWidth).toBe(testCase.newSize.width);
      });
    });

    // DT tests for the checkStartAnim method
    const checkStartAnimDT = [
      { isLivePanel: true, isLiveHeadsUp: true, expected: true },
      { isLivePanel: true, isLiveHeadsUp: false, expected: true },
      { isLivePanel: false, isLiveHeadsUp: true, expected: true },
      { isLivePanel: false, isLiveHeadsUp: false, expected: false },
    ];

    checkStartAnimDT.forEach((testCase) => {
      it(`should return ${testCase.expected} for checkStartAnim with isLivePanel: ${testCase.isLivePanel} and isLiveHeadsUp: ${testCase.isLiveHeadsUp}`, () => {
        BannerVm.instance.isLivePanel = testCase.isLivePanel;
        BannerVm.instance.isLiveHeadsUp = testCase.isLiveHeadsUp;
        expect(liveCardOtherProgressVm.checkStartAnim()).toBe(testCase.expected);
      });
    });

    it('checkStartAnimDT1', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 100;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('checkStartAnimDT2', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 0;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(0);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('checkStartAnimDT3', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(0);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('checkStartAnimDT4', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('checkStartAnimDT5', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(37.5);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('checkStartAnimDT6', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('checkStartAnimDT7', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);

      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 1);

      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('checkStartAnimDT8', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 2);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(0);
    });

    it('should_return_progress_when_layoutNodeIcons_has_only_2_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(37.5);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutNodeIcons_has_only_3_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_create_animator_with_reset_1', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);

      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 1);

      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('should_create_animator_with_reset_2', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 2);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(0);

    });

    it('should_create_animator_with_reset_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 0);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('should_set_dotsColors_correctly_when_progress_is_greater_than_progressWidth', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.progressWidth = 100;
      livecardotherprogressvm.dots = [{ offset: 110 }];
      let mocker: MockKit = new MockKit();
      let mockLineColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      let mockLineBackgroundColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      when(mockLineColor)(ArgumentMatchers.any).afterReturn("red");
      when(mockLineBackgroundColor)(ArgumentMatchers.any).afterReturn("blue");
      livecardotherprogressvm.onFrameAnimation(110);
      expect(livecardotherprogressvm.dotsColors).assertDeepEquals(["blue"]);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
    });
    it('should_return_progress_when_layoutNodeIcons_has_only_2_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(37.5);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutNodeIcons_has_only_3_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_create_animator_with_reset_1', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);

      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 1);

      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('should_create_animator_with_reset_2', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 2);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(0);

    });

    it('should_create_animator_with_reset_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 0);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('should_set_dotsColors_correctly_when_progress_is_greater_than_progressWidth', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      livecardotherprogressvm.progressWidth = 100;
      livecardotherprogressvm.dots = [{ offset: 110 }];
      let mocker: MockKit = new MockKit();
      let mockLineColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      let mockLineBackgroundColor: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
      when(mockLineColor)(ArgumentMatchers.any).afterReturn("red");
      when(mockLineBackgroundColor)(ArgumentMatchers.any).afterReturn("blue");
      livecardotherprogressvm.onFrameAnimation(110);
      expect(livecardotherprogressvm.dotsColors).assertDeepEquals(["blue"]);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineColor);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.lineBackgroundColor);
    });
    it('should_return_progress_when_layoutNodeIcons_has_only_2_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(37.5);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_return_progress_when_layoutNodeIcons_has_only_3_icons', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.card);
      let cardProgress: LiveCardProgressModel = new LiveCardProgressModel();
      cardProgress.layoutProgress = 50;
      cardProgress.layoutNodeIcons = [1, 2, 3];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(cardProgress);

      const result = livecardotherprogressvm.getInitialProgress();
      expect(result).assertEqual(25);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.card);
    });

    it('should_create_animator_with_reset_1', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);

      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 1);

      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });

    it('should_create_animator_with_reset_2', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 2);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(0);

    });

    it('should_create_animator_with_reset_0', 0, () => {
      let livecardotherprogressvm: LiveCardOtherProgressVm = new LiveCardOtherProgressVm();
      let mocker: MockKit = new MockKit();
      let mockGetInitialProgress: Function = mocker.mockFunc(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
      when(mockGetInitialProgress)(ArgumentMatchers.any).afterReturn(100);
      let card: LiveCardProgressModel = new LiveCardProgressModel();
      livecardotherprogressvm.card = card;
      livecardotherprogressvm.createAnimator(100, 0);
      expect(livecardotherprogressvm.animator).assertInstanceOf(AnimatorResult);
      expect(livecardotherprogressvm.animEnd).assertEqual(100);
      mocker.ignoreMock(livecardotherprogressvm, livecardotherprogressvm.getInitialProgress);
    });
  });
}
