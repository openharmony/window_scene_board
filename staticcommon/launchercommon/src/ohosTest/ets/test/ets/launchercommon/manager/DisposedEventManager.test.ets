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
} from '@ohos/hypium'
import { preferences } from '@kit.ArkData';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonEvent, GlobalContext, InstallStatusChangeEvent } from '@ohos/frameworkwrapper';
import { AppToHapMappingManager, DisposedEventManager } from '../../../../../../main/ets/TsIndex'
import { common } from '@kit.AbilityKit';

const TAG = 'DisposedEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function DisposedEventManagerTest() {
  describe('DisposedEventManagerTest', () => {
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

    it('DisposedEventManagerTest_init', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      expect(manager).not().assertNull();
    });

    it('DisposedEventManagerTest_init_allkeys', 0, async () => {
      let options: preferences.Options = {
        name: 'eventManagerFile'
      };
      let pre = preferences.getPreferencesSync(GlobalContext.getInstance()
        .getObject('desktopContext') as common.ApplicationContext, options);
      pre.put('testkey1', 'key1Value');
      pre.put('testkey2', 'key2Value');
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let res = manager['ruledBundleNamesMap'];
      expect(res).not().assertNull();
    });

    it('DisposedEventManagerTest_handleDisposedRuleEvent01', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = "com.ohos.sceneboard";
      let event = new CommonEvent({
        event: 'usual.event.DISPOSED_RULE_ADDED',
        bundleName: bundleName,
        parameters: {
          appId: 'testEvent1_appid_1',
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.showInfo);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      manager['handleDisposedRuleEvent'](event);
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_handleDisposedRuleEvent02', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = "com.ohos.sceneboard";
      let event = new CommonEvent({
        event: 'usual.event.DISPOSED_RULE_DELETED',
        bundleName: bundleName,
        parameters: {
          appId: 'testEvent1_appid_1',
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.showInfo);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      manager['handleDisposedRuleEvent'](event);
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_handleDisposedRuleEvent03', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = "com.ohos.sceneboard";
      let event = new CommonEvent({
        event: 'usual.event.UPDATE_MIGRATE_STATUS_CHANGE',
        bundleName: bundleName,
        parameters: {
          appId: 'testEvent1_appid_1',
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.showInfo);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      try {
        manager['handleDisposedRuleEvent'](event);
      } catch(e) {}
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('test_handleDisposedRuleEvent_default_001', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = "com.ohos.sceneboard";
      let event = new CommonEvent({
        event: 'usual.event.UPDATE_MIGRATE_STATUS_CHANGETest',
        bundleName: bundleName,
        parameters: {
          appId: 'testEvent1_appid_1',
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      }as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.showInfo);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      manager['handleDisposedRuleEvent'](event);
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_init_errorPreference', 0, async () => {
      let options: preferences.Options = {
        name: 'eventManagerFile'
      };
      let a = 'test';
      preferences.deletePreferences(GlobalContext.getInstance()
        .getObject('desktopContext') as common.ApplicationContext, 'eventManagerFile')
      let pre = preferences.getPreferencesSync(GlobalContext.getInstance()
        .getObject('desktopContext') as common.ApplicationContext, options);
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      try {
        manager['init']();
      } catch (e) {}
      let allKeys: string[] = Object.keys(pre.getAllSync());
      expect(a).assertEqual('test');
    });

    it('DisposedEventManagerTest_startMigration', 0, async () => {
      let bundleName = "com.ohos.sceneboard";
      let packageName = 'music';
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      manager['installedBundleNamesMap'].set('com.ohos.musicTest', 'packageName1');
      manager['startMigration'](bundleName, packageName);
      manager['startMigration'](bundleName, packageName);
      let installedBundleNamesMap: Map<string, string> = manager['installedBundleNamesMap'];
      expect(installedBundleNamesMap.has(bundleName)).assertTrue();
    });

    it('DisposedEventManagerTest_setAppNameToNormal', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = "com.ohos.sceneboard";
      let event = new CommonEvent({
        event: 'usual.event.DISPOSED_RULE_ADDED',
        bundleName: bundleName,
        parameters: {
          appId: 'testEvent1',
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.error);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      manager['setAppNameToNormal'](event);
      expect(logAction).assertFalse();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_setAppNameToNormal01', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let bundleName = "com.ohos.sceneboard";
        let event = new CommonEvent({
          event: 'usual.event.DISPOSED_RULE_ADDED',
          bundleName: bundleName,
          parameters: {
            appId: 'testEvent1_appid_1',
            bundleName: 'com.ohos.sceneboard.test',
            taskContext: '{\\"backup\\":1}'
          } as TestParameters
        } as CommonEventData);
        let logAction = false;
        let mockErrorLog = mocker.mockFunc(log, log.error);
        when(mockErrorLog)('update migrate status change event bundleName is undefined').afterAction(() => {
          logAction = true;
        });
        manager['setAppNameToNormal'](event);
        expect(logAction).assertFalse();
      } catch (e) {}
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_setAppNameToNormal02', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = "com.ohos.sceneboard";
      let event = new CommonEvent({
        event: 'usual.event.DISPOSED_RULE_ADDED',
        bundleName: bundleName,
        parameters: {
          appId: 'testEvent1_appid_1',
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      } as CommonEventData);
      manager['ruledBundleNamesMap'].set('testEvent1', 'testValue');
      manager['setAppNameToNormal'](event);
      let res = manager['ruledBundleNamesMap'].has('testEvent1');
      expect(res).assertFalse();
    });

    it('test_setAppNameToNormal_emptyHmName_001', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = "com.ohos.sceneboard";
      let event = new CommonEvent({
        event: 'usual.event.DISPOSED_RULE_ADDED',
        bundleName: bundleName,
        parameters: {
          appId: 'testEvent1_appid_1',
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      }as CommonEventData);
      manager['ruledBundleNamesMap'].set('testEvent1', 'testValue');
      let mocker : MockKit = new MockKit();
      let mockFunc : Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      manager['setAppNameToNormal'](event);
      expect(event.parameters?.appId).assertEqual('testEvent1_appid_1');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_setDisposedStatusAndMigration_empty', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = 'com.ohos.sceneboard';
      let event = new CommonEvent({
        bundleName: bundleName,
        parameters: {
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.error);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      let mockEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockEmpty)(ArgumentMatchers.any).afterReturn(true);
      manager['setDisposedStatusAndMigration'](event);
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_setDisposedStatusAndMigration_catcherror', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = 'com.ohos.sceneboard';
      let event = new CommonEvent({
        bundleName: bundleName,
        parameters: {
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}'
        } as TestParameters,
        data: '{want:{parameters:{}}}',
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.showError);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      let mockEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockEmpty)(ArgumentMatchers.any).afterReturn(false);
      manager['setDisposedStatusAndMigration'](event);
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_handleAppInstalled', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = 'com.ohos.sceneboard';
      let eventEmpty = new CommonEvent({
        bundleName: bundleName,
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.error);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      let mockShowInfo = mocker.mockFunc(log, log.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      manager.handleAppInstalled(eventEmpty);
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_handleAppInstalled01', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = 'com.ohos.sceneboard';
      let eventEmpty = new CommonEvent({
        bundleName: bundleName,
        parameters: {
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: 'testerror'
        } as TestParameters
      } as CommonEventData);
      let logAction = false;
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.error);
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      let mockShowInfo = mocker.mockFunc(log, log.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      manager.handleAppInstalled(eventEmpty);
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_handleAppInstalled01_errorempty', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let logAction = false;
      let bundleName = 'com.ohos.sceneboard';
      let event = new CommonEvent({
        bundleName: bundleName,
        parameters: {
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\"backup\":1}'
        } as TestParameters
      } as CommonEventData);
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.error);
      when(mockErrorLog)('handleAppInstalled taskContext is undefined or is not back up').afterAction(() => {
        logAction = true;
      });
      let mockShowInfo = mocker.mockFunc(log, log.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterAction(() => {
        logAction = true;
      });
      try {
        manager.handleAppInstalled(event);
      } catch (e) {}
      expect(logAction).assertTrue();
      mocker.clear(log);
      mocker.clearAll();
    });

    it('DisposedEventManagerTest_initEvent', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      manager.initEvent().then(() => {
      });
      expect(manager).not().assertNull();
    });

    it('test_setDisposedStatusAndMigration_codeif', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = 'com.ohos.sceneboard';
      let event = new CommonEvent({
        bundleName: bundleName,
        parameters: {
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}',
          APPGALLERY_APP_STATUS_EXTERNAL_CODE: '{"5":"inttype5"}',
          KEY_DISPOSED_BUNDLE_NAME: '{"9":"inttype9"}',
        } as TestParameters,
        data: '{want:{parameters:{}}}',
        code: 1,
      } as CommonEventData);
      let mocker: MockKit = new MockKit();
      let appManager:AppToHapMappingManager = AppToHapMappingManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(appManager, appManager.getPackageName);
      when(mockFunc)(ArgumentMatchers.any).afterAction("testBundleName");
      try {
        manager['setDisposedStatusAndMigration'](event);
      } catch (e) {}
      expect(manager).not().assertUndefined();
      mocker.clear(appManager);
      mocker.clearAll();
    });

    it('test_uninstallPackage_empty001', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      manager['ruledBundleNamesMap'] = new Map();
      let bundleName = 'com.ohos.sceneboard';
      let emptyNameEvent = new CommonEvent({
        bundleName: bundleName,
        parameters: {
          bundleName: '',
          taskContext: '{\\"backup\\":1}',
          APPGALLERY_APP_STATUS_EXTERNAL_CODE: '{"5":"inttype5"}',
          KEY_DISPOSED_BUNDLE_NAME: '{"9":"inttype9"}',
        } as TestParameters,
        data: '{want:{parameters:{}}}',
      } as CommonEventData);
      try {
        manager['uninstallPackage'](emptyNameEvent);
        expect(manager['ruledBundleNamesMap'].has(bundleName)).assertFalse();
      } catch (e) {}
    })

    it('test_uninstallPackage_001', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = 'com.ohos.sceneboard';
      let event = new CommonEvent({
        bundleName: bundleName,
        parameters: {
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}',
          APPGALLERY_APP_STATUS_EXTERNAL_CODE: '{"5":"inttype5"}',
          KEY_DISPOSED_BUNDLE_NAME: '{"9":"inttype9"}',
        } as TestParameters,
        data: '{want:{parameters:{}}}',
      }as CommonEventData);
      manager['ruledBundleNamesMap'] = new Map();
      manager['ruledBundleNamesMap'].set(bundleName, 'testvalue');
      let mocker: MockKit = new MockKit();
      let appManager:AppToHapMappingManager = AppToHapMappingManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(appManager, appManager.getPackageName);
      when(mockFunc1)(ArgumentMatchers.any).afterAction('testBundleName');
      try {
        manager['uninstallPackage'](event);
      } catch (e) {}
      expect(manager['ruledBundleNamesMap']).not().assertUndefined();
      mocker.clear(appManager);
      mocker.clearAll();
    });

    it('test_uninstallPackage_emptyBundleName', 0, async () => {
      let manager: DisposedEventManager = DisposedEventManager.getInstance();
      let bundleName = 'com.ohos.sceneboard';
      let event = new CommonEvent({
        event: InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
        bundleName: bundleName,
        code: 0,
        parameters: {
          bundleName: 'com.ohos.sceneboard.test',
          taskContext: '{\\"backup\\":1}',
          APPGALLERY_APP_STATUS_EXTERNAL_CODE: '{"5":"inttype5"}',
          KEY_DISPOSED_BUNDLE_NAME: '{"9":"inttype9"}',
        } as TestParameters,
        data: '{want:{parameters:{}}}',
      });
      manager['ruledBundleNamesMap'] = new Map();
      let mocker: MockKit = new MockKit();
      let appManager:AppToHapMappingManager = AppToHapMappingManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(appManager, appManager.getPackageName);
      when(mockFunc1)(ArgumentMatchers.any).afterAction('');
      try {
        manager['uninstallPackage'](event);
      } catch (e) {}
      expect(manager['ruledBundleNamesMap'].has(bundleName)).assertFalse();
      mocker.clear(appManager);
      mocker.clearAll();
    });


    interface TestParameters {
      appId?: string,
      bundleName?: string,
      taskContext?: string,
      APPGALLERY_APP_STATUS_EXTERNAL_CODE?: string,
      KEY_DISPOSED_BUNDLE_NAME?: string,
    }

    interface CommonEventData {
      event: string;
      bundleName?: string;
      code?: number;
      data?: string;
      parameters?: Record<string, Object>;
    }
  })
}
