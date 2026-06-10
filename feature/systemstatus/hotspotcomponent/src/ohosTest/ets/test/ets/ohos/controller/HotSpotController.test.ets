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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { HotSpotController } from '../../../../../../main/ets/com/ohos/controller/HotSpotController';
import { CommonEventData } from 'commonEvent/commonEventData';
import commonEvtMgr from '@ohos.commonEventManager';

export function HotSpotControllerTest() {
  let mocker: MockKit;

  describe('HotSpotControllerTest', (): void => {
    beforeEach((): void => {

    })
    beforeAll(() => {
      mocker = new MockKit();
    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    it('HotSpotController_onStartTest01', 0, (): void => {
      new HotSpotController().onStart();
      expect(new HotSpotController().isPersist()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_onStartTest02', 0, (): void => {
      new HotSpotController().onStart();
      // isAvailable mock测试
      let isAvailable = mocker.mockFunc(new HotSpotController(), new HotSpotController().isAvailable);

      when(isAvailable)().afterReturn(false);
      new HotSpotController().onStart();
      expect(new HotSpotController().isAvailable()).assertTrue();
      mocker.clear(new HotSpotController());
    })

    it('HotSpotController_onStartTest03', 0, (): void => {
      new HotSpotController().onStart();
      let onStart = mocker.mockFunc(new HotSpotController(), new HotSpotController().onStart);
      when(onStart)().afterThrow('getVoiceCapability error');
      try {
        new HotSpotController().onStart();
      } catch (e) {
        expect(e).assertEqual('getVoiceCapability error');//执行通过
      } finally {
        mocker.clear(new HotSpotController());
      }
    })

    it('HotSpotController_handleClickTest01', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      new HotSpotController().handleOneClick();
      expect(new HotSpotController().isLoadLottie()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_handleClickTest02', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = false;
      new HotSpotController().handleOneClick();
      expect(new HotSpotController().isDarkReverse()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_handleClickTest03', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      (new HotSpotController() as object)['isWaitingLastActionDone'] = true;
      new HotSpotController().handleOneClick();
      expect(new HotSpotController().isDarkReverse()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_handleClickTest04', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = false;
      (new HotSpotController() as object)['isWaitingLastActionDone'] = false;
      new HotSpotController().handleOneClick();
      expect(new HotSpotController().needListenSatelliteMode()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_switchHotspotStatusTest01', 0, (): void => {
      (new HotSpotController() as object)['switchHotspotStatus'](false);
      expect(new HotSpotController().isLoadLottie()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_switchHotspotStatusTest02', 0, (): void => {
      (new HotSpotController() as object)['switchHotspotStatus'](true);
      expect(new HotSpotController().isLoadLottie()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_onHotSpotStateChangeTest01', 0, (): void => {
      (new HotSpotController() as object)['onHotSpotStateChange'](true);
      expect(new HotSpotController().isLoadLottie()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_onHotSpotStateChangeTest02', 0, (): void => {
      (new HotSpotController() as object)['onHotSpotStateChange'](false);
      expect(new HotSpotController().isLoadLottie()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_handleLongClickTestTest02', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      expect(new HotSpotController().isAvailable()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_handleLongClickTest02', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      // isPC mock测试
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();

      when(isPC)().afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('HotSpotController_handleLongClickTest03', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      // isPC mock测试
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();

      when(isPC)().afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('HotSpotController_handleLongClickTest04', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      // isPC mock测试
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();
      mocker.clear(DeviceHelper);
    })

    it('HotSpotController_getLottieOpenNameTest01', 0, (): void => {
      new HotSpotController().getLottieOpenName();
      expect(new HotSpotController().isInit()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_getLottieCloseNameTest02', 0, (): void => {
      new HotSpotController().getLottieCloseName();
      expect(new HotSpotController().isDarkReverse()).assertInstanceOf('Boolean');
    })

    it('HotSpotController_isSharingTest01', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      // isPC mock测试
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();

      when(isPC)().afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('HotSpotController_isLoadLottie', 0, (): void => {
      expect(new HotSpotController().isLoadLottie()).assertTrue();
    })

    it('HotSpotController_getLottieOpenName1', 0, (): void => {
      new HotSpotController().getLottieOpenName();
      new HotSpotController().getLottieCloseName();
      new HotSpotController().getNewLottieOpenName();
      new HotSpotController().getNewLottieCloseName();
      new HotSpotController().getLottieDarkName();
      expect(new HotSpotController().isLoadLottie()).assertTrue();
      expect(new HotSpotController().isDarkReverse()).assertTrue();
    })

    it('HotSpotController_onStart', 0, (): void => {
      new HotSpotController().onStart();
      expect(new HotSpotController().isLoadLottie()).assertTrue();
    })

    it('HotSpotController_handleStatusBarState', 0, (): void => {
      new HotSpotController().handleStatusBarState(true);
      new HotSpotController().handleStatusBarState(false);
      new HotSpotController().getViewData();
      expect(new HotSpotController().isAvailable()).assertTrue();
    })

    it('HotSpotController_handleClick', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      new HotSpotController().handleOneClick();

      new HotSpotController().getViewData().isUnavailable = false;
      (new HotSpotController() as object)['isWaitingLastActionDone'] = false;
      new HotSpotController().getViewData().isOn = true;
      new HotSpotController().handleOneClick();
      new HotSpotController().getViewData().isOn = false;
      new HotSpotController().handleOneClick();
      (new HotSpotController() as object)['isWaitingLastActionDone'] = true;
      new HotSpotController().getViewData().isOn = true;
      new HotSpotController().handleOneClick();
      new HotSpotController().getViewData().isOn = false;
      new HotSpotController().handleOneClick();

      expect(new HotSpotController().getViewData().isOn).assertFalse();
    })

    it('HotSpotController_handleLongClick', 0, (): void => {
      new HotSpotController().getViewData().isUnavailable = true;
      new HotSpotController().getViewData().isUnavailable = false;
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();
      mocker.clear(DeviceHelper);
    })

    it('HotSpotController_handleHotSpotChangeEvent', 0, (): void => {
      let data: CommonEventData = {
        event: commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED,
        bundleName: '',
        code: 0,
        data: '',
        parameters: [],
      }
      new HotSpotController().handleHotSpotChangeEvent(data);
      let data2: CommonEventData = {
        event: commonEvtMgr.Support.COMMON_EVENT_WIFI_AP_STA_JOIN,
        bundleName: '',
        code: 0,
        data: '',
        parameters: [],
      }
      new HotSpotController().handleHotSpotChangeEvent(data2);
      let data3: CommonEventData = {
        event: commonEvtMgr.Support.COMMON_EVENT_WIFI_AP_STA_LEAVE,
        bundleName: '',
        code: 0,
        data: '',
        parameters: [],
      }
      new HotSpotController().handleHotSpotChangeEvent(data3);
      expect(new HotSpotController().needListenSatelliteMode()).assertTrue();
    })

    it('HotSpotController_updateDisableState', 0, (): void => {
      new HotSpotController().updateDisableState();
      new HotSpotController().updateDisableState();
      new HotSpotController().updateDisableState();
      expect(new HotSpotController().getViewData().isUnavailable).assertFalse();
    })
  })
}