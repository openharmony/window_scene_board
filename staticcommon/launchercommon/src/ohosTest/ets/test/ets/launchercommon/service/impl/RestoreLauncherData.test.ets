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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  RestoreLauncherData,
  ExtraDataInfo,
  OwnerInfo
} from '../../../../../../../main/ets/service/impl/RestoreLauncherData';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import { CloneCloudServiceResponse } from '../../../../../../../main/ets/constants/DesktopServiceConstant';
import { AppReserveType, GridLayoutItemInfo, LaunchLayoutCacheManager } from '../../../../../../../main/ets/TsIndex';

export default function RestoreLauncherDataTest() {
  describe('RestoreLauncherDataTest', () => {
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

    it('RestoreLauncherDataTest_execute01', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      await data.execute({
        list: []
      });
      expect(data['backUpExtraDatas'].length).assertEqual(0);
      let ownerInfo: OwnerInfo = new OwnerInfo();
      ownerInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      ownerInfo.moduleName = CommonConstants.SETTING_MODULE;
      ownerInfo.abilityName = CommonConstants.SETTING_ABILITY;
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'ohos';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.title = 'dt title';
      dataInfo.iconUri = 'icon.png';
      let ret = await data.execute({
        ownerInfo: ownerInfo, list: [dataInfo]
      });
      expect(data['isBackUpLauncherLayout']).assertTrue();
      done();
    })

    it('RestoreLauncherDataTest_execute02', 0, async (done: Function) => {
      let ownerInfo: OwnerInfo = new OwnerInfo();
      const pkgName = 'com.ohos.weather';
      ownerInfo.bundleName = pkgName;
      ownerInfo.moduleName = CommonConstants.SETTING_MODULE;
      ownerInfo.abilityName = CommonConstants.SETTING_ABILITY;
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = pkgName ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      let data: RestoreLauncherData = new RestoreLauncherData();
      let ret:string = await data.execute({
        ownerInfo: ownerInfo, list: [dataInfo]
      });
      expect(ret).assertEqual(CloneCloudServiceResponse.SUCCESS);
      done();
    })

    it('test_parseItemParam1', 0, async (done: Function) => {
      try {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['parseItemParam'](null,'')
      expect(data).not().assertNull();
      } catch (e) {}
      done();
    })

    it('test_parseItemParam2', 0, async (done: Function) => {
      const pkgName = 'com.ohos.weather';
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = pkgName ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      data['parseItemParam'](dataInfo,'')
      expect(data).not().assertNull();
      done();
    })

    it('test_parseItemParam3', 0, async (done: Function) => {
      const pkgName = 'com.ohos.weather';
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = pkgName ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      data['parseItemParam'](dataInfo,'aa')
      expect(data).not().assertNull();
      done();
    })

    it('test_parseItemParam3', 0, async (done: Function) => {
      const pkgName = 'com.ohos.weather';
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = pkgName ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      data['versionCode'] = '11'
      data['parseItemParam'](dataInfo,'aa')
      expect(data).not().assertNull();
      done();
    })

    it('test_parseLegacyInfo1', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['parseLegacyInfo'](null)
      expect(data).not().assertNull();
      done();
    })

    it('test_parseLegacyInfo2', 0, async (done: Function) => {
      const pkgName = 'com.ohos.weather';
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      //TODO dataInfo.legacyInfo = null;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = pkgName ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      data['parseLegacyInfo'](dataInfo)
      expect(data).not().assertNull();
      done();
    })

    it('test_parseLegacyInfo3', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      //TODO dataInfo.legacyInfo = null;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = '' ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      data['parseLegacyInfo'](dataInfo)
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    })

    it('test_saveRestoreItem2Sp1', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['versionCode'] = ''
      data['saveRestoreItem2Sp']()
      expect(data).not().assertNull();
      done();
    })

    it('test_saveRestoreItem2Sp2', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['versionCode'] = '11'
      data['saveRestoreItem2Sp']()
      expect(data).not().assertNull();
      done();
    })

    it('test_getIconUri1', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = 'aa' ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = '';
      data['getIconUri'](dataInfo);
      expect(data).not().assertNull();
      done();
    })

    it('test_getIconUri2', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = 'aa' ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      data['getIconUri'](dataInfo);
      expect(data).not().assertNull();
      done();
    })

    it('test_getIconUri2', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      let dataInfo: ExtraDataInfo = new ExtraDataInfo();
      dataInfo.callerName = 'os';
      dataInfo.callerType = 0;
      dataInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dataInfo.packageName = 'aa' ;
      dataInfo.title = 'weather title';
      dataInfo.iconUri = 'weather.png';
      data['appGalleryIcon'] = undefined;
      data['getIconUri'](dataInfo);
      expect(data).not().assertNull();
      done();
    })

    it('test_insertIntoLayout1', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['restorePkgList'] = [];
      data['insertIntoLayout']();
      expect(data).not().assertNull();
      done();
    })

    it('test_insertIntoLayout2', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['restorePkgList'] = ['a'];
      data['items'] = ['a']
      data['insertIntoLayout']();
      expect(data).not().assertNull();
      done();
    })

    it('test_insertIntoLayout3', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['restorePkgList'] = ['a'];
      data['items'] = ['a']
      data['insertIntoLayout']();
      expect(data).not().assertNull();
      done();
    })

    it('test_insertIntoLayout4', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['restorePkgList'] = ['a'];
      data['isWaitForHarmonyList'] = [true];
      data['restoreAppTypeList'] = [AppReserveType.ENTERPRISE];
      data['items'] = ['a']
      data['insertIntoLayout']();
      expect(data).not().assertNull();
      done();
    })

    it('test_insertIntoLayout5', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['restorePkgList'] = ['a'];
      data['isWaitForHarmonyList'] = [true];
      data['restoreAppTypeList'] = [AppReserveType.THIRD];
      data['items'] = ['a']
      data['insertIntoLayout']();
      expect(data).not().assertNull();
      done();
    })

    it('test_insertIntoLayout6', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['restorePkgList'] = ['a'];
      data['isWaitForHarmonyList'] = [false];
      data['restoreAppTypeList'] = [AppReserveType.ENTERPRISE];
      data['items'] = ['a']
      data['insertIntoLayout']();
      expect(data).not().assertNull();
      done();
    })

    it('test_insertIntoLayout7', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      data['restorePkgList'] = ['a'];
      data['isWaitForHarmonyList'] = [false];
      data['restoreAppTypeList'] = [AppReserveType.THIRD];
      data['items'] = ['a']
      data['insertIntoLayout']();
      expect(data).not().assertNull();
      done();
    })

    it('test_getIconCopyUri1', 0, async (done: Function) => {
      try {
      let data: RestoreLauncherData = new RestoreLauncherData();
      expect(data['getIconCopyUri'](null)).assertThrowError("err");
      } catch (e) {}
      done();
    })

    it('test_checkIsInstalled1', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      let mock = new MockKit();
      let result = mock.mockFunc(LaunchLayoutCacheManager, LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem);
      when(result)().afterReturn(null);
      data['items'] = ['a']
      expect(data['checkIsInstalled'](data['items'])).assertFalse();
      mock.clear(LaunchLayoutCacheManager);
      mock.clearAll()
      done();
    })

    it('test_checkIsInstalled2', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      let mock = new MockKit();
      let grid = new GridLayoutItemInfo();
      let installedItems: GridLayoutItemInfo[] = [grid];
      let result = mock.mockFunc(LaunchLayoutCacheManager, LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem);
      when(result)().afterReturn(installedItems);
      data['items'] = ['a']
      expect(data['checkIsInstalled'](data['items'])).not().assertNull();
      mock.clear(LaunchLayoutCacheManager);
      mock.clearAll()
      done();
    })

    it('test_checkIsInstalled3', 0, async (done: Function) => {
      let data: RestoreLauncherData = new RestoreLauncherData();
      let mock = new MockKit();
      let grid = new GridLayoutItemInfo();
      let installedItems: GridLayoutItemInfo[] = [grid];
      let result = mock.mockFunc(LaunchLayoutCacheManager, LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem);
      when(result)().afterReturn(installedItems);
      try {
      expect(data['checkIsInstalled'](null)).assertFalse();
      } catch (e) {}
      mock.clear(LaunchLayoutCacheManager);
      mock.clearAll()
      done();
    })
  })
}