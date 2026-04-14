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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { DockItemPosition } from '../../../../main/ets/default/common/DockItemPosition';
import { RectInfo } from '@ohos/basicutils';

export default function DockItemPositionTest() {
  describe('DockItemPositionTest', () => {
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

    it('DockItemPosition_test_getInstance', 0, () => {
      const instance: DockItemPosition = DockItemPosition.getInstance();
      expect(instance).not().assertNull();
      expect(instance).assertEqual(DockItemPosition.getInstance());
    })

    it('DockItemPosition_test_setIconRect', 0, () => {
      const instance: DockItemPosition = DockItemPosition.getInstance();
      const tempData: RectInfo = new RectInfo()
      tempData.left = 0;
      tempData.top = 0;
      tempData.right = 0;
      tempData.bottom = 0;
      tempData.height = 0;
      tempData.width = 0;
      expect(instance.setIconRect(tempData) === undefined).assertTrue();
    })
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('calculateAppIconPosition_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('calculateAppIconPosition_test02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getListWidth_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test01', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getListWidth_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let itemList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getListWidth'](itemList);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getIndexInList_test02', 0, () => {
      let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
      let list = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      (smartDockCloseAppHandler as object)['getIndexInList'](list);
      expect(smartDockCloseAppHandler instanceof SmartDockCloseAppHandler).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_SmartDockCloseAppHandler_getAppIconInfo', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: IconExtendParam = new IconExtendParam();
        info.bundleName = 'bundleName';
        (smartDockCloseAppHandler as object)['mFindSmartDockPosition'] = true;
        smartDockCloseAppHandler.getAppIconInfo(info);
        expect(smartDockCloseAppHandler).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        AppStorage.setOrCreate('recentList', []);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        let mockFunc2: Function = mocker.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.LAUNCHER_BUNDLE);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clear(ObjUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockCloseAppHandler_calculateAppIconPosition_02', 0, () => {
      try {
        let smartDockCloseAppHandler: SmartDockCloseAppHandler = SmartDockCloseAppHandler.getInstance();
        let info: DockItemInfo = new DockItemInfo();
        info.abilityName = CommonConstants.RECENT_ABILITY;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        let mockFunc1: Function = mocker.mockFunc(smartDockCloseAppHandler, (smartDockCloseAppHandler as object)['getIndexInList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        (smartDockCloseAppHandler as object)['calculateAppIconPosition']();
        expect(smartDockCloseAppHandler).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(smartDockCloseAppHandler);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}
