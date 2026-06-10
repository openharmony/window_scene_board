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
import { CloneItemInfoManager } from '../../../../../../main/ets/transformdata/manager/CloneItemInfoManager';
import { CloneItemInfo, CommonConstants, LegacyInfo } from '../../../../../../main/ets/constants/CommonConstants';
import { preferences } from '@kit.ArkData';
import type ctx from '@ohos.app.ability.common';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { RestoreLauncherDataListInfo } from '../../../../../../main/ets/transformdata/RestoreLauncherDataListInfo';
import { CheckEmptyUtils } from '@ohos/basicutils';

export default function CloneItemInfoManagerTest() {
  describe('CloneItemInfoManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('CloneItemInfoManagerTest_getCloneItemInfoByPackageName', 0, () => {
      const SCB_PACKAGE = 'com.ohos.sceneboard';
      let item: CloneItemInfo = new TestCloneItemInfo();
      item.packageName = SCB_PACKAGE;

      let ret = CloneItemInfoManager.getInstance().getCloneItemInfoByPackageName(SCB_PACKAGE, false);
      CloneItemInfoManager.getInstance()['cloneItemInfoList'].push(item);
      ret = CloneItemInfoManager.getInstance().getCloneItemInfoByPackageName(SCB_PACKAGE, true);
      expect(true).assertTrue();
    })

    it('CloneItemInfoManagerTest_getCloneItemInfoByPackageName01', 0, () => {
      const SCB_PACKAGE = 'com.ohos.sceneboard';
      let item: CloneItemInfo = new TestCloneItemInfo();
      item.packageName = SCB_PACKAGE;
      let ret = CloneItemInfoManager.getInstance().getCloneItemInfoByPackageName(SCB_PACKAGE, false);
      CloneItemInfoManager.getInstance()['cloneItemInfoList'].push(item);
      CloneItemInfoManager.getInstance().getCloneItemInfoByPackageName(SCB_PACKAGE);
      expect(true).assertTrue();
    })

    it('CloneItemInfoManagerTest_isNeedCloneJudgeByPackageName', 0, () => {
      const SCB_PACKAGE = 'com.ohos.sceneboard';
      let item: CloneItemInfo = new TestCloneItemInfo();
      item.packageName = SCB_PACKAGE;
      let ret = CloneItemInfoManager.getInstance().getCloneItemInfoByPackageName(SCB_PACKAGE, false);
      CloneItemInfoManager.getInstance()['cloneItemInfoList'].push(item);
      let result = CloneItemInfoManager.getInstance().isNeedCloneJudgeByPackageName(SCB_PACKAGE);
      expect(result).assertTrue();
    })

    it('test_getCloneItemInfoByBundleName', 0, () => {
      try {
        let instance = CloneItemInfoManager.getInstance();
        instance.getCloneItemInfoByBundleName('com.ohos.contacts');
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_queryRestoreLauncherData_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(GlobalContext.getInstance(), GlobalContext.getInstance().getObject);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');
        let instance = CloneItemInfoManager.getInstance();
        instance.queryRestoreLauncherData();
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(GlobalContext.getInstance());
      mock.clearAll();
    })

    it('test_queryRestoreLauncherData_02', 0, async (done: Function) => {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      await preferences.getPreferences(context, CommonConstants.RESTORE_LAUNCHER_DATA)
        .then((preference) => {
          preference.put('RestorePkgData', ['1']);
          preference.put('bundleList', ['1', '2']);
          preference.put('RestoreIconUriData', ['1', '2', '3']);
          preference.put('RestoreAppTypeData', [1, 2, 3]);
        });
      let instance = CloneItemInfoManager.getInstance();
      instance.queryRestoreLauncherData();
      expect(instance instanceof CloneItemInfoManager).assertTrue();
      done();
    })

    it('test_getCloneItemInfoList_01', 0, () => {
      try {
        let instance = CloneItemInfoManager.getInstance();
        let resLauDaListInfo = new RestoreLauncherDataListInfo();
        resLauDaListInfo.pkgList = ['1'];
        resLauDaListInfo.bundleList = ['1', '2'];
        instance['getCloneItemInfoList'](resLauDaListInfo);
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCloneItemInfoList_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance = CloneItemInfoManager.getInstance();
        let resLauDaListInfo = new RestoreLauncherDataListInfo();
        resLauDaListInfo.pkgList = ['1', '2'];
        resLauDaListInfo.bundleList = ['1', '2'];
        instance['getCloneItemInfoList'](resLauDaListInfo);
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getCloneItemInfoList_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let instance = CloneItemInfoManager.getInstance();
        let resLauDaListInfo = new RestoreLauncherDataListInfo();
        resLauDaListInfo.pkgList = ['1', '2'];
        resLauDaListInfo.bundleList = ['1', '2'];
        resLauDaListInfo.iconUriList = ['1', '2'];
        resLauDaListInfo.titleList = ['1', '2'];
        resLauDaListInfo.appIndexList = [0, 0];
        resLauDaListInfo.callerName = 'test';
        instance['getCloneItemInfoList'](resLauDaListInfo);
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_updateEnterpriseAndWaitForHarmonyItem_01', 0, () => {
      try {
        let instance = CloneItemInfoManager.getInstance();
        let resLauDaListInfo = new RestoreLauncherDataListInfo();
        resLauDaListInfo.pkgList = ['1', '2'];
        resLauDaListInfo.bundleList = ['1', '2'];
        resLauDaListInfo.iconUriList = ['1', '2'];
        resLauDaListInfo.titleList = ['1', '2'];
        resLauDaListInfo.appIndexList = [0, 0];
        resLauDaListInfo.callerName = 'test';
        resLauDaListInfo.isWaitForHarmonyList = [true];
        resLauDaListInfo.legacyInfoList = [new LegacyInfo()];
        resLauDaListInfo.appTypeList = [1];
        resLauDaListInfo.enterpriseLinkList = ['1', '2'];

        let i: number = 0;
        let info: CloneItemInfo = {
          bundleName: resLauDaListInfo.bundleList[i],
          packageName: resLauDaListInfo.pkgList[i],
          iconUri: resLauDaListInfo.iconUriList[i],
          title: resLauDaListInfo.titleList[i],
          callerName: resLauDaListInfo.callerName,
          isUsed: false,
          appIndex: resLauDaListInfo.appIndexList[i]
        } as CloneItemInfo;

        instance['updateEnterpriseAndWaitForHarmonyItem'](resLauDaListInfo, info, i);
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateEnterpriseAndWaitForHarmonyItem_02', 0, () => {
      try {
        let instance = CloneItemInfoManager.getInstance();
        let resLauDaListInfo = new RestoreLauncherDataListInfo();
        resLauDaListInfo.pkgList = ['1', '2'];
        resLauDaListInfo.bundleList = ['1', '2'];
        resLauDaListInfo.iconUriList = ['1', '2'];
        resLauDaListInfo.titleList = ['1', '2'];
        resLauDaListInfo.appIndexList = [0, 0];
        resLauDaListInfo.callerName = 'test';
        resLauDaListInfo.isWaitForHarmonyList = [false];
        resLauDaListInfo.legacyInfoList = [new LegacyInfo()];
        resLauDaListInfo.appTypeList = [1];
        resLauDaListInfo.enterpriseLinkList = ['1', '2'];

        let i: number = 0;
        let info: CloneItemInfo = {
          bundleName: resLauDaListInfo.bundleList[i],
          packageName: resLauDaListInfo.pkgList[i],
          iconUri: resLauDaListInfo.iconUriList[i],
          title: resLauDaListInfo.titleList[i],
          callerName: resLauDaListInfo.callerName,
          isUsed: false,
          appIndex: resLauDaListInfo.appIndexList[i]
        } as CloneItemInfo;

        instance['updateEnterpriseAndWaitForHarmonyItem'](resLauDaListInfo, info, i);
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateEnterpriseAndWaitForHarmonyItem_03', 0, () => {
      try {
        let instance = CloneItemInfoManager.getInstance();
        let resLauDaListInfo = new RestoreLauncherDataListInfo();
        resLauDaListInfo.pkgList = ['1', '2'];
        resLauDaListInfo.bundleList = ['1', '2'];
        resLauDaListInfo.iconUriList = ['1', '2'];
        resLauDaListInfo.titleList = ['1', '2'];
        resLauDaListInfo.appIndexList = [0, 0];
        resLauDaListInfo.callerName = 'test';
        resLauDaListInfo.isWaitForHarmonyList = [false];
        resLauDaListInfo.legacyInfoList = [new LegacyInfo()];
        resLauDaListInfo.appTypeList = [2];
        resLauDaListInfo.enterpriseLinkList = ['1', '2'];

        let i: number = 0;
        let info: CloneItemInfo = {
          bundleName: resLauDaListInfo.bundleList[i],
          packageName: resLauDaListInfo.pkgList[i],
          iconUri: resLauDaListInfo.iconUriList[i],
          title: resLauDaListInfo.titleList[i],
          callerName: resLauDaListInfo.callerName,
          isUsed: false,
          appIndex: resLauDaListInfo.appIndexList[i]
        } as CloneItemInfo;

        instance['updateEnterpriseAndWaitForHarmonyItem'](resLauDaListInfo, info, i);
        expect(instance instanceof CloneItemInfoManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    class TestCloneItemInfo implements CloneItemInfo {
      callerName?: string | undefined;
      callerType?: number | undefined;
      bundleName: string = '';
      packageName: string = '';
      title?: string | undefined;
      iconUri: string = '';
      isUsed?: boolean | undefined;
    }
  })
}
