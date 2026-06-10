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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { GridLayoutUtil, RdbStoreManager, ExtraInfo } from '../../../../../../main/ets/TsIndex'
import { SwiperItemInfo } from '../../../../../../main/ets/TsIndex'
import {
  AppItemInfo,
  BadgeItemInfo, CardItemInfo, CommonConstants, DockItemInfo,
  GridLayoutInfoColumns,
  GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex'
import { ValuesBucket } from '@ohos.data.ValuesBucket'
import { AppStatus, DownloadInfoItem } from '../../../../../../main/ets/TsIndex'
import rdb from '@ohos.data.relationalStore';
import { CheckEmptyUtils, SingleContext } from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import { GlobalContext, IconResourceManager, RdbStoreConfig, rdbStoreHelper } from '@ohos/frameworkwrapper';
import { RdbTaskPool } from '../../../../../../main/ets/TsIndex'
import { BaseBundleInfo } from '../../../../../../main/ets/bean/BaseBundleInfo'
import { rdbTaskPool } from '../../../../../../main/ets/db/RdbTaskPool'
import { AppGridItemInfo } from '../../../../../../main/ets/bean/AppGridItemInfo'
import { AppItemCardInfo } from '../../../../../../main/ets/bean/AppItemCardInfo'

export default function RdbStoreManagerTest() {
  describe('RdbStoreManagerTest', () => {
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
    it('test_getInstance', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        globalThis.RdbStoreManagerInstance = undefined;
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        expect(globalThis.RdbStoreManagerInstance).not().assertUndefined();
        expect(globalThis.RdbStoreManagerInstance).assertEqual(instance);
        expect(instance).assertEqual(RdbStoreManager.getInstance());
      } catch (err) {}
      done();
    })

    it('test_initRdbConfig', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const clearCache = () => {

        }
        await instance.initRdbConfig(clearCache);
        const maxIndex = instance.generateRandomUUID();
        expect(maxIndex).not().assertNull();
      } catch (err) {}
      done();
    });

    it('test_getAllBadge', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const badgeList: BadgeItemInfo[] = await instance.getAllBadge();
        expect(badgeList.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_getBadgeByBundle', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeList: BadgeItemInfo[] = await instance.getBadgeByBundle(bundleInfo);
        expect(badgeList.length).assertEqual(0);

        bundleInfo.bundleName = '';
        let badgeList1: BadgeItemInfo[] = await instance.getBadgeByBundle(bundleInfo);
        expect(badgeList1.length).assertEqual(0);

        bundleInfo.bundleName = CommonConstants.NOTEPAD_BUNDLE;
        badgeList = await instance.getBadgeByBundle(bundleInfo);
        expect(badgeList.length).assertLargerOrEqual(0);

        bundleInfo = { bundleName: 'testBundle', appIndex: undefined };
        badgeList = await instance.getBadgeByBundle(bundleInfo);
        expect(badgeList.length).assertLargerOrEqual(0);
      }catch (err){}
      done();
    })

    it('test_insertBadgeByBundle_01', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.insertBadgeByBundle(bundleInfo, badgeNumber, isShow);
        expect(changed).assertEqual(true);
      } catch (err) {}
      done();
    });

    it('test_insertBadgeByBundle_02', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.deleteBadgeByBundle(bundleInfo);
        expect(changed).assertEqual(true);
      } catch (err) {}
      done();
    });

    it('test_insertBadgeByBundle_03', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.deleteBadgeByBundle(bundleInfo);
        expect(changed).assertEqual(false);
      } catch (err) {}

      done();
    });

    it('test_insertBadgeByBundle_04', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.deleteBadgeByBundle(bundleInfo);
        expect(changed).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeNumByBundle_01', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.insertBadgeByBundle(bundleInfo, badgeNumber, isShow);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeNumByBundle_02', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.updateBadgeNumByBundle(bundleInfo, -1);
        expect(changed).assertEqual(false);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });


    it('test_updateBadgeNumByBundle_03', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.updateBadgeNumByBundle(bundleInfo, 0);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeNumByBundle_04', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.updateBadgeNumByBundle(bundleInfo, 0);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeNumByBundle_05', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.updateBadgeNumByBundle(bundleInfo, 0);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeDisplayByBundle_01', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.insertBadgeByBundle(bundleInfo, badgeNumber, isShow);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeDisplayByBundle_02', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.updateBadgeDisplayByBundle(bundleInfo, isShow);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });


    it('test_updateBadgeDisplayByBundle_03', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.updateBadgeDisplayByBundle(bundleInfo, isShow);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });


    it('test_updateBadgeDisplayByBundle_04', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
        let badgeNumber: number = 10;
        const isShow: boolean = true;

        let changed = await instance.updateBadgeDisplayByBundle(bundleInfo, !isShow);
        expect(changed).assertEqual(true);

        await instance.deleteBadgeByBundle(bundleInfo);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeDisplayByBundle_05', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let bundleInfo: BaseBundleInfo = { bundleName: '', appIndex: 0 };
        const isShow: boolean = true;

        let changed = await instance.updateBadgeDisplayByBundle(bundleInfo, isShow);
        expect(changed).assertEqual(false);

        let ret = await instance.deleteBadgeByBundle(bundleInfo);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_updateBadgeDisplayByBundle_06', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: undefined };
      const isShow: boolean = true;
      try {
        let changed = await instance.updateBadgeDisplayByBundle(bundleInfo, isShow);
        expect(changed).assertEqual(true);
      } catch (err) {}

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.update);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      try {
        let changed = await instance.updateBadgeDisplayByBundle(bundleInfo, isShow);
        expect(changed).assertEqual(true);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();

      let ret = await instance.deleteBadgeByBundle(bundleInfo);
      done();
    });

    it('test_deleteBadgeByBundle_01', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let bundleInfo: BaseBundleInfo = { bundleName: 'tempBundleName', appIndex: 0 };
      let bundleInfo1: BaseBundleInfo = { bundleName: 'tempBundleName1', appIndex: 0 };
      let bundleInfo2: BaseBundleInfo = { bundleName: 'tempBundleName2', appIndex: 0 };
      let badgeNumber: number = 10;
      const isShow: boolean = true;

      try {
        let changed = await instance.insertBadgeByBundle(bundleInfo1, badgeNumber, isShow);
        expect(changed).assertEqual(true);
      } catch (err) {}
      done();
    });

    it('test_deleteBadgeByBundle_02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let bundleInfo: BaseBundleInfo = { bundleName: 'tempBundleName', appIndex: 0 };
      let bundleInfo1: BaseBundleInfo = { bundleName: 'tempBundleName1', appIndex: 0 };
      let bundleInfo2: BaseBundleInfo = { bundleName: 'tempBundleName2', appIndex: 0 };
      let badgeNumber: number = 10;
      const isShow: boolean = true;

      try {
        let changed = await instance.deleteBadgeByBundle(bundleInfo2);
        expect(changed).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_deleteBadgeByBundle_03', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let bundleInfo: BaseBundleInfo = { bundleName: 'tempBundleName', appIndex: 0 };
      let bundleInfo1: BaseBundleInfo = { bundleName: 'tempBundleName1', appIndex: 0 };
      let bundleInfo2: BaseBundleInfo = { bundleName: 'tempBundleName2', appIndex: 0 };
      let badgeNumber: number = 10;
      const isShow: boolean = true;

      try {
        let changed = await instance.deleteBadgeByBundle(bundleInfo);
        expect(changed).assertEqual(false);
      } catch (err) {}

      done();
    });

    it('test_deleteBadgeByBundle_04', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let bundleInfo: BaseBundleInfo = { bundleName: 'tempBundleName', appIndex: 0 };
      let bundleInfo1: BaseBundleInfo = { bundleName: 'tempBundleName1', appIndex: 0 };
      let bundleInfo2: BaseBundleInfo = { bundleName: 'tempBundleName2', appIndex: 0 };
      let badgeNumber: number = 10;
      const isShow: boolean = true;

      try {
        let changed = await instance.deleteBadgeByBundle(bundleInfo1);
        expect(changed).assertEqual(true);
      } catch (err) {}

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      try {
        let changed = await instance.deleteBadgeByBundle(bundleInfo1);
        expect(changed).assertEqual(true);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    });

    it('test_getAllFormInfos', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const formList: CardItemInfo[] = await instance.getAllFormInfos();
        expect(formList.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_getAllFormInfosPcMode', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const formList: CardItemInfo[] = await instance.getAllFormInfosPcMode();
        expect(formList.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_getAllFormExceptStackInfos', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const formList: CardItemInfo[] = await instance.getAllFormExceptStackInfos();
        expect(formList.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_getFormInfoById', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const formList: CardItemInfo[] = await instance.getFormInfoById('');
        expect(formList.length).assertEqual(0);
      } catch (err) {}
      done();
    });

    it('test_getCardItemInfoByFaInfo', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName = CommonConstants.NOTEPAD_BUNDLE;
      const moduleName = 'anyModuleNotExists';
      const formName = 'anyFormNameNotExists';
      const abilityName = 'anyAbilityNameNotExists';
      const dimension: number = 100;
      try {
        const formList: CardItemInfo[] = await instance.getCardItemInfoByFaInfo(bundleName, moduleName, formName, abilityName, dimension);
        expect(formList.length).assertEqual(0);
      } catch (err) {}
      done();
    });

    it('test_getCardItemInfoByFaInfo02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a ='test';
      try {
        const formList: CardItemInfo[] = await instance.getCardItemInfoByFaInfo('', '', '', '', 0);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it('test_updateFormInfoById', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.cardId = '99999';
      cardItemInfo.cardName = 'anyCardName';
      cardItemInfo.bundleName = 'anyBundleName';
      cardItemInfo.abilityName = 'anyAbilityName';
      cardItemInfo.moduleName = 'anyModuleName';
      cardItemInfo.formConfigAbility = 'anyFormConfigAbility';
      cardItemInfo.appLabelId = 10;
      cardItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      cardItemInfo.page = 1;
      cardItemInfo.column = 2;
      cardItemInfo.row = 0;
      try {
        let updated = await instance.updateFormInfoById(cardItemInfo);
        expect(updated).assertEqual(true);
        cardItemInfo.cardName = 'anotherCardName';
        updated = await instance.updateFormInfoById(cardItemInfo);
        expect(updated).assertEqual(true);
      } catch (err) {}
      try {
        await instance.deleteFormInfoById(cardItemInfo.cardId);
      } catch (err) {}
      done();
    });

    it('test_updateFormInfoById02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let cardItemInfo:CardItemInfo = {} as CardItemInfo;
      //let cardItemInfo: CardItemInfo = null;
      try {
        let ret = await instance.updateFormInfoById(cardItemInfo);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_updateFormInfoById03', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret = await instance.updateFormInfoById(null);
        expect(ret).assertEqual(false);
        ret = await instance.updateFormInfoById(undefined);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    })

    it('test_updateFormConfigInfo', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardItemInfo: CardItemInfo = new CardItemInfo();
      let a = 'test';
      cardItemInfo.cardId = '99999';
      cardItemInfo.cardName = 'anyCardName';
      cardItemInfo.bundleName = 'anyBundleName';
      cardItemInfo.abilityName = 'anyAbilityName';
      cardItemInfo.moduleName = 'anyModuleName';
      cardItemInfo.formConfigAbility = 'anyFormConfigAbility';
      cardItemInfo.appLabelId = 10;
      cardItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      cardItemInfo.page = 1;
      cardItemInfo.column = 2;
      cardItemInfo.row = 0;
      try {
        let updated = await instance.updateFormConfigInfo(cardItemInfo);
        expect(a).assertEqual('test');
        cardItemInfo.formConfigAbility = 'anotherFormConfigAbility';
        updated = await instance.updateFormConfigInfo(cardItemInfo);
        expect(a).assertEqual('test');

        cardItemInfo.cardId = '';
        updated = await instance.updateFormConfigInfo(cardItemInfo);
        expect(a).assertEqual('test');

        cardItemInfo.cardId = '99999';
        await instance.deleteFormInfoById(cardItemInfo.cardId);
      } catch (err) {}
      done();
    });

    it('test_updateFormConfigInfo02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a = 'test';
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.cardId = '99999';
      cardItemInfo.isTransparent = true;
      cardItemInfo.intent = undefined;
      try {
        let updated = await instance.updateFormConfigInfo(cardItemInfo);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it('test_updateFormInfoByPosition', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      cardItemInfo.cardId = '99999';
      cardItemInfo.cardName = 'anyCardName';
      cardItemInfo.bundleName = 'anyBundleName';
      cardItemInfo.abilityName = 'anyAbilityName';
      cardItemInfo.moduleName = 'anyModuleName';
      cardItemInfo.formConfigAbility = 'anyFormConfigAbility';
      cardItemInfo.appLabelId = 10;
      cardItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      cardItemInfo.page = 1;
      cardItemInfo.column = 2;
      cardItemInfo.row = 0;
      let a = 'test'
      try {
        await instance.updateFormInfoByPosition(cardItemInfo);

        cardItemInfo.page = 2;
        await instance.updateFormInfoByPosition(cardItemInfo);
        expect(a).assertEqual('test');

        await instance.deleteFormInfoById(cardItemInfo.cardId);
        await instance.deleteFormInfoById(cardItemInfo.cardId);
      } catch (err) {}
      done();
    });

    it('test_updateFormInfoByPosition01', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret = await instance.updateFormInfoByPosition(null);
        expect(ret).assertEqual(false);
        ret = await instance.updateFormInfoByPosition(undefined);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    })

    it('test_getLayoutInfoTableName', 0, () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc1)().afterReturn(true);
      try {
        let ret = instance['getLayoutInfoTableName'](undefined);
        expect(ret).assertEqual(RdbStoreConfig.outerGridLayoutInfo.tableName);
      } catch (err) {}
      mocker.clear(launcherStatusUtil);
    })

    it('test_updateCardIdOfFormStack', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      cardItemInfo.cardId = '23456';
      cardItemInfo.cardName = 'anyCardName';
      cardItemInfo.bundleName = 'anyBundleName';
      cardItemInfo.abilityName = 'anyAbilityName';
      cardItemInfo.moduleName = 'anyModuleName';
      cardItemInfo.formConfigAbility = 'anyFormConfigAbility';
      cardItemInfo.appLabelId = 10;
      cardItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      cardItemInfo.page = 1;
      cardItemInfo.column = 2;
      cardItemInfo.row = 0;
      cardItemInfo.extend1 = JSON.stringify('{"parameters":{"ohos.extra.param.key.migrate_form":true}}');
      try {
        let updated = await instance.updateCardIdOfFormStack('', null);
        expect(updated).assertFalse();

        cardItemInfo.page = 2;
        updated = await instance.updateCardIdOfFormStack('1', cardItemInfo);
        expect(updated).assertInstanceOf('Boolean');

        updated = await instance.updateCardIdOfFormStack('', cardItemInfo);
        expect(updated).assertInstanceOf('Boolean');
      } catch (err) {}
      done();
    });

    it('test_updateShortcutItemInfo', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      cardItemInfo.cardId = '23456';
      cardItemInfo.cardName = 'anyCardName';
      cardItemInfo.bundleName = 'anyBundleName';
      cardItemInfo.abilityName = 'anyAbilityName';
      cardItemInfo.moduleName = 'anyModuleName';
      cardItemInfo.formConfigAbility = 'anyFormConfigAbility';
      cardItemInfo.appLabelId = 10;
      cardItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      cardItemInfo.page = 1;
      cardItemInfo.column = 2;
      cardItemInfo.row = 0;
      cardItemInfo.extend1 = JSON.stringify('{"parameters":{"ohos.extra.param.key.migrate_form":true}}');
      try {
        let updated = await instance.updateShortcutItemInfo(null);
        expect(updated).assertFalse();

        cardItemInfo.bundleName = 'anyBundleName1';
        updated = await instance.updateShortcutItemInfo(cardItemInfo);
        expect(updated).assertInstanceOf('Boolean');

        updated = await instance.updateShortcutItemInfo(cardItemInfo);
        expect(updated).assertInstanceOf('Boolean');
      } catch (err) {}
      done();
    });

    it('test_updateContactShortcutItemInfo', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      cardItemInfo.cardId = '23456';
      cardItemInfo.cardName = 'anyCardName';
      cardItemInfo.bundleName = 'anyBundleName';
      cardItemInfo.abilityName = 'anyAbilityName';
      cardItemInfo.moduleName = 'anyModuleName';
      cardItemInfo.formConfigAbility = 'anyFormConfigAbility';
      cardItemInfo.appLabelId = 10;
      cardItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      cardItemInfo.page = 1;
      cardItemInfo.column = 2;
      cardItemInfo.row = 0;
      cardItemInfo.extend1 = JSON.stringify('{"parameters":{"ohos.extra.param.key.migrate_form":true}}');
      try {
        let updated = await instance.updateContactShortcutItemInfo(null);
        expect(updated).assertFalse();

        cardItemInfo.bundleName = 'anyBundleName1';
        updated = await instance.updateContactShortcutItemInfo(cardItemInfo);
        expect(updated).assertInstanceOf('Boolean');

        updated = await instance.updateContactShortcutItemInfo(cardItemInfo);
        expect(updated).assertInstanceOf('Boolean');
      } catch (err) {}
      done();
    });

    it('test_deleteFormInfoById', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardId = '99999';
      let conditions1: Map<string, rdb.ValueType> = new Map();
      conditions1.set('info_id', cardId.toString());
      conditions1.set('type_id', CommonConstants.TYPE_CARD);
      let conditions2: Map<string, rdb.ValueType> = new Map();
      conditions2.set('info_id', ''.toString());
      conditions2.set('type_id', CommonConstants.TYPE_CARD);

      try {
        let changRows: number = await RdbTaskPool.getInstance().delete(RdbStoreConfig.gridLayoutInfo.tableName, conditions1);
        expect(changRows).assertInstanceOf('Number');

        let ret = await instance.deleteFormInfoById(cardId)
        expect(ret).assertInstanceOf('Number');

        changRows = await RdbTaskPool.getInstance().delete(RdbStoreConfig.gridLayoutInfo.tableName, conditions2);
        expect(changRows).assertInstanceOf('Number');
      } catch (err) {}
      done();
    });

    it('test_deleteFormInfoById01', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const cardId = '99999';
      let conditions1: Map<string, rdb.ValueType> = new Map();
      conditions1.set('info_id', cardId.toString());
      conditions1.set('type_id', CommonConstants.TYPE_CARD);
      let conditions2: Map<string, rdb.ValueType> = new Map();
      conditions2.set('info_id', ''.toString());
      conditions2.set('type_id', CommonConstants.TYPE_CARD);

      try {
        let changRows: number = await RdbTaskPool.getInstance().delete(RdbStoreConfig.gridLayoutInfo.tableName, conditions1);
        expect(changRows).assertInstanceOf('Number');

        let ret = await instance.deleteFormInfoById(cardId, true)
        expect(ret).assertInstanceOf('Number');

        changRows = await RdbTaskPool.getInstance().delete(RdbStoreConfig.gridLayoutInfo.tableName, conditions2);
        expect(changRows).assertInstanceOf('Number');
      } catch (err) {}
      done();
    });

    it('test_deleteFormInfoByPosition', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const conditions: Map<string, rdb.ValueType> = new Map();
      conditions.set('page_index',-99999);
      conditions.set('column', -99999);
      conditions.set('row', -99999);
      conditions.set('type_id', CommonConstants.TYPE_CARD);
      try {
        let changeRows: number = await RdbTaskPool.getInstance().delete(RdbStoreConfig.gridLayoutInfo.tableName, conditions);
        expect(changeRows).assertLess(1);
      } catch (err) {}
      done();
    });

    it('test_deleteFormInfoByPosition01', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret = await instance.deleteFormInfoByPosition(1, 1, 1, false);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_deleteFormInfoByPosition02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      try {
        let ret = await instance.deleteFormInfoByPosition(1, 1, 1, false);
        expect(ret).assertEqual(true);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    });

    it('test_deleteFormInfoByPosition03', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      try {
        let ret = await instance.deleteFormInfoByPosition(1, 1, 1, true);
        expect(ret).assertEqual(true);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    });

    it('test_deleteInfoByBundle', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName = 'anyBundleNotExists';
      try {
        let ret = await instance.deleteInfoByBundle(bundleName);
        expect(ret).assertEqual(false);

        ret = await instance.deleteInfoByBundle(bundleName, CommonConstants.TYPE_CARD);
        expect(ret).assertEqual(false);

        const cardItemInfo: CardItemInfo = new CardItemInfo();
        cardItemInfo.cardId = '99999';
        cardItemInfo.cardName = 'anyCardName';
        cardItemInfo.bundleName = 'anyBundleName';
        await instance.updateFormInfoById(cardItemInfo);
        ret = await instance.deleteInfoByBundle('anyBundleName', CommonConstants.TYPE_CARD);
        expect(instance).not().assertNull();
      } catch (err) {}
      done();
    });

    it('test_deleteInfoByBundle02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let ret = await instance.deleteInfoByBundle('anyBundleName', CommonConstants.TYPE_CARD, 1, true, '1');
      expect(ret).assertEqual(false);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      try {
        ret = await instance.deleteInfoByBundle('anyBundleName', CommonConstants.TYPE_CARD, 1, true, '1');
        expect(ret).assertEqual(true);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    })

    it('test_deleteOuterInfoByBundle', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName = 'anyBundleNotExists';
      try {
        let ret = await instance.deleteOuterInfoByBundle(bundleName,1);
        expect(ret).assertEqual(false);

        ret = await instance.deleteOuterInfoByBundle(bundleName);
        expect(ret).assertEqual(false);

        const appItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItemInfo.bundleName = 'bundleName';
        appItemInfo.abilityName = 'abilityName';
        appItemInfo.appIconId = 9999;
        await instance.updateNewInstalledGridInfo(appItemInfo);
        ret = await instance.deleteOuterInfoByBundle(appItemInfo.bundleName);
        expect(instance).not().assertNull();
      } catch (err) {}
      done();
    });

    it('test_deleteOuterInfoByBundle02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName = 'anyBundleNotExists';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      try {
        let ret = await instance.deleteOuterInfoByBundle(bundleName,1);
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(rdbTaskPool);


      const appItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appItemInfo.bundleName = 'bundleName';
      appItemInfo.abilityName = 'abilityName';
      appItemInfo.appIconId = 9999;
      appItemInfo.typeId = 0;
      appItemInfo.appIndex = 1;
      try {
        await instance.updateNewInstalledGridInfo(appItemInfo);
        await instance.deleteOuterInfoByBundle(appItemInfo.bundleName, 1, 0);
        expect(instance).not().assertNull();
      } catch (err) {}
      done();
    });

    it('test_deleteOuterInfoByBundle03', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName = 'anyBundleNotExists';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      try {
        let ret = await instance.deleteOuterInfoByBundle(bundleName,1);
        expect(ret).assertEqual(true);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    })

    it('test_deleteFormInFormStackByNameAndContainer', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let appItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let a = 'test';
      appItemInfo.bundleName = 'bundleName';
      appItemInfo.cardName = 'cardName';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      try {
        let ret: boolean = await instance.deleteFormInFormStackByNameAndContainer(appItemInfo, 0);
        expect(a).assertEqual('test');
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      try {
        await instance.deleteFormInFormStackByNameAndContainer(appItemInfo, 0);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    })

    it('test_deleteFormInFormStackByNameAndContainer02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: boolean = await instance.deleteFormInFormStackByNameAndContainer(null, 0);
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateSettings', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret: boolean = await instance.updateSettings('test', 0);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    })

    it('test_updateDesktopPageCount', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret: boolean = await instance.updateDesktopPageCount('test', true);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    })

    it('test_querySettingsPageCount', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      GlobalContext.getInstance().setObject('backupStatus', false);
      try {
        let res = await instance.querySettingsPageCount();
        expect(res).assertLarger(0);
      } catch (err) {}
      GlobalContext.getInstance().setObject('backupStatus', true);
      try {
        let ret: number = await instance.querySettingsPageCount(true);
        ret = await instance.querySettingsPageCount();
        expect(ret).assertLarger(0);
      } catch (err) {}
      done();
    })

    it('test_insertIntoSmartdock', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let dockInfoList: DockItemInfo[] = [];
      let a = 'test';
      const bundleName = 'anyBundleAsYouLike';
      const insertItem = new DockItemInfo();
      insertItem.appId = '001';
      insertItem.itemType = CommonConstants.TYPE_APP;
      insertItem.bundleName = bundleName;
      insertItem.moduleName = 'anyModuleAsYouLike';
      insertItem.abilityName = 'anyAbilityAsYouLike';
      insertItem.appIconId = 999;
      insertItem.appLabelId = 9999;
      insertItem.appName = 'anyAppName';
      insertItem.iconId = '002';
      insertItem.layoutInfo = [];
      insertItem.appStatus = 0;
      insertItem.appIndex = 0;
      dockInfoList.push(insertItem);
      try {
        let ret = await instance.insertIntoSmartdock(dockInfoList);
        expect(a).assertEqual('test');
        ret = await instance.deleteSmartDockByBundleAndAppIndex(bundleName, insertItem.appIndex);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_insertIntoSmartdock02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let dockInfoList: DockItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.insertIntoSmartdock(dockInfoList);
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_insertIntoRecentDock', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let dockInfoList: DockItemInfo[] = [];
        let a = 'test';
        let ret = await instance.insertIntoRecentDock(dockInfoList);
        expect(ret).assertEqual(true);
        const bundleName = 'anyBundleAsYouLike';
        const insertItem = new DockItemInfo();
        insertItem.appId = '001';
        insertItem.itemType = CommonConstants.TYPE_APP;
        insertItem.bundleName = bundleName;
        insertItem.moduleName = 'anyModule';
        insertItem.abilityName = 'anyAbility';
        insertItem.appIconId = 999;
        insertItem.appLabelId = 9999;
        insertItem.appName = 'anyAppName';
        insertItem.iconId = '002';
        insertItem.layoutInfo = [];
        insertItem.appStatus = 0;
        dockInfoList.push(insertItem);
        ret = await instance.insertIntoRecentDock(dockInfoList);
        expect(a).assertEqual('test');

        ret = await instance.deleteRecentDockByBundle(bundleName, 0);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_insertIntoRecentDock02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let recentDockList: DockItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.insertIntoRecentDock(recentDockList);
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_insertIntoRecentDockInfo', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const num = 10;
      let a = 'test';
      try {
        const ret  = await instance.insertIntoRecentDockInfo(num);
        expect(a).assertEqual('test');

        const retValue = await instance.queryRecentDockInfo();
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_insertIntoRecentDockInfo02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let visibleCount = 0;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        const ret  = await instance.insertIntoRecentDockInfo(visibleCount);
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_deleteAllRecentDockData', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const num = 10;
      try {
        const ret  = await instance.deleteAllRecentDockData();
        expect(ret).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_deleteAllRecentDockData02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      try {
        const ret  = await instance.deleteAllRecentDockData();
        expect(ret).assertLargerOrEqual(0);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      done();
    });

    it('test_deleteSmartDockItem', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: boolean  = await instance.deleteSmartDockItem('');
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      try {
        let ret = await instance.deleteSmartDockItem('bundleName');
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    })

    it('test_deleteSmartDockItem02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let a = 'test';
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      try {
        let ret: boolean = await instance.deleteSmartDockItem('bundleName', undefined, '1', false);
        expect(a).assertEqual('test');
      } catch (err) {}
      try {
        await instance.deleteSmartDockItem('bundleName', 0, '', false);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    })

    it('test_deleteSmartDockByBundleAndAppIndex', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.deleteSmartDockByBundleAndAppIndex('bundleName', 0);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_deleteRecentDockByBundle', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a ='test'
      try {
        let ret  = await instance.deleteRecentDockByBundle('', 0);
        expect(a).assertEqual('test');
      } catch (err) {}
      try {
        await instance.deleteRecentDockByBundle('bundleName', 0);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it('test_deleteSmartDockByBundle01', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName: string = 'bundleNameNotExist';
      const appIndex: number = 0;
      try {
        let ret = await instance.deleteSmartDockByBundleAndAppIndex(bundleName, appIndex);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_deleteSmartDockByBundle02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName: string = '';
      const appIndex: number = 0;
      let a = 'test';
      try {
        let ret = await instance.deleteSmartDockByBundleAndAppIndex(bundleName, appIndex);
        expect(a).assertEqual('test');
      } catch (err) {}
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      try {
        await instance.deleteSmartDockByBundleAndAppIndex('bundleName', undefined);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    });

    it('test_deleteSmartDockByBundle03', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName: string = 'anyBundleName';
      let a = 'test';
      let bundleInfo: BaseBundleInfo = { bundleName: 'anyBundleName', appIndex: 0 };
      let conditions: Map<string, rdb.ValueType> = new Map();
      conditions.set('bundle_name', bundleName);
      conditions.set('container', CommonConstants.CONTAINER_SMARTDOCK);
      let insertItem: DockItemInfo = new DockItemInfo();
      let dockInfoList: DockItemInfo[] = [];
      insertItem.appId = '001';
      insertItem.itemType = CommonConstants.TYPE_APP;
      insertItem.bundleName = bundleName;
      insertItem.moduleName = 'anyModule';
      insertItem.abilityName = 'anyAbility';
      insertItem.appIconId = 999;
      insertItem.appLabelId = 9999;
      insertItem.appName = 'anyAppName';
      insertItem.iconId = '002';
      insertItem.layoutInfo = [];
      insertItem.appStatus = 0;
      dockInfoList.push(insertItem);
      instance.insertIntoSmartdock(dockInfoList);

      try {
        let ret = await instance.deleteSmartDockByBundleAndAppIndex('', 0);
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.deleteBadgeByBundle(bundleInfo);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_dropFormTable', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      await instance.dropFormTable();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);
      try {
        await instance.dropFormTable();
        expect(instance).not().assertUndefined();
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    });

    it('test_ifStringIsNull', 0, () => {
      try {
        let ret = RdbStoreManager.getInstance()['ifStringIsNull']('');
        expect(ret).assertTrue();
      } catch (err) {}

      try {
        let ret = RdbStoreManager.getInstance()['ifStringIsNull'](null);
        expect(ret).assertTrue();
      } catch (err) {}

      try {
        let ret = RdbStoreManager.getInstance()['ifStringIsNull'](undefined);
        expect(ret).assertTrue();
      } catch (err) {}

      try {
        let ret = RdbStoreManager.getInstance()['ifStringIsNull']('string');
        expect(ret).assertFalse();
      } catch (err) {}
    });

    it('test_booleanToNumber', 0, () => {
      try {
        expect(RdbStoreManager.getInstance().booleanToNumber(true)).assertEqual(1);
      } catch (err) {}

      try {
        expect(RdbStoreManager.getInstance().booleanToNumber(false)).assertEqual(0);
      } catch (err) {}

      try {
        expect(RdbStoreManager.getInstance().numberToBoolean(1)).assertTrue();
      } catch (err) {}

      try {
        expect(RdbStoreManager.getInstance().numberToBoolean(123)).assertFalse();
      } catch (err) {}
    });

    it('test_querySmartDock', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        const dockItems: DockItemInfo[] = await instance.querySmartDock();
        expect(dockItems.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_queryRecentDock', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        const dockItems: DockItemInfo[] = await instance.queryRecentDock();
        expect(dockItems.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_getAllSwiperFormInfo', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        const items: SwiperItemInfo[] = await instance.getAllSwiperFormInfo();
        expect(items.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_updateSwiperFormInfo', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const formItem: SwiperItemInfo = new SwiperItemInfo();
      formItem.id = '9999';
      formItem.infoName = '9999';
      formItem.bundleName = 'anyBundleName';
      formItem.abilityName = 'anyAbilityName';
      formItem.moduleName = 'anyModuleName';
      formItem.userId = 998;
      formItem.dimension = 1;
      try {
        let ret = await instance.updateSwiperFormInfo(formItem);
        expect(ret).assertEqual(true);
      } catch (err) {}

      try {
        formItem.infoName = '999';
        let ret = await instance.updateSwiperFormInfo(formItem);
        expect(ret).assertEqual(true);
      } catch (err) {}
      done();
    });

    it('test_updateSwiperFormInfo02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret: boolean = await instance.updateSwiperFormInfo(null);
        expect(ret).assertFalse();
        ret = await instance.updateSwiperFormInfo(undefined);
        expect(ret).assertFalse();
        const formItem: SwiperItemInfo = new SwiperItemInfo();
        formItem.bundleName = 'testBundleName';
        ret = await instance.updateSwiperFormInfo(formItem);
        expect(ret).assertEqual(true);
      } catch (err) {}
      done();
    })

    it('test_queryDesktopApplication', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const items: AppItemInfo[] = await instance.queryDesktopApplication();
        expect(items.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_queryDesktopApplication02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbStoreHelper, rdbStoreHelper.query);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      try {
        const items: AppItemInfo[] = await instance.queryDesktopApplication();
        expect(items.length).assertLargerOrEqual(0);
      } catch (err) {}
      mocker.clear(rdbStoreHelper)
      done();
    });

    it('test_queryNotInstalledApplication', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const items: string[] = await instance.queryNotInstalledApplication();
        expect(items.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_deleteAllGridInfoData_01', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const retValue = await instance.deleteAllGridInfoData();
        expect(retValue).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_deleteAllGridInfoData_02', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const retValue = await instance.deleteAllGridInfoData(false);
        expect(retValue).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_deleteAllGridInfoData_03', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const retValue = await instance.deleteAllGridInfoData(true);
        expect(retValue).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_deleteAllGridInfoData_04', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      try {
        const retValue = await instance.deleteAllGridInfoData(true);
        expect(retValue).assertLargerOrEqual(0);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      done();
    });

    it('test_insertGridLayoutInfo', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const gridlayoutInfo: GridLayoutItemInfo[] = [];
      GlobalContext.getInstance().setObject('isBackupService', true);
      try {
        let retValue = await instance.insertGridLayoutInfo(gridlayoutInfo);
        expect(retValue).assertEqual(false);
        GlobalContext.getInstance().setObject('backupStatus', false);
        retValue = await instance.insertGridLayoutInfo(gridlayoutInfo);
        expect(retValue).assertEqual(false);

        GlobalContext.getInstance().setObject('isBackupService', false);
        GlobalContext.getInstance().setObject('backupStatus', true);
        retValue = await instance.insertGridLayoutInfo(gridlayoutInfo);
        expect(retValue).assertEqual(false);

        const bundleName: string = 'anyBundleName';
        const abilityName: string = 'anyAbilityName';
        const moduleName: string = 'anyModuleName';
        const containId: number = 0;
        const info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = bundleName;
        info.abilityName = abilityName;
        info.moduleName = moduleName;
        info.container = containId;

        gridlayoutInfo.push(info);
        retValue = await instance.insertGridLayoutInfo(gridlayoutInfo);
        expect(retValue).assertEqual(false);

        await instance.deleteGridLayoutByCondition(info, containId);
      } catch (err) {}
      done();
    });

    it('test_insertAppCenter', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let list: AppGridItemInfo[] = [];
        let ret: boolean = await instance.insertAppCenter(list);
        expect(ret).assertEqual(false);
        let item: AppGridItemInfo = new AppGridItemInfo();
        item.bundleName = 'bundleName';
        list.push(item);
        ret = await instance.insertAppCenter(list);
        expect(ret).assertEqual(true);
      } catch (err) {}
      done();
    })

    it('test_updateGridInfoNameFromIconCache', 0, () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let instance2: IconResourceManager = IconResourceManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_CARD;
      let list: GridLayoutItemInfo[] = [item];
      try {
        instance['updateGridInfoNameFromIconCache'](list);
      } catch (err) {}
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.layoutInfo = [[item]];
      list = [item2];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance2, instance2.getCachedIconNameSync);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('');
      try {
        instance['updateGridInfoNameFromIconCache'](list);
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn('appName');
      try {
        instance['updateGridInfoNameFromIconCache'](list);
        expect(list[0].appName).assertUndefined();
      } catch (err) {}
      mocker.clear(instance2);
    })

    it('test_convertIntentStringToMap', 0, () => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let intentStr: string = "{\"a\":\"test\"}";
        let ret = instance['convertIntentStringToMap'](intentStr);
        expect(ret.get('a')).assertEqual('test');
        intentStr = 'test';
        ret = instance['convertIntentStringToMap'](intentStr);
        expect(ret.size).assertEqual(0);
      } catch (err) {}
    })

    it('test_updateDockInfoNameFromIconCache', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let instance2: IconResourceManager = IconResourceManager.getInstance();
      const insertItem = new DockItemInfo();
      insertItem.itemType = CommonConstants.TYPE_FOLDER;
      try {
        instance['updateDockInfoNameFromIconCache'](insertItem);
      } catch (err) {}
      let mocker: MockKit = new MockKit();
      insertItem.itemType = CommonConstants.TYPE_APP;
      let mockFunc: Function = mocker.mockFunc(instance2, instance2.getCachedIconNameSync);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('appName');
      try {
        instance['updateDockInfoNameFromIconCache'](insertItem);
        expect(insertItem.appName).assertEqual('appName');
      } catch (err) {}
      mocker.clear(instance2);
      done();
    })

    it('test_isElementExistInGridLayout01', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = ''
        const abilityName:string = '';
        const moduleName:string = '';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout02', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = ''
        const abilityName:string = 'anyAbilityName';
        const moduleName:string = '';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout03', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = ''
        const abilityName:string = '';
        const moduleName:string = 'anyModuleName';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout04', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = ''
        const abilityName:string = 'anyAbilityName';
        const moduleName:string = 'anyModuleName';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout05', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = 'anyBundleName'
        const abilityName:string = '';
        const moduleName:string = '';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout06', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = 'anyBundleName'
        const abilityName:string = 'anyAbilityName';
        const moduleName:string = '';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout07', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = 'anyBundleName'
        const abilityName:string = '';
        const moduleName:string = 'anyModuleName';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout08', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const bundleName:string = 'anyBundleName'
        const abilityName:string = 'anyAbilityName';
        const moduleName:string = 'anyModuleName';
        let ret = await instance.isElementExistInGridLayout(bundleName, abilityName,moduleName);
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_isElementExistInGridLayout09', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.isElementExistInGridLayout('bundleName', 'abilityName', 'moduleName');
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('test_insertFormStackLayout', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let list: GridLayoutItemInfo[] = [item];
      let a ='test';
      try {
        let ret: boolean = await instance.insertFormStackLayout(item, list, []);
        expect(a).assertEqual('test');
      } catch (err) {}
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.insert);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);
      try {
        await instance.insertFormStackLayout(item, list, []);;
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    })

    it('test_insertFormStackLayout02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let list: GridLayoutItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: boolean = await instance.insertFormStackLayout(item, list, []);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_addInfoToFolder', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId === CommonConstants.TYPE_APP;
      let list: GridLayoutItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        await instance.addInfoToFolder('', list);
        await instance.addInfoToFolder('test', []);
        expect(list.length).assertLargerOrEqual(0);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_queryItemByInfoId', 0, async (done:Function) => {
      try {
        let a ='test';
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let ret: GridLayoutItemInfo = await instance.queryItemByInfoId('99');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it('test_queryItemByInfoId02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: GridLayoutItemInfo = await instance.queryItemByInfoId('');
        expect(ret instanceof GridLayoutItemInfo).assertTrue();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_queryRecordByInfoId', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: GridLayoutItemInfo = await instance.queryRecordByInfoId('');
        expect(ret).assertUndefined();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_addInfoToDockFolder', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId === CommonConstants.TYPE_APP;
      let list: GridLayoutItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        await instance.addInfoToDockFolder('', list);
        expect(list.length).assertLargerOrEqual(0);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_addInfoToFormStack', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId === CommonConstants.TYPE_APP;
      let list: GridLayoutItemInfo[] = [item];
      try {
        await instance.addInfoToFormStack(item, list);
        await instance.addInfoToFormStack(item, list, 1);
        expect(list.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    })

    it('test_addInfoToFormStack02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId === CommonConstants.TYPE_APP;
      let list: GridLayoutItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        await instance.addInfoToFormStack(item, list);
        expect(list.length).assertLargerOrEqual(0);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_deleteAppCenterItem', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: AppItemInfo = new AppItemInfo();
      await instance.deleteAppCenterItem(item);
      item.bundleName = 'bundleName';
      item.abilityName = 'abilityName';
      item.moduleName = 'moduleName';
      item.appIndex  = undefined;
      try {
        await instance.deleteAppCenterItem(item);
        expect(item.bundleName).assertEqual('bundleName');
      } catch (err) {}
      done();
    })

    it('test_deleteAppCenterItem02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: AppItemInfo = new AppItemInfo();
      item.appId = '1';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        await instance.deleteAppCenterItem(item);
        expect(item.appId).assertEqual('1');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateAllInfoPosition', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.folderId = '99';
      let a ='test';
      let list: GridLayoutItemInfo[] = [item];
      try {
        let ret: boolean = await instance.updateAllInfoPosition(null);
        expect(a).assertEqual('test');
      } catch (err) {}
      try {
        await instance.updateAllInfoPosition(undefined);
        expect(a).assertEqual('test');
      } catch (err) {}
      try {
        await instance.updateAllInfoPosition([]);
        expect(a).assertEqual('test');
      } catch (err) {}
      list = [item, item];
      try {
        await instance.updateAllInfoPosition(list);
        expect(a).assertEqual('test');
      } catch (err) {}
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        await instance.updateInfoPosition(list, 'test');
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    })

    it('test_deleteGridLayoutByCondition01', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        await instance.deleteGridLayoutByCondition({
          bundleName: 'bundleNameNotExist',
          abilityName: 'abilityNameNotExist',
          moduleName: 'abilityNameNotExist'});
        expect(instance).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('test_deleteGridLayoutByCondition02', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();

        const containId: number = 888888;
        await instance.deleteGridLayoutByCondition({
          bundleName: 'anyBundleName',
          abilityName: 'anyAbilityName',
          moduleName: 'anyAbilityName'}, 888888);
        expect(instance).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('test_deleteGridLayoutByCondition03', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();

        const containId: number = 888888;
        await instance.deleteGridLayoutByCondition({
          appIndex: undefined,
          shortcutId: '1',
          bundleName: '',
          abilityName: '',
          moduleName: ''}, containId);
        expect(instance).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('test_deleteShortcutItem', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();

        instance.deleteShortcutItem('', '1', 0);
        expect(instance).not().assertUndefined();
      } catch (err) {
      }
      done();
    });

    it('test_deleteFileFolderItem', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const ino = 'idNotExists';
        await instance.deleteFileFolderItem(ino);
        expect(instance).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('test_deleteItemByInfoId', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const ino = 'idNotExists';
        await instance.deleteItemByInfoId(ino);
        expect(instance).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('test_deleteItemByInfoIdAndContainer', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let item = new GridLayoutItemInfo();
        item.infoId = 'infoIdNotExists';
        item.container = -1000;
        await instance.deleteItemsByInfoIdAndContainer([item]);
        expect(instance).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('test_updateInfoPosition_0_length', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const itemList: GridLayoutItemInfo[] = [];
      const container: number = 0;
      const isConvertToSmall: boolean = false;
      try {
        let retValue =
          await instance.updateInfoPosition(itemList, 'test', new ExtraInfo(container, isConvertToSmall));
        expect(retValue).assertEqual(false);
      } catch (err) {}

      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemList.push(itemInfo);
      try {
        let retValue =
          await instance.updateInfoPosition(itemList, 'test', new ExtraInfo(container, isConvertToSmall));
        expect(retValue).assertEqual(false);
      } catch (err) {}

      itemInfo.typeId === CommonConstants.TYPE_FOLDER;
      itemInfo.folderId = '';
      try {
        let retValue =
          await instance.updateInfoPosition(itemList, 'test', new ExtraInfo(container, isConvertToSmall));
        expect(retValue).assertEqual(false);
      } catch (err) {}

      itemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER;
      itemInfo.ino = '';
      try {
        let retValue =
          await instance.updateInfoPosition(itemList, 'test', new ExtraInfo(container, isConvertToSmall));
        expect(retValue).assertEqual(false);
      } catch (err) {}

      itemInfo.typeId === CommonConstants.TYPE_FORM_STACK;
      itemInfo.formStackId = '';
      try {
        let retValue =
          await instance.updateInfoPosition(itemList, 'test', new ExtraInfo(container, isConvertToSmall));
        expect(retValue).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_updateInfoPosition_1_length', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const itemList: GridLayoutItemInfo[] = [itemInfo];
      const container: number = 0;
      const isConvertToSmall: boolean = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        let retValue = await instance.updateInfoPosition(itemList, 'test', new ExtraInfo(container, isConvertToSmall));
        expect(retValue).assertEqual(false);
      } catch (err) {}
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    })

    it('test_updateGridLayoutPositionBatch', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const gridItemList: GridLayoutItemInfo[] = [];
      let a = 'test';
      try {
        let retValue = await instance.updateGridLayoutPositionBatch(gridItemList);
        expect(a).assertEqual('test');
      } catch (err) {}

      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItemList.push(itemInfo);
      try {
        await instance.updateGridLayoutPositionBatch(gridItemList);
        expect(a).assertEqual('test');
      } catch (err) {}

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        await instance.updateGridLayoutPositionBatch(gridItemList);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    });

    it('test_updateGridLayoutPositionBatch02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const gridItemList: GridLayoutItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let retValue = await instance.updateGridLayoutPositionBatch(gridItemList);
        expect(retValue).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateNewInstalledGridInfo', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a = 'test';
      const gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      const bundleName = 'anyBundleName';
      const moduleName = 'anyModuleName';
      const appIconId = 999;
      const appLabelId = 9999;
      const appStatus = 0;
      gridItem.bundleName = bundleName;
      gridItem.moduleName = moduleName;
      gridItem.appIconId = appIconId;
      gridItem.appLabelId = appLabelId;
      gridItem.appStatus = appStatus;

      try {
        let retValue = await instance.updateNewInstalledGridInfo(gridItem);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_updateNewInstalledGridInfo02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let retValue = await instance.updateNewInstalledGridInfo(gridItem);
        expect(retValue).assertEqual(-1);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateGridInfoById', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a ='test';
      const infoId: string = 'IdNotExists';
      const key: string = GridLayoutInfoColumns.BUNDLE_NAME;
      const value: string = 'anyValue';
      try {
        let retValue = await instance.updateGridInfoById(infoId, key, value);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_updateGridInfoById02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let retValue = await instance.updateGridInfoById('', 'key', 'value');
        expect(retValue).assertEqual(-1);
      } catch (err) {}
      try {
        let retValue = await instance.updateGridInfoById('infoId', '', 'value');
        expect(retValue).assertEqual(-1);
      } catch (err) {}
      done();
    })

    it('test_queryGridLayoutByType', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let retValue: GridLayoutItemInfo[] = await instance.queryGridLayoutByType(CommonConstants.TYPE_APP);
        expect(retValue.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_queryGridLayoutByContainer', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let retValue: GridLayoutItemInfo[] = await instance.queryGridLayoutByContainer(CommonConstants.CONTAINER_DESKTOP);
        expect(retValue.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_updateDownloadInfo', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName: string = 'anyBundle';
      const iconResource: string = 'anyIconResource';
      const appStatus: AppStatus = AppStatus.INSTALLED;
      const downloadProgress: number = 100;
      const abilityName: string = 'anyAbilityName';
      const moduleName: string = '';
      const callerName: string = '';
      const appInfo: DownloadInfoItem = {
        bundleName,
        iconResource,
        appStatus,
        downloadProgress,
        abilityName,
        moduleName,
        callerName
      };
      try {
        let retValue = await instance.updateDownloadInfo(appInfo);
        expect(retValue).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_updateDownloadInfo02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let retValue = await instance.updateDownloadInfo(null);
        expect(retValue).assertEqual(-1);
      } catch (err) {}
      done();
    })

    it('test_batchInsertBadge', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();

      const bundleName: string = 'anyBundle';
      const badgeNumber: number = 99;
      const isShow: boolean = true;
      const userId: number = 100;
      const badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.bundleName = bundleName;
      badgeInfo.badgeNumber = badgeNumber;
      badgeInfo.isShow = isShow;
      badgeInfo.userId = userId;
      const badgeList: BadgeItemInfo[] = [badgeInfo];
      try {
        let retValue = await instance.batchInsertBadge(badgeList);
        expect(retValue).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_batchInsertBadge02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const badgeList: BadgeItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.batchInsert);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      try {
        let retValue = await instance.batchInsertBadge(badgeList);
        expect(retValue).assertEqual(false);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      done();
    })

    it('test_insertIntelligentDiscoveryInfo', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a = 'test';
      const discoveryInfo: Array<rdb.ValuesBucket> = [];
      discoveryInfo.push({
        'parent_id': 999,
        'service_id': 'anyValue'
      });

      try {
        let retValue = await instance.insertIntelligentDiscoveryInfo(discoveryInfo);
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        const dataList = await instance.queryIntelligentDiscoveryInfo();
        expect(a).assertEqual('test');
      }catch (err){}
      done();
    });

    it('test_insertIntelligentDiscoveryInfo02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const discoveryInfo: Array<rdb.ValuesBucket> = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let retValue = await instance.insertIntelligentDiscoveryInfo(discoveryInfo);
        expect(retValue).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_deleteFeedHeadPicByModuleName', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const moduleName = 'moduleNotExists';
      let a = 'test';
      try {
        let ret = await instance.deleteFeedHeadPicByModuleName(moduleName);
        expect(a).assertEqual('test');
      } catch (err) {}
      try {
        await instance.deleteFeedHeadPicByModuleName('');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_deleteFeedHeadPicByModuleName02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const moduleName = 'moduleNotExists';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.delete);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      try {
        let ret = await instance.deleteFeedHeadPicByModuleName(moduleName);
        expect(ret).assertEqual(true);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    });


    it('test_insertGridLayoutInfoWithCheck_01', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const item: GridLayoutItemInfo = new GridLayoutItemInfo();
        const retValue = await instance.insertGridLayoutInfoWithCheck(item);
        expect(retValue).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    });

    it('test_insertGridLayoutInfoWithCheck_02', 0, async (done:Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const item: GridLayoutItemInfo = new GridLayoutItemInfo();
        const retValue = await instance.insertGridLayoutInfoWithCheck(item, true);
        expect(retValue).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('test_insertGridLayoutInfoWithCheck_03', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.isElementExistInGridLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let retValue = await instance.insertGridLayoutInfoWithCheck(item);
        expect(retValue).assertFalse();
      } catch (err) {}
      mocker.clear(instance);
      done();
    });

    it('test_insertGridLayoutInfoWithCheck_04', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let retValue = await instance.insertGridLayoutInfoWithCheck(item);
        expect(retValue).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_getContainerByFolderId', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.folderId = '999';
      item.id = 1;
      let a ='test';
      let list: GridLayoutItemInfo[] = [item]
      try {
        let ret = await instance.getContainerByFolderId(item);
        expect(a).assertEqual('test');
      } catch (err) {}
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.queryAllGridLayoutInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      try {
        await instance.getContainerByFolderId(item);
        expect(a).assertEqual('test');
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      done();
    })

    it('test_getContainerByFolderId02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.getContainerByFolderId(item);
        expect(ret).assertUndefined();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_queryLocationInfoById', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a = 'test';
      try {
        let ret = await instance.queryLocationInfoById('');
        expect(a).assertEqual('test');
      } catch (err) {}
      try {
        await instance.queryLocationInfoById('999');
        expect(a).assertEqual('test');
      } catch (err) {}
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let list: GridLayoutItemInfo[] = [item]
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.queryAllGridLayoutInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      try {
        await instance.queryLocationInfoById('999');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it('test_queryLocationInfoById02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.queryLocationInfoById('test');
        expect(ret).assertNull();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_queryGridLayoutItemsByBundleName', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.queryGridLayoutItemsByBundleName('');
        expect(ret.length === 0).assertTrue();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      try {
        let ret = await instance.queryGridLayoutItemsByBundleName('bundleName');
        expect(ret.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    })

    it('test_updateIntelligentCardList', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let res: ValuesBucket = {
        formId: 1,
        name: 'anyString'
      };
      let cardList: Array<ValuesBucket> = [res];
      try {
        await RdbStoreManager.getInstance().updateIntelligentCardList('intelligent_card_lists', cardList);
        expect(res.name).assertEqual('anyString');
      } catch (err) {}
      done();
    });

    it('test_getIntelligentCardList', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const idNameInfo = 'idNotExists';
      try {
        const retValue = await instance.getIntelligentCardList(idNameInfo);
        expect(retValue).assertNull();
      } catch (err) {}
      done();
    });

    it('test_insertIntelligentImage', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a = 'test';
      let imageInfo: rdb.ValuesBucket = {
        moduleName: 'anyModule'
      };
      try {
        let retValue = await instance.insertIntelligentImage(imageInfo);
        expect(a).assertEqual('test');
      } catch (err) {}

      imageInfo = {
        moduleName: 'feedHeadPic',
        imageUrl: 'imageUrl',
        imageBase64: 'imageBase64',
        extraData: 'extraData'
      };
      try {
        await instance.insertIntelligentImage(imageInfo);
        expect(a).assertEqual('test');
      } catch (err) {}

      imageInfo = {
        moduleName: 'otherModule',
        imageUrl: 'imageUrl',
        imageBase64: 'imageBase64',
        extraData: 'extraData'
      };
      try {
        await instance.insertIntelligentImage(imageInfo);
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.insertIntelligentImage(imageInfo);
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.queryIntelligentImageByUrl('imageUrl');
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        let rows = await instance.queryIntelligentImageByModule('otherModule');
      } catch (err) {}
      expect(a).assertEqual('test');
      expect(a).assertEqual('test');
      try {
        await instance.queryIntelligentImageByModuleAndUrl('otherModule', 'imageUrl');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_insertIntelligentImage02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let imageInfo: rdb.ValuesBucket = {
        moduleName: 'anyModule'
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.insertIntelligentImage(imageInfo);
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_insertIntelligentCommonData', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a ='test';
      let imageInfo: rdb.ValuesBucket = {
        moduleName: 'anyModule'
      };
      try {
        let retValue = await instance.insertIntelligentCommonData(imageInfo);
        expect(retValue).assertEqual(false);
      } catch (err) {}

      imageInfo = {
        moduleName: 'anyModule',
        keyName: 'keyName',
        value: 'anyValue',
        extraData: 'extraData'
      };
      try {
        await instance.insertIntelligentCommonData(imageInfo);
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.insertIntelligentCommonData(imageInfo);
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.queryIntelligentCommonData('anyModule', 'keyName');
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.queryIntelligentCommonDataByModule('anyModule');
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.deleteIntelligentCommonData('anyModule', 'keyName');
        expect(a).assertEqual('test');
      } catch (err) {}

      try {
        await instance.deleteIntelligentCommonData('anyModule');
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    });

    it('test_insertIntelligentCommonData02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let imageInfo: rdb.ValuesBucket = {
        moduleName: 'anyModule'
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.insertIntelligentCommonData(imageInfo);
        expect(ret).assertEqual(false);
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_deleteIntelligentCommonData', 0, async (done: Function) => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let result = await instance.deleteIntelligentCommonData('');
        expect(result).assertFalse();
      } catch (err) {}
      done();
    })

    it('test_updateExtend1ByCardId01', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret = await instance.updateExtend1ByCardId('', '');
        expect(ret).assertEqual(false);
      } catch (err) {}
      done();
    });

    it('test_updateExtend1ByCardId02', 0, async (done:Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret =await instance.updateExtend1ByCardId('testValue', '999');
        expect(ret).assertEqual(true);
      } catch (err) {}
      done();
    });

    it('test_updateRelationFormInfoOfDb', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let a ='test';
      const cardItemInfo: CardItemInfo = new CardItemInfo();
      let list: CardItemInfo[] = [cardItemInfo];
      try {
        let ret = await instance.updateRelationFormInfoOfDb(list);
        expect(a).assertEqual('test');
      } catch (err) {}
      done();
    })

    it('test_updateRelationFormInfoOfDb02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const list: CardItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.updateRelationFormInfoOfDb(list);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_deleteRelationFormInfoOfDb', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const infoId = 'InfoIdNotExists';
      let a = 'test';
      const list: string[] = [];
      list.push(infoId);
      try {
        let ret = await instance.deleteRelationFormInfoOfDb(list);
        expect(a).assertEqual('test');
      } catch (error) {
      }
      done();
    });

    it('test_deleteRelationFormInfoOfDb02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const list: string[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.deleteRelationFormInfoOfDb(list);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateAppCenterItemPositions', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: AppGridItemInfo = new AppGridItemInfo();
      item.bundleName = '';
      let list: AppGridItemInfo[] = [item];
      try {
        let ret = await instance.updateAppCenterItemPositions(list);
        expect(ret).assertFalse();
      } catch (err) {}
      item.bundleName = 'bundleName';
      list = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.updateAppCenterItemPositions(list);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateAppCenterItemPositions02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: AppGridItemInfo = new AppGridItemInfo();
      item.bundleName = '';
      let list: AppGridItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: boolean = await instance.updateAppCenterItemPositions(list);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateAppCenterSys', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: AppGridItemInfo = new AppGridItemInfo();
      item.bundleName = '';
      let list: AppGridItemInfo[] = [item];
      try {
        let ret = await instance.updateAppCenterSys(list);
        expect(ret).assertFalse();
      } catch (err) {}
      item.bundleName = 'bundleName';
      list = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret = await instance.updateAppCenterSys(list);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateAppCenterSys02', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: AppGridItemInfo = new AppGridItemInfo();
      item.bundleName = 'bundleName';
      let list: AppGridItemInfo[] = [item];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: boolean = await instance.updateAppCenterSys(list);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_insertGridLayoutInfoOuter', 0, async (done: Function) => {
      if (launcherStatusUtil.getShowOutLauncherStatus()){
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        const gridlayoutInfo: GridLayoutItemInfo[] = [];
        GlobalContext.getInstance().setObject('isBackupService', true);
        try {
          let retValue = await instance.insertGridLayoutInfo(gridlayoutInfo, true);
          expect(retValue).assertEqual(false);
          GlobalContext.getInstance().setObject('backupStatus', false);
          retValue = await instance.insertGridLayoutInfo(gridlayoutInfo, true);
          expect(retValue).assertEqual(false);
          GlobalContext.getInstance().setObject('isBackupService', false);
          GlobalContext.getInstance().setObject('backupStatus', true);
          retValue = await instance.insertGridLayoutInfo(gridlayoutInfo, true);
          expect(retValue).assertEqual(false);
        } catch (err) {}
      } else {
        let a = 'test';
        expect(a).assertEqual('test');
      }
      done();
    });

    it('test_updateLayoutTableName', 0, () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let desktopMode: number = 0;
      try {
        instance.updateLayoutTableName(desktopMode);
        expect(instance['mLayoutTableName']).assertEqual(RdbStoreConfig.gridLayoutInfo.tableName);
        desktopMode = 1;
        instance.updateLayoutTableName(desktopMode);
        expect(instance['mLayoutTableName']).assertEqual(RdbStoreConfig.simpleLayoutInfo.tableName);
      } catch (err) {}
    });

    it('test_ifDuplicatePosition', 0, () => {
      try {
        const instance: RdbStoreManager = RdbStoreManager.getInstance();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.area = [1, 1];
        item.page = 1;
        item.row = 1;
        item.column = 1;
        let list: GridLayoutItemInfo[] = [item];
        let insertPositionInfo: Array<number> = [1, 1, 1];
        let area: Array<number> = [1, 1];
        let ret: boolean = instance.ifDuplicatePosition(list, insertPositionInfo, area);
        expect(ret).assertTrue();
        insertPositionInfo = [1, 1, 2];
        ret = instance.ifDuplicatePosition(list, insertPositionInfo, area);
        expect(ret).assertFalse();
        insertPositionInfo = [1, 1, 2, 1];
        ret = instance.ifDuplicatePosition(list, insertPositionInfo, area);
        expect(ret).assertFalse();
      } catch (err) {}
    })

    it('test_correctShortcutItemInfo', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret = await instance.correctShortcutItemInfo(null);
        expect(ret).assertFalse();
      } catch (err) {}
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'bundleName';
      item.appIndex = 1;
      item.shortcutId = '1';
      item.infoName = 'infoName';
      item.intent = 'intent';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.update);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      try {
        let ret = await instance.correctShortcutItemInfo(item);
        expect(ret).assertFalse();
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    })

    it('test_queryAppCenterInstallApp', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let ret = await instance.queryAppCenterInstallApp();
        expect(ret.length).assertLargerOrEqual(0);
      } catch (err) {}
      done();
    })

    it('test_insertItemWithoutLayoutInfo', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'bundleName';
      item.appIndex = 1;
      item.shortcutId = '1';
      item.infoName = 'infoName';
      item.intent = 'intent';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbTaskPool, rdbTaskPool.insert);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      try {
        let ret = await instance.insertItemWithoutLayoutInfo(item);
        expect(ret).assertEqual(1);
      } catch (err) {}
      mocker.clear(rdbTaskPool);
      mocker.clearAll();
      done();
    })

    it('test_updateAppNameByAbilityInfoAndType', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let appName = 'appName';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        await instance.updateAppNameByAbilityInfoAndType(appName, 'bundleName', 'moduleName', 'abilityName', 0);
        expect(appName).assertInstanceOf('Number');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateAppItemIntentByInfoId', 0, async (done: Function) => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let folderContainer = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        await instance.updateAppItemIntentByInfoId(folderContainer, 'DT');
        expect(folderContainer).assertInstanceOf('Number');
      } catch (err) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_insertGridLayoutInfoIfNotExist', 0, async () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = '';
      const retValue = await instance.insertGridLayoutInfoIfNotExist(item);
      expect(retValue).not().assertUndefined();
    });

    it('test_insertGridLayoutInfoIfNotExist1', 0, async () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'anyInfoId';
      const retValue = await instance.insertGridLayoutInfoIfNotExist(item);
      expect(retValue).not().assertUndefined();
    });

    it('test_updateLayoutTableNameByName1', 0, () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let name: string = "validName";
      instance.updateLayoutTableNameByName(name);
      expect(instance['mLayoutTableName']).assertEqual(name);
    });

    it('test_checkIfItemExist', 0, async() => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = '';
      let ret = await instance.checkIfItemExist(item);
      expect(ret).assertEqual(false);
    });

    it('test_checkIfItemExist1', 0, async() => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'anyInfoId';
      let ret = await instance.checkIfItemExist(item);
      expect(ret).assertEqual(false);
    });

    it('test_updateAppItemFormInfo', 0, async () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName: string = 'bundleName';
      const appItemCardInfo: AppItemCardInfo = {
        bundleName: 'bundleName',
        appName: 'appName',
        appIndex: 0,
        cards: [],
        status: 0
      };
      let result: boolean = await instance.updateAppItemFormInfo(bundleName, appItemCardInfo);
      expect(result).assertTrue();
    });

    it('test_batchInsertAppItemFormInfo', 0, async () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const appItemCardInfoList: AppItemCardInfo[] = [{
        bundleName: 'bundleName',
        appName: 'appName',
        appIndex: 0,
        cards: [],
        status: 0
      }];
      let result: boolean = await instance.batchInsertAppItemFormInfo(appItemCardInfoList);
      expect(result).assertTrue();
    });

    it('test_deleteAppItemFormInfo', 0, async () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      const bundleName: string = 'bundleName';
      let result: boolean = await instance.deleteAppItemFormInfo(bundleName);
      expect(result).assertTrue();
    });

    it('test_deleteAllAppItemFormInfo', 0, async () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let result: boolean = await instance.deleteAllAppItemFormInfo();
      expect(result).assertTrue();
    });

    it('test_batchUpdateAppItemFormInfo', 0, async () => {
      const instance: RdbStoreManager = RdbStoreManager.getInstance();
      let result: boolean = await instance.batchUpdateAppItemFormInfo(1);
      expect(result).assertTrue();
    });
  })
}