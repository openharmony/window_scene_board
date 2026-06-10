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
import { LiveVmInjector } from '../../../../../../main/ets/live/LiveVmInjector';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { LiveSwitchVm } from '../../../../../../main/ets/live/vm/LiveSwitchVm';
import { bannerMgr } from '../../../../../../main/ets/banner/phone/BannerManager';
import { LiveCardListAnimation } from '../../../../../../main/ets/live/animation/LiveCardListAnimation';
import { ILiveSwitchVm } from '../../../../../../main/ets/live/interface/ILiveSwitchVm';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { CutoutVm } from '../../../../../../../newIndex';
import { ILiveCapsuleListVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleListVm';
import { NodeControllerManager } from '../../../../../../main/ets/framenode/NodeControllerManager';
import { NotificationDataManager } from '../../../../../../main/ets/manager/NotificationDataManager';

// 111

export default function LiveSwitchVmTest() {
  describe('showBanner_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })


    it('should_resolve_bannerAppearPromise_when_bannerAppearPromise_is_undefined', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      liveswitchvm.bannerAppearPromise = undefined;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      const result = await liveswitchvm.showBanner();
      expect(result).assertInstanceOf(CustomPromise);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_resolve_bannerAppearPromise_when_bannerAppearPromise_is_defined', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      liveswitchvm.bannerAppearPromise = new CustomPromise();
      const result = await liveswitchvm.showBanner();
      expect(result).assertInstanceOf(CustomPromise);
    });

    it('should_resolve_bannerAppearPromise_when_bannerAppearPromise_is_already_resolved', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      liveswitchvm.bannerAppearPromise = new CustomPromise();
      liveswitchvm.bannerAppearPromise.resolve();
      const result = await liveswitchvm.showBanner();
      expect(result).assertInstanceOf(CustomPromise);
    });

    it('should_log_hide_panel_and_release_panel_capsule_list_when_panel_is_not_banner_type', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockReleasePanelCapsuleList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
      when(mockReleasePanelCapsuleList)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockIsBannerPanelType: Function = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
      when(mockIsBannerPanelType)([ArgumentMatchers.any]).afterReturn(false);

      let mockReleasePanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
      when(mockReleasePanelLiveList)([ArgumentMatchers.any]).afterReturnNothing();

      liveswitchvm.hidePanel();
      mocker.verify('releasePanelLiveList', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
    });

    it('should_log_hide_panel_and_release_panel_live_list_when_panel_is_banner_type', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockReleasePanelCapsuleList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
      when(mockReleasePanelCapsuleList)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockIsBannerPanelType: Function = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
      when(mockIsBannerPanelType)([ArgumentMatchers.any]).afterReturn(true);

      let mockReleasePanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
      when(mockReleasePanelLiveList)([ArgumentMatchers.any]).afterReturnNothing();

      liveswitchvm.hidePanel();

      mocker.verify('releasePanelLiveList', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
    });

    it('should_log_hide_panel_and_release_panel_live_list_when_panel_is_not_banner_type_and_expand_card_timer_id_is_not_undefined',
      0, async () => {
        let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
        liveswitchvm.expandCardTimerId = 1;
        let mocker: MockKit = new MockKit();

        let mockReleasePanelCapsuleList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
        when(mockReleasePanelCapsuleList)(ArgumentMatchers.any).afterReturnNothing();

        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

        let mockIsBannerPanelType: Function = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
        when(mockIsBannerPanelType)([ArgumentMatchers.any]).afterReturn(false);

        let mockReleasePanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
        when(mockReleasePanelLiveList)([ArgumentMatchers.any]).afterReturnNothing();

        liveswitchvm.hidePanel();
        mocker.verify('releasePanelLiveList', [ArgumentMatchers.any]).once();
        mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
        mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
      });

    it('should_log_hide_panel_and_release_panel_capsule_list_when_panel_is_banner_type_and_expand_card_timer_id_is_undefined',
      0, async () => {
        let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
        liveswitchvm.expandCardTimerId = undefined;
        let mocker: MockKit = new MockKit();

        let mockReleasePanelCapsuleList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
        when(mockReleasePanelCapsuleList)(ArgumentMatchers.any).afterReturnNothing();

        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

        let mockIsBannerPanelType: Function = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
        when(mockIsBannerPanelType)([ArgumentMatchers.any]).afterReturn(true);

        let mockReleasePanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
        when(mockReleasePanelLiveList)([ArgumentMatchers.any]).afterReturnNothing();

        liveswitchvm.hidePanel();

        mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
        mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
      });

    it('should_return_duration_when_expanding_true_and_collapsing_false', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);

      liveswitchvm.isExpanding = true;
      liveswitchvm.isCollapsing = false;

      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_false_and_collapsing_true', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);

      liveswitchvm.isExpanding = false;
      liveswitchvm.isCollapsing = true;

      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_and_collapsing_are_false', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);

      liveswitchvm.isExpanding = false;
      liveswitchvm.isCollapsing = false;

      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

  });

  describe('onPanelSizeChange_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    onPanelSizeChangeTest1();
    onPanelSizeChangeTest2();
    onPanelSizeChangeTest3();
    onPanelSizeChangeTest4();
    onPanelSizeChangeTest5();
    onPanelSizeChangeTest6();
    onPanelSizeChangeTest7();
    onPanelSizeChangeTest8();
    onPanelSizeChangeTest9();
    onPanelSizeChangeTest10();
    onPanelSizeChangeTest11();
    onPanelSizeChangeTest12();
    onPanelSizeChangeTest13();
    onPanelSizeChangeTest14();
    onPanelSizeChangeTest15();
    onPanelSizeChangeTest16();
    onPanelSizeChangeTest17();
    onPanelSizeChangeTest18();
    onPanelSizeChangeTest19();
    onPanelSizeChangeTest20();
    onPanelSizeChangeTest21();
    onPanelSizeChangeTest22();
  });

  describe('showBanner_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    showBannerTest1();

    showBannerTest2();
  });

  describe('hidePanel_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    hidePanelTest1();

    hidePanelTest2();
  });

  describe('expandCapsuleToCard_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    expandCapsuleToCardTest1();
    expandCapsuleToCardTest2();
    expandCapsuleToCardTest3();
    expandCapsuleToCardTest4();
    expandCapsuleToCardTest5();
    expandCapsuleToCardTest6();
    expandCapsuleToCardTest7();
    expandCapsuleToCardTest8();
    expandCapsuleToCardTest9();
    expandCapsuleToCardTest10();
    expandCapsuleToCardTest11();
    expandCapsuleToCardTest12();
    expandCapsuleToCardTest13();
    expandCapsuleToCardTest14();
    expandCapsuleToCardTest15();
    expandCapsuleToCardTest16();
    expandCapsuleToCardTest17();
    expandCapsuleToCardTest18();
    expandCapsuleToCardTest19();
    expandCapsuleToCardTest20();
    expandCapsuleToCardTest21();
    expandCapsuleToCardTest22();
    expandCapsuleToCardTest23();
    expandCapsuleToCardTest24();
    expandCapsuleToCardTest25();
    expandCapsuleToCardTest26();
    expandCapsuleToCardTest27();
    expandCapsuleToCardTest28();
    expandCapsuleToCardTest29();
    expandCapsuleToCardTest30();
    expandCapsuleToCardTest31();
    expandCapsuleToCardTest32();
    expandCapsuleToCardTest33();
    expandCapsuleToCardTest34();
    expandCapsuleToCardTest35();
    expandCapsuleToCardTest36();
    expandCapsuleToCardTest37();
    expandCapsuleToCardTest38();
    expandCapsuleToCardTest39();
    expandCapsuleToCardTest40();
    expandCapsuleToCardTest41();
    expandCapsuleToCardTest42();
    expandCapsuleToCardTest43();
    expandCapsuleToCardTest44();
  });

  describe('getCollapseCardDuration_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    it('should_return_equal_new_card_list_return', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

      let cardListAnimation = new LiveCardListAnimation(liveVmInjector);

      let duration: number = liveSwitchVm.getCollapseCardDuration();
      expect(duration).assertEqual(cardListAnimation.getCollapseCardDuration());
    });
  });

  describe('showBanner_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_when_bannerAppearPromise_is_undefined', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined_and_banner_request_succeeds', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterReturn(true);

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined_and_banner_request_fails', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterReturn(false);

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_resolve_when_bannerAppearPromise_is_undefined', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined_and_banner_request_succeeds', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterReturn(true);

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined_and_banner_request_fails', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterReturn(false);

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_reject_when_bannerAppearPromise_is_defined_and_banner_request_throws_error', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterThrow('Request failed');

      let result = liveswitchvm.showBanner();
      await expect(result).assertPromiseIsRejectedWith('Request failed');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined_and_banner_request_returns_undefined', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterReturn(undefined);

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined_and_banner_request_returns_null', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterReturn(null);

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });

    it('should_resolve_when_bannerAppearPromise_is_defined_and_banner_request_returns_number', 0, async () => {
      let liveswitchvm: LiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      liveswitchvm.bannerAppearPromise = new CustomPromise();
      let mockRequestPanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
      when(mockRequestPanelLiveList)().afterReturn(123);

      let result = await liveswitchvm.showBanner();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
    });
  });

  describe('hidePanel_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_release_panel_capsule_list_when_panel_is_not_banner_type', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let bannerMgrMock: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
      when(bannerMgrMock)([]).afterReturnNothing();

      liveswitchvm.hidePanel();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
    });

    it('should_release_panel_live_list_when_panel_is_banner_type', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let bannerMgrMock: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
      when(bannerMgrMock)([]).afterReturnNothing();

      liveswitchvm.hidePanel();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
    });

    it('should_log_info_when_hiding_panel', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(logHelperMock)([ArgumentMatchers.anyString]).afterReturnNothing();

      liveswitchvm.hidePanel();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_release_panel_capsule_list_when_panel_is_banner_type', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let bannerMgrMock: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
      when(bannerMgrMock)([]).afterReturnNothing();

      liveswitchvm.hidePanel();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
    });

    it('should_release_panel_capsule_list_and_panel_live_list_when_panel_is_not_banner_type', 0, async () => {
      const mocker = new MockKit();
      const releasePanelCapsuleListMock = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
      when(releasePanelCapsuleListMock)([]).afterReturnNothing();

      const releasePanelLiveListMock = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
      when(releasePanelLiveListMock)([]).afterReturnNothing();

      const isBannerPanelTypeMock = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
      when(isBannerPanelTypeMock)([BannerPanelType.TYPE_LIVE_HEADS_UP]).afterReturn(false);

      liveswitchvm.hidePanel();

      expect(releasePanelCapsuleListMock).toHaveBeenCalled();
      expect(releasePanelLiveListMock).toHaveBeenCalled();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    });

    it('should_only_release_panel_capsule_list_when_panel_is_banner_type', 0, async () => {
      const mocker = new MockKit();
      const releasePanelCapsuleListMock = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
      when(releasePanelCapsuleListMock)([]).afterReturnNothing();

      const releasePanelLiveListMock = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
      when(releasePanelLiveListMock)([]).afterReturnNothing();

      const isBannerPanelTypeMock = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
      when(isBannerPanelTypeMock)([BannerPanelType.TYPE_LIVE_HEADS_UP]).afterReturn(true);

      liveswitchvm.hidePanel();

      expect(releasePanelCapsuleListMock).toHaveBeenCalled();
      expect(releasePanelLiveListMock).not.toHaveBeenCalled();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    });

    it('should_log_info_when_hiding_panel', 0, async () => {
      const mocker = new MockKit();
      const showInfoMock = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(showInfoMock)([ArgumentMatchers.anyString]).afterReturnNothing();
      liveswitchvm.hidePanel();
      expect(showInfoMock).toHaveBeenCalled();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });

  describe('getCollapseCardDuration_testSuite', () => {
    beforeEach(() => {

    });
    afterEach(() => {

    });
    it('should_return_duration_when_expanding_true_and_collapsing_false', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = true;
      liveswitchvm.isCollapsing = false;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_false_and_collapsing_true', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = false;
      liveswitchvm.isCollapsing = true;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_and_collapsing_are_true', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = true;
      liveswitchvm.isCollapsing = true;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_and_collapsing_are_false', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = false;
      liveswitchvm.isCollapsing = false;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_true_and_collapsing_false', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = true;
      liveswitchvm.isCollapsing = false;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_false_and_collapsing_true', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = false;
      liveswitchvm.isCollapsing = true;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_and_collapsing_are_true', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = true;
      liveswitchvm.isCollapsing = true;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_duration_when_expanding_and_collapsing_are_false', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(1000);
      liveswitchvm.isExpanding = false;
      liveswitchvm.isCollapsing = false;
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_zero_when_liveCardListAnimation_returns_zero', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(0);
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(0);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_negative_value_when_liveCardListAnimation_returns_negative', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(-500);
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(-500);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_throw_error_when_liveCardListAnimation_throws_exception', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterThrow('Error occurred');
      expect(() => {
        liveswitchvm.getCollapseCardDuration();
      }).assertThrowError('Error occurred');
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_undefined_when_liveCardListAnimation_returns_undefined', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(undefined);
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertUndefined();
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_undefined_when_liveCardListAnimation_returns_undefined', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(undefined);
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertUndefined();
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_large_positive_value_when_liveCardListAnimation_returns_large_value', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn(999999);
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual(999999);
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });

    it('should_return_string_when_liveCardListAnimation_returns_string', 0, async () => {
      let liveswitchvm: ILiveSwitchVm = new LiveSwitchVm();
      let mocker: MockKit = new MockKit();
      let liveCardListAnimation: LiveCardListAnimation = new LiveCardListAnimation(liveswitchvm.vmInjector);
      let mockfunc: Function = mocker.mockFunc(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
      when(mockfunc)().afterReturn("1000");
      const result = liveswitchvm.getCollapseCardDuration();
      expect(result).assertEqual("1000");
      mocker.ignoreMock(liveCardListAnimation, liveCardListAnimation.getCollapseCardDuration);
    });
  });
}

function expandCapsuleToCardTest1() {
  it('should_return_when_isExpanding_is_true', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    liveSwitchVm.isExpanding = true;
    await liveSwitchVm.expandCapsuleToCard();
    expect(liveSwitchVm.isExpanding).assertEqual(true);
  });
}

function expandCapsuleToCardTest2() {
  it('should_return_when_isCollapsing_is_true', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    liveSwitchVm.isCollapsing = true;
    await liveSwitchVm.expandCapsuleToCard();
    expect(liveSwitchVm.isCollapsing).assertEqual(true);
  });
}

function expandCapsuleToCardTest3() {
  it('should_expand_capsule_to_card_successfully', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.expandCapsuleToCard();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}

function expandCapsuleToCardTest4() {
  it('should_expand_capsule_to_card_successfully_when_is_banner_panel_type', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(true);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.expandCapsuleToCard();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}

function expandCapsuleToCardTest5() {
  it('should_collapse_card_to_capsule_successfully', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest6() {
  it('should_return_when_isExpanding_is_true_live_id_is_6', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 6;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    liveSwitchVm.isExpanding = true;
    await liveSwitchVm.expandCapsuleToCard();
    expect(liveSwitchVm.isExpanding).assertEqual(true);
  });
}
function expandCapsuleToCardTest7() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_7', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 7;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest8() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_8', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 8;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest9() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_9', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 9;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest10() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_10', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 10;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest11() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_11', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 11;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest12() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_12', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 12;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest13() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_13', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 13;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest14() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_14', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 14;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest15() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_15', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 15;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest16() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_16', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 16;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest17() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_17', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 17;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest18() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_18', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 18;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest19() {
  it('should_return_when_isExpanding_is_true_live_id_is_19', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 19;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    liveSwitchVm.isExpanding = true;
    await liveSwitchVm.expandCapsuleToCard();
    expect(liveSwitchVm.isExpanding).assertEqual(true);
  });
}
function expandCapsuleToCardTest20() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_20', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 20;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest21() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_21', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 21;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest22() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_22', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 22;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest23() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_23', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 23;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest24() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_24', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 24;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest25() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_25', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 25;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest26() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_26', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 26;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest27() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_27', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 27;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest28() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 28;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest29() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 29;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest30() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 30;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest31() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 31;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest32() {
  it('should_return_when_isExpanding_is_true_live_id_is_19', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 19;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    liveSwitchVm.isExpanding = true;
    await liveSwitchVm.expandCapsuleToCard();
    expect(liveSwitchVm.isExpanding).assertEqual(true);
  });
}
function expandCapsuleToCardTest33() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_20', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 20;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest34() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_21', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 21;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest35() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_22', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 22;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest36() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_23', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 23;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest37() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_24', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 24;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest38() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_25', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 25;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest39() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_26', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 26;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest40() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_27', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 27;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest41() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 28;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest42() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 29;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest43() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 30;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest44() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 31;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest45() {
  it('should_return_when_isExpanding_is_true_live_id_is_19', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 19;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    liveSwitchVm.isExpanding = true;
    await liveSwitchVm.expandCapsuleToCard();
    expect(liveSwitchVm.isExpanding).assertEqual(true);
  });
}
function expandCapsuleToCardTest46() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_20', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 20;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest47() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_21', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 21;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest48() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_22', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 22;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest49() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_23', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 23;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest50() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_24', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 24;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest51() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_25', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 25;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest52() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_26', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 26;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest53() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_27', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 27;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest54() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 28;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest55() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 29;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest56() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 30;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function expandCapsuleToCardTest57() {
  it('should_collapse_card_to_capsule_successfully_live_id_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    live.id = 31;

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();

    let mockGetCapsuleListVm = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockGetCapsuleListVm)(ArgumentMatchers.any).afterReturn(new LiveVmInjector().getCapsuleListVm());

    let mockFreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockUnfreeze = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

    let mockIsBannerPanelType = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);

    let mockShowInfo = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    await liveSwitchVm.collapseCardToCapsule();

    expect(liveSwitchVm.isExpanding).assertEqual(false);
    expect(liveSwitchVm.isCollapsing).assertEqual(false);

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.freeze);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.unfreeze);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    mocker.ignoreMock(log, log.showInfo);
  });
}
function hidePanelTest1() {
  it('should_release_panel_capsule_list_when_panel_is_not_banner_type', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();
    let mockReleasePanelCapsuleList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
    let mockReleasePanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
    let mockShowInfo: Function = mocker.mockFunc(log, log.showInfo);
    let mockIsBannerPanelType: Function = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);

    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(false);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    liveSwitchVm.hidePanel();

    mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
    mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
  });
}

function hidePanelTest2() {
  it('should_release_panel_live_list_when_panel_is_banner_type', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();
    let mockReleasePanelCapsuleList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelCapsuleList);
    let mockReleasePanelLiveList: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelLiveList);
    let mockShowInfo: Function = mocker.mockFunc(log, log.showInfo);
    let mockIsBannerPanelType: Function = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);

    when(mockIsBannerPanelType)(ArgumentMatchers.any).afterReturn(true);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    liveSwitchVm.hidePanel();

    mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelCapsuleList);
    mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelLiveList);
    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
  });
}

function showBannerTest1() {
  it('should_resolve_bannerAppearPromise_when_bannerAppearPromise_is_undefined', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

    const result: Promise<void> = liveSwitchVm.showBanner();
    expect(result).assertInstanceOf('Promise<void>');
    mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
  });
}

function showBannerTest2() {
  it('should_resolve_bannerAppearPromise_when_bannerAppearPromise_is_defined', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: LiveSwitchVm = new LiveSwitchVm(liveVmInjector);

    liveSwitchVm.showBanner();

    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.requestPanelLiveList);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

    const result: Promise<void> = liveSwitchVm.showBanner();
    expect(result).assertInstanceOf('Promise<void>');
    mocker.ignoreMock(bannerMgr, bannerMgr.requestPanelLiveList);
  });
}

function onPanelSizeChangeTest1() {
  it('should_resolve_bannerAppearPromise_when_sizeHeight_is_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 100, height: 0 });

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onPanelSizeChangeTest2() {
  it('should_call_moveToStatusBar_when_sizeHeight_is_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToStatusBar);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 100, height: 0 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToStatusBar);
  });
}

function onPanelSizeChangeTest3() {
  it('should_call_moveToBanner_when_sizeHeight_is_not_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 100, height: 200 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest4() {
  it('should_call_moveToBanner_when_size_width_is_0_height_is_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 0, height: 0 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest5() {
  it('should_call_moveToBanner_when_size_width_is_50_height_is_50', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 50, height: 50 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest6() {
  it('should_call_moveToBanner_when_size_width_is_-50_height_is_50', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: -50, height: 50 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest7() {
  it('should_call_moveToBanner_when_size_width_is_50_height_is_-50', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 50, height: -50 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest8() {
  it('should_call_moveToBanner_when_size_width_is_50_height_is_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 50, height: 0 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest9() {
  it('should_call_moveToBanner_when_size_width_is_0_height_is_50', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 0, height: 50 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest10() {
  it('should_call_moveToBanner_when_size_width_is_-50_height_is_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: -50, height: 0 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest11() {
  it('should_call_moveToBanner_when_size_width_is_0_height_is_-50', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 0, height: -50 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest12() {
  it('should_call_moveToBanner_when_size_width_is_100_height_is_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 100, height: 0 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest13() {
  it('should_call_moveToBanner_when_size_width_is_0_height_is_100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 0, height: 100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest14() {
  it('should_call_moveToBanner_when_size_width_is_100_height_is_100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 100, height: 100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest15() {
  it('should_call_moveToBanner_when_size_width_is_-100_height_is_0', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: -100, height: 0 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest16() {
  it('should_call_moveToBanner_when_size_width_is_0_height_is_-100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 0, height: -100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest17() {
  it('should_call_moveToBanner_when_size_width_is_-100_height_is_-100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: -100, height: -100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest18() {
  it('should_call_moveToBanner_when_size_width_is_100_height_is_-100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 100, height: -100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest19() {
  it('should_call_moveToBanner_when_size_width_is_-100_height_is_100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: -100, height: 100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest20() {
  it('should_call_moveToBanner_when_size_width_is_100_height_is_50', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 100, height: 50 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest21() {
  it('should_call_moveToBanner_when_size_width_is_50_height_is_100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: 50, height: 100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

function onPanelSizeChangeTest22() {
  it('should_call_moveToBanner_when_size_width_is_-50_height_is_100', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let liveSwitchVm: ILiveSwitchVm = new LiveSwitchVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    const TAG = 'LiveSwitchVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let capsuleListVm: ILiveCapsuleListVm = liveVmInjector.getCapsuleListVm();
    let viewManager: NodeControllerManager = capsuleListVm.viewManager;
    let mockFunc2: Function = mocker.mockFunc(viewManager, viewManager.moveToBanner);
    when(mockFunc2)().afterReturnNothing();

    liveSwitchVm.onPanelSizeChange({}, { width: -50, height: 100 });

    mocker.ignoreMock(log, log.showInfo);
    mocker.ignoreMock(viewManager, viewManager.moveToBanner);
  });
}

// 测试用例：验证胶囊展开为卡片的正常流程
function testExpandCapsuleToCard_NormalFlow() {
  // 准备局部模拟对象
  const mockBannerMgr = {
    isBannerPanelType: () => false,
    requestPanelLiveList: jest.fn()
  };
  const mockNotificationMgr = {
    freeze: jest.fn(),
    unfreeze: jest.fn()
  };
  const mockCardListVm = {
    initLiveList: jest.fn(),
    listOpacity: 0,
    resetList: jest.fn()
  };
  const mockCapsuleListVm = {
    toggleCapsuleList: jest.fn(),
    liveList: [/* 模拟通知数据 */],
    isInterruptInstantBanner: false
  };
  const mockAnimation = {
    expandCard: jest.fn().mockReturnValue(Promise.resolve())
  };

  // 创建被测对象并注入模拟依赖
  const vm = new LiveSwitchVm();
  vm.vmInjector = {
    getCardListVm: () => mockCardListVm,
    getCapsuleListVm: () => mockCapsuleListVm,
    getLiveHeadsUpVm: () => ({ isInterrupt: false }),
    getCapsuleVm: () => ({ isToDelete: false }),
    getCardListAnimation: () => mockAnimation
  };
  vm.bannerMgr = mockBannerMgr;
  vm.notificationMgr = mockNotificationMgr;

  // 执行操作
  return vm.expandCapsuleToCard().then(() => {
    // 验证关键步骤
    expect(mockCapsuleListVm.toggleCapsuleList).toHaveBeenCalled();
    expect(mockNotificationMgr.freeze).toHaveBeenCalledWith("LIVE_PANEL_EXPAND", 1500);
    expect(mockCardListVm.initLiveList).toHaveBeenCalledWith(mockCapsuleListVm.liveList);
    expect(mockAnimation.expandCard).toHaveBeenCalled();
    expect(mockNotificationMgr.unfreeze).toHaveBeenCalledWith("LIVE_PANEL_EXPAND");
    expect(vm.isExpanding).toBe(false);
  });
}

// 测试用例：验证展开时已有展开操作正在进行
function testExpandCapsuleToCard_AlreadyExpanding() {
  const vm = new LiveSwitchVm();
  vm.isExpanding = true;

  // 执行操作
  const result = vm.expandCapsuleToCard();

  // 验证立即返回
  expect(result).resolves.toBeUndefined();
  expect(vm.isExpanding).toBe(true);
}

// 测试用例：验证收起卡片到胶囊的正常流程
function testCollapseCardToCapsule_NormalFlow() {
  const mockBannerMgr = {
    releasePanelLiveList: jest.fn(),
    requestPanelCapsuleList: jest.fn()
  };
  const mockAnimation = {
    collapseCard: jest.fn().mockReturnValue(Promise.resolve())
  };
  const mockCardListVm = {
    resetList: jest.fn().mockReturnValue(Promise.resolve()),
    scrollToTop: jest.fn()
  };
  const mockCapsuleListVm = {
    toggleCapsuleList: jest.fn(),
    isInterruptInstantBanner: true
  };

  const vm = new LiveSwitchVm();
  vm.vmInjector = {
    getCardListVm: () => mockCardListVm,
    getCapsuleListVm: () => mockCapsuleListVm,
    getCardListAnimation: () => mockAnimation
  };
  vm.bannerMgr = mockBannerMgr;
  vm.isCollapsing = false;

  return vm.collapseCardToCapsule().then(() => {
    expect(mockCapsuleListVm.isInterruptInstantBanner).toBe(false);
    expect(mockCardListVm.resetList).toHaveBeenCalled();
    expect(mockAnimation.collapseCard).toHaveBeenCalled();
    expect(mockCardListVm.scrollToTop).toHaveBeenCalled();
    expect(vm.isCollapsing).toBe(false);
  });
}

// 测试用例：验证横幅面板显示逻辑
function testShowBanner_BannerPanelType() {
  const mockBannerMgr = {
    isBannerPanelType: jest.fn().mockReturnValue(true),
    requestPanelLiveList: jest.fn()
  };
  const vm = new LiveSwitchVm();
  vm.bannerMgr = mockBannerMgr;

  vm.showBanner().then(() => {
    expect(mockBannerMgr.requestPanelLiveList).toHaveBeenCalled();
    expect(vm.bannerAppearPromise).toBeDefined();
  });
}

// 测试用例：验证不同缺口类型动画延迟
function testExpandCard_DelayCalculation() {
  const mockCutoutVm = {
    isMiddleCutout: jest.fn()
  };
  const vm = new LiveSwitchVm();
  CutoutVm.instance = { isMiddleCutout: () => true };

  vm.expandCard();
  expect(vm.expandCardTimerId).toBeGreaterThan(0);
  expect(setTimeout).toHaveBeenLastCalledWith(expect.any(Function), 367);

  CutoutVm.instance.isMiddleCutout = () => false;
  vm.expandCard();
  expect(setTimeout).toHaveBeenLastCalledWith(expect.any(Function), 230);
}

function testHidePanel_WhenBannerPanelType() {
  const mockBannerMgr = {
    isBannerPanelType: () => true,
    releasePanelLiveList: jest.fn(),
    releasePanelCapsuleList: jest.fn()
  };

  const vm = new LiveSwitchVm();
  vm.bannerMgr = mockBannerMgr;

  vm.hidePanel();

  // 验证：当面板类型为横幅时，不释放 live 列表
  expect(mockBannerMgr.releasePanelLiveList).not.toHaveBeenCalled();
  expect(mockBannerMgr.releasePanelCapsuleList).toHaveBeenCalled();
}

function testOnPanelSizeChange_HeightZero() {
  const mockCapsuleListVm = {
    viewManager: {
      moveToStatusBar: jest.fn()
    }
  };

  const vm = new LiveSwitchVm();
  vm.vmInjector = {
    getCapsuleListVm: () => mockCapsuleListVm
  };
  vm.bannerAppearPromise = new CustomPromise();

  vm.onPanelSizeChange({}, { width: 100, height: 0 });

  // 验证：高度为 0 时移动到状态栏
  expect(mockCapsuleListVm.viewManager.moveToStatusBar).toHaveBeenCalled();
  expect(vm.bannerAppearPromise).toBeUndefined();
}

function testExpandCard_CancelDuringExpansion() {
  const mockAnimation = {
    expandCard: jest.fn().mockReturnValue(Promise.resolve())
  };
  const mockCutoutVm = {
    isMiddleCutout: () => true
  };

  const vm = new LiveSwitchVm();
  vm.vmInjector = { getCardListAnimation: () => mockAnimation };
  CutoutVm.instance = { isMiddleCutout: () => true };

  // 模拟开始展开
  vm.expandCard();
  expect(vm.expandCardTimerId).toBeDefined();

  // 模拟中断（调用 collapseCardToCapsule）
  vm.collapseCardToCapsule = jest.fn().mockReturnValue(Promise.resolve());
  vm.collapseCardToCapsule();

  // 验证：定时器被清除且 Promise 被 resolve
  expect(clearTimeout).toHaveBeenCalledWith(vm.expandCardTimerId);
  expect(vm.expandCardPromise).toBeResolved();
}

function testExpandCapsuleToCard_EmptyCapsuleList() {
  const mockCapsuleListVm = {
    liveList: [],
    toggleCapsuleList: jest.fn()
  };

  const vm = new LiveSwitchVm();
  vm.vmInjector = {
    getCapsuleListVm: () => mockCapsuleListVm,
    getCapsuleVm: () => ({ isToDelete: false })
  };

  return vm.expandCapsuleToCard().then(() => {
    // 验证：胶囊列表为空时仍执行动画但不初始化卡片列表
    expect(mockCapsuleListVm.toggleCapsuleList).toHaveBeenCalled();
    expect(vm.vmInjector.getCardListVm().initLiveList).not.toHaveBeenCalled();
  });
}

function testReportSwitch_ParameterValidation() {
  const mockMaintenance = {
    reportClick: jest.fn()
  };
  const mockHiSysEvent = {
    reportCapsuleSwitchEvent: jest.fn()
  };

  const vm = new LiveSwitchVm();
  vm.vmInjector.getCapsuleListVm = () => ({
    liveList: [{ id: "test" }]
  });
  vm.vmInjector.getLiveHiSysEvent = () => mockHiSysEvent;
  vm.ClickNotificationMaintenance = mockMaintenance;

  // 测试展开时的 reportSwitch
  vm.reportSwitch(true);
  expect(mockMaintenance.reportClick).toHaveBeenCalledWith(
    expect.anything(),
    expect.objectContaining({ data: vm.vmInjector.getCapsuleListVm().liveList[0] })
  );
  expect(mockHiSysEvent.reportCapsuleSwitchEvent).toHaveBeenCalledWith(
    vm.vmInjector.getCapsuleListVm().liveList,
    true
  );

  // 测试收起时的 reportSwitch
  vm.reportSwitch(false);
  expect(mockHiSysEvent.reportCapsuleSwitchEvent).toHaveBeenCalledWith(
    vm.vmInjector.getCapsuleListVm().liveList,
    false
  );
}

function testCollapseCardToCapsule_WithExpandTimer() {
  const mockBannerMgr = {
    releasePanelLiveList: jest.fn(),
    requestPanelCapsuleList: jest.fn()
  };
  const mockCapsuleListVm = {
    toggleCapsuleList: jest.fn(),
    isInterruptInstantBanner: true
  };

  const vm = new LiveSwitchVm();
  vm.bannerMgr = mockBannerMgr;
  vm.vmInjector = {
    getCapsuleListVm: () => mockCapsuleListVm
  };
  vm.expandCardTimerId = 123 as any;

  return vm.collapseCardToCapsule().then(() => {
    // 验证：清除定时器并直接调用 toggleCapsuleList
    expect(clearTimeout).toHaveBeenCalledWith(123);
    expect(mockCapsuleListVm.toggleCapsuleList).toHaveBeenCalledWith(
      expect.objectContaining({ isUpwards: true, isNeedLight: true })
    );
    expect(vm.expandCardPromise).toBeResolved();
  });
}