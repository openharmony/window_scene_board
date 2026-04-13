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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when } from '@ohos/hypium';
import { FlashlightController } from '../../../../../../../main/ets/com/ohos/controller/FlashlightController';
import Constants, { FlashlightData } from '../../../../../../../main/ets/com/ohos/common/Constants';


export function FlashLightControllerTest01() {
  let mocker: MockKit;

  describe('FlashLightControllerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    let sFlashlightController = FlashlightController.getInstance();
    it('onStart_01', 0, (): void => {
      sFlashlightController.onStart();
      sFlashlightController.onStop();
      expect(sFlashlightController.handleOneClick()).assertInstanceOf('Boolean');
    })

    it('onStart_02', 0, (): void => {
      sFlashlightController.onStart();
      sFlashlightController.onStop();

      const isAvailable = mocker.mockFunc(sFlashlightController, sFlashlightController.isAvailable);

      when(isAvailable)().afterReturn(false);
      sFlashlightController.onStart();
      sFlashlightController.onStop();
      expect(sFlashlightController.isAvailable()).assertFalse();
      mocker.clear(sFlashlightController);
    })

    it('isAvailable', Level.LEVEL0, (): void => {
      const isAvailable: boolean = sFlashlightController.isAvailable();

      expect(isAvailable).assertTrue();
    })

    it('getSwitchAvailable_01', Level.LEVEL0, (): void => {
      const mFlashlightDataCache: FlashlightData = (sFlashlightController as object)['mFlashlightDataCache'];
      mFlashlightDataCache.isUnavailable = true;

      expect(sFlashlightController.getSwitchAvailable()).assertEqual(10080001);
    })

    it('getSwitchAvailable_02', Level.LEVEL0, (): void => {
      const mFlashlightDataCache: FlashlightData = (sFlashlightController as object)['mFlashlightDataCache'];
      mFlashlightDataCache.isUnavailable = false;

      expect(sFlashlightController.getSwitchAvailable()).assertEqual(0);
    })

    it('setSwitchState_01', Level.LEVEL0, (): void => {
      expect(sFlashlightController.setSwitchState(true)).assertTrue();
    })

    it('setSwitchState_02', Level.LEVEL0, (): void => {
      expect(sFlashlightController.setSwitchState('false')).assertTrue();
    })
  })
}

export function FlashLightControllerTest02() {
  describe('FlashLightControllerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it ('getLottieOpenDarkName', Level.LEVEL0, (): void => {
      const lottieOpenDarkName = sFlashlightController.getLottieOpenDarkName();

      expect(lottieOpenDarkName).assertEqual(Constants.LOTTIE_DATA_OPEN_DARK);
    });

    it ('getLottieCloseDarkName', Level.LEVEL0, (): void => {
      const lottieCloseDarkName = sFlashlightController.getLottieCloseDarkName();
      expect(lottieCloseDarkName).assertEqual(Constants.LOTTIE_DATA_CLOSE_DARK);
    });

    it ('getNewLottieOpenName', Level.LEVEL0, (): void => {
      const newLottieOpenName = sFlashlightController.getNewLottieOpenName();
      expect(newLottieOpenName).assertEqual(Constants.NEW_LOTTIE_DATA_OPEN);
    });

    it ('getNewLottieCloseName', Level.LEVEL0, (): void => {
      const newLottieCloseName = sFlashlightController.getNewLottieCloseName();
      expect(newLottieCloseName).assertEqual(Constants.NEW_LOTTIE_DATA_CLOSE);
    });

    it('isLoadLottie', Level.LEVEL0, (): void => {
      const isLoadLottie: boolean = sFlashlightController.isLoadLottie();

      expect(isLoadLottie).assertTrue();
    })

    it('isDarkReverse', Level.LEVEL0, (): void => {
      const isDarkReverse: boolean = sFlashlightController.isDarkReverse();

      expect(isDarkReverse).assertTrue();
    })
  })
}