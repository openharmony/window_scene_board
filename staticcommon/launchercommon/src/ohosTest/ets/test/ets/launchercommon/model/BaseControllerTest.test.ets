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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import BrightnessController
  from '../../../../../../../../../feature/controlcentercomponent/src/main/ets/com/ohos/viewModel/BrightnessController';

export default function BaseControllerTest() {

  describe('BaseControllerTest', (): void => {
    let callback: (value: object) => void;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_removeAllLottieData_return', 0, (): void => {
      BrightnessController.removeAllLottieData();
      expect(BrightnessController.isAlreadyLoadLottie).assertEqual(false);
    })

    it('test_initAllLottieData_return', 0, (): void => {
      BrightnessController.initAllLottieData();
      expect(BrightnessController.isAlreadyLoadLottie).assertEqual(true);
    })

    it('test_isDarkReverse_return', 0, (): void => {
      let result = BrightnessController.isDarkReverse();
      expect(result).assertEqual(false);
    })

    it('test_getOpenLottieData_return', 0, (): void => {
      let records: Record<string, object> = {};
      let result = BrightnessController.getOpenLottieData();
      expect(!result).assertTrue();
    })

    it('test_getCloseLottieData_return', 0, (): void => {
      let records: Record<string, object> = {};
      let result = BrightnessController.getCloseLottieData();
      expect(!result).assertTrue();
    })

    it('test_matchLottieData_return-one', 0, (): void => {
      let records: Record<string, object> = {};
      let isDarkMode: boolean = true;
      let result = BrightnessController.matchLottieData(isDarkMode);
      expect(!result).assertFalse();
    })

    it('test_matchLottieData_return-two', 0, (): void => {
      let records: Record<string, object> = {};
      let isDarkMode: boolean = false;
      let result = BrightnessController.matchLottieData(isDarkMode);
      expect(!result).assertFalse();
    })

    it('test_getLottieOpenName_return', 0, (): void => {
      let result = BrightnessController.getLottieOpenName();
      expect(result).assertEqual('');
    })

    it('test_getLottieCloseName_return', 0, (): void => {
      BrightnessController.getNewLottieOpenName();
      let result = BrightnessController.getLottieCloseName();
      expect(result).assertEqual('');
    })

    it('test_getNewLottieCloseName_return', 0, (): void => {
      let result = BrightnessController.getNewLottieCloseName();
      expect(result).assertEqual('');
    })

    it('test_getLottieDarkName_return', 0, (): void => {
      let result = BrightnessController.getLottieDarkName();
      expect(result).assertEqual('');
    })

    it('test_getLottieOpenDarkName_return', 0, (): void => {
      let result = BrightnessController.getLottieOpenDarkName();
      expect(result).assertEqual('');
    })

    it('test_getLottieCloseDarkName_return', 0, (): void => {
      let result = BrightnessController.getLottieCloseDarkName();
      expect(result).assertEqual('');
    })

    it('test_isLoadLottie_return', 0, (): void => {
      let result = BrightnessController.isLoadLottie();
      expect(result).assertEqual(true);
    })

    it('test_loadLottieData_return', 0, (): void => {
      let jsonName: string = 'res';
      BrightnessController.loadLottieData(jsonName, callback);
      expect(jsonName).assertEqual('res');
    })

    it('test_needListenSatelliteMode_return', 0, (): void => {
      let result = BrightnessController.needListenSatelliteMode();
      expect(result).assertEqual(false);
    })

    it('test_updateDisableState_return', 0, (): void => {
      BrightnessController.updateDisableState();
      BrightnessController.onStart();
      BrightnessController.onStop();
      BrightnessController.handleUpdateState();
      BrightnessController.getData();
      BrightnessController.isAvailable();
      let result = BrightnessController.getSbPluginSlot();
      expect(result).assertEqual('');
    })

    it('test_addStateChangedListener_return', 0, (): void => {
      BrightnessController.addStateChangedListener();
      BrightnessController.removeStateChangedListener();
      let result = BrightnessController.isAvailable();
      expect(result).not().assertNull();
    })

    it('test_handleLongClick_return', 0, (): void => {
      let result = BrightnessController.handleLongClick();
      expect(result).assertEqual(false);
    })

    it('test_handleLongClick_return', 0, (): void => {
      let slot: string = '';
      let result = BrightnessController.handleLabelClick(slot);
      expect(result).assertEqual(false);
    })

    it('test_handleHover_return', 0, (): void => {
      let isHover: boolean = true;
      BrightnessController.handleHover(isHover);
      let handle: Function = () => {
        return true
      };
      expect(handle()).assertEqual(true);
    })

    it('test_handleGoSettingWithScreenLock_return', 0, (): void => {
      let handle: Function = () => {
        return true
      };
      BrightnessController.handleGoSettingWithScreenLock(handle);
      expect(handle()).assertEqual(true);
    })

    it('test_goSettingWithDelay_return', 0, (): void => {
      let delay: number = 3;
      BrightnessController.goSettingWithDelay(delay);
      expect(delay).assertEqual(3);
    })

    it('test_requestUnlock_return-false', 0, (): void => {
      let beforeUnlock: boolean = false;
      let handle: Function = () => {
        return true
      };
      BrightnessController.requestUnlock(handle, beforeUnlock);
      expect(handle()).assertEqual(true);
    })

    it('test_requestUnlock_return-true', 0, (): void => {
      let beforeUnlock: boolean = true;
      let handle: Function = () => {
        return true
      };
      BrightnessController.requestUnlock(handle, beforeUnlock);
      expect(handle()).assertEqual(true);
    })

    it('test_handleOnControlCenterWithScreenLock_return-true', 0, (): void => {
      let beforeUnlock: boolean = true;
      let handle: Function = () => {
        return true
      };
      BrightnessController.handleOnControlCenterWithScreenLock(handle, beforeUnlock);
      expect(handle()).assertEqual(true);
    })
  })
}