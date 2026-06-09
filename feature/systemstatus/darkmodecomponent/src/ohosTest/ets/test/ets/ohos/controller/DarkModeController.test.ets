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
import Constants from '../../../../../../main/ets/com/ohos/common/Constants';
import { DarkModeController } from '../../../../../../main/ets/com/ohos/controller/DarkModeController';


export function DarkModeControllerTest() {
  let mocker: MockKit;
  describe('DarkModeControllerTest', (): void => {
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

    it('DarkModeController_handleLongClickTest01', 0, (): void => {
      let handleGoSettingWithScreenLock = mocker.mockFunc(DarkModeController, new DarkModeController().handleGoSettingWithScreenLock);
      when(handleGoSettingWithScreenLock)(ArgumentMatchers.any).afterReturnNothing();
      // isPC mock测试
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();

      when(isPC)().afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      mocker.clear(DarkModeController);
    })


    it('DarkModeController_setDarkModeStateTest01', 0, (): void => {
      let status: boolean = new DarkModeController().mDarkModeData.status;
      (new DarkModeController() as object)['setDarkModeState'](true);
      expect(status).assertInstanceOf('Boolean');
      (new DarkModeController() as object)['setDarkModeState'](false);
      expect(status).assertInstanceOf('Boolean');
      expect(new DarkModeController().getLottieOpenName()).not().assertNull();
      expect(new DarkModeController().getLottieCloseName()).not().assertNull();
      expect(new DarkModeController().getLottieDarkName()).not().assertNull();
      expect(new DarkModeController().getLottieOpenDarkName()).not().assertNull();
      expect(new DarkModeController().getLottieCloseDarkName()).not().assertNull();
      expect(new DarkModeController().getNewLottieOpenName()).not().assertNull();
      expect(new DarkModeController().getNewLottieCloseName()).not().assertNull();
      expect(new DarkModeController().isLoadLottie()).assertTrue();
      new DarkModeController().addStateChangedListener();
      new DarkModeController().removeStateChangedListener();
      expect(new DarkModeController().isAvailable()).assertTrue();
      new DarkModeController().onStop();
    })

    it('DarkModeController_handleClick01', 0, (): void => {
      let darkModeController: DarkModeController = new DarkModeController();
      (darkModeController as object)['isLockDarkMode'] = false;
      darkModeController.handleOneClick();
      (darkModeController as object)['isLockDarkMode'] = true;
      darkModeController.handleOneClick();
      expect(darkModeController).not().assertFalse();
    })

    it('DarkModeController_handleLongClick01', 0, (): void => {
      let handleGoSettingWithScreenLock = mocker.mockFunc(DarkModeController, new DarkModeController().handleGoSettingWithScreenLock);
      when(handleGoSettingWithScreenLock)(ArgumentMatchers.any).afterReturnNothing();
      // isPC mock测试
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();

      when(isPC)().afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      mocker.clear(DarkModeController);
      mocker.clear(DeviceHelper);
    })

    it('DarkModeControllerTest_getLottieOpenName', 0, (): void => {
      (new DarkModeController() as object)['goSettings']();
      (new DarkModeController() as object)['switchColorModeStatus'](true);
      (new DarkModeController() as object)['switchColorModeStatus'](false);
      (new DarkModeController() as object)['switchHighContrastText'](false);
      let openName = new DarkModeController().getLottieOpenName();
      expect(openName).assertEqual(Constants.LOTTIE_DATA_OPEN);
      let closeName = new DarkModeController().getLottieCloseName();
      expect(closeName).assertEqual(Constants.LOTTIE_DATA_CLOSE);
      let darkName = new DarkModeController().getLottieDarkName();
      expect(darkName).assertEqual(Constants.LOTTIE_DATA_OPEN_DARK);
    })

    it('DarkModeControllerTest_setDarkModeState', 0, (): void => {
      new DarkModeController().addStateChangedListener();
      (new DarkModeController() as object)['darkModeEvent'].isDarkMode = false;
      (new DarkModeController() as object)['setDarkModeState'](true);
      expect(new DarkModeController().mDarkModeData.status).assertTrue();
      new DarkModeController().removeStateChangedListener();
      new DarkModeController().onStop();
    })

    it('DarkModeControllerTest_handleClick', 0, (): void => {
      let darkModeController: DarkModeController = new DarkModeController();
      (darkModeController as object)['isLockDarkMode'] = true;
      darkModeController.handleOneClick();
      (new DarkModeController() as object)['isLockDarkMode'] = false;
      darkModeController.handleOneClick();
      expect(darkModeController).not().assertFalse();
    })

    it('DarkModeControllerTest_handleLongClick_1', 0, (): void => {
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)().afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();
      mocker.clear(DeviceHelper);
    })

    it('DarkModeControllerTest_handleLongClick_2', 0, (): void => {
      let notPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(notPC)().afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      mocker.clear(DeviceHelper);
    })
  })
}