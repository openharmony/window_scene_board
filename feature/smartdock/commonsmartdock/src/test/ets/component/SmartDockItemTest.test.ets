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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { SCBConstants } from '@ohos/commonconstants';
import { GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import { windowManager } from '@ohos/componentdrag';
import image from '@ohos.multimedia.image';

export function SmartDockItemTest() {
  describe('SmartDockItemTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_ResourceManager_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = ResourceManager.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = ResourceManager.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('test_getSCBInnerString_should_return_string', Level.LEVEL0, (): void => {
      let name: string = '';
      ResourceManager.getInstance().getSCBInnerString(SCBConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringById_should_return_string', Level.LEVEL0, (): void => {
      let name: string = '';
      ResourceManager.getInstance().getStringById($r('app.string.uninstall').id, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      /* 异常数据时查询返回空字符串 */
      ResourceManager.getInstance().getStringById(0, (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      /* 异常数据时查询返回空字符串 */
      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getStringById_should_return_number', Level.LEVEL0, (): void => {
      let radius: number = ResourceManager.getInstance().getNumberByResource($r('app.float.form_corner_radius'));
      let res: boolean = radius >= 0;
      expect(res).assertTrue();
    })

    it('test_getStringByIdSync_should_return_string', Level.LEVEL0, async (done: Function) => {
      let res: string = await ResourceManager.getInstance().getStringByIdSync($r('app.string.uninstall').id);
      expect(res).not().assertNull();

      res = await ResourceManager.getInstance().getStringByIdSync(undefined);
      expect(res).assertEqual('');

      res = await ResourceManager.getInstance().getStringByIdSync(-1);
      expect(res).assertEqual('');

      done();
    })

    it('test_getStringByResource_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getStringByResource($r('app.string.uninstall'));
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightRegular_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data', Level.LEVEL0, (): void => {
      ResourceManager.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      ResourceManager.getInstance().getSCBInnerIcon(SCBConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean', Level.LEVEL0, (): void => {
      let res: boolean = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        '');
      expect(res).assertFalse();

      res = ResourceManager.getInstance().isSCBInnerModule('',
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data002', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedIconPixelMapByKey_should_return_data003', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      const cacheKey = `${iconId}${bundleName}${moduleName}`;
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      ResourceManager.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data101', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data102', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppAllResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data103', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);
      res = ResourceManager.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      ResourceManager.getInstance().setBundleAppIconCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data105', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = ResourceManager.getInstance().getBundleAppName('');
      expect(res).assertEqual('');
      ResourceManager.getInstance().setBundleAppNameCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data106', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = ResourceManager.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      ResourceManager.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getAppSessionLabelCache_should_return_data107', Level.LEVEL0, (): void => {
      let cacheKey: number = 11;
      let value: string = '文件管理'
      let res: string = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppSessionLabelCache(cacheKey, value);
      res = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().deleteAppSessionLabelCache(cacheKey);
      res = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertNull();
    })

    it('test_ResourceManager2Test_getBundleLabelWithCache108', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getBundleLabelWithCache';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);

      result = 0;
      let tmp = GlobalContext.getInstance().getObject('desktopContext')
      GlobalContext.getInstance().setObject('desktopContext', null);
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      GlobalContext.getInstance().setObject('desktopContext', tmp);
      expect(result).assertEqual(1);

      result = 0;
      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);
    })

    it('test_ResourceManagerTest_getAccountSAState109', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      ResourceManager.getInstance().getAccountSAState().then((success: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('test_ResourceManagerTest_getAppIconWithCache110', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, null, value);
      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      /* 设置测试的数据，模拟可以获取缓存 */
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', 'icon_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'imageDescriptor', 'imageDescriptor_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'adaptiveicon', 'adaptiveicon_value');

      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === 'icon_value') {
          result = 1;
        }
      }, value);
      /* 清理模拟数据 */
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'icon');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'imageDescriptor');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'adaptiveicon');

      expect(result).assertEqual(1);
    })

    it('test_ResourceManager2Test_getAppIconWithCache2', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCache2';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let result = 0;
      let temp = GlobalContext.getInstance().getObject('desktopContext');

      GlobalContext.getInstance().setObject('desktopContext', null);
      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      GlobalContext.getInstance().setObject('desktopContext', temp);
      expect(result).assertEqual(1);
    })

    it('test_ResourceManager2Test_getAppIconWithCacheAsync', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCacheAsync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'

      let ret1 = await ResourceManager.getInstance().getAppIconWithCacheAsync(0, bundleName, moduleName, value);
      expect(ret1).assertEqual(value);

      let ret2 = await ResourceManager.getInstance().getAppIconWithCacheAsync(labelId, bundleName, moduleName, value);
      expect(ret2).assertEqual(value);

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', 'icon_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'adaptiveicon', 'adaptiveicon_value');
      let ret3 = await ResourceManager.getInstance().getAppIconWithCacheAsync(labelId, bundleName, moduleName, value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'icon');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'adaptiveicon');
      expect(ret3).assertEqual('icon_value');

      done();
    })

    it('test_ResourceManager2Test_updateAppNameSync', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_updateAppNameSync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = await ResourceManager.getInstance().updateAppNameSync(labelId, bundleName, moduleName, value);
      expect(result).assertEqual(value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');

      done();
    })

    it('test_ResourceManager2Test_getAppNameSync', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppNameSync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      let result1 = await ResourceManager.getInstance().getAppNameSync(0, bundleName, moduleName, value);
      expect(result1).assertEqual(value);

      let result2 = await ResourceManager.getInstance().getAppNameSync(labelId, bundleName, moduleName, value);
      expect(result2).assertEqual(value);

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      let result3 = await ResourceManager.getInstance().getAppNameSync(labelId, bundleName, moduleName, value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      expect(result3).assertEqual('name_value');

      done();
    })

    it('test_ResourceManager2Test_getAppNameWithCache', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppNameWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      ResourceManager.getInstance().getAppNameWithCache(null, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      });
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, null);
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        result = 1;
      });
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === 'name_value') {
          result = 1;
        }
      });
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      expect(result).assertEqual(1);
    })

    it('test_getWindowWidth_should_return_true', Level.LEVEL0, (): void => {
      let screenW: number = windowManager.getWindowWidth();
      let res: boolean = screenW > 0;
      expect(res).assertTrue();
    })

    it('test_getWindowHeight_should_return_true', Level.LEVEL0, (): void => {
      let screenH: number = windowManager.getWindowHeight();
      let res: boolean = screenH > 0;
      expect(res).assertTrue();
    })

    it('test_isSplitWindowMode', Level.LEVEL0, (): void => {
      expect(windowManager.isSplitWindowMode(100))
        .assertTrue();
      expect(windowManager.isSplitWindowMode(101))
        .assertTrue();
      expect(windowManager.isSplitWindowMode(1))
        .assertFalse();
    })

    it('test_isSplitWindowMode_should_return', Level.LEVEL0, (): void => {
      let res: boolean = windowManager.isSplitWindowMode(100);
      expect(res).assertTrue();
      res = windowManager.isSplitWindowMode(101);
      expect(res).assertTrue();

      res = windowManager.isSplitWindowMode(102);
      expect(res).assertFalse();
    })

    it('test_findWindow_should_return', Level.LEVEL0, (): void => {
      let win1 = getLastWindow();
      windowManager.hideWindowStatusBar('EntryView');
      windowManager.showWindowStatusBar('EntryView');
      windowManager.hideWindowStatusBar(null);
      windowManager.showWindowStatusBar(null);
      let win2 = getLastWindow();
      expect(win1?.isWindowShowing()).assertEqual(win2?.isWindowShowing());
    })

    it('test_hideWindow_should_return', Level.LEVEL0, (): void => {
      let win1 = getLastWindow();
      windowManager.hideWindow(win1?.getWindowProperties().id.toString());
      let win2 = getLastWindow();
      if (win1 && win2) {
        expect(win1?.getWindowProperties().id).not().assertEqual(win2?.getWindowProperties().id);
      } else {
        expect(win2).assertNull();
      }
    })

    it('test_getNumberById_invalid_input_number', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getStringById_should_return_number', Level.LEVEL0, (): void => {
      let radius: number = ResourceManager.getInstance().getNumberByResource($r('app.float.form_corner_radius'));
      let res: boolean = radius >= 0;
      expect(res).assertTrue();
    })

    it('test_getStringByIdSync_should_return_string', Level.LEVEL0, async (done: Function) => {
      let res: string = await ResourceManager.getInstance().getStringByIdSync($r('app.string.uninstall').id);
      expect(res).not().assertNull();

      res = await ResourceManager.getInstance().getStringByIdSync(undefined);
      expect(res).assertEqual('');

      res = await ResourceManager.getInstance().getStringByIdSync(-1);
      expect(res).assertEqual('');

      done();
    })

    it('test_getStringByResource_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getStringByResource($r('app.string.uninstall'));
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightRegular_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data', Level.LEVEL0, (): void => {
      ResourceManager.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      ResourceManager.getInstance().getSCBInnerIcon(SCBConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean', Level.LEVEL0, (): void => {
      let res: boolean = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        '');
      expect(res).assertFalse();

      res = ResourceManager.getInstance().isSCBInnerModule('',
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedIconPixelMapByKey_should_return_data', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      const cacheKey = `${iconId}${bundleName}${moduleName}`;
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getStringByResource_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getStringByResource($r('app.string.uninstall'));
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightRegular_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data', Level.LEVEL0, (): void => {
      ResourceManager.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      ResourceManager.getInstance().getSCBInnerIcon(SCBConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean', Level.LEVEL0, (): void => {
      let res: boolean = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        '');
      expect(res).assertFalse();

      res = ResourceManager.getInstance().isSCBInnerModule('',
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_ResourceManager_Test_getAppNameWithCache', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppNameWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      ResourceManager.getInstance().getAppNameWithCache(null, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      });
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, null);
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        result = 1;
      });
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === 'name_value') {
          result = 1;
        }
      });
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      expect(result).assertEqual(1);
    })

    it('test_getCachedAppIcon_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedIconPixelMapByKey_should_return_data', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      const cacheKey = `${iconId}${bundleName}${moduleName}`;
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      ResourceManager.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppAllResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })


    it('test_clearAppResourceCache_should_return_data201', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data202', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppAllResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data203', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);
      res = ResourceManager.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      ResourceManager.getInstance().setBundleAppIconCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data205', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = ResourceManager.getInstance().getBundleAppName('');
      expect(res).assertEqual('');
      ResourceManager.getInstance().setBundleAppNameCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data206', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = ResourceManager.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      ResourceManager.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getAppSessionLabelCache_should_return_data207', Level.LEVEL0, (): void => {
      let cacheKey: number = 11;
      let value: string = '文件管理'
      let res: string = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppSessionLabelCache(cacheKey, value);
      res = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().deleteAppSessionLabelCache(cacheKey);
      res = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertNull();
    })

    it('test_ResourceManager2Test_getBundleLabelWithCache208', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getBundleLabelWithCache';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);

      result = 0;
      let tmp = GlobalContext.getInstance().getObject('desktopContext')
      GlobalContext.getInstance().setObject('desktopContext', null);
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      GlobalContext.getInstance().setObject('desktopContext', tmp);
      expect(result).assertEqual(1);

      result = 0;
      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);
    })

    it('test_ResourceManagerTest_getAccountSAState209', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      ResourceManager.getInstance().getAccountSAState().then((success: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('test_ResourceManagerTest_getAppIconWithCache210', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, null, value);
      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      /* 设置测试的数据，模拟可以获取缓存 */
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', 'icon_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'imageDescriptor', 'imageDescriptor_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'adaptiveicon', 'adaptiveicon_value');

      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === 'icon_value') {
          result = 1;
        }
      }, value);
      /* 清理模拟数据 */
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'icon');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'imageDescriptor');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'adaptiveicon');

      expect(result).assertEqual(1);
    })

    it('test_getStringById_should_return_string301', Level.LEVEL0, (): void => {
      let name: string = '';
      ResourceManager.getInstance().getStringById($r('app.string.uninstall').id, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      /* 异常数据时查询返回空字符串 */
      ResourceManager.getInstance().getStringById(0, (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string302', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      /* 异常数据时查询返回空字符串 */
      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number303', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getStringById_should_return_number304', Level.LEVEL0, (): void => {
      let radius: number = ResourceManager.getInstance().getNumberByResource($r('app.float.form_corner_radius'));
      let res: boolean = radius >= 0;
      expect(res).assertTrue();
    })

    it('test_getStringByIdSync_should_return_string305', Level.LEVEL0, async (done: Function) => {
      let res: string = await ResourceManager.getInstance().getStringByIdSync($r('app.string.uninstall').id);
      expect(res).not().assertNull();

      res = await ResourceManager.getInstance().getStringByIdSync(undefined);
      expect(res).assertEqual('');

      res = await ResourceManager.getInstance().getStringByIdSync(-1);
      expect(res).assertEqual('');

      done();
    })

    it('test_getStringByResource_should_return_string306', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getStringByResource($r('app.string.uninstall'));
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string307', Level.LEVEL0, async (done: Function) => {
      let name: string = await ResourceManager.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data308', Level.LEVEL0, (): void => {
      ResourceManager.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      ResourceManager.getInstance().getSCBInnerIcon(SCBConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean309', Level.LEVEL0, (): void => {
      let res: boolean = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = ResourceManager.getInstance().isSCBInnerModule(SCBConstants.SCENE_BOARD_PKG,
        '');
      expect(res).assertFalse();

      res = ResourceManager.getInstance().isSCBInnerModule('',
        SCBConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean310', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data311', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data312', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data313', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedIconPixelMapByKey_should_return_data314', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      const cacheKey = `${iconId}${bundleName}${moduleName}`;
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data315', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data316', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data317', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      ResourceManager.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data318', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data319', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data320', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().clearAppAllResourceCache();
      res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data321', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);
      res = ResourceManager.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      ResourceManager.getInstance().setBundleAppIconCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data323', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = ResourceManager.getInstance().getBundleAppName('');
      expect(res).assertEqual('');
      ResourceManager.getInstance().setBundleAppNameCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data324', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = ResourceManager.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      ResourceManager.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getAppSessionLabelCache_should_return_data325', Level.LEVEL0, (): void => {
      let cacheKey: number = 11;
      let value: string = '文件管理'
      let res: string = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertNull();

      ResourceManager.getInstance().setAppSessionLabelCache(cacheKey, value);
      res = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertEqual(value);

      ResourceManager.getInstance().deleteAppSessionLabelCache(cacheKey);
      res = ResourceManager.getInstance().getAppSessionLabelCache(cacheKey) as string;
      expect(res).assertNull();
    })

    it('test_ResourceManager2Test_getBundleLabelWithCache326', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getBundleLabelWithCache';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);

      result = 0;
      let tmp = GlobalContext.getInstance().getObject('desktopContext')
      GlobalContext.getInstance().setObject('desktopContext', null);
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      GlobalContext.getInstance().setObject('desktopContext', tmp);
      expect(result).assertEqual(1);

      result = 0;
      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertEqual(1);
    })

    it('test_ResourceManagerTest_getAccountSAState327', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      ResourceManager.getInstance().getAccountSAState().then((success: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('test_ResourceManagerTest_getAppIconWithCache328', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, null, value);
      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      /* 设置测试的数据，模拟可以获取缓存 */
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', 'icon_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'imageDescriptor', 'imageDescriptor_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'adaptiveicon', 'adaptiveicon_value');

      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === 'icon_value') {
          result = 1;
        }
      }, value);
      /* 清理模拟数据 */
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'icon');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'imageDescriptor');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'adaptiveicon');

      expect(result).assertEqual(1);
    })

    it('test_ResourceManager2Test_getAppIconWithCache329', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCache2';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let result = 0;
      let temp = GlobalContext.getInstance().getObject('desktopContext');

      GlobalContext.getInstance().setObject('desktopContext', null);
      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      GlobalContext.getInstance().setObject('desktopContext', temp);
      expect(result).assertEqual(1);
    })

    it('test_ResourceManager2Test_getAppIconWithCacheAsync330', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCacheAsync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'

      let ret1 = await ResourceManager.getInstance().getAppIconWithCacheAsync(0, bundleName, moduleName, value);
      expect(ret1).assertEqual(value);

      let ret2 = await ResourceManager.getInstance().getAppIconWithCacheAsync(labelId, bundleName, moduleName, value);
      expect(ret2).assertEqual(value);

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', 'icon_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'adaptiveicon', 'adaptiveicon_value');
      let ret3 = await ResourceManager.getInstance().getAppIconWithCacheAsync(labelId, bundleName, moduleName, value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'icon');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'adaptiveicon');
      expect(ret3).assertEqual('icon_value');

      done();
    })

    it('test_ResourceManager2Test_updateAppNameSync332', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_updateAppNameSync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = await ResourceManager.getInstance().updateAppNameSync(labelId, bundleName, moduleName, value);
      expect(result).assertEqual(value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');

      done();
    })

    it('test_ResourceManager2Test_getAppNameSync333', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppNameSync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      let result1 = await ResourceManager.getInstance().getAppNameSync(0, bundleName, moduleName, value);
      expect(result1).assertEqual(value);

      let result2 = await ResourceManager.getInstance().getAppNameSync(labelId, bundleName, moduleName, value);
      expect(result2).assertEqual(value);

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      let result3 = await ResourceManager.getInstance().getAppNameSync(labelId, bundleName, moduleName, value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      expect(result3).assertEqual('name_value');

      done();
    })

    it('test_getCachedAppName_should_return_data', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data002', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await resourceManagerCreateImage();
      let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_ResourceManager2Test_getAppNameWithCache334', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppNameWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      ResourceManager.getInstance().getAppNameWithCache(null, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      });
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, null);
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        result = 1;
      });
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === 'name_value') {
          result = 1;
        }
      });
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      expect(result).assertEqual(1);
    })

    it('test_getWindowWidth_should_return_true335', Level.LEVEL0, (): void => {
      let screenW: number = windowManager.getWindowWidth();
      let res: boolean = screenW > 0;
      expect(res).assertTrue();
    })

    it('test_getWindowHeight_should_return_true336', Level.LEVEL0, (): void => {
      let screenH: number = windowManager.getWindowHeight();
      let res: boolean = screenH > 0;
      expect(res).assertTrue();
    })

    it('test_isSplitWindowMode', Level.LEVEL0, (): void => {
      expect(windowManager.isSplitWindowMode(100))
        .assertTrue();
      expect(windowManager.isSplitWindowMode(101))
        .assertTrue();
      expect(windowManager.isSplitWindowMode(1))
        .assertFalse();
    })

    it('test_getBundleAppIcon_should_return_data337', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);
      res = ResourceManager.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(SCBConstants.DEFAULT_ICON);

      ResourceManager.getInstance().setBundleAppIconCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_calculatePreviewHeight_338', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_339', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getCachedAppCanNotice_should_return_data338', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

    })
  })
}

async function resourceManagerCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}