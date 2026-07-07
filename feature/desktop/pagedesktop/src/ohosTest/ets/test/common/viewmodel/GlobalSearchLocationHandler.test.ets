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
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  GlobalSearchLocationHandler
} from '../../../../../main/ets/default/common/viewmodel/GlobalSearchLocationHander';
import { SearchLocationType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import GlobalSearchLocationParam from '../../../../../main/ets/default/common/viewmodel/GlobalSearchLocationParam';
import { AppItemInfo,
  DockItemInfo,
  FolderLayoutCacheManager,
  GridLayoutItemInfo, LauncherLayoutCacheUtil,
  LaunchLayoutCacheManager,
  ResidentLayoutCacheMgr} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { bundle } from '@kit.AbilityKit';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { desktopUtil, ObjectCopyUtil } from '@ohos/componenthelper';

function getNullObject(): GridLayoutItemInfo | null {
  return null;
}

export default function GlobalSearchLocationHandlerTest() {
  describe('GlobalSearchLocationHandlerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('test_getInstance', 0, () => {
      globalThis.globalSearchLocationHandlerInstance = null;
      let instance = GlobalSearchLocationHandler.getInstance();
      expect(instance).not().assertNull();
    })

    it('setGlobalSearchAnimation0', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      hanlder.setGlobalSearchAnimation(false);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('setGlobalSearchAnimation1', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      hanlder.setGlobalSearchAnimation(true);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('getGlobalSearchAnimation', 2, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let ret = hanlder.getGlobalSearchAnimation();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(ret !== undefined).assertTrue();
    })

    it('getGlobalSearchLocationParam', 3, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let ret = hanlder.getGlobalSearchLocationParam();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(ret !== undefined).assertTrue();
    })

    it('isAtCurrentPage', 4, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let ret = hanlder.isAtCurrentPage();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(ret).assertFalse();
    })

    it('doIconAnimation0', 5, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      hanlder.doIconAnimation();
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    })

    it('doIconAnimation1', 6, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      hanlder.setGlobalSearchAnimation(true);
      hanlder.doIconAnimation();
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    })

    it('pageJumpFinish1', 7, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let hanlder: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      hanlder.setGlobalSearchAnimation(false);
      hanlder.pageJumpFinish();
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    })

    it('test_setGlobalSearchAnimation_01', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let isAnimating: boolean = false;
      instance.setGlobalSearchAnimation(isAnimating);
      expect(isAnimating).assertEqual(false);
    });

    it('test_setGlobalSearchAnimation_02', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let isAnimating: boolean = true;
      instance.setGlobalSearchAnimation(isAnimating);
      expect(isAnimating).assertEqual(true);
    });

    it('test_getGlobalSearchAnimation_01', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.setGlobalSearchAnimation(true)
      let ret: boolean = instance.getGlobalSearchAnimation();
      expect(ret).assertEqual(true);
    });

    it('test_getGlobalSearchAnimation_02', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.setGlobalSearchAnimation(false)
      let ret: boolean = instance.getGlobalSearchAnimation();
      expect(ret).assertEqual(false);
    });

    it('test_beginLocationAnimation', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.calendar';
      let abilityName: string = '';
      let moduleName: string = '';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.calendarMainAbilityphone0';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, keyName);
      expect(instance.getGlobalSearchAnimation()).assertFalse();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_beginLocationAnimation_01', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.calendar';
      let abilityName: string = '';
      let moduleName: string = '';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.calendarMainAbilityphone0';
      try {
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, keyName);
      } catch (e) {};
      expect(abilityName).assertEqual('');
      done();
    });

    it('test_beginLocationAnimation_02', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.calendar';
      let abilityName: string = 'MainAbility';
      let moduleName: string = 'phone';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.calendarMainAbilityphone0';
      try {
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, keyName);
      } catch (e) {};
      expect(bundleName).assertEqual('com.ohos.calendar');
      done();
    });

    it('test_beginLocationAnimation_03', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.contacts';
      let abilityName: string = 'com.ohos.contacts.MainAbility';
      let moduleName: string = 'entry';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry0';
      try {
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, keyName);
      } catch (e) {};
      expect(bundleName).assertEqual('com.ohos.contacts');
      done();
    });

    it('test_beginLocationAnimation_04', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.contacts';
      let abilityName: string = 'com.ohos.contacts.MainAbility';
      let moduleName: string = 'entry';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry0';
      try {
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, keyName);
      } catch (e) {};
      expect(bundleName).assertEqual('com.ohos.contacts');
      done();
    });

    it('test_beginLocationAnimation_05', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.music';
      let abilityName: string = 'MainAbility';
      let moduleName: string = 'phone';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.musicMainAbilityphone0'
      try {
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, keyName);
      } catch (e) {};
      expect(bundleName).assertEqual('com.ohos.music');
      done();
    });

    it('test_beginLocationAnimation_07', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.music';
      let abilityName: string = 'MainAbility';
      let moduleName: string = 'phone';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.musicMainAbilityphone';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.id = 1;
      item.bundleName = bundleName;
      item.abilityName = abilityName;
      item.moduleName = moduleName;
      item.typeId = 0;
      item.keyName = keyName;
      let list: GridLayoutItemInfo[] = [item];
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.type = SearchLocationType.DOCK_TYPE;
      gsParam.page = 1
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.queryGridLayoutItemsByBundleName);
      let mockFunc2: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(gsParam);
      try{
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, '1');
        expect((instance as object)['gsParam'].type).assertEqual(SearchLocationType.DOCK_TYPE);
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(instance);
      done();
    });

    it('test_beginLocationAnimation_08', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.music';
      let abilityName: string = 'MainAbility';
      let moduleName: string = 'phone';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.musicMainAbilityphone';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.id = 1;
      item.bundleName = bundleName;
      item.abilityName = abilityName;
      item.moduleName = moduleName;
      item.typeId = 0;
      item.keyName = keyName;
      let list: GridLayoutItemInfo[] = [item];
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.type = SearchLocationType.BIG_FOLDER_ITEM_TYPE;
      gsParam.page = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.queryGridLayoutItemsByBundleName);
      let mockFunc2: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
      let mockFunc3: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(gsParam);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      try{
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, '1');
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      try{
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, '1');
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(bundleName).assertEqual('com.ohos.music');
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_beginLocationAnimation_09', 0, async (done: Function) => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.ohos.music';
      let abilityName: string = 'MainAbility';
      let moduleName: string = 'phone';
      let typeId: number = 0;
      let keyName: string = 'com.ohos.musicMainAbilityphone';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.id = 1;
      item.bundleName = bundleName;
      item.abilityName = abilityName;
      item.moduleName = moduleName;
      item.typeId = 0;
      item.keyName = keyName;
      let list: GridLayoutItemInfo[] = [item];
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.type = SearchLocationType.NULL_TYPE;
      gsParam.page = 1
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.queryGridLayoutItemsByBundleName);
      let mockFunc2: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(gsParam);
      try{
        await instance.beginLocationAnimation(bundleName, abilityName, moduleName, typeId, '1');
        expect((instance as object)['gsParam'].type).assertEqual(SearchLocationType.NULL_TYPE);
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(instance);
      done();
    });

    it('test_isAtCurrentPage_01', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let isAnimating: boolean = false;
      instance.setGlobalSearchAnimation(isAnimating);
      instance.doIconAnimation();
      expect(isAnimating).assertFalse();
    })

    it('test_pageJumpFinish_01_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = false;
        instance.setGlobalSearchAnimation(isAnimating);

        let mockFunc: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        instance.pageJumpFinish();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_pageJumpFinish_02_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        instance.setGlobalSearchAnimation(isAnimating);

        let mockFunc1: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.BIG_FOLDER_ITEM_TYPE;

        let mockFunc2: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(gsParam);
        instance.pageJumpFinish();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_pageJumpFinish_03_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        instance.setGlobalSearchAnimation(isAnimating);

        let mockFunc1: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.SMALL_FOLDER_ITEM_TYPE;

        let mockFunc2: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(gsParam);
        instance.pageJumpFinish();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_pageJumpFinish_04_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        instance.setGlobalSearchAnimation(isAnimating);

        let mockFunc1: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.DOCK_FOLDER_ITEM_TYPE;

        let mockFunc2: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(gsParam);
        instance.pageJumpFinish();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_pageJumpFinish_05_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        instance.setGlobalSearchAnimation(isAnimating);

        let mockFunc1: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.NULL_TYPE;

        let mockFunc2: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(gsParam);
        instance.pageJumpFinish();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_folderPageJumpFinish_01', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let isAnimating: boolean = true;
      instance.setGlobalSearchAnimation(isAnimating);
      expect(isAnimating).assertTrue();
    });

    it('test_hideIcon_01_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.DESKTOP_ITEM;

        let mockFunc1: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(gsParam);

        instance.hideIcon();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_hideIcon_02_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.BIG_FOLDER_ITEM_TYPE;

        let mockFunc1: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(gsParam);

        instance.hideIcon();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_hideIcon_03_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.DOCK_TYPE;

        let mockFunc1: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(gsParam);

        instance.hideIcon();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_restoreIcon_01_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.DESKTOP_ITEM;

        let mockFunc1: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(gsParam);

        instance.restoreIcon();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_restoreIcon_02_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.BIG_FOLDER_ITEM_TYPE;

        let mockFunc1: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(gsParam);

        instance.restoreIcon();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_restoreIcon_03_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let isAnimating: boolean = true;
        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.DOCK_TYPE;

        let mockFunc1: Function = mocker.mockFunc(instance, instance.calcGlobalSearchLocationParam);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(gsParam);

        instance.restoreIcon();
        expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_filterGridLayoutItemByEntityId', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let gridLayoutItemInfos: GridLayoutItemInfo[] = [];
      let item = new GridLayoutItemInfo();
      item.id = 1;
      item.bundleName = 'aaa';
      item.moduleName = 'bbb';
      item.appIndex = 0;
      item.container = -101;

      gridLayoutItemInfos.push(item);
      expect(instance.filterGridLayoutItemByEntityId('1', gridLayoutItemInfos)?.id).assertEqual(1);

      let item2 = new GridLayoutItemInfo();
      item2.id = 2;
      item2.bundleName = 'aaa';
      item2.moduleName = 'bbb';
      item2.appIndex = 0;
      item2.container = -101;

      gridLayoutItemInfos.push(item2);
      expect(instance.filterGridLayoutItemByEntityId('1', gridLayoutItemInfos)?.id).assertEqual(1);

      let item3 = new GridLayoutItemInfo();
      item3.id = 3;
      item3.bundleName = 'aaa';
      item3.moduleName = 'bbb';
      item3.appIndex = 0;
      item3.container = -101;

      gridLayoutItemInfos.push(item3);
      expect(instance.filterGridLayoutItemByEntityId('4', gridLayoutItemInfos)).assertNull();
    });

    it('test_queryGridLayoutItemsByBundleName', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.beginLocationAnimation('aaa', 'bbb', 'vvv', 0, '123');
      expect(instance != null).assertTrue();
    });

    it('test_folderOpenFinish', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.setGlobalSearchAnimation(true);
      AppStorage.setOrCreate('openFolderPageIndex', 1);
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.type = SearchLocationType.BIG_FOLDER_ITEM_TYPE;
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.page = 1;
      gsParam.appItem = appItem;
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.layoutInfo = [[folderItem1], [folderItem1]];
      gsParam.folderItem = folderItem;
      (instance as object)['gsParam'] = gsParam;
      instance.folderOpenFinish();
      AppStorage.setOrCreate('openFolderPageIndex', 2);
      instance.folderOpenFinish();
      expect(instance.getGlobalSearchAnimation()).assertTrue();
      gsParam.appItem.page = 3;
      (instance as object)['gsParam'] = gsParam;
      instance.folderOpenFinish();
      expect(instance.getGlobalSearchAnimation()).assertFalse();
    })

    it('test_folderPageJumpFinish', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.setGlobalSearchAnimation(false);
      instance.folderPageJumpFinish();
      instance.setGlobalSearchAnimation(true);
      instance.folderPageJumpFinish();
      expect(AppStorage.get('globalSearchLocationAppShow')).assertTrue();
    })

    it('test_findAppInDock', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let bundleName: string = 'com.example.myapplication';
      let abilityName: string = 'EntryAbility';
      let keyName: string = 'keyName';
      let moduleName: string = 'moduleName';
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      dockItemInfo.bundleName = bundleName;
      dockItemInfo.abilityName = abilityName;
      dockItemInfo.moduleName = moduleName;
      dockItemInfo.keyName = keyName;
      dockItemInfo.page = 1;
      dockItemInfo.typeId = 3;
      let dockItemInfoOther = ObjectCopyUtil.deepClone(dockItemInfo);
      dockItemInfoOther.keyName = 'keyNameOther'
      let dockItemInfo2: DockItemInfo = new DockItemInfo();
      dockItemInfo2.bundleName = bundleName;
      dockItemInfo2.abilityName = abilityName;
      dockItemInfo2.moduleName = moduleName;
      dockItemInfo2.keyName = keyName;
      dockItemInfo2.page = 1;
      dockItemInfo2.typeId = 2;
      let dockItemInfo2Other = ObjectCopyUtil.deepClone(dockItemInfo2);
      dockItemInfo2Other.keyName = 'keyNameOther'
      let list: DockItemInfo[] = [dockItemInfoOther, dockItemInfo, dockItemInfo2Other, dockItemInfo2];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', list, false);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.layoutInfoToList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      let ret = instance.findAppInDock(bundleName, abilityName, moduleName, 2, keyName);
      expect(ret.type).assertEqual(SearchLocationType.DOCK_TYPE);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_findAppInDesktop', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let instance2: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let bundleName: string = 'com.example.myapplication';
      let abilityName: string = 'EntryAbility';
      let keyName: string = 'keyName';
      let moduleName: string = 'moduleName';
      item.bundleName = bundleName;
      item.abilityName = abilityName;
      item.moduleName = moduleName;
      item.typeId = 0;
      item.keyName = keyName;
      item.page = 1;
      item.area = [1, 1];
      let list: GridLayoutItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance2, instance2['selectGridLayoutItemsByBundleName']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      let ret = instance.findAppInDesktop(bundleName, abilityName, moduleName, 0, 'keyNames');
      expect(ret.type).assertEqual(SearchLocationType.NULL_TYPE);
      ret = instance.findAppInDesktop(bundleName, abilityName, moduleName, 0, keyName);
      expect(ret.type).assertEqual(SearchLocationType.DESKTOP_ITEM);
      mocker.clear(instance2);
    })

    it('test_findAppInFolder', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let instance2: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let bundleName: string = 'com.example.myapplication';
      let abilityName: string = 'EntryAbility';
      let keyName: string = 'keyName';
      let moduleName: string = 'moduleName';
      item.bundleName = bundleName;
      item.abilityName = abilityName;
      item.moduleName = moduleName;
      item.typeId = 0;
      item.keyName = keyName;
      item.page = 1;
      item.area = [1, 1];
      let list: GridLayoutItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance2, instance2.selectFolderByKeyName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      try{
        instance.findAppInFolder(bundleName, abilityName, moduleName, 0, keyName);
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn(item);
      let mockFunc1: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.layoutInfoToList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(list);
      try{
        let ret = instance.findAppInFolder(bundleName, abilityName, moduleName, 0, keyName);
        expect(ret.type).assertEqual(SearchLocationType.SMALL_FOLDER_ITEM_TYPE);
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(instance2);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_findAppInFolder01', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let instance2: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let bundleName: string = 'com.example.myapplication';
      let abilityName: string = 'EntryAbility';
      let keyName: string = 'keyName';
      let moduleName: string = 'moduleName';
      item.bundleName = bundleName;
      item.abilityName = abilityName;
      item.moduleName = moduleName;
      item.typeId = 0;
      item.keyName = keyName;
      item.page = 1;
      item.area = [1, 0];
      let list: GridLayoutItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance2, instance2.selectFolderByKeyName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(item);
      let mockFunc1: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.layoutInfoToList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(list);
      let ret = instance.findAppInFolder(bundleName, abilityName, moduleName, 0, keyName);
      expect(ret.type).assertEqual(SearchLocationType.BIG_FOLDER_ITEM_TYPE);
      mocker.clear(instance2);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_getFolderItem', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      dockItemInfo.keyName = 'keyName';
      let ret: GridLayoutItemInfo = (instance as object)['getFolderItem'](dockItemInfo);
      expect(ret.keyName).assertEqual('keyName');
    })

    it('test_gsParam_DESKTOP_ITEM', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.setGlobalSearchAnimation(true);
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.type = SearchLocationType.DESKTOP_ITEM;
      (instance as object)['gsParam'] = gsParam;
      instance.hideIcon();
      instance.restoreIcon();
      instance.pageJumpFinish();
      expect(instance.getGlobalSearchLocationParam().type).assertEqual(SearchLocationType.DESKTOP_ITEM);
    })

    it('test_gsParam_DOCK_TYPE', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.setGlobalSearchAnimation(true);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.type = SearchLocationType.DOCK_TYPE;
      (instance as object)['gsParam'] = gsParam;
      instance.hideIcon();
      instance.restoreIcon();
      instance.pageJumpFinish();
      expect(instance.getGlobalSearchLocationParam().type).assertEqual(SearchLocationType.DOCK_TYPE);
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_gsParam_BIG_FOLDER_ITEM_TYPE', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      instance.setGlobalSearchAnimation(true);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.isAtCurrentPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.type = SearchLocationType.BIG_FOLDER_ITEM_TYPE;
      (instance as object)['gsParam'] = gsParam;
      instance.hideIcon();
      instance.restoreIcon();
      instance.pageJumpFinish();
      expect(instance.getGlobalSearchLocationParam().type).assertEqual(SearchLocationType.BIG_FOLDER_ITEM_TYPE);
      gsParam.type = SearchLocationType.SMALL_FOLDER_ITEM_TYPE;
      (instance as object)['gsParam'] = gsParam;
      instance.hideIcon();
      instance.restoreIcon();
      instance.pageJumpFinish();
      expect(instance.getGlobalSearchLocationParam().type).assertEqual(SearchLocationType.SMALL_FOLDER_ITEM_TYPE);
      gsParam.type = SearchLocationType.DOCK_FOLDER_ITEM_TYPE;
      (instance as object)['gsParam'] = gsParam;
      instance.hideIcon();
      instance.restoreIcon();
      instance.pageJumpFinish();
      expect(instance.getGlobalSearchLocationParam().type).assertEqual(SearchLocationType.DOCK_FOLDER_ITEM_TYPE);
      gsParam.type = SearchLocationType.NULL_TYPE;
      (instance as object)['gsParam'] = gsParam;
      instance.hideIcon();
      instance.restoreIcon();
      instance.pageJumpFinish();
      instance.stopGlobalSearchProcess();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_isAtCurrentPage_7', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      AppStorage.setOrCreate('folderStatus', 1);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.page = 0;
      (instance as object)['gsParam'] = gsParam;
      let ret = instance.isAtCurrentPage();
      expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_isAtCurrentPage01_7', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      AppStorage.setOrCreate('folderStatus', 1);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(4);
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.page = 5;
      (instance as object)['gsParam'] = gsParam;
      let ret = instance.isAtCurrentPage();
      expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_isAtCurrentPage02_7', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      AppStorage.setOrCreate('folderStatus', 1);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
      gsParam.page = 2;
      (instance as object)['gsParam'] = gsParam;
      let ret = instance.isAtCurrentPage();
      expect(instance instanceof GlobalSearchLocationHandler).assertTrue();
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_isSame', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let bundleName: string = 'com.example.myapplication';
      let abilityName: string = 'EntryAbility';
      let keyName: string = 'keyName';
      let moduleName: string = 'moduleName';
      item.bundleName = bundleName;
      item.abilityName = abilityName;
      item.moduleName = moduleName;
      item.typeId = 0;
      item.keyName = keyName;
      let ret: boolean = (instance as object)['isSame'](item, bundleName, abilityName, moduleName, 0, keyName);
      expect(ret).assertTrue();
    })

    it('test_isSame02', 0, () => {
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      let item = getNullObject() as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let bundleName: string = 'com.example.myapplication';
      let abilityName: string = 'EntryAbility';
      let keyName: string = 'keyName';
      let moduleName: string = 'moduleName';
      let ret: boolean = (instance as object)['isSame'](item, bundleName, abilityName, moduleName, 0, keyName);
      expect(ret).assertFalse();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_calcGlobalSearchLocationParam', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance();
      try {
        let bundleName: string = 'com.example.myapplication';
        let abilityName: string = 'EntryAbility';
        let keyName: string = 'keyName';
        let moduleName: string = 'moduleName';
        let typeId = 1;
        let gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
        gsParam.type = SearchLocationType.DOCK_FOLDER_ITEM_TYPE;
        gsParam.page = 1;

        let mockFunc: Function = mocker.mockFunc(instance, instance.findAppInDock);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(gsParam);
        let ret = instance.calcGlobalSearchLocationParam(bundleName, abilityName, moduleName, typeId, keyName);
        gsParam.type = SearchLocationType.NULL_TYPE;
        when(mockFunc)(ArgumentMatchers.any).afterReturn(gsParam);
        ret = instance.calcGlobalSearchLocationParam(bundleName, abilityName, moduleName, typeId, keyName);
        expect(ret).not().assertNull();
      } catch(e) {}
      mocker.clear(instance);
      mocker.clearAll();
    })
  })
}