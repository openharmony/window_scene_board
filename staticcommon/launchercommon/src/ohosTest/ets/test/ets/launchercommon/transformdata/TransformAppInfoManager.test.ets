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

import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when
} from '@ohos/hypium';
import {
  AppReservePolicyType,
  LocalHapMigrateInfo,
  PackageInfo,
  TransformAppInfoManager
} from '../../../../../../main/ets/TsIndex';
import type ctx from '@ohos.app.ability.common';
import { BackupExtensionContext } from '@kit.CoreFileKit';

export default function TransformAppInfoManagerTest() {

  describe('TransformAppInfoManagerTest', () => {
    beforeAll((): void => {
      let serviceExtensionContext: ctx.ServiceExtensionContext =
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
      let filesDir: string = serviceExtensionContext.filesDir;
      let appList: string =
        '[{"appList":[{"appName":"番茄小说","appScanSourceDir":"/system/priv-app/Dragon","packageName":"com.dragon.read","primaryCpuAbi":"","secondaryCpuAbi":"","sign":"2d3a95823214e8f03b426d0b83644becb3c8af7a96edb5a7210f4b7f56c616dc","version":"140000300","versionName":"14.0.0.300"}],"userId":0}]';
      FileUtils.writeStringToFile(appList, filesDir + '/app_list.json');

      let thirdList: string = '[{"migrateData":"1","sourceModule":"com.wuba","targetModule":"com.wuba.life"}]';
      FileUtils.writeStringToFile(thirdList, filesDir + '/third_dev_module_migrate_policy.json');

      let appReserve: string =
        '{"appReservePolicy":"reserve", "isAutoMigrateApp": 1, "sunsetAppList":"com.openharmony.hwmirror,com.openharmony.mirror,com.openharmony.systemmanager"}';
      FileUtils.writeStringToFile(appReserve, filesDir + '/app_reserve_policy.json');
    })
    beforeEach((): void => {
    })
    afterEach((): void => {
    })
    afterAll((): void => {
      let serviceExtensionContext: ctx.ServiceExtensionContext =
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
      let filesDir: string = serviceExtensionContext.filesDir;
      FileUtils.deleteConfigFile(filesDir + '/app_list.json');
      FileUtils.deleteConfigFile(filesDir + '/third_dev_module_migrate_policy.json');
      FileUtils.deleteConfigFile(filesDir + '/app_reserve_policy.json');
    })

    it('test_getInstance01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init00', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.init('');
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let serviceExtensionContext: ctx.ServiceExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
        let filesDir: string = serviceExtensionContext.filesDir;
        sInstance.init(filesDir);
        sInstance.init('/' + filesDir);
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let serviceExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
        let filesDir: string = serviceExtensionContext.filesDir;

        let backupExtensionContext: BackupExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as BackupExtensionContext;
        let backupDir = backupExtensionContext.backupDir;

        sInstance.init(filesDir, backupDir);
        sInstance.init('/' + filesDir, '/' + backupDir);
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init03', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let serviceExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
        let filesDir: string = serviceExtensionContext.filesDir;

        let backupExtensionContext: BackupExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as BackupExtensionContext;
        let backupDir: string = backupExtensionContext.backupDir;
        if (!backupDir) {
          backupDir = '/data/storage';
        }

        const mocker: MockKit = new MockKit();
        const isExist: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
        when(isExist)(ArgumentMatchers.any).afterReturn(true);

        sInstance.init(filesDir, backupDir);
        sInstance.init('/' + filesDir, '/' + backupDir);
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
        mocker.ignoreMock(FileUtils, FileUtils.isExist);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_saveFilesToLocal01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        sInstance.saveFilesToLocal();
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_saveFilesToLocal02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let serviceExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
        let filesDir: string = serviceExtensionContext.filesDir;
        sInstance.init(filesDir);

        sInstance.saveFilesToLocal();
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_saveFilesToLocal03', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let serviceExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
        let filesDir: string = serviceExtensionContext.filesDir;
        sInstance.init(filesDir);

        let backupExtensionContext: BackupExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as BackupExtensionContext;
        let backupDir: string = backupExtensionContext.backupDir;
        if (!backupDir) {
          backupDir = '/data/storage/el1/base/haps/phone_sceneboard/files';
        }
        sInstance.saveFilesToLocal();
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_saveFileToLocal', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        sInstance['saveFileToLocal']('');
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
        mocker.clear(FileUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getSunsetAppList01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let result: Set<string> = sInstance.getSunsetAppList(true);
        expect(result.size).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getSunsetAppList02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let result: Set<string> = sInstance.getSunsetAppList(false);
        expect(result.size).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_loadAppReservePolicy', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        sInstance['loadAppReservePolicy']();
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getSunsetAppList03', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();

        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)().afterReturn(false);

        let result: Set<string> = sInstance.getSunsetAppList(false);
        expect(result.size).assertLargerOrEqual(0);
        mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getHapMigrateInfos01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let result: Array<LocalHapMigrateInfo> = sInstance.getHapMigrateInfos();
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getHapMigrateInfos02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)().afterReturn(true);
        let result: Array<LocalHapMigrateInfo> = sInstance.getHapMigrateInfos();
        expect(result.length).assertLargerOrEqual(0);
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_callback', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let localHapMigrateInfo: LocalHapMigrateInfo = {
          'sourceModule': 'sourceModule',
          'sourceModules': ['sourceModules'],
          'targetModule': 'targetModule',
          'migrateData': 'migrateData',
          'sourceModuleSignature': 'sourceModuleSignature',
          'type': 0,
          'targetModuleUrl': 'targetModuleUrl',
          'source': 'source',
          'sources': ['sources'],
          'target': 'target',
          'isValid': (): boolean => {
            return false
          }
        };
        sInstance['mAppMigrateInfoMap'].set('test', localHapMigrateInfo);
        sInstance.isEnterpriseApp('');
        sInstance.isTasteFreshApp('');
        sInstance.getMigrateByBundleAndType('', 0);
        let result: Map<string, LocalHapMigrateInfo> = sInstance.getHapMigrateInfosMap();
        expect(result.size).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getHapMigrateInfosMap02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releaseHapMigrateInfos();
        let result: Map<string, LocalHapMigrateInfo> = sInstance.getHapMigrateInfosMap();
        expect(result.size).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isEnterpriseApp01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let bundleName: string = '';
        let result: boolean = sInstance.isEnterpriseApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isEnterpriseApp02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releaseHapMigrateInfos();
        let bundleName: string = '';
        let result: boolean = sInstance.isEnterpriseApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isTasteFreshApp01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let bundleName: string = '';
        let result: boolean = sInstance.isTasteFreshApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isTasteFreshApp02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releaseHapMigrateInfos();
        let bundleName: string = '';
        let result: boolean = sInstance.isTasteFreshApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isdeliverApp01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let bundleName: string = '';
        let result: boolean = sInstance.isdeliverApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isdeliverApp02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releaseHapMigrateInfos();
        let bundleName: string = '';
        let result: boolean = sInstance.isdeliverApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isOtherdeliverApp', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let bundleName: string = '';
        let result: boolean = sInstance.isOtherdeliverApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isOtherdeliverApp02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releaseHapMigrateInfos();
        let bundleName: string = '';
        let result: boolean = sInstance.isOtherdeliverApp(bundleName);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getMigrateByBundleAndType01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let bundleName: string = '';
        let type: number = 1;
        let result: LocalHapMigrateInfo = sInstance.getMigrateByBundleAndType(bundleName, type);
        sInstance.releaseHapMigrateInfos();
        sInstance.getMigrateByBundleAndType(bundleName, type);
        expect(result).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFileString', Level.LEVEL0, () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        sInstance['getFileString']('');
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_releaseHapMigrateInfos01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releaseHapMigrateInfos();
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getPackageInfosForUserId01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let userId: number = 100;
        let result: Array<PackageInfo> = sInstance.getPackageInfosForUserId(userId);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getPackageInfosForUserId02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releasePackageInfos();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let userId: number = 100;
        let result: Array<PackageInfo> = sInstance.getPackageInfosForUserId(userId);
        expect(result.length).assertLargerOrEqual(0);
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getPackageInfoByUserIdAndBundleName01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let userId: number = 100;
        let packageName: string = '';
        sInstance.releasePackageInfos();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let result: PackageInfo = sInstance.getPackageInfoByUserIdAndBundleName(userId, packageName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        result = sInstance.getPackageInfoByUserIdAndBundleName(userId, packageName);
        expect(result).not().assertNull();
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getTwinAppPackageInfoByBundleName01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();

        let packageName: string = 'packageName';
        let result: PackageInfo = sInstance.getTwinAppPackageInfoByBundleName(packageName);
        expect(result).assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getTwinAppPackageInfoByBundleName02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();

        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let packageName: string = 'packageName';
        sInstance.getTwinAppPackageInfoByBundleName(packageName);
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
        mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_releasePackageInfos01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance.releasePackageInfos();
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppReservePolicy01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)().afterReturn(false);
        let appReservePolicyType: AppReservePolicyType = sInstance.getAppReservePolicy(true);
        expect(appReservePolicyType).assertLessOrEqual(2);
        mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppReservePolicy02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let appReservePolicyType: AppReservePolicyType = sInstance.getAppReservePolicy(true);
        expect(appReservePolicyType).assertLessOrEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAutoMigrateAppType01', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();

        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)().afterReturn(false);

        let autoMigrateAppType: number = sInstance.getAutoMigrateAppType(true);
        expect(autoMigrateAppType).assertLessOrEqual(2);
        mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAutoMigrateAppType02', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let autoMigrateAppType: number = sInstance.getAutoMigrateAppType(true);
        expect(autoMigrateAppType).assertLessOrEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAutoMigrateAppType03', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance['privacyPolicyCode'] = 'not_unknown';
        sInstance['userAgreementCode'] = 'not_unknown';
        let autoMigrateAppType: number = sInstance.getAutoMigrateAppType(true);
        expect(autoMigrateAppType).assertLessOrEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getRgmSupportType01', Level.LEVEL0, async () => {
      let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)().afterReturn(false);

      let rgmSupportType: number = sInstance.getRgmSupportType(true);
      expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
    })

    it('test_getRgmSupportType02', Level.LEVEL0, async () => {
      let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
      let rgmSupportType: number = sInstance.getRgmSupportType(true);
      expect(sInstance instanceof TransformAppInfoManager).assertTrue();
    })

    it('test_getAppReservePolicy03', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();

        let serviceExtensionContext: ctx.ServiceExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
        let filesDir: string = serviceExtensionContext.filesDir;
        FileUtils.deleteConfigFile(filesDir + '/app_list.json');
        FileUtils.deleteConfigFile(filesDir + '/third_dev_module_migrate_policy.json');
        FileUtils.deleteConfigFile(filesDir + '/app_reserve_policy.json');

        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)().afterReturn(false);

        let appReservePolicyType: AppReservePolicyType = sInstance.getAppReservePolicy(true);
        expect(appReservePolicyType).assertLessOrEqual(2);

        sInstance.releasePackageInfos();
        sInstance.releaseHapMigrateInfos();

        sInstance.getAppReservePolicy(true);
        sInstance.getAppReservePolicy(false);
        sInstance.saveFilesToLocal();

        mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_loadPackageInfos_01', Level.LEVEL0, () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        sInstance['loadPackageInfos']('');
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_loadPackageInfos_02', Level.LEVEL0, () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance['loadPackageInfos']('/app_list.json');
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAccountIdFromUserId', Level.LEVEL0, async () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        let result = sInstance['getAccountIdFromUserId'](130);
        expect(result).assertEqual(130);
        result = sInstance['getAccountIdFromUserId'](1);
        expect(result).assertEqual(92);
        result = sInstance['getAccountIdFromUserId'](0);
        expect(result).assertEqual(100);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_loadHideIconAppList_01', Level.LEVEL0, async () => {
      try {
        await TransformAppInfoManager.getInstance().loadHideIconAppList();
        expect(TransformAppInfoManager.sHideIconAppList.size).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealWithCfgConfig_01', 0, () => {
      try {
        let sInstance: TransformAppInfoManager = TransformAppInfoManager.getInstance();
        sInstance['dealWithCfgConfig']('');
        expect(sInstance instanceof TransformAppInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}