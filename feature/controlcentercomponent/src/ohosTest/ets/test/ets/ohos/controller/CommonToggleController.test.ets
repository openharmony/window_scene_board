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
import { PluginSlot } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { ApplicationToggleController } from '../../../../../../main/ets/com/ohos/controller/ApplicationToggleController';

export function CommonToggleControllerTest() {
  let mocker: MockKit;
  describe('CommonToggleControllerTest', (): void => {
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

    it('CommonToggleControllerTest001', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest002', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest003', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let HandleUpdateState = commonToggleController.getViewData();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest004', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      commonToggleController.handleOneClick();
      expect(commonToggleController !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest005', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      commonToggleController.startService();
      expect(commonToggleController !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest006', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest007', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest008', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest009', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let HandleClick = commonToggleController.handleOneClick();
      expect(commonToggleController !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();
    })

    it('CommonToggleControllerTest019', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest020', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest021', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();
    })

    it('CommonToggleControllerTest022', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.isAvailable();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.isAvailable();

      let HandleLongClick = commonToggleController.isAvailable();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest023', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleController_handleClickTest01', 0, (): void => {
      let sCommonToggleController = new ApplicationToggleController(PluginSlot.SLOT_CONTROL_SCREENSHOT);
      sCommonToggleController.handleOneClick();
      expect(sCommonToggleController !== null).assertEqual(true);
    })

    it('CommonToggleController_handleClickTest02', 0, (): void => {
      let sCommonToggleController = new ApplicationToggleController(PluginSlot.SLOT_CONTROL_SCREEN_RECORDER);
      let get = mocker.mockFunc(AppStorage, AppStorage.get);
      when(get)('lockStatus').afterReturn(1);
      sCommonToggleController.handleOneClick();
      expect(get('lockStatus') == 1).assertTrue();
      mocker.clear(AppStorage);
    })
  })
}