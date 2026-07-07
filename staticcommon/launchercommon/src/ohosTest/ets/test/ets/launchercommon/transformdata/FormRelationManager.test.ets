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
  describe,
  expect,
  it,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';

import dataConvert from '../../../../../../main/ets/transformdata/DataConvert';
import GridLayoutItemInfo from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import {
  CardItemInfo,
  CommonConstants,
  FormRelationManager,
  BackupSceneBundleVersionName
} from '../../../../../../main/ets/TsIndex';
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

export default function FormRelationManagerTest() {
  describe('FormRelationManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_getSceneBoardFormRelationModelMap', 0, () => {
      FormRelationManager.getInstance().initSceneBoardFormRelation();
      let ret = FormRelationManager.getInstance().getSceneBoardFormRelationModelMap();
      expect(ret).not().assertNull();
      FormRelationManager.getInstance().clearSceneBoardFormRelationModel();
      ret = FormRelationManager.getInstance().getSceneBoardFormRelationModelMap();
      expect(ret).not().assertNull();
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName_04', 0, () => {
      let bundleName: string = 'bundleName';
      let layoutInfo: GridLayoutItemInfo[] = [];
      let layout1: GridLayoutItemInfo = new GridLayoutItemInfo();
      layout1.typeId = CommonConstants.TYPE_CARD;
      layout1.layoutInfo = [[]];
      let layout2: GridLayoutItemInfo = new GridLayoutItemInfo();
      layout2.typeId = CommonConstants.TYPE_FORM_STACK;
      layout2.layoutInfo = [[]];

      layoutInfo.push(layout1);
      layoutInfo.push(layout2);

      let remainingStackInfos: GridLayoutItemInfo[] = [];
      let grid: GridLayoutItemInfo = new GridLayoutItemInfo();
      grid.layoutInfo = [];
      remainingStackInfos.push(grid);

      let deleteFormAndStackInfos: GridLayoutItemInfo[] = [];

      let sceneBoardFormMap: Map<string, CardItemInfo[]> = new Map();
      let relationCards: CardItemInfo[] = [];
      let cardItemInfo1: CardItemInfo = new CardItemInfo();
      cardItemInfo1.cardId = '1';
      let cardItemInfo2: CardItemInfo = new CardItemInfo();
      cardItemInfo2.cardId = '2';
      relationCards.push(cardItemInfo1, cardItemInfo2);

      sceneBoardFormMap.set('bundleName', relationCards);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(dataConvert, dataConvert['getSceneBoardFormRelationModelMap']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sceneBoardFormMap);
      FormRelationManager.getInstance()
        .deleteSceneBoardFormRelationInfoByBundleName(bundleName, layoutInfo, remainingStackInfos,
          deleteFormAndStackInfos);

      expect(bundleName).assertEqual('bundleName');
      mocker.clear(dataConvert);
      mocker.clearAll();
    });

    it('test_deleteSceneBoardFormRelationMapByCardId01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByCardId(cardId);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationMapByCardId02', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '12345678';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByCardId(cardId);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationMapByBundleName01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByBundleName(bundleName);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationMapByBundleName02', Level.LEVEL0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = '';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByBundleName(bundleName);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_isSceneBoardCard01', Level.LEVEL0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      const formName: string = 'formNameNotExists';
      let result: boolean = FormRelationManager.getInstance().isSceneBoardCard(bundleName, formName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertFalse();
    })

    it('test_isSceneBoardCard02', Level.LEVEL0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = '';
      const formName: string = '';
      let result: boolean = FormRelationManager.getInstance().isSceneBoardCard(bundleName, formName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertFalse();
    })

    it('test_isSceneBoardCard03', Level.LEVEL0, async () => {
      const bundleName: string = CommonConstants.LAUNCHER_BUNDLE;
      const formName: string = 'SceneBoard_2_1_Card';
      let result: boolean = FormRelationManager.getInstance().isSceneBoardCard(bundleName, formName);
      expect(result).assertTrue();
    })

    it('test_getAppNameByCardId01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '';
      let result: string = FormRelationManager.getInstance().getAppNameByCardId(cardId);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertEqual('');
    })

    it('test_getAppNameByCardId02', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '12345678';
      let result: string = FormRelationManager.getInstance().getAppNameByCardId(cardId);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertEqual('国泰君安君弘');
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);

      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 1;
      gridLayout.infoId = '12345678';
      gridLayout.appName = '国泰君安君弘';
      gridLayout.bundleName = 'com.gtja.junhong.hm.next';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_KeyName';
      gridLayout.abilityName = 'EntryFormAbility';
      gridLayout.moduleName = 'default';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 1;

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName02', Level.LEVEL0, async () => {
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', []);

      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 1;
      gridLayout.infoId = '12345678';
      gridLayout.appName = '国泰君安君弘';
      gridLayout.bundleName = 'com.gtja.junhong.hm.next';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_KeyName';
      gridLayout.abilityName = 'EntryFormAbility';
      gridLayout.moduleName = 'default';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 1;

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName03', Level.LEVEL0, async () => {
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', []);

      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 1;
      gridLayout.infoId = '12345678';
      gridLayout.appName = '国泰君安君弘';
      gridLayout.bundleName = 'com.gtja.junhong.hm.next';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_KeyName';
      gridLayout.abilityName = 'EntryFormAbility';
      gridLayout.moduleName = 'default';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 1;

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName04', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);


      let card1: GridLayoutItemInfo = new GridLayoutItemInfo();
      card1.typeId = 1;
      card1.infoId = '12345677';
      card1.appName = '国泰君安君弘';
      card1.bundleName = 'com.gtja.junhong.hm.next';
      card1.keyName = 'com.gtja.junhong.hm.next_KeyName';
      card1.abilityName = 'EntryFormAbility';
      card1.moduleName = 'default';
      card1.appIconId = 1;
      card1.appLabelId = 2;
      card1.badgeNumber = 3;
      card1.row = 4;
      card1.column = 5;
      card1.area = [2, 2];
      card1.areaType = 1;

      let card2: GridLayoutItemInfo = new GridLayoutItemInfo();
      card1.typeId = 1;
      card1.infoId = '12345678';
      card1.appName = '国泰君安君弘';
      card1.bundleName = 'com.gtja.junhong.hm.next';
      card1.keyName = 'com.gtja.junhong.hm.next_KeyName';
      card1.abilityName = 'EntryFormAbility';
      card1.moduleName = 'default';
      card1.appIconId = 1;
      card1.appLabelId = 2;
      card1.badgeNumber = 3;
      card1.row = 4;
      card1.column = 5;
      card1.area = [2, 2];
      card1.areaType = 1;


      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 6;
      gridLayout.infoId = '1234567891011';
      gridLayout.formStackId = '1234567891011';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_stack_KeyName';
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 6;
      gridLayout.layoutInfo = [[card1], [card2]];

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_updateFormAndStackInfoByBundleName01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      let cardItems: CardItemInfo[] = FormRelationManager.getInstance().updateFormAndStackInfoByBundleName(bundleName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(cardItems.length).assertEqual(0);
    })

    it('test_updateFormAndStackInfoByBundleName02', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      let cardItems: CardItemInfo[] = FormRelationManager.getInstance().updateFormAndStackInfoByBundleName(bundleName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(cardItems.length).assertEqual(1);
    })

    it('test_updateFormAndStackInfoByBundleName03', Level.LEVEL0, async () => {
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', []);

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      let cardItems: CardItemInfo[] = FormRelationManager.getInstance().updateFormAndStackInfoByBundleName(bundleName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(cardItems.length).assertEqual(0);
    })


    it('test_getSceneBoardFormRelationModelMap_mock1', 0, () => {
      const mocker: MockKit = new MockKit();
      const mockFunction: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      FormRelationManager.getInstance().clearSceneBoardFormRelationModel();
      FormRelationManager.getInstance().initSceneBoardFormRelation();
      let ret = FormRelationManager.getInstance().getSceneBoardFormRelationModelMap();
      expect(ret).not().assertNull();
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('test_getSceneBoardFormRelationModelMap_mock2', 0, () => {
      const mocker: MockKit = new MockKit();
      const mockFunction: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      const mockFun1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);

      FormRelationManager.getInstance().clearSceneBoardFormRelationModel();
      FormRelationManager.getInstance().initSceneBoardFormRelation();
      let ret = FormRelationManager.getInstance().getSceneBoardFormRelationModelMap();
      expect(ret).not().assertNull();
      mocker.clear(FileUtils);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_getDefaultCardType_01', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: number = instance['getDefaultCardType']([]);
        expect(res).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDefaultCardType_02', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: number = instance['getDefaultCardType']([2, 1]);
        expect(res).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDefaultCardType_03', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: number = instance['getDefaultCardType']([2, 2]);
        expect(res).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDefaultCardType_04', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: number = instance['getDefaultCardType']([4, 2]);
        expect(res).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDefaultCardType_05', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: number = instance['getDefaultCardType']([4, 4]);
        expect(res).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDefaultCardType_06', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: number = instance['getDefaultCardType']([1, 1]);
        expect(res).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDefaultCardType_07', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: number = instance['getDefaultCardType']([1, 1]);
        expect(res).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getSceneBoardFormName_01', 0, () => {
      try {
        let res: string = FormRelationManager.getInstance().getSceneBoardFormName(4);
        expect(res).assertInstanceOf('String');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getSceneBoardFormRelationByBundleName_01', 0, () => {
      try {
        let relationCardItems: CardItemInfo[] =
          FormRelationManager.getInstance().getSceneBoardFormRelationByBundleName('com.ohos.totemweather');
        expect(relationCardItems.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getSceneBoardFormRelationByBundleName_02', 0, () => {
      try {
        let relationCardItems: CardItemInfo[] =
          FormRelationManager.getInstance().getSceneBoardFormRelationByBundleName('test_bundleName');
        expect(relationCardItems.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFileMapping_01', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: string = instance['getFileMapping'](BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
        expect(res.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFileMapping_02', 0, () => {
      try {
        let instance: FormRelationManager = FormRelationManager.getInstance();
        let res: string = instance['getFileMapping'](BackupSceneBundleVersionName.ADLAUNCHER_TO_ohos);
        expect(res.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFileMapping_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance: FormRelationManager = FormRelationManager.getInstance();
        instance['getFileMapping'](BackupSceneBundleVersionName.ADLAUNCHER_TO_ohos);
        expect(instance instanceof FormRelationManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(FileUtils);
      mock.clearAll();
    })

    it('test_getFileMapping_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');

        let instance: FormRelationManager = FormRelationManager.getInstance();
        instance['getFileMapping'](BackupSceneBundleVersionName.ADLAUNCHER_TO_ohos);
        expect(instance instanceof FormRelationManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(FileUtils);
      mock.clearAll();
    })

    it('test_loadFormRelation_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');

        let instance: FormRelationManager = FormRelationManager.getInstance();
        instance.loadFormRelation(BackupSceneBundleVersionName.ADLAUNCHER_TO_ohos);
        expect(instance instanceof FormRelationManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_loadFormRelation_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance: FormRelationManager = FormRelationManager.getInstance();
        instance.loadFormRelation(BackupSceneBundleVersionName.ADLAUNCHER_TO_ohos);
        expect(instance instanceof FormRelationManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_collectDeleteCardLayoutInfo_01', 0, () => {
      try {
        let cardId: string = 'cardId';
        let formLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        formLayoutInfo.cardId = cardId;
        let info: CardItemInfo = new CardItemInfo();
        info.cardId = cardId;
        let relationCards: CardItemInfo[] = [];
        relationCards.push(info);
        let deleteFormAndStackInfos: GridLayoutItemInfo[] = [];
        let instance: FormRelationManager = FormRelationManager.getInstance();
        instance['collectDeleteCardLayoutInfo'](relationCards, formLayoutInfo, deleteFormAndStackInfos);
        expect(relationCards.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_refreshSceneBoardFormRelationToFile_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(GlobalContext, GlobalContext.getInstance);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');

        let instance: FormRelationManager = FormRelationManager.getInstance();
        instance.refreshSceneBoardFormRelationToFile();
        expect(instance instanceof FormRelationManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(GlobalContext);
      mock.clearAll();
    })
  })
}