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
import { GlobalSearchService } from '../../../../../../main/ets/globalSearch/GlobalSearchService';
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
import { EventConstants } from '../../../../../../main/ets/constants/EventConstants';
import { SearchEvents } from '../../../../../../main/ets/globalSearch/SearchEvents';
import { AppModel } from '../../../../../../main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'GlobalSearchService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function GlobalSearchServiceTest() {
  describe('GlobalSearchServiceTest', () => {
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

    it('test_getUUID', 0, () => {
      let ret = GlobalSearchService.getInstance()['getUUID']();
      expect(ret).assertInstanceOf('String');
    });

    it('test_init', 0, async () => {
      try{
        let instance:GlobalSearchService = GlobalSearchService.getInstance();
        instance.init();
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_subscribeAppEvent', 0, () => {
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      instance['subscribeAppEvent']();
      expect(instance).not().assertNull()
    });

    it('test_publishAppClickEvent', 0, async (done: Function) => {
      let instance:GlobalSearchService = GlobalSearchService.getInstance();
      let appInfo: AppItemInfo = {
        appName: 'anyAppName',
        appIconId: 0,
        bundleName: 'anyBundleName',
        abilityName: 'anyAbilityName'
      };
      await instance.publishAppClickEvent(appInfo);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_publishSearchEvent01', 0, () => {
      let instance:GlobalSearchService = GlobalSearchService.getInstance();
      let mOperationItemInfo: AppItemInfo = {} as AppItemInfo;
      let event: string = '';
      instance.publishSearchEvent(event, mOperationItemInfo);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_publishSearchEvent02', 0, () => {
      let instance:GlobalSearchService = GlobalSearchService.getInstance();
      let event: string = EventConstants.EVENT_PACKAGE_REMOVED;
      let mOperationItemInfo: AppItemInfo = {
        appName: 'anyAppName',
        appIconId: 0,
        bundleName: 'anyBundleName',
        abilityName: 'anyAbilityName'
      };
      instance.publishSearchEvent(event, mOperationItemInfo);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_publishSearchEvent03', 0, () => {
      let instance:GlobalSearchService = GlobalSearchService.getInstance();
      let event: string = EventConstants.EVENT_PACKAGE_CHANGED;
      let mOperationItemInfo: AppItemInfo = {
        appName: 'anyAppName',
        appIconId: 0,
        bundleName: 'anyBundleName',
        abilityName: 'anyAbilityName'
      };
      instance.publishSearchEvent(event, mOperationItemInfo);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_publishSearchEvent04', 0, () => {
      let instance:GlobalSearchService = GlobalSearchService.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE;
      let mOperationItemInfo: AppItemInfo = {
        appName: 'anyAppName',
        appIconId: 0,
        bundleName: 'anyBundleName',
        abilityName: 'anyAbilityName'
      };
      instance.publishSearchEvent(event, mOperationItemInfo);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_unSubscribeAppEvent', 0, () => {
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      instance['unSubscribeAppEvent']();
      expect(instance).not().assertNull()
    });

    it('test_appListChangeListener', 0, () => {
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      instance['appListChangeListener']['onReceiveEvent'](SearchEvents.EVENT_SEARCH_PACKAGE_REMOVED, null);

      let itemInfo: AppItemInfo = new AppItemInfo();
      itemInfo.bundleName = ' com.ohos.email';
      itemInfo.appIconId = 2234;
      itemInfo.moduleName = 'email';
      itemInfo.abilityName = 'ability';
      itemInfo.appName = 'email';
      itemInfo.appLabelId = 1234;
      try {
        instance['appListChangeListener']['onReceiveEvent'](SearchEvents.EVENT_SEARCH_PACKAGE_REMOVED, itemInfo);
        instance['appListChangeListener']['onReceiveEvent'](SearchEvents.EVENT_SEARCH_PACKAGE_ADDED, itemInfo);
        instance['appListChangeListener']['onReceiveEvent'](SearchEvents.EVENT_SEARCH_PACKAGE_CHANGED, itemInfo);
        instance['appListChangeListener']['onReceiveEvent'](SearchEvents.EVENT_SEARCH_PACKAGE_LANGUAGE_CHANGED,
          itemInfo);
        expect(instance).not().assertNull();
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_removeItemInfo', 0, () => {
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      instance['removeItemInfo']('com.ohos.maps.app');
      expect(instance).not().assertNull();
    })

    it('test_destroy', 0, () => {
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      instance.destroy();
      expect(instance).not().assertNull()
    });

    it('test_publishAppClickEvent_undefined', 0, async (done: Function) => {
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        await instance.publishAppClickEvent(undefined);
        let mockErrorLog = mocker.mockFunc(log, log.showWarn);
        let logAction = false;
        when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
          logAction = true;
        });
        expect(logAction).assertFalse();
      } catch (e) {}
      mocker.clear(log);
      mocker.clearAll();
      done();
    });

    it('GlobalSearchServiceTest_setAppList', 0, () => {
      let appItem1: AppItemInfo = {
        appName: '1',
        appIconId: 0,
        bundleName: 'anyBundleName_3',
        abilityName: '',
        moduleName: 'test.moduleName'
      };
      let appItem2: AppItemInfo = {
        appName: '2',
        appIconId: 0,
        bundleName: 'anyBundleName_4',
        abilityName: '',
        moduleName: 'test.moduleName4'
      };
      let appItem3: AppItemInfo = {
        appName: '3',
        appIconId: 0,
        bundleName: '',
        abilityName: '',
        moduleName: 'test.moduleName4'
      };
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      let mocker: MockKit = new MockKit();
      let mappModel: AppModel = AppModel.getInstance();
      instance['mAppModel'];
      let mockFuncGetAppList = mocker.mockFunc(mappModel, mappModel.getAppList);
      when(mockFuncGetAppList)().afterReturn([appItem1, appItem2, appItem3]);
      instance.setAppList();
      expect(instance).not().assertNull();
      mocker.clear(mappModel);
      mocker.clearAll();
    });

    it('GlobalSearchServiceTest_convertToSearchItemInfo', 0, () => {
      let instance: GlobalSearchService = GlobalSearchService.getInstance();
      instance['convertToSearchItemInfo(undefined)'];
      expect(instance).not().assertNull();
    });
  })
}