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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { ILiveCardListVm } from '../../../../../../main/ets/live/interface/ILiveCardListVm';
import { LiveCardListVm } from '../../../../../../main/ets/live/vm/LiveCardListVm';
import { NotificationArray } from '../../../../../../main/ets/model/NotificationBase';
import { bannerMgr } from '../../../../../../main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { BannerOutsideState, BannerPanelType } from '../../../../../../main/ets/banner/common/info/BannerState';
import { OnStateChangeListener } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import { StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { LiveType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveCardAnimation } from '../../../../../../main/ets/live/animation/LiveCardAnimation';
import { BannerVm } from '../../../../../../main/ets/vm/BannerVm';
import { LiveCardUpdateAnimation } from '../../../../../../main/ets/live/animation/LiveCardUpdateAnimation';
import { AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
import { AppLifeCycleManager } from '../../../../../../main/ets/manager/AppLifeCycleManager';
import { SystemUICommonUtil } from '../../../../../../main/ets/utils/SystemUICommonUtil';
import { DeviceInfoVm } from '../../../../../../main/ets/vm/DeviceInfoVm';
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import { ILiveSwitchVm } from '../../../../../../main/ets/live/interface/ILiveSwitchVm';

export default function LiveCardListVmTest() {
  describe('clearLiveList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_clear_all_live_list_collections', 0, () => {
      let liveVmInjector = new LiveVmInjector();
      let livecardlistvm: ILiveCardListVm = liveVmInjector.getCardListVm();
      let mocker: MockKit = new MockKit();
      let liveList = new NotificationArray();
      let mockLiveArrayClear: Function = mocker.mockFunc(livecardlistvm.liveList, liveList.clear);
      when(mockLiveArrayClear)(ArgumentMatchers.any).afterReturn(null);

      let mockMapClear: Function = mocker.mockFunc(livecardlistvm.liveMap, livecardlistvm.liveMap.clear);
      when(mockMapClear)(ArgumentMatchers.any).afterReturn(null);

      livecardlistvm.clearLiveList();
      expect(livecardlistvm.liveList.length).assertEqual(0);
      mocker.ignoreMock(livecardlistvm.liveList, liveList.clear);
      mocker.ignoreMock(livecardlistvm.liveMap, livecardlistvm.liveMap.clear);
    });
  });
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_register_state_change_listener_when_init_is_called', 0, () => {
      let liveVmInjector = new LiveVmInjector();
      let livecardlistvm: ILiveCardListVm = liveVmInjector.getCardListVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.registerStateChangeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      livecardlistvm.init();
      mocker.verify('registerStateChangeListener', [ArgumentMatchers.any, ArgumentMatchers.any]).once();
      mocker.ignoreMock(bannerMgr, bannerMgr.registerStateChangeListener);
    });
  });
    describe('addLive_testSuite', () => {

      beforeEach(() => {

      });
      afterEach(() => {

      });

      it('should_return_immediately_when_live_panel_is_not_shown', 0, async () => {
        let livecardlistvm: LiveCardListVm = new LiveCardListVm();
        let mocker: MockKit = new MockKit();
        let bannerVmMock: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
        when(bannerVmMock)().afterReturn(false);
        let logMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(logMock)([ArgumentMatchers.anyString]).afterReturnNothing();

        await livecardlistvm.addLive(new LiveNotification());

        mocker.verify('isLivePanel', []).once();
        mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      it('should_return_immediately_when_shouldAdd_returns_false', 0, async () => {
        let livecardlistvm: LiveCardListVm = new LiveCardListVm();
        let mocker: MockKit = new MockKit();
        let bannerVmMock: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
        when(bannerVmMock)().afterReturn(true);
        let logMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(logMock)([ArgumentMatchers.anyString]).afterReturnNothing();

        let live: LiveNotification = new LiveNotification();
        live.type = LiveType.VIDEO_LIVE;
        await livecardlistvm.addLive(live);

        mocker.verify('isLivePanel', []).once();
        mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      it('should_execute_animation_when_shouldAdd_returns_true', 0, async () => {
        let livecardlistvm: LiveCardListVm = new LiveCardListVm();
        let mocker: MockKit = new MockKit();
        let bannerVmMock: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
        when(bannerVmMock)().afterReturn(true);
        let logMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(logMock)([ArgumentMatchers.anyString]).afterReturnNothing();
        let animationMock: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
        when(animationMock)([ArgumentMatchers.any]).afterReturn(Promise.resolve());

        let live: LiveNotification = new LiveNotification();
        live.type = LiveType.VIDEO_LIVE;
        livecardlistvm.liveList.add(live);
        await livecardlistvm.addLive(live);

        mocker.verify('isLivePanel', []).once();
        mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
      });
    });
  describe('localUpdateLiveList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_live_panel_is_not_shown', 0, async () => {
      let livecardlistvm: LiveCardListVm = new LiveCardListVm();
      let mocker: MockKit = new MockKit();
      let bannerVmMock: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(bannerVmMock)().afterReturn(false);
      let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification('1', 'title1', 'content1', LiveType.VIDEO_PLAY, 'url1'),
        new LiveNotification('2', 'title2', 'content2', LiveType.VIDEO_PLAY, 'url2')
      ];
      livecardlistvm.localUpdateLiveList(liveList);

      mocker.verify('isLivePanel', []).once();
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_live_list_and_sort_when_live_panel_is_shown', 0, async () => {
      let livecardlistvm: LiveCardListVm = new LiveCardListVm();
      let mocker: MockKit = new MockKit();
      let bannerVmMock: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(bannerVmMock)().afterReturn(true);
      let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();
      let sortMock: Function = mocker.mockFunc(livecardlistvm.liveList, livecardlistvm.liveList.sort);
      when(sortMock)().afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification('1', 'title1', 'content1', LiveType.VIDEO_PLAY, 'url1'),
        new LiveNotification('2', 'title2', 'content2', LiveType.VIDEO_PLAY, 'url2')
      ];
      livecardlistvm.localUpdateLiveList(liveList);

      mocker.verify('isLivePanel', []).once();
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecardlistvm.liveList, livecardlistvm.liveList.sort);
    });

    it('should_not_update_live_list_when_live_panel_is_not_shown', 0, async () => {
      let livecardlistvm: LiveCardListVm = new LiveCardListVm();
      let mocker: MockKit = new MockKit();
      let bannerVmMock: Function = mocker.mockFunc(BannerVm.instance, BannerVm.instance.isLivePanel);
      when(bannerVmMock)().afterReturn(false);
      let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();
      let sortMock: Function = mocker.mockFunc(livecardlistvm.liveList, livecardlistvm.liveList.sort);
      when(sortMock)().afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification('1', 'title1', 'content1', LiveType.VIDEO_PLAY, 'url1'),
        new LiveNotification('2', 'title2', 'content2', LiveType.VIDEO_PLAY, 'url2')
      ];
      livecardlistvm.localUpdateLiveList(liveList);

      mocker.verify('isLivePanel', []).once();
      mocker.ignoreMock(BannerVm.instance, BannerVm.instance.isLivePanel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecardlistvm.liveList, livecardlistvm.liveList.sort);
    });
  });
}
