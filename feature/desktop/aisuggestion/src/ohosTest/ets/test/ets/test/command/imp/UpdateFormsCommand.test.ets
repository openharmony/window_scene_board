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
import { LauncherCardInfo } from '../../../../../../../main/ets/default/bean/LauncherCardInfo';
import { CommandConsumer } from '../../../../../../../main/ets/default/command/CommandConsumer';
import { UpdateFormsCommand } from '../../../../../../../main/ets/default/command/imp/UpdateFormsCommand';
import { AiSuggestionFormManager } from '../../../../../../../main/ets/default/manager/AiSuggestionFormManager';

export default function UpdateFormsCommandTest() {
  describe('UpdateFormsCommandTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('UpdateFormsCommandTest_execute_01', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
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

    it('UpdateFormsCommandTest_execute_02', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let item: LauncherCardInfo = new LauncherCardInfo();
      item.stackId = '3232';
      commandObj.data = item;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(LauncherCardInfo, LauncherCardInfo.isCardInfoInValid);
      const func2: Function = mocker.mockFunc(manager, manager.updateCardInfo);
      when(func1)().afterReturn(true);
      when(func2)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertFalse();
      mocker.clear(LauncherCardInfo);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_canExecute_01', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](undefined);
      expect(results).assertEqual(true);
    });

    it('UpdateFormsCommandTest_execute_04', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let item: LauncherCardInfo = new LauncherCardInfo();
      item.stackId = '3232';
      commandObj.data = item;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(manager, manager.updateCardInfo);
      when(func)(item.operateFormId).afterAction(action);

      commandObj.execute();
      expect(called).assertFalse();
      mocker.clear(LauncherCardInfo);
      mocker.clear(manager);
      mocker.clear(commandObj);
      mocker.clearAll();
    });
  });
}