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
import {
  DeleteCardFromFormStackCommand
} from '../../../../../../../main/ets/default/command/imp/DeleteCardFromFormStackCommand';
import { AbilityFormUtil } from '../../../../../../../main/ets/default/utils/AbilityFormUtil';

export default function DeleteCardFromFormStackCommandTest() {
  describe('DeleteCardFromFormStackCommandTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('DeleteCardFromFormStackCommandTest_execute_01', 0, (): void => {
      let commandObj: DeleteCardFromFormStackCommand = new DeleteCardFromFormStackCommand('123');
      commandObj.data = [];
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

    it('DeleteCardFromFormStackCommandTest_execute_02', 0, (): void => {
      let commandObj: DeleteCardFromFormStackCommand = new DeleteCardFromFormStackCommand('123');
      const lists: LauncherCardInfo[] = [];
      const items: LauncherCardInfo = new LauncherCardInfo();
      items.operateFormId = '454';
      lists.push(items);
      commandObj.data = lists;
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

    it('DeleteCardFromFormStackCommandTest_canExecute_01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      const deleteIds: string[] = [];
      deleteIds.push('329379');
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)('329379').afterReturn(true);

      let commandObj: DeleteCardFromFormStackCommand = new DeleteCardFromFormStackCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](deleteIds);
      expect(results).assertEqual(true);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('DeleteCardFromFormStackCommandTest_canExecute_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      const deleteIds: string[] = [];
      deleteIds.push('329379');
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)('329379').afterReturn(false);

      let commandObj: DeleteCardFromFormStackCommand = new DeleteCardFromFormStackCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](deleteIds);
      expect(results).assertEqual(false);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('DeleteCardFromFormStackCommandTest_execute_03', 0, (): void => {
      let commandObj: DeleteCardFromFormStackCommand = new DeleteCardFromFormStackCommand('123');
      const lists: LauncherCardInfo[] = [];
      const items: LauncherCardInfo = new LauncherCardInfo();
      items.operateFormId = '454';
      lists.push(items);
      commandObj.data = lists;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      let func1: Function = mocker.mockFunc(commandObj, (commandObj as object)['canExecute']);
      when(func)('123').afterAction(action);
      when(func1)(['454']).afterReturn(true);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(manager);
      mocker.clear(commandObj);
      mocker.clearAll();
    });
  });
}