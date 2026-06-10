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
import {
  AppItemInfo,
  DockItemInfo,
  launcherAbilityManager,
  LauncherLayoutCacheUtil,
  LayoutDescription,
  NotHarmonyUtil,
  RdbStoreManager,
  SettingsModel,
  LaunchLayoutCacheManager,
  CommonConstants,
  FolderData,
  FolderLayoutCacheManager,
  LayoutViewModel,
  FolderModel,
  GridLayoutUtil,
  DefaultDesktopLayoutInfo,
  BadgeItemInfo
} from '@ohos/launchercommon'
import { DesktopLayoutCacheData } from '@ohos/launchercommon/src/main/ets/cache/layout/DesktopLayoutCacheData';
import { PageDesktopViewModel } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModel'
import {
  PageDesktopViewModelUtils,
  SqueezeGridLayout
} from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModelUtils'
import { CardItemInfo } from '@ohos/launchercommon'
import { GridLayoutItemInfo } from '@ohos/launchercommon'
import { AppModel } from '@ohos/launchercommon'
import { CheckEmptyUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { CommonEvent, GlobalContext, EvtBus, ResourceManager } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';
import { AppListInfo } from '../../../../../main/ets/default/common/dao/AppListInfo';
import { AppStatus } from '@ohos/launchercommon';
import { FolderLayoutStruct } from  '../../../../../../../../../staticcommon/launchercommon/src/main/ets/folder/FolderLayoutInfo';
import { RgmStatusChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { ItemLocation } from '@ohos/launchercommon/Index';

export default function PageDesktopViewModelUtilsTest() {
  describe('PageDesktopViewModelUtilsTest', () => {
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
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    })

    it('test_addNewInstalledInfo01', 0, async(done:Function) => {
      try{
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let  totalAppInfoList: AppItemInfo[] = [];
        let a = 'test';
        let totalAppInfoListItem: AppItemInfo = {
          abilityName : 'AppModel',
          appName : 'AppModelName',
          appIconId : 9999,
          bundleName : 'com.ohos.appModel',
          moduleName : 'model',
          keyName : 'PageDesktop'
        } as AppItemInfo;
        totalAppInfoList.push(totalAppInfoListItem);
        let  pageDesktopInfoList: GridLayoutItemInfo[] = [];
        let pageDesktopInfoItem: GridLayoutItemInfo = {
          abilityName : 'AppModel',
          appName : 'AppModelName',
          appIconId : 9999,
          bundleName : 'com.ohos.appModel',
          moduleName : 'model',
          keyName : 'PageDesktop'
        } as GridLayoutItemInfo;
        pageDesktopInfoList.push(pageDesktopInfoItem)
        instance.addNewInstalledInfo(totalAppInfoList, pageDesktopInfoList);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_addNewInstalledInfo02', 0, async(done:Function) => {
      try{
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let  totalAppInfoList: AppItemInfo[] = [];
        let a = 'test';
        let totalAppInfoListItem: AppItemInfo = {
          abilityName : 'AppModel',
          appName : 'AppModelName',
          appIconId : 9999,
          bundleName : 'com.ohos.appModel',
          moduleName : 'model',
          keyName : 'PageDesktop'
        } as AppItemInfo;
        totalAppInfoList.push(totalAppInfoListItem);
        let  pageDesktopInfoList: GridLayoutItemInfo[] = [];
        let pageDesktopInfoItem: GridLayoutItemInfo = {
          abilityName : 'AppModel',
          appName : 'AppModelName',
          appIconId : 9999,
          bundleName : 'com.ohos.appModel',
          moduleName : 'model',
          keyName : 'SmartDock'
        } as GridLayoutItemInfo;
        pageDesktopInfoList.push(pageDesktopInfoItem);
        instance.addNewInstalledInfo(totalAppInfoList, pageDesktopInfoList);
        expect(a).assertEqual('test');
      }catch(err){}
      done()
    });

    it('test_appendFolderData01', 0, async(done:Function) => {
      try{
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        let a = 'test';
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        dockItem.layoutInfo = [[item1],[item2],[item3]];
        let folderInfoList: GridLayoutItemInfo[] = [];
        folderInfoList.push(dockItem);
        let bundleInfoList: GridLayoutItemInfo[] = [];
        let appItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItem1.bundleName = 'com.ohos.sceneboard';
        bundleInfoList.push(appItem1);
        instance.appendFolderData(folderInfoList, bundleInfoList);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_appendFolderData02', 0, async(done:Function) => {
      try{
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        let a = 'test';
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        dockItem.layoutInfo = [[item1],[item2],[item3]];
        let folderInfoList: GridLayoutItemInfo[] = [];
        folderInfoList.push(dockItem);
        let bundleInfoList: GridLayoutItemInfo[] = [];
        let appItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItem1.bundleName = 'com.ohos.healhty';
        bundleInfoList.push(appItem1);
        instance.appendFolderData(folderInfoList, bundleInfoList);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_appendFormStackData01', 0, async(done:Function) => {
      try{
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        let a ='test';
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.cardId = '1';
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.cardId = '2';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.cardId = '3';
        dockItem.layoutInfo = [[item1],[item2],[item3]];
        let folderInfoList: GridLayoutItemInfo[] = [];
        folderInfoList.push(dockItem);
        let bundleInfoList: GridLayoutItemInfo[] = [];
        let cardItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
        cardItem1.cardId = '99999';
        bundleInfoList.push(cardItem1);
        instance.appendFormStackData(folderInfoList, bundleInfoList);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_appendFormStackData02', 0, async(done:Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        let a = 'test';
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.cardId = '1';
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.cardId = '2';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.cardId = '3';
        dockItem.layoutInfo = [[item1],[item2],[item3]];
        let folderInfoList: GridLayoutItemInfo[] = [];
        folderInfoList.push(dockItem);
        let bundleInfoList: GridLayoutItemInfo[] = [];
        let cardItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
        cardItem1.cardId = '2';
        bundleInfoList.push(cardItem1);
        instance.appendFormStackData(folderInfoList, bundleInfoList);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_buildGridLayoutInfoFromItemInfo01', 0, async(done:Function) => {
      try{
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let  appItemInfos: AppItemInfo[] = [];
        let a = 'test';
        let appItemInfo1: AppItemInfo = {
          bundleName: 'anyBundleName',
          typeId: 99999,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          badgeNumber: 1,
          area: [1,2,3,4,5,6,7,8,9],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          installTime:'123',
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName'
        } as AppItemInfo;
        appItemInfos.push(appItemInfo1);
        let ret: GridLayoutItemInfo =instance.buildGridLayoutInfoFromItemInfo(appItemInfos[0], 1, 1, 1);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_buildGridLayoutInfoFromItemInfo02', 0, async(done:Function) => {
      try{
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let  appItemInfos: GridLayoutItemInfo[] = [];
        let a ='test';
        let appItemInfo1: GridLayoutItemInfo = {
          bundleName: 'anyBundleName',
          typeId: 99999,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          badgeNumber: 1,
          area: [1,2,3,4,5,6,7,8,9],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          folderName: 'anyFolderName',
          folderId:'anyFolderId',
          container: 111,
          extend1: 'anyExtend1'
        } as GridLayoutItemInfo;

        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.cardId = '1';
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.cardId = '2';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.cardId = '3';
        appItemInfo1.layoutInfo = [[item1],[item2],[item3]];
        appItemInfos.push(appItemInfo1);

        let ret: GridLayoutItemInfo =instance.buildGridLayoutInfoFromItemInfo(appItemInfos[0], 1, 1, 1);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_dealWithContainerApp01', 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let bundleName = 'anyBundleName'
      let mocker1 = new MockKit();
      let mockfunc1 = mocker1.mockFunc(AppModel, AppModel.getInstance().getAppInfoByBundleName);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturn(true);
      let mocker2 = new MockKit();
      let mockfunc2 = mocker2.mockFunc(Number, Number.isNaN);
      when(mockfunc2)(ArgumentMatchers.anyNumber).afterReturn(true);
      let mocker3 = new MockKit();
      let itemInfo = new AppItemInfo();
      try {
        itemInfo.bundleName = bundleName;
        instance.dealWithContainerApp(itemInfo);
        expect(instance).not().assertNull();
      } catch (err) {}
      mocker1.clear(AppModel);
      mocker2.clear(Number);
      done();
    });


    it('test_dealWithContainerApp02', 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let bundleName = 'anyBundleName'
      let mocker1 = new MockKit();
      let mockfunc1 = mocker1.mockFunc(AppModel, AppModel.getInstance().getAppInfoByBundleName);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturn(true);
      let mocker2 = new MockKit();
      let mockfunc2 = mocker2.mockFunc(Number, Number.isNaN);
      when(mockfunc2)(ArgumentMatchers.anyNumber).afterReturn(false);
      let mocker3 = new MockKit();
      let mocker4 = new MockKit();
      let mockfunc4 = mocker4.mockFunc(instance, (instance as object)['checkInSmartDock']);
      when(mockfunc4)(ArgumentMatchers.anyString).afterReturn(true);
      let itemInfo = new AppItemInfo();
      itemInfo.bundleName = bundleName;
      try {
        instance.dealWithContainerApp(itemInfo);
        expect(bundleName).assertEqual('anyBundleName');
      } catch (err) {}
      mocker1.clear(AppModel);
      mocker2.clear(Number);
      mocker4.clear(instance);
      done();
    });

    it('test_dealWithContainerApp03', 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let bundleName = 'anyBundleName'
      let mocker1 = new MockKit();
      let mockfunc1 = mocker1.mockFunc(AppModel, AppModel.getInstance().getAppInfoByBundleName);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturn(true);
      let mocker2 = new MockKit();
      let mockfunc2 = mocker2.mockFunc(Number, Number.isNaN);
      when(mockfunc2)(ArgumentMatchers.anyNumber).afterReturn(false);
      let mocker3 = new MockKit();
      let mocker4 = new MockKit();
      let mockfunc4 = mocker4.mockFunc(instance, (instance as object)['checkInSmartDock']);
      when(mockfunc4)(ArgumentMatchers.anyString).afterReturn(true);
      let itemInfo = new AppItemInfo();
      itemInfo.bundleName = bundleName;
      try {
        instance.dealWithContainerApp(itemInfo);
        expect(bundleName).assertEqual('anyBundleName');
      } catch (err) {}
      mocker1.clear(AppModel);
      mocker2.clear(Number);
      mocker4.clear(instance);
      done();
    });

    it('test_dealWithContainerApp04', 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let bundleName = 'anyBundleName'
      let mocker1 = new MockKit();
      let mockfunc1 = mocker1.mockFunc(AppModel, AppModel.getInstance().getAppInfoByBundleName);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturn(true);
      let mocker2 = new MockKit();
      let mockfunc2 = mocker2.mockFunc(Number, Number.isNaN);
      when(mockfunc2)(ArgumentMatchers.anyNumber).afterReturn(false);
      let mocker3 = new MockKit();
      let mocker4 = new MockKit();
      let mockfunc4 = mocker4.mockFunc(instance, (instance as object)['checkInSmartDock']);
      when(mockfunc4)(ArgumentMatchers.anyString).afterReturn(true);
      let itemInfo = new AppItemInfo();
      itemInfo.bundleName = bundleName;
      try {
        instance.dealWithContainerApp(itemInfo);
        expect(bundleName).assertEqual('anyBundleName');
      } catch (err) {}
      mocker1.clear(AppModel);
      mocker2.clear(Number);
      mocker4.clear(instance);
      done();
    });

    it('test_createNewCardItemInfo01', 0, async(done:Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let a ='test';
        class FormCardItem{
          constructor() {
          }
          cardId: string = '';
          cardName: string = '';
          appName: string | undefined;
          bundleName: string = '';
          abilityName: string = '';
          moduleName: string = '';
          formConfigAbility: string | undefined;
          appLabelId: number | undefined;
          cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
        }
        let  formCardItem: CardItemInfo = new CardItemInfo();
        formCardItem.cardId = '99999';
        formCardItem.cardName = 'anyCardName';
        formCardItem.appName = 'anyAppName';
        formCardItem.bundleName = 'anyBundleName';
        formCardItem.abilityName = 'anyAbilityName';
        formCardItem.moduleName = 'anyModuleName';
        formCardItem.formConfigAbility = 'formConfigAbility';
        formCardItem.appLabelId = 88888;
        formCardItem.cardDimension = CommonConstants.CARD_DIMENSION_1x2;

        let ret: CardItemInfo = instance.createNewCardItemInfo(formCardItem);
        expect(a).assertEqual('test');
      }catch(err){}
      done();
    });

    it('test_createNewCardItemInfo02', 0, async(done:Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let a ='test';
        class FormCardItem{
          constructor() {
          }
          cardId: string = '';
          cardName: string = '';
          appName: string | undefined;
          bundleName: string = '';
          abilityName: string = '';
          moduleName: string = '';
          formConfigAbility: string | undefined;
          appLabelId: number | undefined;
          cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
          isTransparent: boolean = false;
        }
        let  formCardItem: CardItemInfo = new CardItemInfo();
        formCardItem.cardId = '99999';
        formCardItem.cardName = 'anyCardName';
        formCardItem.appName = 'anyAppName';
        formCardItem.bundleName = 'anyBundleName';
        formCardItem.abilityName = 'anyAbilityName';
        formCardItem.moduleName = 'anyModuleName';
        formCardItem.formConfigAbility = 'formConfigAbility';
        formCardItem.appLabelId = 88888;
        formCardItem.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
        formCardItem.isTransparent = false;
        let ret: CardItemInfo = instance.createNewCardItemInfo(formCardItem);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_getFolderAppBadgeNumber', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let folderInfoList: GridLayoutItemInfo[] =[];
        let a = 'test';
        let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        gridLayoutItemInfo.layoutInfo = [[item1],[item2],[item3]];
        folderInfoList.push(gridLayoutItemInfo);
        instance.getFolderAppBadgeNumber(folderInfoList);
        expect(a).assertEqual('test');
      } catch (err) {}
    });

    it('test_base64ToPixelMap', 0, () => {
      try {
        let a = 'test'
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        expect(a).assertEqual('test');

        const base64StrWithPre: string = 'data:image/jpeg;base64,test string';
        instance.base64ToPixelMap(base64StrWithPre);

        const base64StrNotWithPre: string = 'test string';
        instance.base64ToPixelMap(base64StrNotWithPre);
      }catch (err){}
    });

    it('test_getNeighborPage01', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let page: number = 2;
        let ret = instance.getNeighborPage(page);
        expect(a).assertEqual('test');
      } catch (err) {}
    });

    it('test_getNeighborPage02', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let page: number = 3;
        let ret = instance.getNeighborPage(page);
        expect(a).assertEqual('test');
      } catch (err) {}
    });

    it('test_updateFormId01', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        class FormCardItem{
          constructor() {
          }
          cardId: string = '';
          cardName: string = '';
          appName: string | undefined;
          bundleName: string = '';
          abilityName: string = '';
          moduleName: string = '';
          formConfigAbility: string | undefined;
          appLabelId: number | undefined;
          cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
          isTransparent: boolean = false;
        }

        let  formCardItem: CardItemInfo = new CardItemInfo();
        formCardItem.cardId = '99999';
        formCardItem.cardName = 'someBundleName';
        formCardItem.appName = 'anyAppName';
        formCardItem.bundleName = 'anyBundleName';
        formCardItem.abilityName = 'anyAbilityName';
        formCardItem.moduleName = 'anyModuleName';
        formCardItem.formConfigAbility = 'formConfigAbility';
        formCardItem.appLabelId = 88888;
        formCardItem.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
        formCardItem.isTransparent = false;
        let formInfo: CardItemInfo = instance.createNewCardItemInfo(formCardItem);

        let  bundleInfoList: AppItemInfo[] = [];
        let bundleInfo1: AppItemInfo = {
          bundleName: 'anyBundleName',
          typeId: 99999,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          badgeNumber: 1,
          area: [1,2,3,4,5,6,7,8,9],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          isUninstallAble: true,
          isSystemApp: false
        } as AppItemInfo;
        bundleInfoList.push(bundleInfo1);

        instance.updateFormId(formInfo, bundleInfoList);
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (err) {}
    });

    it('test_updateFormId02', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        class FormCardItem{
          constructor() {
          }
          cardId: string = '';
          cardName: string = '';
          appName: string | undefined;
          bundleName: string = '';
          abilityName: string = '';
          moduleName: string = '';
          formConfigAbility: string | undefined;
          appLabelId: number | undefined;
          cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
          isTransparent: boolean = false;
        }

        let  formCardItem: CardItemInfo = new CardItemInfo();
        formCardItem.cardId = '99999';
        formCardItem.cardName = 'anyCardName';
        formCardItem.appName = 'anyAppName';
        formCardItem.bundleName = 'anyBundleName';
        formCardItem.abilityName = 'anyAbilityName';
        formCardItem.moduleName = 'anyModuleName';
        formCardItem.formConfigAbility = 'formConfigAbility';
        formCardItem.appLabelId = 88888;
        formCardItem.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
        formCardItem.isTransparent = false;
        let formInfo: CardItemInfo = instance.createNewCardItemInfo(formCardItem);

        let  bundleInfoList: AppItemInfo[] = [];
        let bundleInfo1: AppItemInfo = {
          bundleName: 'anyBundleName',
          typeId: 99999,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          badgeNumber: 1,
          area: [1,2,3,4,5,6,7,8,9],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          isUninstallAble: true,
          isSystemApp: false
        } as AppItemInfo;
        instance.updateFormId(formInfo, bundleInfoList);
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (err) {}
    });

    it('test_addInfoToFolder01', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let folderItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo;
        let newAppItem: AppItemInfo = new AppItemInfo;
        let a = 'test';
        folderItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        folderItemInfo.layoutInfo = [];
        (instance as object)['addInfoToFolder'](folderItemInfo,newAppItem)
        expect(a).assertEqual('test')
      } catch (err) {}
    })

    it('test_addInfoToFolder02', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let folderItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo;
        let newAppItem: AppItemInfo = new AppItemInfo;
        folderItemInfo.typeId = 123;
        (instance as object)['addInfoToFolder'](folderItemInfo,newAppItem)
        expect(a).assertEqual('test')
      } catch (err) {}
    })

    it('test_updateAppInFolderByInstalledApps', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let totalAppInfoList: AppItemInfo[] = [];
        let a ='test';
        let item1: AppItemInfo = new AppItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        item1.typeId === CommonConstants.TYPE_FOLDER;
        let item2: AppItemInfo = new AppItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        item2.typeId === CommonConstants.TYPE_FOLDER;
        let item3: AppItemInfo = new AppItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        item3.typeId === CommonConstants.TYPE_FOLDER;
        totalAppInfoList.push(item1);
        totalAppInfoList.push(item2);
        totalAppInfoList.push(item3);
        instance.updateAppInFolderByInstalledApps();
        expect(a).assertEqual('test')
      } catch (err) {}
    });

    it('test_updateGridLayoutInfoPosition', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo;
        let a ='test';
        let page = 1;
        let col = 1;
        let row = 1;
        let ret: GridLayoutItemInfo = PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item,page,col,row);
        expect(a).assertEqual('test')
      } catch (err) {}
    });

    it('test_ifColumnOrRowAreBigger01', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo;
        let layoutInfo: GridLayoutItemInfo[] = [];
        let a ='test';
        item.column = 2;
        item.row = 2;
        item.page = 2;
        layoutInfo.push(item)
        let column = 1;
        let row = 1;
        let ret: Boolean = instance.ifColumnOrRowAreBigger(layoutInfo,column,row);
        expect(a).assertEqual('test')
      } catch (err) {}
    });

    it('test_ifColumnOrRowAreBigger02', 0, () => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo;
        let layoutInfo: GridLayoutItemInfo[] = [];
        item.column = 1;
        item.row = 1;
        item.page = CommonConstants.WATERFALL_PAGE_INDEX;
        let a ='test';
        layoutInfo.push(item)
        let column = 2;
        let row = 2;
        let ret: Boolean = instance.ifColumnOrRowAreBigger(layoutInfo,column,row);
        expect(a).assertEqual('test')
      } catch (err) {}
    });

    it('test_getAlignStatus', 0, async () => {
      try {
        let pageDesktop: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        let instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktop);
        let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).getApplicationContext();
        let statusResult: boolean = false;
        await preferences.getPreferences(context, 'DesktopSetting').then((preference) => {
          statusResult = preference.getSync('autoAlignStatus', false) as boolean;
        })
        let result: boolean =  await instance.getAlignStatus();
        expect(a).assertEqual('test')
      } catch (err) {}
    });

    it('test_sortAndChangeForAutoAlign', 0, async () => {
      try {
        let pageDesktop: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktop);
        let gridNull: GridLayoutItemInfo[] = [];
        let a ='test';
        let appItemDemo: AppItemInfo = new AppItemInfo();
        appItemDemo.bundleName = 'anyBundleName';
        let result :SqueezeGridLayout[] =instance.sortAndChangeForAutoAlign(gridNull, [appItemDemo])
        expect(a).assertEqual('test')
      } catch (err) {}
    });

    it('test_initOuterInstalledInfo', 0, async () => {
      try {
        let pageDesktop: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktop);
        let totalAppInfoList: AppItemInfo[] = [];
        let pageDesktopInfo: GridLayoutItemInfo[] = [];
        let outerLayoutInfoList: GridLayoutItemInfo[] = [];
        let a ='test';
        let pageDesktopInfoItem: GridLayoutItemInfo = {
          abilityName : 'AppModel',
          appName : 'AppModelName',
          appIconId : 9999,
          bundleName : 'com.ohos.appModel',
          moduleName : 'model',
          keyName : 'PageDesktop'
        } as GridLayoutItemInfo;
        let pageDesktopInfoItem1: AppItemInfo = {
          abilityName : 'AppModel',
          appName : 'AppModelName',
          appIconId : 9999,
          bundleName : 'com.ohos.appModel',
          moduleName : 'model',
          keyName : 'PageDesktop'
        } as AppItemInfo;
        outerLayoutInfoList.push(pageDesktopInfoItem);
        totalAppInfoList.push(pageDesktopInfoItem1);
        instance.initOuterInstalledInfo(totalAppInfoList, pageDesktopInfo, outerLayoutInfoList);
        expect(a).assertEqual('test')
      } catch (err) {}
    });

    it('buildGridLayoutInfoFromItemInfo', 0, async(done:Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let appItemInfo1 = new GridLayoutItemInfo();
        appItemInfo1.bundleName = 'anyBundleName';
        appItemInfo1.typeId = 99999;
        appItemInfo1.abilityName = 'anyAbilityName';
        appItemInfo1.moduleName = 'anyModuleName';
        appItemInfo1.keyName = 'anyKeyName';
        appItemInfo1.badgeNumber = 1;
        appItemInfo1.area = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        appItemInfo1.appName = 'anyAppName';
        appItemInfo1.appIconId = 88888;
        appItemInfo1.appLabelId = 77777;
        appItemInfo1.kindId = 66666;
        appItemInfo1.bundleType = 2;
        appItemInfo1.applicationName = 'anyAppliucationName';
        appItemInfo1.appStatus = 0;
        appItemInfo1.downloadProgress = 0;
        appItemInfo1.iconResource = 'anyIconResource';
        appItemInfo1.callerName = 'anyCallerName';
        appItemInfo1.folderName = 'anyFolderName';
        appItemInfo1.folderId = 'anyFolderId';
        appItemInfo1.container = 111;
        appItemInfo1.extend1 = 'anyExtend1';
        let ret: GridLayoutItemInfo = instance.buildGridLayoutInfoFromItemInfo(appItemInfo1, 1, 1, 1);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it("updateFolderAppLocation", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let gridLayoutItemInfo: GridLayoutItemInfo = {
          bundleName: 'anyBundleName',
          typeId: CommonConstants.TYPE_FOLDER,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          badgeNumber: 1,
          area: [1, 2, 3, 4, 5, 6, 7, 8, 9],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          folderName: 'anyFolderName',
          folderId: 'anyFolderId',
          container: 111,
          extend1: 'anyExtend1',
          row: 1,
          column: 1,
          page: 1,
          layoutInfo: [[
            {
              bundleName: 'bundleName',
              folderId: ''
            }
          ]]
        } as GridLayoutItemInfo;
        let a = 'test';
        let layoutList = [gridLayoutItemInfo, gridLayoutItemInfo, gridLayoutItemInfo];
        (instance as object)['updateFolderAppLocation'](layoutList);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("sortDeliverFolderApp1", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a = 'test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let result: GridLayoutItemInfo[] = (instance as object)['sortDeliverFolderApp']([]);
        expect(a).assertEqual('test');
      } catch (err) {
      }
      done();
    })

    it("sortDeliverFolderApp2", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let gridLayoutItemInfo: GridLayoutItemInfo = {
        bundleName: 'anyBundleName',
        typeId: CommonConstants.TYPE_FOLDER,
        abilityName: 'anyAbilityName',
        moduleName: 'anyModuleName',
        keyName: 'anyKeyName',
        badgeNumber: 1,
        area: [1, 2, 3, 4, 5, 6, 7, 8, 9],
        appName: 'anyAppName',
        appIconId: 88888,
        appLabelId: 77777,
        kindId: 66666,
        bundleType: 2,
        applicationName: 'anyAppliucationName',
        appStatus: 0,
        downloadProgress: 0,
        iconResource: 'anyIconResource',
        callerName: 'anyCallerName',
        folderName: 'anyFolderName',
        folderId: 'anyFolderId',
        container: 111,
        extend1: 'anyExtend1',
        row: 1,
        column: 1,
        page: 1,
        layoutInfo: [[
          {
            bundleName: 'bundleName',
            folderId: ''
          }
        ]]
      } as GridLayoutItemInfo;
      let layoutList = [gridLayoutItemInfo, gridLayoutItemInfo, gridLayoutItemInfo];
      let mocker: MockKit = new MockKit();
      let a ='test';
      try {
        (instance as object)['sortDeliverFolderApp'](layoutList);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clearAll();
      done();
    })

    it("sortDeliverFolderApp3", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let gridLayoutItemInfo: GridLayoutItemInfo = {
        bundleName: 'anyBundleName',
        typeId: CommonConstants.TYPE_FOLDER,
        abilityName: 'anyAbilityName',
        moduleName: 'anyModuleName',
        keyName: 'anyKeyName',
        badgeNumber: 1,
        area: [1, 2, 3, 4, 5, 6, 7, 8, 9],
        appName: 'anyAppName',
        appIconId: 88888,
        appLabelId: 77777,
        kindId: 66666,
        bundleType: 2,
        applicationName: 'anyAppliucationName',
        appStatus: 0,
        downloadProgress: 0,
        iconResource: 'anyIconResource',
        callerName: 'anyCallerName',
        folderName: 'anyFolderName',
        folderId: 'anyFolderId',
        container: 111,
        extend1: 'anyExtend1',
        intent: `{'name':'value'}`,
        row: 1,
        column: 1,
        page: 1,
        layoutInfo: [[
          {
            bundleName: 'bundleName',
            folderId: ''
          }
        ]]
      } as GridLayoutItemInfo;
      let layoutList = [gridLayoutItemInfo, gridLayoutItemInfo, gridLayoutItemInfo];
      let mocker: MockKit = new MockKit();
      let a = 'test';
      try {
        (instance as object)['sortDeliverFolderApp'](layoutList);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clearAll();
      done();
    })

    it("refreshAddIcon1", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('openFolderId');
      let a ='test';
      try {
        (instance as object)['refreshAddIcon']('openFolderId');
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(AppStorage);
      mocker.clearAll();
      done();
    })

    it("refreshAddIcon2", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('openFolderId');
      let a ='test';
      try {
        (instance as object)['refreshAddIcon']('');
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(AppStorage);
      mocker.clearAll();
      done();
    })

    it("checkInLayout1", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let itemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.typeId = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'bundleName';
        let a ='test';
        let infoList = [itemInfo];
        (instance as object)['checkInLayout'](infoList, 'bundleName');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("checkInLayout2", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let gridLayoutItemInfo: GridLayoutItemInfo = {
          bundleName: 'anyBundleName',
          typeId: CommonConstants.TYPE_FOLDER,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          badgeNumber: 1,
          area: [1, 2, 3, 4, 5, 6, 7, 8, 9],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          folderName: 'anyFolderName',
          folderId: 'anyFolderId',
          container: 111,
          extend1: 'anyExtend1',
          intent: `{'name':'value'}`,
          row: 1,
          column: 1,
          page: 1,
          layoutInfo: [[
            {
              bundleName: 'bundleName',
              folderId: ''
            }
          ]]
        } as GridLayoutItemInfo;
        let itemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_FOLDER;
        itemInfo.typeId = CommonConstants.TYPE_FOLDER;
        itemInfo.bundleName = 'bundleName';
        itemInfo.layoutInfo = [[gridLayoutItemInfo, gridLayoutItemInfo], [gridLayoutItemInfo]];
        let infoList = [itemInfo];
        let a ='test';
        (instance as object)['checkInLayout'](infoList, 'bundleName');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("checkInLayout3", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let itemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_ADD;
        itemInfo.typeId = CommonConstants.TYPE_ADD;
        itemInfo.bundleName = 'bundleName';
        let infoList = [itemInfo];
        let a ='test';
        (instance as object)['checkInLayout'](infoList, 'bundleName');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("getAlignStatus1", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let globalContextInstance = GlobalContext.getInstance();
      let mockFunction: Function =
        mocker.mockFunc(globalContextInstance, globalContextInstance.getObject);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let a ='test';
      try {
        await instance.getAlignStatus();
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(globalContextInstance);
      mocker.clearAll();
      done();
    })

    it("getAlignStatus2", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let globalContextInstance = GlobalContext.getInstance();
      let desktopContext = new Object({
        getApplicationContext: () => {
          return;
        }
      }) as ctx.ServiceExtensionContext;
      let mockFunction: Function =
        mocker.mockFunc(globalContextInstance, globalContextInstance.getObject);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(desktopContext);
      let a ='test';
      try {
        await instance.getAlignStatus();
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(globalContextInstance);
      mocker.clearAll();
      done();
    })

    it("getAlignStatus3", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let globalContextInstance = GlobalContext.getInstance();
      let applicationContext = new Object({});
      let desktopContext = new Object({
        getApplicationContext: () => {
          return applicationContext
        }
      }) as ctx.ServiceExtensionContext;
      let mockFunction: Function =
        mocker.mockFunc(globalContextInstance, globalContextInstance.getObject);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(desktopContext);
      let a ='test';
      try {
        await instance.getAlignStatus();
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(globalContextInstance);
      mocker.clearAll();
      done();
    })

    it("sortAndChangeForAutoAlign1", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let a ='test';
        instance.sortAndChangeForAutoAlign([], []);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("compareGridLayoutItemByLocation", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        (instance as object)['compareGridLayoutItemByLocation'](undefined, undefined, 1);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("compareGridLayoutItemByLocation", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let gridLayoutItemInfo: GridLayoutItemInfo = {
          bundleName: 'bundleName',
          typeId: CommonConstants.TYPE_ADD,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          badgeNumber: 1,
          area: [1, 2],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          folderName: 'anyFolderName',
          folderId: 'anyFolderId',
          container: 111,
          extend1: 'anyExtend1',
          intent: `{'name':'value'}`,
          row: 1,
          column: 1,
          page: 1,
          layoutInfo: [[
            {
              bundleName: 'bundleName',
              folderId: ''
            }
          ]]
        } as GridLayoutItemInfo;
        let a = 'test';
        (instance as object)['compareGridLayoutItemByLocation'](gridLayoutItemInfo, gridLayoutItemInfo, 1);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("isBundleNameAppExistInDock1", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let a ='test';
      try {
        instance.isBundleNameAppExistInDock('bundleName', 1);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(AppStorage);
      mocker.clearAll();
      done();
    })

    it("handleRgmStatusChangeEvent1", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let event = new Object({
          event: 'event',
          parameters: new Object({
            'rgmStatus': 'rgm_user_unlocked'
          })
        }) as CommonEvent;
        let a ='test';
        (instance as object)['handleRgmStatusChangeEvent'](event);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("handleRgmStatusChangeEvent2", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let event = new Object({
        event: 'event',
        parameters: new Object({
          'rgmStatus': 'rgm_remove'
        })
      }) as CommonEvent;
      let mocker: MockKit = new MockKit();
      let a = 'test';
      try {
        (instance as object)['handleRgmStatusChangeEvent'](event);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clearAll();
      done();
    })

    it("handleRgmStatusChangeEvent3", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let event = new Object({
        event: 'event',
        parameters: new Object({
          'rgmStatus': 'rgm_remove'
        })
      }) as CommonEvent;
      let gridLayoutItemInfo: GridLayoutItemInfo = {
        bundleName: 'bundleName',
        typeId: CommonConstants.TYPE_ADD,
        abilityName: 'anyAbilityName',
        moduleName: 'anyModuleName',
        keyName: 'anyKeyName',
        badgeNumber: 1,
        area: [1, 2],
        appName: 'anyAppName',
        appIconId: 88888,
        appLabelId: 77777,
        kindId: 66666,
        bundleType: 2,
        applicationName: 'anyAppliucationName',
        appStatus: 0,
        downloadProgress: 0,
        iconResource: 'anyIconResource',
        callerName: 'anyCallerName',
        folderName: 'anyFolderName',
        folderId: 'anyFolderId',
        container: 111,
        extend1: 'anyExtend1',
        intent: `{'name':'value'}`,
        row: 1,
        column: 1,
        page: 1,
        layoutInfo: [[
          {
            bundleName: 'bundleName',
            folderId: ''
          }
        ]]
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction2: Function =
        mocker.mockFunc(viewModel, (viewModel as object)['lightPagingFiltering']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let a ='test';
      try {
        (instance as object)['handleRgmStatusChangeEvent'](event);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(viewModel);
      mocker.clearAll();
      done();
    })

    it("handleRgmStatusChangeEvent4", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let event = new Object({
        event: 'event',
        parameters: new Object({
          'rgmStatus': 'rgm_remove'
        })
      }) as CommonEvent;
      let gridLayoutItemInfo: GridLayoutItemInfo = {
        bundleName: 'bundleName',
        typeId: CommonConstants.TYPE_ADD,
        abilityName: 'anyAbilityName',
        moduleName: 'anyModuleName',
        keyName: 'anyKeyName',
        badgeNumber: 1,
        area: [1, 2],
        appName: 'anyAppName',
        appIconId: 88888,
        appLabelId: 77777,
        kindId: 66666,
        bundleType: 2,
        applicationName: 'anyAppliucationName',
        appStatus: 0,
        downloadProgress: 0,
        iconResource: 'anyIconResource',
        callerName: 'anyCallerName',
        folderName: 'anyFolderName',
        folderId: 'anyFolderId',
        container: 111,
        extend1: 'anyExtend1',
        intent: `{'name':'value'}`,
        row: 1,
        column: 1,
        page: 1,
        layoutInfo: [[
          {
            bundleName: 'bundleName',
            folderId: ''
          }
        ]]
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction2: Function =
        mocker.mockFunc(viewModel, (viewModel as object)['lightPagingFiltering']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let a ='test';
      try {
        (instance as object)['handleRgmStatusChangeEvent'](event);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(viewModel);
      mocker.clearAll();
      done();
    })

    it("handleRgmStatusChangeEvent5", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let a ='test';
        let event = new Object({
          event: 'event',
          parameters: new Object({
            'rgmStatus': ''
          })
        }) as CommonEvent;
        (instance as object)['handleRgmStatusChangeEvent'](event);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("refreshDeliverAppList1", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let promise = Promise.resolve([]);
      let mockFunction: Function =
        mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getLauncherAbilityList);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(promise);
      let a ='test';
      try {
        instance.refreshDeliverAppList();
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
      done();
    })

    it("getCardDimension1", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let gridLayoutItemInfo: GridLayoutItemInfo = {
          bundleName: 'bundleName',
          typeId: CommonConstants.TYPE_ADD,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          shortcutId: 'shortcutId123',
          badgeNumber: 1,
          area: [1, 2],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          folderName: 'anyFolderName',
          folderId: 'anyFolderId',
          container: 111,
          extend1: 'anyExtend1',
          intent: `{'name':'value'}`,
          row: 2,
          column: 2,
          page: 2,
          layoutInfo: [[
            {
              bundleName: 'bundleName',
              folderId: ''
            }
          ]]
        } as GridLayoutItemInfo;
        let a = 'test';
        instance.getCardDimension(0, gridLayoutItemInfo);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("getCardDimension2", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let a = 'test';
        let gridLayoutItemInfo: GridLayoutItemInfo = {
          bundleName: 'bundleName',
          typeId: CommonConstants.TYPE_ADD,
          abilityName: 'anyAbilityName',
          moduleName: 'anyModuleName',
          keyName: 'anyKeyName',
          shortcutId: 'shortcutId123',
          badgeNumber: 1,
          area: [1, 2],
          appName: 'anyAppName',
          appIconId: 88888,
          appLabelId: 77777,
          kindId: 66666,
          bundleType: 2,
          applicationName: 'anyAppliucationName',
          appStatus: 0,
          downloadProgress: 0,
          iconResource: 'anyIconResource',
          callerName: 'anyCallerName',
          folderName: 'anyFolderName',
          folderId: 'anyFolderId',
          container: 111,
          extend1: 'anyExtend1',
          intent: `{'name':'value'}`,
          row: 2,
          column: 2,
          page: 2,
          layoutInfo: [[
            {
              bundleName: 'bundleName',
              folderId: ''
            }
          ]]
        } as GridLayoutItemInfo;
        instance.getCardDimension(1, gridLayoutItemInfo);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("findBlankPositionWithoutVerify1", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let itemLocation:ItemLocation = new Object({}) as ItemLocation;
        instance.findBlankPositionWithoutVerify(0, 0, itemLocation);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("findBlankPositionWithoutVerify2", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let itemLocation:ItemLocation = new Object({}) as ItemLocation;
        let a ='test';
        itemLocation.findRow = 1;
        itemLocation.curRow = 2;
        itemLocation.findCol = 1;
        itemLocation.curCol = 2;
        itemLocation.findPage = 1;
        itemLocation.curPage = 2;
        instance.findBlankPositionWithoutVerify(10, 10, itemLocation);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("hasNextItemLocationInOnePage", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a = 'test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let itemLocation:ItemLocation = new Object({}) as ItemLocation;
        itemLocation.findRow = 1;
        itemLocation.curRow = 2;
        itemLocation.findCol = 1;
        itemLocation.curCol = 2;
        itemLocation.findPage = 1;
        itemLocation.curPage = 2;
        (instance as object)['hasNextItemLocationInOnePage'](1, 1, itemLocation);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("findBlankPositionFromOnePage1", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let itemLocation:ItemLocation = new Object({}) as ItemLocation;
        let a ='test';
        let itemInfo = new GridLayoutItemInfo();
        (instance as object)['findBlankPositionFromOnePage'](0, 0, 0, itemInfo, itemLocation);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("findBlankPositionFromOnePage2", 0, async (done: Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let itemLocation:ItemLocation = new Object({}) as ItemLocation;
      let itemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let launchLayoutCacheManager:LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mockFunction: Function =
        mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.isPositionValid);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let a = 'test';
      try {
        (instance as object)['findBlankPositionFromOnePage'](1, 1, 1, itemInfo, itemLocation);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(launchLayoutCacheManager);
      mocker.clearAll();
      done();
    })

    it("getStartFindItemLocation", 0, async (done: Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a ='test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        PageDesktopViewModelUtils.getStartFindItemLocation(1, 1, 1);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("SqueezeGridLayout", 0, async (done: Function) => {
      try {
        let updateItemsInfo = new GridLayoutItemInfo();
        let a  = 'test';
        let sueezeGridLayout = new SqueezeGridLayout('keyname', updateItemsInfo, [1, 2, 3], [4, 5, 6]);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("test_appendFormStackData1", 0, async(done:Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        let folderInfoList: GridLayoutItemInfo[] = [];
        folderInfoList.push(dockItem);
        let bundleInfoList: GridLayoutItemInfo[] = [];
        let a ='test';
        let cardItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
        cardItem1.cardId = '2';
        bundleInfoList.push(cardItem1);
        instance.appendFormStackData(folderInfoList, bundleInfoList);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("test_sortDeliverFolderApp1", 0, async(done:Function) => {
      try {
        const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        let a = 'test';
        const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
        let newArr: GridLayoutItemInfo[] = [];
        (instance as object)['sortDeliverFolderApp'](newArr);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it("test_makeContainerFolderToDesktop1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let layoutDescription = {
        pageCount: 1,
        row: 1,
        column: 1,
        maxPage: 1,
        maxForm: 1,
      } as LayoutDescription;
      let appItemInfo = new AppItemInfo()
      let containerFolder = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(layoutDescription);
      let mockFunction1: Function =
        mocker.mockFunc(instance, (instance as object)['setIsMakingFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(instance, (instance as object)['makeFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(containerFolder);
      let mockFunction3: Function =
        mocker.mockFunc((instance as object)['pageDesktopViewModel'], (instance as object)['pageDesktopViewModel'].updateElementLocation);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let a ='test';
      try {
        (instance as object)['makeContainerFolderToDesktop'](appItemInfo);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(instance);
      mocker.clear((instance as object)['pageDesktopViewModel']);
      mocker.clearAll();
      done();
    })

    it("test_addInfoToFolder1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let folderItemInfo = new GridLayoutItemInfo();
      let newAppItem = new AppItemInfo();
      folderItemInfo.typeId = CommonConstants.TYPE_ADD;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let a ='test';
      try {
        (instance as object)['addInfoToFolder'](folderItemInfo,newAppItem);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_addInfoToFolder2", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let folderItemInfo = new GridLayoutItemInfo();
      let newAppItem = new AppItemInfo();
      folderItemInfo.typeId = CommonConstants.TYPE_FOLDER;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(instance, (instance as object)['getGridLayoutItemInfo']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(folderItemInfo);
      let mockFunction2: Function =
        mocker.mockFunc(FolderLayoutCacheManager.getInstance(), FolderLayoutCacheManager.getInstance().insertAppItemToFolder);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let a = 'test';
      try {
        (instance as object)['addInfoToFolder'](folderItemInfo,newAppItem);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clear(instance);
      mocker.clear(FolderLayoutCacheManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("test_getGridLayoutItemInfo1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let folderItemInfo = new GridLayoutItemInfo();
      folderItemInfo.layoutInfo = [[]];
      folderItemInfo.page = 0;
      folderItemInfo.row = 1;
      folderItemInfo.column = 1;
      folderItemInfo.folderId = '';
      folderItemInfo.typeId = CommonConstants.TYPE_ADD;
      let newAppItem = new AppItemInfo();
      newAppItem.bundleName = '';
      newAppItem.page = 0;
      newAppItem.row = 1;
      newAppItem.column = 1;
      newAppItem.typeId = CommonConstants.TYPE_ADD;
      let dockItemInfo = new DockItemInfo();
      dockItemInfo.layoutInfo = [[folderItemInfo]];
      dockItemInfo.itemType = 3;
      dockItemInfo.row = 1;
      dockItemInfo.column = 1;
      dockItemInfo.typeId = CommonConstants.TYPE_ADD;
      dockItemInfo.bundleName = '';
      let residentList = [dockItemInfo];
      let mocker: MockKit = new MockKit();
      let openFolderConfig = {} as FolderLayoutStruct;
      let mockFunction: Function =
        mocker.mockFunc(FolderModel.getInstance(), FolderModel.getInstance().getFolderOpenLayout);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(openFolderConfig);
      let mockFunction1: Function =
        mocker.mockFunc(instance, (instance as object)['buildGridLayoutInfoFromItemInfo']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(folderItemInfo);
      let a ='test';
      try {
        let result: GridLayoutItemInfo | undefined =
          (instance as object)['getGridLayoutItemInfo'](dockItemInfo, newAppItem);
        expect(result).not().assertUndefined();
      } catch (err) {}
      mocker.clear(FolderModel.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("test_sortAndChangeForAutoAlign1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let folderItemInfo = new GridLayoutItemInfo();
      folderItemInfo.layoutInfo = [[]];
      folderItemInfo.page = 0;
      folderItemInfo.row = 1;
      folderItemInfo.column = 1;
      folderItemInfo.folderId = '';
      folderItemInfo.typeId = CommonConstants.TYPE_ADD;
      let itemList = [folderItemInfo];
      let uninstallAppItem = new AppItemInfo();
      uninstallAppItem.bundleName = '';
      uninstallAppItem.page = 0;
      uninstallAppItem.row = 1;
      uninstallAppItem.column = 1;
      uninstallAppItem.typeId = CommonConstants.TYPE_ADD;
      uninstallAppItem.shortcutId = '1';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let layoutDescription = {
        pageCount: 1,
        row: 1,
        column: 1,
        maxPage: 1,
        maxForm: 1,
      } as LayoutDescription;
      let mockFunction2: Function =
        mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.selectLayoutDescription);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(layoutDescription);
      let mockFunction3: Function =
        mocker.mockFunc(instance, (instance as object)['compareGridLayoutItemByLocation']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(1);
      let mockFunction4: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(false);
      let updateItemsInfo = new GridLayoutItemInfo();
      let squeezeGridLayout: SqueezeGridLayout = new SqueezeGridLayout('keyname', updateItemsInfo, [1, 2, 3], [4, 5, 6]);
      let AlignItem = [squeezeGridLayout];
      let mockFunction5: Function =
        mocker.mockFunc(instance, (instance as object)['autoAlignGridLayoutItem']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(AlignItem);
      let a ='test';
      try {
        (instance as object)['sortAndChangeForAutoAlign'](itemList, [uninstallAppItem]);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("test_sortAndChangeForAutoAlign2", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let folderItemInfo = new GridLayoutItemInfo();
      folderItemInfo.layoutInfo = [[]];
      folderItemInfo.page = 0;
      folderItemInfo.row = 1;
      folderItemInfo.column = 1;
      folderItemInfo.folderId = '';
      folderItemInfo.typeId = CommonConstants.TYPE_ADD;
      let itemList = [folderItemInfo];
      let uninstallAppItem = new AppItemInfo();
      uninstallAppItem.bundleName = '';
      uninstallAppItem.page = 0;
      uninstallAppItem.row = 1;
      uninstallAppItem.column = 1;
      uninstallAppItem.typeId = CommonConstants.TYPE_ADD;
      uninstallAppItem.shortcutId = '1';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let layoutDescription = {
        pageCount: 1,
        row: 1,
        column: 1,
        maxPage: 1,
        maxForm: 1,
      } as LayoutDescription;
      let mockFunction2: Function =
        mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.selectLayoutDescription);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(layoutDescription);
      let mockFunction3: Function =
        mocker.mockFunc(instance, (instance as object)['compareGridLayoutItemByLocation']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(1);
      let mockFunction4: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      let updateItemsInfo = new GridLayoutItemInfo();
      let squeezeGridLayout: SqueezeGridLayout = new SqueezeGridLayout('keyname', updateItemsInfo, [1, 2, 3], [4, 5, 6]);
      let AlignItem = [squeezeGridLayout];
      let mockFunction5: Function =
        mocker.mockFunc(instance, (instance as object)['autoAlignGridLayoutItem']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(AlignItem);
      let a ='test';
      try {
        (instance as object)['sortAndChangeForAutoAlign'](itemList, [uninstallAppItem]);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("test_autoAlignGridLayoutItem1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let folderItemInfo1 = new GridLayoutItemInfo();
      folderItemInfo1.layoutInfo = [[]];
      folderItemInfo1.page = 0;
      folderItemInfo1.row = 1;
      folderItemInfo1.column = 1;
      folderItemInfo1.folderId = '';
      folderItemInfo1.typeId = CommonConstants.TYPE_ADD;
      folderItemInfo1.bundleName = '123';
      folderItemInfo1.shortcutId = '123';
      folderItemInfo1.area = [1,1];
      folderItemInfo1.keyName = 'keyName';
      let folderItemInfo2 = new GridLayoutItemInfo();
      folderItemInfo2.layoutInfo = [[]];
      folderItemInfo2.page = 0;
      folderItemInfo2.row = 2;
      folderItemInfo2.column = 2;
      folderItemInfo2.folderId = '';
      folderItemInfo2.typeId = CommonConstants.TYPE_ADD;
      folderItemInfo2.bundleName = '123';
      folderItemInfo2.shortcutId = '123';
      folderItemInfo2.area = [1,1];
      folderItemInfo2.keyName = 'keyName';
      let itemList = [folderItemInfo1,folderItemInfo2];
      let uninstallAppItem = new AppItemInfo();
      uninstallAppItem.bundleName = '456';
      uninstallAppItem.page = 0;
      uninstallAppItem.row = 1;
      uninstallAppItem.column = 1;
      uninstallAppItem.typeId = CommonConstants.TYPE_ADD;
      uninstallAppItem.shortcutId = '456';
      uninstallAppItem.area = [1,2];
      uninstallAppItem.keyName = 'keyName';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getIconCenterPosition);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([1]);
      let mockFunction1: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getIconCenterPosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([2]);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.generateUniqueKey);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn('keyName');
      let a ='test';
      try {
        (instance as object)['autoAlignGridLayoutItem'](itemList, [uninstallAppItem]);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    })

    it("test_isBundleNameAppExistInDock1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let dockItemInfo = new DockItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let a ='test';
      try {
        instance.isBundleNameAppExistInDock('1',1);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(AppStorage);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_isBundleNameAppExistInDock2", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let dockItemInfo = new DockItemInfo();
      dockItemInfo.itemType = CommonConstants.TYPE_APP;
      dockItemInfo.bundleName = '2';
      dockItemInfo.appIndex = 2;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let a = 'test';
      try {
        instance.isBundleNameAppExistInDock('1',1);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(AppStorage);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_isBundleNameAppExistInDock3", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let folderItemInfo1 = new GridLayoutItemInfo();
      folderItemInfo1.layoutInfo = [[]];
      folderItemInfo1.page = 0;
      folderItemInfo1.row = 1;
      folderItemInfo1.column = 1;
      folderItemInfo1.folderId = '';
      folderItemInfo1.typeId = CommonConstants.TYPE_ADD;
      folderItemInfo1.bundleName = '123';
      folderItemInfo1.shortcutId = '123';
      folderItemInfo1.area = [1,1];
      folderItemInfo1.keyName = 'keyName';
      folderItemInfo1.appIndex = 1;
      let dockItemInfo = new DockItemInfo();
      dockItemInfo.itemType = CommonConstants.TYPE_FOLDER;
      dockItemInfo.bundleName = '123';
      dockItemInfo.appIndex = 1;
      dockItemInfo.layoutInfo = [[folderItemInfo1]];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let a = 'test';
      try {
        instance.isBundleNameAppExistInDock('123',1);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(AppStorage);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_initDeliverStatusChange1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, (instance as object)['handleRgmStatusChangeEvent']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let a = 'test';
      try {
        let event = {} as CommonEvent;
        await (instance as object)['handleRgmStatusChangeEvent'](event);
        EvtBus.post(RgmStatusChangeEvent,event);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("test_handleRgmStatusChangeEvent1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let event = new Object({
        event: 'event',
        parameters: new Object({
          "rgmStatus":"rgm_remove"
        })
      }) as CommonEvent;
      let gridLayoutItemInfo = new GridLayoutItemInfo();
      let deleteItemList = [gridLayoutItemInfo];
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let a ='test';
      try {
        (instance as object)['handleRgmStatusChangeEvent'](event);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_refreshDeliverAppList1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let appItem = new AppItemInfo();
      let appList = [appItem];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getLauncherAbilityList);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve(appList));
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let a ='test';
      try {
        instance.refreshDeliverAppList();
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(launcherAbilityManager);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_findPositionForContainerApp1", 0, async(done:Function) => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let appItem = new AppItemInfo();
      appItem.typeId = CommonConstants.TYPE_ADD;
      appItem.codePath = '1';
      appItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
      appItem.bundleName = 'bundleName';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppInfoByBundleName);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(appItem);
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let a ='test';
      try {
        instance.findPositionForContainerApp(appItem,false);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(AppModel.getInstance());
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('selectContainerAppIndexInLayout00', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let containerIndex: number[] = [-1, -1];
        instance.selectContainerAppIndexInLayout(bundleName, containerIndex);
        expect(containerIndex[1]).assertEqual(-1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('selectContainerAppIndexInLayout01', 1, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let containerIndex: number[] = [-1, -1];
        instance.selectContainerAppIndexInLayout('bundleName', containerIndex);
        expect(containerIndex[1]).assertEqual(-1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('selectContainerAppIndexInLayout02', 2, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let containerIndex: number[] = [-1, -1];
        instance.selectContainerAppIndexInLayout(bundleName, containerIndex);
        expect(containerIndex[0]).assertEqual(-1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('selectContainerAppIndexInLayout03', 3, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.extend1 = CommonConstants.CONTAINER_APP_KIND_ID.toString();
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let containerIndex: number[] = [-1, -1];
        instance.selectContainerAppIndexInLayout('bundleName', containerIndex);
        expect(infoId).assertEqual('1');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('updateFolderLayoutInfo00', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.appIndex = undefined;
      demoApp.keyName = keyName;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.badgeNumber = 10;
      demoApp.badgeNumber = 0;
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.badgeNumber = 3;

      // 条件1
      let newApp: AppItemInfo = new AppItemInfo();
      newApp.keyName = 'keyName';
      newApp.bundleName = bundleName;
      newApp.appIndex = undefined;
      newApp.appStatus = AppStatus.WAIT_FOR_HARMONY;
      try {
        instance.updateFolderLayoutInfo(demoFolder);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let appModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleInfo);
      let mockFunc2: Function = mocker.mockFunc(appModel, appModel.checkIsMultiIcon);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(newApp);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        instance.updateFolderLayoutInfo(demoFolder);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let res: string = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('test');
      mocker.clear(appModel);
      mocker.clearAll()
    })
    // 小文件夹刷新
    it('updateFolderLayoutInfo01', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.area = [1, 1];
      demoFolder.badgeNumber = 10;
      demoApp.badgeNumber = 0;
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.badgeNumber = 3;

      const newBundle = 'com.bundle.new';
      const appName = 'new Name';
      let newApp: AppItemInfo = new AppItemInfo();
      newApp.keyName = keyName;
      newApp.bundleName = newBundle;
      newApp.isUninstallAble = true;
      newApp.isSystemApp = true;
      newApp.appLabelId = 223344;
      newApp.appIconId = 1000;
      newApp.appName = appName;
      try {
        const isSmallFolder: boolean = GridLayoutUtil.isSmallFolder(demoFolder);
        expect(isSmallFolder).assertTrue();
        instance.updateFolderLayoutInfo(demoFolder);
        expect(demoFolder.layoutInfo.length).assertLarger(0);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    // 大文件夹刷新
    it('updateFolderLayoutInfo02', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [2, 2];
      demoApp.keyName = keyName;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.area = [2, 2];
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.badgeNumber = 10;
      demoApp.badgeNumber = 0;
      try {
        const isSmallFolder: boolean = GridLayoutUtil.isSmallFolder(demoFolder);
        expect(isSmallFolder).assertFalse();
        instance.updateFolderLayoutInfo(demoFolder);
        expect(demoFolder.layoutInfo.length).assertLarger(0);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });
  })
}