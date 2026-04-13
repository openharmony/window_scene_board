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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { PageDeskTopViewModel } from '../../../../../../main/ets/TsIndex';
import { StyleConstants } from '../../../../../../../../launchercommon/src/main/ets/TsIndex';
import { CommonConstants } from '../../../../../../../../launchercommon/src/main/ets/TsIndex';

import image from '@ohos.multimedia.image';

export function PageDeskTopViewModelTest() {
  describe('PageDeskTopViewModelTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_PageDeskTopViewModel_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = PageDeskTopViewModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = PageDeskTopViewModel.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('test_getStringByName_should_return_string', Level.LEVEL0, (): void => {
      let name: string = PageDeskTopViewModel.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = PageDeskTopViewModel.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number', Level.LEVEL0, (): void => {
      let res: number = PageDeskTopViewModel.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getSCBInnerString_should_return_string', Level.LEVEL0, (): void => {
      let name: string = '';
      PageDeskTopViewModel.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      PageDeskTopViewModel.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getFontWeightRegular_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data', Level.LEVEL0, (): void => {
      PageDeskTopViewModel.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      PageDeskTopViewModel.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean', Level.LEVEL0, (): void => {
      let res: boolean = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        '');
      expect(res).assertFalse();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule('',
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await PageDeskTopViewModel.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppAllResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      PageDeskTopViewModel.getInstance().setBundleAppIconCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getSCBInnerString_should_return_string02', Level.LEVEL0, (): void => {
      let name: string = '';
      PageDeskTopViewModel.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      PageDeskTopViewModel.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string02', Level.LEVEL0, (): void => {
      let name: string = PageDeskTopViewModel.getInstance().getStringByName('add');
      expect(name).not().assertEqual('');

      name = PageDeskTopViewModel.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number02', Level.LEVEL0, (): void => {
      let res: number = PageDeskTopViewModel.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getFontWeightRegular_should_return_string02', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightRegular();
      expect(name).not().assertNaN();
      done();
    })

    it('test_getFontWeightMedium_should_return_string02', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightMedium();
      expect(name).not().assertNaN();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data02', Level.LEVEL0, (): void => {
      PageDeskTopViewModel.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertFail();
      }, null);

      PageDeskTopViewModel.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean02', Level.LEVEL0, (): void => {
      let res: boolean = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        '');
      expect(res).assertFalse();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule('',
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean02', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await PageDeskTopViewModel.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data02', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data02', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data02', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data02', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data02', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data02', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data02', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data02', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data02', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppAllResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data02', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      PageDeskTopViewModel.getInstance().setBundleAppIconCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data02', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data02', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getSCBInnerString_should_return_string03', Level.LEVEL0, (): void => {
      let name: string = '';
      PageDeskTopViewModel.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      PageDeskTopViewModel.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string03', Level.LEVEL0, (): void => {
      let name: string = PageDeskTopViewModel.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      /* 异常数据时查询返回空字符串 */
      name = PageDeskTopViewModel.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number03', Level.LEVEL0, (): void => {
      let res: number = PageDeskTopViewModel.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getFontWeightRegular_should_return_string03', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string03', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data03', Level.LEVEL0, (): void => {
      PageDeskTopViewModel.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      PageDeskTopViewModel.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean03', Level.LEVEL0, (): void => {
      let res: boolean = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        '');
      expect(res).assertFalse();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule('',
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean03', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await PageDeskTopViewModel.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data03', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data03', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data03', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data03', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data03', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data03', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data03', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data03', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data03', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppAllResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data03', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      PageDeskTopViewModel.getInstance().setBundleAppIconCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data03', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data03', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getSCBInnerString_should_return_string04', Level.LEVEL0, (): void => {
      let name: string = '';
      PageDeskTopViewModel.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      PageDeskTopViewModel.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string04', Level.LEVEL0, (): void => {
      let name: string = PageDeskTopViewModel.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      /* 异常数据时查询返回空字符串 */
      name = PageDeskTopViewModel.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number04', Level.LEVEL0, (): void => {
      let res: number = PageDeskTopViewModel.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getFontWeightRegular_should_return_string04', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string04', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data04', Level.LEVEL0, (): void => {
      PageDeskTopViewModel.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      PageDeskTopViewModel.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean04', Level.LEVEL0, (): void => {
      let res: boolean = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        '');
      expect(res).assertFalse();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule('',
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean04', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await PageDeskTopViewModel.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data04', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data04', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data04', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data04', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data04', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data04', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data04', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data04', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data04', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppAllResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data04', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      PageDeskTopViewModel.getInstance().setBundleAppIconCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data04', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data04', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getSCBInnerString_should_return_string05', Level.LEVEL0, (): void => {
      let name: string = '';
      PageDeskTopViewModel.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      PageDeskTopViewModel.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string05', Level.LEVEL0, (): void => {
      let name: string = PageDeskTopViewModel.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      /* 异常数据时查询返回空字符串 */
      name = PageDeskTopViewModel.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number05', Level.LEVEL0, (): void => {
      let res: number = PageDeskTopViewModel.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getFontWeightRegular_should_return_string05', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string05', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data05', Level.LEVEL0, (): void => {
      PageDeskTopViewModel.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      PageDeskTopViewModel.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean05', Level.LEVEL0, (): void => {
      let res: boolean = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        '');
      expect(res).assertFalse();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule('',
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean05', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await PageDeskTopViewModel.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data05', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data05', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedIconPixelMap_should_return_data05', Level.LEVEL0, async (done: Function) => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedIconPixelMap';
      let moduleName: string = 'moduleTest';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
      done();
    })

    it('test_getCachedCardSnapshot_should_return_data05', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data05', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data05', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_deleteAppResourceCache_should_return_data05', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_deleteAppResourceCache';
      let cacheType: string = 'cacheType_deleteAppResourceCache'
      let value: string = 'value_deleteAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().deleteAppResourceCache(cacheKey, cacheType);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppResourceCache_should_return_data05', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_clearAppAllResourceCache_should_return_data05', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
      let cacheType: string = 'cacheType_clearAppAllResourceCache'
      let value: string = 'value_clearAppAllResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppAllResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppIcon_should_return_data05', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppIcon';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppIcon('');
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(null);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      /* 查询不存在的bundle，还是默认值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

      PageDeskTopViewModel.getInstance().setBundleAppIconCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppIcon(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data05', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data05', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getSCBInnerString_should_return_string06', Level.LEVEL0, (): void => {
      let name: string = '';
      PageDeskTopViewModel.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      PageDeskTopViewModel.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string06', Level.LEVEL0, (): void => {
      let name: string = PageDeskTopViewModel.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      /* 异常数据时查询返回空字符串 */
      name = PageDeskTopViewModel.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number06', Level.LEVEL0, (): void => {
      let res: number = PageDeskTopViewModel.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getFontWeightRegular_should_return_string06', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string06', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data06', Level.LEVEL0, (): void => {
      PageDeskTopViewModel.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      PageDeskTopViewModel.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })


    it('test_isSCBInnerModule_should_return_boolean06', Level.LEVEL0, (): void => {
      let res: boolean = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertTrue();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
        '');
      expect(res).assertFalse();

      res = PageDeskTopViewModel.getInstance().isSCBInnerModule('',
        CommonConstants.NTF_MANAGEMENT_MODULE);
      expect(res).assertFalse();
    })

    it('test_getAccountSAState_should_return_boolean06', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await PageDeskTopViewModel.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data06', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data06', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedCardSnapshot_should_return_data06', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data06', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data06', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_clearAppResourceCache_should_return_data06', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppName_should_return_data06', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data06', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getAccountSAState_should_return_boolean07', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await PageDeskTopViewModel.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('test_getCachedAppIcon_should_return_data07', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedAppName_should_return_data07', Level.LEVEL0, (): void => {
      let labelId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppName';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'name', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppName(labelId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedCardSnapshot_should_return_data07', Level.LEVEL0, async (done: Function) => {
      let bundleName: string = 'bundleTest_getCachedCardSnapshot';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
      res = PageDeskTopViewModel.getInstance().getCachedCardSnapshot(bundleName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_getCachedAppCanNotice_should_return_data07', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppCanNotice';
      let moduleName: string = 'moduleTest';
      let value: string = "valueTest";
      let res: string = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
      res = PageDeskTopViewModel.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('test_getCachedEffectKit_should_return_data07', Level.LEVEL0, async (done: Function) => {
      let appIconId: number = 0;
      let abilityName: string = 'bundleTest_getCachedEffectKit';
      let value: image.PixelMap = await PageDeskTopViewModelCreateImage();
      let res: image.PixelMap = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setEffectKitCache(appIconId, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getCachedEffectKit(appIconId, abilityName);
      expect(res).assertEqual(value);

      done();
    })

    it('test_clearAppResourceCache_should_return_data07', Level.LEVEL0, (): void => {
      let cacheKey: string = 'cacheKey_clearAppResourceCache';
      let cacheType: string = 'cacheType_clearAppResourceCache'
      let value: string = 'value_clearAppResourceCache'
      let res: string = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();

      PageDeskTopViewModel.getInstance().setAppResourceCache(cacheKey, cacheType, value);
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertEqual(value);

      PageDeskTopViewModel.getInstance().clearAppResourceCache();
      res = PageDeskTopViewModel.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
      expect(res).assertNull();
    })

    it('test_getBundleAppName_should_return_data07', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data07', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getBundleAppName_should_return_data08', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getBundleAppName';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getBundleAppName(null);
      expect(res).assertNull();
      res = PageDeskTopViewModel.getInstance().getBundleAppName('');
      expect(res).assertEqual('');

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setBundleAppNameCache(bundleName, value);
      res = PageDeskTopViewModel.getInstance().getBundleAppName(bundleName);
      expect(res).assertEqual(value);
    })

    it('test_getAbilityAppName_should_return_data08', Level.LEVEL0, (): void => {
      let bundleName: string = 'bundleTest_getAbilityAppName';
      let moduleName: string = 'moduleTest';
      let abilityName: string = 'abilityTest';
      let value: string = 'valueTest';
      let res: string = PageDeskTopViewModel.getInstance().getAbilityAppName(null, null, null);
      expect(res).assertEqual(null);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName('', moduleName, abilityName);
      expect(res).assertEqual('');
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, '', abilityName);
      expect(res).assertEqual(bundleName);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, '');
      expect(res).assertEqual(bundleName);

      /* 查询不存在的bundle，还是原始值 */
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(bundleName);

      PageDeskTopViewModel.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
      res = PageDeskTopViewModel.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
      expect(res).assertEqual(value);
    })

    it('test_getSCBInnerString_should_return_string08', Level.LEVEL0, (): void => {
      let name: string = '';
      PageDeskTopViewModel.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
        name = value;
        expect(name).not().assertEqual('');
      });

      PageDeskTopViewModel.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('test_getStringByName_should_return_string08', Level.LEVEL0, (): void => {
      let name: string = PageDeskTopViewModel.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      /* 异常数据时查询返回空字符串 */
      name = PageDeskTopViewModel.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('test_getNumberById_invalid_input_number08', Level.LEVEL0, (): void => {
      let res: number = PageDeskTopViewModel.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('test_getFontWeightRegular_should_return_string08', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightRegular();
      expect(name).not().assertNull();
      done();
    })

    it('test_getFontWeightMedium_should_return_string08', Level.LEVEL0, async (done: Function) => {
      let name: string = await PageDeskTopViewModel.getInstance().getFontWeightMedium();
      expect(name).not().assertNull();
      done();
    })

    it('test_getSCBInnerIcon_should_return_data08', Level.LEVEL0, (): void => {
      PageDeskTopViewModel.getInstance().getSCBInnerIcon('', (image: Resource): void => {
        expect(image).assertNull();
      }, null);

      PageDeskTopViewModel.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
        expect(image).not().assertNull();
      }, null);
    })
  })
}

async function PageDeskTopViewModelCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}