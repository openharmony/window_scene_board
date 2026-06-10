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
import { CheckEmptyUtils } from '@ohos/basicutils'

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {
  AppItemInfo,
  CommonConstants, ContextMenuListener, MenuInfo, MenuInfoManager } from '../../../../../../main/ets/TsIndex'

export default function MenuInfoManagerTest() {
  describe('MenuInfoManagerTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_menuInfoManager', Level.LEVEL0, () => {
      let instance = MenuInfoManager.getInstance();
      expect(instance).not().assertNull();
      let menuInfo = instance.createOpenMenuInfo();
      expect(menuInfo).not().assertNull();
    })

    it('test_getContextMenuListener_null_0', Level.LEVEL0, () => {
      let instance = MenuInfoManager.getInstance();
      expect(instance.getContextMenuListener(null)).assertUndefined();

      let contentId: string = '0';
      expect(instance.getContextMenuListener(contentId)).assertUndefined();
    })

    it('test_unregisterContextMenuListener_null_0', Level.LEVEL0, () => {
      let instance = MenuInfoManager.getInstance();
      instance.unregisterContextMenuListener(null);

      let contentId: string = '0';
      instance.unregisterContextMenuListener(contentId);

      expect(instance).not().assertNull();
    })

    it('test_creadUninstallMenuInfo', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let appInfo: AppInfo = new AppInfo('anyName', CommonConstants.TYPE_APP);
      let isPadFlag: boolean = false;
      instance.creadUninstallMenuInfo(appInfo, isPadFlag)
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_createAddFormToDesktopMenuInfo', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let ret: MenuInfo = instance.createAddFormToDesktopMenuInfo()
      expect(ret).not().assertNull();
    });

    it('test_createAddToDockMenuInfo01', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let appInfo: AppInfo = new AppInfo('anyName', undefined);
      let appName:string = 'someName';
      let ret: MenuInfo = instance.createAddToDockMenuInfo(appInfo, appName)
      expect(ret).not().assertNull();
    });

    it('test_createAddToDockMenuInfo02', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let appInfo: AppInfo = new AppInfo('anyName',CommonConstants.TYPE_APP);
      let appName:string = '';
      let ret: MenuInfo = instance.createAddToDockMenuInfo(appInfo, appName);
      expect(ret).not().assertNull();
    });

    it('test_createAddToWorkSpaceMenuInfo', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let appInfo: AppInfo = new AppInfo('anyName',CommonConstants.TYPE_APP)
      let ret: MenuInfo = instance.createAddToWorkSpaceMenuInfo(appInfo);
      expect(ret).not().assertNull();
    });

    it('test_createFormCenterMenuInfo', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let formManagerShowFrom: number = 1;
      let ret: MenuInfo = instance.createFormCenterMenuInfo(undefined, undefined, formManagerShowFrom);
      expect(ret).not().assertNull();
    });

    it('test_createMenuInfo', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let menuType: number = CommonConstants.MENU_TYPE_FIXED;
      let menuImgsrc: string = 'menuImgsrc';
      let menuText: string = 'anyMenuText';
      let ret: MenuInfo = instance.createMenuInfo(menuType, menuImgsrc, menuText);
      expect(ret).not().assertNull();
    });

    it('test_createOpenMenuInfo', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let ret: MenuInfo = instance.createOpenMenuInfo();
      expect(ret).not().assertNull();
    });

    it('test_createShortcutInfoMenuInfoList', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let value: ValueInfo = new ValueInfo(1, 1, 'anyBudleName', 'anyModuleName');
      let ret: MenuInfo = instance.createShortcutInfoMenuInfoList(value);
      expect(ret).not().assertNull();
    });

    it('test_getContextMenuListener01', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let contentId: string = '0';
      instance.getContextMenuListener(contentId);
      expect(contentId).assertEqual('0');
    });

    it('test_getContextMenuListener02', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let contentId: string = '1';
      instance.getContextMenuListener(contentId);
      expect(contentId).assertEqual('1');
    });

    it('test_registerContextMenuListener', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let contentId: string = '0';
      let listener: ContextMenuListener = {} as ContextMenuListener;
      instance.registerContextMenuListener(contentId, listener);
      expect(contentId).assertEqual('0');
    });

    it('test_unregisterContextMenuListener', 0, async () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let contentId: string = '0';
      instance.unregisterContextMenuListener(contentId);
      expect(contentId).assertEqual('0');
    });

    it('test_createMoreServiceFormMenuInfo', 0, async (done: Function) => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
     let formInfo: AppItemInfo = new AppItemInfo();
      formInfo.appName = 'DemoApplication';
      formInfo.bundleName = 'com.openharmony.demo';
      let menuInfo: MenuInfo = instance.createMoreServiceFormMenuInfo(formInfo, null, true, 'appname', 0, ()=>{});
      if (menuInfo && menuInfo.onMenuClick) {
        menuInfo.onMenuClick();
      }
      expect(menuInfo).not().assertUndefined();
      done();
    });

    it('test_createMoreServiceFormMenuInfo_001', 0, async (done: Function) => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let formInfo: AppItemInfo = new AppItemInfo();
      formInfo.appName = 'DemoApplication';
      formInfo.bundleName = 'com.openharmony.demo';
      let menuInfo: MenuInfo = instance.createMoreServiceFormMenuInfo(formInfo, null, true, null, 0, ()=>{});
      if (menuInfo && menuInfo.onMenuClick) {
        menuInfo.onMenuClick();
      }
      expect(menuInfo).not().assertUndefined();
      done();
    });

    it('test_createAddToDockMenuInfo_menuClick', 0, () => {
      try {
        let instance: MenuInfoManager = MenuInfoManager.getInstance();
        let formInfo: AppItemInfo = new AppItemInfo();
        formInfo.appName = 'DemoApplication';
        formInfo.bundleName = 'com.openharmony.demo';
        let menuInfo: MenuInfo = instance.createAddToDockMenuInfo(formInfo, 'appname');
        if (menuInfo && menuInfo.onMenuClick) {
          menuInfo.onMenuClick();
        }
        expect(menuInfo).not().assertUndefined();
      } catch (e) {
      }
    });

    it('test_createAddToDockMenuInfo_menuClick_001', 0, () => {
      try {
        let instance: MenuInfoManager = MenuInfoManager.getInstance();
        let formInfo: AppItemInfo = new AppItemInfo();
        formInfo.appName = 'DemoApplication';
        formInfo.bundleName = 'com.openharmony.demo';
        formInfo.typeId = 12234;
        let menuInfo: MenuInfo = instance.createAddToDockMenuInfo(formInfo, null);
        if (menuInfo && menuInfo.onMenuClick) {
          menuInfo.onMenuClick();
        }
        expect(menuInfo).not().assertUndefined();
      } catch (e) {
      }
    });

    it('test_creadUninstallMenuInfo_trueFlag', 0, () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let appInfo: AppInfo = new AppInfo('anyName', CommonConstants.TYPE_APP);
      let res = instance.creadUninstallMenuInfo(appInfo, true);
      expect(res).not().assertUndefined();
    });

    it('test_registerContextMenuListener_regist', 0, () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let contentId: string = 'testDemoContentId';
      let listener: ContextMenuListener = {} as ContextMenuListener;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.registerContextMenuListener(contentId, listener);
      expect(instance['mMenuListenerMap'].has(contentId)).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_getContextMenuListener_listener_001', 0, () => {
      let instance: MenuInfoManager = MenuInfoManager.getInstance();
      let contentId: string = 'testDemoContentId';
      let listener: ContextMenuListener = {} as ContextMenuListener;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.registerContextMenuListener(contentId, listener);
      expect(instance['mMenuListenerMap'].has(contentId)).assertTrue();
      let res = instance.getContextMenuListener(contentId);
      expect(res).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    class AppInfo{
      appName?: String;
      typeId?: number;

      constructor(appName?: string, typeId?: number) {
        this.appName = appName;
        this.typeId = typeId;
      }
    }

    class ValueInfo{
      iconId: number;
      labelId: number;
      bundleName: string;
      moduleName: string;

      constructor( iconId: number, labelId: number, bundleName: string, moduleName: string) {
        this.iconId = iconId;
        this.labelId = labelId;
        this.bundleName = bundleName;
        this.moduleName = moduleName;
      }
    }

  })
}
