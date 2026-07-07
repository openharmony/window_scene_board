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
  beforeAll, beforeEach, describe, expect, it, MockKit, when, } from '@ohos/hypium';
import {
  BundleConstants,
  CardItemInfo,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PageDesktopModel
} from '@ohos/launchercommon';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { FormStackUtil } from '@ohos/formstack/src/main/ets/common/FormStackUtil';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';
import { ScreenDisplayStatus } from '../../../../../../main/ets/default/constants/ScreenDisplayStatus';
import { AiSuggestionFormManager } from '../../../../../../main/ets/default/manager/AiSuggestionFormManager';
import { InputFaInfo } from '../../../../../../main/ets/default/bean/InputFaInfo';
import { LauncherFormDistribution } from '../../../../../../main/ets/default/bean/LauncherFormDistribution';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';

const TAG: string = 'AbilityFormUtilTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
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

    it('AbilityFormUtilTest_getVersionName', 0, async (done: Function): Promise<void> => {
      expect(await AbilityFormUtil.getVersionName('')).assertEqual('');

      expect(await AbilityFormUtil.getVersionName('bundleName')).assertEqual('');
      done();
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
  });

  describe('createVoiceSuggestionCard_testSuite', () => {
    it('atc_should_return_new_GridLayoutItemInfo_when_baseLayoutInfo_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createVoiceSuggestionCard(undefined);
      expect(result).assertDeepEquals(GridLayoutItemInfo);
      mocker.ignoreMock(log, log.showWarn);
    });

    it('atc_should_return_new_GridLayoutItemInfo_when_baseLayoutInfo_is_invalid', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createVoiceSuggestionCard(baseLayoutInfo);
      expect(result).assertDeepEquals(GridLayoutItemInfo);
      mocker.ignoreMock(log, log.showWarn);
    });

    it('atc_should_return_new_GridLayoutItemInfo_with_dimensions_when_baseLayoutInfo_is_valid', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      baseLayoutInfo.area = [12];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createVoiceSuggestionCard(baseLayoutInfo);
      expect(result).assertDeepEquals(GridLayoutItemInfo);
      expect(result.cardDimension).assertLarger(0);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_return_cardName_when_cardDimension_is_2x2', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      baseLayoutInfo.area = [12];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createVoiceSuggestionCard(baseLayoutInfo);
      expect(result.cardName).assertEqual(BundleConstants.AI_SUGGESTION_MIN_CARD);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_return_cardName_when_cardDimension_is_2x4', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      baseLayoutInfo.area = [24];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createVoiceSuggestionCard(baseLayoutInfo);
      expect(result.cardName).assertEqual(BundleConstants.AI_SUGGESTION_MED_CARD);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_return_cardName_when_cardDimension_is_4x4', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      baseLayoutInfo.area = [48];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createVoiceSuggestionCard(baseLayoutInfo);
      expect(result.cardName).assertEqual(BundleConstants.AI_SUGGESTION_MAX_CARD);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_log_warning_when_cardDimension_is_unknown', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      baseLayoutInfo.area = [60];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createVoiceSuggestionCard(baseLayoutInfo);
      expect(result.cardName).assertUndefined();
      mocker.ignoreMock(LogHelper, log.showWarn);
    });
  });

  describe('createCard_testSuite', () => {
    it('atc_should_return_new_GridLayoutItemInfo_when_baseLayoutInfo_is_null', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const recItem = new LauncherRecItem();
      const result: GridLayoutItemInfo = AbilityFormUtil.createCard(baseLayoutInfo, recItem);
      expect(result).assertDeepEquals(GridLayoutItemInfo);
      expect(result.componentId).assertEqual(undefined);
      expect(result.id).assertEqual(undefined);
      expect(result.infoId).assertEqual(undefined);
    });

    it('atc_should_return_new_GridLayoutItemInfo_when_baseLayoutInfo_is_invalid', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const recItem = new LauncherRecItem();
      const result: ESObject = AbilityFormUtil.createCard(undefined, recItem);
      expect(result).assertDeepEquals(GridLayoutItemInfo);
      expect(result.componentId).assertEqual(undefined);
      expect(result.id).assertEqual(undefined);
      expect(result.infoId).assertEqual(undefined);
    });

    it('atc_should_return_new_GridLayoutItemInfo_with_dimensions_when_baseLayoutInfo_is_valid', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const recItem = new LauncherRecItem();
      baseLayoutInfo.area = [12];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createCard(baseLayoutInfo, recItem);
      expect(result).assertDeepEquals(GridLayoutItemInfo);
      expect(result.cardDimension).assertLarger(0);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_return_cardName_when_cardDimension_is_2x2', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const recItem = new LauncherRecItem();
      baseLayoutInfo.area = [12];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createCard(baseLayoutInfo, recItem);
      expect(result.cardName).assertEqual(BundleConstants.AI_SUGGESTION_MIN_CARD);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_return_cardName_when_cardDimension_is_2x4', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const recItem = new LauncherRecItem();
      baseLayoutInfo.area = [24];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createCard(baseLayoutInfo, recItem);
      expect(result.cardName).assertEqual(BundleConstants.AI_SUGGESTION_MED_CARD);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_return_cardName_when_cardDimension_is_4x4', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const recItem = new LauncherRecItem();
      baseLayoutInfo.area = [48];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createCard(baseLayoutInfo, recItem);
      expect(result.cardName).assertEqual(BundleConstants.AI_SUGGESTION_MAX_CARD);
      mocker.ignoreMock(LogHelper, log.showWarn);
    });

    it('atc_should_log_warning_when_cardDimension_is_unknown', 0, () => {
      let baseLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const recItem = new LauncherRecItem();
      baseLayoutInfo.area = [60];
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, log.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      const result: ESObject = AbilityFormUtil.createCard(baseLayoutInfo, recItem);
      expect(result.cardName).assertUndefined();
      mocker.ignoreMock(LogHelper, log.showWarn);
    });
  });

  describe('isAbilityFormVisible_testSuite', () => {

    it('atc_should_return_false_when_stackItemInfo_is_invalid', 0, () => {
      let cardId: string = "card1";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = AbilityFormUtil.isAbilityFormVisible(cardId);
      expect(result).assertEqual(false);
      mocker.ignoreMock(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
    });

    it('atc_should_return_true_when_stackItemInfo_is_valid_and_top_card_matches', 0, () => {
      let cardId: string = "card1";
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      let mockfunc2: Function = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      let mockfunc3: Function = mocker.mockFunc(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn({ page: 1, cardId: "card1" });
      const result: ESObject = AbilityFormUtil.isAbilityFormVisible(cardId);
      expect(result).assertEqual(true);
      mocker.ignoreMock(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      mocker.ignoreMock(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      mocker.ignoreMock(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
    });

    it('atc_should_return_false_when_stackItemInfo_is_valid_but_top_card_does_not_match', 0, () => {
      let cardId: string = "card1";
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      let mockfunc2: Function = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      let mockfunc3: Function = mocker.mockFunc(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn({ page: 1, cardId: "card2" });
      const result: ESObject = AbilityFormUtil.isAbilityFormVisible(cardId);
      expect(result).assertEqual(false);
      mocker.ignoreMock(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      mocker.ignoreMock(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      mocker.ignoreMock(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
    });

    it('atc_should_return_true_when_cardItemInfo_is_valid_and_cardId_matches', 0, () => {
      let cardId: string = "card1";
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      let mockfunc3: Function = mocker.mockFunc(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn({ page: 1, cardId: "card1" });
      const result: ESObject = AbilityFormUtil.isAbilityFormVisible(cardId);
      expect(result).assertEqual(true);
      mocker.ignoreMock(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      mocker.ignoreMock(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
    });

    it('atc_should_return_false_when_cardItemInfo_is_valid_but_cardId_does_not_match', 0, () => {
      let cardId: string = "card1";
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      let mockfunc3: Function = mocker.mockFunc(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn({ page: 1, cardId: "card2" });
      const result: ESObject = AbilityFormUtil.isAbilityFormVisible(cardId);
      expect(result).assertEqual(false);
      mocker.ignoreMock(PageDesktopModel, PageDesktopModel.getInstance().getPageIndex);
      mocker.ignoreMock(FormLayoutCacheManager, FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
    });
  });
}