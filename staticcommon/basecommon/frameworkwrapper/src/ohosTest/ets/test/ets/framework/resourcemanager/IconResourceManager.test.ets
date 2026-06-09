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
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { memoryCache } from '../../../../../../main/ets/resourcemanager/cache/MemoryCache';
import { IconCacheFwkInterface } from '../../../../../../main/ets/resourcemanager/IconCacheFwkInterface';
import IconInfo, { IconPicType } from '../../../../../../main/ets/resourcemanager/IconInfo';
import { bundleManagerFwk, dbCache, IconCacheInterface, IconResourceManager } from '../../../../../../main/ets/TsIndex';
import { image } from '@kit.ImageKit';
import { GraphicUtils } from '../../../../../../main/ets/resourcemanager/GraphicsUtils';
import { HashSet, List } from '@kit.ArkTS';
import { IconExtendParam } from '../../../../../../main/ets/resourcemanager/IconExtendParam';
import { AppIconIdLoader } from '../../../../../../main/ets/resourcemanager/AppIconIdLoader';
import { CalendarCache } from '../../../../../../main/ets/resourcemanager/cache/CalendarCache';
import { TaskInfo } from '../../../../../../main/ets/resourcemanager/TaskInfo';
import { ResourceManager } from '../../../../../../main/ets/manager/ResourceManager';
import { SCBConstants } from '@ohos/commonconstants';
import { CompanionIconInfo, StartType } from '@ohos/basicutils';
import { onLineThemeUtil } from '../../../../../../main/ets/utils/OnLineThemeUtil';
import HashMap from '@ohos.util.HashMap';

class TestCache implements CalendarCache {
  private bundleName: string = '';

  async getCalendarImage(bundleName: string): Promise<image.PixelMap | undefined> {
    if (this.bundleName?.indexOf('photos') > 0) {
      return undefined;
    }
    let img = image.createPixelMapSync({ size: { width: 16, height: 16 } });
    return img;
  }

  getCalendarImageSync(bundleName: string): image.PixelMap | undefined {
    if (this.bundleName?.indexOf('photos') > 0) {
      return undefined;
    }
    return image.createPixelMapSync({ size: { width: 16, height: 16 } });
  }

  checkIsDynamicCalendarIcon(bundleName: string): boolean {
    this.bundleName = bundleName;
    if (this.bundleName?.indexOf('photos') > 0) {
      return false;
    }
    return true;
  }

  getCalendarImageSyncWithoutCheck(): image.PixelMap | undefined {
    if (this.bundleName?.indexOf('photos') > 0) {
      return undefined;
    }
    return image.createPixelMapSync({ size: { width: 16, height: 16 } });
  }
}

export function IconResourceManagerTest() {
  const bundleName = 'com.dbCacheTest';
  const moduleName = 'dbCacheTest';
  const abilityName = 'MainAbility';
  const appName = 'testAppName';
  const iconInfo = new IconInfo();
  iconInfo.combinePic = 'combinePic';
  iconInfo.adaptivePic = ['backPic', 'forePic'];
  iconInfo.iconType = IconPicType.ADAPTIVE;

  describe('IconResourceManagerTest', () => {
    let iconResourceManager = new IconResourceManager();
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('initCacheList', 0, () => {
      let cacheFactory: List<IconCacheInterface> = new List();
      let fwkFactory: IconCacheFwkInterface = bundleManagerFwk;
      iconResourceManager.initCacheList(cacheFactory, fwkFactory);
      expect(iconResourceManager['cacheFactory']).not().assertUndefined(); // should be cachefactory
      expect(iconResourceManager['fwkFactory']).not().assertUndefined();  // should be cachefactory
    });

    it('getCombIcon', 0, async (done: Function) => {
      let value: string = await resourceManagerCreateImage();
      let iconInfo: IconInfo = new IconInfo(IconPicType.NORMAL, [], value);
      let param: IconExtendParam = new IconExtendParam();
      memoryCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      const result1 = await iconResourceManager.getCombIcon(bundleName, moduleName, abilityName);
      expect(result1).assertUndefined(); // assertEqual('value')
      iconResourceManager.clearAppResourceCache('');
      let iconstring = await iconResourceManager.getCombIcon('com.ohos.photos', 'phone_photos',
        'com.ohos.photos.MainAbility');
      let iconDb = await dbCache.getCombIcon('com.ohos.photos', 'phone_photos',
        'com.ohos.photos.MainAbility', param);
      let iconMemory = memoryCache.getCombIconSync('com.ohos.photos', 'phone_photos',
        'com.ohos.photos.MainAbility');
      expect(iconstring).not().assertNull();// equals getCombIcon
      done();
    });

    it('getIconResource', 0, async (done: Function) => {
      const result = await iconResourceManager.getIconResource('bundleName', 'moduleName', 'abilityName');
      expect(result).not().assertUndefined();
      let value: string = await resourceManagerCreateImage();
      let iconInfo: IconInfo = new IconInfo(IconPicType.NORMAL, [], value);
      let param: IconExtendParam = new IconExtendParam();
      memoryCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      const result1 = await iconResourceManager.getIconResource(bundleName, moduleName, abilityName);
      expect(result1?.combinePic).not().assertUndefined();
      memoryCache.deleteCache(bundleName);
      dbCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      const result2 = await iconResourceManager.getIconResource(bundleName, moduleName, abilityName);
      expect(result2?.combinePic).not().assertUndefined();
      done();
    });

    it('getCachedCombIconSync', 0, async (done: Function) => {
      let value: string = await resourceManagerCreateImage();
      let res: string | PixelMap = iconResourceManager.getCachedCombIconSync(bundleName, moduleName, abilityName);
      expect(res).assertUndefined();
      let iconInfo: IconInfo = new IconInfo(IconPicType.NORMAL, [], value);
      let param: IconExtendParam = new IconExtendParam();
      memoryCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      let result: string | PixelMap = iconResourceManager.getCachedCombIconSync(bundleName, moduleName, abilityName);
      expect(result).assertUndefined();
      done();
    });

    it('checkSystemStateAndVersion', 0, async (done: Function) => {
      await iconResourceManager.checkSystemStateAndVersion();
      done();
    })

    it('deleteIconResource', 0, () => {
      let mocker: MockKit = new MockKit();
      let meDeleteCache = mocker.mockFunc(memoryCache, memoryCache.deleteCache);
      let dbDeleteCache = mocker.mockFunc(dbCache, dbCache.deleteCache);
      when(meDeleteCache)('test').afterReturn(true);
      when(dbDeleteCache)('test').afterReturn(true);
      iconResourceManager.deleteIconResource(bundleName); // expect once
      mocker.clear(memoryCache);
      mocker.clear(dbCache);
      mocker.clearAll();
    });

    it('clearAppResourceCache', 0, () => {
      let mocker: MockKit = new MockKit();
      let medeleteAllCache = mocker.mockFunc(memoryCache, memoryCache.deleteAllCache);
      let dbdeleteAllCache = mocker.mockFunc(dbCache, dbCache.deleteAllCache);
      when(medeleteAllCache)('test').afterReturn(true);
      when(dbdeleteAllCache)('test').afterReturn(true);
      iconResourceManager.clearAppResourceCache('');  // expect once
      mocker.clear(memoryCache);
      mocker.clear(dbCache);
      mocker.clearAll();
    });

    it('getCachedIconNameSync', 0, () => {
      iconResourceManager
        .setNameResourceCache(bundleName, moduleName, abilityName, appName);
      iconResourceManager.clearAllAppNameCache();
      let name = iconResourceManager
        .getCachedIconNameSync(bundleName, moduleName, abilityName);
      expect(name === '').assertTrue();
    });

    it('clearAllAppNameCache', 0, async (done: Function) => {
      iconResourceManager
        .setNameResourceCache(bundleName, moduleName, abilityName, appName);
      iconResourceManager.clearAllAppNameCache();
      let isNameCacheEmpty = iconResourceManager.isNameCacheEmpty();
      expect(isNameCacheEmpty).assertEqual(true);
      done();
    });

    it('test_setAppIconIdLoader_01', 0, () => {
      let loader: AppIconIdLoader = {
        getAppItemIconId: (bundleName: string, moduleName: string, abilityName: string): number => {
          return 1;
        }
      }
      let irMgr = new IconResourceManager();
      irMgr.setAppIconIdLoader(loader);
      expect(irMgr['iconIdLoaderCache']).not().assertUndefined();

      iconResourceManager.setAppIconIdLoader(loader);
      expect(iconResourceManager['fwkFactory']).not().assertUndefined();
    });

    it('test_getCombineIcon_01', 0, async (): Promise<void> => {
      let testCache: TestCache = new TestCache();
      let bundleName: string = 'com.ohos.calendar';
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = false;

      iconResourceManager.initCalendarCache(testCache);
      let result: image.PixelMap = await iconResourceManager.getCombineIcon(bundleName, '', '', param);
      expect(result).not().assertUndefined();
    });

    it('test_getCombineIcon_02', 0, async (): Promise<void> => {
      let testCache: TestCache = new TestCache();
      let bundleName: string = 'com.ohos.photos';
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = false;

      iconResourceManager.initCalendarCache(testCache);
      let result: image.PixelMap = await iconResourceManager.getCombineIcon(bundleName, '', '', param);
      expect(result).assertUndefined();
    });

    it('test_getCombineIcon_03', 0, async (): Promise<void> => {
      let testCache: TestCache = new TestCache();
      let bundleName: string = 'com.ohos.photos';
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = true;

      let cacheFactory: List<IconCacheInterface> = new List();
      cacheFactory.add(memoryCache);
      let fwkFactory: IconCacheFwkInterface = bundleManagerFwk;
      iconResourceManager.initCacheList(cacheFactory, fwkFactory);

      iconResourceManager.initCalendarCache(testCache);
      let hashSet = (iconResourceManager as object)['deletingIcons'] as HashSet<string>;
      hashSet.add(bundleName);
      let result: image.PixelMap = await iconResourceManager.getCombineIcon(bundleName, '', '', param);
      expect(result).assertUndefined();
    });

    it('test_getCombineIcon_04', 0, async (): Promise<void> => {
      let testCache: TestCache = new TestCache();
      let bundleName: string = 'com.ohos.photos';
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = true;

      let cacheFactory: List<IconCacheInterface> = new List();
      cacheFactory.add(memoryCache);
      let fwkFactory: IconCacheFwkInterface = bundleManagerFwk;
      iconResourceManager.initCacheList(cacheFactory, fwkFactory);

      iconResourceManager.initCalendarCache(testCache);
      let hashSet = (iconResourceManager as object)['deletingIcons'] as HashSet<string>;
      hashSet?.clear();
      let result: image.PixelMap = await iconResourceManager.getCombineIcon(bundleName, '', '', param);
      expect(result).assertUndefined();
    });

    it('test_getIconResourceBySize_01', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let result: IconInfo = await iconResourceManager.getIconResourceBySize('', '', '', 16);
      expect(result.moduleName).assertEqual('');

      result = await iconResourceManager.getIconResourceBySize(bundleName, '', '', 16);
      expect(result).not().assertUndefined();
    });

    it('test_setIconResourceCache_01', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let iconInfo: IconInfo = new IconInfo();
      let ext: IconExtendParam = new IconExtendParam();
      iconResourceManager.setIconResourceCache(bundleName, '', '', iconInfo, ext);
      expect(iconInfo.bundleName).assertEqual('');
    });

    it('test_setIconResourceCache_02', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let iconInfo: IconInfo = new IconInfo();
      iconInfo.combinePic = 'combinePic';

      let ext: IconExtendParam = new IconExtendParam();
      iconResourceManager.setIconResourceCache(bundleName, '', '', iconInfo, ext);
      expect(iconResourceManager['cacheFactory']).not().assertUndefined();
    });

    it('test_refreshIconResourceBatch_01', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let iconExt: IconExtendParam = new IconExtendParam();
      let taskInfo: TaskInfo = new TaskInfo(bundleName, 'phone_photos', 'com.ohos.photos.MainAbility', iconExt);
      let taskList: TaskInfo[] = [taskInfo];
      await iconResourceManager.refreshIconResourceBatch(taskList);
      expect(taskList).not().assertUndefined();
    });

    it('test_refreshIconResourceBatch_02_mock', 0, async (): Promise<void> => {
      let iconInfo: IconInfo = new IconInfo();
      let iconList: IconInfo[] = [iconInfo];
      let mocker: MockKit = new MockKit();
      let mockerFunInfo: Function = mocker.mockFunc(bundleManagerFwk, bundleManagerFwk.getIconResourceFromFwkBatch);
      when(mockerFunInfo)(ArgumentMatchers.any).afterReturn(iconList);

      let bundleName: string = 'com.ohos.photos';
      let iconExt: IconExtendParam = new IconExtendParam();
      let taskInfo: TaskInfo = new TaskInfo(bundleName, 'phone_photos', 'com.ohos.photos.MainAbility', iconExt);
      let taskList: TaskInfo[] = [taskInfo];
      await iconResourceManager.refreshIconResourceBatch(taskList);
      expect(taskList).not().assertUndefined();
      mocker.clear(bundleManagerFwk);
      mocker.ignoreMock(bundleManagerFwk, mockerFunInfo);
      mocker.clearAll();
    });

    it('test_refreshIconResourceBatch_03_mock', 0, async (): Promise<void> => {
      let iconInfo: IconInfo = new IconInfo();
      iconInfo.iconType = IconPicType.NORMAL;
      iconInfo.bundleName = 'bundleName';
      iconInfo.moduleName = 'moduleName';
      iconInfo.abilityName = 'abilityName';
      iconInfo.combinePic = 'combinePic';
      iconInfo.param = new IconExtendParam();

      let iconList: IconInfo[] = [iconInfo];
      let mocker: MockKit = new MockKit();
      let mockerFunInfo: Function = mocker.mockFunc(bundleManagerFwk, bundleManagerFwk.getIconResourceFromFwkBatch);
      when(mockerFunInfo)(ArgumentMatchers.any).afterReturn(iconList);

      let bundleName: string = 'com.ohos.photos';
      let iconExt: IconExtendParam = new IconExtendParam();
      let taskInfo: TaskInfo = new TaskInfo(bundleName, 'phone_photos', 'com.ohos.photos.MainAbility', iconExt);
      let taskList: TaskInfo[] = [taskInfo];
      await iconResourceManager.refreshIconResourceBatch(taskList);
      expect(taskList).not().assertUndefined();
      mocker.clear(bundleManagerFwk);
      mocker.ignoreMock(bundleManagerFwk, mockerFunInfo);
      mocker.clearAll();
    });

    it('test_needWaitCheckAppVersion_args_empty', 0, async (): Promise<void> => {
      let result: boolean = (iconResourceManager as object)['needWaitCheckAppVersion']('', '');
      expect(result).assertFalse();
      result = (iconResourceManager as object)['needWaitCheckAppVersion']('0.0.0.0', '');
      expect(result).assertFalse();
    });

    it('test_needWaitCheckAppVersion_args_invalid', 0, async (): Promise<void> => {
      let result: boolean = (iconResourceManager as object)['needWaitCheckAppVersion']('0.0.0.0', '1.0');
      expect(result).assertFalse();
    });

    it('test_needWaitCheckAppVersion_true', 0, async (): Promise<void> => {
      let result: boolean = (iconResourceManager as object)['needWaitCheckAppVersion']('1.0.0.0', '1.1.2.3');
      expect(result).assertTrue();
    });

    it('test_needWaitCheckAppVersion_false', 0, async (): Promise<void> => {
      let result: boolean = (iconResourceManager as object)['needWaitCheckAppVersion']('1.9.0.0', '1.1.2.3');
      expect(result).assertFalse();
    });

    it('test_getAppName_labelId_invalid', 0, async (): Promise<void> => {
      let appName: string = 'abc';
      let res: string = await iconResourceManager.getAppName(0, 'com.ohos.contacts', 'entry', appName, 0);
      expect(res === appName).assertTrue();
      let res2: string = await iconResourceManager.getAppName(0, 'com.ohos.contacts', 'entry', appName, 1);
      expect(res2 === appName).assertTrue();
    });

    it('test_getAppName_labelId_valid', 0, async (): Promise<void> => {
      memoryCache.setAppName(100663322, 'com.ohos.contacts', 'entry', '电话');
      let appName: string = '电话';
      let res: string = await iconResourceManager.getAppName(100663322, 'com.ohos.contacts', 'entry', appName, 0);
      expect(res === appName).assertTrue();
      let res2: string = await iconResourceManager.getAppName(100663322, 'com.ohos.contacts', 'entry', appName, 1);
      expect('电话1' === res2).assertTrue();

      memoryCache.deleteCache('com.ohos.contacts');
      let mocker: MockKit = new MockKit();
      let mockerFun: Function =
        mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppName);
      when(mockerFun)(ArgumentMatchers.any).afterReturn('电话');

      let res3: string = await iconResourceManager.getAppName(100663322, 'com.ohos.contacts', 'entry', appName, 0);
      expect('电话' === res3).not().assertUndefined();

      let res4: string = await iconResourceManager.getAppName(100663322, 'com.ohos.contacts', 'entry', appName, 1);
      expect('电话1' === res4).not().assertUndefined();
      mocker.clear(mockerFun);
      mocker.ignoreMock(ResourceManager.getInstance(), mockerFun);
      mocker.clearAll();
    });

    it('test_updateAppNameSync_labelId_invalid', 0, async (): Promise<void> => {
      let appName: string = '电话';
      let name: string = await iconResourceManager.updateAppNameSync(0, 'com.ohos.contacts', 'entry', appName, 0);
      expect(name === appName).assertTrue();
    });

    it('test_updateAppNameSync_labelId_valid', 0, async (): Promise<void> => {
      let mocker: MockKit = new MockKit();
      let mockerFun: Function =
        mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppName);
      when(mockerFun)(ArgumentMatchers.any).afterReturn('电话');

      let res3: string = await iconResourceManager.updateAppNameSync(100663322, 'com.ohos.contacts', 'entry', appName,
        0);
      expect('电话' === res3).not().assertUndefined();

      let res4: string = await iconResourceManager.updateAppNameSync(100663322, 'com.ohos.contacts', 'entry', appName,
        1);
      expect('电话1' === res4).not().assertUndefined();
      mocker.clear(mockerFun);
      mocker.ignoreMock(ResourceManager.getInstance(), mockerFun);
      mocker.clearAll();
    });

    it('test_getAppNameWithCallback_labelId_invalid', 0, async (): Promise<void> => {
      let appName: string = 'default';
      iconResourceManager.getAppNameWithCallback(0, 'com.ohos.contacts', 'entry', appName, (name: string) => {
        expect(name === appName).assertTrue();
      }, 0);
    });

    it('test_getAppNameWithCallback_labelId_valid_index0', 0, async (): Promise<void> => {
      let mocker: MockKit = new MockKit();
      let mockerFun: Function =
        mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppName);
      when(mockerFun)(ArgumentMatchers.any).afterReturn('电话');

      iconResourceManager.getAppNameWithCallback(100663322, 'com.ohos.contacts', 'entry', '电话',(name: string) => {
        expect(name === '电话').assertTrue();
        mocker.clear(mockerFun);
        mocker.ignoreMock(ResourceManager.getInstance(), mockerFun);
        mocker.clearAll();
      }, 0);
    });

    it('test_getAppNameWithCallback_labelId_valid_index1', 0, async (): Promise<void> => {
      let mocker: MockKit = new MockKit();
      let mockerFun: Function =
        mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppName);
      when(mockerFun)(ArgumentMatchers.any).afterReturn('电话');

      iconResourceManager.getAppNameWithCallback(100663322, 'com.ohos.contacts', 'entry', '电话',(name: string) => {
        expect(name === '电话1').assertTrue();
        mocker.clear(mockerFun);
        mocker.ignoreMock(ResourceManager.getInstance(), mockerFun);
        mocker.clearAll();
      }, 1);
    });

    it('test_getAppNameByCache', 0, (): void => {
      memoryCache.setAppName(100663322, 'com.ohos.contacts', 'entry', '电话');
      let name: string = iconResourceManager.getAppNameByCache(100663322, 'com.ohos.contacts', 'entry', '电话', 0);
      expect(name === '电话').assertTrue();
      let name1: string = iconResourceManager.getAppNameByCache(100663322, 'com.ohos.contacts', 'entry', '电话', 1);
      expect(name1 === '电话1').assertTrue();
      memoryCache.setAppName(100663322, 'com.ohos.contacts', 'entry', '');
      let name2: string = iconResourceManager.getAppNameByCache(100663322, 'com.ohos.contacts', 'entry', 'default', 0);
      expect(name2 === 'default').assertTrue();
    });

    it('test_getAppNameCacheKey', 0, (): void => {
      let name: string = iconResourceManager.getAppNameCacheKey(100663322, 'com.ohos.contacts', 'entry');
      expect(name === '100663322#com.ohos.contactsentry').assertTrue();
    });

    it('test_setAppNameCacheByCacheKey', 0, (): void => {
      let cacheKey: string = '100663322#com.ohos.contactsentry';
      iconResourceManager.setAppNameCacheByCacheKey(cacheKey, '');
      iconResourceManager.setAppNameCacheByCacheKey('', '');
      iconResourceManager.setAppNameCacheByCacheKey(cacheKey, '电话');
      let name: string = memoryCache.getAppName(100663322, 'com.ohos.contacts', 'entry');
      expect(name === '电话').assertTrue();
    });

    it('test_isAdaptiveIcon', 0, async (): Promise<void> => {
      let info: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.SHORTCUT_APP,
        cardId: ''
      };
      let result: boolean = iconResourceManager.isAdaptiveIcon(info);
      expect(result).assertFalse();

      expect(iconResourceManager.isAdaptiveIcon(null)).assertTrue();
    });

    it('test_isAdaptiveIcon_mock', 0, async (): Promise<void> => {
      let mocker: MockKit = new MockKit();
      let mockerFun: Function =
        mocker.mockFunc(onLineThemeUtil, onLineThemeUtil.isOnlineTheme);
      when(mockerFun)(ArgumentMatchers.any).afterReturn(false);

      let bundleName: string = 'com.ohos.photos';
      let info: CompanionIconInfo = {
        iconId: '',
        bundleName: bundleName,
        abilityName: 'com.ohos.photos.MainAbility',
        moduleName: 'phone_photos',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      };
      let result: boolean = iconResourceManager.isAdaptiveIcon(info);
      expect(result).assertFalse();
    });
  });
}
async function resourceManagerCreateImage(): Promise<string> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return GraphicUtils.changePixelToBase64(await image.createPixelMap(color, opts));
}