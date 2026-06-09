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
import { LiveItemBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { ILiveCapsuleVm } from '../../../../main/ets/live/interface/ILiveCapsuleVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { CapsuleShowType, LiveType } from '../../../../main/ets/live/model/LiveCommonModel';
import { ILiveCapsuleMarqueeVm } from '../../../../main/ets/live/interface/ILiveCapsuleMarqueeVm';
import { DeviceInfoVm } from '../../../../main/ets/vm/DeviceInfoVm';
import { EnvVm } from '../../../../main/ets/vm/EnvVm';
import { CutoutVm } from '../../../../main/ets/statusbar/vm/CutoutVm';
import { ClickNotificationMaintenance } from '../../../../main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../main/ets/maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../../../../main/ets/live/sysEvent/LiveHiSysEvent';
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
  ArgumentMatchers
} from '@ohos/hypium';
import { LiveCapsuleVm } from '../../../../main/ets/live/vm/LiveCapsuleVm';

export default function LiveCapsuleInfoVmTest() {
  describe('isTempDisplay_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_live_type_is_instant', 0, () => {
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.type = LiveType.INSTANT;
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.live = live;
      expect(livecapsulevm.isTempDisplay).assertEqual(true);
    });

    it('should_return_false_when_live_type_is_not_instant', 0, () => {
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.type = LiveType.NORMAL;
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.live = live;
      expect(livecapsulevm.isTempDisplay).assertEqual(false);
    });
  });

  describe('contentColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_isTempDisplay_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isTempDisplay = true;
      const result = livecapsulevm.contentColor;
      expect(result).assertUndefined();
    });

    it('should_return_backgroundColor_when_isTempDisplay_is_false_and_backgroundColor_is_not_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isTempDisplay = false;
      livecapsulevm.live.capsule = {
        backgroundColor: 'rgba(0, 0, 0, 0)'
      };
      const result = livecapsulevm.contentColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0)');
    });

    it('should_return_LiveStyle_CAPSULE_CONTENT_COLOR_when_isTempDisplay_is_false_and_backgroundColor_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isTempDisplay = false;
      livecapsulevm.live.capsule = {
        backgroundColor: null
      };
      const result = livecapsulevm.contentColor;
      expect(result).assertEqual(LiveStyle.CAPSULE_CONTENT_COLOR);
    });
  });

  describe('containerColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_isTempDisplay_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isTempDisplay = true;
      const result = livecapsulevm.containerColor;
      expect(result).assertUndefined();
    });

    it('should_return_LiveStyle_CAPSULE_SHADOW_COLOR_when_showType_is_SHADOW', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.showType = CapsuleShowType.SHADOW;
      const result = livecapsulevm.containerColor;
      expect(result).assertEqual(LiveStyle.CAPSULE_SHADOW_COLOR);
    });

    it('should_return_backgroundColor_when_isCakeShow_is_false_and_live_capsule_has_backgroundColor', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isCakeShow = false;
      livecapsulevm.live.capsule = {
        backgroundColor: 'rgba(0, 0, 0, 0.1)'
      };
      const result = livecapsulevm.containerColor;
      expect(result).assertEqual('rgba(0, 0, 0, 0.1)');
    });

    it('should_return_LiveStyle_CAPSULE_CONTENT_COLOR_when_isCakeShow_is_false_and_live_capsule_has_no_backgroundColor', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isCakeShow = false;
      livecapsulevm.live.capsule = {
        backgroundColor: undefined
      };
      const result = livecapsulevm.containerColor;
      expect(result).assertEqual(LiveStyle.CAPSULE_CONTENT_COLOR);
    });

    it('should_return_LiveStyle_CAPSULE_CONTAINER_COLOR_when_isCakeShow_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.isCakeShow = true;
      const result = livecapsulevm.containerColor;
      expect(result).assertEqual(LiveStyle.CAPSULE_CONTAINER_COLOR);
    });
  });

  describe('showWave_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_live_type_is_instant', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.type = LiveType.INSTANT;
      livecapsulevm.live = live;
      expect(livecapsulevm.showWave).assertEqual(false);
    });

    it('should_return_false_when_live_capsule_isProgress_is_false', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.type = LiveType.NORMAL;
      live.capsule = {
        isProgress: () => false
      } as ILiveCapsuleVm;
      livecapsulevm.live = live;
      expect(livecapsulevm.showWave).assertEqual(false);
    });

    it('should_return_true_when_live_capsule_isProgress_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.type = LiveType.NORMAL;
      live.capsule = {
        isProgress: () => true
      } as ILiveCapsuleVm;
      livecapsulevm.live = live;
      expect(livecapsulevm.showWave).assertEqual(true);
    });

    it('should_return_false_when_live_capsule_isProgress_is_undefined', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      live.type = LiveType.NORMAL;
      live.capsule = {
        isProgress: undefined
      } as ILiveCapsuleVm;
      livecapsulevm.live = live;
      expect(livecapsulevm.showWave).assertEqual(false);
    });
  });

  describe('icon_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_live_icon_when_live_capsule_icon_is_not_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      liveItemBaseVm.live.capsule = { icon: 'testIcon' } as ILiveCapsuleVm;
      liveItemBaseVm.live.appIcon = 'appIcon';
      livecapsulevm.live = liveItemBaseVm.live;
      expect(livecapsulevm.icon).assertEqual('testIcon');
    });

    it('should_return_live_appIcon_when_live_capsule_icon_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      liveItemBaseVm.live.capsule = {} as ILiveCapsuleVm;
      liveItemBaseVm.live.appIcon = 'appIcon';
      livecapsulevm.live = liveItemBaseVm.live;
      expect(livecapsulevm.icon).assertEqual('appIcon');
    });

    it('should_return_live_appIcon_when_live_capsule_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      liveItemBaseVm.live.capsule = null as ILiveCapsuleVm;
      liveItemBaseVm.live.appIcon = 'appIcon';
      livecapsulevm.live = liveItemBaseVm.live;
      expect(livecapsulevm.icon).assertEqual('appIcon');
    });

    it('should_return_live_appIcon_when_live_capsule_and_appIcon_are_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      liveItemBaseVm.live.capsule = null as ILiveCapsuleVm;
      liveItemBaseVm.live.appIcon = null as string;
      livecapsulevm.live = liveItemBaseVm.live;
      expect(livecapsulevm.icon).assertUndefined();
    });
  });

  describe('button_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_live_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.live = null;
      expect(livecapsulevm.button).assertUndefined();
    });

    it('should_return_button_when_live_is_not_null_and_has_button', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let live: ILiveCapsuleVm = new LiveItemBaseVm();
      let button: any = { name: 'testButton' };
      live.capsule = { button: button };
      livecapsulevm.live = live;
      expect(livecapsulevm.button).assertDeepEquals(button);
    });

    it('should_return_undefined_when_live_is_not_null_and_has_no_button', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let live: ILiveCapsuleVm = new LiveItemBaseVm();
      live.capsule = null;
      livecapsulevm.live = live;
      expect(livecapsulevm.button).assertUndefined();
    });
  });

  describe('buttonIcon_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_lightIcon_when_isDarkMode_is_false', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.button = { lightIcon: 'lightIcon', darkIcon: 'darkIcon' };
      EnvVm.instance.isDarkMode = false;
      expect(livecapsulevm.buttonIcon).assertEqual('lightIcon');
    });

    it('should_return_darkIcon_when_isDarkMode_is_true', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.button = { lightIcon: 'lightIcon', darkIcon: 'darkIcon' };
      EnvVm.instance.isDarkMode = true;
      expect(livecapsulevm.buttonIcon).assertEqual('darkIcon');
    });

    it('should_return_undefined_when_button_is_null', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      livecapsulevm.button = null;
      EnvVm.instance.isDarkMode = false;
      expect(livecapsulevm.buttonIcon).assertUndefined();
    });
  });

  describe('marqueeVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_marqueeVm_when_live_type_is_ capsule', 0, async () => {
      let liveCapsuleVm: LiveCapsuleVm = new LiveCapsuleVm();
      liveCapsuleVm.live.type = LiveType.capsule;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveCapsuleVm.vmInjector, liveCapsuleVm.vmInjector.getCapsuleMarqueeVm);
      let marqueeVm: ILiveCapsuleMarqueeVm = {} as ILiveCapsuleMarqueeVm;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(marqueeVm);
      const result = liveCapsuleVm.marqueeVm;
      expect(result).assertEqual(marqueeVm);
      mocker.ignoreMock(liveCapsuleVm.vmInjector, liveCapsuleVm.vmInjector.getCapsuleMarqueeVm);
    });

    it('should_return_correct_marqueeVm_when_live_type_is_ instant', 0, async () => {
      let liveCapsuleVm: LiveCapsuleVm = new LiveCapsuleVm();
      liveCapsuleVm.live.type = LiveType.instant;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveCapsuleVm.vmInjector, liveCapsuleVm.vmInjector.getCapsuleMarqueeVm);
      let marqueeVm: ILiveCapsuleMarqueeVm = {} as ILiveCapsuleMarqueeVm;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(marqueeVm);
      const result = liveCapsuleVm.marqueeVm;
      expect(result).assertEqual(marqueeVm);
      mocker.ignoreMock(liveCapsuleVm.vmInjector, liveCapsuleVm.vmInjector.getCapsuleMarqueeVm);
    });

    it('should_return_correct_marqueeVm_when_live_type_is_ unknown', 0, async () => {
      let liveCapsuleVm: LiveCapsuleVm = new LiveCapsuleVm();
      liveCapsuleVm.live.type = LiveType.unknown;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveCapsuleVm.vmInjector, liveCapsuleVm.vmInjector.getCapsuleMarqueeVm);
      let marqueeVm: ILiveCapsuleMarqueeVm = {} as ILiveCapsuleMarqueeVm;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(marqueeVm);
      const result = liveCapsuleVm.marqueeVm;
      expect(result).assertEqual(marqueeVm);
      mocker.ignoreMock(liveCapsuleVm.vmInjector, liveCapsuleVm.vmInjector.getCapsuleMarqueeVm);
    });

  });

  describe('isShowProgress_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_live_is_charge_and_capsule_is_progress', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      let mockIsCharge: Function = mocker.mockFunc(live, live.isCharge);
      when(mockIsCharge)().afterReturn(true);
      livecapsulevm.live = live;
      let capsule: ILiveCapsuleVm = {
        isProgress: () => true
      };
      livecapsulevm.live.capsule = capsule;
      const result = livecapsulevm.isShowProgress;
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isCharge);
    });

    it('should_return_false_when_live_is_not_charge_or_capsule_is_not_progress', 0, () => {
      let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
      let mocker: MockKit = new MockKit();
      let live: LiveItemBaseVm = new LiveItemBaseVm();
      let mockIsCharge: Function = mocker.mockFunc(live, live.isCharge);
      when(mockIsCharge)().afterReturn(false);
      livecapsulevm.live = live;
      let capsule: ILiveCapsuleVm = {
        isProgress: () => false
      };
      livecapsulevm.live.capsule = capsule;
      const result = livecapsulevm.isShowProgress;
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isCharge);
    });
  });
}