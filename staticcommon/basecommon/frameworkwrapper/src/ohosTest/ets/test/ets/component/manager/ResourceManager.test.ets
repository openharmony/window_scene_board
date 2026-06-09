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
import { ResourceManager } from '../../../../../../main/ets/TsIndex';
import { SCBConstants } from '@ohos/commonconstants';


import image from '@ohos.multimedia.image';

export function ResourceManagerTest() {
  describe('ResourceManagerTest', (): void => {
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

    it('test_getCachedIconPixelMapByKey_should_return_data_02', Level.LEVEL0, async (done: Function) => {
      try {
        let iconId: number = 0;
        let bundleName: string = 'bundleTest_getCachedIconPixelMap';
        let moduleName: string = 'moduleTest';
        let value: image.PixelMap = await resourceManagerCreateImage();
        const cacheKey = `${iconId}${bundleName}${moduleName}`;
        let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
        ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
        res = ResourceManager.getInstance().getCachedIconPixelMapByKey(cacheKey);
        expect(cacheKey).assertInstanceOf('String');
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
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

    it('test_getBundleAppIcon_should_return_data', Level.LEVEL0, (): void => {
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

    it('test_getBundleAppName_should_return_data', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = ResourceManager.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = ResourceManager.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      /* 查询不存在的bundle，还是原始值 */
      res = ResourceManager.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      ResourceManager.getInstance().setBundleAppNameCache(bundleName, value);
      res = ResourceManager.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data', Level.LEVEL0, (): void => {
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

      /* 查询不存在的bundle，还是原始值 */
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      ResourceManager.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
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