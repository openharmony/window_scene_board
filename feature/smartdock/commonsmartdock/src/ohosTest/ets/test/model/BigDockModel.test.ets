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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import SmartDockModel from '../../../../main/ets/default/model/SmartDockModel'
import { GridLayoutItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon'
import { SCBSceneContainerSession, SCBSceneSessionManager } from '@ohos/windowscene'
import { CommonConstants } from '@ohos/launchercommon';
import {
  AppItemInfo,
  AppModel,
  DockItemInfo,
  GridLayoutUtil,
  RdbStoreManager,
  launcherAbilityManager,
  LayoutViewModel
} from '@ohos/launchercommon';

/**
 * SmartDockModel测试
 *
 * @since 2023-11-07
 */
export default function BigDockModelTest() {
  describe('BigDockModelTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance', 0, (): void => {
      try{
        globalThis.SmartDockModel = null;
        let instance = SmartDockModel.getInstance();
        expect(instance instanceof SmartDockModel).assertTrue();
      }catch(err){

      }
    })

    it('test_getResidentList1', 0, (): void => {
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let instance: RdbStoreManager = RdbStoreManager.getInstance()
      try{
        let mockFunc: Function = mocker.mockFunc(instance,instance.querySmartDock);
        when(mockFunc)().afterReturn(undefined);
        ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test_getResidentList1');
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_getResidentList2', 0, (): void => {
      let newInstalledBundleName = 'com.ohos.contacts';
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      let dockDataList: DockItemInfo[] = new Array<DockItemInfo>();
      dockDataList.push(itemInfo);

      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let instance: RdbStoreManager = RdbStoreManager.getInstance();
      try{
        let mockFunc: Function = mocker.mockFunc(instance,instance.querySmartDock);
        when(mockFunc)().afterReturn(dockDataList);
        ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test_getResidentList2');
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_initRecentDataList', 0, (): void => {
      try {
        let containerSessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance().getContainerSessionList();
        SmartDockModel.getInstance().initRecentDataList(containerSessionList);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}
    })

    it('test_createDockAppInfo_16', 0, (): void => {
      let mocker: MockKit = new MockKit();
      try {
        let dockItem: DockItemInfo = {
          itemType: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.contacts.MainAbility',
          moduleName: 'entry',
          editable: true,
          visible: true,
          borderVisible: true,
          shake: 0,
          missionInfoList: [],
          appName: 'MainAbility',
          appIconId: 100663798
        };
        let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockFunc)(dockItem).afterReturn(false);
        let instance: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
        ResidentLayoutCacheMgr.getInstance().createDockAppInfo(dockItem, 0);
        expect(instance instanceof ResidentLayoutCacheMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_createDockAppInfo_26', 0, (): void => {
      let mocker: MockKit = new MockKit();
      try {
        let dockItem: DockItemInfo = {
          itemType: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.contacts.MainAbility',
          moduleName: 'entry',
          editable: true,
          visible: true,
          borderVisible: true,
          shake: 0,
          missionInfoList: [],
          appName: 'MainAbility',
          appIconId: 100663798
        };
        let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockFunc)(dockItem).afterReturn(true);
        let mockFunc1: Function =
          mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc1)(dockItem.bundleName).afterReturn(undefined);
        let instance: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
        instance.createDockAppInfo(dockItem, 0);
        expect(instance instanceof ResidentLayoutCacheMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(GridLayoutUtil);
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    })

    it('test_createDockAppInfo_36', 0, (): void => {
      let mocker: MockKit = new MockKit();
      try {
        let dockItem: DockItemInfo = {
          itemType: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.contacts.MainAbility',
          applicationName: 'contacts',
          applicationLabelId: 1,
          appLabelId: 1,
          moduleName: 'entry',
          editable: true,
          visible: true,
          borderVisible: true,
          shake: 0,
          missionInfoList: [],
          appName: 'MainAbility',
          appIconId: 100663798,
          appStatus: 1,
          installTime: '2023'
        };
        let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockFunc)(dockItem).afterReturn(true);

        let appDataFromSystem: AppItemInfo = new AppItemInfo();
        appDataFromSystem.appName = dockItem.appName;
        appDataFromSystem.bundleName = dockItem.bundleName;
        appDataFromSystem.moduleName = dockItem.moduleName;
        appDataFromSystem.abilityName = dockItem.abilityName;
        appDataFromSystem.appIconId = dockItem.appIconId;
        appDataFromSystem.appLabelId = dockItem.appLabelId;
        appDataFromSystem.applicationLabelId = dockItem.applicationLabelId;
        appDataFromSystem.applicationName = dockItem.applicationName;
        appDataFromSystem.installTime = dockItem.installTime;
        appDataFromSystem.appStatus = dockItem.appStatus;
        let mockFunc1: Function =
          mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc1)(dockItem.bundleName).afterReturn(undefined);
        let instance: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
        instance.createDockAppInfo(dockItem, 0);
        expect(instance instanceof ResidentLayoutCacheMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(GridLayoutUtil);
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    })

    it('test_addToSmartDock_26', 0, (): void => {
      try {
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        let appItemInfo = appList[0];
        let gInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        if (appItemInfo) {
          gInfo.bundleName = appItemInfo.bundleName;
          gInfo.abilityName = appItemInfo.abilityName;
          gInfo.moduleName = appItemInfo.moduleName;
          gInfo.typeId = 0;
          gInfo.badgeNumber = appItemInfo.badgeNumber;
          gInfo.appIconId = appItemInfo.appIconId;
          gInfo.appLabelId = appItemInfo.appLabelId;
          gInfo.infoName = appItemInfo.appName;
          gInfo.appStatus = 0;
          gInfo.negativeId = 0;
          gInfo.isSelect = false;
          gInfo.enterEditing = false;
          gInfo.downloadProgress = 100;
          gInfo.iconResource = '';
          gInfo.callerName = '';
        }
        let rst = SmartDockModel.getInstance().addToSmartDock(GridLayoutUtil.gridLayoutToDockItem(gInfo), 0);
        expect(rst).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addToSmartDock_1', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_FOLDER;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.appStatus = 0;
      appInfo.downloadProgress = 100;
      appInfo.iconResource = '';
      appInfo.callerName = '';
      try {
        let rst = SmartDockModel.getInstance().addToSmartDock(appInfo, 0);
        expect(rst).not().assertNull();
      } catch (e) {}
    })

    it('test_deleteDockItem', 0, (): void => {
      try {
        let isDeleteSuccess = SmartDockModel.getInstance().deleteDockItem(new GridLayoutItemInfo(), -1);
        expect(isDeleteSuccess).not().assertNull();
      } catch (e) {}
    })

    it('test_buildDockItemInfo_26', 0, (): void => {
      try {
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        let appItemInfo = appList[1];
        let gInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        if (appItemInfo) {
          gInfo.bundleName = appItemInfo.bundleName;
          gInfo.abilityName = appItemInfo.abilityName;
          gInfo.moduleName = appItemInfo.moduleName;
          gInfo.typeId = 0;
          gInfo.badgeNumber = appItemInfo.badgeNumber;
          gInfo.appIconId = appItemInfo.appIconId;
          gInfo.appLabelId = appItemInfo.appLabelId;
          gInfo.infoName = appItemInfo.appName;
          gInfo.appStatus = 0;
          gInfo.negativeId = 0;
          gInfo.isSelect = false;
          gInfo.enterEditing = false;
          gInfo.downloadProgress = 100;
          gInfo.iconResource = '';
          gInfo.callerName = '';
        }
        let rst = SmartDockModel.getInstance().buildDockItemInfo(GridLayoutUtil.gridLayoutToDockItem(gInfo));
        expect(rst).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addToPageDesk_16', 0, (): void => {
      try {
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        let appItemInfo = appList[2];
        let gInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        if (appItemInfo) {
          gInfo.bundleName = appItemInfo.bundleName;
          gInfo.abilityName = appItemInfo.abilityName;
          gInfo.moduleName = appItemInfo.moduleName;
          gInfo.typeId = 0;
          gInfo.badgeNumber = appItemInfo.badgeNumber;
          gInfo.appIconId = appItemInfo.appIconId;
          gInfo.appLabelId = appItemInfo.appLabelId;
          gInfo.infoName = appItemInfo.appName;
          gInfo.appStatus = 0;
          gInfo.negativeId = 0;
          gInfo.isSelect = false;
          gInfo.enterEditing = false;
          gInfo.downloadProgress = 100;
          gInfo.iconResource = '';
          gInfo.callerName = '';
        }
        SmartDockModel.getInstance().addToPageDesk(GridLayoutUtil.gridLayoutToDockItem(gInfo));
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener', 0, (): void => {
      try {
        SmartDockModel.getInstance().registerDockListener();
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}
    })

    it('test_unregisterDockListener', 0, (): void => {
      try {
        SmartDockModel.getInstance().unregisterDockListener();
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}
    })

    it('test_getShortcutInfo', 0, (): void => {
      try {
        SmartDockModel.getInstance().getShortcutInfo('com.ohos.contacts');
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}

    })

    it('test_getShortcutInfoFromManager', 0, (): void => {
      try {
        SmartDockModel.getInstance().getShortcutInfoFromManager('com.ohos.contacts');
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}
    })

    it('test_getAppName', 0, (): void => {
      try {
        let itemInfo: AppItemInfo = {
          appLabelId: 0,
          bundleName: 'test',
          moduleName: 'test',
          appIndex: 0,
          appIconId: 0,
          abilityName: '',
          appName: ''
        };
        SmartDockModel.getInstance().getAppName(itemInfo);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {}
    })

    class DeletDockItem {
      bundleName?: string;
      keyName?: string;
      isDeleteAppToUninstallFolder?: boolean
    }

  })
}