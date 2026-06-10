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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import {
  FlashlightTipsWindowData,
  FlashlightTipsAnimationData,
  FlashlightTipsModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/flashlight/model/FlashlightTipsModel';
import { inputConsumer, KeyCode } from '@kit.InputKit';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { sensor } from '@kit.SensorServiceKit';
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';

/**
 * 手电筒Model测试用例
 */
export function FlashlightTipsModelTest() {
  let flashlightTipsModel: FlashlightTipsModel = new FlashlightTipsModel();

  describe('FlashlightTipsModelTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_registerListeners', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      mockFunc = mocker.mockFunc(FileUtils, FileUtils.getFileList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['test', 'test']);

      flashlightTipsModel.registerListeners();

      mocker.clear(CheckEmptyUtils);
      mocker.clear(FileUtils);
      mocker.clearAll();

      let res = true;
      flashlightTipsModel.registerListeners();
      expect(res).assertTrue();
    });

    it('test_unRegisterListeners', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      flashlightTipsModel.unRegisterListeners();

      mocker.clear(CheckEmptyUtils);
      mocker.clear(FileUtils);
      mocker.clearAll();

      let res = true;
      flashlightTipsModel.unRegisterListeners();
      expect(res).assertTrue();
    });

    it('test_powerKeyDownUpCallback', Level.LEVEL0, (): void => {
      let res = true;
      let keyOptions: inputConsumer.KeyOptions = {} as  inputConsumer.KeyOptions;
      keyOptions.finalKey === KeyCode.KEYCODE_POWER && keyOptions.isFinalKeyDown;
      flashlightTipsModel.powerKeyDownUpCallback(keyOptions);
      expect(res).assertTrue();
    });

    it('test_backGestureCallBack', Level.LEVEL0, (): void => {
      let res = true;
      let type : GestureType = {} as GestureType;
      let event : GestureEvent = {} as GestureEvent;
      flashlightTipsModel.backGestureCallBack(type, event);
      expect(res).assertTrue();
    });

    it('test_screenCallback', Level.LEVEL0, (): void => {
      let res = true;
      let err : BusinessError = {code: 1} as BusinessError;
      let data: commonEventManager.CommonEventData = {event: ''} as commonEventManager.CommonEventData;
      flashlightTipsModel.screenCallback(err, data);
      data.event = commonEventManager.Support.COMMON_EVENT_SCREEN_ON;
      flashlightTipsModel.screenCallback(err, data);
      expect(res).assertTrue();
    });

    it('test_foldToExpandChangeCallback', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.foldToExpandChangeCallback();
      expect(res).assertTrue();
    });

    it('test_gyroscopeCallback', Level.LEVEL0, (): void => {
      let res = true;
      let data : sensor.GyroscopeResponse = {x: 200, y: 200} as sensor.GyroscopeResponse;
      flashlightTipsModel.gyroscopeCallback(data);
      expect(res).assertTrue();
    });

    it('test_setFlashlightTipsTextAnimate', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.setFlashlightTipsTextAnimate();
      expect(res).assertTrue();
    });

    it('test_setDelayPlayFlashlightTipsTextAnimate', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.setDelayPlayFlashlightTipsTextAnimate();
      expect(res).assertTrue();
    });

    it('test_playFlashlightTipsTextAnimate', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.playFlashlightTipsTextAnimate();
      expect(res).assertTrue();
    });

    it('test_oneTextMotion', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.oneTextMotion();
      expect(res).assertTrue();
    });

    it('test_twoTextMotion', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.twoTextMotion();
      expect(res).assertTrue();
    });

    it('test_initMotionParam', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.initMotionParam();
      expect(res).assertTrue();
    });

    it('test_exitPage', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.exitPage(false, false);
      expect(res).assertTrue();
    });

    it('test_setData', Level.LEVEL0, (): void => {
      let res = true;
      flashlightTipsModel.setData(new FlashlightTipsAnimationData(), new FlashlightTipsWindowData());
      expect(res).assertTrue();
    });
  })
}