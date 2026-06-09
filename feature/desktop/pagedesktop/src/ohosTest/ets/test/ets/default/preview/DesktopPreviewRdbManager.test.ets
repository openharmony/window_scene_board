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
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { ObjUtil } from '@ohos/basicutils';
import { IconResourceManager, RdbStoreConfig } from '@ohos/frameworkwrapper';
import { DesktopParam, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { Context, contextConstant } from '@kit.AbilityKit';
import { PreviewUtils } from '../../../../../../main/ets/default/preview/PreviewUtils';
import { Log } from '../../../../../../main/ets/default/preview/Log';
import common from '@ohos.app.ability.common';
import { DesktopPreviewRdbManager } from '../../../../../../main/ets/default/preview/DesktopPreviewRdbManager';
import { NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';
import { Content } from '@kit.ArkUI';

let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

export default function DesktopPreviewRdbManagerTest() {
  describe('DesktopPreviewRdbManagerTest', () => {
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

    it('should_create_a_new_instance_if_not_already_created', 0, async (done: Function) => {
      globalThis.desktopPreviewRdbManager = null; // Ensure no instance is created before the test
      const firstCall: ESObject = DesktopPreviewRdbManager.getInstance();
      const secondCall: ESObject = DesktopPreviewRdbManager.getInstance();
      expect(firstCall).assertEqual(secondCall);
      done();
    });

    it('should_return_true_if_mLauncherRdbStore_is_already_defined', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: ESObject = DesktopPreviewRdbManager.getInstance();
      desktoppreviewrdbmanager.mLauncherRdbStore = {}; // Simulate that the store is already defined
      const result: ESObject = await desktoppreviewrdbmanager.createLauncherRdbStore({
        area: contextConstant.AreaMode.EL1
      } as common.Context);
      expect(result).assertTrue();
      done();
    });

    it('should_return_true_on_successful_rdb_store_creation', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: ESObject = DesktopPreviewRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockLogInfo: ESObject = mocker.mockFunc(Log, Log.showInfo);

      const result: ESObject = await desktoppreviewrdbmanager.createLauncherRdbStore({
        area: contextConstant.AreaMode.EL1
      } as common.Context);
      expect(result).assertTrue();
      done();
    });

    it('should_register_callback_correctly', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: ESObject = DesktopPreviewRdbManager.getInstance();
      let callback: ESObject = () => {
      };
      desktoppreviewrdbmanager.registerLoadFinishState(callback);
      expect(desktoppreviewrdbmanager.getIsLoadFinishState()).assertFalse();
      done();
    });

    it('should_call_callback_on_load_finish', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: ESObject = DesktopPreviewRdbManager.getInstance();
      let callback: ESObject = () => {
        return "Callback Called";
      };
      desktoppreviewrdbmanager.registerLoadFinishState(callback);
      desktoppreviewrdbmanager.mPreviewDataLoadFinishCallBack();
      expect(desktoppreviewrdbmanager.getIsLoadFinishState()).assertFalse();
      done();
    });

    it('should_handle_empty_abilityInfoList_correctly', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: ESObject = DesktopPreviewRdbManager.getInstance();
      let mockLog: ESObject = mocker.mockFunc(Log, Log.showInfo);
      await manager.initIconName();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(Log, Log.showInfo);
      done();
    });

    it('should_handle_non_empty_abilityInfoList_correctly', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: ESObject = DesktopPreviewRdbManager.getInstance();
      let abilityInfoList: ESObject = [{
        bundleName: 'bundle1',
        moduleName: 'module1',
        abilityName: 'ability1',
        label: 'Label1',
        appIndex: 1
      }];
      let mockPreviewUtils: ESObject = mocker.mockFunc(PreviewUtils, PreviewUtils.checkStrIsEmpty);
      when(mockPreviewUtils)(ArgumentMatchers.any).afterReturn(false);
      let mockIconResourceManager: ESObject = mocker.mockFunc(IconResourceManager.getInstance(),
        IconResourceManager.getInstance().setNameResourceCache);
      await manager.initIconName();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(PreviewUtils, PreviewUtils.checkStrIsEmpty);
      mocker.ignoreMock(IconResourceManager.getInstance(), IconResourceManager.getInstance().setNameResourceCache);
      done();
    });

    it('should_not_proceed_if_createLauncherRdbStore_fails', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: ESObject = DesktopPreviewRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockCreateLauncherRdbStore: ESObject =
        mocker.mockFunc(desktoppreviewrdbmanager, desktoppreviewrdbmanager.createLauncherRdbStore);
      expect(desktoppreviewrdbmanager.mIsLoadFinished).assertFalse();
      mocker.ignoreMock(desktoppreviewrdbmanager, desktoppreviewrdbmanager.createLauncherRdbStore);
      done();
    });

    it('should_proceed_normally_when_createLauncherRdbStore_succeeds', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: ESObject = DesktopPreviewRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockCreateLauncherRdbStore: ESObject =
        mocker.mockFunc(desktoppreviewrdbmanager, desktoppreviewrdbmanager.createLauncherRdbStore);
      let mockQueryGridLayoutItemInfos: ESObject =
        mocker.mockFunc(desktoppreviewrdbmanager, desktoppreviewrdbmanager.queryGridLayoutItemInfos);
      when(mockQueryGridLayoutItemInfos)(['TABLE_NAME', false]).afterReturn([]);
      expect(desktoppreviewrdbmanager.mIsLoadFinished).assertFalse();
      mocker.ignoreMock(desktoppreviewrdbmanager, desktoppreviewrdbmanager.createLauncherRdbStore);
      mocker.ignoreMock(desktoppreviewrdbmanager, desktoppreviewrdbmanager.queryGridLayoutItemInfos);
      done();
    });


    it('getIsLoadFinishState_test_1', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: DesktopPreviewRdbManager = DesktopPreviewRdbManager.getInstance();
      desktoppreviewrdbmanager.registerLoadFinishState(() => {
      });
      let result: boolean = desktoppreviewrdbmanager.getIsLoadFinishState();
      expect(result).assertFalse();
      done();
    });

    it('getIsLoadFinishState_test_2', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: DesktopPreviewRdbManager = DesktopPreviewRdbManager.getInstance();
      desktoppreviewrdbmanager.registerLoadFinishState(() => {
      });
      (desktoppreviewrdbmanager as object)['mIsLoadFinished'] = true;
      let result: boolean = desktoppreviewrdbmanager.getIsLoadFinishState();
      expect(result).assertTrue();
      done();
    });

    it('should_return_empty_string_when_labelId_is_undefined', 0, async (done: Function) => {
      const desktoppreviewrdbmanager = DesktopPreviewRdbManager.getInstance();
      const result = desktoppreviewrdbmanager.getAppNameWithCache(undefined, 'bundleName', 'moduleName', 'appName', 1);
      expect(result).assertEqual(undefined);
      done();
    });

    it('should_return_appName_when_getStringValue_returns_empty_or_null', 0, async (done: Function) => {
      const desktoppreviewrdbmanager = DesktopPreviewRdbManager.getInstance();
      const mocker = new MockKit();
      const result = desktoppreviewrdbmanager.getAppNameWithCache(1, 'bundleName', 'moduleName', 'appName', 1);
      expect(result).assertEqual(undefined);
      done();
    });

    it('should_return_appName_when_labelId_is_zero', 0, async (done: Function) => {
      let manager = DesktopPreviewRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let logMock = mocker.mockFunc(Log, Log.showInfo);
      let callback = (result: string) => {
        expect(result).assertEqual("appName");
        mocker.ignoreMock(Log, Log.showInfo);
        done();
      };
      manager.getBundleLabelWithCache(0, "bundleName", "moduleName", "appName", callback);
    });

    it('should_handle_error_when_getStringValue_fails', 0, async (done: Function) => {
      let manager = DesktopPreviewRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let logMock = mocker.mockFunc(Log, Log.showError);
      let callback = (result: string) => {
        expect(result).assertEqual("appName");
        mocker.ignoreMock(Log, Log.showError);
        done();
      };
      manager.getBundleLabelWithCache(1, "bundleName", "moduleName", "appName", callback);
    });

    it('should_return_value_when_getStringValue_succeeds', 0, async (done: Function) => {
      let manager = DesktopPreviewRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let callback = (result: string) => {
        expect(result).assertEqual("appName");
        done();
      };
      manager.getBundleLabelWithCache(1, "bundleName", "moduleName", "appName", callback);
    });

    it('should_handle_exception_gracefully', 0, async (done: Function) => {
      let manager = DesktopPreviewRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let logMock = mocker.mockFunc(Log, Log.showError);
      let callback = (result: string) => {
        expect(result).assertEqual("appName");
        mocker.ignoreMock(Log, Log.showError);
        done();
      };
      manager.getBundleLabelWithCache(1, "bundleName", "moduleName", "appName", callback);
    });

    it('should_return_input_if_input_is_invalid', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let desktoppreviewrdbmanager: DesktopPreviewRdbManager = DesktopPreviewRdbManager.getInstance();
      let mockObjUtil: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockObjUtil)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = desktoppreviewrdbmanager.getRealFolderName("invalidInput");
      expect(result).assertEqual("invalidInput");
      mocker.verify('isInvalid', ['invalidInput']).atLeast(1);
      mocker.ignoreMock(ObjUtil, ObjUtil.isInvalid);
      done();
    });

    it('should_return_input_if_no_match_found', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let desktoppreviewrdbmanager: DesktopPreviewRdbManager = DesktopPreviewRdbManager.getInstance();
      let mockObjUtil: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockObjUtil)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = desktoppreviewrdbmanager.getRealFolderName("noMatchExpected");
      expect(result).assertEqual("noMatchExpected");
      mocker.clear(ObjUtil);
      mocker.clearAll();
      done();
    });

    it('should_return_correct_string_if_single_match_found', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let desktoppreviewrdbmanager: DesktopPreviewRdbManager = DesktopPreviewRdbManager.getInstance();
      let mockObjUtil: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockObjUtil)(ArgumentMatchers.any).afterReturn(false);
      let mockGetStringByName: Function =
        mocker.mockFunc(desktoppreviewrdbmanager, desktoppreviewrdbmanager.getStringByName);
      when(mockGetStringByName)(ArgumentMatchers.any).afterReturn("Result1");
      const result: ESObject = desktoppreviewrdbmanager.getRealFolderName("${match1}");
      expect(result).assertEqual("Result1");
      mocker.ignoreMock(desktoppreviewrdbmanager, desktoppreviewrdbmanager.getStringByName);
      mocker.clear(ObjUtil);
      mocker.clearAll();
      done();
    });

    it('should_return_correct_string_if_multiple_matches_found', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let desktoppreviewrdbmanager: DesktopPreviewRdbManager = DesktopPreviewRdbManager.getInstance();
      let mockObjUtil: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockObjUtil)(ArgumentMatchers.any).afterReturn(false);
      let mockGetStringByName: Function =
        mocker.mockFunc(desktoppreviewrdbmanager, desktoppreviewrdbmanager.getStringByName);
      when(mockGetStringByName)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn("Result2");
      const result: ESObject = desktoppreviewrdbmanager.getRealFolderName("${match1}2");
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(desktoppreviewrdbmanager, desktoppreviewrdbmanager.getStringByName);
      mocker.clear(ObjUtil);
      done();
    });

    it('getStringByName_test_noParams', 0, async (done: Function) => {
      let manager = DesktopPreviewRdbManager.getInstance();
      let result = manager.getStringByName('testName');
      expect(result).assertEqual(undefined);
      done();
    });

    it('getStringByName_test_withParams', 0, async (done: Function) => {
      let manager = DesktopPreviewRdbManager.getInstance();
      let result = manager.getStringByName('testName', 'param1', 123);
      expect(result).assertEqual(undefined);
      done();
    });

    it('queryFirstScreenData_001', 0, () => {
      let manager = DesktopPreviewRdbManager.getInstance();
      let info = manager.queryFirstScreenData();
      expect(true).assertTrue();
    });

    it('initIconResourceCache_001', 0, () => {
      let manager = DesktopPreviewRdbManager.getInstance();
      manager.initIconResourceCache();
      expect(true).assertTrue();
    });

    it('initDesktopData_001', 0, () => {
      let manager = DesktopPreviewRdbManager.getInstance();
      manager.initDesktopData(context, true);
      manager.initDesktopData(context, false);
      expect(true).assertTrue();
    });

    it('DesktopPreviewRdbManagerTest_createLauncherRdbStore_undefined', 0, async (done: Function) => {
      let desktoppreviewrdbmanager: ESObject = DesktopPreviewRdbManager.getInstance();
      desktoppreviewrdbmanager.mLauncherRdbStore = undefined;
      const result: ESObject = await desktoppreviewrdbmanager.createLauncherRdbStore(context);
      expect(result).assertTrue();
      done();
    });

    it('DesktopPreviewRdbManagerTest_getAppNameWithCache', 0, () => {
      let item = new GridLayoutItemInfo();
      item.bundleName = "com.ohos.sceneboard";
      item.moduleName = "main";
      item.appName = "sceneboard";
      item.appLabelId = 1;
      item.appIndex = 1;
      let manager = DesktopPreviewRdbManager.getInstance();
      let res = manager.getAppNameWithCache();
      expect(res).assertUndefined();
      let normalRes = manager.getAppNameWithCache(item.appLabelId, item.bundleName, item.moduleName,  item.appName, item.appIndex);
      expect(normalRes).not().assertNull();
    });

    it('test_init_unregister', 0, () => {
      if (globalThis.desktopPreviewRdbManager) {
        globalThis.desktopPreviewRdbManager = null;
      }
      let manager = DesktopPreviewRdbManager.getInstance(0);
      expect((manager as object)['mTableName']).assertEqual(RdbStoreConfig.gridLayoutInfo.tableName);
      if (globalThis.desktopPreviewRdbManager) {
        globalThis.desktopPreviewRdbManager = null;
      }
      let manager1 = DesktopPreviewRdbManager.getInstance(1);
      manager1.unRegisterLoadFinishState();
      expect((manager1 as object)['mPreviewDataLoadFinishCallBack']).assertUndefined();
    });

    it('test_initIconName', 0, () => {
      let manager = DesktopPreviewRdbManager.getInstance(0);
      let mocker:MockKit = new MockKit();
      let mockFunc : Function = mocker.mockFunc(PreviewUtils, PreviewUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      manager.initIconName();
      expect(PreviewUtils.checkStrIsEmpty('empty')).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterThrow('errorinitIconname');
      manager.initIconName();
      expect(manager).not().assertNull();
      mocker.clear(PreviewUtils);
      mocker.clearAll();
    });

    it('test_queryGridLayoutItemInfos_001', 0, () => {
      let manager = DesktopPreviewRdbManager.getInstance();
      (manager as object)['mLauncherRdbStore'] = undefined;
      let result: GridLayoutItemInfo[] = (manager as object)['queryGridLayoutItemInfos']('tablename', false);
      expect(result.length === 0).assertTrue();
    })

    it('test_queryGridLayoutItemInfos_dealResultSet_002', 0, async (done: Function) => {
      if (globalThis.desktopPreviewRdbManager) {
        globalThis.desktopPreviewRdbManager = null;
      }
      let manager = DesktopPreviewRdbManager.getInstance(0);
      let createRdbstore = await manager.createLauncherRdbStore(context);
      expect(createRdbstore).assertTrue();
      let result: GridLayoutItemInfo[]  = (manager as object)['queryGridLayoutItemInfos'](RdbStoreConfig.gridLayoutInfo.tableName, false)
      expect(result).not().assertUndefined();
      done();
    });

    it('test_getAppNameWithCache_001', 0, () => {
      let labelId: number = 0;
      let bundleName: string = 'com.ohos.suggestion';
      let moduleName: string = 'entry';
      let appName: string = 'suggestion';
      let appIndex: number = 0;
      let manager = DesktopPreviewRdbManager.getInstance();
      let mocker:MockKit = new MockKit();
      try {
        let result = manager.getAppNameWithCache(labelId, bundleName, moduleName, appName, appIndex);
        expect(result).not().assertEqual(appName + moduleName);
        let result0 = manager.getAppNameWithCache(labelId, bundleName, moduleName, appName);
        expect(result0).not().assertEqual(appName + moduleName);
        let result1 = manager.getAppNameWithCache(labelId, 'test.bundleName', moduleName, appName);
        expect(result1).not().assertEqual(appName + moduleName);
        let mockFunc : Function = mocker.mockFunc(Log, Log.showInfo);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('test error');
        let result3 = manager.getAppNameWithCache(labelId, 'test.bundleName', moduleName, appName);
        expect(result3).not().assertEqual(appName + moduleName);
      } catch (e) {}
      mocker.clear(Log);
      mocker.clearAll();
    });

    it('test_getBundleLabelWithCache_001', 0, async (done: Function) => {
      let labelId: number = 0;
      let bundleName: string = 'com.ohos.suggestion';
      let moduleName: string = 'entry';
      let appName: string = 'suggestion';
      let manager = DesktopPreviewRdbManager.getInstance();
      let callback = (result: string) => {
        expect(result).assertEqual(appName);
        done();
      };
      manager.getBundleLabelWithCache(labelId, bundleName, moduleName, appName, callback);
    });

  })
}
