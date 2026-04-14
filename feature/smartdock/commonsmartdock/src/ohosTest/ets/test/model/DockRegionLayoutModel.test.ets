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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import {
  DockRegionLayoutModel,
  PadDockRegionLayoutModel,
  PhoneDockRegionLayoutModel,
} from '../../../../main/ets/default/model/DockRegionLayoutModel';
import { DockRegionType } from '../../../../main/ets/default/common/enum/SmartDockEnum';
import { SmartDockZoomFeatureSwitch } from '@ohos/launchercommon';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { SCBSceneSessionManager } from '@ohos/windowscene';

export default function DockRegionLayoutModelTest() {
  describe('DockRegionLayoutModelTest', () => {
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

    it('test_getParams1', 0, (): void => {
      let instance = DockRegionLayoutModel.getInstance();
      instance.updateRegionLayoutWidth(DockRegionType.RESIDENT,100);
      expect(instance.getRegionLayoutWidth(DockRegionType.RESIDENT)).assertEqual(100);
    })

    it('test_getParams2', 0, (): void => {
      let instance = DockRegionLayoutModel.getInstance();
      expect(instance.getSpace(0)).assertLessOrEqual(50);
    })

    it('test_getParams3', 0, (): void => {
      let instance = DockRegionLayoutModel.getInstance();
      expect(instance.getListItemWidth()).assertLargerOrEqual(52);

    })

    it('test_getParams4', 0, (): void => {
      let instance = DockRegionLayoutModel.getInstance();
      expect(instance.getIconSize()).assertLargerOrEqual(0);

    })

    it('test_getParams5', 0, (): void => {
      let instance = DockRegionLayoutModel.getInstance();
      expect(instance.getDockHeight()).assertLargerOrEqual(0);

    })

    it('test_getParams6', 0, (): void => {
      let instance = DockRegionLayoutModel.getInstance();
      expect(instance.getDockRadius()).assertLargerOrEqual(22);
    })

    it('test_getPadParams', 0, (): void => {
      let instance = PadDockRegionLayoutModel.getInstance();
      expect(instance.getSpace(1)).assertLarger(0);
      expect(instance.getIconSize()).assertLessOrEqual(66);
      expect(instance.getDividerWidth()).assertLessOrEqual(20);
      expect(instance.getIconRadius()).assertLessOrEqual(24);
      expect(instance.getDockHeight()).assertLessOrEqual(108);
      expect(instance.getListItemWidth()).assertLessOrEqual(66);
      expect(instance.getListItemHeight()).assertLessOrEqual(66);
      expect(instance.getDockHeight()).assertLessOrEqual(86);
      expect(instance.getSmallFolderIconSize()).assertLessOrEqual(13);
      expect(instance.getListPadding()).assertLessOrEqual(20);

      expect(instance.calculateRegionWidth(0)).assertEqual(0);
      expect(instance.calculateRegionWidth(1)).assertLarger(0);
    })

    it('test_calculateScaleWithRegionNum', 0, (): void => {
      let instance = PadDockRegionLayoutModel.getInstance();
      expect(instance.calculateScaleWithRegionNum(4)).assertLessOrEqual(1);
    })

    it('test_calculateScale', 0, (): void => {
      let instance = PadDockRegionLayoutModel.getInstance();
      expect(instance.calculateScale()).assertLargerOrEqual(1);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SmartDockZoomFeatureSwitch, SmartDockZoomFeatureSwitch.isSupportZoom);
      when(mockFunc)().afterReturn(true);
      expect(instance.calculateScale()).assertLessOrEqual(1);
      mocker.clear(SmartDockZoomFeatureSwitch);
      mocker.clearAll();
    })

    it('test_getTvParams', 0, (): void => {
      let instance = TvDockRegionLayoutModel.getInstance();
      expect(instance.getSpace(0)).assertLarger(9);
    })

    it('test_instance_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let instance = DockRegionLayoutModel.getInstance();
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_instance_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let instance = DockRegionLayoutModel.getInstance();
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_instance_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let instance = DockRegionLayoutModel.getInstance();
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_instance_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let instance = DockRegionLayoutModel.getInstance();
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_updateRegionLayoutLength_01', 0, () => {
      try {
        let region: DockRegionType = DockRegionType.OTHER;
        let num: number = 0;
        let instance = DockRegionLayoutModel.getInstance();
        instance.updateRegionLayoutLength(region, num);
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getRegionLayoutLength_01', 0, () => {
      try {
        let region: DockRegionType = DockRegionType.OTHER;
        let instance = DockRegionLayoutModel.getInstance();
        instance.getRegionLayoutLength(region);
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getSpace_01', 0, () => {
      try {
        let instance = DockRegionLayoutModel.getInstance();
        instance.getSpace(0);
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_calculateRegionWidth_01', 0, () => {
      try {
        let instance = DockRegionLayoutModel.getInstance();
        instance.calculateRegionWidth(0);
        instance.calculateRegionWidth(1);
        instance.getDividerHeight();
        instance.calculateScaleWithRegionNum(1);
        instance.calculateRegionWidthWithScale(1);
        expect(instance instanceof DockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDividerHeight_01', 0, () => {
      try {
        let instance = PadDockRegionLayoutModel.getInstance();
        instance.getDividerHeight();
        instance.getDockRadius();
        (instance as object)['scaleFilter'](2);
        (instance as object)['scaleFilter'](1);
        expect(instance instanceof PadDockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_instance_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance = PhoneDockRegionLayoutModel.getInstance();
        instance.getListPadding();
        expect(instance instanceof PhoneDockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(desktopUtil);
      mock.clearAll();
    })

    it('test_getListCount_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let instance = PadDockRegionLayoutModel.getInstance();
        instance.updateRegionLayoutLength(DockRegionType.RECENT, 20);
        expect(instance instanceof PadDockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_calculateRegionWidth_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let instance = PadDockRegionLayoutModel.getInstance();
        instance.calculateRegionWidth(1, DockRegionType.RECENT);
        expect(instance instanceof PadDockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_calculateRegionWidth_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let instance = PadDockRegionLayoutModel.getInstance();
        instance.calculateRegionWidth(6, DockRegionType.RECENT);
        expect(instance instanceof PadDockRegionLayoutModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}
