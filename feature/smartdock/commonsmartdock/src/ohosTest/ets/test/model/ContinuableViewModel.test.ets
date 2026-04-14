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

import { ObjUtil } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import ContinuableViewModel from '../../../../main/ets/default/model/ContinuableViewModel';
import deviceManager from '@ohos.distributedDeviceManager';
import { DockContinuableInfo } from '@ohos/launchercommon';

export default function ContinuableViewModelTest() {
  describe('ContinuableViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_getDeviceManagerInstance', 0, (): void => {
      let instance = ContinuableViewModel.getInstance();
      (instance as object)['getDeviceManagerInstance']();
      expect(instance instanceof ContinuableViewModel).assertTrue();
    })

    it('test_judgeResultInvalid', 0, (): void => {
      let instance = ContinuableViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let data = null;
      (instance as object)['judgeResultInvalid'](data);
      (instance as object)['judgeResultIsActive']({
        state: 1
      });
      (instance as object)['judgeResultIsActive']({
        info: 1
      });
      (instance as object)['judgeResultIsActive']({
        state: 1,
        info: {
          srcDeviceId: '',
          bundleName: ''
        }
      });
      expect(data).assertNull();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('test_judgeResultIsActive', 0, (): void => {
      let instance = ContinuableViewModel.getInstance();
      let data: ESObject = { state: 1 };
      (instance as object)['judgeResultIsActive'](data);
      expect(data.state).assertEqual(1);
    })

    it('test_getAnonymousDeviceId', 0, (): void => {
      let instance = ContinuableViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['getAnonymousDeviceId']('deviceIdContinuableInfo');
      expect(instance instanceof ContinuableViewModel).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('test_getAnonymousDeviceId02', 0, (): void => {
      let instance = ContinuableViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['getAnonymousDeviceId']('deviceIdContinuableInfo');
      expect(instance instanceof ContinuableViewModel).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('test_continueMission', 0, (): void => {
      let instance = ContinuableViewModel.getInstance();
      let itemInfo: DockContinuableInfo = {
        sourceDeviceName: undefined,
        sourceDeviceType: undefined,
        sourceNetworkId: undefined,
        isContinuableInfo: false,
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      }
      instance.continueMission(undefined);
      instance.continueMission(itemInfo);
      itemInfo.sourceNetworkId = '123'
      instance.continueMission(itemInfo);
      itemInfo.bundleName = '123';
      instance.continueMission(itemInfo);
      expect((instance as object)['deviceLink']).not().assertUndefined();
    })
  })
}
