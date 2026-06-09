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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT } from '@ohos/hypium';
import Constants, { AutoRotateData } from '../../../../../../../main/ets/com/ohos/common/Constants';
import { AutoRotateController } from '../../../../../../../main/ets/com/ohos/controller/AutoRotateController';

export function AutoRotateComponentTest01() {
  describe('AutoRotateComponentTest01', (): void => {
    let sAutoRotateController = new AutoRotateController();
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('AutoRotateComponent_initAutoRotateControllerTest01', DEFAULT, (): void => {
      const autoRotateController: AutoRotateController = new AutoRotateController();
      expect(autoRotateController instanceof AutoRotateController).assertTrue();
    })

    it('AutoRotateComponent_getLottieOpenDarkNameTest01', DEFAULT, (): void => {
      const name: string = sAutoRotateController.getLottieOpenDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_OPEN_DARK);
    })

    it('AutoRotateComponent_getLottieCloseDarkNameTest01', DEFAULT, (): void => {
      const name: string = sAutoRotateController.getLottieCloseDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_CLOSE_DARK);
    })

    it('AutoRotateComponent_getLottieOpenNameTest01', DEFAULT, (): void => {
      const name: string = sAutoRotateController.getLottieOpenName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_OPEN);
    })

    it('AutoRotateComponent_getLottieCloseNameTest01', DEFAULT, (): void => {
      const name: string = sAutoRotateController.getLottieCloseName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_CLOSE);
    })

    it('AutoRotateComponent_getNewLottieOpenNameTest01', DEFAULT, (): void => {
      const name: string = sAutoRotateController.getNewLottieOpenName();
      expect(name).assertEqual(Constants.NEW_LOTTIE_DATA_OPEN);
    })
  })
}

export function AutoRotateComponentTest02() {
  describe('AutoRotateComponentTest02', (): void => {
    let sAutoRotateController = new AutoRotateController();
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('AutoRotateComponent_getNewLottieCloseNameTest01', DEFAULT, (): void => {
      const name: string = sAutoRotateController.getNewLottieCloseName();
      expect(name).assertEqual(Constants.NEW_LOTTIE_DATA_CLOSE);
    })

    it('AutoRotateComponent_getLottieDarkNameTest01', DEFAULT, (): void => {
      const name: string = sAutoRotateController.getLottieDarkName();
      expect(name).assertEqual(Constants.LOTTIE_DATA_CLOSE_DARK);
    })

    it('AutoRotateComponent_isLoadLottieTest01', DEFAULT, (): void => {
      const isLoadLottie: boolean = sAutoRotateController.isLoadLottie();
      expect(isLoadLottie).assertTrue();
    })

    it('AutoRotateComponent_isDarkReverseTest01', DEFAULT, (): void => {
      const isDarkReverse: boolean = sAutoRotateController.isDarkReverse();
      expect(isDarkReverse).assertTrue();
    })

    it('AutoRotateComponent_onStartTest01', DEFAULT, (): void => {
      sAutoRotateController.onStart();
      expect((sAutoRotateController as object)['mAutoRotateData'] !== undefined).assertTrue();
    })

    it('AutoRotateComponent_onSetEnableTest01', DEFAULT, (): void => {
      sAutoRotateController.onSetEnable(true);
      expect((sAutoRotateController as object)['mAutoRotateData']['available']).assertTrue();
    })
  })
}

export function AutoRotateComponentTest03() {
  describe('AutoRotateComponentTest03', (): void => {
    let sAutoRotateController = new AutoRotateController();
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('AutoRotateComponent_handleUpdateStateTest01', DEFAULT, (): void => {
      sAutoRotateController.handleUpdateState();
      expect((sAutoRotateController as object)['mAutoRotateData']['status']).assertInstanceOf('Boolean');
    })

    it('AutoRotateComponent_getDataTest01', DEFAULT, (): void => {
      const data: AutoRotateData = sAutoRotateController.getData();
      expect(data instanceof AutoRotateData).assertTrue();
    })

    it('AutoRotateComponent_isAvailableTest01', DEFAULT, (): void => {
      const isAvailable: boolean = sAutoRotateController.isAvailable();
      expect(isAvailable).assertTrue();
    })

    it('AutoRotateComponent_handleClickTest01', DEFAULT, (): void => {
      (sAutoRotateController as object)['mAutoRotateData']['available'] = true;
      const clickRes: boolean = sAutoRotateController.handleOneClick();
      expect(clickRes).assertTrue();
    })

    it('AutoRotateComponent_handleClickTest02', DEFAULT, (): void => {
      (sAutoRotateController as object)['mAutoRotateData']['available'] = false;
      const clickRes: boolean = sAutoRotateController.handleOneClick();
      expect(clickRes).assertFalse();
    })
  })
}

export function AutoRotateComponentTest04() {
  describe('AutoRotateComponentTest04', (): void => {
    let sAutoRotateController = new AutoRotateController();
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('AutoRotateComponent_lockRotationTemporarilyTest01', DEFAULT, async (): Promise<void> => {
      (sAutoRotateController as object)['mAutoRotateData']['status'] = false;
      await sAutoRotateController.lockRotationTemporarily();
      expect((sAutoRotateController as object)['lockTemporarily']).assertTrue();
    })

    it('AutoRotateComponent_restoreAutoRotationTest01', DEFAULT, async (): Promise<void> => {
      (sAutoRotateController as object)['lockTemporarily'] = true;
      await sAutoRotateController.restoreAutoRotation();
      expect((sAutoRotateController as object)['lockTemporarily']).assertFalse();
    })

    it('AutoRotateComponent_isLockedTemporarilyTest01', DEFAULT, (): void => {
      (sAutoRotateController as object)['lockTemporarily'] = true;
      const isLockedTemporarily: boolean = sAutoRotateController.isLockedTemporarily();
      expect(isLockedTemporarily).assertInstanceOf('Boolean');
    })
  })
}
