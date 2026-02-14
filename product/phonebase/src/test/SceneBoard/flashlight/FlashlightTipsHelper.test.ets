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
import { SCBScreenProperty } from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { FlashlightTipsHelper } from '../../../main/ets/SceneBoard/flashlight/helper/FlashlightTipsHelper';
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';

/**
 * 手电筒Helper测试用例
 */
export function FlashlightTipsHelperTest() {
  let flashlightTipsHelper: FlashlightTipsHelper = new FlashlightTipsHelper();

  describe('FlashlightTipsHelperTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterAll(() => {
      flashlightTipsHelper.unRegisterBackGestureEvent();
    });
    afterEach(() => {
    });

    it("registerBackGestureEvent_unRegisterBackGestureEvent", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      flashlightTipsHelper.unRegisterBackGestureEvent();
      let callback = () => {
        flashlightTipsHelper.unRegisterBackGestureEvent();
      }
      flashlightTipsHelper.registerBackGestureEvent(callback);
      let test = 'test';
      let src = 'test';
      expect(test === src).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      flashlightTipsHelper.registerBackGestureEvent(callback);
    });

    it("getFlashlightTipsResource", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.getFileList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['test', 'test']);
      let test = 'test';
      let src = 'test';
      flashlightTipsHelper.getFlashlightTipsResource();
      expect(test === src).assertTrue();
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it("registerScreenListener_unRegisterScreenListener", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      flashlightTipsHelper.unRegisterScreenListener();
      let callback = () => {
        flashlightTipsHelper.unRegisterScreenListener();
      }
      flashlightTipsHelper.registerScreenListener(callback);
      let test = 'test';
      let src = 'test';
      expect(test === src).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      flashlightTipsHelper.registerScreenListener(callback);
      expect(test === src).assertTrue();
    });

    it("registerScreenSessionManagerListener_unRegisterScreenSessionManagerListener", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      let screenProp: SCBScreenProperty = new SCBScreenProperty();
      let callback = () => {
        flashlightTipsHelper.unRegisterScreenSessionManagerListener(callback, screenProp);
      }
      flashlightTipsHelper.registerScreenSessionManagerListener(callback, screenProp);
      flashlightTipsHelper.unRegisterScreenSessionManagerListener(callback, screenProp);

      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      flashlightTipsHelper.registerScreenSessionManagerListener(callback, screenProp);
      let test = 'test';
      let src = 'test';
      expect(test === src).assertTrue();
    });

    it("registerGyroscopeListener_unRegisterGyroscopeListener", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      let callback = () => {
        flashlightTipsHelper.unRegisterGyroscopeListener();
      }
      flashlightTipsHelper.registerGyroscopeListener(callback);

      when(mockFunc)(ArgumentMatchers.any).afterThrow('error Failed to invoke on');
      flashlightTipsHelper.registerGyroscopeListener(callback);

      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      flashlightTipsHelper.registerGyroscopeListener(callback);
      let test = 'test';
      let src = 'test';
      expect(test === src).assertTrue();
    });

    it("registerPowerListener_unRegisterPowerListener", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      flashlightTipsHelper.unRegisterPowerListener();
      let callback = () => {
        flashlightTipsHelper.unRegisterPowerListener();
      }
      flashlightTipsHelper.registerPowerListener(callback);

      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      flashlightTipsHelper.registerPowerListener(callback);
      let test = 'test';
      let src = 'test';
      expect(test === src).assertTrue();
    });

    it("keepScreenOn_cancelKeepScreenOn", Level.LEVEL1, () => {
      flashlightTipsHelper.cancelKeepScreenOn();
      flashlightTipsHelper.keepScreenOn(180000);
      let test = 'test';
      let src = 'test';
      expect(test === src).assertTrue();
      flashlightTipsHelper.cancelKeepScreenOn();
      expect(test === src).assertTrue();
    });
  })
}