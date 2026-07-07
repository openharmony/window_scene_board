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
  TestType,
  Size,
  Level,
  MockKit,
  when,
} from '@ohos/hypium';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { LauncherCardInfo } from '../../../../../../main/ets/default/bean/LauncherCardInfo';
import { LauncherExposeEventLogs } from '../../../../../../main/ets/default/bean/LauncherExposeEventLogs';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';

export function LauncherExposeEventLogsTest() {
  describe('LauncherExposeEventLogsTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testConstructor', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      const cardId: string = '12345';

      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.findParentFormByFormId);
      when(mockFunc)(cardId).afterReturnNothing();

      const cardItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let func: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAiSuggestionItemByCardId);
      when(func)(cardId).afterReturn(cardItem);

      let logs: LauncherExposeEventLogs = new LauncherExposeEventLogs(cardId);
      expect(logs.recId).assertUndefined();
      expect(logs.subRecId).assertUndefined();
      expect(logs.portfolioId).assertUndefined();

      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.recId = 'recId';
      cardInfo.subRecId = 123;

      when(mockFunc)(cardId).afterReturn(cardInfo);
      logs = new LauncherExposeEventLogs(cardId);
      expect(logs.recId).assertEqual(cardInfo.recId);
      expect(logs.subRecId).assertEqual(cardInfo.subRecId);
      expect(logs.portfolioId).assertUndefined();

      cardInfo.portfolioInfo = new PortfolioInfo();
      cardInfo.portfolioInfo.portfolioId = '456';
      when(mockFunc)(cardId).afterReturn(cardInfo);
      logs = new LauncherExposeEventLogs(cardId);
      expect(logs.portfolioId).assertEqual(cardInfo.portfolioInfo.portfolioId);

      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });
  });
}