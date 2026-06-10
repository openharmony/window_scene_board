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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  DEFAULT,
} from '@ohos/hypium';
import Constants from '../../../../../../../main/ets/com/ohos/common/Constants';
import { BluetoothController } from '../../../../../../../main/ets/com/ohos/controller/BluetoothController';

export function BluetoothControllerTest01() {
  const sBluetoothController: BluetoothController = new BluetoothController();
  describe('BluetoothControllerTest01', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('BluetoothController_initBluetoothControllerTest01', DEFAULT, (): void => {
      const bluetoothController: BluetoothController = new BluetoothController();
      expect(bluetoothController instanceof BluetoothController).assertTrue();
    })

    it('BluetoothController_getLottieOpenDarkNameTest01', DEFAULT, (): void => {
      const name: string = sBluetoothController.getLottieOpenDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_OPEN_DARK);
    })

    it('BluetoothController_getLottieCloseDarkNameTest01', DEFAULT, (): void => {
      const name: string = sBluetoothController.getLottieCloseDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_CLOSE_DARK);
    })

    it('BluetoothController_getLottieOpenNameTest01', DEFAULT, (): void => {
      const name: string = sBluetoothController.getLottieOpenName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_OPEN);
    })

    it('BluetoothController_getLottieCloseNameTest01', DEFAULT, (): void => {
      const name: string = sBluetoothController.getLottieCloseName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_CLOSE);
    })

    it('BluetoothController_getLottieDarkNameTest01', DEFAULT, (): void => {
      const name: string = sBluetoothController.getLottieDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_OPEN_DARK);
    })
  })
}

export function BluetoothControllerTest02() {
  const sBluetoothController: BluetoothController = new BluetoothController();
  describe('BluetoothControllerTest02', (): void => {
    it('BluetoothController_getNewLottieOpenNameTest01', DEFAULT, (): void => {
      const name: string = sBluetoothController.getNewLottieOpenName();
      expect(name).assertEqual(Constants.NEW_LOTTIE_DATA_OPEN);
    })

    it('BluetoothController_getNewLottieCloseNameTest01', DEFAULT, (): void => {
      const name: string = sBluetoothController.getNewLottieCloseName();
      expect(name).assertEqual(Constants.NEW_LOTTIE_DATA_CLOSE);
    })

    it('BluetoothController_isLoadLottieTest01', DEFAULT, (): void => {
      const isLoadLottie: boolean = sBluetoothController.isLoadLottie();
      expect(isLoadLottie).assertTrue();
    })

    it('BluetoothController_getSbPluginSlotTest01', DEFAULT, (): void => {
      const slot = sBluetoothController.getSbPluginSlot();
      expect(slot).assertInstanceOf('String');
    })

    it('BluetoothController_isAvailableTest01', DEFAULT, (): void => {
      const isAvailable: boolean = sBluetoothController.isAvailable();
      expect(isAvailable).assertTrue();
    })
  })
}
