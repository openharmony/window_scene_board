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
﻿import { CheckEmptyUtils } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { DesktopLayoutCacheData } from '../../../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import {
  BundleConstants,
  CardItemInfo,
  CommonConstants,
  DefaultDesktopLayoutInfo, FormLayoutCacheManager,
  GridLayoutItemInfo,
  LauncherLayoutCacheUtil
} from '../../../../../../../main/ets/TsIndex'
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default function FormLayoutCacheManagerTest() {
  describe('FormLayoutCacheManagerTest', () => {
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
    it('getInstance00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      // 条件1
      let layoutCacheManager1: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutCacheManager).assertEqual(layoutCacheManager1);
    })

    it('selectGridLayoutItemByCardId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = bundleName;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByCardId('1');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(demoCard);
      }catch{};
    })

    it('selectGridLayoutItemByCardId01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = bundleName;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let outerGridLayoutList = layoutCacheData.getGridLayoutItemList(true)??[];
        outerGridLayoutList.push(demoCard);
        layoutCacheData.setGridLayoutItemList(outerGridLayoutList, true);

        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByCardId('1', true);

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(demoCard);
      }catch{};
    })

    it('selectGridLayoutItemsByBundleName00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = bundleName;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        let res: GridLayoutItemInfo[] = layoutCacheManager.selectGridLayoutItemsByBundleName(bundleName);

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(1);
      }catch{};
    })

    it('selectGridLayoutItemByPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = bundleName;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByPosition(0, 0, 0);

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(demoCard);
      }catch{};
    })

    it('selectGridLayoutItemByIndex00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = bundleName;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        let demoApp: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoCard);
        demoApp.typeId = CommonConstants.TYPE_APP;
        layoutInfoList.push(demoCard);
        layoutInfoList.push(demoApp);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByIndex(-1);
        if (!res) {
          res = layoutCacheManager.selectGridLayoutItemByIndex(1)
        }
        if (!res) {
          res = layoutCacheManager.selectGridLayoutItemByIndex(0);
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(demoCard);
      }catch{};
    })

    it('selectAllAiSuggestionItems00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        let res: GridLayoutItemInfo[] = layoutCacheManager.selectAllAiSuggestionItems();

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(1);
      }catch{};
    })

    it('selectFormStackItemByFormStackId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_FORM_STACK;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        demoCard.formStackId = '11';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        let res: GridLayoutItemInfo = layoutCacheManager.selectFormStackItemByFormStackId('11');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertUndefined();
      }catch{};
    })

    it('selectAllFormsAndFormStack00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_FORM_STACK;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        demoCard.formStackId = '11';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        let res: GridLayoutItemInfo[] = layoutCacheManager.selectAllFormsAndFormStack();

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(1);
      }catch{};
    })

    it('deleteGridLayoutItemByItemId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        layoutCacheManager.deleteGridLayoutItemByItemId('1', 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(0);
      }catch{};
    })

    it('deleteGridLayoutItemByItemId01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let outerGridLayoutList = layoutCacheData.getGridLayoutItemList(true)??[];
        outerGridLayoutList.push(demoCard);
        layoutCacheData.setGridLayoutItemList(outerGridLayoutList,true);

        layoutCacheManager.deleteGridLayoutItemByItemId('1', 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(0);
      }catch{};
    })

    it('updateGridLayoutItemByPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newCard: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoCard);
        newCard.page = 1;

        layoutCacheManager.updateGridLayoutItemByPosition(0, 0, 0, null, 'DT', true);
        layoutCacheManager.updateGridLayoutItemByPosition(5, 0, 0, null, 'DT', true);
        layoutCacheManager.updateGridLayoutItemByPosition(0, 0, 0, newCard, 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let card: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          card = res[0];
        }

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(card?.page).assertEqual(1);
      }catch{};
    })

    it('updateFormStackItemById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_FORM_STACK;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        demoCard.formStackId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newCard: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoCard);
        newCard.page = 1;

        layoutCacheManager.updateFormStackItemById(null, 'DT');
        newCard.formStackId = '2';
        layoutCacheManager.updateFormStackItemById(newCard, 'DT');
        newCard.formStackId = '1';
        layoutCacheManager.updateFormStackItemById(newCard, 'DT');
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let card: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          card = res[0];
        }

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(card?.page).assertEqual(1);
      }catch{};
    })

    it('updateFormItemInfoById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newCard: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoCard);
        layoutCacheManager.updateFormItemInfoById(null, 'DT');
        layoutCacheManager.updateFormItemInfoById(newCard, 'DT');
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(2);
      }catch{};
    })

    it('insertFormToFormStack00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.insertFormToFormStack(null, [], 'DT', true);
        layoutCacheManager.insertFormToFormStack(demoCard, [], 'DT', true);
        let res: string = 'test';

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual('test');
      }catch{};
    })

    it('addCardItemToDesktop00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newCard: CardItemInfo = new CardItemInfo();
        layoutCacheManager.addCardItemToDesktop(null, 'DT', false);
        layoutCacheManager.addCardItemToDesktop(newCard, 'DT', false);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(2);
      }catch{};
    })

    it('insertFormStackItemInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        layoutCacheManager.insertFormStackItemInfo(null, [], 'DT', []);
        layoutCacheManager.insertFormStackItemInfo(newCard, [], 'DT', []);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(2);
      }catch{};
    })

    it('updateCardsFormDesktopToFormStack00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        layoutCacheManager.updateCardsFormDesktopToFormStack(null, [], 'DT', [], true);
        layoutCacheManager.updateCardsFormDesktopToFormStack(newCard, [demoCard], 'DT', [], true);
        let res: string = 'test';

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual('test');
      }catch{};
    })

    it('deleteSceneBoardFormAndStackInfos00', 0, () => {
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        layoutCacheManager.deleteSceneBoardFormAndStackInfos([], [], 'DT', true);
        let res: string = 'test';
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual('test');
      }catch{};
    })

    it('deleteSceneBoardFormAndStackInfos01', 0, () => {
      try{
        let delItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        delItem.infoId = 'infoId1';
        delItem.bundleName = 'com.ohos.weather';
        delItem.typeId = CommonConstants.TYPE_APP;

        let remainItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        remainItem.infoId = 'infoId1';
        remainItem.bundleName = 'com.ohos.weather';
        remainItem.typeId = CommonConstants.TYPE_APP;
        remainItem.formStackId = 'remain_form_stack';

        let deleteFormAndStackInfos: GridLayoutItemInfo[] = [delItem];
        let remainingStackInfos: GridLayoutItemInfo[] = [remainItem];

        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        layoutCacheManager.deleteSceneBoardFormAndStackInfos(remainingStackInfos, deleteFormAndStackInfos, 'DT', true);
        expect(true).assertTrue();
      }catch{};
    })

    it('deleteSceneBoardFormAndStackInfos01', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 1;
      itemInfo.area = [3, 3];

      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'infoId1';
      item.bundleName = 'com.ohos.weather';
      item.typeId = CommonConstants.TYPE_APP;
      item.page = 1;
      item.row = 1;
      item.column = 1;
      item.area = [1, 1];
      item.keyName = 'weather';
      item.formStackId = 'weather';
      item.layoutInfo = [[itemInfo]];
      let list :GridLayoutItemInfo[] = [];
      list.push(item);

      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      layoutCacheManager.deleteSceneBoardFormAndStackInfos(list, [], 'DT', true);
      expect(true).assertTrue();
    })

    it('updateFormAndStackInfos00', 0, () => {
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        layoutCacheManager.updateFormAndStackInfos([], 'DT', true);
        let res: string = 'test';
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual('test');
      }catch{};
    })

    it('updateFormAndStackInfos01', 0, () => {
      try{
        let item: CardItemInfo = new CardItemInfo();
        item.id = 'infoId';
        item.bundleName = 'com.ohos.music';
        item.page = 0;
        item.row = 1;
        item.column = 1;
        item.area = [1, 1];
        item.cardName = 'music';
        item.appName = 'music';
        item.moduleName = 'music_main';
        item.abilityName = 'MusicAbility';

        let list: CardItemInfo[] = [];
        list.push(item);
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        layoutCacheManager.updateFormAndStackInfos(list, 'DT', true);
        expect(true).assertTrue();
      }catch{};
    })

    it('test_deleteGridLayoutItemByBundleNameAndType', 0, () => {
      try{
        let bundleName = 'com.ohos.music';
        FormLayoutCacheManager.getInstance().deleteGridLayoutItemByBundleNameAndType(bundleName, 0, 'DT', false);
        FormLayoutCacheManager.getInstance().deleteGridLayoutItemByBundleNameAndType(bundleName, 0, 'DT', true);
        expect(true).assertTrue();
      }catch{};
    })

    it('test_deleteGridLayoutItemByPosition1', 0, () => {
      try{
        FormLayoutCacheManager.getInstance().deleteGridLayoutItemByPosition(1, 1, 1, 'DT', false);
        expect(true).assertTrue();
      }catch{};
    })

    it('test_deleteGridLayoutItemByPosition2', 0, () => {
      try{
        FormLayoutCacheManager.getInstance().deleteGridLayoutItemByPosition(1, 1, 1, 'DT', true);
        expect(true).assertTrue();
      }catch{};
    })

    it('test_deleteGridLayoutItemByPosition3', 0, () => {
      try{
        FormLayoutCacheManager.getInstance().deleteGridLayoutItemByPosition(1, 1, 1, 'DT', true, true);
        expect(true).assertTrue();
      }catch{};
    })

    it('test_selectAllFormsList1', 0, () => {
      try{
        let ret = FormLayoutCacheManager.getInstance().selectAllFormsList();
        expect(ret).not().assertNull();
      }catch{};
    })

    it('test_selectAllFormsList2', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let allFormsAndFormStackList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'infoId1';
      item.bundleName = 'com.ohos.weather';
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      item.page = 1;
      item.row = 1;
      item.column = 1;
      item.area = [1, 1];
      item.keyName = 'weather';
      item.formStackId = 'weather';
      allFormsAndFormStackList.push(item);

      let mocker: MockKit = new MockKit();
      try {
        const mockerFunc1 = mocker.mockFunc(layoutCacheManager, layoutCacheManager.selectAllFormsAndFormStack);
        when(mockerFunc1)().afterReturn(allFormsAndFormStackList);
        let ret = FormLayoutCacheManager.getInstance().selectAllFormsList();
        expect(ret).not().assertNull();
      } catch (e) {}
      mocker.clear(layoutCacheManager);
      mocker.clearAll();
    })

    it('test_selectAllFormsList2', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();

      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 1;
      itemInfo.area = [3, 3];

      let allFormsAndFormStackList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'infoId1';
      item.bundleName = 'com.ohos.weather';
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      item.page = 1;
      item.row = 1;
      item.column = 1;
      item.area = [1, 1];
      item.keyName = 'weather';
      item.formStackId = 'weather';
      item.layoutInfo = [[itemInfo]];
      allFormsAndFormStackList.push(item);

      let mocker: MockKit = new MockKit();
      try{
        const mockerFunc1 = mocker.mockFunc(layoutCacheManager, layoutCacheManager.selectAllFormsAndFormStack);
        when(mockerFunc1)().afterReturn(allFormsAndFormStackList);
        let ret = FormLayoutCacheManager.getInstance().selectAllFormsList();
        expect(ret).not().assertNull();
      } catch (e) {
      }
      mocker.clear(layoutCacheManager);
      mocker.clearAll();
    })

    it('test_checkAndDealDirtyStack_001', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let formStackInfo : GridLayoutItemInfo = gridItem1();
      formStackInfo.formStackId = 'DT';
      formStackInfo.id = 0;
      let item : GridLayoutItemInfo = gridItem1();
      formStackInfo.layoutInfo = [[item]];
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(true);
      let res = layoutCacheManager['checkAndDealDirtyStack'](formStackInfo, 'DT')
      expect(res).assertFalse();
      let mockerFunc2= mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(true);
      let res1 = layoutCacheManager['checkAndDealDirtyStack'](formStackInfo, 'DT')
      expect(res1).assertFalse();
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(false);
      let res2 = layoutCacheManager['checkAndDealDirtyStack'](formStackInfo, 'DT')
      expect(res2).assertFalse();
      let formStackInfo1 : GridLayoutItemInfo = gridItem1();
      formStackInfo1.formStackId = 'DT';
      formStackInfo1.id = 0;
      let item2 : GridLayoutItemInfo = gridItem1();
      let item3 : GridLayoutItemInfo = gridItem1();
      formStackInfo.layoutInfo = [[item, item2, item3]];
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(false);
      let res3 = layoutCacheManager['checkAndDealDirtyStack'](formStackInfo, 'DT')
      expect(res3).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('FormLayoutCacheManagerTest_isEmptyStack_5201', 0, () => {
      try{
        let cacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        const layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        layoutItem.bundleName = 'com.ohos.music';
        layoutItem.cardId = '1000';
        layoutItem.layoutInfo = []
        let res = cacheManager.isEmptyStack(layoutItem);
        const layoutItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
        layoutItem1.bundleName = 'com.ohos.music';
        layoutItem1.cardId = '1001';
        layoutItem.layoutInfo = [[layoutItem1]];
        let res1 = cacheManager.isEmptyStack(layoutItem);
        expect(layoutItem.cardId).assertEqual('1000');
      }catch{};
    })

    it('test_deletePreloadFormInFormStack_5201', 0, () => {
      let cacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      try {
        cacheManager.deletePreloadFormInFormStack(nullParam() as GridLayoutItemInfo, 'stackid', 'test');
        expect(cacheManager).not().assertNull();
      } catch(e) {}

      let bundleName = 'com.ohos.music';
      let infoId: string = '1';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let formStackId: string = '12'
      let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoCard.infoId = infoId;
      demoCard.bundleName = bundleName;
      demoCard.typeId = CommonConstants.TYPE_CARD;
      demoCard.page = 0;
      demoCard.row = 0;
      demoCard.column = 0;
      demoCard.area = [2, 2];
      demoCard.keyName = keyName;
      demoCard.cardId = '1';
      demoCard.formStackId = formStackId;
      try {
        cacheManager.deletePreloadFormInFormStack(demoCard, 'stackid', 'test');
      } catch(e){
      }

      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let defDemoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
      defDemoCard.infoId = infoId;
      defDemoCard.bundleName = bundleName;
      defDemoCard.typeId = CommonConstants.TYPE_CARD;
      defDemoCard.page = 0;
      defDemoCard.row = 0;
      defDemoCard.column = 0;
      defDemoCard.area = [2, 2];
      defDemoCard.keyName = keyName;
      defDemoCard.cardId = '1';
      defDemoCard.formStackId = formStackId;
      layoutInfoList.push(defDemoCard);
      defaultLayout.layoutInfo = layoutInfoList;
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      cacheManager.reInit(layoutCacheData);
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(layoutCacheData, layoutCacheData.getGridLayoutItemList);
        when(mockFunc)().afterReturn([defDemoCard]);
        cacheManager.deletePreloadFormInFormStack(demoCard, formStackId, 'test');
        expect(cacheManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(layoutCacheData);
      mocker.clearAll();
    })

    it('FormLayoutCacheManagerTest_deleteGridLayoutItemByBundleNameAndType_5201', 0, () => {
      let bundleName = 'com.ohos.music';
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoCard.infoId = infoId;
      demoCard.bundleName = bundleName;
      demoCard.typeId = CommonConstants.TYPE_CARD;
      demoCard.page = 0;
      demoCard.row = 0;
      demoCard.column = 0;
      demoCard.area = [2, 2];
      demoCard.keyName = keyName;
      demoCard.cardId = '1';
      layoutInfoList.push(demoCard);
      defaultLayout.layoutInfo = layoutInfoList;
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc = mocker.mockFunc(layoutCacheData, layoutCacheData.getGridLayoutItemList)
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.infoId = 'infoId1';
        item.bundleName = bundleName;
        item.typeId = CommonConstants.TYPE_FORM_STACK;
        item.page = 1;
        item.row = 1;
        item.column = 1;
        item.area = [1, 1];
        item.keyName = 'music';
        item.formStackId = 'music';
        when(mockFunc)().afterReturn([item]);
        FormLayoutCacheManager.getInstance().deleteGridLayoutItemByBundleNameAndType(bundleName, 0, 'DT');
        expect(FormLayoutCacheManager.getInstance()['layoutCacheData']).not().assertNull();
      } catch (e){};
      mocker.clear(layoutCacheData);
      mocker.clearAll();
    })

    it('FormLayoutCacheManagerTest_deleteGridLayoutItemByPosition_5201', 0, () => {
      try{
        FormLayoutCacheManager.getInstance().deleteGridLayoutItemByPosition(1, 1, 1, 'DT');
        expect(true).assertTrue();
      }catch{};
    })

    it('FormLayoutCacheManagerTest_getAllFormsLen_5201', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_CARD
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 1;
      itemInfo.area = [3, 3];
      let itemInfo1 = new GridLayoutItemInfo();
      itemInfo1.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo1.bundleName = 'com.test.name';
      itemInfo1.moduleName = 'test_module';
      itemInfo1.page = 1;
      itemInfo1.area = [3, 2];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'infoId1';
      item.bundleName = 'com.ohos.weather';
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      item.page = 1;
      item.row = 1;
      item.column = 1;
      item.area = [1, 1];
      item.keyName = 'weather';
      item.formStackId = 'weather';
      itemInfo1.layoutInfo = [[itemInfo]];
      let itemInfo2 = new GridLayoutItemInfo();
      itemInfo2.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo2.bundleName = 'com.test.name';
      itemInfo2.moduleName = 'test_module';
      itemInfo2.page = 1;
      itemInfo2.area = [3, 2];
      itemInfo1.layoutInfo = [];
      let mocker: MockKit = new MockKit();
      try{
        const mockerFunc1 = mocker.mockFunc(layoutCacheManager, layoutCacheManager.selectAllFormsAndFormStack);
        when(mockerFunc1)().afterReturn([itemInfo, itemInfo1, itemInfo2]);
        let ret = layoutCacheManager.getAllFormsLen();
        expect(ret).assertEqual(1);
      } catch (e) {
      }
      mocker.clear(layoutCacheManager);
      mocker.clearAll();
    })

    it('test_updateCardIdOfFormStack', 0, async (done: Function) => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let newCard: CardItemInfo = new CardItemInfo();
      newCard.bundleName = 'com.ohos.CardName';
      newCard.cardId = 'com.ohos.CardName';
      let formStackId: string = 'id12233';
      let newCardId: string = 'newcardid1111';
      let containerId: number = 12;
      let mocker: MockKit = new MockKit();
      let layoutCacheData: DesktopLayoutCacheData = layoutCacheManager['layoutCacheData'];
      try{
        const mockerFunc = mocker.mockFunc(layoutCacheData, layoutCacheData.getGridLayoutItemList);
        let itemInfo = new GridLayoutItemInfo();
        itemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
        itemInfo.bundleName = 'com.test.name';
        itemInfo.moduleName = 'test_module';
        itemInfo.page = 1;
        itemInfo.area = [3, 3];
        itemInfo.layoutInfo = [[]];
        itemInfo.formStackId = formStackId;
        when(mockerFunc)().afterReturn([itemInfo]);
        await layoutCacheManager.updateCardIdOfFormStack(formStackId, newCardId, newCard, containerId);
        let emptyArr = CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo[0]);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.cardId = newCardId;
        item.bundleName = 'com.ohos.CardName';
        item.typeId = CommonConstants.TYPE_FORM_STACK;
        item.page = 1;
        item.row = 1;
        item.column = 1;
        item.area = [1, 1];
        item.keyName = 'weather';
        item.formStackId = formStackId;
        itemInfo.layoutInfo = [[item]];
        await layoutCacheManager.updateCardIdOfFormStack(formStackId, newCardId, newCard, containerId);
        let emptyArr1 = CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo[0]);
        expect(emptyArr1).assertFalse();
      } catch (e) {
      }
      mocker.clear(layoutCacheData);
      mocker.clearAll();
      done();
    })

    it('test_updateCardIdOfFormStack_001', 0, async (done: Function) => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let newCard: CardItemInfo = new CardItemInfo();
      newCard.bundleName = 'com.ohos.CardName';
      newCard.cardId = 'com.ohos.CardName';
      let formStackId: string = 'id12233';
      let newCardId: string = 'newcardid1111';
      let containerId: number = 12;
      let mocker: MockKit = new MockKit();
      let layoutCacheData: DesktopLayoutCacheData = layoutCacheManager['layoutCacheData'];
      try {
        const mockerFunc = mocker.mockFunc(layoutCacheData, layoutCacheData.getGridLayoutItemList);
        let itemInfo = new GridLayoutItemInfo();
        itemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
        itemInfo.bundleName = 'com.test.name';
        itemInfo.moduleName = 'test_module';
        itemInfo.page = 1;
        itemInfo.area = [3, 3];
        itemInfo.layoutInfo = [[]];
        itemInfo.formStackId = formStackId;
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.cardId = '';
        item.bundleName = 'com.ohos.CardName123';
        item.typeId = CommonConstants.TYPE_FORM_STACK;
        item.page = 1;
        item.row = 1;
        item.column = 1;
        item.area = [1, 1];
        item.keyName = 'weather';
        item.formStackId = formStackId;
        itemInfo.layoutInfo = [[item]];
        when(mockerFunc)().afterReturn([itemInfo]);
        await layoutCacheManager.updateCardIdOfFormStack(formStackId, newCardId, newCard, containerId);
        let emptyArr1 = CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo[0]);
        expect(emptyArr1).assertFalse();
      } catch (e) {}
      mocker.clear(layoutCacheData);
      mocker.clearAll();
      done();
    })

    it('test_updateCardIdOfFormStack_002', 0, async (done: Function) => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let newCard: CardItemInfo = new CardItemInfo();
      newCard.bundleName = 'com.ohos.CardName';
      newCard.cardId = 'com.ohos.CardName';
      newCard.extend1 = 'extend1test'
      let formStackId: string = 'id12233';
      let newCardId: string = 'newcardid1111';
      let containerId: number = 12;
      let mocker: MockKit = new MockKit();
      let layoutCacheData: DesktopLayoutCacheData = layoutCacheManager['layoutCacheData'];
      try {
        const mockerFunc = mocker.mockFunc(layoutCacheData, layoutCacheData.getGridLayoutItemList);
        let itemInfo = new GridLayoutItemInfo();
        itemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
        itemInfo.bundleName = 'com.test.name';
        itemInfo.moduleName = 'test_module';
        itemInfo.page = 1;
        itemInfo.area = [3, 3];
        itemInfo.layoutInfo = [[]];
        itemInfo.formStackId = formStackId;
        itemInfo.extend1 = 'extend1test'
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.cardId = 'com.ohos.CardName';
        item.bundleName = 'com.ohos.CardName';
        item.typeId = CommonConstants.TYPE_FORM_STACK;
        item.page = 1;
        item.row = 1;
        item.column = 1;
        item.area = [1, 1];
        item.keyName = 'weather';
        item.formStackId = formStackId;
        itemInfo.layoutInfo = [[item]];
        when(mockerFunc)().afterReturn([itemInfo]);
        await layoutCacheManager.updateCardIdOfFormStack(formStackId, newCardId, newCard, containerId);
        let emptyArr1 = CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo[0]);
        expect(emptyArr1).assertFalse();
      } catch (e) {}
      mocker.clear(layoutCacheData);
      mocker.clearAll();
      done();
    })

    it('test_selectAllFormsList_001', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let allFormsAndFormStackList: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_CARD;
      allFormsAndFormStackList.push(item1);

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_FORM_STACK;
      allFormsAndFormStackList.push(item2);
      let item21: GridLayoutItemInfo = new GridLayoutItemInfo();
      item21.typeId = CommonConstants.TYPE_FORM_STACK;
      item21.layoutInfo =[[]];
      allFormsAndFormStackList.push(item21);
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_FORM_STACK;
      let item31: GridLayoutItemInfo = new GridLayoutItemInfo();
      item31.typeId = CommonConstants.TYPE_FORM_STACK;
      item31.cardDimension = 100;
      item31.area = [2, 2];
      let item32: GridLayoutItemInfo = new GridLayoutItemInfo();
      item32.typeId = CommonConstants.TYPE_FORM_STACK;
      item32.cardDimension = 101;
      item32.area = [2, 2];
      item3.layoutInfo =[[item31,item32]];
      allFormsAndFormStackList.push(item3);
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.typeId = CommonConstants.TYPE_FORM_COMBINE;
      allFormsAndFormStackList.push(item4);
      let mocker: MockKit = new MockKit();
      try{
        const mockerFunc1 = mocker.mockFunc(layoutCacheManager, layoutCacheManager.selectAllFormsAndFormStack);
        when(mockerFunc1)().afterReturn(allFormsAndFormStackList);
        let ret = layoutCacheManager.selectAllFormsList();
        expect(ret.length).assertEqual(3);
      } catch (e) {
      }
      mocker.clear(layoutCacheManager);
      mocker.clearAll();
    })

    it('test_selectFormStackItemByFormStackId_checkAndDealDirtyStack001', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let formStackId: string = 'testFormStackid';
      let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoCard.infoId = infoId;
      demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      demoCard.typeId = CommonConstants.TYPE_FORM_STACK;
      demoCard.page = 0;
      demoCard.row = 0;
      demoCard.column = 0;
      demoCard.area = [2, 2];
      demoCard.keyName = keyName;
      demoCard.cardId = '1';
      demoCard.formStackId = formStackId;
      layoutInfoList.push(demoCard);
      defaultLayout.layoutInfo = layoutInfoList;
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let mocker: MockKit = new MockKit();
      try {
        const mockerFunc1 = mocker.mockFunc(layoutCacheData, layoutCacheData.getGridLayoutItemList);
        when(mockerFunc1)(ArgumentMatchers.any).afterReturn([demoCard]);
        let res: GridLayoutItemInfo = layoutCacheManager.selectFormStackItemByFormStackId('11');
        expect(res).assertUndefined();
        let res1: GridLayoutItemInfo = layoutCacheManager.selectFormStackItemByFormStackId(formStackId);
        expect(res1).assertUndefined();
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.infoId = infoId;
        item1.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        item1.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        item1.typeId = CommonConstants.TYPE_FORM_STACK;
        item1.cardId = '12230';
        demoCard.layoutInfo = [[item1]];
        when(mockerFunc1)(ArgumentMatchers.any).afterReturn([demoCard]);
        let res2: GridLayoutItemInfo = layoutCacheManager.selectFormStackItemByFormStackId(formStackId);
        expect(res2).assertUndefined();
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.infoId = infoId;
        item2.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        item2.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        item2.typeId = CommonConstants.TYPE_FORM_STACK;
        item2.cardId = '1223';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.infoId = infoId;
        item3.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        item3.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        item3.typeId = CommonConstants.TYPE_FORM_STACK;
        item3.cardId = '12233';
        demoCard.layoutInfo = [[item2, item3]];
        when(mockerFunc1)(ArgumentMatchers.any).afterReturn([demoCard]);
        let res3: GridLayoutItemInfo = layoutCacheManager.selectFormStackItemByFormStackId(formStackId);
        expect(res3).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(layoutCacheData);
      mocker.clearAll();
    })

    it('test_selectAllAiSuggestionItems_001', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let cacheData: DesktopLayoutCacheData = layoutCacheManager['layoutCacheData'];
      let mocker: MockKit = new MockKit();
      try{
        const mockerFunc1 = mocker.mockFunc(cacheData, cacheData.getGridLayoutItemList);
        let items: GridLayoutItemInfo[] = createLayoutItems();
        when(mockerFunc1)().afterReturn(items);
        let res: GridLayoutItemInfo[] = layoutCacheManager.selectAllAiSuggestionItems();
        expect(res.length > 0).assertTrue();
      } catch (e) {
      }
      mocker.clear(cacheData);
      mocker.clearAll();
    })

    it('test_selectAllFormsList_0023', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let mockerFunc1 = mocker.mockFunc(layoutCacheManager, layoutCacheManager.selectAllFormsAndFormStack);
        let items: GridLayoutItemInfo[] = createLayoutItems();
        when(mockerFunc1)().afterReturn(items);
        let res: GridLayoutItemInfo[] = layoutCacheManager.selectAllFormsList();
        expect(res.length > 0).assertTrue();
      } catch (e) {}
      mocker.clear(layoutCacheManager);
      mocker.clearAll();
    })

    it('test_deleteGridLayoutItemByPosition_catch', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.deleteFormInfoByPositionCallback);
      when(mockerFunc1)(ArgumentMatchers.any).afterThrow('testeeror');
      layoutCacheManager.deleteGridLayoutItemByPosition(1, 1, 1, 'DT', true);
      expect(layoutCacheManager).not().assertNull();
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_deleteGridLayoutItemByBundleNameAndType_003', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let bundleName = 'com.ohos.music';
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.deleteFormInfoByBundleCallback);
      when(mockerFunc1)(ArgumentMatchers.any).afterThrow('testeeror');
      layoutCacheManager.deleteGridLayoutItemByBundleNameAndType(bundleName, 0, 'DT', true);
      expect(layoutCacheManager).not().assertNull();
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_updateGridLayoutItemByPosition_001', 0, async (done: Function) => {
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoCard.infoId = infoId;
        demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
        demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
        demoCard.typeId = CommonConstants.TYPE_CARD;
        demoCard.page = 0;
        demoCard.row = 0;
        demoCard.column = 0;
        demoCard.area = [2, 2];
        demoCard.keyName = keyName;
        demoCard.cardId = '1';
        demoCard.layoutInfo = [[]];
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newCard: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoCard);
        newCard.page = 1;
        await layoutCacheManager.updateGridLayoutItemByPosition(0, 0, 0, nullParam() as GridLayoutItemInfo, 'DT', true);
        expect(CheckEmptyUtils.isEmpty(newCard)).assertFalse();
        await layoutCacheManager.updateGridLayoutItemByPosition(5, 0, 0, nullParam() as GridLayoutItemInfo, 'DT', true);
        expect(demoCard.page).not().assertEqual(5);
        await layoutCacheManager.updateGridLayoutItemByPosition(0, 0, 0, newCard, 'DT', true);
        expect(demoCard.page).not().assertEqual(5);
        await layoutCacheManager.updateGridLayoutItemByPosition(0, 0, 0, newCard, 'DT', false);
        expect(newCard.page).not().assertEqual(demoCard.page);
      }catch{};
      done();
    })

    it('test_changeStackToCard_001', 0, () => {
      try{
        let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
        let item:GridLayoutItemInfo = new GridLayoutItemInfo();
        item.page = 0;
        item.row = 0;
        item.column = 1;
        item.bundleName = 'com.ohos.sugesture';
        layoutCacheManager.changeStackToCard(nullParam() as GridLayoutItemInfo, nullParam() as GridLayoutItemInfo);
        expect(layoutCacheManager).not().assertUndefined();
        layoutCacheManager.changeStackToCard(item, nullParam() as GridLayoutItemInfo);
        let needFalse: boolean = !nullParam();
        expect(needFalse).assertTrue();
        let remainingCard:GridLayoutItemInfo = new GridLayoutItemInfo();
        remainingCard.page = 1;
        remainingCard.row = 0;
        remainingCard.column = 1;
        remainingCard.bundleName = 'com.ohos.sugesture';
        layoutCacheManager.changeStackToCard(item, remainingCard);
        expect(remainingCard).not().assertEqual(item);
      }catch{};
    })

    it('test_updateFormItemInfoById_001', 0,  async (done: Function) => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoCard.infoId = infoId;
      demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      demoCard.typeId = CommonConstants.TYPE_CARD;
      demoCard.page = 0;
      demoCard.row = 0;
      demoCard.column = 0;
      demoCard.area = [2, 2];
      demoCard.keyName = keyName;
      demoCard.cardId = '1';
      layoutInfoList.push(demoCard);
      defaultLayout.layoutInfo = layoutInfoList;
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let newCard: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoCard);
      let mocker: MockKit = new MockKit();
      try {
        layoutCacheManager.updateFormItemInfoById(nullParam() as GridLayoutItemInfo, 'DT');
        let needFalse: boolean = CheckEmptyUtils.isEmpty(nullParam());
        layoutCacheManager.updateFormItemInfoById(newCard, 'DT');
        let mockerFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
        let mockerFunc1 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.updateFormInfoByIdChange);
        when(mockerFunc1)(ArgumentMatchers.any).afterThrow('testeeror');
        layoutCacheManager.updateFormItemInfoById(newCard, 'DT', true);
        layoutCacheManager.updateFormItemInfoById(newCard, 'DT', false);
        expect(needFalse).assertTrue();
      } catch (e) {
      }
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_addCardItemToDesktop_001', 0, async (done: Function)  => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
       try{
         layoutCacheManager.addCardItemToDesktop(nullParam() as CardItemInfo, 'DT');
         let needFalse: boolean = CheckEmptyUtils.isEmpty(nullParam());
         expect(needFalse).assertTrue();
         let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
         let layoutInfoList: GridLayoutItemInfo[] = [];
         let infoId: string = '1';
         let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
         let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
         demoCard.infoId = infoId;
         demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
         demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
         demoCard.typeId = CommonConstants.TYPE_CARD;
         demoCard.page = 0;
         demoCard.row = 0;
         demoCard.column = 0;
         demoCard.area = [2, 2];
         demoCard.keyName = keyName;
         demoCard.cardId = '1';
         layoutInfoList.push(demoCard);
         defaultLayout.layoutInfo = layoutInfoList;
         let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
         layoutCacheManager.reInit(layoutCacheData);
         let newCard: CardItemInfo = new CardItemInfo();
         layoutCacheManager.addCardItemToDesktop(newCard, 'DT');
         let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
         let mockerFunc1 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.updateFormInfoByIdChange);
         when(mockerFunc1)(ArgumentMatchers.any).afterThrow('testeeror');
         layoutCacheManager.addCardItemToDesktop(newCard, 'DT');
         expect(res.length > 0).assertTrue();
       } catch (e) {
       }
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
      done();

    })

    it('test_insertFormStackItemInfo_001', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let demoCard: GridLayoutItemInfo = gridItem1();
      layoutInfoList.push(demoCard);
      defaultLayout.layoutInfo = layoutInfoList;
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      let mocker: MockKit = new MockKit();
      try{
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.insertFormStackItemInfo(nullParam() as GridLayoutItemInfo, [], 'DT', []);
        let needFalse: boolean = CheckEmptyUtils.isEmpty(nullParam());
        expect(needFalse).assertTrue();
        let newCard: GridLayoutItemInfo = gridItem1();
        let mockerFunc1 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.insertNewFormStackInfoCallBack);
        when(mockerFunc1)(ArgumentMatchers.any).afterThrow('testeeror');
        layoutCacheManager.insertFormStackItemInfo(newCard, [], 'DT', []);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        expect(res.length>0).assertTrue();
      } catch (e){}
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_updateCardsFormDesktopToFormStacko_001', 0, () => {
      let layoutCacheManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let mocker: MockKit = new MockKit();
      try {
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let demoCard: GridLayoutItemInfo = gridItem1();
        layoutInfoList.push(demoCard);
        defaultLayout.layoutInfo = layoutInfoList;
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.updateCardsFormDesktopToFormStack(nullParam() as GridLayoutItemInfo, [], 'DT', [], true);
        let needFalse: boolean = CheckEmptyUtils.isEmpty(nullParam());
        expect(needFalse).assertTrue();
        let newCard: GridLayoutItemInfo = gridItem1();
        let mockerFunc1 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.insertNewFormStackInfoCallBack);
        when(mockerFunc1)(ArgumentMatchers.any).afterThrow('testeeror');
        layoutCacheManager.updateCardsFormDesktopToFormStack(newCard, [], 'DT', [], false);
        layoutCacheManager.updateCardsFormDesktopToFormStack(newCard, [], 'DT', [], true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        expect(res.length>0).assertTrue();
      } catch (e) {}
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })
  })

}
function gridItem1(): GridLayoutItemInfo {
  let infoId: string = '1';
  let bundleName: string = 'com.openharmony.demoApp';
  let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
  let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  demoCard.infoId = infoId;
  demoCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
  demoCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
  demoCard.typeId = CommonConstants.TYPE_CARD;
  demoCard.page = 0;
  demoCard.row = 0;
  demoCard.column = 0;
  demoCard.area = [2, 2];
  demoCard.keyName = keyName;
  demoCard.formStackId = '1';
  demoCard.cardId = '1';
  return demoCard;
}


function nullParam(): GridLayoutItemInfo | CardItemInfo | undefined {
  return undefined
}

function createLayoutItems(): GridLayoutItemInfo[] {
  let lists: GridLayoutItemInfo[] = [];
  let item: GridLayoutItemInfo = new GridLayoutItemInfo();
  item.area = [0, 1];
  item.folderId = 'lkqkw4s76q0592qwa4g';
  item.row = 2;
  item.column = 2;
  item.typeId = CommonConstants.TYPE_FORM_STACK;
  item.isInDock = false;
  item.page = 1;
  item.layoutInfo = [[]];
  lists.push(item);

  let item0: GridLayoutItemInfo = new GridLayoutItemInfo();
  item0.area = [0, 1];
  item0.folderId = 'lkqkw4s76q0592qwa4g';
  item0.row = 2;
  item0.column = 2;
  item0.typeId = CommonConstants.TYPE_FORM_STACK;
  item0.isInDock = false;
  item0.page = 1;
  lists.push(item0);

  let item01: GridLayoutItemInfo = new GridLayoutItemInfo();
  item01.area = [0, 1];
  item01.folderId = 'lkqkw4s76q0592qwa4g';
  item01.row = 2;
  item01.column = 2;
  item01.typeId = CommonConstants.TYPE_FOLDER;
  item01.isInDock = false;
  item01.page = 1;
  lists.push(item01);

  let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
  item1.area = [1, 1];
  item1.folderId = 'lkqkw4s76q0592qwa4g';
  item1.row = 2;
  item1.column = 2;
  item1.typeId = CommonConstants.TYPE_FORM_STACK;
  item1.isInDock = false;
  item1.page = 1;
  let item1LayoutInfo: GridLayoutItemInfo[] = [];
  for (let index = 0; index < 3; index++) {
    let item0: GridLayoutItemInfo = new GridLayoutItemInfo();
    item0.typeId = CommonConstants.TYPE_CARD;
    item0.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
    item0.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
    item1LayoutInfo.push(item0);
  }
  item1.layoutInfo = [item1LayoutInfo];
  lists.push(item1);
  return lists;
}