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
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { BaseCommand } from '../../../../../../main/ets/default/command/BaseCommand';
import { CommandList } from '../../../../../../main/ets/default/command/CommandList';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';

class MyCommand extends BaseCommand {
  execute(): void {
    console.info('do nothing');
  };
};

export default function CommandListTest() {
  describe('CommandListTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('CommandListTest_isCommandExecuting_01', 0, () => {
      const commandObj: CommandList = new CommandList();
      expect(commandObj.isCommandExecuting()).assertFalse();
    });

    it('CommandListTest_isCommandExecuting_02', 0, () => {
      const commandObj: CommandList = new CommandList();
      const commands: BaseCommand[] = [];
      const items: BaseCommand = new MyCommand();
      items.commandId = '1111111';
      items.commandType = AiSuggestionUpdateConstants.CommandType.UPDATE_CARD;
      items.operateCardId = '111111';
      items.delayTime = 1;
      items.executeTime = Date.now() - 1;
      commands.push(items);
      (commandObj as object)['pendingCommandMap'].set('1111111',commands);
      expect(commandObj.isCommandExecuting()).assertTrue();
    });

    it('CommandListTest_isCommandExecuting_03', 0, () => {
      const commandObj: CommandList = new CommandList();
      const commands: BaseCommand[] = [];
      const items: BaseCommand = new MyCommand();
      items.commandId = '1111111';
      items.commandType = AiSuggestionUpdateConstants.CommandType.UPDATE_CARD;
      items.operateCardId = '111111';
      items.delayTime = 1;
      items.executeTime = Date.now() - 1;
      commands.push(items);
      (commandObj as object)['executeCommandList'] = commands;
      expect(commandObj.isCommandExecuting()).assertTrue();
    });

    it('CommandListTest_removeExecutedCommand_01', 0, () => {
      const commandObj: CommandList = new CommandList();
      expect(commandObj.removeExecutedCommand('111', 2)).assertFalse();
    });

    it('CommandListTest_removeExecutedCommand_02', 0, () => {
      const commandObj: CommandList = new CommandList();
      const command: BaseCommand = new MyCommand();
      command.commandId = '111111';
      command.commandType = AiSuggestionUpdateConstants.CommandType.UPDATE_CARD;
      command.operateCardId = '111111';
      command.delayTime = 1;
      const commandList: BaseCommand[] = [];
      const items1: BaseCommand = new MyCommand();
      items1.commandId = '111111';
      items1.commandType = AiSuggestionUpdateConstants.CommandType.UPDATE_CARD;
      items1.operateCardId = '111111';
      items1.delayTime = 1;
      commandList.push(items1);
      (commandObj as object)['executeCommandList'] = commandList;
      expect(commandObj.removeExecutedCommand('111111', 0, '111111')).assertTrue();
    });
  });
}