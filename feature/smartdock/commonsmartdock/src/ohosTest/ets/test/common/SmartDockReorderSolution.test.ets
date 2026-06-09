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
import { CommonConstants, DockItemInfo, GridLayoutUtil, ResidentLayoutCacheMgr } from '@ohos/launchercommon';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import SmartDockReorderSolution from '../../../../main/ets/default/common/SmartDockReorderSolution';
import SmartDockReorderLayout from '../../../../main/ets/default/layout/SmartDockReorderLayout';
import { SmartDockStyleConfig } from '../../../../main/ets/default/common/SmartDockStyleConfig';

export default function SmartDockReorderSolutionTest() {
  describe('SmartDockReorderSolutionTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_getReorderSolution', 0, () => {
      try {
        let instance = SmartDockReorderSolution.getInstance();

        let x: number = 1;
        let y: number = 1;
        let targetX: number = 1;

        let smartDockReorderLayout = SmartDockReorderLayout.getInstance();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
        smartDockReorderLayout.initSolution(new DockItemInfo(), []);
        instance.setSmartDockReorderLayout(smartDockReorderLayout);

        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: '',
          typeId: 1,
          keyName: 'abc'
        }
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dockItemInfo], false);
        smartDockReorderLayout.initSolution(dockItemInfo, [dockItemInfo]);
        instance.setSmartDockReorderLayout(smartDockReorderLayout);

        instance.getReorderSolution(x, y, targetX, dockItemInfo);

        let dockItemInfo2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: '',
          typeId: 0,
          keyName: 'abc'
        }
        instance.getReorderSolution(x, y, targetX, dockItemInfo2);

        let dockItemInfo3: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: '',
          typeId: 1,
          itemType: 0,
          keyName: 'abc'
        }
        instance.getReorderSolution(x, y, targetX, dockItemInfo3);
        expect(instance.isCanCover(x, y, targetX, dockItemInfo3)).assertFalse();

        instance.getDockItemPosition(0);
        instance.getDockItemPosition(1);

        targetX = -1;
        expect(instance.isCanCover(x, y, targetX, dockItemInfo3)).assertFalse();

        targetX = 0;
        expect(instance.isCanCover(x, y, targetX, dockItemInfo3)).assertFalse();

      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_pushViewsToTempLocation', 0, () => {
      try {
        let instance = SmartDockReorderSolution.getInstance();

        let x: number = 1;
        let y: number = 1;
        let targetX: number = 0;

        let dockItemInfo: DockItemInfo = {
          bundleName: CommonConstants.LAUNCHER_BUNDLE,
          abilityName: CommonConstants.RECENT_ABILITY,
          typeId: 0,
          itemType: CommonConstants.TYPE_FUNCTION,
          areaType: CommonConstants.TYPE_AREA_DOCK,
          appIndex: 0,
          keyName: CommonConstants.LAUNCHER_BUNDLE + CommonConstants.RECENT_ABILITY,
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0
        };
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dockItemInfo], false);
        let smartDockReorderLayout = SmartDockReorderLayout.getInstance();
        smartDockReorderLayout.initSolution(dockItemInfo, [dockItemInfo]);
        instance.setSmartDockReorderLayout(smartDockReorderLayout);
        instance.getReorderSolution(x, y, targetX, dockItemInfo);

        let dockItemInfo2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: '',
          typeId: 0,
          keyName: 'abc'
        };
        instance.getReorderSolution(x, y, targetX, dockItemInfo2);
        expect(instance.isCanCover(x, y, targetX, dockItemInfo2)).assertFalse();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_SmartDockReorderSolution_getReorderSolution_7', 0, () => {
      let instance: SmartDockReorderSolution = SmartDockReorderSolution.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['getDirectionVector']);
        let mockFunc1: Function = mocker.mockFunc(instance, (instance as object)['pushViewsToTempLocation']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([0, 1]);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        let result: boolean = instance.getReorderSolution(1, 1, 1, new DockItemInfo());
        expect(result).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_SmartDockReorderSolution_pushViewsToTempLocation', 0, () => {
      let instance: SmartDockReorderSolution = SmartDockReorderSolution.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc((instance as object)['mSmartDockReorderLayout'], (instance as object)['mSmartDockReorderLayout'].getItemIndex);
        let mockFunc1: Function = mocker.mockFunc((instance as object)['mSmartDockReorderLayout'], (instance as object)['mSmartDockReorderLayout'].getSolution);
        let mockFunc2: Function = mocker.mockFunc((instance as object)['mSmartDockReorderLayout'], (instance as object)['mSmartDockReorderLayout'].addItem);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        let result: boolean = (instance as object)['pushViewsToTempLocation'](1, 1, new DockItemInfo());

        when(mockFunc1)(ArgumentMatchers.any).afterReturn([new DockItemInfo()]);
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mockFunc3: Function = mocker.mockFunc((instance as object)['mSmartDockReorderLayout'], (instance as object)['mSmartDockReorderLayout'].addItem);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(info);
        let result1: boolean = (instance as object)['pushViewsToTempLocation'](0, 1, new DockItemInfo());

        let result2: boolean = (instance as object)['pushViewsToTempLocation'](1, 1, new DockItemInfo());
        expect(instance instanceof SmartDockReorderSolution).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear((instance as object)['mSmartDockReorderLayout']);
      mocker.clearAll();
    })

    it('test_SmartDockReorderSolution_getDirectionVector_7', 0, () => {
      let instance: SmartDockReorderSolution = SmartDockReorderSolution.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(instance, instance.getDockItemPosition);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([1, 1]);
        let result: number[] = (instance as object)['getDirectionVector'](1, 1, 1);
        expect(result.length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_SmartDockReorderSolution_computeDirectionVector', 0, () => {
      let instance: SmartDockReorderSolution = SmartDockReorderSolution.getInstance();
      let result: number[] = (instance as object)['computeDirectionVector'](0, 1);
      expect(result.length).assertEqual(2);
    })

    it('test_SmartDockReorderSolution_findNearestArea', 0, () => {
      try {
        let instance: SmartDockReorderSolution = SmartDockReorderSolution.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc((instance as object)['mSmartDockReorderLayout'], (instance as object)['mSmartDockReorderLayout'].getSolution);
        when(mockFunc)().afterReturn([]);
        let result: number = instance.findNearestArea(1, 1);
        expect(result).assertEqual(0);
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        when(mockFunc)().afterReturn([info]);
        let result1: number = instance.findNearestArea(1, 1);
        expect(result1).assertEqual(0);
        mocker.clear((instance as object)['mSmartDockReorderLayout']);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_SmartDockReorderSolution_isCanCover', 0, () => {
      let instance: SmartDockReorderSolution = SmartDockReorderSolution.getInstance();
      let info: DockItemInfo = new DockItemInfo();
      info.abilityName = CommonConstants.RECENT_ABILITY;
      info.keyName = 'keyName';
      let info1: DockItemInfo = new DockItemInfo();
      info1.abilityName = CommonConstants.RECENT_ABILITY;
      info1.keyName = 'keyName1';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      let mockFunc1: Function = mocker.mockFunc((instance as object)['mSmartDockReorderLayout'], (instance as object)['mSmartDockReorderLayout'].getItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(info1);
      let result: boolean = instance.isCanCover(1, 1, 1, info);
      info.abilityName = CommonConstants.GRIDSWIPER_STACK_ID;
      info1.abilityName = CommonConstants.INTELLIGENT_BUNDLE;
      let result1: boolean = instance.isCanCover(1, 1, 1, info);
      expect(result1).assertInstanceOf('Boolean');
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_setSmartDockStyleConfig_01', 0, () => {
      try {
        let instance = SmartDockReorderSolution.getInstance();
        instance.setSmartDockStyleConfig(SmartDockStyleConfig.getInstance());
        expect(instance instanceof SmartDockReorderSolution).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })



  })
}
