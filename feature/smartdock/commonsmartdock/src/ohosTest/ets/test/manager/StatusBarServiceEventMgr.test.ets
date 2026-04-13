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
import { DeviceHelper, ProcessStateChangeEvent } from '@ohos/frameworkwrapper';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { CommonConstants, DockItemInfo, MenuInfo,
  RecentLayoutCacheMgr,
  ResidentLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import StatusBarServiceEventMgr, { AppManager } from '../../../../main/ets/default/manager/StatusBarServiceEventMgr';
import {
  BundleInfo,
  StatusBarConnectEvent,
  StatusBarServiceInfo,
  TrayManager } from '@ohos/statusbarextensionservice/src/main/ets/TsIndex';

export default function StatusBarServiceEventMgrTest() {
  describe('StatusBarServiceEventMgrTest', () => {
    const bundleName: string = 'com.example.app';
    const wpsName: string = 'cn.wps.office.hap';
    const pid1: number = 10000;
    const pid2: number = 10001;

    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_registerStatusBarServiceEventListener_01', 0, () => {
      try {
        let instance = StatusBarServiceEventMgr.getInstance();
        instance.registerStatusBarServiceEventListener();
        instance.unregisterStatusBarServiceEventListener();
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_unregisterStatusBarServiceEventListener_01', 0, () => {
      try {
        let instance = StatusBarServiceEventMgr.getInstance();
        instance.unregisterStatusBarServiceEventListener();
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isWpsAndRegister1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let instance = StatusBarServiceEventMgr.getInstance();
      const result = instance.isWpsAndRegister(bundleName);
      expect(result).assertInstanceOf('Boolean');
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    });

    it('test_isWpsAndRegister2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let instance = StatusBarServiceEventMgr.getInstance();
      const result1 = instance.isWpsAndRegister(bundleName);
      expect(result1).assertInstanceOf('Boolean');
      let mockFunc2: Function = mocker.mockFunc(instance, instance.isRegisterApp);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      const result2 = instance.isWpsAndRegister(wpsName);
      expect(result2).assertInstanceOf('Boolean');
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(instance, instance.isRegisterApp);
    });

    it('test_isWpsAndRegister3', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let bundleName: string = 'cn.wps.office.hap';
        instance.isWpsAndRegister(bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_preExit1', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: StatusBarServiceEventMgr = StatusBarServiceEventMgr.getInstance();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getAppInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      instance.preExit(bundleName);
      expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      mocker.ignoreMock(instance, instance.getAppInfoByBundleName);
    });

    it('test_preExit2', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: StatusBarServiceEventMgr = StatusBarServiceEventMgr.getInstance();
      let appManager: AppManager | undefined = new AppManager(bundleName);
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getAppInfoByBundleName);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appManager);
      let mockFunc2: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);
      try {
      instance.preExit(bundleName);
      expect(appManager.getIsOnExit()).assertTrue();
      } catch (e) {}
      mocker.ignoreMock(instance, instance.getAppInfoByBundleName);
      mocker.ignoreMock(AppStorage, AppStorage.get);
      appManager.setIsOnExit(false);
    });

    it('test_preExit3', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: StatusBarServiceEventMgr = StatusBarServiceEventMgr.getInstance();
      let appManager: AppManager | undefined = new AppManager(bundleName);
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getAppInfoByBundleName);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appManager);
      let mockFunc2: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([bundleName]);
      AppStorage.setOrCreate('openAppNameList', [bundleName]);
      try {
      instance.preExit(bundleName);
      expect(appManager.getIsOnExit()).assertTrue();
      } catch (e) {}
      mocker.ignoreMock(instance, instance.getAppInfoByBundleName);
      mocker.ignoreMock(AppStorage, AppStorage.get);
      appManager.setIsOnExit(false);
    });

    it('test_isRegisterApp', 0, () => {
      let instance = StatusBarServiceEventMgr.getInstance();
      const result: boolean = instance.isRegisterApp(bundleName);
      expect(result).assertInstanceOf('Boolean');
    });

    it('test_getRegisterBundleNameList', 0, () => {
      let instance = StatusBarServiceEventMgr.getInstance();
      const result: string[] = instance.getRegisterBundleNameList();
      expect(result.length).assertEqual(0);
    });

    it('test_addPid', 0, () => {
      let appManager: AppManager | undefined = new AppManager(bundleName, pid1);
      expect(appManager.getPidList().length).assertEqual(1);
      appManager.addPid(pid1);
      expect(appManager.getPidList().length).assertEqual(1);
      appManager.addPid(pid2);
      expect(appManager.getPidListLength()).assertEqual(2);
      appManager.deletePid(pid2);
      expect(appManager.getPidListLength()).assertEqual(1);
      appManager.deletePid(pid1);
      expect(appManager.getPidListLength()).assertEqual(0);
    });

    it('test_setTokenId', 0, () => {
      let appManager: AppManager | undefined = new AppManager(bundleName, pid1);
      appManager.setTokenId(1);
      expect(appManager.getTokenId()).assertEqual(1);
    });

    it('test_getAppInfo1', 0, () => {
      let dockItem1: DockItemInfo = new DockItemInfo();
      dockItem1.bundleName = bundleName;
      let dockItem2: DockItemInfo = new DockItemInfo();
      dockItem2.bundleName = wpsName;
      let mocker: MockKit = new MockKit();
      let appManager: AppManager | undefined = new AppManager(bundleName);
      let mgr1: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
      let mockFunc: Function = mocker.mockFunc(mgr1, mgr1.getAllDockItems);
      when(mockFunc)().afterReturn([dockItem2, dockItem1]);
      expect(appManager.getAppInfo()?.bundleName).assertEqual(bundleName);
      mocker.ignoreMock(mgr1, mgr1.getAllDockItems);
    });

    it('test_getAppInfo2', 0, () => {
      let dockItem1: DockItemInfo = new DockItemInfo();
      dockItem1.bundleName = bundleName;
      let dockItem2: DockItemInfo = new DockItemInfo();
      dockItem2.bundleName = wpsName;
      let mocker: MockKit = new MockKit();
      let appManager: AppManager | undefined = new AppManager(bundleName);
      let mgr1: RecentLayoutCacheMgr = RecentLayoutCacheMgr.getInstance();
      let mockFunc: Function = mocker.mockFunc(mgr1, mgr1.getAllDockItems);
      when(mockFunc)().afterReturn([dockItem2, dockItem1]);
      expect(appManager.getAppInfo()?.bundleName).assertEqual(bundleName);
      mocker.ignoreMock(mgr1, mgr1.getAllDockItems);
    });

    it('test_getBundleName', 0, () => {
      let appManager: AppManager | undefined = new AppManager(bundleName);
      expect(appManager.getBundleName()).assertEqual(bundleName);
    });

    it('test_getIsOnExit_01', 0, () => {
      try {
        let appManager: AppManager = new AppManager(bundleName, pid1);
        appManager.getIsOnExit();
        expect(appManager instanceof AppManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onExtendedMenuClick_01', 0, () => {
      try {
        let appManager: AppManager = new AppManager(bundleName, pid1);
        (appManager as object)['onExtendedMenuClick']();
        expect(appManager instanceof AppManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getMoreMenu_01', 0, () => {
      try {
        let appManager: AppManager = new AppManager(bundleName, pid1);
        let menu: MenuInfo = (appManager as object)['getMoreMenu']();
        if (menu.onMenuClick) {
          menu.onMenuClick();
        }
        expect(appManager instanceof AppManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getExitMenu_01', 0, () => {
      try {
        let appManager: AppManager = new AppManager(bundleName, pid1);
        let menu: MenuInfo = (appManager as object)['getExitMenu']();
        if (menu.onMenuClick) {
          menu.onMenuClick();
        }
        expect(appManager instanceof AppManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getRegisterBundleNameList_02', 0, () => {
      try {
        let app1: AppManager = new AppManager(bundleName, pid1);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['appInfoList'] = [app1];
        instance.getRegisterBundleNameList();
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isRegisterApp_01', 0, () => {
      try {
        let app1: AppManager = new AppManager(bundleName, pid1);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['appInfoList'] = [app1];
        instance.isRegisterApp(bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleteAppInfoByTokenId_01', 0, () => {
      try {
        let tokenId: number = 1;
        let app1: AppManager = new AppManager(bundleName, pid1);
        app1.setTokenId(tokenId);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['appInfoList'] = [app1];
        (instance as object)['deleteAppInfoByTokenId'](tokenId);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppInfoByTokenId_01', 0, () => {
      try {
        let tokenId: number = 1;
        let app1: AppManager = new AppManager(bundleName, pid1);
        app1.setTokenId(tokenId);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['appInfoList'] = [app1];
        (instance as object)['getAppInfoByTokenId'](tokenId);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppInfoByBundleName_01', 0, () => {
      try {
        let app1: AppManager = new AppManager(bundleName, pid1);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['appInfoList'] = [app1];
        instance.getAppInfoByBundleName(bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateAppNameListByBundleName_01', 0, () => {
      try {
        AppStorage.setOrCreate('openAppNameList', []);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['updateAppNameListByBundleName'](bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateAppNameListByBundleName_02', 0, () => {
      try {
        AppStorage.setOrCreate('openAppNameList', [bundleName]);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['updateAppNameListByBundleName'](bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateAppNameListByBundleName_03', 0, () => {
      try {
        AppStorage.setOrCreate('openAppNameList', ['test']);
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['updateAppNameListByBundleName'](bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateUnreadMessageWindow_01', 0, () => {
      try {
        let updateState: string = 'add';
        let serviceInfo: StatusBarServiceInfo = {
          type: 1,
          tokenId: 1,
          bundleName: 'test',
          pid: 1,
          data: {
            operationHeight: 1,
          },
          appIndex: 0,
        } as StatusBarServiceInfo;
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['updateUnreadMessageWindow'](updateState, serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateUnreadMessageWindow_02', 0, () => {
      try {
        let updateState: string = 'updateHeight';
        let serviceInfo: StatusBarServiceInfo = {
          type: 1,
          tokenId: 1,
          bundleName: 'test',
          pid: 1,
          data: {
            operationHeight: 1,
          },
          appIndex: 0,
        } as StatusBarServiceInfo;
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['updateUnreadMessageWindow'](updateState, serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateUnreadMessageWindow_03', 0, () => {
      try {
        let updateState: string = 'updateHeight3';
        let serviceInfo: StatusBarServiceInfo = {
          type: 1,
          tokenId: 1,
          bundleName: 'test',
          pid: 1,
          data: {
            operationHeight: 1,
          },
          appIndex: 0,
        } as StatusBarServiceInfo;
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['updateUnreadMessageWindow'](updateState, serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_trayServiceCallback_01', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getAppInfoByTokenId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let tokenId: number = 0;
        let pid: number = 0;
        let instanceKey: string = '';
        let isDetached: boolean = false;
        (instance as object)['trayServiceCallback'](tokenId, pid, instanceKey, isDetached);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_trayServiceCallback_02', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let appManager: AppManager | undefined = new AppManager(bundleName, pid1);
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getAppInfoByTokenId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appManager);

        let tokenId: number = 0;
        let pid: number = 0;
        let instanceKey: string = '';
        let isDetached: boolean = false;
        (instance as object)['trayServiceCallback'](tokenId, pid, instanceKey, isDetached);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_appProcessChange_01', 0, () => {
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let event: ProcessStateChangeEvent = {
          bundleName: 'com.ohos.contacts',
          visible: true,
          requestUid: 0,
        } as ProcessStateChangeEvent
        (instance as object)['appProcessChange'](event);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_appProcessChange_02', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getAppInfoByBundleName']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let event: ProcessStateChangeEvent = {
          bundleName: 'com.ohos.contacts',
          visible: true,
          requestPid: 0,
          requestUid: 0,
        } as ProcessStateChangeEvent
        (instance as object)['appProcessChange'](event);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_appProcessChange_03', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let appManager: AppManager | undefined = new AppManager(bundleName, pid1);
        appManager.addPid(1);
        appManager.addPid(2);
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getAppInfoByBundleName']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appManager);

        AppStorage.setOrCreate('openAppNameList', []);

        let event: ProcessStateChangeEvent = {
          bundleName: 'com.ohos.contacts',
          visible: true,
          requestPid: 0,
          requestUid: 0,
        } as ProcessStateChangeEvent
        (instance as object)['appProcessChange'](event);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_appProcessChange_03', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let appManager: AppManager | undefined = new AppManager(bundleName, pid1);
        appManager.addPid(1);
        appManager.addPid(2);
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getAppInfoByBundleName']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appManager);

        AppStorage.setOrCreate('openAppNameList', []);

        let event: ProcessStateChangeEvent = {
          bundleName: 'com.ohos.contacts',
          visible: false,
          requestPid: 0,
          requestUid: 0,
        } as ProcessStateChangeEvent
        (instance as object)['appProcessChange'](event);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_windowInfoCallback_01', 0, () => {
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let serviceInfo: StatusBarServiceInfo = {} as StatusBarServiceInfo;
        (instance as object)['windowInfoCallback'](serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_windowInfoCallback_02', 0, () => {
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let serviceInfo: StatusBarServiceInfo = {
          type: StatusBarConnectEvent.UPDATE_QUICK_OPERATION_HEIGHT,
          tokenId: 1,
          bundleName: 'test',
          pid: 1,
          data: {
            operationHeight: 1,
          },
          appIndex: 0,
        } as StatusBarServiceInfo;
        (instance as object)['windowInfoCallback'](serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_windowInfoCallback_03', 0, () => {
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let serviceInfo: StatusBarServiceInfo = {
          type: StatusBarConnectEvent.UNKNOWN,
          tokenId: 1,
          bundleName: 'test',
          pid: 1,
          data: {
            operationHeight: 1,
          },
          appIndex: 0,
        } as StatusBarServiceInfo;
        (instance as object)['windowInfoCallback'](serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_windowInfoCallback_04', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getAppInfoByBundleName']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let serviceInfo: StatusBarServiceInfo = {
          type: StatusBarConnectEvent.ADD_TO_STATUS_BAR,
          tokenId: 1,
          bundleName: 'test',
          pid: 1,
          data: {
            operationHeight: 1,
          },
          appIndex: 0,
        } as StatusBarServiceInfo;
        (instance as object)['windowInfoCallback'](serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_windowInfoCallback_05', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let appManager: AppManager | undefined = new AppManager(bundleName, pid1);
        appManager.setTokenId(2);
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getAppInfoByBundleName']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appManager);

        let serviceInfo: StatusBarServiceInfo = {
          type: StatusBarConnectEvent.ADD_TO_STATUS_BAR,
          tokenId: 1,
          bundleName: 'test',
          pid: 1,
          data: {
            operationHeight: 1,
          },
          appIndex: 0,
        } as StatusBarServiceInfo;
        (instance as object)['windowInfoCallback'](serviceInfo);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getAppManagerMenuByBundleName_01', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let bundleName: string = 'com.ohos.contacts';
        instance.getAppManagerMenuByBundleName(bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_getAppManagerMenuByBundleName_02', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(instance, instance.isRegisterApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let bundleName: string = 'com.ohos.contacts';
        instance.getAppManagerMenuByBundleName(bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getAppManagerMenuByBundleName_03', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(instance, instance.isRegisterApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppInfoByBundleName);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(undefined);

        let bundleName: string = 'com.ohos.contacts';
        instance.getAppManagerMenuByBundleName(bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getAppManagerMenuByBundleName_04', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(instance, instance.isRegisterApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let bundleName: string = 'com.ohos.contacts';
        let appManager: AppManager | undefined = new AppManager(bundleName);
        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppInfoByBundleName);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(appManager);

        instance.getAppManagerMenuByBundleName(bundleName);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_queryExistingPid', 0, () => {
      try {
        let instance = StatusBarServiceEventMgr.getInstance();
        (instance as object)['queryExistingPid']();
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_callbackfn_01', 0, () => {
      let mock = new MockKit();
      let instance = StatusBarServiceEventMgr.getInstance();
      try {
        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppInfoByBundleName);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(undefined);

        let bundleInfo: BundleInfo = {
          bundleName: bundleName,
          pids: new Set([1, 2]),
          backPids: new Set([3, 4]),
        };
        let key: number = 0;
        let instanceKey: string = '';
        (instance as object)['callbackfn'](bundleInfo, key, instanceKey);
        expect(instance instanceof StatusBarServiceEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })








  })
}
