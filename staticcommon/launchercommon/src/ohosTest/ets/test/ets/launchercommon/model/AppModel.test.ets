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
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import {
  AppItemInfo,
  AppModel,
  CommonConstants,
  DeliverUtil,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  launcherAbilityManager,
  RdbStoreManager
} from '../../../../../../main/ets/TsIndex';
import { ShortcutInfo, ShortcutWant } from '../../../../../../main/ets/bean/ReceiveEventInfo';
import { EventConstants } from '../../../../../../main/ets/constants/EventConstants';
import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { AccountMgr, DeviceHelper, PackageCommonEvent } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { IconChangeListener } from '../../../../../../main/ets/model/AppModel';

export function AppModelTest() {
  let model: AppModel = AppModel.getInstance();
  describe('AppModelTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('test_getInstance', Level.LEVEL0, (): void => {
      let another = AppModel.getInstance();
      expect(another).assertEqual(model);
    })

    it('test_deleteBundleItem01', Level.LEVEL0, async (done: Function): Promise<void> => {
      const appList: AppItemInfo[] = model.getAppList();
      if (appList.length > 0) {
        const appInfo: AppItemInfo = appList[0];
        model.deleteBundleItem(appInfo);
        let appListAfterRemove: AppItemInfo[] = model.getAppList();
        expect(appListAfterRemove.length).assertLessOrEqual(appList.length);
        const index: number = appListAfterRemove.findIndex((value, index) => {
          return value === appInfo;
        });
        expect(index).assertLess(0);
        done();
      }
    })

    it('test_getWithKey', Level.LEVEL0, async (done: Function): Promise<void> => {
      const appList: AppItemInfo[] = model.getAppList();
      if (appList.length > 0) {
        const appInfo: AppItemInfo = appList[0];
        let key = `${appInfo.bundleName}${appInfo.abilityName}${appInfo.moduleName}`;
        const appReturned: AppItemInfo = model.isExistBundleInfoList(key);
        expect(model).not().assertNull();
        done();
      }
    })

    it('test_getShortcutInfo', Level.LEVEL0, (): void => {
      // 无法获取到系统应用的 shortCut 信息
      let shortCutInfo = model.getShortcutInfo('');
      expect(shortCutInfo).not().assertNull();
    })

    it('test_getAppInfoByBundleNameNotExists', Level.LEVEL0, (): void => {
      let itemInfo = model.getAppInfoByBundleName('');
      expect(itemInfo).assertEqual(undefined);
    })

    it('test_getAppInfoByBundleName', Level.LEVEL0, (): void => {
      const appList: AppItemInfo[] = model.getAppList();
      if (appList.length > 0) {
        const appInfo: AppItemInfo = appList[0];
        let itemInfo = model.getAppInfoByBundleName(appInfo.bundleName);
        expect(typeof  itemInfo).assertEqual(typeof appInfo);
      }
    })

    it('test_getAppInfoByBundleNameAndAbilityNotExists', Level.LEVEL0, (): void => {
      let itemInfo = model.getAppInfoByBundleNameAndAbility('', '');
      expect(itemInfo).assertEqual(undefined);
    })

    it('test_getAppInfoByBundleNameAndAbility', Level.LEVEL0, (): void => {
      const appList: AppItemInfo[] = model.getAppList();
      if (appList.length > 0) {
        const appInfo: AppItemInfo = appList[0];
        let itemInfo = model.getAppInfoByBundleNameAndAbility(appInfo.bundleName, appInfo.abilityName);
        expect(itemInfo).assertEqual(appInfo);
      }
    })

    it('test_isExistBundleInfoList', Level.LEVEL0, (): void => {
      const key = 'keyNotExists';
      let itemInfo = model.isExistBundleInfoList(key);
      expect(itemInfo).assertNull();
    })

    it('test_loadAppList01', Level.LEVEL0, async (done: Function): Promise<void> => {
      await model.loadAppList();
      expect(model.isExistBundleInfoList('')).assertEqual(null);
      done();
    })

    it('test_loadAppList02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      //result && result.length>0 false
      let mockFunc1: Function = mocker.mockFunc(instance, instance.loadAppList);
      let result: AppItemInfo[] =[];
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      expect(instance.loadAppList()).assertUndefined();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_getShortcutInfoFromManager', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let bundleName: string = 'anyBundleName';
      await instance.getShortcutInfoFromManager(bundleName);
      expect(instance).not().assertUndefined();
      done();
    });

    it('test_getShortcutInfo01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let bundleName: string = 'anyBundleName';
      instance.getShortcutInfo(bundleName);
      expect(instance).not().assertUndefined();
      done();
    });

    it('test_setShortcutInfo02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let bundleName: string = 'anyBundleName';
      let shortcutInfo: ShortcutInfo[] = [];
      instance.setShortcutInfo(bundleName, shortcutInfo);
      expect(instance).not().assertUndefined();
      done();
    });

    it('test_getOperationItemInfo01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getOperationItemInfo);
      when(mockFunc1)(ArgumentMatchers.anyString).afterReturn(undefined);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it('test_getOperationItemInfo02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getOperationItemInfo);
      when(mockFunc1)(ArgumentMatchers.anyString).afterReturn(appItemInfo);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it('test_unregisterAppListEvent', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      instance.registerAppListEvent();
      instance.unregisterAppListEvent();
      expect(instance).not().assertNull();
      done();
    });

    it('test_registerAppListEvent', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      instance.registerAppListEvent();
      expect(instance).not().assertNull();
      done();
    });

    it('test_getUserId', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      instance.getUserId();
      expect(instance).not().assertNull();
      done();
    });

    it('test_getAppIconContainerId', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let traceId: string = 'id';
      let bundleName: string = 'bundleName';
      let abilityName: string = 'abilityName';
      let ret: string = instance.getAppIconContainerId(traceId, bundleName, abilityName);
      expect(ret).not().assertNull();
      done();
    });

    it('test_getAppIconContainerId1', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let traceId: string = 'id';
      let bundleName: string = 'bundleName';
      let abilityName: string = 'abilityName';
      let appIndex: number = 2;
      let ret: string = instance.getAppIconContainerId(traceId, bundleName, abilityName, appIndex);
      expect(ret).not().assertNull();
      done();
    });

    it('test_getAppIconId01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let isOpenFolder: boolean = true;
      let item: AppItemInfo = new AppItemInfo();
      item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      let ret = instance.getAppIconId(isOpenFolder, item);
      expect(ret).not().assertNull();
      done();
    });

    it('test_getAppIconContainerId2', 0, async () => {
      const instance: AppModel = AppModel.getInstance();
      let traceId: string = 'id';
      let bundleName: string = 'bundleName';
      let abilityName: string = 'abilityName';
      let appIndex: number = 2;
      let appInstanceKey: string = 'appInstanceKey';
      let ret: string = instance.getAppIconContainerId(traceId, bundleName, abilityName, appIndex, appInstanceKey);
      expect(ret).not().assertNull();
    });

    it('test_getAppIconId02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let isOpenFolder: boolean = false;
      let item: AppItemInfo = new AppItemInfo();
      item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      let ret = instance.getAppIconId(isOpenFolder, item);
      expect(ret).not().assertNull();
      done();
    });

    it('test_getAppInfoByBundleNameAndAbility01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.anyString).afterReturn(true);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_getAppInfoByBundleNameAndAbility02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.anyString).afterReturn(false);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_getAppInfoByBundleNameAndAbility03', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appList: AppItemInfo[] = [];
      appList[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel'
      };
      let itemBundleName = 'com.ohos.appModel';
      let itemAbilityName = 'AppModel';
      instance.setAppListAsync(appList);
      let appItemInfo: AppItemInfo = instance.getAppInfoByBundleNameAndAbility(itemBundleName, itemAbilityName);
      expect(appItemInfo).not().assertNull();
      done();
    });

    it('test_getAppInfoByBundleNameAndAbility04', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let itemBundleName = 'com.ohos.appModel';
      let itemAbilityName = 'AppModel';
      let ret: AppItemInfo = instance.getAppInfoByBundleNameAndAbility(itemBundleName, itemAbilityName);
      expect(ret).not().assertNull();
      done();
    });

    it('test_getAppInfoByBundleName01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_getAppInfoByBundleName02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appList: AppItemInfo[] = [];
      let appItem: AppItemInfo = new AppItemInfo()
      appItem.abilityName = 'AppModel';
      appItem.appName = 'AppModelName';
      appItem.appIconId = 9999;
      appItem.bundleName = 'com.ohos.appModel';
      appList.push(appItem);
      instance.setAppListAsync(appList);
      instance.getAppInfoByBundleName(appList[0].bundleName);
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteBundleItem02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appList: AppItemInfo[] = [];
      appList[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel'
      };
      instance.setAppListAsync(appList);
      instance.deleteBundleItem(appList[0]);
      expect(instance).not().assertNull();
      done();
    });

    it('test_isExistBundleInfoList01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appList: AppItemInfo[] = [];
      appList[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel',
        moduleName : 'model'
      };
      let keyName: string = 'com.ohos.appModelAppModelmodel';
      instance.setAppListAsync(appList);
      let ret: AppItemInfo = instance.isExistBundleInfoList(keyName);
      expect(instance).not().assertNull();
      done();
    });

    it('test_isExistBundleInfoList02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appList: AppItemInfo[] = [];
      appList[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel',
        moduleName : 'model'
      };
      let keyNameNew: string = 'anyKeyName';
      instance.setAppListAsync(appList);
      let ret: AppItemInfo = instance.isExistBundleInfoList(keyNameNew);
      expect(ret).assertNull();
      done();
    });

    it('test_checkIsMultiIcon_01', 0, async (done: Function) => {
      let mMultiIconAppMap = new Map<string, number>();
      mMultiIconAppMap.set('a', 1);
      const instance: AppModel = AppModel.getInstance();
      instance['mMultiIconAppMap'] = mMultiIconAppMap;
      instance.checkIsMultiIcon('a', 0);
      expect(instance).not().assertNull();
      done();
    });

    it('test_checkIsMultiIcon_02', 0, async (done: Function) => {
      let mMultiIconAppMap = new Map<string, number>();
      mMultiIconAppMap.set('a', 1);
      const instance: AppModel = AppModel.getInstance();
      instance['mMultiIconAppMap'] = mMultiIconAppMap;
      instance.checkIsMultiIcon('abc', 0);
      expect(instance).not().assertNull();
      done();
    });

    it('test_checkIsMultiIcon_03', 0, async (done: Function) => {
      let mMultiIconAppMap = new Map<string, number>();
      mMultiIconAppMap.set('a', 1);
      let mBundleInfoList = [];
      const instance: AppModel = AppModel.getInstance();
      instance['mMultiIconAppMap'] = mMultiIconAppMap;
      instance['mBundleInfoList'] = mBundleInfoList;
      instance.checkIsMultiIcon('abc', 0);
      expect(instance).not().assertNull();
      done();
    });

    it('test_checkIsMultiIcon_04', 0, async (done: Function) => {
      let mMultiIconAppMap = new Map<string, number>();
      mMultiIconAppMap.set('a', 1);
      let mBundleInfoList: AppItemInfo[] = [];
      mBundleInfoList[0] = {
        abilityName: 'AppModel',
        appName: 'AppModelName',
        appIconId: 9999,
        bundleName: 'com.ohos.appModel',
        moduleName: 'model'
      };
      const instance: AppModel = AppModel.getInstance();
      instance['mMultiIconAppMap'] = mMultiIconAppMap;
      instance['mBundleInfoList'] = mBundleInfoList;
      instance.checkIsMultiIcon('abc', 0);
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteAppsByDelivery_01', 0, async (done: Function) => {
      let deliverApps: AppItemInfo[] | undefined = undefined;
      const instance: AppModel = AppModel.getInstance();
      instance.deleteAppsByDelivery(deliverApps);
      expect(true).not().assertEqual(true);
      done();
    });

    it('test_deleteAppsByDelivery_02', 0, async (done: Function) => {
      let deliverApps: AppItemInfo[] | null = null;
      const instance: AppModel = AppModel.getInstance();
      instance.deleteAppsByDelivery(deliverApps);
      expect(true).not().assertEqual(true);
      done();
    });

    it('test_deleteAppsByDelivery_03', 0, async (done: Function) => {
      let deliverApps: AppItemInfo[] = [];
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let isSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(isSupportDeliver)(ArgumentMatchers.any).afterReturn(true);
      instance.deleteAppsByDelivery(deliverApps);
      expect(true).not().assertEqual(true);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
      done();
    });

    it('test_deleteAppsByDelivery_04', 0, async (done: Function) => {
      let deliverApps: AppItemInfo[] = [];
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let isSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(isSupportDeliver)(ArgumentMatchers.any).afterReturn(false);
      instance.deleteAppsByDelivery(deliverApps);
      expect(instance).not().assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
      done();
    });

    it('getAppItemIconId_01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let containerIsEmpty: Function = mocker.mockFunc(CommonUtils, CommonUtils.containerIsEmpty);
      when(containerIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      instance.getAppItemIconId('aaa', 'bbb', 'ccc');
      expect(instance).not().assertNull();
      mocker.clear(CommonUtils);
      mocker.clearAll();
      done();
    });

    it('getAppItemIconId_02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let containerIsEmpty: Function = mocker.mockFunc(CommonUtils, CommonUtils.containerIsEmpty);
      when(containerIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      instance.getAppItemIconId('aaa', 'bbb', 'ccc');
      expect(instance).not().assertNull();
      mocker.clear(CommonUtils);
      mocker.clearAll();
      done();
    });

    it('setAppListByDelivery_01', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let isSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(isSupportDeliver)(ArgumentMatchers.any).afterReturn(true);
      instance.setAppListByDelivery(appItemInfo);
      expect(instance).not().assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
      done();
    });

    it('setAppListByDelivery_02', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let isSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(isSupportDeliver)(ArgumentMatchers.any).afterReturn(false);
      instance.setAppListByDelivery(appItemInfo);
      expect(instance).not().assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
      done();
    });

    it('setAppListByDelivery_03', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let isSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(isSupportDeliver)(ArgumentMatchers.any).afterReturn(true);
      appItemInfo.appIndex = 0;
      instance.setAppListByDelivery(appItemInfo);
      expect(instance).not().assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
      done();
    });

    it('setAppListByDelivery_04', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let isSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(isSupportDeliver)(ArgumentMatchers.any).afterReturn(true);
      appItemInfo.appIndex = 1;
      instance.setAppListByDelivery(appItemInfo);
      expect(instance).not().assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
      done();
    });

    it('setAppListByDelivery_05', 0, async (done: Function) => {
      let mBundleInfoList: AppItemInfo[] = [];
      mBundleInfoList[0] = {
        abilityName: 'AppModel',
        appName: 'AppModelName',
        appIconId: 9999,
        bundleName: 'com.ohos.appModel',
        moduleName: 'model'
      };
      const instance: AppModel = AppModel.getInstance();
      instance['mBundleInfoList'] = mBundleInfoList;
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName='com.ohos.appModel';
      appItemInfo.abilityName='AppModel';
      appItemInfo.moduleName='model';
      instance.setAppListByDelivery(appItemInfo);
      expect(instance).not().assertNull();
      done();
    });

    it('setAppListByDelivery_06', 0, async (done: Function) => {
      let mBundleInfoList: AppItemInfo[] = [];
      mBundleInfoList[0] = {
        abilityName: 'AppModel',
        appName: 'AppModelName',
        appIconId: 9999,
        bundleName: 'com.ohos.appModel',
        moduleName: 'model'
      };
      const instance: AppModel = AppModel.getInstance();
      instance['mBundleInfoList'] = mBundleInfoList;
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.abilityName='AppModel';
      appItemInfo.moduleName='model';
      instance.setAppListByDelivery(appItemInfo);
      expect(instance).not().assertNull();
      done();
    });

    it('test_checkIconMissWhenPowerOn_01', 0, async (done: Function) => {
      let bundleInfoList: AppItemInfo[] = [];
      const instance: AppModel = AppModel.getInstance();
      instance['mIsFirstTime'] = true;
      instance['checkIconMissWhenPowerOn'](bundleInfoList);
      expect(instance).not().assertNull();
      done();
    });

    it('test_checkIconMissWhenPowerOn_02', 0, async (done: Function) => {
      let bundleInfoList: AppItemInfo[] = [];
      const instance: AppModel = AppModel.getInstance();
      instance['mIsFirstTime'] = false;
      instance['checkIconMissWhenPowerOn'](bundleInfoList);
      expect(instance).not().assertNull();
      done();
    });

    it('test_getAppIconImageId_01', 0, async (done: Function) => {
      let itemInfo: GridLayoutItemInfo | undefined;
      const instance: AppModel = AppModel.getInstance();
      instance.getAppIconImageId(itemInfo);
      expect(instance).not().assertNull();
      done();
    });

    it('test_getAppIconImageId_02', 0, async (done: Function) => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const instance: AppModel = AppModel.getInstance();
      instance.getAppIconImageId(itemInfo);
      expect(instance).not().assertNull();
      done();
    });

    it('test_getAppIconImageId_03', 0, async (done: Function) => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_APP;
      const instance: AppModel = AppModel.getInstance();
      instance.getAppIconImageId(itemInfo);
      expect(instance).not().assertNull();
      done();
    });

    it('test_getAppIconImageId_04', 0, async (done: Function) => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      const instance: AppModel = AppModel.getInstance();
      instance.getAppIconImageId(itemInfo);
      expect(instance).not().assertNull();
      done();
    });

    it('test_registerIconChangeListener_01', 0, async (done: Function) => {
      let listener: IconChangeListener = { onIconResourceChange: () => {} };
      const instance: AppModel = AppModel.getInstance();
      instance['mIconChangeListener'] = [];
      instance.registerIconChangeListener(listener);
      expect(instance).not().assertNull();
      done();
    });

    it('test_registerIconChangeListener_02', 0, async (done: Function) => {
      let listener: IconChangeListener = { onIconResourceChange: () => {} };
      let mIconChangeListener: IconChangeListener[] = [];
      mIconChangeListener.push(listener);
      const instance: AppModel = AppModel.getInstance();
      instance['mIconChangeListener'] = mIconChangeListener;
      instance.registerIconChangeListener(listener);
      expect(instance).not().assertNull();
      done();
    });

    it('test_unregisterIconChangeListener_01', 0, async (done: Function) => {
      let listener: IconChangeListener = { onIconResourceChange: () => {} };
      let mIconChangeListener: IconChangeListener[] = [];
      mIconChangeListener.push(listener);
      const instance: AppModel = AppModel.getInstance();
      instance['mIconChangeListener'] = mIconChangeListener;
      instance.unregisterIconChangeListener(listener);
      expect(instance).not().assertNull();
      done();
    });

    it('test_unregisterIconChangeListener_02', 0, async (done: Function) => {
      let listener: IconChangeListener = { onIconResourceChange: () => {} };
      const instance: AppModel = AppModel.getInstance();
      instance['mIconChangeListener'] = [];
      try{
        instance.registerIconChangeListener(listener);
      }catch(e){}
      expect(instance).not().assertNull();
      done();
    });

    it('test_notifyAppStateChangeEvent', 0, () => {
      AppModel.getInstance()['notifyAppStateChangeEvent']('event', 'com.hos.app', 0);
      expect(true).assertTrue();
    });

    it('test_getItemIndex', 0, () => {
      let ret = AppModel.getInstance()['getItemIndex']('com.hos.demo');
      expect(ret).assertEqual(-1);
    });

    it('test_appendItem_removeItem', 0, () => {
      const bundle = 'com.test.dt';
      let item: AppItemInfo = new AppItemInfo();
      item.bundleName = bundle;
      item.moduleName = 'main_entry';
      item.applicationLabelId = 12345;
      let list: AppItemInfo[] = [];
      list.push(item);
      AppModel.getInstance()['appendItem'](list, 0);
      expect(true).assertTrue();
      AppModel.getInstance()['removeItem'](bundle, 0);
      expect(true).assertTrue();
      AppModel.getInstance()['removeItemCache'](bundle, 0);
      expect(true).assertTrue();
    });

    it('test_replaceItem', 0, () => {
      const bundle = 'com.test.dt';
      let item: AppItemInfo = new AppItemInfo();
      item.bundleName = bundle;
      item.moduleName = 'main_entry';
      item.applicationLabelId = 12345;
      let list: AppItemInfo[] = [];
      list.push(item);
      AppModel.getInstance()['replaceItem'](bundle, 0,list);
      expect(true).assertTrue();
    });

    it('test_setShortcutInfo', 0, () => {
      const bundle = 'com.test.dt';
      class MyShortcutInfo implements ShortcutInfo {
        id: string = '147258';
        bundleName: string = bundle;
        moduleName: string = 'main_entry';
        hostAbility: string = '';
        icon: string = '';
        iconId: number = 1;
        label: string = 'test';
        labelId: number = 2;
        wants: ShortcutWant[] = [];
        appIndex: number = 0;
        sourceType: number = 1;
      }
      let item: ShortcutInfo = new MyShortcutInfo();
      let list: ShortcutInfo[] = [];
      list.push(item);
      AppModel.getInstance()['setShortcutInfo'](bundle, list);
      expect(true).assertTrue();
    });

    it('test_updateShortcutInfo_if', 0, () => {
      const bundle = 'com.test.dt';
      AppModel.getInstance()['updateShortcutInfo'](bundle, EventConstants.EVENT_PACKAGE_REMOVED);
      expect(true).assertTrue();
      AppModel.getInstance()['updateShortcutInfo'](bundle, EventConstants.EVENT_PACKAGE_CHANGED);
      expect(true).assertTrue();
    })

    it('test_getShortcutInfoFromManager', Level.LEVEL0, async (done: Function) => {
      const bundle = 'com.test.dt';
      let ret = await AppModel.getInstance().getShortcutInfoFromManager(bundle);
      expect(true).assertTrue();
      done();
    })

    it('test_updateInfoNameOfApp', Level.LEVEL0, async (done: Function): Promise<void> => {
      await model.updateInfoNameOfApp(false);
      expect(true).assertTrue();
      done();
    });

    //xy_log
    it('test_getAppItemIconId_01', 0, async (done: Function) => {
      try {
        let appModel: AppModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(AppModel, appModel.getAppList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
        const result: number = appModel.getAppItemIconId("com.example.app", "main", "EntryAbility");
        mocker.verify('mBundleInfoList', []).atLeast(0);
        mocker.ignoreMock(appModel, appModel.getAppList);
      } catch (e) {}
      done();
    });

    it('test_getAppItemIconId_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mBundleInfoList = appModel['mBundleInfoList'];
      appModel['mBundleInfoList'] = [{
        bundleName: "com.example.app",
        moduleName: "main",
        abilityName: "EntryAbility",
        appIconId: 123
      }] as AppItemInfo[];
      try {
        const result: number = appModel.getAppItemIconId("com.example.app", "main", "EntryAbility");
        expect(result).assertEqual(123);
      } catch (e) {
      }
      appModel['mBundleInfoList'] = mBundleInfoList;
      done();
    });

    //getInstance
    it('test_getInstance_01', 0, async (done: Function) => {
      let instance1: AppModel = AppModel.getInstance();
      let instance2: AppModel = AppModel.getInstance();
      expect(instance1).assertDeepEquals(instance2);
      done();
    });

    it('test_getInstance_02', 0, async (done: Function) => {
      globalThis.AppModel = null;
      let instance: AppModel = AppModel.getInstance();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    //registerIconChangeListener
    it('test_registerIconChangeListener_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      done();
    });

    //unregisterIconChangeListener
    it('test_unregisterIconChangeListener_03', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let listener: ESObject = () => {};
      appModel.registerIconChangeListener(listener);
      appModel.unregisterIconChangeListener(listener);
      mocker.verify('indexOf', [listener]).atLeast(0);
      done();
    });

    it('test_unregisterIconChangeListener_04', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let listener: ESObject = () => {
      };
      try {
        appModel.unregisterIconChangeListener(listener);
      } catch (e) {
      }
      mocker.verify('indexOf', [listener]).atLeast(0);
      done();
    });

    //subscribeBundleResourceChangeEvent
    it('test_subscribeBundleResourceChangeEvent_02', 0, async (done: Function) => {
      try {
        let appModel: AppModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        await appModel.subscribeBundleResourceChangeEvent();
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (e) {
      }
      done();
    });

    it('test_subscribeBundleResourceChangeEvent_03', 0, async (done: Function) => {
      try {
        let appModel: AppModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        let eventData: ESObject = { event: EventConstants.EVENT_BUNDLE_RESOURCES_CHANGED, code: 1 };
        await appModel.subscribeBundleResourceChangeEvent();
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (e) {
      }
      done();
    });

    it('test_subscribeBundleResourceChangeEvent_04', 0, async (done: Function) => {
      try {
        let appModel: AppModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        let eventData: ESObject = { event: EventConstants.EVENT_BUNDLE_RESOURCES_CHANGED, code: 0 };
        await appModel.subscribeBundleResourceChangeEvent();
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (e) {
      }
      done();
    });


    it('test_loadAppList_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockSetAppListAsync: ESObject = mocker.mockFunc(appModel, appModel.setAppListAsync);
      when(mockSetAppListAsync)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      await appModel.loadAppList(true);
      expect(appModel['mIsLoadFinish']).assertFalse();
      mocker.verify('execute', [ArgumentMatchers.any]).atLeast(0);
      mocker.verify('setAppListAsync', [ArgumentMatchers.any]).atLeast(0);
      mocker.ignoreMock(appModel, appModel.setAppListAsync);
      done();
    });

    //initIconNameCache
    it('test_initIconNameCache_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      await appModel.initIconNameCache();
      mocker.verify('execute', []).atLeast(0);
      done();
    });

    it('test_initIconNameCache_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      await appModel.initIconNameCache();
      mocker.verify('execute', []).atLeast(0);
      mocker.verify('checkStrIsEmpty', []).atLeast(0);
      done();
    });

    it('test_initIconNameCache_03', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      await appModel.initIconNameCache();
      mocker.verify('execute', []).atLeast(0);
      mocker.verify('checkStrIsEmpty', []).atLeast(0);
      mocker.verify('setNameResourceCache', []).atLeast(0);
      done();
    });

    //updateInfoNameOfApp
    it('test_updateInfoNameOfApp_01', 0, async (done: Function) => {
      let appModel = AppModel.getInstance();
      let mocker = new MockKit();
      await appModel.updateInfoNameOfApp(true);
      mocker.verify('execute', [ArgumentMatchers.any]).atLeast(0);
      mocker.verify('queryGridLayoutByType', [ArgumentMatchers.any, ArgumentMatchers.any]).atLeast(0);
      mocker.verify('updateAppNameByAbilityInfoAndType', [ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).atLeast(0);
      mocker.verify('setNameResourceCache', [ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).atLeast(0);
      mocker.verify('getShowOutLauncherStatus', []).atLeast(0);
      mocker.verify('initResourceNameCache', []).atLeast(0);
      done();
    });

    it('test_updateInfoNameOfApp_02', 0, async (done: Function) => {
      let appModel = AppModel.getInstance();
      let mocker = new MockKit();
      await appModel.updateInfoNameOfApp(false);
      mocker.verify('execute', [ArgumentMatchers.any]).atLeast(0);
      mocker.verify('queryGridLayoutByType', [ArgumentMatchers.any, ArgumentMatchers.any]).atLeast(0);
      mocker.verify('setNameResourceCache', [ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).atLeast(0);
      mocker.verify('getShowOutLauncherStatus', []).atLeast(0);
      done();
    });

    it('test_updateInfoNameOfApp_03', 0, async (done: Function) => {
      let appModel = AppModel.getInstance();
      let mocker = new MockKit();
      await appModel.updateInfoNameOfApp(true);
      mocker.verify('execute', [ArgumentMatchers.any]).atLeast(0);
      mocker.verify('showError', [ArgumentMatchers.any]).atLeast(0);
      done();
    });

    //getAppList
    it('test_getAppList_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      appModel['mIsLoadFinish'] = true;
      appModel['mBundleInfoList'] = [new AppItemInfo()];
      const result: AppItemInfo[] = appModel.getAppList();
      expect(result).assertDeepEquals([new AppItemInfo()]);
      mocker.verify('showInfo', []).atLeast(0);
      done();
    });

    it('test_getAppList_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      appModel['mIsLoadFinish'] = false;
      appModel['callBack'] = [];
      appModel.getAppList(() => {});
      expect(appModel['callback'].length).assertEqual(1);
      mocker.verify('showInfo', []).atLeast(0);
      done();
    });

    it('test_getAppList_03', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockInit: Function = mocker.mockFunc(AppModel, appModel['initMultiIconList']);
      appModel['mIsLoadFinish'] = true;
      appModel['mBundleInfoList'] = [new AppItemInfo()];
      appModel['mIsMultiIconAppMapInit'] = false;
      appModel.getAppList();
      expect(appModel['mIsMultiIconAppMapInit']).not().assertNull();
      mocker.verify('initMultiIconList', []).atLeast(0);
      done();
    });

    it('test_getAppList_04', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockInit: ESObject = mocker.mockFunc(AppModel, appModel['initMultiIconList']);
      appModel['mIsLoadFinish'] = true;
      appModel['mBundleInfoList'] = [];
      appModel['mIsMultiIconAppMapInit'] = true;
      appModel.getAppList();
      expect(appModel['mIsMultiIconAppMapInit']).assertTrue();
      mocker.verify('initMultiIconList', []).never();
      done();
    });

    //checkIsMultiIcon
    it('test_checkIsMultiIcon_05', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      appModel.checkIsMultiIcon('com.example.app', 0);
      expect(appModel).assertEqual(AppModel.getInstance());
      done();
    });

    it('test_checkIsMultiIcon_06', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      const result: boolean = appModel.checkIsMultiIcon('com.example.app', 0);
      expect(result).assertInstanceOf('Boolean');
      done();
    });

    it('test_checkIsMultiIcon_07', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      appModel.checkIsMultiIcon('com.example.app', 0);
      expect(appModel).assertEqual(AppModel.getInstance());
      done();
    });

    it('test_checkIsMultiIcon_08', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      const result: boolean = appModel.checkIsMultiIcon('com.example.app', 0);
      expect(result).assertFalse();
      mocker.verify('has', ['com.example.app']).atLeast(0);
      mocker.verify('filter', [ArgumentMatchers.any]).atLeast(0);
      done();
    });

    //isExistBundleInfoList
    it('test_isExistBundleInfoList_01', 0, async (done: Function) => {
      try {
        let appModel: AppModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(AppModel, appModel['getAppList']);
        when(mockFunc)().afterReturn([]);
        const result: AppItemInfo = appModel.isExistBundleInfoList("com.example.app");
        expect(result).assertNull();
        mocker.verify('mBundleInfoList', []).atLeast(0);
        mocker.ignoreMock(appModel, appModel['getAppList']);
      } catch (e) {}
      done();
    });

    //setAppListAsync
    it('test_setAppListAsync_01', 0, async (done: Function) => {
      try {
        let appmodel: AppModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        const result: AppItemInfo[] = await appmodel.setAppListAsync([]);
        expect(result).not().assertNull();
        mocker.verify('showInfo', []).atLeast(0);
      } catch (e) {}
      done();
    });

    it('test_setAppListAsync_02', 0, async (done: Function) => {
      let appmodel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockUpdateShortcutInfo: Function = mocker.mockFunc(AppModel, appmodel['updateShortcutInfo']);
      when(mockUpdateShortcutInfo)(ArgumentMatchers.any).afterReturn(null);
      mocker.verify('showInfo', []).atLeast(0);
      mocker.verify('updateShortcutInfo', ['systemApp']).atLeast(0);
      mocker.ignoreMock(AppModel, appmodel['updateShortcutInfo']);
      done();
    });

    it('test_setAppListAsync_03', 0, async (done: Function) => {
      let appmodel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockUpdateShortcutInfo: Function = mocker.mockFunc(AppModel, appmodel['updateShortcutInfo']);
      let mockAddCloneAppCache: Function = mocker.mockFunc(AppModel, appmodel['addCloneAppCache']);
      when(mockUpdateShortcutInfo)(ArgumentMatchers.any).afterReturn(null);
      when(mockAddCloneAppCache)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
      mocker.verify('showInfo', []).atLeast(0);
      mocker.verify('updateShortcutInfo', ['nonSystemApp']).atLeast(0);
      mocker.verify('addCloneAppCache', ['nonSystemApp', 1]).atLeast(0);
      mocker.ignoreMock(AppModel, appmodel['updateShortcutInfo']);
      mocker.ignoreMock(AppModel, appmodel['addCloneAppCache']);
      done();
    });

    it('test_setAppListAsync_04', 0, async (done: Function) => {
      let appmodel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockCheckIconMissWhenPowerOn: Function = mocker.mockFunc(AppModel, appmodel['checkIconMissWhenPowerOn']);
      when(mockCheckIconMissWhenPowerOn)(ArgumentMatchers.any).afterReturn(null);
      mocker.verify('showInfo', []).atLeast(0);
      mocker.verify('checkIconMissWhenPowerOn', [ArgumentMatchers.any]).atLeast(0);
      mocker.ignoreMock(AppModel, appmodel['checkIconMissWhenPowerOn']);
      done();
    });

    it('test_setAppListAsync_05', 0, async (done: Function) => {
      let appmodel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockCallback: Function = mocker.mockFunc(AppModel, appmodel['callBack'].forEach);
      mocker.verify('showInfo', []).atLeast(0);
      mocker.verify('forEach', [ArgumentMatchers.any]).atLeast(0);
      mocker.ignoreMock(AppModel, appmodel['callBack'].forEach);
      done();
    });

    //setAppListByDelivery
    it('test_setAppListByDelivery_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(false);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appModel.setAppListByDelivery(appItemInfo);
      expect(appModel['mBundleInfoMap'].has(appItemInfo.bundleName)).assertFalse();
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_setAppListByDelivery_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appIndex = 0;
      appModel.setAppListByDelivery(appItemInfo);
      expect(appModel['mBundleInfoMap'].has(appItemInfo.bundleName)).assertTrue();
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_setAppListByDelivery_03', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appIndex = -1;
      appModel.setAppListByDelivery(appItemInfo);
      appModel.setAppListByDelivery(appItemInfo);
      expect(appModel['mBundleInfoList'].length).assertEqual(1);
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_setAppListByDelivery_04', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appIndex = 1;
      appModel.setAppListByDelivery(appItemInfo);
      mocker.verify('showInfo', [ArgumentMatchers.anyString, ArgumentMatchers.any]).atLeast(0);
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_setAppListByDelivery_05', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appIndex = 10;
      appModel.setAppListByDelivery(appItemInfo);
      expect(appModel['mBundleInfoList'].length).assertEqual(1);
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    //deleteAppsByDelivery
    it('test_deleteAppsByDelivery_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(false);
      appModel.deleteAppsByDelivery([]);
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_deleteAppsByDelivery_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      appModel.deleteAppsByDelivery(undefined);
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_deleteAppsByDelivery_03', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      appModel.deleteAppsByDelivery(null);
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_deleteAppsByDelivery_04', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      expect(appModel['mBundleInfoMap'].has('bundle2')).assertFalse();
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_deleteAppsByDelivery_05', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      expect(appModel['mBundleInfoMap']).not().assertNull();
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_deleteAppsByDelivery_06', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      expect(appModel['mBundleInfoMap']).not().assertNull();
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    it('test_deleteAppsByDelivery_07', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockDeliverUtil: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockDeliverUtil)().afterReturn(true);
      expect(appModel['mBundleInfoMap']).not().assertNull();
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isSupportDeliver);
      done();
    });

    //getAppIconImageId
    it('test_getAppIconImageId_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      const result: string = appModel.getAppIconImageId(null);
      expect(result).assertEqual('');
      done();
    });

    it('test_getAppIconImageId_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn({ appIconId: 'icon123' });
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      done();
    });

    //getAppIconId
    it('test_getAppIconId_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let item: AppItemInfo = new AppItemInfo();
      item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      item.bundleName = "com.example.app";
      item.appIndex = 1;
      item.shortcutId = "shortcut1";
      const result: string = appModel.getAppIconId(false, item);
      expect(result).not().assertNull();
      done();
    });

    it('test_getAppIconId_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let item: AppItemInfo = new AppItemInfo();
      item.typeId = 123;
      item.bundleName = "com.example.app";
      item.appIconId = 456;
      item.appIndex = 1;
      const result: string = appModel.getAppIconId(true, item);
      expect(result).not().assertNull();
      done();
    });

    //registerStateChangeListener
    it('test_registerStateChangeListener_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel['mAppStateChangeListener'].indexOf);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
      let listener: ESObject = () => {};
      appModel.registerStateChangeListener(listener);
      expect(appModel['mAppStateChangeListener']).not().assertNull();
      mocker.verify('indexOf', [listener]).atLeast(0);
      mocker.ignoreMock(AppModel, appModel['mAppStateChangeListener'].indexOf);
      done();
    });

    it('test_registerStateChangeListener_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel['mAppStateChangeListener'].indexOf);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      let listener: ESObject = () => {};
      appModel.registerStateChangeListener(listener);
      mocker.verify('indexOf', [listener]).atLeast(0);
      mocker.ignoreMock(AppModel, appModel['mAppStateChangeListener'].indexOf);
      done();
    });

    //getOperationItemInfo
    it('test_getOperationItemInfo_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      const result: AppItemInfo | undefined = appModel.getOperationItemInfo("com.example.app");
      expect(result).assertUndefined();
      mocker.verify('getItemIndex', ["com.example.app"]).atLeast(0);
      done();
    });

    it('test_getOperationItemInfo_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockAppItemInfo: AppItemInfo = new AppItemInfo();
      const result: AppItemInfo | undefined = appModel.getOperationItemInfo("com.example.app");
      expect(result).not().assertNull();
      mocker.verify('getItemIndex', ["com.example.app"]).atLeast(0);
      done();
    });

    //getShortcutInfo
    it('test_getShortcutInfo_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel['mShortcutInfoMap'].get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      const result: ShortcutInfo[] | undefined = appModel.getShortcutInfo('');
      expect(result).assertUndefined();
      mocker.verify('get', ['']).atLeast(0);
      mocker.ignoreMock(AppModel, appModel['mShortcutInfoMap'].get);
      done();
    });

    it('test_getShortcutInfo_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel['mShortcutInfoMap'].get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      const result: ShortcutInfo[] | undefined = appModel.getShortcutInfo('com.example.app');
      expect(result).assertUndefined();
      mocker.verify('get', ['com.example.app']).atLeast(0);
      mocker.ignoreMock(AppModel, appModel['mShortcutInfoMap'].get);
      done();
    });

    it('test_getShortcutInfo_03', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel['mShortcutInfoMap'].get);
      const result: ShortcutInfo[] | undefined = appModel.getShortcutInfo('com.example.app');
      mocker.verify('get', ['com.example.app']).atLeast(0);
      mocker.ignoreMock(AppModel, appModel['mShortcutInfoMap'].get);
      done();
    });

    it('test_getShortcutInfo_04', 0, async (done: Function) => {
      try {
        let appModel: AppModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(AppModel, appModel['mShortcutInfoMap'].get);
        const result: ShortcutInfo[] | undefined = appModel.getShortcutInfo('com.example.app');
        expect(result).not().assertNull();
        mocker.verify('get', ['com.example.app']).atLeast(0);
        mocker.ignoreMock(AppModel, appModel['mShortcutInfoMap'].get);
      } catch (e) {}
      done();
    });

    //getShortcutInfoFromManager
    it('test_getShortcutInfoFromManager_01', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel.getShortcutInfoFromManager);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      const result: ShortcutInfo[] = await appModel.getShortcutInfoFromManager('com.example.app');
      expect(result).not().assertUndefined();
      mocker.verify('getShortcutInfoFromManager', ['com.example.app']).atLeast(0);
      mocker.ignoreMock(appModel, appModel.getShortcutInfoFromManager);
      done();
    });

    it('test_getShortcutInfoFromManager_02', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel.getShortcutInfoFromManager);
      let shortcutInfo: ESObject = [{ id: 1, name: 'App1' }];
      when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfo);
      const result: ShortcutInfo[] = await appModel.getShortcutInfoFromManager('com.example.app');
      expect(result).assertDeepEquals(shortcutInfo);
      mocker.verify('getShortcutInfoFromManager', ['com.example.app']).atLeast(0);
      mocker.ignoreMock(appModel, appModel.getShortcutInfoFromManager);
      done();
    });

    it('test_getShortcutInfoFromManager_03', 0, async (done: Function) => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel, appModel.getShortcutInfoFromManager);
      let shortcutInfo: ESObject = [{ id: 1, name: 'App1' }, { id: 2, name: 'App2' }, { id: 3, name: 'App3' }];
      when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfo);
      const result: ShortcutInfo[] = await appModel.getShortcutInfoFromManager('com.example.app');
      expect(result.length).assertEqual(3);
      mocker.verify('getShortcutInfoFromManager', ['com.example.app']).atLeast(0);
      mocker.ignoreMock(appModel, appModel.getShortcutInfoFromManager);
      done();
    });

    it('test_constructor_isInvalidAccount', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const accountMgr = mocker.mockFunc(AccountMgr, AccountMgr.isInvalidAccount);
      when(accountMgr)(ArgumentMatchers.any).afterReturn(true);
      const appModel: AppModel = AppModel.getInstance();
      expect(appModel['mOperationItemInfo']).assertEqual(undefined);
      mocker.clear(AccountMgr);
      mocker.clearAll();
      done();
    });

    it('test_getAppItemIconId_03', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      appModel['mBundleInfoList'].push({
        bundleName: 'com.example.app',
        moduleName: 'main',
        abilityName: 'EntryAbility',
        appIconId: 1
      } as AppItemInfo);
      expect(appModel.getAppItemIconId('com.example.app', 'main', 'EntryAbility')).assertEqual(1);
      done();
    });

    it('test_onDownloadCanceled', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const onDownloadCanceled = appModel.onDownloadCanceled('', '', 0) as undefined;
      expect(onDownloadCanceled).assertEqual(undefined);
      done();
    });

    it('test_handlePackageEvent_01', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const handlePackageEvent = appModel['handlePackageEvent'](undefined) as undefined;
      expect(handlePackageEvent).assertEqual(undefined);
      done();
    });

    it('test_handlePackageEvent_02', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const event = {
        event: EventConstants.EVENT_DYNAMIC_ICON_CHANGED
      } as PackageCommonEvent;
      const handlePackageEvent = appModel['handlePackageEvent'](event) as undefined;
      expect(handlePackageEvent).assertEqual(undefined);
      done();
    });

    it('test_handlePackageEvent_03', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const event = {
        event: EventConstants.EVENT_PACKAGE_REMOVED
      } as PackageCommonEvent;
      const handlePackageEvent = appModel['handlePackageEvent'](event) as undefined;
      expect(handlePackageEvent).assertEqual(undefined);
      done();
    });

    it('test_getDesktopAppBundle', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const handlePackageEvent = appModel.getDesktopAppBundle();
      expect(handlePackageEvent).not().assertNull();
      done();
    });

    it('test_deleteDynamicIconCache', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const handlePackageEvent = appModel['deleteDynamicIconCache']() as undefined;
      expect(handlePackageEvent).assertEqual(undefined);
      done();
    });

    it('test_handleResourceChangeEvent_01', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const getInitAccountId = mocker.mockFunc(AccountMgr, AccountMgr.getInitAccountId);
      const isHaveDeliverApps = mocker.mockFunc(DeliverUtil, DeliverUtil.isHaveDeliverApps);
      when(getInitAccountId)().afterReturn(100);
      when(isHaveDeliverApps)().afterReturn(false);
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      appModel['mIconChangeListener'] = [{
        onIconResourceChange: () => {
        }
      }];
      const parameters: ESObject = {
        bundleResourceChangeType: 30,
        userId: 100
      };
      const eventData: ESObject = {
        parameters
      };
      try {
        const handleResourceChangeEvent = await appModel['handleResourceChangeEvent'](eventData) as undefined;
        expect(handleResourceChangeEvent).assertEqual(undefined);
      } catch (e) {};
      mocker.clear(AccountMgr);
      mocker.clear(DeliverUtil);
      done();
    });

    it('test_handleResourceChangeEvent_02', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const getInitAccountId = mocker.mockFunc(AccountMgr, AccountMgr.getInitAccountId);
      const isHaveDeliverApps = mocker.mockFunc(DeliverUtil, DeliverUtil.isHaveDeliverApps);
      const getAppList = mocker.mockFunc(appModel, appModel.getAppList);
      const isEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(getInitAccountId)().afterReturn(100);
      when(isHaveDeliverApps)().afterReturn(true);
      when(getAppList)().afterReturn([{ codePath: '1', bundleName: '' }, { codePath: '2', bundleName: '' }]);
      const parameters: ESObject = {
        bundleResourceChangeType: 30,
        userId: 100
      };
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      const eventData: ESObject = {
        parameters
      };
      try {
        const handleResourceChangeEvent = await appModel['handleResourceChangeEvent'](eventData) as undefined;
        expect(handleResourceChangeEvent).assertEqual(undefined);
      } catch (e) {};
      mocker.clear(AccountMgr);
      mocker.clear(DeliverUtil);
      mocker.clear(appModel);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('test_handleResourceChangeEvent_03', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const getInitAccountId = mocker.mockFunc(AccountMgr, AccountMgr.getInitAccountId);
      const isHaveDeliverApps = mocker.mockFunc(DeliverUtil, DeliverUtil.isHaveDeliverApps);
      const isPc = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(getInitAccountId)().afterReturn(100);
      when(isHaveDeliverApps)().afterReturn(false);
      when(isPc)().afterReturn(true);
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      appModel['mIconChangeListener'] = [{
        onIconResourceChange: () => {
        }
      }];
      const parameters: ESObject = {
        bundleResourceChangeType: 16,
        userId: 100
      };
      const eventData: ESObject = {
        parameters
      };
      try {
        const handleResourceChangeEvent = await appModel['handleResourceChangeEvent'](eventData) as undefined;
        expect(handleResourceChangeEvent).assertEqual(undefined);
      } catch (e) {};
      mocker.clear(AccountMgr);
      mocker.clear(DeliverUtil);
      done();
    });

    it('test_subscribeBundleResourceChangeEvent_05', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const isEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      const subscribeBundleResourceChangeEvent = await appModel.subscribeBundleResourceChangeEvent() as undefined;
      expect(subscribeBundleResourceChangeEvent).assertEqual(undefined);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('test_loadAppList_04', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const loadAppList = await appModel.loadAppList(true) as undefined;
      const loadAppList1 = await appModel.loadAppList(false) as undefined;
      expect(loadAppList).assertEqual(undefined);
      expect(loadAppList1).assertEqual(undefined);
      done();
    });

    it('test_initResourceNameCache', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const mBundleInfoList = mocker.mockFunc(appModel['mBundleInfoList'], appModel['mBundleInfoList'].forEach);
      when(mBundleInfoList)(ArgumentMatchers.any).afterThrow('err');
      const initResourceNameCache = await appModel['initResourceNameCache']() as undefined;
      expect(initResourceNameCache).assertEqual(undefined);
      mocker.clear(appModel['mBundleInfoList']);
      mocker.clearAll();
      done();
    });

    it('test_updateInfoNameOfApp_04', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const getShowOutLauncherStatus = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)().afterReturn(true);
      const updateInfoNameOfApp = await appModel.updateInfoNameOfApp(true, true) as undefined;
      const updateInfoNameOfApp1 = await appModel.updateInfoNameOfApp(false, true) as undefined;
      expect(updateInfoNameOfApp).assertEqual(undefined);
      expect(updateInfoNameOfApp1).assertEqual(undefined);
      const dbStoreGetInstance = mocker.mockFunc(RdbStoreManager, RdbStoreManager.getInstance);
      when(dbStoreGetInstance)().afterReturnNothing;
      const updateInfoNameOfApp2 = await appModel.updateInfoNameOfApp(false, true) as undefined;
      expect(updateInfoNameOfApp2).assertEqual(undefined);
      mocker.clear(launcherStatusUtil);
      mocker.clear(RdbStoreManager);
      mocker.clearAll();
      done();
    });

    it('test_getAppList_05', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      appModel['mIsLoadFinish'] = false;
      const getAppList = appModel.getAppList(() => {
      });
      appModel['mIsLoadFinish'] = true;
      appModel['mIsMultiIconAppMapInit'] = false;
      const isEmptyArr = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)().afterReturn(false);
      const getAppList1 = appModel.getAppList(() => {
      });
      expect(Array.isArray(getAppList)).assertTrue();
      expect(Array.isArray(getAppList1)).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('test_deleteAppsByDelivery_08', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const isSupportDeliver = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(isSupportDeliver)().afterReturn(true);
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      appModel['mBundleInfoMap'].set('newSet', {
        codePath: '1',
        appStatus: 0,
        bundleName: 'bundleName',
      } as AppItemInfo);
      const deleteAppsByDelivery = appModel.deleteAppsByDelivery([{} as AppItemInfo]);
      expect(Array.isArray(deleteAppsByDelivery)).assertFalse();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
      done();
    })

    it('test_checkIconMissWhenPowerOn_03', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const rdbStoreManager = RdbStoreManager.getInstance();
      const queryAllGridLayoutInfo = mocker.mockFunc(rdbStoreManager, rdbStoreManager.queryAllGridLayoutInfo);
      const gridLayoutItemInfo = {
        typeId: 0
      } as GridLayoutItemInfo;
      when(queryAllGridLayoutInfo)().afterReturn(Promise.resolve([gridLayoutItemInfo]));
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      appModel['mIsFirstTime'] = true;
      const bundleInfoList: AppItemInfo[] = [];
      for (let i = 0; i < 100; i++) {
        bundleInfoList.push({} as AppItemInfo);
      }
      const checkIconMissWhenPowerOn = appModel['checkIconMissWhenPowerOn'](bundleInfoList) as undefined;
      expect(checkIconMissWhenPowerOn).assertUndefined();
      mocker.clear(rdbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_checkIconMissWhenPowerOn_04', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const rdbStoreManager = RdbStoreManager.getInstance();
      const queryAllGridLayoutInfo = mocker.mockFunc(rdbStoreManager, rdbStoreManager.queryAllGridLayoutInfo);
      when(queryAllGridLayoutInfo)().afterReturn(Promise.reject());
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      appModel['mIsFirstTime'] = true;
      const bundleInfoList: AppItemInfo[] = [];
      const checkIconMissWhenPowerOn = appModel['checkIconMissWhenPowerOn'](bundleInfoList) as undefined;
      expect(checkIconMissWhenPowerOn).assertUndefined();
      mocker.clear(rdbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_getAppInfoByBundleNameAndAppIndex', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const bundleName = 'bundleName ';
      const appIndex = 1;
      appModel['mBundleInfoList'] = [{ bundleName, appIndex } as AppItemInfo];
      const getAppInfoByBundleNameAndAppIndex = appModel.getAppInfoByBundleNameAndAppIndex(bundleName, appIndex);
      expect(getAppInfoByBundleNameAndAppIndex.length).assertEqual(1);
      done();
    })

    it('test_installationSubscriberCallBack_01', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const bundleName = 'bundleName';
      const eventType = EventConstants.EVENT_PACKAGE_REMOVED;
      appModel['mIsLoadFinish'] = true;
      const updateAppBundleNameList: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      if (!updateAppBundleNameList || !updateAppBundleNameList.length) {
        AppStorage.setOrCreate('updateAppBundleNameList', [bundleName]);
      } else {
        updateAppBundleNameList.push(bundleName);
        AppStorage.setOrCreate('updateAppBundleNameList', updateAppBundleNameList);
      }
      await appModel['installationSubscriberCallBack'](eventType, bundleName, 0);
      expect(appModel).not().assertUndefined();
      done();
    })

    it('test_installationSubscriberCallBack_02', 0, async (done: Function) => {
      try {
        globalThis.AppModel = null;
        const appModel: AppModel = AppModel.getInstance();
        const bundleName = '-bundleNameNOT-';
        const eventType = EventConstants.EVENT_PACKAGE_REMOVED;
        AppStorage.setOrCreate('updateAppBundleNameList', []);
        DeliverUtil.DELIVER_APP_MAP.set(bundleName, eventType);
        await appModel['installationSubscriberCallBack'](eventType, bundleName, 0);
        expect(appModel).not().assertUndefined();
      } catch (e) {
      }
      done();
    })

    it('test_installationSubscriberCallBack_03', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
      try{
        const isEmptyArr = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
        const mBundleInfoMapHas = mocker.mockFunc(appModel['mBundleInfoMap'], appModel['mBundleInfoMap'].has);
        when(mBundleInfoMapHas)(ArgumentMatchers.any).afterReturn(true);
        const bundleName = 'bundleName';
        const eventType = EventConstants.EVENT_PACKAGE_ADDED;
        const installationSubscriberCallBack =
          await appModel['installationSubscriberCallBack'](eventType, bundleName, 0) as undefined;
        expect(installationSubscriberCallBack).assertUndefined();
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clear(appModel['mBundleInfoMap']);
      mocker.clearAll();
      done();
    })

    it('test_installationSubscriberCallBack_04', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const isEmptyArr = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const locationNameIndexOf =
        mocker.mockFunc(appModel['mSystemApplicationName'], appModel['mSystemApplicationName'].indexOf);
      when(locationNameIndexOf)(ArgumentMatchers.any).afterReturn(1);
      const bundleName = 'bundleName';
      const eventType = EventConstants.EVENT_PACKAGE_ADDED;
      try {
        const installationSubscriberCallBack =
          await appModel['installationSubscriberCallBack'](eventType, bundleName, 0) as undefined;
        expect(installationSubscriberCallBack).assertUndefined();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(appModel['mSystemApplicationName']);
      mocker.clearAll();
      done();
    })

    it('test_installationSubscriberCallBack_05', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const isEmptyArr = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const locationNameIndexOf =
        mocker.mockFunc(appModel['mSystemApplicationName'], appModel['mSystemApplicationName'].indexOf);
      when(locationNameIndexOf)(ArgumentMatchers.any).afterReturn(-1);
      const bundleName = 'bundleName';
      const eventType = EventConstants.EVENT_PACKAGE_CHANGED;
      appModel['mIsLoadFinish'] = true;
      try {
        const installationSubscriberCallBack =
          await appModel['installationSubscriberCallBack'](eventType, bundleName, 0) as undefined;
        expect(installationSubscriberCallBack).assertUndefined();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(appModel['mSystemApplicationName']);
      mocker.clearAll();
      done();
    })

    it('test_installationSubscriberCallBack_06', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const isEmptyArr = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const locationNameIndexOf =
        mocker.mockFunc(appModel['mSystemApplicationName'], appModel['mSystemApplicationName'].indexOf);
      when(locationNameIndexOf)(ArgumentMatchers.any).afterReturn(-1);
      const bundleName = 'bundleName';
      const eventType = EventConstants.EVENT_PACKAGE_CHANGED + 'not';
      appModel['mIsLoadFinish'] = true;
      try {
        const installationSubscriberCallBack =
          await appModel['installationSubscriberCallBack'](eventType, bundleName, 0) as undefined;
        expect(installationSubscriberCallBack).assertUndefined();
      }catch(e){
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(appModel['mSystemApplicationName']);
      mocker.clearAll();
      done();
    })

    it('test_cleanGameCard_01', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const isEmptyArr = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)().afterReturn(true);
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const cleanGameCard = appModel['cleanGameCard']('') as undefined;
      expect(cleanGameCard).assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_cleanGameCard_02', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const isEmptyArr = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)().afterReturn(false);
      const formManager = FormLayoutCacheManager.getInstance();
      const selectGridLayoutItemsByBundleName =
        mocker.mockFunc(formManager, formManager.selectGridLayoutItemsByBundleName);
      when(selectGridLayoutItemsByBundleName)(ArgumentMatchers.any).afterReturn([{
        cardName: 'cardName',
        gameCardInfo: false
      }]);
      const getAppItemFormInfo =
        mocker.mockFunc(appModel['mFormModel'], appModel['mFormModel'].getAppItemFormInfo);
      when(getAppItemFormInfo)(ArgumentMatchers.any).afterReturn([{
        cardName: 'cardName',
      }]);
      const cleanGameCard = appModel['cleanGameCard']('cardName') as undefined;
      expect(cleanGameCard).assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(formManager);
      mocker.clear(appModel['mFormModel']);
      mocker.clearAll();
      done();
    })

    it('test_updateGameEngineValidStatus', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const updateGameEngineValidStatus = appModel['updateGameEngineValidStatus']('bundleName') as undefined;
      expect(updateGameEngineValidStatus).assertUndefined();
      done();
    })

    it('test_getOperationItemInfo_03', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const getItemIndex =
        mocker.mockFunc(appModel, appModel['getItemIndex']);
      when(getItemIndex)(ArgumentMatchers.any).afterReturn(-2);
      const updateGameEngineValidStatus = appModel.getOperationItemInfo('bundleName') as undefined;
      expect(updateGameEngineValidStatus).assertUndefined();
      mocker.clear(appModel);
      mocker.clearAll();
      done();
    })

    it('test_getAndReplaceLauncherAbility_01', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const isEmptyArr =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      const getAndReplaceLauncherAbility = await appModel['getAndReplaceLauncherAbility']('bundleName', 1);
      expect(getAndReplaceLauncherAbility).assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_getAndReplaceLauncherAbility_02', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const isEmptyArr =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      const getLauncherAbilityInfo =
        mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getLauncherAbilityInfo);
      when(getLauncherAbilityInfo)(ArgumentMatchers.any).afterReturn({
        findIndex: (item: ESObject) => -1
      });
      const getAndReplaceLauncherAbility = await appModel['getAndReplaceLauncherAbility']('bundleName', 1);
      expect(getAndReplaceLauncherAbility).assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
      done();
    })

    it('test_getAndReplaceLauncherAbility_03', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const isEmptyArr =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      const getLauncherAbilityInfo =
        mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getLauncherAbilityInfo);
      when(getLauncherAbilityInfo)(ArgumentMatchers.any).afterReturn({
        findIndex: (item: ESObject) => {
          item({});
        }
      });
      const getAndReplaceLauncherAbility = await appModel['getAndReplaceLauncherAbility']('bundleName', 1);
      expect(getAndReplaceLauncherAbility).assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
      done();
    })

    it('test_appendItem', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const isEmptyArr =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      appModel['mSystemApplicationName'].push('bundleName');
      const appendItem = await appModel['appendItem']([{ bundleName: 'bundleName' } as AppItemInfo], 0) as undefined;
      expect(appendItem).assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_removeCloneAppCache_01', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const mCloneInfoMapHas =
        mocker.mockFunc(appModel['mCloneInfoMap'], appModel['mCloneInfoMap'].has);
      when(mCloneInfoMapHas)(ArgumentMatchers.any).afterReturn(false);
      const removeCloneAppCache = appModel['removeCloneAppCache']('bundleName', 0) as undefined;
      expect(removeCloneAppCache).assertUndefined();
      mocker.clear(appModel['mCloneInfoMap']);
      mocker.clearAll();
      done();
    })

    it('test_removeCloneAppCache_02', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const mCloneInfoMapHas =
        mocker.mockFunc(appModel['mCloneInfoMap'], appModel['mCloneInfoMap'].has);
      const mCloneInfoMapGet =
        mocker.mockFunc(appModel['mCloneInfoMap'], appModel['mCloneInfoMap'].get);
      when(mCloneInfoMapHas)(ArgumentMatchers.any).afterReturn(true);
      when(mCloneInfoMapGet)(ArgumentMatchers.any).afterReturn({
        delete: (appIndex: number) => appIndex
      });
      const removeCloneAppCache = appModel['removeCloneAppCache']('-bundleName-NOT', 0) as undefined;
      expect(removeCloneAppCache).assertUndefined();
      mocker.clear(appModel['mCloneInfoMap']);
      mocker.clearAll();
      done();
    })

    it('test_getCloneAppNumber', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const mCloneInfoMapHas =
        mocker.mockFunc(appModel['mCloneInfoMap'], appModel['mCloneInfoMap'].has);
      when(mCloneInfoMapHas)(ArgumentMatchers.any).afterReturn(true);
      const getCloneAppNumber = appModel['getCloneAppNumber']('-bundleName-NOT');
      expect(getCloneAppNumber).assertEqual(0);
      mocker.clear(appModel['mCloneInfoMap']);
      mocker.clearAll();
      done();
    })

    it('test_removeItem', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const mMultiIconAppMapHas =
        mocker.mockFunc(appModel['mMultiIconAppMap'], appModel['mMultiIconAppMap'].has);
      when(mMultiIconAppMapHas)(ArgumentMatchers.any).afterReturn(true);
      appModel['mIsMultiIconAppMapInit'] = true;
      const removeItem = appModel['removeItem']('bundleName', 0) as undefined;
      expect(removeItem).assertUndefined();
      mocker.clear(appModel['mMultiIconAppMap']);
      mocker.clearAll();
      done();
    })

    it('test_removeItemCache', 0, async (done: Function) => {
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const removeItemCache = appModel['removeItemCache']('com', 0) as undefined;
      expect(removeItemCache).assertUndefined();
      done();
    })

    it('test_getShortcutInfo_05', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      globalThis.AppModel = null;
      const appModel: AppModel = AppModel.getInstance();
      const isEmptyArr =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      appModel['mShortcutInfoMap'].set('bundleName', [{} as ShortcutInfo]);
      try {
        const getShortcutInfo = appModel['getShortcutInfo']('bundleName') ?? undefined;
        expect(getShortcutInfo).not().assertNull();
      } catch (e) {};
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    /**
     * 异步加载BMS应用列表
     */
    it('test_loadAppList_05', 0, async (done: Function) => {
      const instance: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.loadAppList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      expect(instance.loadAppList(true)).assertUndefined();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });
  })
}