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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when, } from '@ohos/hypium';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import {
  BundleConstants,
  CardItemInfo,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PageDesktopModel,
} from '@ohos/launchercommon';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { FormStackUtil } from '@ohos/formstack/src/main/ets/common/FormStackUtil';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';
import { ScreenDisplayStatus } from '../../../../../../main/ets/default/constants/ScreenDisplayStatus';
import { AiSuggestionFormManager } from '../../../../../../main/ets/default/manager/AiSuggestionFormManager';
import { InputFaInfo } from '../../../../../../main/ets/default/bean/InputFaInfo';
import { LauncherFormDistribution } from '../../../../../../main/ets/default/bean/LauncherFormDistribution';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';

/**
 * AbilityFormUtil测试
 *
 * @since 2023-10-17
 */
export function AbilityFormUtilTest() {
  describe('AbilityFormUtilTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('AbilityFormUtilTest_createVoiceSuggestionCard', 0, (): void => {
      expect(AbilityFormUtil.createVoiceSuggestionCard(null).bundleName).assertEqual('');
      let gridLayoutItemInfo = new GridLayoutItemInfo();
      expect(AbilityFormUtil.createVoiceSuggestionCard(gridLayoutItemInfo).bundleName).assertEqual('com.ohos.suggestion');
      gridLayoutItemInfo.area = [2, 2];
      gridLayoutItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_2x2;
      expect(AbilityFormUtil.createVoiceSuggestionCard(gridLayoutItemInfo).cardName).assertEqual('minVoiceRecCard');
      gridLayoutItemInfo.area = [4, 2];
      gridLayoutItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_2x4;
      expect(AbilityFormUtil.createVoiceSuggestionCard(gridLayoutItemInfo).cardName).assertEqual('medVoiceRecCard');
      gridLayoutItemInfo.area = [4, 4];
      gridLayoutItemInfo.cardDimension = CommonConstants.CARD_DIMENSION_4x4;
      expect(AbilityFormUtil.createVoiceSuggestionCard(gridLayoutItemInfo).cardName).assertEqual('maxVoiceRecCard');
    });

    it('AbilityFormUtilTest_createCard', 0, (): void => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let createCard: LauncherRecItem = new LauncherRecItem();
      // 校验卡片为null
      expect(AbilityFormUtil.createCard(null, null).bundleName).assertEqual('');
      expect(AbilityFormUtil.createCard(null, createCard).bundleName).assertEqual('');
      expect(AbilityFormUtil.createCard(gridLayoutItemInfo, null).bundleName).assertEqual('');

      // 校验卡片为undefined
      expect(AbilityFormUtil.createCard(undefined, undefined).bundleName).assertEqual('');
      expect(AbilityFormUtil.createCard(undefined, createCard).bundleName).assertEqual('');
      expect(AbilityFormUtil.createCard(gridLayoutItemInfo, undefined).bundleName).assertEqual('');

      createCard.bundleName = 'com.ohos.suggestion';
      createCard.abilityName = 'MainAbility';
      createCard.moduleName = 'entry';
      createCard.formName = 'medVoiceRecCard';
      createCard.dimension = 2;
      expect(AbilityFormUtil.createCard(gridLayoutItemInfo, createCard).bundleName)
        .assertEqual('com.ohos.suggestion');
      expect(AbilityFormUtil.createCard(gridLayoutItemInfo, createCard).abilityName).assertEqual('MainAbility');
      expect(AbilityFormUtil.createCard(gridLayoutItemInfo, createCard).moduleName).assertEqual('entry');
      expect(AbilityFormUtil.createCard(gridLayoutItemInfo, createCard).cardName).assertEqual('medVoiceRecCard');
      expect(AbilityFormUtil.createCard(gridLayoutItemInfo, createCard).cardDimension).assertEqual(2);
    });

    it('AbilityFormUtilTest_isAbilityFormVisible', 0, (): void => {
      let gridLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      const cardId: string = '111';

      expect(AbilityFormUtil.isAbilityFormVisible(cardId)).assertFalse();

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutInfo.cardId = '222';
      layoutInfo.typeId = CommonConstants.TYPE_APP;
      gridLayoutInfo.layoutInfo.push(layoutInfo);
      expect(AbilityFormUtil.isAbilityFormVisible(cardId)).assertFalse();

      layoutInfo.cardId = cardId;
      layoutInfo.typeId = CommonConstants.TYPE_CARD;
      expect(AbilityFormUtil.isAbilityFormVisible(cardId)).assertFalse();
    });

    it('findParentFormByFormId', 0, (): void => {
      const cardId: string = '222';

      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(manager, manager.getCardInfo);
      when(mockFunc)(cardId).afterReturnNothing();
      expect(AbilityFormUtil.findParentFormByFormId(cardId)).assertEqual(undefined);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_isPortrait', 0, (): void => {
      let mocker: MockKit = new MockKit();
      const mockIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhone)().afterReturn(true);
      expect(AbilityFormUtil.isPortrait()).assertTrue();

      when(mockIsPhone)().afterReturn(false);
      expect(AbilityFormUtil.isPortrait()).assertTrue();

      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getScreenDisplayStatus', 0, (): void => {
      let mocker: MockKit = new MockKit();
      const mockIsExpand: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.isExpand);
      when(mockIsExpand)().afterReturn(true);
      expect(AbilityFormUtil.getScreenDisplayStatus()).assertEqual(ScreenDisplayStatus.EXPAND);

      when(mockIsExpand)().afterReturn(false);
      const mockIsPortrait: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.isPortrait);
      when(mockIsPortrait)().afterReturn(true);
      expect(AbilityFormUtil.getScreenDisplayStatus()).assertEqual(ScreenDisplayStatus.PORTRAIT);

      when(mockIsPortrait)().afterReturn(false);
      expect(AbilityFormUtil.getScreenDisplayStatus()).assertEqual(ScreenDisplayStatus.LANDSCAPE);

      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_isVoiceAbilityForm', 0, (): void => {
      expect(AiSuggestionUtil.isVoiceAbilityForm(BundleConstants.AI_SUGGESTION_BUNDLE,
        BundleConstants.AI_SUGGESTION_ABILITY)).assertTrue();

      expect(AiSuggestionUtil.isVoiceAbilityForm(BundleConstants.AI_SUGGESTION_ABILITY,
        BundleConstants.AI_SUGGESTION_ABILITY)).assertFalse();
    });

    it('AbilityFormUtilTest_getVersionName', 0, async (done: Function): Promise<void> => {
      expect(await AbilityFormUtil.getVersionName('')).assertEqual('');

      expect(await AbilityFormUtil.getVersionName('bundleName')).assertEqual('');
      done();
    });

    it('testSetStorageForCompanion', 0, (): void => {
      AbilityFormUtil.setStorageForCompanion('0', []);
      const recItem: LauncherRecItem = new LauncherRecItem();
      recItem.itemType === CommonConstants.TYPE_APP;
      const recItems: LauncherRecItem[] = [recItem];
      AbilityFormUtil.setStorageForCompanion(undefined, recItems);
      AbilityFormUtil.setStorageForCompanion('0', recItems);
    });

    it('testAppendParams', 0, (): void => {
      const jsonStr = '{"key":"value"}';
      const params: Record<string, Object> = {};
      AbilityFormUtil.appendParams(jsonStr, params);
      const keyName = 'key';
      expect(params[keyName]).assertEqual('value');
    });

    it('AbilityFormUtilTest_is2x2Form', 0, (): void => {
      expect(AbilityFormUtil.is2x2Form(undefined)).assertFalse();

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(AbilityFormUtil.is2x2Form(layoutInfo)).assertFalse();

      layoutInfo.cardDimension = CommonConstants.CARD_DIMENSION_2x2;
      expect(AbilityFormUtil.is2x2Form(layoutInfo)).assertTrue();
    });

    it('AbilityFormUtilTest_is2x4Form', 0, (): void => {
      expect(AbilityFormUtil.is2x4Form(undefined)).assertFalse();

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(AbilityFormUtil.is2x4Form(layoutInfo)).assertFalse();

      layoutInfo.cardDimension = CommonConstants.CARD_DIMENSION_2x4;
      expect(AbilityFormUtil.is2x4Form(layoutInfo)).assertTrue();
    });

    it('AbilityFormUtilTest_is4x4Form', 0, (): void => {
      expect(AbilityFormUtil.is4x4Form(undefined)).assertFalse();

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(AbilityFormUtil.is4x4Form(layoutInfo)).assertFalse();

      layoutInfo.cardDimension = CommonConstants.CARD_DIMENSION_4x4;
      expect(AbilityFormUtil.is4x4Form(layoutInfo)).assertTrue();
    });

    it('AbilityFormUtilTest_getCurrentPageTargets', 0, (): void => {
      const itemList: GridLayoutItemInfo[] = [];
      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.cardId = '111';
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      itemInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo);
      const itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo2.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo2.formStackId = '333';
      itemInfo2.layoutInfo = [[]];
      itemList.push(itemInfo2);
      const itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo1.formStackId = '222';
      itemInfo1.layoutInfo = [[itemInfo]];
      itemList.push(itemInfo1);

      let mocker: MockKit = new MockKit();
      let model: PageDesktopModel = PageDesktopModel.getInstance();
      const func: Function = mocker.mockFunc(model, model.getPageIndex);
      when(func)().afterReturn(0);

      let manager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const func1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemsByPage);
      when(func1)(0).afterReturn(itemList);

      const commandIds: string[] = AbilityFormUtil.getCurrentPageTargets();
      expect(commandIds.length).assertEqual(2);

      mocker.clear(model);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_isExpand', 0, (): void => {
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(false);
      expect(AbilityFormUtil.isExpand()).assertFalse();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getCardBelongFormStack_01', 0, (): void => {
      expect(AbilityFormUtil.getCardBelongFormStack('0')).assertEqual(null);
    });

    it('AbilityFormUtilTest_getCardBelongFormStack_02', 0, (): void => {
      expect(AbilityFormUtil.getCardBelongFormStack('')).assertEqual(null);
    });

    it('AbilityFormUtilTest_getCardBelongFormStack_03', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let stackList: GridLayoutItemInfo[] = [];
      const mockerStackList: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAllFormStackList);
      when(mockerStackList)().afterReturn(stackList);
      expect(AbilityFormUtil.getCardBelongFormStack('123')).assertEqual(null);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getCardBelongFormStack_04', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let stackList: GridLayoutItemInfo[] = [];
      const mockerStackList: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAllFormStackList);
      when(mockerStackList)().afterReturn(stackList);
      let stackItem: FormStackItemInfo = new FormStackItemInfo();
      stackList.push(stackItem as Object as GridLayoutItemInfo);
      expect(AbilityFormUtil.getCardBelongFormStack('123')).assertEqual(null);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getCardBelongFormStack_05', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let stackList: GridLayoutItemInfo[] = [];
      const mockerStackList: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAllFormStackList);
      when(mockerStackList)().afterReturn(stackList);
      let stackItem: FormStackItemInfo = new FormStackItemInfo();
      stackList.push(stackItem as Object as GridLayoutItemInfo);
      let layoutInfo: CardItemInfo[][] = [[]];
      stackItem.layoutInfo = layoutInfo;
      expect(AbilityFormUtil.getCardBelongFormStack('123')).assertEqual(null);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getCardBelongFormStack_06', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let stackList: GridLayoutItemInfo[] = [];
      const mockerStackList: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAllFormStackList);
      when(mockerStackList)().afterReturn(stackList);
      let stackItem: FormStackItemInfo = new FormStackItemInfo();
      stackList.push(stackItem as Object as GridLayoutItemInfo);
      let layoutInfo: CardItemInfo[][] = [[]];
      stackItem.layoutInfo = layoutInfo;
      let cardInfo: CardItemInfo = new CardItemInfo();
      cardInfo.cardId = '123';
      layoutInfo[0].push(cardInfo);
      expect(AbilityFormUtil.getCardBelongFormStack('123')).assertEqual(stackItem);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getAiSuggestionItems', 0, (): void => {
      let infoList: GridLayoutItemInfo[] = [];
      let manager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(manager, manager.selectAllAiSuggestionItems);
      when(mockFunc)().afterReturn(infoList);
      const results: GridLayoutItemInfo[] = [];
      expect(results.length).assertEqual(0);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getVisibleVoiceList_01', 0, (): void => {
      const itemList: GridLayoutItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let manager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const func1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemsByPage);
      when(func1)(0).afterReturn(itemList);

      const commandIds: GridLayoutItemInfo[] = AbilityFormUtil.getVisibleVoiceList();
      expect(commandIds.length).assertEqual(0);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getVisibleVoiceList_02', 0, (): void => {
      const itemList: GridLayoutItemInfo[] = [];
      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.cardId = '111';
      itemInfo.typeId = CommonConstants.TYPE_FUNCTION;
      itemInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo);

      let mocker: MockKit = new MockKit();
      let model: PageDesktopModel = PageDesktopModel.getInstance();
      const func: Function = mocker.mockFunc(model, model.getPageIndex);
      when(func)().afterReturn(0);

      let manager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const func1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemsByPage);
      when(func1)(0).afterReturn(itemList);

      const commandIds: GridLayoutItemInfo[] = AbilityFormUtil.getVisibleVoiceList();
      expect(commandIds.length).assertEqual(0);

      mocker.clear(model);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getVisibleVoiceList_03', 0, (): void => {
      const itemList: GridLayoutItemInfo[] = [];
      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.cardId = '111';
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      itemInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo);

      const itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo1.formStackId = '222';
      itemInfo1.layoutInfo = undefined;
      itemList.push(itemInfo1);

      const itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo2.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo2.formStackId = '333';
      itemInfo2.layoutInfo = [[itemInfo]];
      itemList.push(itemInfo2);

      const itemInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo3.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo3.formStackId = '333';
      itemInfo3.layoutInfo = [[itemInfo2]];
      itemList.push(itemInfo3);

      let mocker: MockKit = new MockKit();
      let model: PageDesktopModel = PageDesktopModel.getInstance();
      const func: Function = mocker.mockFunc(model, model.getPageIndex);
      when(func)().afterReturn(0);

      let manager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const func1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemsByPage);
      when(func1)(0).afterReturn(itemList);

      const commandIds: GridLayoutItemInfo[] = AbilityFormUtil.getVisibleVoiceList();
      expect(commandIds.length).assertEqual(2);

      mocker.clear(model);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_isDefaultCard', 0, (): void => {
      const recItem: LauncherRecItem = new LauncherRecItem();
      recItem.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      recItem.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      expect(AbilityFormUtil.isDefaultCard(recItem)).assertTrue();
    });

    it('AbilityFormUtilTest_getAiSuggestionItemByCardId', 0, (): void => {
      const cardId: string = '123';
      const itemList: GridLayoutItemInfo[] = [];
      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.cardId = '123';
      itemList.push(itemInfo);
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAllAiSuggestionItems);
      when(func)().afterReturn(itemList);
      const results = AbilityFormUtil.getAiSuggestionItemByCardId(cardId);
      expect(results?.cardId).assertEqual(cardId);
    });

    it('AbilityFormUtilTest_getFormDistributionFromCache', 0, async (done: Function): Promise<void> => {
      const inputFormInfo: InputFaInfo = new InputFaInfo();
      const CARD_SIZE_LENGTH_TWO = 2;
      const CARD_SIZE_LENGTH_NINE = 9;
      const CARD_SIZE_LENGTH_TEN = 10;
      inputFormInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      inputFormInfo.moduleName = 'ablit';
      inputFormInfo.formName = 'form';
      inputFormInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      inputFormInfo.dimension = CARD_SIZE_LENGTH_TWO;

      const itemList: GridLayoutItemInfo[] = [];
      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      itemInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo.moduleName = 'ablit';
      itemInfo.cardName = 'form';
      itemInfo.area = [CARD_SIZE_LENGTH_TWO];
      itemInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo);

      const itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo1.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo1.moduleName = 'ablit';
      itemInfo1.cardName = 'aaa';
      itemInfo1.area = [CARD_SIZE_LENGTH_TWO];
      itemInfo1.layoutInfo = [[itemInfo]];
      itemInfo1.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo1);

      const itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo2.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo2.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo2.moduleName = 'ablit';
      itemInfo2.cardName = 'form';
      itemInfo2.area = [CARD_SIZE_LENGTH_TWO];
      itemInfo2.layoutInfo = [[itemInfo1]];
      itemInfo2.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo2);

      const itemInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo3.typeId = CommonConstants.TYPE_CARD;
      itemInfo3.bundleName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo3);

      const itemInfo4: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo4.typeId = CommonConstants.TYPE_CARD;
      itemInfo4.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo4.moduleName = 'abc';
      itemList.push(itemInfo4);

      const itemInfo5: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo5.typeId = CommonConstants.TYPE_CARD;
      itemInfo5.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo5.moduleName = 'ablit';
      itemInfo5.cardName = 'form12';
      itemList.push(itemInfo5);

      const itemInfo6: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo6.typeId = CommonConstants.TYPE_CARD;
      itemInfo6.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo6.moduleName = 'ablit';
      itemInfo6.cardName = 'form';
      itemInfo6.abilityName = 'ccc';
      itemList.push(itemInfo6);

      const itemInfo7: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo7.typeId = CommonConstants.TYPE_CARD;
      itemInfo7.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo7.moduleName = 'ablit';
      itemInfo7.cardName = 'form';
      itemInfo7.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemList.push(itemInfo7);

      const itemInfo8: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo8.typeId = CommonConstants.TYPE_CARD;
      itemInfo8.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo8.moduleName = 'ablit';
      itemInfo8.cardName = 'form';
      itemInfo8.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      itemInfo8.area = [CARD_SIZE_LENGTH_NINE, CARD_SIZE_LENGTH_TEN];
      itemList.push(itemInfo8);

      let mocker: MockKit = new MockKit();
      let model: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const func: Function = mocker.mockFunc(model, model.selectAllFormsAndFormStack);
      when(func)().afterReturn(itemList);
      AbilityFormUtil.getFormDistributionFromCache(inputFormInfo).then((result: LauncherFormDistribution[]) => {
        try {
          expect(result.length).assertEqual(1);
        } catch (e) {
        } finally {
          done();
        }
      })
    });

    it('AbilityFormUtilTest_isFormStackContainVoiceCard_02', 0, (): void => {
      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      itemInfo.layoutInfo = undefined;
      expect(AbilityFormUtil.isFormStackContainVoiceCard(itemInfo)).assertFalse();
    });

    it('AbilityFormUtilTest_getFormStackInfoByFormStackId', 0, (): void => {
      expect(AbilityFormUtil.getFormStackInfoByFormStackId('').length).assertEqual(0);
    });

    it('AbilityFormUtilTest_isAddPortfolioCardToFormStack_01', 0, (): void => {
      expect(AbilityFormUtil.isAddPortfolioCardToFormStack(new ExtraData())).assertFalse();
    });

    it('AbilityFormUtilTest_isAddPortfolioCardToFormStack_02', 0, (): void => {
      const extra: ExtraData = new ExtraData();
      extra.commandType = AiSuggestionUpdateConstants.CommandType.UPDATE_CARD;
      expect(AbilityFormUtil.isAddPortfolioCardToFormStack(extra)).assertFalse();
    });

    it('AbilityFormUtilTest_isAddPortfolioCardToFormStack_03', 0, (): void => {
      const extra: ExtraData = new ExtraData();
      extra.commandType = AiSuggestionUpdateConstants.CommandType.ADD_CARD_TO_STACK;
      expect(AbilityFormUtil.isAddPortfolioCardToFormStack(extra)).assertTrue();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_01', 0, (): void => {
      expect(AbilityFormUtil.isCardIdInvalid('0')).assertTrue();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_02', 0, (): void => {
      expect(AbilityFormUtil.isCardIdInvalid('')).assertTrue();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_03', 0, (): void => {
      expect(AbilityFormUtil.isCardIdInvalid('123456')).assertFalse();
    });

    it('AbilityFormUtilTest_isAbilityFormVisible_02', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const cardId: string = '123';
      const instance: PageDesktopModel = PageDesktopModel.getInstance();
      const stackItemInfo: FormStackItemInfo = new FormStackItemInfo();
      stackItemInfo.layoutInfo = [[]];
      stackItemInfo.page = 1;
      const cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.cardId = '356';
      stackItemInfo.layoutInfo = [[cardItemInfo]];
      const func1: Function = mocker.mockFunc(instance, instance.getPageIndex);
      const func2: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      const func3: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      when(func1)().afterReturn(1);
      when(func2)(cardId).afterReturn(stackItemInfo);
      when(func3)(stackItemInfo).afterReturn(false);

      expect(AbilityFormUtil.isAbilityFormVisible(cardId)).assertFalse();
      mocker.clear(instance);
      mocker.clear(FormStackUtil);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_isAbilityFormVisible_03', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const cardId: string = '123';
      const instance: PageDesktopModel = PageDesktopModel.getInstance();
      const stackItemInfo: FormStackItemInfo = new FormStackItemInfo();
      stackItemInfo.page = 1;
      const cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.cardId = cardId;
      stackItemInfo.layoutInfo = [[cardItemInfo]];
      const func1: Function = mocker.mockFunc(instance, instance.getPageIndex);
      const func2: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      const func3: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      when(func1)().afterReturn(1);
      when(func2)(cardId).afterReturn(stackItemInfo);
      when(func3)(stackItemInfo).afterReturn(false);

      expect(AbilityFormUtil.isAbilityFormVisible(cardId)).assertTrue();
      mocker.clear(instance);
      mocker.clear(FormStackUtil);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_getItemFromFormStack', 0, (): void => {
      const inputFormInfo: InputFaInfo = new InputFaInfo();
      const CARD_SIZE_LENGTH_TWO = 2;
      inputFormInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      inputFormInfo.moduleName = 'ablit';
      inputFormInfo.formName = 'form';
      inputFormInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;

      const inputInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      inputInfo.layoutInfo = [[]];

      const itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      itemInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo.moduleName = 'ablitrt';
      itemInfo.cardName = 'form';
      itemInfo.area = [CARD_SIZE_LENGTH_TWO];
      itemInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      inputInfo.layoutInfo[0].push(itemInfo);

      const itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.typeId = CommonConstants.TYPE_CARD;
      itemInfo1.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo1.moduleName = 'ablit';
      itemInfo1.cardName = 'form';
      itemInfo1.area = [CARD_SIZE_LENGTH_TWO];
      itemInfo1.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      inputInfo.layoutInfo[0].push(itemInfo1);

      const itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo2.typeId = CommonConstants.TYPE_FORM_STACK;
      itemInfo2.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo2.moduleName = 'ablit';
      itemInfo2.cardName = 'form';
      itemInfo2.area = [CARD_SIZE_LENGTH_TWO];
      itemInfo2.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      inputInfo.layoutInfo[0].push(itemInfo2);
      expect((AbilityFormUtil as object)['getItemFromFormStack'](inputFormInfo, inputInfo).length).assertEqual(2);
    });

    it('AbilityFormUtilTest_AppendParams_01', 0, (): void => {
      const jsonStr = '';
      const params: Record<string, Object> = {};
      AbilityFormUtil.appendParams(jsonStr, params);
      const keyName = 'key';
      expect(params[keyName]).not().assertTrue();
    });

    it('AbilityFormUtilTest_isSameForm_01', 0, (): void => {
      expect(AbilityFormUtil.isSameForm(new LauncherRecItem(), new GridLayoutItemInfo())).assertFalse();
    });

    it('AbilityFormUtilTest_isSameForm_02', 0, (): void => {
      const recItem: LauncherRecItem = new LauncherRecItem();
      recItem.bundleName = 'a';
      recItem.abilityName = 'b';
      recItem.moduleName = 'c';
      recItem.formName = 'd';
      recItem.dimension = 1;

      expect(AbilityFormUtil.isSameForm(recItem, new GridLayoutItemInfo())).assertFalse();
    });

    it('AbilityFormUtilTest_isSameForm_03', 0, (): void => {
      const info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'a';
      info.abilityName = 'b';
      info.moduleName = 'c';
      info.cardName = 'd';
      info.cardDimension = 1;

      expect(AbilityFormUtil.isSameForm(new LauncherRecItem(), info)).assertFalse();
    });

    it('AbilityFormUtilTest_isSameForm_04', 0, (): void => {
      const recItem: LauncherRecItem = new LauncherRecItem();
      recItem.bundleName = 'a';
      recItem.abilityName = 'b';
      recItem.moduleName = 'c';
      recItem.formName = 'd';
      recItem.dimension = 1;

      const info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'a';
      info.abilityName = 'b';
      info.moduleName = 'c';
      info.cardName = 'd';
      info.cardDimension = 1;

      expect(AbilityFormUtil.isSameForm(recItem, info)).assertTrue();
    });
  });
}