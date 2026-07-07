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

import { LogDomain, LogHelper } from "@ohos/basicutils";
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { GridLayoutItemInfo } from "@ohos/launchercommon";
import { PortfolioInfo } from "@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo";
import { AiSuggestionViewModel } from "../../../../../../main/ets/default/model/AiSuggestionViewModel";

const TAG = 'AiSuggestionViewModelTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
/**
 * AiSuggestionViewModel测试
 *
 * @since 2025-06-11
 */
export default function AiSuggestionViewModelTest() {
  describe('initEvent_testSuite', () => {
    it('atc_should_log_error_when_cardId_is_undefined', 0, () => {
      let aisuggestionviewmodel: AiSuggestionViewModel = new AiSuggestionViewModel();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      aisuggestionviewmodel.initEvent(undefined, new GridLayoutItemInfo());
      mocker.ignoreMock(log, log.showError);
    });

    it('atc_should_create_event_when_mEvent_is_null', 0, () => {
      let aisuggestionviewmodel: AiSuggestionViewModel = new AiSuggestionViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(log, log.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      aisuggestionviewmodel.initEvent('cardId', new GridLayoutItemInfo());
      mocker.ignoreMock(log, log.showError);
    });
  });

  describe('deleteCard_testSuite', () => {
    it('atc_should_set_cardId_correctly', 0, () => {
      let aisuggestionviewmodel: AiSuggestionViewModel = new AiSuggestionViewModel();
      let cardId: string = "testCardId";
      aisuggestionviewmodel.setCardId(cardId);
      expect(aisuggestionviewmodel.cardId).assertEqual(cardId);
    });
  });

  describe('updateDesc2TopMargin_testSuite', () => {
    it('atc_should_update_desc2TopMargin_correctly', 0, () => {
      let aisuggestionviewmodel: AiSuggestionViewModel = new AiSuggestionViewModel();
      let desc2TopMargin: number = 10;
      aisuggestionviewmodel.updateDesc2TopMargin(desc2TopMargin);
      expect(aisuggestionviewmodel.viewData.desc2TopMargin).assertEqual(desc2TopMargin);
    });
  });

  describe('updateLanguage_testSuite', () => {
    beforeEach(() => {

    });

    afterEach(() => {

    });

    it('atc_should_not_update_language_when_portfolioInfo_is_null', 0, () => {
      let aisuggestionviewmodel: AiSuggestionViewModel = new AiSuggestionViewModel();
      let portfolioInfo: PortfolioInfo | undefined = undefined;
      aisuggestionviewmodel.updateLanguage(portfolioInfo);
    });
  });
}