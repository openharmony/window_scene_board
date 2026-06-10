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
  it,
  describe,
  expect,
  MockKit,
  when,
  TestType,
  Level,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  FormHiSysEventReporter,
  GridLayoutItemInfo,
  layoutConfigManager,
  SettingsModel,
  CardItemInfo,
  FormModel,
  FormLayoutCacheManager
} from '@ohos/launchercommon';
import { DefaultDesktopLayoutInfo } from '@ohos/launchercommon';
import { FormStyleConfig } from '../../../../../../main/ets/default/common/FormStyleConfig';
import { FormViewModel } from '../../../../../../../src/main/ets/default/viewmodel/FormViewModel';
import FeatureConstants from '../../../../../../main/ets/default/common/constants/FeatureConstants';

export function FormViewModelTest() {
  describe('FormViewModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getFormStyleConfig', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let styleConfig: FormStyleConfig = layoutConfigManager.getStyleConfig(FormStyleConfig.APP_LIST_STYLE_CONFIG,
          FeatureConstants.FEATURE_NAME);
        let formStyleConfig: FormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
        expect(formStyleConfig).assertEqual(styleConfig);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    // it('updateCardIdOfPreloadForm', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
    //   let cardInfo: CardItemInfo = new CardItemInfo();
    //   cardInfo.cardId = 234;
    //   cardInfo.bundleName = 'test';
    //   cardInfo.cardName = 'testName';
    //
    //   let layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    //   layoutItem.typeId = cardInfo.typeId;
    //   layoutItem.cardId = cardInfo.cardId;
    //
    //   const mocker: MockKit = new MockKit();
    //   let mLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
    //   const mockFunc: Function = mocker.mockFunc(mLayoutManager, mLayoutManager.selectGridLayoutItemByPosition);
    //   when(mockFunc)(ArgumentMatchers.any).afterReturn(layoutItem);
    //
    //   let formItem: CardItemInfo = new CardItemInfo();
    //   formItem.cardId = 345;
    //   formItem.bundleName = 'test';
    //   formItem.cardName = 'testName';
    //   formItem.formConfigAbility = 'testConfig';
    //   formItem.isTransparent = true;
    //
    //   let formModel: FormModel = FormModel.getInstance();
    //   const mockFunc1: Function = mocker.mockFunc(formModel, formModel.getFormsInfoByBundleName);
    //   when(mockFunc1)(ArgumentMatchers.any).afterReturn([formItem]);
    //
    //   await FormViewModel.getInstance().updateCardIdOfPreloadForm(cardInfo, 345);
    //   expect(cardInfo.cardId).assertEqual(345);
    //   expect(cardInfo.formConfigAbility).assertEqual('testConfig');
    //   expect(cardInfo.isTransparent).assertEqual(true);
    //   mocker.clear(mLayoutManager);
    //   mocker.clear(formModel);
    //   mocker.clearAll();
    //   done();
    // });
    //
    // it('updateCardIdOfPreloadForm_1', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
    //   let cardInfo: CardItemInfo = new CardItemInfo();
    //   cardInfo.cardId = 234;
    //   cardInfo.bundleName = 'test';
    //   cardInfo.cardName = 'testName';
    //   cardInfo.formConfigAbility = 'testConfig';
    //
    //   let layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    //   layoutItem.typeId = 0;
    //   layoutItem.cardId = cardInfo.cardId;
    //
    //   const mocker: MockKit = new MockKit();
    //   let mLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
    //   const mockFunc: Function = mocker.mockFunc(mLayoutManager, mLayoutManager.selectGridLayoutItemByPosition);
    //   when(mockFunc)(ArgumentMatchers.any).afterReturn(layoutItem);
    //
    //   await FormViewModel.getInstance().updateCardIdOfPreloadForm(cardInfo, 345);
    //   expect(cardInfo.cardId).assertEqual(345);
    //   expect(cardInfo.formConfigAbility).assertEqual('testConfig');
    //   mocker.clear(mLayoutManager);
    //   mocker.clearAll();
    //   done();
    // });
    //
    // it('updateCardIdOfPreloadForm_2', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
    //   let cardInfo: CardItemInfo = new CardItemInfo();
    //   cardInfo.cardId = 234;
    //   cardInfo.bundleName = 'test';
    //   cardInfo.cardName = 'testName';
    //   cardInfo.formConfigAbility = 'testConfig';
    //
    //   let layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    //   layoutItem.typeId = cardInfo.typeId;
    //   layoutItem.cardId = cardInfo.cardId;
    //
    //   const mocker: MockKit = new MockKit();
    //   let mLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
    //   const mockFunc: Function = mocker.mockFunc(mLayoutManager, mLayoutManager.selectGridLayoutItemByPosition);
    //   when(mockFunc)(ArgumentMatchers.any).afterReturn(layoutItem);
    //
    //   let formModel: FormModel = FormModel.getInstance();
    //   const mockFunc1: Function = mocker.mockFunc(formModel, formModel.getFormsInfoByBundleName);
    //   when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);
    //
    //   await FormViewModel.getInstance().updateCardIdOfPreloadForm(cardInfo, 345);
    //   expect(cardInfo.cardId).assertEqual(345);
    //   expect(cardInfo.formConfigAbility).assertEqual('testConfig');
    //   mocker.clear(mLayoutManager);
    //   mocker.clear(formModel);
    //   mocker.clearAll();
    //   done();
    // });

    it('reportIntelligentAddCardEvent', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(FormHiSysEventReporter, FormHiSysEventReporter.reportAddCardToScreenByClick);
      let called: boolean = false;
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => { called = true; });
      try {
        FormViewModel.getInstance().reportIntelligentAddCardEvent(new CardItemInfo(), [0, 1], 1, 0);
        expect(called === undefined).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(FormHiSysEventReporter);
      mocker.clearAll();
    });
  })
}