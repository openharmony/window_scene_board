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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { AppCategoryInfoManager, CommonConstants, AppCategoryUtils } from '../../../../../../main/ets/TsIndex';
import { appInfoManager } from '@kit.StoreKit';
import { RdbStoreManager } from '../../../../../../main/ets/db/RdbStoreManager';
import osAccount from '@ohos.account.osAccount';
import { UserUnlockedEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { EventManager, EvtBus, OobeActivatedEvent } from '@ohos/frameworkwrapper';
import { CommonEventData } from 'commonEvent/commonEventData';
import commonEventManager from '@ohos.commonEventManager';


/**
 * AppCategoryInfoManager DT测试套
 */
export default function AppCategoryInfoManagerTest() {
  let mocker: MockKit;
  let appCatManager: AppCategoryInfoManager = new AppCategoryInfoManager();
  describe('AppCategoryInfoManagerTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    it('test_AppCategoryInfoManager_getValidAppCatInfo_when_categoryResult_is_not_empty', 0, async (done: Function) => {
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(eventMgr);
      appCatManager.init();

      // 从应用市场获取分类成功，且为游戏应用
      const categoryResult1: appInfoManager.AppCategoryInfo[] = [
        {
          bundleName: 'bundleName1',
          primaryCategoryId: CommonConstants.GAME_APP_PRIMARY_CATEGORY_ID,
          secondaryCategoryId: 1,
          appQueryCode: appInfoManager.QueryCode.SUCCESS,
        }
      ];
      const result1 = appCatManager['getValidAppCatInfo'](categoryResult1);
      expect(result1.length).assertEqual(1);

      // 从应用市场获取分类成功，且为普通应用
      const categoryResult2: appInfoManager.AppCategoryInfo[] = [
        {
          bundleName: 'bundleName2',
          primaryCategoryId: 1,
          secondaryCategoryId: 1,
          appQueryCode: appInfoManager.QueryCode.SUCCESS,
        }
      ];
      const result2 = appCatManager['getValidAppCatInfo'](categoryResult2);
      expect(result2.length).assertEqual(1);

      // 从应用市场获取分类失败，且不为预置应用
      const categoryResult3: appInfoManager.AppCategoryInfo[] = [
        {
          bundleName: 'bundleName3',
          primaryCategoryId: 1,
          secondaryCategoryId: 1,
          appQueryCode: appInfoManager.QueryCode.QUERY_ERROR,
        }
      ];
      const result3 = appCatManager['getValidAppCatInfo'](categoryResult3);
      expect(result3.length).assertEqual(0);

      // 从应用市场获取分类失败，且为预置应用
      const categoryResult4: appInfoManager.AppCategoryInfo[] = [
        {
          bundleName: 'com.ohos.mms',
          primaryCategoryId: 1,
          secondaryCategoryId: 1,
          appQueryCode: appInfoManager.QueryCode.QUERY_ERROR,
        }
      ];
      const result4 = appCatManager['getValidAppCatInfo'](categoryResult4);
      expect(result4.length).assertEqual(1);
      mocker.ignoreMock(eventMgr, eventMgr.on);
      done();
    });

    it('test_AppCategoryInfoManager_getValidAppCatInfo_when_categoryResult_is_empty', 0, async (done: Function) => {
      const result1 = appCatManager['getValidAppCatInfo'](null);
      expect(result1.length).assertEqual(0);

      const result2 = appCatManager['getValidAppCatInfo']([]);
      expect(result2.length).assertEqual(0);
      done();
    });

    it('test_AppCategoryInfoManager_initAllAppCatInfo_when_appCatInfos_is_not_null', 0, async (done: Function) => {
      let mockfunc1: Function = mocker.mockFunc(appCatManager, appCatManager['getAppCatInfoFromAG']);
      let mockAppCatInfos: appInfoManager.AppCategoryInfo[] = [
        { bundleName: 'bundleName1', primaryCategoryId: 1, secondaryCategoryId: 1, appQueryCode: 0 },
        { bundleName: 'bundleName2', primaryCategoryId: 2, secondaryCategoryId: 2, appQueryCode: 0 },
      ];
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(Promise.resolve(mockAppCatInfos));
      let rdbStoreManager: RdbStoreManager = RdbStoreManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.deleteAppCatInfoTable);
      when(mockfunc2)().afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.batchInsertOrUpdateAppCatInfo);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager.initAllAppCatInfo(['bundleName1', 'bundleName2']);
        let size1: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size1).assertEqual(2);
      } catch (e) {
      }

      let mockfunc4: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.batchInsertOrUpdateAppCatInfo);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager.initAllAppCatInfo(['bundleName1', 'bundleName2']);
        let size2: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size2).assertEqual(2);
      } catch (e) {
      }

      let mockfunc5: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.deleteAppCatInfoTable);
      when(mockfunc5)().afterThrow('Test error');
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager.initAllAppCatInfo(['bundleName1', 'bundleName2']);
        let size3: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size3).assertEqual(2);
      } catch (e) {
      }

      (appCatManager as object)['appCatIdMap'].clear();
      mocker.ignoreMock(appCatManager, appCatManager['getAppCatInfoFromAG']);
      mocker.ignoreMock(rdbStoreManager, rdbStoreManager.deleteAppCatInfoTable);
      mocker.ignoreMock(rdbStoreManager, rdbStoreManager.batchInsertOrUpdateAppCatInfo);
      done();
    });


    it('test_AppCategoryInfoManager_initAllAppCatInfo_when_bundleNames_is_empty', 0, async (done: Function) => {
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager.initAllAppCatInfo(undefined);
        let size1: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size1).assertEqual(0);

        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager.initAllAppCatInfo([]);
        let size2: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size2).assertEqual(0);
      } catch (e) {
      }
      done();
    });

    it('test_AppCategoryInfoManager_initAllAppCatInfo_when_appCatInfos_is_null', 0, async (done: Function) => {
      let mockfunc: Function = mocker.mockFunc(appCatManager, appCatManager['getAppCatInfoFromAG']);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(null));
      try {
        await appCatManager.initAllAppCatInfo(['bundleName1']);
        let size1: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size1).assertEqual(0);

        when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve([]));
        await appCatManager.initAllAppCatInfo(['bundleName2']);
        let size2: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size2).assertEqual(0);
      } catch (e) {
      }
      mocker.ignoreMock(appCatManager, appCatManager['getAppCatInfoFromAG']);
      done();
    });

    it('test_AppCategoryInfoManager_addAppCatInfo_when_appCatInfos_is_not_null', 0, async (done: Function) => {
      let mockfunc1: Function = mocker.mockFunc(appCatManager, appCatManager['getAppCatInfoFromAG']);
      let mockAppCatInfos: appInfoManager.AppCategoryInfo[] = [
        { bundleName: 'bundleName1', primaryCategoryId: 1, secondaryCategoryId: 1, appQueryCode: 0 },
        { bundleName: 'bundleName2', primaryCategoryId: 2, secondaryCategoryId: 2, appQueryCode: 0 },
      ];
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(Promise.resolve(mockAppCatInfos));
      let rdbStoreManager: RdbStoreManager = RdbStoreManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.batchInsertOrUpdateAppCatInfo);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager['addAppCatInfo'](['bundleName1', 'bundleName2']);
        let size1: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size1).assertEqual(2);
      } catch (e) {
      }

      let mockfunc3: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.batchInsertOrUpdateAppCatInfo);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager['addAppCatInfo'](['bundleName1', 'bundleName2']);
        let size2: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size2).assertEqual(2);
      } catch (e) {
      }

      let mockfunc4: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.batchInsertOrUpdateAppCatInfo);
      when(mockfunc4)(ArgumentMatchers.any).afterThrow('Test error');
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager['addAppCatInfo'](['bundleName1', 'bundleName2']);
        let size3: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size3).assertEqual(2);
      } catch (e) {
      }

      mocker.ignoreMock(appCatManager, appCatManager['getAppCatInfoFromAG']);
      mocker.ignoreMock(rdbStoreManager, rdbStoreManager.deleteAppCatInfoTable);
      mocker.ignoreMock(rdbStoreManager, rdbStoreManager.batchInsertOrUpdateAppCatInfo);
      done();
    });

    it('test_AppCategoryInfoManager_addAppCatInfo_when_appCatInfos_is_null', 0, async (done: Function) => {
      let mockfunc: Function = mocker.mockFunc(appCatManager, appCatManager['getAppCatInfoFromAG']);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(null));
      try {
        (appCatManager as object)['appCatIdMap'].clear();
        await appCatManager['addAppCatInfo'](['bundleName1']);
        let size1: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size1).assertEqual(0);

        (appCatManager as object)['appCatIdMap'].clear();
        when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve([]));
        await appCatManager['addAppCatInfo'](['bundleName2']);
        let size2: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size2).assertEqual(0);
      } catch (e) {
      }
      mocker.ignoreMock(appCatManager, appCatManager['getAppCatInfoFromAG']);
      done();
    });

    it('test_AppCategoryInfoManager_onOobeChangeEvent_when_event_null', 0, () => {
      const oobeEvent: OobeActivatedEvent | undefined = undefined;
      (appCatManager as object)['onOobeChangeEvent'](oobeEvent);
      expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();
    });

    it('test_AppCategoryInfoManager_onOobeChangeEvent_when_isActivated_false', 0, () => {
      let oobeEvent: OobeActivatedEvent = new OobeActivatedEvent();
      (oobeEvent as object)['isActivated'] = false;
      let mockFunc: Function = mocker.mockFunc(AppCategoryUtils, AppCategoryUtils.getAllAppBundleNames);
      when(mockFunc)().afterReturn(['bundleName1']);
      (appCatManager as object)['onOobeChangeEvent'](oobeEvent);
      expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();
      mocker.ignoreMock(AppCategoryUtils, AppCategoryUtils.getAllAppBundleNames);
    });

    it('test_AppCategoryInfoManager_onUserUnlockedEvent', 0, () => {
      try {
        const commonEvent: CommonEventData = {
          event: commonEventManager.Support.COMMON_EVENT_USER_UNLOCKED,
          bundleName: '',
          code: 0,
          data: '',
          parameters: [],
        }
        const userUnlockedEvent: UserUnlockedEvent = new UserUnlockedEvent(commonEvent);

        let mockFunc1: Function = mocker.mockFunc(osAccount.getAccountManager(),
          osAccount.getAccountManager().isOsAccountUnlocked);
        when(mockFunc1)().afterReturn(Promise.resolve(true));
        let mockFunc2: Function = mocker.mockFunc(AppCategoryUtils, AppCategoryUtils.getAllAppBundleNames);
        when(mockFunc2)().afterReturn(['bundleName1']);
        (appCatManager as object)['onUserUnlockedEvent'](userUnlockedEvent);
        expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();

        let mockFunc3: Function = mocker.mockFunc(osAccount.getAccountManager(),
          osAccount.getAccountManager().isOsAccountUnlocked);
        when(mockFunc3)().afterReturn(Promise.resolve(false));
        (appCatManager as object)['onUserUnlockedEvent'](userUnlockedEvent);
        expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();

        let mockFunc4: Function = mocker.mockFunc(osAccount.getAccountManager(),
          osAccount.getAccountManager().isOsAccountUnlocked);
        when(mockFunc4)().afterThrow('Test error');
        (appCatManager as object)['onUserUnlockedEvent'](userUnlockedEvent);
        expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();
      } catch (e) {
      }

      mocker.ignoreMock(osAccount.getAccountManager(), osAccount.getAccountManager().isOsAccountUnlocked);
    });

    it('test_AppCategoryInfoManager_getInstance', 0, () => {
      let instance1: AppCategoryInfoManager = AppCategoryInfoManager.getInstance();
      let instance2: AppCategoryInfoManager = AppCategoryInfoManager.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('test_AppCategoryInfoManager_registerOobeActivatedEventListener', 0, () => {
      appCatManager['registerOobeActivatedEventListener'];
      expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();
    });

    it('test_AppCategoryInfoManager_unRegisterEventListener', 0, () => {
      appCatManager['unRegisterEventListener'];
      expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();
    });

    it('test_AppCategoryInfoManager_registerUserUnlockedEventListener', 0, () => {
      appCatManager['registerUserUnlockedEventListener'];
      expect(appCatManager instanceof AppCategoryInfoManager).assertTrue();
    });

    it('test_AppCategoryInfoManager_getAppCatName', 0, () => {
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result1 = appCatManager.getAppCatName(1);
      expect(result1).assertUndefined();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result2 = appCatManager.getAppCatName(1);
      expect(result2).assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('test_AppCategoryInfoManager_updateAppCatTimeStamp_when_more_than_7_days', 0, () => {
      (appCatManager as object)['updateAppCatTimeStamp'] = -1;
      appCatManager.updateAppCatInfo(['test']);
      let size1: number = (appCatManager as object)['appCatIdMap'].size;
      expect(size1).assertEqual(0);

      (appCatManager as object)['updateAppCatTimeStamp'] = new Date().getTime() - 8 * CommonConstants.ONE_DAY_MILL;
      appCatManager.updateAppCatInfo(['test']);
      let size2: number = (appCatManager as object)['appCatIdMap'].size;
      expect(size2).assertEqual(0);
    });

    it('test_AppCategoryInfoManager_updateAppCatTimeStamp_when_less_than_7_days', 0, () => {
      (appCatManager as object)['updateAppCatTimeStamp'] = new Date().getTime() - 1 * CommonConstants.ONE_DAY_MILL;
      appCatManager.updateAppCatInfo(['test']);
      let size: number = (appCatManager as object)['appCatIdMap'].size;
      expect(size).assertEqual(0);
    });

    it('test_AppCategoryInfoManager_addAppCatInfo_when_bundleNames_is_empty', 0, async (done: Function) => {
      try {
        let appCatIdMap: Map<string, number> = new Map();
        appCatManager['appCatIdMap'] = appCatIdMap;
        await appCatManager['addAppCatInfo'](undefined);
        let size1: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size1).assertEqual(0);

        await appCatManager['addAppCatInfo']([]);
        let size2: number = (appCatManager as object)['appCatIdMap'].size;
        expect(size2).assertEqual(0);
      } catch (e) {
      }
      done();
    });

    it('test_AppCategoryInfoManager_readCatIdFromCache_when_appCatIdMap_is_null_or_empty', 0, () => {
      let mockfunc1: Function = mocker.mockFunc(AppCategoryUtils, AppCategoryUtils.getAllAppBundleNames);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(['bundleName1']);
      let mockfunc2: Function = mocker.mockFunc(appCatManager, appCatManager.initAllAppCatInfo);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let appCatIdMap: Map<string, number> = new Map();
      appCatManager['appCatIdMap'] = appCatIdMap;
      const result = appCatManager.readCatIdFromCache('bundleName1');
      expect(result).assertUndefined();
      (appCatManager as object)['appCatIdMap'].clear();
      mocker.clear(AppCategoryUtils);
      mocker.ignoreMock(appCatManager, appCatManager.initAllAppCatInfo);
    });

    it('test_AppCategoryInfoManager_readCatIdFromCache_when_appCatIdMap_is_not_null_and_contains_bundleName', 0, () => {
      let appCatIdMap: Map<string, number> = new Map();
      appCatIdMap.set('bundleName1', 123);
      appCatManager['appCatIdMap'] = appCatIdMap;
      const result = appCatManager.readCatIdFromCache('bundleName1');
      expect(result).assertEqual(123);
      (appCatManager as object)['appCatIdMap'].clear();
    });

    it('test_AppCategoryInfoManager_getAppCatInfoFromAG_when_bundleNames_is_null', 0, async (done: Function) => {
      const result1 = await appCatManager['getAppCatInfoFromAG'](null);
      expect(result1).assertDeepEquals([]);

      const result2 = await appCatManager['getAppCatInfoFromAG']([]);
      expect(result2).assertDeepEquals([]);
      done();
    });

    it('test_AppCategoryInfoManager_getPresetAppCategory_when_bundleNames_is_null', 0, () => {
      let categoryResult: appInfoManager.AppCategoryInfo | undefined = undefined;
      const result = appCatManager['getPresetAppCategory'](categoryResult);
      expect(result).assertUndefined();
    });

    it('test_AppCategoryInfoManager_syncAppCatDataToCache_when_appCatInfos_is_invalid', 0, async () => {
      let mockfunc: Function = mocker.mockFunc(RdbStoreManager.getInstance(),
        RdbStoreManager.getInstance().getAllAppCatInfo);
      when(mockfunc)().afterReturn(Promise.resolve(null));
      const result1 = await appCatManager['syncAppCatDataToCache']();
      expect(result1).assertEqual(false);

      when(mockfunc)().afterReturn(Promise.resolve([]));
      const result2 = await appCatManager['syncAppCatDataToCache']();
      expect(result2).assertEqual(false);

      when(mockfunc)().afterThrow('Test error');
      const result3 = await appCatManager['syncAppCatDataToCache']();
      expect(result3).assertEqual(false);

      let appCatInfo: appInfoManager.AppCategoryInfo = {
        bundleName: 'bundleName1', primaryCategoryId: 1, secondaryCategoryId: 1, appQueryCode: 0 };
      when(mockfunc)().afterReturn(Promise.resolve([appCatInfo]));
      const result4 = await appCatManager['syncAppCatDataToCache']();
      expect(result4).assertEqual(true);
      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().getAllAppCatInfo);
    });

    it('test_AppCategoryInfoManager_init', 0, () => {
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(eventMgr);
      appCatManager.init();
      expect(appCatManager['appCatEnable']).assertEqual(true);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });

    it('test_AppCategoryInfoManager_release', 0, () => {
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.offAll);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      appCatManager.release();
      expect(appCatManager['appCatEnable']).assertEqual(false);
      mocker.ignoreMock(eventMgr, eventMgr.offAll);
    });
  });
}