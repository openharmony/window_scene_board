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

import { DeviceHelper, sSettingsUtil } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { ScreenToggleController } from '../../../../../../main/ets/com/ohos/controller/ScreenToggleController';
import { CCMockUtil } from '../../../CCMockUtil';

const SUB_WINDOW_HEIGHT_DEFAULT = 260;
const SUB_WINDOW_HEIGHT_MIN_DPI = 221;

export default function ScreenToggleControllerTest() {
  let mocker: MockKit = new MockKit();

  describe('ScreenToggleControllerTest', () => {

    afterAll(() => {
      mocker.clearAll();
    })

    it('ScreenToggleControllerTest_onStart', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      (screenToggleController as object)['isEmulator'] = true;
      screenToggleController.init();
      screenToggleController.handleUpdateState();
      screenToggleController.onStart();
      screenToggleController.onStop();
      screenToggleController.unInit();
      expect(screenToggleController.getViewData().isUnavailable).assertTrue();
    })

    it('ScreenToggleControllerTest_getData', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      let gData = screenToggleController.getViewData();
      expect(gData).not().assertNull();
    })

    it('ScreenToggleControllerTest_isAvailable', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      CCMockUtil.mockFuncForObj(AppStorage, 'get', (): boolean => {
        return true;
      });
      screenToggleController.isAvailable();
      CCMockUtil.mockFuncForObj(AppStorage, 'get', (): boolean => {
        return false;
      });
      let isAvailable = screenToggleController.isAvailable();
      expect(isAvailable).assertTrue();
      CCMockUtil.clearAll();
    })

    it('ScreenToggleControllerTest_handleClick1', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      screenToggleController.getViewData().isUnavailable = true;
      let result = screenToggleController.handleOneClick();
      expect(result).assertFalse();
    })

    it('ScreenToggleControllerTest_handleClick2', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      screenToggleController.getViewData().isUnavailable = false;
      let result = screenToggleController.handleOneClick();
      expect(result).assertTrue();
    })

    it('ScreenToggleControllerTest_handleLongClick_1', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      screenToggleController.getViewData().isUnavailable = true;
      CCMockUtil.mockFuncForObj(DeviceHelper, 'isPC', (): boolean => {
        return false;
      });
      screenToggleController.getViewData().isUnavailable = false;
      CCMockUtil.mockFuncForObj(DeviceHelper, 'isPC', (): boolean => {
        return true;
      });
      let result = screenToggleController.isAvailable();
      expect(result).assertTrue();
      CCMockUtil.clearAll();
    })

    it('ScreenToggleControllerTest_handleLongClick_2', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      screenToggleController.getViewData().isUnavailable = false;
      CCMockUtil.mockFuncForObj(DeviceHelper, 'isPC', (): boolean => {
        return false;
      });
      let result = screenToggleController.isAvailable();
      expect(result).assertTrue();
      CCMockUtil.clearAll();
    })

    it('ScreenToggleControllerTest_handleLongClick_3', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      screenToggleController.getViewData().isUnavailable = false;
      CCMockUtil.mockFuncForObj(DeviceHelper, 'isPC', (): boolean => {
        return false;
      });
      let result = screenToggleController.isAvailable();
      expect(result).assertTrue();
      CCMockUtil.clearAll();
    })

    it('ScreenToggleControllerTest_getWindowHeight_1', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      CCMockUtil.mockFuncForObj(sSettingsUtil, 'getValue', (): number => {
        return 100;
      });
      (screenToggleController as object)["defaultDpi"] = 200;
      let result: number = (screenToggleController as object)["getWindowHeight"]();
      expect(result).assertEqual(SUB_WINDOW_HEIGHT_MIN_DPI);
      CCMockUtil.clearAll();
    })

    it('ScreenToggleControllerTest_getWindowHeight_2', 0, () => {
      let screenToggleController: ScreenToggleController = new ScreenToggleController();
      CCMockUtil.mockFuncForObj(sSettingsUtil, 'getValue', (): number => {
        return 0;
      });
      let result: number = (screenToggleController as object)["getWindowHeight"]();
      expect(result).assertEqual(SUB_WINDOW_HEIGHT_DEFAULT);
      mocker.clear(sSettingsUtil);
      CCMockUtil.clearAll();
    })
  })
}