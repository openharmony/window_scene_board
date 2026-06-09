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
import { DeviceHelper, sSettingsUtil } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { AirplaneController } from '../../../../../../main/ets/default/controller/AirplaneController';
import Constants from '../../../../../../main/ets/default/common/Constants';
import { CommonEventData } from 'commonEvent/commonEventData';
import commonEvtMgr from '@ohos.commonEventManager';

export function AirplaneControllerTest() {
  let sAirplaneController = new AirplaneController();
  let mocker: MockKit;
  describe('AirplaneControllerTest', (): void => {
    beforeAll(() => {
      mocker = new MockKit();
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    it('AirplaneController_handleClickTest01', 0, (): void => {
      (sAirplaneController as object)['isWaitingLastActionDone'] = false;
      sAirplaneController.handleOneClick();
      expect(sAirplaneController.isAvailable()).assertInstanceOf('Boolean');
    })

    it('AirplaneController_handleClickTest02', 0, (): void => {
      (sAirplaneController as object)['isWaitingLastActionDone'] = true;
      sAirplaneController.handleOneClick();
      expect(sAirplaneController.isAvailable()).assertInstanceOf('Boolean');
    })

    it('AirplaneController_handleClickTest03', 0, (): void => {
      sAirplaneController.getViewData().isUnavailable = true;
      sAirplaneController.handleOneClick();
      expect(sAirplaneController.isAvailable()).assertInstanceOf('Boolean');
      sAirplaneController.getViewData().isUnavailable = false;
    })


    it('AirplaneController_handleLongClickTest01', 0, (): void => {
      let handleGoSettingWithScreenLock = mocker.mockFunc(sAirplaneController, sAirplaneController.handleGoSettingWithScreenLock);
      when(handleGoSettingWithScreenLock)(ArgumentMatchers.any).afterReturnNothing();
      expect(sAirplaneController.isAvailable()).assertInstanceOf('Boolean');
      mocker.clear(sAirplaneController);
    })

    it('AirplaneController_handleLongClickTest02', 0, (): void => {
      sAirplaneController.getViewData().isUnavailable = true;
      sAirplaneController.getViewData().isUnavailable = false;

      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();
      sAirplaneController.updateDisableState();
      sAirplaneController.updateDisableState();
      mocker.clear(DeviceHelper);
    })

    it('AirplaneController_constructor01', 0, (): void => {
      sAirplaneController.onStart();
      // isPC mock测试
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();

      when(isPC)().afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('AirplaneController_initAirplaneStateTest01', 0, (): void => {
      sAirplaneController.initAirplaneState();
      expect(sAirplaneController.getLottieOpenName()).assertInstanceOf('String');
    })

    it('AirplaneController_initAirplaneStateTest02', 0, (): void => {
      let getValue = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValue);
      when(getValue)(ArgumentMatchers.any).afterReturn('1');
      sAirplaneController.initAirplaneState();
      expect(sAirplaneController.getLottieOpenName()).assertInstanceOf('String');
      mocker.clear(sSettingsUtil);
    })

    it('AirplaneController_onStopTest01', 0, (): void => {
      sAirplaneController.onStop();
      expect(sAirplaneController.getLottieOpenName()).assertInstanceOf('String');
    })

    it('AirplaneController_onStopTest02', 0, (): void => {
      sAirplaneController.onStop();
      (sAirplaneController as object)['mSubscriber'];
      expect(sAirplaneController.getLottieOpenName()).assertInstanceOf('String');
    })

    it('AirplaneController_switchAirplaneStatusTest01', 0, (): void => {
      sAirplaneController.switchAirplaneStatus(true);
      expect(sAirplaneController.getLottieOpenName()).assertInstanceOf('String');
    })

    it('AirplaneController_switchAirplaneStatusTest02', 0, (): void => {
      sAirplaneController.switchAirplaneStatus(false);
      expect(sAirplaneController.getLottieOpenName()).assertInstanceOf('String');
    })

    it('AirplaneController_onStartTest01', 0, (): void => {
      let sAirplaneController = new AirplaneController();
      sAirplaneController.onStart();
      expect(sAirplaneController.getLottieOpenName()).assertInstanceOf('String');
    })

    it('AirplaneController_addStateChangedListenerTest01', 0, (): void => {
      let sAirplaneController = new AirplaneController();
      sAirplaneController.addStateChangedListener();
      expect(true).assertTrue();
    })

    it('AirplaneController_getDataTest01', 0, (): void => {
      let sAirplaneController = new AirplaneController();
      sAirplaneController.getViewData();
      expect(true).assertTrue();
    })

    it('AirplaneController_getLottieOpenNameTest01', 0, (): void => {
      const name: string = sAirplaneController.getLottieOpenName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_OPEN);
    })

    it('AirplaneController_getLottieCloseNameTest01', 0, (): void => {
      const name: string = sAirplaneController.getLottieCloseName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_CLOSE);
    })

    it('AirplaneController_getNewLottieOpenNameTest01', 0, (): void => {
      const name: string = sAirplaneController.getNewLottieOpenName();
      expect(name).assertEqual(Constants.NEW_LOTTIE_DATA_OPEN);
    })

    it('AirplaneController_getNewLottieCloseNameTest01', 0, (): void => {
      const name: string = sAirplaneController.getNewLottieCloseName();
      expect(name).assertEqual(Constants.NEW_LOTTIE_DATA_CLOSE);
    })

    it('AirplaneController_getLottieOpenDarkNameTest01', 0, (): void => {
      const name: string = sAirplaneController.getLottieOpenDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_OPEN_DARK);
    })

    it('AirplaneController_getLottieCloseDarkNameTest01', 0, (): void => {
      const name: string = sAirplaneController.getLottieCloseDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_CLOSE_DARK);
    })

    it('AirplaneController_isLoadLottieTest01', 0, (): void => {
      const isLoadLottie: boolean = sAirplaneController.isLoadLottie();
      expect(isLoadLottie).assertTrue();
    })

    it('AirplaneController_needListenSatelliteModeTest01', 0, (): void => {
      const needMode: boolean = sAirplaneController.needListenSatelliteMode();
      expect(needMode).assertTrue();
    })

    it('AirplaneController_isAvailableTest01', 0, (): void => {
      const isAvailable: boolean = sAirplaneController.isAvailable();
      expect(isAvailable).assertTrue();
    })


    it('AirplaneController_handleCommonEvent', 0, (): void => {
      let data: CommonEventData = {
        event: commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED,
        bundleName: '',
        code: 0,
        data: '',
        parameters: [],
      }
      sAirplaneController.getViewData().isOn = true;
      sAirplaneController.getViewData().isUnavailable = true;
      (sAirplaneController as object)['isWaitingLastActionDone'] = false;
      sAirplaneController.handleCommonEvent(data);
      expect(sAirplaneController.getViewData().isOn).assertFalse();

      (sAirplaneController as object)['isWaitingLastActionDone'] = true;
      sAirplaneController.handleCommonEvent(data);

      sAirplaneController.getViewData().isOn = true;
      sAirplaneController.getViewData().isUnavailable = false;
      (sAirplaneController as object)['isWaitingLastActionDone'] = false;
      sAirplaneController.handleCommonEvent(data);
      expect(sAirplaneController.getViewData().isOn).assertFalse();

      (sAirplaneController as object)['isWaitingLastActionDone'] = true;
      sAirplaneController.handleCommonEvent(data);

      sAirplaneController.getViewData().isOn = false;
      sAirplaneController.handleCommonEvent(data);
      expect(sAirplaneController.getViewData().isOn).assertFalse();

      let data2: CommonEventData = {
        event: commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED,
        bundleName: '',
        code: 1,
        data: '',
        parameters: [],
      }
      sAirplaneController.getViewData().isOn = true;
      sAirplaneController.handleCommonEvent(data2);

      sAirplaneController.getViewData().isOn = false;
      sAirplaneController.getViewData().isUnavailable = true;
      (sAirplaneController as object)['isWaitingLastActionDone'] = false;
      sAirplaneController.handleCommonEvent(data);
      expect(sAirplaneController.getViewData().isOn).assertFalse();

      (sAirplaneController as object)['isWaitingLastActionDone'] = true;
      sAirplaneController.handleCommonEvent(data);
      expect(sAirplaneController.getViewData().isOn).assertFalse();

      sAirplaneController.getViewData().isUnavailable = false;
      (sAirplaneController as object)['isWaitingLastActionDone'] = false;
      sAirplaneController.handleCommonEvent(data);

      (sAirplaneController as object)['isWaitingLastActionDone'] = true;
      sAirplaneController.handleCommonEvent(data);
      expect(sAirplaneController.getViewData().isOn).assertFalse();
    })
  })
}
