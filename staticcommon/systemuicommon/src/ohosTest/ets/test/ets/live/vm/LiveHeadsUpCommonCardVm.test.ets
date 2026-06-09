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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
  DEFAULT
} from '@ohos/hypium';
import { DropdownVm, EnvVm, LiveVmInjector } from '../../../../../../../newIndex';
import { BannerPanelType } from '../../../../../../main/ets/banner/common/info/BannerState';
import { bannerMgr } from '../../../../../../main/ets/banner/phone/BannerManager';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { LiveType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { SysTypeCode } from '../../../../../../main/ets/liveview/common/LiveConstants';
import { StatusBarType } from '../../../../../../main/ets/plugin/info/StatusBarType';

export default function LiveHeadsUpCommonCardVmTest() {
  describe('LiveHeadsUpVmTest', () => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })
  })
  LiveHeadsUpCommonCardVmTest1();
  LiveHeadsUpCommonCardVmTest2();
  LiveHeadsUpCommonCardVmTest3();
  LiveHeadsUpCommonCardVmTest4();
  LiveHeadsUpCommonCardVmTest5();
  LiveHeadsUpCommonCardVmTest6();
  LiveHeadsUpCommonCardVmTest7();

  describe('cardGradientColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_rgba_0_0_0_0_when_live_is_null_or_live_card_is_small', 0, () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let mockIsSmallCard: Function = mocker.mockFunc(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      when(mockIsSmallCard)().afterReturn(true);
      const result = liveheadsupcommoncardvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0)');
      mocker.ignoreMock(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
    });

    it('should_return_rgba_when_live_is_not_null_and_live_card_is_not_small', 0, () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let mockIsSmallCard: Function = mocker.mockFunc(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);
      let mockConvertColorToRgba: Function = mocker.mockFunc(LiveBaseVm.prototype, LiveBaseVm.prototype.convertColorToRgba);
      when(mockIsSmallCard)().afterReturn(false);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({ contentColor: 'rgba(0, 0, 0, 1)' });
      when(mockConvertColorToRgba)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn('rgba(0, 0, 0, 0.25)');
      const result = liveheadsupcommoncardvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0.25)');
      mocker.ignoreMock(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LiveBaseVm.prototype, LiveBaseVm.prototype.convertColorToRgba);
    });

    it('should_return_rgba_0_0_0_0_when_live_is_null_or_live_card_is_small', 0, () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      // 模拟live为null的情况
      const result1 = liveheadsupcommoncardvm.cardGradientColor;
      expect(result1).assertEqual('rgba(0, 0, 0, 0)');

      // 模拟live不为null，但card是小卡片的情况
      let mockIsSmallCard: Function = mocker.mockFunc(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      when(mockIsSmallCard)().afterReturn(true);
      const result2 = liveheadsupcommoncardvm.cardGradientColor;
      expect(result2).assertEqual('rgba(0, 0, 0, 0)');
      mocker.ignoreMock(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
    });

    it('should_return_rgba_when_live_is_not_null_and_live_card_is_not_small', 0, () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let mockIsSmallCard: Function = mocker.mockFunc(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);
      let mockConvertColorToRgba: Function = mocker.mockFunc(LiveBaseVm.prototype, LiveBaseVm.prototype.convertColorToRgba);

      when(mockIsSmallCard)().afterReturn(false);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({ contentColor: 'rgba(0, 0, 0, 1)' });
      when(mockConvertColorToRgba)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn('rgba(0, 0, 0, 0.25)');

      const result = liveheadsupcommoncardvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0.25)');

      mocker.ignoreMock(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LiveBaseVm.prototype, LiveBaseVm.prototype.convertColorToRgba);
    });

    it('should_return_rgba_0_0_0_0_when_live_card_is_null', 0, () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      // 模拟live存在，但card为null的情况
      liveheadsupcommoncardvm.live = { card: null } as LiveNotification;
      const result = liveheadsupcommoncardvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0)');
    });

    it('should_return_rgba_0_0_0_0_when_getCapsuleVm_returns_null', 0, () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let mockIsSmallCard: Function = mocker.mockFunc(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);

      when(mockIsSmallCard)().afterReturn(false);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(null);

      const result = liveheadsupcommoncardvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0)');

      mocker.ignoreMock(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);
    });

    it('should_return_rgba_0_0_0_0_when_convertColorToRgba_throws_error', 0, () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let mockIsSmallCard: Function = mocker.mockFunc(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);
      let mockConvertColorToRgba: Function = mocker.mockFunc(LiveBaseVm.prototype, LiveBaseVm.prototype.convertColorToRgba);

      when(mockIsSmallCard)().afterReturn(false);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({ contentColor: 'rgba(0, 0, 0, 1)' });
      when(mockConvertColorToRgba)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterThrow('Error occurred');

      const result = liveheadsupcommoncardvm.cardGradientColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0)');

      mocker.ignoreMock(liveheadsupcommoncardvm.live?.card, liveheadsupcommoncardvm.live?.card.isSmallCard);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LiveBaseVm.prototype, LiveBaseVm.prototype.convertColorToRgba);
    });
  });

  describe('show_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_and_expand_card_when_show_is_called', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveNotification: LiveNotification = new LiveNotification();
      let envVm: EnvVm = new EnvVm();
      let dropdownVm: DropdownVm = new DropdownVm();
      envVm.dropdownVm = dropdownVm;
      envVm.liveVmList = [];
      liveheadsupcommoncardvm.envVm = envVm;

      let mockExpandCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
      when(mockExpandCard)().afterReturn(Promise.resolve());

      await liveheadsupcommoncardvm.show(liveNotification);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
    });

    it('should_log_info_and_expand_card_when_show_is_called', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveNotification: LiveNotification = new LiveNotification();
      let envVm: EnvVm = new EnvVm();
      let dropdownVm: DropdownVm = new DropdownVm();
      envVm.dropdownVm = dropdownVm;
      envVm.liveVmList = [];
      liveheadsupcommoncardvm.envVm = envVm;

      let mockExpandCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
      when(mockExpandCard)().afterReturn(Promise.resolve());

      await liveheadsupcommoncardvm.show(liveNotification);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
    });

    it('should_throw_error_when_logHelper_is_null', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterThrow('LogHelper is null');

      let liveNotification: LiveNotification = new LiveNotification();
      let envVm: EnvVm = new EnvVm();
      let dropdownVm: DropdownVm = new DropdownVm();
      envVm.dropdownVm = dropdownVm;
      envVm.liveVmList = [];
      liveheadsupcommoncardvm.envVm = envVm;

      let mockExpandCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
      when(mockExpandCard)().afterReturn(Promise.resolve());

      await expect(liveheadsupcommoncardvm.show(liveNotification)).assertThrowError('LogHelper is null');

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
    });

    it('should_throw_error_when_getCapsuleListVm_returns_null', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: any = liveheadsupcommoncardvm.vmInjector;
      let mockGetCapsuleListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListVm);
      when(mockGetCapsuleListVm)().afterReturn(null);

      let liveNotification: LiveNotification = new LiveNotification();

      await expect(liveheadsupcommoncardvm.show(liveNotification)).assertThrowError('getCapsuleListVm returned null');

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListVm);
    });

    it('should_throw_error_when_expandCard_fails', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveNotification: LiveNotification = new LiveNotification();
      let envVm: EnvVm = new EnvVm();
      let dropdownVm: DropdownVm = new DropdownVm();
      envVm.dropdownVm = dropdownVm;
      envVm.liveVmList = [];
      liveheadsupcommoncardvm.envVm = envVm;

      let mockExpandCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
      when(mockExpandCard)().afterThrow('expandCard failed');

      await expect(liveheadsupcommoncardvm.show(liveNotification)).assertThrowError('expandCard failed');

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.expandCard);
    });

    it('should_throw_error_when_live_is_null', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let liveNotification: LiveNotification = null as any;

      await expect(liveheadsupcommoncardvm.show(liveNotification)).assertThrowError('live is null');
    });
  });

  describe('update_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_and_call_updateVmByLive_when_live_is_provided', 0, async () => {
      let liveheadsupcommoncardvm: LiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockUpdateVmByLive: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);

      let live: LiveNotification = new LiveNotification();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateVmByLive)(ArgumentMatchers.anyObj).afterReturnNothing();

      await liveheadsupcommoncardvm.update(live);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);
    });

    it('should_not_log_info_and_not_call_updateVmByLive_when_live_is_null', 0, async () => {
      let liveheadsupcommoncardvm: LiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockUpdateVmByLive: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);

      let live: LiveNotification = null;
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateVmByLive)(ArgumentMatchers.anyObj).afterReturnNothing();

      await liveheadsupcommoncardvm.update(live);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);
    });

    it('should_log_info_and_call_updateVmByLive_when_live_is_provided', 0, async () => {
      let liveheadsupcommoncardvm: LiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockUpdateVmByLive: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);

      let live: LiveNotification = new LiveNotification();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateVmByLive)(ArgumentMatchers.anyObj).afterReturnNothing();

      await liveheadsupcommoncardvm.update(live);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);
    });

    it('should_not_log_info_and_not_call_updateVmByLive_when_live_is_null', 0, async () => {
      let liveheadsupcommoncardvm: LiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockUpdateVmByLive: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);

      let live: LiveNotification = null;
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateVmByLive)(ArgumentMatchers.anyObj).afterReturnNothing();

      await liveheadsupcommoncardvm.update(live);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);
    });

    it('should_log_info_with_null_hashCode_and_call_updateVmByLive_when_live_hashCode_is_null', 0, async () => {
      let liveheadsupcommoncardvm: LiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockUpdateVmByLive: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);

      let live: LiveNotification = new LiveNotification();
      live.hashCode = null;
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateVmByLive)(ArgumentMatchers.anyObj).afterReturnNothing();

      await liveheadsupcommoncardvm.update(live);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);
    });

    it('should_throw_error_when_updateVmByLive_throws_error', 0, async () => {
      let liveheadsupcommoncardvm: LiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockUpdateVmByLive: Function = mocker.mockFunc(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);

      let live: LiveNotification = new LiveNotification();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateVmByLive)(ArgumentMatchers.anyObj).afterThrow('Error occurred');

      await expect(liveheadsupcommoncardvm.update(live)).assertThrowError('Error occurred');

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(liveheadsupcommoncardvm.vmInjector, liveheadsupcommoncardvm.vmInjector.updateVmByLive);
    });
  });

  describe('hide_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_warning_when_live_is_undefined', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await liveheadsupcommoncardvm.hide();

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_collapse_card_when_live_is_defined', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockCollapseCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);

      let live: LiveNotification = new LiveNotification();
      liveheadsupcommoncardvm.live = live;

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCollapseCard)().afterReturn(Promise.resolve());

      await liveheadsupcommoncardvm.hide();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);
    });

    it('should_log_warning_when_live_is_undefined', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await liveheadsupcommoncardvm.hide();

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_collapse_card_when_live_is_defined', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockCollapseCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);

      let live: LiveNotification = new LiveNotification();
      liveheadsupcommoncardvm.live = live;

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCollapseCard)().afterReturn(Promise.resolve());

      await liveheadsupcommoncardvm.hide();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);
    });

    it('should_throw_error_when_collapseCard_fails', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockCollapseCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);

      let live: LiveNotification = new LiveNotification();
      liveheadsupcommoncardvm.live = live;

      when(mockCollapseCard)().afterThrow('Collapse failed');

      await expect(liveheadsupcommoncardvm.hide()).assertThrowError('Collapse failed');

      // 检查live是否仍然存在
      expect(liveheadsupcommoncardvm.live).assertNotNull();

      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);
    });

    it('should_handle_getCapsuleListVm_returning_undefined', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: any = liveheadsupcommoncardvm.vmInjector;
      let mockGetCapsuleListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListVm);

      let live: LiveNotification = new LiveNotification();
      liveheadsupcommoncardvm.live = live;

      when(mockGetCapsuleListVm)().afterReturn(undefined);

      await expect(liveheadsupcommoncardvm.hide()).assertThrowError('getCapsuleListVm returned undefined');

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListVm);
    });

    it('should_log_info_without_hashCode', 0, async () => {
      let liveheadsupcommoncardvm: ILiveHeadsUpCommonCardVm = new LiveHeadsUpCommonCardVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockCollapseCard: Function = mocker.mockFunc(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);

      let live: LiveNotification = new LiveNotification();
      // 删除hashCode属性
      delete live.hashCode;
      liveheadsupcommoncardvm.live = live;

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCollapseCard)().afterReturn(Promise.resolve());

      await liveheadsupcommoncardvm.hide();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(LiveHeadsUpCommonCardAnimation.prototype, LiveHeadsUpCommonCardAnimation.prototype.collapseCard);
    });
  });
}

function LiveHeadsUpCommonCardVmTest1() {
  it('show', DEFAULT, () => {
    const cardVm = LiveVmInjector.instance.getLiveHeadsUpCommonCardVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    live.typeCode = SysTypeCode.PHONE;
    try {
      cardVm.show(live);
      expect(cardVm.live).assertEqual(live);
    } catch (e) {
    }
  })
}

function LiveHeadsUpCommonCardVmTest2() {
  it('update', DEFAULT, () => {
    const cardVm = LiveVmInjector.instance.getLiveHeadsUpCommonCardVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    live.typeCode = SysTypeCode.PHONE;
    try {
      cardVm.update(live);
      expect(cardVm.live).assertEqual(live);
    } catch (e) {
    }
  })
}

function LiveHeadsUpCommonCardVmTest3() {
  it('hide', DEFAULT, () => {
    const cardVm = LiveVmInjector.instance.getLiveHeadsUpCommonCardVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    live.typeCode = SysTypeCode.PHONE;
    try {
      cardVm.live = new LiveNotification();
      cardVm.hide();
      expect(cardVm.live).assertUndefined();
    } catch (e) {
    }
  })
}

function LiveHeadsUpCommonCardVmTest4() {
  it('isNeedShow1', DEFAULT, () => {
    const cardVm = LiveVmInjector.instance.getLiveHeadsUpCommonCardVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    live.typeCode = SysTypeCode.PHONE;
    try {
      cardVm.live = new LiveNotification();
      const result = cardVm.isNeedShow(live);
      expect(result).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpCommonCardVmTest5() {
  it('isNeedShow2', DEFAULT, () => {
    const cardVm = LiveVmInjector.instance.getLiveHeadsUpCommonCardVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    live.typeCode = SysTypeCode.PHONE;
    try {
      cardVm.live = new LiveNotification();
      EnvVm.instance.isScreenLock = true;
      const result = cardVm.isNeedShow(live);
      expect(result).assertFalse();
    } catch (e) {
    }
  })
}

function LiveHeadsUpCommonCardVmTest6() {
  it('isNeedShow3', DEFAULT, () => {
    const cardVm = LiveVmInjector.instance.getLiveHeadsUpCommonCardVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    live.typeCode = SysTypeCode.PHONE;
    try {
      cardVm.live = new LiveNotification();
      EnvVm.instance.isScreenLock = true;
      const result = cardVm.isNeedShow(live);
      expect(result).assertFalse();
    } catch (e) {
    }
  })
}

function LiveHeadsUpCommonCardVmTest7() {
  it('isNeedShow4', DEFAULT, () => {
    const cardVm = LiveVmInjector.instance.getLiveHeadsUpCommonCardVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    live.typeCode = SysTypeCode.PHONE;
    try {
      cardVm.live = new LiveNotification();
      DropdownVm.instance.statusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
      const result = cardVm.isNeedShow(live);
      expect(result).assertFalse();
    } catch (e) {
    }
  })
}