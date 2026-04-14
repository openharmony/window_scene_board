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

import { LiveItemBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { ILiveCardListItemVm } from '../../../../../../main/ets/live/interface/ILiveCardListItemVm';
import { AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCardAnimation } from '../../../../../../main/ets/live/animation/LiveCardAnimation';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { ClickNotificationMaintenance } from '../../../../../../main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../../../main/ets/maintenance/StatisticsConstants';
import { SystemUIUseScene } from '../../../../../../main/ets/constants/SystemuiConstants';
import { AppLifeCycleManager } from '../../../../../../main/ets/manager/AppLifeCycleManager';
import { bannerMgr } from '../../../../../../main/ets/banner/phone/BannerManager';
import { NotificationUtil } from '../../../../../../main/ets/utils/NotificationUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCardListItemVm } from '../../../../../../main/ets/live/vm/LiveCardListItemVm';
export default function LiveCardListItemVmTest() {
  describe('cardGradientColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_rgba_when_live_is_not_small_card', 0, async () => {
      let livecardlistitemvm: ILiveCardListItemVm = new LiveCardListItemVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveItemBaseVm.LiveItemBaseVmInjector = new LiveItemBaseVm.LiveItemBaseVmInjector();
      let live: LiveNotification = new LiveNotification();
      let liveVmInjector: LiveItemBaseVm.LiveItemBaseVmInjector = new LiveItemBaseVm.LiveItemBaseVmInjector();
      let liveCardModel: LiveCardModel = new LiveCardModel();
      let liveCardModelIsSmallCard: Function = mocker.mockFunc(liveCardModel, liveCardModel.isSmallCard);
      when(liveCardModelIsSmallCard)().afterReturn(false);
      let liveCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let getCapsuleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
      when(getCapsuleVm)(ArgumentMatchers.any).afterReturn(liveCapsuleVm);
      let capsuleVmContentColor: string = 'red';
      let convertColorToRgba: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.convertColorToRgba);
      when(convertColorToRgba)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber)
        .afterReturn('rgba(0, 0, 0, 0.25)');
      livecardlistitemvm.vmInjector = vmInjector;
      livecardlistitemvm.live = live;
      livecardlistitemvm.liveVmInjector = liveVmInjector;
      livecardlistitemvm.live.card = liveCardModel;
      livecardlistitemvm.live.capsule = liveCapsuleVm;
      livecardlistitemvm.live.card.contentColor = capsuleVmContentColor;
      const result = livecardlistitemvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0.25)');
      mocker.ignoreMock(liveCardModel, liveCardModel.isSmallCard);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.convertColorToRgba);
    });

    it('should_return_rgba_0_0_0_0_when_live_is_small_card', 0, async () => {
      let livecardlistitemvm: ILiveCardListItemVm = new LiveCardListItemVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveItemBaseVm.LiveItemBaseVmInjector = new LiveItemBaseVm.LiveItemBaseVmInjector();
      let live: LiveNotification = new LiveNotification();
      let liveVmInjector: LiveItemBaseVm.LiveItemBaseVmInjector = new LiveItemBaseVm.LiveItemBaseVmInjector();
      let liveCardModel: LiveCardModel = new LiveCardModel();
      let liveCardModelIsSmallCard: Function = mocker.mockFunc(liveCardModel, liveCardModel.isSmallCard);
      when(liveCardModelIsSmallCard)().afterReturn(true);
      livecardlistitemvm.vmInjector = vmInjector;
      livecardlistitemvm.live = live;
      livecardlistitemvm.liveVmInjector = liveVmInjector;
      livecardlistitemvm.live.card = liveCardModel;
      const result = livecardlistitemvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0)');
      mocker.ignoreMock(liveCardModel, liveCardModel.isSmallCard);
    });
  });

  describe('updateSwipeOffset_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_containerOffsetX_equals_offsetLeft', 0, async () => {
      let livecardlistitemvm: LiveCardListItemVm = new LiveCardListItemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardlistitemvm, livecardlistitemvm.updateSwipeOffset);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(null);
      await livecardlistitemvm.updateSwipeOffset(0, true);
      mocker.ignoreMock(livecardlistitemvm, livecardlistitemvm.updateSwipeOffset);
    });

    it('should_execute_animation_when_animation_is_true', 0, async () => {
      let livecardlistitemvm: LiveCardListItemVm = new LiveCardListItemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardlistitemvm, livecardlistitemvm.updateSwipeOffset);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(null);
      let mockfunc2: Function = mocker.mockFunc(livecardlistitemvm.animation, livecardlistitemvm.animation.executeAnimation);
      when(mockfunc2)(ArgumentMatchers.anyObj, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecardlistitemvm.updateSwipeOffset(100, true);
      mocker.ignoreMock(livecardlistitemvm, livecardlistitemvm.updateSwipeOffset);
      mocker.ignoreMock(livecardlistitemvm.animation, livecardlistitemvm.animation.executeAnimation);
    });

    it('should_execute_animation_false_when_animation_is_false', 0, async () => {
      let livecardlistitemvm: LiveCardListItemVm = new LiveCardListItemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardlistitemvm, livecardlistitemvm.updateSwipeOffset);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(null);
      let mockfunc2: Function = mocker.mockFunc(livecardlistitemvm.animation, livecardlistitemvm.animation.executeAnimation);
      when(mockfunc2)(ArgumentMatchers.anyObj, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecardlistitemvm.updateSwipeOffset(100, false);
      mocker.ignoreMock(livecardlistitemvm, livecardlistitemvm.updateSwipeOffset);
      mocker.ignoreMock(livecardlistitemvm.animation, livecardlistitemvm.animation.executeAnimation);
    });
  });

  describe('doRemoveAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_execute_animation_when_live_is_not_null', 0, async () => {
      let livecardlistitemvm: ILiveCardListItemVm = new LiveCardListItemVm();
      let mocker: MockKit = new MockKit();
      let mockGetCardListVm: Function = mocker.mockFunc(livecardlistitemvm.vmInjector, livecardlistitemvm.vmInjector.getCardListVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecardlistitemvm.animation, livecardlistitemvm.animation.executeAnimation);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetCardListVm)().afterReturn({ cardWidth: 100 });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livecardlistitemvm.doRemoveAnimation();

      expect(livecardlistitemvm.containerOffsetX).assertEqual(-100);
      expect(livecardlistitemvm.containerOpacity).assertEqual(0);

      mocker.ignoreMock(livecardlistitemvm.vmInjector, livecardlistitemvm.vmInjector.getCardListVm);
      mocker.ignoreMock(livecardlistitemvm.animation, livecardlistitemvm.animation.executeAnimation);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
}