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

import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
} from '@ohos/hypium';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LauncherCardInfo } from '../../../../../../../main/ets/default/bean/LauncherCardInfo';
import { CommandConsumer } from '../../../../../../../main/ets/default/command/CommandConsumer';
import { SwitchCardToTopCommand } from '../../../../../../../main/ets/default/command/imp/SwitchCardToTopCommand';
import { AbilityFormUtil } from '../../../../../../../main/ets/default/utils/AbilityFormUtil';

export default function SwitchCardToTopCommandTest() {
  describe('SwitchCardToTopCommandTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('SwitchCardToTopCommandTest_execute_01', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      commandObj.data = undefined;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      when(func)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_execute_02', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      const items: LauncherCardInfo = new LauncherCardInfo();
      items.operateFormId = '454';
      commandObj.data = items;
      commandObj.commandType = AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: FormStackViewModel = new FormStackViewModel();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.swapCardToTopOfFormStack);
      when(func)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertFalse();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_execute_03', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      const items: LauncherCardInfo = new LauncherCardInfo();
      items.operateFormId = '454';
      commandObj.data = items;
      commandObj.commandType = AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP_AFTER_CREATE_STACK;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_execute_04', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      const items: LauncherCardInfo = new LauncherCardInfo();
      items.operateFormId = '454';
      commandObj.data = items;
      commandObj.commandType = AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP_AFTER_ADD_CARD_TO_STACK;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(commandObj, (commandObj as object)['getSwitchCardId']);
      when(func)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(commandObj);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_execute_05', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      const items: LauncherCardInfo = new LauncherCardInfo();
      items.operateFormId = '454';
      commandObj.data = items;
      commandObj.commandType = AiSuggestionUpdateConstants.CommandType.UPDATE_CARD;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      when(func)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_getSwitchCardId_01', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      let results: string = (commandObj as object)['getSwitchCardId']('', '');
      expect(results.length === 0).assertTrue();
    });

    it('SwitchCardToTopCommandTest_getSwitchCardId_02', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      let results: string = (commandObj as object)['getSwitchCardId']('1', '');
      expect(results.length === 0).assertTrue();
    });

    it('SwitchCardToTopCommandTest_getSwitchCardId_03', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getItemInfoFromStackByPortfolioId);
      when(func1)('123').afterReturn(null);
      let results: string = (commandObj as object)['getSwitchCardId']('1', '2');
      expect(results.length === 0).assertTrue();
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_canExecute_01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let cardId = '345';
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)(cardId).afterReturn(false);

      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](cardId);
      expect(results).assertEqual(false);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_canExecute_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let cardId = '345';
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)(cardId).afterReturn(true);

      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](cardId);
      expect(results).assertEqual(true);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_execute_06', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      const items: LauncherCardInfo = new LauncherCardInfo();
      items.operateFormId = '454';
      commandObj.data = items;
      commandObj.commandType = AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      let func1: Function = mocker.mockFunc(commandObj, (commandObj as object)['canExecute']);
      when(func)('123').afterAction(action);
      when(func1)(items.operateFormId).afterReturn(true);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(manager);
      mocker.clear(commandObj);
      mocker.clearAll();
    });

    it('SwitchCardToTopCommandTest_getSwitchCardId_04', 0, (): void => {
      let commandObj: SwitchCardToTopCommand = new SwitchCardToTopCommand('123');
      const cardInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      cardInfo.cardId = '124';
      const stackId = '1';
      const portfolioId = '2';
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getItemInfoFromStackByPortfolioId);
      when(func)(stackId).afterReturn(cardInfo);
      let results: string = (commandObj as object)['getSwitchCardId'](stackId, portfolioId);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
      expect(results).assertEqual('124');
    });

  });
}