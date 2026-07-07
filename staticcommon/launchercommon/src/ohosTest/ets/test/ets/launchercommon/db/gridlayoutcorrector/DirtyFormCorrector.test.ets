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

import { describe, it, expect, MockKit, when } from '@ohos/hypium';

import { BundleConstants, CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';
import { DirtyFormCorrector } from '../../../../../../../main/ets/db/gridlayoutcorrector/DirtyFormCorrector';
import AiSuggestionUpdateConstants from '../../../../../../../main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { RdbStoreManager } from '../../../../../../../main/ets/TsIndex';

class PortfolioData {
  public cardType?: number;
  public portfolioId?: string;
}

class Extend1Data {
  public data?: PortfolioData;
}

class Extend1 {
  public parameters?: Extend1Data;
}

export default function DirtyFormCorrectorTest() {
  describe('DirtyFormCorrectorTest', () => {
    it('test_dealDirtyAiSuggestionForm', 0, () => {
      const corrector: DirtyFormCorrector = new DirtyFormCorrector();
      const cardItem = new GridLayoutItemInfo();
      cardItem.typeId = CommonConstants.TYPE_CARD;
      cardItem.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      const extend1: Extend1 = {
        'parameters': {
          'data': {
            'cardType': AiSuggestionUpdateConstants.CardType.TEMP,
            'portfolioId': 'default',
          }
        }
      };
      cardItem.extend1 = JSON.stringify(extend1);

      const folderItem = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.layoutInfo = [];

      const stackItem = new GridLayoutItemInfo();
      stackItem.typeId = CommonConstants.TYPE_FORM_STACK;

      const gridInfo = [cardItem, folderItem, stackItem];
      corrector.handleData(gridInfo);

      const stackCardItem = ObjectCopyUtil.deepClone(cardItem);
      stackCardItem.extend1 = undefined;
      stackItem.layoutInfo = [];
      corrector.handleData(gridInfo);

      stackItem.layoutInfo[0] = [ stackCardItem ];
      corrector.handleData(gridInfo);
      expect(gridInfo.length).assertEqual(3);
    });

    it('test_dealDirtyVoiceInfo', 0, () => {
      const corrector: DirtyFormCorrector = new DirtyFormCorrector();
      const cardItem = new GridLayoutItemInfo();
      cardItem.typeId = CommonConstants.TYPE_CARD;
      cardItem.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      cardItem.cardId = '123';
      const extend1: Extend1 = {
        'parameters': {
          'data': {
            'cardType': AiSuggestionUpdateConstants.CardType.TEMP,
            'portfolioId': 'default',
          }
        }
      };
      cardItem.extend1 = JSON.stringify(extend1);

      const folderItem = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.layoutInfo = [];

      const stackItem = new GridLayoutItemInfo();
      stackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      const stackCardItem = ObjectCopyUtil.deepClone(cardItem);
      stackCardItem.extend1 = undefined;
      stackCardItem.cardId = '456';
      stackItem.layoutInfo = [[ stackCardItem ]];

      const gridInfo = [cardItem, folderItem, stackItem];

      const mocker: MockKit = new MockKit();
      const mockFunc: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryAllVoiceCardInfo);
      const result: Record<string, string>[] =[{ 'cardId': '123' }, { 'cardId': '111' }];
      when(mockFunc)().afterReturn(Promise.resolve(result));

      corrector.handleData(gridInfo);
      expect(gridInfo.length).assertEqual(3);

      mocker.clear(RdbStoreManager.getInstance());
      mocker.clearAll();
    });
  });
}
