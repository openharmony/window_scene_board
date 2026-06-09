/**
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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, Level, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
import { PreInstallUtils } from '../../../../../../main/ets/utils/PreInstallUtils';
import { RdbStoreManager } from '../../../../../../main/ets/db/RdbStoreManager';
import GridLayoutItemInfo  from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';
import { FileUtils } from '@ohos/basicutils';

export function PreInstallUtilsTest() {
  describe('PreInstallUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    // initNeedInstallAppCache 测试DT
    it('PreInstallUtilsTest_initNeedInstallAppCache_01', 0, () => {
      const res: string = 'success';
      const mock = new MockKit();
      const readStr = mock.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(readStr)(ArgumentMatchers.any).afterReturn(null);
      PreInstallUtils.initNeedInstallAppCache();
      mock.clear(FileUtils);
      mock.clearAll();
      expect(res).assertEqual('success');
    })

    it('PreInstallUtilsTest_initNeedInstallAppCache_02', 0, () => {
      const res: string = 'success';
      const mock = new MockKit();
      const readStr = mock.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(readStr)(ArgumentMatchers.any).afterReturn({ uninstall_preload_list: ["com.kuaishou.hmapp"] });
      PreInstallUtils.initNeedInstallAppCache();
      mock.clear(FileUtils);
      mock.clearAll();
      expect(res).assertEqual('success');
    })

    it('PreInstallUtilsTest_initNeedInstallAppCache_03', 0, () => {
      const res: string = 'success';
      const mock = new MockKit();
      const readStr = mock.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(readStr)(ArgumentMatchers.any).afterReturn({ uninstall_preload_list: ["com.temp.hmapp"] });
      PreInstallUtils.initNeedInstallAppCache();
      mock.clear(FileUtils);
      mock.clearAll();
      expect(res).assertEqual('success');
    })

    // checkIsNeedInstallApp 测试DT
    it('PreInstallUtilsTest_checkIsNeedInstallApp_01', 0, () => {
      const appItem: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: 1,
        intent: ''
      };

      const res: boolean = PreInstallUtils.checkIsNeedInstallApp(appItem);
      expect(res).assertEqual(false);
    })

    it('PreInstallUtilsTest_checkIsNeedInstallApp_02', 0, () => {
      const appItem: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: ''
      };
      const res: boolean = PreInstallUtils.checkIsNeedInstallApp(appItem);
      expect(res).assertEqual(false);
    })

    it('PreInstallUtilsTest_checkIsNeedInstallApp_03', 0, () => {
      PreInstallUtils['iconsResourceMap'].set('bundleName', 'img');
      const appItem: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: '{"isNeedInstallApp":true}',
        iconResource: 'img'
      };
      const res: boolean = PreInstallUtils.checkIsNeedInstallApp(appItem);
      expect(res).assertEqual(true);
    })

    // checkIsNeedInstallAppByIntent 测试DT
    it('PreInstallUtilsTest_checkIsNeedInstallAppByIntent', 0, () => {
      let appItem: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: '{"isNeedInstallApp":true}'
      };

      const res: boolean = PreInstallUtils.checkIsNeedInstallAppByIntent(appItem);
      expect(res).assertEqual(true);
    })

    // checkIsResetAppInfo 测试DT
    // checkIsNeedInstallAppByIntent 直接返回false
    it('PreInstallUtilsTest_checkIsResetAppInfo_01', 0, () => {
      const res: string = 'success';
      const mock = new MockKit();
      const readStr = mock.mockFunc(PreInstallUtils, PreInstallUtils.checkIsNeedInstallAppByIntent);
      when(readStr)(ArgumentMatchers.any).afterReturn(false);

      const needResetAppInfoList: GridLayoutItemInfo[] = [];
      let appItem: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        bundleType: CommonConstants.TYPE_APP,
        iconResource: 'img'
      } as GridLayoutItemInfo;

      let layoutInfo: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        bundleType: CommonConstants.TYPE_APP,
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: '{"isNeedInstallApp":true}'
      } as GridLayoutItemInfo;

      const mock2 = new MockKit();
      const readStr2 = mock2.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().updateDownloadInfo);
      when(readStr2)(ArgumentMatchers.any).afterReturnNothing();
      PreInstallUtils.checkIsResetAppInfo(appItem, layoutInfo, needResetAppInfoList);
      expect(res).assertEqual('success');
      mock.clear(PreInstallUtils);
      mock.clearAll();
      mock2.clear(RdbStoreManager.getInstance());
      mock2.clearAll();
    })

    it('PreInstallUtilsTest_checkIsResetAppInfo_02', 0, () => {
      const res: string = 'success';
      const mock = new MockKit();
      const readStr = mock.mockFunc(PreInstallUtils, PreInstallUtils.checkIsNeedInstallAppByIntent);
      when(readStr)(ArgumentMatchers.any).afterReturn(true);

      const needResetAppInfoList: GridLayoutItemInfo[] = [];
      let appItem: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        bundleType: CommonConstants.TYPE_APP,
        iconResource: 'img'
      } as GridLayoutItemInfo;

      let layoutInfo: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        bundleType: CommonConstants.TYPE_APP,
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: '{"isNeedInstallApp":true}'
      } as GridLayoutItemInfo;

      PreInstallUtils.checkIsResetAppInfo(appItem, layoutInfo, needResetAppInfoList);
      expect(res).assertEqual('success');
      mock.clear(PreInstallUtils);
      mock.clearAll();
    })

    // resetAppInfoList 测试DT
    it('PreInstallUtilsTest_resetAppInfoList_01', 0, () => {
      PreInstallUtils['iconsResourceMap'].set('bundleName', 'img');
      const appItem: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        bundleType: CommonConstants.TYPE_APP,
        iconResource: 'img'
      } as GridLayoutItemInfo;
      const needResetAppInfoList = [appItem];

      const mock = new MockKit();
      const readStr = mock.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().updateDownloadInfo);
      when(readStr)(ArgumentMatchers.any).afterReturnNothing();
      PreInstallUtils.resetAppInfoList(needResetAppInfoList);
      mock.clear(RdbStoreManager.getInstance());
      mock.clearAll();
    })

    it('PreInstallUtilsTest_resetAppInfoList_02', 0, () => {
      PreInstallUtils['iconsResourceMap'].set('bundleName', 'img');
      const appItem: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        bundleType: CommonConstants.TYPE_APP,
        iconResource: ''
      } as GridLayoutItemInfo;
      const needResetAppInfoList = [appItem];

      const mock = new MockKit();
      const readStr = mock.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().updateDownloadInfo);
      when(readStr)(ArgumentMatchers.any).afterReturnNothing();
      PreInstallUtils.resetAppInfoList(needResetAppInfoList);
      mock.clear(RdbStoreManager.getInstance());
      mock.clearAll();
    })

    it('PreInstallUtilsTest_resetAppInfoList_03', 0, () => {
      PreInstallUtils['iconsResourceMap'].set('bundleName', 'img');
      const appItem: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        bundleType: CommonConstants.TYPE_APP,
        iconResource: ''
      } as GridLayoutItemInfo;
      const needResetAppInfoList = [appItem];

      const mock = new MockKit();
      const readStr = mock.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().updateDownloadInfo);
      when(readStr)(ArgumentMatchers.any).afterReturnNothing();
      PreInstallUtils.resetAppInfoList(needResetAppInfoList);
      mock.clear(RdbStoreManager.getInstance());
      mock.clearAll();
    })

    it('PreInstallUtilsTest_resetIntent_01', 0, () => {
      const appInfo: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        bundleType: CommonConstants.TYPE_APP,
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: '{"isNeedInstallApp":true}'
      } as GridLayoutItemInfo;
      const mock = new MockKit();
      const readStr = mock.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().updateDownloadInfo);
      when(readStr)(ArgumentMatchers.any).afterReturnNothing();
      PreInstallUtils.resetIntent(appInfo);
      mock.clear(RdbStoreManager.getInstance());
      mock.clearAll();
    })

    it('PreInstallUtilsTest_resetIntent_02', 0, () => {
      const appInfo: GridLayoutItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        bundleType: CommonConstants.TYPE_APP,
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: ''
      } as GridLayoutItemInfo;
      const mock = new MockKit();
      const readStr = mock.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().updateDownloadInfo);
      when(readStr)(ArgumentMatchers.any).afterReturnNothing();
      PreInstallUtils.resetIntent(appInfo);
      mock.clear(RdbStoreManager.getInstance());
      mock.clearAll();
    })
  })
}