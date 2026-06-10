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
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import { IconExtendParam } from '../../../../../../../main/ets/resourcemanager/IconExtendParam';
import IconInfo, { IconPicType } from '../../../../../../../main/ets/resourcemanager/IconInfo';
import { bundleManagerFwk, dbCache, GlobalContext } from '../../../../../../../main/ets/TsIndex';

export function DbCacheTest() {
  const bundleName = 'com.ohos.photos';
  const moduleName = 'phone_photos';
  const abilityName = 'com.ohos.photos.MainAbility';
  const iconInfo = new IconInfo();
  iconInfo.combinePic = 'combinePic';
  iconInfo.adaptivePic = ['backPic', 'forePic'];
  iconInfo.iconType = IconPicType.ADAPTIVE;

  describe('DbCacheTest', () => {
    beforeAll((): void => {
      let tmp = GlobalContext.getInstance().getObject('desktopContext');
      GlobalContext.getInstance().setObject('desktopContext', tmp);
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('getCombIcon_return_empty_string', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      const result = await dbCache.getCombIcon('bundleName', 'moduleName', 'abilityName', param);
      expect(result).assertInstanceOf('IconInfo');
      done();
    });

    it('getCombIcon_return_icon', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      await dbCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      const result = await dbCache.getCombIcon(bundleName, moduleName, abilityName, param);
      expect(result).assertInstanceOf('IconInfo');
      done();
    });

    it('getIconResource_return_empty_string', 0, async (done: Function) => {
      const result = await dbCache.getIconResource('bundleName', 'moduleName', 'abilityName');
      expect(result.iconType).assertEqual(IconPicType.NONE);
      done();
    });

    it('setIconResource_return_Undefined', 0, async (done: Function) => {
      await dbCache.deleteCache(bundleName);
      let param: IconExtendParam = new IconExtendParam();
      await dbCache.setIconResource('', moduleName, abilityName, iconInfo, param);
      let info = await dbCache.getCombIcon(bundleName, moduleName, abilityName, param);
      expect(info).assertInstanceOf('IconInfo'); //dbcache delete failed
      done();
    });

    it('rdbRestore', 0, async (done: Function) => {
      let tmp = GlobalContext.getInstance().getObject('desktopContext');
      GlobalContext.getInstance().setObject('desktopContext', null);
      const result = await dbCache.getIconResource(bundleName, moduleName, abilityName);
      expect(result.iconType).assertEqual(IconPicType.NONE);
      GlobalContext.getInstance().setObject('desktopContext', tmp);
      const result1 = await dbCache.getIconResource(bundleName, moduleName, abilityName);
      let param: IconExtendParam = new IconExtendParam();
      const result2 = await bundleManagerFwk.getIconResourceFromFwk(param, bundleName, moduleName, moduleName);
      expect(result1.combinePic).assertEqual('');
      done();
    });

    it('deleteAllCache', 0, async (done: Function) => {
      await dbCache.deleteAllCache();
      expect(GlobalContext.getInstance()).not().assertNull();
      done();
    });

    it('deleteCache', 0, async (done: Function) => {
      let res = await dbCache.deleteCache('');
      expect(typeof res === 'undefined').assertTrue();
      done();
    });

    it('DbCacheTest_getCombIcon_001', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      param.appIndex = 1;
      let info = await dbCache.getCombIcon(bundleName, moduleName, abilityName, param);
      expect(info).not().assertNull();
      done();
    });

    it('DbCacheTest_getCombIcon_002', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      let info = await dbCache.getCombIcon(bundleName, null, null, param);
      expect(info).not().assertNull();
      done();
    });

    it('DbCacheTest_getCombIconSync_003', 0, (): void => {
      let info = dbCache.getCombIconSync(bundleName, moduleName, abilityName, 1);
      expect(info).assertEqual(undefined);
    });

    it('DbCacheTest_getIconResource_004', 0, async (done: Function) => {
      const result = await dbCache.getIconResource('bundleName', 'moduleName', 'abilityName', 1);
      expect(result).assertEqual(undefined);
      done();
    });

    it('DbCacheTest_getIconResource_005', 0, async (done: Function) => {
      const result = await dbCache.getIconResource('bundleName', null, null);
      expect(result).not().assertNull();
      done();
    });

    it('DbCacheTest_setIconResource_006', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      param.appIndex = 1;
      const result = await dbCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      expect(result == null).assertTrue();
      done();
    });

    it('DbCacheTest_setIconResource_007', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      const result = await dbCache.setIconResource(bundleName, null, null, iconInfo, param);
      expect(result == null).assertTrue();
      done();
    });

    it('DbCacheTest_getVersionByBundleName_008', 0, async (done: Function) => {
      const result: String = await (dbCache as object)['getVersionByBundleName'](bundleName);
      expect(result.length >= 0).assertTrue();
      done();
    });

    it('DbCacheTest_getAndSetIcon_009', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = true;
      let info = await dbCache.getCombIcon(bundleName, '', '', param);
      await dbCache.setIconResource(bundleName, '', '', info, param);
      expect(info).not().assertNull();
      done();
    });

    it('DbCacheTest_getIconByBundles_010', 0, async (done: Function) => {
      let bundles: Array<string> = ['com.ohos.photos', 'com.ohos.mms'];
      let res = await dbCache.getIconByBundles(bundles);
      expect(res.length === 2).assertTrue();
      done();
    });

    it('DbCacheTest_getIconByBundles_011', 0, async (done: Function) => {
      let bundles: Array<string> = ['com.ohos.photos', 'com.ohos.mms'];
      let res = await dbCache.getIconByBundles(bundles, true);
      expect(res.length >= 0).assertTrue();
      done();
    });

  });
}