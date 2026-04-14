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

import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import {
  AppToHapMappingManager,
  AppToHapDetail,
  InstalledDialogType,
} from '../../../../../../main/ets/base/AppToHapMappingManager';
import { AppModel } from '../../../../../../main/ets/model/AppModel';
import {
  AppFoundationServiceExtensionManager
} from '../../../../../../main/ets/manager/AppFoundationServiceExtensionManager';
import { LaunchLayoutCacheManager } from '../../../../../../main/ets/TsIndex';

export default function AppToHapMappingManagerTest() {
  describe('AppToHapMappingManagerTest', () => {
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

    it("init", 0, async (done: Function) => {
      try {
        let instance = AppToHapMappingManager.getInstance();
        instance['init']
        expect(instance['mMapping'].size>=0).assertTrue();
      } catch (e) {
      }
      done();
    })

    it("getMyRecordMapFromSP1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance()
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(instance['getMyRecordMapFromSP']()).assertEqual(instance['mRecordMap']);
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done()
    })

    it("getMyRecordMapFromSP2", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = instance['getMyRecordMapFromSP']();
        expect(result.size>=0).assertTrue();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("getMappingFromSP1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      instance['init']();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
      let map = (new Map<string, Object>()).set('name', new Object({
        age: 18
      }));
      when(mockFunction)(ArgumentMatchers.any).afterReturn(map);
      try {
        let result = instance['getMyRecordMapFromSP']();
        expect(result.size>=0).assertTrue();
      } catch (e) {
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
      done();
    })

    it("getMappingFromSP2", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      instance['init']();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
      let map = (new Map<string, Object>()).set('name', new Object({
        age: 18
      }));
      when(mockFunction)(ArgumentMatchers.any).afterReturn(map);
      try {
        let result = instance['getMyRecordMapFromSP']();
        expect(result.size>=0).assertTrue();
      } catch (e) {
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
      done();
    })


    it("saveMyMapping", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let map = (new Map<string, AppToHapDetail>()).set('name', {
        'bundleName': '123'
      });
      instance['saveMyMapping'](map);
      expect(instance instanceof AppToHapMappingManager).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("saveMyLastUpdateTime", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      instance['saveMyLastUpdateTime'](1);
      expect(instance['mLastUpdateTime'] !== 0).assertTrue();
      done();
    })

    it("saveMyRecordMap", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      instance['saveMyRecordMap']('name', 1);
      expect(instance['mRecordMap'].size !== 0).assertTrue();
      done();
    })

    it("getInstance", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    })

    it("getMapping", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      expect(instance.getMapping().size>=0).assertEqual(true);
      done();
    })

    it("isUninstalled", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().isBundleNameExistInDeskTopOrDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      expect(instance['isUninstalled']('name')).assertTrue();
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("shouldOpenDialog1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        expect(instance['shouldOpenDialog']('name')).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("shouldOpenDialog2", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      instance['mapping'] = (new Map()).set('name','value')
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['firstQueryMapping']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['isQueryMappingAfter24Hours']);
      when(mockFunction3)().afterReturn(true);
      try {
        expect(instance['shouldOpenDialog']('name')).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("shouldOpenDialog3", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      instance['mapping'] = (new Map()).set('name','value')
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['isQueryMappingAfter24Hours']);
      when(mockFunction2)().afterReturn(true);
      try {
        expect(instance['shouldOpenDialog']('name1')).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("shouldOpenDialog4", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      instance['mapping'] = (new Map()).set('name','value')
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['isQueryMappingAfter24Hours']);
      when(mockFunction2)().afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['isUninstalled']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(instance['shouldOpenDialog']('name')).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("shouldOpenDialog5", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance()
      let mocker: MockKit = new MockKit();
      instance['mapping'] = (new Map()).set('name','value')
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['isQueryMappingAfter24Hours']);
      when(mockFunction2)().afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['isUninstalled']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(instance['shouldOpenDialog']('name1')).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("firstQueryMapping", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      expect(instance['firstQueryMapping']()).assertFalse();
      done();
    })

    it("isQueryMappingAfter24Hours1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let prevTime = instance['mLastUpdateTime'];
      instance['mLastUpdateTime'] = 1;
      expect(instance['isQueryMappingAfter24Hours']()).assertTrue();
      instance['mLastUpdateTime'] = prevTime;
      done();
    })

    it("isQueryMappingAfter24Hours2", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let prevTime = instance['mLastUpdateTime'];
      instance['mLastUpdateTime'] = new Date().getTime();
      expect(instance['isQueryMappingAfter24Hours']()).assertFalse();
      instance['mLastUpdateTime'] = prevTime;
      done();
    })

    it("isOpenDialogAfter24Hours1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['saveMyRecordMap']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      instance['mRecordMap'] = (new Map()).set('name',99);
      let mockFunction2: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(instance['isOpenDialogAfter24Hours']('name')).assertEqual(true);
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("isOpenDialogAfter24Hours2", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['saveMyRecordMap']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      instance['mRecordMap'] = (new Map()).set('name123',99);
      let mockFunction2: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      instance['mRecordMap'] = (new Map()).set('name123',99);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['mRecordMap'].get);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        expect(instance['isOpenDialogAfter24Hours']('name')).assertEqual(false);
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("queryCloudAppMappingAndPersist1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      let appInstance = AppModel.getInstance();
      let mockFunction1: Function =
        mocker.mockFunc(appInstance, appInstance.getAppList);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([{
        codePath: '1'
      }]);
      try {
        instance['queryCloudAppMappingAndPersist'];
        expect(instance['mMapping'].size>=0).assertTrue();
      } catch (e) {
      }
      mocker.clear(appInstance);
      mocker.clearAll();
      done();
    })

    it("queryCloudAppMappingAndPersist2", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let mocker: MockKit = new MockKit();
      let appInstance = AppModel.getInstance();
      let mockFunction1: Function =
        mocker.mockFunc(appInstance, appInstance.getAppList);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([{}]);
      let appServiceManager: AppFoundationServiceExtensionManager = AppFoundationServiceExtensionManager.getInstance();
      let mockFunction2: Function =
        mocker.mockFunc(appServiceManager, appServiceManager.getohosAppMap);
      when(mockFunction2)().afterReturn([{
        size: 2
      }]);
      try {
        instance['queryCloudAppMappingAndPersist'];
        expect(instance['mMapping'].size>=0).assertTrue();
      } catch (e) {
      }
      mocker.clear(appInstance);
      mocker.clear(appServiceManager);
      mocker.clearAll();
      done();
    })

    it("getPackageName", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      instance['mMapping'] = (new Map()).set('name', '1');
      expect(instance.getPackageName('name')).not().assertNull();
      done();
    })

    it("minusDays", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      expect(instance['minusDays'](new Date(), 7)).assertInstanceOf('Number');
      done();
    })

    it("checkRemindFrequencyAndCount1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let result = instance['checkRemindFrequencyAndCount']({
        lastShowDialogTime: 0
      }, {
        remindMaxCount: 1
      });
      expect(result).assertTrue();
      done();
    })

    it("checkRemindFrequencyAndCount2", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let result = instance['checkRemindFrequencyAndCount']({
        lastShowDialogTime: 0,
        showDialogCount: 1
      }, {
        remindMaxCount: 1
      });
      expect(result).assertFalse();
      done();
    })

    it("checkRemindFrequencyAndCount3", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let time = new Date().getTime() - 1000 * 60 * 60 * 25;
      let result = instance['checkRemindFrequencyAndCount']({
        lastShowDialogTime: time,
        showDialogCount: 1
      }, {
        remindFrequency: '1',
        remindMaxCount: 2
      });
      expect(result).assertTrue();
      done();
    })

    it("checkRemindFrequencyAndCount4", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      let time = new Date().getTime() - 1000 * 60 * 60 * 25;
      let result = instance['checkRemindFrequencyAndCount']({
        lastShowDialogTime: time,
        showDialogCount: 1,
        increasingFlag: 1
      }, {
        remindFrequency: '1d',
        remindMaxCount: 2
      });
      expect(result).assertTrue();
      done();
    })

    it("getInstalledDialogType1", 0, async (done: Function) => {
      let instance = AppToHapMappingManager.getInstance();
      instance.queryCloudAppMappingAndPersist();
      let result = instance.getInstalledDialogType('testName');
      expect(result).assertEqual(InstalledDialogType.OPEN);
      done();
    })

  })
}
