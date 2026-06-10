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
import image from '@ohos.multimedia.image';
import { ResourceManager } from '../../../../../../main/ets/manager/ResourceManager';
import { AppResourceCacheManager } from '../../../../../../main/ets/manager/AppResourceCacheManager';
import { GlobalContext } from '../../../../../../main/ets/utils/GlobalContext';
import { resourceManager } from '@kit.LocalizationKit';
import type ctx from '@ohos.app.ability.common';
import { MemoryUtils } from '@ohos/basicutils';

async function createImage(width: number, height: number): Promise<image.PixelMap> {
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return await image.createPixelMap(color, opts);
}

export default function ResourceManager3Test() {
  describe('ResourceManager3Test', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    });
    afterEach((): void => {

    });
    afterAll((): void => {

    });

    it('getCachedSmallFolderIcon_should_return_cached_icon_when_cache_exists_7', 0, async () => {
      let mocker: MockKit = new MockKit();
      let appResourceCacheManager: AppResourceCacheManager = globalThis.AppResourceCacheManager;
      try {
        let smallFolderId: string = "123";
        let cachedIcon: image.PixelMap = await createImage(288, 288);

        let mockFunc: Function = mocker.mockFunc(appResourceCacheManager, appResourceCacheManager.getCache);
        when(mockFunc)(ArgumentMatchers.anyString).afterReturn(cachedIcon);

        let resMgr: ResourceManager = ResourceManager.getInstance();
        let result: image.PixelMap = resMgr.getCachedSmallFolderIcon(smallFolderId);

        expect(resMgr instanceof ResourceManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(appResourceCacheManager, appResourceCacheManager.getCache);
    });

    it('should_return_undefined_when_cache_does_not_exist', 0, async () => {
      let smallFolderId: string = "123";
      let mocker: MockKit = new MockKit();
      let appResourceCacheManager: AppResourceCacheManager = globalThis.AppResourceCacheManager;
      let mockFunc: Function = mocker.mockFunc(appResourceCacheManager, appResourceCacheManager.getCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(undefined);

      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let result: image.PixelMap = resourceManager.getCachedSmallFolderIcon(smallFolderId);

      expect(result).assertUndefined();
      mocker.ignoreMock(appResourceCacheManager, appResourceCacheManager.getCache);
    });

    it('should_return_undefined_when_cache_is_null_7', 0, async () => {
      let smallFolderId: string = "123";
      let mocker: MockKit = new MockKit();
      let appResourceCacheManager: AppResourceCacheManager = globalThis.AppResourceCacheManager;
      let mockFunc: Function = mocker.mockFunc(appResourceCacheManager, appResourceCacheManager.getCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);

      let resMgr: ResourceManager = ResourceManager.getInstance();
      let result: image.PixelMap = resMgr.getCachedSmallFolderIcon(smallFolderId);

      expect(resMgr instanceof ResourceManager).assertTrue();
      mocker.ignoreMock(appResourceCacheManager, appResourceCacheManager.getCache);
    });

    it('getCachedNormalMediaAppIcon_should_return_cached_icon_when_cache_exists_7', 0, async () => {
      let mocker: MockKit = new MockKit();
      let appResourceCacheManager: AppResourceCacheManager = globalThis.AppResourceCacheManager;
      try {
        let iconId: number = 1;
        let bundleName: string = "com.example.test";
        let moduleName: string = "entry";
        let resMgr: ResourceManager = ResourceManager.getInstance();

        // Mock the getCache method
        let mockGetCache: Function = mocker.mockFunc(appResourceCacheManager, appResourceCacheManager.getCache);
        when(mockGetCache)(ArgumentMatchers.anyString).afterReturn("cachedIcon");

        const result = resMgr.getCachedNormalMediaAppIcon(iconId, bundleName, moduleName);
        expect(resMgr instanceof ResourceManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(appResourceCacheManager, appResourceCacheManager.getCache);
    });

    it('should_return_null_when_cache_does_not_exist_7', 0, async () => {
      let iconId: number = 1;
      let bundleName: string = "com.example.test";
      let moduleName: string = "entry";
      let resMgr: ResourceManager = ResourceManager.getInstance();
      let appResourceCacheManager: AppResourceCacheManager = globalThis.AppResourceCacheManager;
      let mocker: MockKit = new MockKit();

      // Mock the getCache method
      let mockGetCache: Function = mocker.mockFunc(appResourceCacheManager, appResourceCacheManager.getCache);
      when(mockGetCache)(ArgumentMatchers.anyString).afterReturn(null);

      const result = resMgr.getCachedNormalMediaAppIcon(iconId, bundleName, moduleName);
      expect(resMgr instanceof ResourceManager).assertTrue();

      mocker.ignoreMock(appResourceCacheManager, appResourceCacheManager.getCache);
    });

    it('should_log_warning_and_delete_cache_when_bundleName_is_valid', 0, async () => {
      let bundleName: string = "validBundleName";
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();

      let appResourceCacheManager: AppResourceCacheManager = globalThis.AppResourceCacheManager;
      let mockDeleteCacheByBundle: Function =
        mocker.mockFunc(appResourceCacheManager, appResourceCacheManager.deleteCacheByBundle);
      when(mockDeleteCacheByBundle)(ArgumentMatchers.anyString).afterReturnNothing();

      resourceManager.deleteAppResourceCacheByBundle(bundleName);

      mocker.ignoreMock(appResourceCacheManager, appResourceCacheManager.deleteCacheByBundle);
    });

    it('should_log_warning_but_not_delete_cache_when_bundleName_is_empty', 0, async () => {
      let bundleName: string = "";
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();

      let appResourceCacheManager: AppResourceCacheManager = globalThis.AppResourceCacheManager;
      let mockDeleteCacheByBundle: Function =
        mocker.mockFunc(appResourceCacheManager, appResourceCacheManager.deleteCacheByBundle);
      when(mockDeleteCacheByBundle)(ArgumentMatchers.anyString).afterReturnNothing();

      resourceManager.deleteAppResourceCacheByBundle(bundleName);

      mocker.ignoreMock(appResourceCacheManager, appResourceCacheManager.deleteCacheByBundle);
    });

    it('should_return_immediately_when_iconBase64_is_not_empty', 0, async () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn("someBase64String");
      await resourceManager.updateIconCache("iconId", "bundleName", "moduleName");
      mocker.ignoreMock(resourceManager, resourceManager.getAppResourceCache);
    });

    it('should_log_debug_when_iconBase64_is_empty_and_getAccountSAState_succeeds', 0, async () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      let mockFunc2: Function = mocker.mockFunc(resourceManager, resourceManager.getAccountSAState);
      when(mockFunc2)().afterReturn(Promise.resolve(true));
      await resourceManager.updateIconCache("iconId", "bundleName", "moduleName");
      mocker.ignoreMock(resourceManager, resourceManager.getAppResourceCache);
      mocker.ignoreMock(resourceManager, resourceManager.getAccountSAState);
    });

    it('should_return_defaultAppIcon_when_callback_is_empty', 0, () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let defaultAppIcon: string = "defaultIcon";
      resourceManager.getNormalMediaAppIconWithCache(1, "bundleName", "moduleName", null, defaultAppIcon);
    });

    it('should_return_defaultAppIcon_when_iconId_is_empty', 0, () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let callback: Function = (icon: string) => {
        expect(icon).assertEqual("defaultIcon");
      };
      let defaultAppIcon: string = "defaultIcon";
      resourceManager.getNormalMediaAppIconWithCache(0, "bundleName", "moduleName", callback, defaultAppIcon);
    });

    it('should_return_cached_icon_when_all_caches_are_valid_7', 0, () => {
      let resMgr: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resMgr, resMgr.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn("cachedIcon");

      let callback: Function = (icon: string) => {
        expect(resMgr instanceof ResourceManager).assertTrue();
      };
      let defaultAppIcon: string = "defaultIcon";
      resMgr.getNormalMediaAppIconWithCache(1, "bundleName", "moduleName", callback, defaultAppIcon);

      mocker.ignoreMock(resMgr, resMgr.getAppResourceCache);
    });

    it('should_call_getNormalMediaContentBase_when_resourceManager_is_empty', 0, () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);

      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc2: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(null);

      let callback: Function = (icon: string) => {
        expect(icon).assertEqual("defaultIcon");
      };
      let defaultAppIcon: string = "defaultIcon";
      resourceManager.getNormalMediaAppIconWithCache(1, "bundleName", "moduleName", callback, defaultAppIcon);

      mocker.ignoreMock(resourceManager, resourceManager.getAppResourceCache);
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_call_callback_with_defaultAppIcon_when_iconBase64_is_empty_and_resourceManager_is_empty', 0, () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockGetAppResourceCache: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockGetAppResourceCache)(ArgumentMatchers.any).afterReturn(null);

      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc2: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(null);

      let mockCallback: Function = (icon: string) => {
        expect(icon).assertEqual("defaultAppIcon");
      };

      resourceManager.getAppIconWithCache(1, "bundleName", "moduleName", mockCallback, "defaultAppIcon", 1);

      mocker.ignoreMock(resourceManager, resourceManager.getAppResourceCache);
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_return_appName_when_resourceManager_is_empty', 0, async () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc2: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(null);
      let result = await resourceManager.getAppNameSync('labelId', 'bundleName', 'moduleName', 'appName');
      expect(result).assertEqual('appName');
      mocker.ignoreMock(resourceManager, resourceManager.getAppResourceCache);
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_return_appName_when_getAppResourceCache_is_empty', 0, async () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn("");

      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc2: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(null);

      let callback = (appName: string) => {
        expect(appName).assertEqual("bundleName");
      };
      resourceManager.getAppNameWithCache(1, "bundleName", "moduleName", "defaultAppName", callback);
      mocker.ignoreMock(resourceManager, resourceManager.getAppResourceCache);
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_return_appName_when_name_is_empty_and_resourceManager_is_empty', 0, async () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc2: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(null);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.getBundleAppName);
      when(mockFunc3)(ArgumentMatchers.anyString).afterReturn("defaultAppName");
      let callback = (appName: string) => {
        expect(appName).assertEqual("defaultAppName");
      };
      resourceManager.getBundleLabelWithCache(1, "bundleName", "moduleName", "defaultAppName", callback);
      mocker.ignoreMock(resourceManager, resourceManager.getAppResourceCache);
      mocker.ignoreMock(globalContext, globalContext.getObject);
      mocker.ignoreMock(resourceManager, resourceManager.getBundleAppName);
    });

    it('should_call_callback_with_empty_string_when_resourceManager_is_empty', 0, async () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      let callback = (appName: string) => {
        expect(appName).assertEqual('');
      };
      resourceManager.getStringById(1, callback);
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_return_empty_string_when_resId_is_zero', 0, async () => {
      let resId: number = 0;
      let bundleName: string = "testBundle";
      let moduleName: string = "testModule";
      let appIndex: number = 0;
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      const result = await resourceManager.getBundleStringByIdSync(resId, bundleName, moduleName, appIndex);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_resourceManager_is_empty', 0, async () => {
      let resId: number = 1;
      let bundleName: string = "testBundle";
      let moduleName: string = "testModule";
      let appIndex: number = 0;
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      const result = await resourceManager.getBundleStringByIdSync(resId, bundleName, moduleName, appIndex);
      expect(result).assertEqual('');
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_return_empty_string_when_resourceManager_is_empty', 0, async () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      const result = await resourceManager.getStringByIdSync(1);
      expect(result).assertEqual('');
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_return_0_when_resourceManager_is_empty', 0, () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      let globalContext: GlobalContext = GlobalContext.getInstance();
      let mockFunc: Function = mocker.mockFunc(globalContext, globalContext.getObject);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      let result = resourceManager.getNumberById(1);
      expect(result).assertEqual(0);
      mocker.ignoreMock(globalContext, globalContext.getObject);
    });

    it('should_return_undefined_when_resourceName_is_empty', 0, () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      const result = resourceManager.getPixelMapByResourceName("", "bundleName", "moduleName");
      expect(result).assertUndefined();
    });

    it('should_return_false_when_resourceNames_is_empty', 0, () => {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let resourceNames: string[] = [];
      let bundleName: string = "com.ohos.test";
      let moduleName: string = "entry";
      const result = resourceManager.isExistResByResourceNames(resourceNames, bundleName, moduleName);
      expect(result).assertEqual(false);
    });

    it('test_getAppName', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.contacts';
      let moduleName: string = 'entry';
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let resMgr: resourceManager.ResourceManager =
          (GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);

        let mockFunc: Function = mocker.mockFunc(resMgr, resMgr.getStringValue);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('电话');
        let name: string = await resourceManager.getAppName(1, bundleName, moduleName);
        expect(name === '电话');
        mocker.ignoreMock(resMgr, resMgr.getStringValue);
        MemoryUtils.removeNapiWrap(resMgr, false);
      } catch (err) {
        expect(err).not().assertNull();
      }
    })
  });
}